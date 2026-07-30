import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const storyText = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);
const main = readFileSync('app/lib/main.dart', 'utf8');

test('narration rebuilds do not dismiss an open vocabulary explanation', () => {
  assert.match(storyText, /vocabularyWordListsEquivalent/);
  assert.match(
    storyText,
    /final entriesChanged = !vocabularyWordListsEquivalent/,
  );
  assert.doesNotMatch(storyText, /oldWidget\.entries != widget\.entries/);
  assert.match(
    storyText,
    /vocabularyPopoverAutoHideDuration = Duration\(seconds: 12\)/,
  );
  assert.match(storyText, /Timer\(vocabularyPopoverAutoHideDuration/);
});

test('vocabulary timing stays local instead of intercepting every app timer', () => {
  assert.doesNotMatch(main, /runWithPhoenixTimerPolicy/);
  assert.doesNotMatch(main, /vocabulary_popover_timer_policy/);
});
