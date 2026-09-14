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
const contract = read('docs/PHOENIX_JOURNEY_ACCEPTANCE_CONTRACT.md');
const summerPalace = read('app/lib/data/summer_palace_journey.dart');
const forbiddenCity = read('app/lib/data/forbidden_city_journey_runtime.dart');

function requiresEvery(text, values, label) {
  for (const value of values) assert.ok(text.includes(value), `${label} must include ${value}`);
}

test('canonical standards bind Story culture and level learning without a parallel V2', () => {
  requiresEvery(narrative, ['文化知识不是背景资料，而是剧情压力','CULTURAL FACT ACTION TEST','CULTURAL KNOWLEDGE RESIDUE','Story encounter → Discovery explanation','2 / 2 / 2 / 2 / 3 / 3 / 3 / 3 / 3 / 3','LANGUAGE GRADIENT + STORY UNDERSTANDING GRADIENT + CULTURAL UNDERSTANDING GRADIENT','LEVEL SEMANTIC DELTA','NEW PHRASE != NEW UNDERSTANDING','LEVEL BACKWARD COMPLETENESS','LV10 MASTERY DELTA','MASTERY CAPSTONE','MINIMUM SUFFICIENT STORY','ACTION FIRST; TERMINOLOGY SECOND','INTERNAL QA LANGUAGE MUST NEVER LEAK TO LEARNER CONTENT','NO ENDLESS POLISH LOOP','PR HEAD SHA = Founder review Candidate SHA = Preview release SHA'], 'Narrative standard');
  assert.doesNotMatch(`${narrative}\n${creation}`, /(?:HUMAN_STORY|CULTURE|LEVEL)_STANDARD_V2/);
});

test('canonical lifecycle and matrices keep Story × Culture × Level rules actionable', () => {
  requiresEvery(creation, ['Binding Story × Culture × Level lifecycle extension','five cognitive bands','Any source commit after Founder Experience invalidates that SHA-bound approval','six-stage product architecture is unchanged'], 'Creation standard');
  requiresEvery(acceptance, ['NJ-064','NJ-068','NJ-071','NJ-072','NJ-074','NJ-080','NJ-081'], 'Acceptance matrix');
  requiresEvery(design, ['Adjacent Level Semantic Delta','Causal/relational evidence chain','Story × Culture evidence','Founder-visible QA language sweep'], 'Design matrix');
  requiresEvery(sixStage, ['The six stages remain unchanged','Five cognitive bands','Backward completeness'], 'Six-stage matrix');
  requiresEvery(behavior, ['Story × Culture × Level behavior','Green automation is never literary or Founder authority'], 'AI behavior');
});

test('current acceptance contract replaces deleted remediation-roadmap authority without weakening quality', () => {
  requiresEvery(contract, ['one acceptance entry point for every active Phoenix Journey','Speed MUST NOT remove a quality gate','Every level must be independently reviewed','Story must contain an identifiable protagonist','Discovery extends a question raised by Story','Automated structural `PASS` and human literary/semantic `PASS` are separate results','All final evidence is SHA-bound.','Fail fast, but never approve fast.'], 'Acceptance contract');
  assert.match(contract, /A new document MUST NOT restate an existing canonical rule merely to create another checklist/);
  assert.match(contract, /Historical checklists and roadmaps are non-authoritative/);
});

test('Summer Palace keeps its own trace-bearing-history engine and sourced place causality', () => {
  requiresEvery(summerPalace, ['许澄','外婆周岚','为校展拍出一张她认为不需要外婆指导的“无瑕”颐和园照片','十七孔桥桥洞金光移动时放下相机，先捡回旧照片，再用剩余光线重构画面','等了一下午的十七孔桥桥洞金光真实消失','让冬至前后十七孔桥的短暂光线、颐和园的修复历史和外婆旧照片共同制造行动压力','不复述许澄事件链','UNESCO World Heritage Centre','北京市公园管理中心'], 'Summer Palace runtime');
  assert.doesNotMatch(summerPalace, /两条路线都能走通|不再用一条线覆盖另一条/);
  requiresEvery(forbiddenCity, ['两条路线都能走通','不再用一条线覆盖另一条'], 'Forbidden City reference mechanism');
});

test('single-track governance remains binding after documentation cleanup', () => {
  const governance = `${behavior}\n${qualityGate}\n${baseline}\n${contract}`;
  requiresEvery(governance, ['PHOENIX SINGLE-TRACK DEVELOPMENT','STARTING_MAIN_SHA','ACTIVE_DEVELOPMENT_BRANCH','ACTIVE_DEVELOPMENT_PR','RELATED HISTORY != CURRENT SOURCE OF TRUTH','ONE JOURNEY AT A TIME','ONE ACTIVE DEVELOPMENT PR AT A TIME','NO SILENT PRODUCT REPLACEMENT','ABSENCE OF AUTHORIZATION = PRESERVE CURRENT MAIN','PROTECTED BASELINE MANIFEST','FILE EXISTS != ACTIVE PRODUCT','Founder approval remains SHA-bound'], 'Single-track governance');
});
