import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const workflow = readFileSync('.github/workflows/preview-cloudflare.yml', 'utf8');
const template = readFileSync('.github/pull_request_template.md', 'utf8');
const processDoc = readFileSync('docs/development-workflow.md', 'utf8');
const stableBaseline = readFileSync('docs/PHOENIX_STABLE_BASELINE_STANDARD.md', 'utf8');

test('every Phoenix pull request gets an isolated Worker name and URL', () => {
  assert.match(workflow, /PREVIEW_WORKER: phoenix-journeys-pr-\$\{\{ github\.event\.pull_request\.number \}\}/);
  assert.match(workflow, /PREVIEW_URL: https:\/\/phoenix-journeys-pr-\$\{\{ github\.event\.pull_request\.number \}\}\.7hn5tyrjgh\.workers\.dev/);
  assert.match(workflow, /--name "\$PREVIEW_WORKER"/);
});

test('preview uses the exact feature head rather than the pull request merge ref', () => {
  assert.match(workflow, /PREVIEW_RELEASE: \$\{\{ github\.event\.pull_request\.head\.sha \}\}/);
  assert.match(workflow, /ref: \$\{\{ env\.PREVIEW_RELEASE \}\}/);
  assert.match(workflow, /test "\$\(git rev-parse HEAD\)" = "\$PREVIEW_RELEASE"/);
  assert.match(workflow, /PHOENIX_RELEASE:\$PREVIEW_RELEASE/);
});

test('preview exact health identity is verified before status and link publication', () => {
  const verifyIndex = workflow.indexOf('name: Verify exact preview release identity');
  const statusIndex = workflow.indexOf('name: Publish preview status');
  const commentIndex = workflow.indexOf('name: Add or update preview comment');
  assert.ok(verifyIndex >= 0);
  assert.ok(statusIndex > verifyIndex);
  assert.ok(commentIndex > statusIndex);
  assert.match(workflow, /validateHealthIdentity/);
  assert.match(workflow, /health_url="\$\{PREVIEW_URL\}\/api\/health\?commit=\$\{PREVIEW_RELEASE\}"/);
  assert.match(workflow, /statuses\/\$\{PREVIEW_RELEASE\}/);
  assert.match(workflow, /v=\$\{release\}/);
});

test('preview workers are removed when pull requests close', () => {
  assert.match(workflow, /github\.event\.action == 'closed'/);
  assert.match(workflow, /wrangler@4 delete --name "\$PREVIEW_WORKER"/);
});

test('fork pull requests cannot access deployment secrets', () => {
  assert.match(workflow, /github\.event\.pull_request\.head\.repo\.full_name == github\.repository/g);
});

test('candidate evidence protects stable behavior without duplicating the old merge checklist', () => {
  assert.match(template, /Desktop required levels\/stages/);
  assert.match(template, /ReadingAnnotation browser verification/);
  assert.match(template, /Mobile WebKit \/ target phone bare startup/);
  assert.match(template, /pageErrors \/ failedRequests blocking defects/);
  assert.match(template, /Explicit Merge authorization: `YES \/ NO`/);
  assert.match(template, /No merge without explicit authorization/);
});

test('development process forbids direct main development', () => {
  assert.match(processDoc, /禁止直接在 `main` 开发或试验/);
  assert.match(processDoc, /用户明确确认后，才允许合并到 `main`/);
  assert.match(processDoc, /历史最低产品质量基线 PR：`#137`/);
  assert.match(processDoc, /历史最低产品质量基线 Commit：`5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`/);
  assert.match(processDoc, /基线身份唯一权威来源：`docs\/PHOENIX_STABLE_BASELINE_STANDARD\.md`/);
  assert.match(stableBaseline, /\*\*Historical minimum-quality baseline PR:\*\* `#137`/);
  assert.match(stableBaseline, /\*\*Historical minimum-quality baseline Commit:\*\* `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`/);
});
