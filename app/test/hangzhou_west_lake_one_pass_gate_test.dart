import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/hangzhou_west_lake_one_pass.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('Hangzhou Story obeys Lv1-Lv10 requested length and paragraph policy', () {
    expect(hangzhouWestLakeOnePassLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final content = hangzhouWestLakeOnePassLevels[level - 1];
      final characters = content.storyParagraphs.join().runes.length;
      final target = phoenixStoryLengthTargetForLevel(level);
      // ignore: avoid_print
      print('HANGZHOU_STORY_METRIC Lv$level characters=$characters paragraphs=${content.storyParagraphs.length}');
      expect(characters, inInclusiveRange(target.acceptedMinimumCharacters, target.acceptedMaximumCharacters), reason: 'Lv$level Story-only accepted range');
      expect(content.storyParagraphs.length, target.paragraphCount, reason: 'Lv$level strict paragraph shape');
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
    }
  });

  test('all levels preserve one canonical Hangzhou soundscape narrative', () {
    for (var level = 1; level <= 10; level++) {
      final story = hangzhouWestLakeOnePassLevels[level - 1].storyParagraphs.join();
      for (final anchor in <String>['许澄', '西湖', '苏堤', '录音', '雨', '在场']) {
        expect(story, contains(anchor), reason: 'Lv$level $anchor');
      }
      expect(story, isNot(contains('清晨，你沿着苏堤慢慢向前走')));
      expect(story, isNot(contains('永宁门')));
      expect(story, isNot(contains('跑表')));
      expect(story, isNot(contains('提单')));
      expect(story, isNot(contains('地图上的空白')));
      expect(story, isNot(contains('没有____，却第一次真正')));
      expect(story, isNot(contains('我原来以为')));
    }
  });

  test('advanced Story carries verified West Lake cultural-landscape anchors', () {
    final advanced = hangzhouWestLakeOnePassLevels[9].storyParagraphs.join();
    expect(advanced, contains('苏堤'));
    expect(advanced, contains('疏浚'));
    expect(advanced, contains('三面山地'));
    expect(advanced, contains('文化景观'));
    expect(advanced, contains('九世纪'));
  });

  test('Words have exact Story trace and truthful first appearance', () {
    final stories = <String>[for (final level in hangzhouWestLakeOnePassLevels) level.storyParagraphs.join()];
    expect(hangzhouWestLakeOnePassWords, hasLength(hangzhouWestLakeWordTraces.length));
    expect(hangzhouWestLakeOnePassWords, hasLength(hangzhouWestLakeWordFirstAppears.length));
    for (final word in hangzhouWestLakeOnePassWords) {
      final trace = hangzhouWestLakeWordTraces.firstWhere((item) => item.word == word.word);
      expect(trace.sourceText, contains(word.word), reason: word.word);
      expect(stories.any((story) => story.contains(trace.sourceText)), isTrue, reason: '${word.word} exact source');
      final first = stories.indexWhere((story) => story.contains(word.word)) + 1;
      expect(first, hangzhouWestLakeWordFirstAppears[word.word], reason: '${word.word} first appears');
      expect(word.pinyin.trim(), isNotEmpty);
      expect(word.partOfSpeech.trim(), isNotEmpty);
      expect(word.simpleChinese.trim(), isNotEmpty);
      expect(word.translation.trim(), isNotEmpty);
      expect(word.englishDefinition.trim(), isNotEmpty);
    }
  });

  test('Discovery is exactly one level-bound card with sources and Story Link', () {
    final sourceIds = hangzhouWestLakeSources.map((source) => source.id).toSet();
    expect(hangzhouWestLakeDiscoverySpecs, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final spec = hangzhouWestLakeDiscoverySpecs[level - 1];
      expect(spec.level, level);
      expect(spec.title.trim(), isNotEmpty);
      expect(spec.storyLink.trim(), isNotEmpty);
      expect(spec.keyTerms, isNotEmpty);
      expect(spec.learnerInsight.trim(), isNotEmpty);
      expect(spec.check.trim(), isNotEmpty);
      expect(spec.answer.trim(), isNotEmpty);
      expect(spec.sourceIds, isNotEmpty);
      expect(spec.sourceIds.every(sourceIds.contains), isTrue);
      final levelContent = hangzhouWestLakeOnePassLevelContent(level);
      expect(levelContent.discoveries, hasLength(1));
      expect(identical(levelContent.discoveries.single, spec.entry), isTrue);
    }
  });

  test('Challenge covers all ten levels with only approved active-story types', () {
    const approved = <String>{'paragraphRebuild', 'grammarRepair', 'missingSentence'};
    expect(hangzhouWestLakeChallenges, hasLength(30));
    for (var level = 1; level <= 10; level++) {
      final story = hangzhouWestLakeOnePassLevels[level - 1].storyParagraphs.join();
      final challenges = hangzhouWestLakeChallenges.where((item) => item.level == level).toList();
      expect(challenges.map((item) => item.type).toSet(), approved);
      for (final challenge in challenges) {
        expect(story.contains(challenge.anchor), isTrue, reason: 'Lv$level ${challenge.type}');
        if (challenge.type == 'missingSentence') {
          expect(challenge.answer, challenge.anchor);
          expect(RegExp(r'[^。！？!?]+[。！？!?]').allMatches(story).map((match) => match.group(0)!).contains(challenge.answer), isTrue, reason: 'Lv$level exact missing sentence');
        }
      }
    }
  });

  test('Memory and Complete stay bound to the rain soundscape journey', () {
    final memory = hangzhouWestLakeMemory.map((item) => item.answer).join();
    for (final anchor in <String>['许澄', '苏堤', '西湖', '录音', '雨', '文化景观', '麦克风', '在场']) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(hangzhouWestLakeCompletion.achievement, '湖雨采声者');
    expect(hangzhouWestLakeCompletion.memoryAnchor, '第一滴雨落进西湖录音里的声音');
    expect(hangzhouWestLakeCompletion.challengeReward, '西湖声纹章');
    expect(hangzhouWestLakeCompletion.journeyCompletion, contains('“在场”'));
  });

  test('Narrative Difference Matrix covers all five approved Gold Journeys', () {
    expect(approvedNarrativeDnaCatalog.map((item) => item.journeyId).toSet(), containsAll(<String>{'beijing-summer-palace', 'beijing-forbidden-city', 'shanghai-bund', 'xian-city-wall', hangzhouWestLakeJourneyId}));
    expect(approvedNarrativeDnaCatalog.every((item) => item.narrativeIdentity.trim().isNotEmpty && item.majorDimensions.every((dimension) => dimension.trim().isNotEmpty)), isTrue);
  });

  test('Hangzhou Narrative DNA differs materially from every approved Gold reference', () {
    final hangzhou = approvedNarrativeDnaCatalog.singleWhere((item) => item.journeyId == hangzhouWestLakeJourneyId);
    final references = approvedNarrativeDnaCatalog.where((item) => item.journeyId != hangzhouWestLakeJourneyId);
    expect(narrativeDnaIsUnique(hangzhou, references), isTrue);
    for (final reference in references) {
      expect(duplicatedMajorDimensions(hangzhou, reference), lessThan(3), reason: reference.journeyId);
    }
  });

  test('anti-template gate rejects a three-dimension Hangzhou copy', () {
    final hangzhou = approvedNarrativeDnaCatalog.singleWhere((item) => item.journeyId == hangzhouWestLakeJourneyId);
    final copy = JourneyNarrativeDnaRecord(
      journeyId: 'hangzhou-copy-probe', narrativeIdentity: 'probe', protagonistIdentity: hangzhou.protagonistIdentity, protagonistAgeIdentity: hangzhou.protagonistAgeIdentity, protagonistArchetype: hangzhou.protagonistArchetype, openingSituation: 'other', storyGoal: 'other', locationMechanism: 'other', movementPattern: 'other', conflictType: 'other', choiceType: 'other', climaxType: 'other', consequenceType: 'other', emotionalArc: 'other', historicalLearningMechanism: 'other', resolutionType: 'other', endingMechanism: 'other', memoryAnchorType: 'other', achievementType: 'other', rewardSymbolism: 'other', temporalPattern: 'other', supportingStructure: 'other', centralMetaphor: 'other', narrativeVoice: 'other', storyRhythm: 'other');
    expect(duplicatedMajorDimensions(copy, hangzhou), greaterThanOrEqualTo(3));
    expect(narrativeDnaIsUnique(copy, <JourneyNarrativeDnaRecord>[hangzhou]), isFalse);
  });

  test('runtime classifies Hangzhou as dedicated Gold and resolves immutable snapshots', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(hangzhouWestLakeJourneyId), isTrue);
    expect(usesSharedGenericAdaptivePipeline(hangzhouWestLakeJourneyId), isFalse);
    final experience = requireDailyJourneyExperience(hangzhouWestLakeJourneyId);
    for (var level = 1; level <= 10; level++) {
      final resolved = resolveAdaptiveJourneyLevel(experience, profile: levelAgent.profileForPhoenixLevel(level));
      expect(identical(resolved.storyParagraphs, hangzhouWestLakeOnePassLevels[level - 1].storyParagraphs), isTrue);
      expect(resolved.storyParagraphs.join(), isNot(contains('清晨，你沿着苏堤慢慢向前走')));
      expect(resolved.discoveries, hasLength(1));
    }
  });

  test('Hangzhou integration preserves approved Shanghai runtime prompts', () {
    final shanghai = requireDailyJourneyExperience('shanghai-bund');
    final resolved = resolveAdaptiveJourneyLevel(shanghai, profile: levelAgent.profileForPhoenixLevel(5));
    expect(resolved.wonderQuestion, '林岸为什么在过江后不再把两岸理解成过去和未来？');
    expect(resolved.expressQuestion, '旧海运提单与陆家嘴结算系统在故事里共同组织了哪些流动？');
  });
}
