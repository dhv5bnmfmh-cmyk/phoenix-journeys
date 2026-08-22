import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/forbidden_city_trace_validation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Vocabulary Trace emits zero-failure metrics', () {
    final records = forbiddenCityWordRecords;
    var incorrectEarliest = 0;
    var missingStorySource = 0;
    var sameLevelFailures = 0;
    var orphans = 0;

    for (final record in records) {
      final word = record.entry.word;
      final source = record.storySource.trim();
      final earliestIndex = forbiddenCityLockedStories.indexWhere(
        (story) => story.contains(word),
      );
      final earliest = earliestIndex < 0 ? 0 : earliestIndex + 1;

      if (earliest == 0) {
        orphans++;
      }
      if (earliest != record.firstAppearsAt) {
        incorrectEarliest++;
      }
      if (source.isEmpty) {
        missingStorySource++;
      }

      final declaredIndex = record.firstAppearsAt - 1;
      final declaredLevelValid =
          declaredIndex >= 0 && declaredIndex < forbiddenCityLockedStories.length;
      if (!declaredLevelValid ||
          source.isEmpty ||
          !forbiddenCityLockedStories[declaredIndex].contains(word) ||
          !forbiddenCityLockedStories[declaredIndex].contains(source)) {
        sameLevelFailures++;
      }
    }

    print('Vocabulary Trace:');
    print('records checked: ${records.length}');
    print('incorrect earliest: $incorrectEarliest');
    print('missing storySource: $missingStorySource');
    print('same-level failures: $sameLevelFailures');
    print('orphans: $orphans');

    expect(records, isNotEmpty);
    expect(validateForbiddenCityWordTrace(), isEmpty);
    expect(validateForbiddenCityImportedWords(), isEmpty);
    expect(incorrectEarliest, 0);
    expect(missingStorySource, 0);
    expect(sameLevelFailures, 0);
    expect(orphans, 0);
    expect(
      records.singleWhere((record) => record.entry.word == '判断').firstAppearsAt,
      3,
    );
    expect(
      records.singleWhere((record) => record.entry.word == '证据').firstAppearsAt,
      5,
    );
  });
}
