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

JourneySemanticFingerprint _replaceEvidence(
  JourneySemanticFingerprint source,
  NarrativeMechanismEvidence replacement,
) =>
    JourneySemanticFingerprint(
      journeyId: source.journeyId,
      surfaceIdentity: source.surfaceIdentity,
      mechanisms: source.mechanisms,
      coreEvidence: List<NarrativeMechanismEvidence>.unmodifiable([
        for (final evidence in source.coreEvidence)
          if (evidence.dimension == replacement.dimension)
            replacement
          else
            evidence,
      ]),
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

  test('every CORE evidence record satisfies provenance and rationale contract', () {
    for (final fingerprint in approvedGoldSemanticFingerprints.values) {
      expect(
        fingerprint.coreEvidence.length,
        narrativeSemanticCoreDimensions.length,
        reason: fingerprint.journeyId,
      );
      expect(
        semanticEvidenceContractErrors(fingerprint),
        isEmpty,
        reason: fingerprint.journeyId,
      );
      final activeStory = activeCanonicalGoldStoryText(fingerprint.journeyId);
      for (final evidence in fingerprint.coreEvidence) {
        expect(evidence.journeyId, fingerprint.journeyId);
        expect(evidence.activeSourceId, activeGoldStorySourceId);
        expect(evidence.sourceTexts, isNotEmpty);
        expect(evidence.semanticRationale.trim(), isNotEmpty);
        expect(evidence.mechanism, fingerprint.mechanism(evidence.dimension));
        for (final sourceText in evidence.sourceTexts) {
          expect(sourceText.trim(), isNotEmpty);
          expect(
            activeStory,
            contains(sourceText),
            reason:
                '${fingerprint.journeyId}:${evidence.dimension.name}:$sourceText',
          );
        }
      }
    }
  });

  test('multi-span evidence resolves every cited span to the active Story', () {
    var multiSpanRecords = 0;
    for (final fingerprint in approvedGoldSemanticFingerprints.values) {
      final activeStory = activeCanonicalGoldStoryText(fingerprint.journeyId);
      for (final evidence in fingerprint.coreEvidence) {
        if (evidence.sourceTexts.length > 1) multiSpanRecords++;
        for (final sourceText in evidence.sourceTexts) {
          expect(activeStory, contains(sourceText));
        }
      }
    }
    expect(multiSpanRecords, greaterThan(0));
  });

  test('empty semantic rationale fails evidence-contract completeness', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final original = source.coreEvidence.firstWhere(
      (evidence) =>
          evidence.dimension == NarrativeSemanticDimension.choiceMechanism,
    );
    final invalid = _replaceEvidence(
      source,
      NarrativeMechanismEvidence(
        journeyId: original.journeyId,
        dimension: original.dimension,
        mechanism: original.mechanism,
        activeSourceId: original.activeSourceId,
        sourceTexts: original.sourceTexts,
        semanticRationale: '',
      ),
    );

    expect(
      semanticEvidenceContractErrors(invalid),
      contains(
        'beijing-forbidden-city:choiceMechanism:missing-semantic-rationale',
      ),
    );
  });

  test('missing Story evidence fails evidence-contract completeness', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final original = source.coreEvidence.firstWhere(
      (evidence) =>
          evidence.dimension == NarrativeSemanticDimension.choiceMechanism,
    );
    final invalid = _replaceEvidence(
      source,
      NarrativeMechanismEvidence(
        journeyId: original.journeyId,
        dimension: original.dimension,
        mechanism: original.mechanism,
        activeSourceId: original.activeSourceId,
        sourceTexts: const [],
        semanticRationale:
            'The rationale is present, but there is no active Story evidence.',
      ),
    );

    expect(
      semanticEvidenceContractErrors(invalid),
      contains('beijing-forbidden-city:choiceMechanism:missing-source-text'),
    );
  });

  test('legacy Forbidden City Story evidence fails active provenance', () {
    const abandonedMaintenanceStory = '纪衡在午门内收到雷雨预警。';
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final original = source.coreEvidence.firstWhere(
      (evidence) =>
          evidence.dimension == NarrativeSemanticDimension.choiceMechanism,
    );
    final active = activeCanonicalGoldStoryText(source.journeyId);
    expect(active, isNot(contains(abandonedMaintenanceStory)));

    final invalid = _replaceEvidence(
      source,
      NarrativeMechanismEvidence(
        journeyId: original.journeyId,
        dimension: original.dimension,
        mechanism: original.mechanism,
        activeSourceId: original.activeSourceId,
        sourceTexts: const [abandonedMaintenanceStory],
        semanticRationale:
            'A non-empty rationale cannot make abandoned Story prose active evidence.',
      ),
    );

    expect(
      semanticEvidenceContractErrors(invalid),
      contains(
        'beijing-forbidden-city:choiceMechanism:source-not-in-active-story-0',
      ),
    );
    expect(
      source.coreEvidence.any(
        (evidence) => evidence.sourceTexts.contains(abandonedMaintenanceStory),
      ),
      isFalse,
    );
  });

  test('evidence mechanism metadata must stay aligned with fingerprint mechanism', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final original = source.coreEvidence.firstWhere(
      (evidence) =>
          evidence.dimension == NarrativeSemanticDimension.choiceMechanism,
    );
    final invalid = _replaceEvidence(
      source,
      NarrativeMechanismEvidence(
        journeyId: original.journeyId,
        dimension: original.dimension,
        mechanism: NarrativeMechanismFamily.carryPastObjectIntoChosenFuture,
        activeSourceId: original.activeSourceId,
        sourceTexts: original.sourceTexts,
        semanticRationale: original.semanticRationale,
      ),
    );

    expect(
      semanticEvidenceContractErrors(invalid),
      contains('beijing-forbidden-city:choiceMechanism:mechanism-mismatch'),
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
        semanticEvidenceContractErrors(fingerprint),
        isEmpty,
        reason: record.journeyId,
      );
    }
  });

  test('Hangzhou relationship evidence shows internal-model solo fieldwork', () {
    final fingerprint = approvedGoldSemanticFingerprints['hangzhou-west-lake']!;
    final evidence = fingerprint.coreEvidence.singleWhere(
      (item) =>
          item.dimension == NarrativeSemanticDimension.relationshipGeometry,
    );
    expect(evidence.sourceTexts.length, greaterThanOrEqualTo(2));
    expect(evidence.sourceTexts.join('\n'), contains('私下又加了一条标准'));
    expect(evidence.sourceTexts.join('\n'), contains('桥上人流'));
    expect(evidence.semanticRationale, contains('no mentor'));
  });

  test('Hangzhou cultural anchor evidence is causal rather than a bare landmark', () {
    final fingerprint = approvedGoldSemanticFingerprints['hangzhou-west-lake']!;
    final evidence = fingerprint.coreEvidence.singleWhere(
      (item) =>
          item.dimension == NarrativeSemanticDimension.culturalAnchorFunction,
    );
    expect(evidence.sourceTexts.join('\n'), contains('湖水治理和人工营造'));
    expect(evidence.sourceTexts.join('\n'), contains('文化景观'));
    expect(evidence.sourceTexts, isNot(equals(const ['苏堤'])));
    expect(evidence.semanticRationale, contains('disproves'));
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

  test('Rule A and Rule B named thresholds remain unchanged', () {
    expect(semanticCollisionSameEngineAdditionalCoreThreshold, 3);
    expect(semanticCollisionIndependentCoreThreshold, 4);
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
