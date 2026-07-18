from pathlib import Path
import re

controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()
old = '''      await _tts.setVolume(1.0);
      final speakFuture = _tts.speak(remainingText);
      unawaited(_startProgressWatchdog(sessionToken, safeOffset));
      final result = await speakFuture;
'''
new = '''      await _tts.setVolume(1.0);
      // Start Phoenix's progress clock before invoking Safari speech. On iOS,
      // the web TTS call itself can remain pending until the utterance ends.
      // Scheduling after it would leave progress and the inline marker at 0%.
      unawaited(_startProgressWatchdog(sessionToken, safeOffset));
      final result = await _tts.speak(remainingText);
'''
if old not in controller:
    raise SystemExit('speech watchdog order block not found')
controller = controller.replace(old, new, 1)
controller_path.write_text(controller)

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()
journey = journey.replace(
'''        color: active
            ? const Color(0xFFFFF2EE)
            : Colors.white.withValues(alpha: .94),''',
'''        color: Colors.white.withValues(alpha: .94),''',
1,
)
journey = journey.replace(
'''          color: active
              ? PhoenixTheme.red
              : PhoenixTheme.gold.withValues(alpha: .22),
          width: active ? 1.5 : 1,''',
'''          color: PhoenixTheme.gold.withValues(alpha: .22),
          width: 1,''',
1,
)
journey = re.sub(
    r'''        boxShadow: active\n            \? const \[\n                BoxShadow\([\s\S]*?\n              \]\n            : null,''',
    '        boxShadow: null,',
    journey,
    count=1,
)
journey = journey.replace(
'''              backgroundColor: active
                  ? PhoenixTheme.red
                  : PhoenixTheme.gold.withValues(alpha: .18),
              child: active
                  ? const Icon(
                      Icons.graphic_eq_rounded,
                      size: 10,
                      color: Colors.white,
                    )
                  : Text(
                      '$index',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),''',
'''              backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
              child: Text(
                '$index',
                style: const TextStyle(
                  color: PhoenixTheme.red,
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                ),
              ),''',
1,
)
journey_path.write_text(journey)

interactive_path = Path('app/lib/widgets/interactive_story_text.dart')
interactive = interactive_path.read_text()
interactive = interactive.replace(
'''        const CustomPaint(size: Size(7, 4), painter: _ReadingTrianglePainter()),''',
'''        const CustomPaint(size: Size(6, 3.5), painter: _ReadingTrianglePainter()),''',
1,
)
interactive_path.write_text(interactive)

Path('worker/triangle_reading_marker.test.mjs').write_text('''import test from 'node:test';
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
  assert.match(interactive, /CustomPaint\(size: Size\(6, 3\.5\)/);
  assert.doesNotMatch(journey, /Icons\.graphic_eq_rounded/);
  assert.doesNotMatch(journey, /const Color\(0xFFFFF2EE\)/);
});
''')
