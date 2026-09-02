enum PublicationState { reference, published, hidden, development }

class CityKnowledgeDomain {
  const CityKnowledgeDomain({
    required this.id,
    required this.cityId,
    required this.title,
    required this.description,
    required this.sourceRefs,
    required this.placeIds,
    required this.journeyIds,
    required this.tags,
  });

  final String id;
  final String cityId;
  final String title;
  final String description;
  final List<String> sourceRefs;
  final List<String> placeIds;
  final List<String> journeyIds;
  final List<String> tags;
}

class PlaceDefinition {
  const PlaceDefinition({
    required this.placeId,
    required this.cityId,
    required this.title,
    required this.knowledgeDomainIds,
    required this.sourceRefs,
    required this.publicationState,
  });

  final String placeId;
  final String cityId;
  final String title;
  final List<String> knowledgeDomainIds;
  final List<String> sourceRefs;
  final PublicationState publicationState;
}

class JourneyDefinition {
  const JourneyDefinition({
    required this.journeyId,
    required this.runtimeId,
    required this.cityId,
    required this.placeId,
    required this.title,
    required this.theme,
    required this.learningObjective,
    required this.knowledgeDomainIds,
    required this.sourceRefs,
    required this.storyIdentity,
    required this.sceneIds,
    required this.levelPolicy,
    required this.publicationState,
  });

  final String journeyId;
  final String runtimeId;
  final String cityId;
  final String placeId;
  final String title;
  final String theme;
  final String learningObjective;
  final List<String> knowledgeDomainIds;
  final List<String> sourceRefs;
  final String storyIdentity;
  final List<String> sceneIds;
  final String levelPolicy;
  final PublicationState publicationState;
}

class SceneSafeZone {
  const SceneSafeZone({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;
}

class JourneySceneDefinition {
  const JourneySceneDefinition({
    required this.sceneId,
    required this.cityId,
    required this.placeId,
    required this.journeyId,
    required this.title,
    required this.storyAnchor,
    required this.knowledgeAnchors,
    required this.paragraphBindings,
    required this.levelBands,
    required this.stageBindings,
    required this.landscapeAsset,
    required this.portraitAsset,
    required this.mobileFocalPoint,
    required this.desktopFocalPoint,
    required this.mobileSafeZone,
    required this.desktopSafeZone,
    required this.altText,
    required this.historicalNotes,
    required this.sourceRefs,
    required this.visualVerification,
    required this.promptVersion,
    required this.assetVersion,
  });

  final String sceneId;
  final String cityId;
  final String placeId;
  final String journeyId;
  final String title;
  final String storyAnchor;
  final List<String> knowledgeAnchors;
  final List<int> paragraphBindings;
  final List<String> levelBands;
  final List<String> stageBindings;
  final String landscapeAsset;
  final String portraitAsset;
  final (double, double) mobileFocalPoint;
  final (double, double) desktopFocalPoint;
  final SceneSafeZone mobileSafeZone;
  final SceneSafeZone desktopSafeZone;
  final String altText;
  final List<String> historicalNotes;
  final List<String> sourceRefs;
  final List<String> visualVerification;
  final String promptVersion;
  final String assetVersion;
}
