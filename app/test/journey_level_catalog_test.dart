import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/data/journey_level_catalog.dart';

void main() {
  group('Summer Palace adaptive levels', () {
    final journey = requireDailyJourneyExperience('beijing-summer-palace');

    test('offers light, standard, and challenge journeys', () {
      expect(
        supportedJourneyDifficulties(journey),
        JourneyDifficulty.values,
      );
    });

    test('light journey reduces reading and vocabulary load', () {
      final easy = resolveJourneyLevel(journey, JourneyDifficulty.easy);
      final standard = resolveJourneyLevel(journey, JourneyDifficulty.standard);

      expect(easy.words.length, lessThan(standard.words.length));
      expect(
        easy.storyParagraphs.join().length,
        lessThan(standard.storyParagraphs.join().length),
      );
      expect(easy.storyAnnotations.length, easy.storyParagraphs.length);
    });

    test('challenge journey increases depth without changing destination', () {
      final standard = resolveJourneyLevel(journey, JourneyDifficulty.standard);
      final challenge = resolveJourneyLevel(journey, JourneyDifficulty.challenge);

      expect(
        challenge.storyParagraphs.join().length,
        greaterThan(standard.storyParagraphs.join().length),
      );
      expect(challenge.words.length, standard.words.length);
      expect(challenge.storyAnnotations.length, challenge.storyParagraphs.length);
      expect(challenge.wonderQuestion, contains('重新解释自然'));
    });

    test('storage parser safely falls back to standard', () {
      expect(parseJourneyDifficulty('easy'), JourneyDifficulty.easy);
      expect(parseJourneyDifficulty('challenge'), JourneyDifficulty.challenge);
      expect(parseJourneyDifficulty('unknown'), JourneyDifficulty.standard);
      expect(parseJourneyDifficulty(null), JourneyDifficulty.standard);
    });
  });

  test('other destinations remain standard until level content is prepared', () {
    final journey = requireDailyJourneyExperience('beijing-forbidden-city');
    expect(
      supportedJourneyDifficulties(journey),
      const <JourneyDifficulty>[JourneyDifficulty.standard],
    );
  });
}
