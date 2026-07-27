import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/world_story_runtime.dart';

void main() {
  test('runtime serves a publishable Beijing Forbidden City Journey', () {
    final agent = createPhoenixWorldStoryAgent();
    final journey = requireJourneyContent(agent, 'beijing-forbidden-city');

    expect(journey.geoNodeId, 'cn-beijing-dongcheng-forbidden-city');
    expect(journey.storyParagraphs, hasLength(4));
    expect(agent.sourcesForJourney(journey.id), hasLength(3));
    expect(agent.isJourneyPublishable(journey.id), isTrue);
  });

  test('runtime rejects an unknown Journey ID', () {
    final agent = createPhoenixWorldStoryAgent();

    expect(
      () => requireJourneyContent(agent, 'unknown-journey'),
      throwsStateError,
    );
  });
}
