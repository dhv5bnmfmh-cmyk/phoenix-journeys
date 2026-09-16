import '../models/language_proficiency.dart';
import 'daily_journey_experience.dart';
import 'forbidden_city_story_two_content.dart';
import 'journey_level_catalog.dart';
import 'journey_story_identity.dart';

typedef AuthoredJourneyLevelProvider = JourneyLevelContent Function(
  ChineseProficiencyProfile profile,
  Set<String> knownWords,
);

int _levelForBand(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 9,
      PhoenixReadingBand.mastery => 10,
    };

final Map<String, AuthoredJourneyLevelProvider> authoredJourneyLevelProviders =
    <String, AuthoredJourneyLevelProvider>{
  forbiddenCityStoryTwoJourneyId: (profile, knownWords) =>
      forbiddenCityStoryTwoLevelContent(
        profile.phoenixLevel ?? _levelForBand(profile.band),
        knownWords: knownWords,
      ),
};

JourneyLevelContent? resolveRegisteredAuthoredJourneyLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  required Set<String> knownWords,
}) {
  final provider = authoredJourneyLevelProviders[experience.id];
  return provider?.call(profile, knownWords);
}
