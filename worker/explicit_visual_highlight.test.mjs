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

test('position derives from playback and is passed to Story and Discovery', () => {
  assert.match(controller, /NarrationHighlightSnapshot\? get highlightSnapshot \{/);
  assert.match(interactive, /final int\? highlightStart/);
  assert.equal(
    (journey.match(
      /highlightStart:\s*isActive\s*\?\s*snapshot!\.start\s*:\s*null/g,
    ) ?? []).length,
    2,
  );
});

test('Flutter verifies active narration uses gold text without triangles', () => {
  assert.match(interactive, /class _InlineReadingMarker/);
  assert.match(interactive, /reading-highlight-/);
  assert.match(interactive, /alignment: PlaceholderAlignment\.middle/);
  assert.doesNotMatch(
    interactive,
    /_ReadingTrianglePainter|reading-triangle-|Size\(9,\s*5\)/,
  );
  assert.match(widgetTest, /reading-highlight-visual-test/);
  assert.match(widgetTest, /highlightedText\.style\?\.color/);
  assert.match(widgetTest, /Color\(0xFFFFE7AA\)/);
});
