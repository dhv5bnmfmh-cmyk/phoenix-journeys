import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/xian_city_wall_one_pass.dart';

void main() {
  const acceptedRanges = <int, (int, int)>{
    1: (200, 280), 2: (250, 340), 3: (300, 390), 4: (350, 460),
    5: (400, 540), 6: (450, 620), 7: (500, 700), 8: (560, 780),
    9: (620, 860), 10: (700, 980),
  };
  const levelAgent = PhoenixLanguageLevelAgent();

  test('Xi\'an Story obeys Lv1-Lv10 requested length and paragraph policy', () {
    expect(xianCityWallOnePassLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final content = xianCityWallOnePassLevels[level - 1];
      final characters = content.storyParagraphs.join().length;
      final range = acceptedRanges[level]!;
      expect(characters, inInclusiveRange(range.$1, range.$2), reason: 'Lv$level length');
      expect(content.storyParagraphs.length, level <= 2 ? 1 : 2, reason: 'Lv$level paragraphs');
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
    }
  });

  test('all levels preserve one canonical Xi\'an narrative DNA', () {
    for (var level = 1; level <= 10; level++) {
      final story = xianCityWallOnePassLevels[level - 1].storyParagraphs.join();
      for (final anchor in <String>['周遥', '搬', '永宁门', '城墙', '跑表', '新家']) {
        expect(story, contains(anchor), reason: 'Lv$level $anchor');
      }
      expect(story, isNot(contains('你从永宁门走上西安城墙')));
      expect(story, isNot(contains('时间边界')));
      expect(story, isNot(contains('沈砚')));
      expect(story, isNot(contains('林岸')));
      expect(story, isNot(contains('提单')));
      expect(story, isNot(contains('门槛')));
      expect(story, isNot(contains('地图上的空白')));
    }
  });

  test('location identity and verified historical anchors are Xi\'an-specific', () {
    final advanced = xianCityWallOnePassLevels[9].storyParagraphs.join();
    expect(advanced, contains('西安城墙'));
    expect(advanced, contains('永宁门'));
    expect(advanced, contains('十三点七四公里'));
    expect(advanced, contains('明洪武七年至十一年'));
    expect(advanced, contains('南墙、西墙'));
    expect(advanced, contains('1961年'));
    expect(advanced, contains('全国重点文物保护单位'));
    expect(advanced, contains('护城河'));
  });

  test('Words have exact Story trace and truthful first appearance', () {
    final stories = <String>[for (final level in xianCityWallOnePassLevels) level.storyParagraphs.join()];
    expect(xianCityWallOnePassWords, hasLength(xianCityWallWordTraces.length));
    expect(xianCityWallOnePassWords, hasLength(xianCityWallWordFirstAppears.length));
    for (final word in xianCityWallOnePassWords) {
      final trace = xianCityWallWordTraces.firstWhere((item) => item.word == word.word);
      expect(trace.sourceText, contains(word.word), reason: word.word);
      expect(stories.any((story) => story.contains(trace.sourceText)), isTrue, reason: '${word.word} exact source');
      final first = stories.indexWhere((story) => story.contains(word.word)) + 1;
      expect(first, xianCityWallWordFirstAppears[word.word], reason: '${word.word} first appears');
      expect(word.pinyin.trim(), isNotEmpty);
      expect(word.partOfSpeech.trim(), isNotEmpty);
      expect(word.simpleChinese.trim(), isNotEmpty);
      expect(word.translation.trim(), isNotEmpty);
      expect(word.englishDefinition.trim(), isNotEmpty);
    }
  });

  test('Discovery is exactly one level-bound card with sources and Story Link', () {
    final sourceIds = xianCityWallSources.map((source) => source.id).toSet();
    expect(xianCityWallDiscoverySpecs, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final spec = xianCityWallDiscoverySpecs[level - 1];
      expect(spec.level, level);
      expect(spec.title.trim(), isNotEmpty);
      expect(spec.storyLink.trim(), isNotEmpty);
      expect(spec.keyTerms, isNotEmpty);
      expect(spec.learnerInsight.trim(), isNotEmpty);
      expect(spec.check.trim(), isNotEmpty);
      expect(spec.answer.trim(), isNotEmpty);
      expect(spec.sourceIds, isNotEmpty);
      expect(spec.sourceIds.every(sourceIds.contains), isTrue);
      final levelContent = xianCityWallOnePassLevelContent(level);
      expect(levelContent.discoveries, hasLength(1));
      expect(identical(levelContent.discoveries.single, spec.entry), isTrue);
    }
  });

  test('Challenge covers all ten levels with only approved active-story types', () {
    const approved = <String>{'paragraphRebuild', 'grammarRepair', 'missingSentence'};
    expect(xianCityWallChallenges, hasLength(30));
    for (var level = 1; level <= 10; level++) {
      final story = xianCityWallOnePassLevels[level - 1].storyParagraphs.join();
      final challenges = xianCityWallChallenges.where((item) => item.level == level).toList();
      expect(challenges.map((item) => item.type).toSet(), approved);
      for (final challenge in challenges) {
        expect(story.contains(challenge.anchor), isTrue, reason: 'Lv$level ${challenge.type}');
        if (challenge.type == 'missingSentence') {
          expect(challenge.answer, challenge.anchor);
          expect(story.contains(challenge.answer), isTrue);
        }
      }
    }
  });

  test('Memory and Complete remain bound to Zhou Yao route and original anchor', () {
    final memory = xianCityWallMemory.map((item) => item.answer).join();
    for (final anchor in <String>['周遥', '永宁门', '母亲', '城墙', '跑表', '新家', '明洪武', '全国重点文物保护单位']) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(xianCityWallCompletion.journeySummary, contains('周遥'));
    expect(xianCityWallCompletion.achievement, '续程跑者');
    expect(xianCityWallCompletion.memoryAnchor, '永宁门后没有按停的跑表');
    expect(xianCityWallCompletion.challengeReward, '长安续程牌');
    expect(xianCityWallCompletion.journeyCompletion, contains('“回家”'));
  });

  test('Narrative DNA differs materially from all approved Gold references', () {
    final xian = approvedNarrativeDnaCatalog.singleWhere((item) => item.journeyId == xianCityWallJourneyId);
    final references = approvedNarrativeDnaCatalog.where((item) => item.journeyId != xianCityWallJourneyId);
    expect(narrativeDnaIsUnique(xian, references), isTrue);
    for (final reference in references) {
      expect(duplicatedMajorDimensions(xian, reference), lessThan(3), reason: reference.journeyId);
    }
  });

  test('runtime resolves Xi\'an only through immutable canonical gold snapshots', () {
    final experience = requireDailyJourneyExperience(xianCityWallJourneyId);
    for (var level = 1; level <= 10; level++) {
      final profile = levelAgent.allProfiles.singleWhere((item) => item.phoenixLevel == level);
      final resolved = resolveAdaptiveJourneyLevel(experience, profile: profile);
      expect(identical(resolved.storyParagraphs, xianCityWallOnePassLevels[level - 1].storyParagraphs), isTrue);
      expect(resolved.storyParagraphs.join(), isNot(contains('傍晚，你从永宁门走上西安城墙')));
      expect(resolved.storyAnnotations.length, resolved.storyParagraphs.length);
      expect(resolved.discoveries, hasLength(1));
    }
  });
}
