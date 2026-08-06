import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/agents/phoenix_world_story_agent.dart';
import 'package:phoenix_journeys/data/world_geo_catalog.dart';
import 'package:phoenix_journeys/data/world_story_runtime.dart';

void main() {
  PhoenixWorldStoryAgent buildAgent() {
    return PhoenixWorldStoryAgent(
      nodes: worldGeoNodes,
      journeys: worldJourneyRecords,
      sources: worldStorySources,
    );
  }

  test('builds the full path to the Forbidden City', () {
    final agent = buildAgent();

    expect(
      agent.pathForNode('cn-beijing-dongcheng-forbidden-city')
          .map((node) => node.id),
      ['world', 'asia', 'cn', 'cn-beijing', 'cn-beijing-dongcheng', 'cn-beijing-dongcheng-forbidden-city'],
    );
  });

  test('searches local and international aliases', () {
    final agent = buildAgent();

    expect(agent.searchGeo('Forbidden City').single.id,
        'cn-beijing-dongcheng-forbidden-city');
    expect(agent.searchGeo('北京').map((node) => node.id), contains('cn-beijing'));
  });

  test('rejects orphan geographic nodes', () {
    expect(
      () => PhoenixWorldStoryAgent(
        nodes: [
          ...worldGeoNodes,
          const GeoNode(
            id: 'orphan',
            type: GeoNodeType.place,
            name: 'Orphan',
            parentId: 'missing-parent',
          ),
        ],
        journeys: worldJourneyRecords,
        sources: worldStorySources,
      ),
      throwsStateError,
    );
  });

  test('binds the Beijing Journey to its precise place and evidence', () {
    final agent = buildAgent();
    final journey = agent.findJourney('beijing-forbidden-city');

    expect(journey, isNotNull);
    expect(journey!.geoNodeId, 'cn-beijing-dongcheng-forbidden-city');
    expect(journey.storyParagraphs, hasLength(4));
    expect(agent.sourcesForJourney(journey.id), hasLength(3));
    expect(agent.evidenceForSection(journey.id, 'story-2'), hasLength(3));
  });

  test('finds every place Journey from its country hierarchy', () {
    final agent = buildAgent();
    final ids = agent
        .journeysForGeo('cn', includeDescendants: true)
        .map((journey) => journey.id)
        .toSet();

    expect(ids, contains('beijing-forbidden-city'));
    expect(ids, contains('beijing-temple-of-heaven'));
    expect(agent.journeysForGeo('cn'), isEmpty);
  });

  test('marks the seeded Beijing Journey publishable', () {
    final agent = buildAgent();

    expect(agent.publicationIssues('beijing-forbidden-city'), isEmpty);
    expect(agent.isJourneyPublishable('beijing-forbidden-city'), isTrue);
  });

  test('blocks publication when evidence is weak or unverified', () {
    final source = worldStorySources.first;
    final journey = worldJourneyRecords.first;
    final weakAgent = PhoenixWorldStoryAgent(
      nodes: worldGeoNodes,
      journeys: [
        journey.copyWith(
          sections: [
            JourneyStorySection(
              id: 'story-0',
              text: journey.sections.first.text,
              sourceIds: [source.id],
            ),
          ],
        ),
      ],
      sources: [source],
    );

    expect(weakAgent.isJourneyPublishable(journey.id), isFalse);
    expect(weakAgent.publicationIssues(journey.id), isNotEmpty);
  });
}
