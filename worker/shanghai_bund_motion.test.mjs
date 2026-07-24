import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const background = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);

test('Shanghai Bund uses its own cinematic river and skyline motion', () => {
  assert.match(background, /_shanghaiBundJourneyId = 'shanghai-bund'/);
  assert.match(background, /class _ShanghaiBundDynamicBackground/);
  assert.match(background, /Duration\(seconds: 15\)/);
  assert.match(background, /shanghai-bund-camera-transform/);
  assert.match(background, /shanghai-bund-skyline-glow/);
  assert.match(background, /shanghai-bund-river-light/);
  assert.match(background, /shanghai-bund-boat-shadow/);
});

test('Shanghai Bund motion remains lightweight', () => {
  const start = background.indexOf('class _ShanghaiBundDynamicBackground');
  const end = background.indexOf('class _SummerPalaceDynamicBackground');
  const bund = background.slice(start, end);
  assert.doesNotMatch(bund, /CustomPaint|VideoPlayer|\.mp4|animated.*webp/i);
  assert.match(bund, /RepaintBoundary/);
  assert.match(bund, /_motion\.repeat\(reverse: true\)/);
});
