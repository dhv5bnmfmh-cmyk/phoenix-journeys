import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const interactive = readFileSync(
  'app/lib/widgets/interactive_story_text.dart',
  'utf8',
);

function section(source, start, end) {
  const startIndex = source.indexOf(start);
  assert.notEqual(startIndex, -1, `Missing architecture anchor: ${start}`);
  const endIndex = source.indexOf(end, startIndex + start.length);
  assert.notEqual(endIndex, -1, `Missing architecture anchor: ${end}`);
  return source.slice(startIndex, endIndex);
}

const storyPresentation = section(
  journey,
  'Widget _storyPage()',
  'Widget _wordsPage()',
);
const revealRuntime = section(
  journey,
  'int? _narrationRevealEnd(',
  'Widget _storyPage()',
);
const playbackRuntime = section(
  journey,
  'List<NarrationItem> get _storyPlaybackItems',
  'Future<void> _playDiscoveries',
);
const stageRuntime = section(
  journey,
  '@override\n  Widget build(BuildContext context)',
  'Widget _page({',
);

const directJourneyIdentityBranch =
  /(?:if\s*\([^)]*(?:(?:journeyId|_experience\.id)\s*(?:==|!=)|(?:==|!=)\s*(?:journeyId|_experience\.id))[^)]*\)|switch\s*\(\s*(?:journeyId|_experience\.id)\s*\))/;

test('normal Journeys use one shared Phoenix Story component', () => {
  assert.match(journey, /Widget _storyPage\(\) => _defaultStoryPage\(\);/);

  const specializedStoryPages = [
    ...journey.matchAll(/Widget (_[A-Za-z0-9]+StoryPage)\s*\(/g),
  ].map((match) => match[1]);
  assert.deepEqual(
    specializedStoryPages,
    ['_defaultStoryPage'],
    'Journey-specific Story page renderers require Founder-approved architecture review',
  );

  assert.doesNotMatch(
    storyPresentation,
    /_is[A-Za-z0-9]*Journey\b|_isForbiddenCity|forbiddenCityJourneyId/,
    'Journey-specific Story presentation flags require architecture review',
  );
  assert.doesNotMatch(
    storyPresentation,
    directJourneyIdentityBranch,
    'Normal Story presentation must not route runtime by Journey identity',
  );
  assert.match(
    storyPresentation,
    /SpecialRealmStoryIntro\.supports\(_experience\.id\)/,
    'Approved destination/special-realm visuals may remain data-driven inside the shared Story renderer',
  );
});

test('normal Journeys use one shared narration runtime and progress model', () => {
  assert.match(
    journey,
    /List<NarrationItem> get _storyPlaybackItems => _storyNarrationItems;/,
  );
  assert.match(playbackRuntime, /items:\s*_storyPlaybackItems/);
  assert.equal(
    (journey.match(/NarrationController\(\)/g) ?? []).length,
    1,
    'JourneyScreen must own exactly one shared narration controller',
  );
  assert.doesNotMatch(
    journey,
    /_storySegmentIndex|story-segment-progress|story-segment-scroll|StorySegmentController/,
    'Parallel Story progress/segment state is forbidden',
  );
});

test('normal Journeys use one shared cinematic reveal runtime', () => {
  assert.match(storyPresentation, /revealEnd:\s*_narrationRevealEnd\(/);
  assert.doesNotMatch(revealRuntime, /journeyId|_experience\.id|_isForbiddenCity/);

  const cursor = section(
    interactive,
    'double _targetRevealCursor(int? revealEnd)',
    'double get _currentRevealCursor',
  );
  assert.match(cursor, /revealEnd \?\? widget\.text\.length/);
  assert.doesNotMatch(
    cursor,
    /narrationContentId\s*==\s*['"]story['"]|journeyId|forbidden/i,
    'Story-wide or Journey-specific reveal bypass is forbidden',
  );
});

test('normal Journeys keep the stable shared six-stage navigation', () => {
  assert.match(journey, /bool get _isSummerPalacePilot => false;/);
  assert.match(stageRuntime, /final page = switch \(step\) \{/);
  assert.match(stageRuntime, /0 => _storyPage\(\)/);
  assert.match(stageRuntime, /1 => _wordsPage\(\)/);
  assert.match(stageRuntime, /2 => _discoveryPage\(\)/);
  assert.match(stageRuntime, /3 => stepThreePage[\s\S]*_challengePage\(\)/);
  assert.match(stageRuntime, /4 => stepFourPage[\s\S]*_memoryPage\(\)/);
  assert.match(stageRuntime, /_ => _completePage\(\)/);
  assert.match(stageRuntime, /child: page/);
  assert.doesNotMatch(stageRuntime, /final pages = <Widget>\[/);
  assert.doesNotMatch(stageRuntime, /pages\[step\]/);
  assert.doesNotMatch(
    stageRuntime,
    /_is[A-Za-z0-9]*Journey\b|_isForbiddenCity|forbiddenCityJourneyId/,
    'Normal Journey stage navigation must not branch by Journey identity',
  );
  assert.doesNotMatch(
    stageRuntime,
    directJourneyIdentityBranch,
    'Normal Journey stage navigation must not route by Journey identity',
  );
});

test('Journey Runtime Architecture Gate reports stable baseline parity', () => {
  assert.ok(storyPresentation.includes('NarrationPlayerCard('));
  assert.ok(storyPresentation.includes('InteractiveStoryText('));
  assert.ok(storyPresentation.includes("contentId: 'story'"));
  assert.ok(storyPresentation.includes("narrationContentId: 'story'"));
  assert.ok(storyPresentation.includes("key: const ValueKey('story-auto-visibility-scroll')"));
});
