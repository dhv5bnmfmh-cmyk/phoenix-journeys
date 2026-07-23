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

test('Passport creates one collection for every city', () => {
  assert.match(passport, /itemCount: journeyCityCatalog\.length/);
  assert.match(passport, /_CityCollection\(/);
  assert.match(passport, /city\.destinations\.length/);
  assert.match(passport, /passport-city-\$\{city\.id\}/);
  assert.match(passport, /passport-destination-\$\{journey\.id\}/);
});

test('city collections preserve stamp progress and journey actions', () => {
  assert.match(passport, /earnedCount \/ city\.destinationCount/);
  assert.match(passport, /JourneyShareButton\(/);
  assert.match(passport, /JourneyScreen\(journeyId: journey\.id\)/);
  assert.match(passport, /state\.activateJourney\(journey\.id\)/);
});
