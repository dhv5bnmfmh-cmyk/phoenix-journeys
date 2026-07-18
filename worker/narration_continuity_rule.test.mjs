import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);

test('changing speed never starts a second narration session', () => {
  const start = controller.indexOf('Future<void> setSpeechRate');
  const end = controller.indexOf('Future<void> stop', start);
  const body = controller.slice(start, end);

  assert.match(body, /_speechRate = option\.rate/);
  assert.doesNotMatch(body, /_speakFrom/);
});

test('resume clamps to the saved position instead of zero', () => {
  const start = controller.indexOf('Future<void> resume()');
  const end = controller.indexOf('Future<void> resumeFromOffset', start);
  const body = controller.slice(start, end);

  assert.match(body, /_currentOffset\.clamp\(0, maxOffset\)/);
  assert.doesNotMatch(body, /\? 0 : _currentOffset/);
});

test('speaking from an end-adjacent offset cannot restart at the beginning', () => {
  const start = controller.indexOf('Future<void> _speakFrom');
  const end = controller.indexOf('Future<void> _startProgressWatchdog', start);
  const body = controller.slice(start, end);

  assert.match(body, /offset\.clamp\(0, maxOffset\)/);
  assert.doesNotMatch(body, /offset >= _plan\.text\.length[\s\S]*\? 0/);
});

test('audio, progress and highlight share currentOffset', () => {
  assert.match(controller, /_currentOffset = safeOffset/);
  assert.match(controller, /_applyProgress\(safeOffset\)/);
  assert.match(controller, /_speechBaseOffset = safeOffset/);
});
