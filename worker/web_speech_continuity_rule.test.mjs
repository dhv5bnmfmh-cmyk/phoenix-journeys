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
