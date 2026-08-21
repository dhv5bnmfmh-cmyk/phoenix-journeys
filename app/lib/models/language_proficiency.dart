enum ChineseExamTrack { hsk, tocfl }

enum PhoenixReadingBand {
  beginner,
  elementary,
  intermediate,
  upperIntermediate,
  advanced,
  mastery,
}

enum VocabularyKind { general, cultural, properNoun, idiom }

/// Exam-level evidence is intentionally stricter than historical `curated`.
///
/// `officialHsk`, `officialTocfl`, and `verifiedCuratedEquivalence` are the
/// only evidence categories that may make an HSK/TOCFL number authoritative.
/// Historical `curated` and `cultural` values remain source-compatible but
/// are treated as EXAM_LEVEL=N/A until explicitly re-verified.
enum VocabularyLevelEvidence {
  official,
  curated,
  cultural,
  officialHsk,
  officialTocfl,
  verifiedCuratedEquivalence,
  culturalTerm,
  properNoun,
  idiomOrSpecialTerm,
}

enum PedagogicalLoad { low, medium, high }

extension ChineseExamTrackPresentation on ChineseExamTrack {
  String get storageValue => switch (this) {
        ChineseExamTrack.hsk => 'hsk',
        ChineseExamTrack.tocfl => 'tocfl',
      };

  String get label => switch (this) {
        ChineseExamTrack.hsk => 'HSK',
        ChineseExamTrack.tocfl => 'TOCFL',
      };
}

extension PhoenixReadingBandPresentation on PhoenixReadingBand {
  String get label => switch (this) {
        PhoenixReadingBand.beginner => '入门',
        PhoenixReadingBand.elementary => '初级',
        PhoenixReadingBand.intermediate => '中级',
        PhoenixReadingBand.upperIntermediate => '中高级',
        PhoenixReadingBand.advanced => '高级',
        PhoenixReadingBand.mastery => '精通',
      };
}

class ChineseProficiencyProfile {
  const ChineseProficiencyProfile({
    required this.track,
    required this.levelCode,
    required this.levelLabel,
    required this.band,
    this.phoenixLevel,
  }) : assert(
          phoenixLevel == null ||
              (phoenixLevel >= 1 && phoenixLevel <= 10),
        );

  final ChineseExamTrack track;
  final String levelCode;
  final String levelLabel;
  final PhoenixReadingBand band;
  final int? phoenixLevel;

  bool get isPhoenix => phoenixLevel != null;

  String get storageValue => isPhoenix
      ? 'phoenix:$phoenixLevel'
      : '${track.storageValue}:$levelCode';

  String get displayLabel => isPhoenix ? 'Lv.$phoenixLevel' : '${track.label} $levelLabel';
}

class ReadingGenerationPlan {
  const ReadingGenerationPlan({
    required this.band,
    required this.paragraphCount,
    required this.minTotalCharacters,
    required this.maxTotalCharacters,
    required this.targetVocabularyCount,
    required this.maximumVocabularyCount,
    required this.cultureWordQuota,
    required this.targetGrammarCount,
    required this.minimumKnownWordCoverage,
    required this.maximumSentenceCharacters,
    required this.speechRate,
  });

  final PhoenixReadingBand band;
  final int paragraphCount;
  final int minTotalCharacters;
  final int maxTotalCharacters;
  final int targetVocabularyCount;
  final int maximumVocabularyCount;
  final int cultureWordQuota;
  final int targetGrammarCount;
  final double minimumKnownWordCoverage;
  final int maximumSentenceCharacters;
  final double speechRate;
}

class VocabularyLevelTag {
  const VocabularyLevelTag({
    this.hskLevel,
    this.tocflLevel,
    this.kind = VocabularyKind.general,
    this.evidence = VocabularyLevelEvidence.curated,
    this.phoenixSupportLevel,
    this.supportRationale,
    this.pedagogicalLoad = PedagogicalLoad.medium,
  }) : assert(
          phoenixSupportLevel == null ||
              (phoenixSupportLevel >= 1 && phoenixSupportLevel <= 10),
        );

  const VocabularyLevelTag.ungraded()
      : hskLevel = null,
        tocflLevel = null,
        kind = VocabularyKind.general,
        evidence = VocabularyLevelEvidence.curated,
        phoenixSupportLevel = null,
        supportRationale = 'No verified exam-level evidence; teach in context.',
        pedagogicalLoad = PedagogicalLoad.medium;

  final int? hskLevel;
  final int? tocflLevel;
  final VocabularyKind kind;
  final VocabularyLevelEvidence evidence;

  /// Phoenix-owned support threshold. This is pedagogical evidence only and
  /// must never be presented as official HSK/TOCFL certificate equivalence.
  final int? phoenixSupportLevel;
  final String? supportRationale;
  final PedagogicalLoad pedagogicalLoad;

  bool get isCulture =>
      kind == VocabularyKind.cultural ||
      kind == VocabularyKind.properNoun ||
      kind == VocabularyKind.idiom;

  bool get hasAuthoritativeExamEvidence => switch (evidence) {
        VocabularyLevelEvidence.official ||
        VocabularyLevelEvidence.officialHsk ||
        VocabularyLevelEvidence.officialTocfl ||
        VocabularyLevelEvidence.verifiedCuratedEquivalence => true,
        _ => false,
      };

  int? levelFor(ChineseExamTrack track) {
    if (!hasAuthoritativeExamEvidence) return null;
    return switch ((track, evidence)) {
      (ChineseExamTrack.hsk, VocabularyLevelEvidence.officialTocfl) => null,
      (ChineseExamTrack.tocfl, VocabularyLevelEvidence.officialHsk) => null,
      (ChineseExamTrack.hsk, _) => hskLevel,
      (ChineseExamTrack.tocfl, _) => tocflLevel,
    };
  }

  int? levelForProfile(ChineseProficiencyProfile profile) {
    if (profile.isPhoenix && phoenixSupportLevel != null) {
      return phoenixSupportLevel;
    }
    if (!profile.isPhoenix) return levelFor(profile.track);

    final authoritativeHsk = levelFor(ChineseExamTrack.hsk);
    final authoritativeTocfl = levelFor(ChineseExamTrack.tocfl);
    final anchors = <int>[
      if (authoritativeHsk != null) _phoenixFromHsk(authoritativeHsk),
      if (authoritativeTocfl != null) _phoenixFromTocfl(authoritativeTocfl),
    ];
    if (anchors.isEmpty) return null;
    return (anchors.reduce((left, right) => left + right) / anchors.length)
        .round()
        .clamp(1, 10)
        .toInt();
  }

  int _phoenixFromHsk(int level) => switch (level) {
        <= 1 => 1,
        2 => 2,
        3 => 3,
        4 => 5,
        5 => 6,
        6 => 8,
        _ => 9,
      };

  int _phoenixFromTocfl(int level) => switch (level) {
        <= 1 => 2,
        2 => 4,
        3 => 5,
        4 => 7,
        5 => 8,
        _ => 9,
      };
}
