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
const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);

test('compact and full narration controls expose live follow status', () => {
  assert.match(speed, /NarrationFollowStatus/);
  assert.match(speed, /narration-controls-with-follow-status/);
  assert.match(speed, /compact-narration-controls-with-follow-status/);
  assert.match(speed, /narration-control-row/);
  assert.match(speed, /narration-speed-group/);
});

test('follow status reports paragraph, word, pause, completion, and error', () => {
  assert.match(follow, /controller\.currentItemLabel/);
  assert.match(follow, /controller\.highlightSnapshot/);
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

test('current sentence guidance changes only at sentence boundaries', () => {
  assert.match(follow, /String narrationSentenceAtOffset/);
  assert.match(follow, /。！？!\?；;/);
  assert.match(follow, /sentenceSource/);
  assert.match(follow, /currentItemLocalOffset/);
  assert.match(follow, /narration-sentence-guide-/);
  assert.match(follow, /BoxConstraints\(maxWidth:\s*246\)/);
  assert.match(follow, /maxLines:\s*2/);
  assert.match(follow, /backgroundColor:\s*activeColor/);
});

test('shadowing remains reachable when narration is unavailable', () => {
  assert.match(controller, /String\? get currentItemText/);
  assert.match(controller, /int get currentItemLocalOffset/);
  assert.match(follow, /controller\.currentItemText/);
  assert.match(follow, /controller\.currentItemLocalOffset/);
  assert.match(follow, /showSentenceGuide = currentSentence\.isNotEmpty/);
});
