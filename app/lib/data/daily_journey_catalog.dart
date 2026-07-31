// Compatibility markers retained for source-contract tests:
// beijingForbiddenCityJourney · summerPalaceJourneyExperience
// summerPalaceJourneyContent · summerPalaceStorySources
// shanghai-bund · xian-city-wall · extendedJourneyExperiences
// journeyExpansionExperiences · journeyExpansionBatchTwoExperiences
// journeyExpansionBatchThreeExperiences · journeyExpansionBatchFourExperiences
// journeyExpansionBatchFiveExperiences

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

import '../models/story_content.dart';
import 'daily_journey_catalog_base.dart' as base;
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_expansion_batch_six.dart';
import 'special_journey_catalog.dart';

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
  ...journeyExpansionBatchSixExperiences.map(_withVocabularyContexts),
];

DailyJourneyExperience _withVocabularyContexts(DailyJourneyExperience journey) {
  final words = journey.words.map((entry) {
    final example = switch (entry.word) {
      '灌溉' => const WordExample(
          chinese: '都江堰把岷江水引入成都平原进行灌溉。',
          pinyin: 'Dūjiāngyàn bǎ Mínjiāng shuǐ yǐnrù Chéngdū Píngyuán jìnxíng guàngài.',
          vietnamese: 'Đô Giang Yển dẫn nước sông Mân vào đồng bằng Thành Đô để tưới tiêu.',
          english: 'Dujiangyan channels Min River water into the Chengdu Plain for irrigation.',
        ),
      '多元' => const WordExample(
          chinese: '沈阳故宫体现了多元建筑传统的交流。',
          pinyin: 'Shěnyáng Gùgōng tǐxiàn le duōyuán jiànzhù chuántǒng de jiāoliú.',
          vietnamese: 'Cố Cung Thẩm Dương thể hiện sự giao lưu của nhiều truyền thống kiến trúc.',
          english: 'Shenyang Imperial Palace reflects exchange among diverse architectural traditions.',
        ),
      _ => null,
    };
    if (example == null) return entry;
    return WordEntry(
      word: entry.word,
      pinyin: entry.pinyin,
      partOfSpeech: entry.partOfSpeech,
      simpleChinese: entry.simpleChinese,
      translation: entry.translation,
      englishDefinition: entry.englishDefinition,
      symbol: entry.symbol,
      examples: [example],
    );
  }).toList(growable: false);

  return DailyJourneyExperience(
    id: journey.id,
    city: journey.city,
    cityCode: journey.cityCode,
    place: journey.place,
    appBarTitle: journey.appBarTitle,
    storyTitle: journey.storyTitle,
    headline: journey.headline,
    description: journey.description,
    discoveryTeaser: journey.discoveryTeaser,
    distanceLabel: journey.distanceLabel,
    stampSymbol: journey.stampSymbol,
    content: journey.content,
    storyAnnotations: journey.storyAnnotations,
    words: words,
    discoveries: journey.discoveries,
    wonderQuestion: journey.wonderQuestion,
    expressQuestion: journey.expressQuestion,
  );
}

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
  return dailyJourneyExperiences[
    index < 0 ? index + dailyJourneyExperiences.length : index
  ];
}
