import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const background = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);

const remainingJourneys = [
  ['xian-city-wall', 26],
  ['hangzhou-west-lake', 28],
  ['chengdu-kuanzhai-alley', 27],
  ['nanjing-qinhuai-river', 29],
  ['guangzhou-chen-clan-academy', 26],
];

test('every remaining journey uses the new cinematic dynamic background', () => {
  for (const [journeyId, seconds] of remainingJourneys) {
    assert.match(background, new RegExp(`'${journeyId}'`));
    assert.match(
      background,
      new RegExp(
        `keyName: '${journeyId}',[\\s\\S]*?Duration\\(seconds: ${seconds}\\)`,
      ),
    );
    assert.match(background, new RegExp(`\\$\\{style\\.keyName\\}-dynamic-background`));
  }
  assert.match(background, /_remainingDynamicBackgrounds\[journeyId\]/);
  assert.match(background, /class _CinematicDestinationBackground/);
});

test('remaining journey motion is premium, local, and phone-safe', () => {
  const start = background.indexOf('class _CinematicDestinationBackground');
  const end = background.indexOf('class _JourneyBackgroundScrim');
  const cinematic = background.slice(start, end);

  assert.match(cinematic, /RepaintBoundary/);
  assert.match(cinematic, /_motion\.repeat\(\)/);
  assert.match(cinematic, /FilterQuality\.high/);
  assert.match(cinematic, /_destinationReduceMotion\(context\)/);
  assert.match(cinematic, /precacheImage\(AssetImage\(path\), context\)/);
  assert.match(cinematic, /_CinematicMovingLight/);
  assert.match(cinematic, /_CinematicAtmosphere/);
  assert.match(cinematic, /_CinematicForegroundDepth/);
  assert.match(cinematic, /_CinematicWaterLight/);
  assert.doesNotMatch(cinematic, /VideoPlayer|\.mp4|animated.*webp|CustomPaint/i);
});
