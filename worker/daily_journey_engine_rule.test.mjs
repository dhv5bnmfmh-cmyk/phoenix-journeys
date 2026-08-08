import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const journey = fs.readFileSync(
  path.join(root, 'app/lib/screens/journey_screen.dart'),
  'utf8',
);
const catalog = fs.readFileSync(
  path.join(root, 'app/lib/data/daily_journey_catalog.dart'),
  'utf8',
);
const adaptive = fs.readFileSync(
  path.join(root, 'app/lib/data/adaptive_journey_level_runtime.dart'),
  'utf8',
);
const appState = fs.readFileSync(
  path.join(root, 'app/lib/state/app_state.dart'),
  'utf8',
);

test('daily catalog keeps a real multi-destination Journey registry', () => {
  assert.match(catalog, /List<DailyJourneyExperience> get dailyJourneyCatalog/);
  assert.match(catalog, /summer_palace/);
  assert.match(catalog, /forbidden_city/);
  assert.match(catalog, /shanghai_bund/);
  assert.match(catalog, /requireDailyJourneyExperience/);
});

test('adaptive resolver accepts every Journey instead of one hard-coded lesson', () => {
  assert.match(adaptive, /resolveAdaptiveJourneyLevel/);
  assert.match(adaptive, /DailyJourneyExperience journey/);
  assert.match(adaptive, /resolveJourneyLevel\(journey, difficulty\)/);
  assert.match(adaptive, /journey\.storyParagraphs/);
  assert.match(adaptive, /journey\.words/);
  assert.match(adaptive, /journey\.discoveries/);
});

test('one stable Journey screen renders every city and supported level', () => {
  assert.match(journey, /final String\? journeyId/);
  assert.match(journey, /DailyJourneyExperience _experience/);
  assert.match(journey, /JourneyLevelContent get _levelContent/);
  assert.match(journey, /final levelContent = _levelContent/);
  assert.match(journey, /(?:_levelContent|levelContent)\.storyAnnotations/);
  assert.match(journey, /(?:_levelContent|levelContent)\.words/);
  assert.match(journey, /(?:_levelContent|levelContent)\.discoveries/);
  assert.match(journey, /AnimatedCityJourneyStamp/);
});

test('Journey progress remains compatible with the shared six-stage runtime', () => {
  assert.match(appState, /static const int journeyLastStep = 5/);
  assert.match(appState, /beijingJourneyStep/);
  assert.match(appState, /journeyCompleted/);
  assert.match(appState, /completeJourney/);
});
