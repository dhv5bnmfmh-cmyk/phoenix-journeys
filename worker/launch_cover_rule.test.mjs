import assert from 'node:assert/strict';
import { readFile, stat } from 'node:fs/promises';
import test from 'node:test';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('Phoenix launch cover animates a short branded journey and waits for real app readiness', async () => {
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
  assert.match(index, /phoenix-time-flight-v2 3\.2s cubic-bezier/);
  assert.match(index, /phoenix-time-flight-v2/);
  assert.match(index, /animation-duration: 18s/);
  assert.match(index, /#phoenix-loading\.phoenix-loading--hidden[\s\S]*pointer-events: none/);
  assert.match(bootstrap, /minimumJourneyDurationMs = 3200/);
  assert.match(bootstrap, /phoenixFlightDurationMs = 3200/);
  assert.match(bootstrap, /coverExitTransitionMs = 360/);
  assert.match(bootstrap, /querySelector\('\.phoenix-loading__traveler'\)/);
  assert.match(bootstrap, /traveler\.animate/);
  assert.match(bootstrap, /cubic-bezier\(\.45, 0, \.72, \.48\)/);
  assert.match(bootstrap, /cubic-bezier\(\.18, \.62, \.3, 1\)/);
  assert.match(bootstrap, /phoenix-startup-settled/);
  assert.match(bootstrap, /waitForStartupSettled\(\)/);
  assert.match(bootstrap, /await waitForStartupSettled\(\)/);
  assert.match(bootstrap, /await hideLoading\(\)/);
  assert.match(bootstrap, /flightCompleted/);
  assert.match(bootstrap, /phoenix-home-ready/);
  assert.match(bootstrap, /phoenix-flight-start/);
  assert.match(bootstrap, /phoenix-flight-end/);
  assert.match(bootstrap, /phoenix-cover-exit-start/);
  assert.match(bootstrap, /releaseCoverInteraction\(\)/);
  assert.match(bootstrap, /cover\.style\.pointerEvents = 'none'/);
  assert.match(bootstrap, /cover\.setAttribute\('inert', ''\)/);
  assert.match(bootstrap, /cover\.setAttribute\('aria-hidden', 'true'\)/);
  assert.match(bootstrap, /document\.elementFromPoint/);
  assert.match(bootstrap, /coverCapturesHitTesting\(\)/);
  assert.match(bootstrap, /phoenix-cover-input-released/);
  assert.match(bootstrap, /phoenix-cover-hit-test-safe/);
  assert.match(bootstrap, /phoenix-cover-hit-test-fallback-removed/);
  assert.match(bootstrap, /classList\.add\('phoenix-loading--hidden'\)/);
  assert.match(bootstrap, /phoenix-main-interactive/);
  assert.doesNotMatch(bootstrap, /classList\.add\('phoenix-loading-hidden'\)/);
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
