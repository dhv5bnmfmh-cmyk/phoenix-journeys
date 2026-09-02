import '../data/journey_level_catalog.dart';

class JourneyPreparationKey {
  const JourneyPreparationKey({
    required this.journeyId,
    required this.phoenixLevel,
    required this.scriptMode,
  });

  final String journeyId;
  final int phoenixLevel;
  final String scriptMode;

  @override
  bool operator ==(Object other) =>
      other is JourneyPreparationKey &&
      other.journeyId == journeyId &&
      other.phoenixLevel == phoenixLevel &&
      other.scriptMode == scriptMode;

  @override
  int get hashCode => Object.hash(journeyId, phoenixLevel, scriptMode);
}

class JourneyLayoutMetadata {
  const JourneyLayoutMetadata({required this.storyCharacterCount});

  final int storyCharacterCount;
}

/// Immutable, Journey-agnostic material consumed by the six-stage session.
class JourneyPreparedBundle {
  const JourneyPreparedBundle({
    required this.key,
    required this.levelContent,
    required this.narrationItems,
    required this.challengeSourceMaterial,
    required this.layoutMetadata,
  });

  final JourneyPreparationKey key;
  final JourneyLevelContent levelContent;
  final List<String> narrationItems;
  final List<String> challengeSourceMaterial;
  final JourneyLayoutMetadata layoutMetadata;
}
