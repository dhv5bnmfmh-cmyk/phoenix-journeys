import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'summer_palace_adaptive_story_levels.dart';
import 'summer_palace_cultural_discovery_levels.dart';

const summerPalacePilotPhaseId = 'PILOT_N1';
const summerPalacePilotPrimaryFinding = 'CULTURAL_PLACE_CAUSALITY_MISSING';
const summerPalacePilotProtagonist = '许澄';
const summerPalacePilotRelationship = '外婆周岚';
const summerPalacePilotGoal = '为校展拍出一张她认为不需要外婆指导的“无瑕”颐和园照片';
const summerPalacePilotConflict =
    '冬至前后十七孔桥的季节光线与旧照片同时成为不可兼得的行动窗口，迫使许澄在作品和外婆的记忆之间选择';
const summerPalacePilotChoice =
    '在十七孔桥桥洞金光移动时放下相机，先捡回旧照片，再用剩余光线重构画面';
const summerPalacePilotConsequence =
    '等了一下午的十七孔桥桥洞金光真实消失，周岚停止替她调整构图并把旧照片交给她保存';
const summerPalaceStoryFunctionContract =
    '让冬至前后十七孔桥的短暂光线、颐和园的修复历史和外婆旧照片共同制造行动压力，使地点机制直接参与Choice与Cost。';
const summerPalaceDiscoveryFunctionContract =
    '按Lv1-Lv10解释山湖框架、自然与人工整体、历史层次、路线与借景、十七孔桥空间与季节光线、功能系统及World Heritage保护，不复述许澄事件链。';

const summerPalaceStorySources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-summer-palace-880', title: 'Summer Palace, an Imperial Garden in Beijing',
    publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/880/',
    kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-beijing-haidian-summer-palace'],
    verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-08-13',
  ),
  StorySourceRecord(
    id: 'beijing-parks-summer-palace-overview', title: '颐和园', publisher: '北京市公园管理中心',
    url: 'https://gygl.beijing.gov.cn/mlgy/mlgy_lsmy/201911/t20191129_732237.html',
    kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-beijing-haidian-summer-palace'],
    verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-08-13',
  ),
  StorySourceRecord(
    id: 'beijing-parks-seventeen-arch-bridge', title: '十七孔桥', publisher: '北京市公园管理中心',
    url: 'https://gygl.beijing.gov.cn/whgy/whgy_wsgc/201912/t20191206_885494.html',
    kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-beijing-haidian-summer-palace'],
    verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-08-13',
  ),
  StorySourceRecord(
    id: 'beijing-parks-seventeen-arch-winter-light', title: '“金光穿洞”景观进入最佳观赏期', publisher: '北京市公园管理中心',
    url: 'https://gygl.beijing.gov.cn/xxgk/xxgk_gyxx/202312/t20231201_3336230.html',
    kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-beijing-haidian-summer-palace'],
    verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-08-13',
  ),
];

final _summerPalacePublishedStory = summerPalaceN1LevelForPhoenixLevel(8);
final summerPalaceStoryParagraphs = _summerPalacePublishedStory.storyParagraphs;
final summerPalaceStoryAnnotations = _summerPalacePublishedStory.storyAnnotations;

const summerPalaceWords = <WordEntry>[
  WordEntry(word: '颐和园', pinyin: 'Yíhéyuán', partOfSpeech: '名词（专名）', simpleChinese: '北京著名的清代皇家园林和世界文化遗产。', translation: 'Di Hòa Viên ở Bắc Kinh.', englishDefinition: 'the Summer Palace', symbol: '🏯'),
  WordEntry(word: '昆明湖', pinyin: 'Kūnmíng Hú', partOfSpeech: '名词（专名）', simpleChinese: '颐和园内面积最大的湖。', translation: 'Hồ Côn Minh.', englishDefinition: 'Kunming Lake', examples: [WordExample(chinese: '长廊的开口让昆明湖重新进入许澄的画面。', pinyin: 'Chángláng de kāikǒu ràng Kūnmíng Hú chóngxīn jìnrù Xǔ Chéng de huàmiàn.', vietnamese: 'Khoảng mở của Trường Lang đưa hồ Côn Minh trở lại khung hình của Hứa Trừng.', english: 'An opening in the Long Corridor brings Kunming Lake back into Xu Cheng’s frame.')], symbol: '🌊'),
  WordEntry(word: '万寿山', pinyin: 'Wànshòu Shān', partOfSpeech: '名词（专名）', simpleChinese: '颐和园内的重要山景。', translation: 'Núi Vạn Thọ.', englishDefinition: 'Longevity Hill', examples: [WordExample(chinese: '旧照片、外婆的手和万寿山形成三层画面。', pinyin: 'Jiù zhàopiàn, wàipó de shǒu hé Wànshòu Shān xíngchéng sān céng huàmiàn.', vietnamese: 'Bức ảnh cũ, bàn tay bà và núi Vạn Thọ tạo thành ba lớp hình ảnh.', english: 'The old photograph, her grandmother’s hand, and Longevity Hill form three visual layers.')], symbol: '⛰️'),
  WordEntry(word: '长廊', pinyin: 'chángláng', partOfSpeech: '名词', simpleChinese: '很长、带有屋顶的走廊。', translation: 'Hành lang dài có mái che.', englishDefinition: 'a long covered corridor', examples: [WordExample(chinese: '走过长廊时，许澄故意加快脚步。', pinyin: 'Zǒuguò Chángláng shí, Xǔ Chéng gùyì jiākuài jiǎobù.', vietnamese: 'Khi đi qua Trường Lang, Hứa Trừng cố ý bước nhanh hơn.', english: 'While walking through the Long Corridor, Xu Cheng deliberately quickens her pace.')], symbol: '🖼️'),
  WordEntry(word: '皇家园林', pinyin: 'huángjiā yuánlín', partOfSpeech: '名词', simpleChinese: '为皇室建造和使用的园林。', translation: 'Vườn hoàng gia.', englishDefinition: 'an imperial garden', examples: [WordExample(chinese: '许澄不再把皇家园林拍成没有旧痕迹的画面。', pinyin: 'Xǔ Chéng bù zài bǎ huángjiā yuánlín pāi chéng méiyǒu jiù hénjì de huàmiàn.', vietnamese: 'Hứa Trừng không còn chụp vườn hoàng gia như một khung hình không có dấu vết cũ.', english: 'Xu Cheng no longer photographs the imperial garden as an image without old traces.')], symbol: '👑'),
  WordEntry(word: '修复', pinyin: 'xiūfù', partOfSpeech: '动词', simpleChinese: '保护、加固并修补损坏的事物。', translation: 'Phục hồi và bảo tồn.', englishDefinition: 'to restore or conserve', symbol: '🛠️'),
  WordEntry(word: '借景', pinyin: 'jièjǐng', partOfSpeech: '名词／动词', simpleChinese: '把远处景物引入当前视野。', translation: 'Mượn cảnh xa.', englishDefinition: 'borrowed scenery', examples: [WordExample(chinese: '长廊用借景把远处的湖山带入眼前。', pinyin: 'Chángláng yòng jièjǐng bǎ yuǎnchù de húshān dài rù yǎnqián.', vietnamese: 'Trường Lang dùng phép mượn cảnh để đưa hồ núi ở xa vào tầm mắt.', english: 'The Long Corridor uses borrowed scenery to bring distant lake and hills into view.')], symbol: '🔭'),
  WordEntry(word: '湖光山色', pinyin: 'húguāng shānsè', partOfSpeech: '成语', simpleChinese: '湖水和山景组成的风光。', translation: 'Cảnh hồ và núi.', englishDefinition: 'lake-and-mountain scenery', examples: [WordExample(chinese: '十七孔桥把湖光山色和季节光线连在一起。', pinyin: 'Shíqīkǒng Qiáo bǎ húguāng shānsè hé jìjié guāngxiàn lián zài yìqǐ.', vietnamese: 'Cầu Thập Thất Khổng nối cảnh hồ núi với ánh sáng theo mùa.', english: 'The Seventeen-Arch Bridge connects lake-and-mountain scenery with seasonal light.')], symbol: '🌄'),
  WordEntry(word: '十七孔桥', pinyin: 'Shíqīkǒng Qiáo', partOfSpeech: '名词（专名）', simpleChinese: '昆明湖上的十七孔石桥。', translation: 'Cầu Thập Thất Khổng.', englishDefinition: 'the Seventeen-Arch Bridge', symbol: '🌉'),
];

final summerPalaceDiscoveries = List<DiscoveryEntry>.unmodifiable(
  summerPalaceDiscoveryEntriesForLevel(7).take(2),
);

final summerPalaceJourneyContent = JourneyContentRecord(
  id: 'beijing-summer-palace',
  title: '北京 · 颐和园：留下痕迹的风景',
  geoNodeId: 'cn-beijing-haidian-summer-palace',
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['北京', '颐和园', '昆明湖', '万寿山', '长廊修复', '借景', '世界文化遗产'],
  sections: [
    for (var index = 0; index < summerPalaceStoryParagraphs.length; index++)
      JourneyStorySection(
        id: 'story-$index',
        text: summerPalaceStoryParagraphs[index],
        sourceIds: const [
          'unesco-summer-palace-880',
          'beijing-parks-summer-palace-overview',
          'beijing-parks-seventeen-arch-bridge',
          'beijing-parks-seventeen-arch-winter-light',
        ],
      ),
  ],
);

final summerPalaceJourneyExperience = DailyJourneyExperience(
  id: summerPalaceJourneyContent.id,
  city: '北京',
  cityCode: 'PEK',
  place: '颐和园',
  appBarTitle: '北京 · 颐和园',
  storyTitle: '留下痕迹的风景',
  headline: '许澄必须决定镜头里要留下什么',
  description: '冬至前后的十七孔桥光线和一张旧照片，把许澄与外婆周岚推入一次不可兼得的选择。',
  discoveryTeaser: '十七孔桥的季节光线、湖桥关系与修复历史为什么不能分开看？',
  distanceLabel: '1,670 km',
  stampSymbol: '园',
  content: summerPalaceJourneyContent,
  storyAnnotations: summerPalaceStoryAnnotations,
  words: summerPalaceWords,
  discoveries: summerPalaceDiscoveries,
  wonderQuestion: '颐和园经历过损毁和修复。许澄最后把旧照片和正在暗下来的桥洞一起拍进画面，你觉得她对“无瑕”的理解发生了什么变化？',
  expressQuestion: '请用三到五句话写一段许澄可能放在校展照片旁的说明。写出拍摄的时节、十七孔桥、旧照片，以及她最后决定留下什么。',
);
