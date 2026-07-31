// Compatibility marker: beijingForbiddenCityJourney
// Compatibility marker: summerPalaceJourneyExperience

export 'daily_journey_catalog_base.dart'
    hide
        dailyStorySources,
        dailyJourneyRecords,
        dailyJourneyExperiences,
        allJourneyExperiences,
        allDailyJourneyWords,
        requireDailyJourneyExperience,
        dailyJourneyForDate;
export 'daily_journey_experience.dart';

import 'daily_journey_catalog_base.dart' as base;
import 'daily_journey_experience.dart';
import 'journey_expansion_batch_six.dart';
import 'special_journey_catalog.dart';
import '../models/story_content.dart';

final dailyStorySources = <StorySourceRecord>[
  ...base.dailyStorySources,
  ...journeyExpansionBatchSixSources,
];

final dailyJourneyRecords = <JourneyContentRecord>[
  ...base.dailyJourneyRecords,
  ...journeyExpansionBatchSixRecords,
];

final dailyJourneyExperiences = <DailyJourneyExperience>[
  ...base.dailyJourneyExperiences,
  ...journeyExpansionBatchSixExperiences,
];

final allJourneyExperiences = <DailyJourneyExperience>[
  ...dailyJourneyExperiences,
  ...specialJourneyExperiences,
];

final List<WordEntry> allDailyJourneyWords = List<WordEntry>.unmodifiable(
  <String, WordEntry>{
    for (final journey in allJourneyExperiences)
      for (final entry in journey.words) entry.word: entry,
  }.values,
);

DailyJourneyExperience requireDailyJourneyExperience(String id) {
  return allJourneyExperiences.firstWhere(
    (journey) => journey.id == id,
    orElse: () => dailyJourneyExperiences.first,
  );
}

DailyJourneyExperience dailyJourneyForDate(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final epoch = DateTime.utc(2026, 1, 1);
  final dayNumber = day.difference(epoch).inDays;
  final index = dayNumber % dailyJourneyExperiences.length;
  return dailyJourneyExperiences[index < 0
      ? index + dailyJourneyExperiences.length
      : index];
}
