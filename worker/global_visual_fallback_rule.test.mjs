import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('global hero, maps, atlas and journey badges have static failure fallbacks', async () => {
  const [explore, passport, badge] = await Promise.all([
    read('app/lib/screens/explore_screen.dart'),
    read('app/lib/screens/city_passport_screen.dart'),
    read('app/lib/widgets/journey_symbol_badge.dart'),
  ]);

  assert.match(explore, /phoenix-home-hero-image[\s\S]*?errorBuilder:/);
  assert.equal((explore.match(/_FlightMapFallback\(\)/g) ?? []).length >= 2, true);
  assert.match(explore, /phoenix-flight-map-static-fallback/);
  assert.match(passport, /passport-atlas-static-fallback/);
  assert.match(badge, /journey-symbol-static-fallback/);
});

test('global motion remains reduced-motion aware and releases controllers', async () => {
  const explore = await read('app/lib/screens/explore_screen.dart');

  assert.match(explore, /disableAnimations/);
  assert.match(explore, /_motion\.dispose\(\)/);
  assert.match(explore, /_controller\.dispose\(\)/);
});
