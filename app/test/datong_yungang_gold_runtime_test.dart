import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/datong_yungang_gold_content.dart';
import 'package:phoenix_journeys/data/dedicated_adaptive_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_expansion_batch_two.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';

void main() {
  test('Datong has one dedicated active Gold source', () {
    expect(usesDedicatedAdaptiveJourneyRuntime(datongYungangJourneyId), isTrue);
    expect(isBatchOneGoldJourney(datongYungangJourneyId), isTrue);
    expect(journeyExpansionBatchTwoExperiences.where((item) => item.id == datongYungangJourneyId), hasLength(1));
  });

  test('Lv1 proves actual Yungang hinge, choice, cost and consequence', () {
    final story = datongYungangGoldLevelContent(1).storyParagraphs.join();
    expect(story, contains('北魏迁都洛阳后，云冈不再像从前那样营造巨像'));
    expect(story, contains('父亲只肯把手艺交给一个人'));
    expect(story, contains('割成三段'));
    expect(story, contains('失去了父亲许诺的唯一位置'));
    expect(story, contains('魏朔第一次自己弹出墨线'));
  });

  test('place-causality contract removes cause instead of transplanting it', () {
    expect(datongYungangPlaceCausality['YUNGANG_REMOVAL'], contains('collapse'));
    expect(datongYungangPlaceCausality['LONGMEN_REPLACEMENT'], contains('reversed'));
    expect(datongYungangHistoricalSafety['INVENTED_RELOCATION_ORDER'], 'NONE');
    expect(datongYungangHistoricalSafety['INVENTED_INSTITUTIONAL_RULE'], 'NONE');
  });

  test('Lv5 and Lv10 deepen one spine and keep four-language parity', () {
    final lv5 = datongYungangGoldLevelContent(5);
    final lv10 = datongYungangGoldLevelContent(10);
    for (final anchor in ['魏岚', '魏朔', '割成三段', '三道黑线']) {
      expect(lv10.storyParagraphs.join(), contains(anchor));
    }
    expect(lv10.storyParagraphs.join().length, greaterThan(lv5.storyParagraphs.join().length));
    for (final level in [1, 5, 10]) {
      final content = datongYungangGoldLevelContent(level);
      expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
      expect(content.storyAnnotations.every((item) => item.pinyin.isNotEmpty && item.vietnamese.isNotEmpty && item.english.isNotEmpty), isTrue);
    }
  });

  test('Discovery is deep and vocabulary is active-only', () {
    for (var level = 1; level <= 10; level++) {
      final content = datongYungangGoldLevelContent(level);
      expect(content.discoveries.length, level < 5 ? 2 : 3);
      final visible = '${content.storyParagraphs.join()}${content.discoveries.map((item) => item.text).join()}';
      expect(content.words.every((word) => visible.contains(word.word)), isTrue);
    }
  });

  test('DNA and semantic fingerprint describe the active causal Story', () {
    final dna = approvedNarrativeDnaCatalog.singleWhere((item) => item.journeyId == datongYungangJourneyId);
    expect(dna.choiceType, contains('three-working-lines'));
    final fingerprint = approvedGoldSemanticFingerprints[datongYungangJourneyId]!;
    expect(semanticFingerprintCompletenessErrors(fingerprint), isEmpty);
    expect(semanticEvidenceContractErrors(fingerprint), isEmpty);
    expect(auditFutureGoldCandidate(fingerprint, approvedGoldSemanticFingerprints.values).isGoldReady, isTrue);
  });

  test('challenge, memory and completion are Datong-specific', () {
    expect(datongYungangGoldJourney.challenges.map((item) => item.type).toSet(), {'paragraphRebuild', 'grammarRepair', 'missingSentence'});
    expect(datongYungangGoldJourney.completion.memoryAnchor, contains('三段墨绳'));
    expect(datongYungangGoldJourney.completion.journeyCompletion, isNot(contains('保护文化')));
  });
}
