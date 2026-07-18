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
  assert.match(
    player,
    /lastObservedOffset: _lastObservedOffset/,
  );
});

test('every resumed session resets the observed offset to its start', () => {
  const start = player.indexOf('void _beginLocalPlayback');
  const end = player.indexOf('void _observeControllerOffset', start);
  const body = player.slice(start, end);

  assert.match(body, /_lastObservedOffset = offset/);
  assert.doesNotMatch(body, /math\.max\(_lastObservedOffset, offset\)/);
});

test('pause freezes and resumes from exactly one saved offset', () => {
  const pauseStart = player.indexOf('Future<void> _pauseSession');
  const pauseEnd = player.indexOf('Future<void> _resumeSession', pauseStart);
  const pause = player.slice(pauseStart, pauseEnd);

  assert.match(pause, /final offset = _captureContinuationOffset\(\)/);
  assert.match(pause, /_resumeOffset = offset/);
  assert.match(pause, /_lastObservedOffset = offset/);
  assert.match(pause, /pauseAtOffset\(offset\)/);
});

test('speed changes keep the same saved offset', () => {
  const start = player.indexOf('Future<void> _setSpeechRate');
  const end = player.indexOf('@override\n  Widget build', start);
  const body = player.slice(start, end);

  assert.match(body, /final offset = _captureContinuationOffset\(\)/);
  assert.match(body, /pauseAtOffset\(offset\)/);
  assert.match(body, /setSpeechRate\(rate\)/);
  assert.match(body, /_beginLocalPlayback\(offset\)/);
  assert.match(body, /resumeFromOffset\(offset\)/);
});

test('estimated Safari progress rewinds instead of skipping text', () => {
  assert.match(player, /return math\.max\(0, estimated - 2\)/);
});

test('paused progress remains visible at the retained offset', () => {
  assert.match(player, /math\.max\(_resumeOffset, _lastObservedOffset\)/);
  assert.match(player, /final visibleOffset = isPlaying \|\| isPaused/);
  assert.match(player, /visibleOffset \/ total/);
});
