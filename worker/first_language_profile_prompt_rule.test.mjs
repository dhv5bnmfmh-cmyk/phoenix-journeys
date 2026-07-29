import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const store = readFileSync(
  'app/lib/services/language_level_preference_store.dart',
  'utf8',
);
const journeyScreen = readFileSync(
  'app/lib/screens/journey_screen.dart',
  'utf8',
);
const main = readFileSync('app/lib/main.dart', 'utf8');

test('Phoenix level initializes before the app renders', () => {
  assert.match(main, /Future<void> main\(\) async/);
  assert.match(main, /initializePhoenixLevel\(\)/);
  assert.match(store, /phoenix\.level/);
  assert.match(store, /PhoenixLevelController\.defaultLevel/);
});

test('legacy exam settings migrate without showing a blocking picker', () => {
  assert.match(store, /phoenixLevelFromStorage/);
  assert.match(store, /setString\([\s\S]*profileForPhoenixLevel/);
  assert.match(store, /Future<bool> shouldShowJourneyPrompt\(\) async => false/);
  assert.doesNotMatch(journeyScreen, /_showFirstLanguageProfilePrompt/);
  assert.doesNotMatch(journeyScreen, /_showLanguageProfilePicker/);
  assert.doesNotMatch(journeyScreen, /SnackBarAction/);
});

test('the journey screen loads one unified profile and listens for changes', () => {
  assert.match(journeyScreen, /_languageLevelStore\.load\(\)/);
  assert.match(journeyScreen, /_phoenixLevelController\.addListener/);
  assert.match(journeyScreen, /_applyPhoenixLevelChange/);
});
