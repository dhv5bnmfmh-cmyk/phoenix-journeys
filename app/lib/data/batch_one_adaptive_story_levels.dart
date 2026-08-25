import '../models/language_proficiency.dart';
import '../services/phoenix_level_controller.dart';
import 'batch_one_journey_remediation.dart';
import 'chengdu_kuanzhai_one_pass.dart';
import 'daily_journey_experience.dart';
import 'datong_yungang_gold_content.dart';
import 'hangzhou_west_lake_one_pass.dart';
import 'honghe_hani_rice_terraces_gold_content.dart';
import 'pingyao_ancient_city_gold_content.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'kaiping_diaolou_gold.dart';
import 'lijiang_old_town_gold_content.dart';
import 'luoyang_longmen_level_depth.dart';
import 'luoyang_longmen_one_pass.dart';
import 'nanjing_qinhuai_one_pass.dart';
import 'nanjing_qinhuai_vocabulary_curation.dart';
import 'shanghai_bund_one_pass.dart';
import 'xian_city_wall_one_pass.dart';

const _summerPalaceJourneyId = 'beijing-summer-palace';

bool isBatchOneGoldJourney(String journeyId) =>
    journeyId == shanghaiBundJourneyId ||
    journeyId == xianCityWallJourneyId ||
    journeyId == hangzhouWestLakeJourneyId ||
    journeyId == chengduKuanzhaiJourneyId ||
    journeyId == nanjingQinhuaiJourneyId ||
    journeyId == luoyangLongmenJourneyId ||
    journeyId == kaipingDiaolouJourneyId ||
    journeyId == datongYungangJourneyId ||
    journeyId == lijiangOldTownJourneyId ||
    journeyId == hongheHaniRiceTerracesJourneyId ||
    journeyId == pingyaoAncientCityJourneyId;

const _lijiangLv10IntangibleCultureWord = WordEntry(
  word: '非物质文化',
  pinyin: 'fēi wùzhì wénhuà',
  partOfSpeech: '名词',
  simpleChinese: '通过知识、技艺、习俗等方式持续传承的文化。',
  translation: 'Văn hóa phi vật thể.',
  englishDefinition: 'intangible culture carried through living knowledge, skills, and practices',
  symbol: '🧩',
);

JourneyLevelContent _withLijiangLv10Vocabulary(
  String journeyId,
  int level,
  JourneyLevelContent base,
) {
  if (journeyId != lijiangOldTownJourneyId || level != 10) return base;
  final activeContext = '${base.storyParagraphs.join()}${base.discoveries.map((entry) => entry.text).join()}';
  if (!activeContext.contains(_lijiangLv10IntangibleCultureWord.word) ||
      base.words.any((entry) => entry.word == _lijiangLv10IntangibleCultureWord.word)) {
    return base;
  }
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: List<WordEntry>.unmodifiable(<WordEntry>[
      ...base.words,
      _lijiangLv10IntangibleCultureWord,
    ]),
    discoveries: base.discoveries,
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

/// Thin adaptive adapter over canonical one-pass content packages.
/// Story, Words, Discovery, Challenge, Memory, and Completion remain immutable
/// content definitions; narration/progress updates never rebuild them.
JourneyLevelContent buildBatchOneGoldLevel(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  if (!isBatchOneGoldJourney(experience.id)) {
    throw ArgumentError.value(experience.id, 'experience.id');
  }
  final level = profile.phoenixLevel ?? _legacyLevel(profile.band);
  final sourceBase = switch (experience.id) {
    xianCityWallJourneyId => xianCityWallOnePassLevelContent(level),
    hangzhouWestLakeJourneyId => hangzhouWestLakeOnePassLevelContent(level),
    chengduKuanzhaiJourneyId => chengduKuanzhaiOnePassLevelContent(level),
    nanjingQinhuaiJourneyId => nanjingQinhuaiCuratedLevelContent(level),
    luoyangLongmenJourneyId => luoyangLongmenGoldLevelContent(level),
    kaipingDiaolouJourneyId => kaipingDiaolouGoldLevelContent(level),
    datongYungangJourneyId => datongYungangGoldLevelContent(level),
    lijiangOldTownJourneyId => lijiangOldTownGoldLevelContent(level),
    hongheHaniRiceTerracesJourneyId =>
      hongheHaniRiceTerracesGoldLevelContent(level),
    pingyaoAncientCityJourneyId => pingyaoAncientCityGoldLevelContent(level),
    _ => shanghaiBundOnePassRemediation.levelContent(level),
  };
  final base = _withLijiangLv10Vocabulary(experience.id, level, sourceBase);
  final unseenWords = base.words
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);
  final wonderQuestion = experience.id == shanghaiBundJourneyId
      ? '林岸为什么在过江后不再把两岸理解成过去和未来？'
      : base.wonderQuestion;
  final expressQuestion = experience.id == shanghaiBundJourneyId
      ? '旧海运提单与陆家嘴结算系统在故事里共同组织了哪些流动？'
      : base.expressQuestion;

  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: unseenWords.isEmpty
        ? base.words
        : List<WordEntry>.unmodifiable(unseenWords),
    discoveries: base.discoveries,
    wonderQuestion: wonderQuestion,
    expressQuestion: expressQuestion,
  );
}

class BatchOneJourneyMemorySpec {
  const BatchOneJourneyMemorySpec({
    required this.storyResult,
    required this.culturalPoint,
    required this.reviews,
    required this.longTermAnchor,
    required this.completionSummary,
  });

  final String storyResult;
  final String culturalPoint;
  final List<RemediatedMemoryReview> reviews;
  final String longTermAnchor;
  final String completionSummary;
}

BatchOneJourneyMemorySpec _summerPalaceMemorySpecForLevel(int phoenixLevel) {
  final level = phoenixLevel.clamp(1, 10).toInt();
  final culturalPoint = switch (level) {
    1 =>
      '万寿山与昆明湖构成颐和园最基本的山水框架，自然山水与亭台、殿堂、寺庙、桥梁等人工要素共同形成整体皇家园林。',
    2 =>
      '颐和园不只用于观景。UNESCO资料记录政治行政、居住、精神和游憩等不同功能共同存在于湖山园林之中。',
    3 =>
      '颐和园始建于一七五〇年，一八六〇年遭受严重破坏；一八八六年开始在原有基础上重新修复，建造、损毁和修复形成可读的历史层次。',
    4 =>
      '长廊位于万寿山南麓、临近昆明湖。沿长廊移动时，观看位置持续变化，湖、山和建筑会按行走顺序进入视野。',
    5 =>
      '颐和园的观看还会把视线延伸到园外。北京官方资料把玉泉山和香山列为重要借景，近处园景与远处山体因此形成空间层次。',
    6 =>
      '十七孔桥东接东堤、西连南湖岛。桥把岛、堤和水面组织成可通行的空间关系，因此不能只把它当成一个孤立造型。',
    7 =>
      '北京官方资料记录，十一月下旬到冬至前后的晴朗傍晚可见十七孔桥桥洞逐渐被夕阳照亮；现有史料没有证明这种冬至金光是造园者刻意设计的。',
    8 =>
      '颐和园的山、水、建筑、寺庙、桥梁与人的移动路线共同构成园林系统；功能与景观需要放在同一整体中理解。',
    9 =>
      '昆明湖中的岛、岸与桥梁构成多重连接。南湖岛通过十七孔桥与东堤相连，西堤及其桥梁又形成另一组连接结构。',
    _ =>
      '颐和园于一九九八年列入《世界遗产名录》。UNESCO强调自然山水与人工建筑形成的和谐整体，遗产保存也需要让建造、损毁与修复的历史信息继续可读。',
  };
  final placeAnswer = switch (level) {
    1 =>
      '十七孔桥冬至前后的短暂落日光影制造了不可暂停的拍摄窗口；本级又从万寿山、昆明湖与人工要素的整体关系理解为什么这里不是普通公园。',
    2 =>
      '十七孔桥的短暂光线让许澄必须现场选择；本级看到同一皇家园林还承载政治行政、居住、精神和游憩等不同功能。',
    3 =>
      '十七孔桥的短暂光线制造不可暂停的选择，而一七五〇年兴建、一八六〇年受损、一八八六年开始修复的历史让旧照片与“留下痕迹”有了真实地点因果。',
    4 =>
      '故事中的长廊不是背景贴图：沿廊移动会持续改变湖、山与建筑进入视野的顺序，也直接改变许澄和周岚的行走节奏。',
    5 =>
      '许澄的取景选择依赖真实视线关系；玉泉山、香山等园外远景参与借景，使“只留下无瑕局部”与完整观看之间产生地点性的张力。',
    6 =>
      '十七孔桥东接东堤、西连南湖岛，桥上的选择发生在真实的岛、堤、水面连接关系中，因此不能等价搬到任意公园。',
    7 =>
      '冬至前后的桥洞金光提供真实季节窗口，但现有史料并不支持“造园者特意设计冬至金光”的说法；故事只使用可验证的现象与观看位置。',
    8 =>
      '许澄一路遇到的山、水、长廊、桥梁与移动路线属于同一园林系统，地点结构本身推动她从单一完美画面转向关系性的观看。',
    9 =>
      '昆明湖不是孤立水面：岛、东堤、西堤与桥梁形成多重连接，十七孔桥上的取舍因此嵌在更大的湖区空间网络中。',
    _ =>
      '世界遗产价值来自自然与人工要素的整体关系，也包括让历史层次保持可读；许澄最终保留痕迹而非抹平痕迹，与这一地点逻辑形成呼应。',
  };
  final completionLens = switch (level) {
    1 => '本级收束在湖、山与人工要素如何共同组成一座园林。',
    2 => '本级进一步把多种功能空间放回同一湖山园林理解。',
    3 => '本级用兴建、损毁、修复三个时间节点理解“痕迹”不是抽象修辞。',
    4 => '本级把长廊中的移动位置与观看顺序纳入人物选择。',
    5 => '本级把借景与近远空间层次纳入取景判断。',
    6 => '本级把十七孔桥两端的真实连接关系纳入地点因果。',
    7 => '本级区分可验证的季节光影与没有史料支持的“刻意设计”推断。',
    8 => '本级把功能、景观与移动整合成园林系统来理解。',
    9 => '本级把昆明湖读成由岛、岸、堤与桥共同形成的连接网络。',
    _ => '本级综合世界遗产整体价值与历史信息可读性，完成保存判断。',
  };

  return BatchOneJourneyMemorySpec(
    storyResult:
        '许澄在十七孔桥金光亮起、旧照片被风吹落时放下相机先捡照片。她错过等了一下午的画面，却改拍旧照片、外婆的手和正在暗下的桥洞，并把作品命名为《留下痕迹的风景》。',
    culturalPoint: culturalPoint,
    reviews: <RemediatedMemoryReview>[
      RemediatedMemoryReview(
        category: 'choice',
        prompt: '金光亮起、旧照片被风吹落时，许澄真正做了什么选择？',
        answer: '她放下相机先捡回旧照片，因此错过了等了一下午的金光画面。',
        storyEventIds: <String>[
          'photographFalls',
          'forcedChoice',
          'enactedChoice',
          'lostLight',
        ],
      ),
      RemediatedMemoryReview(
        category: 'relationship',
        prompt: '这次选择怎样改变了许澄和周岚的关系？',
        answer: '周岚不再替许澄调构图，让她自己决定下一张，并把旧照片交给她保存。',
        storyEventIds: <String>['trustChange', 'photographEntrusted'],
      ),
      RemediatedMemoryReview(
        category: 'place',
        prompt: '为什么这个故事不能随便搬到另一座普通公园？',
        answer: placeAnswer,
        storyEventIds: <String>[
          'grandmotherConservationBackground',
          'photographFalls',
          'lostLight',
          'changedUnderstanding',
        ],
      ),
      RemediatedMemoryReview(
        category: 'memory',
        prompt: '离开颐和园后，最值得长期记住的画面是什么？',
        answer: '许澄手里留下旧照片，镜头里留下外婆的手和正在暗下的十七孔桥。',
        storyEventIds: <String>[
          'threeLayerComposition',
          'workTitle',
          'photographEntrusted',
        ],
      ),
    ],
    longTermAnchor:
        '她没有留下“无瑕”的金光，却留下了旧照片、外婆的手和一幅承认时间痕迹的新作品。',
    completionSummary:
        '作品《留下痕迹的风景》完成了这次 Journey：许澄失去预想中的完美画面，却获得独立判断，也接过旧照片与修复记忆。$completionLens 下一次面对“完美”与真实痕迹的冲突时，先问自己准备留下什么、又愿意为选择承担什么。',
  );
}

BatchOneJourneyMemorySpec? batchOneMemorySpecFor(
  String journeyId, {
  int? phoenixLevel,
}) {
  if (journeyId == _summerPalaceJourneyId) {
    return _summerPalaceMemorySpecForLevel(
      phoenixLevel ?? PhoenixLevelController.instance.level,
    );
  }

  final journey = switch (journeyId) {
    shanghaiBundJourneyId => shanghaiBundOnePassRemediation,
    xianCityWallJourneyId => xianCityWallOnePassRemediation,
    hangzhouWestLakeJourneyId => hangzhouWestLakeReopenedRemediation,
    chengduKuanzhaiJourneyId => chengduKuanzhaiOnePassRemediation,
    nanjingQinhuaiJourneyId => nanjingQinhuaiRemediatedJourney,
    luoyangLongmenJourneyId => luoyangLongmenGoldJourney,
    kaipingDiaolouJourneyId => kaipingDiaolouGoldJourney,
    datongYungangJourneyId => datongYungangGoldJourney,
    lijiangOldTownJourneyId => lijiangOldTownGoldJourney,
    hongheHaniRiceTerracesJourneyId => hongheHaniRiceTerracesGoldJourney,
    pingyaoAncientCityJourneyId => pingyaoAncientCityGoldJourney,
    _ => null,
  };
  if (journey == null) return null;

  String memoryAnswer(String category) => journey.memory
      .firstWhere((item) => item.category == category)
      .answer;

  final culturalPoint = switch (journeyId) {
    chengduKuanzhaiJourneyId =>
      '${memoryAnswer('history')} ${memoryAnswer('preservation')}',
    nanjingQinhuaiJourneyId =>
      '${memoryAnswer('选择')} ${memoryAnswer('画面')}',
    datongYungangJourneyId =>
      '${memoryAnswer('choice')} ${memoryAnswer('place')}',
    lijiangOldTownJourneyId ||
    hongheHaniRiceTerracesJourneyId ||
    pingyaoAncientCityJourneyId =>
      '${memoryAnswer('place')} ${memoryAnswer('memory')}',
    luoyangLongmenJourneyId || kaipingDiaolouJourneyId =>
      '${memoryAnswer('truth')} ${memoryAnswer('place')}',
    xianCityWallJourneyId || hangzhouWestLakeJourneyId =>
      '${memoryAnswer('history')} ${memoryAnswer('culture')}',
    _ => '${memoryAnswer('culture')} ${memoryAnswer('architecture')}',
  };

  return BatchOneJourneyMemorySpec(
    storyResult: journey.completion.journeySummary,
    culturalPoint: culturalPoint,
    reviews: List<RemediatedMemoryReview>.unmodifiable(journey.memory),
    longTermAnchor: journey.completion.memoryAnchor,
    completionSummary:
        '${journey.completion.achievement} ${journey.completion.challengeReward}',
  );
}

int _legacyLevel(PhoenixReadingBand band) => switch (band) {
      PhoenixReadingBand.beginner => 1,
      PhoenixReadingBand.elementary => 3,
      PhoenixReadingBand.intermediate => 5,
      PhoenixReadingBand.upperIntermediate => 7,
      PhoenixReadingBand.advanced => 8,
      PhoenixReadingBand.mastery => 10,
    };
