import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const storyText = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('narration auto-follow is paragraph-scoped and pause-safe', () => {
  assert.match(storyText, /shouldAutoFollowNarrationItem/);
  assert.match(storyText, /status == NarrationStatus\.playing/);
  assert.match(storyText, /!wasActive \|\| sessionChanged/);
  assert.match(storyText, /Scrollable\.ensureVisible/);
  assert.match(storyText, /alignment: \.34/);
  assert.match(storyText, /Duration\(milliseconds: 360\)/);
});

test('active narration paragraph has a bounded visual surface', () => {
  assert.match(storyText, /narration-follow-surface/);
  assert.match(storyText, /AnimatedContainer/);
  assert.match(storyText, /Color\(0x16FFD879\)/);
  assert.match(storyText, /BorderRadius\.circular\(8\)/);
});
