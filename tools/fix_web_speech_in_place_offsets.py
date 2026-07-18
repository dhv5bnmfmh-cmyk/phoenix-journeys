from pathlib import Path

CONTROLLER = Path('app/lib/services/narration_controller.dart')
RULE = Path('worker/web_speech_continuity_rule.test.mjs')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    if old not in text:
        if new in text:
            return text
        raise RuntimeError(f'missing replacement target: {label}')
    return text.replace(old, new, 1)


controller = CONTROLLER.read_text(encoding='utf-8')
controller = replace_once(
    controller,
    "  void _bindHandlers() {\n    if (_webSpeech.isAvailable) return;\n",
    "  void _bindHandlers() {\n",
    'keep word handlers on web',
)

controller = replace_once(
    controller,
    "    _status = NarrationStatus.paused;\n"
    "    _currentOffset = safeOffset;\n"
    "    _speechBaseOffset = safeOffset;\n"
    "    _currentItemIndex = _plan.indexForOffset(safeOffset);\n"
    "    _cancelProgressClock();\n"
    "    _applyProgress(safeOffset);\n\n"
    "    if (_webSpeech.isAvailable) {\n",
    "    _status = NarrationStatus.paused;\n"
    "    _currentOffset = safeOffset;\n"
    "    _currentItemIndex = _plan.indexForOffset(safeOffset);\n"
    "    _cancelProgressClock();\n"
    "    _applyProgress(safeOffset);\n\n"
    "    if (_webSpeech.isAvailable) {\n",
    'preserve utterance base before web pause',
)

controller = replace_once(
    controller,
    "      _status = NarrationStatus.paused;\n"
    "      _currentOffset = safeOffset;\n"
    "      _speechBaseOffset = safeOffset;\n"
    "      _currentItemIndex = _plan.indexForOffset(safeOffset);\n",
    "      _status = NarrationStatus.paused;\n"
    "      _currentOffset = safeOffset;\n"
    "      _currentItemIndex = _plan.indexForOffset(safeOffset);\n",
    'preserve utterance base after web pause',
)

controller = replace_once(
    controller,
    "    await _stopSpeechEngine();\n"
    "    if (_disposed) return;\n\n"
    "    _status = NarrationStatus.paused;\n"
    "    _currentOffset = safeOffset;\n",
    "    _speechBaseOffset = safeOffset;\n"
    "    await _stopSpeechEngine();\n"
    "    if (_disposed) return;\n\n"
    "    _status = NarrationStatus.paused;\n"
    "    _currentOffset = safeOffset;\n",
    'set base only for stop-and-restart pause',
)

controller = replace_once(
    controller,
    "    _status = NarrationStatus.paused;\n"
    "    _currentOffset = safeOffset;\n"
    "    _speechBaseOffset = safeOffset;\n"
    "    _currentItemIndex = _plan.indexForOffset(safeOffset);\n"
    "    _cancelProgressClock();\n"
    "    _applyProgress(safeOffset);\n\n"
    "    if (_webSpeech.isAvailable) {\n",
    "    _status = NarrationStatus.paused;\n"
    "    _currentOffset = safeOffset;\n"
    "    _currentItemIndex = _plan.indexForOffset(safeOffset);\n"
    "    _cancelProgressClock();\n"
    "    _applyProgress(safeOffset);\n\n"
    "    if (_webSpeech.isAvailable) {\n",
    'preserve utterance base before web resume',
)

controller = replace_once(
    controller,
    "    if (_webSpeech.isAvailable) {\n"
    "      await _webSpeech.stop();\n",
    "    if (_webSpeech.isAvailable &&\n"
    "        _speechMode != _NarrationSpeechMode.word) {\n"
    "      await _webSpeech.stop();\n",
    'allow Flutter TTS word speech to stop on web',
)

CONTROLLER.write_text(controller, encoding='utf-8')

rule = RULE.read_text(encoding='utf-8')
if "utterance base offset is preserved" not in rule:
    rule += """

test('utterance base offset is preserved during native pause and resume', () => {
  const pauseStart = controller.indexOf('Future<void> pauseAtOffset');
  const resumeStart = controller.indexOf('Future<void> resumeFromOffset');
  const wordStart = controller.indexOf('Future<bool> speakWord');
  const pauseBody = controller.slice(pauseStart, resumeStart);
  const resumeBody = controller.slice(resumeStart, wordStart);
  const webPauseBody = pauseBody.slice(pauseBody.indexOf('if (_webSpeech.isAvailable)'));
  const webResumeBody = resumeBody.slice(0, resumeBody.indexOf('await _stopSpeechEngine'));

  assert.doesNotMatch(webPauseBody, /_speechBaseOffset = safeOffset/);
  assert.doesNotMatch(webResumeBody, /_speechBaseOffset = safeOffset/);
});

test('Flutter word callbacks remain bound on web', () => {
  assert.doesNotMatch(
    controller,
    /void _bindHandlers\(\) \{\s*if \(_webSpeech\.isAvailable\) return/,
  );
  assert.match(
    controller,
    /_webSpeech\.isAvailable &&\s*_speechMode != _NarrationSpeechMode\.word/,
  );
});
"""
    RULE.write_text(rule, encoding='utf-8')
