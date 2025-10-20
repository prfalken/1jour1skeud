class AlbumGuessrGame {
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
            this.showError('Failed to connect to the search index. Please refresh the page.');
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

        // Show refresh-based info
        this.elements.gameDate.textContent = 'New mystery on each refresh';
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
                this.showError('Error while loading the game. Please refresh the page.');
                this.showLoading(false);
            });
    }

    async selectDailyAlbum() {
        // Pick a random line from mistery-albums.jsonl and use its id as Algolia objectID
        try {
            const response = await fetch('mistery-albums.jsonl', { cache: 'no-store' });
            if (!response.ok) throw new Error('Failed to load mistery-albums.jsonl');

            const text = await response.text();
            const lines = text
                .split('\n')
                .map(l => l.trim())
                .filter(l => l.length > 0);

            if (lines.length === 0) throw new Error('Empty mistery-albums.jsonl');

            const randomIndex = Math.floor(Math.random() * lines.length);
            const randomEntry = JSON.parse(lines[randomIndex]);
            const releaseGroupId = randomEntry.id; // Use as Algolia objectID

            if (!this.algoliaIndex) throw new Error('Algolia index not initialized');

            const attrs = [
                'objectID', 'title', 'artists', 'genres', 'release_year', 'countries', 'tags',
                'musicians', 'musicians_details', 'rating_value', 'rating_count', 'rating',
                'cover_art_url_250', 'cover_art_url_500', 'cover_art_url_1200', 'cover_art_url'
            ];

            this.mysteryAlbum = await this.algoliaIndex.getObject(releaseGroupId, { attributesToRetrieve: attrs });
            console.log('Loaded mystery album from mistery-albums.jsonl');
            console.log(this.mysteryAlbum);
            return this.mysteryAlbum;
        } catch (error) {
            console.error('Failed to select random album:', error);
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
                hitsPerPage: 20,
                attributesToRetrieve: [
                    'objectID', 'title', 'artists', 'genres', 'release_year', 'countries', 'musicians',
                    'cover_art_url_250', 'cover_art_url_500', 'cover_art_url_1200', 'cover_art_url'
                ]
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

        const resultsHTML = this.searchResults.map((album, index) => {
            const coverUrl = this.getCoverUrl(album);
            return `
            <div class="search-result ${index === 0 ? 'selected' : ''}" data-album-id="${album.objectID}" data-index="${index}">
                ${coverUrl ? `<img class=\"search-result-thumb\" src=\"${coverUrl}\" alt=\"Cover\">` : `<div class=\"search-result-thumb placeholder\"></div>`}
                <div class="search-result-text">
                    <div class="search-result-title">${this.escapeHtml(album.title)}</div>
                    <div class="search-result-artist">${this.escapeHtml(album.artists ? album.artists.join(', ') : 'Unknown artist')}</div>
                    <div class="search-result-meta">
                        ${album.release_year ? `<span>${album.release_year}</span>` : ''}
                        ${album.genres && album.genres.length > 0 ? `<span>${album.genres[0]}</span>` : ''}
                        ${album.countries && album.countries.length > 0 ? `<span>${album.countries[0]}</span>` : ''}
                    </div>
                </div>
            </div>`;
        }).join('');

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
            yearHint = `between ${latestBefore} and ${earliestAfter}`;
        } else if (yearsBefore.length > 0) {
            // We only have years before - show "after X"
            const latestBefore = Math.max(...yearsBefore);
            yearHint = `after ${latestBefore}`;
        } else if (yearsAfter.length > 0) {
            // We only have years after - show "before X"
            const earliestAfter = Math.min(...yearsAfter);
            yearHint = `before ${earliestAfter}`;
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
                    <p>Make a first guess to reveal clues...</p>
                </div>
            `;
            return;
        }

        const cluesHTML = Array.from(this.discoveredClues.entries()).map(([category, values]) => {
            const categoryConfig = GAME_CONFIG.clueCategories.find(c => c.key === category);
            if (!categoryConfig) return '';

            let valuesHTML = '';
            if (category === 'musicians') {
                const nameToDetail = this.buildMusicianDetailMap();
                valuesHTML = Array.from(values).map(name => {
                    const safeName = this.escapeHtml(name);
                    // Render musician name only (no avatar), preserving data-name for potential future use
                    return `
                        <span class="clue-value clue-musician" data-name="${safeName}">
                            <span class="clue-musician-name">${safeName}</span>
                        </span>
                    `;
                }).join('');
            } else {
                valuesHTML = Array.from(values).map(value => 
                    `<span class="clue-value">${this.escapeHtml(value)}</span>`
                ).join('');
            }

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

		const guessesHTML = this.guesses.slice().reverse().map(guess => {
            const coverUrl = this.getCoverUrl(guess.album);
            // Build per-attribute chips: green for common values, red for guessed-only values
            let detailedCluesHTML = '';
            if (!guess.correct) {
                const categories = GAME_CONFIG.clueCategories.map(c => c.key);
                const revealedByCategory = new Map();
                (guess.cluesRevealed || []).forEach(c => revealedByCategory.set(c.category, new Set(c.values)));

                const sections = [];
                categories.forEach(catKey => {
                    if (catKey === 'release_year') {
                        // Year special-case: show chip relative to mystery year when available
                        const gy = guess.album.release_year;
                        const my = this.mysteryAlbum && this.mysteryAlbum.release_year;
                        if (!gy) return;
                        let cls = 'guess-chip-miss';
                        let label = String(gy);
                        if (my) {
                            const gyi = parseInt(gy);
                            const myi = parseInt(my);
                            if (!isNaN(gyi) && !isNaN(myi)) {
                                if (gyi === myi) {
                                    cls = 'guess-chip-hit';
                                } else if (gyi < myi) {
                                    cls = 'guess-chip-miss';
                                    label = `${gyi} (before)`;
                                } else if (gyi > myi) {
                                    cls = 'guess-chip-miss';
                                    label = `${gyi} (after)`;
                                }
                            }
                        }
                        const catConf = GAME_CONFIG.clueCategories.find(c => c.key === 'release_year');
                        sections.push(`
                            <div class="guess-attr">
                                <div class="guess-attr-title"><i class="bi ${catConf.icon}"></i> ${catConf.label}</div>
                                <div class="guess-attr-values">
                                    <span class="guess-chip ${cls}">${this.escapeHtml(label)}</span>
                                </div>
                            </div>
                        `);
                        return;
                    }

                    const guessVal = guess.album[catKey];
                    const mysteryVal = this.mysteryAlbum ? this.mysteryAlbum[catKey] : undefined;
                    if (!guessVal) return;
                    const catConf = GAME_CONFIG.clueCategories.find(c => c.key === catKey);
                    const revealed = revealedByCategory.get(catKey) || new Set();

                    const guessValues = Array.isArray(guessVal) ? guessVal : [guessVal];
                    const valuesHTML = guessValues.map(v => {
                        const vStr = String(v);
                        const isCommon = revealed.has(vStr);
                        const cls = isCommon ? 'guess-chip-hit' : 'guess-chip-miss';
                        return `<span class="guess-chip ${cls}">${this.escapeHtml(vStr)}</span>`;
                    }).join('');

                    // Only render section if there is at least one value
                    if (valuesHTML) {
                        sections.push(`
                            <div class="guess-attr">
                                <div class="guess-attr-title"><i class="bi ${catConf.icon}"></i> ${catConf.label}</div>
                                <div class="guess-attr-values">${valuesHTML}</div>
                            </div>
                        `);
                    }
                });

                if (sections.length > 0) {
                    detailedCluesHTML = `<div class="guess-details">${sections.join('')}</div>`;
                }
            }

            return `
            <div class="guess-item ${guess.correct ? 'victory' : ''}">
                ${coverUrl ? `<img class=\"guess-cover\" src=\"${coverUrl}\" alt=\"Cover\">` : `<div class=\"guess-cover placeholder\"></div>`}
                <div class="guess-info">
                    <div class="guess-title">${this.escapeHtml(guess.album.title)}</div>
                    <div class="guess-artist">${this.escapeHtml(guess.album.artists ? guess.album.artists.join(', ') : 'Unknown artist')}</div>
                    ${!guess.correct ? detailedCluesHTML : ''}
                </div>
                <div class="guess-clues ${guess.correct ? 'victory' : ''}">
                    ${guess.correct ? 
                        '<i class="bi bi-trophy-fill"></i> Victory!' : 
                        `<i class=\"bi bi-lightbulb\"></i> ${guess.cluesRevealed.length} clue(s)`
                    }
                </div>
            </div>`;
        }).join('');

        this.elements.guessesContainer.innerHTML = guessesHTML;
    }

    showVictoryModal() {
        // Display mystery album
        const mysteryAlbumHTML = `
            <div class="mystery-album-title">${this.escapeHtml(this.mysteryAlbum.title)}</div>
            <div class="mystery-album-artist">${this.escapeHtml(this.mysteryAlbum.artists ? this.mysteryAlbum.artists.join(', ') : 'Unknown artist')}</div>
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
        const albumInfo = `"${this.mysteryAlbum.title}" by ${this.mysteryAlbum.artists ? this.mysteryAlbum.artists.join(', ') : 'Unknown artist'}`;
        const stats = `${this.guessCount} guess(es) • ${this.discoveredClues.size} clue(s) discovered`;

        const shareText = `🎵 I found the mystery album!\n\n${albumInfo}\n${stats}\n\n🎵 AlbumGuessr 🎵`;

        if (navigator.share) {
            navigator.share({
                title: 'AlbumGuessr',
                text: shareText
            });
        } else {
            // Fallback: copy to clipboard
            navigator.clipboard.writeText(shareText).then(() => {
                alert('Result copied to clipboard!');
            }).catch(() => {
                alert('Unable to copy the result. You can share it manually:\n\n' + shareText);
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

    getCoverUrl(album) {
        if (!album) return null;
        return album.cover_art_url_250 || album.cover_art_url_500 || album.cover_art_url_1200 || album.cover_art_url || null;
    }

    buildMusicianDetailMap() {
        const map = new Map();
        const details = (this.mysteryAlbum && this.mysteryAlbum.musicians_details) ? this.mysteryAlbum.musicians_details : [];
        if (Array.isArray(details)) {
            details.forEach(d => {
                if (d && d.name) {
                    map.set(d.name, d);
                }
            });
        }
        return map;
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
    new AlbumGuessrGame();
});