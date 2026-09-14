import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_language_level_agent.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';

const _pendingFounderReviewId = 'beijing-forbidden-city';

const _goldIds = <String>{
  'beijing-summer-palace',
  'shanghai-bund',
  'xian-city-wall',
  'hangzhou-west-lake',
  'chengdu-kuanzhai-alley',
  'nanjing-qinhuai-river',
  'guangzhou-chen-clan-academy',
  'suzhou-humble-administrators-garden',
  'luoyang-longmen-grottoes',
  'jiangmen-kaiping-diaolou',
  'datong-yungang-grottoes',
  'lijiang-old-town',
  'honghe-hani-rice-terraces',
};

Map<String, JourneySemanticFingerprint> get _founderApprovedGoldFingerprints =>
    Map<String, JourneySemanticFingerprint>.unmodifiable({
      for (final entry in approvedGoldSemanticFingerprints.entries)
        if (entry.key != _pendingFounderReviewId) entry.key: entry.value,
    });

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

String _activeForbiddenCityStory() {
  const agent = PhoenixLanguageLevelAgent();
  final journey = requireDailyJourneyExperience(forbiddenCityJourneyId);
  return <String>[
    for (final profile in agent.allProfiles)
      resolveAdaptiveJourneyLevel(journey, profile: profile)
          .storyParagraphs
          .join('\n\n'),
  ].join('\n');
}

void main() {
  test('Founder-approved Gold Journeys keep complete normalized fingerprints', () {
    expect(_founderApprovedGoldFingerprints.keys.toSet(), _goldIds);
    expect(approvedGoldSemanticFingerprints, contains(_pendingFounderReviewId));
    for (final fingerprint in _founderApprovedGoldFingerprints.values) {
      expect(fingerprint.mechanisms.length, NarrativeSemanticDimension.values.length,
          reason: fingerprint.journeyId);
      expect(semanticFingerprintCompletenessErrors(fingerprint), isEmpty,
          reason: fingerprint.journeyId);
      expect(semanticEvidenceContractErrors(fingerprint), isEmpty,
          reason: fingerprint.journeyId);
    }
  });

  test('every Founder-approved CORE evidence record preserves provenance and rationale contract', () {
    for (final fingerprint in _founderApprovedGoldFingerprints.values) {
      final activeStory = activeCanonicalGoldStoryText(fingerprint.journeyId);
      expect(fingerprint.coreEvidence.length, narrativeSemanticCoreDimensions.length,
          reason: fingerprint.journeyId);
      for (final evidence in fingerprint.coreEvidence) {
        expect(evidence.journeyId, fingerprint.journeyId);
        expect(evidence.activeSourceId, activeGoldStorySourceId);
        expect(evidence.sourceTexts, isNotEmpty);
        expect(evidence.semanticRationale.trim(), isNotEmpty);
        expect(evidence.mechanism, fingerprint.mechanism(evidence.dimension));
        for (final sourceText in evidence.sourceTexts) {
          expect(sourceText.trim(), isNotEmpty);
          expect(activeStory, contains(sourceText),
              reason: '${fingerprint.journeyId}:${evidence.dimension.name}:$sourceText');
        }
      }
    }
  });

  test('multi-span evidence resolves every cited span to active Founder-approved Story', () {
    var multiSpanRecords = 0;
    for (final fingerprint in _founderApprovedGoldFingerprints.values) {
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

  test('empty semantic rationale still fails deterministic contract', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final original = source.coreEvidence.first;
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
    expect(semanticEvidenceContractErrors(invalid),
        contains('${source.journeyId}:${original.dimension.name}:missing-semantic-rationale'));
  });

  test('missing Story evidence still fails deterministic contract', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final original = source.coreEvidence.first;
    final invalid = _replaceEvidence(
      source,
      NarrativeMechanismEvidence(
        journeyId: original.journeyId,
        dimension: original.dimension,
        mechanism: original.mechanism,
        activeSourceId: original.activeSourceId,
        sourceTexts: const [],
        semanticRationale: original.semanticRationale,
      ),
    );
    expect(semanticEvidenceContractErrors(invalid),
        contains('${source.journeyId}:${original.dimension.name}:missing-source-text'));
  });

  test('legacy Forbidden City refusal Story cannot satisfy active provenance', () {
    const abandonedStory = '于是沈砚停下，没有跨过门槛。';
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final original = source.coreEvidence.firstWhere(
      (item) => item.dimension == NarrativeSemanticDimension.choiceMechanism,
    );
    expect(_activeForbiddenCityStory(), isNot(contains(abandonedStory)));
    final invalid = _replaceEvidence(
      source,
      NarrativeMechanismEvidence(
        journeyId: original.journeyId,
        dimension: original.dimension,
        mechanism: original.mechanism,
        activeSourceId: original.activeSourceId,
        sourceTexts: const [abandonedStory],
        semanticRationale: 'Legacy prose cannot become active evidence.',
      ),
    );
    expect(
      semanticEvidenceContractErrors(invalid),
      contains('beijing-forbidden-city:choiceMechanism:source-not-in-active-story-0'),
    );
  });

  test('evidence mechanism metadata must remain aligned', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final original = source.coreEvidence.firstWhere(
      (item) => item.dimension == NarrativeSemanticDimension.choiceMechanism,
    );
    final invalid = _replaceEvidence(
      source,
      NarrativeMechanismEvidence(
        journeyId: original.journeyId,
        dimension: original.dimension,
        mechanism: NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut,
        activeSourceId: original.activeSourceId,
        sourceTexts: original.sourceTexts,
        semanticRationale: original.semanticRationale,
      ),
    );
    expect(semanticEvidenceContractErrors(invalid),
        contains('beijing-forbidden-city:choiceMechanism:mechanism-mismatch'));
  });

  test('Forbidden City descriptive DNA matches current pending-Founder-review Story', () {
    final record = approvedNarrativeDnaCatalog.singleWhere(
      (item) => item.journeyId == 'beijing-forbidden-city',
    );
    final active = _activeForbiddenCityStory();
    expect(record.protagonistIdentity, contains('Shen-Yan'));
    expect(record.protagonistIdentity, contains('seventeen-year-old'));
    expect(record.protagonistArchetype, contains('construction-apprentice'));
    expect(record.narrativeIdentity, contains('dual-valid-route'));
    expect(record.conflictType, contains('coexisting-role-and-purpose-dependent-routes'));
    expect(record.choiceType, contains('preserve-both-valid-routes'));
    expect(record.choiceType, isNot(contains('threshold')));
    expect(record.consequenceType, isNot(contains('blank')));
    expect(record.endingMechanism, isNot(contains('wooden-ruler')));
    expect(active, contains('十七岁的营造学徒沈砚'));
    expect(active, contains('阿宁'));
    expect(active, contains('两条'));
    expect(active, contains('乾清门'));
    expect(active, contains('建筑连接'));
    expect(active, contains('人物目标'));
    expect(active, contains('行动后果'));
    expect(active, isNot(contains('旧木尺')));
    expect(active, isNot(contains('没有跨过门槛')));
  });

  test('all Founder-approved descriptive registry entries resolve to active Story evidence', () {
    final founderApprovedDna = approvedNarrativeDnaCatalog
        .where((item) => item.journeyId != _pendingFounderReviewId)
        .toList(growable: false);
    expect(founderApprovedDna.map((item) => item.journeyId).toSet(), _goldIds);
    for (final record in founderApprovedDna) {
      final activeStory = activeCanonicalGoldStoryText(record.journeyId);
      final fingerprint = _founderApprovedGoldFingerprints[record.journeyId];
      expect(activeStory.trim(), isNotEmpty, reason: record.journeyId);
      expect(fingerprint, isNotNull, reason: record.journeyId);
      expect(semanticEvidenceContractErrors(fingerprint!), isEmpty,
          reason: record.journeyId);
    }
  });

  test('Hangzhou reopened evidence stays grounded in the active married-couple Story', () {
    final fingerprint = approvedGoldSemanticFingerprints['hangzhou-west-lake']!;
    final relationship = fingerprint.coreEvidence.singleWhere(
      (item) => item.dimension == NarrativeSemanticDimension.relationshipGeometry,
    );
    final cultural = fingerprint.coreEvidence.singleWhere(
      (item) => item.dimension == NarrativeSemanticDimension.culturalAnchorFunction,
    );
    expect(relationship.sourceTexts.join('\n'), contains('结婚四十三年'));
    expect(relationship.semanticRationale, contains('marriage'));
    expect(cultural.sourceTexts.join('\n'), contains('断桥残雪'));
    expect(cultural.semanticRationale, contains('place, season'));
  });

  test('wording disguise cannot evade normalized semantic collision', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final a = _synthetic('north-probe', 'surface A', Map.from(source.mechanisms));
    final b = _synthetic('south-probe', 'surface B', Map.from(source.mechanisms));
    final comparison = compareSemanticFingerprints(a, b);
    expect(comparison.sameDramaticEngine, isTrue);
    expect(comparison.isCollision, isTrue);
    expect(comparison.classification, SemanticCollisionClassification.semanticCollision);
  });

  test('surface similarity alone still cannot create a false collision', () {
    final a = _synthetic('surface-a', 'same surface', _cloneGold('beijing-summer-palace'));
    final b = _synthetic('surface-b', 'same surface', _cloneGold('shanghai-bund'));
    final comparison = compareSemanticFingerprints(a, b);
    expect(comparison.coreMatchCount, 0);
    expect(comparison.isCollision, isFalse);
  });

  test('Rule A and Rule B thresholds remain unchanged', () {
    expect(semanticCollisionSameEngineAdditionalCoreThreshold, 3);
    expect(semanticCollisionIndependentCoreThreshold, 4);
  });

  test('Rule A blocks same engine plus exactly three additional CORE matches', () {
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
      _synthetic('rule-a-left', 'A', left),
      _synthetic('rule-a-right', 'B', right),
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
      _synthetic('below-a-left', 'A', left),
      _synthetic('below-a-right', 'B', right),
    );
    expect(comparison.ruleA, isFalse);
    expect(comparison.ruleB, isFalse);
  });

  test('Rule B blocks exactly four CORE matches with different engines', () {
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
      _synthetic('rule-b-left', 'A', left),
      _synthetic('rule-b-right', 'B', right),
    );
    expect(comparison.sameDramaticEngine, isFalse);
    expect(comparison.coreMatchCount, 4);
    expect(comparison.ruleB, isTrue);
  });

  test('current semantic audit remains pair-complete and deterministic', () {
    final first = auditApprovedGoldSemanticPairs();
    final second = auditApprovedGoldSemanticPairs();
    final count = approvedGoldSemanticFingerprints.length;
    expect(first, hasLength(count * (count - 1) ~/ 2));
    expect(
      first.map((item) => _pairKey(item.journeyA, item.journeyB)).toSet().length,
      count * (count - 1) ~/ 2,
    );
    expect(
      first.map((item) =>
          '${_pairKey(item.journeyA, item.journeyB)}|${item.matchingCoreDimensions.map((d) => d.name).join(',')}|${item.classification.name}').toList(),
      second.map((item) =>
          '${_pairKey(item.journeyA, item.journeyB)}|${item.matchingCoreDimensions.map((d) => d.name).join(',')}|${item.classification.name}').toList(),
    );
  });

  test('no historical semantic collision debt remains', () {
    final debts = auditApprovedGoldSemanticPairs().where(
      (item) => item.classification == SemanticCollisionClassification.existingSemanticCollisionDebt,
    );
    expect(debts, isEmpty);
    expect(auditApprovedGoldSemanticPairs().where((item) => item.isCollision), isEmpty);
  });

  test('Forbidden City pending-review candidate vs Nanjing triggers neither Rule A nor Rule B', () {
    final comparison = _pair('beijing-forbidden-city', 'nanjing-qinhuai-river');
    expect(comparison.sameDramaticEngine, isFalse);
    expect(comparison.ruleA, isFalse);
    expect(comparison.ruleB, isFalse);
    expect(comparison.isCollision, isFalse);
    expect(
      comparison.matchingCoreDimensions,
      isNot(contains(NarrativeSemanticDimension.dramaticEngineFamily)),
    );
  });

  test('Forbidden City pending-review candidate collides with no comparison Journey', () {
    final comparisons = auditApprovedGoldSemanticPairs().where(
      (item) => item.journeyA == 'beijing-forbidden-city' || item.journeyB == 'beijing-forbidden-city',
    );
    expect(comparisons, hasLength(approvedGoldSemanticFingerprints.length - 1));
    expect(comparisons.every((item) => !item.isCollision), isTrue);
  });

  test('Forbidden City engine is synthesis, not refusal or reclassification', () {
    final fingerprint = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    expect(
      fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
      NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel,
    );
    expect(
      fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
      isNot(NarrativeMechanismFamily.responsibleRefusalOfAvailableShortcut),
    );
    expect(
      fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
      isNot(NarrativeMechanismFamily.evidenceForcesReclassification),
    );
  });

  test('Chengdu engine is repeated spatial handoff, not evidence reclassification', () {
    final fingerprint = approvedGoldSemanticFingerprints['chengdu-kuanzhai-alley']!;
    expect(
      fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
      NarrativeMechanismFamily.repeatedSpatialHandoffsCreateSharedUseProtocol,
    );
    expect(
      fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily),
      isNot(NarrativeMechanismFamily.evidenceForcesReclassification),
    );
  });

  test('Hangzhou vs Chengdu is structurally distinct after Chengdu remediation', () {
    final comparison = _pair('hangzhou-west-lake', 'chengdu-kuanzhai-alley');
    expect(comparison.sameDramaticEngine, isFalse);
    expect(comparison.coreMatchCount, 0);
    expect(comparison.ruleA, isFalse);
    expect(comparison.ruleB, isFalse);
    expect(comparison.isCollision, isFalse);
    expect(comparison.classification, SemanticCollisionClassification.distinct);
  });

  test('Chengdu collides with no other semantic comparison Journey', () {
    final comparisons = auditApprovedGoldSemanticPairs().where(
      (item) => item.journeyA == 'chengdu-kuanzhai-alley' || item.journeyB == 'chengdu-kuanzhai-alley',
    );
    expect(comparisons, hasLength(approvedGoldSemanticFingerprints.length - 1));
    expect(comparisons.every((item) => !item.isCollision), isTrue);
  });

  test('Guangzhou collides with no other semantic comparison Journey', () {
    final comparisons = auditApprovedGoldSemanticPairs().where(
      (item) => item.journeyA == 'guangzhou-chen-clan-academy' || item.journeyB == 'guangzhou-chen-clan-academy',
    );
    expect(comparisons, hasLength(approvedGoldSemanticFingerprints.length - 1));
    expect(comparisons.every((item) => !item.ruleA), isTrue);
    expect(comparisons.every((item) => !item.ruleB), isTrue);
    expect(comparisons.every((item) => !item.isCollision), isTrue);
  });

  test('Guangzhou engine protects present identity over public kinship proof', () {
    final fingerprint = approvedGoldSemanticFingerprints['guangzhou-chen-clan-academy']!;
    final engine = fingerprint.mechanism(NarrativeSemanticDimension.dramaticEngineFamily);
    expect(engine, NarrativeMechanismFamily.publicKinshipProofSacrificedForPresentIdentity);
    expect(engine, isNot(NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship));
    expect(engine, isNot(NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel));
    expect(engine, isNot(NarrativeMechanismFamily.spatialCrossingReframesTemporalContinuity));
    expect(engine, isNot(NarrativeMechanismFamily.completedClosureBecomesOpenContinuation));
    expect(engine, isNot(NarrativeMechanismFamily.evidenceForcesReclassification));
    expect(engine, isNot(NarrativeMechanismFamily.repeatedSpatialHandoffsCreateSharedUseProtocol));
    expect(engine, isNot(NarrativeMechanismFamily.operationalRefusalLeavesVisibleIncompletion));
  });

  test('future colliding candidate still hard-blocks with exact status', () {
    final source = approvedGoldSemanticFingerprints['beijing-forbidden-city']!;
    final candidate = _synthetic(
      'future-collision-probe',
      'different city, names, professions, and objects',
      Map.from(source.mechanisms),
    );
    final result = evaluateFutureGoldSemanticCandidate(candidate);
    expect(result.isGoldReady, isFalse);
    expect(result.status, 'TEMPLATE COLLISION - NOT GOLD READY');
  });
}
