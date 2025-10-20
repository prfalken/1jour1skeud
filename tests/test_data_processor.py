import json
import sys
import types
import importlib
import tempfile
import unittest
from pathlib import Path
from typing import Any, Dict, List

from unittest.mock import patch, MagicMock

# We'll import AlbumDataProcessor dynamically after installing stubs
AlbumDataProcessor = None  # type: ignore
Config = None  # type: ignore


def _install_dependency_stubs() -> None:
    """Install minimal stubs for external deps so importing data_processor works."""
    # Stub psycopg2 and extras.RealDictCursor if missing
    if "psycopg2" not in sys.modules:
        psycopg2_stub = types.SimpleNamespace()
        psycopg2_stub.connect = MagicMock(name="psycopg2.connect")
        extras = types.SimpleNamespace(RealDictCursor=object)
        psycopg2_stub.extras = extras
        sys.modules["psycopg2"] = psycopg2_stub
        sys.modules["psycopg2.extras"] = extras
    # Stub tqdm.tqdm to a passthrough
    if "tqdm" not in sys.modules:

        def _tqdm(iterable=None, **kwargs):  # noqa: ARG001
            return iterable

        tqdm_stub = types.SimpleNamespace(tqdm=_tqdm)
        sys.modules["tqdm"] = tqdm_stub


class TestAlbumDataProcessor(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        _install_dependency_stubs()
        # Ensure project root is on sys.path for direct module imports
        project_root = Path(__file__).resolve().parents[1]
        if str(project_root) not in sys.path:
            sys.path.insert(0, str(project_root))
        dp = importlib.import_module("data_processor")
        globals()["AlbumDataProcessor"] = dp.AlbumDataProcessor
        globals()["Config"] = importlib.import_module("config").Config

    def setUp(self):
        self.processor = AlbumDataProcessor()

    # Helper/pure functions
    def test_clean_text(self):
        self.assertIsNone(self.processor.clean_text(None))
        self.assertIsNone(self.processor.clean_text(""))
        self.assertIsNone(self.processor.clean_text("   "))
        self.assertEqual(self.processor.clean_text("Hello, World!"), "Hello, World!")
        self.assertEqual(self.processor.clean_text("Hello, World!   "), "Hello, World!")
        self.assertEqual(self.processor.clean_text("A   B\tC"), "A B C")

    def test_extract_artist_names(self):
        artist_credit: List[Dict[str, Any]] = [
            {"name": " Metallica ", "artist": {"name": "Metallica"}},
            {"artist": {"name": "James Hetfield"}},
            {"name": None},
        ]
        names = self.processor.extract_artist_names(artist_credit)
        self.assertEqual(names, ["Metallica", "James Hetfield"])

        # Empty and non-dict entries
        self.assertEqual(self.processor.extract_artist_names([]), [])
        self.assertEqual(self.processor.extract_artist_names(["x"]), [])

    def test_extract_genres_and_tags(self):
        genres = [{"name": "  Thrash Metal  "}, {"name": None}, {}]
        self.assertEqual(self.processor.extract_genres(genres), ["Thrash Metal"])

        tags = [{"name": " classic "}, {"x": 1}, {"name": ""}]
        self.assertEqual(self.processor.extract_tags(tags), ["classic"])

    def test_parse_date_formats_and_fallback(self):
        self.assertEqual(self.processor.parse_date("1986-03-03"), "1986-03-03")
        self.assertEqual(self.processor.parse_date("1986-03"), "1986-03-01")
        self.assertEqual(self.processor.parse_date("1986"), "1986-01-01")
        self.assertEqual(self.processor.parse_date("Released in 1999?"), "1999-01-01")
        self.assertIsNone(self.processor.parse_date("n/a"))
        self.assertIsNone(self.processor.parse_date(None))

    def test_safe_numeric_convert_int_and_float(self):
        self.assertEqual(self.processor.safe_numeric_convert("10", 0), 10)
        self.assertEqual(self.processor.safe_numeric_convert("10.9", 0), 10)
        self.assertEqual(self.processor.safe_numeric_convert("10.9", 0.0), 10.9)
        self.assertEqual(self.processor.safe_numeric_convert("1,234", 0), 1234)
        self.assertEqual(self.processor.safe_numeric_convert("bad", 7), 7)
        self.assertEqual(self.processor.safe_numeric_convert(None, 2.5), 2.5)

    def test_extract_country_info(self):
        artist_credit = [
            {"artist": {"country": " US "}},
            {"artist": {"country": "US"}},
            {"artist": {}},
        ]
        self.assertEqual(self.processor.extract_country_info(artist_credit), ["US"])
        self.assertEqual(self.processor.extract_country_info([]), [])

    # Record processing
    def test_process_album_record_happy_path(self):
        album_data = {
            "id": 123,
            "primary-type": "Album",
            "title": "  Master of Puppets  ",
            "first-release-date": "1986-03-03",
            "artist-credit": [
                {"name": "Metallica"},
                {"artist": {"name": "James Hetfield", "country": "US"}},
            ],
            "genres": [{"name": "Thrash Metal"}],
            "secondary-types": ["live", None],
            "rating": {"value": 4.5, "votes-count": 100},
        }
        result = self.processor.process_album_record(album_data)
        self.assertIsInstance(result, dict)
        self.assertEqual(result["objectID"], "123")
        self.assertEqual(result["title"], "Master of Puppets")
        self.assertEqual(result["first_release_date"], "1986-03-03")
        self.assertEqual(result["release_year"], 1986)
        self.assertEqual(result["artists"], ["Metallica", "James Hetfield"])
        self.assertEqual(result["countries"], ["US"])
        self.assertEqual(result["genres"], ["Thrash Metal"])
        self.assertEqual(result["main_artist"], "Metallica")
        self.assertEqual(result["primary_genre"], "Thrash Metal")
        self.assertIn("rating_score", result)

    def test_process_album_record_non_album(self):
        not_album = {"id": 1, "primary-type": "Single", "title": "X"}
        self.assertIsNone(self.processor.process_album_record(not_album))

    def test_process_album_record_missing_required(self):
        missing_title = {"id": 1, "primary-type": "Album"}
        self.assertIsNone(self.processor.process_album_record(missing_title))

        missing_id = {"primary-type": "Album", "title": "X"}
        self.assertIsNone(self.processor.process_album_record(missing_id))

    # File I/O
    def test_load_json_data_in_batches_and_error_count(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            p = Path(tmpdir) / "data.jsonl"
            lines = [
                json.dumps({"id": 1}),
                "",  # blank
                json.dumps({"id": 2}),
                "{bad json}",  # error
                json.dumps({"id": 3}),
            ]
            p.write_text("\n".join(lines), encoding="utf-8")

            batches = list(self.processor.load_json_data_in_batches(p, batch_size=2))
            # Expect batches: [ [1,2], [3] ]
            self.assertEqual(len(batches), 2)
            self.assertEqual(len(batches[0]), 2)
            self.assertEqual(len(batches[1]), 1)
            self.assertGreaterEqual(self.processor.error_count, 1)

    def test_load_json_data_success_and_errors(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            p = Path(tmpdir) / "data.jsonl"
            p.write_text("\n".join([json.dumps({"a": 1}), "{oops}", json.dumps({"b": 2})]), encoding="utf-8")
            proc = AlbumDataProcessor()
            items = proc.load_json_data(p)
            self.assertEqual(len(items), 2)
            self.assertEqual(proc.error_count, 1)

    def test_load_json_data_file_not_found(self):
        with self.assertRaises(FileNotFoundError):
            self.processor.load_json_data(Path("/no/such/file.jsonl"))

    def test_process_albums_respects_max_records(self):
        albums = [
            {"id": i, "primary-type": "Album", "title": f"T{i}", "first-release-date": "2000"} for i in range(5)
        ]
        proc = AlbumDataProcessor()
        out = proc.process_albums(albums, max_records=2)
        self.assertEqual(len(out), 2)

    # SQL helpers
    @patch("data_processor.psycopg2.connect")
    def test_connect_db_uses_config(self, mock_connect):
        with patch.object(Config, "DB_HOST", "h"), patch.object(Config, "DB_PORT", 5432), patch.object(
            Config, "DB_NAME", "n"
        ), patch.object(Config, "DB_USER", "u"), patch.object(Config, "DB_PASSWORD", "p"):
            self.processor._connect_db()
            mock_connect.assert_called_once_with(host="h", port=5432, dbname="n", user="u", password="p")

    def test_build_album_batch_sql_contains_expected_clauses(self):
        sql = self.processor._build_album_batch_sql()
        self.assertIn("SELECT", sql)
        self.assertIn("FROM musicbrainz.release_group rg", sql)
        self.assertIn("WHERE rpt.name = 'Album'", sql)
        self.assertIn("LIMIT %s", sql)

    # SQL row transformation
    def test_row_to_album_happy_path_and_cover_art(self):
        row = {
            "object_uuid": "uuid-123",
            "title": "  Ride the Lightning ",
            "fr_year": 1984,
            "fr_month": 7,
            "fr_day": 27,
            "rating_0_100": 85,
            "rating_count": 42,
            "artist_names": ["Metallica"],
            "countries": ["US"],
            "tag_names": ["Thrash"],
            "secondary_names": ["live", None],
            "musician_names": ["Cliff Burton"],
            "musician_details": [{"name": "Cliff Burton", "mbid": "mbid-1", "instruments": ["bass", None]}],
            "cover_release_gid": "rel-1",
        }
        out = self.processor._row_to_album(row)
        self.assertEqual(out["objectID"], "uuid-123")
        self.assertEqual(out["title"], "Ride the Lightning")
        self.assertEqual(out["first_release_date"], "1984-07-27")
        self.assertEqual(out["release_year"], 1984)
        self.assertAlmostEqual(out["rating_value"], 4.2)
        self.assertEqual(out["rating_count"], 42)
        self.assertIn("rating_score", out)
        self.assertEqual(out["artists"], ["Metallica"])
        self.assertEqual(out["countries"], ["US"])
        self.assertEqual(out["genres"], ["Thrash"])
        self.assertEqual(out["main_artist"], "Metallica")
        self.assertEqual(out["primary_genre"], "Thrash")
        # Musicians
        self.assertEqual(out.get("musicians"), ["Cliff Burton"])
        self.assertEqual(out.get("musicians_details")[0]["name"], "Cliff Burton")
        # Cover art URLs
        base = "https://coverartarchive.org/release/rel-1/front"
        self.assertEqual(out["cover_art_url"], base)
        self.assertEqual(out["cover_art_url_250"], base + "-250")
        self.assertEqual(out["cover_art_url_500"], base + "-500")
        self.assertEqual(out["cover_art_url_1200"], base + "-1200")

    def test_row_to_album_missing_required_returns_none(self):
        row_missing_id = {"title": "X"}
        self.assertIsNone(self.processor._row_to_album(row_missing_id))

        row_missing_title = {"object_uuid": "abc"}
        self.assertIsNone(self.processor._row_to_album(row_missing_title))

    # Streaming from DB
    def test_stream_albums_from_db_yields_and_stops(self):
        rows_iter = [
            [
                {"rg_id": 1, "object_uuid": "id-1", "title": "T1"},
                {"rg_id": 2, "object_uuid": "id-2", "title": "T2"},
            ],
            [
                {"rg_id": 3, "object_uuid": "id-3", "title": "T3"},
            ],
            [],
        ]

        class FakeCursor:
            def __init__(self):
                self.calls = 0

            def __enter__(self):
                return self

            def __exit__(self, exc_type, exc, tb):
                return False

            def execute(self, sql, params):  # noqa: ARG002
                self.calls += 1

            def fetchall(self):
                return rows_iter.pop(0)

        class FakeConn:
            def __enter__(self):
                return self

            def __exit__(self, exc_type, exc, tb):
                return False

            def cursor(self, cursor_factory=None):  # noqa: ARG002
                return FakeCursor()

        with patch.object(AlbumDataProcessor, "_connect_db", return_value=FakeConn()):
            # Patch _row_to_album to simply echo minimal album for each row
            def to_album(row):
                return {"objectID": row.get("object_uuid", ""), "title": row.get("title", "")}

            with patch.object(AlbumDataProcessor, "_row_to_album", side_effect=lambda r: to_album(r)):
                batches = list(self.processor.stream_albums_from_db(batch_size=2))
                self.assertEqual(len(batches), 2)
                self.assertEqual(len(batches[0]), 2)
                self.assertEqual(len(batches[1]), 1)

        # Test early stop via max_records
        rows_iter2 = [[{"rg_id": i, "object_uuid": f"id-{i}", "title": f"T{i}"} for i in range(1, 6)], []]
        with patch.object(AlbumDataProcessor, "_connect_db", return_value=FakeConn()):
            with patch.object(FakeCursor, "fetchall", new=lambda self: rows_iter2.pop(0)):
                with patch.object(
                    AlbumDataProcessor,
                    "_row_to_album",
                    side_effect=lambda r: {"objectID": r["object_uuid"], "title": r["title"]},
                ):
                    out = []
                    for batch in self.processor.stream_albums_from_db(batch_size=10, max_records=3):
                        out.extend(batch)
                    # Implementation yields full batch then stops; ensure at least 3 were yielded
                    self.assertGreaterEqual(len(out), 3)

    # JSON pipeline wrappers
    def test_process_json_file_in_batches_limits_and_callback(self):
        calls = []

        def fake_loader(path, batch_size):  # noqa: ARG001
            yield [{"id": 1, "primary-type": "Album", "title": "A", "first-release-date": "2000"}] * 3
            yield [{"id": 2, "primary-type": "Album", "title": "B", "first-release-date": "2000"}] * 3

        with patch.object(AlbumDataProcessor, "load_json_data_in_batches", side_effect=fake_loader):
            with patch.object(
                AlbumDataProcessor,
                "process_albums",
                side_effect=lambda xs: [{"objectID": str(i.get("id")), "title": i.get("title")} for i in xs],
            ):

                def on_batch(processed, total):
                    calls.append((len(processed), total))

                gen = self.processor.process_json_file_in_batches(
                    Path("dummy"), batch_size=3, max_records=5, on_batch_processed=on_batch
                )
                batches = list(gen)
                # Expect two batches output: first 3, then only 2 to respect max_records=5
                self.assertEqual([len(b) for b in batches], [3, 2])
                self.assertEqual(calls, [(3, 3), (2, 5)])

    def test_process_json_file_chains(self):
        with patch.object(AlbumDataProcessor, "load_json_data", return_value=[{"id": 1}]) as ld, patch.object(
            AlbumDataProcessor, "process_albums", return_value=[{"objectID": "1"}]
        ) as pa:
            out = self.processor.process_json_file(Path("dummy"), max_records=1)
            self.assertEqual(out, [{"objectID": "1"}])
            ld.assert_called_once()
            pa.assert_called_once()


if __name__ == "__main__":
    unittest.main(verbosity=2)
