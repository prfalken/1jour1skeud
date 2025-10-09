# Music Album Database Sync to Algolia

A Python application that fetches the latest music album database from Kaggle and indexes it into Algolia for powerful search functionality.

## Features

- 🎬 Fetches music album data from Kaggle datasets
- 🔄 Processes and cleans movie data for optimal search
- 🔍 Indexes data to Algolia with optimized search settings
- 📊 Batch processing with progress indicators
- 🧪 Built-in testing and validation
- ⚙️ Configurable via environment variables
- 🚀 Command-line interface with multiple options

## Prerequisites

Before running this application, you need:

1. **Kaggle Account & API Key**
   - Create an account at [kaggle.com](https://www.kaggle.com)
   - Generate API credentials at [kaggle.com/settings](https://www.kaggle.com/settings)

2. **Algolia Account & Credentials**
   - Create an account at [algolia.com](https://www.algolia.com)
   - Get your Application ID and Admin API Key from the dashboard

3. **Python 3.8+**

## Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd movies-sync
```

2. Create and activate a virtual environment:
```bash
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Set up environment variables:
```bash
cp .env.example .env
```

Edit `.env` with your credentials:
```env
# Kaggle API credentials
KAGGLE_USERNAME=your_kaggle_username
KAGGLE_KEY=your_kaggle_key

# Algolia credentials
ALGOLIA_APPLICATION_ID=your_algolia_app_id
ALGOLIA_API_KEY=your_algolia_admin_api_key

# Index configuration
ALGOLIA_INDEX_NAME=movies
```

## Usage

### Basic Sync
Run the complete sync process:
```bash
python main.py
```

### Command Line Options

```bash
# Force re-download from Kaggle
python main.py --force-download

# Limit records for testing
python main.py --max-records 1000

# Clear existing index before sync
python main.py --clear-index

# Test search functionality
python main.py --test-search "batman"

# Show index statistics
python main.py --show-stats

# Help
python main.py --help
```

### Example Workflows

**Initial Setup:**
```bash
# First run - download data and create index
python main.py --clear-index

# Test that everything works
python main.py --test-search "action"
```

**Regular Updates:**
```bash
# Update with latest data
python main.py --force-download
```

**Testing with Limited Data:**
```bash
# Test with only 100 records
python main.py --max-records 100 --clear-index
```

## Project Structure

```
movies-sync/
├── main.py              # Main application entry point
├── config.py            # Configuration management
├── kaggle_fetcher.py    # Kaggle data fetching
├── data_processor.py    # Data cleaning and processing
├── algolia_indexer.py   # Algolia indexing functionality
├── requirements.txt     # Python dependencies
├── .env.example        # Environment variables template
├── .gitignore          # Git ignore rules
└── README.md           # This file
```

## Data Processing

The application processes movie data with the following transformations:

### Data Cleaning
- Text normalization and cleaning
- Date parsing and standardization
- Numeric value validation
- JSON field parsing (genres, production companies, etc.)

### Enhanced Fields
- **Searchable Text**: Combined searchable content
- **Image URLs**: Full Albim image URLs for posters and backdrops
- **Derived Metrics**: Profit, ROI, release year, decade
- **Faceting Data**: Structured data for filtering

### Algolia Optimization
- **Search Ranking**: Popularity, ratings, and vote counts
- **Faceting**: Genre, year, language, companies
- **Highlighting**: Title and overview snippets
- **Typo Tolerance**: Smart search suggestions

## Algolia Index Configuration

The application automatically configures your Algolia index with:

- **Searchable Attributes**: title, overview, genres, etc.
- **Faceting Attributes**: genres, year, language, etc.
- **Custom Ranking**: popularity, ratings, revenue
- **Search Features**: typo tolerance, highlighting, snippets

## Search Examples

Once indexed, you can search for movies using various queries:

```javascript
// Basic search
index.search('batman')

// Search with filters
index.search('action', {
  filters: 'release_year >= 2020 AND genres:Action'
})

// Faceted search
index.search('', {
  facets: ['genres', 'release_year'],
  maxValuesPerFacet: 10
})
```

## Troubleshooting

### Common Issues

**Kaggle Authentication Error:**
- Verify your Kaggle username and API key
- Check that your Kaggle account has API access enabled

**Algolia Connection Error:**
- Verify your Application ID and API key
- Ensure you're using the Admin API key (not Search-only)

**Memory Issues:**
- Use `--max-records` to limit the dataset size
- The full Album dataset can be several hundred thousand records

**Import Errors:**
- Ensure all dependencies are installed: `pip install -r requirements.txt`
- Verify you're using the correct Python environment

### Performance Tips

1. **First Run**: Use `--max-records 1000` to test the setup
2. **Memory**: Process in smaller batches if you encounter memory issues  
3. **Network**: Ensure stable internet for Kaggle downloads and Algolia uploads
4. **Index Settings**: The application optimizes settings automatically

## Dataset Information

This application uses Music Albums datasets available on Kaggle, typically containing:

- Movie titles and descriptions
- Release dates and runtime
- Ratings and popularity metrics
- Genres and production information
- Cast and crew data (if available)
- Financial data (budget/revenue)

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Support

If you encounter issues:

1. Check the troubleshooting section
2. Verify your environment variables
3. Test with limited records first
4. Check the console output for specific error messages

For bugs or feature requests, please open an issue on the repository.