import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _section(String source, String start, String end) {
  final startIndex = source.indexOf(start);
  expect(startIndex, greaterThanOrEqualTo(0), reason: 'Missing architecture anchor: $start');
  final endIndex = source.indexOf(end, startIndex + start.length);
  expect(endIndex, greaterThanOrEqualTo(0), reason: 'Missing architecture anchor: $end');
  return source.substring(startIndex, endIndex);
}

void main() {
  final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
  final interactive =
      File('lib/widgets/interactive_story_text.dart').readAsStringSync();

  test('Shared Story Component: PASS', () {
    final story = _section(journey, 'Widget _storyPage()', 'Widget _wordsPage()');

    expect(journey, contains('Widget _storyPage() => _defaultStoryPage();'));
    expect(
      RegExp(r'Widget (_[A-Za-z0-9]+StoryPage)\s*\(')
          .allMatches(journey)
          .map((match) => match.group(1))
          .toSet(),
      equals(<String>{'_storyPage', '_defaultStoryPage'}),
      reason: 'Journey-specific Story renderer requires Founder-approved architecture review.',
    );
    expect(story, isNot(contains('_isForbiddenCity')));
    expect(story, isNot(contains('forbiddenCityJourneyId')));
    expect(
      RegExp(r'(?:if|switch)\s*\([^)]*(?:journeyId|_experience\.id)[^)]*\)')
          .hasMatch(story),
      isFalse,
      reason: 'Standard Story presentation must not branch by Journey identity.',
    );
  });

  test('Shared Narration Runtime: PASS', () {
    expect(
      journey,
      contains('List<NarrationItem> get _storyPlaybackItems => _storyNarrationItems;'),
    );
    expect(
      RegExp(r'NarrationController\(\)').allMatches(journey).length,
      1,
      reason: 'JourneyScreen must own one shared narration controller.',
    );
    expect(journey, contains('items: _storyPlaybackItems'));
  });

  test('Shared Cinematic Reveal: PASS', () {
    final story = _section(journey, 'Widget _storyPage()', 'Widget _wordsPage()');
    final reveal = _section(
      journey,
      'int? _narrationRevealEnd(',
      'Widget _storyPage()',
    );
    final cursor = _section(
      interactive,
      'double _targetRevealCursor(int? revealEnd)',
      'double get _currentRevealCursor',
    );

    expect(story, contains('revealEnd: _narrationRevealEnd('));
    expect(reveal, isNot(contains('_isForbiddenCity')));
    expect(reveal, isNot(contains('journeyId')));
    expect(reveal, isNot(contains('_experience.id')));
    expect(cursor, contains('revealEnd ?? widget.text.length'));
    expect(cursor, isNot(contains("narrationContentId == 'story'")));
  });

  test('Shared Progress Model: PASS', () {
    expect(journey, isNot(contains('_storySegmentIndex')));
    expect(journey, isNot(contains('story-segment-progress')));
    expect(journey, isNot(contains('story-segment-scroll')));
    expect(journey, isNot(contains('StorySegmentController')));
  });

  test('Stable Baseline Parity: PASS', () {
    final story = _section(journey, 'Widget _storyPage()', 'Widget _wordsPage()');
    final stages = _section(
      journey,
      '@override\n  Widget build(BuildContext context)',
      'Widget _page({',
    );

    expect(story, contains('NarrationPlayerCard('));
    expect(story, contains('InteractiveStoryText('));
    expect(story, contains("contentId: 'story'"));
    expect(story, contains("narrationContentId: 'story'"));
    expect(story, contains("key: const ValueKey('story-auto-visibility-scroll')"));

    expect(journey, contains('bool get _isSummerPalacePilot => false;'));
    expect(stages, contains('_storyPage(),'));
    expect(stages, contains('_wordsPage(),'));
    expect(stages, contains('_discoveryPage(),'));
    expect(stages, contains('_challengePage()'));
    expect(stages, contains('_memoryPage()'));
    expect(stages, contains('_completePage(),'));
    expect(stages, isNot(contains('_isForbiddenCity')));
    expect(stages, isNot(contains('forbiddenCityJourneyId')));
  });
}
