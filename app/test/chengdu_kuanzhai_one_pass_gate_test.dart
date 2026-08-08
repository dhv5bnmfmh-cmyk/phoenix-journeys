import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/chengdu_kuanzhai_one_pass.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

void main() {
  const levelAgent = PhoenixLanguageLevelAgent();

  test('Chengdu Story obeys Lv1-Lv10 length and paragraph policy', () {
    expect(chengduKuanzhaiOnePassLevels, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final content = chengduKuanzhaiOnePassLevels[level - 1];
      final characters = content.storyParagraphs.join().runes.length;
      final target = phoenixStoryLengthTargetForLevel(level);
      // ignore: avoid_print
      print('CHENGDU_STORY_METRIC Lv$level characters=$characters paragraphs=${content.storyParagraphs.length}');
      expect(characters, inInclusiveRange(target.acceptedMinimumCharacters, target.acceptedMaximumCharacters), reason: 'Lv$level accepted Story range');
      expect(content.storyParagraphs.length, target.paragraphCount, reason: 'Lv$level paragraph count');
      expect(content.storyAnnotations.length, content.storyParagraphs.length);
    }
  });

  test('all levels preserve the canonical Lin Xia use-trace narrative', () {
    for (var level = 1; level <= 10; level++) {
      final story = chengduKuanzhaiOnePassLevels[level - 1].storyParagraphs.join();
      for (final anchor in <String>['林夏', '宽窄巷子', '商业活动', '茶桌', '仍在使用']) {
        expect(story, contains(anchor), reason: 'Lv$level $anchor');
      }
      expect(story, isNot(contains('午后，你走进成都宽窄巷子')));
      expect(story, isNot(contains('在场')));
      expect(story, isNot(contains('提单')));
      expect(story, isNot(contains('跑表')));
      expect(story, isNot(contains('许可')));
    }
  });

  test('climax and ending preserve the crossed-out survey judgment', () {
    final advanced = chengduKuanzhaiOnePassLevels[9].storyParagraphs.join();
    expect(advanced, contains('宽巷子'));
    expect(advanced, contains('窄巷子'));
    expect(advanced, contains('井巷子'));
    expect(advanced, contains('院落'));
    expect(advanced, contains('保护更新'));
    expect(advanced, contains('把“商业活动”划掉'));
    expect(advanced, contains('“仍在使用。”'));
    expect(advanced, contains('第二天'));
    expect(advanced, contains('没有把报告誊成没有修改痕迹的干净版本'));
  });

  test('Words have exact Story trace and truthful first appearance', () {
    final stories = <String>[for (final level in chengduKuanzhaiOnePassLevels) level.storyParagraphs.join()];
    expect(chengduKuanzhaiOnePassWords, hasLength(chengduKuanzhaiWordTraces.length));
    expect(chengduKuanzhaiOnePassWords, hasLength(chengduKuanzhaiWordFirstAppears.length));
    for (final word in chengduKuanzhaiOnePassWords) {
      final trace = chengduKuanzhaiWordTraces.firstWhere((item) => item.word == word.word);
      expect(trace.sourceText, contains(word.word), reason: word.word);
      expect(stories.any((story) => story.contains(trace.sourceText)), isTrue, reason: '${word.word} exact source');
      final first = stories.indexWhere((story) => story.contains(word.word)) + 1;
      expect(first, chengduKuanzhaiWordFirstAppears[word.word], reason: '${word.word} first appears');
      expect(word.pinyin.trim(), isNotEmpty);
      expect(word.partOfSpeech.trim(), isNotEmpty);
      expect(word.translation.trim(), isNotEmpty);
      expect(word.englishDefinition.trim(), isNotEmpty);
    }
    final active = chengduKuanzhaiOnePassWords.map((word) => word.word).toSet();
    expect(active, isNot(containsAll(<String>['巷子', '平行', '盖碗茶', '保留', '慢生活', '商业'])));
  });

  test('Discovery is exactly ten level-bound sourced Story-linked entries', () {
    final sourceIds = chengduKuanzhaiSources.map((source) => source.id).toSet();
    expect(chengduKuanzhaiDiscoverySpecs, hasLength(10));
    for (var level = 1; level <= 10; level++) {
      final spec = chengduKuanzhaiDiscoverySpecs[level - 1];
      expect(spec.level, level);
      expect(spec.storyLink.trim(), isNotEmpty);
      expect(spec.keyTerms, isNotEmpty);
      expect(spec.learnerInsight.trim(), isNotEmpty);
      expect(spec.check.trim(), isNotEmpty);
      expect(spec.answer.trim(), isNotEmpty);
      expect(spec.sourceIds, isNotEmpty);
      expect(spec.sourceIds.every(sourceIds.contains), isTrue);
      final resolved = chengduKuanzhaiOnePassLevelContent(level);
      expect(resolved.discoveries, hasLength(1));
      expect(identical(resolved.discoveries.single, spec.entry), isTrue);
    }
  });

  test('Challenge covers Lv1-Lv10 with approved active-story types only', () {
    const approved = <String>{'paragraphRebuild', 'grammarRepair', 'missingSentence'};
    expect(chengduKuanzhaiChallenges, hasLength(30));
    for (var level = 1; level <= 10; level++) {
      final story = chengduKuanzhaiOnePassLevels[level - 1].storyParagraphs.join();
      final challenges = chengduKuanzhaiChallenges.where((item) => item.level == level).toList();
      expect(challenges.map((item) => item.type).toSet(), approved);
      for (final challenge in challenges) {
        expect(story, contains(challenge.anchor), reason: 'Lv$level ${challenge.type}');
        if (challenge.type == 'missingSentence') {
          expect(challenge.answer, challenge.anchor);
          expect(RegExp(r'[^。！？!?]+[。！？!?]').allMatches(story).map((m) => m.group(0)!).contains(challenge.answer), isTrue, reason: 'Lv$level exact missing sentence');
        }
      }
    }
  });

  test('Memory and Complete remain Chengdu-specific', () {
    final memory = chengduKuanzhaiMemory.map((item) => item.answer).join();
    for (final anchor in <String>['林夏', '调查表', '宽巷子', '窄巷子', '井巷子', '院落', '茶桌', '商业活动', '仍在使用']) {
      expect(memory, contains(anchor), reason: anchor);
    }
    expect(chengduKuanzhaiCompletion.achievement, '巷院痕迹观察者');
    expect(chengduKuanzhaiCompletion.memoryAnchor, '调查表上被划掉的“商业活动”四个字');
    expect(chengduKuanzhaiCompletion.challengeReward, '巷院使用印记');
    expect(chengduKuanzhaiCompletion.journeyCompletion, contains('“仍在使用。”'));
  });

  test('Narrative Difference Matrix covers six Gold Journeys and Chengdu is unique', () {
    final ids = approvedNarrativeDnaCatalog.map((item) => item.journeyId).toSet();
    expect(ids, containsAll(<String>{'beijing-summer-palace', 'beijing-forbidden-city', 'shanghai-bund', 'xian-city-wall', 'hangzhou-west-lake', chengduKuanzhaiJourneyId}));
    final chengdu = approvedNarrativeDnaCatalog.singleWhere((item) => item.journeyId == chengduKuanzhaiJourneyId);
    final references = approvedNarrativeDnaCatalog.where((item) => item.journeyId != chengduKuanzhaiJourneyId);
    expect(narrativeDnaIsUnique(chengdu, references), isTrue);
    for (final reference in references) {
      expect(duplicatedMajorDimensions(chengdu, reference), lessThan(3), reason: reference.journeyId);
    }
  });

  test('runtime classifies Chengdu as dedicated Gold and resolves immutable snapshots', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(chengduKuanzhaiJourneyId), isTrue);
    expect(usesSharedGenericAdaptivePipeline(chengduKuanzhaiJourneyId), isFalse);
    final experience = requireDailyJourneyExperience(chengduKuanzhaiJourneyId);
    for (final level in <int>[1, 5, 10]) {
      final resolved = resolveAdaptiveJourneyLevel(experience, profile: levelAgent.profileForPhoenixLevel(level));
      expect(identical(resolved.storyParagraphs, chengduKuanzhaiOnePassLevels[level - 1].storyParagraphs), isTrue);
      expect(resolved.storyParagraphs.join(), isNot(contains('午后，你走进成都宽窄巷子')));
      expect(resolved.discoveries, hasLength(1));
    }
  });
}
