import assert from 'node:assert/strict';
import test from 'node:test';

import { PhoenixBackgroundAgent } from './agents/phoenix_background_agent.mjs';

const xianIds = [
  '01-sunrise-arrival',
  '02-morning-street',
  '03-misty-detail',
  '04-bright-panorama',
  '05-after-rain',
  '06-seasonal-landscape',
  '07-golden-hour',
  '08-blue-hour',
  '09-lantern-night',
  '10-quiet-night-panorama',
].map((slot) => `xian-city-wall-${slot}`);

test('Background Agent recognizes the reviewed Xian library as ten filled slots', () => {
  const jobs = new PhoenixBackgroundAgent().planOfflineLibrary({
    journeyIds: ['xian-city-wall'],
    existingIds: xianIds,
  });

  assert.deepEqual(jobs, []);
});

test('Background Agent schedules only a genuinely missing Xian slot', () => {
  const jobs = new PhoenixBackgroundAgent().planOfflineLibrary({
    journeyIds: ['xian-city-wall'],
    existingIds: xianIds.filter(
      (id) => id !== 'xian-city-wall-09-lantern-night',
    ),
  });

  assert.deepEqual(
    jobs.map((job) => job.id),
    ['xian-city-wall-09-lantern-night'],
  );
});
