import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const player = readFileSync('app/lib/widgets/narration_player_card.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('Safari progress watchdog is scheduled before speak', () => {
  const watchdog = controller.indexOf('unawaited(_startProgressWatchdog(sessionToken, safeOffset))');
  const speak = controller.indexOf('final result = await _tts.speak(remainingText)');
  assert.ok(watchdog >= 0 && speak > watchdog);
});

test('Story and Discovery use text-only narration highlights', () => {
  assert.match(interactive, /class _InlineReadingMarker/);
  assert.match(interactive, /reading-highlight-/);
  assert.match(interactive, /alignment: PlaceholderAlignment\.middle/);
  assert.match(interactive, /color: const Color\(0xFFFFE7AA\)/);
  assert.doesNotMatch(
    interactive,
    /_ReadingTrianglePainter|reading-triangle-|Size\(9,\s*5\)/,
  );
  assert.equal((journey.match(/InteractiveStoryText\(/g) ?? []).length >= 2, true);
  assert.match(journey, /contentId: 'story'/);
  assert.match(journey, /contentId: 'discovery'/);
});

test('playing percent never appears stuck at zero', () => {
  assert.match(
    player,
    /final percent\s*=\s*isPlaying[\s\S]*roundedPercent\.clamp\(1, 99\)/,
  );
});
