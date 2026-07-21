import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const state = readFileSync('app/lib/state/app_state.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');
const me = readFileSync('app/lib/screens/me_screen.dart', 'utf8');
const explorerUi = [state, journey, sheet, me].join('\n');

test('explorer-facing vocabulary labels consistently use 单词', () => {
  assert.doesNotMatch(explorerUi, /生词/);
  assert.match(state, /'单词'/);
  assert.match(journey, /title: '单词'/);
  assert.match(sheet, /收藏单词/);
  assert.match(sheet, /上一个单词/);
  assert.match(sheet, /下一个单词/);
  assert.match(me, /我的单词/);
  assert.match(me, /单词本/);
});
