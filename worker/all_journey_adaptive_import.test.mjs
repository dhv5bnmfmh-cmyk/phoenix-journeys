import assert from 'node:assert/strict';
import test from 'node:test';
import { readFileSync } from 'node:fs';

const runtime = readFileSync(
  'app/lib/data/adaptive_journey_level_runtime.dart',
  'utf8',
);
const catalog = readFileSync(
  'app/lib/data/all_journey_language_level_catalog.dart',
  'utf8',
);

test('all journeys use the adaptive catalog instead of fixed content', () => {
  assert.match(runtime, /buildAdaptiveLevelForJourney/);
  assert.doesNotMatch(
    runtime,
    /experience\.id != 'beijing-summer-palace'[\s\S]{0,100}JourneyLevelContent\.fromExperience/,
  );
  assert.match(catalog, /PhoenixReadingBand\.beginner/);
  assert.match(catalog, /PhoenixReadingBand\.mastery/);
  assert.match(catalog, /_discoveriesForProfile/);
  assert.match(catalog, /selectVocabulary/);
});

test('adaptive catalog keeps one-or-two story paragraphs and level-specific tasks', () => {
  assert.match(catalog, /_partitionPackets/);
  assert.match(catalog, /paragraphCount/);
  assert.match(catalog, /_wonderQuestion/);
  assert.match(catalog, /_expressQuestion/);
  assert.match(catalog, /请使用“既……也……”或“不是……而是……”/);
});
