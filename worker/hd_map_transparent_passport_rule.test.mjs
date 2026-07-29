import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync, statSync } from 'node:fs';

const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');
const passport = readFileSync(
  'app/lib/screens/city_passport_screen.dart',
  'utf8',
);
const special = readFileSync(
  'app/lib/widgets/special_journey_passport.dart',
  'utf8',
);

test('both circled map pages use project-owned retina WebP artwork', () => {
  assert.match(explore, /world-flight-atlas-v1\.webp/);
  assert.match(explore, /east-asia-flight-relief-v2\.webp/);
  assert.match(passport, /china-passport-atlas-v2\.webp/);
  assert.ok(
    statSync('app/assets/images/maps/east-asia-flight-relief-v2.webp').size >
      150_000,
  );
  assert.ok(
    statSync('app/assets/images/maps/china-passport-atlas-v2.webp').size >
      150_000,
  );
  assert.ok(
    statSync('app/assets/images/maps/world-flight-atlas-v1.webp').size >
      40_000,
  );
});

test('world camera zooms into the real route and lands from above', () => {
  assert.match(explore, /Interval\(0, \.38/);
  assert.match(explore, /scale: 1 \+ cameraT \* 1\.7/);
  assert.match(explore, /destinationFocusT/);
  assert.match(explore, /scale: 1 \+ destinationFocusT \* \.72/);
  assert.match(explore, /destination\.mapPoint\.x \* 2 - 1/);
  assert.match(explore, /Interval\(\s*\.78,\s*\.94/);
  assert.match(explore, /geometry\.landingPoint\(landingT\)/);
  assert.match(explore, /math\.pi \/ 2/);
  assert.match(explore, /void paint\(Canvas canvas, Size size\) \{\s*_drawRoute/);
  assert.doesNotMatch(explore, /void _drawLand/);
  assert.doesNotMatch(explore, /void _drawGrid/);
});

test('passport removes large overview and card furniture', () => {
  assert.doesNotMatch(passport, /class _CityOverview/);
  assert.doesNotMatch(passport, /LinearProgressIndicator/);
  assert.doesNotMatch(passport, /journey\.description/);
  assert.doesNotMatch(passport, /FilledButton/);
  assert.match(passport, /showModalBottomSheet<void>/);
  assert.match(passport, /requireJourneyLocation\(city\.primaryDestination\.id\)/);
  assert.match(passport, /InteractiveViewer\(/);
  assert.match(passport, /maxScale: 4/);
  assert.match(passport, /_resolveCityMarkerPlacements/);
  assert.match(passport, /occupied\.every/);
  assert.match(passport, /passport-city-landmark-/);
  assert.match(passport, /_CityMarkerLeaderPainter/);
  assert.match(passport, /JourneySymbolBadge\(\s*journeyId: city\.primaryDestination\.id/);
});

test('special journeys open from a featured wallet-aware button', () => {
  assert.match(special, /open-special-journey-menu/);
  assert.match(special, /height: 48/);
  assert.match(special, /JourneySymbolBadge\(/);
  assert.match(special, /size: 52/);
  assert.match(special, /state\.displayText\(journey\.chapter\)/);
  assert.match(special, /state\.walletBalance\(journey\.currency\)/);
  assert.match(special, /showModalBottomSheet<void>/);
  assert.doesNotMatch(special, /journey\.subtitle/);
});
