import '../models/city_standard.dart';
import 'daily_journey_catalog.dart';

const referenceJourneyRuntimeId = 'beijing-forbidden-city';

const publishedJourneyRuntimeIds = <String>[
  referenceJourneyRuntimeId,
];

PublicationState journeyPublicationState(String journeyId) {
  if (journeyId == referenceJourneyRuntimeId) {
    return PublicationState.reference;
  }
  if (journeyExperienceById(journeyId) != null) {
    return PublicationState.hidden;
  }
  return PublicationState.development;
}

bool isJourneyDiscoverable(String journeyId) {
  final state = journeyPublicationState(journeyId);
  return state == PublicationState.reference ||
      state == PublicationState.published;
}

final List<String> hiddenLegacyJourneyRuntimeIds = List<String>.unmodifiable(
  dailyJourneyIds.where((journeyId) => !isJourneyDiscoverable(journeyId)),
);
