import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const explore = readFileSync('app/lib/screens/explore_screen.dart', 'utf8');

test('home flight runs once and remains at the selected destination', () => {
  assert.match(explore, /duration: const Duration\(seconds: 14\)/);
  assert.match(explore, /_controller\.forward\(\)/);
  assert.doesNotMatch(explore, /duration: const Duration\(seconds: 14\),\s*\)\.\.repeat\(\)/);
  assert.match(explore, /late String _animatedJourneyId/);
  assert.match(explore, /journeyId != _animatedJourneyId/);
  assert.match(explore, /\.\.value = 0\s*\.\.forward\(\)/);
});

test('camera, cruise and landing form one continuous arrival sequence', () => {
  assert.match(explore, /Interval\(0, \.38, curve: Curves\.easeInOutCubic\)/);
  assert.match(explore, /\.20,\s*\.78,\s*curve: Curves\.easeInOutCubic/);
  assert.match(explore, /\.78,\s*\.94,\s*curve: Curves\.easeInCubic/);
  assert.match(explore, /\.68,\s*1\.0,\s*curve: Curves\.easeInOutCubic/);
  assert.match(explore, /landingPoint\(landingT\)/);
  assert.match(explore, /active: state\.activeJourneyStampEarned \|\| landingT > \.35/);
});

test('map flight respects reduced-motion accessibility', () => {
  assert.match(explore, /disableAnimations/);
  assert.match(explore, /queryParameters\['motion'\] == 'on'/);
  assert.match(explore, /if \(reduceMotion\)[\s\S]{0,100}_controller[\s\S]{0,80}\.\.value = 1/);
});
