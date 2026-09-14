import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/models/language_proficiency.dart';
import 'package:phoenix_journeys/services/journey_preparation_coordinator.dart';

void main() {
  const profile = ChineseProficiencyProfile(
    track: ChineseExamTrack.hsk,
    levelCode: '5',
    levelLabel: '5',
    band: PhoenixReadingBand.intermediate,
    phoenixLevel: 5,
  );

  setUp(JourneyPreparationCoordinator.instance.clearForTesting);

  test('prepared bundle is keyed by journey level and script', () async {
    final coordinator = JourneyPreparationCoordinator.instance;
    final first = await coordinator.prepare(
      journeyId: 'beijing-forbidden-city',
      profile: profile,
      scriptMode: 'simplified',
    );
    final again = coordinator.prepareNow(
      journeyId: 'beijing-forbidden-city',
      profile: profile,
      scriptMode: 'simplified',
    );

    expect(identical(first, again), isTrue);
    expect(first.key.phoenixLevel, 5);
    expect(first.levelContent.storyParagraphs, isNotEmpty);
    expect(first.levelContent.storyAnnotations.length,
        first.levelContent.storyParagraphs.length);
    expect(first.narrationItems, first.levelContent.storyParagraphs);
    expect(first.challengeSourceMaterial, first.levelContent.storyParagraphs);
  });

  test('different script mode has an independent bundle identity', () {
    final coordinator = JourneyPreparationCoordinator.instance;
    final simplified = coordinator.prepareNow(
      journeyId: 'beijing-forbidden-city',
      profile: profile,
      scriptMode: 'simplified',
    );
    final traditional = coordinator.prepareNow(
      journeyId: 'beijing-forbidden-city',
      profile: profile,
      scriptMode: 'traditional',
    );

    expect(identical(simplified, traditional), isFalse);
  });
}
