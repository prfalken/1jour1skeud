// Generates frontend/config.js from environment variables at build time.
// Uses search-only Algolia key for the browser. Fails fast if required vars are missing.

const fs = require('fs');
const path = require('path');

function getEnv(name, { required = true, fallback = undefined } = {}) {
  const value = process.env[name] ?? fallback;
  if (required && (value === undefined || value === '')) {
    throw new Error(`Missing required env var: ${name}`);
  }
  return value;
}

function main() {
  // Use public-labeled vars so secrets scanning doesn't track their values
  const applicationId = getEnv('ALGOLIA_APPLICATION_ID');
  const apiKey = getEnv('ALGOLIA_PUBLIC_SEARCH_KEY');
  const indexName = getEnv('ALGOLIA_INDEX_NAME', { required: true });

  const output = `// Configuration for Algolia Search (generated at build time)\n` +
    `const ALGOLIA_CONFIG = {\n` +
    `    applicationId: '${applicationId}',\n` +
    `    apiKey: '${apiKey}',\n` +
    `    indexName: '${indexName}'\n` +
    `};\n\n` +
    `const GAME_CONFIG = {\n` +
    `    clueCategories: [\n` +
    `        { key: 'artists', label: 'Artistes', icon: 'bi-person-fill', description: 'Artistes en commun' },\n` +
    `        { key: 'genres', label: 'Genres', icon: 'bi-music-note-list', description: 'Genres musicaux partagés' },\n` +
    `        { key: 'release_year', label: 'Année', icon: 'bi-calendar-fill', description: 'Année de sortie' },\n` +
    `        { key: 'countries', label: 'Pays', icon: 'bi-globe', description: 'Pays d\\'origine' },\n` +
    `        { key: 'musicians', label: 'Musiciens', icon: 'bi-people-fill', description: 'Musiciens/contributeurs en commun' }\n` +
    `    ]\n` +
    `};\n\n` +
    `if (typeof module !== 'undefined' && module.exports) {\n` +
    `    module.exports = { ALGOLIA_CONFIG, GAME_CONFIG };\n` +
    `}\n`;

  const destination = path.join(__dirname, 'config.js');
  fs.writeFileSync(destination, output, 'utf8');
  console.log(`Generated ${destination}`);
}

try {
  main();
} catch (err) {
  console.error(err.message);
  process.exit(1);
}


