import '../models/journey_background.dart';

class JourneyBackgroundKpi {
  const JourneyBackgroundKpi({
    required this.destinationInventory,
    required this.pageInventory,
    required this.destinationTargetMet,
    required this.pageTargetMet,
  });

  final int destinationInventory;
  final int pageInventory;
  final bool destinationTargetMet;
  final bool pageTargetMet;
}

class JourneyBackgroundPolicy {
  const JourneyBackgroundPolicy();

  static const int requiredOfflineInventoryPerDestination = 10;
  static const int minimumDestinationInventory =
      requiredOfflineInventoryPerDestination;
  static const int minimumPageInventory =
      requiredOfflineInventoryPerDestination;
  static const int minimumComplianceScore = 90;
  static const int minimumVarietyScore = 80;

  JourneyBackgroundAsset? select({
    required String journeyId,
    String? locationPath,
    required JourneyBackgroundPage page,
    required DateTime localDate,
    required List<JourneyBackgroundAsset> catalog,
  }) {
    final eligible = catalog
        .where(
          (asset) =>
              asset.journeyId == journeyId &&
              _matchesLocation(asset, locationPath) &&
              asset.approved &&
              asset.complianceScore >= minimumComplianceScore &&
              asset.varietyScore >= minimumVarietyScore &&
              asset.supports(page),
        )
        .toList(growable: false);

    final aiGenerated = eligible
        .where((asset) => asset.origin == JourneyBackgroundOrigin.aiGenerated)
        .toList(growable: false);
    final candidates = aiGenerated.isNotEmpty ? aiGenerated : eligible;

    if (candidates.isEmpty) return null;
    candidates.sort((left, right) => left.id.compareTo(right.id));

    final dayKey = '${localDate.year}-${localDate.month}-${localDate.day}';
    final identity = locationPath ?? journeyId;
    final index =
        _stableHash('$identity|${page.name}|$dayKey') % candidates.length;
    return candidates[index];
  }

  JourneyBackgroundKpi inspect({
    required String journeyId,
    String? locationPath,
    required JourneyBackgroundPage page,
    required List<JourneyBackgroundAsset> catalog,
  }) {
    final destinationAssets = catalog
        .where(
          (asset) =>
              asset.journeyId == journeyId &&
              _matchesLocation(asset, locationPath) &&
              asset.approved &&
              asset.origin == JourneyBackgroundOrigin.aiGenerated,
        )
        .toList(growable: false);
    final pageAssets = destinationAssets
        .where((asset) => asset.supports(page))
        .toList(growable: false);
    return JourneyBackgroundKpi(
      destinationInventory: destinationAssets.length,
      pageInventory: pageAssets.length,
      destinationTargetMet:
          destinationAssets.length >= minimumDestinationInventory,
      pageTargetMet: pageAssets.length >= minimumPageInventory,
    );
  }

  bool _matchesLocation(JourneyBackgroundAsset asset, String? locationPath) {
    if (locationPath == null ||
        asset.origin != JourneyBackgroundOrigin.aiGenerated) {
      return true;
    }
    final normalizedAssetPath = asset.assetPath.replaceAll('\\', '/');
    final normalizedLocationPath = locationPath.replaceAll('\\', '/');
    return normalizedAssetPath.contains(
      '/backgrounds/generated/$normalizedLocationPath/',
    );
  }

  int _stableHash(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }
}
