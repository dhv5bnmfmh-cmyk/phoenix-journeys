import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const storyText = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);
const coordinator = readFileSync(
  'app/lib/services/narration_follow_coordinator.dart',
  'utf8',
);

test('narration auto-follow is paragraph-scoped and pause-safe', () => {
  assert.match(storyText, /shouldAutoFollowNarrationItem/);
  assert.match(storyText, /status == NarrationStatus\.playing/);
  assert.match(storyText, /!wasActive \|\| sessionChanged/);
  assert.match(storyText, /Scrollable\.ensureVisible/);
  assert.match(storyText, /alignment: \.34/);
  assert.match(storyText, /Duration\(milliseconds: 360\)/);
});

test('active narration keeps geometry with text-only highlight', () => {
  const surfaceKey = storyText.indexOf('narration-follow-surface-');
  const surfaceStart = storyText.lastIndexOf('return AnimatedContainer(', surfaceKey);
  const surfaceEnd = storyText.indexOf('child: Text.rich(', surfaceKey);
  assert.ok(surfaceKey >= 0);
  assert.ok(surfaceStart >= 0);
  assert.ok(surfaceEnd > surfaceStart);

  const surface = storyText.slice(surfaceStart, surfaceEnd);
  assert.match(surface, /AnimatedContainer/);
  assert.match(
    surface,
    /padding: const EdgeInsets\.symmetric\(horizontal: 3, vertical: 2\)/,
  );
  assert.doesNotMatch(surface, /decoration:/);
  assert.doesNotMatch(surface, /BoxShadow/);
  assert.doesNotMatch(surface, /Color\(0x16FFD879\)/);
  assert.match(storyText, /Color\(0xFFFFE7AA\)/);
  assert.match(storyText, /fontWeight: FontWeight\.w900/);
});

test('manual reading temporarily suspends narration auto-follow', () => {
  assert.match(coordinator, /narrationAutoFollowManualHold/);
  assert.match(coordinator, /Expando<NarrationFollowCoordinator>/);
  assert.match(
    storyText,
    /onPointerDown: \(_\) => _suspendNarrationAutoFollow\(\)/,
  );
  assert.match(storyText, /_followCoordinator\?\.remainingHold/);
  assert.match(storyText, /HitTestBehavior\.translucent/);
});
