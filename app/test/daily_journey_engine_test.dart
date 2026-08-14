import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/chengdu_kuanzhai_one_pass.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/guangzhou_chen_clan_one_pass.dart';
import 'package:phoenix_journeys/data/journey_expansion_catalog.dart';
import 'package:phoenix_journeys/data/luoyang_longmen_one_pass.dart';
import 'package:phoenix_journeys/data/world_story_runtime.dart';

void main() {
  test('the same calendar day always returns the same journey', () {
    final morning = dailyJourneyForDate(DateTime(2026, 7, 20, 8));
    final evening = dailyJourneyForDate(DateTime(2026, 7, 20, 22));

    expect(morning.id, evening.id);
  });

  test('three consecutive days rotate through three different journeys', () {
    final ids = <String>{
      dailyJourneyForDate(DateTime(2026, 7, 20)).id,
      dailyJourneyForDate(DateTime(2026, 7, 21)).id,
      dailyJourneyForDate(DateTime(2026, 7, 22)).id,
    };

    expect(ids, hasLength(3));
  });

  test('all daily journeys pass publication checks', () {
    final agent = createPhoenixWorldStoryAgent();

    for (final journey in dailyJourneyExperiences) {
      expect(
        agent.publicationIssues(journey.id),
        isEmpty,
        reason: journey.id,
      );

      if (journey.id == forbiddenCityJourneyId) {
        expect(journey.content.sections, hasLength(1));
        expect(
          journey.content.sections.single.text,
          forbiddenCityLockedStories.last,
          reason: 'Forbidden City catalog metadata must bind the locked canonical Story',
        );
      } else {
        expect(journey.storyAnnotations.length, journey.content.sections.length);
      }

      expect(journey.words.length, greaterThanOrEqualTo(9));
      if (journey.id == chengduKuanzhaiJourneyId) {
        expect(
          journey.content.storyParagraphs,
          chengduKuanzhaiOnePassLevels[4].storyParagraphs,
          reason: 'Chengdu catalog metadata must bind canonical Gold Lv5 Story',
        );
        expect(
          journey.discoveries.length,
          chengduKuanzhaiOnePassDiscoveries.length,
          reason: journey.id,
        );
      } else if (journey.id == guangzhouChenClanJourneyId) {
        expect(
          journey.content.storyParagraphs,
          guangzhouChenClanOnePassLevels[4].storyParagraphs,
          reason: 'Guangzhou catalog metadata must bind canonical Gold Lv5 Story',
        );
        expect(
          journey.discoveries.length,
          guangzhouChenClanOnePassDiscoveries.length,
          reason: journey.id,
        );
      } else if (journey.id == luoyangLongmenJourneyId) {
        expect(
          journey.content.storyParagraphs,
          luoyangLongmenOnePassLevels[4].storyParagraphs,
          reason: 'Longmen catalog metadata must bind canonical Gold Lv5 Story',
        );
        expect(
          journey.discoveries.length,
          luoyangLongmenOnePassLevels[4].discoveries.length,
          reason: journey.id,
        );
      } else if (journey.id == suzhouGardenJourney.id) {
        expect(
          journey.discoveries.length,
          26,
          reason: 'Suzhou publishes the complete Gold Discovery pool for level slicing',
        );
      } else {
        expect(
          journey.discoveries.length,
          journey.id == 'beijing-summer-palace' ? 2 : 4,
          reason: journey.id,
        );
      }
    }
  });
}
