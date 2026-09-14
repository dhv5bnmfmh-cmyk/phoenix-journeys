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

test('advanced and mastery discoveries stay in two focused sections', () => {
  assert.match(
    catalog,
    /PhoenixReadingBand\.advanced \|\| PhoenixReadingBand\.mastery =>\s*_groupDiscoveries/,
  );
  assert.match(
    catalog,
    /PhoenixReadingBand\.upperIntermediate \|\|\s*PhoenixReadingBand\.advanced \|\|\s*PhoenixReadingBand\.mastery => 2/,
  );
  assert.match(runtime, /discoveries: source\.discoveries/);
  assert.doesNotMatch(runtime, /_summerPalaceN1DiscoveryCount/);
});

test('advanced prompts use journey-specific analysis lenses', () => {
  assert.match(catalog, /_advancedWonderLens\(experience\)/);
  assert.match(catalog, /_advancedExpressLens\(experience\)/);
  for (const journeyId of [
    'beijing-forbidden-city',
    'beijing-summer-palace',
    'shanghai-bund',
    'xian-city-wall',
    'hangzhou-west-lake',
    'chengdu-kuanzhai-alley',
    'nanjing-qinhuai-river',
    'guangzhou-chen-clan-academy',
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  ]) {
    assert.match(catalog, new RegExp(`'${journeyId}'`));
  }
});
