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

test('Story and Discovery use an inline triangle rather than recoloring text', () => {
  assert.match(interactive, /class _ReadingTrianglePainter/);
  assert.match(interactive, /reading-triangle-/);
  assert.match(interactive, /size:\s*Size\(6, 3\.5\)/);
  assert.doesNotMatch(interactive, /backgroundColor: const Color\(0xFF8F1D18\)/);
  assert.equal((journey.match(/InteractiveStoryText\(/g) ?? []).length >= 2, true);
  assert.match(journey, /contentId: 'story'/);
  assert.match(journey, /contentId: 'discovery'/);
});

test('playing percent never appears stuck at zero', () => {
  assert.match(player, /final percent = isPlaying[\s\S]*roundedPercent\.clamp\(1, 99\)/);
});
