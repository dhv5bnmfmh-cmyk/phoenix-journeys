import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('Story and Discovery always expose an obvious live reading position', () => {
  assert.equal((journey.match(/_NowReadingStrip\(/g) ?? []).length, 3);
  assert.match(journey, /ValueKey\('now-reading-\$contentId'\)/);
  assert.match(journey, /ValueKey\('now-reading-word-\$contentId'\)/);
  assert.match(journey, /Icons\.graphic_eq_rounded/);
  assert.match(journey, /正在朗读/);
  assert.match(journey, /暂停在/);
  assert.match(journey, /当前：\$word/);
  assert.match(journey, /第 \$itemNumber\/\$totalItems 段/);
});

test('active paragraph and current word use strong visual contrast', () => {
  assert.match(journey, /const Color\(0xFFFFE7A8\)/);
  assert.match(journey, /color: active[\s\S]*PhoenixTheme\.red/);
  assert.match(interactive, /backgroundColor: const Color\(0xFFFFC928\)/);
  assert.match(interactive, /decorationThickness: 2\.1/);
  assert.match(interactive, /fontSize:[\s\S]*\+ 1\.4/);
});
