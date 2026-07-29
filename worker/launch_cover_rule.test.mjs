import assert from 'node:assert/strict';
import { readFile, stat } from 'node:fs/promises';
import test from 'node:test';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('Phoenix launch cover uses the premium phoenix artwork', async () => {
  const [index, manifest, artwork] = await Promise.all([
    read('app/web/index.html'),
    read('app/web/manifest.json'),
    stat(new URL('../app/assets/images/phoenix-launch-cover.webp', import.meta.url)),
  ]);

  assert.match(index, /phoenix-launch-cover\.webp/);
  assert.match(index, /<div class="phoenix-loading__mark" aria-hidden="true">凤<\/div>/);
  assert.match(index, /正在展开你的语言旅程/);
  assert.match(index, /env\(safe-area-inset-bottom\)/);
  assert.match(index, /prefers-reduced-motion/);
  assert.match(index, /phoenix-cover-breathe/);
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
  assert.ok(artwork.size > 80_000);
  assert.ok(artwork.size < 500_000);
  assert.equal(JSON.parse(manifest).background_color, '#180908');
  assert.equal(JSON.parse(manifest).theme_color, '#180908');
});
