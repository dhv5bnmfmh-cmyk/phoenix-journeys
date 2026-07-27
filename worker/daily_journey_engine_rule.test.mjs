import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync('app/lib/data/daily_journey_catalog.dart', 'utf8');
const extended = readFileSync('app/lib/data/extended_journey_catalog.dart', 'utf8');
const cityCatalog = readFileSync('app/lib/data/journey_city_catalog.dart', 'utf8');
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');
const picker = readFileSync('app/lib/widgets/journey_picker_sheet.dart', 'utf8');
const progress = readFileSync('app/lib/widgets/journey_progress_header.dart', 'utf8');

test('daily catalog contains a reviewed seven-day city cycle', () => {
  assert.match(catalog, /beijingForbiddenCityJourney/);
  assert.match(catalog, /shanghai-bund/);
  assert.match(catalog, /summerPalaceJourneyExperience/);
  assert.match(catalog, /xian-city-wall/);
  assert.match(catalog, /extendedJourneyExperiences/);
  assert.match(extended, /hangzhou-west-lake/);
  assert.match(extended, /chengdu-kuanzhai-alley/);
  assert.match(extended, /nanjing-qinhuai-river/);
  assert.match(extended, /guangzhou-chen-clan-academy/);
  assert.match(catalog, /dailyJourneyForDate/);
  assert.match(catalog, /dailyJourneyExperiences\.length/);
});

test('new journeys include authoritative sources and complete study stages', () => {
  assert.match(extended, /StorySourceKind\.unesco/);
  assert.ok((extended.match(/StorySourceKind\.government/g) ?? []).length >= 3);
  assert.ok((extended.match(/storyAnnotations:/g) ?? []).length >= 4);
  assert.ok((extended.match(/words:/g) ?? []).length >= 4);
  assert.ok((extended.match(/discoveries:/g) ?? []).length >= 4);
  assert.ok((extended.match(/wonderQuestion:/g) ?? []).length >= 4);
  assert.ok((extended.match(/expressQuestion:/g) ?? []).length >= 4);
});

test('daily progress, Agent feedback and stamps use destination path namespaces', () => {
  assert.match(state, /binding\.storageNamespace/);
  assert.match(state, /binding\.legacyStorageNamespace/);
  assert.match(state, /activeJourneyStoragePath/);
  assert.match(state, /earnedJourneyStampIds/);
  assert.match(state, /saveGuideFeedback/);
  assert.match(state, /saveWritingFeedback/);
  assert.match(state, /activateJourney/);
});

test('one stable Journey screen renders every city and supported level', () => {
  assert.match(journey, /final String\? journeyId/);
  assert.match(journey, /DailyJourneyExperience _experience/);
  assert.match(journey, /JourneyLevelContent get _levelContent/);
  assert.match(journey, /_levelContent\.storyAnnotations/);
  assert.match(journey, /_levelContent\.words/);
  assert.match(journey, /_levelContent\.discoveries/);
  assert.match(journey, /AnimatedCityJourneyStamp/);
});

test('Explore opens every selected city and destination journey', () => {
  assert.match(explore, /openJourneyById\(String journeyId\)/);
  assert.match(explore, /state\.activateJourney\(journeyId\)/);
  assert.match(explore, /JourneyScreen\(journeyId: journeyId\)/);
  assert.match(explore, /showJourneyPickerSheet/);
  assert.match(cityCatalog, /journeyCityCatalog/);
  assert.match(cityCatalog, /destinations/);
  assert.match(picker, /journey-city-\$\{city\.id\}/);
  assert.match(picker, /journey-destination-\$\{journey\.id\}/);
  assert.match(picker, /\.pop\(journey\.id\)/);
  assert.doesNotMatch(journey, /单屏模式/);
});

test('learners follow journey steps in order until completion', () => {
  assert.match(journey, /!_appState\.journeyCompleted/);
  assert.match(journey, /safeStep != step - 1/);
  assert.match(journey, /safeStep != step \+ 1/);
  assert.match(progress, /required this\.isCompleted/);
  assert.match(progress, /final enabled = isCompleted/);
  assert.match(progress, /全部完成后可自由选择页面/);
  assert.doesNotMatch(progress, /Uri\.base/);
  assert.doesNotMatch(progress, /体验全开放/);
});
