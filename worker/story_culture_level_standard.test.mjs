import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const read = (path) => readFileSync(new URL(`../${path}`, import.meta.url), 'utf8');

const narrative = read('docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md');
const creation = read('docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md');
const design = read('docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md');
const acceptance = read('docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md');
const sixStage = read('docs/templates/PHOENIX_SIX_STAGE_JOURNEY_ACCEPTANCE_MATRIX.md');
const behavior = read('ai/AI_BEHAVIOR.md');
const qualityGate = read('docs/journey-content-quality-gate.md');
const baseline = read('docs/PHOENIX_STABLE_BASELINE_STANDARD.md');
const roadmap = read('docs/PHOENIX_STORY_REMEDIATION_ROADMAP.md');

function requiresEvery(text, values, label) {
  for (const value of values) {
    assert.ok(text.includes(value), `${label} must include ${value}`);
  }
}

test('canonical standards bind Story culture and level learning without a parallel V2', () => {
  requiresEvery(narrative, [
    '文化知识不是背景资料，而是剧情压力',
    'CULTURAL FACT ACTION TEST',
    'CULTURAL KNOWLEDGE RESIDUE',
    'Story encounter → Discovery explanation',
    '2 / 2 / 2 / 2 / 3 / 3 / 3 / 3 / 3 / 3',
    'LANGUAGE GRADIENT + STORY UNDERSTANDING GRADIENT + CULTURAL UNDERSTANDING GRADIENT',
    'LEVEL SEMANTIC DELTA',
    'NEW PHRASE != NEW UNDERSTANDING',
    'LEVEL BACKWARD COMPLETENESS',
    'LV10 MASTERY DELTA',
    'MASTERY CAPSTONE',
    'MINIMUM SUFFICIENT STORY',
    'ACTION FIRST; TERMINOLOGY SECOND',
    'INTERNAL QA LANGUAGE MUST NEVER LEAK TO LEARNER CONTENT',
    'NO ENDLESS POLISH LOOP',
    'PR HEAD SHA = Founder review Candidate SHA = Preview release SHA',
  ], 'Narrative standard');
  assert.doesNotMatch(
    `${narrative}\n${creation}`,
    /(?:HUMAN_STORY|CULTURE|LEVEL)_STANDARD_V2/,
  );
});

test('canonical lifecycle and matrices make the Pilot rules actionable', () => {
  requiresEvery(creation, [
    'Binding Story × Culture × Level lifecycle extension',
    'five cognitive bands',
    'Any source commit after Founder Experience invalidates that SHA-bound approval',
    'six-stage product architecture is unchanged',
  ], 'Creation standard');
  requiresEvery(acceptance, [
    'NJ-064',
    'NJ-068',
    'NJ-071',
    'NJ-072',
    'NJ-074',
    'NJ-080',
    'NJ-081',
  ], 'Acceptance matrix');
  requiresEvery(design, [
    'Adjacent Level Semantic Delta',
    'Causal/relational evidence chain',
    'Story × Culture evidence',
    'Founder-visible QA language sweep',
  ], 'Design matrix');
  requiresEvery(sixStage, [
    'The six stages remain unchanged',
    'Five cognitive bands',
    'Backward completeness',
  ], 'Six-stage matrix');
  requiresEvery(behavior, [
    'Story × Culture × Level behavior',
    'Green automation is never literary or Founder authority',
  ], 'AI behavior');
});

test('horizontal audit is current and does not authorize multi-Journey rewrites', () => {
  requiresEvery(roadmap, [
    '38b798c314b819792b6a827e9b9c672efcdb8946',
    '`beijing-summer-palace`',
    '`beijing-forbidden-city`',
    '`shanghai-bund`',
    '`xian-city-wall`',
    '`hangzhou-west-lake`',
    '`chengdu-kuanzhai-alley`',
    '`nanjing-qinhuai-river`',
    '`guangzhou-chen-clan-academy`',
    '`suzhou-humble-administrators-garden`',
    'Never modify Journeys in this standards PR',
    'FURTHER ISOLATED AUDIT REQUIRED',
    '《不入镜》',
    'guangzhouChenClanOnePassLevels → _guangzhouLockedLevel(...)',
    '陈秀仪',
    '刘嘉禾',
    '匾额下被扣在青砖上的手机',
  ], 'Horizontal audit');
  assert.doesNotMatch(roadmap, /approved catalog remains eight/i);
  assert.doesNotMatch(roadmap, /Suzhou is not counted as Gold/i);
  const currentGuangzhouRow = roadmap
    .split('\n')
    .find((line) => line.startsWith('| `guangzhou-chen-clan-academy` | 《不入镜》 | PASS |'));
  assert.ok(currentGuangzhouRow, 'Current Guangzhou audit row must bind 《不入镜》');
  assert.doesNotMatch(
    currentGuangzhouRow,
    /梁遥|贺真|纸桥|prototype|maker|material reencoding/i,
    'Current Guangzhou rationale must not use legacy Paper Bridge evidence',
  );
});

test('canonical governance enforces a single current-main development line', () => {
  const governance = `${behavior}\n${qualityGate}\n${baseline}`;
  requiresEvery(governance, [
    'PHOENIX SINGLE-TRACK DEVELOPMENT',
    'STARTING_MAIN_SHA',
    'ACTIVE_DEVELOPMENT_BRANCH',
    'ACTIVE_DEVELOPMENT_PR',
    'REMOTE_ACTIVE_DEVELOPMENT_LINE_COUNT',
    'MULTIPLE ACTIVE DEVELOPMENT LINES — BLOCKED',
    'fetch current remote main',
    'RELATED HISTORY != CURRENT SOURCE OF TRUTH',
    'ONE JOURNEY AT A TIME',
    'ONE ACTIVE DEVELOPMENT PR AT A TIME',
    'ONE ACTIVE DEVELOPMENT BRANCH AT A TIME',
    'ONE ACTIVE DEVELOPMENT LINE',
    'NO SILENT PRODUCT REPLACEMENT',
    'ABSENCE OF AUTHORIZATION = PRESERVE CURRENT MAIN',
    'PROTECTED BASELINE MANIFEST',
    'FILE EXISTS != ACTIVE PRODUCT',
    'ACTIVE RUNTIME',
    'ACTIVE RESOLVER',
    'ACTIVE BINDING',
    'CURRENT MAIN',
    'Founder approval remains SHA-bound',
  ], 'Single-track governance');
});
