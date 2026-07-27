import test from 'node:test';
import assert from 'node:assert/strict';
import worker from './index.mjs';

const env = {
  ASSETS: {
    fetch: async () => new Response('app'),
  },
};

test('PR 129 keeps one canonical all-access preview URL', async () => {
  const response = await worker.fetch(
    new Request('https://phoenix-journeys-pr-129.example.workers.dev/'),
    env,
  );

  assert.equal(response.status, 308);
  assert.equal(
    response.headers.get('location'),
    'https://phoenix-journeys-pr-129.example.workers.dev/?unlock=all&prototype=journeys&v=211086ef',
  );
});

test('PR 129 canonical preview continues to the app', async () => {
  const response = await worker.fetch(
    new Request(
      'https://phoenix-journeys-pr-129.example.workers.dev/?unlock=all&prototype=journeys&v=211086ef',
    ),
    env,
  );

  assert.equal(response.status, 200);
  assert.equal(await response.text(), 'app');
});

test('canonical redirect never affects APIs or other deployments', async () => {
  const health = await worker.fetch(
    new Request(
      'https://phoenix-journeys-pr-129.example.workers.dev/api/health',
    ),
    env,
  );
  const production = await worker.fetch(
    new Request('https://phoenix-journeys.example.workers.dev/'),
    env,
  );

  assert.equal(health.status, 200);
  assert.equal(production.status, 200);
});
