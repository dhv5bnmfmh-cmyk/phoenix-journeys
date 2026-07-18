from pathlib import Path

PLAYER = Path('app/lib/widgets/narration_player_card.dart')
CONTROLLER = Path('app/lib/services/narration_controller.dart')
UNIT_TEST = Path('app/test/narration_resume_offset_test.dart')
IOS_RULE = Path('worker/ios_narration_position_rule.test.mjs')
CONTINUITY_RULE = Path('worker/narration_continuity_rule.test.mjs')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise RuntimeError(f'missing target: {label}')
    return text.replace(old, new, 1)


player = PLAYER.read_text(encoding='utf-8')
player = replace_once(
    player,
    "  final maxOffset = math.max(0, totalCharacters - 1);\n"
    "  if (nativeProgressIsFresh) {\n"
    "    return nativeOffset.clamp(0, maxOffset).toInt();\n"
    "  }\n\n"
    "  final estimated = estimatedOffset.clamp(0, maxOffset).toInt();\n"
    "  // When Safari has no exact word callback, resume slightly before the\n"
    "  // estimate so Phoenix never skips text after pause or a speed change.\n"
    "  return math.max(0, estimated - 2);\n",
    "  final maxOffset = math.max(0, totalCharacters - 1);\n"
    "  final estimated = estimatedOffset.clamp(0, maxOffset).toInt();\n"
    "  final safeEstimated = math.max(0, estimated - 1);\n"
    "  if (nativeProgressIsFresh) {\n"
    "    final native = nativeOffset.clamp(0, maxOffset).toInt();\n"
    "    return math.max(native, safeEstimated);\n"
    "  }\n\n"
    "  return safeEstimated;\n",
    'pause offset resolution',
)
player = replace_once(
    player,
    "        final retainedOffset = controllerIsCurrent\n"
    "            ? math.max(\n"
    "                widget.controller.currentOffset,\n"
    "                math.max(_resumeOffset, _lastObservedOffset),\n"
    "              )\n"
    "            : 0;\n"
    "        final visibleOffset = isPlaying || isPaused\n"
    "            ? retainedOffset\n"
    "            : controllerIsCurrent\n"
    "            ? widget.controller.currentOffset\n"
    "            : 0;\n",
    "        final visibleOffset = controllerIsCurrent\n"
    "            ? isPaused\n"
    "                  ? math.max(widget.controller.currentOffset, _resumeOffset)\n"
    "                  : widget.controller.currentOffset\n"
    "            : 0;\n",
    'single visible progress source',
)
PLAYER.write_text(player, encoding='utf-8')

controller = CONTROLLER.read_text(encoding='utf-8')
controller = replace_once(
    controller,
    "  Future<void> resume() async {\n"
    "    if (_status != NarrationStatus.paused || _plan.isEmpty) return;\n\n"
    "    final offset = _currentOffset >= _plan.text.length ? 0 : _currentOffset;\n"
    "    await _speakFrom(offset);\n"
    "  }\n",
    "  Future<void> resume() async {\n"
    "    if (_status != NarrationStatus.paused || _plan.isEmpty) return;\n\n"
    "    final maxOffset = math.max(0, _plan.text.length - 1);\n"
    "    final offset = _currentOffset.clamp(0, maxOffset).toInt();\n"
    "    await _speakFrom(offset);\n"
    "  }\n",
    'resume must not reset to zero',
)
controller = replace_once(
    controller,
    "    _speechRate = option.rate;\n"
    "    _safeNotify();\n\n"
    "    if (_status == NarrationStatus.playing && !_plan.isEmpty) {\n"
    "      await _speakFrom(_currentOffset);\n"
    "    }\n",
    "    _speechRate = option.rate;\n"
    "    _safeNotify();\n",
    'speech rate must not restart playback',
)
controller = replace_once(
    controller,
    "  Future<void> _speakFrom(int offset, {bool stopEngineFirst = true}) async {\n"
    "    final safeOffset = offset < 0\n"
    "        ? 0\n"
    "        : offset >= _plan.text.length\n"
    "        ? 0\n"
    "        : offset;\n"
    "    final remainingText = _plan.text.substring(safeOffset);\n",
    "  Future<void> _speakFrom(int offset, {bool stopEngineFirst = true}) async {\n"
    "    if (_plan.isEmpty) return;\n"
    "    final maxOffset = math.max(0, _plan.text.length - 1);\n"
    "    final safeOffset = offset.clamp(0, maxOffset).toInt();\n"
    "    final remainingText = _plan.text.substring(safeOffset);\n",
    'speak offset must clamp instead of restart',
)
if "import 'dart:math' as math;" not in controller:
    controller = controller.replace(
        "import 'dart:async';\n",
        "import 'dart:async';\nimport 'dart:math' as math;\n",
        1,
    )
CONTROLLER.write_text(controller, encoding='utf-8')

unit_test = UNIT_TEST.read_text(encoding='utf-8')
unit_test = unit_test.replace("      17,\n", "      23,\n", 1)
unit_test = unit_test.replace("      22,\n", "      23,\n", 1)
unit_test = unit_test.replace("      29,\n", "      30,\n", 1)
unit_test = unit_test.replace("      40,\n", "      41,\n", 1)
unit_test = unit_test.replace("      37,\n", "      47,\n", 1)
UNIT_TEST.write_text(unit_test, encoding='utf-8')

IOS_RULE.write_text(
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
  assert.match(player, /lastObservedOffset: _lastObservedOffset/);
});

test('fresh native zero cannot pull the saved position back to the beginning', () => {
  assert.match(player, /return math\.max\(native, safeEstimated\)/);
  assert.match(player, /final safeEstimated = math\.max\(0, estimated - 1\)/);
});

test('pause freezes and resumes from exactly one saved offset', () => {
  const pauseStart = player.indexOf('Future<void> _pauseSession');
  const pauseEnd = player.indexOf('Future<void> _resumeSession', pauseStart);
  const pause = player.slice(pauseStart, pauseEnd);

  assert.match(pause, /final offset = _captureContinuationOffset\(\)/);
  assert.match(pause, /_resumeOffset = offset/);
  assert.match(pause, /pauseAtOffset\(offset\)/);
});

test('speed changes keep the same saved offset', () => {
  const start = player.indexOf('Future<void> _setSpeechRate');
  const end = player.indexOf('@override\n  Widget build', start);
  const body = player.slice(start, end);

  assert.match(body, /final offset = _captureContinuationOffset\(\)/);
  assert.match(body, /pauseAtOffset\(offset\)/);
  assert.match(body, /setSpeechRate\(rate\)/);
  assert.match(body, /resumeFromOffset\(offset\)/);
});

test('playing progress comes directly from the narration controller', () => {
  assert.match(
    player,
    /isPaused[\s\S]*math\.max\(widget\.controller\.currentOffset, _resumeOffset\)[\s\S]*: widget\.controller\.currentOffset/,
  );
});
""",
    encoding='utf-8',
)

CONTINUITY_RULE.write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);

test('changing speed never starts a second narration session', () => {
  const start = controller.indexOf('Future<void> setSpeechRate');
  const end = controller.indexOf('Future<void> stop', start);
  const body = controller.slice(start, end);

  assert.match(body, /_speechRate = option\.rate/);
  assert.doesNotMatch(body, /_speakFrom/);
});

test('resume clamps to the saved position instead of zero', () => {
  const start = controller.indexOf('Future<void> resume()');
  const end = controller.indexOf('Future<void> resumeFromOffset', start);
  const body = controller.slice(start, end);

  assert.match(body, /_currentOffset\.clamp\(0, maxOffset\)/);
  assert.doesNotMatch(body, /\? 0 : _currentOffset/);
});

test('speaking from an end-adjacent offset cannot restart at the beginning', () => {
  const start = controller.indexOf('Future<void> _speakFrom');
  const end = controller.indexOf('Future<void> _startProgressWatchdog', start);
  const body = controller.slice(start, end);

  assert.match(body, /offset\.clamp\(0, maxOffset\)/);
  assert.doesNotMatch(body, /offset >= _plan\.text\.length[\s\S]*\? 0/);
});

test('audio, progress and highlight share currentOffset', () => {
  assert.match(controller, /_currentOffset = safeOffset/);
  assert.match(controller, /_applyProgress\(safeOffset\)/);
  assert.match(controller, /_speechBaseOffset = safeOffset/);
});
""",
    encoding='utf-8',
)
