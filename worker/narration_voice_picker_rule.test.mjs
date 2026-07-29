import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const quality = readFileSync(
  'app/lib/services/narration_voice_quality.dart',
  'utf8',
);
const webService = readFileSync(
  'app/lib/services/narration_voice_picker_service_web.dart',
  'utf8',
);
const webSpeech = readFileSync(
  'app/lib/services/phoenix_web_speech_web.dart',
  'utf8',
);
const button = readFileSync(
  'app/lib/widgets/narration_voice_picker_button.dart',
  'utf8',
);
const speed = readFileSync(
  'app/lib/widgets/narration_speed_stepper.dart',
  'utf8',
);

test('voice picker ranks and remembers locale-specific choices', () => {
  assert.match(quality, /rankNarrationVoiceOptions/);
  assert.match(quality, /phoenix\.narration\.voice\./);
  assert.match(webService, /localStorage\[narrationVoicePreferenceKey/);
  assert.match(webService, /selectVoice/);
  assert.match(webService, /previewVoice/);
});

test('saved voice preference overrides automatic ranking when available', () => {
  assert.match(webSpeech, /preferredVoiceId:/);
  assert.match(webSpeech, /id == preferred/);
  assert.match(webSpeech, /return bestScore <= -10000 \? null : bestVoice/);
});

test('compact narration controls expose the voice picker without a new panel', () => {
  assert.match(speed, /NarrationVoicePickerButton/);
  assert.match(button, /narration-voice-picker/);
  assert.match(button, /简体普通话/);
  assert.match(button, /台湾国语/);
  assert.match(button, /自动选择最佳声线/);
  assert.match(button, /试听后选择/);
});
