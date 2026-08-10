import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/guangzhou_chen_clan_one_pass.dart';
import 'package:phoenix_journeys/data/journey_narrative_dna_catalog.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';

void main() {
  test('Guangzhou remains a seven-Gold future candidate before promotion', () {
    expect(approvedGoldSemanticFingerprints, hasLength(7));
    expect(
      approvedGoldSemanticFingerprints,
      isNot(contains(guangzhouChenClanJourneyId)),
    );

    final gate = evaluateFutureGoldSemanticCandidate(
      guangzhouChenClanGoldSemanticFingerprint,
    );
    expect(gate.comparisons, hasLength(7));
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
    expect(active, contains('她的第一件原型却在桌面上散开'));
    expect(active, contains('留下窄窄的纸桥'));
    expect(active, contains('整张纸没有散开'));
    expect(active, contains('先问材料怎样连接'));
    expect(active, isNot(contains(guangzhouChenClanLegacyOpening)));
    expect(active, isNot(contains(guangzhouChenClanLegacyMetaphor)));
  });

  test('Guangzhou candidate DNA is distinct from seven approved Gold records', () {
    expect(approvedNarrativeDnaCatalog, hasLength(7));
    expect(
      narrativeDnaIsUnique(
        guangzhouChenClanGoldNarrativeDna,
        approvedNarrativeDnaCatalog,
      ),
      isTrue,
    );
    expect(
      guangzhouChenClanGoldNarrativeDna.narrativeIdentity,
      'paper-bridges-translate-relief-across-material-constraints',
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
      NarrativeMechanismFamily.materialConstraintForcesCrossMediumReencoding,
    );
    expect(protectedEngines, isNot(contains(engine)));
  });
}
