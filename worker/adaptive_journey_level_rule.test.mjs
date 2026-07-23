import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync(
  'app/lib/data/journey_level_catalog.dart',
  'utf8',
);
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

// Guards the first adaptive destination rollout before wider catalog expansion.
test('Summer Palace provides three persistent journey levels', () => {
  assert.match(catalog, /enum JourneyDifficulty \{ easy, standard, challenge \}/);
  assert.match(catalog, /summerPalaceEasyLevel/);
  assert.match(catalog, /const summerPalaceChallengeLevel = JourneyLevelContent/);
  assert.match(state, /JourneyDifficulty journeyDifficulty/);
  assert.match(state, /Future<void> setJourneyDifficulty/);
  assert.match(state, /_key\('difficulty'\)/);
});

test('journey UI lets explorers choose and change level', () => {
  assert.match(screen, /journey-difficulty-selector/);
  assert.match(screen, /选择适合你的旅程/);
  assert.match(screen, /supportedJourneyDifficulties/);
  assert.match(screen, /resolveJourneyLevel/);
  assert.match(screen, /currentLevel.*journeyDifficulty\.label/s);
});
