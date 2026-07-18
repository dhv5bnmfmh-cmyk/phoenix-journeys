from pathlib import Path
import re

CONTROLLER = Path('app/lib/services/narration_controller.dart')
PLAYER = Path('app/lib/widgets/narration_player_card.dart')
RULE = Path('worker/web_speech_continuity_rule.test.mjs')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        raise RuntimeError(f'missing replacement target: {label}')
    return text.replace(old, new, 1)


controller = CONTROLLER.read_text(encoding='utf-8')
if "import 'phoenix_web_speech.dart';" in controller:
    raise SystemExit(0)

controller = replace_once(
    controller,
    "import 'package:flutter_tts/flutter_tts.dart';\n",
    "import 'package:flutter_tts/flutter_tts.dart';\n\n"
    "import 'phoenix_web_speech.dart';\n",
    'web speech import',
)

controller = replace_once(
    controller,
    "  NarrationController({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {\n"
    "    _bindHandlers();\n"
    "  }\n",
    "  NarrationController({FlutterTts? tts}) : _tts = tts ?? FlutterTts() {\n"
    "    _webSpeech = PhoenixWebSpeech(\n"
    "      onStart: _handleWebStart,\n"
    "      onProgress: _handleWebProgress,\n"
    "      onComplete: _handleWebComplete,\n"
    "      onPause: _handleWebPause,\n"
    "      onResume: _handleWebResume,\n"
    "      onError: _handleWebError,\n"
    "    );\n"
    "    _bindHandlers();\n"
    "  }\n",
    'controller constructor',
)

controller = replace_once(
    controller,
    "  final FlutterTts _tts;\n",
    "  final FlutterTts _tts;\n"
    "  late final PhoenixWebSpeech _webSpeech;\n",
    'web speech field',
)

controller = replace_once(
    controller,
    "  int _speechSessionToken = 0;\n",
    "  int _speechSessionToken = 0;\n"
    "  bool _webSpeechPausedInPlace = false;\n"
    "  bool _restartWebSpeechOnResume = false;\n",
    'web speech state fields',
)

web_handlers = r'''
  void _handleWebStart() {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _status = NarrationStatus.playing;
    _errorMessage = null;
    _startProgressClock(_currentOffset);
    _safeNotify();
  }

  void _handleWebProgress(int startOffset, int endOffset, String word) {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    final globalStart = _speechBaseOffset + startOffset;
    final globalEnd = _speechBaseOffset + endOffset;
    final now = DateTime.now();
    _lastNativeOffset = globalStart;
    _lastNativeProgressAt = now;
    _estimateAnchorTime = now;
    _estimateAnchorOffset = globalStart;
    _applyProgress(globalStart, endOffset: globalEnd, word: word);
  }

  void _handleWebComplete() {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _webSpeechPausedInPlace = false;
    _restartWebSpeechOnResume = false;
    _finishNarrationSession();
  }

  void _handleWebPause() {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _status = NarrationStatus.paused;
    _cancelProgressClock();
    _safeNotify();
  }

  void _handleWebResume() {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _status = NarrationStatus.playing;
    _startProgressClock(_currentOffset);
    _safeNotify();
  }

  void _handleWebError(String message) {
    if (_disposed || _speechMode != _NarrationSpeechMode.narration) return;
    _cancelProgressClock();
    _speechMode = _NarrationSpeechMode.idle;
    _status = NarrationStatus.error;
    _errorMessage = '当前设备暂时无法朗读，请检查声音设置后重试。';
    _currentItemIndex = null;
    _highlightSnapshot = null;
    NarrationHighlightBus.instance.clear(contentId: _contentId);
    debugPrint('Phoenix web narration error: $message');
    _safeNotify();
  }

'''
controller = replace_once(
    controller,
    "  void _bindHandlers() {\n",
    web_handlers + "  void _bindHandlers() {\n    if (_webSpeech.isAvailable) return;\n",
    'web speech handlers',
)

controller = replace_once(
    controller,
    "    _speechMode = _NarrationSpeechMode.narration;\n"
    "    _applyProgress(0);\n",
    "    _speechMode = _NarrationSpeechMode.narration;\n"
    "    _webSpeechPausedInPlace = false;\n"
    "    _restartWebSpeechOnResume = false;\n"
    "    _applyProgress(0);\n",
    'reset web speech state on play',
)

pause_target = """    await _stopSpeechEngine();
    if (_disposed) return;

    _status = NarrationStatus.paused;
    _currentOffset = safeOffset;
    _speechBaseOffset = safeOffset;
    _currentItemIndex = _plan.indexForOffset(safeOffset);
    _applyProgress(safeOffset);
  }

  Future<void> resume() async {
    if (_status != NarrationStatus.paused || _plan.isEmpty) return;

    final maxOffset = math.max(0, _plan.text.length - 1);
    final offset = _currentOffset.clamp(0, maxOffset).toInt();
    await _speakFrom(offset);
  }
"""
pause_replacement = """    if (_webSpeech.isAvailable) {
      final paused = await _webSpeech.pause();
      if (_disposed) return;
      _webSpeechPausedInPlace = paused;
      _status = NarrationStatus.paused;
      _currentOffset = safeOffset;
      _speechBaseOffset = safeOffset;
      _currentItemIndex = _plan.indexForOffset(safeOffset);
      _applyProgress(safeOffset);
      return;
    }

    await _stopSpeechEngine();
    if (_disposed) return;

    _status = NarrationStatus.paused;
    _currentOffset = safeOffset;
    _speechBaseOffset = safeOffset;
    _currentItemIndex = _plan.indexForOffset(safeOffset);
    _applyProgress(safeOffset);
  }

  Future<void> resume() async {
    if (_status != NarrationStatus.paused || _plan.isEmpty) return;
    await resumeFromOffset(_currentOffset);
  }
"""
controller = replace_once(
    controller,
    pause_target,
    pause_replacement,
    'native web pause and resume',
)

resume_target = """    _status = NarrationStatus.paused;
    _cancelProgressClock();
    _safeNotify();

    await _stopSpeechEngine();
    if (_disposed) return;

    // Safari/iOS needs a quiet gap after the word voice releases audio.
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (_disposed) return;
    _ignoreEngineCallbacksUntil = null;
    await _speakFrom(safeOffset, stopEngineFirst: false);
  }
"""
resume_replacement = """    _status = NarrationStatus.paused;
    _currentOffset = safeOffset;
    _speechBaseOffset = safeOffset;
    _currentItemIndex = _plan.indexForOffset(safeOffset);
    _cancelProgressClock();
    _applyProgress(safeOffset);

    if (_webSpeech.isAvailable) {
      final resumeInPlace =
          _webSpeechPausedInPlace && !_restartWebSpeechOnResume;
      _webSpeechPausedInPlace = false;
      final restartAtSavedOffset = _restartWebSpeechOnResume;
      _restartWebSpeechOnResume = false;

      if (resumeInPlace) {
        _status = NarrationStatus.playing;
        _startProgressClock(safeOffset);
        _safeNotify();
        final resumed = await _webSpeech.resume();
        if (resumed || _disposed) return;
      }

      if (restartAtSavedOffset || !_disposed) {
        await _speakFrom(safeOffset);
      }
      return;
    }

    await _stopSpeechEngine();
    if (_disposed) return;

    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (_disposed) return;
    _ignoreEngineCallbacksUntil = null;
    await _speakFrom(safeOffset, stopEngineFirst: false);
  }
"""
controller = replace_once(
    controller,
    resume_target,
    resume_replacement,
    'web resume from saved position',
)

controller = replace_once(
    controller,
    "    _speechRate = option.rate;\n"
    "    _safeNotify();\n"
    "  }\n",
    "    _speechRate = option.rate;\n"
    "    if (_webSpeech.isAvailable && _status == NarrationStatus.paused) {\n"
    "      _restartWebSpeechOnResume = true;\n"
    "    }\n"
    "    _safeNotify();\n"
    "  }\n",
    'restart web utterance after rate change',
)

speak_marker = """      final sessionToken = ++_speechSessionToken;

      await _configureNaturalVoice('zh-CN');
"""
speak_web = """      final sessionToken = ++_speechSessionToken;

      if (_webSpeech.isAvailable) {
        _webSpeechPausedInPlace = false;
        _restartWebSpeechOnResume = false;
        unawaited(_startProgressWatchdog(sessionToken, safeOffset));
        final started = await _webSpeech.speak(
          remainingText,
          languageCode: 'zh-CN',
          rate: _speechRate,
          pitch: .98,
          volume: 1,
        );
        if (!started && !_disposed) {
          _cancelProgressClock();
          _speechMode = _NarrationSpeechMode.idle;
          _status = NarrationStatus.error;
          _errorMessage = '当前浏览器暂时无法朗读，请换用 Safari 或 Chrome 重试。';
          _safeNotify();
        }
        return;
      }

      await _configureNaturalVoice('zh-CN');
"""
controller = replace_once(
    controller,
    speak_marker,
    speak_web,
    'direct web speech path',
)

stop_marker = """  Future<void> _stopSpeechEngine() async {
    _speechSessionToken += 1;
"""
stop_web = """  Future<void> _stopSpeechEngine() async {
    _speechSessionToken += 1;
    if (_webSpeech.isAvailable) {
      await _webSpeech.stop();
      _webSpeechPausedInPlace = false;
      _restartWebSpeechOnResume = false;
      _speechMode = _NarrationSpeechMode.idle;
      _isSpeakingWord = false;
      _spokenWord = null;
      return;
    }
"""
controller = replace_once(
    controller,
    stop_marker,
    stop_web,
    'stop direct web speech',
)

controller = replace_once(
    controller,
    "    _highlightSnapshot = null;\n"
    "    NarrationHighlightBus.instance.clear(contentId: _contentId);\n"
    "    unawaited(_tts.stop());\n"
    "    super.dispose();\n",
    "    _highlightSnapshot = null;\n"
    "    NarrationHighlightBus.instance.clear(contentId: _contentId);\n"
    "    _webSpeech.dispose();\n"
    "    unawaited(_tts.stop());\n"
    "    super.dispose();\n",
    'dispose web speech',
)

CONTROLLER.write_text(controller, encoding='utf-8')

player = PLAYER.read_text(encoding='utf-8')
capture_pattern = re.compile(
    r"  int _captureContinuationOffset\(\) \{.*?\n  \}\n\n  void _handleMainPressed\(\) \{",
    re.S,
)
player, count = capture_pattern.subn(
    "  int _captureContinuationOffset() {\n"
    "    if (!_controllerIsCurrent) return _resumeOffset;\n"
    "    final total = widget.controller.totalCharacters;\n"
    "    if (total <= 0) return 0;\n"
    "    return widget.controller.currentOffset\n"
    "        .clamp(0, math.max(0, total - 1))\n"
    "        .toInt();\n"
    "  }\n\n"
    "  void _handleMainPressed() {",
    player,
    count=1,
)
if count != 1:
    raise RuntimeError('unable to replace player continuation source')
PLAYER.write_text(player, encoding='utf-8')

RULE.write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);
const webSpeech = readFileSync(
  'app/lib/services/phoenix_web_speech_web.dart',
  'utf8',
);

test('Safari narration uses a Phoenix-owned utterance', () => {
  assert.match(controller, /PhoenixWebSpeech/);
  assert.match(controller, /_webSpeech\.speak\(/);
  assert.match(webSpeech, /SpeechSynthesisUtterance/);
  assert.match(webSpeech, /synth\.speak\(utterance\)/);
});

test('pause and continue keep the same browser utterance', () => {
  assert.match(webSpeech, /synth\.pause\(\)/);
  assert.match(webSpeech, /synth\.resume\(\)/);
  assert.match(controller, /_webSpeechPausedInPlace/);
  assert.match(controller, /final resumed = await _webSpeech\.resume\(\)/);
});

test('speed changes restart only at the saved offset', () => {
  assert.match(controller, /_restartWebSpeechOnResume = true/);
  assert.match(controller, /await _speakFrom\(safeOffset\)/);
  assert.doesNotMatch(
    controller,
    /setSpeechRate[\s\S]{0,500}await _speakFrom\(_currentOffset\)/,
  );
});

test('audio, triangle, and highlighted text share controller offset', () => {
  const start = player.indexOf('int _captureContinuationOffset');
  const end = player.indexOf('void _handleMainPressed', start);
  const body = player.slice(start, end);
  assert.match(body, /widget\.controller\.currentOffset/);
  assert.doesNotMatch(body, /lastNativeOffset/);
  assert.doesNotMatch(body, /lastObservedOffset/);
  assert.match(controller, /_applyProgress\(globalStart/);
});
""",
    encoding='utf-8',
)
