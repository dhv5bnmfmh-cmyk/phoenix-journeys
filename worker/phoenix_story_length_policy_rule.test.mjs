import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const policy = fs.readFileSync(
  new URL('../app/lib/services/phoenix_story_length_policy.dart', import.meta.url),
  'utf8',
);
const expander = fs.readFileSync(
  new URL('../app/lib/services/journey_story_length_expander.dart', import.meta.url),
  'utf8',
);
const runtime = fs.readFileSync(
  new URL('../app/lib/data/adaptive_journey_level_runtime.dart', import.meta.url),
  'utf8',
);
const auditor = fs.readFileSync(
  new URL('../app/lib/services/journey_content_quality_auditor.dart', import.meta.url),
  'utf8',
);

test('Phoenix keeps the approved story ranges for levels one through ten', () => {
  const ranges = [
    [150, 220],
    [200, 280],
    [260, 340],
    [320, 420],
    [380, 500],
    [450, 580],
    [520, 650],
    [580, 720],
    [650, 800],
    [720, 900],
  ];

  for (const [minimum, maximum] of ranges) {
    assert.match(policy, new RegExp(`minimumCharacters: ${minimum}`));
    assert.match(policy, new RegExp(`maximumCharacters: ${maximum}`));
  }
  assert.equal((policy.match(/enrichmentPacketCount:/g) ?? []).length, 10);
});

test('higher Phoenix levels keep two readable paragraphs', () => {
  assert.match(policy, /3 => const PhoenixStoryLengthTarget\([\s\S]*paragraphCount: 2/);
  assert.match(policy, /_ => const PhoenixStoryLengthTarget\([\s\S]*paragraphCount: 2/);
});

test('every journey passes through the story length expander', () => {
  assert.equal((runtime.match(/expandJourneyStoryToTarget\(/g) ?? []).length, 2);
  assert.match(runtime, /journey_story_length_expander\.dart/);
  assert.match(expander, /preferredCharacters/);
  assert.match(expander, /_categoryPackets/);
  assert.match(expander, /_palaceAndGardenEnrichment/);
  assert.match(expander, /_waterfrontEnrichment/);
  assert.match(expander, /_urbanHeritageEnrichment/);
});

test('special journeys receive genre-specific enrichment instead of urban filler', () => {
  assert.match(expander, /journeyId == 'literary-roaming'/);
  assert.match(expander, /journeyId == 'myth-tracing'/);
  assert.match(expander, /journeyId == 'strange-night-talks'/);
  assert.match(expander, /journeyId == 'folk-secret-land'/);
  assert.match(expander, /_literaryRoamingEnrichment/);
  assert.match(expander, /_mythTracingEnrichment/);
  assert.match(expander, /_strangeNightTalksEnrichment/);
  assert.match(expander, /_folkSecretLandEnrichment/);
});

test('quality gate blocks stories outside the active level range', () => {
  assert.match(auditor, /story-below-level-range/);
  assert.match(auditor, /story-above-level-range/);
  assert.match(auditor, /phoenixStoryLengthTargetFor\(profile\)/);
});
