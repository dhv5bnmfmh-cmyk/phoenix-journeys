enum JourneyBackgroundPage {
  explore,
  passport,
  profile,
  story,
  vocabulary,
  discovery,
  reflection,
  writing,
  memory,
  completion,
}

enum JourneyBackgroundOrigin { aiGenerated, originalSeed }

class JourneyBackgroundAsset {
  const JourneyBackgroundAsset({
    required this.id,
    required this.journeyId,
    required this.generatedOn,
    required this.origin,
    required this.complianceReviewed,
    required this.complianceScore,
    this.assetPath,
    this.svgData,
    this.varietyScore = 100,
    this.pageTypes = JourneyBackgroundPage.values,
  }) : assert(
          assetPath != null || svgData != null,
          'A background needs an assetPath or inline SVG data.',
        );

  final String id;
  final String journeyId;
  final String? assetPath;
  final String? svgData;
  final DateTime generatedOn;
  final JourneyBackgroundOrigin origin;
  final bool complianceReviewed;
  final int complianceScore;
  final int varietyScore;
  final List<JourneyBackgroundPage> pageTypes;

  bool supports(JourneyBackgroundPage page) => pageTypes.contains(page);

  bool get approved =>
      complianceReviewed && complianceScore >= 90 && varietyScore >= 80;
}
