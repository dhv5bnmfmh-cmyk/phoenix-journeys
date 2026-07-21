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
  assert.match(journey, /entries: (?:_experience\.)?words/);
  assert.match(journey, /onSpeakEntry:/);
});

test('Words grid fills the available height without a fixed card cap', () => {
  assert.doesNotMatch(journey, /cellHeight\.clamp\(38\.0, 70\.0\)/);
  assert.match(journey, /safeCellHeight = math\.max\(1\.0, cellHeight\)/);
  assert.match(journey, /final ratio = cellWidth \/ safeCellHeight/);
});

test('Discovery cards stay connected and support word highlighting', () => {
  const start = journey.indexOf('Widget _discoveryPage()');
  const end = journey.indexOf('Widget _wonderPage()', start);
  const discovery = journey.slice(start, end);
  assert.match(discovery, /adaptive-discovery-text-area/);
  assert.doesNotMatch(discovery, /MainAxisAlignment\.spaceBetween/);
  assert.match(discovery, /MainAxisAlignment\.start/);
  assert.match(discovery, /InteractiveStoryText/);
  assert.match(discovery, /fontSize: fontSize/);
  assert.match(discovery, /height: 1\.2/);
});

test('narration keeps natural voice selection and speed profile', () => {
  assert.match(narration, /getVoices/);
  assert.match(narration, /natural/);
  assert.match(narration, /premium/);
  assert.match(narration, /NarrationSpeedOption\(label: '1\.0×', rate: 1\.0\)/);
  assert.match(narration, /setPitch\(\.98\)/);
});

// Keep these three mobile actions in visual and keyboard order.
test('word detail actions keep Save Previous and Next on one row', () => {
  assert.match(sheet, /bool get _isFirst => _index == 0;/);
  assert.match(sheet, /Future<void> _previousWord\(\) async/);
  assert.match(sheet, /_index -= 1;/);
  assert.match(sheet, /key: const ValueKey\('previous-word-button'\)/);
  assert.match(
    sheet,
    /onPressed: _isSpeaking \|\| _isFirst \? null : _previousWord/,
  );

  const save = sheet.indexOf("state.displayText(isSaved ? '已收藏' : '收藏生词')");
  const previous = sheet.indexOf("state.displayText('上一个生词')");
  const next = sheet.indexOf("_isLast ? '完成并收起' : '下一个单词'");
  assert.ok(save >= 0 && save < previous && previous < next);
});
