import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, writeFileSync } from 'node:fs';

const journeyPath = 'app/lib/screens/journey_screen.dart';
const controllerPath = 'app/lib/services/narration_controller.dart';

function replaceOnce(source, pattern, replacement, label) {
  const matches = source.match(pattern);
  assert.ok(matches, `${label}: expected source block was not found`);
  const updated = source.replace(pattern, replacement);
  assert.notEqual(updated, source, `${label}: source was not changed`);
  return updated;
}

test('generate reliable narration resume patch', () => {
  let journey = readFileSync(journeyPath, 'utf8');
  journey = replaceOnce(
    journey,
    /  Future<void> _openWord\(WordEntry entry\) async \{[\s\S]*?\n  \}\n\n(?=  bool _isNarrating)/,
    `  Future<void> _openWord(WordEntry entry) async {
    final shouldResume = _narration.status == NarrationStatus.playing;
    if (shouldResume) {
      await _narration.pause();
    }
    final resumeOffset = _narration.currentOffset;
    if (!mounted) return;

    await showWordDetail(
      context,
      entry,
      onSpeak: () => _narration.speakWord(
        _appState.displayText(entry.word),
        languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      ),
    );
    if (!mounted || !shouldResume) return;

    // Wait until the sheet animation and iOS audio channel have fully closed.
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    await _narration.resumeFromOffset(resumeOffset);
  }

`,
    '_openWord',
  );
  writeFileSync(journeyPath, journey);

  let controller = readFileSync(controllerPath, 'utf8');
  controller = replaceOnce(
    controller,
    /  Future<void> resume\(\) async \{[\s\S]*?\n  \}\n\n(?=  Future<bool> speakWord)/,
    `  Future<void> resume() async {
    if (_status != NarrationStatus.paused || _plan.isEmpty) return;

    final offset = _currentOffset >= _plan.text.length ? 0 : _currentOffset;
    await _speakFrom(offset);
  }

  Future<void> resumeFromOffset(int offset) async {
    if (_plan.isEmpty || _disposed) return;

    final maxOffset = _plan.text.isEmpty ? 0 : _plan.text.length - 1;
    final safeOffset = offset.clamp(0, maxOffset).toInt();
    _status = NarrationStatus.paused;
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

`,
    'resumeFromOffset',
  );

  controller = replaceOnce(
    controller,
    /  Future<void> _speakFrom\(int offset\) async \{/,
    `  Future<void> _speakFrom(
    int offset, {
    bool stopEngineFirst = true,
  }) async {`,
    '_speakFrom signature',
  );

  const methodStart = controller.indexOf('  Future<void> _speakFrom(');
  const methodEnd = controller.indexOf('\n  void _finishWordSpeech', methodStart);
  assert.ok(methodStart >= 0 && methodEnd > methodStart, '_speakFrom method bounds');
  let method = controller.slice(methodStart, methodEnd);
  method = replaceOnce(
    method,
    /      await _stopSpeechEngine\(\);/,
    `      if (stopEngineFirst) {
        await _stopSpeechEngine();
      }`,
    '_speakFrom engine stop',
  );
  controller = controller.slice(0, methodStart) + method + controller.slice(methodEnd);
  writeFileSync(controllerPath, controller);

  assert.match(journey, /resumeFromOffset\(resumeOffset\)/);
  assert.match(controller, /Future<void> resumeFromOffset\(int offset\)/);
  assert.match(controller, /stopEngineFirst: false/);

  console.log(`PHOENIX_JOURNEY_BASE64=${Buffer.from(journey).toString('base64')}`);
  console.log(`PHOENIX_CONTROLLER_BASE64=${Buffer.from(controller).toString('base64')}`);
});
