import '../data/journey_data.dart';
import '../models/language_proficiency.dart';

class PhoenixLanguageLevelAgent {
  const PhoenixLanguageLevelAgent();

  static const List<ChineseProficiencyProfile> hskProfiles = [
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '1',
      levelLabel: '1',
      band: PhoenixReadingBand.beginner,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '2',
      levelLabel: '2',
      band: PhoenixReadingBand.elementary,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '3',
      levelLabel: '3',
      band: PhoenixReadingBand.intermediate,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '4',
      levelLabel: '4',
      band: PhoenixReadingBand.upperIntermediate,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '5',
      levelLabel: '5',
      band: PhoenixReadingBand.advanced,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '6',
      levelLabel: '6',
      band: PhoenixReadingBand.advanced,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '7-9',
      levelLabel: '7–9',
      band: PhoenixReadingBand.mastery,
    ),
  ];

  static const List<ChineseProficiencyProfile> tocflProfiles = [
    ChineseProficiencyProfile(
      track: ChineseExamTrack.tocfl,
      levelCode: 'novice',
      levelLabel: '准备级',
      band: PhoenixReadingBand.beginner,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.tocfl,
      levelCode: '1',
      levelLabel: 'Level 1',
      band: PhoenixReadingBand.elementary,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.tocfl,
      levelCode: '2',
      levelLabel: 'Level 2',
      band: PhoenixReadingBand.intermediate,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.tocfl,
      levelCode: '3',
      levelLabel: 'Level 3',
      band: PhoenixReadingBand.upperIntermediate,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.tocfl,
      levelCode: '4',
      levelLabel: 'Level 4',
      band: PhoenixReadingBand.advanced,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.tocfl,
      levelCode: '5',
      levelLabel: 'Level 5',
      band: PhoenixReadingBand.advanced,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.tocfl,
      levelCode: '6',
      levelLabel: 'Level 6',
      band: PhoenixReadingBand.mastery,
    ),
  ];

  List<ChineseProficiencyProfile> profilesFor(ChineseExamTrack track) =>
      track == ChineseExamTrack.hsk ? hskProfiles : tocflProfiles;

  ChineseProficiencyProfile? profileFromStorage(String? value) {
    if (value == null || !value.contains(':')) return null;
    return allProfiles.where((profile) => profile.storageValue == value).firstOrNull;
  }

  List<ChineseProficiencyProfile> get allProfiles => [
        ...hskProfiles,
        ...tocflProfiles,
      ];

  ReadingGenerationPlan planFor(ChineseProficiencyProfile profile) {
    return switch (profile.band) {
      PhoenixReadingBand.beginner => const ReadingGenerationPlan(
          band: PhoenixReadingBand.beginner,
          paragraphCount: 2,
          minTotalCharacters: 80,
          maxTotalCharacters: 140,
          targetVocabularyCount: 4,
          maximumVocabularyCount: 5,
          cultureWordQuota: 1,
          targetGrammarCount: 1,
          minimumKnownWordCoverage: .98,
          maximumSentenceCharacters: 16,
          speechRate: .80,
        ),
      PhoenixReadingBand.elementary => const ReadingGenerationPlan(
          band: PhoenixReadingBand.elementary,
          paragraphCount: 2,
          minTotalCharacters: 150,
          maxTotalCharacters: 240,
          targetVocabularyCount: 6,
          maximumVocabularyCount: 7,
          cultureWordQuota: 2,
          targetGrammarCount: 1,
          minimumKnownWordCoverage: .97,
          maximumSentenceCharacters: 22,
          speechRate: .85,
        ),
      PhoenixReadingBand.intermediate => const ReadingGenerationPlan(
          band: PhoenixReadingBand.intermediate,
          paragraphCount: 2,
          minTotalCharacters: 280,
          maxTotalCharacters: 400,
          targetVocabularyCount: 9,
          maximumVocabularyCount: 10,
          cultureWordQuota: 2,
          targetGrammarCount: 2,
          minimumKnownWordCoverage: .96,
          maximumSentenceCharacters: 30,
          speechRate: .90,
        ),
      PhoenixReadingBand.upperIntermediate => const ReadingGenerationPlan(
          band: PhoenixReadingBand.upperIntermediate,
          paragraphCount: 2,
          minTotalCharacters: 450,
          maxTotalCharacters: 600,
          targetVocabularyCount: 11,
          maximumVocabularyCount: 12,
          cultureWordQuota: 3,
          targetGrammarCount: 2,
          minimumKnownWordCoverage: .95,
          maximumSentenceCharacters: 38,
          speechRate: .95,
        ),
      PhoenixReadingBand.advanced => const ReadingGenerationPlan(
          band: PhoenixReadingBand.advanced,
          paragraphCount: 2,
          minTotalCharacters: 600,
          maxTotalCharacters: 800,
          targetVocabularyCount: 14,
          maximumVocabularyCount: 16,
          cultureWordQuota: 4,
          targetGrammarCount: 3,
          minimumKnownWordCoverage: .95,
          maximumSentenceCharacters: 48,
          speechRate: 1,
        ),
      PhoenixReadingBand.mastery => const ReadingGenerationPlan(
          band: PhoenixReadingBand.mastery,
          paragraphCount: 2,
          minTotalCharacters: 700,
          maxTotalCharacters: 1000,
          targetVocabularyCount: 16,
          maximumVocabularyCount: 20,
          cultureWordQuota: 5,
          targetGrammarCount: 3,
          minimumKnownWordCoverage: .95,
          maximumSentenceCharacters: 58,
          speechRate: 1.05,
        ),
    };
  }

  List<WordEntry> selectVocabulary({
    required Iterable<WordEntry> words,
    required ChineseProficiencyProfile profile,
    Set<String> knownWords = const <String>{},
  }) {
    final plan = planFor(profile);
    final targetLevel = _numericLevel(profile);
    final candidates = words.toList(growable: false);
    final selected = <WordEntry>[];

    void addWhere(bool Function(WordEntry entry) predicate, {int? limit}) {
      for (final entry in candidates) {
        if (limit != null && selected.length >= limit) return;
        if (selected.any((item) => item.word == entry.word)) continue;
        if (predicate(entry)) selected.add(entry);
      }
    }

    final newCoreTarget = (plan.targetVocabularyCount * .60).round();
    addWhere(
      (entry) {
        final level = entry.levelTag.levelFor(profile.track);
        return !entry.levelTag.isCulture &&
            !knownWords.contains(entry.word) &&
            level != null &&
            level <= targetLevel &&
            level >= targetLevel - 1;
      },
      limit: newCoreTarget,
    );

    addWhere(
      (entry) {
        final level = entry.levelTag.levelFor(profile.track);
        return !entry.levelTag.isCulture &&
            !knownWords.contains(entry.word) &&
            level != null &&
            level <= targetLevel;
      },
      limit: newCoreTarget,
    );

    final reviewTarget =
        (newCoreTarget + (plan.targetVocabularyCount * .25).round())
            .clamp(0, plan.targetVocabularyCount);
    addWhere(
      (entry) {
        final level = entry.levelTag.levelFor(profile.track);
        return !entry.levelTag.isCulture &&
            knownWords.contains(entry.word) &&
            level != null &&
            level <= targetLevel;
      },
      limit: reviewTarget,
    );

    final cultureLimit =
        (selected.length + plan.cultureWordQuota).clamp(0, plan.targetVocabularyCount);
    addWhere((entry) => entry.levelTag.isCulture, limit: cultureLimit);

    addWhere(
      (entry) {
        final level = entry.levelTag.levelFor(profile.track);
        return level == null || level <= targetLevel + 1;
      },
      limit: plan.targetVocabularyCount,
    );

    addWhere((_) => true, limit: plan.targetVocabularyCount);
    return selected.take(plan.maximumVocabularyCount).toList(growable: false);
  }

  List<String> validateJourney({
    required List<String> paragraphs,
    required List<WordEntry> vocabulary,
    required ChineseProficiencyProfile profile,
    String sourceText = '',
  }) {
    final plan = planFor(profile);
    final issues = <String>[];
    final totalCharacters = paragraphs.join().length;

    if (paragraphs.length != plan.paragraphCount) {
      issues.add('短文应为 ${plan.paragraphCount} 段');
    }
    if (totalCharacters < plan.minTotalCharacters) {
      issues.add('短文少于 ${plan.minTotalCharacters} 字');
    }
    if (totalCharacters > plan.maxTotalCharacters) {
      issues.add('短文超过 ${plan.maxTotalCharacters} 字');
    }
    if (vocabulary.length < plan.targetVocabularyCount) {
      issues.add('重点生词少于 ${plan.targetVocabularyCount} 个');
    }
    if (vocabulary.length > plan.maximumVocabularyCount) {
      issues.add('重点生词超过 ${plan.maximumVocabularyCount} 个');
    }

    final searchable = '${paragraphs.join()}$sourceText';
    for (final entry in vocabulary) {
      if (!searchable.contains(entry.word)) {
        issues.add('生词“${entry.word}”没有出现在故事或发现内容中');
      }
    }

    return issues;
  }

  int _numericLevel(ChineseProficiencyProfile profile) {
    if (profile.track == ChineseExamTrack.hsk && profile.levelCode == '7-9') {
      return 7;
    }
    if (profile.track == ChineseExamTrack.tocfl &&
        profile.levelCode == 'novice') {
      return 0;
    }
    return int.tryParse(profile.levelCode) ?? 0;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
