import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_two_content.dart';
import 'package:phoenix_journeys/data/journey_story_catalog.dart';
import 'package:phoenix_journeys/data/journey_story_identity.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/screens/journey_story_selection_screen.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';
import 'package:phoenix_journeys/state/app_state.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('Forbidden City exposes two Stories under one Destination', () {
    final golden = requireDailyJourneyExperience(forbiddenCityGoldenJourneyId);
    final stories = storiesForJourney(golden);

    expect(stories.map((story) => story.id), containsAll(<String>[
      forbiddenCityGoldenJourneyId,
      forbiddenCityStoryTwoJourneyId,
    ]));
    expect(stories.length, 2);
    expect(stories.map((story) => story.destinationId).toSet(), <String>{'forbidden-city'});
    expect(stories.map((story) => story.geoNodeId).toSet().length, 1);
    expect(dailyJourneyIds, isNot(contains(forbiddenCityStoryTwoJourneyId)));
  });

  test('Story identities share place but isolate storage namespaces', () {
    final golden = requireJourneyLocation(forbiddenCityGoldenJourneyId);
    final storyTwo = requireJourneyLocation(forbiddenCityStoryTwoJourneyId);

    expect(golden.locationPath, storyTwo.locationPath);
    expect(golden.geoNodeId, storyTwo.geoNodeId);
    expect(golden.storyId, forbiddenCityGoldenStoryId);
    expect(storyTwo.storyId, forbiddenCityStoryTwoId);
    expect(golden.storageNamespace, 'journey.beijing/forbidden-city');
    expect(
      storyTwo.storageNamespace,
      'journey.beijing/forbidden-city.story.wuying-hall-light-limit',
    );
    expect(golden.storageNamespace, isNot(storyTwo.storageNamespace));
  });

  test('Story progress and narration remain isolated across switching', () async {
    final state = AppState(clock: () => DateTime(2026, 9, 16));
    await state.load();

    await state.activateJourney(forbiddenCityStoryTwoJourneyId);
    await state.saveJourneyProgress(
      step: 2,
      wonder: 'story-two-wonder',
      express: 'story-two-express',
      memory: 'story-two-memory',
    );
    await state.saveJourneyNarrationPosition(
      contentId: 'story',
      contentSignature: 'story-two-signature',
      offset: 37,
    );

    await state.activateJourney(forbiddenCityGoldenJourneyId);
    expect(state.journeyStep, isNot(2));
    expect(state.wonderDraft, isNot('story-two-wonder'));
    expect(state.journeyNarrationOffsetFor('story'), 0);

    await state.saveJourneyProgress(
      step: 1,
      wonder: 'golden-wonder',
      express: '',
      memory: '',
    );

    await state.activateJourney(forbiddenCityStoryTwoJourneyId);
    expect(state.journeyStep, 2);
    expect(state.wonderDraft, 'story-two-wonder');
    expect(state.expressDraft, 'story-two-express');
    expect(state.memoryDraft, 'story-two-memory');
    expect(state.journeyNarrationOffsetFor('story'), 37);

    await state.activateJourney(forbiddenCityGoldenJourneyId);
    expect(state.journeyStep, 1);
    expect(state.wonderDraft, 'golden-wonder');
  });

  test('Story 2 Lv1-Lv10 content is complete and place-specific', () {
    for (var level = 1; level <= 10; level++) {
      final content = forbiddenCityStoryTwoLevelContent(level);
      final text = <String>[
        ...content.storyParagraphs,
        ...content.discoveries.map((entry) => entry.text),
      ].join();
      expect(content.storyParagraphs, isNotEmpty, reason: 'Lv$level Story');
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
      expect(content.words, isNotEmpty, reason: 'Lv$level Vocabulary');
      expect(content.discoveries, isNotEmpty, reason: 'Lv$level Discovery');
      expect(content.wonderQuestion.trim(), isNotEmpty);
      expect(content.expressQuestion.trim(), isNotEmpty);
      expect(
        text.contains('武英殿') || text.contains('紫禁城'),
        isTrue,
        reason: 'Lv$level must retain Forbidden City necessity',
      );
    }
  });

  test('Story 2 Challenge is 120 authored questions with 2x6 each level', () {
    const engine = JourneyChallengeEngine();
    const modes = <StoryChallengeMode>[
      StoryChallengeMode.sentenceRebuild,
      StoryChallengeMode.grammarRepair,
      StoryChallengeMode.storyCompletion,
      StoryChallengeMode.storyEvidence,
      StoryChallengeMode.knowledgeReasoning,
      StoryChallengeMode.scenarioDecision,
    ];
    final matrix = <StoryChallengeSet>[];

    for (var level = 1; level <= 10; level++) {
      final content = forbiddenCityStoryTwoLevelContent(level);
      final set = engine.build(
        journeyId: forbiddenCityStoryTwoJourneyId,
        sessionLevel: level,
        storyParagraphs: content.storyParagraphs,
      );
      matrix.add(set);
      expect(set.journeyId, forbiddenCityStoryTwoJourneyId);
      expect(set.questions.length, 12, reason: 'Lv$level question count');
      for (final mode in modes) {
        expect(
          set.questions.where((question) => question.mode == mode).length,
          2,
          reason: 'Lv$level ${mode.name}',
        );
      }
      for (final grammar in set.questions
          .where((question) => question.mode == StoryChallengeMode.grammarRepair)) {
        expect(grammar.errorSegments.length, 4);
        expect(grammar.errorSegmentIndex, isNotNull);
        expect(grammar.options.length, 4);
        expect(grammar.options.toSet().length, 4);
        expect(grammar.grammarOptionExplanations.length, 4);
        for (final option in grammar.options) {
          expect(RegExp(r'[。？！]$').hasMatch(option.trim()), isTrue);
        }
      }
    }

    expect(matrix.expand((set) => set.questions).length, 120);
    expect(const ChallengeAntiTemplateAuditor().auditMatrix(matrix).passed, isTrue);
  });

  test('Story 2 Memory uses its own anchor and closure', () {
    final memory = batchOneMemorySpecFor(
      forbiddenCityStoryTwoJourneyId,
      phoenixLevel: 10,
    );
    expect(memory, isNotNull);
    expect(memory!.longTermAnchor, forbiddenCityStoryTwoMemoryAnchor);
    expect(memory.longTermAnchor, isNot(forbiddenCityMemoryAnchor));
    expect(memory.completionSummary, contains('不再加光'));
    expect(memory.culturalPoint, contains('武英殿'));
  });

  testWidgets('shared Story selector renders both Forbidden City Stories',
      (tester) async {
    final golden = requireDailyJourneyExperience(forbiddenCityGoldenJourneyId);
    final state = AppState(clock: () => DateTime(2026, 9, 16));
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          home: JourneyStorySelectionScreen(destinationJourney: golden),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('两条路，一张图'), findsOneWidget);
    expect(find.text(forbiddenCityStoryTwoTitle), findsOneWidget);
    expect(find.byKey(const ValueKey('journey-story-selection-list')), findsOneWidget);
  });

  testWidgets('Story 2 authored Grammar uses shared two-step HSK UI',
      (tester) async {
    const engine = JourneyChallengeEngine();
    final content = forbiddenCityStoryTwoLevelContent(5);
    final full = engine.build(
      journeyId: forbiddenCityStoryTwoJourneyId,
      sessionLevel: 5,
      storyParagraphs: content.storyParagraphs,
    );
    final grammar = full.questions
        .firstWhere((question) => question.mode == StoryChallengeMode.grammarRepair);
    final grammarOnly = StoryChallengeSet(
      journeyId: full.journeyId,
      sessionLevel: full.sessionLevel,
      questions: <StoryChallengeQuestion>[grammar],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 720,
            child: HskStoryChallenge(
              challenge: grammarOnly,
              displayText: (value) => value,
              onCompleted: () async {},
              onNarrate: (_, __) async {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('STEP 1 · 哪里错？'), findsOneWidget);
    expect(grammar.errorSegments.length, 4);
    await tester.tap(
      find.byKey(ValueKey('grammar-location-${grammar.errorSegmentIndex}')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('challenge-submit')));
    await tester.pump();
    expect(find.byKey(const ValueKey('grammar-step1-continue')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('grammar-step1-continue')));
    await tester.pump();
    expect(find.text('STEP 2 · 怎么改？'), findsOneWidget);
    expect(grammar.options.length, 4);
  });

  test('Golden identity and title remain unchanged', () {
    final golden = requireDailyJourneyExperience(forbiddenCityGoldenJourneyId);
    expect(golden.storyTitle, '两条路，一张图');
    expect(golden.storyId, forbiddenCityGoldenStoryId);
    expect(golden.isPrimaryStory, isTrue);
    expect(requireJourneyLocation(golden.id).storageNamespace,
        'journey.beijing/forbidden-city');
  });
}
