import assert from 'node:assert/strict';
import { readdir, readFile, stat } from 'node:fs/promises';
import test from 'node:test';

const assetDirectory = new URL(
  '../app/assets/images/special-realms/rights-safe-v1/',
  import.meta.url,
);
const backgroundSource = new URL(
  '../app/lib/widgets/special_realm_background.dart',
  import.meta.url,
);

const realms = [
  'changan-last-bus', 'tide-letter', 'arcade-lost-property',
  'tea-horse-echo', 'ice-city-star-map', 'literary-roaming',
  'myth-tracing', 'strange-night-talks', 'folk-secret-land',
];

test('every special realm has ten rights-safe narrative plates', async () => {
  const source = await readFile(backgroundSource, 'utf8');

  for (const journeyId of realms) {
    const journeyDirectory = new URL(`${journeyId}/`, assetDirectory);
    const generated = (await readdir(journeyDirectory))
      .filter((file) => file.endsWith('.webp'))
      .sort();

    assert.equal(generated.length, 10, `${journeyId} must own exactly ten images`);

    for (const file of generated) {
      const info = await stat(new URL(file, journeyDirectory));
      assert.ok(info.size > 8_000, `${file} should be a valid optimized vector-derived WebP`);
      assert.match(source, new RegExp(file.replace('.', '\\.')));
    }
  }
});

test('special realm image mapping covers all ten scene positions', async () => {
  const source = await readFile(backgroundSource, 'utf8');

  assert.match(source, /JourneyBackgroundPage\.story\s*=>\s*1 \+/);
  assert.match(source, /JourneyBackgroundPage\.vocabulary => 4/);
  assert.match(source, /JourneyBackgroundPage\.discovery => 5/);
  assert.match(source, /JourneyBackgroundPage\.reflection => 6/);
  assert.match(source, /JourneyBackgroundPage\.writing => 7/);
  assert.match(source, /JourneyBackgroundPage\.memory => 8/);
  assert.match(source, /JourneyBackgroundPage\.completion => 9/);
});

test('special realm plates stay clean and transition without procedural effects', async () => {
  const source = await readFile(backgroundSource, 'utf8');

  assert.doesNotMatch(source, /SpecialRealmCinematicOverlay/);
  assert.match(source, /precacheImage\(AssetImage\(asset\), context\)/);
  assert.match(source, /AnimatedSwitcher\(/);
  assert.match(source, /Duration\(milliseconds: 1400\)/);
});

test('special realm plates preload within the mobile decode budget and fail safely', async () => {
  const source = await readFile(backgroundSource, 'utf8');

  assert.match(source, /_precacheVisiblePlates\(\)/);
  assert.match(source, /assets\[current\], assets\.first/);
  assert.doesNotMatch(source, /for \(final asset in _PremiumRealmPlate\.assetsFor/);
  assert.match(source, /errorBuilder:/);
  assert.match(source, /_programmaticFallback/);
  assert.match(source, /didUpdateWidget/);
  assert.match(source, /_motion\.dispose\(\)/);
});
