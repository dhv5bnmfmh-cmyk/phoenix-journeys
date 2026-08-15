import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const workflow = fs.readFileSync(
  new URL('../docs/development-workflow.md', import.meta.url),
  'utf8',
);
const stableBaseline = fs.readFileSync(
  new URL('../docs/PHOENIX_STABLE_BASELINE_STANDARD.md', import.meta.url),
  'utf8',
);

const EXPECTED_STABLE_PR = '137';
const EXPECTED_STABLE_COMMIT =
  '5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977';

function extractRequired(text, pattern, label) {
  const match = text.match(pattern);
  assert.ok(match, `${label} must be recorded`);
  return match[1];
}

test('historical quality floor is recorded while current remote main remains development authority', () => {
  const workflowPr = extractRequired(
    workflow,
    /历史最低产品质量基线 PR：`#(\d+)`/,
    'development workflow stable PR',
  );
  const workflowCommit = extractRequired(
    workflow,
    /历史最低产品质量基线 Commit：`([0-9a-f]{40})`/,
    'development workflow stable Commit',
  );
  const standardPr = extractRequired(
    stableBaseline,
    /\*\*Historical minimum-quality baseline PR:\*\* `#(\d+)`/,
    'Stable Baseline Standard stable PR',
  );
  const standardCommit = extractRequired(
    stableBaseline,
    /\*\*Historical minimum-quality baseline Commit:\*\* `([0-9a-f]{40})`/,
    'Stable Baseline Standard stable Commit',
  );

  assert.equal(standardPr, EXPECTED_STABLE_PR);
  assert.equal(standardCommit, EXPECTED_STABLE_COMMIT);
  assert.equal(workflowPr, standardPr);
  assert.equal(workflowCommit, standardCommit);

  assert.match(stableBaseline, /NEW RESULT >= CURRENT STABLE BASELINE/);
  assert.match(stableBaseline, /development source authority[^\n]*exact current remote `main`/);
  assert.match(
    stableBaseline,
    /The stable baseline does not automatically move to the newest PR/,
  );
  assert.match(
    stableBaseline,
    /The Founder explicitly approves the candidate and its exact Commit/,
  );
  assert.match(stableBaseline, /The approved PR is merged into `main`/);
  assert.match(
    stableBaseline,
    /This file, `docs\/PHOENIX_STABLE_BASELINE_STANDARD\.md`, is the single normative authority/,
  );

  assert.match(
    workflow,
    /基线身份唯一权威来源：`docs\/PHOENIX_STABLE_BASELINE_STANDARD\.md`/,
  );
  assert.match(workflow, /PR #132 是历史已合并版本，不是当前开发基线/);
  assert.match(
    workflow,
    /关闭的 PR #138–#141[^\n]*不得作为开发基线/,
  );
  assert.doesNotMatch(workflow, /当前稳定版本来源：PR #132/);
  assert.doesNotMatch(workflow, /d6d2a435b123839153f756d28df9c8ba369c2aeb/);
  assert.doesNotMatch(stableBaseline, /\*\*Stable PR:\*\* `#132`/);
});

test('all future work must use current remote main or the sole authorized active line', () => {
  assert.match(
    workflow,
    /必须从 preflight 重新读取的精确 remote `main` 创建/,
  );
  assert.match(
    workflow,
    /开发前必须同时记录 current remote `main` SHA 与 `docs\/PHOENIX_STABLE_BASELINE_STANDARD\.md` 中的历史最低质量基线/,
  );
  assert.match(
    workflow,
    /禁止从历史 PR、旧体验分支、旧提交或关闭分支继续开发/,
  );
  assert.match(workflow, /版本确认合并后，必须关闭其他所有开发 PR/);
  assert.match(workflow, /删除它们的 Cloudflare Preview Worker/);
  assert.match(workflow, /NEW RESULT >= CURRENT STABLE BASELINE/);
  assert.doesNotMatch(workflow, /必须从当时最新的\s+`origin\/main`/);
});
