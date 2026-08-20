import '../services/journey_startup_resolver.dart';
import 'daily_journey_catalog.dart';

class JourneyCityCatalogEntry {
  const JourneyCityCatalogEntry({
    required this.id,
    required this.name,
    required this.cityCode,
    required this.destinations,
    required this.primaryDestination,
  });

  final String id;
  final String name;
  final String cityCode;
  final List<DailyJourneyExperience> destinations;
  final ({String id}) primaryDestination;

  int get destinationCount => destinations.length;

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
        primaryDestination: (id: city.id),
      );
    }),
  );
}

DailyJourneyExperience _deferredJourney(
  JourneyStartupMetadata metadata,
) {
  return DeferredDailyJourneyExperience(
    id: metadata.id,
    city: metadata.city,
    cityCode: metadata.cityCode,
    place: metadata.place,
    distanceLabel: metadata.distanceLabel,
    stampSymbol: metadata.stampSymbol,
    geoNodeId: metadata.geoNodeId,
    resolve: () => requireDailyJourneyExperience(metadata.id),
  );
}

final List<JourneyCityCatalogEntry> journeyCityCatalog =
    List<JourneyCityCatalogEntry>.unmodifiable(
  journeyStartupCityCatalog.map(
    (city) => JourneyCityCatalogEntry(
      id: city.id,
      name: city.name,
      cityCode: city.cityCode,
      destinations: List<DailyJourneyExperience>.unmodifiable(
        city.destinations.map(_deferredJourney),
      ),
      primaryDestination: (id: city.primaryDestination.id),
    ),
  ),
);

JourneyCityCatalogEntry? journeyCityById(String cityId) {
  if (cityId.isEmpty) return null;
  for (final city in journeyCityCatalog) {
    if (city.id == cityId) return city;
  }
  return null;
}

JourneyCityCatalogEntry requireJourneyCity(String cityId) {
  final city = journeyCityById(cityId);
  if (city == null) {
    throw StateError('Journey city is not registered: "$cityId".');
  }
  return city;
}

List<DailyJourneyExperience> journeysForCity(String cityId) {
  return requireJourneyCity(cityId).destinations;
}
