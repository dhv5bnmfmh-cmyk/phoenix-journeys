import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_expansion_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';

ChineseProficiencyProfile profile(int level) => ChineseProficiencyProfile(
  track: ChineseExamTrack.hsk, levelCode: '$level', levelLabel: '$level',
  band: PhoenixReadingBand.intermediate, phoenixLevel: level,
);

void main() {
  final experience = dailyJourneyExperiences.singleWhere(
    (item) => item.id == 'suzhou-humble-administrators-garden',
  );

  test('runtime Lv1 Lv5 Lv10 equal locked Next Place package', () {
    for (final level in <int>[1, 5, 10]) {
      final runtime = resolveAdaptiveJourneyLevel(
        experience,
        profile: profile(level),
      );
      final canonical = suzhouGardenCanonicalLevelContent(level);
      expect(runtime.storyParagraphs, canonical.storyParagraphs);
      expect(runtime.discoveries, canonical.discoveries);
      expect(runtime.wonderQuestion, canonical.wonderQuestion);
      expect(runtime.expressQuestion, canonical.expressQuestion);
    }
  });

  test('Memory Completion and Discovery stay synchronized', () {
    final spec = batchOneMemorySpecFor(experience.id)!;
    expect(spec.storyResult, suzhouGardenMemoryResult);
    expect(spec.longTermAnchor, suzhouGardenMemoryAnchor);
    expect(spec.completionSummary, suzhouGardenCompletionSummary);
    expect(experience.discoveryTeaser, contains('视线'));
    expect(experience.discoveryTeaser, isNot(contains('喊他回来')));
  });
}
