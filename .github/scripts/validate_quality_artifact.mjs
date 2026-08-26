import { readFile } from 'node:fs/promises';
import { pathToFileURL } from 'node:url';

export function validateQualityReport(report) {
  const required = {
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
  for (const [key, expected] of Object.entries(required)) {
    if (report?.[key] !== expected) {
      throw new Error(`quality report contract mismatch: ${key} expected=${expected} actual=${report?.[key]}`);
    }
  }
  return true;
}

export function validateArtifactManifest(manifest, expectedType, expectedSha) {
  if (manifest?.schema !== 1 || manifest?.type !== expectedType || manifest?.sha !== expectedSha) {
    throw new Error(
      `artifact manifest mismatch: expected type=${expectedType} sha=${expectedSha}; ` +
        `actual type=${manifest?.type} sha=${manifest?.sha} schema=${manifest?.schema}`,
    );
  }
  return true;
}

async function cli() {
  const [qualityPath, manifestPath, expectedSha] = process.argv.slice(2);
  if (!qualityPath || !manifestPath || !expectedSha) {
    throw new Error('usage: validate_quality_artifact.mjs <quality-json> <manifest-json> <sha>');
  }
  const report = JSON.parse(await readFile(qualityPath, 'utf8'));
  const manifest = JSON.parse(await readFile(manifestPath, 'utf8'));
  validateQualityReport(report);
  validateArtifactManifest(manifest, 'journey-quality', expectedSha);
  console.log(`QUALITY ARTIFACT = PASS | 360/360 | SHA=${expectedSha}`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  cli().catch((error) => {
    console.error(error?.stack || String(error));
    process.exitCode = 1;
  });
}
