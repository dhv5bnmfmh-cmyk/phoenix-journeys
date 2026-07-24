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

test('stalled Safari offsets cannot freeze or rewind Phoenix progress', () => {
  assert.match(controller, /if \(globalStart < _currentOffset\) return;/);
  assert.match(
    controller,
    /final nativeAdvanced = globalStart > _lastNativeOffset;/,
  );
  assert.match(
    controller,
    /if \(nativeAdvanced\) \{[\s\S]*_lastNativeProgressAt = now;/,
  );
  assert.doesNotMatch(
    controller,
    /_lastNativeProgressAt = DateTime\.now\(\);/,
  );
});

test('visible percentage leaves zero immediately while narration is playing', () => {
  assert.match(
    player,
    /final percent\s*=\s*isPlaying[\s\S]*roundedPercent\.clamp\(1, 99\)/,
  );
});
