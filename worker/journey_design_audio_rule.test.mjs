import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const read = (path) => readFileSync(path, 'utf8');
const journey = read('app/lib/screens/journey_screen.dart');
const player = read('app/lib/widgets/narration_player_card.dart');
const theme = read('app/lib/theme/phoenix_theme.dart');
const narration = read('app/lib/services/narration_controller.dart');

test('all journey cards use the shared Phoenix surface and typography tokens', () => {
  assert.match(theme, /journeyPanelDecoration/);
  assert.match(theme, /journeySolidPanelDecoration/);
  assert.ok((journey.match(/PhoenixTheme\.journeyPanelDecoration/g) ?? []).length >= 2);
  assert.match(player, /PhoenixTheme\.journeyPanelDecoration/);
  assert.match(player, /PhoenixTheme\.journeyTitleStyle/);
  assert.match(player, /PhoenixTheme\.journeyMetaStyle/);
});

test('vocabulary to Discovery starts speech inside the continue gesture', () => {
  assert.match(journey, /unawaited\(_playDiscoveries\(stopEngineFirst: false\)\)/);
  assert.match(narration, /bool stopEngineFirst = true/);
  assert.match(narration, /_speakFrom\(0, stopEngineFirst: stopEngineFirst\)/);
  assert.match(narration, /cancelExisting: stopEngineFirst/);
  const webSpeech = read('app/lib/services/phoenix_web_speech_web.dart');
  assert.match(webSpeech, /bool cancelExisting = true/);
  assert.match(webSpeech, /if \(cancelExisting\) synth\.cancel\(\)/);
});
