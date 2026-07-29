import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const policy = readFileSync(
  'app/lib/services/vocabulary_popover_timer_policy.dart',
  'utf8',
);
const main = readFileSync('app/lib/main.dart', 'utf8');
const storyText = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('inline vocabulary explanation stays readable without changing other timers', () => {
  assert.match(
    policy,
    /legacyInlineVocabularyPopoverDuration = Duration\([\s\S]*milliseconds: 3200/,
  );
  assert.match(
    policy,
    /readableInlineVocabularyPopoverDuration = Duration\(seconds: 12\)/,
  );
  assert.match(policy, /if \(requested == legacyInlineVocabularyPopoverDuration\)/);
  assert.match(main, /runWithPhoenixTimerPolicy\(\(\) \{/);
  assert.match(storyText, /Duration\(milliseconds: 3200\)/);
  assert.match(storyText, /onClose: _hideEntry/);
});
