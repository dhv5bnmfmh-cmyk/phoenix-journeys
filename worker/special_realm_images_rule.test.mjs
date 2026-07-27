import assert from 'node:assert/strict';
import { readdir, readFile, stat } from 'node:fs/promises';
import test from 'node:test';

const assetDirectory = new URL(
  '../app/assets/images/special-realms/ten-scene/',
  import.meta.url,
);
const backgroundSource = new URL(
  '../app/lib/widgets/special_realm_background.dart',
  import.meta.url,
);

const realms = [
  ['dream-butterfly', 'dream-butterfly-v3.webp'],
  ['moon-letter', 'moon-letter-v2.webp'],
  ['shadowless-inn', 'shadowless-inn-v2.webp'],
  ['upstream-lantern', 'upstream-lantern-v3.webp'],
];

test('every special realm has ten valid story images including its retained plate', async () => {
  const files = await readdir(assetDirectory);
  const source = await readFile(backgroundSource, 'utf8');

  for (const [prefix, retainedPlate] of realms) {
    const generated = files
      .filter((file) => file.startsWith(`${prefix}-`) && file.endsWith('.webp'))
      .sort();

    assert.equal(generated.length, 9, `${prefix} should add exactly nine images`);
    assert.match(source, new RegExp(retainedPlate.replace('.', '\\.')));

    for (const file of generated) {
      const info = await stat(new URL(file, assetDirectory));
      assert.ok(info.size > 50_000, `${file} should be a real HD WebP`);
      assert.match(source, new RegExp(file.replace('.', '\\.')));
    }
  }
});

test('special realm image mapping covers all ten scene positions', async () => {
  const source = await readFile(backgroundSource, 'utf8');

  assert.match(source, /JourneyBackgroundPage\.story\s*=>\s*1 \+/);
  assert.match(source, /JourneyBackgroundPage\.vocabulary => 4/);
  assert.match(source, /JourneyBackgroundPage\.discovery => 5/);
  assert.match(source, /JourneyBackgroundPage\.reflection => 6/);
  assert.match(source, /JourneyBackgroundPage\.writing => 7/);
  assert.match(source, /JourneyBackgroundPage\.memory => 8/);
  assert.match(source, /JourneyBackgroundPage\.completion => 9/);
});

test('special realm plates stay clean and transition without procedural effects', async () => {
  const source = await readFile(backgroundSource, 'utf8');

  assert.doesNotMatch(source, /SpecialRealmCinematicOverlay/);
  assert.match(source, /precacheImage\(AssetImage\(asset\), context\)/);
  assert.match(source, /AnimatedSwitcher\(/);
  assert.match(source, /Duration\(milliseconds: 1400\)/);
});
