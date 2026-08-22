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

String _earliestStorySource(String word) {
  final story = base.forbiddenCityLockedStories[_earliestStoryLevel(word) - 1];
  for (final segment in story.split(RegExp(r'[。！？!?；;\n]'))) {
    final source = segment.trim();
    if (source.contains(word)) return source;
  }
  throw StateError('Forbidden City vocabulary has no Story source: $word');
}

/// Canonical vocabulary metadata is derived from the locked Lv1-Lv10 Story.
/// This prevents hand-authored earliest-level and Story-source drift.
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
  final band = level <= 3
      ? 1
      : level <= 6
          ? 2
          : level <= 8
              ? 3
              : 4;
  final notes = <WordExample>[
    WordExample(
      chinese: 'Story 原句：${record.storySource}',
      pinyin: _pinyin(record.storySource),
      vietnamese: 'Câu gốc trong Story: ${record.storySource}',
      english: 'Story source: ${record.storySource}',
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
            story.contains(record.entry.word) &&
            story.contains(record.storySource),
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
