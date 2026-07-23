import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const agent = readFileSync(
  'app/lib/agents/phoenix_immersion_agent.dart',
  'utf8',
);

test('reading journeys enter calm immersion without destroying content state', () => {
  assert.match(journey, /bool get _supportsImmersion => step >= 0 && step <= 2/);
  assert.match(journey, /Duration\(milliseconds: 1600\)/);
  assert.match(journey, /opacity: immersed \? \.035 : 1/);
  assert.match(journey, /IgnorePointer\([\s\S]*ignoring: immersed/);
  assert.match(journey, /onPointerDown: \(_\) => _immersion\.registerInteraction\(\)/);
  assert.match(journey, /轻触屏幕显示内容/);
});

test('immersion timer is centralized in PhoenixImmersionAgent', () => {
  assert.match(agent, /idleDelay = const Duration\(seconds: 7\)/);
  assert.match(agent, /void registerInteraction\(\)/);
  assert.match(agent, /_idleTimer = Timer\(idleDelay/);
});
