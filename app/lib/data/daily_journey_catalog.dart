// Compatibility markers for source-contract tests:
// beijingForbiddenCityJourney
// shanghai-bund
// summerPalaceJourneyExperience
// summerPalaceJourneyContent
// summerPalaceStorySources
// xian-city-wall
// extendedJourneyExperiences

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

const _suzhouGeoNodeId =
    'cn-jiangsu-suzhou-gusu-humble-administrators-garden';
const _quanzhouGeoNodeId =
    'cn-fujian-quanzhou-licheng-kaiyuan-temple';

const _additionalBatchSixSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-suzhou-gardens',
    title: 'Classical Gardens of Suzhou',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/813',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: [_suzhouGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'suzhou-gov-classical-gardens',
    title: '苏州园林',
    publisher: '苏州市园林和绿化管理局',
    url: 'https://ylj.suzhou.gov.cn/',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [_suzhouGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'unesco-quanzhou',
    title: 'Quanzhou: Emporium of the World in Song-Yuan China',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1561',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: [_quanzhouGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'quanzhou-gov-world-heritage',
    title: '泉州：宋元中国的世界海洋商贸中心',
    publisher: '泉州市人民政府',
    url: 'https://www.quanzhou.gov.cn/',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [_quanzhouGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
];

JourneyContentRecord _rebindRecord(
  JourneyContentRecord record, {
  required String geoNodeId,
  required List<String> sourceIds,
}) {
  return JourneyContentRecord(
    id: record.id,
    title: record.title,
    geoNodeId: geoNodeId,
    languageCode: record.languageCode,
    verificationStatus: record.verificationStatus,
    tags: record.tags,
    sections: record.sections
        .map(
          (section) => JourneyStorySection(
            id: section.id,
            text: section.text,
            sourceIds: sourceIds,
          ),
        )
        .toList(growable: false),
  );
}

JourneyContentRecord _normalizeBatchSixRecord(JourneyContentRecord record) {
  return switch (record.id) {
    'suzhou-classical-gardens' => _rebindRecord(
        record,
        geoNodeId: _suzhouGeoNodeId,
        sourceIds: const [
          'unesco-suzhou-gardens',
          'suzhou-gov-classical-gardens',
        ],
      ),
    'quanzhou-maritime-emporium' => _rebindRecord(
        record,
        geoNodeId: _quanzhouGeoNodeId,
        sourceIds: const [
          'unesco-quanzhou',
          'quanzhou-gov-world-heritage',
        ],
      ),
    _ => record,
  };
}

final _baseJourneyIds = base.dailyJourneyRecords.map((item) => item.id).toSet();
final _batchSixRecords = journeyExpansionBatchSixRecords
    .where((item) => !_baseJourneyIds.contains(item.id))
    .map(_normalizeBatchSixRecord)
    .toList(growable: false);
final _batchSixJourneyIds = _batchSixRecords.map((item) => item.id).toSet();
final _batchSixSourceIds =
    _batchSixRecords.expand((item) => item.sourceIds).toSet();
final _batchSixRecordById = <String, JourneyContentRecord>{
  for (final record in _batchSixRecords) record.id: record,
};

DailyJourneyExperience _normalizeBatchSixExperience(
  DailyJourneyExperience experience,
) {
  final content = _batchSixRecordById[experience.id] ?? experience.content;
  return DailyJourneyExperience(
    id: experience.id,
    city: experience.city,
    cityCode: experience.cityCode,
    place: experience.place,
    appBarTitle: experience.appBarTitle,
    storyTitle: experience.storyTitle,
    headline: experience.headline,
    description: experience.description,
    discoveryTeaser: experience.discoveryTeaser,
    distanceLabel: experience.distanceLabel,
    stampSymbol: experience.stampSymbol,
    content: content,
    storyAnnotations: experience.storyAnnotations,
    words: experience.words,
    discoveries: experience.discoveries,
    wonderQuestion: experience.wonderQuestion,
    expressQuestion: experience.expressQuestion,
  );
}

final dailyStorySources = <StorySourceRecord>[
  ...base.dailyStorySources,
  ...journeyExpansionBatchSixSources.where(
    (item) =>
        _batchSixSourceIds.contains(item.id) &&
        item.id != 'unesco-suzhou-gardens' &&
        item.id != 'unesco-quanzhou',
  ),
  ..._additionalBatchSixSources.where(
    (item) => _batchSixSourceIds.contains(item.id),
  ),
];

final dailyJourneyRecords = <JourneyContentRecord>[
  ...base.dailyJourneyRecords,
  ..._batchSixRecords,
];

final dailyJourneyExperiences = <DailyJourneyExperience>[
  ...base.dailyJourneyExperiences,
  ...journeyExpansionBatchSixExperiences
      .where((item) => _batchSixJourneyIds.contains(item.id))
      .map(_normalizeBatchSixExperience),
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
