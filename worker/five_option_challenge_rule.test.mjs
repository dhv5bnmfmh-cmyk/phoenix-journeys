import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const panel = readFileSync(
  'app/lib/widgets/journey_challenge_panel.dart',
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

test('higher-level distractors stay tied to current content', () => {
  assert.match(panel, /grammar\.segments\[grammar\.problemSegmentIndex\]/);
  assert.match(panel, /discoveryCandidate/);
  assert.match(panel, /JourneyChallengeDifficulty\.advanced/);
  assert.match(panel, /five unique options/);
  assert.match(panel, /four distractors/);
});
