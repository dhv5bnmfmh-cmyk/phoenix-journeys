import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_journey_content_quality_agent.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_challenge_package.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_trace_validation.dart';

List<String> _sentences(String story) => RegExp(r'[^。！？!?]+[。！？!?]')
    .allMatches(story)
    .map((match) => match.group(0)!.trim())
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();
  const qualityAgent = PhoenixJourneyContentQualityAgent();

  test('Forbidden City Lv9 is locked at the normal Phoenix shape', () {
    final story = forbiddenCityLockedStories[8];
    expect(forbiddenCityStoryParagraphsByLevel[8], hasLength(2));
    expect(story.runes.length, 626);
    expect(story, contains('这种分辨也让沈砚明白，理解空间首先要承认自己所处的位置。'));
    expect(story, contains('于是他没有跨过去。'));
    expect(story, endsWith('那天，沈砚没有走遍紫禁城。他却第一次真正看见了紫禁城。'));
  });

  test('every Forbidden City Word has exact final Story trace metadata', () {
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
      expect(
        sentenceSets.any((sentences) => sentences.contains(record.storySource)),
        isTrue,
        reason: '${record.entry.word} must cite a complete verbatim Story sentence',
      );
      final earliest = forbiddenCityLockedStories.indexWhere(
            (story) => story.contains(record.entry.word),
          ) +
          1;
      expect(record.firstAppearsAt, earliest, reason: record.entry.word);
    }
  });

  test('all three Challenge types trace to the matching final Story level', () {
    for (var level = 1; level <= 10; level += 1) {
      final story = forbiddenCityLockedStories[level - 1];
      final sentences = _sentences(story).toSet();
      final rebuild = forbiddenCityParagraphRebuild.singleWhere((item) => item.level == level);
      final grammar = forbiddenCityGrammarRepair.singleWhere((item) => item.level == level);
      final missing = forbiddenCityMissingSentence.singleWhere((item) => item.level == level);

      expect(rebuild.segments.every(story.contains), isTrue, reason: 'Lv$level paragraphRebuild');
      expect(story.contains(grammar.correct), isTrue, reason: 'Lv$level grammarRepair');
      expect(story.contains(missing.before), isTrue, reason: 'Lv$level missing before');
      expect(story.contains(missing.after), isTrue, reason: 'Lv$level missing after');
      expect(sentences.contains(missing.answer), isTrue, reason: 'Lv$level missing answer must be a literal Story sentence');
    }
  });

  test('Discovery, Memory and Complete remain bound to Forbidden City identity', () {
    final storyCorpus = forbiddenCityLockedStories.join();
    const anchors = <String>['中轴', '外朝', '内廷', '宫门', '身份', '空白', '第二张地图'];
    for (final discovery in forbiddenCityDiscoveries) {
      expect(discovery.pinyin.trim(), isNotEmpty);
      expect(discovery.vietnamese.trim(), isNotEmpty);
      expect(discovery.english.trim(), isNotEmpty);
      expect(
        anchors.any((anchor) => discovery.text.contains(anchor) && storyCorpus.contains(anchor)),
        isTrue,
        reason: discovery.text,
      );
    }

    final memory = forbiddenCityMemoryReviews
        .map((item) => '${item.prompt}${item.answer}')
        .join();
    for (final anchor in <String>[
      '沈砚', '周师傅', '顾文澜', '年幼侍役', '午门', '外朝', '内廷', '乾清门',
      '门槛', '界', '第二张地图', '旧木尺', forbiddenCityMemoryAnchor,
    ]) {
      expect(memory, contains(anchor), reason: 'Memory must preserve $anchor');
    }

    expect(forbiddenCityChallengeRewardName, contains('旧木尺'));
    expect(forbiddenCityJourneyCompletion, contains('没有跨过的门槛'));
    expect(forbiddenCityJourneyCompletion, contains('沈砚没有走遍紫禁城'));
    expect(forbiddenCityJourneyCompletion, contains('第一次真正看见了紫禁城'));
  });

  test('Forbidden City uses the same unified quality agent as published journeys', () {
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
