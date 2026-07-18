import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('Story and Discovery show reading position only inside the text', () => {
  assert.doesNotMatch(journey, /_NowReadingStrip/);
  assert.doesNotMatch(journey, /朗读位置/);
  assert.doesNotMatch(journey, /正在朗读/);
  assert.doesNotMatch(journey, /当前：\$word/);
  assert.equal(
    (journey.match(/highlightStart: isActive \? snapshot!\.start : null/g) ?? [])
      .length,
    2,
  );
});

test('current word is unmistakably different from surrounding text', () => {
  assert.match(journey, /const Color\(0xFFFFF2EE\)/);
  assert.match(journey, /color: active[\s\S]*PhoenixTheme\.red/);
  assert.match(interactive, /color: Colors\.white/);
  assert.match(interactive, /backgroundColor: const Color\(0xFF8F1D18\)/);
  assert.match(interactive, /fontSize:[\s\S]*\+ 2\.2/);
  assert.match(interactive, /fontWeight: FontWeight\.w900/);
});
