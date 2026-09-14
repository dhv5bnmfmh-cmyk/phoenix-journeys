import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const workflow = readFileSync(
  '.github/workflows/preview-cloudflare.yml',
  'utf8',
);

test('preview status and PR comment use the current head release', () => {
  assert.match(
    workflow,
    /prototype=journeys&v=\$\{PREVIEW_RELEASE\}/,
  );
  assert.match(
    workflow,
    /const release = process\.env\.PHOENIX_PREVIEW_RELEASE;/,
  );
  assert.match(
    workflow,
    /prototype=journeys&v=\$\{release\}/,
  );
});

test('preview links do not pin a historical commit parameter', () => {
  assert.doesNotMatch(
    workflow,
    /prototype=journeys&v=[0-9a-f]{8}(?:[0-9a-f]{32})?/,
  );
});
