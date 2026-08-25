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
  englishDefinition:
      'intangible culture carried through living knowledge, skills, and practices',
  symbol: '🧩',
);

JourneyLevelContent _withLijiangLv10Vocabulary(
  String journeyId,
  int level,
  JourneyLevelContent base,
) {
  if (journeyId != lijiangOldTownJourneyId || level != 10) return base;
  final activeContext =
      '${base.storyParagraphs.join()}${base.discoveries.map((entry) => entry.text).join()}';
  if (!activeContext.contains(_lijiangLv10IntangibleCultureWord.word) ||
      base.words.any(
          (entry) => entry.word == _lijiangLv10IntangibleCultureWord.word)) {
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
String shanghaiBundWonderQuestionForLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  if (level == 1) {
    return '林岸为什么最后没有把旧提单留在西岸？';
  }
  if (level <= 5) {
    return '林岸为什么在过江后不再把两岸理解成过去和未来？';
  }
  return '历史时间层次为什么让“旧上海到新上海”的直线说法变得不够准确？';
}

String shanghaiBundExpressQuestionForLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  if (level == 1) {
    return '轮渡、旧提单和两岸距离怎样共同推动林岸做出选择？';
  }
  if (level <= 5) {
    return level == 5
        ? '旧海运提单与陆家嘴结算系统在故事里共同组织了哪些流动？'
        : '旧海运提单与陆家嘴结算工作在故事里共同组织了哪些流动？';
  }
  return '结合外滩长期形成的贸易金融功能与陆家嘴现代结算，解释“变化的是载体，不是流动本身”是否充分。';
}

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
    shanghaiBundJourneyId => shanghaiBundOnePassLevelContent(level),
    _ => shanghaiBundOnePassRemediation.levelContent(level),
  };
  final base = _withLijiangLv10Vocabulary(experience.id, level, sourceBase);
  final unseenWords = base.words
      .where((entry) => !knownWords.contains(entry.word))
      .toList(growable: false);
  final wonderQuestion = experience.id == shanghaiBundJourneyId
      ? shanghaiBundWonderQuestionForLevel(level)
      : base.wonderQuestion;
  final expressQuestion = experience.id == shanghaiBundJourneyId
      ? shanghaiBundExpressQuestionForLevel(level)
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
    1 => '万寿山与昆明湖构成颐和园最基本的山水框架，自然山水与亭台、殿堂、寺庙、桥梁等人工要素共同形成整体皇家园林。',
    2 => '颐和园不只用于观景。UNESCO资料记录政治行政、居住、精神和游憩等不同功能共同存在于湖山园林之中。',
    3 => '颐和园始建于一七五〇年，一八六〇年遭受严重破坏；一八八六年开始在原有基础上重新修复，建造、损毁和修复形成可读的历史层次。',
    4 => '长廊位于万寿山南麓、临近昆明湖。沿长廊移动时，观看位置持续变化，湖、山和建筑会按行走顺序进入视野。',
    5 => '颐和园的观看还会把视线延伸到园外。北京官方资料把玉泉山和香山列为重要借景，近处园景与远处山体因此形成空间层次。',
    6 => '十七孔桥东接东堤、西连南湖岛。桥把岛、堤和水面组织成可通行的空间关系，因此不能只把它当成一个孤立造型。',
    7 => '北京官方资料记录，十一月下旬到冬至前后的晴朗傍晚可见十七孔桥桥洞逐渐被夕阳照亮；现有史料没有证明这种冬至金光是造园者刻意设计的。',
    8 => '颐和园的山、水、建筑、寺庙、桥梁与人的移动路线共同构成园林系统；功能与景观需要放在同一整体中理解。',
    9 => '昆明湖中的岛、岸与桥梁构成多重连接。南湖岛通过十七孔桥与东堤相连，西堤及其桥梁又形成另一组连接结构。',
    _ =>
      '颐和园于一九九八年列入《世界遗产名录》。UNESCO强调自然山水与人工建筑形成的和谐整体，遗产保存也需要让建造、损毁与修复的历史信息继续可读。',
  };
  final placeAnswer = switch (level) {
    1 => '十七孔桥冬至前后的短暂落日光影制造了不可暂停的拍摄窗口；本级又从万寿山、昆明湖与人工要素的整体关系理解为什么这里不是普通公园。',
    2 => '十七孔桥的短暂光线让许澄必须现场选择；本级看到同一皇家园林还承载政治行政、居住、精神和游憩等不同功能。',
    3 => '十七孔桥的短暂光线制造不可暂停的选择，而一七五〇年兴建、一八六〇年受损、一八八六年开始修复的历史让旧照片与“留下痕迹”有了真实地点因果。',
    4 => '故事中的长廊不是背景贴图：沿廊移动会持续改变湖、山与建筑进入视野的顺序，也直接改变许澄和周岚的行走节奏。',
    5 => '许澄的取景选择依赖真实视线关系；玉泉山、香山等园外远景参与借景，使“只留下无瑕局部”与完整观看之间产生地点性的张力。',
    6 => '十七孔桥东接东堤、西连南湖岛，桥上的选择发生在真实的岛、堤、水面连接关系中，因此不能等价搬到任意公园。',
    7 => '十七孔桥冬至前后的桥洞金光提供真实季节窗口，但现有史料并不支持“造园者特意设计冬至金光”的说法；故事只使用可验证的现象与观看位置。',
    8 => '许澄一路遇到的山、水、长廊、桥梁与移动路线属于同一园林系统，地点结构本身推动她从单一完美画面转向关系性的观看。',
    9 => '昆明湖不是孤立水面：岛、东堤、西堤与桥梁形成多重连接，十七孔桥上的取舍因此嵌在更大的湖区空间网络中。',
    _ => '世界遗产价值来自自然与人工要素的整体关系，也包括让历史层次保持可读；许澄最终保留痕迹而非抹平痕迹，与这一地点逻辑形成呼应。',
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
      const RemediatedMemoryReview(
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
      const RemediatedMemoryReview(
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
      const RemediatedMemoryReview(
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
    longTermAnchor: '她没有留下“无瑕”的金光，却留下了旧照片、外婆的手和一幅承认时间痕迹的新作品。',
    completionSummary:
        '作品《留下痕迹的风景》完成了这次 Journey：许澄失去预想中的完美画面，却获得独立判断，也接过旧照片与修复记忆。$completionLens 下一次面对“完美”与真实痕迹的冲突时，先问自己准备留下什么、又愿意为选择承担什么。',
  );
}

BatchOneJourneyMemorySpec _shanghaiBundMemorySpecForLevel(
  int phoenixLevel,
) {
  final level = phoenixLevel.clamp(1, 10).toInt();
  final culturalPoint = switch (level) {
    1 => '黄浦江把外滩与浦东放进同一条真实跨江关系里；林岸必须实际离开西岸，故事的选择才会发生。',
    2 => '东金线把浦西金陵东路与浦东东昌路连接起来，轮渡让“过江”成为可执行的城市行动，而不是抽象隐喻。',
    3 => '海运提单把货物、承运、交付与责任固定成可追踪的商业关系，旧单据因此不是怀旧道具，而是家庭工作经验的具体载体。',
    4 =>
      '外滩现海关大楼于1927年建成；这座二十世纪建筑与黄浦江航运、轮渡共同构成今天可见的西岸城市界面，现存建筑的年代需要与更早的外滩历史分开理解。',
    5 => '外滩与陆家嘴隔江同时可见，使林岸能够把“旧/新”从替代关系改读成同一城市中不同阶段、不同工具共同组织流动。',
    6 => '上海1843年的开埠发生在十九世纪不平等条约体系下；外滩贸易、航运、海关、银行与商业功能经历长期发展，不能被压缩成中性的一夜现代化。',
    7 => '外滩的贸易、航运、海关、银行与商业机构经过长期聚集和重组；1927年建成的现海关大楼本身也提示需要区分不同历史时段。',
    8 => '旧提单用纸面组织货物、信用、责任与付款；1990年浦东开发开放以后持续形成的现代陆家嘴金融空间，则以新的基础设施和数字系统组织流动。',
    9 => '现代陆家嘴金融核心区并不意味着外滩相关金融与航运历史被清空；两岸需要放在同一城市经济系统的长期重组中理解。',
    _ =>
      '综合1843年的不平等条约背景、1927年现海关大楼的时间边界、1990年后陆家嘴现代金融空间的发展与黄浦江跨江关系，可以区分历史连续性、制度变化与简单“新替旧”叙事。',
  };
  final completionLens = switch (level) {
    1 => '本级收束在一次真实过江与“是否带走旧提单”的选择。',
    2 => '本级把轮渡路线与职业转向放在同一个可行动的城市空间中。',
    3 => '本级用提单的运输与责任关系理解旧纸为什么值得带过江。',
    4 => '本级用1927年现海关大楼的时间边界避免把不同年代的外滩混成一幅静止图。',
    5 => '本级从两岸同时可见理解“旧/新”不是简单替代。',
    6 => '本级加入1843年不平等条约背景，并拒绝中性化的一夜现代化叙事。',
    7 => '本级进一步用长期聚集、制度重组和建筑年代解释外滩功能的形成。',
    8 => '本级比较纸面单据与1990年后现代金融空间中的数字结算如何组织流动。',
    9 => '本级把外滩与陆家嘴放入同一城市经济系统进行多角度判断。',
    _ => '本级综合1843、1927与1990后三个时间层，完成历史、空间与现代金融关系的证据化判断。',
  };
  final storyResult = level == 1
      ? '林岸把旧提单带过黄浦江，仍继续走向新的工作；他没有用丢掉旧纸来证明自己已经离开过去。'
      : level <= 5
          ? '林岸仍选择去陆家嘴开始新工作，但把外祖父留下的旧海运提单一起带过黄浦江，不再把西岸当成必须丢下的过去。'
          : '林岸仍选择离开家庭旧行业、乘轮渡去陆家嘴开始新工作，但他把外祖父留下的旧海运提单带过黄浦江，并开始用历史、空间与流动关系重新判断“旧上海/新上海”的直线说法。';
  final relationshipAnswer = level == 1
      ? '母亲没有劝他留下，只把旧提单交给他，让他自己决定是否带它过江。'
      : level == 2
          ? '母亲没有反驳他的职业选择，只问他要不要把旧提单带走，把判断留给林岸自己。'
          : '母亲没有要求他留下或接班，只把旧提单交给他，并用纸船记忆和问题让他自己判断“换工作”是否等于“切断来路”。';

  return BatchOneJourneyMemorySpec(
    storyResult: storyResult,
    culturalPoint: culturalPoint,
    reviews: <RemediatedMemoryReview>[
      const RemediatedMemoryReview(
        category: 'choice',
        prompt: '到轮渡站前，林岸真正做了什么选择？',
        answer: '他没有把旧提单还给母亲，而是把它放进包里带上轮渡，同时保留去陆家嘴开始新工作的决定。',
        storyEventIds: <String>['BD2-E6', 'BD2-E7', 'BD2-E9'],
      ),
      RemediatedMemoryReview(
        category: 'relationship',
        prompt: '母亲怎样影响林岸，而没有替他选择职业？',
        answer: relationshipAnswer,
        storyEventIds: const <String>['BD2-E2', 'BD2-E3', 'BD2-E6'],
      ),
      RemediatedMemoryReview(
        category: 'place',
        prompt: '为什么这个故事不能随便搬到另一座城市的普通河岸？',
        answer: culturalPoint,
        storyEventIds: const <String>['BD2-E4', 'BD2-E7', 'BD2-E8'],
      ),
      const RemediatedMemoryReview(
        category: 'memory',
        prompt: '哪一个物件把家庭经验、人物选择与过江行动留在一起？',
        answer: '外祖父留下的旧海运提单副本。它跟林岸一起过江，成为“一张过江的旧提单”。',
        storyEventIds: <String>['BD2-E2', 'BD2-E7'],
      ),
    ],
    longTermAnchor: '一张过江的旧提单',
    completionSummary:
        '“双岸行者”完成：林岸没有放弃新职业，也没有通过丢掉旧提单来证明自己属于“新上海”。$completionLens 下一次遇到“新旧替代”的说法时，先分清哪些是可验证的历史与空间事实，哪些只是方便的直线叙事。',
  );
}

BatchOneJourneyMemorySpec? batchOneMemorySpecFor(
  String journeyId, {
  int? phoenixLevel,
}) {
  if (journeyId == shanghaiBundJourneyId) {
    return _shanghaiBundMemorySpecForLevel(
      phoenixLevel ?? PhoenixLevelController.instance.level,
    );
  }

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

  String memoryAnswer(String category) =>
      journey.memory.firstWhere((item) => item.category == category).answer;

  final culturalPoint = switch (journeyId) {
    chengduKuanzhaiJourneyId =>
      '${memoryAnswer('history')} ${memoryAnswer('preservation')}',
    nanjingQinhuaiJourneyId => '${memoryAnswer('选择')} ${memoryAnswer('画面')}',
    datongYungangJourneyId =>
      '${memoryAnswer('choice')} ${memoryAnswer('place')}',
    lijiangOldTownJourneyId ||
    hongheHaniRiceTerracesJourneyId ||
    pingyaoAncientCityJourneyId =>
      '${memoryAnswer('place')} ${memoryAnswer('memory')}',
    luoyangLongmenJourneyId ||
    kaipingDiaolouJourneyId =>
      '${memoryAnswer('truth')} ${memoryAnswer('place')}',
    xianCityWallJourneyId ||
    hangzhouWestLakeJourneyId =>
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
