class JourneyStoryIdentity {
  const JourneyStoryIdentity({
    required this.journeyId,
    required this.destinationId,
    required this.storyId,
    required this.isPrimaryStory,
  });

  final String journeyId;
  final String destinationId;
  final String storyId;
  final bool isPrimaryStory;

  String get identityPath => '$destinationId/$storyId';
}

const String forbiddenCityGoldenJourneyId = 'beijing-forbidden-city';
const String forbiddenCityGoldenStoryId = 'two-roads-one-map';
const String forbiddenCityStoryTwoJourneyId =
    'beijing-forbidden-city-wuying-hall-light';
const String forbiddenCityStoryTwoId = 'wuying-hall-light-limit';

const _explicitJourneyStoryIdentities = <String, JourneyStoryIdentity>{
  forbiddenCityGoldenJourneyId: JourneyStoryIdentity(
    journeyId: forbiddenCityGoldenJourneyId,
    destinationId: 'forbidden-city',
    storyId: forbiddenCityGoldenStoryId,
    isPrimaryStory: true,
  ),
  forbiddenCityStoryTwoJourneyId: JourneyStoryIdentity(
    journeyId: forbiddenCityStoryTwoJourneyId,
    destinationId: 'forbidden-city',
    storyId: forbiddenCityStoryTwoId,
    isPrimaryStory: false,
  ),
};

JourneyStoryIdentity journeyStoryIdentityFor(String journeyId) {
  final explicit = _explicitJourneyStoryIdentities[journeyId];
  if (explicit != null) return explicit;
  return JourneyStoryIdentity(
    journeyId: journeyId,
    destinationId: _legacyDestinationId(journeyId),
    storyId: 'primary',
    isPrimaryStory: true,
  );
}

String _legacyDestinationId(String journeyId) {
  if (journeyId == 'guangzhou-chen-clan-academy') {
    return 'chen-clan-ancestral-hall';
  }
  final separator = journeyId.indexOf('-');
  if (separator < 0 || separator == journeyId.length - 1) return journeyId;
  return journeyId.substring(separator + 1);
}
