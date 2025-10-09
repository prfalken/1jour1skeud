// Configuration for Algolia Search
// Generated automatically from .env file - DO NOT EDIT MANUALLY
const ALGOLIA_CONFIG = {
    applicationId: 'RF1SJ2T8X7',
    apiKey: 'a28b84a7810f0eeca4badbb6db942e64', // Public search-only API key
    indexName: '1jour1skeud'
};

// Game configuration
const GAME_CONFIG = {
    // Clue categories to show when there are matches
    clueCategories: [
        { 
            key: 'artists', 
            label: 'Artistes', 
            icon: 'bi-person-fill',
            description: 'Artistes en commun'
        },
        { 
            key: 'genres', 
            label: 'Genres', 
            icon: 'bi-music-note-list',
            description: 'Genres musicaux partagés'
        },
        { 
            key: 'release_year', 
            label: 'Année', 
            icon: 'bi-calendar-fill',
            description: 'Année de sortie'
        },
        { 
            key: 'countries', 
            label: 'Pays', 
            icon: 'bi-globe',
            description: 'Pays d\'origine'
        },
    ]
};

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { ALGOLIA_CONFIG, GAME_CONFIG };
}
