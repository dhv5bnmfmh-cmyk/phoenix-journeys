import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('speed changes never call setSpeechRate while narration is still playing', () => {
  const start = player.indexOf('Future<void> _setSpeechRate');
  const end = player.indexOf('@override\n  Widget build', start);
  const body = player.slice(start, end);

  assert.match(body, /if \(wasPlaying\)[\s\S]*pauseAtOffset\(offset\)/);
  assert.match(body, /await widget\.controller\.setSpeechRate\(rate\)/);
  assert.match(body, /await widget\.controller\.resumeFromOffset\(offset\)/);
  assert.doesNotMatch(
    body,
    /setSpeechRate\(rate\)[\s\S]*status != NarrationStatus\.playing/,
  );
});
