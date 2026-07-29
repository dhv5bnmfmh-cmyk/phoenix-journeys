import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const homeShell = readFileSync(
  new URL('../app/lib/screens/home_shell.dart', import.meta.url),
  'utf8',
);
const explore = readFileSync(
  new URL('../app/lib/screens/explore_screen.dart', import.meta.url),
  'utf8',
);

test('shadowing is a fixed navigation tab immediately after passport', () => {
  const passport = homeShell.indexOf("label: state.displayText('护照')");
  const shadowing = homeShell.indexOf("label: state.displayText('跟读训练')");
  const profile = homeShell.indexOf("label: state.displayText('我的')");

  assert.ok(passport >= 0);
  assert.ok(shadowing > passport);
  assert.ok(profile > shadowing);
  assert.match(homeShell, /ShadowingTrainingScreen\(embedded: true\)/);
});

test('explore page no longer carries an inline shadowing shortcut', () => {
  assert.doesNotMatch(explore, /home-shadowing-training-entry/);
  assert.doesNotMatch(explore, /_ShadowingHomeEntry/);
});
