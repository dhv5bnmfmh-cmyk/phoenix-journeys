import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';
import 'package:phoenix_journeys/data/luoyang_longmen_one_pass.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

String _canonicalPinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

void main() {
  final longmen = dailyJourneyExperiences.singleWhere(
    (journey) => journey.id == luoyangLongmenJourneyId,
  );
  const agent = PhoenixLanguageLevelAgent();

  test('Longmen base experience exposes Gold entry before profile resolution', () {
    expect(longmen.city, '洛阳');
    expect(longmen.place, '龙门石窟');
    expect(longmen.storyTitle, luoyangLongmenCanonicalTitle);
    expect(longmen.headline, luoyangLongmenHeadline);
    expect(longmen.description, contains('题记'));
    expect(longmen.discoveryTeaser, contains('证据层'));

    final base = resolveJourneyLevel(longmen, JourneyDifficulty.standard);
    final story = base.storyParagraphs.join();
    expect(story, contains('林砚'));
    expect(story, contains('周澄'));
    expect(story, contains('无依据，不使用'));
    expect(story, isNot(contains('一部刻在山崖上的艺术史')));
    expect(story, isNot(contains('河水向前流')));
  });

  test('Longmen is dedicated and active Lv1-Lv10 stay one Gold Story', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(luoyangLongmenJourneyId), isTrue);
    expect(isBatchOneGoldJourney(luoyangLongmenJourneyId), isTrue);

    const expectedDiscoveryCounts = <int>[2, 2, 2, 2, 3, 3, 3, 3, 3, 3];
    for (var level = 1; level <= 10; level++) {
      final profile = agent.profileForPhoenixLevel(level);
      final plan = agent.planFor(profile);
      final target = phoenixStoryLengthTargetFor(profile);
      final active = resolveAdaptiveJourneyLevel(
        longmen,
        profile: profile,
      );
      final story = active.storyParagraphs.join();

      expect(story, contains('林砚'), reason: 'Lv$level protagonist');
      expect(story, contains('周澄'), reason: 'Lv$level relationship');
      expect(story, contains('没依据，不能放在我们两人的名字下'), reason: 'Lv$level relationship conflict');
      expect(story, contains('关掉那一层'), reason: 'Lv$level enacted choice');
      expect(story, contains('无依据，不使用'), reason: 'Lv$level memory ending');
      expect(story, isNot(contains('河水向前流')), reason: 'Lv$level legacy');
      expect(story, isNot(contains('一部刻在山崖上的艺术史')), reason: 'Lv$level legacy');
      expect(story, isNot(contains('陈玉兰')), reason: 'Lv$level Suzhou isolation');
      expect(story, isNot(contains('程朗')), reason: 'Lv$level Suzhou isolation');

      expect(
        story.length,
        greaterThanOrEqualTo(target.acceptedMinimumCharacters),
        reason: 'Lv$level accepted minimum',
      );
      expect(
        story.length,
        lessThanOrEqualTo(target.acceptedMaximumCharacters),
        reason: 'Lv$level accepted maximum',
      );
      expect(active.storyParagraphs, hasLength(target.paragraphCount));
      expect(active.storyAnnotations, hasLength(active.storyParagraphs.length));
      for (var index = 0; index < active.storyParagraphs.length; index++) {
        expect(
          active.storyAnnotations[index].pinyin,
          _canonicalPinyin(active.storyParagraphs[index]),
          reason: 'Lv$level Story pinyin paragraph ${index + 1}',
        );
        expect(active.storyAnnotations[index].vietnamese.trim(), isNotEmpty);
        expect(active.storyAnnotations[index].english.trim(), isNotEmpty);
      }

      expect(
        active.discoveries,
        hasLength(expectedDiscoveryCounts[level - 1]),
        reason: 'Lv$level approved runtime Discovery shape',
      );
      for (final discovery in active.discoveries) {
        expect(discovery.pinyin, _canonicalPinyin(discovery.text));
        expect(discovery.vietnamese.trim(), isNotEmpty);
        expect(discovery.english.trim(), isNotEmpty);
      }

      expect(active.words.length, plan.targetVocabularyCount);
      expect(active.words.length, lessThanOrEqualTo(plan.maximumVocabularyCount));
      final visible = '${active.storyParagraphs.join()}'
          '${active.discoveries.map((entry) => entry.text).join()}';
      for (final word in active.words) {
        expect(visible, contains(word.word), reason: 'Lv$level ${word.word} provenance');
        expect(word.examples, hasLength(greaterThanOrEqualTo(3)));
      }
    }
  });

  test('Longmen adjacent levels add understanding without replacing Story spine', () {
    final stories = <String>[];
    for (var level = 1; level <= 10; level++) {
      final active = resolveAdaptiveJourneyLevel(
        longmen,
        profile: agent.profileForPhoenixLevel(level),
      );
      stories.add(active.storyParagraphs.join());
    }

    for (var index = 1; index < stories.length; index++) {
      expect(stories[index], isNot(stories[index - 1]), reason: 'Lv${index + 1} semantic delta');
      expect(stories[index], contains('林砚'));
      expect(stories[index], contains('关掉那层'));
    }

    expect(stories[4], contains('历史老照片支持复原'));
    expect(stories[6], contains('现存状态'));
    expect(stories[7], contains('建模前先问'));
    expect(stories[8], contains('成片只留下三层'));
    expect(stories[9], contains('放进下一次模板'));
  });

  test('Longmen historical production record is explicit and bounded', () {
    expect(luoyangLongmenStoryArchitectures, hasLength(3));
    expect(
      luoyangLongmenStoryArchitectures.where((item) => item.selected),
      hasLength(1),
    );
    expect(
      luoyangLongmenStoryArchitectures.singleWhere((item) => item.selected).id,
      'A-evidence-ends-here',
    );
    expect(luoyangLongmenPrimaryDepthMechanism, 'AMBIGUITY / UNCERTAINTY');
    expect(luoyangLongmenSecondaryDepthMechanisms, contains('ABSENCE / LOSS'));
    expect(luoyangLongmenDepthActionTest['RESULT'], 'PASS');
    expect(
      luoyangLongmenDepthActionTest['REMOVAL_TEST'],
      contains('Goal-Conflict-Choice-Cost-Consequence collapse'),
    );
    for (final claim in luoyangLongmenClaimLedger) {
      expect(claim.result, 'PASS', reason: claim.id);
      expect(claim.source.trim(), isNotEmpty, reason: claim.id);
      expect(claim.sourceLocationOrIdentifier.trim(), isNotEmpty, reason: claim.id);
      expect(claim.interpretationBoundary.trim(), isNotEmpty, reason: claim.id);
    }
    for (final result in luoyangLongmenHistoricalSafetyAudit.values) {
      expect(result, 'NONE');
    }
  });

  test('Longmen challenge, memory and completion are current Gold package', () {
    expect(
      luoyangLongmenGoldJourney.challenges.map((item) => item.type).toList(),
      <String>['paragraphRebuild', 'grammarRepair', 'missingSentence'],
    );
    for (final challenge in luoyangLongmenGoldJourney.challenges) {
      expect(challenge.storyEventIds, isNotEmpty);
      expect(challenge.anchor.trim(), isNotEmpty);
    }

    final memory = batchOneMemorySpecFor(luoyangLongmenJourneyId);
    expect(memory, isNotNull);
    expect(memory!.storyResult, contains('林砚'));
    expect(memory.culturalPoint, contains('不知道'));
    expect(memory.culturalPoint, contains('万佛洞'));
    expect(memory.longTermAnchor, contains('无依据，不使用'));
    expect(memory.completionSummary, contains('证据边界守护者'));
  });

  test('Longmen Gold source does not implement a second Story or multi-story selector', () {
    expect(luoyangLongmenStoryArchitectures.where((item) => item.selected), hasLength(1));
    expect(luoyangLongmenFuturePlaceStoryOpportunities, isNotEmpty);
    expect(luoyangLongmenGoldJourney.id, luoyangLongmenJourneyId);
    expect(luoyangLongmenGoldJourney.title, luoyangLongmenCanonicalTitle);
  });
}
