import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const shell = readFileSync('app/lib/screens/home_shell.dart', 'utf8');
const passport = readFileSync(
  'app/lib/screens/city_passport_screen.dart',
  'utf8',
);

test('Home uses the city-grouped Passport screen', () => {
  assert.match(shell, /import 'city_passport_screen\.dart';/);
  assert.match(shell, /CityPassportScreen\(\)/);
  assert.doesNotMatch(shell, /import 'passport_screen\.dart';/);
});

test('Passport keeps every city journey reachable on the transparent atlas', () => {
  assert.match(passport, /itemCount: journeyCityCatalog\.length/);
  assert.match(passport, /_CityCollection\(/);
  assert.match(passport, /city\.destinations/);
  assert.match(passport, /passport-city-\$\{city\.id\}/);
  assert.match(passport, /passport-destination-\$\{journey\.id\}/);
  assert.match(passport, /china-passport-atlas-v2\.webp/);
});

test('Passport tiles only render a small transparent stamp and journey name', () => {
  assert.match(passport, /CityJourneyStamp\(/);
  assert.match(passport, /size: 36/);
  assert.match(passport, /transparentInk: true/);
  assert.match(passport, /state\.displayText\(journey\.place\)/);
  assert.match(passport, /JourneyScreen\(journeyId: journey\.id\)/);
  assert.match(passport, /state\.activateJourney\(journey\.id\)/);
  assert.doesNotMatch(passport, /journey\.description/);
  assert.doesNotMatch(passport, /LinearProgressIndicator/);
  assert.doesNotMatch(passport, /JourneyShareButton/);
  assert.doesNotMatch(passport, /城市收藏地图/);
});
