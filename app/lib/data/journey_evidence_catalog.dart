import '../models/story_content.dart';
import 'daily_journey_catalog.dart';

const supplementalDailyStorySources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'hangzhou-west-lake-scenic-committee',
    title: '西湖景观：西湖十景',
    publisher: '杭州西湖风景名胜区管理委员会',
    url:
        'https://westlake.hangzhou.gov.cn/art/2024/3/4/art_1643935_59046173.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-zhejiang-hangzhou-west-lake'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: 'chengdu-kuanzhai-academic-study',
    title:
        'Tourists’ Motives for Visiting Historic Conservation Areas: Kuanzhai Alley',
    publisher: 'Sustainability',
    url: 'https://doi.org/10.3390/su15043130',
    kind: StorySourceKind.academic,
    languageCode: 'en',
    geoNodeIds: ['cn-sichuan-chengdu-kuanzhai'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: 'nanjing-qinhuai-legislature',
    title: '南京市夫子庙秦淮风光带风景名胜区条例',
    publisher: '南京市人民代表大会常务委员会',
    url:
        'https://rd.nanjing.gov.cn/lfgz_0/sjfg_1/202103/t20210325_2859111.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-jiangsu-nanjing-qinhuai'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: 'guangzhou-chen-clan-museum',
    title: '广东民间工艺博物馆：本馆概况',
    publisher: '广东民间工艺博物馆',
    url:
        'https://www.gzcjc.com.cn/MYwebsite/rc/my_gaik_xq.htm?leixing=a98536&subpath=3&token=35afbd486503488aa1ee1f327d9be0c5',
    kind: StorySourceKind.museum,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-guangdong-guangzhou-chen-clan'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: 'palace-museum-wuying-hall',
    title: '武英殿',
    publisher: '故宫博物院',
    url: 'https://www.dpm.org.cn/explore/building/236500.html',
    kind: StorySourceKind.museum,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-09-15',
  ),
  StorySourceRecord(
    id: 'palace-museum-wuying-rebuild',
    title: '重建武英殿',
    publisher: '故宫博物院',
    url: 'https://www.dpm.org.cn/subject_600/buildingdetails/253797.html',
    kind: StorySourceKind.museum,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-09-15',
  ),
  StorySourceRecord(
    id: 'palace-museum-fire-safety',
    title: '珍爱文化遗产 守护人类文明——故宫博物院举办“中国文化遗产日”系列活动',
    publisher: '故宫博物院',
    url: 'https://www.dpm.org.cn/classify_detail/178660.html',
    kind: StorySourceKind.museum,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-09-15',
  ),
  StorySourceRecord(
    id: 'unesco-imperial-palaces-beijing-shenyang',
    title: 'Imperial Palaces of the Ming and Qing Dynasties in Beijing and Shenyang',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/439',
    kind: StorySourceKind.institutional,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-dongcheng-forbidden-city'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-09-15',
  ),
];

const _supplementalSourceByJourney = <String, String>{
  'hangzhou-west-lake': 'hangzhou-west-lake-scenic-committee',
  'chengdu-kuanzhai-alley': 'chengdu-kuanzhai-academic-study',
  'nanjing-qinhuai-river': 'nanjing-qinhuai-legislature',
  'guangzhou-chen-clan-academy': 'guangzhou-chen-clan-museum',
};

final reviewedDailyStorySources = <StorySourceRecord>[
  ...dailyStorySources,
  ...supplementalDailyStorySources,
];

final reviewedDailyJourneyRecords = dailyJourneyRecords.map((journey) {
  final supplementalSourceId = _supplementalSourceByJourney[journey.id];
  if (supplementalSourceId == null) return journey;

  return JourneyContentRecord(
    id: journey.id,
    title: journey.title,
    geoNodeId: journey.geoNodeId,
    languageCode: journey.languageCode,
    verificationStatus: journey.verificationStatus,
    tags: journey.tags,
    sections: journey.sections
        .map(
          (section) => JourneyStorySection(
            id: section.id,
            text: section.text,
            sourceIds: [...section.sourceIds, supplementalSourceId],
          ),
        )
        .toList(growable: false),
  );
}).toList(growable: false);
