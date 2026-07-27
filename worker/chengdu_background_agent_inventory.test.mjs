import assert from 'node:assert/strict';
import test from 'node:test';
import { PhoenixBackgroundAgent } from './agents/phoenix_background_agent.mjs';

const ids = [
  '01-sunrise-arrival', '02-morning-street', '03-misty-detail',
  '04-bright-panorama', '05-after-rain', '06-seasonal-landscape',
  '07-golden-hour', '08-blue-hour', '09-lantern-night',
  '10-quiet-night-panorama',
].map((slot) => `chengdu-kuanzhai-alley-${slot}`);

test('Background Agent recognizes the reviewed Chengdu library', () => {
  assert.deepEqual(new PhoenixBackgroundAgent().planOfflineLibrary({
    journeyIds: ['chengdu-kuanzhai-alley'], existingIds: ids,
  }), []);
});

test('Background Agent schedules only a missing Chengdu slot', () => {
  const jobs = new PhoenixBackgroundAgent().planOfflineLibrary({
    journeyIds: ['chengdu-kuanzhai-alley'],
    existingIds: ids.filter((id) => id !== 'chengdu-kuanzhai-alley-08-blue-hour'),
  });
  assert.deepEqual(jobs.map((job) => job.id), [
    'chengdu-kuanzhai-alley-08-blue-hour',
  ]);
});
