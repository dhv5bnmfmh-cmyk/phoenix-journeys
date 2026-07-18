import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');

test('story text listens directly to the same narration controller as audio', () => {
  assert.match(controller, /NarrationHighlightSnapshot\? get highlightSnapshot/);
  assert.match(controller, /_highlightSnapshot = snapshot/);
  assert.match(interactive, /final NarrationController\? narrationController/);
  assert.match(interactive, /widget\.narrationController\?\.highlightSnapshot/);
});

test('Story and Discovery both pass the active controller to highlighted text', () => {
  const bindings = journey.match(/narrationController: _narration/g) ?? [];
  assert.equal(bindings.length, 2);
  assert.match(journey, /narrationContentId: 'story'/);
  assert.match(journey, /narrationContentId: 'discovery'/);
});

test('vocabulary detail stays content-sized and below half a phone viewport', () => {
  assert.match(sheet, /maxHeight: size\.height \* \.48/);
  assert.match(sheet, /FittedBox\(/);
  assert.match(sheet, /fit: BoxFit\.scaleDown/);
});
