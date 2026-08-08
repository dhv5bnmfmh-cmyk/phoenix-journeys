import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const widgetTest = readFileSync(
  'app/test/widgets/interactive_story_text_visual_test.dart',
  'utf8',
);

test('position derives from playback and is passed to shared Story and Discovery', () => {
  assert.match(controller, /NarrationHighlightSnapshot\? get highlightSnapshot \{/);
  assert.match(interactive, /final int\? highlightStart/);
  const highlightBindings = journey.match(
    /highlightStart:\s*isActive\s*\?\s*snapshot!\.start\s*:\s*null/g,
  ) ?? [];
  assert.equal(
    highlightBindings.length,
    2,
    'shared Story and Discovery must each bind visible text to narration position exactly once',
  );
  assert.doesNotMatch(
    journey,
    /Widget _forbiddenCityStoryPage|forbidden-city-story-segment/,
    'Forbidden City must not restore a parallel Story highlight renderer',
  );
});

test('Flutter verifies active narration highlight without triangles', () => {
  assert.match(interactive, /class _InlineReadingMarker/);
  assert.match(interactive, /reading-highlight-/);
  assert.match(interactive, /alignment: PlaceholderAlignment\.middle/);
  assert.doesNotMatch(
    interactive,
    /_ReadingTrianglePainter|reading-triangle-|Size\(9,\s*5\)/,
  );
  assert.match(widgetTest, /reading-highlight-visual-test/);
  assert.doesNotMatch(widgetTest, /reading-triangle-/);
});
