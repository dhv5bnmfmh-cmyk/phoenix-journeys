import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('Phoenix clock drives highlighting during active playback', () => {
  assert.match(controller, /void syncPlaybackHighlight\(/);
  assert.match(player, /widget\.controller\.syncPlaybackHighlight\([\s\S]*offset: nextOffset/);
});

test('highlight clears only after the local playback clock reaches the end', () => {
  assert.match(
    player,
    /if \(total > 0 && nextOffset >= total\)[\s\S]*clearPlaybackHighlight/,
  );
});
