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
