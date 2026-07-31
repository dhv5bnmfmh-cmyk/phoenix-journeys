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
    id: 'dujiangyan-sichuan-water-resources',
    title: '都江堰水利工程保护与传承',
    publisher: '四川省水利厅',
    url:
        'https://slt.sc.gov.cn/scsslt/c112517/2025/7/16/d72e4374c5fc41848df897bcf9fba5cf.shtml',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-sichuan-chengdu-dujiangyan-irrigation-system'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'dazu-chongqing-protection-regulation',
    title: '重庆市大足石刻保护条例',
    publisher: '重庆市文化和旅游发展委员会',
    url:
        'https://whlyw.cq.gov.cn/zwgk_221/fdzdgknr/lzyj/xzfg/201808/t20180802_9153291.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-chongqing-dazu-rock-carvings'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'wudang-hubei-cultural-heritage',
    title: '世界文化遗产·武当山古建筑群',
    publisher: '湖北省文化和旅游厅',
    url:
        'https://wlt.hubei.gov.cn/bmdt/ztzl/lszt/sjwhyc/sjyzcd/wdsgjzq/201911/t20191121_1366117.shtml',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-hubei-shiyan-wudang-mountains'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'fujian-tulou-provincial-government',
    title: '福建土楼文化遗产保护规划',
    publisher: '福建省人民政府',
    url:
        'https://www.fujian.gov.cn/zwgk/zfxxgk/szfwj/jgzz/kjwwzcwj/201302/t20130207_1183721.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-fujian-longyan-yongding-tulou'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'shenyang-palace-liaoning-government',
    title: '沈阳故宫博物院',
    publisher: '辽宁省人民政府',
    url:
        'https://www.ln.gov.cn/web/sqgk/whly/ajjq/sy/2025101511142611813/index.shtml',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-liaoning-shenyang-shenhe-imperial-palace'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
];

const _supplementalSourceByJourney = <String, String>{
  'hangzhou-west-lake': 'hangzhou-west-lake-scenic-committee',
  'chengdu-kuanzhai-alley': 'chengdu-kuanzhai-academic-study',
  'nanjing-qinhuai-river': 'nanjing-qinhuai-legislature',
  'guangzhou-chen-clan-academy': 'guangzhou-chen-clan-museum',
  'dujiangyan-irrigation-system': 'dujiangyan-sichuan-water-resources',
  'chongqing-dazu-rock-carvings': 'dazu-chongqing-protection-regulation',
  'shiyan-wudang-mountains': 'wudang-hubei-cultural-heritage',
  'longyan-fujian-tulou': 'fujian-tulou-provincial-government',
  'shenyang-imperial-palace': 'shenyang-palace-liaoning-government',
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
