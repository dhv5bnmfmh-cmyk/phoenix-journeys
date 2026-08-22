import 'package:pinyin/pinyin.dart';

import 'forbidden_city_journey_runtime_base.dart' as base;
import 'journey_data.dart';
import 'journey_level_catalog.dart';

export 'forbidden_city_journey_runtime_base.dart'
    hide
        forbiddenCityWordRecords,
        validateForbiddenCityWordTrace,
        forbiddenCityWordsForLevel,
        forbiddenCityLevelContent;

int _earliestStoryLevel(String word) {
  for (var index = 0; index < base.forbiddenCityLockedStories.length; index++) {
    if (base.forbiddenCityLockedStories[index].contains(word)) return index + 1;
  }
  throw StateError('Forbidden City vocabulary is orphaned from Story: $word');
}

String _storySource(String word, String story, {required String context}) {
  for (final segment in story.split(RegExp(r'[。！？!?；;\n]'))) {
    final source = segment.trim();
    if (source.contains(word)) return source;
  }
  throw StateError(
    'Forbidden City vocabulary has no $context Story source: $word',
  );
}

String _earliestStorySource(String word) {
  final level = _earliestStoryLevel(word);
  return _storySource(
    word,
    base.forbiddenCityLockedStories[level - 1],
    context: 'earliest-level',
  );
}

String _sameLevelStorySource(String word, int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  return _storySource(
    word,
    base.forbiddenCityLockedStories[safeLevel - 1],
    context: 'Lv$safeLevel',
  );
}

/// Canonical first-appearance metadata is derived from the locked Lv1-Lv10
/// Story. Teaching examples below derive their source again from the selected
/// level so first-appearance provenance and same-level trace cannot drift.
final List<base.ForbiddenCityWordRecord> forbiddenCityWordRecords =
    List<base.ForbiddenCityWordRecord>.unmodifiable([
  for (final record in base.forbiddenCityWordRecords)
    base.ForbiddenCityWordRecord(
      entry: record.entry,
      usageNote: record.usageNote,
      storySource: _earliestStorySource(record.entry.word),
      firstAppearsAt: _earliestStoryLevel(record.entry.word),
      contrastNote: record.contrastNote,
      narrativeNote: record.narrativeNote,
    ),
]);

String _pinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

WordEntry _wordEntryForLevel(base.ForbiddenCityWordRecord record, int level) {
  final source = record.entry;
  final sameLevelStorySource = _sameLevelStorySource(source.word, level);
  final band = level <= 3
      ? 1
      : level <= 6
          ? 2
          : level <= 8
              ? 3
              : 4;
  final notes = <WordExample>[
    WordExample(
      chinese: 'Story 原句：$sameLevelStorySource',
      pinyin: _pinyin(sameLevelStorySource),
      vietnamese: 'Câu gốc trong Story: $sameLevelStorySource',
      english: 'Story source: $sameLevelStorySource',
    ),
    WordExample(
      chinese: band == 1
          ? '意思：${source.simpleChinese}'
          : '搭配与语境：${record.usageNote}',
      pinyin: _pinyin(
        band == 1 ? '意思：${source.simpleChinese}' : '搭配与语境：${record.usageNote}',
      ),
      vietnamese: band == 1
          ? 'Nghĩa: ${source.translation}'
          : 'Ngữ cảnh: ${record.usageNote}',
      english: band == 1
          ? 'Meaning: ${source.englishDefinition}'
          : 'Collocation/context: ${record.usageNote}',
    ),
    WordExample(
      chinese: band <= 2
          ? '在这段 Story 里：${record.usageNote}'
          : '对比：${record.contrastNote}',
      pinyin: _pinyin(
        band <= 2 ? '在这段故事里：${record.usageNote}' : '对比：${record.contrastNote}',
      ),
      vietnamese: band <= 2
          ? 'Trong Story: ${record.usageNote}'
          : 'So sánh ngữ nghĩa: ${record.contrastNote}',
      english: band <= 2
          ? 'In this Story: ${record.usageNote}'
          : 'Semantic contrast: ${record.contrastNote}',
    ),
    if (band == 4)
      WordExample(
        chinese: '叙事功能：${record.narrativeNote}',
        pinyin: _pinyin('叙事功能：${record.narrativeNote}'),
        vietnamese: 'Chức năng tự sự: ${record.narrativeNote}',
        english: 'Narrative function: ${record.narrativeNote}',
      ),
  ];
  return WordEntry(
    word: source.word,
    pinyin: source.pinyin,
    partOfSpeech: source.partOfSpeech,
    simpleChinese: source.simpleChinese,
    translation: source.translation,
    englishDefinition: source.englishDefinition,
    symbol: source.symbol,
    examples: notes,
  );
}

List<String> validateForbiddenCityWordTrace() {
  final invalid = <String>[];
  for (final record in forbiddenCityWordRecords) {
    final earliest = _earliestStoryLevel(record.entry.word);
    final earliestStory = base.forbiddenCityLockedStories[earliest - 1];
    if (record.firstAppearsAt != earliest ||
        record.storySource.trim().isEmpty ||
        !record.storySource.contains(record.entry.word) ||
        !earliestStory.contains(record.storySource)) {
      invalid.add(record.entry.word);
    }
  }
  return invalid;
}

List<WordEntry> forbiddenCityWordsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final story = base.forbiddenCityLockedStories[safeLevel - 1];
  final maximum = <int>[5, 6, 7, 7, 8, 8, 8, 8, 8, 8][safeLevel - 1];
  return forbiddenCityWordRecords
      .where(
        (record) =>
            record.firstAppearsAt <= safeLevel &&
            story.contains(record.entry.word),
      )
      .take(maximum)
      .map((record) => _wordEntryForLevel(record, safeLevel))
      .toList(growable: false);
}

JourneyLevelContent forbiddenCityLevelContent(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final source = base.forbiddenCityLevelContent(safeLevel);
  return JourneyLevelContent(
    storyParagraphs: source.storyParagraphs,
    storyAnnotations: source.storyAnnotations,
    words: forbiddenCityWordsForLevel(safeLevel),
    discoveries: source.discoveries,
    wonderQuestion: source.wonderQuestion,
    expressQuestion: source.expressQuestion,
  );
}
