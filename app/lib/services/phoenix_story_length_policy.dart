import '../models/language_proficiency.dart';

class PhoenixStoryLengthTarget {
  const PhoenixStoryLengthTarget({
    required this.minimumCharacters,
    required this.maximumCharacters,
    required this.paragraphCount,
    required this.enrichmentPacketCount,
  });

  final int minimumCharacters;
  final int maximumCharacters;
  final int paragraphCount;
  final int enrichmentPacketCount;

  int get preferredCharacters =>
      ((minimumCharacters + maximumCharacters) / 2).round();
}

PhoenixStoryLengthTarget phoenixStoryLengthTargetFor(
  ChineseProficiencyProfile profile,
) {
  final level = profile.phoenixLevel ?? _legacyLevel(profile.band);
  return phoenixStoryLengthTargetForLevel(level);
}

PhoenixStoryLengthTarget phoenixStoryLengthTargetForLevel(int level) {
  return switch (level.clamp(1, 10).toInt()) {
    1 => const PhoenixStoryLengthTarget(
        minimumCharacters: 150,
        maximumCharacters: 220,
        paragraphCount: 1,
        enrichmentPacketCount: 4,
      ),
    2 => const PhoenixStoryLengthTarget(
        minimumCharacters: 200,
        maximumCharacters: 280,
        paragraphCount: 1,
        enrichmentPacketCount: 6,
      ),
    3 => const PhoenixStoryLengthTarget(
        minimumCharacters: 260,
        maximumCharacters: 340,
        paragraphCount: 2,
        enrichmentPacketCount: 8,
      ),
    4 => const PhoenixStoryLengthTarget(
        minimumCharacters: 320,
        maximumCharacters: 420,
        paragraphCount: 2,
        enrichmentPacketCount: 10,
      ),
    5 => const PhoenixStoryLengthTarget(
        minimumCharacters: 380,
        maximumCharacters: 500,
        paragraphCount: 2,
        enrichmentPacketCount: 13,
      ),
    6 => const PhoenixStoryLengthTarget(
        minimumCharacters: 450,
        maximumCharacters: 580,
        paragraphCount: 2,
        enrichmentPacketCount: 16,
      ),
    7 => const PhoenixStoryLengthTarget(
        minimumCharacters: 520,
        maximumCharacters: 650,
        paragraphCount: 2,
        enrichmentPacketCount: 18,
      ),
    8 => const PhoenixStoryLengthTarget(
        minimumCharacters: 580,
        maximumCharacters: 720,
        paragraphCount: 2,
        enrichmentPacketCount: 20,
      ),
    9 => const PhoenixStoryLengthTarget(
        minimumCharacters: 650,
        maximumCharacters: 800,
        paragraphCount: 2,
        enrichmentPacketCount: 22,
      ),
    _ => const PhoenixStoryLengthTarget(
        minimumCharacters: 720,
        maximumCharacters: 900,
        paragraphCount: 2,
        enrichmentPacketCount: 24,
      ),
  };
}

int _legacyLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 8,
      PhoenixReadingBand.mastery => 10,
    };
