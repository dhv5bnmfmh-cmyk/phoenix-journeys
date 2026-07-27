import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const source = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const start = source.indexOf('Widget _page({');
const end = source.indexOf('int? _narrationRevealEnd', start);
const pageChrome = source.slice(start, end);

test('journey progress header is the only shared page label', () => {
  assert.match(pageChrome, /JourneyProgressHeader\(/);
  assert.doesNotMatch(pageChrome, /PhoenixTheme\.journeyTitleStyle/);
  assert.doesNotMatch(pageChrome, /Text\(\s*title/);
});
