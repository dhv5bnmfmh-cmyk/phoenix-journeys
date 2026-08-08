import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const scene = readFileSync('app/lib/widgets/living_story_scene.dart', 'utf8');
const choreography = readFileSync(
  'app/lib/data/forbidden_city_story_scenes.dart',
  'utf8',
);

test('Living Story remains an enhancement of the shared Story screen', () => {
  assert.match(journey, /class JourneyScreen extends StatefulWidget/);
  assert.match(journey, /LivingStoryScene\(/);
  assert.match(journey, /InteractiveStoryText\(/);
  assert.match(journey, /NarrationPlayerCard\(/);
  assert.doesNotMatch(journey, /ForbiddenCityStory(?:Screen|Renderer|Engine)/);
});

test('narration ticks are reduced to cue-boundary scene changes', () => {
  assert.match(scene, /if \(next == _cueIndex\) return false/);
  assert.match(scene, /notifyListeners\(\)/);
  assert.match(scene, /widget\.progressListenable\.addListener\(_handleProgress\)/);
  assert.equal((scene.match(/AnimationController\(/g) ?? []).length, 2);
});

test('ambient and narrative motion remain bounded and level timelines cached', () => {
  assert.match(scene, /Duration\(seconds: 18\)/);
  assert.match(scene, /livingStoryReduceMotion/);
  assert.match(scene, /queryParameters\['motion'\] == 'on'/);
  assert.match(choreography, /forbiddenCityStoryVariantsByLevel/);
  assert.match(choreography, /List<StorySceneVariant>\.unmodifiable/);
  assert.doesNotMatch(journey, /ForbiddenCityStory(?:Screen|Renderer|Engine)/);
});
