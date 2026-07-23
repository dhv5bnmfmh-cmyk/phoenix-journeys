// Permanent Phoenix narration-progressive-reveal release rule.
import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('story and discovery reveal text from narration progress', () => {
  assert.match(journey, /int\? _narrationRevealEnd\(/);
  assert.match(journey, /contentId: 'story'[\s\S]*revealEnd: _narrationRevealEnd/);
  assert.match(journey, /contentId: 'discovery'[\s\S]*revealEnd: _narrationRevealEnd/);
  assert.match(journey, /transparentSurface: true/);
  assert.match(journey, /stableNarrationRevealEnd/);
  assert.match(journey, /controllerItemIndex: _narration\.currentItemIndex/);
  assert.match(journey, /currentOffset: _narration\.currentOffset/);
});

test('unspoken text stays layout-stable, invisible, and non-interactive', () => {
  assert.match(interactive, /final int\? revealEnd/);
  assert.match(interactive, /revealedSegmentLength\(/);
  assert.match(interactive, /color: Colors\.transparent/);
  assert.match(interactive, /interactive: false/);
  assert.match(interactive, /semanticsLabel: hidden/);
});
