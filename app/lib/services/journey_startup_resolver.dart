import '../data/world_geo_catalog.dart';
import '../models/geo_node.dart';
import '../state/app_state.dart';
import 'journey_location_binding.dart';

import '../data/journey_startup_metadata.dart';
export '../data/journey_startup_metadata.dart';

class JourneyStartupLocation {
  const JourneyStartupLocation({
    required this.metadata,
    required this.placeNode,
  });

  final JourneyStartupMetadata metadata;
  final GeoNode placeNode;

  double get latitude => placeNode.latitude!;
  double get longitude => placeNode.longitude!;

  JourneyMapPoint get mapPoint {
    const calibratedPoints = <String, JourneyMapPoint>{
      'beijing/forbidden-city': JourneyMapPoint(x: 0.63, y: 0.29),
      'beijing/summer-palace': JourneyMapPoint(x: 0.63, y: 0.29),
      'shanghai/bund': JourneyMapPoint(x: 0.76, y: 0.43),
      'xian/city-wall': JourneyMapPoint(x: 0.49, y: 0.39),
      'hangzhou/west-lake': JourneyMapPoint(x: 0.70, y: 0.49),
      'chengdu/kuanzhai-alley': JourneyMapPoint(x: 0.38, y: 0.54),
      'nanjing/qinhuai-river': JourneyMapPoint(x: 0.64, y: 0.44),
      'guangzhou/chen-clan-ancestral-hall': JourneyMapPoint(x: 0.53, y: 0.67),
    };
    final calibratedPoint = calibratedPoints[metadata.locationPath];
    if (calibratedPoint != null) return calibratedPoint;

    const minLongitude = 100.0;
    const maxLongitude = 123.0;
    const minLatitude = 22.0;
    const maxLatitude = 41.0;
    final longitudeRatio =
        ((longitude - minLongitude) / (maxLongitude - minLongitude)).clamp(0.0, 1.0);
    final latitudeRatio =
        ((latitude - minLatitude) / (maxLatitude - minLatitude)).clamp(0.0, 1.0);
    return JourneyMapPoint(
      x: (0.38 + longitudeRatio * 0.50).clamp(0.38, 0.88).toDouble(),
      y: (0.72 - latitudeRatio * 0.44).clamp(0.28, 0.72).toDouble(),
    );
  }
}

final Map<String, GeoNode> _startupGeoNodeById = <String, GeoNode>{
  for (final node in worldGeoCatalog) node.id: node,
};
final Map<String, JourneyStartupLocation> _startupLocationCache =
    <String, JourneyStartupLocation>{};

JourneyStartupLocation requireJourneyStartupLocation(String journeyId) {
  final cached = _startupLocationCache[journeyId];
  if (cached != null) return cached;
  final metadata = requireJourneyStartupMetadata(journeyId);
  final node = _startupGeoNodeById[metadata.geoNodeId];
  if (node == null || !node.isPlace || node.latitude == null || node.longitude == null) {
    throw StateError(
      'Journey $journeyId startup location is invalid: ${metadata.geoNodeId}.',
    );
  }
  final location = JourneyStartupLocation(metadata: metadata, placeNode: node);
  _startupLocationCache[journeyId] = location;
  return location;
}

extension JourneyStartupAppState on AppState {
  JourneyStartupMetadata get activeJourneyMetadata =>
      requireJourneyStartupMetadata(activeJourneyId);
  JourneyStartupLocation get activeJourneyStartupLocation =>
      requireJourneyStartupLocation(activeJourneyId);
}
