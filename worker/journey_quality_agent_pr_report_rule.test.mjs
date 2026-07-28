import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const workflowPath = '.github/workflows/preview-cloudflare.yml';
const reportToolPath = 'app/tool/generate_journey_quality_report.dart';

const [workflow, reportTool] = await Promise.all([
  readFile(workflowPath, 'utf8'),
  readFile(reportToolPath, 'utf8'),
]);

test('generates and publishes the quality agent report before preview deployment', () => {
  const generateIndex = workflow.indexOf('Generate journey quality agent report');
  const commentIndex = workflow.indexOf('Add or update quality agent comment');
  const enforceIndex = workflow.indexOf('Enforce quality agent release decision');
  const buildIndex = workflow.indexOf('Build preview web app');
  const deployIndex = workflow.indexOf('Deploy isolated preview Worker');

  assert.ok(generateIndex >= 0);
  assert.ok(commentIndex > generateIndex);
  assert.ok(enforceIndex > commentIndex);
  assert.ok(buildIndex > enforceIndex);
  assert.ok(deployIndex > buildIndex);
  assert.match(workflow, /dart run tool\/generate_journey_quality_report\.dart/);
  assert.match(workflow, /phoenix-content-quality-agent-report/);
  assert.match(workflow, /journey-quality-report\.json/);
  assert.match(workflow, /if \(!report\.canPublish\)/);
  assert.match(workflow, /actions\/upload-artifact@v4/);
});

test('report covers the published catalog and exposes release evidence', () => {
  assert.match(reportTool, /PhoenixJourneyContentQualityAgent/);
  assert.match(reportTool, /inspectPublishedCatalog/);
  assert.match(reportTool, /dailyJourneyExperiences/);
  assert.match(reportTool, /allProfiles/);
  assert.match(reportTool, /'canPublish': batch\.canPublish/);
  assert.match(reportTool, /'minimumScore': batch\.minimumScore/);
  assert.match(reportTool, /'findings':/);
  assert.match(reportTool, /Phoenix 全旅程内容品质报告/);
});
