import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/data/daily_journey_catalog.dart';

void main() {
  test('every published word has a complete preloaded example', () {
    for (final journey in dailyJourneyExperiences) {
      for (final entry in journey.words) {
        if (entry.examples.isNotEmpty) {
          final example = entry.examples.first;
          expect(
            example.chinese,
            contains(entry.word),
            reason: '${journey.id}/${entry.word} curated example misses word',
          );
          expect(example.pinyin.trim(), isNotEmpty);
          expect(example.vietnamese.trim(), isNotEmpty);
          expect(example.english.trim(), isNotEmpty);
          continue;
        }

        var found = false;
        for (var index = 0; index < journey.content.sections.length; index += 1) {
          final section = journey.content.sections[index];
          if (!section.text.contains(entry.word)) continue;
          expect(
            index,
            lessThan(journey.storyAnnotations.length),
            reason: '${journey.id}/${entry.word} has no story annotation',
          );
          final annotation = journey.storyAnnotations[index];
          expect(annotation.pinyin.trim(), isNotEmpty);
          expect(annotation.vietnamese.trim(), isNotEmpty);
          expect(annotation.english.trim(), isNotEmpty);
          found = true;
          break;
        }

        if (!found) {
          for (final discovery in journey.discoveries) {
            if (!discovery.text.contains(entry.word)) continue;
            expect(discovery.pinyin.trim(), isNotEmpty);
            expect(discovery.vietnamese.trim(), isNotEmpty);
            expect(discovery.english.trim(), isNotEmpty);
            found = true;
            break;
          }
        }

        expect(
          found,
          isTrue,
          reason:
              '${journey.id}/${entry.word} must ship with a real preloaded context',
        );
      }
    }
  });
}
