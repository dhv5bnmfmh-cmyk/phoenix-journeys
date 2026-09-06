import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/beijing_city_standard.dart';
import 'package:phoenix_journeys/data/beijing_story_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_content_pipeline_fixture.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_knowledge_universe.dart';
import 'package:phoenix_journeys/data/forbidden_city_story_engine_v1.dart';
import 'package:phoenix_journeys/models/content_pipeline.dart';
import 'package:phoenix_journeys/models/knowledge_universe.dart';

void main() {
  group('AI Content Pipeline V1 fixture boundary', () {
    test('1 fixture is not registered as a production Journey', () {
      expect(forbiddenCityPipelineFixture.id, forbiddenCityPipelineFixturePackageId);
      expect(
        beijingJourneyCatalog.map((journey) => journey.id),
        isNot(contains(forbiddenCityPipelineFixturePackageId)),
      );
      expect(
        beijingJourneyCatalog.map((journey) => journey.title),
        isNot(contains('交接前的标记')),
      );
    });

    test('2 fixture is absent from production Journey catalogs', () {
      for (final path in <String>[
        'lib/data/beijing_story_catalog.dart',
        'lib/data/all_journey_language_level_catalog.dart',
        'lib/data/dedicated_adaptive_journey_catalog.dart',
      ]) {
        final source = File(path).readAsStringSync();
        expect(source, isNot(contains(forbiddenCityPipelineFixturePackageId)));
        expect(source, isNot(contains(forbiddenCitySecondStorySeed.id)));
      }
    });

    test('3 fixture creates no production Journey route', () {
      final appSource = File('lib/app.dart').readAsStringSync();
      expect(appSource, isNot(contains(forbiddenCityPipelineFixturePackageId)));
      expect(appSource, isNot(contains(forbiddenCitySecondStorySeed.id)));
      expect(appSource, isNot(contains('交接前的标记')));
    });

    test('4 invalid KnowledgeUnit is rejected by knowledge selection', () {
      const invalid = KnowledgeSelectionRequest(
        placeRefs: <String>[knowledgePlaceForbiddenCity],
        requiredKnowledgeUnitRefs: <String>['ku.invalid.fixture'],
      );
      expect(
        () => forbiddenCityContentPipelineV1.selectKnowledge(invalid),
        throwsArgumentError,
      );
    });

    test('5 factual claim traces KnowledgeUnit to Source completely', () {
      final package = forbiddenCityPipelineFixture;
      expect(package.factTrace, hasLength(4));
      for (final trace in package.factTrace) {
        expect(trace.knowledgeUnitRefs, isNotEmpty);
        expect(trace.sourceRefs, isNotEmpty);
        for (final ref in trace.knowledgeUnitRefs) {
          final unit = forbiddenCityKnowledgeUniverse.knowledgeById[ref];
          expect(unit, isNotNull);
          expect(unit!.status, KnowledgeStatus.verified);
          expect(trace.sourceRefs.toSet().containsAll(unit.sourceRefs), isTrue);
        }
      }
      expect(
        package.validationReport.passed(ContentQualityCheckKind.factTrace),
        isTrue,
      );
    });

    test('6 fictional narrative remains separate from factual claims', () {
      final fictional = forbiddenCityPipelineFixture.storyPlan.narrativeClaims
          .where((claim) => claim.type.name == 'fictionalNarrative')
          .toList(growable: false);
      expect(fictional, isNotEmpty);
      expect(fictional.every((claim) => claim.knowledgeUnitRefs.isEmpty), isTrue);
      final tracedIds = forbiddenCityPipelineFixture.factTrace
          .map((trace) => trace.claimId)
          .toSet();
      expect(fictional.every((claim) => !tracedIds.contains(claim.id)), isTrue);
    });

    test('7 Vocabulary can only come from Story and has valid storySource', () {
      final package = forbiddenCityPipelineFixture;
      final lineById = <String, String>{
        for (final line in package.storyContent.lines) line.id: line.text,
      };
      for (final item in package.vocabulary) {
        expect(package.storyContent.text, contains(item.word));
        expect(lineById[item.storySource], isNotNull);
        expect(lineById[item.storySource], contains(item.word));
        expect(item.pinyin, isNotEmpty);
        expect(item.partOfSpeech, isNotEmpty);
        expect(item.simpleChinese, isNotEmpty);
        expect(item.usage, isNotEmpty);
        expect(item.semanticContrast, isNotEmpty);
      }
    });

    test('8 Discovery factual content is grounded in verified knowledge', () {
      for (final item in forbiddenCityPipelineFixture.discoveries) {
        expect(item.kind, DiscoveryAssertionKind.fact);
        expect(item.knowledgeUnitRefs, isNotEmpty);
        expect(item.sourceRefs, isNotEmpty);
        for (final ref in item.knowledgeUnitRefs) {
          final unit = forbiddenCityKnowledgeUniverse.knowledgeById[ref];
          expect(unit, isNotNull);
          expect(unit!.status, KnowledgeStatus.verified);
          expect(item.sourceRefs.toSet().containsAll(unit.sourceRefs), isTrue);
        }
      }
    });

    test('9 Challenge cannot test untaught knowledge', () {
      final package = forbiddenCityPipelineFixture;
      final taught = package.knowledgeUnitRefs.toSet();
      final teachingIds = <String>{
        ...package.storyContent.lines.map((line) => line.id),
        ...package.vocabulary.map((item) => item.id),
        ...package.discoveries.map((item) => item.id),
      };
      expect(
        package.challenges.map((item) => item.kind).toSet(),
        containsAll(GeneratedChallengeKind.values),
      );
      for (final item in package.challenges) {
        expect(item.teachingSourceRefs, isNotEmpty);
        expect(item.teachingSourceRefs.every(teachingIds.contains), isTrue);
        expect(item.knowledgeUnitRefs.every(taught.contains), isTrue);
      }
    });

    test('10 Memory aligns to Story and learning targets', () {
      final package = forbiddenCityPipelineFixture;
      final teachingIds = <String>{
        ...package.storyContent.lines.map((line) => line.id),
        ...package.vocabulary.map((item) => item.id),
        ...package.discoveries.map((item) => item.id),
      };
      expect(package.memory.items, hasLength(4));
      for (final item in package.memory.items) {
        expect(item.text, isNotEmpty);
        expect(item.teachingSourceRefs, isNotEmpty);
        expect(item.teachingSourceRefs.every(teachingIds.contains), isTrue);
      }
    });

    test('11 same snapshot + seed + pipeline version is deterministic', () {
      final first = buildForbiddenCityPipelineFixture();
      final second = buildForbiddenCityPipelineFixture();
      expect(first.canonicalSignature, second.canonicalSignature);
      expect(first.knowledgeUnitRefs, orderedEquals(<String>[
        kuCentralAxisSequence,
        kuJingyunGateEast,
        kuMeridianGateAxis,
        kuQianqingGateCourts,
      ]));
    });

    test('12 automated result can reach at most VALIDATED', () {
      final report = forbiddenCityPipelineFixture.validationReport;
      expect(report.automatedValidation, isTrue);
      expect(report.overallCandidateStatus, ContentCandidateStatus.validated);
      expect(forbiddenCityPipelineFixture.status, ContentCandidateStatus.validated);
      expect(forbiddenCityPipelineFixture.status, isNot(ContentCandidateStatus.approved));
    });

    test('13 automated validator never returns literary approval', () {
      final report = forbiddenCityPipelineFixture.validationReport;
      expect(report.literaryReview, HumanReviewStatus.pending);
      expect(report.storyDiscoveryFunctionalReview, HumanReviewStatus.pending);
      expect(report.founderContentApproval, HumanReviewStatus.pending);
    });

    test('14 existing Founder PASS Journey remains unchanged', () {
      expect(forbiddenCityStoryParagraphsByLevel, hasLength(10));
      expect(
        forbiddenCityStoryParagraphsByLevel.first.single,
        '十七岁的古建学徒沈砚跟周师傅走进紫禁城。沈砚从午门出发，沿中轴向北走。他要画一张路线图，给新学徒看。他走到乾清门前，觉得这条路线最正确。阿宁从东侧来到乾清门前。她要把记录送回东边，目标和沈砚不同。沈砚说：“你走错了。”阿宁说：“我们一起看。”两人重新看图。两条路线都到乾清门前。沈砚留下两条路线。周师傅问：“为什么？”沈砚说：“同一个地方，可以有不同路线。”',
      );
      expect(forbiddenCityJourney01.title, '两条路，一张图');
    });

    test('15 pipeline infrastructure has no UI dependency', () {
      for (final path in <String>[
        'lib/models/content_pipeline.dart',
        'lib/services/ai_content_pipeline_v1.dart',
        'lib/data/forbidden_city_content_pipeline_fixture.dart',
      ]) {
        final source = File(path).readAsStringSync();
        expect(source, isNot(contains('package:flutter/')));
        expect(source, isNot(contains('/widgets/')));
        expect(source, isNot(contains('/screens/')));
        expect(source, isNot(contains('Widget build(')));
      }
    });

    test('16 applicable canonical standards remain binding and reusable', () {
      final journey = File('../docs/PHOENIX_JOURNEY_SYSTEM_STANDARD.md')
          .readAsStringSync();
      final narrative =
          File('../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md')
              .readAsStringSync();
      final creation = File('../docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md')
          .readAsStringSync();
      final ui = File('../docs/PHOENIX_UI_VISUAL_STANDARD.md').readAsStringSync();
      final governance = File('../docs/FAST_DEVELOPMENT_GOVERNANCE_V2.md')
          .readAsStringSync();

      expect(journey, contains('**Status:** BINDING'));
      expect(journey, contains('| Reflection | REQUIRED |'));
      expect(journey, contains('| Writing | REQUIRED |'));
      expect(journey, contains('| Completion | REQUIRED |'));
      expect(journey, contains('| Reward | REQUIRED |'));
      expect(narrative, contains('**Status:** BINDING'));
      expect(narrative, contains('Automated validation cannot by itself approve:'));
      expect(creation, contains('**Status:** BINDING'));
      expect(creation, contains('reusable infrastructure changes must be separately scoped'));
      expect(ui, contains('**Status:** BINDING'));
      expect(ui, contains('PR `#137`'));
      expect(governance, contains('Preflight -> Analyze once -> Full Flutter once'));
      expect(governance, contains('REAL PRODUCT FAILURE'));
      expect(governance, contains('HARNESS / TEST FAILURE'));
      expect(governance, contains('DEPLOY / INFRA FAILURE'));
    });

    test('automated structural checks are all PASS for fixture', () {
      final report = forbiddenCityPipelineFixture.validationReport;
      expect(report.automatedChecks, isNotEmpty);
      expect(report.automatedChecks.every((check) => check.passed), isTrue);
      expect(
        report.passed(ContentQualityCheckKind.provenanceCompleteness),
        isTrue,
      );
      expect(report.passed(ContentQualityCheckKind.antiAiSlopSignals), isTrue);
      expect(report.passed(ContentQualityCheckKind.duplication), isTrue);
    });
  });
}
