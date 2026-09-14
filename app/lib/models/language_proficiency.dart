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

enum VocabularyLevelEvidence { official, curated, cultural }

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
  });

  const VocabularyLevelTag.ungraded()
      : hskLevel = null,
        tocflLevel = null,
        kind = VocabularyKind.general,
        evidence = VocabularyLevelEvidence.curated;

  final int? hskLevel;
  final int? tocflLevel;
  final VocabularyKind kind;
  final VocabularyLevelEvidence evidence;

  bool get isCulture =>
      kind == VocabularyKind.cultural ||
      kind == VocabularyKind.properNoun ||
      kind == VocabularyKind.idiom;

  int? levelFor(ChineseExamTrack track) => switch (track) {
        ChineseExamTrack.hsk => hskLevel,
        ChineseExamTrack.tocfl => tocflLevel,
      };

  int? levelForProfile(ChineseProficiencyProfile profile) {
    if (!profile.isPhoenix) return levelFor(profile.track);

    final anchors = <int>[
      if (hskLevel != null) _phoenixFromHsk(hskLevel!),
      if (tocflLevel != null) _phoenixFromTocfl(tocflLevel!),
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
