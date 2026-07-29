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
const resumeTest = readFileSync(
  'app/test/narration_resume_offset_test.dart',
  'utf8',
);

test('journey narration position is namespaced and restored without autoplay', () => {
  assert.match(state, /saveJourneyNarrationPosition/);
  assert.match(state, /_key\('narrationContentId'\)/);
  assert.match(state, /_key\('narrationContentSignature'\)/);
  assert.match(state, /_key\('narrationOffset'\)/);
  assert.match(journey, /_persistNarrationPosition/);
  assert.match(journey, /_restoreNarrationPosition/);
  assert.match(journey, /_narration\.preparePaused/);
  assert.match(narration, /void preparePaused/);
  assert.match(narration, /_status = NarrationStatus\.paused/);
  assert.match(narration, /bool get isRestoredPosition/);
  assert.match(player, /上次停在这里 · \$percent% · 点击继续/);
});

test('saved position is discarded when narration content changes', () => {
  assert.match(journey, /String narrationContentSignature/);
  assert.match(
    journey,
    /journeyNarrationSignatureFor\(contentId\)[\s\S]*narrationContentSignature\(items\)/,
  );
  assert.match(
    journey,
    /if \(!matchesStep \|\| !matchesContent\)/,
  );
  assert.match(
    journey,
    /clearJourneyNarrationPosition\(contentId: contentId\)/,
  );
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
  assert.doesNotMatch(
    resumeTest,
    /addTearDown\(controller\.dispose\)/,
    'restore tests must not invoke a real device TTS plugin',
  );
});


test('step changes checkpoint narration before replacing the active plan', () => {
  assert.match(journey, /void _checkpointNarrationBeforeStepChange\(\)/);
  assert.match(
    journey,
    /if \(safeStep != step\) \{\s*_checkpointNarrationBeforeStepChange\(\);\s*\}/,
  );
  assert.match(
    journey,
    /_narrationCheckpointTimer\?\.cancel\(\);[\s\S]*unawaited\(_persistNarrationPosition\(\)\)/,
  );
});

test('unrelated feedback cleanup preserves narration and completion clears it', () => {
  const feedbackStart = state.indexOf('Future<void> clearWritingFeedback()');
  const restartStart = state.indexOf('Future<void> restartJourney()');
  const feedbackBody = state.slice(feedbackStart, restartStart);
  assert.doesNotMatch(feedbackBody, /journeyNarrationContentId = null/);
  assert.doesNotMatch(feedbackBody, /narrationContentSignature/);
  assert.doesNotMatch(feedbackBody, /narrationOffset/);

  const completionStart = state.indexOf('Future<void> completeJourney(');
  const completionBody = state.slice(completionStart);
  assert.match(completionBody, /journeyNarrationContentId = null/);
  assert.match(completionBody, /prefs\.remove\(_key\('narrationContentId'\)\)/);
  assert.match(completionBody, /prefs\.remove\(_key\('narrationOffset'\)\)/);
});


test('story and discovery keep independent narration checkpoints', () => {
  assert.match(state, /_journeyNarrationSignatures/);
  assert.match(state, /_journeyNarrationOffsets/);
  assert.match(state, /journeyNarrationSignatureFor\(String contentId\)/);
  assert.match(state, /journeyNarrationOffsetFor\(String contentId\)/);
  assert.match(state, /_key\('narration\.\$contentId\.\$suffix'\)/);
  assert.match(
    state,
    /prefs\.setString\(_narrationKey\(contentId, 'signature'\)/,
  );
  assert.match(
    state,
    /prefs\.setInt\(_narrationKey\(contentId, 'offset'\)/,
  );
});

test('returning to a narration page restores its own checkpoint', () => {
  assert.match(
    journey,
    /void _restoreNarrationPosition\(\[String\? requestedContentId\]\)/,
  );
  assert.match(
    journey,
    /journeyNarrationOffsetFor\('discovery'\) > 0[\s\S]*_restoreNarrationPosition\('discovery'\)/,
  );
  assert.match(
    journey,
    /safeStep == 0[\s\S]*_restoreNarrationPosition\('story'\)/,
  );
  assert.match(
    journey,
    /clearJourneyNarrationPosition\(contentId: contentId\)/,
  );
});
