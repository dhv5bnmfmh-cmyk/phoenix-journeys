from pathlib import Path

controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()
old = '''      final speakFuture = _tts.speak(remainingText);
      unawaited(_startProgressWatchdog(sessionToken, safeOffset));
      final result = await speakFuture;
'''
new = '''      // Schedule Phoenix progress before invoking Safari. On iOS Web the
      // speak() call can hold the Dart continuation until the utterance ends.
      // Starting the watchdog first keeps percentage and the triangle marker
      // moving while audio is audible.
      unawaited(_startProgressWatchdog(sessionToken, safeOffset));
      final result = await _tts.speak(remainingText);
'''
if old not in controller:
    raise SystemExit('speak/watchdog order marker not found')
controller_path.write_text(controller.replace(old, new, 1))

player_path = Path('app/lib/widgets/narration_player_card.dart')
player = player_path.read_text()
old_percent = '''        final percent = (progress * 100).round();
'''
new_percent = '''        final rawPercent = (progress * 100).round();
        final percent = isPlaying ? rawPercent.clamp(1, 99) : rawPercent;
'''
if old_percent not in player:
    raise SystemExit('player percent marker not found')
player_path.write_text(player.replace(old_percent, new_percent, 1))

worker_test = Path('worker/triangle_progress_rule.test.mjs')
worker_test.write_text('''import test from 'node:test';
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

test('active narration uses an inline triangle rather than recoloring text', () => {
  assert.match(interactive, /class _ReadingTrianglePainter/);
  assert.match(interactive, /reading-triangle-/);
  assert.match(interactive, /CustomPaint\(size: Size\(7, 4\)/);
  assert.doesNotMatch(interactive, /backgroundColor: const Color\(0xFF8F1D18\)/);
  assert.equal((journey.match(/InteractiveStoryText\(/g) ?? []).length >= 2, true);
});

test('playing percent never appears stuck at zero', () => {
  assert.match(player, /final percent = isPlaying \? rawPercent\.clamp\(1, 99\) : rawPercent/);
});
''')
