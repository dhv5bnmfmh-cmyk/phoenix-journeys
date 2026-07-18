import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');

test('iOS progress watchdog starts before Safari speech is awaited', () => {
  const watchdog = controller.indexOf('unawaited(_startProgressWatchdog(sessionToken, safeOffset))');
  const speak = controller.indexOf('final result = await _tts.speak(remainingText)');
  assert.ok(watchdog >= 0 && speak > watchdog);
});

test('Story and Discovery use an inline triangle without paragraph narration highlighting', () => {
  assert.match(interactive, /_ReadingTrianglePainter/);
  assert.match(interactive, /size:\s*Size\(6, 3\.5\)/);
  assert.doesNotMatch(journey, /Icons\.graphic_eq_rounded/);
  assert.doesNotMatch(journey, /const Color\(0xFFFFF2EE\)/);
});
