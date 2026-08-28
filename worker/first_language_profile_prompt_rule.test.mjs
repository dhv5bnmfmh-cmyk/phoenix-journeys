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
const appState = readFileSync('app/lib/state/app_state.dart', 'utf8');
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

test('AppState initializes the configured level and Journey snapshots it once', () => {
  assert.match(appState, /initializePhoenixLevel\(\)/);
  assert.match(journeyScreen, /snapshotJourneySessionProfile/);
  assert.match(journeyScreen, /late final ChineseProficiencyProfile _sessionLanguageProfile/);
  assert.doesNotMatch(journeyScreen, /_phoenixLevelController\.addListener/);
  assert.doesNotMatch(journeyScreen, /_applyPhoenixLevelChange/);
});
