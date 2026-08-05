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

    test('standard journey uses two balanced long paragraphs', () {
      final standard = resolveJourneyLevel(journey, JourneyDifficulty.standard);
      expect(standard.storyParagraphs, hasLength(2));
      expect(standard.storyAnnotations, hasLength(2));
      expect(standard.discoveries, hasLength(2));
    });

    test('challenge journey adds analytical depth without changing destination',
        () {
      final standard = resolveJourneyLevel(journey, JourneyDifficulty.standard);
      final challenge =
          resolveJourneyLevel(journey, JourneyDifficulty.challenge);

      expect(challenge.words.length, standard.words.length);
      expect(
        challenge.discoveries.length,
        greaterThanOrEqualTo(standard.discoveries.length),
      );
      expect(
        challenge.storyAnnotations.length,
        challenge.storyParagraphs.length,
      );
      expect(challenge.wonderQuestion, contains('摄影选择'));
      expect(challenge.expressQuestion, contains('遗产态度'));
    });

    test('all difficulty modes preserve Pilot N1 causal identity', () {
      for (final difficulty in JourneyDifficulty.values) {
        final level = resolveJourneyLevel(journey, difficulty);
        final story = level.storyParagraphs.join();
        expect(story, contains('许澄'), reason: difficulty.name);
        expect(story, contains('周岚'), reason: difficulty.name);
        expect(story, contains('旧照片'), reason: difficulty.name);
        expect(story, contains('修复'), reason: difficulty.name);
        expect(story, anyOf(contains('选择'), contains('先把照片捡回来')),
            reason: difficulty.name);
        expect(level.storyAnnotations.length, level.storyParagraphs.length);
      }
    });

    test('storage parser safely falls back to standard', () {
      expect(parseJourneyDifficulty('easy'), JourneyDifficulty.easy);
      expect(parseJourneyDifficulty('challenge'), JourneyDifficulty.challenge);
      expect(parseJourneyDifficulty('unknown'), JourneyDifficulty.standard);
      expect(parseJourneyDifficulty(null), JourneyDifficulty.standard);
    });
  });

  test('other destinations remain standard until level content is prepared',
      () {
    final journey = requireDailyJourneyExperience('beijing-forbidden-city');
    expect(
      supportedJourneyDifficulties(journey),
      const <JourneyDifficulty>[JourneyDifficulty.standard],
    );
  });
}
