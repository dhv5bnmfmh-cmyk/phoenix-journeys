import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/forbidden_city_ai_content_pipeline_v1.dart';
import 'package:phoenix_journeys/data/forbidden_city_challenge_package.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_knowledge_universe.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_engine_v1.dart';
import 'package:phoenix_journeys/models/content_pipeline.dart';
import 'package:phoenix_journeys/models/knowledge_universe.dart';

void main() {
  group('AI Content Pipeline V1', () {
    test('1 Knowledge selection deterministic', () {
      final a = forbiddenCityAiContentPipelineV1.selectKnowledge(
        forbiddenCityPipelineKnowledgeSelection,
      );
      final b = forbiddenCityAiContentPipelineV1.selectKnowledge(
        forbiddenCityPipelineKnowledgeSelection,
      );
      expect(a.canonicalSignature, b.canonicalSignature);
      expect(a.knowledgeUnitRefs, orderedEquals(List<String>.from(a.knowledgeUnitRefs)..sort()));
      expect(a.knowledgeUnitRefs, hasLength(4));
    });

    test('2 invalid KnowledgeUnit rejected', () {
      expect(
        () => forbiddenCityAiContentPipelineV1.selectKnowledge(
          const KnowledgeSelectionRequest(
            placeRefs: <String>[knowledgePlaceForbiddenCity],
            requiredKnowledgeUnitRefs: <String>['ku.not.real'],
          ),
        ),
        throwsArgumentError,
      );
    });

    test('3 Story fact trace valid', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      expect(package.factTrace, hasLength(4));
      expect(package.qualityReport.factTracePass, isTrue);
      for (final trace in package.factTrace) {
        expect(trace.knowledgeUnitRefs, isNotEmpty);
        expect(trace.sourceRefs, isNotEmpty);
        for (final ref in trace.knowledgeUnitRefs) {
          final unit = forbiddenCityKnowledgeUniverse.knowledgeById[ref]!;
          expect(unit.status, KnowledgeStatus.verified);
          expect(trace.sourceRefs.toSet().containsAll(unit.sourceRefs), isTrue);
        }
      }
    });

    test('4 Vocabulary only from Story', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      for (final item in package.vocabulary) {
        expect(package.storyContent.text, contains(item.word));
      }
      expect(package.qualityReport.vocabularyOriginPass, isTrue);
    });

    test('5 Vocabulary storySource valid', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      final storyIds = package.storyContent.beats.map((beat) => beat.id).toSet();
      for (final item in package.vocabulary) {
        expect(storyIds, contains(item.storySource));
        final beat = package.storyContent.beats.singleWhere((b) => b.id == item.storySource);
        expect(beat.text, contains(item.word));
        expect(item.usage, beat.text);
      }
    });

    test('6 Discovery only from valid Knowledge', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      for (final discovery in package.discoveries) {
        expect(discovery.knowledgeUnitRefs, isNotEmpty);
        for (final ref in discovery.knowledgeUnitRefs) {
          final unit = forbiddenCityKnowledgeUniverse.knowledgeById[ref];
          expect(unit, isNotNull);
          expect(unit!.status, KnowledgeStatus.verified);
          expect(package.knowledgeUnitRefs, contains(ref));
        }
      }
    });

    test('7 Discovery factual source valid', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      for (final discovery in package.discoveries) {
        expect(discovery.sourceRefs, isNotEmpty);
        for (final sourceRef in discovery.sourceRefs) {
          expect(forbiddenCityKnowledgeUniverse.sourceByRef[sourceRef], isNotNull);
        }
      }
      expect(package.qualityReport.sourceValidityPass, isTrue);
    });

    test('8 Challenge cannot test untaught knowledge', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      final bad = package.copyWith(
        challenges: <PipelineChallengeTarget>[
          ...package.challenges,
          PipelineChallengeTarget(
            id: 'pipeline.challenge.untaught',
            kind: PipelineChallengeKind.knowledgeMcq,
            target: '未教学知识',
            knowledgeUnitRefs: const <String>[kuForbiddenCityMingQing],
            vocabularyRefs: const <String>[],
            teachingRefs: <String>[package.storyContent.beats.first.id],
          ),
        ],
      );
      final report = ContentQualityGate(forbiddenCityKnowledgeUniverse).evaluate(bad);
      expect(report.challengeAlignmentPass, isFalse);
      expect(report.passed, isFalse);
    });

    test('9 Memory aligned to Story', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      final storyIds = package.storyContent.beats.map((beat) => beat.id).toSet();
      final vocabIds = package.vocabulary.map((item) => item.id).toSet();
      expect(storyIds, contains(package.memory.storyAnchor));
      expect(storyIds, contains(package.memory.characterMoment));
      expect(package.memory.knowledgeUnitRefs.every(package.knowledgeUnitRefs.toSet().contains), isTrue);
      expect(package.memory.vocabularyRecall.every(vocabIds.contains), isTrue);
      expect(package.qualityReport.memoryAlignmentPass, isTrue);
    });

    test('10 entire package deterministic', () {
      final second = forbiddenCityAiContentPipelineV1.build(
        packageId: 'journey.candidate.forbidden_city.modern_evidence_handoff',
        packageVersion: forbiddenCityAiContentPackageVersion,
        knowledgeSnapshotVersion: forbiddenCityStoryEngineKnowledgeSnapshotVersion,
        knowledgeSelection: forbiddenCityPipelineKnowledgeSelection,
        seedRequest: forbiddenCityPipelineSeedRequest,
        storyBlueprint: forbiddenCitySecondStoryBlueprint,
        vocabularyLexicon: forbiddenCityPipelineVocabularyLexicon,
      );
      expect(second.canonicalSignature, forbiddenCitySecondJourneyContentPackage.canonicalSignature);
      expect(second.status, JourneyContentStatus.validated);
    });

    test('11 content package provenance complete', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      final ids = package.provenance.map((item) => item.contentId).toSet();
      final expected = <String>{
        ...package.storyContent.beats.map((item) => item.id),
        ...package.vocabulary.map((item) => item.id),
        ...package.discoveries.map((item) => item.id),
        ...package.challenges.map((item) => item.id),
        'memory.storyAnchor',
        'memory.knowledgeTakeaway',
        'memory.vocabularyRecall',
        'memory.characterMoment',
      };
      expect(ids.containsAll(expected), isTrue);
      expect(package.validationReport.isValid, isTrue);
      expect(package.validationReport.criticalErrors, isEmpty);
    });

    test('12 critical quality failure cannot become APPROVED', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      final first = package.vocabulary.first;
      final bad = package.copyWith(
        vocabulary: <PipelineVocabularyItem>[
          PipelineVocabularyItem(
            id: first.id,
            word: '故事里没有的词',
            pinyin: first.pinyin,
            partOfSpeech: first.partOfSpeech,
            simpleChinese: first.simpleChinese,
            storySource: first.storySource,
            usage: first.usage,
            semanticContrast: first.semanticContrast,
            knowledgeUnitRefs: first.knowledgeUnitRefs,
          ),
          ...package.vocabulary.skip(1),
        ],
      );
      final report = ContentQualityGate(forbiddenCityKnowledgeUniverse).evaluate(bad);
      expect(report.passed, isFalse);
      expect(report.criticalFailures, contains('VOCABULARY_ORIGIN'));
      expect(() => forbiddenCityAiContentPipelineV1.approve(bad), throwsStateError);
      expect(package.status, JourneyContentStatus.validated);
      expect(package.status, isNot(JourneyContentStatus.approved));
    });

    test('13 AI-slop / duplication basic guard', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      final first = package.storyContent.beats.first;
      final bad = package.copyWith(
        storyContent: CanonicalStoryContent(
          beats: <StoryContentBeat>[
            StoryContentBeat(
              id: first.id,
              type: first.type,
              text: '通过这件事我们了解到一个地点。',
              knowledgeUnitRefs: first.knowledgeUnitRefs,
              sourceRefs: first.sourceRefs,
            ),
            ...package.storyContent.beats.skip(1),
          ],
        ),
      );
      final report = ContentQualityGate(forbiddenCityKnowledgeUniverse).evaluate(bad);
      expect(report.storyQualityPass, isFalse);
      expect(report.passed, isFalse);
      expect(package.storyContent.text, isNot(contains('通过这件事')));
      expect(package.storyContent.text, isNot(contains('由此可知')));
    });

    test('14 second Story candidate differs from current Founder Story', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      expect(package.storyPlan.title, forbiddenCitySecondJourneyCandidateName);
      expect(package.storyPlan.title, isNot(forbiddenCityJourney01.title));
      expect(package.storyContent.text, contains('林乔'));
      expect(package.storyContent.text, isNot(contains('沈砚')));
      expect(package.storyContent.text, isNot(contains('阿宁')));
    });

    test('15 current Story unchanged', () {
      expect(forbiddenCityStoryParagraphsByLevel, hasLength(10));
      expect(
        forbiddenCityStoryParagraphsByLevel.first.single,
        '十七岁的古建学徒沈砚跟周师傅走进紫禁城。沈砚从午门出发，沿中轴向北走。他要画一张路线图，给新学徒看。他走到乾清门前，觉得这条路线最正确。阿宁从东侧来到乾清门前。她要把记录送回东边，目标和沈砚不同。沈砚说：“你走错了。”阿宁说：“我们一起看。”两人重新看图。两条路线都到乾清门前。沈砚留下两条路线。周师傅问：“为什么？”沈砚说：“同一个地方，可以有不同路线。”',
      );
    });

    test('16 current Vocabulary unchanged', () {
      final lv1 = forbiddenCityWordsForLevel(1);
      expect(lv1.first.word, '午门');
      expect(validateForbiddenCityWordTrace(), isEmpty);
    });

    test('17 current Discovery unchanged', () {
      final discovery = forbiddenCityLevelContent(1).discoveries.first;
      expect(discovery.text, startsWith('Lv1 先认清三个 Story 地点：午门'));
      expect(discovery.sourceRefs, contains(forbiddenCityMeridianGateSourceRef));
      expect(discovery.sourceRefs, contains(forbiddenCityAxisPlanSourceRef));
    });

    test('18 current Challenge unchanged', () {
      expect(forbiddenCityParagraphRebuild, hasLength(10));
      expect(forbiddenCityParagraphRebuild.first.correctOrder, <int>[1, 3, 0, 2]);
      expect(forbiddenCityGrammarRepair.first.correct, '她要把一份记录送到东边，目标和沈砚不同。');
    });

    test('19 current Memory unchanged', () {
      expect(forbiddenCityMemoryReviews, hasLength(3));
      expect(forbiddenCityMemoryReviews.first.answer, '沈砚和阿宁把两条都能走通的路线留在同一张图上。');
      expect(forbiddenCityCompletionMoments, hasLength(10));
      expect(forbiddenCityCoreTakeaway, '一条常用路线，并不等于唯一正确的路线。');
    });

    test('20 UI unchanged', () {
      for (final path in <String>[
        'lib/models/content_pipeline.dart',
        'lib/data/forbidden_city_ai_content_pipeline_v1.dart',
      ]) {
        final source = File(path).readAsStringSync();
        expect(source, isNot(contains('package:flutter/')));
        expect(source, isNot(contains('/widgets/')));
        expect(source, isNot(contains('/screens/')));
        expect(source, isNot(contains('Widget build(')));
      }
    });

    test('V1 auto-generation tops out at VALIDATED', () {
      final package = forbiddenCitySecondJourneyContentPackage;
      expect(package.status, JourneyContentStatus.validated);
      expect(package.qualityReport.passed, isTrue);
      expect(package.validationReport.isValid, isTrue);
      expect(() => forbiddenCityAiContentPipelineV1.approve(package), throwsStateError);
    });
  });
}
