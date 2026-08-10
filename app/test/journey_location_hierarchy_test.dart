import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/agents/phoenix_world_story_agent.dart';
import 'package:phoenix_journeys/data/world_geo_catalog.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';

void main() {
  test('municipalities resolve one node as province-level and city-equivalent',
      () {
    final beijing = requireJourneyLocation('beijing-forbidden-city');
    final shanghai = requireJourneyLocation('shanghai-bund');

    expect(beijing.countryNode?.name, '中国');
    expect(beijing.provinceLevelName, '北京市');
    expect(beijing.cityEquivalentName, '北京市');
    expect(beijing.districtName, '东城区');
    expect(beijing.placeName, '故宫博物院');
    expect(beijing.isMunicipality, isTrue);
    expect(beijing.compactAdministrativeLabel, '北京市 · 东城区');
    expect(beijing.compactAdministrativeLabel, isNot(contains('北京市 · 北京市')));

    expect(shanghai.provinceLevelName, '上海市');
    expect(shanghai.cityEquivalentName, '上海市');
    expect(shanghai.districtName, '黄浦区');
    expect(shanghai.placeName, '外滩');
    expect(shanghai.isMunicipality, isTrue);
    expect(shanghai.compactAdministrativeLabel, '上海市 · 黄浦区');
  });

  test('normal provinces resolve canonical country to place hierarchy', () {
    final cases = <String, List<String>>{
      'chengdu-kuanzhai-alley': ['中国', '四川省', '成都市', '宽窄巷子'],
      'hangzhou-west-lake': ['中国', '浙江省', '杭州市', '西湖文化景观'],
      'xian-city-wall': ['中国', '陕西省', '西安市', '西安城墙'],
      'nanjing-qinhuai-river': ['中国', '江苏省', '南京市', '夫子庙秦淮风光带'],
    };

    for (final entry in cases.entries) {
      final location = requireJourneyLocation(entry.key);
      expect(
        location.canonicalGeoPath.map((node) => node.name),
        orderedEquals(entry.value),
      );
      expect(location.countryNode?.name, '中国');
      expect(location.provinceLevelNode, isNotNull);
      expect(location.cityEquivalentNode, isNotNull);
      expect(location.districtNode, isNull);
      expect(location.placeName, entry.value.last);
      expect(location.isMunicipality, isFalse);
      expect(
        location.compactAdministrativeLabel,
        '${entry.value[1]} · ${entry.value[2]}',
      );
    }
  });

  test('China prefecture and county levels project without rewriting GeoNodes',
      () {
    final honghe = requireJourneyLocation('honghe-hani-rice-terraces');

    expect(honghe.provinceLevelName, '云南省');
    expect(honghe.cityEquivalentName, '红河哈尼族彝族自治州');
    expect(honghe.districtName, '元阳县');
    expect(honghe.placeName, '哈尼梯田');
    expect(
      honghe.compactAdministrativeLabel,
      '云南省 · 红河哈尼族彝族自治州',
    );
  });

  test('every registered production Journey has display-ready geography', () {
    final geographicJourneys = journeyLocationBindings.values.where(
      (location) => location.countryNode?.countryCode == 'CN',
    );
    for (final location in geographicJourneys) {
      expect(location.countryNode, isNotNull, reason: location.journeyId);
      expect(location.provinceLevelNode, isNotNull,
          reason: location.journeyId);
      expect(location.cityEquivalentNode, isNotNull,
          reason: location.journeyId);
      expect(location.placeName, isNotEmpty, reason: location.journeyId);
    }
  });

  test('Guangzhou geography is ready without Journey authoring', () {
    final agent = PhoenixWorldStoryAgent(nodes: worldGeoCatalog);
    final path = agent.pathTo('cn-guangdong-guangzhou-chen-clan');

    expect(
      path.where((node) => node.id != 'world').map((node) => node.name),
      orderedEquals(['中国', '广东省', '广州市', '陈家祠']),
    );
    expect(path.last.latitude, isNotNull);
    expect(path.last.longitude, isNotNull);
  });

  test('coverage derives all counts from canonical Journey bindings', () {
    final coverage = journeyLocationCoverage;
    final beijing = requireJourneyLocation('beijing-forbidden-city');
    final chengdu = requireJourneyLocation('chengdu-kuanzhai-alley');

    expect(coverage.journeyCount, journeyLocationBindings.length);
    expect(coverage.coveredPlaceCount, journeyLocationBindings.length);
    expect(coverage.coveredProvinceLevelRegionCount, greaterThan(1));
    expect(coverage.coveredCityEquivalentRegionCount, greaterThan(1));
    expect(
      coverage.journeyCountForProvinceLevelRegion(
        beijing.provinceLevelNode!.id,
      ),
      2,
    );
    expect(
      coverage.journeyCountForCityEquivalentRegion(
        beijing.cityEquivalentNode!.id,
      ),
      2,
    );
    expect(
      coverage.journeyCountForProvinceLevelRegion(
        chengdu.provinceLevelNode!.id,
      ),
      greaterThanOrEqualTo(1),
    );
  });
}
