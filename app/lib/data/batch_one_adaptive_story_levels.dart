import '../models/language_proficiency.dart';
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

const _summerPalaceMemorySpec = BatchOneJourneyMemorySpec(
  storyResult:
      '许澄在十七孔桥金光亮起、旧照片被风吹落时放下相机先捡照片。她错过等了一下午的画面，却改拍旧照片、外婆的手和正在暗下的桥洞，并把作品命名为《留下痕迹的风景》。',
  culturalPoint:
      '颐和园的价值不只在一张“无瑕”风景照里。清漪园在1860年遭毁，1886年开始重建；今天的园林景观同时承载自然山水、人工营造与历史修复留下的时间层次。',
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
      storyEventIds: <String>[
        'trustChange',
        'photographEntrusted',
      ],
    ),
    RemediatedMemoryReview(
      category: 'place',
      prompt: '为什么这个故事不能随便搬到另一座普通公园？',
      answer:
          '十七孔桥冬至前后的短暂落日光影制造了不可暂停的拍摄窗口，而颐和园1860年受损、1886年开始重建的历史又让旧照片与“留下痕迹”真正有意义。',
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
  longTermAnchor: '她没有留下“无瑕”的金光，却留下了旧照片、外婆的手和一幅承认时间痕迹的新作品。',
  completionSummary:
      '作品《留下痕迹的风景》完成了这次 Journey：许澄失去预想中的完美画面，却获得独立判断，也接过旧照片与修复记忆。下一次面对“完美”与真实痕迹的冲突时，先问自己准备留下什么、又愿意为选择承担什么。',
);

BatchOneJourneyMemorySpec? batchOneMemorySpecFor(String journeyId) {
  if (journeyId == _summerPalaceJourneyId) return _summerPalaceMemorySpec;

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
