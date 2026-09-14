import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';
import 'package:phoenix_journeys/data/xian_city_wall_one_pass.dart';

void main() {
  test('legacy difficulty resolution cannot resurrect old Xi\'an tourist content', () {
    final experience = requireDailyJourneyExperience(xianCityWallJourneyId);

    for (final entry in <(JourneyDifficulty, int)>[
      (JourneyDifficulty.easy, 1),
      (JourneyDifficulty.standard, 5),
      (JourneyDifficulty.challenge, 10),
    ]) {
      final resolved = resolveJourneyLevel(experience, entry.$1);
      final canonical = xianCityWallOnePassLevelContent(entry.$2);
      expect(identical(resolved.storyParagraphs, canonical.storyParagraphs), isTrue);
      expect(resolved.storyParagraphs.join(), contains('周遥'));
      expect(resolved.storyParagraphs.join(), contains('永宁门'));
      expect(resolved.storyParagraphs.join(), contains('跑表'));
      expect(resolved.storyParagraphs.join(), contains('新家'));
      expect(
        resolved.storyParagraphs.join(),
        isNot(contains('傍晚，你从永宁门走上西安城墙')),
      );
      expect(
        resolved.storyParagraphs.join(),
        isNot(contains('沿着西安的时间边界前进')),
      );
    }
  });
}
