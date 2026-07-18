import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('iPhone uses one narration position source', () => {
  assert.doesNotMatch(player, /_continuationClock/);
  assert.doesNotMatch(player, /_estimatedClockOffset/);
  assert.match(player, /lastObservedOffset: _lastObservedOffset/);
});

test('fresh native zero cannot pull the saved position back to the beginning', () => {
  assert.match(player, /return math\.max\(native, safeEstimated\)/);
  assert.match(player, /final safeEstimated = math\.max\(0, estimated - 1\)/);
});

test('pause freezes and resumes from exactly one saved offset', () => {
  const pauseStart = player.indexOf('Future<void> _pauseSession');
  const pauseEnd = player.indexOf('Future<void> _resumeSession', pauseStart);
  const pause = player.slice(pauseStart, pauseEnd);

  assert.match(pause, /final offset = _captureContinuationOffset\(\)/);
  assert.match(pause, /_resumeOffset = offset/);
  assert.match(pause, /pauseAtOffset\(offset\)/);
});

test('speed changes keep the same saved offset', () => {
  const start = player.indexOf('Future<void> _setSpeechRate');
  const end = player.indexOf('@override
  Widget build', start);
  const body = player.slice(start, end);

  assert.match(body, /final offset = _captureContinuationOffset\(\)/);
  assert.match(body, /pauseAtOffset\(offset\)/);
  assert.match(body, /setSpeechRate\(rate\)/);
  assert.match(body, /resumeFromOffset\(offset\)/);
});

test('playing progress comes directly from the narration controller', () => {
  assert.match(
    player,
    /isPaused[\s\S]*math\.max\(widget\.controller\.currentOffset, _resumeOffset\)[\s\S]*: widget\.controller\.currentOffset/,
  );
});
