import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const follow = readFileSync(
  'app/lib/widgets/narration_follow_status.dart',
  'utf8',
);
const speed = readFileSync(
  'app/lib/widgets/narration_speed_stepper.dart',
  'utf8',
);

test('non-compact narration controls expose a separate live follow status', () => {
  assert.match(speed, /NarrationFollowStatus/);
  assert.match(speed, /narration-controls-with-follow-status/);
  assert.match(speed, /compact\s*\?\s*controls/);
  assert.match(speed, /narration-control-row/);
  assert.match(speed, /narration-speed-group/);
});

test('follow status reports paragraph, word, pause, completion, and error', () => {
  assert.match(follow, /controller\.currentItemLabel/);
  assert.match(follow, /controller\.highlightSnapshot\?\.word/);
  assert.match(follow, /跟读中/);
  assert.match(follow, /已暂停/);
  assert.match(follow, /本次朗读完成/);
  assert.match(follow, /朗读暂不可用/);
});

test('follow status is animated, bounded, and accessible', () => {
  assert.match(follow, /Semantics\(/);
  assert.match(follow, /liveRegion:\s*true/);
  assert.match(follow, /AnimatedContainer/);
  assert.match(follow, /AnimatedSwitcher/);
  assert.match(follow, /TweenAnimationBuilder<double>/);
  assert.match(follow, /BoxConstraints\(maxWidth:\s*154\)/);
});
