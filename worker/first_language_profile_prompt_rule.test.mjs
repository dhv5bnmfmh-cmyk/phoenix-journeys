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

test('the first journey level prompt is persistent and appears only without a profile', () => {
  assert.match(store, /phoenix\.languageProficiencyPromptSeen/);
  assert.match(store, /Future<bool> shouldShowJourneyPrompt\(\)/);
  assert.match(store, /return !hasProfile && !promptSeen/);
  assert.match(store, /Future<void> markJourneyPromptSeen\(\)/);
  assert.match(store, /setBool\(_promptSeenKey, true\)/);
});

test('saving a profile suppresses the first-use prompt', () => {
  assert.match(
    store,
    /setString\(_profileKey, profile\.storageValue\)[\s\S]*setBool\(_promptSeenKey, true\)/,
  );
  assert.match(
    store,
    /remove\(_profileKey\)[\s\S]*remove\(_promptSeenKey\)/,
  );
});

test('journey guidance is non-blocking and opens the existing profile picker', () => {
  assert.match(journeyScreen, /_showFirstLanguageProfilePrompt/);
  assert.match(journeyScreen, /WidgetsBinding\.instance\.addPostFrameCallback/);
  assert.match(journeyScreen, /ScaffoldMessenger\.of\(context\)\.showSnackBar/);
  assert.match(journeyScreen, /SnackBarAction/);
  assert.match(journeyScreen, /选择中文等级后，故事、发现和重点单词会更适合你。/);
  assert.match(journeyScreen, /_showLanguageProfilePicker\(showIntro: true\)/);
});
