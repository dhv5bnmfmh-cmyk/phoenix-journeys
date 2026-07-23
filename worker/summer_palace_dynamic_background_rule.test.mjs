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

// Permanent guard for the first destination-level pseudo-dynamic background.
test('Summer Palace background uses clearly visible local pseudo-dynamic layers', () => {
  assert.match(widget, /beijing-summer-palace/);
  assert.match(widget, /summer-palace-dynamic-background/);
  assert.match(widget, /summerPalaceLiveLoopAssetPath/);
  assert.match(catalog, /summer-palace\/live\/11-live-cinemagraph\.webp/);
  assert.match(widget, /summer-palace-live-loop/);
  assert.match(widget, /summer-palace-static-background/);
  assert.match(widget, /AnimationController/);
  assert.match(widget, /Duration\(seconds: 13\)/);
  assert.match(widget, /repeat\(reverse: true\)/);
  assert.match(widget, /summer-palace-camera-layer/);
  assert.match(widget, /summer-palace-camera-transform/);
  assert.match(widget, /summer-palace-cloud-light/);
  assert.match(widget, /summer-palace-water-shimmer/);
  assert.match(widget, /summer-palace-water-ripples/);
  assert.match(widget, /summer-palace-foreground-breath/);
  assert.match(widget, /queryParameters\['motion'\] == 'on'/);
  assert.match(widget, /disableAnimations/);
  assert.match(widget, /precacheImage/);
  assert.match(widget, /RepaintBoundary/);
});
