import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const background = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);

test('Forbidden City uses its own slow cinematic motion layers', () => {
  assert.match(background, /_forbiddenCityJourneyId = 'beijing-forbidden-city'/);
  assert.match(background, /class _ForbiddenCityDynamicBackground/);
  assert.match(background, /Duration\(seconds: 16\)/);
  assert.match(background, /_motion\.repeat\(reverse: true\)/);
  assert.match(background, /forbidden-city-camera-transform/);
  assert.match(background, /forbidden-city-dawn-light/);
  assert.match(background, /forbidden-city-cloud-shadow/);
  assert.match(background, /forbidden-city-gate-depth/);
});

test('Forbidden City motion remains lightweight and has no water effect', () => {
  const start = background.indexOf('class _ForbiddenCityDynamicBackground');
  const end = background.indexOf('class _SummerPalaceDynamicBackground');
  const forbidden = background.slice(start, end);
  assert.doesNotMatch(forbidden, /Water|Ripple|Shimmer|CustomPaint/);
  assert.doesNotMatch(forbidden, /VideoPlayer|\.mp4|animated.*webp/i);
  assert.match(forbidden, /RepaintBoundary/);
  assert.match(background, /queryParameters\['motion'\] == 'on'/);
});
