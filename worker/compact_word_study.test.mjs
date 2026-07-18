import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);

test('word study sheet follows its content and advances through the list', () => {
  assert.doesNotMatch(sheet, /FractionallySizedBox/);
  assert.match(sheet, /mainAxisSize: MainAxisSize\.min/);
  assert.doesNotMatch(sheet, /Expanded\([\s\S]*child: _CoreExampleCard/);
  assert.match(sheet, /下一个单词/);
  assert.match(sheet, /完成并收起/);
  assert.match(sheet, /if \(_isLast\) \{[\s\S]*Navigator\.of\(context\)\.pop/);
  assert.match(journey, /entries: words/);
  assert.match(journey, /onSpeakEntry:/);
});

test('Discovery cards follow text height and support word highlighting', () => {
  const start = journey.indexOf('Widget _discoveryPage()');
  const end = journey.indexOf('Widget _wonderPage()', start);
  const discovery = journey.slice(start, end);
  assert.match(discovery, /mainAxisSize: MainAxisSize\.min/);
  assert.match(discovery, /InteractiveStoryText/);
  assert.match(discovery, /fontSize: 9\.9/);
  assert.match(discovery, /height: 1\.12/);
});

test('narration keeps the natural Chinese voice profile', () => {
  assert.match(narration, /getVoices/);
  assert.match(narration, /natural/);
  assert.match(narration, /premium/);
  assert.match(narration, /NarrationSpeedOption\(label: '1\.0×', rate: \.36\)/);
  assert.match(narration, /setPitch\(\.98\)/);
});
