import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const auditorPath = 'app/lib/services/journey_content_quality_auditor.dart';
const auditorTestPath = 'app/test/journey_content_quality_auditor_test.dart';
const agentPath = 'app/lib/agents/phoenix_journey_content_quality_agent.dart';
const agentTestPath = 'app/test/phoenix_journey_content_quality_agent_test.dart';

const [auditor, auditorCoverage, agent, agentCoverage] = await Promise.all([
  readFile(auditorPath, 'utf8'),
  readFile(auditorTestPath, 'utf8'),
  readFile(agentPath, 'utf8'),
  readFile(agentTestPath, 'utf8'),
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

test('uses a dedicated agent for scoring, release decisions, and repair advice', () => {
  assert.match(agent, /class PhoenixJourneyContentQualityAgent/);
  assert.match(agent, /PhoenixJourneyReleaseStatus/);
  assert.match(agent, /inspectPublishedCatalog/);
  assert.match(agent, /PhoenixJourneyQualityRecommendation/);
  assert.match(agent, /needsRevision/);
  assert.match(agent, /blocked/);
  assert.match(agent, /isPublishable/);
});

test('runs the quality gate across every journey and every exam profile', () => {
  assert.match(auditorCoverage, /for \(final profile in agent\.allProfiles\)/);
  assert.match(auditorCoverage, /for \(final journey in dailyJourneyExperiences\)/);
  assert.match(auditorCoverage, /auditJourneyContentQuality/);
  assert.match(auditorCoverage, /report\.hasCriticalIssues/);
  assert.match(auditorCoverage, /greaterThanOrEqualTo\(90\)/);

  assert.match(agentCoverage, /inspectPublishedCatalog/);
  assert.match(agentCoverage, /dailyJourneyExperiences/);
  assert.match(agentCoverage, /levelAgent\.allProfiles/);
  assert.match(agentCoverage, /batch\.canPublish/);
  assert.match(agentCoverage, /PhoenixJourneyReleaseStatus\.blocked/);
});
