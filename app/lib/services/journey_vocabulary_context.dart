import '../data/daily_journey_experience.dart';
import '../data/journey_data.dart';

class JourneyVocabularyContext {
  const JourneyVocabularyContext({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  static const empty = JourneyVocabularyContext(
    chinese: '',
    pinyin: '',
    vietnamese: '',
    english: '',
  );

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;

  bool get isEmpty => chinese.isEmpty;

  String nativeText(String language) {
    return switch (language) {
      '英语' => english,
      '中文解释' => chinese,
      _ => vietnamese,
    };
  }
}

JourneyVocabularyContext findJourneyVocabularyContext({
  required DailyJourneyExperience activeJourney,
  required Iterable<DailyJourneyExperience> fallbackJourneys,
  required WordEntry entry,
}) {
  final activeMatch = _contextInJourney(activeJourney, entry);
  if (!activeMatch.isEmpty) return activeMatch;

  for (final journey in fallbackJourneys) {
    if (journey.id == activeJourney.id) continue;
    final match = _contextInJourney(journey, entry);
    if (!match.isEmpty) return match;
  }

  return JourneyVocabularyContext.empty;
}

JourneyVocabularyContext _contextInJourney(
  DailyJourneyExperience journey,
  WordEntry entry,
) {
  if (!journey.words.any((word) => word.word == entry.word)) {
    return JourneyVocabularyContext.empty;
  }

  for (var index = 0; index < journey.content.sections.length; index += 1) {
    final section = journey.content.sections[index];
    if (!section.text.contains(entry.word)) continue;
    final annotation = index < journey.storyAnnotations.length
        ? journey.storyAnnotations[index]
        : null;
    return JourneyVocabularyContext(
      chinese: section.text,
      pinyin: annotation?.pinyin ?? '',
      vietnamese: annotation?.vietnamese ?? '',
      english: annotation?.english ?? '',
    );
  }

  for (final discovery in journey.discoveries) {
    if (!discovery.text.contains(entry.word)) continue;
    return JourneyVocabularyContext(
      chinese: discovery.text,
      pinyin: discovery.pinyin,
      vietnamese: discovery.vietnamese,
      english: discovery.english,
    );
  }

  return JourneyVocabularyContext.empty;
}
