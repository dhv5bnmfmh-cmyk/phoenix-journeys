import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/nanjing_qinhuai_one_pass.dart';

void main() {
  test('Nanjing is registered in the approved Gold Narrative DNA catalog', () {
    final record = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == nanjingQinhuaiJourneyId,
    );

    expect(record.narrativeIdentity, nanjingQinhuaiNarrativeDna.narrativeIdentity);
    expect(record.protagonistIdentity, contains('Wei-Zhou'));
    expect(record.openingSituation, contains('seven-minute-countdown'));
    expect(record.storyGoal, nanjingQinhuaiNarrativeDna.storyGoal);
    expect(record.locationMechanism, contains('Qinhuai-river'));
    expect(record.conflictType, nanjingQinhuaiNarrativeDna.conflictType);
    expect(record.choiceType, nanjingQinhuaiNarrativeDna.choiceType);
    expect(record.climaxType, nanjingQinhuaiNarrativeDna.climaxType);
    expect(record.consequenceType, contains('dark-section'));
    expect(record.endingMechanism, nanjingQinhuaiNarrativeDna.endingMechanism);
    expect(record.memoryAnchorType, nanjingQinhuaiNarrativeDna.memoryAnchorType);
  });

  test('Nanjing Narrative DNA stays unique against every other approved Gold Journey', () {
    final candidate = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == nanjingQinhuaiJourneyId,
    );
    expect(narrativeDnaIsUnique(candidate, approvedNarrativeDnaCatalog), isTrue);

    for (final reference in approvedNarrativeDnaCatalog) {
      if (reference.journeyId == nanjingQinhuaiJourneyId) continue;
      expect(
        duplicatedMajorDimensions(candidate, reference),
        lessThan(3),
        reason: 'Nanjing must remain causally distinct from ${reference.journeyId}',
      );
    }
  });
}
