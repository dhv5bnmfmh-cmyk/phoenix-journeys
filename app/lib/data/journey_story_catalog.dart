import 'daily_journey_catalog.dart';
import 'forbidden_city_story_two_content.dart';

/// Shared Story registry for a Destination. Product behavior keys only on the
/// destination/story identity exposed by [DailyJourneyExperience]; authored
/// packages remain independent data providers.
List<DailyJourneyExperience> get _registeredStoryExperiences {
  final byId = <String, DailyJourneyExperience>{
    for (final journey in allJourneyExperiences) journey.id: journey,
    forbiddenCityStoryTwoExperience.id: forbiddenCityStoryTwoExperience,
  };
  return List<DailyJourneyExperience>.unmodifiable(byId.values);
}

List<DailyJourneyExperience> storiesForDestination({
  required String cityId,
  required String destinationId,
}) {
  final stories = _registeredStoryExperiences
      .where(
        (journey) =>
            journey.cityId == cityId && journey.destinationId == destinationId,
      )
      .toList(growable: false)
    ..sort((a, b) {
      if (a.isPrimaryStory != b.isPrimaryStory) {
        return a.isPrimaryStory ? -1 : 1;
      }
      return a.storyTitle.compareTo(b.storyTitle);
    });
  return List<DailyJourneyExperience>.unmodifiable(stories);
}

List<DailyJourneyExperience> storiesForJourney(
  DailyJourneyExperience destinationJourney,
) =>
    storiesForDestination(
      cityId: destinationJourney.cityId,
      destinationId: destinationJourney.destinationId,
    );

bool destinationHasMultipleStories(DailyJourneyExperience journey) =>
    storiesForJourney(journey).length > 1;

DailyJourneyExperience primaryStoryForDestination({
  required String cityId,
  required String destinationId,
}) {
  final stories = storiesForDestination(
    cityId: cityId,
    destinationId: destinationId,
  );
  if (stories.isEmpty) {
    throw StateError('Destination has no registered Story: $cityId/$destinationId');
  }
  return stories.firstWhere(
    (story) => story.isPrimaryStory,
    orElse: () => stories.first,
  );
}
