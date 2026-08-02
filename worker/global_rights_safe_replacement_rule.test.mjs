import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import test from 'node:test';

const root = new URL('../', import.meta.url);
const releasePaths = [
  'app/assets/images/home/phoenix-home-journey-keyart-portrait-v1.webp',
  'app/assets/images/maps/phoenix-world-route-atlas-landscape-v1.webp',
  'app/assets/images/maps/phoenix-east-asia-route-atlas-landscape-v1.webp',
  'app/assets/images/maps/phoenix-china-passport-atlas-portrait-v1.webp',
  'app/assets/images/phoenix-launch-journey-cover-portrait-v1.webp',
  'app/assets/images/phoenix-launch-flight-sprite-landscape-v1.webp',
  'app/web/phoenix-app-mark-square-64-v1.svg',
  'app/web/icons/phoenix-app-mark-square-192-v1.svg',
  'app/web/icons/phoenix-app-mark-square-512-v1.svg',
];
const retiredPaths = [
  'app/assets/images/home/phoenix-world-language-journey-v1.webp',
  'app/assets/images/maps/world-flight-atlas-v1.webp',
  'app/assets/images/maps/east-asia-flight-relief-v2.webp',
  'app/assets/images/maps/china-passport-atlas-v2.webp',
  'app/assets/images/phoenix-time-earth-v2.webp',
  'app/assets/images/phoenix-flight-cycle-v4.webp',
  'app/web/favicon.svg',
  'app/web/icons/Icon-192.svg',
  'app/web/icons/Icon-512.svg',
];

const read = (path) => readFileSync(new URL(`../${path}`, import.meta.url), 'utf8');

test('phase 1 contains exactly nine releases with nine editable masters', () => {
  assert.equal(releasePaths.length, 9);
  for (const path of releasePaths) assert.equal(existsSync(new URL(`../${path}`, import.meta.url)), true, path);
  const masters = releasePaths.map((path) =>
    `design/sources/global-critical-v1/${path.split('/').at(-1).replace(/\.webp$/, '.svg')}`,
  );
  assert.equal(new Set(masters).size, 9);
  for (const path of masters) assert.equal(existsSync(new URL(`../${path}`, import.meta.url)), true, path);
  for (const path of retiredPaths) assert.equal(existsSync(new URL(`../${path}`, import.meta.url)), false, path);
});

test('new SVG releases and masters contain no scripts or external references', () => {
  const paths = releasePaths.filter((path) => path.endsWith('.svg'));
  paths.push(...releasePaths.map((path) =>
    `design/sources/global-critical-v1/${path.split('/').at(-1).replace(/\.webp$/, '.svg')}`,
  ));
  for (const path of paths) {
    const svg = read(path);
    assert.match(svg, /<svg\b/);
    assert.doesNotMatch(svg, /<script\b|javascript:|xlink:href\s*=|<image\b/i, path);
    assert.doesNotMatch(svg.replace('http://www.w3.org/2000/svg', ''), /https?:\/\//i, path);
    assert.match(svg, /viewBox=/, path);
  }
});

test('runtime references only the new phase 1 paths', () => {
  const runtime = [
    read('app/lib/screens/explore_screen.dart'),
    read('app/lib/screens/city_passport_screen.dart'),
    read('app/web/index.html'),
    read('app/web/manifest.json'),
  ].join('\n');
  for (const path of releasePaths) assert.match(runtime, new RegExp(path.split('/').at(-1).replace(/[.*+?^${}()|[\]\\]/g, '\\$&')), path);
  for (const path of retiredPaths) assert.doesNotMatch(runtime, new RegExp(path.split('/').at(-1).replace(/[.*+?^${}()|[\]\\]/g, '\\$&')), path);
  assert.match(runtime, /prefers-reduced-motion/);
  assert.match(runtime, /errorBuilder:/);
  assert.match(runtime, /_FlightMapFallback/);
});

test('rights evidence explicitly forbids external inputs and records local creation', () => {
  const evidence = read('design/evidence/GLOBAL_CRITICAL_V1_EVIDENCE.md');
  assert.match(evidence, /No existing image, map tile, geographic dataset, icon library/);
  assert.match(evidence, /no external service or licensed input used/);
  assert.match(evidence, /all 14 Phase 1 gates passed locally/);
  for (const id of ['HOME','MAP-WORLD','MAP-ASIA','MAP-CHINA','SPLASH','DYNAMIC','ICON-064','ICON-192','ICON-512']) {
    assert.match(evidence, new RegExp(`PHX-GLOBAL-${id}-001`));
  }
});
