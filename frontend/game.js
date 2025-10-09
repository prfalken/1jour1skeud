class Game1Jour1Skeud {
    constructor() {
        this.algoliaClient = null;
        this.algoliaIndex = null;
        this.guessCount = 0;
        this.gameOver = false;
        this.gameWon = false;
        this.mysteryAlbum = null;
        this.guesses = [];
        this.searchResults = [];
        this.selectedResult = null;
        this.discoveredClues = new Map(); // Map of clue category -> Set of values
        
        this.initializeAlgolia();
        this.initializeDOM();
        this.initializeGame();
        this.bindEvents();
    }

    initializeAlgolia() {
        try {
            this.algoliaClient = algoliasearch(
                ALGOLIA_CONFIG.applicationId,
                ALGOLIA_CONFIG.apiKey
            );
            this.algoliaIndex = this.algoliaClient.initIndex(ALGOLIA_CONFIG.indexName);
            console.log('Algolia initialized successfully');
        } catch (error) {
            console.error('Failed to initialize Algolia:', error);
            this.showError('Erreur de connexion à la base de données. Veuillez recharger la page.');
        }
    }

    initializeDOM() {
        // Get DOM elements
        this.elements = {
            gameDate: document.getElementById('game-date'),
            guessCount: document.getElementById('guess-count'),
            albumSearch: document.getElementById('album-search'),
            searchSubmit: document.getElementById('search-submit'),
            searchResults: document.getElementById('search-results'),
            cluesContainer: document.getElementById('clues-container'),
            guessesContainer: document.getElementById('guesses-container'),
            victoryModal: document.getElementById('victory-modal'),
            mysteryAlbumDisplay: document.getElementById('mystery-album-display'),
            finalGuesses: document.getElementById('final-guesses'),
            finalClues: document.getElementById('final-clues'),
            shareButton: document.getElementById('share-button'),
            closeVictory: document.getElementById('close-victory'),
            instructionsModal: document.getElementById('instructions-modal'),
            instructionsButton: document.getElementById('instructions-button'),
            closeInstructions: document.getElementById('close-instructions'),
            loading: document.getElementById('loading')
        };

        // Set current date
        const today = new Date();
        const options = { 
            weekday: 'long', 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
        };
        this.elements.gameDate.textContent = today.toLocaleDateString('fr-FR', options);
    }

    initializeGame() {
        this.showLoading(true);
        this.selectDailyAlbum()
            .then(() => {
                this.updateUI();
                this.showLoading(false);
            })
            .catch(error => {
                console.error('Failed to initialize game:', error);
                this.showError('Erreur lors du chargement du jeu. Veuillez recharger la page.');
                this.showLoading(false);
            });
    }

    async selectDailyAlbum() {
        try {
            // Select a high-quality album prioritizing community rating and number of votes
            
            // Search for albums and select one based on the seed
            const searchResponse = await this.algoliaIndex.search('', {
                hitsPerPage: 1000, // Get more albums to filter from
                attributesToRetrieve: [
                    'objectID', 'title', 'artists', 'genres', 'release_year', 'countries', 'tags',
                    // Support both processed fields and raw nested rating
                    'rating_value', 'rating_count', 'rating'
                ]
            });

            if (searchResponse.hits.length === 0) {
                throw new Error('No albums found in database');
            }

            // Filter for higher quality/well-known albums
            const qualityAlbums = searchResponse.hits.filter(album => {
                // Prioritize albums with:
                // 1. Have genres (indicates more documented/known albums)
                // 2. Have multiple tags (indicates popularity/documentation)
                // 3. Have rating votes (even if rating is null, votes indicate interest)
                // 4. Released in classic decades (1960s-2000s for well-established albums)
                const hasGenres = album.genres && album.genres.length > 0;
                const hasMultipleTags = album.tags && album.tags.length >= 2;
                const hasVotes = (album.rating && album.rating.votes_count > 0) ||
                    (typeof album.rating_count === 'number' && album.rating_count > 0);
                const isFromClassicEra = album.release_year && 
                    parseInt(album.release_year) >= 1960 && 
                    parseInt(album.release_year) <= 2025;
                
                // Album must have at least genres and be from a reasonable time period
                return hasGenres && isFromClassicEra && (hasMultipleTags || hasVotes);
            });

            // If no quality albums found, fallback to albums with just genres
            const albumsToChooseFrom = qualityAlbums.length > 0 ? qualityAlbums : 
                searchResponse.hits.filter(album => album.genres && album.genres.length > 0);

            if (albumsToChooseFrom.length === 0) {
                throw new Error('No suitable albums found in database');
            }

            // Select highest-rated album; break ties by vote count, then title
            const sortedByRatingAndVotes = albumsToChooseFrom.slice().sort((a, b) => {
                const ratingA = (typeof a.rating_value === 'number' ? a.rating_value :
                    (a.rating && typeof a.rating.value === 'number' ? a.rating.value : -1));
                const ratingB = (typeof b.rating_value === 'number' ? b.rating_value :
                    (b.rating && typeof b.rating.value === 'number' ? b.rating.value : -1));
                if (ratingA !== ratingB) return ratingB - ratingA;
                const votesA = (typeof a.rating_count === 'number' ? a.rating_count :
                    (a.rating && typeof a.rating.votes_count === 'number' ? a.rating.votes_count : 0));
                const votesB = (typeof b.rating_count === 'number' ? b.rating_count :
                    (b.rating && typeof b.rating.votes_count === 'number' ? b.rating.votes_count : 0));
                if (votesA !== votesB) return votesB - votesA;
                return (a.title || '').localeCompare(b.title || '');
            });
            this.mysteryAlbum = sortedByRatingAndVotes[0];
            
            console.log('Daily mystery album selected:', this.mysteryAlbum);
            console.log('Selected from', albumsToChooseFrom.length, 'quality albums out of', searchResponse.hits.length, 'total albums');
        } catch (error) {
            console.error('Error selecting daily album:', error);
            throw error;
        }
    }

    hashCode(str) {
        let hash = 0;
        for (let i = 0; i < str.length; i++) {
            const char = str.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash; // Convert to 32-bit integer
        }
        return hash;
    }

    bindEvents() {
        // Search input events
        this.elements.albumSearch.addEventListener('input', 
            this.debounce(this.handleSearchInput.bind(this), 300)
        );
        
        this.elements.albumSearch.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.submitGuess();
            } else if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
                e.preventDefault();
                this.navigateSearchResults(e.key === 'ArrowDown' ? 1 : -1);
            }
        });

        // Submit button
        this.elements.searchSubmit.addEventListener('click', this.submitGuess.bind(this));

        // Modal events
        this.elements.closeVictory.addEventListener('click', this.hideVictoryModal.bind(this));
        this.elements.shareButton.addEventListener('click', this.shareResult.bind(this));
        
        // Instructions modal
        this.elements.instructionsButton.addEventListener('click', this.showInstructionsModal.bind(this));
        this.elements.closeInstructions.addEventListener('click', this.hideInstructionsModal.bind(this));

        // Close modals on background click
        this.elements.victoryModal.addEventListener('click', (e) => {
            if (e.target === this.elements.victoryModal) {
                this.hideVictoryModal();
            }
        });

        this.elements.instructionsModal.addEventListener('click', (e) => {
            if (e.target === this.elements.instructionsModal) {
                this.hideInstructionsModal();
            }
        });

        // Close search results when clicking outside
        document.addEventListener('click', (e) => {
            if (!e.target.closest('.search-container')) {
                this.hideSearchResults();
            }
        });
    }

    async handleSearchInput(event) {
        const query = event.target.value.trim();
        
        if (query.length < 2) {
            this.hideSearchResults();
            this.selectedResult = null;
            this.elements.searchSubmit.disabled = true;
            return;
        }

        try {
            const searchResponse = await this.algoliaIndex.search(query, {
                hitsPerPage: 8,
                attributesToRetrieve: ['objectID', 'title', 'artists', 'genres', 'release_year', 'countries']
            });

            this.searchResults = searchResponse.hits;
            this.displaySearchResults();
            this.elements.searchSubmit.disabled = this.searchResults.length === 0;
        } catch (error) {
            console.error('Search error:', error);
        }
    }

    displaySearchResults() {
        if (this.searchResults.length === 0) {
            this.hideSearchResults();
            return;
        }

        const resultsHTML = this.searchResults.map((album, index) => `
            <div class="search-result ${index === 0 ? 'selected' : ''}" data-album-id="${album.objectID}" data-index="${index}">
                <div class="search-result-title">${this.escapeHtml(album.title)}</div>
                <div class="search-result-artist">${this.escapeHtml(album.artists ? album.artists.join(', ') : 'Artiste inconnu')}</div>
                <div class="search-result-meta">
                    ${album.release_year ? `<span>${album.release_year}</span>` : ''}
                    ${album.genres && album.genres.length > 0 ? `<span>${album.genres[0]}</span>` : ''}
                    ${album.countries && album.countries.length > 0 ? `<span>${album.countries[0]}</span>` : ''}
                </div>
            </div>
        `).join('');

        this.elements.searchResults.innerHTML = resultsHTML;
        this.elements.searchResults.classList.add('show');

        // Set first result as selected by default
        this.selectedResult = this.searchResults[0];

        // Bind click events to search results
        this.elements.searchResults.querySelectorAll('.search-result').forEach(result => {
            result.addEventListener('click', () => {
                const albumId = result.dataset.albumId;
                const album = this.searchResults.find(a => a.objectID === albumId);
                this.selectedResult = album;
                this.updateSelectedResult(parseInt(result.dataset.index));
                this.submitGuess();
            });
        });
    }

    navigateSearchResults(direction) {
        if (this.searchResults.length === 0) return;

        const currentIndex = this.selectedResult ? 
            this.searchResults.findIndex(r => r.objectID === this.selectedResult.objectID) : 0;
        
        let newIndex = currentIndex + direction;
        if (newIndex < 0) newIndex = this.searchResults.length - 1;
        if (newIndex >= this.searchResults.length) newIndex = 0;

        this.selectedResult = this.searchResults[newIndex];
        this.updateSelectedResult(newIndex);
    }

    updateSelectedResult(selectedIndex) {
        const results = this.elements.searchResults.querySelectorAll('.search-result');
        results.forEach((result, index) => {
            if (index === selectedIndex) {
                result.classList.add('selected');
            } else {
                result.classList.remove('selected');
            }
        });
    }

    hideSearchResults() {
        this.elements.searchResults.classList.remove('show');
    }

    submitGuess() {
        if (this.gameOver || !this.selectedResult) return;

        this.guessCount++;
        const isCorrect = this.selectedResult.objectID === this.mysteryAlbum.objectID;
        
        const guess = {
            album: this.selectedResult,
            correct: isCorrect,
            guessNumber: this.guessCount,
            cluesRevealed: []
        };

        // Analyze shared attributes and reveal clues
        if (!isCorrect) {
            guess.cluesRevealed = this.analyzeSharedAttributes(this.selectedResult, this.mysteryAlbum);
            this.updateDiscoveredClues(guess.cluesRevealed);
        }

        this.guesses.push(guess);
        
        if (isCorrect) {
            this.gameWon = true;
            this.gameOver = true;
        }

        // Update year hint if we have any year information
        this.updateYearHint();

        this.updateUI();
        this.elements.albumSearch.value = '';
        this.hideSearchResults();
        this.selectedResult = null;
        this.elements.searchSubmit.disabled = true;

        if (this.gameOver) {
            setTimeout(() => this.showVictoryModal(), 1000);
        }
    }

    analyzeSharedAttributes(guess, mystery) {
        const sharedClues = [];

        GAME_CONFIG.clueCategories.forEach(category => {
            // Skip release_year as it's handled separately
            if (category.key === 'release_year') return;
            
            const guessValue = guess[category.key];
            const mysteryValue = mystery[category.key];

            if (guessValue && mysteryValue) {
                let matches = [];

                if (Array.isArray(guessValue) && Array.isArray(mysteryValue)) {
                    // Find intersection for arrays
                    matches = guessValue.filter(value => mysteryValue.includes(value));
                } else if (guessValue === mysteryValue) {
                    // Direct match for non-arrays
                    matches = [guessValue];
                }

                if (matches.length > 0) {
                    sharedClues.push({
                        category: category.key,
                        label: category.label,
                        icon: category.icon,
                        values: matches
                    });
                }
            }
        });

        return sharedClues;
    }

    updateYearHint() {
        // Check if mystery album has a release year
        if (!this.mysteryAlbum.release_year) return;
        
        const mysteryYear = parseInt(this.mysteryAlbum.release_year);
        
        // Collect all year guesses that have release_year data
        const allYearGuesses = this.guesses
            .map(g => g.album.release_year)
            .filter(year => year && !isNaN(parseInt(year)))
            .map(year => parseInt(year));
        
        if (allYearGuesses.length === 0) return;
        
        // Check if any guess has the exact year
        const exactMatch = allYearGuesses.includes(mysteryYear);
        if (exactMatch) {
            // Show the exact year
            if (!this.discoveredClues.has('release_year')) {
                this.discoveredClues.set('release_year', new Set());
            }
            this.discoveredClues.set('release_year', new Set([mysteryYear.toString()]));
            return;
        }
        
        // Sort years to find the range
        allYearGuesses.sort((a, b) => a - b);
        
        // Find years that are before and after the mystery year
        const yearsBefore = allYearGuesses.filter(year => year < mysteryYear);
        const yearsAfter = allYearGuesses.filter(year => year > mysteryYear);
        
        let yearHint = null;
        
        // Determine the hint based on the range
        if (yearsBefore.length > 0 && yearsAfter.length > 0) {
            // We have years both before and after - show range
            const latestBefore = Math.max(...yearsBefore);
            const earliestAfter = Math.min(...yearsAfter);
            yearHint = `entre ${latestBefore} et ${earliestAfter}`;
        } else if (yearsBefore.length > 0) {
            // We only have years before - show "after X"
            const latestBefore = Math.max(...yearsBefore);
            yearHint = `après ${latestBefore}`;
        } else if (yearsAfter.length > 0) {
            // We only have years after - show "before X"
            const earliestAfter = Math.min(...yearsAfter);
            yearHint = `avant ${earliestAfter}`;
        }
        
        // Update the discovered clues with the new year hint
        if (yearHint) {
            if (!this.discoveredClues.has('release_year')) {
                this.discoveredClues.set('release_year', new Set());
            }
            this.discoveredClues.set('release_year', new Set([yearHint]));
        }
    }

    updateDiscoveredClues(newClues) {
        newClues.forEach(clue => {
            if (!this.discoveredClues.has(clue.category)) {
                this.discoveredClues.set(clue.category, new Set());
            }
            
            clue.values.forEach(value => {
                this.discoveredClues.get(clue.category).add(value);
            });
        });
    }

    updateUI() {
        // Update guess counter
        this.elements.guessCount.textContent = this.guessCount;
        
        // Update clues board
        this.updateCluesBoard();

        // Update guesses history
        this.updateGuessesHistory();
    }

    updateCluesBoard() {
        if (this.discoveredClues.size === 0) {
            this.elements.cluesContainer.innerHTML = `
                <div class="no-clues">
                    <i class="bi bi-search"></i>
                    <p>Faites un premier essai pour découvrir des indices...</p>
                </div>
            `;
            return;
        }

        const cluesHTML = Array.from(this.discoveredClues.entries()).map(([category, values]) => {
            const categoryConfig = GAME_CONFIG.clueCategories.find(c => c.key === category);
            if (!categoryConfig) return '';

            const valuesHTML = Array.from(values).map(value => 
                `<span class="clue-value">${this.escapeHtml(value)}</span>`
            ).join('');

            return `
                <div class="clue-category">
                    <div class="clue-category-title">
                        <i class="bi ${categoryConfig.icon}"></i>
                        ${categoryConfig.label}
                    </div>
                    <div class="clue-values">
                        ${valuesHTML}
                    </div>
                </div>
            `;
        }).join('');

        this.elements.cluesContainer.innerHTML = cluesHTML;
    }

    updateGuessesHistory() {
        if (this.guesses.length === 0) {
            this.elements.guessesContainer.innerHTML = '';
            return;
        }

        const guessesHTML = this.guesses.map(guess => `
            <div class="guess-item ${guess.correct ? 'victory' : ''}">
                <div class="guess-info">
                    <div class="guess-title">${this.escapeHtml(guess.album.title)}</div>
                    <div class="guess-artist">${this.escapeHtml(guess.album.artists ? guess.album.artists.join(', ') : 'Artiste inconnu')}</div>
                </div>
                <div class="guess-clues ${guess.correct ? 'victory' : ''}">
                    ${guess.correct ? 
                        '<i class="bi bi-trophy-fill"></i> Victoire !' : 
                        `<i class="bi bi-lightbulb"></i> ${guess.cluesRevealed.length} indice(s)`
                    }
                </div>
            </div>
        `).join('');

        this.elements.guessesContainer.innerHTML = guessesHTML;
    }

    showVictoryModal() {
        // Display mystery album
        const mysteryAlbumHTML = `
            <div class="mystery-album-title">${this.escapeHtml(this.mysteryAlbum.title)}</div>
            <div class="mystery-album-artist">${this.escapeHtml(this.mysteryAlbum.artists ? this.mysteryAlbum.artists.join(', ') : 'Artiste inconnu')}</div>
            <div class="mystery-album-meta">
                ${this.mysteryAlbum.release_year ? `<span>📅 ${this.mysteryAlbum.release_year}</span>` : ''}
                ${this.mysteryAlbum.genres && this.mysteryAlbum.genres.length > 0 ? `<span>🎵 ${this.mysteryAlbum.genres[0]}</span>` : ''}
                ${this.mysteryAlbum.countries && this.mysteryAlbum.countries.length > 0 ? `<span>🌍 ${this.mysteryAlbum.countries[0]}</span>` : ''}
            </div>
        `;
        this.elements.mysteryAlbumDisplay.innerHTML = mysteryAlbumHTML;

        // Update stats
        this.elements.finalGuesses.textContent = this.guessCount;
        this.elements.finalClues.textContent = this.discoveredClues.size;

        this.elements.victoryModal.classList.add('show');
    }

    hideVictoryModal() {
        this.elements.victoryModal.classList.remove('show');
    }

    showInstructionsModal() {
        this.elements.instructionsModal.classList.add('show');
    }

    hideInstructionsModal() {
        this.elements.instructionsModal.classList.remove('show');
    }

    shareResult() {
        const albumInfo = `"${this.mysteryAlbum.title}" par ${this.mysteryAlbum.artists ? this.mysteryAlbum.artists.join(', ') : 'Artiste inconnu'}`;
        const stats = `${this.guessCount} essai(s) • ${this.discoveredClues.size} indice(s) découvert(s)`;
        
        const shareText = `🎵 J'ai découvert le disque mystère du jour !\n\n${albumInfo}\n${stats}\n\n🎵 1jour1skeud 🎵`;

        if (navigator.share) {
            navigator.share({
                title: '1jour1skeud',
                text: shareText
            });
        } else {
            // Fallback: copy to clipboard
            navigator.clipboard.writeText(shareText).then(() => {
                alert('Résultat copié dans le presse-papiers !');
            }).catch(() => {
                alert('Impossible de copier le résultat. Vous pouvez le partager manuellement :\n\n' + shareText);
            });
        }
    }

    showLoading(show) {
        if (show) {
            this.elements.loading.classList.add('show');
        } else {
            this.elements.loading.classList.remove('show');
        }
    }

    showError(message) {
        alert(message); // Simple error handling - could be improved with custom modal
    }

    escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
}

// Initialize the game when the page loads
document.addEventListener('DOMContentLoaded', () => {
    new Game1Jour1Skeud();
});