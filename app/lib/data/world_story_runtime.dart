import '../agents/phoenix_world_story_agent.dart';
import '../models/story_content.dart';
import 'beijing_story_catalog.dart';
import 'world_geo_catalog.dart';

PhoenixWorldStoryAgent createPhoenixWorldStoryAgent() {
  return PhoenixWorldStoryAgent(
    nodes: worldGeoCatalog,
    sources: beijingStorySources,
    journeys: beijingJourneyCatalog,
  );
}

JourneyContentRecord requireJourneyContent(
  PhoenixWorldStoryAgent agent,
  String journeyId,
) {
  final journey = agent.findJourney(journeyId);
  if (journey == null) {
    throw StateError('Journey content not registered: $journeyId');
  }
  if (!agent.isJourneyPublishable(journeyId)) {
    throw StateError(
      'Journey content failed publication checks: '
      '${agent.publicationIssues(journeyId).join(', ')}',
    );
  }
  return journey;
}
