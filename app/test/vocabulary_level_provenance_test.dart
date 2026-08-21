import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';

void main() {
  test('legacy curated numbers are never authoritative exam evidence', () {
    const tag = VocabularyLevelTag(
      hskLevel: 6,
      tocflLevel: 6,
      evidence: VocabularyLevelEvidence.curated,
    );

    expect(tag.levelFor(ChineseExamTrack.hsk), isNull);
    expect(tag.levelFor(ChineseExamTrack.tocfl), isNull);
    expect(tag.hasAuthoritativeExamEvidence, isFalse);
  });

  test('cultural and special vocabulary keeps EXAM_LEVEL=N/A', () {
    const tags = <VocabularyLevelTag>[
      VocabularyLevelTag(
        hskLevel: 5,
        tocflLevel: 5,
        kind: VocabularyKind.cultural,
        evidence: VocabularyLevelEvidence.culturalTerm,
        phoenixSupportLevel: 3,
        supportRationale: 'Teach with cultural annotation.',
      ),
      VocabularyLevelTag(
        hskLevel: 6,
        tocflLevel: 6,
        kind: VocabularyKind.properNoun,
        evidence: VocabularyLevelEvidence.properNoun,
        phoenixSupportLevel: 2,
        supportRationale: 'Proper name; support recognition in context.',
      ),
      VocabularyLevelTag(
        hskLevel: 6,
        tocflLevel: 6,
        kind: VocabularyKind.idiom,
        evidence: VocabularyLevelEvidence.idiomOrSpecialTerm,
        phoenixSupportLevel: 5,
        supportRationale: 'Teach as a supported phrase.',
        pedagogicalLoad: PedagogicalLoad.high,
      ),
    ];

    for (final tag in tags) {
      expect(tag.levelFor(ChineseExamTrack.hsk), isNull);
      expect(tag.levelFor(ChineseExamTrack.tocfl), isNull);
      expect(tag.levelForProfile(_phoenix(10)), tag.phoenixSupportLevel);
    }
  });

  test('verified evidence is track-specific and explicit', () {
    const hsk = VocabularyLevelTag(
      hskLevel: 4,
      tocflLevel: 4,
      evidence: VocabularyLevelEvidence.officialHsk,
    );
    const tocfl = VocabularyLevelTag(
      hskLevel: 4,
      tocflLevel: 4,
      evidence: VocabularyLevelEvidence.officialTocfl,
    );
    const verified = VocabularyLevelTag(
      hskLevel: 4,
      tocflLevel: 3,
      evidence: VocabularyLevelEvidence.verifiedCuratedEquivalence,
    );

    expect(hsk.levelFor(ChineseExamTrack.hsk), 4);
    expect(hsk.levelFor(ChineseExamTrack.tocfl), isNull);
    expect(tocfl.levelFor(ChineseExamTrack.hsk), isNull);
    expect(tocfl.levelFor(ChineseExamTrack.tocfl), 4);
    expect(verified.levelFor(ChineseExamTrack.hsk), 4);
    expect(verified.levelFor(ChineseExamTrack.tocfl), 3);
  });
}

ChineseProficiencyProfile _phoenix(int level) => ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '$level',
      levelLabel: '$level',
      band: PhoenixReadingBand.mastery,
      phoenixLevel: level,
    );
