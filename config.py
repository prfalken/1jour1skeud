"""
Configuration settings for the Music Album Sync application.
"""

import os
from typing import Optional
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


class Config:
    """Configuration class for the application."""

    # Kaggle API configuration
    KAGGLE_USERNAME: Optional[str] = os.getenv("KAGGLE_USERNAME")
    KAGGLE_KEY: Optional[str] = os.getenv("KAGGLE_KEY")

    # Algolia configuration
    ALGOLIA_APPLICATION_ID: Optional[str] = os.getenv("ALGOLIA_APPLICATION_ID")
    ALGOLIA_API_KEY: Optional[str] = os.getenv("ALGOLIA_API_KEY")
    ALGOLIA_INDEX_NAME: str = os.getenv("ALGOLIA_INDEX_NAME", "albumguessr")

    # Data configuration
    DATA_DIR: str = "data"
    ALBUMS_DATASET: str = "fleshmetal/records-a-comprehensive-music-metadata-dataset"

    # Processing configuration
    BATCH_SIZE: int = int(os.getenv("BATCH_SIZE", "1000"))
    MAX_RECORDS: Optional[int] = None  # Set to limit records for testing

    # Database configuration (MusicBrainz)
    DB_HOST: str = os.getenv("DB_HOST", "localhost")
    DB_PORT: int = int(os.getenv("DB_PORT", "5432"))
    DB_NAME: str = os.getenv("DB_NAME", "musicbrainz_db")
    DB_USER: str = os.getenv("DB_USER", "musicbrainz")
    DB_PASSWORD: str = os.getenv("DB_PASSWORD", "musicbrainz")

    @classmethod
    def validate(cls) -> None:
        """Validate that all required configuration is present."""
        required_vars = [
            ("KAGGLE_USERNAME", cls.KAGGLE_USERNAME),
            ("KAGGLE_KEY", cls.KAGGLE_KEY),
            ("ALGOLIA_APPLICATION_ID", cls.ALGOLIA_APPLICATION_ID),
            ("ALGOLIA_API_KEY", cls.ALGOLIA_API_KEY),
        ]

        missing_vars = [var_name for var_name, var_value in required_vars if not var_value]

        if missing_vars:
            raise ValueError(
                f"Missing required environment variables: {', '.join(missing_vars)}. "
                f"Please check your .env file or environment variables."
            )
