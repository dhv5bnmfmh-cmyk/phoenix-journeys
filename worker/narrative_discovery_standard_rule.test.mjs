import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

function read(path) {
  assert.ok(fs.existsSync(path), `${path} must exist`);
  return fs.readFileSync(path, 'utf8');
}

const narrative = read('docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md');
const designMatrix = read('docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md');
const journeySystem = read('docs/PHOENIX_JOURNEY_SYSTEM_STANDARD.md');
const creation = read('docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md');
const acceptance = read('docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md');
const productQuality = read('docs/PHOENIX_PRODUCT_QUALITY_STANDARD.md');
const auditStandard = read('docs/PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md');
const auditMatrix = read('docs/templates/PHOENIX_FULL_APPLICATION_AUDIT_MATRIX.md');
const roadmap = read('docs/PHOENIX_QUALITY_UNIFICATION_ROADMAP.md');
const prTemplate = read('.github/pull_request_template.md');
const workflow = read('docs/development-workflow.md');
const stableBaseline = read('docs/PHOENIX_STABLE_BASELINE_STANDARD.md');
const acceptanceContract = read('docs/PHOENIX_JOURNEY_ACCEPTANCE_CONTRACT.md');

function requireAll(text, required, label) {
  for (const value of required) assert.ok(text.includes(value), `${label} must contain exact required clause: ${value}`);
}

test('Narrative and Discovery Standard exists and remains canonical', () => {
  assert.match(narrative, /^# Phoenix Narrative and Discovery Standard/m);
  assert.match(narrative, /\*\*Status:\*\* BINDING/);
  assert.match(narrative, /NEW RESULT >= CURRENT STABLE BASELINE/);
  assert.match(journeySystem, /Phoenix Narrative and Discovery Standard.*binding/is);
  assert.match(creation, /binding together with \[Phoenix Narrative and Discovery Standard\]/i);
  assert.match(productQuality, /PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD\.md/);
  assert.match(auditStandard, /PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD\.md/);
  assert.match(acceptanceContract, /`PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD\.md`: Story, Discovery, Lv1-Lv10 literary\/semantic quality, anti-template, historical truth/);
});

test('canonical Story and Discovery functions are operational contracts', () => {
  requireAll(narrative, ['Story Function:','Discovery Function:','Information unique to Story:','Information unique to Discovery:','Functional Separation Result:','Exact-text difference is insufficient.','Functional duplication is a blocking issue.'], 'Narrative Standard');
  assert.match(journeySystem, /Story and Discovery MUST each submit a one-sentence Function Contract/);
  assert.match(designMatrix, /## 2\. Stage Function Contracts/);
  assert.match(designMatrix, /Functional duplication detected: YES \/ NO/);
  assert.match(auditStandard, /one Story Function Contract and one Discovery Function Contract/);
  assert.match(acceptanceContract, /Discovery extends a question raised by Story into independently verifiable real-world knowledge without retelling Story/);
});

test('protagonist, relationship, choice, consequence, and engine rules stay causal and anti-template', () => {
  requireAll(narrative, ['Second person is a narrative perspective, not a substitute for character identity.','Relationship MUST affect at least one of:','show an enacted Choice','show a visible Consequence caused by the Choice','Each Journey MUST declare its primary narrative engine','A city name, landmark, historical fact, object recolor, different weather, or different visual skin applied to the same causal structure does not create an independent Journey.'], 'Narrative Standard');
  assert.match(journeySystem, /Generic second-person perspective alone does not satisfy protagonist identity/);
  assert.match(creation, /causal Relationship evidence/);
  assert.match(creation, /enacted Choice evidence/);
  assert.match(creation, /Consequence caused-by-choice evidence/);
  assert.match(acceptanceContract, /place-dependent Goal, causal Relationship, Conflict connected to Goal, enacted Choice, caused Consequence/);
  assert.match(prTemplate, /Story narrative \+ place causality/);
  assert.match(prTemplate, /Cross-Journey anti-template review/);
});

test('opening, ending, cultural anchor, and library differentiation are independently governed', () => {
  requireAll(narrative, ['## 10. Library differentiation matrix','One unsupported numeric similarity score MUST NOT be used as approval.'], 'Narrative Standard');
  assert.match(creation, /opening independence/);
  assert.match(creation, /catalog-level similarity and differentiation review/);
  assert.match(journeySystem, /Library-level differentiation is REQUIRED evidence/);
  assert.match(designMatrix, /## 5\. Catalog comparison/);
  assert.match(auditMatrix, /FA-ND-005 \| Opening Patterns/);
  assert.match(auditMatrix, /FA-ND-006 \| Ending Patterns/);
  assert.match(auditMatrix, /FA-ND-012 \| Catalog Differentiation/);
});

test('Phoenix level adaptation preserves narrative invariants and substantive progression', () => {
  requireAll(narrative, ['Across Phoenix Lv.1 through Lv.10, the following are narrative invariants:','protagonist identity;','relationship;','key choice;','consequence;','event order;','ending state;','Simplification MUST NOT remove causality or turn Story back into tourism exposition.'], 'Narrative Standard');
  for (let level = 1; level <= 10; level += 1) {
    assert.match(designMatrix, new RegExp(`\\| ${level} \\|.*BLOCKED.*UNVERIFIED`), `design matrix must include Phoenix Lv.${level}`);
  }
  assert.match(acceptance, /NJ-050 \| Level-Adaptation Narrative Invariants/);
  assert.match(auditMatrix, /FA-ND-013 \| Level Invariants/);
  assert.match(acceptanceContract, /Lv1-Lv10 must increase cognitive and linguistic depth, not merely length/);
});

test('automated validation remains bounded from literary approval', () => {
  requireAll(narrative, ['Automated validation cannot by itself approve:','360 / 360 PASS','score 100','average 100','all fields present','They MUST NOT produce overall Story Quality `PASS`.'], 'Narrative Standard');
  assert.match(productQuality, /aggregate content scores cannot approve library differentiation/);
  assert.match(creation, /Automated validation success does not establish literary `PASS`/);
  assert.match(acceptance, /NJ-051 \| Automated Literary Approval Limitation/);
  assert.match(auditStandard, /Automated scores cannot approve literary quality/);
  assert.match(auditMatrix, /FA-ND-014 \| Automated Literary Approval Boundary/);
  assert.match(acceptanceContract, /Aggregate scores, field counts, `360\/360`, or green CI cannot replace human review/);
  assert.match(prTemplate, /Aggregate score cannot approve Story quality/);
});

test('all required narrative blocking codes remain binding', () => {
  const blockingCodes = ['PROTAGONIST_IDENTITY_MISSING','RELATIONSHIP_NOT_CAUSAL','GOAL_NOT_PERSONAL_OR_SPECIFIC','CONFLICT_NOT_CONNECTED_TO_GOAL','CHOICE_NOT_ENACTED','CONSEQUENCE_NOT_CAUSED','EMOTIONAL_ARC_UNVERIFIED','CULTURAL_ANCHOR_DECORATIVE','STORY_IS_PRIMARY_EXPOSITION','STORY_DISCOVERY_FUNCTION_OVERLAP','OPENING_TEMPLATE_REUSE','ENDING_TEMPLATE_REUSE','NARRATIVE_ENGINE_DUPLICATION','LIBRARY_DIFFERENTIATION_UNVERIFIED','LEVEL_ADAPTATION_IDENTITY_LOSS','SPECIAL_MECHANISM_FLATTENED','AUTOMATED_SCORE_NOT_LITERARY_APPROVAL','BATCH_EXPANSION_BEFORE_PILOT_APPROVAL'];
  requireAll(narrative, blockingCodes, 'Narrative Standard blocking codes');
  assert.match(narrative, /Affected Journey IDs:/);
  assert.match(narrative, /Required action:/);
  assert.match(narrative, /Verification method:/);
});

test('archived roadmap cannot override the current fast-but-strict acceptance pipeline', () => {
  requireAll(roadmap, ['ARCHIVED / NON-BINDING HISTORICAL SEQUENCE','PHOENIX_JOURNEY_ACCEPTANCE_CONTRACT.md','Quality requirements remain binding through their canonical owner'], 'Archived roadmap');
  requireAll(acceptanceContract, ['## P16 Fast but Strict Journey Pipeline','Exact-head CI + Preview','Release identity','Browser proof','Final drift check','Founder experience','Merge only after explicit authorization.'], 'Acceptance contract');
  assert.match(narrative, /default repair batch size is two to three Journeys/);
  assert.match(narrative, /Pilot N1 MUST be decided before Pilot S1 implementation begins/);
  assert.match(narrative, /no batch Story rewrite/);
});

test('existing stable-baseline rules remain intact', () => {
  assert.match(workflow, /历史最低产品质量基线 PR：`#137`/);
  assert.match(workflow, /历史最低产品质量基线 Commit：`5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`/);
  assert.match(workflow, /基线身份唯一权威来源：`docs\/PHOENIX_STABLE_BASELINE_STANDARD\.md`/);
  assert.match(workflow, /禁止直接在 `main` 开发或试验/);
  assert.match(workflow, /NEW RESULT >= CURRENT STABLE BASELINE/);
  assert.match(stableBaseline, /\*\*Historical minimum-quality baseline PR:\*\* `#137`/);
  assert.match(stableBaseline, /\*\*Historical minimum-quality baseline Commit:\*\* `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`/);
});
