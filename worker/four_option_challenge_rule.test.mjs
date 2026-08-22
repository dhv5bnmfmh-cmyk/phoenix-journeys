import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const panel = readFileSync(
  'app/lib/widgets/journey_challenge_panel_legacy.dart',
  'utf8',
);

const balancer = readFileSync(
  'app/lib/services/challenge_option_balancer.dart',
  'utf8',
);

test('every challenge mode keeps four candidate answers', () => {
  assert.match(panel, /journeyChallengeOptionCount = 4/);
  assert.match(panel, /options\.length == journeyChallengeOptionCount/);
  assert.match(panel, /while \(options\.length < journeyChallengeOptionCount\)/);
  assert.match(panel, /index < journeyChallengeOptionCount/);
});

test('all challenge modes use unique length-balanced distractors', () => {
  assert.match(panel, /challenge_option_balancer\.dart/);
  assert.match(panel, /List<String> _goldDistractors\(/);
  assert.equal(
    (panel.match(/selectBalancedChallengeDistractors\(/g) ?? []).length,
    4,
  );
  assert.match(panel, /grammar\.segments\[grammar\.problemSegmentIndex\]/);
  assert.match(panel, /discoveryCandidate/);
  assert.match(panel, /JourneyChallengeDifficulty\.advanced/);
  assert.match(panel, /四个长度接近的修改方案/);
  assert.match(panel, /四个长度接近的答案/);

  assert.match(balancer, /correctSet\.contains\(value\)/);
  assert.match(balancer, /uniqueCandidates\.contains\(value\)/);
  assert.match(balancer, /challengeTextLength/);
  assert.match(balancer, /challengeKeywordOverlap/);
  assert.match(balancer, /_distractorPlausibilityScore/);
  assert.match(balancer, /idealOverlap = \.5/);
  assert.match(balancer, /Challenge requires \$count unique distractors/);
});

test('option cards share a visual height floor without truncating answers', () => {
  assert.match(panel, /BoxConstraints\(minHeight: 56\)/);
  assert.doesNotMatch(panel, /maxLines: 1,[\s\S]{0,120}option\.text/);
});

test('regular journeys never fall back to generic challenge filler', () => {
  assert.match(panel, /_regularJourneyDistractors\(journeyId\)/);
  for (const journeyId of [
    'beijing-summer-palace',
    'shanghai-bund',
    'xian-city-wall',
    'hangzhou-west-lake',
    'chengdu-kuanzhai-alley',
    'nanjing-qinhuai-river',
    'guangzhou-chen-clan-academy',
  ]) {
    assert.ok(panel.includes(`'${journeyId}' => [`));
  }
  assert.doesNotMatch(panel, /所有景色完全相同，不需要继续观察/);
  assert.doesNotMatch(panel, /他没有进入景区，直接回到了住处/);
});


test('all journey grammar repairs stay theme-specific at every level', () => {
  assert.match(panel, /_adaptiveGrammarForJourney\(journeyId, difficulty\)/);
  assert.match(panel, /JourneyChallengeDifficulty\.beginner => _GrammarSpec/);
  assert.match(panel, /JourneyChallengeDifficulty\.standard => _GrammarSpec/);
  assert.match(panel, /JourneyChallengeDifficulty\.advanced => _GrammarSpec/);

  for (const journeyId of [
    'beijing-summer-palace',
    'shanghai-bund',
    'xian-city-wall',
    'hangzhou-west-lake',
    'chengdu-kuanzhai-alley',
    'nanjing-qinhuai-river',
    'guangzhou-chen-clan-academy',
    'suzhou-humble-administrators-garden',
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  ]) {
    assert.ok(panel.includes(`'${journeyId}'`));
  }

  for (const destinationMarker of [
    '冬至前后十七孔桥的金光',
    '外滩与浦东两岸',
    '城墙和护城河',
    '断桥残雪、湿石阶和预约卡',
    '宽、窄、井三条巷子',
    '秦淮河的桥梁与灯影',
    '共同兴建与陈氏书院匾额',
    '长廊转弯、曲桥和池水',
    '蓝色蝴蝶和竹林梦境',
    '月宫遗简和守匣白兔',
    '无影夜客和门外呼声',
    '逆流河灯和灯纸姓名',
  ]) {
    assert.ok(panel.includes(destinationMarker));
  }
});


test('grammar replays never leave the selected journey theme', () => {
  assert.match(panel, /return journeySpec;/);
  assert.doesNotMatch(panel, /final variedSpecs = <_GrammarSpec>/);
  for (const genericReplay of [
    '探索者大约走了一个小时左右',
    '古老的钟声被探索者听见了',
    '端详它的声音',
    '那扇门在三百年前即将已经关闭',
    '认真地几乎读完了整封遗简',
  ]) {
    assert.ok(!panel.includes(genericReplay));
  }
});


test('challenge cards explain the active level and training goal', () => {
  assert.match(panel, /challenge-difficulty-\${_session\.difficulty\.name}/);
  assert.match(panel, /难度 · \${_session\.difficultyLabel}/);
  assert.match(panel, /challenge-training-goal/);
  assert.match(panel, /训练目标 · \${_session\.trainingGoal}/);
  for (const level of ['初级', '标准', '高级']) {
    assert.ok(panel.includes(`=> '${level}'`));
  }
  for (const goal of [
    '辨认地点、行动与结果顺序',
    '检查搭配、语序与句式平行',
    '保持主题链、指代与因果连续',
  ]) {
    assert.ok(panel.includes(goal));
  }
});


test('challenge explanations turn attempts into mastery feedback', () => {
  assert.match(panel, /challenge-mastery-summary/);
  assert.match(panel, /String get masteryLabel/);
  assert.match(panel, /String get masteryAdvice/);
  for (const state of ['已掌握', '基本掌握', '正在巩固', '需要复习']) {
    assert.ok(panel.includes(state));
  }
  assert.match(panel, /掌握情况 · \${_session\.masteryLabel}/);
  assert.match(panel, /训练目标 · \${_session\.trainingGoal}/);
  assert.match(panel, /if \(!correct\) return '需要复习'/);
});


test('the final challenge dialog summarizes all three abilities', () => {
  assert.match(panel, /challenge-journey-mastery-summary/);
  assert.match(panel, /旅程学习总结 · \$headline/);
  assert.match(panel, /challenge-summary-\${session\.type\.name}/);
  assert.match(panel, /三项能力已掌握/);
  assert.match(panel, /三项挑战已完成/);
  assert.match(panel, /重点复习\${weakest\.typeLabel}/);
  assert.match(panel, /if \(showJourneySummary\)/);
});


test('explorers can replay the weakest mode without earning twice', () => {
  assert.match(panel, /challenge-replay-weakest/);
  assert.match(panel, /再练重点项/);
  assert.match(panel, /int get _weakestSessionIndex/);
  assert.match(panel, /void _restartWeakestMode\(\)/);
  assert.match(panel, /_focusedReplayActive = true/);
  assert.match(panel, /if \(_rewardedModes\.add\(_activeIndex\)\)/);
  assert.match(panel, /if \(replayWeakest\)/);
  assert.match(panel, /_restartWeakestMode\(\)/);
});
