import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const read = (path) => readFileSync(path, 'utf8');

test('primary Phoenix screens obey the one-screen layout rule', () => {
  const explore = read('app/lib/screens/explore_screen.dart');
  const passport = read('app/lib/screens/passport_screen.dart');
  const me = read('app/lib/screens/me_screen.dart');
  const journey = read('app/lib/screens/journey_screen.dart');

  assert.doesNotMatch(explore, /ListView\(\s*padding: const EdgeInsets\.fromLTRB\(14, 10, 14, 60\)/);
  assert.doesNotMatch(passport, /return ListView\(/);
  assert.doesNotMatch(me, /return ListView\(/);
  assert.match(journey, /Expanded\(child: child\)/);
  assert.match(journey, /CompactPager\(/);
  assert.doesNotMatch(journey, /return ListView\(\s*key: ValueKey\(title\)/);
});

test('one-screen rule is documented for future development', () => {
  const policy = read('docs/one-screen-interface-rule.md');
  assert.match(policy, /one phone viewport/i);
  assert.match(policy, /horizontal paging, tabs, grouped cards, or modal sheets/i);
  assert.match(policy, /Do not add a top-level vertically scrolling feature stack/i);
});
