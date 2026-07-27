import 'daily_journey_catalog.dart';

class JourneyCityCatalogEntry {
  const JourneyCityCatalogEntry({
    required this.id,
    required this.name,
    required this.cityCode,
    required this.destinations,
  });

  final String id;
  final String name;
  final String cityCode;
  final List<DailyJourneyExperience> destinations;

  int get destinationCount => destinations.length;

  DailyJourneyExperience get primaryDestination => destinations.first;

  DailyJourneyExperience? destinationById(String destinationId) {
    for (final destination in destinations) {
      if (destination.destinationId == destinationId) return destination;
    }
    return null;
  }
}

List<JourneyCityCatalogEntry> buildJourneyCityCatalog(
  Iterable<DailyJourneyExperience> journeys,
) {
  final cityOrder = <String>[];
  final grouped = <String, List<DailyJourneyExperience>>{};

  for (final journey in journeys) {
    final cityId = journey.cityId;
    final destinations = grouped.putIfAbsent(cityId, () {
      cityOrder.add(cityId);
      return <DailyJourneyExperience>[];
    });

    if (destinations.isNotEmpty) {
      final city = destinations.first;
      if (city.city != journey.city || city.cityCode != journey.cityCode) {
        throw StateError(
          'Journey city metadata does not match for $cityId: '
          '${city.city}/${city.cityCode} and '
          '${journey.city}/${journey.cityCode}.',
        );
      }
    }

    if (destinations.any(
      (destination) => destination.destinationId == journey.destinationId,
    )) {
      throw StateError(
        'Duplicate destination ${journey.destinationId} in city $cityId.',
      );
    }

    destinations.add(journey);
  }

  return List<JourneyCityCatalogEntry>.unmodifiable(
    cityOrder.map((cityId) {
      final destinations = List<DailyJourneyExperience>.unmodifiable(
        grouped[cityId]!,
      );
      final city = destinations.first;
      return JourneyCityCatalogEntry(
        id: cityId,
        name: city.city,
        cityCode: city.cityCode,
        destinations: destinations,
      );
    }),
  );
}

final List<JourneyCityCatalogEntry> journeyCityCatalog =
    buildJourneyCityCatalog(dailyJourneyExperiences);

JourneyCityCatalogEntry requireJourneyCity(String cityId) {
  return journeyCityCatalog.firstWhere(
    (city) => city.id == cityId,
    orElse: () => journeyCityCatalog.first,
  );
}

List<DailyJourneyExperience> journeysForCity(String cityId) {
  return requireJourneyCity(cityId).destinations;
}
