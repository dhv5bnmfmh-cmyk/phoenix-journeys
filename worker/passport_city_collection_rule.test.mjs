import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const shell = readFileSync('app/lib/screens/home_shell.dart', 'utf8');
const passport = readFileSync(
  'app/lib/screens/city_passport_screen.dart',
  'utf8',
);

const specialPassport = readFileSync(
  'app/lib/widgets/special_journey_passport.dart',
  'utf8',
);

test('Home uses the city-grouped Passport screen', () => {
  assert.match(shell, /import 'city_passport_screen\.dart';/);
  assert.match(shell, /CityPassportScreen\(\)/);
  assert.doesNotMatch(shell, /import 'passport_screen\.dart';/);
});

test('Passport creates one compact stamp section for every city', () => {
  assert.match(passport, /itemCount: journeyCityCatalog\.length/);
  assert.match(passport, /_CityStampSection\(/);
  assert.match(passport, /for \(final journey in city\.destinations\)/);
  assert.match(passport, /passport-city-\$\{city\.id\}/);
  assert.match(passport, /passport-destination-\$\{journey\.id\}/);
});

test('city passport is a two-column transparent stamp book', () => {
  assert.match(passport, /tileWidth = \(constraints\.maxWidth - 5\) \/ 2/);
  assert.match(passport, /Wrap\(/);
  assert.match(passport, /CityJourneyStamp\(/);
  assert.match(passport, /size: 34/);
  assert.match(passport, /Colors\.white\.withValues\(alpha: \.10\)/);
  assert.match(passport, /Colors\.white\.withValues\(alpha: \.14\)/);
  assert.doesNotMatch(passport, /JourneyShareButton\(/);
  assert.doesNotMatch(passport, /journey\.description/);
  assert.doesNotMatch(passport, /LinearProgressIndicator\(/);
  assert.doesNotMatch(passport, /FilledButton/);
});

test('compact stamp tiles preserve journey access and progress status', () => {
  assert.match(passport, /state\.journeyProgressPercent/);
  assert.match(passport, /JourneyScreen\(journeyId: journey\.id\)/);
  assert.match(passport, /state\.activateJourney\(journey\.id\)/);
  assert.match(passport, /onTap: available/);
});

test('special journeys use matching compact transparent stamp tiles', () => {
  assert.match(specialPassport, /tileWidth = \(constraints\.maxWidth - 6\) \/ 2/);
  assert.match(specialPassport, /SpecialJourneyStamp\(/);
  assert.match(specialPassport, /size: 34/);
  assert.match(specialPassport, /transparentInk: true/);
  assert.match(specialPassport, /height: 48/);
});
