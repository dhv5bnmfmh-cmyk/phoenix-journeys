import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('Story and Discovery show position with text-only highlights', () => {
  assert.doesNotMatch(journey, /_NowReadingStrip/);
  assert.equal(
    (journey.match(
      /highlightStart:\s*isActive\s*\?\s*snapshot!\.start\s*:\s*null/g,
    ) ?? []).length,
    2,
  );
  assert.match(interactive, /reading-highlight-/);
  assert.match(interactive, /class _InlineReadingMarker/);
  assert.match(interactive, /color: const Color\(0xFFFFE7AA\)/);
  assert.doesNotMatch(
    interactive,
    /_ReadingTrianglePainter|reading-triangle-|Size\(9,\s*5\)/,
  );
});

test('no separate strip or paragraph background marks narration position', () => {
  assert.doesNotMatch(interactive, /backgroundColor: const Color\(0xFF8F1D18\)/);
  assert.doesNotMatch(journey, /const Color\(0xFFFFF2EE\)/);
});
