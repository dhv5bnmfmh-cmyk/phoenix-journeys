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

bool _containsSemanticEvidence(String story, List<String> evidence) =>
    evidence.any(story.contains);

({bool shenPerspective, bool aNingPerspective, bool divergence, bool synthesis})
    _dualRouteSemanticAxes(String story) {
  final shenPerspective = story.contains('沈砚') &&
      _containsSemanticEvidence(story, const <String>[
        '这条常用的学习路线',
        '这条常用路线',
        '自己的学习路线',
        '自己的路线',
        '中轴观察',
        '最容易组织的路线',
        '沈砚路线',
        '观察路线',
        '路线偏好',
        '自己的学习路线设为默认答案',
        '自己的图',
      ]);

  final aNingPerspective = story.contains('阿宁') &&
      _containsSemanticEvidence(story, const <String>[
        '阿宁却从东侧',
        '阿宁从东侧',
        '阿宁的任务不同',
        '她的任务',
        '她负责',
        '阿宁从东侧空间',
        '阿宁从东侧抵达',
        '她的路线',
        '她自己的路线',
        '东边记录点',
      ]);

  final divergence = _containsSemanticEvidence(story, const <String>[
    '目标和沈砚不同',
    '服务不同任务',
    '目标不同',
    '任务与东边的记录点相连',
    '围绕自己的任务',
    '阿宁的任务不同',
    '另一个目标',
    '不同任务与视角',
    '真正不同的是人物的目标',
    '任务差异',
    '不同任务塑造',
    '适合一种任务',
    '不同优先次序',
    '路线偏好来自学习任务',
  ]);

  final synthesis = _containsSemanticEvidence(story, const <String>[
    '把两条路线都留下',
    '把阿宁的线保留下来',
    '同时画进一张图',
    '不再用一条线覆盖另一条',
    '把两条路线都保留',
    '不再把阿宁的路线降成次要旁线',
    '共同解释同一座宫城',
    '标出共同节点、不同目标和各自路线',
    '两条线之间的连接说明',
    '多层表示',
    '保留差异而变得更完整',
    '两层路线仍然分开',
    '保留两条路线并写下各自成立的条件',
    '共同署名',
  ]);

  return (
    shenPerspective: shenPerspective,
    aNingPerspective: aNingPerspective,
    divergence: divergence,
    synthesis: synthesis,
  );
}

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  const qualityAgent = PhoenixJourneyContentQualityAgent();
  const ceilings = <int>[5, 6, 7, 8, 9, 10, 11, 13, 14, 15];

  test('Forbidden City Lv1-Lv10 preserve the dual-route causal identity', () {
    expect(forbiddenCityLockedStories, hasLength(10));

    final dna = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == forbiddenCityJourneyId,
    );
    expect(dna.narrativeIdentity, contains('dual-valid-route-overlay'));
    expect(
      dna.conflictType,
      contains('coexisting-role-and-purpose-dependent-routes'),
    );
    expect(dna.choiceType, contains('preserve-both-valid-routes'));
    expect(dna.resolutionType, contains('two-task-dependent-routes'));

    final fingerprint =
        approvedGoldSemanticFingerprints[forbiddenCityJourneyId]!;
    expect(
      fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
      NarrativeMechanismFamily
          .coexistingValidPerspectivesSynthesizeRelationalModel,
    );
    expect(semanticEvidenceContractErrors(fingerprint), isEmpty);

    for (var index = 0; index < forbiddenCityLockedStories.length; index++) {
      final story = forbiddenCityLockedStories[index];
      final axes = _dualRouteSemanticAxes(story);
      expect(
        axes.shenPerspective,
        isTrue,
        reason: 'Lv${index + 1} A: Shen Yan keeps his own spatial perspective',
      );
      expect(
        axes.aNingPerspective,
        isTrue,
        reason: 'Lv${index + 1} B: A Ning keeps an independent perspective',
      );
      expect(
        axes.divergence,
        isTrue,
        reason: 'Lv${index + 1} C: the two perspectives genuinely diverge',
      );
      expect(
        axes.synthesis,
        isTrue,
        reason: 'Lv${index + 1} D: the ending preserves and synthesizes both',
      );
      expect(story, contains('乾清门'), reason: 'Lv${index + 1}');
      for (final obsolete in _legacyStoryTokens) {
        expect(
          story,
          isNot(contains(obsolete)),
          reason: 'Lv${index + 1}: $obsolete',
        );
      }
    }

    const missingANingPerspective =
        '沈砚沿中轴记录自己的路线。阿宁跟着沈砚走同样的路，任务、目标和判断都完全相同，最后只保留沈砚的记录。';
    final missingANingAxes = _dualRouteSemanticAxes(missingANingPerspective);
    expect(missingANingAxes.shenPerspective, isTrue);
    expect(missingANingAxes.aNingPerspective, isFalse);

    const missingSynthesis =
        '沈砚把这条常用路线画在图上。阿宁从东侧抵达，她的任务不同，也坚持自己的移动方式。两人的目标不同，最后沈砚删掉阿宁的记录，只留下自己的路线。';
    final missingSynthesisAxes = _dualRouteSemanticAxes(missingSynthesis);
    expect(missingSynthesisAxes.shenPerspective, isTrue);
    expect(missingSynthesisAxes.aNingPerspective, isTrue);
    expect(missingSynthesisAxes.divergence, isTrue);
    expect(missingSynthesisAxes.synthesis, isFalse);
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
    expect(corpus, contains('午门是紫禁城正门'));
    expect(corpus, contains('南北轴线'));
    expect(corpus, contains('外朝'));
    expect(corpus, contains('内廷'));
    expect(corpus, contains('乾清门'));
    expect(corpus, contains('景运门'));
    expect(corpus, contains('路线必须服从这些真实空间条件'));
    expect(corpus, isNot(contains('不是历史官方')));
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
