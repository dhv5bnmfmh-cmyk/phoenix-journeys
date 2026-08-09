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

List<String> _sentences(String story) => RegExp(r'[^。！？!?]+[。！？!?]')
    .allMatches(story)
    .map((match) => match.group(0)!.trim())
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

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
      expect(story, anyOf(contains('同一张'), contains('叠'), contains('保留')),
          reason: 'Lv${index + 1} must enact synthesis');
      expect(story, anyOf(contains('分开'), contains('分向'), contains('分岔')),
          reason: 'Lv${index + 1} must preserve purposeful divergence');
    }
    expect(forbiddenCityStoryParagraphsByLevel[0], hasLength(1));
    expect(forbiddenCityStoryParagraphsByLevel[1], hasLength(1));
    for (var index = 2; index < 10; index++) {
      expect(forbiddenCityStoryParagraphsByLevel[index], hasLength(2));
    }
  });

  test('obsolete refusal blank and ruler machinery is absent from active Story', () {
    final corpus = forbiddenCityLockedStories.join('\n');
    for (final obsolete in <String>[
      '没有跨过门槛',
      '没有跨过去',
      '地图仍留下空白',
      '地图仍不完整',
      '写下“界”',
      '旧木尺',
      '那道没有跨过的门槛',
    ]) {
      expect(corpus, isNot(contains(obsolete)), reason: obsolete);
    }
  });

  test('new secondary participant and synthesis climax are explicit', () {
    final high = forbiddenCityLockedStories[9];
    expect(high, contains('年幼侍役阿宁'));
    expect(high, contains('不是官方历史路线'));
    expect(high, contains('沈砚没有把问题解决成谁对谁错'));
    expect(high, contains('沈砚于是选择合成，而不是裁决'));
    expect(high, contains('路线在乾清门前短暂重合'));
    expect(high, contains('又因角色和目的不同向不同方向延伸'));
    expect(high, contains('一张叠着两条路线的图留在纸上'));
  });

  test('every Forbidden City Word has exact remediated Story trace metadata', () {
    expect(validateForbiddenCityImportedWords(), isEmpty);
    final sentenceSets = <Set<String>>[
      for (final story in forbiddenCityLockedStories) _sentences(story).toSet(),
    ];
    for (final record in forbiddenCityValidatedWordRecords) {
      expect(record.entry.word.trim(), isNotEmpty);
      expect(record.entry.pinyin.trim(), isNotEmpty, reason: record.entry.word);
      expect(record.entry.partOfSpeech.trim(), isNotEmpty, reason: record.entry.word);
      expect(record.entry.translation.trim(), isNotEmpty, reason: record.entry.word);
      expect(record.entry.englishDefinition.trim(), isNotEmpty, reason: record.entry.word);
      expect(record.storySource, contains(record.entry.word), reason: record.entry.word);
      expect(sentenceSets.any((sentences) => sentences.contains(record.storySource)), isTrue,
          reason: '${record.entry.word} must cite a complete verbatim Story sentence');
      final earliest = forbiddenCityLockedStories.indexWhere(
            (story) => story.contains(record.entry.word),
          ) +
          1;
      expect(record.firstAppearsAt, earliest, reason: record.entry.word);
    }
  });

  test('Forbidden City vocabulary remains inside global Lv1-Lv10 ceilings', () {
    for (var level = 1; level <= 10; level++) {
      final words = forbiddenCityWordsForLevel(level);
      expect(words.length, lessThanOrEqualTo(ceilings[level - 1]), reason: 'Lv$level');
      final story = forbiddenCityLockedStories[level - 1];
      expect(words.every((entry) => story.contains(entry.word)), isTrue,
          reason: 'Lv$level words must come from active Story');
    }
  });

  test('all three Challenge types trace to matching remediated Story levels', () {
    for (var level = 1; level <= 10; level++) {
      final story = forbiddenCityLockedStories[level - 1];
      final sentences = _sentences(story).toSet();
      final rebuild = forbiddenCityParagraphRebuild.singleWhere((item) => item.level == level);
      final grammar = forbiddenCityGrammarRepair.singleWhere((item) => item.level == level);
      final missing = forbiddenCityMissingSentence.singleWhere((item) => item.level == level);
      expect(rebuild.segments.every(story.contains), isTrue,
          reason: 'Lv$level paragraphRebuild');
      expect(story.contains(grammar.correct), isTrue,
          reason: 'Lv$level grammarRepair');
      expect(story.contains(missing.before), isTrue,
          reason: 'Lv$level missing before');
      expect(story.contains(missing.after), isTrue,
          reason: 'Lv$level missing after');
      expect(sentences.contains(missing.answer), isTrue,
          reason: 'Lv$level missing answer must be literal Story sentence');
      final challengeCorpus =
          '${rebuild.segments.join()}${grammar.correct}${missing.before}${missing.answer}${missing.after}';
      expect(challengeCorpus, isNot(contains('旧木尺')));
      expect(challengeCorpus, isNot(contains('没有跨过')));
    }
  });

  test('Discovery teaches architecture without replaying obsolete plot machinery', () {
    final discoveryCorpus = forbiddenCityDiscoveries.map((item) => item.text).join('\n');
    expect(discoveryCorpus, contains('午门是紫禁城的正门'));
    expect(discoveryCorpus, contains('南北轴线'));
    expect(discoveryCorpus, contains('外朝'));
    expect(discoveryCorpus, contains('内廷'));
    expect(discoveryCorpus, contains('乾清门'));
    expect(discoveryCorpus, contains('多种推荐参观路线'));
    expect(discoveryCorpus, contains('不是历史官方'));
    expect(discoveryCorpus, isNot(contains('旧木尺')));
    expect(discoveryCorpus, isNot(contains('地图空白')));
    expect(discoveryCorpus, isNot(contains('没有跨过')));
  });

  test('Memory Completion and reward identity point to dual-route synthesis', () {
    final memory = forbiddenCityMemoryReviews
        .map((item) => '${item.prompt}${item.answer}')
        .join('\n');
    for (final anchor in <String>[
      '沈砚',
      '阿宁',
      '两条路线',
      '乾清门',
      '共同',
      '分岔',
      forbiddenCityMemoryAnchor,
    ]) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(forbiddenCityMemoryAnchor, '一张叠着两条路线的图');
    expect(forbiddenCityChallengeRewardName, contains('双线节点'));
    expect(forbiddenCityJourneyCompletion, contains('两条路线'));
    expect(forbiddenCityJourneyCompletion, contains('共享节点'));
    expect(forbiddenCityJourneyCompletion, isNot(contains('旧木尺')));
    expect(forbiddenCityJourneyCompletion, isNot(contains('没有跨过')));
  });

  test('Narrative DNA and semantic fingerprint are derived from active Story', () {
    final dna = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == forbiddenCityJourneyId,
    );
    final fingerprint = approvedGoldSemanticFingerprints[forbiddenCityJourneyId]!;
    expect(dna.narrativeIdentity, contains('dual-valid-route-overlay'));
    expect(dna.memoryAnchorType, contains('two-overlaid-routes'));
    expect(
      fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
      NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel,
    );
    expect(semanticEvidenceContractErrors(fingerprint), isEmpty);
  });

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
