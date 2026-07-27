import test from 'node:test';
import assert from 'node:assert/strict';

import { PhoenixBackgroundAgent } from './agents/phoenix_background_agent.mjs';

const publishedBeijingIds = [
  'beijing-forbidden-city-01-twilight-courtyard',
  'beijing-forbidden-city-02-moonlit-palace',
  'beijing-forbidden-city-03-golden-gate',
  'beijing-forbidden-city-04-winter-snow',
  'beijing-forbidden-city-05-after-rain',
  'beijing-forbidden-city-06-autumn-maples',
  'beijing-forbidden-city-07-clear-morning',
  'beijing-forbidden-city-08-sunlit-corridor',
  'beijing-forbidden-city-09-misty-courtyard',
  'beijing-forbidden-city-10-sunset-panorama',
];

test('Background Agent recognizes the reviewed Beijing library as ten filled slots', () => {
  const jobs = new PhoenixBackgroundAgent().planOfflineLibrary({
    journeyIds: ['beijing-forbidden-city'],
    existingIds: publishedBeijingIds,
  });

  assert.deepEqual(jobs, []);
});

test('Background Agent schedules only the genuinely missing Beijing slot', () => {
  const jobs = new PhoenixBackgroundAgent().planOfflineLibrary({
    journeyIds: ['beijing-forbidden-city'],
    existingIds: publishedBeijingIds.slice(0, 9),
  });

  assert.equal(jobs.length, 1);
  assert.equal(
    jobs[0].id,
    'beijing-forbidden-city-10-quiet-night-panorama',
  );
});
