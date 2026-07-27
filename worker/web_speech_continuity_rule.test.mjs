import test from 'node:test';
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

test('utterance base offset is preserved during native pause and resume', () => {
  const pauseStart = controller.indexOf('Future<void> pauseAtOffset');
  const resumeStart = controller.indexOf('Future<void> resumeFromOffset');
  const wordStart = controller.indexOf('Future<bool> speakWord');
  const pauseBody = controller.slice(pauseStart, resumeStart);
  const resumeBody = controller.slice(resumeStart, wordStart);

  const webPauseStart = pauseBody.indexOf('if (_webSpeech.isAvailable)');
  const fallbackPauseStart = pauseBody.indexOf(
    '_speechBaseOffset = safeOffset',
    webPauseStart,
  );
  const webPauseBody = pauseBody.slice(webPauseStart, fallbackPauseStart);

  const webResumeStart = resumeBody.indexOf('if (_webSpeech.isAvailable)');
  const fallbackResumeStart = resumeBody.indexOf(
    'await _stopSpeechEngine',
    webResumeStart,
  );
  const webResumeBody = resumeBody.slice(webResumeStart, fallbackResumeStart);

  assert.ok(webPauseStart >= 0 && fallbackPauseStart > webPauseStart);
  assert.ok(webResumeStart >= 0 && fallbackResumeStart > webResumeStart);
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
