import assert from 'node:assert/strict';
import { readFile, stat } from 'node:fs/promises';
import test from 'node:test';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('Phoenix launch cover animates a journey from ancient to modern worlds', async () => {
  const [index, bootstrap, manifest, earthArtwork, phoenixArtwork] = await Promise.all([
    read('app/web/index.html'),
    read('app/web/flutter_bootstrap.js'),
    read('app/web/manifest.json'),
    stat(new URL('../app/assets/images/phoenix-time-earth-v2.webp', import.meta.url)),
    stat(new URL('../app/assets/images/phoenix-flight-cycle-v4.webp', import.meta.url)),
  ]);

  assert.match(index, /phoenix-time-earth-v2\.webp/);
  assert.match(index, /phoenix-flight-cycle-v4\.webp/);
  assert.match(index, /phoenix-loading__traveler/);
  assert.match(index, /phoenix-loading__portal/);
  assert.match(index, /古代 · 文明/);
  assert.match(index, /现代 · 世界/);
  assert.match(index, /<div class="phoenix-loading__mark" aria-hidden="true">凤<\/div>/);
  assert.match(index, /凤凰正穿越古今，展开你的语言旅程/);
  assert.match(index, /env\(safe-area-inset-bottom\)/);
  assert.match(index, /prefers-reduced-motion/);
  assert.match(index, /phoenix-earth-drift/);
  assert.match(index, /phoenix-time-flight/);
  assert.match(index, /phoenix-wing-cycle/);
  assert.match(index, /phoenix-time-mist/);
  assert.match(index, /6\.8s cubic-bezier/);
  assert.match(index, /phoenix-time-flight-v2/);
  assert.match(index, /animation-duration: 18s/);
  assert.match(bootstrap, /phoenixFlightDurationMs = 6800/);
  assert.match(bootstrap, /phoenixBrandingDeadlineAt = bootstrapStartedAt \+ phoenixFlightDurationMs/);
  assert.match(bootstrap, /phoenix-startup-settled/);
  assert.match(bootstrap, /HOME READY/);
  assert.match(bootstrap, /const \[branding, startup\] = await Promise\.all\(\[/);
  assert.match(bootstrap, /appRunner[\s\S]*\.runApp\(\)[\s\S]*FLUTTER runApp READY/);
  assert.match(bootstrap, /COVER FADE START/);
  assert.match(bootstrap, /FINAL-FRAME EXTRA WAIT/);
  assert.doesNotMatch(bootstrap, /getAnimations\(\)/);
  assert.doesNotMatch(bootstrap, /animationend/);
  assert.doesNotMatch(bootstrap, /animationcancel/);
  assert.doesNotMatch(bootstrap, /minimumJourneyDurationMs/);
  assert.doesNotMatch(bootstrap, /setTimeout\(resolve, remaining\)/);
  assert.doesNotMatch(index, /mix-blend-mode: screen/);
  assert.match(index, /phoenix-time-portal/);
  assert.match(index, /phoenix-portal-spin/);
  assert.match(index, /phoenix-cover-glow/);
  assert.match(index, /phoenix-light-sweep/);
  assert.match(index, /phoenix-ember-rise/);
  assert.match(index, /phoenix-seal-pulse/);
  assert.equal(
    (index.match(/class="phoenix-loading__ember"/g) ?? []).length,
    8,
  );
  assert.doesNotMatch(index, /🔥/);
  assert.doesNotMatch(index, /radial-gradient\(circle at 12% 18%/);
  assert.ok(earthArtwork.size > 80_000);
  assert.ok(earthArtwork.size < 500_000);
  assert.ok(phoenixArtwork.size > 60_000);
  assert.ok(phoenixArtwork.size < 500_000);
  assert.equal(JSON.parse(manifest).background_color, '#180908');
  assert.equal(JSON.parse(manifest).theme_color, '#180908');
});
