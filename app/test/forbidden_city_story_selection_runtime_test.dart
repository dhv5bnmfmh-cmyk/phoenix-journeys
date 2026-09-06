import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_content_pipeline_fixture.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_runtime.dart';
import 'package:phoenix_journeys/models/content_pipeline.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const originalLv1 =
      '十七岁的古建学徒沈砚跟周师傅走进紫禁城。沈砚从午门出发，沿中轴向北走。他要画一张路线图，给新学徒看。他走到乾清门前，觉得这条路线最正确。阿宁从东侧来到乾清门前。她要把记录送回东边，目标和沈砚不同。沈砚说：“你走错了。”阿宁说：“我们一起看。”两人重新看图。两条路线都到乾清门前。沈砚留下两条路线。周师傅问：“为什么？”沈砚说：“同一个地方，可以有不同路线。”';

  test(
    'Forbidden City owns exactly two Story children without a second Journey',
    () {
      expect(forbiddenCityStoryCatalog, hasLength(2));
      expect(forbiddenCityStoryCatalog.map((story) => story.title), <String>[
        '两条路，一张图',
        '交接前的标记',
      ]);
      expect(
        dailyJourneyIds.where((id) => id == forbiddenCityJourneyId),
        hasLength(1),
      );
      expect(journeyExperienceById(forbiddenCitySecondStoryId), isNull);
    },
  );

  test('Founder PASS Story remains byte-for-byte unchanged at Lv1', () {
    expect(forbiddenCityStoryParagraphsByLevel.first.single, originalLv1);
  });

  test('Second Story runtime imports approved pipeline content without regeneration', () {
    ensureForbiddenCitySecondStoryRuntimeValid();
    final content = forbiddenCitySecondStoryLevelContent();
    expect(forbiddenCityPipelineFixture.storyContent.lines, hasLength(7));
    expect(content.storyParagraphs, hasLength(2));
    final visibleStory = content.storyParagraphs.join();
    expect(visibleStory.length, inInclusiveRange(280, 400));
    final sentenceLengths = content.storyParagraphs
        .expand((paragraph) => paragraph.split(RegExp(r'[。！？]')))
        .map((sentence) => sentence.trim().length)
        .where((length) => length > 0);
    expect(sentenceLengths.every((length) => length <= 30), isTrue);
    expect(content.words.map((word) => word.word), <String>[
      '中轴',
      '景运门',
      '核对',
      '交接',
    ]);
    expect(
      content.discoveries.map((entry) => entry.text),
      forbiddenCityPipelineFixture.discoveries.map((entry) => entry.text),
    );
    expect(
      forbiddenCityPipelineFixture.status,
      ContentCandidateStatus.validated,
    );
    expect(
      forbiddenCityPipelineFixture.validationReport.automatedValidation,
      isTrue,
    );
  });

  test(
    'Second Story Challenge consumes only approved taught target material',
    () {
      final sources = forbiddenCitySecondStoryChallengeSourceMaterial;
      expect(
        sources.map((source) => source.replaceFirst(RegExp(r'。$'), '')),
        forbiddenCityPipelineFixture.challenges.map((item) => item.targetText),
      );
      final challenge = const JourneyChallengeEngine().build(
        journeyId: forbiddenCitySecondStoryId,
        sessionLevel: 5,
        storyParagraphs: sources,
      );
      expect(challenge.questions, hasLength(12));
      expect(
        challenge.questions
            .map((question) => question.signature.sourceHash)
            .toSet()
            .length,
        greaterThanOrEqualTo(4),
      );
      expect(
        challenge.questions
            .map((question) => question.signature.equivalenceKey)
            .toSet(),
        hasLength(12),
      );
      expect(
        challenge.questions.any(
          (question) =>
              question.sourceSentence.contains('沈砚') ||
              question.sourceSentence.contains('阿宁'),
        ),
        isFalse,
      );
    },
  );

  test(
    'Story progress, completion, resume and Memory are isolated by Story ID',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final state = AppState(
        clock: () => DateTime(2026, 9, 6, 15),
        preferencesLoader: SharedPreferences.getInstance,
      );
      await state.load();

      await state.activateJourney(
        forbiddenCityJourneyId,
        storyId: forbiddenCityPrimaryStoryId,
      );
      await state.saveJourneyProgress(
        step: 2,
        wonder: '',
        express: '',
        memory: 'A draft',
      );
      final primaryMemoryId = state.activeJourneyMemoryId;
      await state.saveActiveJourneyMemory('A memory', sessionLevel: 5);

      await state.activateJourney(
        forbiddenCityJourneyId,
        storyId: forbiddenCitySecondStoryId,
      );
      expect(state.journeyStep, 0);
      expect(state.memoryDraft, isEmpty);
      final secondMemoryId = state.activeJourneyMemoryId;
      expect(secondMemoryId, isNot(primaryMemoryId));
      await state.saveJourneyProgress(
        step: 3,
        wonder: '',
        express: '',
        memory: 'B draft',
      );
      await state.saveActiveJourneyMemory('B memory', sessionLevel: 5);
      await state.completeJourney('B memory', sessionLevel: 5);

      final secondProgress = await state.forbiddenCityStoryProgress(
        forbiddenCitySecondStoryId,
      );
      expect(secondProgress.completed, isTrue);

      await state.activateJourney(
        forbiddenCityJourneyId,
        storyId: forbiddenCityPrimaryStoryId,
      );
      expect(state.journeyStep, 2);
      expect(state.journeyCompleted, isFalse);
      expect(state.memoryDraft, 'A draft');
      expect(state.activeJourneyMemoryId, primaryMemoryId);

      await state.activateJourney(
        forbiddenCityJourneyId,
        storyId: forbiddenCitySecondStoryId,
      );
      expect(state.journeyCompleted, isTrue);
      expect(state.journeyStep, AppState.journeyLastStep);
      expect(state.activeJourneyMemoryId, secondMemoryId);
      expect(
        state.journeyMemories
            .where((entry) => !entry.legacy)
            .map((entry) => entry.id)
            .toSet(),
        containsAll(<String>{primaryMemoryId, secondMemoryId}),
      );
    },
  );
}
