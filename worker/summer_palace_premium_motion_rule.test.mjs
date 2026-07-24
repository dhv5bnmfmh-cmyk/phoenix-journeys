import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const source = readFileSync(
  'app/lib/widgets/destination_background.dart',
  'utf8',
);
const start = source.indexOf(
  'class _SummerPalaceDynamicBackground extends StatefulWidget',
);
const end = source.indexOf('class _JourneyBackgroundScrim', start);
const summerPalace = source.slice(start, end);

test('Summer Palace uses a slow premium cinematic cycle', () => {
  assert.match(summerPalace, /Duration\(seconds: 21\)/);
  assert.match(summerPalace, /repeat\(reverse: true\)/);
  assert.match(summerPalace, /Curves\.easeInOutSine/);
});

test('Summer Palace keeps layered depth without artificial ripple lines', () => {
  assert.match(summerPalace, /summer-palace-cinematic-color-grade/);
  assert.match(summerPalace, /summer-palace-mist-veil/);
  assert.match(summerPalace, /summer-palace-water-shimmer/);
  assert.match(summerPalace, /summer-palace-foreground-breath/);
  assert.match(summerPalace, /RadialGradient\(/);
  assert.doesNotMatch(summerPalace, /CustomPainter|drawLine\(|drawPath\(/);
});

test('Summer Palace motion respects reduced-motion mode', () => {
  assert.match(summerPalace, /_destinationReduceMotion\(context\)/);
  assert.match(summerPalace, /_motion\.stop\(\)/);
});
