import assert from 'node:assert/strict';
import { readFileSync, statSync } from 'node:fs';
import test from 'node:test';

const root = new URL('../', import.meta.url);
const read = (path) => readFileSync(new URL(path, root), 'utf8');

test('normal discovery is Beijing only while direct legacy resolution remains', () => {
  const startup = read('app/lib/data/journey_startup_metadata.dart');
  const publication = read('app/lib/data/journey_publication_catalog.dart');
  const picker = read('app/lib/widgets/journey_picker_sheet.dart');
  const passport = read('app/lib/screens/city_passport_screen.dart');
  assert.match(startup, /publishedJourneyStartupCityCatalog/);
  assert.match(startup, /requireJourneyStartupMetadata\('beijing-forbidden-city'\)/);
  assert.match(startup, /_journeyStartupMetadataById/);
  assert.match(picker, /publishedJourneyStartupCityCatalog/);
  assert.match(publication, /publishedJourneyRuntimeIds[\s\S]*referenceJourneyRuntimeId/);
  assert.match(publication, /PublicationState\.hidden/);
  assert.match(passport, /publishedJourneyCityCatalog/);
  assert.doesNotMatch(passport, /SpecialJourneyPassport/);
});

test('Beijing City Standard separates City Place and Journey', () => {
  const standard = read('app/lib/data/beijing_city_standard.dart');
  for (const id of [
    'beijing.history', 'beijing.geography', 'beijing.architecture',
    'beijing.food', 'beijing.folk_customs', 'beijing.language',
    'beijing.arts', 'beijing.craft', 'beijing.education',
    'beijing.technology', 'beijing.commerce', 'beijing.transport',
    'beijing.modern_life',
  ]) assert.match(standard, new RegExp(id.replace('.', '\\.')));
  assert.match(standard, /forbiddenCityPlace = PlaceDefinition/);
  assert.match(standard, /forbiddenCityJourney01 = JourneyDefinition/);
  assert.match(standard, /publicationState: PublicationState\.reference/);
});

test('four canonical scenes bind paired landscape and portrait runtime assets', () => {
  const manifest = JSON.parse(read('app/assets/journeys/china/beijing/forbidden_city/journey_01/manifest/scenes.json'));
  assert.deepEqual(manifest.scenes.map((scene) => scene.sceneId), ['FC01-A', 'FC01-B', 'FC01-C', 'FC01-D']);
  for (const scene of manifest.scenes) {
    for (const path of [scene.runtimeLandscapePath, scene.runtimePortraitPath]) {
      const asset = new URL(`app/assets/journeys/china/beijing/forbidden_city/journey_01/${path}`, root);
      assert.ok(statSync(asset).size > 50_000, `${scene.sceneId} ${path} is production-sized`);
    }
    assert.equal(scene.mobileCropVerified, true);
    assert.equal(scene.desktopCropVerified, true);
  }
});

test('Story progression and stage closure resolve canonical scenes', () => {
  const standard = read('app/lib/data/beijing_city_standard.dart');
  const runtime = read('app/lib/data/forbidden_city_journey_runtime.dart');
  const journey = read('app/lib/screens/journey_screen.dart');
  const background = read('app/lib/widgets/destination_background.dart');
  assert.match(standard, /forbiddenCityStorySceneSpans/);
  assert.match(standard, /JourneyStorySceneSpan/);
  for (const anchor of [
    '沈砚看清后', '两条线都能到', '两人重新对照', '两人比较',
    '沈砚发现', '两人逐项比较后', '证据改变了争论',
    '他们重新检查后发现', '比较结果没有', '沈砚逐项重画后发现',
  ]) assert.match(runtime, new RegExp(anchor));
  assert.match(journey, /forbiddenCitySceneForStoryOffset/);
  assert.match(background, /Duration\(milliseconds: 450\)/);
  assert.match(background, /scene\.portraitAsset/);
  assert.match(background, /scene\.landscapeAsset/);
  assert.match(background, /nextAssetPath/);
});
