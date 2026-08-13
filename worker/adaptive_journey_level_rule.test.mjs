import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync(
  'app/lib/data/journey_level_catalog.dart',
  'utf8',
);
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const controller = readFileSync(
  'app/lib/services/phoenix_level_controller.dart',
  'utf8',
);

// Keeps the legacy difficulty catalog as a safe fallback while Phoenix level
// initialization is loading.
test('Summer Palace keeps persistent fallback journey levels', () => {
  assert.match(catalog, /enum JourneyDifficulty \{ easy, standard, challenge \}/);
  assert.match(catalog, /summerPalaceEasyLevel/);
  assert.match(catalog, /final summerPalaceChallengeLevel = JourneyLevelContent/);
  assert.match(state, /JourneyDifficulty journeyDifficulty/);
  assert.match(state, /Future<void> setJourneyDifficulty/);
  assert.match(state, /_key\('difficulty'\)/);
});

test('every journey UI reacts to the unified Phoenix level controller', () => {
  assert.match(screen, /JourneyLevelSelectorButton\(compact: true\)/);
  assert.match(screen, /resolveAdaptiveJourneyLevel/);
  assert.match(screen, /_phoenixLevelController\.profile/);
  assert.match(screen, /_languageProfile = profile/);
  assert.match(screen, /已即时应用到当前故事与挑战/);
  assert.doesNotMatch(screen, /journey-difficulty-selector/);
  assert.doesNotMatch(screen, /_showLanguageProfilePicker/);
});

test('the global controller clamps explorers between level one and ten', () => {
  assert.match(controller, /minimumLevel = 1/);
  assert.match(controller, /maximumLevel = 10/);
  assert.match(controller, /defaultLevel = 5/);
  assert.match(controller, /level\.clamp\(minimumLevel, maximumLevel\)/);
});
