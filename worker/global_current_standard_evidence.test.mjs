import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const csv = path => {
  const lines = readFileSync(new URL(`../${path}`, import.meta.url), 'utf8')
    .trimEnd()
    .split(/\r?\n/);
  return { header: lines[0], rows: lines.slice(1) };
};

test('global convergence evidence uses the current active and Gold registries', () => {
  const active = csv('docs/PHOENIX_CURRENT_ACTIVE_JOURNEY_INVENTORY.csv');
  assert.equal(active.rows.length, 36);
  assert.equal(active.rows.filter(row => row.includes(',"APPROVED_GOLD",')).length, 14);
  assert.equal(active.rows.filter(row => row.includes(',"GOLD_CANDIDATE",')).length, 1);
  assert.match(active.rows.find(row => row.includes('pingyao-ancient-city')), /GOLD_CANDIDATE/);
});

test('current-standard generator is structural and cannot manufacture semantic PASS', () => {
  const standards = csv('docs/PHOENIX_CURRENT_STANDARD_INVENTORY.csv');
  const generator = readFileSync(
    new URL('../.github/scripts/generate_global_compliance_evidence.mjs', import.meta.url),
    'utf8',
  );

  assert.equal(standards.rows.length, 23);
  assert.match(generator, /CURRENT_EFFECTIVE/);
  assert.match(generator, /normativeSections/);
  assert.match(generator, /explicitNormative/);
  assert.match(generator, /imperative/);
  assert.match(generator, /sourceKind/);
  assert.match(generator, /currentEffectiveDocsWithUnextractedRules/);
  assert.match(generator, /unmappedRequirements/);
  assert.match(generator, /semanticPassesAssertedByGenerator:\s*0/);
  assert.match(generator, /NOT_ASSERTED_BY_GENERATOR/);
  assert.match(generator, /PENDING_REQUIREMENT_SPECIFIC_VERIFICATION/);
  assert.match(generator, /requirements\.length \* allJourneys\.length/);
  assert.doesNotMatch(
    generator,
    /return\s*\{[^}]*level:\s*['"]VERIFIED['"][^}]*result:\s*['"]PASS['"]/s,
  );
  assert.doesNotMatch(generator, /Objective defects remaining:\s*\*\*0\*\*/);
});

test('requirement mappings are requirement-specific even when Agent review is needed', () => {
  const generator = readFileSync(
    new URL('../.github/scripts/generate_global_compliance_evidence.mjs', import.meta.url),
    'utf8',
  );
  for (const contract of [
    'CHALLENGE_RUNTIME_CONTRACT',
    'SPECIAL_MECHANISM_CONTRACT',
    'VOCABULARY_LEVEL_PROVENANCE_CONTRACT',
    'STORY_NARRATIVE_CONTRACT',
    'DISCOVERY_CLOSED_LOOP_CONTRACT',
    'MEMORY_COMPLETION_CONTRACT',
    'MULTILINGUAL_SEMANTIC_CONTRACT',
    'NARRATION_AUDIO_CONTRACT',
    'PERFORMANCE_LAZY_RUNTIME_CONTRACT',
    'LOCATION_PASSPORT_CONTRACT',
    'MOBILE_ACCESSIBILITY_INTERACTION_CONTRACT',
    'ASSET_VISUAL_RIGHTS_CONTRACT',
    'DEVELOPMENT_GOVERNANCE_CONTRACT',
  ]) {
    assert.match(generator, new RegExp(contract));
  }
  assert.match(
    generator,
    /docs\/PHOENIX_DEEP_AUDIT_REPORT\.md#\$\{requirement\.requirementId\}/,
  );
});

test('human Gold evidence is provenance-safe and never machine-promoted', () => {
  const human = csv('docs/PHOENIX_CURRENT_HUMAN_REVIEW_PACKET.csv');
  assert.equal(human.rows.length, 14 * 3 * 3);
  for (const field of [
    'CHALLENGE_PROMPT',
    'ALL_CANDIDATE_ANSWERS_OPTIONS',
    'CORRECT_ANSWER',
    'WHY_EACH_DISTRACTOR_IS_WRONG',
    'TAUGHT_SOURCE_TEXT',
    'AGENT_PRECHECK_RESULT',
  ]) assert.match(human.header, new RegExp(`"${field}"`));
  for (const row of human.rows) {
    assert.match(row, /HUMAN_REVIEW_REQUIRED/);
    assert.match(row, /AGENT PASS/);
    assert.doesNotMatch(row, /JourneyChallengePanel","","","Fresh named human provenance/);
    assert.doesNotMatch(row, /,"PASS"$/);
  }

  const generator = readFileSync(
    new URL('../.github/scripts/generate_global_compliance_evidence.mjs', import.meta.url),
    'utf8',
  );
  assert.match(generator, /HUMAN_OR_FOUNDER_GATE/);
  assert.match(generator, /HUMAN_GATE/);
  assert.match(generator, /Human results remain unasserted until a Human records them/);
});

test('visual evidence separates product basis from current Founder review identity', () => {
  const visual = readFileSync(
    new URL('../docs/PHOENIX_VISUAL_RIGHTS_REVIEW_PACKET.md', import.meta.url),
    'utf8',
  );
  assert.match(
    visual,
    /PRODUCT_VISUAL_EVIDENCE_BASIS_SHA: `d2392bdb6f5ecf3dae50883cf5be1390928656fb`/,
  );
  assert.match(visual, /CURRENT_FOUNDER_REVIEW_HEAD: resolve from remote PR `#195` at review time/);
  assert.match(visual, /v=<CURRENT_PR_HEAD>/);
  assert.match(visual, /image bytes, an active asset path, a release asset mapping/);
  assert.match(visual, /visual runtime behavior, relevant layout\/render behavior/);
  assert.match(visual, /evidence-only, documentation-only, or test-only commit does not invalidate/);
  assert.match(visual, /Preview and Health identities match the current remote PR head/);
  assert.doesNotMatch(visual, /Exact candidate:/);
  assert.doesNotMatch(visual, /must be regenerated if the head changes/);
  assert.doesNotMatch(visual, /v=[0-9a-f]{40}/);
  assert.doesNotMatch(visual, /HUMAN VISUAL RESULT:\s*(?:PASS|APPROVED)/);
  assert.match(visual, /HUMAN VISUAL RESULT: HUMAN_REVIEW_REQUIRED/);
  assert.match(visual, /FINAL FOUNDER MOBILE APPROVAL: PENDING/);
});
