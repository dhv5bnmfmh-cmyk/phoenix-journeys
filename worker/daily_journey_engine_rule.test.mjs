import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync('app/lib/data/daily_journey_catalog.dart', 'utf8');
const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');

test('daily catalog contains three reviewed city journeys', () => {
  assert.match(catalog, /beijing-forbidden-city/);
  assert.match(catalog, /shanghai-bund/);
  assert.match(catalog, /xian-city-wall/);
  assert.match(catalog, /dailyJourneyForDate/);
  assert.match(catalog, /dailyJourneyExperiences\.length/);
});

test('daily progress and stamps are namespaced by journey id', () => {
  assert.match(state, /journey\.\$\{journeyId \?\? activeJourneyId\}/);
  assert.match(state, /earnedJourneyStampIds/);
  assert.match(state, /activateJourney/);
  assert.match(state, /refreshDailyJourney/);
});

test('one stable Journey screen renders all daily cities', () => {
  assert.match(journey, /final String\? journeyId/);
  assert.match(journey, /DailyJourneyExperience _experience/);
  assert.match(journey, /_experience\.storyAnnotations/);
  assert.match(journey, /_experience\.words/);
  assert.match(journey, /_experience\.discoveries/);
  assert.match(journey, /AnimatedCityJourneyStamp/);
  assert.doesNotMatch(journey, /AnimatedForbiddenCityStamp/);
});

test('Explore opens and describes the active daily journey', () => {
  assert.match(explore, /JourneyScreen\([\s\S]*journeyId: state\.activeJourneyId/);
  assert.match(explore, /state\.activeJourney\.headline/);
  assert.match(explore, /state\.activeJourney\.discoveryTeaser/);
  assert.match(explore, /state\.refreshDailyJourney/);
});
