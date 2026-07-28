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

test('every challenge mode keeps five candidate answers', () => {
  assert.match(panel, /journeyChallengeOptionCount = 5/);
  assert.match(panel, /options\.length == journeyChallengeOptionCount/);
  assert.match(panel, /while \(options\.length < journeyChallengeOptionCount\)/);
  assert.match(panel, /index < journeyChallengeOptionCount/);
  assert.doesNotMatch(panel, /候选答案固定为 4 个/);
  assert.doesNotMatch(panel, /_fourOptions/);
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
  assert.match(panel, /五个长度接近的修改方案/);
  assert.match(panel, /五个长度接近的答案/);

  assert.match(balancer, /correctSet\.contains\(value\)/);
  assert.match(balancer, /uniqueCandidates\.contains\(value\)/);
  assert.match(balancer, /challengeTextLength/);
  assert.match(balancer, /Challenge requires \$count unique distractors/);
});

test('option cards share a visual height floor without truncating answers', () => {
  assert.match(panel, /BoxConstraints\(minHeight: 56\)/);
  assert.doesNotMatch(panel, /maxLines: 1,[\s\S]{0,120}option\.text/);
});
