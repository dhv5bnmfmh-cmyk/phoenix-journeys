import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

test('story and discovery side controls keep stable geometry during narration', () => {
  assert.match(journey, /ValueKey\('compact-text-\$index'\)/);
  assert.doesNotMatch(journey, /compact-text-\$index-\$\{active/);
  assert.match(journey, /fontWeight: FontWeight\.w700/);
  assert.match(journey, /backgroundColor: active/);
});

test('cinematic glyphs and reading marker use one fixed line box', () => {
  assert.match(interactive, /strutStyle: StrutStyle\(/);
  assert.match(interactive, /forceStrutHeight: true/);
  assert.match(interactive, /height: style\.height \?\? 1\.22/);
  assert.match(interactive, /height: fontSize \* lineHeight/);
  assert.doesNotMatch(interactive, /padding: const EdgeInsets\.only\(bottom: 5\)/);
});
