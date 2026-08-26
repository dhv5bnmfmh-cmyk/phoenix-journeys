import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const workflow = readFileSync('.github/workflows/preview-cloudflare.yml', 'utf8');

function stepBlock(name, nextName) {
  const start = workflow.indexOf(`      - name: ${name}`);
  const end = workflow.indexOf(`      - name: ${nextName}`, start + 1);
  assert.ok(start >= 0, `missing step: ${name}`);
  assert.ok(end > start, `missing next step after: ${name}`);
  return workflow.slice(start, end);
}

test('producer resolver does not read its own GitHub step outputs', () => {
  const resolve = stepBlock(
    'Resolve successful exact Flutter CI producer',
    'Verify resolved exact producer identity',
  );
  assert.match(resolve, /id: producer/);
  assert.doesNotMatch(resolve, /steps\.producer\.outputs\./);
});

test('resolved producer identity is checked only after resolver step completes', () => {
  const resolveIndex = workflow.indexOf('name: Resolve successful exact Flutter CI producer');
  const verifyIndex = workflow.indexOf('name: Verify resolved exact producer identity');
  const downloadIndex = workflow.indexOf('name: Download exact tested web artifact');
  assert.ok(resolveIndex >= 0);
  assert.ok(verifyIndex > resolveIndex);
  assert.ok(downloadIndex > verifyIndex);

  const verify = stepBlock(
    'Verify resolved exact producer identity',
    'Download exact tested web artifact',
  );
  assert.match(verify, /steps\.producer\.outputs\.producer_sha/);
  assert.match(verify, /steps\.producer\.outputs\.run_id/);
  assert.match(verify, /PREVIEW_RELEASE/);
});
