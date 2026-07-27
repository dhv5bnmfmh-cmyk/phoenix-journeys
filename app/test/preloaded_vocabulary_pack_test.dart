import 'package:flutter_test/flutter_test.dart';

import 'package:phoenix_journeys/data/daily_journey_catalog.dart';
import 'package:phoenix_journeys/services/phoenix_vocabulary_service.dart';

void main() {
  test('every published word has a complete offline vocabulary fallback', () {
    final missing = <String>[];

    for (final journey in dailyJourneyExperiences) {
      for (final entry in journey.words) {
        final bundled = PhoenixVocabularyService.bundledExampleForWord(
          entry.word,
        );
        if (bundled != null) {
          if (!bundled.chinese.contains(entry.word) ||
              bundled.pinyin.trim().isEmpty ||
              bundled.native.trim().isEmpty ||
              bundled.english.trim().isEmpty ||
              bundled.usageNote.trim().isEmpty) {
            missing.add('${journey.id}/${entry.word}: bundled example incomplete');
          }
          continue;
        }

        if (entry.examples.isNotEmpty) {
          final example = entry.examples.first;
          if (!example.chinese.contains(entry.word) ||
              example.pinyin.trim().isEmpty ||
              example.vietnamese.trim().isEmpty ||
              example.english.trim().isEmpty) {
            missing.add('${journey.id}/${entry.word}: curated example incomplete');
          }
          continue;
        }

        var found = false;
        for (var index = 0; index < journey.content.sections.length; index += 1) {
          final section = journey.content.sections[index];
          if (!section.text.contains(entry.word) ||
              index >= journey.storyAnnotations.length) {
            continue;
          }
          final annotation = journey.storyAnnotations[index];
          if (annotation.pinyin.trim().isNotEmpty &&
              annotation.vietnamese.trim().isNotEmpty &&
              annotation.english.trim().isNotEmpty) {
            found = true;
            break;
          }
        }

        if (!found) {
          for (final discovery in journey.discoveries) {
            if (!discovery.text.contains(entry.word)) continue;
            if (discovery.pinyin.trim().isNotEmpty &&
                discovery.vietnamese.trim().isNotEmpty &&
                discovery.english.trim().isNotEmpty) {
              found = true;
              break;
            }
          }
        }

        if (!found &&
            (entry.pinyin.trim().isEmpty ||
                entry.simpleChinese.trim().isEmpty ||
                entry.nativeDefinition('越南语').trim().isEmpty ||
                entry.englishDefinition.trim().isEmpty)) {
          missing.add('${journey.id}/${entry.word}: fallback incomplete');
        }
      }
    }

    expect(
      missing,
      isEmpty,
      reason: 'Incomplete offline vocabulary fallbacks:\n${missing.join('\n')}',
    );
  });
}
