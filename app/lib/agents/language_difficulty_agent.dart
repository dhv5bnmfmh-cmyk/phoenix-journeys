enum ChineseExamTrack { hsk, tocfl, phoenix }

enum PhoenixReadingBand {
  starter,
  elementary,
  intermediate,
  upperIntermediate,
  advanced,
  mastery,
}

class LearnerLanguageProfile {
  const LearnerLanguageProfile({
    required this.track,
    required this.level,
    this.recentComprehension = 0.75,
    this.recentVocabularyAccuracy = 0.75,
    this.lookupRate = 0.05,
    this.preferredChallengeOffset = 0,
  });

  final ChineseExamTrack track;
  final String level;
  final double recentComprehension;
  final double recentVocabularyAccuracy;
  final double lookupRate;
  final int preferredChallengeOffset;
}

class LanguageDifficultyPlan {
  const LanguageDifficultyPlan({
    required this.band,
    required this.minCharacters,
    required this.maxCharacters,
    required this.paragraphCount,
    required this.targetVocabularyCount,
    required this.maxSentenceCharacters,
    required this.targetKnownWordCoverage,
    required this.newGrammarCount,
  });

  final PhoenixReadingBand band;
  final int minCharacters;
  final int maxCharacters;
  final int paragraphCount;
  final int targetVocabularyCount;
  final int maxSentenceCharacters;
  final double targetKnownWordCoverage;
  final int newGrammarCount;
}

class LanguageDifficultyAgent {
  const LanguageDifficultyAgent();

  LanguageDifficultyPlan createPlan(LearnerLanguageProfile profile) {
    final baseBand = _mapExamLevel(profile.track, profile.level);
    final performanceOffset = _performanceOffset(profile);
    final adjustedIndex = (baseBand.index +
            performanceOffset +
            profile.preferredChallengeOffset)
        .clamp(0, PhoenixReadingBand.values.length - 1)
        .toInt();
    return _planFor(PhoenixReadingBand.values[adjustedIndex]);
  }

  PhoenixReadingBand _mapExamLevel(ChineseExamTrack track, String rawLevel) {
    final level = rawLevel.trim().toUpperCase().replaceAll(' ', '');

    return switch (track) {
      ChineseExamTrack.hsk => switch (level) {
          '1' || 'HSK1' => PhoenixReadingBand.starter,
          '2' || 'HSK2' => PhoenixReadingBand.elementary,
          '3' || 'HSK3' => PhoenixReadingBand.intermediate,
          '4' || 'HSK4' => PhoenixReadingBand.upperIntermediate,
          '5' || 'HSK5' || '6' || 'HSK6' => PhoenixReadingBand.advanced,
          '7' || '8' || '9' || 'HSK7' || 'HSK8' || 'HSK9' || 'HSK7-9' =>
            PhoenixReadingBand.mastery,
          _ => PhoenixReadingBand.intermediate,
        },
      ChineseExamTrack.tocfl => switch (level) {
          '准备级' || 'NOVICE' => PhoenixReadingBand.starter,
          '1' || 'LEVEL1' || 'A1' => PhoenixReadingBand.elementary,
          '2' || 'LEVEL2' || 'A2' => PhoenixReadingBand.intermediate,
          '3' || 'LEVEL3' || 'B1' => PhoenixReadingBand.upperIntermediate,
          '4' || 'LEVEL4' || 'B2' => PhoenixReadingBand.advanced,
          '5' || '6' || 'LEVEL5' || 'LEVEL6' || 'C1' || 'C2' =>
            PhoenixReadingBand.mastery,
          _ => PhoenixReadingBand.intermediate,
        },
      ChineseExamTrack.phoenix => switch (level) {
          'STARTER' => PhoenixReadingBand.starter,
          'ELEMENTARY' => PhoenixReadingBand.elementary,
          'INTERMEDIATE' => PhoenixReadingBand.intermediate,
          'UPPERINTERMEDIATE' => PhoenixReadingBand.upperIntermediate,
          'ADVANCED' => PhoenixReadingBand.advanced,
          'MASTERY' => PhoenixReadingBand.mastery,
          _ => PhoenixReadingBand.intermediate,
        },
    };
  }

  int _performanceOffset(LearnerLanguageProfile profile) {
    final strong = profile.recentComprehension >= 0.85 &&
        profile.recentVocabularyAccuracy >= 0.85 &&
        profile.lookupRate <= 0.08;
    if (strong) return 1;

    final overloaded = profile.recentComprehension < 0.60 ||
        profile.recentVocabularyAccuracy < 0.60 ||
        profile.lookupRate > 0.18;
    if (overloaded) return -1;

    return 0;
  }

  LanguageDifficultyPlan _planFor(PhoenixReadingBand band) {
    return switch (band) {
      PhoenixReadingBand.starter => const LanguageDifficultyPlan(
          band: PhoenixReadingBand.starter,
          minCharacters: 80,
          maxCharacters: 140,
          paragraphCount: 2,
          targetVocabularyCount: 4,
          maxSentenceCharacters: 12,
          targetKnownWordCoverage: 0.98,
          newGrammarCount: 1,
        ),
      PhoenixReadingBand.elementary => const LanguageDifficultyPlan(
          band: PhoenixReadingBand.elementary,
          minCharacters: 150,
          maxCharacters: 240,
          paragraphCount: 2,
          targetVocabularyCount: 6,
          maxSentenceCharacters: 15,
          targetKnownWordCoverage: 0.97,
          newGrammarCount: 1,
        ),
      PhoenixReadingBand.intermediate => const LanguageDifficultyPlan(
          band: PhoenixReadingBand.intermediate,
          minCharacters: 280,
          maxCharacters: 400,
          paragraphCount: 2,
          targetVocabularyCount: 9,
          maxSentenceCharacters: 18,
          targetKnownWordCoverage: 0.96,
          newGrammarCount: 2,
        ),
      PhoenixReadingBand.upperIntermediate => const LanguageDifficultyPlan(
          band: PhoenixReadingBand.upperIntermediate,
          minCharacters: 450,
          maxCharacters: 600,
          paragraphCount: 2,
          targetVocabularyCount: 11,
          maxSentenceCharacters: 22,
          targetKnownWordCoverage: 0.95,
          newGrammarCount: 2,
        ),
      PhoenixReadingBand.advanced => const LanguageDifficultyPlan(
          band: PhoenixReadingBand.advanced,
          minCharacters: 600,
          maxCharacters: 800,
          paragraphCount: 2,
          targetVocabularyCount: 14,
          maxSentenceCharacters: 26,
          targetKnownWordCoverage: 0.94,
          newGrammarCount: 3,
        ),
      PhoenixReadingBand.mastery => const LanguageDifficultyPlan(
          band: PhoenixReadingBand.mastery,
          minCharacters: 800,
          maxCharacters: 1000,
          paragraphCount: 3,
          targetVocabularyCount: 18,
          maxSentenceCharacters: 32,
          targetKnownWordCoverage: 0.93,
          newGrammarCount: 3,
        ),
    };
  }
}
