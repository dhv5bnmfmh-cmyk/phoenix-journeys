import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync(
  new URL('../app/lib/data/journey_expansion_batch_two.dart', import.meta.url),
  'utf8',
);
const geo = readFileSync(
  new URL('../app/lib/data/world_geo_catalog.dart', import.meta.url),
  'utf8',
);
const backgrounds = readFileSync(
  new URL('../app/lib/data/journey_background_generated.dart', import.meta.url),
  'utf8',
);

const journeys = [
  ['datong-yungang-grottoes', '大同', '云冈石窟'],
  ['lijiang-old-town', '丽江', '大研古城'],
  ['jiangmen-kaiping-diaolou', '江门', '开平碉楼'],
];

test('second expansion batch follows journey and passport contracts', () => {
  for (const [id, city, place] of journeys) {
    assert.match(catalog, new RegExp(`id: '${id}'`));
    assert.match(catalog, new RegExp(`city: '${city}'`));
    assert.match(catalog, new RegExp(`place: '${place}'`));
    assert.match(backgrounds, new RegExp(`journeyId: '${id}'`));
    assert.match(geo, new RegExp(`name: '${place}'`));
  }
});

test('every second-batch journey has UNESCO and government verification', () => {
  assert.equal(
    (catalog.match(/StoryVerificationStatus\.verified/g) ?? []).length,
    6,
  );
  assert.equal((catalog.match(/kind: StorySourceKind\.unesco/g) ?? []).length, 3);
  assert.equal(
    (catalog.match(/kind: StorySourceKind\.government/g) ?? []).length,
    3,
  );
});
