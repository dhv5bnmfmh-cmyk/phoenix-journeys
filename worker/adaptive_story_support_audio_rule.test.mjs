import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync('app/lib/services/narration_controller.dart', 'utf8');

test('Story and Discovery fit their text to the available phone height', () => {
  assert.match(journey, /_fitJourneyTextSize/);
  assert.match(journey, /adaptive-story-text-area/);
  assert.match(journey, /adaptive-discovery-text-area/);
  assert.match(journey, /TextPainter/);
  assert.match(journey, /MainAxisAlignment\.spaceBetween/);
  assert.match(journey, /maxSize: 20/);
  assert.match(journey, /maxSize: 19/);
});

test('reading notes expose native-language and English speakers', () => {
  assert.match(journey, /support-native-audio/);
  assert.match(journey, /support-english-audio/);
  assert.match(journey, /Icons\.volume_up_rounded/);
  assert.match(journey, /onSpeakNative/);
  assert.match(journey, /onSpeakEnglish/);
  assert.match(journey, /languageCode: 'en-US'/);
  assert.match(journey, /_ => 'vi-VN'/);
});

test('narration selects voices for Vietnamese and English as well as Chinese', () => {
  assert.match(narration, /requestedPrefix/);
  assert.match(narration, /lowerLocale\.startsWith\(requestedPrefix\)/);
  assert.doesNotMatch(narration, /lowerLocale\.startsWith\('zh'\)/);
});
