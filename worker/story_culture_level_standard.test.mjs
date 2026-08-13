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
const dailyCatalog = read('app/lib/data/daily_journey_catalog.dart');
const extendedCatalog = read('app/lib/data/extended_journey_catalog.dart');
const expansionCatalog = read('app/lib/data/journey_expansion_catalog.dart');
const summerPalace = read('app/lib/data/summer_palace_journey.dart');
const forbiddenCity = read('app/lib/data/forbidden_city_journey_runtime.dart');
const shanghai = read('app/lib/data/shanghai_bund_one_pass.dart');
const chengdu = read('app/lib/data/chengdu_kuanzhai_one_pass.dart');
const hangzhou = read('app/lib/data/hangzhou_west_lake_one_pass.dart');
const guangzhou = read('app/lib/data/guangzhou_chen_clan_one_pass.dart');
const nanjing = read('app/lib/data/nanjing_qinhuai_one_pass.dart');

function requiresEvery(text, values, label) {
  for (const value of values) {
    assert.ok(text.includes(value), `${label} must include ${value}`);
  }
}

function capture(text, pattern, label) {
  const match = text.match(pattern);
  assert.ok(match, `Unable to resolve current runtime ${label}`);
  return match[1];
}

function experienceTitle(text, idExpression) {
  const escaped = idExpression.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return capture(
    text,
    new RegExp(`id: ${escaped},[\\s\\S]*?storyTitle: '([^']+)'`),
    `${idExpression} Story title`,
  );
}

function identityRow(journeyId) {
  const proof = roadmap.split('## Horizontal Gold audit matrix')[0];
  const row = proof.split('\n').find((line) => line.startsWith(`| \`${journeyId}\` |`));
  assert.ok(row, `Active identity proof must include ${journeyId}`);
  return row;
}

function identityFields(journeyId) {
  const fields = identityRow(journeyId).split('|').slice(1, -1).map((value) => value.trim());
  assert.equal(fields.length, 11, `${journeyId} identity proof must preserve all eleven fields`);
  return {
    story: fields[1],
    source: fields[2],
    protagonistRelationship: fields[3],
    goal: fields[4],
    conflict: fields[5],
    choice: fields[6],
    cost: fields[7],
    memory: fields[8],
    ending: fields[9],
    verified: fields[10],
  };
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

test('all nine active identity proofs use current runtime titles and remain field-complete', () => {
  const currentTitles = new Map([
    ['beijing-summer-palace', experienceTitle(summerPalace, 'summerPalaceJourneyContent.id')],
    ['beijing-forbidden-city', experienceTitle(dailyCatalog, 'beijingForbiddenCityJourney.id')],
    ['shanghai-bund', experienceTitle(dailyCatalog, 'shanghaiBundJourney.id')],
    ['xian-city-wall', experienceTitle(dailyCatalog, 'xianCityWallJourney.id')],
    ['hangzhou-west-lake', experienceTitle(extendedCatalog, 'hangzhouWestLakeJourney.id')],
    ['chengdu-kuanzhai-alley', experienceTitle(extendedCatalog, 'chengduKuanzhaiJourney.id')],
    [
      'nanjing-qinhuai-river',
      capture(nanjing, /const nanjingQinhuaiCanonicalTitle = '([^']+)'/, 'Nanjing canonical title'),
    ],
    ['guangzhou-chen-clan-academy', experienceTitle(extendedCatalog, 'guangzhouChenClanJourney.id')],
    ['suzhou-humble-administrators-garden', experienceTitle(expansionCatalog, 'suzhouGardenJourney.id')],
  ]);

  for (const [journeyId, title] of currentTitles) {
    const row = identityRow(journeyId);
    assert.ok(row.includes(`| 《${title}》 |`), `${journeyId} must use current Story title 《${title}》`);
    assert.match(row, /\| PASS \|$/, `${journeyId} identity proof must be complete before PASS`);
  }
});

test('Hangzhou, Guangzhou, and Nanjing identity fields match canonical package metadata', () => {
  const hangzhouGoal = capture(
    hangzhou,
    /final hangzhouWestLakeReopenedRemediation[\s\S]*?goal: '([^']+)'/,
    'Hangzhou goal',
  );
  const hangzhouRow = identityRow('hangzhou-west-lake');
  requiresEvery(hangzhouRow, [
    '方毓 ↔ 结婚四十三年的丈夫周绍庭（夫妻）',
    hangzhouGoal,
    'hangzhouWestLakeReopenedLevels',
    'hangzhouWestLakeReopenedRemediation',
  ], 'Hangzhou active identity');
  assert.doesNotMatch(hangzhouRow, /父亲/, 'Hangzhou current identity must not invent a father relationship');

  const guangzhouGoal = capture(
    guangzhou,
    /final guangzhouChenClanRemediatedJourney[\s\S]*?goal: '([^']+)'/,
    'Guangzhou goal',
  );
  const guangzhouRow = identityRow('guangzhou-chen-clan-academy');
  requiresEvery(guangzhouRow, [
    '陈秀仪 ↔ 成年亲生女儿刘嘉禾',
    '亲生母女',
    guangzhouGoal,
    'guangzhouChenClanOnePassLevels → _guangzhouLockedLevel(...)',
    'guangzhouChenClanRemediatedJourney',
  ], 'Guangzhou active identity');
  assert.doesNotMatch(guangzhouRow, /同伴/, 'Guangzhou biological mother-daughter relationship must not be weakened');

  const nanjingTitle = capture(
    nanjing,
    /const nanjingQinhuaiCanonicalTitle = '([^']+)'/,
    'Nanjing canonical title',
  );
  const nanjingMemory = capture(
    nanjing,
    /const nanjingQinhuaiMemoryAnchor = '([^']+)'/,
    'Nanjing memory anchor',
  );
  const nanjingRow = identityRow('nanjing-qinhuai-river');
  assert.ok(nanjingRow.includes(`| 《${nanjingTitle}》 |`));
  assert.ok(nanjingRow.includes(`| ${nanjingMemory} |`));
  assert.notEqual(nanjingTitle, nanjingMemory, 'Nanjing Story title and Memory Anchor must stay distinct');
  requiresEvery(roadmap, [
    '`STORY TITLE`',
    '`HEADLINE`',
    '`DESCRIPTION`',
    '`MEMORY ANCHOR`',
  ], 'Identity field separation rule');
});

test('Forbidden City and Shanghai keep initial Goal separate from enacted Choice', () => {
  requiresEvery(forbiddenCity, [
    '想做一张能解释宫城空间的学习图',
    '一张好图应该有一条明确主线',
    '两条路线都来自真实的行动',
    '不选一条覆盖另一条',
    forbiddenCity.match(/const forbiddenCityMemoryAnchor = '([^']+)'/)[1],
  ], 'Forbidden City active runtime');
  const forbiddenFields = identityFields('beijing-forbidden-city');
  requiresEvery(forbiddenFields.goal, [
    '建筑怎样组织人的移动',
    '可读的宫城学习图',
    '一条明确主线',
  ], 'Forbidden City Goal');
  assert.notEqual(forbiddenFields.goal, forbiddenFields.choice);
  assert.doesNotMatch(forbiddenFields.goal, /^保留两条都成立的路线$/);
  requiresEvery(forbiddenFields.choice, ['不选一条覆盖另一条', '不同线型保留'], 'Forbidden City Choice');

  const shanghaiGoal = capture(
    shanghai,
    /final shanghaiBundOnePassRemediation[\s\S]*?goal: '([^']+)'/,
    'Shanghai goal',
  );
  const shanghaiConflict = capture(
    shanghai,
    /final shanghaiBundOnePassRemediation[\s\S]*?conflict: '([^']+)'/,
    'Shanghai conflict',
  );
  const shanghaiFields = identityFields('shanghai-bund');
  assert.equal(shanghaiFields.goal, shanghaiGoal);
  assert.equal(shanghaiFields.conflict, shanghaiConflict);
  assert.doesNotMatch(shanghaiFields.goal, /^把旧提单带过江$/);
  requiresEvery(shanghaiFields.choice, ['旧提单', '电脑包', '上船', '新职业'], 'Shanghai Choice');
  assert.match(shanghaiFields.cost, /identity \/ certainty cost/);
  assert.doesNotMatch(shanghaiFields.cost, /承担文件与记忆的重量/);
});

test('Chengdu and Suzhou identity proof follows active action evidence without invented motives', () => {
  const chengduGoal = capture(
    chengdu,
    /final chengduKuanzhaiOnePassRemediation[\s\S]*?goal: '([^']+)'/,
    'Chengdu goal',
  );
  const chengduConflict = capture(
    chengdu,
    /final chengduKuanzhaiOnePassRemediation[\s\S]*?conflict: '([^']+)'/,
    'Chengdu conflict',
  );
  requiresEvery(chengdu, [
    '林夏还没起身，周叔已经把椅子移开',
    '人过去后，他又把它放回茶桌边',
    '谁先看见下一次需要，谁就先动手',
    '没有再伸手',
  ], 'Chengdu active Story');
  const chengduFields = identityFields('chengdu-kuanzhai-alley');
  assert.equal(chengduFields.goal, chengduGoal);
  assert.equal(chengduFields.conflict, chengduConflict);
  requiresEvery(chengduFields.choice, ['通行', '移椅', '通道清空', '茶桌'], 'Chengdu Choice');
  requiresEvery(chengduFields.memory, ['林夏还没起身', '周叔', '放回茶桌旁'], 'Chengdu Memory Moment');
  assert.doesNotMatch(chengduFields.goal + chengduFields.conflict + chengduFields.cost, /私人记忆|独占纪念物|该留下给谁/);

  requiresEvery(expansionCatalog, [
    '下周一，十二岁的程朗要开始自己坐车去初中',
    '今天让我走前面吧，我在下一处等你',
    '陈玉兰抬起手',
    '却没有喊',
    '陈玉兰没有追上去',
  ], 'Suzhou active Story');
  const suzhouFields = identityFields('suzhou-humble-administrators-garden');
  requiresEvery(suzhouFields.goal, ['独立通勤', '让他走在前面', '不再因暂时看不见他就把他叫回来'], 'Suzhou Goal');
  requiresEvery(suzhouFields.choice, ['第二次', '抬起手', '没有喊'], 'Suzhou Choice');
  requiresEvery(suzhouFields.ending, ['背影很快又被房屋挡住', '陈玉兰没有追上去'], 'Suzhou Ending');
  assert.doesNotMatch(suzhouFields.goal, /确认孩子仍会回望与等待/);
});

test('all nine proofs keep Goal, Choice, Memory, and Ending as distinct complete fields', () => {
  const journeyIds = [
    'beijing-summer-palace',
    'beijing-forbidden-city',
    'shanghai-bund',
    'xian-city-wall',
    'hangzhou-west-lake',
    'chengdu-kuanzhai-alley',
    'nanjing-qinhuai-river',
    'guangzhou-chen-clan-academy',
    'suzhou-humble-administrators-garden',
  ];
  for (const journeyId of journeyIds) {
    const fields = identityFields(journeyId);
    for (const key of ['goal', 'conflict', 'choice', 'cost', 'memory', 'ending']) {
      assert.ok(fields[key].length > 0, `${journeyId} ${key} must be explicit`);
    }
    assert.notEqual(fields.goal, fields.choice, `${journeyId} Goal must not equal Choice`);
    assert.notEqual(fields.story, fields.memory, `${journeyId} Story title must not equal Memory Moment`);
    assert.notEqual(fields.choice, fields.ending, `${journeyId} Choice must not equal Ending`);
    assert.equal(fields.verified, 'PASS');
  }
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
