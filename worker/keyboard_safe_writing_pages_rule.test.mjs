import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('journey screen resizes above the iPhone keyboard', () => {
  assert.match(screen, /resizeToAvoidBottomInset: true/);
  assert.match(screen, /MediaQuery\.viewInsetsOf\(context\)\.bottom > 0/);
});

test('keyboard mode hides fixed navigation that previously covered writing', () => {
  const start = screen.indexOf('Widget _page');
  const end = screen.indexOf('Widget _storyPage', start);
  const body = screen.slice(start, end);

  assert.match(body, /bool keyboardAdaptive = false/);
  assert.match(body, /if \(!keyboardVisible\)[\s\S]*JourneyProgressHeader/);
  assert.match(body, /if \(!keyboardVisible\)[\s\S]*FilledButton\.icon/);
  assert.match(body, /输入中/);
});

test('writing fields keep persistent focus nodes on iPhone Safari', () => {
  assert.match(screen, /final wonderFocusNode = FocusNode/);
  assert.match(screen, /final expressFocusNode = FocusNode/);
  assert.match(screen, /final memoryFocusNode = FocusNode/);
  assert.match(screen, /focusNode: wonderFocusNode/);
  assert.match(screen, /focusNode: expressFocusNode/);
  assert.match(screen, /focusNode: memoryFocusNode/);
  assert.match(screen, /wonderFocusNode\.hasFocus/);
  assert.match(screen, /expressFocusNode\.hasFocus/);
  assert.match(screen, /memoryFocusNode\.hasFocus/);
});

test('Safari keyboard cannot be dismissed by a synthetic tap outside', () => {
  assert.doesNotMatch(screen, /onTapOutside:/);
  assert.doesNotMatch(screen, /primaryFocus\?\.unfocus/);
});

for (const page of ['_wonderPage', '_expressPage', '_memoryPage']) {
  test(`${page} gives the text field the keyboard viewport`, () => {
    const start = screen.indexOf(`Widget ${page}`);
    const end = screen.indexOf('Widget _', start + 8);
    const body = screen.slice(start, end);

    assert.match(body, /keyboardAdaptive: true/);
    assert.match(body, /Expanded\([\s\S]*TextField\(/);
    assert.match(body, /scrollPadding: const EdgeInsets\.only\(bottom: 24\)/);
  });
}

test('all three writing fields have stable test keys', () => {
  assert.match(screen, /wonder-writing-field/);
  assert.match(screen, /express-writing-field/);
  assert.match(screen, /memory-writing-field/);
});
