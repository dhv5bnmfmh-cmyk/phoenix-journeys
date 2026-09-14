import '../models/story_content.dart';
import 'beijing_temple_of_heaven_story.dart';
import 'forbidden_city_journey_runtime.dart';

const beijingStorySources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'dpm-forbidden-city-guide',
    title: '故宫博物院导览 · 宫廷建筑',
    publisher: '故宫博物院',
    url: 'https://www.dpm.org.cn/Visit.html',
    kind: StorySourceKind.museum,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-18',
  ),
  StorySourceRecord(
    id: 'unesco-imperial-palaces-439',
    title: 'Imperial Palaces of the Ming and Qing Dynasties',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/439/',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-18',
  ),
  StorySourceRecord(
    id: 'beijing-gov-forbidden-city-2025',
    title: 'World Cultural Heritage Tour in Beijing: Forbidden City',
    publisher: 'The People’s Government of Beijing Municipality',
    url: 'https://english.beijing.gov.cn/latest/news/202505/t20250504_4080361.html',
    kind: StorySourceKind.government,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-18',
  ),
  StorySourceRecord(
    id: 'unesco-temple-of-heaven-881',
    title: 'Temple of Heaven: an Imperial Sacrificial Altar in Beijing',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/881/',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-dongcheng'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-06',
  ),
  StorySourceRecord(
    id: 'beijing-gov-temple-of-heaven',
    title: 'Temple of Heaven',
    publisher: 'The People’s Government of Beijing Municipality',
    url: 'https://english.beijing.gov.cn/specials/parktours/guidevisitors/templeofheaven/',
    kind: StorySourceKind.government,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-dongcheng'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-06',
  ),
];

final _forbiddenCityCanonicalStory = <String>[
  forbiddenCityLockedStories.last,
];

JourneyContentRecord _record({
  required String id,
  required String title,
  required String geoNodeId,
  required List<String> tags,
  required List<String> paragraphs,
  required List<String> sourceIds,
}) {
  return JourneyContentRecord(
    id: id,
    title: title,
    geoNodeId: geoNodeId,
    languageCode: 'zh-CN',
    verificationStatus: StoryVerificationStatus.published,
    tags: tags,
    sections: List.generate(
      paragraphs.length,
      (index) => JourneyStorySection(
        id: 'story-$index',
        text: paragraphs[index],
        sourceIds: sourceIds,
      ),
    ),
  );
}

final beijingForbiddenCityJourney = _record(
  id: forbiddenCityJourneyId,
  title: '北京 · 紫禁城',
  geoNodeId: 'cn-beijing-dongcheng-forbidden-city',
  tags: const [
    '北京',
    '故宫',
    '紫禁城',
    '中轴',
    '礼仪秩序',
    '宫廷空间',
    '世界文化遗产',
  ],
  paragraphs: _forbiddenCityCanonicalStory,
  sourceIds: const [
    'dpm-forbidden-city-guide',
    'unesco-imperial-palaces-439',
    'beijing-gov-forbidden-city-2025',
  ],
);

final beijingTempleOfHeavenJourney = _record(
  id: templeOfHeavenJourneyId,
  title: '北京 · 天坛：$templeOfHeavenCanonicalTitle',
  geoNodeId: 'cn-beijing-dongcheng',
  tags: const <String>[
    '北京',
    '天坛',
    '祈年殿',
    '圜丘',
    '冬至祭天',
    '祈谷',
    '影像叙事',
    '世界文化遗产',
  ],
  paragraphs: templeOfHeavenCanonicalStoryParagraphs,
  sourceIds: const <String>[
    'unesco-temple-of-heaven-881',
    'beijing-gov-temple-of-heaven',
  ],
);

final beijingJourneyCatalog = <JourneyContentRecord>[
  beijingForbiddenCityJourney,
  beijingTempleOfHeavenJourney,
];
