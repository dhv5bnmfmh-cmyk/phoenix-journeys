import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const widgetTest = readFileSync(
  'app/test/widgets/interactive_story_text_visual_test.dart',
  'utf8',
);

test('highlight derives from current playback position and is passed explicitly', () => {
  assert.match(controller, /NarrationHighlightSnapshot\? get highlightSnapshot \{/);
  assert.match(interactive, /final int\? highlightStart/);
  assert.match(interactive, /hasExplicitHighlight/);
  assert.equal((journey.match(/highlightStart: isActive \? snapshot!\.start : null/g) ?? []).length, 2);
});

test('Flutter verifies an actual yellow TextSpan is painted', () => {
  assert.match(widgetTest, /backgroundColor == const Color\(0xFFFFD05A\)/);
  assert.match(widgetTest, /_containsYellowHighlight\(text\.textSpan!\)/);
});
