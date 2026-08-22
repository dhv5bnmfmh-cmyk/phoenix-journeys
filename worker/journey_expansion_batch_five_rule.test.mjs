import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const catalog = readFileSync(
  new URL('../app/lib/data/journey_expansion_batch_five.dart', import.meta.url),
  'utf8',
);
const geo = readFileSync(
  new URL('../app/lib/data/world_geo_catalog_base.dart', import.meta.url),
  'utf8',
);
const backgrounds = readFileSync(
  new URL('../app/lib/data/journey_background_generated.dart', import.meta.url),
  'utf8',
);

const journeys = [
  ['huangshan-cloud-peaks', '黄山', '黄山风景区'],
  ['zhangjiajie-wulingyuan', '张家界', '武陵源'],
  ['kaifeng-song-capital', '开封', '宋都古城'],
  ['dali-cangshan-erhai', '大理', '大理古城'],
  ['harbin-central-street', '哈尔滨', '中央大街'],
];

test('batch five connects story, passport, geography, and ten backgrounds', () => {
  for (const [id, city, place] of journeys) {
    assert.match(catalog, new RegExp(`'${id}'`));
    assert.match(catalog, new RegExp(`city:'${city}'|city: '${city}'`));
    assert.match(geo, new RegExp(`name:'${place}'|name: '${place}'`));
    const start = backgrounds.indexOf(`id: '${id}-$assetName'`);
    assert.ok(start >= 0, `${id} background loop is registered`);
    const listStart = backgrounds.lastIndexOf(
      'for (final assetName in <String>[',
      start,
    );
    const listEnd = backgrounds.indexOf('])', listStart);
    const names = backgrounds.slice(listStart, listEnd).match(/'[^']+'/g) ?? [];
    assert.equal(names.length, 10, `${id} has exactly ten backgrounds`);
  }
});

test('every new journey carries two reviewed authorities and full learning depth', () => {
  assert.equal(
    (catalog.match(/StoryVerificationStatus\.verified/g) ?? []).length,
    10,
  );
  assert.equal((catalog.match(/const _\w+P=<String>\[/g) ?? []).length, 5);
  assert.equal((catalog.match(/const _\w+W=<WordEntry>\[/g) ?? []).length, 5);
  assert.equal((catalog.match(/const _\w+D=<DiscoveryEntry>\[/g) ?? []).length, 5);
});
