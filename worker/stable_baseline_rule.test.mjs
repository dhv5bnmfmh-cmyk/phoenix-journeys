import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const workflow = fs.readFileSync(
  new URL('../docs/development-workflow.md', import.meta.url),
  'utf8',
);

test('PR 132 is permanently recorded as the new stable baseline', () => {
  assert.match(workflow, /当前稳定版本来源：PR #132/);
  assert.match(workflow, /d6d2a435b123839153f756d28df9c8ba369c2aeb/);
  assert.match(workflow, /PR #132 合并后的 `main` 是 Phoenix 唯一稳定基线/);
});

test('all future work must branch from the latest stable main', () => {
  assert.match(workflow, /必须从当时最新的\s+`origin\/main`/);
  assert.match(workflow, /禁止从 PR #131 或更早的/);
  assert.match(workflow, /关闭其他\s+所有开发 PR/);
  assert.match(workflow, /删除它们的 Cloudflare Preview Worker/);
});
