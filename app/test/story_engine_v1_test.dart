import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/forbidden_city_challenge_package.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_knowledge_universe.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_engine_v1.dart';
import 'package:phoenix_journeys/models/knowledge_universe.dart';
import 'package:phoenix_journeys/models/story_engine.dart';

StoryBlueprint _blueprint({
  List<NarrativeClaim>? narrativeClaims,
  List<ChallengeTarget>? challengeTargets,
}) =>
    StoryBlueprint(
      id: forbiddenCitySecondStoryBlueprint.id,
      title: forbiddenCitySecondStoryBlueprint.title,
      characters: forbiddenCitySecondStoryBlueprint.characters,
      storyBeats: forbiddenCitySecondStoryBlueprint.storyBeats,
      requiredFacts: forbiddenCitySecondStoryBlueprint.requiredFacts,
      narrativeClaims:
          narrativeClaims ?? forbiddenCitySecondStoryBlueprint.narrativeClaims,
      vocabularyTargets: forbiddenCitySecondStoryBlueprint.vocabularyTargets,
      discoveryTargets: forbiddenCitySecondStoryBlueprint.discoveryTargets,
      challengeTargets:
          challengeTargets ?? forbiddenCitySecondStoryBlueprint.challengeTargets,
    );

void main() {
  group('Story Engine V1 source-grounded contract', () {
    test('1 StorySeed invalid KnowledgeUnit fails', () {
      const seed = StorySeed(
        id: 'seed.invalid',
        placeRef: knowledgePlaceForbiddenCity,
        periodRef: knowledgePeriodModern,
        characterRoleRef: knowledgeRoleRestorationWorker,
        professionRef: knowledgeProfessionHeritageConservation,
        goal: 'test',
        conflict: 'test',
        knowledgeUnitRefs: <String>['ku.does.not.exist'],
        languageLevel: 5,
        learningFocus: <String>['test'],
      );
      expect(
        () => forbiddenCityStoryEngineV1.compose(
          seed: seed,
          blueprint: forbiddenCitySecondStoryBlueprint,
          knowledgeSnapshotVersion:
              forbiddenCityStoryEngineKnowledgeSnapshotVersion,
        ),
        throwsArgumentError,
      );
    });

    test('2 factual claims are traceable KnowledgeUnit -> Source', () {
      final audit = forbiddenCitySecondStoryKnowledgeCoverage;
      expect(audit.factualClaimMap, hasLength(4));
      for (final trace in audit.factualClaimMap) {
        expect(trace.knowledgeUnitRefs, isNotEmpty);
        expect(trace.sourceRefs, isNotEmpty);
        for (final ref in trace.knowledgeUnitRefs) {
          final unit = forbiddenCityKnowledgeUniverse.knowledgeById[ref];
          expect(unit, isNotNull);
          expect(unit!.status, KnowledgeStatus.verified);
          expect(unit.sourceRefs, isNotEmpty);
          expect(trace.sourceRefs.toSet().containsAll(unit.sourceRefs), isTrue);
        }
      }
    });

    test('3 every Story source exists in canonical Knowledge Universe', () {
      for (final sourceRef in forbiddenCitySecondStoryPlan.sourceRefs) {
        expect(forbiddenCityKnowledgeUniverse.sourceByRef[sourceRef], isNotNull);
      }
    });

    test('4 fictional narrative carries no fabricated provenance', () {
      final fictional = forbiddenCitySecondStoryPlan.narrativeClaims
          .where((claim) => claim.type == NarrativeClaimType.fictionalNarrative)
          .toList(growable: false);
      expect(fictional, isNotEmpty);
      expect(fictional.every((claim) => claim.knowledgeUnitRefs.isEmpty), isTrue);
      final tracedIds = forbiddenCitySecondStoryKnowledgeCoverage.factualClaimMap
          .map((trace) => trace.claimId)
          .toSet();
      expect(fictional.every((claim) => !tracedIds.contains(claim.id)), isTrue);
    });

    test('5 factual narrative without KnowledgeUnit/source fails', () {
      final claims = <NarrativeClaim>[
        ...forbiddenCitySecondStoryBlueprint.narrativeClaims
            .where((claim) => claim.type != NarrativeClaimType.fact),
        const NarrativeClaim(
          id: 'fact.invalid',
          text: '一个没有来源的历史事实。',
          type: NarrativeClaimType.fact,
        ),
      ];
      expect(
        () => forbiddenCityStoryEngineV1.compose(
          seed: forbiddenCitySecondStorySeed,
          blueprint: _blueprint(narrativeClaims: claims),
          knowledgeSnapshotVersion:
              forbiddenCityStoryEngineKnowledgeSnapshotVersion,
        ),
        throwsArgumentError,
      );
    });

    test('6 same StorySeed + snapshot produces deterministic StoryPlan', () {
      final second = forbiddenCityStoryEngineV1.compose(
        seed: forbiddenCitySecondStorySeed,
        blueprint: forbiddenCitySecondStoryBlueprint,
        knowledgeSnapshotVersion: forbiddenCityStoryEngineKnowledgeSnapshotVersion,
      );
      expect(
        second.canonicalSignature,
        forbiddenCitySecondStoryPlan.canonicalSignature,
      );
      expect(
        forbiddenCitySecondStoryPlan.storyBeats.map((beat) => beat.type),
        StoryBeatType.values,
      );
    });

    test('7 KnowledgeUnit query is deterministic', () {
      const query = KnowledgeQuery(
        placeRefs: <String>[knowledgePlaceForbiddenCity],
        statuses: <KnowledgeStatus>[KnowledgeStatus.verified],
      );
      final first = forbiddenCityKnowledgeUniverse.query(query)
          .map((unit) => unit.id)
          .toList(growable: false);
      final second = forbiddenCityKnowledgeUniverse.query(query)
          .map((unit) => unit.id)
          .toList(growable: false);
      expect(first, second);
      expect(first, orderedEquals(List<String>.from(first)..sort()));
    });

    test('8 Story and Vocabulary targets are aligned', () {
      final taught = forbiddenCitySecondStoryPlan.knowledgeUnitRefs.toSet();
      final storyText = forbiddenCitySecondStoryPlan.storyBeats
          .map((beat) => beat.text)
          .join('');
      for (final target in forbiddenCitySecondStoryPlan.vocabularyTargets) {
        expect(storyText, contains(target.term));
        expect(target.knowledgeUnitRefs.every(taught.contains), isTrue);
      }
      expect(
        forbiddenCitySecondStoryLearningAlignment.whatVocabularyCameFromIt(),
        <String>['午门', '中轴', '乾清门', '景运门'],
      );
    });

    test('9 Story and Discovery targets are aligned', () {
      final taught = forbiddenCitySecondStoryLearningAlignment
          .whatDidThisStoryTeach()
          .toSet();
      final discoveries = forbiddenCitySecondStoryLearningAlignment
          .whatDiscoveryFactsSupportIt();
      expect(discoveries, isNotEmpty);
      expect(discoveries.every(taught.contains), isTrue);
      expect(
        discoveries,
        containsAll(<String>[
          kuMeridianGateAxis,
          kuCentralAxisSequence,
          kuQianqingGateCourts,
          kuJingyunGateEast,
        ]),
      );
    });

    test('10 Challenge cannot reference knowledge Story/Discovery did not teach', () {
      final invalidChallenges = <ChallengeTarget>[
        ...forbiddenCitySecondStoryBlueprint.challengeTargets,
        const ChallengeTarget(
          id: 'challenge.untaught',
          concept: '未教学的明清皇宫身份',
          knowledgeUnitRefs: <String>[kuForbiddenCityMingQing],
        ),
      ];
      expect(
        () => forbiddenCityStoryEngineV1.compose(
          seed: forbiddenCitySecondStorySeed,
          blueprint: _blueprint(challengeTargets: invalidChallenges),
          knowledgeSnapshotVersion:
              forbiddenCityStoryEngineKnowledgeSnapshotVersion,
        ),
        throwsArgumentError,
      );
      expect(
        forbiddenCitySecondStoryLearningAlignment
            .whatChallengeConceptsAreAllowed(),
        hasLength(3),
      );
    });

    test('11 second Forbidden City Story is distinct from Founder PASS Story', () {
      expect(forbiddenCitySecondStoryPlan.title, '交接前的标记');
      expect(forbiddenCitySecondStoryPlan.title, isNot(forbiddenCityJourney01.title));
      final candidate = forbiddenCitySecondStoryPlan.storyBeats
          .map((beat) => beat.text)
          .join('');
      expect(candidate, isNot(contains('沈砚')));
      expect(candidate, isNot(contains('阿宁')));
      expect(candidate, contains('林乔'));
    });

    test('12 current Founder PASS Story remains unchanged', () {
      expect(forbiddenCityStoryParagraphsByLevel, hasLength(10));
      expect(
        forbiddenCityStoryParagraphsByLevel.first.single,
        '十七岁的古建学徒沈砚跟周师傅走进紫禁城。沈砚从午门出发，沿中轴向北走。他要画一张路线图，给新学徒看。他走到乾清门前，觉得这条路线最正确。阿宁从东侧来到乾清门前。她要把记录送回东边，目标和沈砚不同。沈砚说：“你走错了。”阿宁说：“我们一起看。”两人重新看图。两条路线都到乾清门前。沈砚留下两条路线。周师傅问：“为什么？”沈砚说：“同一个地方，可以有不同路线。”',
      );
      expect(forbiddenCityJourneySummary, contains('沈砚'));
      expect(forbiddenCityJourneySummary, contains('阿宁'));
    });

    test('13 current Vocabulary remains unchanged', () {
      final lv1 = forbiddenCityWordsForLevel(1);
      expect(lv1, isNotEmpty);
      expect(lv1.first.word, '午门');
      expect(validateForbiddenCityWordTrace(), isEmpty);
    });

    test('14 current Discovery remains unchanged', () {
      final discovery = forbiddenCityLevelContent(1).discoveries.first;
      expect(discovery.text, startsWith('Lv1 先认清三个 Story 地点：午门'));
      expect(discovery.sourceRefs, contains(forbiddenCityMeridianGateSourceRef));
      expect(discovery.sourceRefs, contains(forbiddenCityAxisPlanSourceRef));
    });

    test('15 current Challenge remains unchanged', () {
      expect(forbiddenCityParagraphRebuild, hasLength(10));
      expect(forbiddenCityParagraphRebuild.first.correctOrder, <int>[1, 3, 0, 2]);
      expect(
        forbiddenCityGrammarRepair.first.correct,
        '她要把一份记录送到东边，目标和沈砚不同。',
      );
    });

    test('16 current Memory remains unchanged', () {
      expect(forbiddenCityMemoryReviews, hasLength(3));
      expect(
        forbiddenCityMemoryReviews.first.answer,
        '沈砚和阿宁把两条都能走通的路线留在同一张图上。',
      );
      expect(forbiddenCityCompletionMoments, hasLength(10));
      expect(forbiddenCityCoreTakeaway, '一条常用路线，并不等于唯一正确的路线。');
    });

    test('17 Story Engine infrastructure has no UI dependency', () {
      for (final path in <String>[
        'lib/models/story_engine.dart',
        'lib/data/forbidden_city_story_engine_v1.dart',
      ]) {
        final source = File(path).readAsStringSync();
        expect(source, isNot(contains('package:flutter/')));
        expect(source, isNot(contains('/widgets/')));
        expect(source, isNot(contains('/screens/')));
        expect(source, isNot(contains('Widget build(')));
      }
    });

    test('coverage reports used and unused verified KnowledgeUnits', () {
      final audit = forbiddenCitySecondStoryKnowledgeCoverage;
      expect(
        audit.usedKnowledge,
        <String>[
          kuCentralAxisSequence,
          kuJingyunGateEast,
          kuMeridianGateAxis,
          kuQianqingGateCourts,
        ],
      );
      expect(audit.unusedKnowledge, contains(kuForbiddenCityMingQing));
      expect(audit.unusedKnowledge, contains(kuOuterInnerCourtFunctions));
    });
  });
}
