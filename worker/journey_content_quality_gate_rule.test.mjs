import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const auditorPath = 'app/lib/services/journey_content_quality_auditor.dart';
const testPath = 'app/test/journey_content_quality_auditor_test.dart';

const [auditor, coverage] = await Promise.all([
  readFile(auditorPath, 'utf8'),
  readFile(testPath, 'utf8'),
]);

test('audits story shape, multilingual alignment, discovery novelty, and prompts', () => {
  assert.match(auditor, /story-paragraph-shape/);
  assert.match(auditor, /story-annotation-count/);
  assert.match(auditor, /dependent-paragraph-opening/);
  assert.match(auditor, /discovery-repeats-story/);
  assert.match(auditor, /duplicate-discovery/);
  assert.match(auditor, /empty-learning-prompt/);
  assert.match(auditor, /chineseContentSimilarity/);
});

test('runs the quality gate across every journey and every exam profile', () => {
  assert.match(coverage, /for \(final profile in agent\.allProfiles\)/);
  assert.match(coverage, /for \(final journey in dailyJourneyExperiences\)/);
  assert.match(coverage, /auditJourneyContentQuality/);
  assert.match(coverage, /report\.hasCriticalIssues/);
  assert.match(coverage, /greaterThanOrEqualTo\(90\)/);
});
