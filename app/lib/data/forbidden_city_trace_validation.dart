import 'forbidden_city_journey_runtime.dart';
import 'forbidden_city_word_supplement.dart';
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
    <ForbiddenCityWordRecord>[
      ...forbiddenCityWordRecords,
      ...forbiddenCitySupplementalWordRecords,
    ].map((record) {
      return switch (record.entry.word) {
        '界' => _correctTrace(
            record,
            storySource: '“界”。',
            firstAppearsAt: 1,
          ),
        '宫院' => _correctTrace(
            record,
            storySource: '后来，一道通往更深宫院的门打开了。',
            firstAppearsAt: 1,
          ),
        '开阔' => _correctTrace(
            record,
            storySource: '沈砚抬头看宫殿，又看看宽阔的院子，突然觉得自己很小。',
            firstAppearsAt: 1,
          ),
        '性质' => _correctTrace(
            record,
            storySource: '到了乾清门附近，周师傅告诉他，空间的性质开始变化。',
            firstAppearsAt: 2,
          ),
        '对照' => _correctTrace(
            record,
            storySource: '沈砚看着他的背影，突然发现了一个奇怪的对照。',
            firstAppearsAt: 3,
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
        '接近' => _correctTrace(
            record,
            storySource:
                '外朝和重要典礼、政务有关，内廷则更接近皇帝、后妃等人的宫廷生活。',
            firstAppearsAt: 1,
          ),
        '停留' => _correctTrace(
            record,
            storySource:
                '这些空间与国家重要典礼和政务活动密切相关。中轴、院落、宫门以及殿宇前后的关系，共同规定了进入、接近和停留的方式。',
            firstAppearsAt: 4,
          ),
        '空间组织' => _correctTrace(
            record,
            storySource:
                '它不再只是“很多漂亮的大房子”，而逐渐成为一套通过空间组织人与活动的系统。',
            firstAppearsAt: 5,
          ),
        '占有' => _correctTrace(
            record,
            storySource: '一张真正理解空间的地图，并不要求把所有未知都占有。',
            firstAppearsAt: 7,
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
