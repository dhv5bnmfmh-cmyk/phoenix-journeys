import test from 'node:test';
import assert from 'node:assert/strict';
import { existsSync, readFileSync, statSync } from 'node:fs';

const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');
const pubspec = readFileSync('app/pubspec.yaml', 'utf8');
const hero =
  'app/assets/images/home/phoenix-world-language-journey-v1.webp';
const flightMap =
  'app/assets/images/home/east-asia-flight-map-v2.webp';

test('home uses an original world travel and language-learning hero', () => {
  assert.equal(existsSync(hero), true);
  assert.ok(statSync(hero).size < 350_000);
  assert.match(explore, /phoenix-world-language-journey-v1\.webp/);
  assert.match(explore, /phoenix-home-world-language-background/);
  assert.match(explore, /phoenix-home-route-glow/);
  assert.match(explore, /Duration\(seconds: 28\)/);
  assert.match(explore, /FilterQuality\.high/);
  assert.match(pubspec, /- assets\/images\/home\//);
  assert.doesNotMatch(explore, /CustomPaint\(painter: _CloudPainter\(\)\)/);
});

test('welcome flight card uses a bundled HD illustrated map', () => {
  assert.equal(existsSync(flightMap), true);
  assert.ok(statSync(flightMap).size > 100_000);
  assert.ok(statSync(flightMap).size < 400_000);
  assert.match(explore, /east-asia-flight-map-v2\.webp/);
  assert.match(explore, /phoenix-flight-map-hd-image/);
  assert.doesNotMatch(
    explore,
    /void paint\(Canvas canvas, Size size\) \{\s*_drawGrid/,
  );
});

test('home motion remains subtle and respects reduced motion', () => {
  assert.match(explore, /camera \* 4/);
  assert.match(explore, /camera \* -3/);
  assert.match(explore, /disableAnimations/);
  assert.match(explore, /queryParameters\['motion'\] == 'on'/);
});
