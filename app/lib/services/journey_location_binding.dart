import '../agents/phoenix_world_story_agent.dart';
import '../data/daily_journey_catalog.dart';
import '../data/world_geo_catalog.dart';
import '../models/geo_node.dart';

class JourneyMapPoint {
  const JourneyMapPoint({required this.x, required this.y});

  final double x;
  final double y;

  @override
  bool operator ==(Object other) =>
      other is JourneyMapPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

class JourneyLocationBinding {
  const JourneyLocationBinding({
    required this.journey,
    required this.placeNode,
    required this.geoPath,
  });

  final DailyJourneyExperience journey;
  final GeoNode placeNode;
  final List<GeoNode> geoPath;

  GeoNode? get countryNode => _singleNodeOfKind(GeoNodeKind.country);
  GeoNode? get provinceLevelNode => _singleNodeOfKind(GeoNodeKind.adminLevel1);

  GeoNode? get cityEquivalentNode {
    final cityNode = _singleNodeOfKind(GeoNodeKind.city);
    if (cityNode != null) return cityNode;
    final provinceLevel = provinceLevelNode;
    if (provinceLevel != null && _isChinaMunicipality(provinceLevel)) {
      return provinceLevel;
    }
    return null;
  }

  GeoNode? get districtNode => _singleNodeOfKind(GeoNodeKind.district);

  String? get provinceLevelName => provinceLevelNode?.name;
  String? get cityEquivalentName => cityEquivalentNode?.name;
  String? get districtName => districtNode?.name;
  String get placeName => placeNode.name;

  bool get isMunicipality =>
      provinceLevelNode != null &&
      cityEquivalentNode?.id == provinceLevelNode?.id;

  List<GeoNode> get canonicalGeoPath => List<GeoNode>.unmodifiable(
        geoPath.where((node) => node.kind != GeoNodeKind.world),
      );

  List<String> get compactAdministrativeNames {
    final provinceLevel = provinceLevelNode;
    final cityEquivalent = cityEquivalentNode;
    final district = districtNode;
    final names = <String>[];
    if (provinceLevel != null) names.add(provinceLevel.name);
    if (cityEquivalent != null && cityEquivalent.id != provinceLevel?.id) {
      names.add(cityEquivalent.name);
    }
    if (isMunicipality && district != null) names.add(district.name);
    return List<String>.unmodifiable(names);
  }

  String get compactAdministrativeLabel =>
      compactAdministrativeNames.join(' · ');

  String get journeyId => journey.id;
  String get cityId => journey.cityId;
  String get destinationId => journey.destinationId;
  String get locationPath => journey.locationPath;
  String get geoNodeId => placeNode.id;
  String get storageNamespace => 'journey.$locationPath';
  String get legacyStorageNamespace => 'journey.$journeyId';
  String get generatedBackgroundDirectory =>
      'assets/images/backgrounds/generated/$locationPath/';

  double get latitude => placeNode.latitude!;
  double get longitude => placeNode.longitude!;

  GeoNode? _singleNodeOfKind(GeoNodeKind kind) {
    GeoNode? result;
    for (final node in geoPath) {
      if (node.kind != kind) continue;
      if (result != null) {
        throw StateError(
          'Journey $journeyId has more than one ${kind.name} GeoNode.',
        );
      }
      result = node;
    }
    return result;
  }

  JourneyMapPoint get mapPoint {
    // The home map is a hand-painted oblique relief, not a geographic
    // projection. These points are art-directed against the actual coastline
    // so the aircraft lands on the city represented by the label.
    const calibratedPoints = <String, JourneyMapPoint>{
      'beijing/forbidden-city': JourneyMapPoint(x: 0.63, y: 0.29),
      'beijing/summer-palace': JourneyMapPoint(x: 0.63, y: 0.29),
      'shanghai/bund': JourneyMapPoint(x: 0.76, y: 0.43),
      'xian/city-wall': JourneyMapPoint(x: 0.49, y: 0.39),
      'hangzhou/west-lake': JourneyMapPoint(x: 0.70, y: 0.49),
      'chengdu/kuanzhai-alley': JourneyMapPoint(x: 0.38, y: 0.54),
      'nanjing/qinhuai-river': JourneyMapPoint(x: 0.64, y: 0.44),
      'guangzhou/chen-clan-ancestral-hall': JourneyMapPoint(
        x: 0.53,
        y: 0.67,
      ),
    };
    final calibratedPoint = calibratedPoints[locationPath];
    if (calibratedPoint != null) return calibratedPoint;

    const minLongitude = 100.0;
    const maxLongitude = 123.0;
    const minLatitude = 22.0;
    const maxLatitude = 41.0;

    final longitudeRatio =
        ((longitude - minLongitude) / (maxLongitude - minLongitude)).clamp(
          0.0,
          1.0,
        );
    final latitudeRatio =
        ((latitude - minLatitude) / (maxLatitude - minLatitude)).clamp(
          0.0,
          1.0,
        );

    return JourneyMapPoint(
      x: (0.38 + longitudeRatio * 0.50).clamp(0.38, 0.88).toDouble(),
      y: (0.72 - latitudeRatio * 0.44).clamp(0.28, 0.72).toDouble(),
    );
  }
}

bool _isChinaMunicipality(GeoNode node) {
  return node.countryCode == 'CN' &&
      node.kind == GeoNodeKind.adminLevel1 &&
      node.localType == '直辖市';
}

class JourneyLocationCoverage {
  JourneyLocationCoverage._({
    required this.journeyCount,
    required this.coveredProvinceLevelRegionCount,
    required this.coveredCityEquivalentRegionCount,
    required this.coveredPlaceCount,
    required Map<String, int> provinceJourneyCounts,
    required Map<String, int> cityJourneyCounts,
  })  : _provinceJourneyCounts = Map.unmodifiable(provinceJourneyCounts),
        _cityJourneyCounts = Map.unmodifiable(cityJourneyCounts);

  factory JourneyLocationCoverage.fromBindings(
    Iterable<JourneyLocationBinding> bindings,
  ) {
    var journeyCount = 0;
    final provinceJourneyCounts = <String, int>{};
    final cityJourneyCounts = <String, int>{};
    final placeIds = <String>{};

    for (final binding in bindings) {
      journeyCount += 1;
      placeIds.add(binding.placeNode.id);
      final provinceLevel = binding.provinceLevelNode;
      final cityEquivalent = binding.cityEquivalentNode;
      if (provinceLevel != null) {
        provinceJourneyCounts.update(
          provinceLevel.id,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
      if (cityEquivalent != null) {
        cityJourneyCounts.update(
          cityEquivalent.id,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }

    return JourneyLocationCoverage._(
      journeyCount: journeyCount,
      coveredProvinceLevelRegionCount: provinceJourneyCounts.length,
      coveredCityEquivalentRegionCount: cityJourneyCounts.length,
      coveredPlaceCount: placeIds.length,
      provinceJourneyCounts: provinceJourneyCounts,
      cityJourneyCounts: cityJourneyCounts,
    );
  }

  final int journeyCount;
  final int coveredProvinceLevelRegionCount;
  final int coveredCityEquivalentRegionCount;
  final int coveredPlaceCount;
  final Map<String, int> _provinceJourneyCounts;
  final Map<String, int> _cityJourneyCounts;

  int journeyCountForProvinceLevelRegion(String geoNodeId) =>
      _provinceJourneyCounts[geoNodeId] ?? 0;

  int journeyCountForCityEquivalentRegion(String geoNodeId) =>
      _cityJourneyCounts[geoNodeId] ?? 0;
}

final PhoenixWorldStoryAgent _journeyGeoAgent = PhoenixWorldStoryAgent(
  nodes: worldGeoCatalog,
);

final Map<String, JourneyLocationBinding> journeyLocationBindings =
    _buildJourneyLocationBindings();

final JourneyLocationCoverage journeyLocationCoverage =
    JourneyLocationCoverage.fromBindings(journeyLocationBindings.values);

Map<String, JourneyLocationBinding> _buildJourneyLocationBindings() {
  final bindings = <String, JourneyLocationBinding>{};
  final paths = <String>{};
  final geoNodeIds = <String>{};

  for (final journey in allJourneyExperiences) {
    final node = _journeyGeoAgent.find(journey.content.geoNodeId);
    if (node == null) {
      throw StateError(
        'Journey ${journey.id} references unknown GeoNode: '
        '${journey.content.geoNodeId}.',
      );
    }
    if (!node.isPlace || node.latitude == null || node.longitude == null) {
      throw StateError(
        'Journey ${journey.id} must bind to a place GeoNode with coordinates.',
      );
    }
    if (!paths.add(journey.locationPath)) {
      throw StateError(
        'Duplicate Journey location path: ${journey.locationPath}.',
      );
    }
    if (!geoNodeIds.add(node.id)) {
      throw StateError('Duplicate Journey GeoNode binding: ${node.id}.');
    }

    final geoPath = _journeyGeoAgent.pathTo(node.id);
    if (geoPath.isEmpty || geoPath.last.id != node.id) {
      throw StateError('Incomplete GeoNode path for Journey ${journey.id}.');
    }

    final countryNodes = geoPath.where(
      (pathNode) => pathNode.kind == GeoNodeKind.country,
    );
    if (countryNodes.length != 1) {
      throw StateError(
        'Journey ${journey.id} must have exactly one country ancestor.',
      );
    }

    bindings[journey.id] = JourneyLocationBinding(
      journey: journey,
      placeNode: node,
      geoPath: List<GeoNode>.unmodifiable(geoPath),
    );
  }

  return Map<String, JourneyLocationBinding>.unmodifiable(bindings);
}

JourneyLocationBinding requireJourneyLocation(String journeyId) {
  final binding = journeyLocationBindings[journeyId];
  if (binding == null) {
    throw StateError('Journey location is not registered: $journeyId.');
  }
  return binding;
}
