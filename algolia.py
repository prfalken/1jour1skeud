from config import Config
from algoliasearch.search.client import SearchClientSync


class AlgoliaApp:
    def __init__(self, config: Config, client: SearchClientSync):
        self.config = config
        self.client = client
        self.index_name = config.ALGOLIA_INDEX_NAME
        self.batch_size = 1000  # Algolia recommended batch size

    def clear_index(self) -> None:
        """Clear all records from the Algolia index."""
        try:
            print(f"🧹 Clearing index '{self.index_name}'...")
            self.client.clear_objects(index_name=self.index_name)
            print(f"✅ Index '{self.index_name}' cleared successfully.")
        except Exception as e:
            print(f"⚠️  Error clearing index '{self.index_name}': {e}")

    def get_index_stats(self):
        """Retrieve statistics for the Algolia index."""
        try:
            stats = self.client.list_indices()
            print(f"📈 Index stats for '{self.index_name}': {stats}")
            print(stats)
        except Exception as e:
            print(f"⚠️  Error retrieving index stats: {e}")
            return {}

    def configure_index_settings(self) -> None:
        """Configure Algolia index settings for optimal album search with rating support."""
        print("⚙️  Configuring index settings for optimal album search...")
        print("🎯 Ratings will be indexed for search ranking and filtering")
        print("📝 Custom ranking: rating_value (desc) → rating_count (desc) → release_year (desc)")
