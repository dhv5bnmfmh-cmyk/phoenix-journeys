import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const agent = readFileSync('app/lib/agents/phoenix_stamp_agent.dart', 'utf8');
const stamp = readFileSync('app/lib/widgets/city_journey_stamp.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const workflow = readFileSync('docs/development-workflow.md', 'utf8');

test('every completion stamp uses the real press animation agent', () => {
  assert.match(
    journey,
    /AnimatedCityJourneyStamp\(\s*journey: _experience,[\s\S]*?size: 104/,
  );
  assert.match(stamp, /PhoenixStampAgent\(vsync: this\)/);
  assert.match(stamp, /_agent\.pressOffset\.value/);
  assert.match(stamp, /_agent\.pressScale\.value/);
  assert.match(stamp, /city-stamp-tool/);
  assert.match(stamp, /city-stamp-imprint/);
});

test('the physical stamp disappears while the imprint stays visible', () => {
  assert.match(agent, /toolOpacity = TweenSequence<double>/);
  assert.match(agent, /Tween\(begin: 1\.0, end: 0\.0\)/);
  assert.match(stamp, /opacity: _agent\.toolOpacity\.value/);
  assert.match(stamp, /opacity: _agent\.imprintOpacity\.value/);
  assert.match(
    workflow,
    /实体印章从上方落下、接触时压缩回弹、留下城市印迹/,
  );
  assert.match(workflow, /随后实体工具移出并淡出/);
});

test('the remaining transparent imprint sits at the background upper right', () => {
  assert.match(journey, /completion-background-stamp/);
  assert.match(journey, /alignment: Alignment\.topRight/);
  assert.match(stamp, /transparentInk: true/);
  assert.match(stamp, /transparentInk\s*\?\s*Colors\.transparent/);
});
