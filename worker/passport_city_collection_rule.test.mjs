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

test('Passport preserves the 77335370 compact city stamp layout', () => {
  assert.match(passport, /itemCount: journeyCityCatalog\.length/);
  assert.match(passport, /_CityStampSection\(/);
  assert.match(passport, /LayoutBuilder\(/);
  assert.match(passport, /for \(final journey in city\.destinations\)/);
  assert.match(passport, /passport-city-\$\{city\.id\}/);
  assert.match(passport, /passport-destination-\$\{journey\.id\}/);
});

test('compact passport keeps stamps, status and journey actions', () => {
  assert.match(passport, /CityJourneyStamp\(/);
  assert.match(passport, /state\.isJourneyStampEarned\(journey\.id\)/);
  assert.match(passport, /JourneyScreen\(journeyId: journey\.id\)/);
  assert.match(passport, /state\.activateJourney\(journey\.id\)/);
  assert.match(specialPassport, /SpecialJourneyStamp\(/);
  assert.match(specialPassport, /state\.unlockSpecialJourney\(/);
});
