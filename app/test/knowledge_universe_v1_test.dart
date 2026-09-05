import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_knowledge_universe.dart';
import 'package:phoenix_journeys/models/knowledge_universe.dart';

void main() {
  group('Phoenix Knowledge Universe V1 validation', () {
    test('KnowledgeUnit must reference a valid canonical source', () {
      expect(
        () => KnowledgeUniverseRepository(
          sources: forbiddenCityKnowledgeSources,
          places: forbiddenCityKnowledgePlaces,
          periods: forbiddenCityKnowledgePeriods,
          personRoles: forbiddenCityKnowledgePersonRoles,
          professions: forbiddenCityKnowledgeProfessions,
          cultureTopics: forbiddenCityKnowledgeCultureTopics,
          events: forbiddenCityKnowledgeEvents,
          knowledgeUnits: <KnowledgeUnit>[
            ...forbiddenCityKnowledgeUnits,
            const KnowledgeUnit(
              id: 'ku.invalid.source',
              claim: '测试 claim',
              simpleChinese: '测试',
              status: KnowledgeStatus.verified,
              sourceRefs: <String>['https://invalid.example/source'],
            ),
          ],
          relations: forbiddenCityKnowledgeRelations,
          storySeeds: forbiddenCityStorySeeds,
        ),
        throwsArgumentError,
      );
    });

    test('verified KnowledgeUnit cannot silently omit provenance', () {
      expect(
        () => KnowledgeUniverseRepository(
          sources: forbiddenCityKnowledgeSources,
          places: forbiddenCityKnowledgePlaces,
          periods: forbiddenCityKnowledgePeriods,
          personRoles: forbiddenCityKnowledgePersonRoles,
          professions: forbiddenCityKnowledgeProfessions,
          cultureTopics: forbiddenCityKnowledgeCultureTopics,
          events: forbiddenCityKnowledgeEvents,
          knowledgeUnits: <KnowledgeUnit>[
            ...forbiddenCityKnowledgeUnits,
            const KnowledgeUnit(
              id: 'ku.invalid.no-source',
              claim: '测试 claim',
              simpleChinese: '测试',
              status: KnowledgeStatus.verified,
            ),
          ],
          relations: forbiddenCityKnowledgeRelations,
          storySeeds: forbiddenCityStorySeeds,
        ),
        throwsArgumentError,
      );
    });

    test('Place parent hierarchy is explicit and valid', () {
      final places = forbiddenCityKnowledgeUniverse.placeById;
      expect(places[knowledgePlaceBeijing]!.parentId, knowledgePlaceChina);
      expect(
        places[knowledgePlaceForbiddenCity]!.parentId,
        knowledgePlaceBeijing,
      );
      expect(
        places[knowledgePlaceMeridianGate]!.parentId,
        knowledgePlaceForbiddenCity,
      );
      expect(
        places[knowledgePlaceQianqingGate]!.parentId,
        knowledgePlaceForbiddenCity,
      );
      expect(
        places[knowledgePlaceJingyunGate]!.parentId,
        knowledgePlaceForbiddenCity,
      );
    });

    test('relation endpoints must exist', () {
      expect(
        () => KnowledgeUniverseRepository(
          sources: forbiddenCityKnowledgeSources,
          places: forbiddenCityKnowledgePlaces,
          periods: forbiddenCityKnowledgePeriods,
          personRoles: forbiddenCityKnowledgePersonRoles,
          professions: forbiddenCityKnowledgeProfessions,
          cultureTopics: forbiddenCityKnowledgeCultureTopics,
          events: forbiddenCityKnowledgeEvents,
          knowledgeUnits: forbiddenCityKnowledgeUnits,
          relations: <KnowledgeRelation>[
            ...forbiddenCityKnowledgeRelations,
            const KnowledgeRelation(
              fromId: knowledgePlaceForbiddenCity,
              type: KnowledgeRelationTypes.connects,
              toId: 'place.missing',
            ),
          ],
          storySeeds: forbiddenCityStorySeeds,
        ),
        throwsArgumentError,
      );
    });

    test('StorySeed only references existing KnowledgeUnits', () {
      expect(
        () => KnowledgeUniverseRepository(
          sources: forbiddenCityKnowledgeSources,
          places: forbiddenCityKnowledgePlaces,
          periods: forbiddenCityKnowledgePeriods,
          personRoles: forbiddenCityKnowledgePersonRoles,
          professions: forbiddenCityKnowledgeProfessions,
          cultureTopics: forbiddenCityKnowledgeCultureTopics,
          events: forbiddenCityKnowledgeEvents,
          knowledgeUnits: forbiddenCityKnowledgeUnits,
          relations: forbiddenCityKnowledgeRelations,
          storySeeds: const <StorySeed>[
            StorySeed(
              id: 'seed.invalid',
              placeRef: knowledgePlaceForbiddenCity,
              periodRef: knowledgePeriodModern,
              characterRoleRef: knowledgeRoleRestorationWorker,
              professionRef: knowledgeProfessionHeritageConservation,
              goal: '测试',
              conflict: '测试',
              knowledgeUnitRefs: <String>['ku.missing'],
              languageLevel: 5,
              learningFocus: <String>['测试'],
            ),
          ],
        ),
        throwsArgumentError,
      );
    });
  });

  group('Phoenix Knowledge Universe V1 query', () {
    test('Forbidden City migrated knowledge is queryable by place', () {
      final results = forbiddenCityKnowledgeUniverse.query(
        const KnowledgeQuery(placeRefs: <String>[knowledgePlaceForbiddenCity]),
      );

      expect(
        results.map((unit) => unit.id).toSet(),
        containsAll(<String>{
          kuForbiddenCityMingQing,
          kuMeridianGateAxis,
          kuQianqingGateCourts,
          kuJingyunGateEast,
          kuCentralAxisSequence,
          kuOuterInnerCourtFunctions,
        }),
      );
    });

    test('knowledge can be queried by historical period', () {
      final results = forbiddenCityKnowledgeUniverse.query(
        const KnowledgeQuery(periodRefs: <String>[knowledgePeriodQing]),
      );

      expect(
        results.map((unit) => unit.id),
        containsAll(<String>[
          kuForbiddenCityMingQing,
          kuOuterInnerCourtFunctions,
        ]),
      );
    });

    test('knowledge can be queried by profession and culture', () {
      final results = forbiddenCityKnowledgeUniverse.query(
        const KnowledgeQuery(
          professionRefs: <String>[knowledgeProfessionArchitecture],
          cultureRefs: <String>[knowledgeCultureArchitecture],
        ),
      );

      expect(results, isNotEmpty);
      expect(
        results.every(
          (unit) =>
              unit.professionRefs.contains(knowledgeProfessionArchitecture) &&
              unit.cultureRefs.contains(knowledgeCultureArchitecture),
        ),
        isTrue,
      );
    });

    test('multi-condition query is deterministic', () {
      const query = KnowledgeQuery(
        placeRefs: <String>[knowledgePlaceBeijing],
        periodRefs: <String>[knowledgePeriodQing],
        professionRefs: <String>[knowledgeProfessionArchitecture],
        cultureRefs: <String>[knowledgeCultureArchitecture],
        statuses: <KnowledgeStatus>[KnowledgeStatus.verified],
      );

      final first = forbiddenCityKnowledgeUniverse
          .query(query)
          .map((unit) => unit.id)
          .toList(growable: false);
      final second = forbiddenCityKnowledgeUniverse
          .query(query)
          .map((unit) => unit.id)
          .toList(growable: false);

      expect(first, second);
      expect(
        first,
        orderedEquals(<String>[
          kuForbiddenCityMingQing,
          kuOuterInnerCourtFunctions,
        ]),
      );
    });

    test('modern StorySeed is backed only by valid KnowledgeUnits', () {
      final seed = forbiddenCityKnowledgeUniverse.storySeeds.single;
      final knowledge = forbiddenCityKnowledgeUniverse.knowledgeById;

      expect(seed.placeRef, knowledgePlaceForbiddenCity);
      expect(seed.periodRef, knowledgePeriodModern);
      expect(seed.characterRoleRef, knowledgeRoleRestorationWorker);
      expect(seed.professionRef, knowledgeProfessionHeritageConservation);
      expect(seed.knowledgeUnitRefs.every(knowledge.containsKey), isTrue);
    });
  });

  group('current Journey regression protection', () {
    test('Discovery authoritative source bindings remain unchanged', () {
      final lv1 = forbiddenCityLevelContent(1).discoveries.first;
      expect(lv1.text, contains('午门'));
      expect(lv1.sourceRefs, contains(forbiddenCityMeridianGateSourceRef));
      expect(lv1.sourceRefs, contains(forbiddenCityAxisPlanSourceRef));
      expect(
        lv1.sourceRefs,
        isNot(contains(forbiddenCityQianqingGateSourceRef)),
      );

      final lv4 = forbiddenCityLevelContent(4).discoveries.first;
      expect(lv4.text, contains('乾清门'));
      expect(lv4.sourceRefs, contains(forbiddenCityQianqingGateSourceRef));

      final lv5 = forbiddenCityLevelContent(5).discoveries.first;
      expect(lv5.text, contains('景运门'));
      expect(
        lv5.sourceRefs,
        orderedEquals(<String>[forbiddenCityJingyunGateSourceRef]),
      );
    });

    test('Knowledge migration does not rewrite current Story or Discovery text', () {
      expect(
        forbiddenCityStoryParagraphsByLevel.first.first,
        contains('十七岁的古建学徒沈砚跟周师傅走进紫禁城'),
      );
      expect(forbiddenCityDiscoveries.first.text, startsWith('午门是紫禁城正门'));
      expect(
        forbiddenCityDiscoveryFocusByLevel[4].text,
        contains('景运门位于乾清门前广场东侧'),
      );
    });
  });
}
