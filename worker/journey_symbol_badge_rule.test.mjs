import assert from 'node:assert/strict';
import fs from 'node:fs';
import test from 'node:test';

const badge = fs.readFileSync(
  new URL('../app/lib/widgets/journey_symbol_badge.dart', import.meta.url),
  'utf8',
);
const cityPassport = fs.readFileSync(
  new URL('../app/lib/screens/city_passport_screen.dart', import.meta.url),
  'utf8',
);
const specialPassport = fs.readFileSync(
  new URL('../app/lib/widgets/special_journey_passport.dart', import.meta.url),
  'utf8',
);

test('journey list symbols use reviewed high-detail illustrated badges', () => {
  assert.match(badge, /Image\.asset/);
  assert.match(badge, /LinearGradient/);
  assert.match(badge, /FilterQuality\.high/);
  assert.match(cityPassport, /JourneySymbolBadge\(/);
  assert.match(specialPassport, /JourneySymbolBadge\(/);
});

test('special and regular journeys share high-resolution WebP treatment', () => {
  for (const asset of [
    'dream-butterfly-v3.webp',
    'moon-letter-v2.webp',
    'shadowless-inn-v2.webp',
    'upstream-lantern-v3.webp',
  ]) {
    assert.ok(badge.includes(asset), `missing special realm plate ${asset}`);
  }
  assert.doesNotMatch(badge, /\.svg/);
});

test('every published journey family has dedicated illustrated artwork', () => {
  for (const identity of [
    'forbidden-city',
    'summer-palace',
    'shanghai',
    'xian',
    'hangzhou',
    'chengdu',
    'nanjing',
    'guangzhou',
    'literary-roaming',
    'myth-tracing',
    'strange-night-talks',
    'folk-secret-land',
  ]) {
    assert.ok(badge.includes(identity), `missing motif mapping for ${identity}`);
  }
});

test('special journey menu no longer renders single-character circle stamps', () => {
  assert.doesNotMatch(specialPassport, /state\.displayText\(journey\.stamp\)/);
});
