import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const panel = readFileSync(
  'app/lib/widgets/journey_challenge_panel.dart',
  'utf8',
);

test('challenge hints and explanations adapt to all three levels', () => {
  assert.match(panel, /adaptiveChallengeHint/);
  assert.match(panel, /adaptiveChallengeExplanation/);
  assert.match(panel, /adaptiveChallengeMemoryTip/);
  assert.match(panel, /JourneyChallengeDifficulty\.beginner/);
  assert.match(panel, /JourneyChallengeDifficulty\.standard/);
  assert.match(panel, /JourneyChallengeDifficulty\.advanced/);
  assert.match(panel, /主题链/);
  assert.match(panel, /结构分析/);
});

test('adaptive pedagogy does not change attempts or rewards', () => {
  assert.match(panel, /attempts >= 3/);
  assert.match(panel, /1 => '金币'/);
  assert.match(panel, /2 => '银币'/);
  assert.match(panel, /_ => '铜币'/);
  assert.match(panel, /: '碎银'/);
});
