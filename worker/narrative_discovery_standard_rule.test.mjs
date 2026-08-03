import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

function read(path) {
  assert.ok(fs.existsSync(path), `${path} must exist`);
  return fs.readFileSync(path, 'utf8');
}

const narrative = read('docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md');
const designMatrix = read(
  'docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md',
);
const journeySystem = read('docs/PHOENIX_JOURNEY_SYSTEM_STANDARD.md');
const creation = read('docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md');
const acceptance = read(
  'docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md',
);
const productQuality = read('docs/PHOENIX_PRODUCT_QUALITY_STANDARD.md');
const auditStandard = read('docs/PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md');
const auditMatrix = read(
  'docs/templates/PHOENIX_FULL_APPLICATION_AUDIT_MATRIX.md',
);
const roadmap = read('docs/PHOENIX_QUALITY_UNIFICATION_ROADMAP.md');
const prTemplate = read('.github/pull_request_template.md');
const workflow = read('docs/development-workflow.md');
const stableBaseline = read('docs/PHOENIX_STABLE_BASELINE_STANDARD.md');

function requireAll(text, required, label) {
  for (const value of required) {
    assert.ok(
      text.includes(value),
      `${label} must contain exact required clause: ${value}`,
    );
  }
}

test('Narrative and Discovery Standard exists and is binding', () => {
  assert.match(narrative, /^# Phoenix Narrative and Discovery Standard/m);
  assert.match(narrative, /\*\*Status:\*\* BINDING/);
  assert.match(narrative, /NEW RESULT >= CURRENT STABLE BASELINE/);
  assert.match(
    journeySystem,
    /Phoenix Narrative and Discovery Standard.*binding/is,
  );
  assert.match(
    creation,
    /binding together with \[Phoenix Narrative and Discovery Standard\]/i,
  );
  assert.match(productQuality, /PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD\.md/);
  assert.match(auditStandard, /PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD\.md/);
});

test('canonical Story and Discovery functions are operational contracts', () => {
  requireAll(
    narrative,
    [
      'Story Function:',
      'Discovery Function:',
      'Information unique to Story:',
      'Information unique to Discovery:',
      'Functional Separation Result:',
      'Exact-text difference is insufficient.',
      'Functional duplication is a blocking issue.',
    ],
    'Narrative Standard',
  );
  assert.match(journeySystem, /Story and Discovery MUST each submit a one-sentence Function Contract/);
  assert.match(designMatrix, /## 2\. Stage Function Contracts/);
  assert.match(designMatrix, /Functional duplication detected: YES \/ NO/);
  assert.match(auditStandard, /one Story Function Contract and one Discovery Function Contract/);
});

test('protagonist, relationship, choice, consequence, and engine rules are causal', () => {
  requireAll(
    narrative,
    [
      'Second person is a narrative perspective, not a substitute for character identity.',
      'Relationship MUST affect at least one of:',
      'show an enacted Choice',
      'show a visible Consequence caused by the Choice',
      'Each Journey MUST declare its primary narrative engine',
      'A city name, landmark, historical fact, object recolor, different weather, or different visual skin applied to the same causal structure does not create an independent Journey.',
    ],
    'Narrative Standard',
  );
  assert.match(journeySystem, /Generic second-person perspective alone does not satisfy protagonist identity/);
  assert.match(creation, /causal Relationship evidence/);
  assert.match(creation, /enacted Choice evidence/);
  assert.match(creation, /Consequence caused-by-choice evidence/);
  assert.match(prTemplate, /Relationship Causal Function:/);
  assert.match(prTemplate, /Enacted Choice:/);
  assert.match(prTemplate, /Caused Consequence:/);
});

test('opening, ending, cultural anchor, and library differentiation are independent', () => {
  requireAll(
    narrative,
    [
      '清晨，你走进……',
      '傍晚，你沿着……',
      '夜色中，你站在……',
      '薄雾里，你来到……',
      '不只是……而是……',
      '真正……不是……',
      '保护不仅……也……',
      '你会发现……',
      '理解……需要……',
      '## 10. Library differentiation matrix',
      'One unsupported numeric similarity score MUST NOT be used as approval.',
    ],
    'Narrative Standard',
  );
  assert.match(creation, /opening independence/);
  assert.match(creation, /catalog-level similarity and differentiation review/);
  assert.match(journeySystem, /Library-level differentiation is REQUIRED evidence/);
  assert.match(designMatrix, /## 5\. Catalog comparison/);
  assert.match(auditMatrix, /FA-ND-005 \| Opening Patterns/);
  assert.match(auditMatrix, /FA-ND-006 \| Ending Patterns/);
  assert.match(auditMatrix, /FA-ND-012 \| Catalog Differentiation/);
});

test('Phoenix level adaptation preserves all narrative invariants', () => {
  requireAll(
    narrative,
    [
      'Across Phoenix Lv.1 through Lv.10, the following are narrative invariants:',
      'protagonist identity;',
      'relationship;',
      'key choice;',
      'consequence;',
      'event order;',
      'ending state;',
      'special mechanism when applicable.',
      'Simplification MUST NOT remove causality or turn Story back into tourism exposition.',
      'All special Journeys MUST use an explicitly approved special or Journey-specific adaptation policy.',
    ],
    'Narrative Standard',
  );
  for (let level = 1; level <= 10; level += 1) {
    assert.match(
      designMatrix,
      new RegExp(`\\| ${level} \\|.*BLOCKED.*UNVERIFIED`),
      `design matrix must include Phoenix Lv.${level}`,
    );
  }
  assert.match(acceptance, /NJ-050 \| Level-Adaptation Narrative Invariants/);
  assert.match(auditMatrix, /FA-ND-013 \| Level Invariants/);
});

test('automated validation is explicitly bounded from literary approval', () => {
  requireAll(
    narrative,
    [
      'Automated validation cannot by itself approve:',
      '360 / 360 PASS',
      'score 100',
      'average 100',
      'all fields present',
      'They MUST NOT produce overall Story Quality `PASS`.',
    ],
    'Narrative Standard',
  );
  assert.match(productQuality, /aggregate content scores cannot approve library differentiation/);
  assert.match(creation, /Automated validation success does not establish literary `PASS`/);
  assert.match(acceptance, /NJ-051 \| Automated Literary Approval Limitation/);
  assert.match(auditStandard, /Automated scores cannot approve literary quality/);
  assert.match(auditMatrix, /FA-ND-014 \| Automated Literary Approval Boundary/);
  assert.match(prTemplate, /Automated score used as literary approval: NO/);
});

test('all required blocking codes are binding', () => {
  const blockingCodes = [
    'PROTAGONIST_IDENTITY_MISSING',
    'RELATIONSHIP_NOT_CAUSAL',
    'GOAL_NOT_PERSONAL_OR_SPECIFIC',
    'CONFLICT_NOT_CONNECTED_TO_GOAL',
    'CHOICE_NOT_ENACTED',
    'CONSEQUENCE_NOT_CAUSED',
    'EMOTIONAL_ARC_UNVERIFIED',
    'CULTURAL_ANCHOR_DECORATIVE',
    'STORY_IS_PRIMARY_EXPOSITION',
    'STORY_DISCOVERY_FUNCTION_OVERLAP',
    'OPENING_TEMPLATE_REUSE',
    'ENDING_TEMPLATE_REUSE',
    'NARRATIVE_ENGINE_DUPLICATION',
    'LIBRARY_DIFFERENTIATION_UNVERIFIED',
    'LEVEL_ADAPTATION_IDENTITY_LOSS',
    'SPECIAL_MECHANISM_FLATTENED',
    'AUTOMATED_SCORE_NOT_LITERARY_APPROVAL',
    'BATCH_EXPANSION_BEFORE_PILOT_APPROVAL',
  ];
  requireAll(narrative, blockingCodes, 'Narrative Standard blocking codes');
  assert.match(narrative, /Affected Journey IDs:/);
  assert.match(narrative, /Required action:/);
  assert.match(narrative, /Verification method:/);
});

test('acceptance matrix preserves NJ-001 through NJ-038 and adds NJ-039 through NJ-052', () => {
  for (let id = 1; id <= 52; id += 1) {
    const code = `NJ-${String(id).padStart(3, '0')}`;
    assert.match(acceptance, new RegExp(`\\| ${code} \\|`), `${code} must exist`);
  }
  requireAll(
    acceptance,
    [
      'NJ-039 | Story Function Contract',
      'NJ-040 | Discovery Function Contract',
      'NJ-041 | Story / Discovery Functional Separation',
      'NJ-042 | Narrative Engine Independence',
      'NJ-043 | Opening Independence',
      'NJ-044 | Relationship Causality',
      'NJ-045 | Enacted Choice',
      'NJ-046 | Caused Consequence',
      'NJ-047 | Climax and Changed Ending State',
      'NJ-048 | Cultural Anchor in Action',
      'NJ-049 | Catalog-Level Differentiation Matrix',
      'NJ-050 | Level-Adaptation Narrative Invariants',
      'NJ-051 | Automated Literary Approval Limitation',
      'NJ-052 | Repair / Creation Pilot Batch Gate',
    ],
    'Acceptance Matrix',
  );
});

test('normal and special pilots gate two-to-three-Journey controlled batches', () => {
  requireAll(
    narrative,
    [
      'Pilot N1',
      'beijing-summer-palace',
      'Pilot S1',
      'tide-letter',
      'no second pilot implementation',
      'default repair batch size is two to three Journeys',
      'Pilot N1 MUST be decided before Pilot S1 implementation begins.',
    ],
    'Narrative Standard pilot gate',
  );
  assert.match(roadmap, /Complete one normal Story pilot/);
  assert.match(roadmap, /Complete one special Story pilot/);
  assert.match(roadmap, /controlled batches of two to three Journeys/);
  assert.match(roadmap, /rewriting 27 normal Journeys in one task/);
  assert.match(roadmap, /rewriting nine special Journeys in one task/);
  assert.match(roadmap, /starting a second pilot before the first is decided/);
  assert.match(acceptance, /NJ-052 \| Repair \/ Creation Pilot Batch Gate/);
});

test('standards prohibit tourism Story, aggregate literary approval, premature batches, and functional duplication', () => {
  assert.match(narrative, /Factual exposition MUST NOT be the Story's primary narrative engine/);
  assert.match(journeySystem, /avoid generic tourism narration/);
  assert.match(productQuality, /factual accuracy does not replace narrative quality/);
  assert.match(narrative, /One unsupported numeric similarity score MUST NOT be used as approval/);
  assert.match(roadmap, /approving a batch only through aggregate score/);
  assert.match(narrative, /no batch Story rewrite/);
  assert.match(creation, /no batch rewrite/);
  assert.match(narrative, /Functional duplication is a blocking issue/);
  assert.match(creation, /Story \/ Discovery functional duplication/);
});

test('existing stable-baseline rules remain intact', () => {
  assert.match(workflow, /当前稳定产品 PR：`#137`/);
  assert.match(
    workflow,
    /当前稳定 main Commit：`5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`/,
  );
  assert.match(
    workflow,
    /基线身份唯一权威来源：`docs\/PHOENIX_STABLE_BASELINE_STANDARD\.md`/,
  );
  assert.match(workflow, /禁止直接在 `main` 开发或试验/);
  assert.match(workflow, /NEW RESULT >= CURRENT STABLE BASELINE/);
  assert.match(stableBaseline, /\*\*Stable PR:\*\* `#137`/);
  assert.match(
    stableBaseline,
    /\*\*Stable Commit:\*\* `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`/,
  );
  assert.match(
    stableBaseline,
    /This file, `docs\/PHOENIX_STABLE_BASELINE_STANDARD\.md`, is the single normative authority/,
  );
});
