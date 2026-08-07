import 'forbidden_city_final_story.dart';
import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';

ForbiddenCityWordRecord _withTrace(
  ForbiddenCityWordRecord record, {
  required String storySource,
  int? firstAppearsAt,
}) {
  return ForbiddenCityWordRecord(
    entry: record.entry,
    usageNote: record.usageNote,
    storySource: storySource,
    firstAppearsAt: firstAppearsAt ?? record.firstAppearsAt,
  );
}

/// The final Words package is derived from the locked adaptive Story.
/// Trace-only corrections never modify Story wording.
List<ForbiddenCityWordRecord> get forbiddenCityValidatedWordRecords =>
    forbiddenCityWordRecords.map((record) {
      return switch (record.entry.word) {
        '外朝' || '内廷' || '中轴' || '礼仪' => _withTrace(
            record,
            storySource:
                '到了外朝，周师傅告诉他，这里的中轴和开阔庭院与重要礼仪、政务有关；走近乾清门后，空间转入更接近日常宫廷生活的内廷。',
          ),
        '身份' => _withTrace(
            record,
            storySource:
                '他走到门槛前，看见一个年幼侍役沿规定路线匆匆经过，突然明白同在宫中，不同身份的人也有不同的路。',
          ),
        _ => record,
      };
    }).toList(growable: false);

int? _earliestLevelContaining(String value) {
  for (var level = 1; level <= 10; level += 1) {
    if (forbiddenCityFinalStoryForLevel(level).contains(value)) return level;
  }
  return null;
}

bool forbiddenCityWordTraceIsValid(ForbiddenCityWordRecord record) {
  final earliest = _earliestLevelContaining(record.entry.word);
  return earliest != null &&
      earliest == record.firstAppearsAt &&
      record.storySource.contains(record.entry.word) &&
      List<int>.generate(10, (index) => index + 1).any(
        (level) => forbiddenCityFinalStoryForLevel(level).contains(record.storySource),
      );
}

List<String> validateForbiddenCityImportedWords() {
  return forbiddenCityValidatedWordRecords
      .where((record) => !forbiddenCityWordTraceIsValid(record))
      .map((record) => record.entry.word)
      .toList(growable: false);
}

List<ForbiddenCityWordRecord> forbiddenCityTraceRecordsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final story = forbiddenCityFinalStoryForLevel(safeLevel);
  return forbiddenCityValidatedWordRecords
      .where(forbiddenCityWordTraceIsValid)
      .where(
        (record) =>
            record.firstAppearsAt <= safeLevel &&
            story.contains(record.entry.word),
      )
      .toList(growable: false);
}

List<WordEntry> forbiddenCityValidatedWordsForLevel(int level) {
  final selected = forbiddenCityWordsForLevel(level)
      .map((entry) => entry.word)
      .toSet();
  return forbiddenCityTraceRecordsForLevel(level)
      .where((record) => selected.contains(record.entry.word))
      .map((record) => record.entry)
      .toList(growable: false);
}
