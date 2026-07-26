import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('PR118 keeps language level in settings and does not autoplay restored discovery', async () => {
  const [journey, settings] = await Promise.all([
    read('app/lib/screens/journey_screen.dart'),
    read('app/lib/screens/me_screen.dart'),
  ]);

  assert.doesNotMatch(journey, /_showDifficultyWelcome/);
  assert.doesNotMatch(journey, /_scheduleDiscoveryAutoStart/);
  assert.match(settings, /settings-language-level/);
  assert.match(settings, /HSK／TOCFL 能力设置/);
});

test('PR118 challenge and passport expose the expanded product rules', async () => {
  const [journey, passport, home] = await Promise.all([
    read('app/lib/screens/journey_screen.dart'),
    read('app/lib/screens/city_passport_screen.dart'),
    read('app/lib/screens/explore_screen.dart'),
  ]);

  assert.match(journey, /final distractors = <String>\[/);
  assert.match(journey, /% 6/);
  assert.match(passport, /passport-special-journeys/);
  assert.match(passport, /万象奇旅 · 特别旅程/);
  assert.match(home, /home-coin-wallet-hint/);
});
