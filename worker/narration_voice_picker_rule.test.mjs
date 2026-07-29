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
  assert.match(speed, /controller: controller/);
  assert.match(button, /narration-voice-picker/);
  assert.match(button, /简体普通话/);
  assert.match(button, /台湾国语/);
  assert.match(button, /自动选择最佳声线/);
  assert.match(button, /试听后选择/);
});

test('voice and speed controls remain visually separate and tactile', () => {
  assert.match(speed, /narration-speed-group/);
  assert.match(speed, /Icons\.remove_rounded/);
  assert.match(speed, /Icons\.add_rounded/);
  assert.match(speed, /AnimatedScale/);
  assert.match(speed, /onTapDown:/);
  assert.match(speed, /onTapCancel:/);
  assert.match(button, /Text\(\s*'声线'/);
  assert.match(button, /AnimatedScale/);
  assert.match(button, /splashColor:/);
  assert.match(button, /boxShadow:/);
});

test('the active voice is visible before the picker opens', () => {
  assert.match(quality, /compactNarrationVoiceSelectionLabel/);
  assert.match(quality, /narrationVoiceSelectionSummary/);
  assert.match(button, /narration-active-voice-label/);
  assert.match(button, /narration-custom-voice-dot/);
  assert.match(button, /narration-current-voice-summary/);
});

test('voice previews report progress and can be stopped', () => {
  assert.match(webService, /utterance\.onBoundary\.listen/);
  assert.match(webService, /onProgress\?\.call/);
  assert.match(webService, /utterance\.onEnd\.listen/);
  assert.match(button, /narration-voice-preview-progress/);
  assert.match(button, /停止试听/);
  assert.match(button, /Icons\.stop_rounded/);
});

test('opening the voice picker preserves the journey playback state', () => {
  assert.match(button, /controller\.stop\(resetPosition: false\)/);
  assert.match(button, /controller\.resumeFromOffset\(resumeOffset\)/);
  assert.match(button, /controller\.pauseAtOffset\(resumeOffset\)/);
  assert.match(button, /wasPlaying/);
  assert.match(button, /wasPaused/);
});
