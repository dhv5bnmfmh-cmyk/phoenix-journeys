import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const catalog = fs.readFileSync(
  new URL(
    '../app/lib/data/all_journey_language_level_catalog.dart',
    import.meta.url,
  ),
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
  new URL(
    '../app/lib/widgets/journey_level_selector_button.dart',
    import.meta.url,
  ),
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

test('every reading band has an approved one-or-two paragraph shape', () => {
  assert.match(
    catalog,
    /PhoenixReadingBand\.beginner\s*\|\|[\s\S]*PhoenixReadingBand\.mastery => 1/,
  );
  assert.match(
    catalog,
    /PhoenixReadingBand\.elementary\s*\|\|[\s\S]*PhoenixReadingBand\.upperIntermediate => 2/,
  );
});

test('the active atlas passport exposes one global HSK and TOCFL selector', () => {
  assert.match(passport, /JourneyLevelSelectorButton\(compact: true\)/);
  assert.match(cityPassport, /JourneyLevelSelectorButton\(compact: true\)/);
  assert.match(cityPassport, /class CityPassportScreen/);
  assert.match(selector, /global-journey-level-selector/);
  assert.match(selector, /ChineseExamTrack\.values/);
  assert.match(selector, /ChineseExamTrack\.hsk/);
  assert.match(selector, /TOCFL/);
  assert.match(selector, /所有普通旅程与特殊旅程/);
});

test('every journey screen exposes the same exam-level selector', () => {
  assert.match(
    journeyScreen,
    /actions: \[\s*TextButton\.icon\([\s\S]*journey-language-level-selector/,
  );
  assert.match(journeyScreen, /切换 HSK \/ TOCFL 等级/);
  assert.match(journeyScreen, /_showLanguageProfilePicker\(\)/);
  assert.doesNotMatch(journeyScreen, /journey-difficulty-selector/);
  assert.doesNotMatch(journeyScreen, /_changeDifficulty/);
  assert.doesNotMatch(journeyScreen, /_supportedDifficulties/);
});

test('changing level refreshes current journey learning state', () => {
  assert.match(journeyScreen, /_appState\.clearGuideFeedback\(\)/);
  assert.match(journeyScreen, /_appState\.clearWritingFeedback\(\)/);
  assert.match(journeyScreen, /_challengeResolved = false/);
  assert.match(journeyScreen, /_challengeSeed \+= 1/);
  assert.match(journeyScreen, /已应用到当前旅程/);
});

test('level changes adjust all learning surfaces together', () => {
  assert.match(selector, /故事、发现、重点单词与写作问题会一起调整/);
  assert.match(catalog, /wonderQuestion: _wonderQuestion/);
  assert.match(catalog, /expressQuestion: _expressQuestion/);
  assert.match(catalog, /selectVocabulary/);
});
