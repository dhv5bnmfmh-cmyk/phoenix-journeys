import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const bindingPath = new URL(
  '../app/lib/services/journey_location_binding.dart',
  import.meta.url,
);
const geographyPath = new URL(
  '../app/lib/data/journey_geography_catalog.dart',
  import.meta.url,
);
const passportPath = new URL(
  '../app/lib/screens/city_passport_screen.dart',
  import.meta.url,
);
const standardPath = new URL(
  '../docs/PHOENIX_LOCATION_HIERARCHY_STANDARD.md',
  import.meta.url,
);

test('location projection derives hierarchy from Journey geoPath', async () => {
  const binding = await readFile(bindingPath, 'utf8');

  assert.match(binding, /GeoNode\? get provinceLevelNode/);
  assert.match(binding, /GeoNode\? get cityEquivalentNode/);
  assert.match(binding, /GeoNode\? get districtNode/);
  assert.match(binding, /String get placeName => placeNode\.name/);
  assert.match(binding, /geoPath\.where/);
  assert.doesNotMatch(binding, /北京市 · 北京市/);
});

test('Passport grouping has no manual province-to-city specification', async () => {
  const geography = await readFile(geographyPath, 'utf8');
  const passport = await readFile(passportPath, 'utf8');

  assert.doesNotMatch(geography, /_chinaProvinceSpecs/);
  assert.match(geography, /requireJourneyLocation/);
  assert.match(geography, /cityEquivalentNode/);
  assert.match(passport, /_PassportCityContext/);
  assert.match(passport, /location\.districtName/);
});

test('location standard protects identity and municipality semantics', async () => {
  const standard = await readFile(standardPath, 'utf8');

  assert.match(standard, /single geographic hierarchy/i);
  assert.match(standard, /MUST NOT create a duplicate same-name city node/);
  assert.match(standard, /cityId.*destinationId.*locationPath/s);
  assert.match(standard, /Progress.*background paths/s);
  assert.match(standard, /Before Gold acceptance/);
});
