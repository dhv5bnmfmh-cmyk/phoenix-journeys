import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'kaiping_diaolou_gold.dart';

const kaipingActiveGeoNodeId = 'cn-guangdong-jiangmen-kaiping-zili-village';
const kaipingActiveGeoDisplayName = '开平碉楼';

const kaipingActiveSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-kaiping-diaolou-villages',
    title: 'Kaiping Diaolou and Villages',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1112/',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-guangdong-jiangmen-kaiping'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'kaiping-government-diaolou-types',
    title: '开平碉楼按功能可分为哪几种形式？',
    publisher: '开平市人民政府',
    url:
        'https://www.kaiping.gov.cn/kpszfw/zmhd/cjwy/lywh/content/post_3492765.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-guangdong-jiangmen-kaiping'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'kaiping-government-zili-village',
    title: '塘口镇 · 自力村碉楼群',
    publisher: '开平市人民政府',
    url:
        'https://www.kaiping.gov.cn/tkzrmzf/tkgk/dlly/content/post_553104.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [kaipingActiveGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'jiangmen-government-kaiping-heritage',
    title: '18年前，中国首个华侨文化世界遗产诞生！',
    publisher: '江门市文化广电旅游体育局',
    url:
        'https://www.jiangmen.gov.cn/jmwgj/gkmlpt/content/3/3323/post_3323136.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-guangdong-jiangmen-kaiping'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
];

final _kaipingActiveBaseLevel = kaipingDiaolouGoldLevelContent(5);

final kaipingActiveJourney = JourneyContentRecord(
  id: kaipingDiaolouJourneyId,
  title: kaipingDiaolouCanonicalTitle,
  geoNodeId: kaipingActiveGeoNodeId,
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['开平碉楼', '侨乡', '众楼', '中西建筑文化交流'],
  sections: <JourneyStorySection>[
    for (var index = 0;
        index < _kaipingActiveBaseLevel.storyParagraphs.length;
        index++)
      JourneyStorySection(
        id: 'story-$index',
        text: _kaipingActiveBaseLevel.storyParagraphs[index],
        sourceIds: const [
          'unesco-kaiping-diaolou-villages',
          'kaiping-government-diaolou-types',
        ],
      ),
  ],
);

final kaipingActiveExperience = DailyJourneyExperience(
  id: kaipingDiaolouJourneyId,
  city: '江门',
  cityCode: 'JMN',
  place: '开平碉楼与村落',
  appBarTitle: '江门 · 开平碉楼与村落',
  storyTitle: kaipingDiaolouCanonicalTitle,
  headline: kaipingDiaolouHeadline,
  description: kaipingDiaolouDescription,
  discoveryTeaser: kaipingDiaolouDiscoveryTeaser,
  distanceLabel: '',
  stampSymbol: '碉',
  content: kaipingActiveJourney,
  storyAnnotations: _kaipingActiveBaseLevel.storyAnnotations,
  words: _kaipingActiveBaseLevel.words,
  discoveries: _kaipingActiveBaseLevel.discoveries,
  wonderQuestion: _kaipingActiveBaseLevel.wonderQuestion,
  expressQuestion: _kaipingActiveBaseLevel.expressQuestion,
);
