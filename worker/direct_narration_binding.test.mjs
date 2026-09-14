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

test('Story, Discovery, and word details share the active narration controller', () => {
  const bindings = journey.match(/narrationController: _narration/g) ?? [];
  assert.ok(bindings.length >= 3);
  assert.match(journey, /narrationContentId: 'story'/);
  assert.match(journey, /narrationContentId: 'discovery'/);
  assert.match(journey, /showWordDetail\([\s\S]*narrationController: _narration/);
});

test('vocabulary detail stays content-sized within a compact phone viewport', () => {
  assert.match(sheet, /maxHeight: size\.height \* \.52/);
  assert.match(sheet, /FittedBox\(/);
  assert.match(sheet, /fit: BoxFit\.scaleDown/);
});
