import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/guangzhou_chen_clan_one_pass.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';

void main() {
  test('promoted Guangzhou compares against every other Gold Journey', () {
    expect(approvedGoldSemanticFingerprints, hasLength(10));
    expect(
      approvedGoldSemanticFingerprints[guangzhouChenClanJourneyId],
      same(guangzhouChenClanGoldSemanticFingerprint),
    );

    final gate = evaluateFutureGoldSemanticCandidate(
      guangzhouChenClanGoldSemanticFingerprint,
    );
    expect(gate.comparisons, hasLength(approvedGoldSemanticFingerprints.length - 1));
    expect(gate.isGoldReady, isTrue);
    expect(gate.status, 'SEMANTIC ANTI-TEMPLATE PASS');
    expect(gate.comparisons.where((item) => item.ruleA), isEmpty);
    expect(gate.comparisons.where((item) => item.ruleB), isEmpty);
    expect(gate.comparisons.where((item) => item.isCollision), isEmpty);
  });

  test('Guangzhou CORE evidence resolves only to active one-pass Story', () {
    expect(
      semanticEvidenceContractErrors(
        guangzhouChenClanGoldSemanticFingerprint,
      ),
      isEmpty,
    );
    final active = activeCanonicalGoldStoryText(guangzhouChenClanJourneyId);
    expect(active, contains('她叫刘嘉禾。今天不入镜。'));
    expect(active, contains('那张她等了三十四年的合照没有拍成'));
    expect(active, contains('两个人并排走了进去'));
    expect(active, isNot(contains('纸桥')));
    expect(active, isNot(contains(guangzhouChenClanLegacyOpening)));
    expect(active, isNot(contains(guangzhouChenClanLegacyMetaphor)));
  });

  test('Guangzhou descriptive DNA is synchronized to current Story', () {
    expect(approvedNarrativeDnaCatalog, hasLength(10));
    expect(
      approvedNarrativeDnaCatalog.where(
        (record) => record.journeyId == guangzhouChenClanJourneyId,
      ),
      hasLength(1),
    );
    expect(
      narrativeDnaIsUnique(
        guangzhouChenClanGoldNarrativeDna,
        approvedNarrativeDnaCatalog,
      ),
      isTrue,
    );
    expect(
      guangzhouChenClanGoldNarrativeDna.narrativeIdentity,
      'birth-mother-refuses-public-kinship-proof-to-protect-daughters-present-name',
    );
  });

  test('Gold audit has complete unique pairs and zero collision debt', () {
    final audit = auditApprovedGoldSemanticPairs();
    final expectedPairs = approvedGoldSemanticFingerprints.length *
        (approvedGoldSemanticFingerprints.length - 1) ~/ 2;
    expect(audit, hasLength(expectedPairs));
    final pairKeys = audit
        .map((item) => <String>[item.journeyA, item.journeyB]..sort())
        .map((pair) => pair.join('|'))
        .toSet();
    expect(pairKeys, hasLength(expectedPairs));
    expect(audit.where((item) => item.isCollision), isEmpty);
    expect(
      audit.where(
        (item) =>
            item.classification ==
            SemanticCollisionClassification.existingSemanticCollisionDebt,
      ),
      isEmpty,
    );
  });

  test('Guangzhou dramatic engine is not any protected Gold engine', () {
    const protectedEngines = <NarrativeMechanismFamily>{
      NarrativeMechanismFamily.forcedTradeoffReframesCreativeAuthorship,
      NarrativeMechanismFamily.coexistingValidPerspectivesSynthesizeRelationalModel,
      NarrativeMechanismFamily.spatialCrossingReframesTemporalContinuity,
      NarrativeMechanismFamily.completedClosureBecomesOpenContinuation,
      NarrativeMechanismFamily.evidenceForcesReclassification,
      NarrativeMechanismFamily.repeatedSpatialHandoffsCreateSharedUseProtocol,
      NarrativeMechanismFamily.operationalRefusalLeavesVisibleIncompletion,
    };
    final engine = guangzhouChenClanGoldSemanticFingerprint.mechanism(
      NarrativeSemanticDimension.dramaticEngineFamily,
    );
    expect(
      engine,
      NarrativeMechanismFamily.publicKinshipProofSacrificedForPresentIdentity,
    );
    expect(protectedEngines, isNot(contains(engine)));
  });
}
