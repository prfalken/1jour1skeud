#!/usr/bin/env python3
"""
Print the top-N MusicBrainz release group MBIDs ranked by (votes * rating).

Uses the MusicBrainz schema tables:
  - musicbrainz.release_group (gid)
  - musicbrainz.release_group_meta (rating, rating_count)

Rating is stored on a 0..100 scale; votes is rating_count. The score is
rating * rating_count.
"""

import argparse
import json
import sys
from typing import List, Dict

import psycopg2
from psycopg2.extras import RealDictCursor

from config import Config


def get_top_release_group_ids(limit: int) -> List[Dict[str, str]]:
    sql = """
        SELECT rg.gid::text AS release_group_id,
        rg.name AS release_group_name
        FROM musicbrainz.release_group rg
        JOIN musicbrainz.release_group_meta rgm ON rgm.id = rg.id
        WHERE rgm.rating IS NOT NULL
          AND rgm.rating_count IS NOT NULL
          AND rgm.rating_count > 0
        ORDER BY (rgm.rating * rgm.rating_count) DESC
        LIMIT %s
    """

    conn = psycopg2.connect(
        host=Config.DB_HOST,
        port=Config.DB_PORT,
        dbname=Config.DB_NAME,
        user=Config.DB_USER,
        password=Config.DB_PASSWORD,
    )

    try:
        with conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute(sql, (limit,))
                rows = cur.fetchall()
                results: List[Dict[str, str]] = []
                for row in rows:
                    rgid = row.get("release_group_id")
                    name = row.get("release_group_name")
                    if rgid:
                        results.append({"id": str(rgid), "name": name or ""})
                return results
    finally:
        conn.close()


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Print top release group MBIDs by (votes * rating)",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=1000,
        help="How many release groups to return (default 1000)",
    )
    args = parser.parse_args()

    try:
        items = get_top_release_group_ids(args.limit)
    except Exception as e:
        print(f"Failed to query database: {e}")
        sys.exit(1)

    for item in items:
        print(json.dumps({"id": item["id"], "name": item["name"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
