import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('Story and Discovery show position only with the inline triangle', () => {
  assert.doesNotMatch(journey, /_NowReadingStrip/);
  assert.equal(
    (journey.match(
      /highlightStart:\s*isActive\s*\?\s*snapshot!\.start\s*:\s*null/g,
    ) ?? []).length,
    2,
  );
  assert.match(interactive, /reading-triangle-/);
  assert.match(interactive, /_ReadingTrianglePainter/);
});

test('no text or paragraph color change is used for narration position', () => {
  assert.doesNotMatch(interactive, /isCurrentNarrationItem[\s\S]{0,200}color:/);
  assert.doesNotMatch(interactive, /backgroundColor: const Color\(0xFF8F1D18\)/);
  assert.doesNotMatch(journey, /const Color\(0xFFFFF2EE\)/);
  assert.doesNotMatch(journey, /Icons\.graphic_eq_rounded/);
});
