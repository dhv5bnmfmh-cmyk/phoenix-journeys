import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const previewWorkflowPath = '.github/workflows/preview-cloudflare.yml';
const flutterWorkflowPath = '.github/workflows/flutter-ci.yml';
const reportToolPath = 'app/tool/generate_journey_quality_report.dart';
const reportRunnerPath = 'app/test/journey_quality_report_ci_test.dart';

const [previewWorkflow, flutterWorkflow, reportTool, reportRunner] = await Promise.all([
  readFile(previewWorkflowPath, 'utf8'),
  readFile(flutterWorkflowPath, 'utf8'),
  readFile(reportToolPath, 'utf8'),
  readFile(reportRunnerPath, 'utf8'),
]);

test('authoritative producer generates exact quality evidence before preview consumes and deploys it', () => {
  const qualityIndex = flutterWorkflow.indexOf('name: Dedicated isolated Journey quality report');
  const contractIndex = flutterWorkflow.indexOf('name: Bind and enforce exact quality artifact');
  const uploadIndex = flutterWorkflow.indexOf('name: Upload exact Journey quality artifact');
  const producerBuildIndex = flutterWorkflow.indexOf('name: Build web release');

  assert.ok(qualityIndex >= 0);
  assert.ok(contractIndex > qualityIndex);
  assert.ok(uploadIndex > contractIndex);
  assert.ok(producerBuildIndex > uploadIndex);
  assert.match(flutterWorkflow, /PHOENIX_GENERATE_QUALITY_REPORT: '1'/);
  assert.match(flutterWorkflow, /flutter test test\/journey_quality_report_ci_test\.dart --reporter expanded/);
  assert.match(flutterWorkflow, /phoenix-journey-quality-\$\{\{ env\.CANDIDATE_SHA \}\}/);
  assert.match(flutterWorkflow, /journey-quality-report\.json/);
  assert.match(flutterWorkflow, /actions\/upload-artifact@v4/);

  const resolveIndex = previewWorkflow.indexOf('name: Resolve successful exact Flutter CI producer');
  const downloadIndex = previewWorkflow.indexOf('name: Download exact Journey quality artifact');
  const verifyIndex = previewWorkflow.indexOf('name: Verify downloaded exact artifact identity and quality contract');
  const commentIndex = previewWorkflow.indexOf('name: Add or update quality agent comment');
  const deployIndex = previewWorkflow.indexOf('name: Deploy exact tested web artifact to isolated preview Worker');

  assert.ok(resolveIndex >= 0);
  assert.ok(downloadIndex > resolveIndex);
  assert.ok(verifyIndex > downloadIndex);
  assert.ok(commentIndex > verifyIndex);
  assert.ok(deployIndex > commentIndex);
  assert.match(previewWorkflow, /phoenix-journey-quality-\$\{\{ env\.PREVIEW_RELEASE \}\}/);
  assert.match(previewWorkflow, /validate_quality_artifact\.mjs/);
  assert.match(previewWorkflow, /journey-quality-report\.json/);
  assert.doesNotMatch(previewWorkflow, /PHOENIX_GENERATE_QUALITY_REPORT/);
  assert.doesNotMatch(previewWorkflow, /\bflutter test\b/);
  assert.doesNotMatch(previewWorkflow, /\bflutter build web\b/);
});

test('Flutter-backed runner requires thirty-six journeys and 360 inspections', () => {
  assert.match(reportRunner, /generate_journey_quality_report\.dart/);
  assert.match(reportRunner, /PHOENIX_QUALITY_MARKDOWN/);
  assert.match(reportRunner, /PHOENIX_QUALITY_JSON/);
  assert.match(reportRunner, /report\['journeyCount'\], 36/);
  assert.match(reportRunner, /report\['specialJourneyCount'\], 9/);
  assert.match(reportRunner, /report\['inspectionCount'\], 360/);
  assert.match(reportRunner, /report\['canPublish'\], isTrue/);
  assert.match(reportRunner, /report\['blockedCount'\], 0/);
});

test('report covers regular and special catalogs and exposes release evidence', () => {
  assert.match(reportTool, /PhoenixJourneyContentQualityAgent/);
  assert.match(reportTool, /inspectPublishedCatalog/);
  assert.match(reportTool, /allJourneyExperiences/);
  assert.match(reportTool, /dailyJourneyExperiences\.length/);
  assert.match(reportTool, /specialJourneyExperiences\.length/);
  assert.match(reportTool, /allProfiles/);
  assert.match(reportTool, /'canPublish': batch\.canPublish/);
  assert.match(reportTool, /'minimumScore': batch\.minimumScore/);
  assert.match(reportTool, /'findings':/);
  assert.match(reportTool, /Phoenix 全旅程内容品质报告/);
});
