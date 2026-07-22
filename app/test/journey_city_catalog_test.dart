import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_city_catalog.dart';

void main() {
  test('published journeys expose stable city and destination paths', () {
    expect(journeyCityCatalog, hasLength(7));
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
      ]),
    );

    final paths = dailyJourneyExperiences
        .map((journey) => journey.locationPath)
        .toSet();
    expect(paths, hasLength(dailyJourneyExperiences.length));
    expect(paths, contains('beijing/forbidden-city'));
    expect(paths, contains('guangzhou/chen-clan-academy'));
  });

  test('one city can contain multiple destination journeys', () {
    final forbiddenCity = requireDailyJourneyExperience(
      'beijing-forbidden-city',
    );
    final summerPalace = DailyJourneyExperience(
      id: 'beijing-summer-palace',
      city: forbiddenCity.city,
      cityCode: forbiddenCity.cityCode,
      place: '颐和园',
      appBarTitle: '北京 · 颐和园',
      storyTitle: '颐和园故事',
      headline: forbiddenCity.headline,
      description: forbiddenCity.description,
      discoveryTeaser: forbiddenCity.discoveryTeaser,
      distanceLabel: forbiddenCity.distanceLabel,
      stampSymbol: '园',
      content: forbiddenCity.content,
      storyAnnotations: forbiddenCity.storyAnnotations,
      words: forbiddenCity.words,
      discoveries: forbiddenCity.discoveries,
      wonderQuestion: forbiddenCity.wonderQuestion,
      expressQuestion: forbiddenCity.expressQuestion,
    );

    final cities = buildJourneyCityCatalog([forbiddenCity, summerPalace]);
    final beijing = cities.single;

    expect(beijing.id, 'beijing');
    expect(beijing.name, '北京');
    expect(beijing.destinationCount, 2);
    expect(
      beijing.destinations.map((journey) => journey.destinationId),
      orderedEquals(['forbidden-city', 'summer-palace']),
    );
    expect(beijing.destinationById('summer-palace')?.place, '颐和园');
  });

  test('duplicate destination ids inside one city are rejected', () {
    final journey = requireDailyJourneyExperience('shanghai-bund');

    expect(
      () => buildJourneyCityCatalog([journey, journey]),
      throwsStateError,
    );
  });
}
