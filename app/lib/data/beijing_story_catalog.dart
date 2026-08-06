import '../models/story_content.dart';
import 'batch_one_journey_remediation.dart';

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
    accessedOn: '2026-08-06',
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
    accessedOn: '2026-08-06',
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
    accessedOn: '2026-08-06',
  ),
  StorySourceRecord(
    id: 'unesco-temple-of-heaven-881',
    title: 'Temple of Heaven: an Imperial Sacrificial Altar in Beijing',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/881/',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-dongcheng-temple-of-heaven'],
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
    geoNodeIds: ['cn-beijing-dongcheng-temple-of-heaven'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-06',
  ),
  StorySourceRecord(
    id: 'temple-of-heaven-park-guide',
    title: '天坛公园导览',
    publisher: '北京市天坛公园管理处',
    url: 'http://www.tiantanpark.com/',
    kind: StorySourceKind.museum,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-beijing-dongcheng-temple-of-heaven'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-06',
  ),
];

JourneyContentRecord _recordFromRemediation({
  required RemediatedJourney journey,
  required String geoNodeId,
  required List<String> tags,
}) {
  return JourneyContentRecord(
    id: journey.id,
    title: journey.title,
    geoNodeId: geoNodeId,
    languageCode: 'zh-CN',
    verificationStatus: StoryVerificationStatus.published,
    tags: tags,
    sections: [
      for (var index = 0; index < journey.levels.length; index++)
        JourneyStorySection(
          id: 'story-lv${index + 1}',
          text: journey.levels[index],
          sourceIds: journey.sourceIds,
        ),
    ],
  );
}

final beijingForbiddenCityJourney = _recordFromRemediation(
  journey: forbiddenCityRemediation,
  geoNodeId: 'cn-beijing-dongcheng-forbidden-city',
  tags: const ['北京', '故宫', '紫禁城', '明清', '古建测绘', '修缮', '文化遗产'],
);

final beijingTempleOfHeavenJourney = _recordFromRemediation(
  journey: templeOfHeavenRemediation,
  geoNodeId: 'cn-beijing-dongcheng-temple-of-heaven',
  tags: const ['北京', '天坛', '圜丘', '祈年殿', '皇穹宇', '回音壁', '文化遗产'],
);

final beijingJourneyCatalog = <JourneyContentRecord>[
  beijingForbiddenCityJourney,
  beijingTempleOfHeavenJourney,
];
