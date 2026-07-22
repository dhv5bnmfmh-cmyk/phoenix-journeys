import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const read = (path) => readFile(new URL(`../${path}`, import.meta.url), 'utf8');

test('Typography Agent keeps journey surfaces on the shared Phoenix type system', async () => {
  const [theme, journey, popover, detail] = await Promise.all([
    read('app/lib/theme/phoenix_theme.dart'),
    read('app/lib/screens/journey_screen.dart'),
    read('app/lib/widgets/interactive_story_text.dart'),
    read('app/lib/widgets/word_detail_sheet.dart'),
  ]);

  for (const token of ['journeyTitleStyle', 'journeyBodyStyle', 'journeyMetaStyle', 'destinationGlass']) {
    assert.match(theme, new RegExp(token), `missing global design token: ${token}`);
  }
  assert.match(journey, /PhoenixTheme\.journeyBodyStyle\.copyWith/);
  assert.match(popover, /PhoenixTheme\.destinationGlass\(alpha: \.12\)/);
  assert.match(detail, /PhoenixTheme\.destinationGlass\(alpha: \.82\)/);
  assert.doesNotMatch(detail, /Color\(0xB3120E0C\)/, 'word sheet must not become an opaque black box');
});
