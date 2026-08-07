import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_content_cache.dart';

String _section(String source, String start, String end) {
  final startIndex = source.indexOf(start);
  expect(startIndex, greaterThanOrEqualTo(0), reason: 'Missing anchor: $start');
  final endIndex = source.indexOf(end, startIndex + start.length);
  expect(endIndex, greaterThanOrEqualTo(0), reason: 'Missing anchor: $end');
  return source.substring(startIndex, endIndex);
}

void main() {
  final journey = File('lib/screens/journey_screen.dart').readAsStringSync();
  final runtime =
      File('lib/data/forbidden_city_journey_runtime.dart').readAsStringSync();
  final cache =
      File('lib/data/forbidden_city_content_cache.dart').readAsStringSync();
  final trace =
      File('lib/data/forbidden_city_trace_validation.dart').readAsStringSync();
  final adaptive =
      File('lib/data/adaptive_journey_level_runtime.dart').readAsStringSync();
  final interactive =
      File('lib/widgets/interactive_story_text.dart').readAsStringSync();

  test('Forbidden City Lv1 Lv5 Lv10 reuse immutable level snapshots', () {
    warmForbiddenCityContentCache();
    for (final level in <int>[1, 5, 10]) {
      final first = cachedForbiddenCityLevelContent(level);
      final second = cachedForbiddenCityLevelContent(level);
      expect(identical(first, second), isTrue);
      expect(first.storyParagraphs, isNotEmpty);
      expect(first.storyAnnotations.length, first.storyParagraphs.length);
      expect(first.words, isNotEmpty);
    }
  });

  test('Story narration hot path does not generate Pinyin or validate traces', () {
    final story = _section(
      journey,
      'Widget _defaultStoryPage()',
      'Widget _wordsPage()',
    );
    final levelResolver = _section(
      journey,
      'JourneyLevelContent get _levelContent',
      'ReadingGenerationPlan? get _generationPlan',
    );

    expect(story, isNot(contains('PinyinHelper.getPinyinE')));
    expect(story, isNot(contains('forbiddenCityValidatedWordsForLevel')));
    expect(levelResolver, isNot(contains('forbiddenCityValidatedWordsForLevel')));
    expect(journey, isNot(contains("forbidden_city_trace_validation.dart")));
    expect(trace, contains('forbiddenCityWordTraceIsValid'));
    expect(trace, contains('_earliestLevelContaining'));
    expect(runtime, contains('PinyinHelper.getPinyinE'));
    expect(cache, contains('late final List<JourneyLevelContent>'));
    expect(cache, contains('warmForbiddenCityContentCache'));
    expect(adaptive, contains('cachedForbiddenCityLevelContent(level)'));
  });

  test('active Journey content is memoized independently of narration progress', () {
    final resolver = _section(
      journey,
      'JourneyLevelContent get _levelContent',
      'ReadingGenerationPlan? get _generationPlan',
    );

    expect(journey, contains('JourneyLevelContent? _cachedLevelContent;'));
    expect(journey, contains('ChineseProficiencyProfile? _cachedLevelProfile;'));
    expect(journey, contains('JourneyDifficulty? _cachedLevelDifficulty;'));
    expect(journey, contains('int? _cachedKnownWordsHash;'));
    expect(resolver, contains('return cached;'));
    expect(resolver, contains('_cachedLevelContent = resolved;'));
    expect(resolver, isNot(contains('_narration.')));
  });

  test('shared Story build captures one content snapshot before narration ticks', () {
    final story = _section(
      journey,
      'Widget _defaultStoryPage()',
      'Widget _wordsPage()',
    );
    final animationStart = story.indexOf('return AnimatedBuilder(');
    expect(animationStart, greaterThanOrEqualTo(0));
    final animation = story.substring(animationStart);

    expect(story, contains('final levelContent = _levelContent;'));
    expect(story, contains('final storyParagraphs = levelContent.storyParagraphs;'));
    expect(story, contains('final storyAnnotations = levelContent.storyAnnotations;'));
    expect(story, contains('final words = levelContent.words;'));
    expect(story, isNot(contains('_levelContent.')));
    expect(animation, isNot(contains('_levelContent')));
  });

  test('shared InteractiveStoryText skips unchanged vocabulary reparsing', () {
    expect(
      interactive,
      contains('!identical(oldWidget.entries, widget.entries) &&'),
    );
    expect(interactive, contains('if (textChanged || entriesChanged)'));
    expect(interactive, contains('_buildSegments();'));
  });

  test('performance remediation preserves shared cinematic Story architecture', () {
    final story = _section(
      journey,
      'Widget _defaultStoryPage()',
      'Widget _wordsPage()',
    );

    expect(journey, contains('Widget _storyPage() => _defaultStoryPage();'));
    expect(journey, isNot(contains('_forbiddenCityStoryPage')));
    expect(story, contains('InteractiveStoryText('));
    expect(story, contains('narrationController: _narration'));
    expect(story, contains('revealEnd: _narrationRevealEnd('));
    expect(story, contains("narrationContentId: 'story'"));
    expect(story, contains("key: const ValueKey('story-auto-visibility-scroll')"));
  });
}
