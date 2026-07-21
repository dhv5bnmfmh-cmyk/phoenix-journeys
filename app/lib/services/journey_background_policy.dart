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

  static const int dailyApprovedTargetPerDestination = 4;
  static const int minimumDestinationInventory = 20;
  static const int minimumPageInventory = 5;
  static const int minimumComplianceScore = 90;

  JourneyBackgroundAsset? select({
    required String journeyId,
    required JourneyBackgroundPage page,
    required DateTime localDate,
    required List<JourneyBackgroundAsset> catalog,
  }) {
    final candidates = catalog
        .where(
          (asset) =>
              asset.journeyId == journeyId &&
              asset.approved &&
              asset.complianceScore >= minimumComplianceScore &&
              asset.supports(page),
        )
        .toList(growable: false)
      ..sort((left, right) => left.id.compareTo(right.id));
    if (candidates.isEmpty) return null;

    final dayKey = '${localDate.year}-${localDate.month}-${localDate.day}';
    final index =
        _stableHash('$journeyId|${page.name}|$dayKey') % candidates.length;
    return candidates[index];
  }

  JourneyBackgroundKpi inspect({
    required String journeyId,
    required JourneyBackgroundPage page,
    required List<JourneyBackgroundAsset> catalog,
  }) {
    final destinationAssets = catalog
        .where((asset) => asset.journeyId == journeyId && asset.approved)
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

  int _stableHash(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }
}
