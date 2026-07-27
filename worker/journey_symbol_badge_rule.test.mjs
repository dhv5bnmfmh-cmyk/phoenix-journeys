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

test('journey list symbols use resolution-independent layered badges', () => {
  assert.match(badge, /CustomPaint/);
  assert.match(badge, /LinearGradient/);
  assert.match(badge, /MaskFilter\.blur/);
  assert.match(cityPassport, /JourneySymbolBadge\(/);
  assert.match(specialPassport, /JourneySymbolBadge\(/);
});

test('every published journey family has a dedicated visual motif', () => {
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
