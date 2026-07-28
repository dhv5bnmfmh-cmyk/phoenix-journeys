import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const panel = readFileSync(
  'app/lib/widgets/journey_challenge_panel.dart',
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
  assert.equal(
    (panel.match(/selectBalancedChallengeDistractors\(/g) ?? []).length,
    3,
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
    'beijing-forbidden-city',
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
    'beijing-forbidden-city',
    'beijing-summer-palace',
    'shanghai-bund',
    'xian-city-wall',
    'hangzhou-west-lake',
    'chengdu-kuanzhai-alley',
    'nanjing-qinhuai-river',
    'guangzhou-chen-clan-academy',
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  ]) {
    assert.ok(panel.includes(`'${journeyId}'`));
  }

  for (const destinationMarker of [
    '午门和中轴线',
    '昆明湖的倒影',
    '外滩与浦东两岸',
    '城墙和护城河',
    '苏堤、桥与远山',
    '宽、窄、井三条巷子',
    '秦淮河的桥梁与灯影',
    '屋脊陶塑和木石雕刻',
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
