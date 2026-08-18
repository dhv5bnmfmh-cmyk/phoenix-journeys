import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';

void main() {
  group('startup lazy Journey registry', () {
    test('schedule IDs preserve canonical publication order and membership',
        () {
      expect(dailyJourneyIds, hasLength(27));
      expect(dailyJourneyIds.toSet(), hasLength(dailyJourneyIds.length));
      expect(
        dailyJourneyExperiences.map((journey) => journey.id).toList(),
        dailyJourneyIds,
      );
    });

    test('date mapping preserves modulo semantics including pre-epoch', () {
      final dates = <DateTime>[
        DateTime.utc(2025, 12, 1),
        DateTime.utc(2025, 12, 31),
        DateTime.utc(2026, 1, 1),
        DateTime.utc(2026, 1, 27),
        DateTime.utc(2026, 8, 18),
        DateTime.utc(2030, 1, 1),
      ];
      final epoch = DateTime.utc(2026, 1, 1);
      for (final date in dates) {
        final day = DateTime.utc(date.year, date.month, date.day);
        final dayNumber = day.difference(epoch).inDays;
        final rawIndex = dayNumber % dailyJourneyIds.length;
        final index =
            rawIndex < 0 ? rawIndex + dailyJourneyIds.length : rawIndex;
        expect(dailyJourneyIdForDate(date), dailyJourneyIds[index]);
        expect(dailyJourneyForDate(date).id, dailyJourneyIds[index]);
      }
    });

    test('every registered ID resolves directly', () {
      for (final id in dailyJourneyIds) {
        expect(requireDailyJourneyExperience(id).id, id);
      }
    });

    test('full catalog remains available to governance paths', () {
      expect(allJourneyExperiences, isNotEmpty);
      expect(
        allJourneyExperiences.map((journey) => journey.id).toSet(),
        containsAll(dailyJourneyIds),
      );
    });
  });

  group('lazy Journey location binding', () {
    test('selected binding preserves namespaces and identity', () {
      const id = 'lijiang-old-town';
      final journey = requireDailyJourneyExperience(id);
      final binding = requireJourneyLocation(id);
      expect(binding.journeyId, id);
      expect(binding.geoNodeId, journey.geoNodeId);
      expect(binding.locationPath, journey.locationPath);
      expect(binding.storageNamespace, 'journey.${journey.locationPath}');
      expect(binding.legacyStorageNamespace, 'journey.$id');
    });

    test('full validation still materializes complete valid coverage', () {
      final bindings =
          buildJourneyLocationBindingsForValidation(allJourneyExperiences);
      expect(bindings.length, allJourneyExperiences.length);
      expect(bindings.keys.toSet(),
          allJourneyExperiences.map((e) => e.id).toSet());
      expect(
        bindings.values.map((e) => e.locationPath).toSet().length,
        bindings.length,
      );
      expect(
        bindings.values.map((e) => e.geoNodeId).toSet().length,
        bindings.length,
      );
    });
  });
}
