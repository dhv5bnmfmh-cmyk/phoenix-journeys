import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const expansion = readFileSync(
  new URL('../app/lib/data/journey_expansion_catalog.dart', import.meta.url),
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
  ['suzhou-humble-administrators-garden', '苏州', '拙政园'],
  ['luoyang-longmen-grottoes', '洛阳', '龙门石窟'],
  ['quanzhou-kaiyuan-temple', '泉州', '开元寺'],
];

test('first city expansion batch follows journey and passport contracts', () => {
  for (const [id, city, place] of journeys) {
    assert.match(expansion, new RegExp(`id: '${id}'`));
    assert.match(expansion, new RegExp(`city: '${city}'`));
    assert.match(expansion, new RegExp(`place: '${place}'`));
    assert.match(backgrounds, new RegExp(`journeyId: '${id}'`));
  }
});

test('every expanded journey has two verified authoritative sources and a geo node', () => {
  assert.equal((expansion.match(/StoryVerificationStatus\.verified/g) ?? []).length, 3);
  for (const [, , place] of journeys) {
    assert.match(geo, new RegExp(`name: '${place}'`));
  }
});
