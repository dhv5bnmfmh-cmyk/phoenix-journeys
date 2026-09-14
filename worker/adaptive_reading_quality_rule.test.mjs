import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const runtime = readFileSync(
  'app/lib/data/adaptive_journey_level_runtime.dart',
  'utf8',
);
const catalog = readFileSync(
  'app/lib/data/all_journey_language_level_catalog.dart',
  'utf8',
);
const levels = readFileSync(
  'app/lib/data/journey_level_catalog.dart',
  'utf8',
);
const screen = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const theme = readFileSync('app/lib/theme/phoenix_theme.dart', 'utf8');

test('all regular and special journeys are limited to two reading blocks', () => {
  assert.match(levels, /withReadingLimit\(/);
  assert.match(levels, /paragraphCount\.clamp\(1, 2\)/);
  assert.match(levels, /discoveryCount\.clamp\(1, 2\)/);
  assert.match(runtime, /\.withReadingLimit\(/);
});

test('explorer level chooses one long block or two short blocks', () => {
  assert.match(catalog, /_discoveryParagraphCount/);
  assert.match(catalog, /PhoenixReadingBand\.beginner[\s\S]*=> 1/);
  assert.match(catalog, /PhoenixReadingBand\.advanced[\s\S]*=> 1/);
  assert.match(catalog, /PhoenixReadingBand\.elementary[\s\S]*=> 2/);
  assert.match(catalog, /_mergeDiscoveryEntries/);
  assert.match(screen, /深度长文/);
  assert.match(screen, /分段短文/);
});

test('story keeps narrative meaning separate from cultural discovery', () => {
  const storyBuilder = catalog.slice(
    catalog.indexOf('_AdaptiveStory _buildStory'),
    catalog.indexOf('ReadingAnnotation _combineAnnotation'),
  );
  assert.doesNotMatch(storyBuilder, /discoveries\.first\.text/);
  assert.doesNotMatch(storyBuilder, /firstDiscoveries/);
});

test('global primary buttons share a refined Phoenix treatment', () => {
  assert.match(theme, /minimumSize: const Size\(48, 48\)/);
  assert.match(theme, /BorderSide\(color: gold/);
  assert.match(theme, /elevation: 4/);
  assert.match(theme, /overlayColor: WidgetStatePropertyAll/);
});
