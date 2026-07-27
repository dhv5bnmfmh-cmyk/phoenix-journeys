import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('Think and Express use the bottom primary action area', () => {
  assert.doesNotMatch(screen, /ask-phoenix-guide-agent/);
  assert.doesNotMatch(screen, /ask-phoenix-writing-agent/);
  assert.match(screen, /buttonText: hasFeedback[\s\S]*问 PhoenixGuideAgent/);
  assert.match(screen, /buttonText: hasFeedback[\s\S]*请 PhoenixWritingAgent 批改/);
});

test('Agent buttons become Continue only after feedback exists', () => {
  const matches = screen.match(/hasFeedback\s*\?\s*'继续'/g) ?? [];
  assert.equal(matches.length, 2);
  assert.match(
    screen,
    /onNext: hasFeedback\s*\?\s*null\s*:\s*\(\) => unawaited\(_askGuide\(\)\)/,
  );
  assert.match(
    screen,
    /onNext: hasFeedback\s*\?\s*null\s*:\s*\(\) => unawaited\(_reviewWriting\(\)\)/,
  );
});

test('primary action shows loading and cannot accidentally continue', () => {
  assert.match(screen, /bool primaryLoading = false/);
  assert.match(screen, /bool primaryEnabled = true/);
  assert.match(screen, /primaryEnabled && !primaryLoading/);
  assert.match(screen, /CircularProgressIndicator/);
});

test('Agent actions safely close the iPhone keyboard and show results', () => {
  assert.match(screen, /focusNode\.unfocus\(\)/);
  assert.match(screen, /SystemChannels\.textInput/);
  assert.match(screen, /useRootNavigator: true/);
  assert.match(screen, /await _showGuideFeedback\(\)/);
  assert.match(screen, /await _showWritingFeedback\(\)/);
});

test('editing an answer resets the primary action back to Agent', () => {
  assert.match(screen, /_guideFeedback = null/);
  assert.match(screen, /_writingFeedback = null/);
});
