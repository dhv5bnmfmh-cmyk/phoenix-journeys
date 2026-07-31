import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_city_catalog.dart';

void main() {
  test('published journeys expose stable city and destination paths', () {
    expect(journeyCityCatalog, hasLength(31));
    expect(
      journeyCityCatalog.map((city) => city.id),
      orderedEquals([
        'beijing',
        'shanghai',
        'xian',
        'hangzhou',
        'chengdu',
        'nanjing',
        'guangzhou',
        'suzhou',
        'luoyang',
        'quanzhou',
        'datong',
        'lijiang',
        'jiangmen',
        'dunhuang',
        'chengde',
        'xiamen',
        'pingyao',
        'qufu',
        'leshan',
        'wuyishan',
        'honghe',
        'huangshan',
        'zhangjiajie',
        'kaifeng',
        'dali',
        'harbin',
        'dujiangyan',
        'chongqing',
        'shiyan',
        'longyan',
        'shenyang',
      ]),
    );

    final paths =
        dailyJourneyExperiences.map((journey) => journey.locationPath).toSet();
    expect(paths, hasLength(dailyJourneyExperiences.length));
    expect(paths, contains('beijing/forbidden-city'));
    expect(paths, contains('beijing/summer-palace'));
    expect(paths, contains('guangzhou/chen-clan-ancestral-hall'));
    expect(paths, contains('dujiangyan/irrigation-system'));
    expect(paths, contains('chongqing/dazu-rock-carvings'));
    expect(paths, contains('shiyan/wudang-mountains'));
    expect(paths, contains('longyan/fujian-tulou'));
    expect(paths, contains('shenyang/imperial-palace'));
  });

  test('Beijing publishes two independent destination journeys', () {
    final beijing = requireJourneyCity('beijing');

    expect(beijing.destinationCount, 2);
    expect(
      beijing.destinations.map((journey) => journey.destinationId),
      orderedEquals(['forbidden-city', 'summer-palace']),
    );
    expect(beijing.destinationById('summer-palace')?.place, '颐和园');
    expect(
      requireDailyJourneyExperience('beijing-summer-palace').locationPath,
      'beijing/summer-palace',
    );
  });

  test('duplicate destination ids inside one city are rejected', () {
    final journey = requireDailyJourneyExperience('shanghai-bund');

    expect(
      () => buildJourneyCityCatalog([journey, journey]),
      throwsStateError,
    );
  });
}
