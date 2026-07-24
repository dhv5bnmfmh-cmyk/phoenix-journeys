import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');

test('narration reveal uses one monotonic linear cursor', () => {
  assert.match(interactive, /AnimationController\.unbounded/);
  assert.match(interactive, /_lastAcceptedRevealCursor/);
  assert.match(interactive, /animateTo\(/);
  assert.match(interactive, /curve: Curves\.linear/);
  assert.match(interactive, /narrationSessionToken/);
  assert.doesNotMatch(interactive, /_revealFrom|_revealTo/);
  assert.match(interactive, /clamp\(160, 700\)/);
});

test('frontier characters stay lightweight on iPhone Flutter Web', () => {
  assert.match(interactive, /TextSpan _cinematicFrontierSpan/);
  assert.match(interactive, /lerpDouble\(\.35, 1, t\)/);
  assert.doesNotMatch(interactive, /_CinematicRevealGlyph/);
  assert.doesNotMatch(interactive, /ImageFilter\.blur|ImageFiltered\(/);
  assert.doesNotMatch(interactive, /reading-triangle-|_ReadingTrianglePainter/);
});

test('future text remains layout-stable and non-interactive', () => {
  assert.match(interactive, /color: Colors\.transparent/);
  assert.match(interactive, /interactive: false/);
  assert.match(interactive, /hidden: true/);
});
