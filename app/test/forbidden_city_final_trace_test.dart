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

  List<String> activeStories() {
    final journey = requireDailyJourneyExperience(forbiddenCityJourneyId);
    return <String>[
      for (final profile in levelAgent.allProfiles)
        resolveAdaptiveJourneyLevel(journey, profile: profile)
            .storyParagraphs
            .join('\n\n'),
    ];
  }

  test('Forbidden City Lv1-Lv10 preserve the dual-route causal identity', () {
    final stories = activeStories();
    expect(stories, hasLength(10));
    expect(stories.first, contains('十七岁的营造学徒沈砚'));
    for (var index = 0; index < stories.length; index++) {
      final story = stories[index];
      expect(story, contains('沈砚'), reason: 'Lv${index + 1} protagonist');
      expect(story, contains('阿宁'), reason: 'Lv${index + 1} second protagonist');
      expect(story, contains('路线'), reason: 'Lv${index + 1} route conflict');
      expect(story, contains('乾清门'), reason: 'Lv${index + 1} shared spatial node');
      expect(
        story.contains('中轴') || story.contains('午门'),
        isTrue,
        reason: 'Lv${index + 1} Forbidden City spatial causality',
      );
      expect(
        story.contains('两条') || story.contains('两人'),
        isTrue,
        reason: 'Lv${index + 1} must compare both perspectives',
      );
    }

    for (var level = 1; level <= 3; level++) {
      final story = stories[level - 1];
      expect(story, anyOf(contains('任务'), contains('目标')),
          reason: 'Lv$level concrete task/goal');
      expect(story, contains('乾清门'), reason: 'Lv$level visible route');
    }
    for (var level = 4; level <= 6; level++) {
      final story = stories[level - 1];
      expect(story, anyOf(contains('连接'), contains('任务')),
          reason: 'Lv$level causality/task fit');
      expect(story, anyOf(contains('外朝'), contains('院落')),
          reason: 'Lv$level architecture constraint');
    }
    for (var level = 7; level <= 8; level++) {
      final story = stories[level - 1];
      expect(story, contains('证据'), reason: 'Lv$level evidence');
      expect(story, contains('视角'), reason: 'Lv$level perspective');
    }
    for (var level = 9; level <= 10; level++) {
      final story = stories[level - 1];
      expect(story, contains('空间骨架'), reason: 'Lv$level synthesis');
      expect(story, anyOf(contains('条件'), contains('后果')),
          reason: 'Lv$level transfer/justification');
    }

    expect(forbiddenCityStoryParagraphsByLevel[0], hasLength(1));
    expect(forbiddenCityStoryParagraphsByLevel[1], hasLength(1));
    for (var index = 2; index < 10; index++) {
      expect(forbiddenCityStoryParagraphsByLevel[index], hasLength(2));
    }
  });

  test('obsolete refusal blank and ruler machinery is absent from active Story', () {
    final corpus = activeStories().join('\n');
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

  test('Lv10 synthesis and transfer remain explicit narrative action', () {
    final high = activeStories()[9];
    expect(high, contains('阿宁'));
    expect(high, contains('周师傅'));
    expect(high, contains('建筑连接'));
    expect(high, contains('人物目标'));
    expect(high, contains('行动后果'));
    expect(high, contains('共同空间骨架'));
    expect(high, contains('成立条件'));
    expect(high, contains('共同署名'));
    expect(high, contains('一条常用路线，并不等于唯一正确的路线'));
    expect(high, isNot(contains('谁对谁错')),
        reason: 'Lv10 resolves by evidence and conditions, not a winner declaration');
  });

  test('every Forbidden City Word has exact remediated Story trace metadata', () {
    activeStories();
    expect(validateForbiddenCityImportedWords(), isEmpty);
    for (final record in forbiddenCityValidatedWordRecords) {
      expect(record.entry.word.trim(), isNotEmpty);
      expect(record.entry.pinyin.trim(), isNotEmpty, reason: record.entry.word);
      expect(record.entry.partOfSpeech.trim(), isNotEmpty, reason: record.entry.word);
      expect(record.entry.translation.trim(), isNotEmpty, reason: record.entry.word);
      expect(record.entry.englishDefinition.trim(), isNotEmpty, reason: record.entry.word);
      expect(record.storySource, contains(record.entry.word), reason: record.entry.word);
      expect(
        forbiddenCityLockedStories.any((story) => story.contains(record.storySource)),
        isTrue,
        reason: '${record.entry.word} must cite an exact verbatim span from active Story',
      );
      final earliest = forbiddenCityLockedStories.indexWhere(
            (story) => story.contains(record.entry.word),
          ) +
          1;
      expect(record.firstAppearsAt, earliest, reason: record.entry.word);
    }
  });

  test('Forbidden City vocabulary remains inside global Lv1-Lv10 ceilings', () {
    activeStories();
    for (var level = 1; level <= 10; level++) {
      final words = forbiddenCityWordsForLevel(level);
      expect(words.length, lessThanOrEqualTo(ceilings[level - 1]), reason: 'Lv$level');
      final story = forbiddenCityLockedStories[level - 1];
      expect(words.every((entry) => story.contains(entry.word)), isTrue,
          reason: 'Lv$level words must come from active Story');
    }
  });

  test('all three Challenge types trace to matching remediated Story levels', () {
    activeStories();
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

  test('Discovery teaches architecture and task-route reasoning without legacy plot machinery', () {
    final discoveryCorpus = <String>[
      ...forbiddenCityDiscoveries.map((item) => item.text),
      ...forbiddenCityDiscoveryFocusByLevel.map((item) => item.text),
    ].join('\n');
    expect(discoveryCorpus, contains('午门是紫禁城正门'));
    expect(discoveryCorpus, contains('南北轴线'));
    expect(discoveryCorpus, contains('外朝'));
    expect(discoveryCorpus, contains('内廷'));
    expect(discoveryCorpus, contains('乾清门'));
    expect(discoveryCorpus, contains('景运门'));
    expect(discoveryCorpus, contains('功能分区'));
    expect(discoveryCorpus, contains('空间连接'));
    expect(discoveryCorpus, contains('任务'));
    expect(discoveryCorpus, isNot(contains('旧木尺')));
    expect(discoveryCorpus, isNot(contains('地图空白')));
    expect(discoveryCorpus, isNot(contains('没有跨过')));
  });

  test('Memory Completion and reward identity preserve the current dual-route anchor', () {
    final memory = forbiddenCityMemoryReviews
        .map((item) => '${item.prompt}${item.answer}')
        .join('\n');
    for (final anchor in <String>[
      '沈砚',
      '阿宁',
      '乾清门',
      '两条都能走通的路线',
    ]) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(forbiddenCityMemoryAnchor, '两条都能走通的路线');
    expect(forbiddenCityChallengeRewardName, contains('空间证据'));
    expect(forbiddenCityJourneyCompletion, contains('两条写明条件的路线'));
    expect(forbiddenCityJourneyCompletion, contains('中轴'));
    expect(forbiddenCityJourneyCompletion, isNot(contains('旧木尺')));
    expect(forbiddenCityJourneyCompletion, isNot(contains('没有跨过')));
  });

  test('Narrative DNA and semantic mechanism match the current pending-review Story', () {
    final stories = activeStories();
    final active = stories.join('\n');
    final dna = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == forbiddenCityJourneyId,
    );
    final fingerprint = approvedGoldSemanticFingerprints[forbiddenCityJourneyId]!;
    expect(dna.protagonistIdentity, contains('seventeen-year-old'));
    expect(dna.protagonistArchetype, contains('construction-apprentice'));
    expect(dna.narrativeIdentity, contains('dual-valid-route'));
    expect(
      fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
      NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel,
    );
    expect(active, contains('十七岁的营造学徒沈砚'));
    expect(active, contains('阿宁'));
    expect(active, contains('景运门').or(contains('东侧')));
    expect(active, contains('建筑连接'));
    expect(active, contains('人物目标'));
    expect(active, contains('行动后果'));
    expect(active, isNot(contains('旧木尺')));
    expect(
      semanticDifferenceMatrixAgainstApprovedGold(fingerprint)
          .where((comparison) => comparison.isCollision),
      isEmpty,
      reason: 'Pending Founder review must still pass the semantic anti-template comparison.',
    );
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
