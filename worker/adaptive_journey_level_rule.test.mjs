import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync(
  'app/lib/data/journey_level_catalog.dart',
  'utf8',
);
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const me = readFileSync('app/lib/screens/me_screen.dart', 'utf8');
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

test('Me owns configured level while each journey snapshots one session level', () => {
  assert.equal((me.match(/JourneyLevelSelectorButton\(/g) ?? []).length, 1);
  assert.doesNotMatch(me, /_chooseLevel|HSK／TOCFL 能力设置/);
  assert.match(screen, /snapshotJourneySessionProfile/);
  assert.match(screen, /_sessionLanguageProfile/);
  assert.match(screen, /journey-session-level-badge/);
  assert.match(screen, /resolveAdaptiveJourneyLevel/);
  assert.doesNotMatch(screen, /_phoenixLevelController\.addListener/);
  assert.doesNotMatch(screen, /_handlePhoenixLevelChanged/);
  assert.doesNotMatch(screen, /JourneyLevelSelectorButton\(compact: true\)/);
  assert.doesNotMatch(screen, /journey-difficulty-selector/);
  assert.doesNotMatch(screen, /_showLanguageProfilePicker/);
});

test('the global controller clamps explorers between level one and ten', () => {
  assert.match(controller, /minimumLevel = 1/);
  assert.match(controller, /maximumLevel = 10/);
  assert.match(controller, /defaultLevel = 5/);
  assert.match(controller, /level\.clamp\(minimumLevel, maximumLevel\)/);
});
