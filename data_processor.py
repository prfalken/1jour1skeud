"""
Data processor for cleaning and transforming music album data for Algolia indexing.
"""

import json
import re
from datetime import datetime
from typing import Any, Dict, List, Optional, Union
from pathlib import Path

from tqdm import tqdm


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

    def safe_numeric_convert(
        self, value: Any, default: Union[int, float] = 0
    ) -> Union[int, float]:
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

    def process_album_record(
        self, album_data: Dict[str, Any]
    ) -> Optional[Dict[str, Any]]:
        """Process a single album record for Algolia indexing."""
        try:
            if not album_data.get("primary-type") == "Album":
                return None
            # Extract basic album information
            album = {
                "objectID": str(album_data.get("id", "")),
                "title": self.clean_text(album_data.get("title")),
                "first_release_date": self.parse_date(
                    album_data.get("first-release-date")
                ),
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
                album["secondary_types"] = [
                    self.clean_text(st) for st in secondary_types if st
                ]

            # Handle rating information
            rating_info = album_data.get("rating", {})
            if isinstance(rating_info, dict):
                if rating_info.get("value") is not None:
                    album["rating_value"] = self.safe_numeric_convert(
                        rating_info["value"], 0.0
                    )
                if rating_info.get("votes-count") is not None:
                    album["rating_count"] = self.safe_numeric_convert(
                        rating_info["votes-count"], 0
                    )

            # Calculate derived fields
            if album["first_release_date"]:
                try:
                    year = datetime.strptime(
                        album["first_release_date"], "%Y-%m-%d"
                    ).year
                    album["release_year"] = year
                except ValueError:
                    # Try to extract just the year if full date parsing fails
                    year_match = re.search(
                        r"\b(19|20)\d{2}\b", album["first_release_date"]
                    )
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

            # Remove None values and empty lists
            album = {
                k: v for k, v in album.items() if v is not None and v != [] and v != ""
            }

            # Ensure we have at least a title and objectID
            if not album.get("title") or not album.get("objectID"):
                return None

            self.processed_count += 1
            return album

        except Exception as e:
            self.error_count += 1
            print(f"⚠️  Error processing record {album_data.get('id', 'unknown')}: {e}")
            return None

    def load_json_data_in_batches(
        self, file_path: Union[str, Path], batch_size: int = 1000
    ):
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
                        print(
                            f"📦 Loaded batch with {len(current_batch)} records (total: {total_loaded})"
                        )
                        yield current_batch
                        current_batch = []

                except json.JSONDecodeError as e:
                    print(f"⚠️  Error parsing JSON on line {line_num}: {e}")
                    self.error_count += 1

        # Yield remaining records in the last batch
        if current_batch:
            print(
                f"📦 Loaded final batch with {len(current_batch)} records (total: {total_loaded})"
            )
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
