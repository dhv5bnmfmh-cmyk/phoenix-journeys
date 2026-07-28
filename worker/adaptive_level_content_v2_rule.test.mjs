import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const catalog = fs.readFileSync(
  new URL('../app/lib/data/all_journey_language_level_catalog.dart', import.meta.url),
  'utf8',
);
const passport = fs.readFileSync(
  new URL('../app/lib/screens/passport_screen.dart', import.meta.url),
  'utf8',
);
const cityPassport = fs.readFileSync(
  new URL('../app/lib/screens/city_passport_screen.dart', import.meta.url),
  'utf8',
);
const journeyScreen = fs.readFileSync(
  new URL('../app/lib/screens/journey_screen.dart', import.meta.url),
  'utf8',
);
const selector = fs.readFileSync(
  new URL('../app/lib/widgets/journey_level_selector_button.dart', import.meta.url),
  'utf8',
);
const agent = fs.readFileSync(
  new URL('../app/lib/agents/phoenix_language_level_agent.dart', import.meta.url),
  'utf8',
);

 test('adaptive journeys select aligned sentence packets instead of raw paragraph pairs', () => {
  assert.match(catalog, /_storySentencePackets/);
  assert.match(catalog, /_selectNarrativePackets/);
  assert.match(catalog, /_partitionPackets/);
  assert.match(catalog, /_alignedSentence/);
  assert.doesNotMatch(catalog, /_pairedStory/);
  assert.doesNotMatch(catalog, /_firstChineseSentence/);
});

test('every reading band keeps an approved one-or-two paragraph shape', () => {
  assert.match(catalog, /paragraphCount: plan\.paragraphCount/);
  assert.match(agent, /paragraphCount: 1/);
  assert.match(agent, /paragraphCount: 2/);
});

test('passport surfaces expose the shared Phoenix plus-minus control', () => {
  assert.match(passport, /JourneyLevelSelectorButton\(compact: true\)/);
  assert.match(cityPassport, /JourneyLevelSelectorButton\(compact: true\)/);
  assert.match(selector, /global-journey-level-selector/);
  assert.match(selector, /phoenix-level-minus/);
  assert.match(selector, /phoenix-level-plus/);
  assert.match(selector, /Lv\.\$level/);
  assert.doesNotMatch(selector, /ChineseExamTrack\.values/);
  assert.doesNotMatch(selector, /showModalBottomSheet/);
});

test('every journey step keeps the level stepper in the upper-right app bar', () => {
  assert.match(journeyScreen, /JourneyLevelSelectorButton\(compact: true\)/);
  assert.match(journeyScreen, /_phoenixLevelController\.addListener/);
  assert.match(journeyScreen, /_handlePhoenixLevelChanged/);
  assert.match(journeyScreen, /_challengeSeed \+= 1/);
  assert.match(journeyScreen, /已即时应用到当前故事与挑战/);
  assert.doesNotMatch(journeyScreen, /journey-language-level-selector/);
});

test('Phoenix exposes ten fused levels while retaining legacy calibration data', () => {
  assert.match(agent, /static const List<ChineseProficiencyProfile> phoenixProfiles/);
  assert.equal((agent.match(/phoenixLevel: /g) ?? []).length, 10);
  assert.match(agent, /phoenixLevelFromStorage/);
  assert.match(agent, /hskProfiles/);
  assert.match(agent, /tocflProfiles/);
});

test('level changes adjust all learning surfaces together', () => {
  assert.match(journeyScreen, /_narration\.stop\(\)/);
  assert.match(journeyScreen, /setSpeechRate/);
  assert.match(journeyScreen, /clearGuideFeedback/);
  assert.match(journeyScreen, /clearWritingFeedback/);
  assert.match(catalog, /wonderQuestion: _wonderQuestion/);
  assert.match(catalog, /expressQuestion: _expressQuestion/);
  assert.match(catalog, /selectVocabulary/);
});
