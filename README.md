# AlbumGuessr — MusicBrainz → Algolia indexer + daily guessing game

This repository contains:

- A Python CLI that streams MusicBrainz release groups from PostgreSQL, normalizes album fields, and indexes them into Algolia for fast search.
- A small static frontend game in `frontend/` where you guess the “mystery album” of the day using Algolia-powered search and progressive clues.

## What it does

- Connects to a MusicBrainz PostgreSQL database and selects release groups of primary type "Album" with related metadata (artists, countries, tags → genres, secondary types, contributors, ratings, first release date, and a representative cover art).
- Normalizes each record to a compact object suitable for search and faceting.
- Indexes records to Algolia in batches.
- Provides a static web game that:
  - Picks a daily mystery album from `frontend/mistery-albums.jsonl` (MBIDs).
  - Lets you search the Algolia index and submit guesses.
  - Reveals shared attributes (artists, genres, countries, musicians, year hints) until you find the right album.

## Prerequisites

- Python 3.10+
- Algolia account with:
  - Application ID
  - Admin API key (for indexing from the backend)
  - Search-only API key (for the frontend)
- Access to a MusicBrainz PostgreSQL database (host, port, database name, user, password). You can point to your own instance or a replica populated with MusicBrainz and Cover Art Archive tables.

Note: `KAGGLE_USERNAME`/`KAGGLE_KEY` exist in `config.py` and are not used by the current indexing flow, but the runtime validation currently expects them to be present. Set any dummy values for these two variables in your `.env` to pass validation.

## Install

```bash
git clone <repository-url>
cd albumguessr

python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

## Configure

Create a `.env` file at the project root with your settings:

```env
# Algolia (backend indexing)
ALGOLIA_APPLICATION_ID=your_algolia_app_id
ALGOLIA_API_KEY=your_algolia_admin_api_key
ALGOLIA_INDEX_NAME=albumguessr

# MusicBrainz PostgreSQL
DB_HOST=localhost
DB_PORT=5432
DB_NAME=musicbrainz_db
DB_USER=musicbrainz
DB_PASSWORD=musicbrainz

# Required by current validation (not used by indexing)
KAGGLE_USERNAME=dummy
KAGGLE_KEY=dummy
```

## Usage (backend)

Run the DB-driven sync to index albums to Algolia:

```bash
python main.py
```

Useful flags:

```bash
# Clear existing index
python main.py --clear-index

# Show index stats
python main.py --stats

# Configure index settings (prints current configuration routine)
python main.py --configure

# Limit processed records (for testing) and batch size
python main.py --max-records 1000 --batch-size 500

# Quick search test from CLI
python main.py --search "appetite for destruction"
```

### Record shape indexed to Algolia

Each album is normalized roughly like this:

```json
{
  "objectID": "<release-group-gid>",
  "title": "Ride the Lightning",
  "artists": ["Metallica"],
  "countries": ["US"],
  "genres": ["Thrash Metal"],
  "secondary_types": ["Compilation"],
  "musicians": ["Cliff Burton", "Kirk Hammett"],
  "first_release_date": "1984-07-27",
  "release_year": 1984,
  "rating_value": 4.6,       // 0..5, mapped from MusicBrainz 0..100
  "rating_count": 1234,
  "main_artist": "Metallica",
  "primary_genre": "Thrash Metal",
  "cover_art_url": "https://coverartarchive.org/release/<gid>/front",
  "cover_art_url_250": "...-250",
  "cover_art_url_500": "...-500",
  "cover_art_url_1200": "...-1200"
}
```

## Frontend game

The static game lives in `frontend/`.

1) Configure Algolia search credentials in `frontend/config.js`:

```js
const ALGOLIA_CONFIG = {
  applicationId: 'YOUR_APP_ID',
  apiKey: 'YOUR_SEARCH_ONLY_API_KEY',
  indexName: 'albumguessr'
};
```

2) Generate or update the mystery album list (MBIDs) using your DB:

```bash
# Writes top release-group IDs ranked by (rating * rating_count)
python top_release_groups.py --limit 1000 > frontend/mistery-albums.jsonl
```

3) Serve the frontend locally (any static server works):

```bash
cd frontend
python -m http.server 8000
# then open http://localhost:8000 in your browser
```

## Project structure

```
albumguessr/
├── main.py                 # CLI entrypoint (DB → Algolia sync, commands)
├── config.py               # Env/config handling (Algolia + DB)
├── data_processor.py       # Normalization + DB streaming and JSONL helpers
├── algolia.py              # Base Algolia app wrapper
├── algolia_indexer.py      # Batched indexing logic
├── algolia_searcher.py     # Simple search helper used by CLI
├── top_release_groups.py   # Utility to produce mystery album candidates
├── frontend/               # Static game (index.html, config.js, game.js, styles.css)
├── data/                   # Sample data files (JSON/JSONL)
├── requirements.txt        # Python dependencies
└── README.md               # This file
```

## Troubleshooting

- DB connection errors: verify `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` in `.env` and that your MusicBrainz schema is accessible.
- Algolia errors: check `ALGOLIA_APPLICATION_ID`, `ALGOLIA_API_KEY` (Admin key for backend), and `ALGOLIA_INDEX_NAME`. The frontend must use a search-only key.
- Empty search results: ensure you ran the indexer (`python main.py`) and the chosen index name matches both backend and frontend configs.
- Cover art URLs: they rely on Cover Art Archive tables/joins; if missing, those fields will be absent.

## License

MIT
