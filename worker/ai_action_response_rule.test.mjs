import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('Think and Express dismiss the iPhone keyboard before calling AI', () => {
  assert.match(screen, /import 'package:flutter\/services\.dart'/);
  assert.match(screen, /focusNode\.unfocus\(\)/);
  assert.match(screen, /SystemChannels\.textInput\.invokeMethod<void>\('TextInput\.hide'\)/);
  assert.match(screen, /_prepareAgentAction\([\s\S]*wonderFocusNode/);
  assert.match(screen, /_prepareAgentAction\([\s\S]*expressFocusNode/);
});

test('both agent actions show immediate progress instead of appearing frozen', () => {
  assert.match(screen, /PhoenixGuideAgent 正在思考/);
  assert.match(screen, /PhoenixWritingAgent 正在批改/);
  assert.match(screen, /CircularProgressIndicator/);
  assert.match(screen, /SnackBarBehavior\.floating/);
});

test('both agent actions always clear loading state', () => {
  const guideStart = screen.indexOf('Future<void> _askGuide');
  const writingStart = screen.indexOf('Future<void> _reviewWriting');
  const showStart = screen.indexOf('Future<void> _showGuideFeedback');
  const guide = screen.slice(guideStart, writingStart);
  const writing = screen.slice(writingStart, showStart);

  assert.match(guide, /try \{/);
  assert.match(guide, /finally \{/);
  assert.match(guide, /_guideLoading = false/);
  assert.match(writing, /try \{/);
  assert.match(writing, /finally \{/);
  assert.match(writing, /_writingLoading = false/);
});

test('AI results open above Safari with the root navigator', () => {
  const matches = screen.match(/useRootNavigator: true/g) ?? [];
  assert.ok(matches.length >= 2);
  assert.match(screen, /await _showGuideFeedback\(\)/);
  assert.match(screen, /await _showWritingFeedback\(\)/);
});

test('short input receives a visible message', () => {
  assert.match(screen, /请先写下一点想法/);
  assert.match(screen, /请先写下至少两个字/);
});
