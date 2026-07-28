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


test('regular journeys use destination-specific grammar repairs', () => {
  const expectedRepairs = new Map([
    ['beijing-forbidden-city', '午门不但规定进入路线'],
    ['beijing-summer-palace', '由于昆明湖产生倒影'],
    ['shanghai-bund', '外滩不仅保存历史建筑'],
    ['xian-city-wall', '通过登上城墙'],
    ['hangzhou-west-lake', '只有天气和季节发生变化'],
    ['chengdu-kuanzhai-alley', '各不相同不一样'],
    ['nanjing-qinhuai-river', '在古代即将已经'],
    ['guangzhou-chen-clan-academy', '通过观察屋脊陶塑'],
  ]);

  for (const [journeyId, sentenceMarker] of expectedRepairs) {
    assert.ok(panel.includes(`'${journeyId}' => const _GrammarSpec(`));
    assert.ok(panel.includes(sentenceMarker));
  }
});
