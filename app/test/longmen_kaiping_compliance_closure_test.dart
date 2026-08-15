import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_semantic_fingerprint_catalog.dart';
import 'package:phoenix_journeys/data/kaiping_diaolou_gold.dart';
import 'package:phoenix_journeys/data/luoyang_longmen_one_pass.dart';

void main() {
  test('Longmen is active approved Gold with complete executable evidence', () {
    final longmen = approvedGoldSemanticFingerprints[luoyangLongmenJourneyId];
    expect(longmen, same(longmenGoldSemanticFingerprint));
    expect(semanticEvidenceContractErrors(longmen!), isEmpty);
    expect(semanticEvidenceProvenanceErrors(longmen), isEmpty);
    expect(
      activeCanonicalGoldStoryText(luoyangLongmenJourneyId),
      allOf(
        contains('不能放在我们两个人的名字下面'),
        contains('周澄把老照片和来源清单重新接回时间线'),
        contains('无依据，不使用'),
      ),
    );
  });

  test('approved Gold catalog has ten identities and forty-five clean pairs', () {
    expect(approvedGoldSemanticFingerprints, hasLength(10));
    final audit = auditApprovedGoldSemanticPairs();
    expect(audit, hasLength(45));
    expect(audit.where((item) => item.ruleA || item.ruleB), isEmpty);
  });

  test('Kaiping candidate has active evidence and compares with Longmen', () {
    expect(
      semanticEvidenceContractErrors(kaipingGoldCandidateSemanticFingerprint),
      isEmpty,
    );
    final gate =
        evaluateFutureGoldSemanticCandidate(kaipingGoldCandidateSemanticFingerprint);
    expect(gate.comparisons, hasLength(10));
    expect(gate.comparisons.where((item) => item.isCollision), isEmpty);
    final longmen = gate.comparisons.singleWhere(
      (item) =>
          item.journeyA == luoyangLongmenJourneyId ||
          item.journeyB == luoyangLongmenJourneyId,
    );
    expect(longmen.ruleA, isFalse);
    expect(longmen.ruleB, isFalse);
    expect(
      activeCanonicalGoldStoryText(kaipingDiaolouJourneyId),
      allOf(
        contains('若要改作别用，就寄还给他'),
        contains('我们家在众楼里的一份'),
        contains('原图留在箱底'),
      ),
    );
  });
}
