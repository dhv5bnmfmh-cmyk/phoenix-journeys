import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_journey_content_quality_agent.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_challenge_package.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_trace_validation.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';

const _legacyStoryTokens = <String>[
  '没有跨过门槛',
  '没有跨过去',
  '地图仍留下空白',
  '地图仍不完整',
  '写下“界”',
  '旧木尺',
  '那道没有跨过的门槛',
  '规定路线',
  '不该跨',
];

bool _enactsRouteSynthesis(String story) =>
    <String>['同一张', '叠', '保留', '同时进入一张图', '复合表示', '同处一页'].any(story.contains);

bool _preservesPurposefulRouteDivergence(String story) =>
    <String>['分开', '分向', '分岔', '转向别处', '转向各自的方向'].any(story.contains);

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  const qualityAgent = PhoenixJourneyContentQualityAgent();
  const ceilings = <int>[5, 6, 7, 8, 9, 10, 11, 13, 14, 15];

  test('Forbidden City Lv1-Lv10 preserve the dual-route causal identity', () {
    expect(forbiddenCityLockedStories, hasLength(10));
    for (var index = 0; index < forbiddenCityLockedStories.length; index++) {
      final story = forbiddenCityLockedStories[index];
      expect(story, contains('十七岁的营造学徒沈砚'), reason: 'Lv${index + 1}');
      expect(story, contains('阿宁'), reason: 'Lv${index + 1}');
      expect(story, contains('两条'), reason: 'Lv${index + 1}');
      expect(story, contains('乾清门'), reason: 'Lv${index + 1}');
      expect(_enactsRouteSynthesis(story), isTrue, reason: 'Lv${index + 1}');
      expect(
        _preservesPurposefulRouteDivergence(story),
        isTrue,
        reason: 'Lv${index + 1}',
      );
      for (final obsolete in _legacyStoryTokens) {
        expect(
          story,
          isNot(contains(obsolete)),
          reason: 'Lv${index + 1}: $obsolete',
        );
      }
    }
  });

  test('every Forbidden City Word has exact earliest Story trace metadata', () {
    expect(validateForbiddenCityWordTrace(), isEmpty);
    expect(validateForbiddenCityImportedWords(), isEmpty);
    for (final record in forbiddenCityValidatedWordRecords) {
      expect(record.entry.word.trim(), isNotEmpty);
      expect(record.entry.pinyin.trim(), isNotEmpty, reason: record.entry.word);
      expect(
        record.entry.partOfSpeech.trim(),
        isNotEmpty,
        reason: record.entry.word,
      );
      expect(
        record.entry.translation.trim(),
        isNotEmpty,
        reason: record.entry.word,
      );
      expect(
        record.entry.englishDefinition.trim(),
        isNotEmpty,
        reason: record.entry.word,
      );
      final earliest = forbiddenCityLockedStories.indexWhere(
            (story) => story.contains(record.entry.word),
          ) +
          1;
      expect(earliest, greaterThan(0), reason: record.entry.word);
      expect(record.firstAppearsAt, earliest, reason: record.entry.word);
      expect(
        record.storySource,
        contains(record.entry.word),
        reason: record.entry.word,
      );
      expect(
        forbiddenCityLockedStories[earliest - 1],
        contains(record.storySource),
        reason: '${record.entry.word} exact source',
      );
    }
  });

  test('Forbidden City vocabulary remains inside global Lv1-Lv10 ceilings', () {
    for (var level = 1; level <= 10; level++) {
      final words = forbiddenCityWordsForLevel(level);
      final story = forbiddenCityLockedStories[level - 1];
      expect(
        words.length,
        lessThanOrEqualTo(ceilings[level - 1]),
        reason: 'Lv$level',
      );
      expect(
        words.every((entry) => story.contains(entry.word)),
        isTrue,
        reason: 'Lv$level words must come from active Story',
      );
    }
  });

  test(
    'Challenge package expresses comprehension evidence and transfer cognition',
    () {
      for (var level = 1; level <= 10; level++) {
        final story = forbiddenCityLockedStories[level - 1];
        final comprehension = forbiddenCityParagraphRebuild.singleWhere(
          (item) => item.level == level,
        );
        final evidence = forbiddenCityGrammarRepair.singleWhere(
          (item) => item.level == level,
        );
        final transfer = forbiddenCityMissingSentence.singleWhere(
          (item) => item.level == level,
        );

        expect(
          comprehension.cognitiveTarget,
          startsWith('Story comprehension'),
        );
        expect(comprehension.segments.every(story.contains), isTrue);
        expect(evidence.evidenceQuestion.trim(), isNotEmpty);
        expect(evidence.evidenceAnswer.trim(), isNotEmpty);
        expect(evidence.evidenceAnswer, isNot(equals(evidence.broken)));
        expect(transfer.transferOptions, hasLength(4));
        expect(transfer.transferOptions, contains(transfer.transferAnswer));
        expect(story, isNot(contains(transfer.transferQuestion)));
        expect(story, isNot(contains(transfer.transferAnswer)));
        expect(transfer.transferQuestion, isNot(equals(transfer.answer)));
      }
    },
  );

  test(
      'Discovery stays grounded in Forbidden City architecture and route reasoning',
      () {
    final corpus = forbiddenCityDiscoveries.map((item) => item.text).join('\n');
    expect(corpus, contains('午门是紫禁城的正门'));
    expect(corpus, contains('南北轴线'));
    expect(corpus, contains('外朝'));
    expect(corpus, contains('内廷'));
    expect(corpus, contains('乾清门'));
    expect(corpus, contains('多种推荐参观路线'));
    expect(corpus, contains('不是历史官方'));
    for (final obsolete in _legacyStoryTokens) {
      expect(corpus, isNot(contains(obsolete)), reason: obsolete);
    }
  });

  test('Memory and Completion are level-bound and share the same Journey core',
      () {
    final memoryPayloads = <String>{};
    final completionPayloads = <String>{};
    for (var level = 1; level <= 10; level++) {
      final memory = forbiddenCityMemoryForLevel(level);
      final completion = forbiddenCityCompletionForLevel(level);
      memoryPayloads.add(
        '${memory.recall}|${memory.characterShift}|${memory.anchor}|${memory.takeaway}',
      );
      completionPayloads.add(
        '${completion.storyClosure}|${completion.discovery}|${completion.learning}|'
        '${completion.memory}|${completion.relationship}|'
        '${completion.emotionalClosure}|${completion.unlockResult}',
      );
      expect(memory.anchor.trim(), isNotEmpty, reason: 'Lv$level');
      expect(completion.unlockResult, contains('Lv$level'));
    }
    expect(memoryPayloads, hasLength(10));
    expect(completionPayloads, hasLength(10));
    expect(
      forbiddenCityMemoryForLevel(1).anchor,
      isNot(equals(forbiddenCityMemoryForLevel(10).anchor)),
    );
    expect(
      forbiddenCityCompletionForLevel(1).storyClosure,
      isNot(equals(forbiddenCityCompletionForLevel(10).storyClosure)),
    );
  });

  test(
    'Narrative DNA and semantic fingerprint remain derived from active Story',
    () {
      final dna = approvedNarrativeDnaCatalog.singleWhere(
        (item) => item.journeyId == forbiddenCityJourneyId,
      );
      final fingerprint =
          approvedGoldSemanticFingerprints[forbiddenCityJourneyId]!;
      expect(dna.narrativeIdentity, contains('dual-valid-route-overlay'));
      expect(dna.memoryAnchorType, contains('two-overlaid-routes'));
      expect(
        fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
        NarrativeMechanismFamily
            .coexistingValidPerspectivesSynthesizeRelationalModel,
      );
      expect(semanticEvidenceContractErrors(fingerprint), isEmpty);
    },
  );

  test('Forbidden City uses the unified quality agent at every level', () {
    final journey = requireDailyJourneyExperience(forbiddenCityJourneyId);
    for (final profile in levelAgent.allProfiles) {
      final content = resolveAdaptiveJourneyLevel(journey, profile: profile);
      final decision = qualityAgent.inspect(
        experience: journey,
        content: content,
        profile: profile,
      );
      expect(decision.isPublishable, isTrue, reason: profile.displayLabel);
    }
  });
}
