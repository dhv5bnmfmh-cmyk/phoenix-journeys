import 'package:pinyin/pinyin.dart';

import '../agents/phoenix_language_level_agent.dart';
import '../models/story_content.dart';
import 'batch_one_journey_remediation.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const quanzhouKaiyuanJourneyId = 'quanzhou-kaiyuan-temple';
const quanzhouKaiyuanCanonicalTitle = '你敲，我就开';
const quanzhouKaiyuanHeadline = '受戒之前，他先把一把钥匙交还给姐姐';
const quanzhouKaiyuanDescription =
    '许安、许宁与家庭细节均为虚构；开元寺戒坛、民国初年传戒活动及泉州海洋商贸遗产机制依据 UNESCO 与泉州官方资料。';
const quanzhouKaiyuanDiscoveryTeaser =
    '一座佛寺为什么既能见证受戒制度，也能保存宋元泉州海洋商贸网络留下的多元文化痕迹？';
const quanzhouKaiyuanGeoNodeId = 'cn-fujian-quanzhou-licheng-kaiyuan-temple';

const quanzhouPrimaryDepthMechanism = 'PRACTICE / RITUAL CAUSALITY';
const quanzhouSecondaryDepthMechanisms = <String>[
  'INSTITUTIONAL / POWER CAUSALITY',
  'NARRATIVE SUBTEXT / RESTRAINT',
];
const quanzhouSupportingDepth = 'PLACE / SPATIAL CAUSALITY';
const quanzhouIntentionallyUnusedDepth = <String>[
  'MATERIAL CAUSALITY',
  'SOCIAL CAUSALITY',
  'ECONOMIC / LIVELIHOOD CAUSALITY',
  'ECOLOGICAL CAUSALITY',
  'INTERGENERATIONAL TRANSMISSION',
  'COLLECTIVE MEMORY',
  'AMBIGUITY / UNCERTAINTY',
  'ABSENCE / LOSS',
];
const quanzhouStorySignature =
    'PRACTICE CAUSALITY × ADULT SIBLING BELONGING × ORDINATION THRESHOLD × RELINQUISHED UNCHANGED FALLBACK';

const quanzhouKaiyuanSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-quanzhou-emporium',
    title: 'Quanzhou: Emporium of the World in Song-Yuan China',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1561/',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: [quanzhouKaiyuanGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'quanzhou-government-kaiyuan-temple',
    title: '开元寺',
    publisher: '泉州市人民政府',
    url: 'https://quanzhou.gov.cn/lyb/lytj/rmjdtj/202202/t20220224_2699974.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [quanzhouKaiyuanGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'quanzhou-government-buddhism-history',
    title: '佛教',
    publisher: '泉州市人民政府',
    url: 'https://www.quanzhou.gov.cn/lyb/lswh/zjwh/201609/t20160913_372277.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [quanzhouKaiyuanGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
  StorySourceRecord(
    id: 'quanzhou-religion-kaiyuan',
    title: '泉州开元寺',
    publisher: '泉州市民族与宗教事务局',
    url: 'https://mzzj.quanzhou.gov.cn/zjzc/qzzjhdcs/200712/t20071207_2313558.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: [quanzhouKaiyuanGeoNodeId],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-08-15',
  ),
];

const quanzhouSourceLedger = <Map<String, String>>[
  {
    'SOURCE_ID': 'QZ-S1',
    'SOURCE_TITLE': 'Quanzhou: Emporium of the World in Song-Yuan China',
    'AUTHORITY': 'UNESCO World Heritage Centre',
    'SOURCE_TYPE': 'WORLD HERITAGE PROPERTY RECORD',
    'RELEVANT_CLAIMS': 'integrated maritime emporium system; religious, administrative, production and transport components',
    'WHAT_IT_CAN_PROVE': 'system-level relationship between Kaiyuan Temple and Song-Yuan Quanzhou maritime trade',
    'WHAT_IT_CANNOT_PROVE': 'fictional people, dialogue, household motives or private actions',
    'CONFIDENCE': 'HIGH',
    'NOTES': 'Use for Discovery and place-system context, not as a fictional biography source.',
  },
  {
    'SOURCE_ID': 'QZ-S2',
    'SOURCE_TITLE': '开元寺',
    'AUTHORITY': '泉州市人民政府',
    'SOURCE_TYPE': 'OFFICIAL HERITAGE DESCRIPTION',
    'RELEVANT_CLAIMS': '1019 ordination platform; institutional status; Hindu spolia; towers; heritage management',
    'WHAT_IT_CAN_PROVE': 'Kaiyuan-specific architectural, institutional and material heritage mechanisms',
    'WHAT_IT_CANNOT_PROVE': 'fictional sibling history or emotional states',
    'CONFIDENCE': 'HIGH',
    'NOTES': 'Claims introduced with legend language remain legend and are not upgraded to fact.',
  },
  {
    'SOURCE_ID': 'QZ-S3',
    'SOURCE_TITLE': '佛教',
    'AUTHORITY': '泉州市人民政府',
    'SOURCE_TYPE': 'OFFICIAL RELIGIOUS-HISTORY OVERVIEW',
    'RELEVANT_CLAIMS': 'Republican-era ordination activity at Kaiyuan and other Quanzhou temples',
    'WHAT_IT_CAN_PROVE': 'the historical setting used for the fictional ordination-day Story',
    'WHAT_IT_CANNOT_PROVE': 'that any fictional character actually received ordination',
    'CONFIDENCE': 'HIGH',
    'NOTES': 'The Story stays at the level of a fictional ordinary person inside a verified practice context.',
  },
  {
    'SOURCE_ID': 'QZ-S4',
    'SOURCE_TITLE': '泉州开元寺',
    'AUTHORITY': '泉州市民族与宗教事务局',
    'SOURCE_TYPE': 'OFFICIAL RELIGIOUS-SITE RECORD',
    'RELEVANT_CLAIMS': 'Kaiyuan ordination platform history and temple layout',
    'WHAT_IT_CAN_PROVE': 'corroborating Kaiyuan place identity and ordination-platform chronology',
    'WHAT_IT_CANNOT_PROVE': 'private human Story facts',
    'CONFIDENCE': 'HIGH',
    'NOTES': 'Used as corroboration only where its wording is direct.',
  },
];

const quanzhouClaimLedger = <Map<String, String>>[
  {
    'CLAIM_ID': 'QZ-C1-ordination-platform',
    'CLAIM': '开元寺甘露戒坛始建于1019年，古代戒坛是佛教僧侣受戒的场所。',
    'CLAIM_TYPE': 'VERIFIED CULTURAL PRACTICE',
    'SOURCE': '泉州市人民政府 · 开元寺',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'quanzhou-government-kaiyuan-temple',
    'CONFIDENCE': 'HIGH',
    'STORY_USE': 'Primary place-causal threshold',
    'DISCOVERY_USE': 'Lv1-Lv10 ordination-platform explanation',
    'INTERPRETATION_BOUNDARY': '不把今天的现存建筑错误说成1019年原构；官方资料明确现存戒坛为1666年重修。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'QZ-C2-republican-ordination',
    'CLAIM': '民国初期，泉州开元寺等寺院仍有开坛传戒的度僧尼仪式。',
    'CLAIM_TYPE': 'VERIFIED HISTORICAL ACTION',
    'SOURCE': '泉州市人民政府 · 佛教',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'quanzhou-government-buddhism-history',
    'CONFIDENCE': 'HIGH',
    'STORY_USE': 'Verified historical setting for fictional ordination-day action',
    'DISCOVERY_USE': 'continuity of religious practice',
    'INTERPRETATION_BOUNDARY': '不把许安、许宁或某一次具体传戒登记为真实人物档案。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'QZ-C3-emporium-system',
    'CLAIM': 'UNESCO 将宋元泉州理解为由宗教、行政、生产与交通等组件共同构成的海洋商贸中心系统。',
    'CLAIM_TYPE': 'VERIFIED FACT',
    'SOURCE': 'UNESCO World Heritage Centre',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'unesco-quanzhou-emporium',
    'CONFIDENCE': 'HIGH',
    'STORY_USE': 'Place-world boundary only',
    'DISCOVERY_USE': 'core cultural system explanation',
    'INTERPRETATION_BOUNDARY': '不把“海洋商贸”写成每个寺院人物的个人动机。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'QZ-C4-hindu-spolia',
    'CLAIM': '开元寺大殿保存再利用的印度教石柱和相关石刻，官方说明将其视为外来文化与泉州本土文化交流融合的物证。',
    'CLAIM_TYPE': 'VERIFIED FACT',
    'SOURCE': '泉州市人民政府 · 开元寺',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'quanzhou-government-kaiyuan-temple',
    'CONFIDENCE': 'HIGH',
    'STORY_USE': 'INTENTIONALLY UNUSED',
    'DISCOVERY_USE': 'higher-level material-culture depth',
    'INTERPRETATION_BOUNDARY': '不把石柱拟人化，也不把它强行变成家庭关系的道德寓言。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'QZ-C5-towers',
    'CLAIM': '开元寺东西塔是宋代石塔，是泉州遗产组成中的重要建筑遗存。',
    'CLAIM_TYPE': 'VERIFIED FACT',
    'SOURCE': '泉州市人民政府 + UNESCO',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'quanzhou-government-kaiyuan-temple ; unesco-quanzhou-emporium',
    'CONFIDENCE': 'HIGH',
    'STORY_USE': 'NONE',
    'DISCOVERY_USE': 'architectural depth',
    'INTERPRETATION_BOUNDARY': '不把双塔变成 Story 的替代主角。',
    'RESULT': 'PASS',
  },
  {
    'CLAIM_ID': 'QZ-C6-fictional-family',
    'CLAIM': '许安、许宁、旧宅、空房、钥匙、孩子与姐弟对话均为虚构。',
    'CLAIM_TYPE': 'FICTIONAL CHARACTER ACTION',
    'SOURCE': 'Phoenix authored fiction',
    'SOURCE_LOCATION_OR_IDENTIFIER': 'quanzhou Story production record',
    'CONFIDENCE': 'EXPLICIT FICTION',
    'STORY_USE': 'human causal spine',
    'DISCOVERY_USE': 'truth-boundary reminder only',
    'INTERPRETATION_BOUNDARY': '不对应任何真实僧人、家庭、戒牒或寺院档案。',
    'RESULT': 'PASS',
  },
];

const quanzhouFactFictionLedger = <Map<String, String>>[
  {'ITEM': '1019年开元寺设戒坛', 'CLASSIFICATION': 'VERIFIED FACT', 'RESULT': 'PASS'},
  {'ITEM': '古代戒坛用于僧人受戒', 'CLASSIFICATION': 'VERIFIED CULTURAL PRACTICE', 'RESULT': 'PASS'},
  {'ITEM': '民国初期开元寺等仍有开坛传戒', 'CLASSIFICATION': 'VERIFIED HISTORICAL ACTION', 'RESULT': 'PASS'},
  {'ITEM': '许安、许宁及家庭关系', 'CLASSIFICATION': 'FICTIONAL CHARACTER ACTION', 'RESULT': 'PASS'},
  {'ITEM': '姐弟全部对话', 'CLASSIFICATION': 'FICTIONAL DIALOGUE', 'RESULT': 'PASS'},
  {'ITEM': '许安害怕失去自动回家的退路', 'CLASSIFICATION': 'FICTIONAL PERSONAL MOTIVATION', 'RESULT': 'PASS'},
  {'ITEM': '钥匙作为“冻结旧生活”的叙事载体', 'CLASSIFICATION': 'INTERPRETIVE STORY DEVICE', 'RESULT': 'PASS'},
  {'ITEM': '桑树开白莲等建寺传说', 'CLASSIFICATION': 'LEGEND / FOLKLORE — STORY UNUSED', 'RESULT': 'PASS'},
  {'ITEM': '未获来源支持的重要历史主张', 'CLASSIFICATION': 'UNSUPPORTED FACTUAL CLAIM', 'RESULT': 'NONE / BLOCKED'},
];

const quanzhouStoryIdentityCard = <String, String>{
  'JOURNEY': quanzhouKaiyuanJourneyId,
  'PLACE': '泉州开元寺 · 甘露戒坛',
  'TRUTH_MODE': 'FICTIONAL REPUBLICAN-ERA CHARACTERS INSIDE VERIFIED ORDINATION PRACTICE',
  'HUMAN_NEED': '进入新生活，同时确认亲情不会因生活身份改变而消失',
  'RELATIONSHIP_GEOMETRY': '准备受戒的成年弟弟 ↔ 不反对他选择、却拒绝替他冻结旧生活的姐姐',
  'WHY_TODAY': '开坛受戒把“以后再说”的变化变成当天要完成的行动',
  'WHAT_CANNOT_WAIT': '旧宅那间房是否继续作为弟弟随时按旧方式回去的保证',
  'WHAT_PROTAGONIST_REFUSES_TO_ADMIT': '他想改变自己的生活，却让姐姐独自承担保持旧生活不变的成本',
  'WHAT_PROTAGONIST_FEARS_LOSING': '不必解释、不必请求就能照旧回家的确定感',
  'WHAT_THE_OTHER_PERSON_WANTS': '继续是姐姐，但可以让自己的家庭生活继续变化',
  'PLACE_PRESSURE': '戒坛让身份转变成为实际发生的仪式阈值',
  'PRIMARY_DEPTH': quanzhouPrimaryDepthMechanism,
  'HUMAN_VALUE': '亲情可以延续，但不等于要求另一个人冻结生活',
  'CULTURAL_VALUE': '把戒坛作为真实宗教实践空间，而不是旅游背景',
  'EMOTIONAL_TEXTURE': '克制、贴近家庭细节、不煽情',
  'OPENING_ENERGY': '已经走到受戒阈值，家庭问题不能再无限延期',
  'FORBIDDEN_NEAREST_GOLD_SHAPES': 'Kaiping private-to-communal contribution; Guangzhou public kinship boundary; Shanghai continuity; Xian farewell circuit',
  'FORBIDDEN_DEFAULT_ENGINES': 'assignment-redesign; evidence deletion; inheritance secret; deadline shortcut; perfect artifact sacrifice; missing-message closure',
  'MUST_NOT_BECOME': 'religion teaches a moral; tourism exposition; generic farewell; community-property story',
};

const quanzhouStoryArchitectures = <Map<String, String>>[
  {
    'ID': 'A-ordination-without-frozen-home',
    'PROTAGONIST': '许安，民国初年虚构成年青年',
    'LIFE_CONTEXT': '准备在开元寺受戒',
    'RELATIONSHIP': '成年弟弟许安 ↔ 姐姐许宁',
    'HUMAN_NEED': '进入新生活而不把亲情等同于旧生活必须原样保存',
    'GOAL': '完成受戒前必须面对的家庭退路安排',
    'WHY_TODAY': '开坛传戒就在当天',
    'WHAT_CANNOT_WAIT': '旧宅房间是否继续空置',
    'HUMAN_STAKES': '姐弟关系如何在生活身份改变后继续，而不是假装没有改变',
    'PLACE_PRESSURE': '戒坛把身份转变从计划变成仪式行动',
    'CONFLICT': '弟弟要求旧生活保持原样 ↔ 姐姐拒绝为他冻结自己的家庭空间',
    'CHOICE': '弟弟交出钥匙，不再要求保留空房',
    'COST': '失去随时按旧方式进入旧宅、无需重新请求的保证',
    'CLIMAX': '受戒前把钥匙放进姐姐手中',
    'CONSEQUENCE': '姐姐可继续安排家庭空间；弟弟日后回来必须先敲门',
    'TRANSFORMATION': '从把亲情理解成不变入口，转向接受亲情存在而生活会变化',
    'ENDING_ACTION': '走向戒坛时摸到腰间空处；姐姐没有把钥匙递回去',
    'STORY_SHAPE': 'RITUAL THRESHOLD → FAMILY ENTITLEMENT NAMED → PHYSICAL RELINQUISHMENT → RELATIONSHIP REMAINS WITHOUT RESTORATION',
    'MEMORY_MOMENT': '姐姐掌心的钥匙与弟弟摸到的空处',
    'PRIMARY_DEPTH': 'PRACTICE / RITUAL CAUSALITY',
    'SECONDARY_DEPTH': 'INSTITUTIONAL / POWER CAUSALITY + NARRATIVE SUBTEXT',
    'NARRATIVE_ENGINE': 'an enacted religious threshold forces a sibling to stop outsourcing the cost of keeping his former life unchanged',
    'TRUTH_MODE': 'FICTIONAL CHARACTERS + VERIFIED REPUBLICAN ORDINATION CONTEXT',
    'HISTORICAL_RISK': 'LOW after moving from Northern Song household material assumptions to verified Republican ordination context',
    'PLACE_SUBSTITUTION_RESULT': 'PASS — generic museum/monument/district cannot create ordination; generic temple lacks verified Kaiyuan platform/practice binding',
    'NEAREST_GOLD_COLLISION_RISK': 'LOW-MEDIUM with Kaiping family/private-space language, controlled by non-communal, non-contribution engine',
    'SELECTED': 'YES',
  },
  {
    'ID': 'B-incense-fire-safety',
    'PROTAGONIST': '当代虚构母女',
    'RELATIONSHIP': '坚持旧烧香方式的母亲 ↔ 参与文保志愿的女儿',
    'GOAL': '完成一次家庭祈愿',
    'CONFLICT': '个人仪式习惯与文保防火规则冲突',
    'CHOICE': '改变香火方式',
    'COST': '放弃熟悉的仪式动作',
    'CLIMAX': '在规则前停止原动作',
    'CONSEQUENCE': '改用允许方式完成祈愿',
    'STORY_SHAPE': 'RULE CONSTRAINT → RESPONSIBLE REFUSAL → ADAPTED PRACTICE',
    'MEMORY_MOMENT': '未点燃的香',
    'PRIMARY_DEPTH': 'INSTITUTIONAL / POWER CAUSALITY',
    'NARRATIVE_ENGINE': 'heritage safety constraint reshapes personal ritual',
    'TRUTH_MODE': 'CONTEMPORARY FICTION + VERIFIED MANAGEMENT',
    'HISTORICAL_RISK': 'LOW',
    'PLACE_SUBSTITUTION_RESULT': 'FAIL — many protected temples reproduce the engine',
    'NEAREST_GOLD_COLLISION_RISK': 'HIGH — Nanjing operational refusal',
    'SELECTED': 'NO',
  },
  {
    'ID': 'C-spolia-family-identity',
    'PROTAGONIST': '当代虚构姐妹',
    'RELATIONSHIP': '对家庭身份理解不同的姐妹',
    'GOAL': '决定如何解释家族的多重文化经验',
    'CONFLICT': '单一身份叙述与复杂来历并存',
    'CHOICE': '保留并列而不强行统一',
    'COST': '失去一个简单的家庭标签',
    'CLIMAX': '在印度教石柱前放弃单一解释',
    'CONSEQUENCE': '姐妹接受不同自我描述',
    'STORY_SHAPE': 'MATERIAL TRACE → IDENTITY CONFLICT → PLURAL ACCEPTANCE',
    'MEMORY_MOMENT': '同一殿中的不同石刻',
    'PRIMARY_DEPTH': 'MATERIAL CAUSALITY',
    'NARRATIVE_ENGINE': 'material coexistence prompts identity plurality',
    'TRUTH_MODE': 'CONTEMPORARY FICTION + VERIFIED SPOLIA',
    'HISTORICAL_RISK': 'MEDIUM — heritage material risks becoming a moral metaphor',
    'PLACE_SUBSTITUTION_RESULT': 'PASS',
    'NEAREST_GOLD_COLLISION_RISK': 'HIGH — Guangzhou identity boundary / Forbidden City plural synthesis',
    'SELECTED': 'NO',
  },
];

const quanzhouPlaceCausalMechanism = <String, String>{
  'VERIFIED_PLACE_PROPERTY': '开元寺甘露戒坛始建于1019年，古代戒坛用于僧侣受戒；民国初期开元寺等仍有开坛传戒活动。',
  'SOURCE': '泉州市人民政府 · 开元寺 / 佛教',
  'VERIFIED_CULTURAL_HISTORICAL_MECHANISM': '受戒是实际宗教实践；戒坛把身份变化落实为有地点、有时刻的仪式行动。',
  'CHARACTER_ENCOUNTER': '虚构许安在开坛受戒当天由姐姐陪到甘露戒坛前。',
  'PRESSURE_CREATED': '他无法继续把生活变化说成“以后再处理”，必须处理要求姐姐冻结旧宅空间的退路。',
  'WHY_KAIYUAN_TEMPLE_MATTERS': 'Story 使用的是有权威史料支持的开元寺戒坛与传戒实践，不是佛寺外观。',
  'WHY_QUANZHOU_MATTERS': '开元寺同时属于泉州海洋商贸遗产系统，Discovery 可解释宗教机构与城市网络的关系。',
  'GOAL_EFFECT': '从抽象“想改变生活”变成当天要完成受戒与家庭安排。',
  'RELATIONSHIP_EFFECT': '姐姐必须决定是否继续替弟弟维持旧生活不变；弟弟必须回应她承担的实际成本。',
  'CONFLICT_EFFECT': '亲情延续与旧生活冻结被拆开。',
  'CHOICE_EFFECT': '弟弟在仪式阈值前交出钥匙。',
  'COST_EFFECT': '失去随时按旧方式回家的无条件入口。',
  'CONSEQUENCE_EFFECT': '姐姐可以继续安排家庭空间；未来回来要先敲门。',
  'GENERIC_PLACE_SUBSTITUTION': 'PASS — museum/monument/heritage district cannot enact ordination; unspecified temple does not preserve the verified Kaiyuan practice-and-platform specificity.',
};

const quanzhouDepthActionTest = <String, String>{
  'DEPTH': quanzhouPrimaryDepthMechanism,
  'SOURCE': 'official Kaiyuan ordination-platform history + official Republican-era ordination record',
  'CHARACTER_ENCOUNTER': 'ordination-day threshold meets a deferred sibling-home conflict',
  'ACTION_CAUSED': 'Xu An must stop postponing the household consequence and physically relinquish unchanged access',
  'CONSTRAINT': 'the ritual makes the new life concrete now rather than hypothetical later',
  'CHOICE_EFFECT': 'returns the key before proceeding toward ordination',
  'COST_EFFECT': 'loses automatic unchanged household fallback',
  'CONSEQUENCE_EFFECT': 'sister can let household life move; future return becomes requested welcome',
  'REMOVAL_TEST': 'without the verified ordination threshold, the same conversation can be postponed indefinitely and Goal-Conflict-Choice-Climax-Consequence lose their present causal pressure',
  'RESULT': 'PASS',
};

class _QuanzhouStorySegment {
  const _QuanzhouStorySegment({
    required this.fromLevel,
    required this.paragraph,
    required this.chinese,
    required this.vietnamese,
    required this.english,
  });

  final int fromLevel;
  final int paragraph;
  final String chinese;
  final String vietnamese;
  final String english;
}

const _quanzhouStorySegments = <_QuanzhouStorySegment>[
  _QuanzhouStorySegment(
    fromLevel: 1,
    paragraph: 0,
    chinese: '民国初年，泉州开元寺仍有开坛传戒的仪式。虚构青年许安要在这里受戒，姐姐许宁陪他走到甘露戒坛前。',
    vietnamese: 'Vào đầu thời Dân Quốc, chùa Khai Nguyên ở Tuyền Châu vẫn có các nghi lễ mở giới đàn truyền giới. Chàng trai hư cấu Hứa An sắp thọ giới tại đây, và chị gái Hứa Ninh đi cùng anh tới trước Giới đàn Cam Lộ.',
    english: 'In the early Republican period, Kaiyuan Temple in Quanzhou still held ordination ceremonies. The fictional young man Xu An is to receive ordination here, and his older sister Xu Ning walks with him to the Ganlu Ordination Platform.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 2,
    paragraph: 0,
    chinese: '他早已对姐姐说过要换一种生活，却一直把“以后还能照旧回家”留作不肯碰的退路。',
    vietnamese: 'Anh đã nói với chị từ lâu rằng mình muốn sống một đời khác, nhưng vẫn giữ ý nghĩ “sau này vẫn có thể về nhà như trước” như một lối lui không chịu chạm tới.',
    english: 'He has long told his sister that he wants a different life, yet he keeps “being able to come home exactly as before” as a fallback he refuses to examine.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 3,
    paragraph: 0,
    chinese: '开元寺的戒坛始建于1019年；在古代，戒坛是僧人受戒的场所。站到这里，许安不能再把受戒只说成一个遥远打算。',
    vietnamese: 'Giới đàn của chùa Khai Nguyên được dựng lần đầu vào năm 1019; trong lịch sử, giới đàn là nơi tăng nhân thọ giới. Đứng ở đây, Hứa An không còn có thể coi việc thọ giới chỉ là một dự định xa xôi.',
    english: 'Kaiyuan Temple’s ordination platform was first established in 1019; historically, an ordination platform was a place where Buddhist monastics received precepts. Standing here, Xu An can no longer treat ordination as a distant plan.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 3,
    paragraph: 0,
    chinese: '泉州官方资料还记录，民国初年开元寺等寺院仍举行传戒度僧仪式。这个地点与今天的决定之间，有直接的制度联系。',
    vietnamese: 'Tư liệu chính thức của Tuyền Châu còn ghi rằng vào đầu thời Dân Quốc, chùa Khai Nguyên và các chùa khác vẫn tổ chức nghi lễ truyền giới cho người xuất gia. Vì thế, nơi này có liên hệ trực tiếp với quyết định của ngày hôm nay.',
    english: 'Official Quanzhou records also state that Kaiyuan and other temples still held monastic ordination ceremonies in the early Republican period. The place therefore has a direct institutional connection to today’s decision.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 4,
    paragraph: 0,
    chinese: '他请许宁把自己在旧宅里的那间房原样留着，连钥匙也替他收好。姐姐一家一直挤住在旧宅里，那间空房却不能给孩子用。',
    vietnamese: 'Anh nhờ Hứa Ninh giữ nguyên căn phòng của mình trong ngôi nhà cũ và cất cả chìa khóa giúp anh. Gia đình người chị vẫn sống chật trong ngôi nhà ấy, nhưng căn phòng trống lại không thể dành cho con chị.',
    english: 'He asks Xu Ning to leave his room in the old house unchanged and even keep its key for him. Her family remains crowded in the old house, while the empty room cannot be used by her child.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 5,
    paragraph: 0,
    chinese: '许宁没有劝他回头。她只问：“你要我认你这个弟弟，还是要我替你把以前的日子也一起锁住？”许安一时答不上来。',
    vietnamese: 'Hứa Ninh không khuyên anh quay lại. Chị chỉ hỏi: “Em muốn chị vẫn nhận em là em trai, hay muốn chị khóa cả những ngày cũ lại cho em?” Hứa An nhất thời không trả lời được.',
    english: 'Xu Ning does not ask him to turn back. She only asks, “Do you want me to remain your sister, or do you want me to lock your old life in place for you too?” Xu An has no answer.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 5,
    paragraph: 0,
    chinese: '许安看见姐姐的手背上有一道旧烫痕，那是这些年在家里做饭留下的。他忽然意识到，自己口中的“留一间房”听起来很轻，实际却要另一个人日复一日替他承担空间、整理和等待。',
    vietnamese: 'Hứa An nhìn thấy một vết bỏng cũ trên mu bàn tay chị, dấu vết của những năm tháng nấu nướng trong nhà. Anh chợt nhận ra câu “để lại một căn phòng” nghe rất nhẹ, nhưng thực ra buộc một người khác ngày ngày gánh lấy không gian, việc thu xếp và sự chờ đợi.',
    english: 'Xu An notices an old burn mark on his sister’s hand, left by years of cooking at home. He suddenly understands that “keep one room for me” sounds small but asks another person to carry the space, upkeep, and waiting day after day.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 1,
    paragraph: 1,
    chinese: '许宁说，她不会不认这个弟弟，但不能永远替他守着一间空房。许安沉默许久，把钥匙放进姐姐手里：“房间别替我留了。我以后回来，先敲门。”',
    vietnamese: 'Hứa Ninh nói chị sẽ không bao giờ thôi nhận anh là em trai, nhưng không thể mãi giữ một căn phòng trống cho anh. Hứa An im lặng rất lâu rồi đặt chìa khóa vào tay chị: “Đừng để phòng lại cho em nữa. Sau này em về, em sẽ gõ cửa trước.”',
    english: 'Xu Ning says she will never stop recognizing him as her brother, but she cannot guard an empty room forever. After a long silence, Xu An places the key in her hand: “Don’t keep the room for me. When I come back, I’ll knock first.”',
  ),
  _QuanzhouStorySegment(
    fromLevel: 6,
    paragraph: 1,
    chinese: '这不是一句方便的话。钥匙交出去以后，他失去的是随时按旧方式进门、把家当作不必重新说明的退路。',
    vietnamese: 'Đó không phải một câu nói cho tiện. Khi trao chìa khóa đi, điều anh mất là quyền bước vào theo cách cũ bất cứ lúc nào và coi nhà như một lối lui không cần giải thích lại.',
    english: 'This is not a convenient phrase. Once he gives up the key, he loses the ability to enter in the old way at any time and to treat home as a fallback that never needs to be renegotiated.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 6,
    paragraph: 1,
    chinese: '他以前总把那把钥匙说成“只是留着”，仿佛不占任何人的位置。可旧宅里每一扇门都连着谁睡哪里、谁收拾哪里、孩子长大后往哪里挪。姐姐拒绝的不是他回来，而是把她的生活变成一张永远不能改动的底图。',
    vietnamese: 'Trước đây anh luôn nói chiếc chìa khóa ấy “chỉ là giữ lại”, như thể nó không chiếm chỗ của ai. Nhưng trong ngôi nhà cũ, mỗi cánh cửa đều gắn với ai ngủ ở đâu, ai dọn dẹp và con trẻ lớn lên sẽ chuyển sang chỗ nào. Điều người chị từ chối không phải là việc anh trở về, mà là biến đời sống của chị thành một bản nền vĩnh viễn không được sửa.',
    english: 'He used to say the key was “just being kept,” as though it occupied no one’s space. Yet every door in the old house is tied to who sleeps where, who maintains what, and where a growing child can move. His sister is not refusing his return; she is refusing to make her life a plan that can never be redrawn.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 7,
    paragraph: 1,
    chinese: '受戒的仪式没有替他解决姐弟之间的问题，却把“以后再说”压成了今天必须完成的动作。',
    vietnamese: 'Nghi lễ thọ giới không giải quyết thay vấn đề giữa hai chị em, nhưng nó ép câu “để sau hãy nói” thành một hành động phải hoàn tất hôm nay.',
    english: 'The ordination ritual does not solve the siblings’ problem for them, but it compresses “we’ll deal with it later” into an action that must be completed today.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 7,
    paragraph: 1,
    chinese: '甘露戒坛不是普通背景。受戒制度曾受官方管理；走到这里，许安不能再要求姐姐假装家里的关系什么都没有改变。',
    vietnamese: 'Giới đàn Cam Lộ không chỉ là phông nền. Chế độ thọ giới từng chịu sự quản lý chính thức; tới đây, Hứa An không thể tiếp tục đòi chị mình giả vờ rằng quan hệ trong nhà chưa thay đổi gì.',
    english: 'The Ganlu Ordination Platform is not mere scenery. Ordination was historically subject to official regulation; at this threshold, Xu An can no longer ask his sister to pretend that nothing in their household relationship has changed.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 8,
    paragraph: 1,
    chinese: '许宁把钥匙握住，没有说“你以后别回来”。她说：“你敲，我就开。”这句话保留了亲情，却没有把旧生活恢复成原样。',
    vietnamese: 'Hứa Ninh nắm lấy chìa khóa mà không nói “sau này đừng về nữa”. Chị nói: “Em gõ, chị sẽ mở.” Câu ấy giữ lại tình thân nhưng không khôi phục đời sống cũ nguyên vẹn.',
    english: 'Xu Ning closes her hand around the key without saying, “Don’t come back.” She says, “You knock, I’ll open.” The words preserve kinship without restoring the old life unchanged.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 8,
    paragraph: 1,
    chinese: '许宁收起钥匙，没有把弟弟推到门外，也没有说“家永远不变”。姐弟可以继续，不必靠空房作保证。',
    vietnamese: 'Hứa Ninh cất chìa khóa, không đẩy em trai ra ngoài cánh cửa, cũng không nói “nhà sẽ mãi không đổi”. Họ vẫn có thể là chị em mà không cần một căn phòng trống làm bảo chứng.',
    english: 'Xu Ning puts the key away. She neither pushes her brother outside the family nor promises that “home will never change.” They can remain siblings without an empty room serving as proof.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 9,
    paragraph: 1,
    chinese: '许安点头，没有再问那间房会给谁，也没有要求姐姐保证下一次回来时桌椅、床铺仍在原处。',
    vietnamese: 'Hứa An gật đầu. Anh không hỏi căn phòng sẽ dành cho ai và cũng không yêu cầu chị bảo đảm rằng lần sau trở về, bàn ghế và giường vẫn ở nguyên chỗ cũ.',
    english: 'Xu An nods. He no longer asks who will use the room or demands that the furniture and bed remain in the same places when he next returns.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 10,
    paragraph: 1,
    chinese: '他转身走向戒坛。走出几步，手在腰边摸了一下，只摸到空处。许宁站在原地，掌心里的钥匙没有再递回去。',
    vietnamese: 'Anh quay người đi về phía giới đàn. Sau vài bước, tay anh chạm vào bên hông và chỉ gặp khoảng trống. Hứa Ninh đứng lại, chiếc chìa khóa trong lòng bàn tay không được đưa trả.',
    english: 'He turns toward the ordination platform. After a few steps, his hand reaches for his waist and finds only empty space. Xu Ning remains where she is; the key in her palm is not handed back.',
  ),
  _QuanzhouStorySegment(
    fromLevel: 10,
    paragraph: 1,
    chinese: '人声从戒坛方向传来，许安没有回头确认姐姐还在不在。空下来的腰间没有给他新的保证，只留下下一次回来必须先敲门的事实。',
    vietnamese: 'Tiếng người vọng từ phía giới đàn. Hứa An không quay lại để xác nhận chị còn đứng đó hay không. Khoảng trống bên hông không cho anh một bảo đảm mới; nó chỉ để lại sự thật rằng lần sau trở về, anh phải gõ cửa trước.',
    english: 'Voices carry from the ordination platform. Xu An does not turn to check whether his sister is still there. The empty place at his waist gives him no new guarantee; it leaves only the fact that next time he returns, he must knock first.',
  ),
];

String _quanzhouPinyin(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

List<String> _quanzhouStoryParagraphs(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final active = _quanzhouStorySegments.where((item) => item.fromLevel <= level);
  if (level <= 2) return <String>[active.map((item) => item.chinese).join()];
  return <String>[
    active.where((item) => item.paragraph == 0).map((item) => item.chinese).join(),
    active.where((item) => item.paragraph == 1).map((item) => item.chinese).join(),
  ];
}

List<ReadingAnnotation> _quanzhouStoryAnnotations(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final active = _quanzhouStorySegments.where((item) => item.fromLevel <= level);
  ReadingAnnotation merge(Iterable<_QuanzhouStorySegment> items) {
    final list = items.toList(growable: false);
    final chinese = list.map((item) => item.chinese).join();
    return ReadingAnnotation(
      pinyin: _quanzhouPinyin(chinese),
      vietnamese: list.map((item) => item.vietnamese).join(' '),
      english: list.map((item) => item.english).join(' '),
    );
  }
  if (level <= 2) return <ReadingAnnotation>[merge(active)];
  return <ReadingAnnotation>[
    merge(active.where((item) => item.paragraph == 0)),
    merge(active.where((item) => item.paragraph == 1)),
  ];
}

DiscoveryEntry _quanzhouDiscovery({
  required String chinese,
  required String simple,
  required String vietnamese,
  required String english,
}) => DiscoveryEntry(
      text: chinese,
      pinyin: _quanzhouPinyin(chinese),
      simpleChinese: simple,
      vietnamese: vietnamese,
      english: english,
    );

final quanzhouKaiyuanDiscoveryPool = <DiscoveryEntry>[
  _quanzhouDiscovery(
    chinese: '泉州开元寺甘露戒坛始建于1019年。古代戒坛是佛教僧侣受戒的场所；10世纪以后，能够设立戒坛也与所在地区的官方地位有关。现存戒坛为1666年重修。',
    simple: '开元寺的戒坛与受戒制度有关，今天看到的建筑是后来重修的。',
    vietnamese: 'Giới đàn Cam Lộ của chùa Khai Nguyên ở Tuyền Châu được dựng lần đầu năm 1019. Trong lịch sử, đây là nơi tăng nhân thọ giới; sau thế kỷ X, việc được phép lập giới đàn cũng liên quan tới địa vị hành chính của địa phương. Công trình hiện còn được trùng tu năm 1666.',
    english: 'Kaiyuan Temple’s Ganlu Ordination Platform was first established in 1019. Historically, ordination platforms were places where Buddhist monastics received precepts; after the tenth century, permission to establish one was also tied to an area’s official standing. The surviving structure was rebuilt in 1666.',
  ),
  _quanzhouDiscovery(
    chinese: '泉州官方宗教史资料记录，民国初期开元寺、承天寺等仍有开坛传戒的度僧尼仪式。故事中的许安与许宁完全虚构，没有对应真实僧人、戒牒或家族档案。',
    simple: '民国初年泉州仍有传戒活动，但故事人物不是历史人物。',
    vietnamese: 'Tư liệu lịch sử tôn giáo chính thức của Tuyền Châu ghi nhận rằng vào đầu thời Dân Quốc, chùa Khai Nguyên, chùa Thừa Thiên và các chùa khác vẫn tổ chức nghi lễ truyền giới. Hứa An và Hứa Ninh trong truyện hoàn toàn hư cấu, không tương ứng với tăng nhân, giới điệp hay hồ sơ gia đình có thật.',
    english: 'Official Quanzhou religious-history records state that Kaiyuan Temple, Chengtian Temple, and others still held ordination ceremonies in the early Republican period. Xu An and Xu Ning are entirely fictional and correspond to no real monk, ordination certificate, or family archive.',
  ),
  _quanzhouDiscovery(
    chinese: 'UNESCO 将“泉州：宋元中国的世界海洋商贸中心”理解为一个相互连接的系统。宗教场所、行政机构、生产地点、桥梁、码头和航标等组件共同说明港口城市怎样运作。',
    simple: '宋元泉州的世界遗产不是单一建筑，而是一套互相关联的城市和港口系统。',
    vietnamese: 'UNESCO nhìn nhận “Tuyền Châu: Trung tâm thương mại hàng hải thế giới của Trung Quốc thời Tống-Nguyên” như một hệ thống liên kết. Các địa điểm tôn giáo, cơ quan hành chính, nơi sản xuất, cầu, bến cảng và mốc hàng hải cùng giải thích cách đô thị cảng vận hành.',
    english: 'UNESCO interprets “Quanzhou: Emporium of the World in Song-Yuan China” as an interconnected system. Religious sites, administrative institutions, production sites, bridges, docks, and navigational landmarks together explain how the port city functioned.',
  ),
  _quanzhouDiscovery(
    chinese: '开元寺是宋元泉州规模大、官方地位突出的佛教寺院。理解它不能只看寺院内部，还要看到它与海洋商贸城市的宗教、社会和交通网络共同存在。',
    simple: '开元寺既是佛教寺院，也是宋元泉州城市网络中的重要组成。',
    vietnamese: 'Khai Nguyên là một ngôi chùa Phật giáo quy mô lớn và có địa vị chính thức nổi bật ở Tuyền Châu thời Tống-Nguyên. Hiểu ngôi chùa không chỉ là nhìn vào bên trong chùa, mà còn phải thấy nó cùng tồn tại với các mạng lưới tôn giáo, xã hội và giao thông của đô thị thương mại hàng hải.',
    english: 'Kaiyuan was a large Buddhist monastery of prominent official standing in Song-Yuan Quanzhou. Understanding it requires looking beyond the temple enclosure to its place alongside the religious, social, and transport networks of a maritime trading city.',
  ),
  _quanzhouDiscovery(
    chinese: '开元寺大殿保存了再利用的印度教石柱与相关石刻。泉州官方资料指出，这些构件在17世纪重修中进入佛教殿宇，并经过本地化改造，是不同文化在泉州交流与重新组合的物证。',
    simple: '开元寺里有来自印度教建筑传统的石构件，后来被重新用于佛教建筑。',
    vietnamese: 'Chính điện chùa Khai Nguyên lưu giữ các cột đá và chạm khắc Hindu được tái sử dụng. Tư liệu chính thức Tuyền Châu cho biết các cấu kiện này được đưa vào điện Phật trong đợt trùng tu thế kỷ XVII và được biến đổi theo địa phương, trở thành chứng cứ vật chất của sự giao lưu và tái tổ hợp văn hóa.',
    english: 'Kaiyuan Temple’s main hall preserves reused Hindu stone columns and related carvings. Official Quanzhou sources state that these components entered the Buddhist hall during a seventeenth-century reconstruction and were locally adapted, providing material evidence of cultural exchange and recombination.',
  ),
  _quanzhouDiscovery(
    chinese: '开元寺东西两座石塔在宋代完成，以石构模仿木构建筑形态。它们既是佛教建筑，也成为泉州历史城市天际线中极具辨识度的遗存。',
    simple: '开元寺双塔是宋代石塔，石构建筑中保留了木构形式的特征。',
    vietnamese: 'Hai tháp đá Đông và Tây của chùa Khai Nguyên được hoàn thành vào thời Tống, dùng đá mô phỏng hình thức kiến trúc gỗ. Chúng vừa là công trình Phật giáo vừa là dấu tích rất dễ nhận biết trên đường chân trời đô thị lịch sử Tuyền Châu.',
    english: 'Kaiyuan Temple’s East and West stone pagodas were completed in the Song dynasty and use stone to emulate forms of timber architecture. They are both Buddhist structures and highly recognizable remains in Quanzhou’s historic skyline.',
  ),
  _quanzhouDiscovery(
    chinese: '泉州官方资料还记录开元寺僧人参与桥梁等公共交通设施的建设。宗教机构并非与港口城市生活隔绝，它也可能进入道路、桥梁和公共事务网络。',
    simple: '开元寺僧人也曾参与桥梁等公共建设，寺院与城市生活有联系。',
    vietnamese: 'Tư liệu chính thức Tuyền Châu còn ghi nhận tăng nhân Khai Nguyên tham gia xây dựng cầu và các hạ tầng giao thông công cộng khác. Cơ sở tôn giáo không tách khỏi đời sống đô thị cảng mà có thể tham gia vào mạng lưới đường sá, cầu cống và công việc công cộng.',
    english: 'Official Quanzhou sources also record Kaiyuan monks participating in the construction of bridges and other public transport infrastructure. Religious institutions were not isolated from port-city life and could take part in networks of roads, bridges, and civic works.',
  ),
  _quanzhouDiscovery(
    chinese: '今天的开元寺仍是佛教活动场所，同时也是世界遗产组成部分。寺院僧侣、信众、宗教与文物管理部门共同参与日常管理，活态宗教实践与遗产保护需要同时被看见。',
    simple: '今天的开元寺既有宗教活动，也要进行世界遗产保护管理。',
    vietnamese: 'Ngày nay chùa Khai Nguyên vẫn là nơi sinh hoạt Phật giáo đồng thời là một thành phần của Di sản Thế giới. Tăng chúng, tín đồ, cơ quan tôn giáo và cơ quan bảo tồn cùng tham gia quản lý hằng ngày, vì vậy thực hành tôn giáo sống và bảo tồn di sản cần được nhìn nhận đồng thời.',
    english: 'Today Kaiyuan Temple remains a place of Buddhist activity and is also a component of the World Heritage property. Monastics, devotees, religious authorities, and heritage agencies share daily management, so living religious practice and heritage conservation must be understood together.',
  ),
];

class _QuanzhouWordSpec {
  const _QuanzhouWordSpec(this.word, this.partOfSpeech, this.simple, this.vietnamese, this.english, this.symbol, this.exampleChinese, this.exampleVietnamese, this.exampleEnglish);
  final String word;
  final String partOfSpeech;
  final String simple;
  final String vietnamese;
  final String english;
  final String symbol;
  final String exampleChinese;
  final String exampleVietnamese;
  final String exampleEnglish;
}

const _quanzhouWordSpecs = <_QuanzhouWordSpec>[
  _QuanzhouWordSpec('开元寺', '名词（专名）', '泉州重要佛教寺院，也是世界遗产组成部分。', 'Chùa Khai Nguyên ở Tuyền Châu.', 'Kaiyuan Temple in Quanzhou.', '🛕', '许安在开元寺受戒。', 'Hứa An thọ giới tại chùa Khai Nguyên.', 'Xu An receives ordination at Kaiyuan Temple.'),
  _QuanzhouWordSpec('戒坛', '名词', '佛教僧侣举行受戒仪式的专门场所。', 'Giới đàn, nơi cử hành nghi lễ thọ giới.', 'an ordination platform for Buddhist precepts', '🏛️', '甘露戒坛是故事的地点压力。', 'Giới đàn Cam Lộ tạo nên áp lực về thời điểm trong truyện.', 'The Ganlu Ordination Platform creates the story’s place pressure.'),
  _QuanzhouWordSpec('受戒', '动词', '按佛教制度接受戒律。', 'Thọ giới theo giới luật Phật giáo.', 'to receive Buddhist precepts or ordination', '🙏', '许安已经决定受戒。', 'Hứa An đã quyết định thọ giới.', 'Xu An has decided to receive ordination.'),
  _QuanzhouWordSpec('姐姐', '名词', '同父母或家庭关系中年长的女性手足。', 'Chị gái.', 'older sister', '👩', '姐姐许宁陪他到戒坛前。', 'Chị gái Hứa Ninh đi cùng anh tới giới đàn.', 'His older sister Xu Ning accompanies him to the platform.'),
  _QuanzhouWordSpec('弟弟', '名词', '同父母或家庭关系中年幼的男性手足。', 'Em trai.', 'younger brother', '👨', '许宁不会不认这个弟弟。', 'Hứa Ninh sẽ không thôi nhận người em trai này.', 'Xu Ning will not stop recognizing him as her brother.'),
  _QuanzhouWordSpec('旧宅', '名词', '以前长期居住的老房子。', 'Ngôi nhà cũ từng ở lâu dài.', 'an old family home', '🏠', '姐姐一家仍住在旧宅里。', 'Gia đình người chị vẫn sống trong ngôi nhà cũ.', 'His sister’s family still lives in the old house.'),
  _QuanzhouWordSpec('房间', '名词', '房屋内部独立使用的空间。', 'Căn phòng.', 'a room', '🚪', '许安不再要求姐姐保留那间房间。', 'Hứa An không còn yêu cầu chị giữ căn phòng đó.', 'Xu An no longer asks his sister to preserve the room.'),
  _QuanzhouWordSpec('钥匙', '名词', '开锁使用的工具。', 'Chìa khóa.', 'a key', '🔑', '许安把钥匙放进姐姐手里。', 'Hứa An đặt chìa khóa vào tay chị.', 'Xu An places the key in his sister’s hand.'),
  _QuanzhouWordSpec('退路', '名词', '遇到变化时可以退回的选择。', 'Lối lui.', 'a fallback or retreat option', '↩️', '他把照旧回家当作退路。', 'Anh coi việc về nhà như cũ là một lối lui.', 'He treats returning home unchanged as a fallback.'),
  _QuanzhouWordSpec('敲门', '动词', '敲击门面请里面的人开门。', 'Gõ cửa.', 'to knock on a door', '✊', '他说以后回来先敲门。', 'Anh nói sau này về sẽ gõ cửa trước.', 'He says he will knock first when he returns.'),
  _QuanzhouWordSpec('传戒', '动词', '佛教中传授戒律、举行受戒的活动。', 'Truyền giới.', 'to confer Buddhist precepts', '📜', '民国初年泉州仍有传戒活动。', 'Đầu thời Dân Quốc Tuyền Châu vẫn có hoạt động truyền giới.', 'Quanzhou still had ordination activity in the early Republican period.'),
  _QuanzhouWordSpec('仪式', '名词', '按一定规程进行的正式活动。', 'Nghi lễ.', 'a formal ritual or ceremony', '🕯️', '受戒是一种正式宗教仪式。', 'Thọ giới là một nghi lễ tôn giáo chính thức.', 'Ordination is a formal religious ceremony.'),
  _QuanzhouWordSpec('佛教', '名词', '发源于古代印度并传播至东亚的重要宗教传统。', 'Phật giáo.', 'Buddhism', '☸️', '开元寺是佛教寺院。', 'Khai Nguyên là một ngôi chùa Phật giáo.', 'Kaiyuan is a Buddhist monastery.'),
  _QuanzhouWordSpec('海洋商贸', '名词', '通过海路进行的商品、人员与制度联系。', 'Thương mại hàng hải.', 'maritime trade', '🌊', '宋元泉州是重要的海洋商贸中心。', 'Tuyền Châu thời Tống-Nguyên là trung tâm thương mại hàng hải quan trọng.', 'Song-Yuan Quanzhou was an important maritime trading center.'),
  _QuanzhouWordSpec('石塔', '名词', '以石材建造的塔。', 'Tháp đá.', 'a stone pagoda', '🗼', '开元寺东西塔是宋代石塔。', 'Hai tháp Đông Tây Khai Nguyên là tháp đá thời Tống.', 'Kaiyuan’s East and West Pagodas are Song-dynasty stone pagodas.'),
  _QuanzhouWordSpec('石柱', '名词', '以石材制作的柱状建筑构件。', 'Cột đá.', 'a stone column', '🪨', '大殿保存再利用的印度教石柱。', 'Chính điện lưu giữ các cột đá Hindu được tái sử dụng.', 'The main hall preserves reused Hindu stone columns.'),
  _QuanzhouWordSpec('多元文化', '名词', '多种文化传统在同一社会空间中相遇并互动。', 'Đa văn hóa.', 'cultural plurality', '🌐', '开元寺保存多元文化交流的物质痕迹。', 'Khai Nguyên lưu giữ dấu tích vật chất của giao lưu đa văn hóa.', 'Kaiyuan preserves material traces of cultural plurality and exchange.'),
  _QuanzhouWordSpec('世界遗产', '名词', '列入联合国教科文组织《世界遗产名录》的遗产。', 'Di sản Thế giới.', 'World Heritage', '🏅', '开元寺是泉州世界遗产体系的组成部分。', 'Khai Nguyên là một thành phần của hệ thống Di sản Thế giới Tuyền Châu.', 'Kaiyuan is a component of Quanzhou’s World Heritage property.'),
];

WordEntry _quanzhouWord(_QuanzhouWordSpec spec) => WordEntry(
      word: spec.word,
      pinyin: _quanzhouPinyin(spec.word),
      partOfSpeech: spec.partOfSpeech,
      simpleChinese: spec.simple,
      translation: spec.vietnamese,
      englishDefinition: spec.english,
      symbol: spec.symbol,
      examples: <WordExample>[
        for (var i = 0; i < 3; i++)
          WordExample(
            chinese: spec.exampleChinese,
            pinyin: _quanzhouPinyin(spec.exampleChinese),
            vietnamese: spec.exampleVietnamese,
            english: spec.exampleEnglish,
          ),
      ],
    );

final quanzhouKaiyuanWords = List<WordEntry>.unmodifiable(_quanzhouWordSpecs.map(_quanzhouWord));

const _quanzhouDiscoveryIndexes = <List<int>>[
  [0, 1],
  [0, 2],
  [0, 3],
  [1, 2],
  [0, 2, 3],
  [0, 4, 5],
  [2, 3, 6],
  [3, 4, 5],
  [2, 6, 7],
  [2, 4, 7],
];

const _quanzhouAgent = PhoenixLanguageLevelAgent();

JourneyLevelContent _buildQuanzhouKaiyuanLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final storyParagraphs = _quanzhouStoryParagraphs(level);
  final storyAnnotations = _quanzhouStoryAnnotations(level);
  final discoveries = <DiscoveryEntry>[
    for (final index in _quanzhouDiscoveryIndexes[level - 1]) quanzhouKaiyuanDiscoveryPool[index],
  ];
  final profile = _quanzhouAgent.profileForPhoenixLevel(level);
  final targetVocabularyCount = _quanzhouAgent.planFor(profile).targetVocabularyCount;
  final visibleText = '${storyParagraphs.join()}${discoveries.map((item) => item.text).join()}';
  final candidates = quanzhouKaiyuanWords.where((entry) => visibleText.contains(entry.word)).toList(growable: false);
  if (candidates.length < targetVocabularyCount) {
    throw StateError('Quanzhou Lv$level has ${candidates.length} source-bound words; requires $targetVocabularyCount.');
  }
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(storyParagraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(storyAnnotations),
    words: List<WordEntry>.unmodifiable(candidates.take(targetVocabularyCount)),
    discoveries: List<DiscoveryEntry>.unmodifiable(discoveries),
    wonderQuestion: '许安为什么必须在走向戒坛前处理那把钥匙？',
    expressQuestion: '开元寺的受戒实践怎样把姐弟之间可以拖延的问题变成当天必须完成的选择？',
  );
}

final quanzhouKaiyuanOnePassLevels = List<JourneyLevelContent>.unmodifiable(
  List<JourneyLevelContent>.generate(10, (index) => _buildQuanzhouKaiyuanLevel(index + 1), growable: false),
);

JourneyLevelContent quanzhouKaiyuanGoldLevelContent(int requestedLevel) =>
    quanzhouKaiyuanOnePassLevels[requestedLevel.clamp(1, 10).toInt() - 1];

final _quanzhouEvents = <RemediatedSemanticEvent>[
  for (var index = 0; index < _quanzhouStorySegments.where((item) => item.fromLevel == 1).length; index++)
    RemediatedSemanticEvent(
      id: 'QZ-E${index + 1}',
      coreChinese: _quanzhouStorySegments.where((item) => item.fromLevel == 1).elementAt(index).chinese,
      corePinyin: _quanzhouPinyin(_quanzhouStorySegments.where((item) => item.fromLevel == 1).elementAt(index).chinese),
      coreVietnamese: _quanzhouStorySegments.where((item) => item.fromLevel == 1).elementAt(index).vietnamese,
      coreEnglish: _quanzhouStorySegments.where((item) => item.fromLevel == 1).elementAt(index).english,
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11,
    ),
];

final quanzhouKaiyuanGoldJourney = RemediatedJourney(
  id: quanzhouKaiyuanJourneyId,
  title: quanzhouKaiyuanCanonicalTitle,
  protagonist: '许安，民国初年准备在开元寺受戒的虚构成年青年',
  goal: '完成受戒，同时不再把姐姐的家庭生活当作必须原样保存的退路',
  conflict: '许安要求保留旧宅空房与自动回家方式，许宁拒绝替他冻结自己的家庭空间',
  eventIds: List<String>.unmodifiable(_quanzhouEvents.map((event) => event.id)),
  events: List<RemediatedSemanticEvent>.unmodifiable(_quanzhouEvents),
  levels: quanzhouKaiyuanOnePassLevels,
  words: quanzhouKaiyuanWords,
  wordTraces: List<RemediatedWordTrace>.unmodifiable([
    for (final word in quanzhouKaiyuanWords)
      RemediatedWordTrace(word: word.word, eventId: 'QZ-E1', usage: 'source-bound active Story/Discovery vocabulary', sourceText: word.examples.first.chinese),
  ]),
  discoveries: List<DiscoveryEntry>.unmodifiable(quanzhouKaiyuanDiscoveryPool),
  discoveryTraces: List<RemediatedDiscoveryTrace>.unmodifiable([
    for (var index = 0; index < quanzhouKaiyuanDiscoveryPool.length; index++)
      RemediatedDiscoveryTrace(
        discoveryIndex: index,
        storyEventIds: index <= 1 ? const ['QZ-E1', 'QZ-E2'] : const <String>[],
        sourceIds: index <= 1
            ? const ['quanzhou-government-kaiyuan-temple', 'quanzhou-government-buddhism-history']
            : const ['unesco-quanzhou-emporium', 'quanzhou-government-kaiyuan-temple'],
      ),
  ]),
  challenges: const <RemediatedChallengeTrace>[
    RemediatedChallengeTrace(type: 'paragraphRebuild', storyEventIds: ['QZ-E1', 'QZ-E2'], anchor: '受戒阈值→姐姐拒绝冻结空房→交出钥匙→以后回来先敲门'),
    RemediatedChallengeTrace(type: 'grammarRepair', storyEventIds: ['QZ-E1', 'QZ-E2'], anchor: '只修复当前 Story / Discovery 句子，不引入新历史主张'),
    RemediatedChallengeTrace(type: 'missingSentence', storyEventIds: ['QZ-E1', 'QZ-E2'], anchor: '钥匙选择必须连接姐姐承担的空间成本与未来敲门的后果'),
  ],
  memory: const <RemediatedMemoryReview>[
    RemediatedMemoryReview(category: 'choice', prompt: '许安在受戒前真正做了什么选择？', answer: '他把旧宅钥匙交给姐姐，不再要求姐姐替他保留一间永远不变的空房。', storyEventIds: ['QZ-E2']),
    RemediatedMemoryReview(category: 'place', prompt: '为什么这个决定在开元寺戒坛前特别有压力？', answer: '开元寺有真实的受戒制度与戒坛历史；传戒当天把生活变化变成必须面对的现实行动。', storyEventIds: ['QZ-E1', 'QZ-E2']),
    RemediatedMemoryReview(category: 'truth', prompt: '许安、许宁和那把钥匙是真实历史人物与档案吗？', answer: '不是。人物、家庭、钥匙与对话全部为虚构；开元寺戒坛和民国初年的传戒背景来自官方资料。', storyEventIds: ['QZ-E1']),
    RemediatedMemoryReview(category: 'memory', prompt: '故事最后留住的动作是什么？', answer: '许安走向戒坛时摸到腰间空处，许宁掌心里的钥匙没有再递回去。', storyEventIds: ['QZ-E2']),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '受戒之前，许安交出旧宅钥匙，不再要求姐姐替他冻结旧生活；姐弟关系留下，自动回家的旧方式结束。',
    achievement: '门前的选择者',
    memoryAnchor: '姐姐掌心的钥匙与许安摸到的空处',
    challengeReward: '你分清了受戒实践、家庭选择与宋元泉州文化机制各自承担的作用。',
    journeyCompletion: '开元寺不是旅游背景：戒坛让人物的生活变化在这里成为必须完成的行动，而海洋商贸与多元文化深度留在 Discovery 中解释。',
  ),
  sources: const <RemediatedSourceBinding>[
    RemediatedSourceBinding(id: 'unesco-quanzhou-emporium', publisher: 'UNESCO World Heritage Centre', scope: 'Song-Yuan maritime emporium integrated system and component relationships'),
    RemediatedSourceBinding(id: 'quanzhou-government-kaiyuan-temple', publisher: '泉州市人民政府', scope: 'Kaiyuan ordination platform, institutional status, Hindu spolia, towers and management'),
    RemediatedSourceBinding(id: 'quanzhou-government-buddhism-history', publisher: '泉州市人民政府', scope: 'Republican-era ordination activity in Quanzhou including Kaiyuan'),
    RemediatedSourceBinding(id: 'quanzhou-religion-kaiyuan', publisher: '泉州市民族与宗教事务局', scope: 'Kaiyuan ordination-platform chronology and religious-site corroboration'),
  ],
);

final _quanzhouBaseLevel = quanzhouKaiyuanGoldLevelContent(5);

final quanzhouKaiyuanJourney = JourneyContentRecord(
  id: quanzhouKaiyuanJourneyId,
  title: quanzhouKaiyuanCanonicalTitle,
  geoNodeId: quanzhouKaiyuanGeoNodeId,
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['泉州', '开元寺', '甘露戒坛', '受戒', '宋元海洋商贸'],
  sections: <JourneyStorySection>[
    for (var index = 0; index < _quanzhouBaseLevel.storyParagraphs.length; index++)
      JourneyStorySection(
        id: 'story-$index',
        text: _quanzhouBaseLevel.storyParagraphs[index],
        sourceIds: const ['quanzhou-government-kaiyuan-temple', 'quanzhou-government-buddhism-history'],
      ),
  ],
);

final quanzhouKaiyuanExperience = DailyJourneyExperience(
  id: quanzhouKaiyuanJourneyId,
  city: '泉州',
  cityCode: 'JJN',
  place: '开元寺',
  appBarTitle: '泉州 · 开元寺',
  storyTitle: quanzhouKaiyuanCanonicalTitle,
  headline: quanzhouKaiyuanHeadline,
  description: quanzhouKaiyuanDescription,
  discoveryTeaser: quanzhouKaiyuanDiscoveryTeaser,
  distanceLabel: '1,250 km',
  stampSymbol: '泉',
  content: quanzhouKaiyuanJourney,
  storyAnnotations: _quanzhouBaseLevel.storyAnnotations,
  words: _quanzhouBaseLevel.words,
  discoveries: _quanzhouBaseLevel.discoveries,
  wonderQuestion: _quanzhouBaseLevel.wonderQuestion,
  expressQuestion: _quanzhouBaseLevel.expressQuestion,
);

const quanzhouHistoricalSafetyAudit = <String, String>{
  'UNSUPPORTED_HISTORICAL_FACT': 'NONE',
  'REAL_PERSON_FABRICATED_ACTION': 'NONE',
  'REAL_PERSON_FABRICATED_DIALOGUE': 'NONE',
  'REAL_PERSON_FABRICATED_MOTIVE': 'NONE',
  'FICTIONAL_FAMILY_MISREPRESENTED_AS_ARCHIVE': 'NONE',
  'LEGEND_PRESENTED_AS_FACT': 'NONE',
  'CONTESTED_PRESENTED_AS_CERTAIN': 'NONE',
  'TEMPORAL_ANACHRONISM': 'NONE — Story moved to verified Republican ordination context after Song-household key risk review',
  'ORDINATION_PLATFORM_ORIGINAL_STRUCTURE_MERGE': 'NONE — 1019 foundation and 1666 surviving rebuild kept distinct',
  'HINDU_SPOLIA_MORAL_METAPHOR': 'NONE — material mechanism stays Discovery/future depth',
  'TRANSLATION_TRUTH_DRIFT': 'NONE',
  'UNSOURCED_STORY_CAUSAL_FACT': 'NONE',
};

const quanzhouFuturePlaceStoryOpportunities = <String>[
  'MATERIAL CAUSALITY — Hindu spolia and local adaptation without turning material plurality into a ready-made family metaphor',
  'URBAN NETWORK CAUSALITY — Kaiyuan monks, bridges and port-city civic infrastructure',
  'ARCHITECTURAL TECHNOLOGY — Song stone towers and stone imitation of timber forms',
  'LIVING HERITAGE — present religious practice and heritage-management negotiation',
];
