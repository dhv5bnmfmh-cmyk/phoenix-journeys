import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('iPhone playback owns a local continuation clock', () => {
  assert.match(player, /Timer\? _continuationClock/);
  assert.match(player, /void _startContinuationClock\(int offset\)/);
  assert.match(player, /_estimatedClockOffset\(\)/);
  assert.match(player, /3\.35 \* \(widget\.controller\.speechRate \/ \.36\)/);
});

test('pause captures the local clock before stopping it', () => {
  const start = player.indexOf('Future<void> _pauseSession');
  const end = player.indexOf('Future<void> _resumeSession', start);
  const body = player.slice(start, end);
  const capture = body.indexOf('final offset = _captureContinuationOffset()');
  const stop = body.indexOf('_stopContinuationClock()');
  const pause = body.indexOf('pauseAtOffset(offset)');

  assert.ok(capture >= 0);
  assert.ok(stop > capture);
  assert.ok(pause > stop);
});

test('speed changes restart the continuation clock from the saved offset', () => {
  const start = player.indexOf('Future<void> _setSpeechRate');
  const end = player.indexOf('@override\n  Widget build', start);
  const body = player.slice(start, end);

  assert.match(body, /final offset = _captureContinuationOffset\(\)/);
  assert.match(body, /pauseAtOffset\(offset\)/);
  assert.match(body, /setSpeechRate\(rate\)/);
  assert.match(body, /_beginLocalPlayback\(offset\)/);
  assert.match(body, /resumeFromOffset\(offset\)/);
});

test('paused progress uses the retained offset instead of transient zero', () => {
  assert.match(player, /math\.max\(_resumeOffset, _lastObservedOffset\)/);
  assert.match(player, /final visibleOffset = isPlaying \|\| isPaused/);
  assert.match(player, /visibleOffset \/ total/);
});
