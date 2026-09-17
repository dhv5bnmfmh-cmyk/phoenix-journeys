import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/journey_background_catalog.dart';
import 'package:phoenix_journeys/data/journey_background_story_two.dart';
import 'package:phoenix_journeys/data/journey_story_identity.dart';
import 'package:phoenix_journeys/models/journey_background.dart';
import 'package:phoenix_journeys/services/journey_background_policy.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';

void main() {
  test('Story 2 owns ten reviewed backgrounds in its story-scoped directory', () {
    final binding = requireJourneyLocation(forbiddenCityStoryTwoJourneyId);
    expect(forbiddenCityStoryTwoBackgrounds.length, 10);
    expect(
      binding.generatedBackgroundDirectory,
      'assets/images/backgrounds/generated/beijing/forbidden-city/wuying-hall-light-limit/',
    );
    expect(
      forbiddenCityStoryTwoBackgrounds.map((asset) => asset.id).toSet().length,
      10,
    );
    for (final asset in forbiddenCityStoryTwoBackgrounds) {
      expect(asset.journeyId, forbiddenCityStoryTwoJourneyId);
      expect(asset.assetPath.startsWith(binding.generatedBackgroundDirectory), isTrue);
      expect(asset.approved, isTrue);
    }
  });

  test('shared background policy resolves Story 2 art for every Journey page', () {
    final binding = requireJourneyLocation(forbiddenCityStoryTwoJourneyId);
    const policy = JourneyBackgroundPolicy();
    for (final page in JourneyBackgroundPage.values) {
      final selected = policy.select(
        journeyId: forbiddenCityStoryTwoJourneyId,
        locationPath: binding.locationPath,
        page: page,
        localDate: DateTime.utc(2026, 9, 16),
        catalog: journeyBackgroundCatalog,
      );
      expect(selected, isNotNull, reason: page.name);
      expect(selected!.journeyId, forbiddenCityStoryTwoJourneyId);
    }
  });
}
