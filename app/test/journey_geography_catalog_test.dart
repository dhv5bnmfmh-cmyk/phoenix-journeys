import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/data/journey_city_catalog.dart';
import 'package:phoenix_journeys/data/journey_geography_catalog.dart';
import 'package:phoenix_journeys/models/geo_node.dart';
import 'package:phoenix_journeys/services/journey_location_binding.dart';

void main() {
  test('every city belongs to exactly one country and province', () {
    final assignedCityIds = <String>{};

    for (final province in chinaProvinceCatalog) {
      for (final cityId in province.cityIds) {
        expect(assignedCityIds.add(cityId), isTrue);

        final city = requireJourneyCity(cityId);
        final binding = requireJourneyLocation(city.primaryDestination.id);
        final countries = binding.geoPath.where(
          (node) => node.kind == GeoNodeKind.country,
        );
        final provinces = binding.geoPath.where(
          (node) => node.kind == GeoNodeKind.adminLevel1,
        );

        expect(countries.map((node) => node.id), ['cn']);
        expect(provinces.map((node) => node.id), [province.geoNodeId]);
        expect(binding.latitude, inInclusiveRange(18, 54));
        expect(binding.longitude, inInclusiveRange(73, 135));
      }
    }

    expect(
      assignedCityIds,
      journeyCityCatalog.map((city) => city.id).toSet(),
    );
  });

  test('municipalities skip a duplicate same-name city level', () {
    final beijing = requireJourneyProvince('beijing');
    final shanghai = requireJourneyProvince('shanghai');

    expect(beijing.isMunicipality, isTrue);
    expect(beijing.cityIds, ['beijing']);
    expect(shanghai.isMunicipality, isTrue);
    expect(shanghai.cityIds, ['shanghai']);
  });
}
