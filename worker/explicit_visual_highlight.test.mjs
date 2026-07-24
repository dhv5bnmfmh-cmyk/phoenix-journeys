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

test('Flutter verifies a real inline triangle is painted in a fixed line box', () => {
  assert.match(interactive, /class _InlineReadingMarker/);
  assert.match(interactive, /class _ReadingTrianglePainter/);
  assert.match(interactive, /size: Size\(9, 5\)/);
  assert.match(interactive, /alignment: PlaceholderAlignment\.middle/);
  assert.match(interactive, /height: fontSize \* lineHeight/);
  assert.match(interactive, /clipBehavior: Clip\.hardEdge/);
  assert.doesNotMatch(interactive, /backgroundColor: const Color\(0xFF8F1D18\)/);
  assert.match(widgetTest, /reading-triangle-visual-test/);
});
