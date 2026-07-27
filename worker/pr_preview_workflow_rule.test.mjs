import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const workflow = readFileSync('.github/workflows/preview-cloudflare.yml', 'utf8');
const template = readFileSync('.github/pull_request_template.md', 'utf8');
const processDoc = readFileSync('docs/development-workflow.md', 'utf8');

test('every Phoenix pull request gets an isolated Worker name and URL', () => {
  assert.match(
    workflow,
    /PREVIEW_WORKER: phoenix-journeys-pr-\$\{\{ github\.event\.pull_request\.number \}\}/,
  );
  assert.match(
    workflow,
    /PREVIEW_URL: https:\/\/phoenix-journeys-pr-\$\{\{ github\.event\.pull_request\.number \}\}\.7hn5tyrjgh\.workers\.dev/,
  );
  assert.match(workflow, /--name "\$PREVIEW_WORKER"/);
});

test('preview uses the feature head commit rather than the pull request merge ref', () => {
  assert.match(workflow, /ref: \$\{\{ github\.event\.pull_request\.head\.sha \}\}/);
  assert.match(workflow, /PREVIEW_RELEASE: \$\{\{ github\.event\.pull_request\.head\.sha \}\}/);
  assert.match(workflow, /PHOENIX_RELEASE:\$PREVIEW_RELEASE/);
});

test('preview is verified before its link is published', () => {
  const verifyIndex = workflow.indexOf('name: Verify preview release');
  const statusIndex = workflow.indexOf('name: Publish preview status');
  const commentIndex = workflow.indexOf('name: Add or update preview comment');

  assert.ok(verifyIndex >= 0);
  assert.ok(statusIndex > verifyIndex);
  assert.ok(commentIndex > statusIndex);
  assert.match(workflow, /health\.release !== expectedRelease/);
});

test('preview workers are removed when pull requests close', () => {
  assert.match(workflow, /github\.event\.action == 'closed'/);
  assert.match(workflow, /wrangler@4 delete --name "\$PREVIEW_WORKER"/);
});

test('fork pull requests cannot access deployment secrets', () => {
  assert.match(
    workflow,
    /github\.event\.pull_request\.head\.repo\.full_name == github\.repository/g,
  );
});

test('merge checklist protects stable Phoenix behavior', () => {
  assert.match(template, /故事页朗读、暂停、继续、调速正常/);
  assert.match(template, /声音、三角形、短文高亮同步/);
  assert.match(template, /键盘稳定/);
  assert.match(template, /用户已确认可以合并到 `main`/);
});

test('development process forbids direct main development', () => {
  assert.match(processDoc, /禁止直接在 `main` 开发或试验/);
  assert.match(processDoc, /用户明确确认后，才允许合并到 `main`/);
  assert.match(processDoc, /stable\/phoenix-baseline-2026-07-19/);
});
