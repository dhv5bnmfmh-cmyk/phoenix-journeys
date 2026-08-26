import test from 'node:test';
import assert from 'node:assert/strict';
import { validateArtifactManifest, validateQualityReport } from './validate_quality_artifact.mjs';

const report = {
  journeyCount: 36,
  regularJourneyCount: 27,
  specialJourneyCount: 9,
  profileCount: 10,
  inspectionCount: 360,
  approvedCount: 360,
  needsRevisionCount: 0,
  blockedCount: 0,
  automatedGateStatus: 'pass',
  canEnterHumanReview: true,
  canPublish: true,
  canPublishScope: 'automated-content-contract-only',
  agentSemanticSufficiencyStatus: 'pending-human-review',
  agentLiteraryReviewStatus: 'pending-human-review',
  humanNarrativeAntiTemplateStatus: 'pending-human-review',
  founderStoryApprovalStatus: 'pending-founder-review',
  overallStoryQualityStatus: 'pending-human-review',
  automatedScoreUsedAsLiteraryApproval: false,
};

test('360/360 quality contract passes without converting human gates to PASS', () => {
  assert.equal(validateQualityReport(report), true);
});

test('quality gate rejects reduced inspection count', () => {
  assert.throws(() => validateQualityReport({ ...report, inspectionCount: 359 }), /inspectionCount/);
});

test('quality gate rejects automated literary approval', () => {
  assert.throws(
    () => validateQualityReport({ ...report, automatedScoreUsedAsLiteraryApproval: true }),
    /automatedScoreUsedAsLiteraryApproval/,
  );
});

test('artifact manifest binds exact SHA and type', () => {
  const sha = 'b'.repeat(40);
  assert.equal(validateArtifactManifest({ schema: 1, type: 'journey-quality', sha }, 'journey-quality', sha), true);
  assert.throws(
    () => validateArtifactManifest({ schema: 1, type: 'journey-quality', sha: 'c'.repeat(40) }, 'journey-quality', sha),
    /artifact manifest mismatch/,
  );
});
