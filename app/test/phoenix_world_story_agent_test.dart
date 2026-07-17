import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/agents/phoenix_world_story_agent.dart';
import 'package:phoenix_journeys/data/world_geo_catalog.dart';

void main() {
  test('builds the full path to the Forbidden City', () {
    final agent = PhoenixWorldStoryAgent(nodes: worldGeoCatalog);

    final path = agent.pathTo('cn-beijing-dongcheng-forbidden-city');

    expect(
      path.map((node) => node.name),
      ['世界', '中国', '北京市', '东城区', '故宫博物院'],
    );
  });

  test('searches local and international aliases', () {
    final agent = PhoenixWorldStoryAgent(nodes: worldGeoCatalog);

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
}
