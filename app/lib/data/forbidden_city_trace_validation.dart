import 'forbidden_city_journey_runtime.dart';
import 'journey_data.dart';

ForbiddenCityWordRecord _correctTrace(
  ForbiddenCityWordRecord record, {
  String? storySource,
  int? firstAppearsAt,
}) {
  return ForbiddenCityWordRecord(
    entry: record.entry,
    usageNote: record.usageNote,
    storySource: storySource ?? record.storySource,
    firstAppearsAt: firstAppearsAt ?? record.firstAppearsAt,
  );
}

/// Applies trace-only corrections discovered during the program-import audit.
/// The locked Story is authoritative and is never changed to satisfy Words.
List<ForbiddenCityWordRecord> get forbiddenCityValidatedWordRecords =>
    forbiddenCityWordRecords.map((record) {
      return switch (record.entry.word) {
        '界' => _correctTrace(
            record,
            storySource: '“界”。',
            firstAppearsAt: 1,
          ),
        '行动范围' => _correctTrace(
            record,
            storySource: '两个人都身在紫禁城，却并不拥有相同的行动范围。',
            firstAppearsAt: 4,
          ),
        '空间界线' => _correctTrace(
            record,
            storySource:
                '此刻，他有机会偷偷跨过一条本来不属于自己的空间界线，却没有任何必须进入的理由。',
            firstAppearsAt: 5,
          ),
        '接近' || '停留' => _correctTrace(
            record,
            storySource:
                '这些空间与国家重要典礼和政务活动密切相关。中轴、院落、宫门以及殿宇前后的关系，共同规定了进入、接近和停留的方式。',
            firstAppearsAt: 4,
          ),
        '建筑语言' => _correctTrace(
            record,
            storySource:
                '身为营造匠人的学徒，他从小熟悉梁、柱、斗栱、台基、屋顶、门窗和彩画等建筑语言。',
            firstAppearsAt: 9,
          ),
        '空间系统' => _correctTrace(
            record,
            storySource:
                '建筑不再只是被人观察的对象，而是一个曾经真实组织人们如何行动的空间系统。',
            firstAppearsAt: 9,
          ),
        _ => record,
      };
    }).toList(growable: false);

int? _earliestLevelContaining(String value) {
  for (var index = 0; index < forbiddenCityLockedStories.length; index++) {
    if (forbiddenCityLockedStories[index].contains(value)) return index + 1;
  }
  return null;
}

bool forbiddenCityWordTraceIsValid(ForbiddenCityWordRecord record) {
  final earliest = _earliestLevelContaining(record.entry.word);
  if (earliest == null || earliest != record.firstAppearsAt) return false;
  if (!record.storySource.contains(record.entry.word)) return false;
  return forbiddenCityLockedStories.any(
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
  final safeLevel = level.clamp(1, 10);
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
  final target = (5 + level.clamp(1, 10)).clamp(6, 15);
  return forbiddenCityTraceRecordsForLevel(level)
      .take(target)
      .map((record) => record.entry)
      .toList(growable: false);
}
