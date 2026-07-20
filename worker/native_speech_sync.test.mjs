import test from 'node:test';
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
  assert.doesNotMatch(narration, /3\.35 \* _speechRate/);
});
