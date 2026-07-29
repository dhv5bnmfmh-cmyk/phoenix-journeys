import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const quality = readFileSync(
  'app/lib/services/narration_voice_quality.dart',
  'utf8',
);
const webSpeech = readFileSync(
  'app/lib/services/phoenix_web_speech_web.dart',
  'utf8',
);
const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('web narration warms and ranks natural voices before playback', () => {
  assert.match(webSpeech, /_primeVoiceCatalog\(\)/);
  assert.match(webSpeech, /_refreshVoiceCatalog\(\)/);
  assert.match(webSpeech, /narrationVoiceScore/);
  assert.match(quality, /'natural': 100/);
  assert.match(quality, /'premium': 85/);
  assert.match(quality, /'compact': 80/);
  assert.match(quality, /'xiaoxiao'/);
  assert.match(quality, /'hsiaochen'/);
});

test('narration startup cannot remain silently stuck in playing state', () => {
  assert.match(webSpeech, /_scheduleStartupCheck/);
  assert.match(webSpeech, /synth\.speaking == true/);
  assert.match(webSpeech, /synth\.pending == true/);
  assert.match(webSpeech, /speech-start-blocked/);
  assert.match(quality, /NarrationStartupDecision\.fail/);
  assert.match(player, /controllerStatus == NarrationStatus\.error/);
  assert.match(controller, /自动朗读被浏览器拦截，请点击播放重试。/);
});

test('language-specific prosody preserves user speed within safe bounds', () => {
  assert.match(webSpeech, /resolveNaturalNarrationRate/);
  assert.match(webSpeech, /resolveNaturalNarrationPitch/);
  assert.match(quality, /'zh' => \(min: \.50, max: 1\.35\)/);
  assert.match(quality, /'zh' => \.96/);
});
