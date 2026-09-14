import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('Agent feedback is persisted inside each journey namespace', () => {
  assert.match(state, /guideFeedbackReply/);
  assert.match(state, /writingFeedbackCorrected/);
  assert.match(state, /saveGuideFeedback/);
  assert.match(state, /saveWritingFeedback/);
  assert.match(state, /_key\('guideFeedbackReply'\)/);
  assert.match(state, /_key\('writingFeedbackCorrected'\)/);
});

test('Journey restores saved feedback after reopening', () => {
  assert.match(screen, /_appState\.hasGuideFeedback/);
  assert.match(screen, /_appState\.hasWritingFeedback/);
  assert.match(screen, /PhoenixGuideFeedback\(/);
  assert.match(screen, /PhoenixWritingFeedback\(/);
});

test('Think and Express show review buttons between Back and Continue', () => {
  assert.match(screen, /String\? secondaryButtonText/);
  assert.match(screen, /journey-secondary-\$title/);
  assert.match(screen, /secondaryButtonText: hasFeedback \? 'AI 回答' : null/);
  assert.match(screen, /secondaryButtonText: hasFeedback \? 'AI 批改' : null/);
  const back = screen.indexOf("'上一步'");
  const secondary = screen.indexOf('if (secondaryButtonText != null');
  const primary = screen.indexOf('child: FilledButton.icon', secondary);
  assert.ok(back >= 0 && secondary > back && primary > secondary);
});

test('editing an answer removes feedback that no longer matches it', () => {
  assert.match(screen, /clearGuideFeedback\(\)/);
  assert.match(screen, /clearWritingFeedback\(\)/);
});
