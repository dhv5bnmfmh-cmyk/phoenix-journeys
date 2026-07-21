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
    required this.assetPath,
    required this.generatedOn,
    required this.origin,
    required this.complianceReviewed,
    required this.complianceScore,
    this.pageTypes = JourneyBackgroundPage.values,
  });

  final String id;
  final String journeyId;
  final String assetPath;
  final DateTime generatedOn;
  final JourneyBackgroundOrigin origin;
  final bool complianceReviewed;
  final int complianceScore;
  final List<JourneyBackgroundPage> pageTypes;

  bool supports(JourneyBackgroundPage page) => pageTypes.contains(page);
  bool get approved => complianceReviewed && complianceScore >= 90;
}
