import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const workflow = readFileSync('.github/workflows/preview-cloudflare.yml', 'utf8');
const template = readFileSync('.github/pull_request_template.md', 'utf8');
const processDoc = readFileSync('docs/development-workflow.md', 'utf8');
const stableBaseline = readFileSync('docs/PHOENIX_STABLE_BASELINE_STANDARD.md', 'utf8');

const envLine = (name) =>
  workflow.split('\n').find((line) => line.trimStart().startsWith(`${name}:`)) ?? '';

test('preview destinations resolve from the selected PR identity across supported triggers', () => {
  const workerLine = envLine('PREVIEW_WORKER');
  const urlLine = envLine('PREVIEW_URL');
  assert.match(workflow, /workflow_dispatch:/);
  assert.match(workflow, /pr_number:/);
  for (const line of [workerLine, urlLine]) {
    assert.match(line, /github\.event\.pull_request\.number/);
    assert.match(line, /inputs\.pr_number/);
  }
  assert.match(workerLine, /phoenix-journeys-pr-\{0\}/);
  assert.match(urlLine, /https:\/\/phoenix-journeys-pr-\{0\}\.7hn5tyrjgh\.workers\.dev/);
  assert.match(workflow, /--name "\$PREVIEW_WORKER"/);
});

test('preview release identity stays exact from event candidate through build and deploy', () => {
  const releaseLine = envLine('PREVIEW_RELEASE');
  assert.match(releaseLine, /github\.event\.pull_request\.head\.sha/);
  assert.match(releaseLine, /github\.sha/);
  assert.doesNotMatch(workflow, /candidate_sha:\s*$/m);
  assert.doesNotMatch(workflow, /release_sha:\s*$/m);
  assert.match(workflow, /ref: \$\{\{ env\.PREVIEW_RELEASE \}\}/);
  assert.match(workflow, /test "\$\(git rev-parse HEAD\)" = "\$PREVIEW_RELEASE"/);
  assert.equal((workflow.match(/flutter build web --release/g) ?? []).length, 1);

  const buildIndex = workflow.indexOf('name: Build preview web app once');
  const validateIndex = workflow.indexOf('name: Validate Cloudflare Worker bundle');
  const deployIndex = workflow.indexOf('name: Deploy isolated preview Worker');
  const verifyIndex = workflow.indexOf('name: Verify preview release');
  assert.ok(buildIndex >= 0);
  assert.ok(validateIndex > buildIndex);
  assert.ok(deployIndex > validateIndex);
  assert.ok(verifyIndex > deployIndex);

  const deployBlock = workflow.slice(deployIndex, verifyIndex);
  assert.match(deployBlock, /test "\$\(git rev-parse HEAD\)" = "\$PREVIEW_RELEASE"/);
  assert.match(deployBlock, /PHOENIX_RELEASE:\$PREVIEW_RELEASE/);
});

test('preview is exact-release verified before its link is published', () => {
  const verifyIndex = workflow.indexOf('name: Verify preview release');
  const statusIndex = workflow.indexOf('name: Publish preview status');
  const commentIndex = workflow.indexOf('name: Add or update preview comment');
  assert.ok(verifyIndex >= 0); assert.ok(statusIndex > verifyIndex); assert.ok(commentIndex > statusIndex);
  assert.match(workflow, /health\.release !== expected/);
  assert.match(workflow, /"\$response" "\$PREVIEW_RELEASE"/);
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
