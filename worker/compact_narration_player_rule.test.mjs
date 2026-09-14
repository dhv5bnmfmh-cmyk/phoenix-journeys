import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);
const seek = readFileSync(
  'app/lib/services/narration_seek.dart',
  'utf8',
);
const rail = readFileSync(
  'app/lib/widgets/narration_seek_rail.dart',
  'utf8',
);

// Compact mode keeps replay beside play/pause and uses a visible, draggable
// progress rail plus one concise status line, so long stories remain readable
// without turning the player into a tall control panel.
test('compact narration player preserves controls and draggable progress', () => {
  assert.match(player, /compact \? 6 : 10/);
  assert.match(player, /compact \? 3 : 8/);
  assert.match(player, /size: compact \? 32 : 44/);
  assert.match(player, /key: const ValueKey\('narration-compact-progress'\)/);
  assert.match(player, /NarrationSeekRail/);
  assert.match(player, /minHeight: 4/);
  assert.match(player, /narration-compact-label/);
  assert.match(player, /剩余 \$remaining 字/);
  assert.match(player, /定位到 \$percent%/);
  assert.match(player, /compact: true/);
  assert.match(player, /width: compact \? 26 : 30/);
  assert.match(player, /height: compact \? 26 : 30/);
  assert.match(rail, /onHorizontalDragStart/);
  assert.match(rail, /onHorizontalDragUpdate/);
  assert.match(rail, /onHorizontalDragEnd/);
  assert.match(rail, /朗读进度，可拖动跳转/);
});

test('seek restarts safely from the selected character offset', () => {
  assert.match(seek, /narrationSeekOffset/);
  assert.match(seek, /await stop\(resetPosition: false\)/);
  assert.match(seek, /await pauseAtOffset\(safeOffset\)/);
  assert.match(seek, /await resumeFromOffset\(safeOffset\)/);
});

test('full narration player keeps detailed segment, percent, and seek labels', () => {
  assert.match(player, /key: const ValueKey\('narration-full-progress'\)/);
  assert.match(player, /第 \$\{currentItem \+ 1\} \/ \$itemCount 段/);
  assert.match(player, /正在定位第 \$displayOffset 字/);
  assert.match(player, /FontFeature\.tabularFigures/);
});
