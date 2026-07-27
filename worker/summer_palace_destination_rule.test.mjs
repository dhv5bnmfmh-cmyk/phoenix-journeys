import test from 'node:test';
import assert from 'node:assert/strict';
import { readdirSync, readFileSync, statSync } from 'node:fs';

const catalog = readFileSync('app/lib/data/daily_journey_catalog.dart', 'utf8');
const journey = readFileSync('app/lib/data/summer_palace_journey.dart', 'utf8');
const geo = readFileSync('app/lib/data/world_geo_catalog.dart', 'utf8');
const backgrounds = readFileSync(
  'app/lib/data/journey_background_generated.dart',
  'utf8',
);
const pubspec = readFileSync('app/pubspec.yaml', 'utf8');
const summerPalaceBackgroundDirectory =
  'app/assets/images/backgrounds/generated/beijing/summer-palace';

test('Beijing publishes Forbidden City and Summer Palace as separate destinations', () => {
  assert.match(catalog, /summerPalaceJourneyExperience/);
  assert.match(catalog, /summerPalaceJourneyContent/);
  assert.match(catalog, /summerPalaceStorySources/);
  assert.match(journey, /id: 'beijing-summer-palace'/);
  assert.match(journey, /place: '颐和园'/);
  assert.match(journey, /UNESCO World Heritage Centre/);
});

test('Summer Palace has its own GeoNode and ten offline backgrounds', () => {
  assert.match(geo, /cn-beijing-haidian-summer-palace/);
  assert.match(geo, /latitude: 39\.9969/);
  assert.match(geo, /longitude: 116\.2680/);
  assert.match(backgrounds, /beijing-summer-palace-\$assetName/);
  assert.match(
    backgrounds,
    /generated\/beijing\/summer-palace\/\$assetName\.webp/,
  );
  assert.match(
    pubspec,
    /assets\/images\/backgrounds\/generated\/beijing\/summer-palace\//,
  );
});

test('Summer Palace backgrounds are production-quality vertical assets', () => {
  const images = readdirSync(summerPalaceBackgroundDirectory)
    .filter((filename) => filename.endsWith('.webp'))
    .sort();

  assert.equal(images.length, 10);
  for (const filename of images) {
    const path = `${summerPalaceBackgroundDirectory}/${filename}`;
    assert.ok(
      statSync(path).size >= 50_000,
      `${filename} must not be a low-detail placeholder`,
    );
    assert.equal(readFileSync(path).subarray(0, 4).toString('ascii'), 'RIFF');
  }
});
