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
    expect(hangzhouWestLakeReopenedLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final content = hangzhouWestLakeReopenedLevels[level - 1];
      final characters = content.storyParagraphs.join().runes.length;
      final target = phoenixStoryLengthTargetForLevel(level);
      expect(
        characters,
        inInclusiveRange(
          target.acceptedMinimumCharacters,
          target.acceptedMaximumCharacters,
        ),
        reason: 'Lv$level Story-only accepted range ($characters)',
      );
      expect(content.storyParagraphs.length, target.paragraphCount);
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
    }
  });

  test('all levels preserve one canonical Hangzhou soundscape narrative', () {
    for (var level = 1; level <= 10; level++) {
      final story = hangzhouWestLakeReopenedLevels[level - 1].storyParagraphs.join();
      for (final anchor in <String>['方毓', '周绍庭', '断桥', '预约卡', '手肘', '医院']) {
        expect(story, contains(anchor), reason: 'Lv$level $anchor');
      }
      for (final stale in <String>['许澄', '录音', '项目', '归档', '在场']) {
        expect(story, isNot(contains(stale)), reason: 'Lv$level stale $stale');
      }
    }
  });

  test('Words have exact Story trace and truthful first appearance', () {
    final stories = hangzhouWestLakeReopenedLevels
        .map((level) => level.storyParagraphs.join())
        .toList(growable: false);
    expect(hangzhouWestLakeReopenedWords, hasLength(hangzhouWestLakeReopenedWordTraces.length));
    for (final word in hangzhouWestLakeReopenedWords) {
      final trace = hangzhouWestLakeReopenedWordTraces.singleWhere((item) => item.word == word.word);
      expect(trace.sourceText, contains(word.word), reason: word.word);
      expect(stories.any((story) => story.contains(trace.sourceText)), isTrue, reason: '${word.word} exact source');
    }
  });

  test('Discovery is exactly one level-bound card with sources and Story Link', () {
    final sourceIds = hangzhouWestLakeSources.map((source) => source.id).toSet();
    expect(hangzhouWestLakeReopenedDiscoverySpecs, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final spec = hangzhouWestLakeReopenedDiscoverySpecs[level - 1];
      expect(spec.level, level);
      expect(spec.sourceIds, isNotEmpty);
      expect(spec.sourceIds.every(sourceIds.contains), isTrue);
      final knowledge = '${spec.entry.text}${spec.entry.simpleChinese}';
      expect(knowledge, isNot(contains('方毓')));
      expect(knowledge, isNot(contains('周绍庭')));
      expect(knowledge, isNot(contains('预约卡')));
      final runtime = hangzhouWestLakeOnePassLevelContent(level);
      expect(runtime.discoveries.single, same(spec.entry));
    }
  });

  test('Challenge covers all ten levels with only approved active-story types', () {
    const approved = <String>{'paragraphRebuild', 'grammarRepair', 'missingSentence'};
    expect(hangzhouWestLakeReopenedRemediation.challenges, hasLength(30));
    for (var level = 1; level <= 10; level++) {
      final story = hangzhouWestLakeReopenedLevels[level - 1].storyParagraphs.join();
      final challenges = hangzhouWestLakeReopenedRemediation.challenges.skip((level - 1) * 3).take(3);
      expect(challenges.map((item) => item.type).toSet(), approved);
      for (final challenge in challenges) {
        expect(story, contains(challenge.anchor), reason: 'Lv$level ${challenge.type}');
        expect(challenge.anchor, isNot(contains('录音')));
      }
    }
  });

  test('Memory and Complete stay bound to the rain soundscape journey', () {
    final memory = hangzhouWestLakeReopenedMemory.map((item) => '${item.prompt}${item.answer}').join();
    for (final anchor in <String>['方毓', '周绍庭', '预约卡', '手肘', '医院']) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(memory, isNot(contains('许澄')));
    expect(memory, isNot(contains('录音')));
    expect(hangzhouWestLakeReopenedCompletion.memoryAnchor, contains('手肘'));
    expect(hangzhouWestLakeReopenedCompletion.journeyCompletion, contains('医院'));
  });

  test('Hangzhou Narrative DNA differs materially from every approved Gold reference', () {
    final hangzhou = approvedNarrativeDnaCatalog.singleWhere((item) => item.journeyId == hangzhouWestLakeJourneyId);
    final references = approvedNarrativeDnaCatalog.where((item) => item.journeyId != hangzhouWestLakeJourneyId);
    expect(narrativeDnaIsUnique(hangzhou, references), isTrue);
    for (final reference in references) {
      expect(duplicatedMajorDimensions(hangzhou, reference), lessThan(3), reason: reference.journeyId);
    }
  });

  test('Narrative Difference Matrix covers all five approved Gold Journeys', () {
    expect(approvedNarrativeDnaCatalog.map((item) => item.journeyId).toSet(), contains(hangzhouWestLakeJourneyId));
    expect(approvedNarrativeDnaCatalog.length, greaterThanOrEqualTo(5));
  });

  test('anti-template gate rejects a three-dimension Hangzhou copy', () {
    final hangzhou = approvedNarrativeDnaCatalog.singleWhere((item) => item.journeyId == hangzhouWestLakeJourneyId);
    final copy = JourneyNarrativeDnaRecord(
      journeyId: 'hangzhou-copy-probe',
      narrativeIdentity: 'probe',
      protagonistIdentity: hangzhou.protagonistIdentity,
      protagonistAgeIdentity: hangzhou.protagonistAgeIdentity,
      protagonistArchetype: hangzhou.protagonistArchetype,
      openingSituation: 'other',
      storyGoal: 'other',
      locationMechanism: 'other',
      movementPattern: 'other',
      conflictType: 'other',
      choiceType: 'other',
      climaxType: 'other',
      consequenceType: 'other',
      emotionalArc: 'other',
      historicalLearningMechanism: 'other',
      resolutionType: 'other',
      endingMechanism: 'other',
      memoryAnchorType: 'other',
      achievementType: 'other',
      rewardSymbolism: 'other',
      temporalPattern: 'other',
      supportingStructure: 'other',
      centralMetaphor: 'other',
      narrativeVoice: 'other',
      storyRhythm: 'other',
    );
    expect(narrativeDnaIsUnique(copy, <JourneyNarrativeDnaRecord>[hangzhou]), isFalse);
  });

  test('Lv1 Lv5 Lv10 runtime equals the reopened canonical Story', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(hangzhouWestLakeJourneyId), isTrue);
    final experience = requireDailyJourneyExperience(hangzhouWestLakeJourneyId);
    for (final level in <int>[1, 5, 10]) {
      final resolved = resolveAdaptiveJourneyLevel(
        experience,
        profile: levelAgent.profileForPhoenixLevel(level),
      );
      expect(resolved.storyParagraphs, hangzhouWestLakeReopenedLevels[level - 1].storyParagraphs);
      expect(resolved.discoveries.single, same(hangzhouWestLakeReopenedDiscoverySpecs[level - 1].entry));
    }
  });

  test('Lv1 Lv5 Lv10 Reading Support matches every current paragraph', () {
    for (final level in <int>[1, 5, 10]) {
      final content = hangzhouWestLakeReopenedLevels[level - 1];
      expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
      final support = content.storyAnnotations
          .map((item) => '${item.pinyin} ${item.vietnamese} ${item.english}')
          .join(' ');
      for (final anchor in <String>[
        'Fang Yu',
        'Zhou Shaoting',
        'appointment card',
        'stone steps',
        'elbow',
        'hospital',
      ]) {
        expect(support, contains(anchor), reason: 'Lv$level $anchor');
      }
      for (final stale in <String>['Xu Cheng', 'recording', 'soundscape project', 'archive']) {
        expect(support, isNot(contains(stale)), reason: 'Lv$level stale $stale');
      }
    }
  });
}
