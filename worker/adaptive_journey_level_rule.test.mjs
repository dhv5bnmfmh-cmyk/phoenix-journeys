import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync(
  'app/lib/data/journey_level_catalog.dart',
  'utf8',
);
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

// Keeps the legacy difficulty catalog available as a safe fallback for users
// who have not selected an HSK or TOCFL profile yet.
test('Summer Palace keeps the persistent fallback journey levels', () => {
  assert.match(catalog, /enum JourneyDifficulty \{ easy, standard, challenge \}/);
  assert.match(catalog, /summerPalaceEasyLevel/);
  assert.match(catalog, /const summerPalaceChallengeLevel = JourneyLevelContent/);
  assert.match(state, /JourneyDifficulty journeyDifficulty/);
  assert.match(state, /Future<void> setJourneyDifficulty/);
  assert.match(state, /_key\('difficulty'\)/);
});

test('every journey UI lets explorers choose and change an exam profile', () => {
  assert.match(screen, /journey-language-level-selector/);
  assert.match(screen, /选择适合你的旅程/);
  assert.match(screen, /_showLanguageProfilePicker/);
  assert.match(screen, /resolveAdaptiveJourneyLevel/);
  assert.match(screen, /_languageProfile\?\.displayLabel/);
  assert.match(screen, /已应用到当前旅程/);
  assert.doesNotMatch(screen, /journey-difficulty-selector/);
  assert.doesNotMatch(screen, /supportedJourneyDifficulties/);
});
