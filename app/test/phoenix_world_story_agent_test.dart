import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_world_story_agent.dart';
import 'package:phoenix_journeys/data/beijing_story_catalog.dart';
import 'package:phoenix_journeys/data/world_geo_catalog.dart';
import 'package:phoenix_journeys/models/story_content.dart';

void main() {
  PhoenixWorldStoryAgent buildAgent() {
    return PhoenixWorldStoryAgent(
      nodes: worldGeoCatalog,
      sources: beijingStorySources,
      journeys: beijingJourneyCatalog,
    );
  }

  test('builds the full path to the Forbidden City', () {
    final agent = buildAgent();

    final path = agent.pathTo('cn-beijing-dongcheng-forbidden-city');

    expect(
      path.map((node) => node.name),
      ['世界', '中国', '北京市', '东城区', '故宫博物院'],
    );
  });

  test('searches local and international aliases', () {
    final agent = buildAgent();

    expect(agent.search('Forbidden City').single.name, '故宫博物院');
    expect(agent.search('北京').map((node) => node.id), contains('cn-beijing'));
  });

  test('rejects orphan geographic nodes', () {
    final agent = PhoenixWorldStoryAgent();

    expect(
      () => agent.register(worldGeoCatalog.last),
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

  test('finds a place Journey from its country hierarchy', () {
    final agent = buildAgent();

    expect(
      agent.journeysForGeo('cn', includeDescendants: true).single.id,
      'beijing-forbidden-city',
    );
    expect(agent.journeysForGeo('cn'), isEmpty);
  });

  test('marks the seeded Beijing Journey publishable', () {
    final agent = buildAgent();

    expect(agent.publicationIssues('beijing-forbidden-city'), isEmpty);
    expect(agent.isJourneyPublishable('beijing-forbidden-city'), isTrue);
  });

  test('blocks publication when evidence is weak or unverified', () {
    const draftSource = StorySourceRecord(
      id: 'draft-source',
      title: 'Draft notes',
      publisher: 'Unknown editor',
      url: 'https://example.com/draft',
      kind: StorySourceKind.editorial,
      languageCode: 'en',
      geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
      verificationStatus: StoryVerificationStatus.draft,
    );
    const draftJourney = JourneyContentRecord(
      id: 'draft-journey',
      title: 'Draft',
      geoNodeId: 'cn-beijing-dongcheng-forbidden-city',
      languageCode: 'zh-CN',
      verificationStatus: StoryVerificationStatus.draft,
      sections: [
        JourneyStorySection(
          id: 'draft-0',
          text: '尚未验证的故事。',
          sourceIds: ['draft-source'],
        ),
      ],
    );
    final agent = PhoenixWorldStoryAgent(
      nodes: worldGeoCatalog,
      sources: const [draftSource],
      journeys: const [draftJourney],
    );

    final issues = agent.publicationIssues('draft-journey');
    expect(issues, contains('故事尚未完成审核'));
    expect(issues, contains('故事至少需要两个独立权威来源'));
    expect(issues, contains('draft-source 尚未验证'));
    expect(agent.isJourneyPublishable('draft-journey'), isFalse);
  });
}
