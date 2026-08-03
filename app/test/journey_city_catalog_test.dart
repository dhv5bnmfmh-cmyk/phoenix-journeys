import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_city_catalog.dart';

void main() {
  test('published journeys expose stable city and destination paths', () {
    expect(journeyCityCatalog, hasLength(26));
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
      ]),
    );

    final paths =
        dailyJourneyExperiences.map((journey) => journey.locationPath).toSet();
    expect(paths, hasLength(dailyJourneyExperiences.length));
    expect(paths, contains('beijing/forbidden-city'));
    expect(paths, contains('beijing/summer-palace'));
    expect(paths, contains('guangzhou/chen-clan-ancestral-hall'));
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

  test('Journey lookup is exact for normal and special IDs', () {
    final normal = journeyExperienceById('beijing-summer-palace');
    final special = journeyExperienceById('literary-roaming');

    expect(normal?.id, 'beijing-summer-palace');
    expect(special?.id, 'literary-roaming');
    expect(requireDailyJourneyExperience(normal!.id), same(normal));
    expect(requireDailyJourneyExperience(special!.id), same(special));
  });

  test('unknown, empty, and stale Journey IDs never select another Journey', () {
    final firstNormalId = dailyJourneyExperiences.first.id;

    for (final invalidId in const [
      'unknown-journey',
      '',
      'removed-journey-v0',
    ]) {
      expect(journeyExperienceById(invalidId), isNull);
      expect(
        () => requireDailyJourneyExperience(invalidId),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains(invalidId),
          ),
        ),
      );
      expect(invalidId, isNot(firstNormalId));
    }
  });

  test('city lookup is exact and invalid IDs never select the first city', () {
    final beijing = journeyCityById('beijing');

    expect(beijing?.id, 'beijing');
    expect(requireJourneyCity('beijing'), same(beijing));
    for (final invalidId in const ['unknown-city', '', 'removed-city-v0']) {
      expect(journeyCityById(invalidId), isNull);
      expect(
        () => requireJourneyCity(invalidId),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains(invalidId),
          ),
        ),
      );
      expect(() => journeysForCity(invalidId), throwsStateError);
    }
  });

  test('Journey-to-city mismatch cannot substitute a different destination', () {
    final beijing = requireJourneyCity('beijing');
    final shanghai = requireDailyJourneyExperience('shanghai-bund');

    expect(beijing.destinationById(shanghai.destinationId), isNull);
    expect(
      beijing.destinations.any((journey) => journey.id == shanghai.id),
      isFalse,
    );
    expect(
      journeyCityById(shanghai.cityId)?.destinationById(
        shanghai.destinationId,
      ),
      same(shanghai),
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
