import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const passport = readFileSync('app/lib/screens/passport_screen.dart', 'utf8');

test('PR preview unlocks every passport city', () => {
  assert.match(passport, /uri\.host\.startsWith\('phoenix-journeys-pr-'\)/);
  assert.match(passport, /uri\.queryParameters\['unlock'\] == 'all'/);
  assert.match(passport, /onPressed: allAccess \|\| isToday \|\| active/);
  assert.match(passport, /isUnlocked: earned \|\| allAccess/);
  assert.match(passport, /allAccess[\s\S]*'开始体验'/);
});

test('preview map removes lock symbols for all cities', () => {
  assert.match(passport, /earned \|\| allAccess[\s\S]*journey\.stampSymbol/);
  assert.match(passport, /'体验 · 七城开放'/);
  assert.match(passport, /'体验版已开放全部城市与学习步骤。'/);
});

test('production still keeps daily rotation rules', () => {
  assert.match(passport, /allAccess \|\| isToday \|\| active/);
  assert.match(passport, /'等待成为今日旅程'/);
  assert.match(passport, /'等待轮换'/);
});
