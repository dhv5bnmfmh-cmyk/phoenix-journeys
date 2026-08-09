import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';

int? _earliestLevelContaining(String value) {
  for (var index = 0; index < forbiddenCityLockedStories.length; index += 1) {
    if (forbiddenCityLockedStories[index].contains(value)) return index + 1;
  }
  return null;
}

ForbiddenCityWordRecord _normalizedRecord(ForbiddenCityWordRecord record) {
  final earliest = _earliestLevelContaining(record.entry.word);
  return ForbiddenCityWordRecord(
    entry: record.entry,
    usageNote: record.usageNote,
    storySource: record.storySource,
    firstAppearsAt: earliest ?? record.firstAppearsAt,
  );
}

List<ForbiddenCityWordRecord> get forbiddenCityValidatedWordRecords =>
    List<ForbiddenCityWordRecord>.unmodifiable(
      forbiddenCityWordRecords.map(_normalizedRecord),
    );

bool forbiddenCityWordTraceIsValid(ForbiddenCityWordRecord record) {
  final earliest = _earliestLevelContaining(record.entry.word);
  return earliest != null &&
      earliest == record.firstAppearsAt &&
      record.storySource.contains(record.entry.word) &&
      forbiddenCityLockedStories.any(
        (story) => story.contains(record.storySource),
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
  final story = forbiddenCityLockedStories[safeLevel - 1];
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
