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

test('Passport exposes only published cities on the transparent atlas', () => {
  assert.match(passport, /for \(final city in publishedJourneyCityCatalog\)/);
  assert.doesNotMatch(passport, /SpecialJourneyPassport/);
  assert.match(passport, /_CityMapMarker\(/);
  assert.match(passport, /city\.destinations/);
  assert.match(passport, /passport-city-\$\{city\.id\}/);
  assert.match(passport, /passport-destination-\$\{journey\.id\}/);
  assert.match(passport, /china-passport-atlas-v2\.webp/);
  assert.match(passport, /showModalBottomSheet<void>/);
  assert.match(passport, /city\.destinationCount.*段旅程/s);
});

test('Passport tiles render a compact layered journey symbol and name', () => {
  assert.match(passport, /JourneySymbolBadge\(/);
  assert.match(passport, /size: 50/);
  assert.match(passport, /state\.displayText\(location\.placeName\)/);
  assert.match(passport, /state\.displayText\(location\.districtName!\)/);
  assert.match(passport, /JourneyScreen\(journeyId: journey\.id\)/);
  assert.match(passport, /state\.activateJourney\(journey\.id\)/);
  assert.doesNotMatch(passport, /journey\.description/);
  assert.doesNotMatch(passport, /LinearProgressIndicator/);
  assert.doesNotMatch(passport, /JourneyShareButton/);
  assert.doesNotMatch(passport, /城市收藏地图/);
});
