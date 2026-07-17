import '../models/story_content.dart';
import 'journey_data.dart';

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
    url:
        'https://english.beijing.gov.cn/latest/news/202505/t20250504_4080361.html',
    kind: StorySourceKind.government,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-18',
  ),
];

final beijingForbiddenCityJourney = JourneyContentRecord(
  id: 'beijing-forbidden-city',
  title: '北京 · 故宫：一座宫殿怎样保存国家的记忆',
  geoNodeId: 'cn-beijing-dongcheng-forbidden-city',
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['北京', '故宫', '紫禁城', '明清', '文化遗产'],
  sections: [
    JourneyStorySection(
      id: 'story-0',
      text: storyParagraphs[0],
      sourceIds: const [
        'dpm-forbidden-city-guide',
        'beijing-gov-forbidden-city-2025',
      ],
    ),
    JourneyStorySection(
      id: 'story-1',
      text: storyParagraphs[1],
      sourceIds: const [
        'dpm-forbidden-city-guide',
        'beijing-gov-forbidden-city-2025',
      ],
    ),
    JourneyStorySection(
      id: 'story-2',
      text: storyParagraphs[2],
      sourceIds: const [
        'dpm-forbidden-city-guide',
        'unesco-imperial-palaces-439',
        'beijing-gov-forbidden-city-2025',
      ],
    ),
    JourneyStorySection(
      id: 'story-3',
      text: storyParagraphs[3],
      sourceIds: const [
        'dpm-forbidden-city-guide',
        'unesco-imperial-palaces-439',
      ],
    ),
  ],
);

final beijingJourneyCatalog = <JourneyContentRecord>[
  beijingForbiddenCityJourney,
];
