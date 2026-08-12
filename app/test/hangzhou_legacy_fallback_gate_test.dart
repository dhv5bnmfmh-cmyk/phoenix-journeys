import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/hangzhou_west_lake_one_pass.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';

void main() {
  test('legacy difficulty resolution cannot resurrect old Hangzhou tourist content', () {
    final experience = requireDailyJourneyExperience(hangzhouWestLakeJourneyId);
    final expectedLevels = <JourneyDifficulty, int>{
      JourneyDifficulty.easy: 1,
      JourneyDifficulty.standard: 5,
      JourneyDifficulty.challenge: 10,
    };
    for (final entry in expectedLevels.entries) {
      final resolved = resolveJourneyLevel(experience, entry.key);
      final canonical = hangzhouWestLakeOnePassLevelContent(entry.value);
      expect(resolved.storyParagraphs, canonical.storyParagraphs, reason: entry.key.name);
      final story = resolved.storyParagraphs.join();
      expect(story, contains('方毓'));
      expect(story, contains('周绍庭'));
      expect(story, contains('预约卡'));
      expect(story, isNot(contains('许澄')));
      expect(story, isNot(contains('录音')));
      expect(story, isNot(contains('清晨，你沿着苏堤慢慢向前走')));
    }
  });
}
