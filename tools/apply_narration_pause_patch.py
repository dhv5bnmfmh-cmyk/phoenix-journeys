from pathlib import Path
import re

PLAYER = Path('app/lib/widgets/narration_player_card.dart')
UNIT_TEST = Path('app/test/narration_resume_offset_test.dart')
RULE_TEST = Path('worker/ios_narration_position_rule.test.mjs')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise RuntimeError(f'missing replacement target: {label}')
    return text.replace(old, new, 1)


player = PLAYER.read_text(encoding='utf-8')
player = replace_once(
    player,
    "  int _lastObservedOffset = 0;\n"
    "  int _clockAnchorOffset = 0;\n"
    "  DateTime? _clockAnchorTime;\n"
    "  Timer? _continuationClock;\n",
    "  int _lastObservedOffset = 0;\n",
    'remove duplicate clock fields',
)
player = replace_once(
    player,
    "    _commandVersion += 1;\n"
    "    _continuationClock?.cancel();\n"
    "    super.dispose();\n",
    "    _commandVersion += 1;\n"
    "    super.dispose();\n",
    'dispose duplicate clock',
)

reset_pattern = re.compile(
    r"  void _resetLocalSession\(\) \{.*?\n  void _beginLocalPlayback\(int offset\) \{",
    re.S,
)
player, count = reset_pattern.subn(
    "  void _resetLocalSession() {\n"
    "    _sessionPlaying = false;\n"
    "    _sessionPaused = false;\n"
    "    _resumeOffset = 0;\n"
    "    _lastObservedOffset = 0;\n"
    "  }\n\n"
    "  void _beginLocalPlayback(int offset) {",
    player,
    count=1,
)
if count != 1:
    raise RuntimeError('unable to remove duplicate continuation clock methods')

player = replace_once(
    player,
    "      _lastObservedOffset = math.max(_lastObservedOffset, offset);\n"
    "    });\n"
    "    _startContinuationClock(offset);\n",
    "      _lastObservedOffset = offset;\n"
    "    });\n",
    'reset observed offset when playback begins',
)

capture_pattern = re.compile(
    r"  int _captureContinuationOffset\(\) \{.*?\n  \}\n\n  void _handleMainPressed\(\) \{",
    re.S,
)
player, count = capture_pattern.subn(
    "  int _captureContinuationOffset() {\n"
    "    if (!_controllerIsCurrent) return _resumeOffset;\n"
    "    return resolveNarrationContinuationOffset(\n"
    "      nativeOffset: widget.controller.lastNativeOffset,\n"
    "      nativeProgressIsFresh: widget.controller.hasFreshNativeProgress,\n"
    "      controllerOffset: widget.controller.currentOffset,\n"
    "      lastObservedOffset: _lastObservedOffset,\n"
    "      totalCharacters: widget.controller.totalCharacters,\n"
    "    );\n"
    "  }\n\n"
    "  void _handleMainPressed() {",
    player,
    count=1,
)
if count != 1:
    raise RuntimeError('unable to replace continuation offset capture')

player = player.replace("    _stopContinuationClock();\n", "")
player = player.replace("    if (wasPlaying) _stopContinuationClock();\n", "")
player = player.replace(
    "        _lastObservedOffset = math.max(\n"
    "          _lastObservedOffset,\n"
    "          _resumeOffset,\n"
    "        );\n",
    "        _lastObservedOffset = _resumeOffset;\n",
)
player = player.replace(
    "      _lastObservedOffset = math.max(_lastObservedOffset, offset);\n",
    "      _lastObservedOffset = offset;\n",
)
player = player.replace(
    "      _lastObservedOffset = math.max(\n"
    "        _lastObservedOffset,\n"
    "        continuedOffset,\n"
    "      );\n",
    "      _lastObservedOffset = continuedOffset;\n",
)
player = replace_once(
    player,
    "  return math.max(0, estimated - 1);\n",
    "  // When Safari has no exact word callback, resume slightly before the\n"
    "  // estimate so Phoenix never skips text after pause or a speed change.\n"
    "  return math.max(0, estimated - 2);\n",
    'conservative Safari rewind',
)

if '_continuationClock' in player or '_estimatedClockOffset' in player:
    raise RuntimeError('duplicate local continuation clock still exists')
if '_lastObservedOffset = math.max(_lastObservedOffset, offset)' in player:
    raise RuntimeError('playback still carries a future observed offset')

PLAYER.write_text(player, encoding='utf-8')

unit_test = UNIT_TEST.read_text(encoding='utf-8')
unit_test = replace_once(unit_test, '      23,\n', '      22,\n', 'Safari zero expectation')
unit_test = replace_once(unit_test, '      30,\n', '      29,\n', 'stale progress expectation')
unit_test = replace_once(unit_test, '      41,\n', '      40,\n', 'transient zero expectation')
UNIT_TEST.write_text(unit_test, encoding='utf-8')

RULE_TEST.write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('iPhone uses one narration position source', () => {
  assert.doesNotMatch(player, /_continuationClock/);
  assert.doesNotMatch(player, /_estimatedClockOffset/);
  assert.match(
    player,
    /lastObservedOffset: _lastObservedOffset/,
  );
});

test('every resumed session resets the observed offset to its start', () => {
  const start = player.indexOf('void _beginLocalPlayback');
  const end = player.indexOf('void _observeControllerOffset', start);
  const body = player.slice(start, end);

  assert.match(body, /_lastObservedOffset = offset/);
  assert.doesNotMatch(body, /math\.max\(_lastObservedOffset, offset\)/);
});

test('pause freezes and resumes from exactly one saved offset', () => {
  const pauseStart = player.indexOf('Future<void> _pauseSession');
  const pauseEnd = player.indexOf('Future<void> _resumeSession', pauseStart);
  const pause = player.slice(pauseStart, pauseEnd);

  assert.match(pause, /final offset = _captureContinuationOffset\(\)/);
  assert.match(pause, /_resumeOffset = offset/);
  assert.match(pause, /_lastObservedOffset = offset/);
  assert.match(pause, /pauseAtOffset\(offset\)/);
});

test('speed changes keep the same saved offset', () => {
  const start = player.indexOf('Future<void> _setSpeechRate');
  const end = player.indexOf('@override\n  Widget build', start);
  const body = player.slice(start, end);

  assert.match(body, /final offset = _captureContinuationOffset\(\)/);
  assert.match(body, /pauseAtOffset\(offset\)/);
  assert.match(body, /setSpeechRate\(rate\)/);
  assert.match(body, /_beginLocalPlayback\(offset\)/);
  assert.match(body, /resumeFromOffset\(offset\)/);
});

test('estimated Safari progress rewinds instead of skipping text', () => {
  assert.match(player, /return math\.max\(0, estimated - 2\)/);
});

test('paused progress remains visible at the retained offset', () => {
  assert.match(player, /math\.max\(_resumeOffset, _lastObservedOffset\)/);
  assert.match(player, /final visibleOffset = isPlaying \|\| isPaused/);
  assert.match(player, /visibleOffset \/ total/);
});
""",
    encoding='utf-8',
)
