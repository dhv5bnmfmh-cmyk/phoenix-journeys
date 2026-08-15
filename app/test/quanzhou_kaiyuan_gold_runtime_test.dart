import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/data/quanzhou_kaiyuan_gold_content.dart';
import 'package:phoenix_journeys/data/world_geo_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_story_length_policy.dart';

String _canonicalPinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

void main() {
  final quanzhou = dailyJourneyExperiences.singleWhere(
    (journey) => journey.id == quanzhouKaiyuanJourneyId,
  );
  const agent = PhoenixLanguageLevelAgent();

  test('Quanzhou keeps the existing Fujian-Quanzhou-Licheng-Kaiyuan hierarchy', () {
    final place = worldGeoCatalog.singleWhere(
      (node) => node.id == quanzhouKaiyuanGeoNodeId,
    );
    final district = worldGeoCatalog.singleWhere((node) => node.id == place.parentId);
    final city = worldGeoCatalog.singleWhere((node) => node.id == district.parentId);
    final province = worldGeoCatalog.singleWhere((node) => node.id == city.parentId);

    expect(province.name, '福建省');
    expect(city.name, '泉州市');
    expect(district.name, '鲤城区');
    expect(place.name, '开元寺');
    expect(quanzhou.city, '泉州');
    expect(quanzhou.place, '开元寺');
    expect(quanzhou.storyTitle, quanzhouKaiyuanCanonicalTitle);
    expect(quanzhou.description, contains('虚构'));
    expect(quanzhou.content.geoNodeId, quanzhouKaiyuanGeoNodeId);
  });

  test('Quanzhou is dedicated Gold and active Lv1-Lv10 never leak tourism seed', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(quanzhouKaiyuanJourneyId), isTrue);
    expect(isBatchOneGoldJourney(quanzhouKaiyuanJourneyId), isTrue);
    const expectedDiscoveryCounts = <int>[2, 2, 2, 2, 3, 3, 3, 3, 3, 3];

    for (var level = 1; level <= 10; level++) {
      final profile = agent.profileForPhoenixLevel(level);
      final plan = agent.planFor(profile);
      final target = phoenixStoryLengthTargetFor(profile);
      final active = resolveAdaptiveJourneyLevel(quanzhou, profile: profile);
      final story = active.storyParagraphs.join();

      expect(story, contains('许安'), reason: 'Lv$level protagonist');
      expect(story, contains('许宁'), reason: 'Lv$level relationship');
      expect(story, contains('受戒'), reason: 'Lv$level place/ritual anchor');
      expect(story, contains('西街'), reason: 'Lv$level Kaiyuan-specific spatial hinge');
      expect(story, contains('钥匙'), reason: 'Lv$level enacted choice object');
      expect(story, contains('先敲门'), reason: 'Lv$level caused consequence');
      expect(story, isNot(contains('上午，你走进泉州开元寺')));
      expect(story, isNot(contains('离开寺院时，你会发现')));
      expect(story, isNot(contains('戒坛始建于1019年')), reason: 'Lv$level history explanation belongs in Discovery');
      expect(story, isNot(contains('官方资料还记录')), reason: 'Lv$level source commentary belongs in Discovery');
      expect(story.length, greaterThanOrEqualTo(target.acceptedMinimumCharacters));
      expect(story.length, lessThanOrEqualTo(target.acceptedMaximumCharacters));
      expect(active.storyParagraphs, hasLength(target.paragraphCount));
      expect(active.storyAnnotations, hasLength(active.storyParagraphs.length));
      for (var index = 0; index < active.storyParagraphs.length; index++) {
        expect(active.storyAnnotations[index].pinyin, _canonicalPinyin(active.storyParagraphs[index]));
        expect(active.storyAnnotations[index].vietnamese.trim(), isNotEmpty);
        expect(active.storyAnnotations[index].english.trim(), isNotEmpty);
      }

      expect(active.discoveries, hasLength(expectedDiscoveryCounts[level - 1]));
      for (final discovery in active.discoveries) {
        expect(discovery.pinyin, _canonicalPinyin(discovery.text));
        expect(discovery.vietnamese.trim(), isNotEmpty);
        expect(discovery.english.trim(), isNotEmpty);
      }

      expect(active.words.length, plan.targetVocabularyCount, reason: 'Lv$level vocabulary target');
      expect(active.words.length, lessThanOrEqualTo(plan.maximumVocabularyCount));
      final visible = '${active.storyParagraphs.join()}${active.discoveries.map((entry) => entry.text).join()}';
      for (final word in active.words) {
        expect(visible, contains(word.word), reason: 'Lv$level ${word.word} provenance');
        expect(word.examples, hasLength(greaterThanOrEqualTo(3)));
      }
    }
  });

  test('Quanzhou repaired Story keeps Kaiyuan place causality without exposition leakage', () {
    final lv1 = resolveAdaptiveJourneyLevel(
      quanzhou,
      profile: agent.profileForPhoenixLevel(1),
    );
    final lv5 = resolveAdaptiveJourneyLevel(
      quanzhou,
      profile: agent.profileForPhoenixLevel(5),
    );
    expect(lv1.storyParagraphs.join(), contains('旧宅也在西街'));
    expect(lv1.storyParagraphs.join(), contains('沿街走到甘露戒坛前'));
    expect(lv5.storyParagraphs.join(), contains('你又不是走得回不来'));
    expect(lv5.storyParagraphs.join(), isNot(contains('1019年')));
    expect(lv5.storyParagraphs.join(), isNot(contains('官方资料')));
    expect(lv5.discoveries.any((item) => item.text.contains('1019年')), isTrue);
    expect(lv5.discoveries.any((item) => item.text.contains('西街中段北侧')), isTrue);
  });

  test('Quanzhou adjacent levels deepen one locked Story and Lv10 keeps action ending', () {
    final stories = <String>[];
    for (var level = 1; level <= 10; level++) {
      stories.add(resolveAdaptiveJourneyLevel(
        quanzhou,
        profile: agent.profileForPhoenixLevel(level),
      ).storyParagraphs.join());
    }
    for (var index = 1; index < stories.length; index++) {
      expect(stories[index], isNot(stories[index - 1]), reason: 'Lv${index + 1} must add semantic depth');
      expect(stories[index], contains('许安'), reason: 'Lv${index + 1} protagonist invariant');
      expect(stories[index], contains('许宁'), reason: 'Lv${index + 1} relationship invariant');
      expect(stories[index], contains('把钥匙放进姐姐手里'), reason: 'Lv${index + 1} enacted-choice invariant');
      expect(stories[index], contains('房间别替我留了'), reason: 'Lv${index + 1} cost/consequence spine');
    }
    expect(stories[4], contains('你要我认你这个弟弟'));
    expect(stories[7], contains('你敲，我就开'));
    expect(stories[8], contains('没有再问那间房会给谁'));
    expect(stories[9], contains('只摸到空处'));
    expect(stories[9], isNot(contains('真正')));
    expect(stories[9], isNot(contains('这告诉我们')));
    expect(stories[9], isNot(contains('她终于明白')));
  });

  test('Quanzhou Fact First, A-B-C and depth records remain bounded', () {
    expect(quanzhouSourceLedger, hasLength(5));
    expect(quanzhouStoryArchitectures, hasLength(3));
    expect(quanzhouStoryArchitectures.where((item) => item['SELECTED'] == 'YES'), hasLength(1));
    expect(
      quanzhouStoryArchitectures.singleWhere((item) => item['SELECTED'] == 'YES')['ID'],
      'A-ordination-without-frozen-home',
    );
    expect(quanzhouPrimaryDepthMechanism, 'PRACTICE / RITUAL CAUSALITY');
    expect(quanzhouDepthActionTest['RESULT'], 'PASS');
    expect(quanzhouPlaceCausalMechanism['GENERIC_PLACE_SUBSTITUTION'], startsWith('PASS'));
    expect(quanzhouPlaceCausalMechanism['VERIFIED_PLACE_PROPERTY'], contains('西街'));
    expect(quanzhouFactFictionLedger.any((item) => item['ITEM'] == '许安、许宁的虚构旧宅也设在西街'), isTrue);
    for (final claim in quanzhouClaimLedger) {
      expect(claim['RESULT'], 'PASS', reason: claim['CLAIM_ID']);
      expect(claim['SOURCE']!.trim(), isNotEmpty);
      expect(claim['INTERPRETATION_BOUNDARY']!.trim(), isNotEmpty);
    }
    for (final result in quanzhouHistoricalSafetyAudit.values) {
      expect(result, startsWith('NONE'));
    }
    expect(quanzhouFuturePlaceStoryOpportunities, isNotEmpty);
  });

  test('Quanzhou Challenge Memory Completion bind only current Story', () {
    expect(
      quanzhouKaiyuanGoldJourney.challenges.map((item) => item.type).toList(),
      <String>['paragraphRebuild', 'grammarRepair', 'missingSentence'],
    );
    final memory = batchOneMemorySpecFor(quanzhouKaiyuanJourneyId);
    expect(memory, isNotNull);
    expect(memory!.storyResult, contains('钥匙'));
    expect(memory.culturalPoint, contains('虚构'));
    expect(memory.culturalPoint, contains('戒坛'));
    expect(memory.longTermAnchor, contains('掌心'));
    expect(memory.completionSummary, contains('门前的选择者'));
  });

  test('Quanzhou is fully promoted into semantic and Narrative DNA registries', () {
    final fingerprint = approvedGoldSemanticFingerprints[quanzhouKaiyuanJourneyId];
    expect(fingerprint, isNotNull);
    expect(semanticFingerprintCompletenessErrors(fingerprint!), isEmpty);
    expect(semanticEvidenceContractErrors(fingerprint), isEmpty);
    expect(
      semanticDifferenceMatrixAgainstApprovedGold(fingerprint).where((item) => item.isCollision),
      isEmpty,
    );
    expect(auditApprovedGoldSemanticPairs(), hasLength(66));
    expect(auditApprovedGoldSemanticPairs().where((item) => item.isCollision), isEmpty);

    final dna = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == quanzhouKaiyuanJourneyId,
    );
    expect(dna.narrativeIdentity, contains('ordination-threshold'));
    expect(narrativeDnaIsUnique(dna, approvedNarrativeDnaCatalog), isTrue);
  });
}
