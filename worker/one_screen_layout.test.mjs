import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (path) => readFileSync(path, 'utf8');

const primaryScreens = [
  'app/lib/screens/explore_screen.dart',
  'app/lib/screens/passport_screen.dart',
  'app/lib/screens/me_screen.dart',
  'app/lib/screens/journey_screen.dart',
];

test('primary Phoenix screens obey the one-screen layout rule', () => {
  const sources = primaryScreens.map(read).join('\n');
  const passport = read('app/lib/screens/passport_screen.dart');
  const me = read('app/lib/screens/me_screen.dart');
  const journey = read('app/lib/screens/journey_screen.dart');

  assert.doesNotMatch(passport, /return ListView\(/);
  assert.doesNotMatch(me, /return ListView\(/);
  assert.match(journey, /Expanded\(child: child\)/);
  assert.doesNotMatch(sources, /CompactPager\s*\(/);
  assert.doesNotMatch(sources, /PageView\s*\(/);
  assert.doesNotMatch(sources, /TabBarView\s*\(/);
  assert.doesNotMatch(journey, /左右翻页/);
  assert.doesNotMatch(journey, /scrollDirection:\s*Axis\.horizontal/);
});

test('story and Discovery adapt every short paragraph to the same screen', () => {
  const journey = read('app/lib/screens/journey_screen.dart');
  assert.match(journey, /adaptive-story-text-area/);
  assert.match(journey, /adaptive-discovery-text-area/);
  assert.match(journey, /_fitJourneyTextSize/);
  assert.doesNotMatch(journey, /MainAxisAlignment\.spaceBetween/);
  assert.doesNotMatch(journey, /cellHeight\.clamp\(38\.0, 70\.0\)/);
  assert.match(journey, /safeCellHeight = math\.max\(1\.0, cellHeight\)/);
  assert.doesNotMatch(journey, /_NowReadingStrip/);
  assert.doesNotMatch(journey, /朗读位置/);
  assert.doesNotMatch(journey, /本页重点词语/);
});

test('one-screen rule forbids horizontal paging in future development', () => {
  const policy = read('docs/one-screen-interface-rule.md');
  assert.match(policy, /one phone viewport/i);
  assert.match(policy, /Do not use horizontal paging/i);
  assert.match(policy, /PageView/);
  assert.match(policy, /Do not add a top-level vertically scrolling feature stack/i);
});
