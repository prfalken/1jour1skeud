from config import Config
from algolia import AlgoliaApp


class AlgoliaSearcher(AlgoliaApp):
    """Handles indexing album data to Algolia with full implementation."""

    def search_albums(self, query: str, params: dict = None) -> dict:
        """Search albums in the Algolia index."""
        response = self.client.search(
            search_method_params={
                "requests": [
                    {
                        "indexName": self.index_name,
                        "query": query,
                        "optionalFilters": "release_year:1985",
                    },
                ],
            },
        )
        return response.to_dict().get("results", [])[0].get("hits", [])
