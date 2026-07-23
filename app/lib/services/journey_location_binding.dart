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

  JourneyMapPoint get mapPoint {
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

final PhoenixWorldStoryAgent _journeyGeoAgent = PhoenixWorldStoryAgent(
  nodes: worldGeoCatalog,
);

final Map<String, JourneyLocationBinding> journeyLocationBindings =
    _buildJourneyLocationBindings();

Map<String, JourneyLocationBinding> _buildJourneyLocationBindings() {
  final bindings = <String, JourneyLocationBinding>{};
  final paths = <String>{};
  final geoNodeIds = <String>{};

  for (final journey in dailyJourneyExperiences) {
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
