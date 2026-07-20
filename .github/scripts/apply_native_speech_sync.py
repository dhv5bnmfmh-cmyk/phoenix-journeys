from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    file = Path(path)
    text = file.read_text(encoding='utf-8')
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{path}: expected one match, found {count}: {old[:80]!r}')
    file.write_text(text.replace(old, new, 1), encoding='utf-8')


controller = 'app/lib/services/narration_controller.dart'
replace_once(
    controller,
    "  static const speedOptions = <NarrationSpeedOption>[\n",
    "  static const double nativeDefaultRate = 1.0;\n\n"
    "  static const speedOptions = <NarrationSpeedOption>[\n",
)
replace_once(
    controller,
    "  double _speechRate = 1.0;\n",
    "  double _speechRate = nativeDefaultRate;\n",
)
replace_once(
    controller,
    "  String? _configuredVoiceLanguage;\n",
    "  String? _configuredVoiceLanguage;\n"
    "  String _narrationLanguageCode = 'zh-CN';\n",
)
replace_once(
    controller,
    "          orElse: () => speedOptions.first,\n",
    "          orElse: () => speedOptions.firstWhere(\n"
    "            (option) => option.rate == nativeDefaultRate,\n"
    "          ),\n",
)
replace_once(
    controller,
    "  Future<void> play({\n"
    "    required String contentId,\n"
    "    required List<NarrationItem> items,\n"
    "  }) async {\n",
    "  Future<void> play({\n"
    "    required String contentId,\n"
    "    required List<NarrationItem> items,\n"
    "    String languageCode = 'zh-CN',\n"
    "  }) async {\n",
)
replace_once(
    controller,
    "    _contentId = contentId;\n"
    "    _plan = plan;\n",
    "    _contentId = contentId;\n"
    "    _narrationLanguageCode = languageCode;\n"
    "    _plan = plan;\n",
)
replace_once(
    controller,
    "  Future<void> restart() async {\n",
    "  Future<bool> speakTemporaryText(\n"
    "    String text, {\n"
    "    required String languageCode,\n"
    "  }) async {\n"
    "    final shouldResume =\n"
    "        _status == NarrationStatus.playing && !_plan.isEmpty;\n"
    "    final resumeOffset = _currentOffset;\n"
    "    final spoken = await speakWord(text, languageCode: languageCode);\n"
    "    if (shouldResume && spoken && !_disposed) {\n"
    "      await Future<void>.delayed(const Duration(milliseconds: 120));\n"
    "      if (!_disposed) await resumeFromOffset(resumeOffset);\n"
    "    }\n"
    "    return spoken;\n"
    "  }\n\n"
    "  Future<void> restart() async {\n",
)
replace_once(
    controller,
    "          languageCode: 'zh-CN',\n"
    "          rate: _speechRate,\n",
    "          languageCode: _narrationLanguageCode,\n"
    "          rate: _speechRate,\n",
)
replace_once(
    controller,
    "      await _configureNaturalVoice('zh-CN');\n",
    "      await _configureNaturalVoice(_narrationLanguageCode);\n",
)
replace_once(
    controller,
    "       final charsPerSecond = 3.35 * _speechRate;\n",
    "       final charsPerSecond =\n"
    "           _nativeCharsPerSecond(_narrationLanguageCode) * _speechRate;\n",
)
replace_once(
    controller,
    "  void _cancelProgressClock() {\n",
    "  double _nativeCharsPerSecond(String languageCode) {\n"
    "    final prefix = languageCode.toLowerCase().split(RegExp('[-_]')).first;\n"
    "    return switch (prefix) {\n"
    "      'zh' => 4.05,\n"
    "      'vi' => 12.0,\n"
    "      'en' => 13.0,\n"
    "      _ => 10.0,\n"
    "    };\n"
    "  }\n\n"
    "  void _cancelProgressClock() {\n",
)
replace_once(
    controller,
    "      debugPrint('Natural Chinese voice selection unavailable: $error');\n",
    "      debugPrint('Natural voice selection unavailable: $error');\n",
)

journey = 'app/lib/screens/journey_screen.dart'
replace_once(
    journey,
    "    return _narration.play(\n"
    "      contentId: 'story',\n",
    "    return _narration.play(\n"
    "      contentId: 'story',\n"
    "      languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',\n",
)
replace_once(
    journey,
    "    return _narration.play(\n"
    "      contentId: 'discovery',\n",
    "    return _narration.play(\n"
    "      contentId: 'discovery',\n"
    "      languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',\n",
)
replace_once(
    journey,
    "    final spoken = await _narration.speakWord(\n"
    "      text,\n"
    "      languageCode: languageCode,\n"
    "    );\n",
    "    final spoken = await _narration.speakTemporaryText(\n"
    "      text,\n"
    "      languageCode: languageCode,\n"
    "    );\n",
)

player = 'app/lib/widgets/narration_player_card.dart'
replace_once(
    player,
    "  void _observeControllerOffset(NarrationStatus status) {\n"
    "    if (!_controllerIsCurrent ||\n"
    "        (status != NarrationStatus.playing &&\n"
    "            status != NarrationStatus.paused)) {\n"
    "      return;\n"
    "    }\n\n"
    "    final total = widget.controller.totalCharacters;\n"
    "    if (total <= 0) return;\n"
    "    final observed = widget.controller.currentOffset\n"
    "        .clamp(0, math.max(0, total - 1))\n"
    "        .toInt();\n"
    "    if (observed > _lastObservedOffset) {\n"
    "      _lastObservedOffset = observed;\n"
    "    }\n"
    "  }\n",
    "  void _observeControllerOffset(NarrationStatus status) {\n"
    "    if (!_controllerIsCurrent) return;\n\n"
    "    // The controller is the single source of truth. Temporary word and\n"
    "    // support speech can pause the same engine outside this card.\n"
    "    if (status == NarrationStatus.playing) {\n"
    "      _sessionPlaying = true;\n"
    "      _sessionPaused = false;\n"
    "    } else if (status == NarrationStatus.paused) {\n"
    "      _sessionPlaying = false;\n"
    "      _sessionPaused = true;\n"
    "    } else if (_controllerFinished) {\n"
    "      _sessionPlaying = false;\n"
    "      _sessionPaused = false;\n"
    "    }\n\n"
    "    if (status != NarrationStatus.playing &&\n"
    "        status != NarrationStatus.paused) {\n"
    "      return;\n"
    "    }\n\n"
    "    final total = widget.controller.totalCharacters;\n"
    "    if (total <= 0) return;\n"
    "    final observed = widget.controller.currentOffset\n"
    "        .clamp(0, math.max(0, total - 1))\n"
    "        .toInt();\n"
    "    if (observed > _lastObservedOffset) {\n"
    "      _lastObservedOffset = observed;\n"
    "    }\n"
    "  }\n",
)

web = 'app/lib/services/phoenix_web_speech_web.dart'
replace_once(
    web,
    "    final utterance = html.SpeechSynthesisUtterance(text)\n"
    "      ..lang = languageCode\n"
    "      ..rate = rate\n"
    "      ..pitch = pitch\n"
    "      ..volume = volume;\n"
    "    _utterance = utterance;\n",
    "    final utterance = html.SpeechSynthesisUtterance(text)\n"
    "      ..lang = languageCode\n"
    "      ..rate = rate\n"
    "      ..pitch = pitch\n"
    "      ..volume = volume;\n"
    "    final selectedVoice = _selectNaturalVoice(\n"
    "      synth.getVoices(),\n"
    "      languageCode,\n"
    "    );\n"
    "    if (selectedVoice != null) utterance.voice = selectedVoice;\n"
    "    _utterance = utterance;\n",
)
replace_once(
    web,
    "  int _findWordEnd(String text, int start) {\n"
    "    if (start >= text.length) return text.length;\n"
    "    var end = start + 1;\n",
    "  html.SpeechSynthesisVoice? _selectNaturalVoice(\n"
    "    List<html.SpeechSynthesisVoice> voices,\n"
    "    String languageCode,\n"
    "  ) {\n"
    "    final requested = languageCode.toLowerCase().replaceAll('_', '-');\n"
    "    final prefix = requested.split('-').first;\n"
    "    html.SpeechSynthesisVoice? bestVoice;\n"
    "    var bestScore = -1;\n"
    "    for (final voice in voices) {\n"
    "      final locale = voice.lang.toLowerCase().replaceAll('_', '-');\n"
    "      if (!locale.startsWith(prefix)) continue;\n"
    "      final name = voice.name.toLowerCase();\n"
    "      var score = 10;\n"
    "      if (locale == requested) score += 100;\n"
    "      if (name.contains('natural')) score += 70;\n"
    "      if (name.contains('premium')) score += 60;\n"
    "      if (name.contains('enhanced')) score += 50;\n"
    "      if (name.contains('compact')) score -= 40;\n"
    "      if (score > bestScore) {\n"
    "        bestScore = score;\n"
    "        bestVoice = voice;\n"
    "      }\n"
    "    }\n"
    "    return bestVoice;\n"
    "  }\n\n"
    "  int _findWordEnd(String text, int start) {\n"
    "    if (start >= text.length) return text.length;\n"
    "    if (_isCjkCodeUnit(text.codeUnitAt(start))) {\n"
    "      return (start + 1).clamp(0, text.length).toInt();\n"
    "    }\n"
    "    var end = start + 1;\n",
)
replace_once(
    web,
    "  void _cancelSubscriptions() {\n",
    "  bool _isCjkCodeUnit(int value) {\n"
    "    return (value >= 0x3400 && value <= 0x4DBF) ||\n"
    "        (value >= 0x4E00 && value <= 0x9FFF) ||\n"
    "        (value >= 0xF900 && value <= 0xFAFF);\n"
    "  }\n\n"
    "  void _cancelSubscriptions() {\n",
)

legacy_test = 'worker/adaptive_word_audio_upgrade.test.mjs'
replace_once(
    legacy_test,
    "  assert.match(narration, /double _speechRate = 1\\.0/);\n",
    "  assert.match(narration, /static const double nativeDefaultRate = 1\\.0/);\n"
    "  assert.match(narration, /double _speechRate = nativeDefaultRate/);\n",
)

Path('worker/native_speech_sync.test.mjs').write_text(
    """import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (path) => readFileSync(path, 'utf8');
const narration = read('app/lib/services/narration_controller.dart');
const webSpeech = read('app/lib/services/phoenix_web_speech_web.dart');
const journey = read('app/lib/screens/journey_screen.dart');
const player = read('app/lib/widgets/narration_player_card.dart');

test('every Phoenix voice starts from the platform native speaking rate', () => {
  assert.match(narration, /static const double nativeDefaultRate = 1\.0/);
  assert.match(narration, /double _speechRate = nativeDefaultRate/);
  assert.match(narration, /_ttsSpeechRate\(_speechRate\)/);
  assert.match(webSpeech, /\.\.rate = rate/);
  assert.match(webSpeech, /_selectNaturalVoice/);
  assert.match(webSpeech, /synth\.getVoices\(\)/);
});

test('story and Discovery use the matching local Chinese locale', () => {
  assert.equal(
    (journey.match(/languageCode: _appState\.isTraditional \? 'zh-TW' : 'zh-CN'/g) ?? []).length,
    2,
  );
  assert.match(narration, /String _narrationLanguageCode = 'zh-CN'/);
  assert.match(narration, /languageCode: _narrationLanguageCode/);
  assert.match(narration, /_configureNaturalVoice\(_narrationLanguageCode\)/);
});

test('temporary note speech pauses and resumes the exact narration position', () => {
  assert.match(narration, /Future<bool> speakTemporaryText/);
  assert.match(narration, /final resumeOffset = _currentOffset/);
  assert.match(narration, /resumeFromOffset\(resumeOffset\)/);
  assert.match(journey, /_narration\.speakTemporaryText/);
});

test('player, progress and CJK reading marker share one synchronized source', () => {
  assert.match(player, /The controller is the single source of truth/);
  assert.match(player, /status == NarrationStatus\.playing/);
  assert.match(player, /status == NarrationStatus\.paused/);
  assert.match(webSpeech, /_isCjkCodeUnit/);
  assert.match(webSpeech, /return \(start \+ 1\)\.clamp/);
  assert.match(narration, /_nativeCharsPerSecond\(_narrationLanguageCode\)/);
});
""",
    encoding='utf-8',
)

# Remove this one-time patch mechanism from the resulting product commit.
Path('.github/scripts/apply_native_speech_sync.py').unlink()
Path('.github/workflows/apply-native-speech-sync.yml').unlink()
