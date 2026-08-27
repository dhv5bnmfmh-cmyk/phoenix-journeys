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
  final narration =
      File('lib/services/narration_controller.dart').readAsStringSync();
  final appState = File('lib/state/app_state.dart').readAsStringSync();
  final selector =
      File('lib/widgets/journey_level_selector_button.dart').readAsStringSync();
  final levelStore =
      File('lib/services/language_level_preference_store.dart')
          .readAsStringSync();

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
    expect(
      cache,
      contains('final List<JourneyLevelContent> _forbiddenCityLevelSnapshots'),
    );
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

  test('Story and Discovery reuse narration definitions for unchanged content', () {
    final narrationDefinitions = _section(
      journey,
      'List<NarrationItem> get _storyNarrationItems',
      'void _restoreNarrationPosition',
    );

    expect(
      journey,
      contains('JourneyLevelContent? _cachedStoryNarrationContent;'),
    );
    expect(journey, contains('List<NarrationItem>? _cachedStoryNarrationItems;'));
    expect(
      journey,
      contains('JourneyLevelContent? _cachedDiscoveryNarrationContent;'),
    );
    expect(
      journey,
      contains('List<NarrationItem>? _cachedDiscoveryNarrationItems;'),
    );
    expect(narrationDefinitions, contains('final content = _levelContent;'));
    expect(
      narrationDefinitions,
      contains('identical(_cachedStoryNarrationContent, content)'),
    );
    expect(
      narrationDefinitions,
      contains('identical(_cachedDiscoveryNarrationContent, content)'),
    );
    expect(narrationDefinitions, contains('return cached;'));
    expect(narrationDefinitions, contains('content.storyParagraphs'));
    expect(narrationDefinitions, contains("id: 'story-\${entry.key}'"));
    expect(narrationDefinitions, contains('content.discoveries'));
    expect(narrationDefinitions, contains("id: 'discovery-\${entry.key}'"));
    expect(narrationDefinitions, isNot(contains('_narration.')));
    expect(narrationDefinitions, isNot(contains('currentOffset')));
    expect(narrationDefinitions, isNot(contains('highlightSnapshot')));
    expect(narrationDefinitions, isNot(contains('reveal')));
  });

  test('narration cache identity follows Journey level content invalidation', () {
    final resolver = _section(
      journey,
      'JourneyLevelContent get _levelContent',
      'ReadingGenerationPlan? get _generationPlan',
    );
    final levelChange = _section(
      journey,
      'Future<void> _applyPhoenixLevelChange()',
      'void _checkpointNarrationBeforeStepChange()',
    );

    expect(resolver, contains('final profile = _languageProfile;'));
    expect(resolver, contains('final difficulty = _appState.journeyDifficulty;'));
    expect(resolver, contains('final knownWordsHash = _knownWordsFingerprint;'));
    expect(resolver, contains('identical(_cachedLevelProfile, profile)'));
    expect(resolver, contains('_cachedLevelDifficulty == difficulty'));
    expect(resolver, contains('_cachedKnownWordsHash == knownWordsHash'));
    expect(levelChange, contains('_languageProfile = profile;'));
    expect(
      journey,
      contains('_experience = requireDailyJourneyExperience(journeyId);'),
    );
    expect(
      journey,
      contains('List<NarrationItem> get _storyPlaybackItems => _storyNarrationItems;'),
    );
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

  test('level switch visible swap is outside persistence and engine cleanup', () {
    final levelChange = _section(
      journey,
      'Future<void> _applyPhoenixLevelChange()',
      'void _checkpointNarrationBeforeStepChange()',
    );
    final visibleSwap = levelChange.indexOf('_languageProfile = profile;');
    final postFrame = levelChange.indexOf('addPostFrameCallback');
    final guideCleanup = levelChange.indexOf('_appState.clearGuideFeedback()');

    expect(visibleSwap, greaterThanOrEqualTo(0));
    expect(postFrame, greaterThan(visibleSwap));
    expect(guideCleanup, greaterThan(postFrame));
    expect(
      levelChange,
      contains('final narrationCancellationToken =\n        _narration.cancelPlaybackImmediately();'),
    );
    expect(levelChange, contains('final narrationPositionFuture ='));
    expect(levelChange, contains('final speechRateFuture ='));
    expect(levelChange, isNot(contains('await _stopJourneyNarration();')));
  });

  test('narration cancellation separates immediate state from engine stop', () {
    expect(narration, contains('int cancelPlaybackImmediately('));
    expect(
      narration,
      contains('Future<void> flushCancelledPlayback(int cancellationToken) async'),
    );
    expect(
      narration,
      contains('if (cancellationToken != _playbackIntentToken) return;'),
    );
    expect(narration, contains('final shouldStopEngine = _engineStopPending;'));
    expect(
      narration,
      contains('_stopSpeechEngine(advanceSessionToken: false)'),
    );
    expect(
      narration,
      contains('(_sharedSpeechRate - rate).abs() >= .001'),
    );
  });

  test('stale level cleanup is rejected before dangerous side effects', () {
    final levelChange = _section(
      journey,
      'Future<void> _applyPhoenixLevelChange()',
      'void _checkpointNarrationBeforeStepChange()',
    );
    final settleStart = levelChange.indexOf('Future<void> _settlePhoenixLevelChange');
    expect(settleStart, greaterThanOrEqualTo(0));
    final settle = levelChange.substring(settleStart);
    final guard = settle.indexOf('if (!mounted || token != _levelChangeToken) return;');
    final flush = settle.indexOf('_narration.flushCancelledPlayback(');
    final feedback = settle.indexOf('_appState.clearGuideFeedback()');
    expect(guard, greaterThanOrEqualTo(0));
    expect(flush, greaterThan(guard));
    expect(feedback, greaterThan(guard));
  });

  test('narration persistence is serialized so latest intent wins on disk', () {
    expect(
      appState,
      contains('Future<void> _journeyNarrationPersistence = Future<void>.value();'),
    );
    expect(
      appState,
      contains('Future<void> _queueJourneyNarrationPersistence('),
    );
    expect(appState, contains('final previous = _journeyNarrationPersistence;'));
    expect(appState, contains('await previous;'));
    expect(
      appState,
      contains('_journeyNarrationPersistence = next.catchError((_) {});'),
    );
  });

  test('narration position memory clears before SharedPreferences I/O', () {
    final clear = _section(
      appState,
      'Future<void> clearJourneyNarrationPosition',
      'Future<void> saveGuideFeedback',
    );
    final memoryClear = clear.indexOf('journeyNarrationContentId = null;');
    final persistence =
        clear.indexOf('return _queueJourneyNarrationPersistence(');
    expect(memoryClear, greaterThanOrEqualTo(0));
    expect(persistence, greaterThan(memoryClear));
  });

  test('rapid level intent is not blocked by persistence', () {
    expect(selector, isNot(contains('_changing')));
    expect(selector, contains('Future<void> _levelPersistence'));
    expect(selector, contains('_store.persistPhoenixLevel(next)'));
    expect(selector, isNot(contains('await _store.savePhoenixLevel(next)')));
    expect(levelStore, contains('Future<void> persistPhoenixLevel(int level)'));
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
