import '../models/geo_node.dart';
import '../services/journey_location_binding.dart';
import 'journey_city_catalog.dart';

class JourneyProvinceCatalogEntry {
  const JourneyProvinceCatalogEntry({
    required this.id,
    required this.name,
    required this.geoNodeId,
    required this.cityIds,
    required this.cityEquivalentGeoNodeIds,
    required this.journeyCount,
    required this.isMunicipality,
  });

  final String id;
  final String name;
  final String geoNodeId;
  final List<String> cityIds;
  final List<String> cityEquivalentGeoNodeIds;
  final int journeyCount;
  final bool isMunicipality;

  int get cityCount => cityEquivalentGeoNodeIds.length;
}

final List<JourneyProvinceCatalogEntry> chinaProvinceCatalog =
    _buildChinaProvinceCatalog();

List<JourneyProvinceCatalogEntry> _buildChinaProvinceCatalog() {
  final provinceOrder = <String>[];
  final groups = <String, _MutableProvinceGroup>{};

  for (final city in journeyCityCatalog) {
    final primaryBinding = requireJourneyLocation(city.primaryDestination.id);
    final country = primaryBinding.countryNode;
    final provinceLevel = primaryBinding.provinceLevelNode;
    final cityEquivalent = primaryBinding.cityEquivalentNode;
    if (country?.id != 'cn' ||
        provinceLevel == null ||
        cityEquivalent == null) {
      throw StateError(
        'Journey city ${city.id} must resolve through country, '
        'province-level region, and city-equivalent region.',
      );
    }
    if (!_nodeMatchesProductCity(cityEquivalent, city.name)) {
      throw StateError(
        'Journey city key ${city.id} does not match its canonical '
        'city-equivalent GeoNode ${cityEquivalent.id}.',
      );
    }

    final group = groups.putIfAbsent(provinceLevel.id, () {
      provinceOrder.add(provinceLevel.id);
      return _MutableProvinceGroup(
        node: provinceLevel,
        isMunicipality: primaryBinding.isMunicipality,
      );
    });
    if (group.isMunicipality != primaryBinding.isMunicipality) {
      throw StateError(
        'Province-level region ${provinceLevel.id} has inconsistent '
        'municipality semantics.',
      );
    }

    for (final journey in city.destinations) {
      final binding = requireJourneyLocation(journey.id);
      if (binding.countryNode?.id != country.id ||
          binding.provinceLevelNode?.id != provinceLevel.id ||
          binding.cityEquivalentNode?.id != cityEquivalent.id) {
        throw StateError(
          'Journey ${journey.id} diverges from city ${city.id} geography.',
        );
      }
    }

    group.cityIds.add(city.id);
    group.cityEquivalentGeoNodeIds.add(cityEquivalent.id);
    group.journeyCount += city.destinationCount;
  }

  return List<JourneyProvinceCatalogEntry>.unmodifiable(
    provinceOrder.map((geoNodeId) {
      final group = groups[geoNodeId]!;
      return JourneyProvinceCatalogEntry(
        id: _chinaRegionId(group.node),
        name: group.node.name,
        geoNodeId: group.node.id,
        cityIds: List<String>.unmodifiable(group.cityIds),
        cityEquivalentGeoNodeIds: List<String>.unmodifiable(
          group.cityEquivalentGeoNodeIds,
        ),
        journeyCount: group.journeyCount,
        isMunicipality: group.isMunicipality,
      );
    }),
  );
}

String _chinaRegionId(GeoNode node) {
  const prefix = 'cn-';
  if (!node.id.startsWith(prefix) || node.id.length == prefix.length) {
    throw StateError('Invalid China province-level GeoNode ID: ${node.id}.');
  }
  return node.id.substring(prefix.length);
}

bool _nodeMatchesProductCity(GeoNode node, String cityName) {
  final names = <String>{
    node.name.replaceFirst(RegExp('市\$'), ''),
    ...node.aliases,
  };
  return names.contains(cityName);
}

class _MutableProvinceGroup {
  _MutableProvinceGroup({required this.node, required this.isMunicipality});

  final GeoNode node;
  final bool isMunicipality;
  final List<String> cityIds = <String>[];
  final Set<String> cityEquivalentGeoNodeIds = <String>{};
  int journeyCount = 0;
}

JourneyProvinceCatalogEntry requireJourneyProvince(String provinceId) {
  return chinaProvinceCatalog.firstWhere(
    (province) => province.id == provinceId,
    orElse: () => throw StateError(
      'Journey province-level region is not registered: $provinceId.',
    ),
  );
}
