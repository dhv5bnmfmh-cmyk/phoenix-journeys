import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const storyText = fs.readFileSync(
  path.join(root, 'app/lib/widgets/interactive_story_text.dart'),
  'utf8',
);

test('narration rebuilds do not dismiss an open vocabulary explanation', () => {
  assert.match(storyText, /vocabularyWordListsEquivalent/);
  assert.match(
    storyText,
    /final entriesChanged\s*=\s*!identical\(oldWidget\.entries, widget\.entries\)\s*&&\s*!vocabularyWordListsEquivalent\(/s,
  );
  assert.doesNotMatch(storyText, /oldWidget\.entries != widget\.entries/);
  assert.match(
    storyText,
    /vocabularyPopoverAutoHideDuration = Duration\(seconds: 12\)/,
  );
  assert.match(storyText, /Timer\(vocabularyPopoverAutoHideDuration/);
});
