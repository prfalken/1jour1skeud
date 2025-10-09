"""
Artists contributions updater:
 - Reads an artists JSONL/JSON-lines file (one JSON object per line)
 - For each artist of type "Person", finds album IDs they contributed to
 - Performs batched partial updates on Algolia to add the artist to role-based arrays

Assumptions:
 - Album objectIDs in Algolia equal the MusicBrainz release-group IDs (UUID strings)
 - Artist objects may contain contribution hints in various nested structures; we scan flexibly
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any, Dict, Iterable, List, Optional, Set, Tuple

from tqdm import tqdm

from algolia import AlgoliaApp
from loguru import logger

UUID_RE = re.compile(
    r"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
)


class ArtistsUpdater(AlgoliaApp):
    """Processes artists file and applies partial updates to album records in Algolia."""

    def __init__(self, config, client):
        super().__init__(config, client)

    def update_from_file(
        self, file_path: str, max_records: Optional[int] = None
    ) -> None:
        """Read artists JSON-lines file and apply partial updates in batches."""
        path = Path(file_path)
        if not path.exists():
            raise FileNotFoundError(f"Artists file not found: {path}")

        total_lines = 0
        total_updates = 0
        batch_updates: List[Dict[str, Any]] = []

        with path.open("r", encoding="utf-8") as fh:
            for line in tqdm(fh, desc="Scanning artists"):
                if not line.strip():
                    continue
                try:
                    artist_obj = json.loads(line)
                except json.JSONDecodeError:
                    continue

                total_lines += 1
                if max_records and total_lines > max_records:
                    break

                if not self._is_person(artist_obj):
                    continue

                artist_name = self._extract_artist_name(artist_obj)
                if not artist_name:
                    continue

                contributions = self._extract_album_contributions(artist_obj)
                if not contributions:
                    continue

                for album_id, role_category in contributions:
                    update_payload = self._build_partial_update(
                        album_id, artist_name, role_category
                    )
                    if update_payload:
                        batch_updates.append(update_payload)

                    if len(batch_updates) >= self.batch_size:
                        self._flush_updates(batch_updates)
                        total_updates += len(batch_updates)
                        batch_updates = []

        if batch_updates:
            self._flush_updates(batch_updates)
            total_updates += len(batch_updates)

        logger.info(
            f"✅ Artists update completed. Partial updates sent: {total_updates}"
        )

    def _flush_updates(self, updates: List[Dict[str, Any]]) -> None:
        if not updates:
            return
        try:
            self.client.partial_update_objects(
                index_name=self.index_name, objects=updates
            )
        except Exception as e:
            logger.error(
                f"⚠️  Error sending partial updates batch of {len(updates)}: {e}"
            )

    def _is_person(self, artist_obj: Dict[str, Any]) -> bool:
        type_val = (
            artist_obj.get("type")
            or artist_obj.get("type-id")
            or artist_obj.get("artist", {}).get("type")
        )
        # Accept common type markers where available
        if isinstance(type_val, str) and type_val:
            return type_val.lower() in {"person", "human"}
        # Fallback: if explicit 'type' missing but object has person-like fields
        return bool(artist_obj.get("name"))

    def _extract_artist_name(self, artist_obj: Dict[str, Any]) -> Optional[str]:
        name = artist_obj.get("name")
        if not name and isinstance(artist_obj.get("artist"), dict):
            name = artist_obj["artist"].get("name")
        if isinstance(name, str):
            cleaned = name.strip()
            return cleaned or None
        return None

    def _extract_album_contributions(
        self, artist_obj: Dict[str, Any]
    ) -> List[Tuple[str, str]]:
        """Return list of tuples (album_id, role_category)."""
        results: List[Tuple[str, str]] = []

        # Heuristic scan through nested structures for album relations
        for node, path in self._walk(artist_obj):
            if isinstance(node, dict):
                # If node looks like a release-group object
                if self._looks_like_release_group(node):
                    album_id = str(node.get("id"))
                    role = self._classify_role_from_path(
                        path
                    ) or self._classify_role_from_node(node)
                    if album_id and UUID_RE.match(album_id):
                        results.append((album_id, role or "musician"))
                    continue

                # Relation-like node that references a release group id
                if node.get("target-type") in {"release_group", "release-group"}:
                    # Look for id fields in common shapes
                    album_id = None
                    if isinstance(node.get("release-group"), dict) and node[
                        "release-group"
                    ].get("id"):
                        album_id = str(node["release-group"]["id"])
                    elif node.get("id") and UUID_RE.match(str(node.get("id"))):
                        album_id = str(node.get("id"))
                    if album_id and UUID_RE.match(album_id):
                        role = self._classify_role_from_node(
                            node
                        ) or self._classify_role_from_path(path)
                        results.append((album_id, role or "musician"))

        # Deduplicate
        seen: Set[Tuple[str, str]] = set()
        deduped: List[Tuple[str, str]] = []
        for tup in results:
            if tup not in seen:
                seen.add(tup)
                deduped.append(tup)
        return deduped

    def _walk(
        self, obj: Any, path: Tuple[Any, ...] = ()
    ) -> Iterable[Tuple[Any, Tuple[Any, ...]]]:
        yield obj, path
        if isinstance(obj, dict):
            for k, v in obj.items():
                yield from self._walk(v, path + (k,))
        elif isinstance(obj, list):
            for i, v in enumerate(obj):
                yield from self._walk(v, path + (i,))

    def _looks_like_release_group(self, node: Dict[str, Any]) -> bool:
        if not node.get("id"):
            return False
        node_id = str(node["id"])
        if not UUID_RE.match(node_id):
            return False
        # Prefer explicit album marker when present
        primary_type = node.get("primary-type") or node.get("primary_type")
        if isinstance(primary_type, str) and primary_type.lower() == "album":
            return True
        # Fallback: if keys suggest a release-group structure
        keys = set(node.keys())
        return bool({"title", "first-release-date"} & keys)

    def _classify_role_from_node(self, node: Dict[str, Any]) -> Optional[str]:
        # Common relation types or attribute hints
        text_candidates: List[str] = []
        for key in ("type", "role", "credit", "attributes"):
            val = node.get(key)
            if isinstance(val, str):
                text_candidates.append(val)
            elif isinstance(val, list):
                text_candidates.extend(
                    [str(x) for x in val if isinstance(x, (str, int))]
                )

        return self._classify_role(" ".join(text_candidates))

    def _classify_role_from_path(self, path: Tuple[Any, ...]) -> Optional[str]:
        tokens = [str(p).lower() for p in path if isinstance(p, (str, int))]
        haystack = " ".join(tokens)
        return self._classify_role(haystack)

    def _classify_role(self, text: str) -> Optional[str]:
        t = text.lower()
        logger.debug(f"Classifying role from text: {text}")
        if any(k in t for k in ["producer", "co-producer", "executive producer"]):
            return "producer"
        if any(
            k in t
            for k in [
                "engineer",
                "mix",
                "mixing",
                "master",
                "mastering",
                "recording",
                "audio",
                "engineering",
            ]
        ):
            return "engineer"
        if any(
            k in t
            for k in [
                "perform",
                "vocal",
                "guitar",
                "bass",
                "drum",
                "piano",
                "keyboard",
                "horn",
                "string",
                "sax",
                "trumpet",
                "trombone",
                "violin",
                "cello",
                "clarinet",
                "flute",
                "percussion",
            ]
        ):
            return "musician"
        return None

    def _build_partial_update(
        self, album_id: str, artist_name: str, role_category: str
    ) -> Optional[Dict[str, Any]]:
        if not album_id or not artist_name:
            return None
        update: Dict[str, Any] = {
            "objectID": str(album_id),
            # Always add to generic artists list
            "artists": {"_operation": "AddUnique", "value": artist_name},
        }
        # Role-specific arrays
        role_field = None
        if role_category == "producer":
            role_field = "producers"
        elif role_category == "engineer":
            role_field = "engineers"
        else:
            role_field = "musicians"

        update[role_field] = {"_operation": "AddUnique", "value": artist_name}
        return update
