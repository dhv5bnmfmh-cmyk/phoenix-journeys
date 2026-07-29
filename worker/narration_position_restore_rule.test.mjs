import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);
const player = readFileSync(
  'app/lib/widgets/narration_player_card.dart',
  'utf8',
);

test('journey narration position is namespaced and restored without autoplay', () => {
  assert.match(state, /saveJourneyNarrationPosition/);
  assert.match(state, /_key\('narrationContentId'\)/);
  assert.match(state, /_key\('narrationOffset'\)/);
  assert.match(journey, /_persistNarrationPosition/);
  assert.match(journey, /_restoreNarrationPosition/);
  assert.match(journey, /_narration\.preparePaused/);
  assert.match(narration, /void preparePaused/);
  assert.match(narration, /_status = NarrationStatus\.paused/);
  assert.match(narration, /bool get isRestoredPosition/);
  assert.match(player, /上次停在这里 · \$percent% · 点击继续/);
});

test('restart and completion remove stale narration positions', () => {
  assert.ok(
    (state.match(/prefs\.remove\(_key\('narrationContentId'\)\)/g) ?? [])
      .length >= 2,
  );
  assert.ok(
    (state.match(/prefs\.remove\(_key\('narrationOffset'\)\)/g) ?? [])
      .length >= 2,
  );
});

test('active narration creates bounded checkpoints and clears completion', () => {
  assert.match(journey, /bool shouldCheckpointNarration/);
  assert.match(journey, /\(offset - lastSavedOffset\)\.abs\(\) >= 12/);
  assert.match(
    journey,
    /Timer\(const Duration\(seconds: 2\), \(\) \{/,
  );
  assert.match(journey, /_narration\.addListener\(_handleNarrationCheckpoint\)/);
  assert.match(
    journey,
    /_narration\.removeListener\(_handleNarrationCheckpoint\)/,
  );
  assert.match(
    journey,
    /offset >= total[\s\S]*clearJourneyNarrationPosition/,
  );
});
