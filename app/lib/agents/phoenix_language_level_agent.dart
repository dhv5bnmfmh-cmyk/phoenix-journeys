import '../data/journey_data.dart';
import '../models/language_proficiency.dart';

class PhoenixLanguageLevelAgent {
  const PhoenixLanguageLevelAgent();

  static const List<ChineseProficiencyProfile> phoenixProfiles = [
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '1',
      levelLabel: '1',
      band: PhoenixReadingBand.beginner,
      phoenixLevel: 1,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '2',
      levelLabel: '2',
      band: PhoenixReadingBand.beginner,
      phoenixLevel: 2,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '3',
      levelLabel: '3',
      band: PhoenixReadingBand.elementary,
      phoenixLevel: 3,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '4',
      levelLabel: '4',
      band: PhoenixReadingBand.elementary,
      phoenixLevel: 4,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '5',
      levelLabel: '5',
      band: PhoenixReadingBand.intermediate,
      phoenixLevel: 5,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '6',
      levelLabel: '6',
      band: PhoenixReadingBand.upperIntermediate,
      phoenixLevel: 6,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '7',
      levelLabel: '7',
      band: PhoenixReadingBand.upperIntermediate,
      phoenixLevel: 7,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '8',
      levelLabel: '8',
      band: PhoenixReadingBand.advanced,
      phoenixLevel: 8,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '9',
      levelLabel: '9',
      band: PhoenixReadingBand.mastery,
      phoenixLevel: 9,
    ),
    ChineseProficiencyProfile(
      track: ChineseExamTrack.hsk,
      levelCode: '10',
      levelLabel: '10',
      band: PhoenixReadingBand.mastery,
      phoenixLevel: 10,
    ),
  ];

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

  List<ChineseProficiencyProfile> get allProfiles => phoenixProfiles;

  ChineseProficiencyProfile profileForPhoenixLevel(int level) {
    final safeLevel = level.clamp(1, 10).toInt();
    return phoenixProfiles[safeLevel - 1];
  }

  ChineseProficiencyProfile? profileFromStorage(String? value) {
    if (value == null || !value.contains(':')) return null;
    if (value.startsWith('phoenix:')) {
      final level = int.tryParse(value.split(':').last);
      return level == null ? null : profileForPhoenixLevel(level);
    }
    return legacyProfiles
        .where((profile) => profile.storageValue == value)
        .firstOrNull;
  }

  int? phoenixLevelFromStorage(String? value) {
    if (value == null || !value.contains(':')) return null;
    if (value.startsWith('phoenix:')) {
      final parsed = int.tryParse(value.split(':').last);
      return parsed?.clamp(1, 10).toInt();
    }

    final profile = legacyProfiles
        .where((item) => item.storageValue == value)
        .firstOrNull;
    if (profile == null) return null;
    if (profile.track == ChineseExamTrack.hsk) {
      return switch (profile.levelCode) {
        '1' => 1,
        '2' => 2,
        '3' => 3,
        '4' => 5,
        '5' => 6,
        '6' => 8,
        _ => 9,
      };
    }
    return switch (profile.levelCode) {
      'novice' => 1,
      '1' => 2,
      '2' => 4,
      '3' => 5,
      '4' => 7,
      '5' => 8,
      _ => 9,
    };
  }

  List<ChineseProficiencyProfile> get legacyProfiles => [
        ...hskProfiles,
        ...tocflProfiles,
      ];

  ReadingGenerationPlan planFor(ChineseProficiencyProfile profile) {
    if (profile.isPhoenix) return _phoenixPlan(profile.phoenixLevel!);
    return _legacyPlan(profile.band);
  }

  ReadingGenerationPlan _phoenixPlan(int level) => switch (level) {
        1 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.beginner,
            paragraphCount: 1,
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
        2 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.beginner,
            paragraphCount: 1,
            minTotalCharacters: 110,
            maxTotalCharacters: 180,
            targetVocabularyCount: 5,
            maximumVocabularyCount: 6,
            cultureWordQuota: 1,
            targetGrammarCount: 1,
            minimumKnownWordCoverage: .98,
            maximumSentenceCharacters: 19,
            speechRate: .83,
          ),
        3 => const ReadingGenerationPlan(
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
            speechRate: .86,
          ),
        4 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.elementary,
            paragraphCount: 2,
            minTotalCharacters: 210,
            maxTotalCharacters: 320,
            targetVocabularyCount: 7,
            maximumVocabularyCount: 8,
            cultureWordQuota: 2,
            targetGrammarCount: 2,
            minimumKnownWordCoverage: .97,
            maximumSentenceCharacters: 26,
            speechRate: .89,
          ),
        5 => const ReadingGenerationPlan(
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
            speechRate: .92,
          ),
        6 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.upperIntermediate,
            paragraphCount: 2,
            minTotalCharacters: 360,
            maxTotalCharacters: 500,
            targetVocabularyCount: 10,
            maximumVocabularyCount: 11,
            cultureWordQuota: 3,
            targetGrammarCount: 2,
            minimumKnownWordCoverage: .96,
            maximumSentenceCharacters: 34,
            speechRate: .95,
          ),
        7 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.upperIntermediate,
            paragraphCount: 2,
            minTotalCharacters: 440,
            maxTotalCharacters: 600,
            targetVocabularyCount: 11,
            maximumVocabularyCount: 12,
            cultureWordQuota: 3,
            targetGrammarCount: 3,
            minimumKnownWordCoverage: .95,
            maximumSentenceCharacters: 38,
            speechRate: .98,
          ),
        8 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.advanced,
            paragraphCount: 1,
            minTotalCharacters: 540,
            maxTotalCharacters: 720,
            targetVocabularyCount: 13,
            maximumVocabularyCount: 15,
            cultureWordQuota: 4,
            targetGrammarCount: 3,
            minimumKnownWordCoverage: .95,
            maximumSentenceCharacters: 44,
            speechRate: 1,
          ),
        9 => const ReadingGenerationPlan(
            band: PhoenixReadingBand.mastery,
            paragraphCount: 1,
            minTotalCharacters: 620,
            maxTotalCharacters: 820,
            targetVocabularyCount: 15,
            maximumVocabularyCount: 18,
            cultureWordQuota: 5,
            targetGrammarCount: 3,
            minimumKnownWordCoverage: .95,
            maximumSentenceCharacters: 52,
            speechRate: 1.03,
          ),
        _ => const ReadingGenerationPlan(
            band: PhoenixReadingBand.mastery,
            paragraphCount: 1,
            minTotalCharacters: 700,
            maxTotalCharacters: 900,
            targetVocabularyCount: 16,
            maximumVocabularyCount: 20,
            cultureWordQuota: 5,
            targetGrammarCount: 4,
            minimumKnownWordCoverage: .94,
            maximumSentenceCharacters: 58,
            speechRate: 1.05,
          ),
      };

  ReadingGenerationPlan _legacyPlan(PhoenixReadingBand band) => switch (band) {
        PhoenixReadingBand.beginner => _phoenixPlan(1),
        PhoenixReadingBand.elementary => _phoenixPlan(3),
        PhoenixReadingBand.intermediate => _phoenixPlan(5),
        PhoenixReadingBand.upperIntermediate => _phoenixPlan(7),
        PhoenixReadingBand.advanced => _phoenixPlan(8),
        PhoenixReadingBand.mastery => _phoenixPlan(9),
      };

  List<WordEntry> selectVocabulary({
    required Iterable<WordEntry> words,
    required Map<String, VocabularyLevelTag> levelCatalog,
    required ChineseProficiencyProfile profile,
    Set<String> knownWords = const <String>{},
  }) {
    final plan = planFor(profile);
    final targetLevel = profile.isPhoenix
        ? profile.phoenixLevel!
        : _numericLegacyLevel(profile);
    final candidates = words.toList(growable: false);
    final selected = <WordEntry>[];

    VocabularyLevelTag tagFor(WordEntry entry) =>
        levelCatalog[entry.word] ?? const VocabularyLevelTag.ungraded();

    void addWhere(bool Function(WordEntry entry) predicate, {int? limit}) {
      for (final entry in candidates) {
        if (limit != null && selected.length >= limit) return;
        if (selected.any((item) => item.word == entry.word)) continue;
        if (predicate(entry)) selected.add(entry);
      }
    }

    int? levelFor(WordEntry entry) => tagFor(entry).levelForProfile(profile);

    final newCoreTarget = (plan.targetVocabularyCount * .60).round();
    addWhere(
      (entry) {
        final tag = tagFor(entry);
        final level = levelFor(entry);
        return !tag.isCulture &&
            !knownWords.contains(entry.word) &&
            level != null &&
            level <= targetLevel &&
            level >= targetLevel - 1;
      },
      limit: newCoreTarget,
    );

    addWhere(
      (entry) {
        final tag = tagFor(entry);
        final level = levelFor(entry);
        return !tag.isCulture &&
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
        final tag = tagFor(entry);
        final level = levelFor(entry);
        return !tag.isCulture &&
            knownWords.contains(entry.word) &&
            level != null &&
            level <= targetLevel;
      },
      limit: reviewTarget,
    );

    final cultureLimit = (selected.length + plan.cultureWordQuota)
        .clamp(0, plan.targetVocabularyCount);
    addWhere((entry) => tagFor(entry).isCulture, limit: cultureLimit);

    addWhere(
      (entry) {
        final level = levelFor(entry);
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
      issues.add('重点单词少于 ${plan.targetVocabularyCount} 个');
    }
    if (vocabulary.length > plan.maximumVocabularyCount) {
      issues.add('重点单词超过 ${plan.maximumVocabularyCount} 个');
    }

    final searchable = '${paragraphs.join()}$sourceText';
    for (final entry in vocabulary) {
      if (!searchable.contains(entry.word)) {
        issues.add('单词“${entry.word}”没有出现在故事或发现内容中');
      }
    }

    return issues;
  }

  int _numericLegacyLevel(ChineseProficiencyProfile profile) {
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
