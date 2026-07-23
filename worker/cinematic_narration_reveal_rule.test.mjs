import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('narration reveal uses cinematic interpolation instead of hard cuts', () => {
  assert.match(interactive, /SingleTickerProviderStateMixin/);
  assert.match(interactive, /AnimationController/);
  assert.match(interactive, /cinematicRevealProgress/);
  assert.match(interactive, /cinematicRevealDuration/);
  assert.match(interactive, /ImageFilter\.blur/);
  assert.match(interactive, /Transform\.translate/);
  assert.match(interactive, /Curves\.easeOutCubic/);
  assert.match(interactive, /Listenable\.merge/);
});

 test('future text remains layout-stable and non-interactive', () => {
  assert.match(interactive, /color: Colors\.transparent/);
  assert.match(interactive, /interactive: false/);
  assert.match(interactive, /hidden: true/);
});
