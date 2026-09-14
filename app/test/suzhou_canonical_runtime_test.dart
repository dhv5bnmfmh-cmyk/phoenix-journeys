import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/adaptive_journey_level_runtime.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_expansion_catalog.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';

ChineseProficiencyProfile profile(int level) => ChineseProficiencyProfile(
  track: ChineseExamTrack.hsk,
  levelCode: '$level',
  levelLabel: '$level',
  band: PhoenixReadingBand.intermediate,
  phoenixLevel: level,
);

void main() {
  final experience = dailyJourneyExperiences.singleWhere(
    (item) => item.id == 'suzhou-humble-administrators-garden',
  );

  test('Suzhou canonical resolver uses verified sources and Gold Discovery depth', () {
    expect(experience.content.sourceIds, hasLength(3));
    const depth = <int>[2, 2, 2, 2, 3, 3, 3, 3, 3, 3];
    final seen = <String>{};
    for (var level = 1; level <= 10; level++) {
      final canonical = suzhouGardenCanonicalLevelContent(level);
      final runtime = resolveAdaptiveJourneyLevel(experience, profile: profile(level));
      expect(canonical.discoveries, hasLength(depth[level - 1]));
      expect(
        runtime.discoveries.map((item) => item.text),
        orderedEquals(canonical.discoveries.map((item) => item.text)),
      );
      for (final item in canonical.discoveries) {
        expect(seen.add(item.text), isTrue);
        expect(item.pinyin.trim(), isNotEmpty);
        expect(item.vietnamese.trim(), isNotEmpty);
        expect(item.english.trim(), isNotEmpty);
      }
    }
    expect(seen, hasLength(26));
  });
}