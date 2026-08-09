import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';

const _goldIds = <String>{
  'beijing-summer-palace',
  'beijing-forbidden-city',
  'shanghai-bund',
  'xian-city-wall',
  'hangzhou-west-lake',
  'chengdu-kuanzhai-alley',
  'nanjing-qinhuai-river',
};

JourneySemanticFingerprint _synthetic(
  String id,
  String surfaceIdentity,
  Map<NarrativeSemanticDimension, NarrativeMechanismFamily> mechanisms,
) =>
    JourneySemanticFingerprint(
      journeyId: id,
      surfaceIdentity: surfaceIdentity,
      mechanisms: Map.unmodifiable(mechanisms),
      coreEvidence: const [],
    );

NarrativeSemanticComparison _pair(String a, String b) =>
    auditApprovedGoldSemanticPairs().singleWhere(
      (item) =>
          (item.journeyA == a && item.journeyB == b) ||
          (item.journeyA == b && item.journeyB == a),
    );

String _pairKey(String a, String b) {
  final ids = <String>[a, b]..sort();
  return ids.join('|');
}

Map<NarrativeSemanticDimension, NarrativeMechanismFamily> _cloneGold(String id) =>
    Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.from(
      approvedGoldSemanticFingerprints[id]!.mechanisms,
    );

void main() {
  test('all seven approved Gold Journeys have complete normalized fingerprints', () {
    expect(approvedGoldSemanticFingerprints.keys.toSet(), _goldIds);
    for (final fingerprint in approvedGoldSemanticFingerprints.values) {
      expect(
        fingerprint.mechanisms.length,
        NarrativeSemanticDimension.values.length,
        reason: fingerprint.journeyId,
      );
      expect(
        semanticFingerprintCompletenessErrors(fingerprint),
        isEmpty,
        reason: fingerprint.journeyId,
      );
      for (final dimension in narrativeSemanticCoreDimensions) {
        expect(
          fingerprint.mechanisms[dimension],
          isNotNull,
          reason: '${fingerprint.journeyId}:${dimension.name}',
        );
      }
    }
  });

  test('every CORE evidence record is exact text from the active production Story', () {
    for (final fingerprint in approvedGoldSemanticFingerprints.values) {
      expect(
        fingerprint.coreEvidence.length,
        narrativeSemanticCoreDimensions.length,
        reason: fingerprint.journeyId,
      );
      expect(
        semanticEvidenceFidelityErrors(fingerprint),
        isEmpty,
        reason: fingerprint.journeyId,
      );
      final activeStory = activeCanonicalGoldStoryText(fingerprint.journeyId);
      for (final evidence in fingerprint.coreEvidence) {
        expect(evidence.journeyId, fingerprint.journeyId);
        expect(activeStory, contains(evidence.sourceText));
        expect(evidence.mechanism, fingerprint.mechanism(evidence.dimension));
      }
    }
  });

  test('legacy Forbidden City Story prose cannot satisfy active DNA evidence', () {
    final active = activeCanonicalGoldStoryText('beijing-forbidden-city');
    const abandonedMaintenanceStory = '纪衡在午门内收到雷雨预警。';
    expect(active, isNot(contains(abandonedMaintenanceStory)));
    expect(
      approvedGoldSemanticFingerprints['beijing-forbidden-city']!.coreEvidence
          .any((evidence) => evidence.sourceText == abandonedMaintenanceStory),
      isFalse,
    );
  });

  test('Forbidden City descriptive registry matches active Shen Yan apprentice Story', () {
    final record = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == 'beijing-forbidden-city',
    );
    final active = activeCanonicalGoldStoryText('beijing-forbidden-city');

    expect(record.protagonistIdentity, contains('Shen-Yan'));
    expect(record.protagonistIdentity, contains('seventeen-year-old'));
    expect(record.protagonistArchetype, contains('construction-apprentice'));
    expect(record.supportingStructure, contains('Zhou-Shifu'));
    expect(record.choiceType, contains('open-threshold'));
    expect(record.consequenceType, contains('map-retains-a-meaningful-blank'));
    expect(record.endingMechanism, contains('old-wooden-ruler'));
    expect(record.protagonistIdentity, isNot(contains('maintenance-worker')));

    expect(active, contains('十七岁的营造学徒沈砚'));
    expect(active, contains('周师傅'));
    expect(active, contains('地图仍留下空白'));
    expect(active, contains('旧木尺'));
  });

  test('all descriptive Gold registry entries resolve to active Story evidence', () {
    expect(approvedNarrativeDnaCatalog.map((item) => item.journeyId).toSet(), _goldIds);
    for (final record in approvedNarrativeDnaCatalog) {
      final activeStory = activeCanonicalGoldStoryText(record.journeyId);
      final fingerprint = approvedGoldSemanticFingerprints[record.journeyId];
      expect(activeStory.trim(), isNotEmpty, reason: record.journeyId);
      expect(fingerprint, isNotNull, reason: record.journeyId);
      expect(fingerprint!.coreEvidence, isNotEmpty, reason: record.journeyId);
      expect(
        semanticEvidenceFidelityErrors(fingerprint),
        isEmpty,
        reason: record.journeyId,
      );
    }
  });

  test('wording disguise cannot evade normalized semantic collision', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final a = _synthetic(
      'northern-archive-probe',
      'Mei / northern city / archivist / brass compass / identity text A',
      Map.from(source.mechanisms),
    );
    final b = _synthetic(
      'southern-harbor-probe',
      'Arun / southern port / engineer / paper ledger / identity text B',
      Map.from(source.mechanisms),
    );

    final comparison = compareSemanticFingerprints(a, b);
    expect(a.surfaceIdentity, isNot(equals(b.surfaceIdentity)));
    expect(comparison.sameDramaticEngine, isTrue);
    expect(comparison.isCollision, isTrue);
    expect(
      comparison.classification,
      SemanticCollisionClassification.semanticCollision,
    );
  });

  test('surface similarity alone does not create a false semantic collision', () {
    final a = _synthetic(
      'surface-a',
      'young / third-person / one-day / heritage / physical-object',
      _cloneGold('beijing-summer-palace'),
    );
    final b = _synthetic(
      'surface-b',
      'young / third-person / one-day / heritage / physical-object',
      _cloneGold('shanghai-bund'),
    );

    final comparison = compareSemanticFingerprints(a, b);
    expect(a.surfaceIdentity, b.surfaceIdentity);
    expect(comparison.coreMatchCount, 0);
    expect(comparison.isCollision, isFalse);
  });

  test('Rule A blocks same dramatic engine plus exactly three additional CORE matches', () {
    final left = _cloneGold('beijing-summer-palace');
    final right = _cloneGold('shanghai-bund');
    for (final dimension in <NarrativeSemanticDimension>[
      NarrativeSemanticDimension.dramaticEngineFamily,
      NarrativeSemanticDimension.conflictMechanism,
      NarrativeSemanticDimension.choiceMechanism,
      NarrativeSemanticDimension.climaxMechanism,
    ]) {
      right[dimension] = left[dimension]!;
    }

    final comparison = compareSemanticFingerprints(
      _synthetic('rule-a-left', 'surface A', left),
      _synthetic('rule-a-right', 'surface B', right),
    );
    expect(comparison.sameDramaticEngine, isTrue);
    expect(comparison.coreMatchCount, 4);
    expect(comparison.ruleA, isTrue);
    expect(comparison.isCollision, isTrue);
  });

  test('Rule A stays open below three additional CORE matches', () {
    final left = _cloneGold('beijing-summer-palace');
    final right = _cloneGold('shanghai-bund');
    for (final dimension in <NarrativeSemanticDimension>[
      NarrativeSemanticDimension.dramaticEngineFamily,
      NarrativeSemanticDimension.conflictMechanism,
      NarrativeSemanticDimension.choiceMechanism,
    ]) {
      right[dimension] = left[dimension]!;
    }

    final comparison = compareSemanticFingerprints(
      _synthetic('below-a-left', 'surface A', left),
      _synthetic('below-a-right', 'surface B', right),
    );
    expect(comparison.sameDramaticEngine, isTrue);
    expect(comparison.coreMatchCount, 3);
    expect(comparison.ruleA, isFalse);
    expect(comparison.ruleB, isFalse);
  });

  test('Rule B blocks exactly four CORE matches with different dramatic engines', () {
    final left = _cloneGold('beijing-summer-palace');
    final right = _cloneGold('shanghai-bund');
    for (final dimension in <NarrativeSemanticDimension>[
      NarrativeSemanticDimension.openingMechanism,
      NarrativeSemanticDimension.conflictMechanism,
      NarrativeSemanticDimension.choiceMechanism,
      NarrativeSemanticDimension.climaxMechanism,
    ]) {
      right[dimension] = left[dimension]!;
    }

    final comparison = compareSemanticFingerprints(
      _synthetic('rule-b-left', 'surface A', left),
      _synthetic('rule-b-right', 'surface B', right),
    );
    expect(comparison.sameDramaticEngine, isFalse);
    expect(comparison.coreMatchCount, 4);
    expect(comparison.ruleB, isTrue);
    expect(comparison.isCollision, isTrue);
  });

  test('current approved Gold audit covers all 21 unique pairs deterministically', () {
    final first = auditApprovedGoldSemanticPairs();
    final second = auditApprovedGoldSemanticPairs();
    expect(first, hasLength(21));
    expect(
      first.map((item) => _pairKey(item.journeyA, item.journeyB)).toSet().length,
      21,
    );
    expect(
      first.map((item) =>
          '${_pairKey(item.journeyA, item.journeyB)}|'
          '${item.matchingCoreDimensions.map((d) => d.name).join(',')}|'
          '${item.matchingSecondaryDimensions.map((d) => d.name).join(',')}|'
          '${item.classification.name}').toList(),
      second.map((item) =>
          '${_pairKey(item.journeyA, item.journeyB)}|'
          '${item.matchingCoreDimensions.map((d) => d.name).join(',')}|'
          '${item.matchingSecondaryDimensions.map((d) => d.name).join(',')}|'
          '${item.classification.name}').toList(),
    );
  });

  test('existing approved collisions are surfaced as debt instead of hidden', () {
    final debtKeys = auditApprovedGoldSemanticPairs()
        .where((item) =>
            item.classification ==
            SemanticCollisionClassification.existingSemanticCollisionDebt)
        .map((item) => _pairKey(item.journeyA, item.journeyB))
        .toSet();

    expect(debtKeys, <String>{
      'beijing-forbidden-city|nanjing-qinhuai-river',
      'chengdu-kuanzhai-alley|hangzhou-west-lake',
    });
  });

  test('Forbidden City vs Nanjing exposes responsible-refusal mechanism reuse', () {
    final comparison = _pair(
      'beijing-forbidden-city',
      'nanjing-qinhuai-river',
    );
    expect(comparison.sameDramaticEngine, isTrue);
    expect(comparison.isCollision, isTrue);
    expect(
      comparison.classification,
      SemanticCollisionClassification.existingSemanticCollisionDebt,
    );
    expect(
      comparison.matchingCoreDimensions,
      containsAll(<NarrativeSemanticDimension>[
        NarrativeSemanticDimension.conflictMechanism,
        NarrativeSemanticDimension.choiceMechanism,
        NarrativeSemanticDimension.consequenceMechanism,
        NarrativeSemanticDimension.transformationMechanism,
        NarrativeSemanticDimension.endingMechanism,
        NarrativeSemanticDimension.dramaticEngineFamily,
      ]),
    );
  });

  test('Hangzhou vs Chengdu exposes evidence-driven reclassification reuse', () {
    final comparison = _pair(
      'hangzhou-west-lake',
      'chengdu-kuanzhai-alley',
    );
    expect(comparison.sameDramaticEngine, isTrue);
    expect(comparison.isCollision, isTrue);
    expect(
      comparison.classification,
      SemanticCollisionClassification.existingSemanticCollisionDebt,
    );
    expect(
      comparison.matchingCoreDimensions,
      containsAll(<NarrativeSemanticDimension>[
        NarrativeSemanticDimension.relationshipGeometry,
        NarrativeSemanticDimension.conflictMechanism,
        NarrativeSemanticDimension.choiceMechanism,
        NarrativeSemanticDimension.climaxMechanism,
        NarrativeSemanticDimension.consequenceMechanism,
        NarrativeSemanticDimension.transformationMechanism,
        NarrativeSemanticDimension.endingMechanism,
        NarrativeSemanticDimension.dramaticEngineFamily,
      ]),
    );
  });

  test('Summer Palace is distinct from responsible-refusal/incompletion family', () {
    for (final other in <String>[
      'beijing-forbidden-city',
      'nanjing-qinhuai-river',
    ]) {
      final comparison = _pair('beijing-summer-palace', other);
      expect(comparison.sameDramaticEngine, isFalse, reason: other);
      expect(comparison.isCollision, isFalse, reason: other);
    }
  });

  test('Shanghai and Xi an remain distinct from every other current Gold Journey', () {
    final audit = auditApprovedGoldSemanticPairs();
    for (final id in <String>['shanghai-bund', 'xian-city-wall']) {
      final comparisons =
          audit.where((item) => item.journeyA == id || item.journeyB == id);
      expect(
        comparisons.every((item) => !item.isCollision),
        isTrue,
        reason: id,
      );
    }
  });

  test('future Gold collision is hard blocking with no candidate-specific bypass', () {
    final reference =
        approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final disguised = _synthetic(
      'future-gold-probe',
      'different city / name / profession / object / descriptive wording',
      Map.from(reference.mechanisms),
    );

    final result = evaluateFutureGoldSemanticCandidate(disguised);
    expect(result.isGoldReady, isFalse);
    expect(result.status, semanticTemplateCollisionNotGoldReady);
    expect(result.comparisons.any((item) => item.isCollision), isTrue);
  });

  test('normalized Difference Matrix resolves from the canonical registry', () {
    final shanghai = approvedGoldSemanticFingerprints['shanghai-bund']!;
    final matrix = semanticDifferenceMatrixAgainstApprovedGold(shanghai);
    expect(matrix, hasLength(6));
    expect(
      matrix.map((item) => item.journeyB).toSet(),
      _goldIds.difference(<String>{'shanghai-bund'}),
    );
    expect(matrix.every((item) => item.journeyA == 'shanghai-bund'), isTrue);
  });
}
