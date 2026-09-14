import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const controller = readFileSync('app/lib/services/narration_controller.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync('app/lib/widgets/interactive_story_text.dart', 'utf8');

test('native callbacks cannot move narration progress backwards', () => {
  assert.equal((controller.match(/if \(globalStart < _currentOffset\) return;/g) ?? []).length, 2);
  assert.match(controller, /int\? get currentItemStartOffset/);
  assert.match(controller, /int get speechSessionToken/);
});

test('missing word snapshots resolve to local paragraph progress', () => {
  assert.match(journey, /controllerItemStartOffset/);
  assert.match(journey, /currentOffset - itemStart/);
  assert.match(journey, /narrationSessionToken:\s*_narration\.speechSessionToken/);
});

test('same narration session accepts forward reveal targets only', () => {
  assert.match(interactive, /requestedTarget < _lastAcceptedRevealCursor/);
  assert.match(interactive, /acceptedTarget - current/);
  assert.doesNotMatch(interactive, /distance <= 0\.01[\s\S]{0,80}_resetRevealTo/);
});
