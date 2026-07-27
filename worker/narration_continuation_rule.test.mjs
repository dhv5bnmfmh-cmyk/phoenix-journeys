import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

function methodBody(startMarker, endMarker) {
  const start = player.indexOf(startMarker);
  const end = player.indexOf(endMarker, start + startMarker.length);
  assert.ok(start >= 0 && end > start, `missing ${startMarker}`);
  return player.slice(start, end);
}

test('pause captures one stable continuation offset', () => {
  const pause = methodBody(
    'Future<void> _pauseSession',
    'Future<void> _resumeSession',
  );
  assert.match(pause, /final offset = _captureContinuationOffset\(\)/);
  assert.match(pause, /_resumeOffset = offset/);
  assert.match(pause, /pauseAtOffset\(offset\)/);
});

test('speed change freezes, changes rate, and resumes from the same offset', () => {
  const speed = methodBody(
    'Future<void> _setSpeechRate',
    '@override\n  Widget build',
  );
  const capture = speed.indexOf('final offset = _captureContinuationOffset()');
  const pause = speed.indexOf('pauseAtOffset(offset)');
  const rate = speed.indexOf('setSpeechRate(rate)');
  const resume = speed.indexOf('resumeFromOffset(offset)');

  assert.ok(capture >= 0, 'speed change must capture the continuation offset');
  assert.ok(pause > capture, 'speed change must pause after capturing offset');
  assert.ok(rate > pause, 'speed must change only after narration is frozen');
  assert.ok(resume > rate, 'narration must resume from the captured offset');
});

test('transient Safari zero cannot erase the last visible position', () => {
  assert.match(player, /int resolveNarrationContinuationOffset/);
  assert.match(
    player,
    /estimatedOffset: math\.max\(controllerOffset, lastObservedOffset\)/,
  );
  assert.match(player, /int _lastObservedOffset = 0/);
  assert.match(player, /_observeControllerOffset\(controllerStatus\)/);
});

test('Story and Discovery keep the same continuation-safe player', () => {
  assert.equal((journey.match(/NarrationPlayerCard\(/g) ?? []).length >= 2, true);
  assert.match(journey, /contentId: 'story'/);
  assert.match(journey, /contentId: 'discovery'/);
});
