import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

// Compact mode moves replay beside play/pause and leaves only a thin progress
// rail below, so the card becomes shorter without dropping any control.
test('compact narration player preserves controls in a shorter layout', () => {
  assert.match(player, /compact \? 6 : 10/);
  assert.match(player, /compact \? 3 : 8/);
  assert.match(player, /size: compact \? 32 : 44/);
  assert.match(player, /key: const ValueKey\('narration-compact-progress'\)/);
  assert.match(player, /minHeight: 3/);
  assert.match(player, /compact: true/);
  assert.match(player, /width: compact \? 26 : 30/);
  assert.match(player, /height: compact \? 26 : 30/);
});

test('full narration player keeps detailed segment and percent labels', () => {
  assert.match(player, /第 \$\{currentItem \+ 1\} \/ \$itemCount 段/);
  assert.match(player, /FontFeature\.tabularFigures/);
});
