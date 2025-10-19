"""
Data processor for cleaning and transforming music album data for Algolia indexing.
"""

import json
import re
from datetime import datetime
from typing import Any, Dict, List, Optional, Union
from pathlib import Path

from tqdm import tqdm
import psycopg2
from psycopg2.extras import RealDictCursor
from config import Config


class AlbumDataProcessor:
    """Processes and cleans music album data for Algolia indexing."""

    def __init__(self):
        self.processed_count = 0
        self.error_count = 0

    def clean_text(self, text: Any) -> Optional[str]:
        """Clean and normalize text data."""
        if text is None or text == "":
            return None

        text = str(text).strip()
        if not text or text.lower() in ["", "null", "none", "nan"]:
            return None

        # Remove excessive whitespace
        text = re.sub(r"\s+", " ", text)
        return text

    def extract_artist_names(self, artist_credit: List[Dict[str, Any]]) -> List[str]:
        """Extract artist names from artist-credit array."""
        artists = []
        if not artist_credit:
            return artists

        for credit in artist_credit:
            if isinstance(credit, dict):
                name = credit.get("name")
                if name:
                    artists.append(self.clean_text(name))

                # Also get the artist object name if different
                artist_obj = credit.get("artist", {})
                if isinstance(artist_obj, dict) and artist_obj.get("name"):
                    artist_name = self.clean_text(artist_obj["name"])
                    if artist_name and artist_name not in artists:
                        artists.append(artist_name)

        return [name for name in artists if name]

    def extract_genres(self, genres: List[Dict[str, Any]]) -> List[str]:
        """Extract genre names from genres array."""
        genre_names = []
        if not genres:
            return genre_names

        for genre in genres:
            if isinstance(genre, dict) and genre.get("name"):
                genre_name = self.clean_text(genre["name"])
                if genre_name:
                    genre_names.append(genre_name)

        return genre_names

    def extract_tags(self, tags: List[Dict[str, Any]]) -> List[str]:
        """Extract tag names from tags array."""
        tag_names = []
        if not tags:
            return tag_names

        for tag in tags:
            if isinstance(tag, dict) and tag.get("name"):
                tag_name = self.clean_text(tag["name"])
                if tag_name:
                    tag_names.append(tag_name)

        return tag_names

    def parse_date(self, date_str: Any) -> Optional[str]:
        """Parse and normalize date strings."""
        if date_str is None:
            return None

        date_str = str(date_str).strip()
        if not date_str or date_str.lower() in ["", "null", "none", "nan"]:
            return None

        try:
            # Try to parse various date formats
            for fmt in ["%Y-%m-%d", "%Y-%m", "%Y"]:
                try:
                    dt = datetime.strptime(date_str, fmt)
                    return dt.strftime("%Y-%m-%d")
                except ValueError:
                    continue

            # If standard formats fail, try to extract year
            year_match = re.search(r"\b(19|20)\d{2}\b", date_str)
            if year_match:
                return f"{year_match.group()}-01-01"

            return None
        except Exception:
            return None

    def safe_numeric_convert(self, value: Any, default: Union[int, float] = 0) -> Union[int, float]:
        """Safely convert value to numeric type."""
        if value is None:
            return default

        try:
            # Handle string numbers
            if isinstance(value, str):
                value = value.strip().replace(",", "")

            if isinstance(default, int):
                return int(float(value))
            else:
                return float(value)
        except (ValueError, TypeError):
            return default

    def extract_country_info(self, artist_credit: List[Dict[str, Any]]) -> List[str]:
        """Extract country information from artist credits."""
        countries = []
        if not artist_credit:
            return countries

        for credit in artist_credit:
            if isinstance(credit, dict):
                artist_obj = credit.get("artist", {})
                if isinstance(artist_obj, dict) and artist_obj.get("country"):
                    country = self.clean_text(artist_obj["country"])
                    if country and country not in countries:
                        countries.append(country)

        return countries

    def process_album_record(self, album_data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Process a single album record for Algolia indexing."""
        try:
            if not album_data.get("primary-type") == "Album":
                return None
            # Extract basic album information
            album = {
                "objectID": str(album_data.get("id", "")),
                "title": self.clean_text(album_data.get("title")),
                "first_release_date": self.parse_date(album_data.get("first-release-date")),
            }

            # Extract artist information
            artist_credit = album_data.get("artist-credit", [])
            album["artists"] = self.extract_artist_names(artist_credit)
            album["countries"] = self.extract_country_info(artist_credit)

            # Extract genres and tags
            album["genres"] = self.extract_genres(album_data.get("genres", []))

            # Extract secondary types
            secondary_types = album_data.get("secondary-types", [])
            if secondary_types:
                album["secondary_types"] = [self.clean_text(st) for st in secondary_types if st]

            # Handle rating information
            rating_info = album_data.get("rating", {})
            if isinstance(rating_info, dict):
                if rating_info.get("value") is not None:
                    album["rating_value"] = self.safe_numeric_convert(rating_info["value"], 0.0)
                if rating_info.get("votes-count") is not None:
                    album["rating_count"] = self.safe_numeric_convert(rating_info["votes-count"], 0)

            # Calculate derived fields
            if album["first_release_date"]:
                try:
                    year = datetime.strptime(album["first_release_date"], "%Y-%m-%d").year
                    album["release_year"] = year
                except ValueError:
                    # Try to extract just the year if full date parsing fails
                    year_match = re.search(r"\b(19|20)\d{2}\b", album["first_release_date"])
                    if year_match:
                        year = int(year_match.group())
                        album["release_year"] = year

            # Create searchable text field
            searchable_fields = [album["title"]]

            # Add artists, genres, and tags to searchable text
            if album.get("artists"):
                searchable_fields.extend(album["artists"])
            if album.get("genres"):
                searchable_fields.extend(album["genres"])

            # Create a main artist field (first artist)
            if album.get("artists"):
                album["main_artist"] = album["artists"][0]

            # Create a primary genre field (first genre)
            if album.get("genres"):
                album["primary_genre"] = album["genres"][0]

            # Compute a composite rating score for ranking: rating_value * rating_count
            # rating_value is expected on a 0..5 scale (float), rating_count is an integer
            if album.get("rating_value") is not None and album.get("rating_count") is not None:
                try:
                    album["rating_score"] = float(album["rating_value"]) * int(album["rating_count"])
                except Exception:
                    # If conversion fails, omit the score
                    pass

            # Remove None values and empty lists
            album = {k: v for k, v in album.items() if v is not None and v != [] and v != ""}

            # Ensure we have at least a title and objectID
            if not album.get("title") or not album.get("objectID"):
                return None

            self.processed_count += 1
            return album

        except Exception as e:
            self.error_count += 1
            print(f"⚠️  Error processing record {album_data.get('id', 'unknown')}: {e}")
            return None

    def load_json_data_in_batches(self, file_path: Union[str, Path], batch_size: int = 1000):
        """
        Load album data from JSON file in batches (generator).

        Args:
            file_path: Path to the JSON file
            batch_size: Number of records per batch

        Yields:
            List of album data dictionaries (batch)
        """
        file_path = Path(file_path)

        if not file_path.exists():
            raise FileNotFoundError(f"Data file not found: {file_path}")

        print(f"📖 Loading data from {file_path} in batches of {batch_size}")

        current_batch = []
        total_loaded = 0

        with open(file_path, "r", encoding="utf-8") as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if not line:
                    continue

                try:
                    album_data = json.loads(line)
                    current_batch.append(album_data)
                    total_loaded += 1

                    # Yield batch when it reaches the specified size
                    if len(current_batch) >= batch_size:
                        print(f"📦 Loaded batch with {len(current_batch)} records (total: {total_loaded})")
                        yield current_batch
                        current_batch = []

                except json.JSONDecodeError as e:
                    print(f"⚠️  Error parsing JSON on line {line_num}: {e}")
                    self.error_count += 1

        # Yield remaining records in the last batch
        if current_batch:
            print(f"📦 Loaded final batch with {len(current_batch)} records (total: {total_loaded})")
            yield current_batch

        print(f"✅ Completed loading {total_loaded} album records in batches")

    def load_json_data(self, file_path: Union[str, Path]) -> List[Dict[str, Any]]:
        """Load album data from JSON file."""
        file_path = Path(file_path)

        if not file_path.exists():
            raise FileNotFoundError(f"Data file not found: {file_path}")

        print(f"📖 Loading data from {file_path}")

        albums = []
        with open(file_path, "r", encoding="utf-8") as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if not line:
                    continue

                try:
                    album_data = json.loads(line)
                    albums.append(album_data)
                except json.JSONDecodeError as e:
                    print(f"⚠️  Error parsing JSON on line {line_num}: {e}")
                    self.error_count += 1

        print(f"✅ Loaded {len(albums)} album records")
        return albums

    def process_albums(
        self, albums_data: List[Dict[str, Any]], max_records: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Process a list of album records.

        Args:
            albums_data: List of album data dictionaries
            max_records: Maximum number of records to process (for testing)

        Returns:
            List of processed album records
        """
        print(f"🔄 Processing {len(albums_data)} album records...")

        if max_records:
            albums_data = albums_data[:max_records]
            print(f"📊 Limited to {max_records} records for processing")

        processed_albums = []

        for album_data in tqdm(albums_data, desc="Processing albums"):
            processed_album = self.process_album_record(album_data)
            if processed_album:
                processed_albums.append(processed_album)

        print(f"✅ Successfully processed {self.processed_count} albums")
        if self.error_count > 0:
            print(f"⚠️  {self.error_count} records had processing errors")

        return processed_albums

    # ==============================
    # SQL-backed data loading
    # ==============================

    def _connect_db(self):
        """Create a PostgreSQL connection using Config settings."""
        return psycopg2.connect(
            host=Config.DB_HOST,
            port=Config.DB_PORT,
            dbname=Config.DB_NAME,
            user=Config.DB_USER,
            password=Config.DB_PASSWORD,
        )

    def _build_album_batch_sql(self) -> str:
        """SQL selecting release groups of primary type 'Album' with metadata, tags, artists, and countries."""
        # Note: We keyset paginate by rg.id using a parameter :last_id and limit :batch_size
        # We rely on joins to build arrays for artists, countries, genres (tags), and secondary types
        return """
            SELECT
                rg.id AS rg_id,
                rg.gid::text AS object_uuid,
                rg.name AS title,
                rgm.first_release_date_year AS fr_year,
                rgm.first_release_date_month AS fr_month,
                rgm.first_release_date_day AS fr_day,
                rgm.rating AS rating_0_100,
                rgm.rating_count AS rating_count,
                ac_info.artist_names,
                ac_info.countries,
                tags.tag_names,
                sec_types.secondary_names,
                mus.musician_names,
                mus.musician_details,
                caa.cover_release_gid
            FROM musicbrainz.release_group rg
            JOIN musicbrainz.release_group_primary_type rpt ON rpt.id = rg.type
            LEFT JOIN musicbrainz.release_group_meta rgm ON rgm.id = rg.id
            LEFT JOIN LATERAL (
                SELECT
                    ARRAY_AGG(acn.name ORDER BY acn."position") AS artist_names,
                    ARRAY_REMOVE(ARRAY_AGG(DISTINCT i1.code), NULL) AS countries
                FROM musicbrainz.artist_credit_name acn
                JOIN musicbrainz.artist a ON a.id = acn.artist
                LEFT JOIN musicbrainz.area ar ON ar.id = a.area
                LEFT JOIN musicbrainz.iso_3166_1 i1 ON i1.area = ar.id
                WHERE acn.artist_credit = rg.artist_credit
            ) ac_info ON TRUE
            LEFT JOIN LATERAL (
                SELECT ARRAY_AGG(t.name ORDER BY rgt.count DESC) AS tag_names
                FROM musicbrainz.release_group_tag rgt
                JOIN musicbrainz.tag t ON t.id = rgt.tag
                WHERE rgt.release_group = rg.id
            ) tags ON TRUE
            LEFT JOIN LATERAL (
                SELECT ARRAY_AGG(rgst.name ORDER BY rgst.name) AS secondary_names
                FROM musicbrainz.release_group_secondary_type_join rgstj
                JOIN musicbrainz.release_group_secondary_type rgst ON rgst.id = rgstj.secondary_type
                WHERE rgstj.release_group = rg.id
            ) sec_types ON TRUE
            LEFT JOIN LATERAL (
                WITH recs AS (
                    SELECT DISTINCT rec.id AS recording_id
                    FROM musicbrainz.release r2
                    JOIN musicbrainz.medium m ON m.release = r2.id
                    JOIN musicbrainz.track t ON t.medium = m.id
                    JOIN musicbrainz.recording rec ON rec.id = t.recording
                    WHERE r2.release_group = rg.id
                ),
                per_artist AS (
                    SELECT
                        lar.entity0 AS artist_id,
                        ARRAY_AGG(DISTINCT lat.name) FILTER (WHERE lat.name IS NOT NULL AND lat.name <> '') AS instrument_names
                    FROM recs
                    JOIN musicbrainz.l_artist_recording lar ON lar.entity1 = recs.recording_id
                    JOIN musicbrainz.link lk ON lk.id = lar.link
                    LEFT JOIN musicbrainz.link_attribute la ON la.link = lk.id
                    LEFT JOIN musicbrainz.link_attribute_type lat ON lat.id = la.attribute_type
                    GROUP BY lar.entity0
                )
                SELECT
                    ARRAY_AGG(DISTINCT a2.name) AS musician_names,
                    JSONB_AGG(
                        DISTINCT JSONB_BUILD_OBJECT(
                            'name', a2.name,
                            'mbid', a2.gid::text,
                            'instruments', COALESCE(per_artist.instrument_names, ARRAY[]::text[])
                        )
                    ) AS musician_details
                FROM per_artist
                JOIN musicbrainz.artist a2 ON a2.id = per_artist.artist_id
            ) mus ON TRUE
            LEFT JOIN LATERAL (
                SELECT rel_choice.rel_gid AS cover_release_gid
                FROM (
                    SELECT
                        r.gid::text AS rel_gid,
                        MAX(CASE WHEN at.name = 'Front' THEN 1 ELSE 0 END) AS has_front,
                        MIN(ca.ordering) AS min_ordering
                    FROM musicbrainz.release r
                    JOIN cover_art_archive.cover_art ca ON ca.release = r.id
                    LEFT JOIN cover_art_archive.cover_art_type cat ON cat.id = ca.id
                    LEFT JOIN cover_art_archive.art_type at ON at.id = cat.type_id
                    WHERE r.release_group = rg.id
                    GROUP BY r.gid
                    ORDER BY has_front DESC, min_ordering ASC
                    LIMIT 1
                ) rel_choice
            ) caa ON TRUE
            WHERE rpt.name = 'Album' AND rg.id > %s
            ORDER BY rg.id
            LIMIT %s
            """

    def _row_to_album(self, row: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Convert a SQL row to the normalized album object used for indexing."""
        first_release_date: Optional[str] = None
        y = row.get("fr_year")
        m = row.get("fr_month")
        d = row.get("fr_day")
        # Build a normalized YYYY-MM-DD with fallbacks
        if y:
            mm = int(m) if m else 1
            dd = int(d) if d else 1
            try:
                first_release_date = datetime(int(y), mm, dd).strftime("%Y-%m-%d")
            except ValueError:
                # Fallback to year only
                first_release_date = f"{int(y):04d}-01-01"

        rating_value: Optional[float] = None
        rating_0_100 = row.get("rating_0_100")
        if rating_0_100 is not None:
            try:
                rating_value = round(float(rating_0_100) / 20.0, 1)
            except Exception:
                rating_value = None

        album: Dict[str, Any] = {
            "objectID": str(row.get("object_uuid") or ""),
            "title": self.clean_text(row.get("title")),
            "first_release_date": first_release_date,
        }

        # Artists and countries
        artist_names = row.get("artist_names") or []
        countries = row.get("countries") or []
        album["artists"] = [self.clean_text(a) for a in artist_names if a]
        album["countries"] = [self.clean_text(c) for c in countries if c]

        # Genres mapped from tags
        tag_names = row.get("tag_names") or []
        album["genres"] = [self.clean_text(t) for t in tag_names if t]

        # Secondary types
        secondary_names = row.get("secondary_names") or []
        if secondary_names:
            album["secondary_types"] = [self.clean_text(s) for s in secondary_names if s]

        # Musicians (contributors across recordings of the album)
        musician_names = row.get("musician_names") or []
        if musician_names:
            album["musicians"] = [self.clean_text(n) for n in musician_names if n]

        # Detailed musicians info with mbid and instruments
        musician_details = row.get("musician_details") or []
        if musician_details:
            normalized_details = []
            for md in musician_details:
                if not isinstance(md, dict):
                    continue
                name = self.clean_text(md.get("name"))
                mbid = self.clean_text(md.get("mbid"))
                instruments = md.get("instruments") or []
                instruments = [self.clean_text(i) for i in instruments if i]
                detail_obj = {
                    k: v
                    for k, v in {
                        "name": name,
                        "mbid": mbid,
                        "instruments": instruments,
                    }.items()
                    if v not in (None, "") and v != []
                }
                if detail_obj:
                    normalized_details.append(detail_obj)
            if normalized_details:
                album["musicians_details"] = normalized_details

        # Ratings
        if rating_value is not None:
            album["rating_value"] = rating_value
        rating_count = row.get("rating_count")
        if rating_count is not None:
            album["rating_count"] = int(rating_count)

        # Composite score for ranking: rating_value * rating_count
        if album.get("rating_value") is not None and album.get("rating_count") is not None:
            try:
                album["rating_score"] = float(album["rating_value"]) * int(album["rating_count"])
            except Exception:
                pass

        # Derived fields
        if first_release_date:
            try:
                album["release_year"] = int(first_release_date[:4])
            except Exception:
                pass

        if album.get("artists"):
            album["main_artist"] = album["artists"][0]
        if album.get("genres"):
            album["primary_genre"] = album["genres"][0]

        # Remove null/empty
        album = {k: v for k, v in album.items() if v not in (None, "") and v != []}
        # Cover art URLs (Cover Art Archive) using a representative release gid when available
        cover_release_gid = row.get("cover_release_gid")
        if cover_release_gid:
            base = f"https://coverartarchive.org/release/{cover_release_gid}/front"
            album["cover_art_url"] = base
            album["cover_art_url_250"] = f"{base}-250"
            album["cover_art_url_500"] = f"{base}-500"
            album["cover_art_url_1200"] = f"{base}-1200"
        if not album.get("title") or not album.get("objectID"):
            return None
        self.processed_count += 1
        return album

    def stream_albums_from_db(
        self,
        batch_size: int = 1000,
        max_records: Optional[int] = None,
    ):
        """Generator yielding processed album batches directly from PostgreSQL."""
        sql = self._build_album_batch_sql()
        total_yielded = 0
        last_id = 0

        with self._connect_db() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                while True:
                    cur.execute(sql, (last_id, batch_size))
                    rows = cur.fetchall()
                    if not rows:
                        break

                    processed_batch: List[Dict[str, Any]] = []
                    for row in rows:
                        album = self._row_to_album(row)
                        if album:
                            processed_batch.append(album)

                    if not processed_batch:
                        # Advance last_id even if nothing processed to avoid infinite loop
                        last_id = rows[-1]["rg_id"]
                        continue

                    total_yielded += len(processed_batch)
                    yield processed_batch

                    last_id = rows[-1]["rg_id"]

                    if max_records is not None and total_yielded >= max_records:
                        break

    def process_json_file_in_batches(
        self,
        file_path: Union[str, Path],
        batch_size: int = 1000,
        max_records: Optional[int] = None,
        on_batch_processed=None,
    ):
        """
        Process album data from JSON file in batches.

        Args:
            file_path: Path to the JSON file
            batch_size: Number of records per batch
            max_records: Maximum total records to process
            on_batch_processed: Callback function called after each batch is processed

        Yields:
            Processed album records for each batch
        """
        total_processed = 0

        for batch_data in self.load_json_data_in_batches(file_path, batch_size):
            # Apply max_records limit
            if max_records and total_processed >= max_records:
                break

            # Limit current batch if needed
            if max_records:
                remaining = max_records - total_processed
                if remaining < len(batch_data):
                    batch_data = batch_data[:remaining]

            # Process the batch
            processed_batch = self.process_albums(batch_data)
            total_processed += len(processed_batch)

            # Call callback if provided
            if on_batch_processed:
                on_batch_processed(processed_batch, total_processed)

            yield processed_batch

    def process_json_file(
        self, file_path: Union[str, Path], max_records: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Load and process album data from a JSON file.

        Args:
            file_path: Path to the JSON file
            max_records: Maximum number of records to process (for testing)

        Returns:
            List of processed album records
        """
        albums_data = self.load_json_data(file_path)
        return self.process_albums(albums_data, max_records)
