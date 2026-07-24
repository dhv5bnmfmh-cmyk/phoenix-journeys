import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

// Permanent guard: narration progress must animate between speech callbacks
// while remaining light enough for iPhone Flutter Web.
test('narration reveal uses smooth lightweight cinematic interpolation', () => {
  assert.match(interactive, /SingleTickerProviderStateMixin/);
  assert.match(interactive, /AnimationController/);
  assert.match(interactive, /cinematicRevealProgress/);
  assert.match(interactive, /cinematicDepthProgress/);
  assert.match(interactive, /cinematicRevealTailLength = 6/);
  assert.match(interactive, /Color\.lerp\(paleColor, finalColor/);
  assert.match(interactive, /lerpDouble\(\.4, 1, t\)/);
  assert.match(interactive, /reading-highlight-/);
  assert.doesNotMatch(
    interactive,
    /_ReadingTrianglePainter|reading-triangle-|Size\(9,\s*5\)/,
  );
  assert.match(interactive, /cinematicRevealDuration/);
  assert.match(interactive, /clamp\(120, 420\)/);
  assert.doesNotMatch(interactive, /ImageFilter\.blur|ImageFiltered\(/);
  assert.match(interactive, /Transform\.translate/);
  assert.match(interactive, /final progress = _cinematicRevealController\.value/);
  assert.match(interactive, /Listenable\.merge/);
});

test('future text remains layout-stable and non-interactive', () => {
  assert.match(interactive, /color: Colors\.transparent/);
  assert.match(interactive, /interactive: false/);
  assert.match(interactive, /hidden: true/);
});
