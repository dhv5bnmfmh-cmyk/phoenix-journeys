import '../models/story_content.dart';
import 'batch_one_journey_remediation.dart';
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

const _templeOfHeavenCanonicalStory = <String>[
  '声学社学生顾遥来到天坛，准备为校展校准一份回音壁实验图。她想证明自己的计算比祖父顾衡留下的旧笔记更可靠，却发现图纸上最关键的一段刻度被雨水洇成空白。',
  '顾遥从圜丘、皇穹宇走到回音壁，比较石面、圆墙和中心轴线。顾衡提醒她，天坛首先是明清皇帝祭天祈谷的礼制建筑，声学现象不能脱离真实空间与参观条件被夸大成传说。',
  '闭园前，顾遥只能选择照抄旧数据按时交件，或放弃漂亮结论，重新记录温度、距离和站位。她选择重测，因此错过校展初审，却发现原图把一次偶然清晰的回声写成了固定规律。',
  '顾遥在补交报告中保留空白刻度，并说明证据不足之处。顾衡把旧笔记交给她继续保管。她不再把修正看成否定前人，而把它看成对历史、建筑和学习者负责的延续。',
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
  id: templeOfHeavenRemediation.id,
  title: templeOfHeavenRemediation.title,
  geoNodeId: 'cn-beijing-dongcheng',
  tags: const ['北京', '天坛', '祭天礼制', '声学', '证据', '世界文化遗产'],
  paragraphs: _templeOfHeavenCanonicalStory,
  sourceIds: const [
    'unesco-temple-of-heaven-881',
    'beijing-gov-temple-of-heaven',
  ],
);

final beijingJourneyCatalog = <JourneyContentRecord>[
  beijingForbiddenCityJourney,
  beijingTempleOfHeavenJourney,
];
