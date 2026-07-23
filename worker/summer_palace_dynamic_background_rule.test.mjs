import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const widget = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);
const catalog = readFileSync(
  'app/lib/data/journey_background_catalog.dart',
  'utf8',
);

// Permanent guard for the lightweight destination-level living background.
test('Summer Palace uses capped local motion without full-frame animated media', () => {
  assert.match(widget, /beijing-summer-palace/);
  assert.match(widget, /summer-palace-dynamic-background/);
  assert.match(widget, /summerPalaceLivingBackgroundAssetPath/);
  assert.match(catalog, /06-summer-lotus-lake\.webp/);
  assert.match(widget, /Timer\.periodic\(_summerPalaceFrameInterval/);
  assert.match(widget, /Duration\(milliseconds: 50\)/);
  assert.match(widget, /TickerMode\.valuesOf\(context\)\.enabled/);
  assert.match(widget, /summer-palace-camera-layer/);
  assert.match(widget, /summer-palace-camera-transform/);
  assert.match(widget, /summer-palace-living-layer/);
  assert.match(widget, /_SummerPalaceLivingPainter/);
  assert.match(widget, /queryParameters\['motion'\] == 'on'/);
  assert.match(widget, /disableAnimations/);
  assert.match(widget, /precacheImage/);
  assert.match(widget, /RepaintBoundary/);
  assert.doesNotMatch(widget, /live-loop|live-cinemagraph|animated WebP/i);
  assert.doesNotMatch(catalog, /live-cinemagraph|\.webp';\s*\/\/ animated/i);
});
