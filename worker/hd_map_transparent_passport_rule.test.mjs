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
});

test('route painter only overlays the route instead of fake flat land', () => {
  assert.match(explore, /void paint\(Canvas canvas, Size size\) \{\s*_drawRoute/);
  assert.doesNotMatch(explore, /void _drawLand/);
  assert.doesNotMatch(explore, /void _drawGrid/);
});

test('passport removes large overview and card furniture', () => {
  assert.doesNotMatch(passport, /class _CityOverview/);
  assert.doesNotMatch(passport, /LinearProgressIndicator/);
  assert.doesNotMatch(passport, /journey\.description/);
  assert.doesNotMatch(passport, /FilledButton/);
  assert.match(passport, /height: 52/);
});

test('special journeys follow the same small stamp plus name rule', () => {
  assert.match(special, /height: 48/);
  assert.match(special, /width: 32/);
  assert.match(special, /state\.displayText\(journey\.chapter\)/);
  assert.doesNotMatch(special, /journey\.subtitle/);
});
