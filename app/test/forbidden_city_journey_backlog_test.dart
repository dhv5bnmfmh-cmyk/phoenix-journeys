import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_backlog.dart';
import 'package:phoenix_journeys/data/journey_publication_catalog.dart';

void main() {
  test('Forbidden City future Journey backlog is planning-only and complete',
      () {
    expect(
      forbiddenCityFutureJourneyKnowledgeBacklog.keys,
      containsAll(<String>[
        'architecture',
        'history',
        'court_life',
        'ritual',
        'craft',
        'collections',
        'conservation',
        'culture_customs',
      ]),
    );
    expect(
      forbiddenCityFutureJourneyKnowledgeBacklog.values
          .expand((items) => items),
      containsAll(<String>[
        '中轴',
        '屋顶等级',
        '斗拱',
        '榫卯',
        '故宫博物院成立',
        '冬季取暖',
        '朝会',
        '琉璃',
        '档案',
        '最小干预',
        '数字保护',
        '色彩象征',
      ]),
    );
    expect(publishedJourneyRuntimeIds, ['beijing-forbidden-city']);
  });
}
