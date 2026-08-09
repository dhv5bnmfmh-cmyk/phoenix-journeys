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

Map<NarrativeSemanticDimension, NarrativeMechanismFamily> _baseMechanisms() => {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.deadlineWithIdealizedTarget,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.creatorProvingIndependentJudgment,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.intergenerationalMentorToRecognizedAgency,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.produceIdealArtifact,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.aestheticPerfectionVsRelationalTrace,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.sacrificeIdealResultToPreserveRelationalEvidence,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.forcedTradeoffCreatesNewFrame,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.sacrificedIdealCreatesAlternativeArtifact,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.independenceReframedAsTraceableResponsibility,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.intergenerationalObjectEntrustment,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.restorationTraceMakesTimeReadable,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.inheritedPhotographForcesRelationalChoice,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.vantageSearchThenRecomposition,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.expiringCreativeOpportunity,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.elderEmbodiesPriorKnowledgeThenEntrusts,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship,
    };

JourneySemanticFingerprint _synthetic(
  String id,
  String surface,
  Map<NarrativeSemanticDimension, NarrativeMechanismFamily> mechanisms,
) =>
    JourneySemanticFingerprint(
      journeyId: id,
      surfaceIdentity: surface,
      mechanisms: Map.unmodifiable(mechanisms),
      coreEvidence: const [],
    );

NarrativeSemanticComparison _pair(String a, String b) {
  final audit = auditApprovedGoldSemanticPairs();
  return audit.singleWhere(
    (item) =>
        (item.journeyA == a && item.journeyB == b) ||
        (item.journeyA == b && item.journeyB == a),
  );
}

void main() {
  test('all seven approved Gold Journeys have complete normalized fingerprints', () {
    expect(approvedGoldSemanticFingerprints.keys.toSet(), _goldIds);
    for (final fingerprint in approvedGoldSemanticFingerprints.values) {
      expect(fingerprint.mechanisms.length, NarrativeSemanticDimension.values.length);
      expect(semanticFingerprintCompletenessErrors(fingerprint), isEmpty,
          reason: fingerprint.journeyId);
      for (final dimension in narrativeSemanticCoreDimensions) {
        expect(fingerprint.mechanisms[dimension], isNotNull,
            reason: '${fingerprint.journeyId}:${dimension.name}');
      }
    }
  });

  test('every CORE evidence record is exact text from the active production Story package', () {
    for (final fingerprint in approvedGoldSemanticFingerprints.values) {
      expect(fingerprint.coreEvidence.length, narrativeSemanticCoreDimensions.length);
      expect(semanticEvidenceFidelityErrors(fingerprint), isEmpty,
          reason: fingerprint.journeyId);
      final activeStory = activeCanonicalGoldStoryText(fingerprint.journeyId);
      for (final evidence in fingerprint.coreEvidence) {
        expect(evidence.journeyId, fingerprint.journeyId);
        expect(activeStory, contains(evidence.sourceText));
        expect(evidence.mechanism, fingerprint.mechanism(evidence.dimension));
      }
    }
  });

  test('legacy Forbidden City Story prose cannot satisfy active Narrative DNA evidence', () {
    final active = activeCanonicalGoldStoryText('beijing-forbidden-city');
    const legacyAbandonedSource = '纪衡在午门内收到雷雨预警。';
    expect(active, isNot(contains(legacyAbandonedSource)));
    expect(
      approvedGoldSemanticFingerprints['beijing-forbidden-city']!.coreEvidence
          .any((evidence) => evidence.sourceText == legacyAbandonedSource),
      isFalse,
    );
  });

  test('Forbidden City descriptive registry reflects active Shen Yan apprentice Story', () {
    final record = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == 'beijing-forbidden-city',
    );
    final story = activeCanonicalGoldStoryText('beijing-forbidden-city');
    expect(record.protagonistIdentity, contains('Shen-Yan'));
    expect(record.protagonistIdentity, contains('seventeen-year-old'));
    expect(record.protagonistArchetype, contains('construction-apprentice'));
    expect(record.supportingStructure, contains('Zhou-Shifu'));
    expect(record.choiceType, contains('open-threshold'));
    expect(record.consequenceType, contains('map-retains-a-meaningful-blank'));
    expect(record.endingMechanism, contains('old-wooden-ruler'));
    expect(record.protagonistIdentity, isNot(contains('maintenance-worker')));
    expect(story, contains('沈砚'));
    expect(story, contains('十七岁的营造学徒沈砚'));
    expect(story, contains('周师傅'));
    expect(story, contains('地图仍留下空白'));
    expect(story, contains('旧木尺'));
  });

  test('all descriptive Gold registry IDs have active Story and semantic evidence', () {
    expect(approvedNarrativeDnaCatalog.map((item) => item.journeyId).toSet(), _goldIds);
    for (final record in approvedNarrativeDnaCatalog) {
      final activeStory = activeCanonicalGoldStoryText(record.journeyId);
      final fingerprint = approvedGoldSemanticFingerprints[record.journeyId];
      expect(activeStory.trim(), isNotEmpty, reason: record.journeyId);
      expect(fingerprint, isNotNull, reason: record.journeyId);
      expect(fingerprint!.coreEvidence, isNotEmpty, reason: record.journeyId);
      expect(semanticEvidenceFidelityErrors(fingerprint), isEmpty,
          reason: record.journeyId);
    }
  });

  test('wording disguise cannot evade normalized semantic collision', () {
    final mechanismsA = _baseMechanisms();
    final mechanismsB = Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.from(
      mechanismsA,
    );
    final a = _synthetic(
      'harbor-restoration-probe',
      'Mei / harbor engineer / brass compass / northern city',
      mechanismsA,
    );
    final b = _synthetic(
      'mountain-archive-probe',
      'Arun / museum intern / paper ledger / southern town',
      mechanismsB,
    );
    final result = compareSemanticFingerprints(a, b);
    expect(a.surfaceIdentity, isNot(equals(b.surfaceIdentity)));
    expect(result.isCollision, isTrue);
    expect(result.classification, SemanticCollisionClassification.semanticCollision);
    expect(result.coreMatchCount, narrativeSemanticCoreDimensions.length);
  });

  test('surface similarity alone does not create a false semantic collision', () {
    final a = _synthetic(
      'surface-a',
      'young / third-person / one-day / heritage / physical-object',
      _baseMechanisms(),
    );
    final mechanismsB = {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.lifeTransitionWithCarriedPast,
      // Deliberately same incidental role pattern.
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.creatorProvingIndependentJudgment,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.parentChildContinuityWithoutCareerControl,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.crossIntoNewRoleWithoutPast,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.ruptureVsContinuity,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.carryPastObjectIntoChosenFuture,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.spatialCrossingTriggersContinuityRecognition,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.carriedObjectCrossesIdentityBoundary,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.cleanBreakModelToContinuityModel,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.arrivalWithCarriedContinuityObject,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.riverFlowConnectsCommercialEras,
      // Deliberately both contain a meaningful physical object, but with a
      // different narrative function.
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.carriedTradeDocumentConnectsEras,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.oneWayCrossingBetweenContrastedBanks,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.nextDayLifeTransition,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.parentOffersObjectWithoutBlockingDeparture,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.spatialCrossingReframesTemporalContinuity,
    };
    final b = _synthetic(
      'surface-b',
      'young / third-person / one-day / heritage / physical-object',
      mechanismsB,
    );
    final result = compareSemanticFingerprints(a, b);
    expect(result.isCollision, isFalse);
    expect(result.coreMatchCount, 0);
    expect(result.classification, SemanticCollisionClassification.relatedButDistinct);
  });

  test('Rule A blocks same dramatic engine plus exactly three additional CORE matches', () {
    final leftMechanisms = _baseMechanisms();
    final rightMechanisms = Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.from(
      {
        NarrativeSemanticDimension.openingMechanism:
            NarrativeMechanismFamily.lifeTransitionWithCarriedPast,
        NarrativeSemanticDimension.protagonistRolePattern:
            NarrativeMechanismFamily.youngProfessionalAtTransition,
        NarrativeSemanticDimension.relationshipGeometry:
            NarrativeMechanismFamily.parentChildContinuityWithoutCareerControl,
        NarrativeSemanticDimension.goalMechanism:
            NarrativeMechanismFamily.crossIntoNewRoleWithoutPast,
        NarrativeSemanticDimension.conflictMechanism:
            NarrativeMechanismFamily.aestheticPerfectionVsRelationalTrace,
        NarrativeSemanticDimension.choiceMechanism:
            NarrativeMechanismFamily.sacrificeIdealResultToPreserveRelationalEvidence,
        NarrativeSemanticDimension.climaxMechanism:
            NarrativeMechanismFamily.forcedTradeoffCreatesNewFrame,
        NarrativeSemanticDimension.consequenceMechanism:
            NarrativeMechanismFamily.carriedObjectCrossesIdentityBoundary,
        NarrativeSemanticDimension.transformationMechanism:
            NarrativeMechanismFamily.cleanBreakModelToContinuityModel,
        NarrativeSemanticDimension.endingMechanism:
            NarrativeMechanismFamily.arrivalWithCarriedContinuityObject,
        NarrativeSemanticDimension.culturalAnchorFunction:
            NarrativeMechanismFamily.riverFlowConnectsCommercialEras,
        NarrativeSemanticDimension.artifactObjectNarrativeFunction:
            NarrativeMechanismFamily.carriedTradeDocumentConnectsEras,
        NarrativeSemanticDimension.movementSpatialMechanism:
            NarrativeMechanismFamily.oneWayCrossingBetweenContrastedBanks,
        NarrativeSemanticDimension.temporalPressureMechanism:
            NarrativeMechanismFamily.nextDayLifeTransition,
        NarrativeSemanticDimension.supportingCharacterFunction:
            NarrativeMechanismFamily.parentOffersObjectWithoutBlockingDeparture,
        NarrativeSemanticDimension.dramaticEngineFamily:
            NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship,
      },
    );
    final result = compareSemanticFingerprints(
      _synthetic('rule-a-left', 'A', leftMechanisms),
      _synthetic('rule-a-right', 'B', rightMechanisms),
    );
    expect(result.sameDramaticEngine, isTrue);
    expect(result.coreMatchCount, 4);
    expect(result.ruleA, isTrue);
    expect(result.isCollision, isTrue);
  });

  test('Rule A does not trigger below three additional CORE matches', () {
    final right = {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.lifeTransitionWithCarriedPast,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.youngProfessionalAtTransition,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.parentChildContinuityWithoutCareerControl,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.crossIntoNewRoleWithoutPast,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.aestheticPerfectionVsRelationalTrace,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.sacrificeIdealResultToPreserveRelationalEvidence,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.spatialCrossingTriggersContinuityRecognition,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.carriedObjectCrossesIdentityBoundary,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.cleanBreakModelToContinuityModel,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.arrivalWithCarriedContinuityObject,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.riverFlowConnectsCommercialEras,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.carriedTradeDocumentConnectsEras,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.oneWayCrossingBetweenContrastedBanks,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.nextDayLifeTransition,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.parentOffersObjectWithoutBlockingDeparture,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship,
    };
    final result = compareSemanticFingerprints(
      _synthetic('below-a-left', 'A', _baseMechanisms()),
      _synthetic('below-a-right', 'B', right),
    );
    expect(result.sameDramaticEngine, isTrue);
    expect(result.coreMatchCount, 3);
    expect(result.ruleA, isFalse);
    expect(result.ruleB, isFalse);
  });

  test('Rule B blocks exactly four CORE matches even with different dramatic engines', () {
    final right = {
      NarrativeSemanticDimension.openingMechanism:
          NarrativeMechanismFamily.deadlineWithIdealizedTarget,
      NarrativeSemanticDimension.protagonistRolePattern:
          NarrativeMechanismFamily.youngProfessionalAtTransition,
      NarrativeSemanticDimension.relationshipGeometry:
          NarrativeMechanismFamily.intergenerationalMentorToRecognizedAgency,
      NarrativeSemanticDimension.goalMechanism:
          NarrativeMechanismFamily.crossIntoNewRoleWithoutPast,
      NarrativeSemanticDimension.conflictMechanism:
          NarrativeMechanismFamily.aestheticPerfectionVsRelationalTrace,
      NarrativeSemanticDimension.choiceMechanism:
          NarrativeMechanismFamily.sacrificeIdealResultToPreserveRelationalEvidence,
      NarrativeSemanticDimension.climaxMechanism:
          NarrativeMechanismFamily.spatialCrossingTriggersContinuityRecognition,
      NarrativeSemanticDimension.consequenceMechanism:
          NarrativeMechanismFamily.carriedObjectCrossesIdentityBoundary,
      NarrativeSemanticDimension.transformationMechanism:
          NarrativeMechanismFamily.cleanBreakModelToContinuityModel,
      NarrativeSemanticDimension.endingMechanism:
          NarrativeMechanismFamily.arrivalWithCarriedContinuityObject,
      NarrativeSemanticDimension.culturalAnchorFunction:
          NarrativeMechanismFamily.riverFlowConnectsCommercialEras,
      NarrativeSemanticDimension.artifactObjectNarrativeFunction:
          NarrativeMechanismFamily.carriedTradeDocumentConnectsEras,
      NarrativeSemanticDimension.movementSpatialMechanism:
          NarrativeMechanismFamily.oneWayCrossingBetweenContrastedBanks,
      NarrativeSemanticDimension.temporalPressureMechanism:
          NarrativeMechanismFamily.nextDayLifeTransition,
      NarrativeSemanticDimension.supportingCharacterFunction:
          NarrativeMechanismFamily.parentOffersObjectWithoutBlockingDeparture,
      NarrativeSemanticDimension.dramaticEngineFamily:
          NarrativeMechanismFamily.spatialCrossingReframesTemporalContinuity,
    };
    final result = compareSemanticFingerprints(
      _synthetic('rule-b-left', 'A', _baseMechanisms()),
      _synthetic('rule-b-right', 'B', right),
    );
    expect(result.sameDramaticEngine, isFalse);
    expect(result.coreMatchCount, 4);
    expect(result.ruleB, isTrue);
    expect(result.isCollision, isTrue);
  });

  test('current approved Gold audit deterministically covers all 21 unique pairs', () {
    final audit = auditApprovedGoldSemanticPairs();
    expect(audit, hasLength(21));
    expect(
      audit.map((item) => '${item.journeyA}|${item.journeyB}').toSet().length,
      21,
    );
    expect(
      audit.every((item) =>
          item.classification != SemanticCollisionClassification.semanticCollision),
      isTrue,
      reason: 'approved collisions must be surfaced as existing debt, never hidden',
    );
  });

  test('known current-catalog collisions are surfaced as explicit existing debt', () {
    final debt = auditApprovedGoldSemanticPairs()
        .where((item) =>
            item.classification ==
            SemanticCollisionClassification.existingSemanticCollisionDebt)
        .toList();
    expect(debt, hasLength(2));
    expect(
      debt.map((item) => {item.journeyA, item.journeyB}),
      containsAll(<Set<String>>[
        {'beijing-forbidden-city', 'nanjing-qinhuai-river'},
        {'hangzhou-west-lake', 'chengdu-kuanzhai-alley'},
      ]),
    );
  });

  test('Forbidden City vs Nanjing collision exposes normalized mechanism reuse', () {
    final result = _pair('beijing-forbidden-city', 'nanjing-qinhuai-river');
    expect(result.sameDramaticEngine, isTrue);
    expect(result.isCollision, isTrue);
    expect(result.classification,
        SemanticCollisionClassification.existingSemanticCollisionDebt);
    expect(
      result.matchingCoreDimensions,
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

  test('Hangzhou vs Chengdu collision exposes evidence-driven reclassification reuse', () {
    final result = _pair('hangzhou-west-lake', 'chengdu-kuanzhai-alley');
    expect(result.sameDramaticEngine, isTrue);
    expect(result.isCollision, isTrue);
    expect(result.classification,
        SemanticCollisionClassification.existingSemanticCollisionDebt);
    expect(
      result.matchingCoreDimensions,
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

  test('Summer Palace remains structurally distinct from refusal/incompletion family', () {
    for (final other in <String>['beijing-forbidden-city', 'nanjing-qinhuai-river']) {
      final result = _pair('beijing-summer-palace', other);
      expect(result.isCollision, isFalse, reason: other);
      expect(result.sameDramaticEngine, isFalse, reason: other);
    }
  });

  test('Shanghai and Xi an remain distinct under normalized mechanism comparison', () {
    for (final id in <String>['shanghai-bund', 'xian-city-wall']) {
      final comparisons = auditApprovedGoldSemanticPairs()
          .where((item) => item.journeyA == id || item.journeyB == id);
      expect(comparisons.every((item) => !item.isCollision), isTrue,
          reason: id);
    }
  });

  test('future Gold candidate collision is hard blocking with no bypass input', () {
    final forbidden = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final disguisedCandidate = _synthetic(
      'future-gold-probe',
      'different city / different name / different profession / different object',
      Map<NarrativeSemanticDimension, NarrativeMechanismFamily>.from(
        forbidden.mechanisms,
      ),
    );
    final result = evaluateFutureGoldSemanticCandidate(disguisedCandidate);
    expect(result.isGoldReady, isFalse);
    expect(result.status, semanticTemplateCollisionNotGoldReady);
    expect(result.comparisons.any((item) => item.isCollision), isTrue);
  });

  test('semantic audit and difference matrix are deterministic', () {
    String encode(List<NarrativeSemanticComparison> items) => items
        .map((item) =>
            '${item.journeyA}|${item.journeyB}|${item.sameDramaticEngine}|'
            '${item.matchingCoreDimensions.map((d) => d.name).join(',')}|'
            '${item.matchingSecondaryDimensions.map((d) => d.name).join(',')}|'
            '${item.classification.name}')
        .join('\n');

    expect(encode(auditApprovedGoldSemanticPairs()),
        encode(auditApprovedGoldSemanticPairs()));
    final shanghai = approvedGoldSemanticFingerprints['shanghai-bund']!;
    expect(
      encode(semanticDifferenceMatrixAgainstApprovedGold(shanghai)),
      encode(semanticDifferenceMatrixAgainstApprovedGold(shanghai)),
    );
  });
}
