import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');
test('word cards reveal metadata only when available space allows it', () => {
  assert.match(journey, /showPartOfSpeech/);
  assert.match(journey, /showMeaning/);
  assert.match(journey, /entry\.partOfSpeech/);
  assert.match(journey, /entry\.simpleChinese/);
});
test('all Phoenix speech uses the unified 1x to 3x speed scale', () => {
  for (const label of ['1.0×', '1.5×', '2.0×', '2.5×', '3.0×']) assert.ok(narration.includes(label));
  assert.doesNotMatch(narration, /label: '0\.8×'/);
  assert.doesNotMatch(narration, /label: '1\.2×'/);
  assert.match(narration, /_ttsSpeechRate\(_speechRate\)/);
});
test('word details and reading notes expose speed controls', () => {
  assert.match(journey, /support-speed-control/);
  assert.match(sheet, /word-detail-speed-control/);
});
