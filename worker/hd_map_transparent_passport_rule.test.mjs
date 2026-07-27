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

const specialArtwork = [
  'literary-roaming-symbol.svg',
  'myth-tracing-symbol.svg',
  'strange-night-talks-symbol.svg',
  'folk-secret-land-symbol.svg',
];

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
  assert.match(explore, /Interval\(0, \.34/);
  assert.match(explore, /scale: 1 \+ cameraT \* 1\.7/);
  assert.match(explore, /destinationFocusT/);
  assert.match(explore, /scale: 1 \+ destinationFocusT \* \.72/);
  assert.match(explore, /destination\.mapPoint\.x \* 2 - 1/);
  assert.match(explore, /Interval\(\s*\.68,\s*\.82/);
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
  assert.match(passport, /_collisionOffset/);
});

test('special journeys use compact cards with layered high-resolution SVG artwork', () => {
  assert.match(special, /open-special-journey-menu/);
  assert.match(special, /height: 58/);
  assert.match(special, /height: 72/);
  assert.match(special, /margin: const EdgeInsets\.only\(bottom: 7\)/);
  assert.match(special, /class _JourneySeal/);
  assert.match(special, /SvgPicture\.asset/);
  assert.match(special, /special-journey-unlock-sheet/);
  assert.match(special, /旅程钱袋/);
  assert.match(special, /state\.displayText\(journey\.chapter\)/);
  assert.match(special, /state\.walletBalance\(journey\.currency\)/);
  assert.match(special, /balance >= journey\.cost/);
  assert.match(special, /showModalBottomSheet<void>/);
  assert.doesNotMatch(special, /journey\.subtitle/);

  for (const filename of specialArtwork) {
    assert.match(special, new RegExp(filename.replace('.', '\\.')));
    const svg = readFileSync(`app/assets/images/special-realms/${filename}`, 'utf8');
    assert.match(svg, /viewBox="0 0 512 512"/);
    assert.match(svg, /linearGradient|radialGradient/);
    assert.ok(svg.length > 1_500);
  }
});
