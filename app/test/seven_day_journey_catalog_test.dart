import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/chengdu_kuanzhai_one_pass.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/data/guangzhou_chen_clan_one_pass.dart';

void main() {
  test('reviewed destinations rotate without repeating during one cycle',
      () {
    expect(dailyJourneyExperiences, hasLength(27));
    expect(
        dailyJourneyExperiences.map((item) => item.id).toSet(), hasLength(27));

    final cycle = List.generate(
      dailyJourneyExperiences.length,
      (index) => dailyJourneyForDate(DateTime(2026, 1, 1 + index)).id,
    );
    expect(cycle.toSet(), hasLength(dailyJourneyExperiences.length));
  });

  test('every journey has complete story and learning content', () {
    for (final journey in dailyJourneyExperiences) {
      if (journey.id == forbiddenCityJourneyId) {
        expect(journey.content.storyParagraphs, hasLength(1), reason: journey.id);
        expect(
          journey.content.storyParagraphs.single,
          forbiddenCityLockedStories.last,
          reason: journey.id,
        );
        expect(forbiddenCityLockedStories, hasLength(10));
        expect(journey.words.length, greaterThanOrEqualTo(9), reason: journey.id);
        expect(journey.discoveries.length, greaterThanOrEqualTo(4), reason: journey.id);
        continue;
      }

      if (journey.id == chengduKuanzhaiJourneyId) {
        expect(
          journey.content.storyParagraphs,
          chengduKuanzhaiOnePassLevels[4].storyParagraphs,
          reason: journey.id,
        );
      } else if (journey.id == guangzhouChenClanJourneyId) {
        expect(
          journey.content.storyParagraphs,
          guangzhouChenClanOnePassLevels[4].storyParagraphs,
          reason: journey.id,
        );
      } else if (journey.id == 'beijing-summer-palace') {
        expect(journey.content.storyParagraphs, hasLength(2), reason: journey.id);
        for (final paragraph in journey.content.storyParagraphs) {
          expect(
            paragraph.length,
            inInclusiveRange(260, 380),
            reason: journey.id,
          );
        }
      } else {
        expect(journey.content.storyParagraphs.length, 4, reason: journey.id);
      }
      expect(
        journey.storyAnnotations.length,
        journey.content.storyParagraphs.length,
        reason: journey.id,
      );
      expect(journey.words.length, greaterThanOrEqualTo(9), reason: journey.id);
      if (journey.id == chengduKuanzhaiJourneyId) {
        expect(
          journey.discoveries,
          hasLength(chengduKuanzhaiOnePassDiscoveries.length),
          reason: journey.id,
        );
      } else if (journey.id == guangzhouChenClanJourneyId) {
        expect(
          journey.discoveries,
          hasLength(guangzhouChenClanOnePassDiscoveries.length),
          reason: journey.id,
        );
      } else if (journey.id == 'beijing-summer-palace') {
        expect(journey.discoveries, hasLength(2), reason: journey.id);
      } else {
        expect(
          journey.discoveries.length,
          greaterThanOrEqualTo(4),
          reason: journey.id,
        );
      }
      expect(journey.wonderQuestion.trim(), isNotEmpty, reason: journey.id);
      expect(journey.expressQuestion.trim(), isNotEmpty, reason: journey.id);
    }
  });

  test('all published records use verified source ids', () {
    final sourceIds = dailyStorySources.map((item) => item.id).toSet();
    for (final record in dailyJourneyRecords) {
      expect(record.sourceIds, isNotEmpty, reason: record.id);
      expect(sourceIds.containsAll(record.sourceIds), isTrue,
          reason: record.id);
    }
  });
}
