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
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');

test('NarrationController is the only playback and highlight clock', () => {
  assert.doesNotMatch(player, /_positionClock/);
  assert.doesNotMatch(player, /syncPlaybackHighlight/);
  assert.match(controller, /setStartHandler\([\s\S]*_startProgressClock/);
  assert.match(controller, /_nativeCharsPerSecond\(_narrationLanguageCode\) \* _speechRate/);
  assert.doesNotMatch(controller, /final charsPerSecond = 3\.35/);
});

test('Story and Discovery share the same word highlight path', () => {
  assert.match(journey, /narrationContentId: 'story'/);
  assert.match(journey, /narrationContentId: 'discovery'/);
  assert.match(journey, /narrationItemId: 'discovery-\$\{entry\.key\}'/);
});

test('premature Safari completion cannot clear an active highlight', () => {
  assert.match(controller, /if \(_currentOffset < finalReadableOffset\)/);
  assert.match(controller, /_finishNarrationSession\(\)/);
});
