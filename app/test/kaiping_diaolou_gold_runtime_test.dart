import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/kaiping_diaolou_gold.dart';
import 'package:phoenix_journeys/data/world_geo_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

String _canonicalPinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

void main() {
  final kaiping = dailyJourneyExperiences.singleWhere(
    (journey) => journey.id == kaipingDiaolouJourneyId,
  );
  const agent = PhoenixLanguageLevelAgent();

  test('Kaiping is registered at the exact Guangdong-Jiangmen-Kaiping-place hierarchy', () {
    final place = worldGeoCatalog.singleWhere(
      (node) => node.id == kaipingDiaolouGeoNodeId,
    );
    final county = worldGeoCatalog.singleWhere((node) => node.id == place.parentId);
    final city = worldGeoCatalog.singleWhere((node) => node.id == county.parentId);
    final province = worldGeoCatalog.singleWhere((node) => node.id == city.parentId);

    expect(province.name, '广东省');
    expect(city.name, '江门市');
    expect(county.name, '开平市');
    expect(county.localType, '县级市');
    expect(place.name, '开平碉楼与村落');
    expect(place.latitude, isNull, reason: 'serial property must not invent one point');
    expect(place.longitude, isNull, reason: 'serial property must not invent one point');

    expect(kaiping.city, '江门');
    expect(kaiping.place, '开平碉楼与村落');
    expect(kaiping.storyTitle, kaipingDiaolouCanonicalTitle);
    expect(kaiping.description, contains('人物、家书与具体建楼选择为虚构'));
    expect(kaiping.content.geoNodeId, kaipingDiaolouGeoNodeId);
  });

  test('Kaiping is dedicated and active Lv1-Lv10 stay one Gold Story', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(kaipingDiaolouJourneyId), isTrue);
    expect(isBatchOneGoldJourney(kaipingDiaolouJourneyId), isTrue);

    const expectedDiscoveryCounts = <int>[1, 1, 2, 2, 2, 2, 2, 2, 2, 2];
    for (var level = 1; level <= 10; level++) {
      final profile = agent.profileForPhoenixLevel(level);
      final plan = agent.planFor(profile);
      final target = phoenixStoryLengthTargetFor(profile);
      final active = resolveAdaptiveJourneyLevel(kaiping, profile: profile);
      final story = active.storyParagraphs.join();

      expect(story, contains('梁川'), reason: 'Lv$level protagonist');
      expect(story, contains('梁海'), reason: 'Lv$level relationship');
      expect(story, contains('众楼'), reason: 'Lv$level place mechanism');
      expect(story, contains('放弃独建'), reason: 'Lv$level enacted choice');
      expect(story, contains('回来，不等于照搬'), reason: 'Lv$level memory ending');
      expect(story, isNot(contains('林砚')), reason: 'Lv$level Longmen isolation');
      expect(story, isNot(contains('周澄')), reason: 'Lv$level Longmen isolation');
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

      expect(active.discoveries, hasLength(expectedDiscoveryCounts[level - 1]));
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

  test('Kaiping adjacent levels add understanding without replacing Story spine', () {
    final stories = <String>[];
    for (var level = 1; level <= 10; level++) {
      stories.add(resolveAdaptiveJourneyLevel(
        kaiping,
        profile: agent.profileForPhoenixLevel(level),
      ).storyParagraphs.join());
    }

    for (var index = 1; index < stories.length; index++) {
      expect(stories[index], isNot(stories[index - 1]), reason: 'Lv${index + 1} semantic delta');
      expect(stories[index], contains('梁川'));
      expect(stories[index], contains('众楼'));
      expect(stories[index], contains('回来，不等于照搬'));
    }

    expect(stories[2], contains('众楼、居楼和更楼'));
    expect(stories[3], contains('重新组合'));
    expect(stories[4], contains('远方经验回到村里后还要接受本地需要'));
    expect(stories[6], contains('并不只有一种功能'));
    expect(stories[7], contains('民居、田地和村路'));
    expect(stories[8], contains('选择、调整和重新组合'));
    expect(stories[9], contains('单纯的“出海成功再衣锦还乡”'));
  });

  test('Kaiping historical production record is explicit, bounded and non-romanticized', () {
    expect(kaipingStoryArchitectures, hasLength(3));
    expect(
      kaipingStoryArchitectures.where((item) => item['SELECTED'] == 'YES'),
      hasLength(1),
    );
    expect(
      kaipingStoryArchitectures.singleWhere((item) => item['SELECTED'] == 'YES')['ID'],
      'A-return-is-not-copying',
    );
    expect(kaipingPrimaryDepthMechanism, 'SOCIAL CAUSALITY');
    expect(kaipingSecondaryDepthMechanisms, contains('CULTURAL VALUE TENSION'));
    expect(kaipingDepthActionTest['RESULT'], 'PASS');
    expect(kaipingDepthActionTest['REMOVAL_TEST'], contains('Goal-Conflict-Choice-Cost-Consequence collapse'));

    for (final claim in kaipingClaimLedger) {
      expect(claim['RESULT'], 'PASS', reason: claim['CLAIM_ID']);
      expect(claim['SOURCE']!.trim(), isNotEmpty, reason: claim['CLAIM_ID']);
      expect(claim['SOURCE_LOCATION_OR_IDENTIFIER']!.trim(), isNotEmpty, reason: claim['CLAIM_ID']);
      expect(claim['INTERPRETATION_BOUNDARY']!.trim(), isNotEmpty, reason: claim['CLAIM_ID']);
    }
    for (final result in kaipingHistoricalSafetyAudit.values) {
      expect(result, startsWith('NONE'));
    }

    final lv10 = kaipingDiaolouGoldLevelContent(10).storyParagraphs.join();
    expect(lv10, contains('并非都用同一种方式建楼'));
    expect(lv10, contains('不再支配整座建筑'));
    expect(lv10, contains('没有把侨乡故事讲成单纯的'));
    expect(lv10, isNot(contains('某国')));
  });

  test('Kaiping challenge, memory and completion bind the current Gold package', () {
    expect(
      kaipingDiaolouGoldJourney.challenges.map((item) => item.type).toList(),
      <String>['paragraphRebuild', 'grammarRepair', 'missingSentence'],
    );
    for (final challenge in kaipingDiaolouGoldJourney.challenges) {
      expect(challenge.storyEventIds, isNotEmpty);
      expect(challenge.anchor.trim(), isNotEmpty);
    }

    final memory = batchOneMemorySpecFor(kaipingDiaolouJourneyId);
    expect(memory, isNotNull);
    expect(memory!.storyResult, contains('众楼'));
    expect(memory.culturalPoint, contains('虚构'));
    expect(memory.culturalPoint, contains('众楼、居楼、更楼'));
    expect(memory.longTermAnchor, contains('没有被原样照搬的图'));
    expect(memory.completionSummary, contains('侨乡重组者'));
  });

  test('Kaiping Gold source implements one Story only and keeps future space unused', () {
    expect(kaipingStoryArchitectures.where((item) => item['SELECTED'] == 'YES'), hasLength(1));
    expect(kaipingFuturePlaceStoryOpportunities, isNotEmpty);
    expect(kaipingDiaolouGoldJourney.id, kaipingDiaolouJourneyId);
    expect(kaipingDiaolouGoldJourney.title, kaipingDiaolouCanonicalTitle);
  });
}
