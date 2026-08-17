import 'package:pinyin/pinyin.dart';

import '../agents/phoenix_language_level_agent.dart';
import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const lijiangOldTownJourneyId = 'lijiang-old-town';
const lijiangOldTownCanonicalTitle = '桥空出来以后';
const lijiangOldTownHeadline = '一驮茶堵住桥时，他割掉了两个人的本钱';
const lijiangOldTownDescription =
    '清末丽江，虚构商贩和清在四方街散市后的火情里割断姐弟共同货物的捆绳，让桥下古城水系真正进入人的选择与代价。';
const lijiangOldTownDiscoveryTeaser = '丽江古城为什么让街、桥、市场和水同时成为一套生活系统？';

class LijiangArchitecture {
  const LijiangArchitecture({
    required this.id,
    required this.protagonist,
    required this.relationship,
    required this.engine,
    required this.choice,
    required this.cost,
    required this.memory,
    required this.selected,
    required this.rejectedReason,
  });

  final String id;
  final String protagonist;
  final String relationship;
  final String engine;
  final String choice;
  final String cost;
  final String memory;
  final bool selected;
  final String rejectedReason;
}

const lijiangOldTownArchitectures = <LijiangArchitecture>[
  LijiangArchitecture(
    id: 'A-bridge-under-fire',
    protagonist: '和清，虚构清末普通商贩',
    relationship: '与姐姐和素共同持有一驮茶、共同背债，却对谁有权承担损失意见相反',
    engine: '四方街散市后的虚构小火情，使沿街水渠、跨渠小桥、木构民居与马帮货物在同一空间发生冲突',
    choice: '和清在姐姐反对时割断共同货物的捆绳，先让被驮货堵住的小桥成为取水通道',
    cost: '数包茶叶浸水、次日交易失去、共同债务延后，同时他必须承担未经共同所有人同意处置货物的关系代价',
    memory: '捆绳弹开，茶包滚进水里，小桥露出一线空处，第一只水桶越过桥。',
    selected: true,
    rejectedReason: '',
  ),
  LijiangArchitecture(
    id: 'B-three-well-before-market',
    protagonist: '虚构早餐摊主',
    relationship: '年长摊主与第一次独立备货的晚辈',
    engine: '三眼井上饮、中洗菜、下洗衣的用水秩序与清晨备货冲突',
    choice: '宁可错过早市也不用上池洗菜',
    cost: '失去第一批客人并暴露双方对信任的分歧',
    memory: '晚辈端着菜篮从上池退到中池。',
    selected: false,
    rejectedReason: '真实机制成立，但人类骨架容易退化成“赶时间→拒绝不当捷径→守规则”，与现有 Gold 的责任型选择过近。',
  ),
  LijiangArchitecture(
    id: 'C-square-wash-away-proof',
    protagonist: '虚构马帮账房',
    relationship: '旧合伙人与被误解的年轻伙计',
    engine: '四方街散市后放水冲街，形成会真实改变地面物件位置的短时窗口',
    choice: '放弃抢回能证明自己无责的账纸，先拉开被水逼到桥边的伙计',
    cost: '失去自证材料，误会不能当场洗清',
    memory: '纸页在石板水面打了一个转，越过鞋尖。',
    selected: false,
    rejectedReason: '地点机制鲜明，但核心仍接近“证据/证明→放弃或删除→关系转向”的既有 Story 形状，且对纸面装置依赖过强。',
  ),
];

const lijiangSourceLedger = <Map<String, String>>[
  {
    'id': 'LJ-S1',
    'title': 'Old Town of Lijiang',
    'authority': 'UNESCO World Heritage Centre',
    'type': 'UNESCO / World Heritage',
    'period': '12th century onward; Ming-Qing morphology; present conservation',
    'claimsSupported': 'three-part property; Dayan commercial centre; uneven topography; canal network; timber houses; multi-cultural architecture; trade; water for fire prevention/daily life/production',
    'claimsNotSupported': 'the fictional fire, fictional siblings, fictional cargo loss, private debt, private dialogue',
    'confidence': 'HIGH',
    'storyUse': 'water/fire/bridge/timber/trade world conditions',
    'discoveryUse': 'core Lv1-Lv10 historical-spatial explanation',
  },
  {
    'id': 'LJ-S2',
    'title': '走进丽江古城 探寻世界文化遗产的密码',
    'authority': '国家文物局来源稿（政府文物系统转载）',
    'type': 'national heritage authority',
    'period': 'historical synthesis published 2025-03-22',
    'claimsSupported': '宋末元初建城; 三眼井上饮中洗菜下洗衣; 四方街商业中心; 无城墙; 茶马古道与马帮集散; 多民族交流',
    'claimsNotSupported': 'any private fictional action in the Story',
    'confidence': 'HIGH',
    'storyUse': 'market/caravan context',
    'discoveryUse': 'water custom, trade, city form',
  },
  {
    'id': 'LJ-S3',
    'title': '纳西族风俗习惯',
    'authority': '国家民族事务委员会',
    'type': 'national government cultural authority',
    'period': 'Ming-Qing through modern ethnographic description',
    'claimsSupported': 'main streets beside water; lanes near channels; bridges; courtyard architecture; Qing-era absorption of Han/Bai/Tibetan building techniques; Sifang Street water flushing',
    'claimsNotSupported': 'the Story family, trade amount, debt, fire event',
    'confidence': 'HIGH',
    'storyUse': 'period plausibility and spatial texture',
    'discoveryUse': 'architecture and water-city relation',
  },
  {
    'id': 'LJ-S4',
    'title': '守护古城文脉 延续历史风貌 / 四方街放水冲街资料',
    'authority': '丽江古城保护管理系统 / 丽江市融媒体公开资料',
    'type': 'local heritage management evidence',
    'period': 'historic custom to present',
    'claimsSupported': '四方街利用西河与街面高差放水冲街; water system remains living heritage',
    'claimsNotSupported': 'Story fire or fictional people',
    'confidence': 'MEDIUM-HIGH',
    'storyUse': 'rejected Architecture C only; not required by selected Story',
    'discoveryUse': 'Lv4/Lv8 street-water management example',
  },
];

const lijiangClaimLedger = <Map<String, String>>[
  {
    'id': 'LJ-C1',
    'claim': '丽江古城顺应不平地形形成城镇空间，古老水系由黑龙潭等水源进入城镇并分成渠道。',
    'source': 'LJ-S1',
    'factType': 'VERIFIED PHYSICAL / SPATIAL CONDITION',
    'certainty': 'HIGH',
    'proves': '水、街、桥可以在同一古城生活空间中发生作用',
    'doesNotProve': '任何特定虚构火情或私人选择',
    'storyUse': 'bridge/water setting',
    'discoveryUse': 'Lv1-Lv3',
    'status': 'ALLOWED',
  },
  {
    'id': 'LJ-C2',
    'claim': '丽江古城水系历史上满足防火、日常生活与生产需要。',
    'source': 'LJ-S1',
    'factType': 'VERIFIED INSTITUTIONAL / PHYSICAL CONDITION',
    'certainty': 'HIGH',
    'proves': '以沿街水源参与虚构居民灭火具有真实世界基础',
    'doesNotProve': 'Story 中某一桶水、某一座桥、某一次火被史料记录',
    'storyUse': 'central Place mechanism',
    'discoveryUse': 'Lv7-Lv8',
    'status': 'ALLOWED',
  },
  {
    'id': 'LJ-C3',
    'claim': '四方街长期是商业中心，丽江自12世纪以来是滇川藏贸易与茶马古道重要集散地。',
    'source': 'LJ-S1 + LJ-S2',
    'factType': 'VERIFIED HISTORICAL / ECONOMIC CONDITION',
    'certainty': 'HIGH',
    'proves': '清末普通商贩、马帮买卖与货物在古城中心相遇具有历史可行性',
    'doesNotProve': '和清、和素或这驮茶真实存在',
    'storyUse': 'livelihood pressure',
    'discoveryUse': 'Lv5-Lv7',
    'status': 'ALLOWED',
  },
  {
    'id': 'LJ-C4',
    'claim': '丽江古城民居大量采用木构，街巷临水并有大量跨渠桥梁。',
    'source': 'LJ-S1 + LJ-S3',
    'factType': 'VERIFIED PHYSICAL / SPATIAL CONDITION',
    'certainty': 'HIGH',
    'proves': '木屋、水渠、桥的组合不是旅游装饰，而能实际组织应急行动',
    'doesNotProve': '虚构邻院火灾的历史真实性',
    'storyUse': 'central Story pressure',
    'discoveryUse': 'Lv3/Lv6/Lv8',
    'status': 'ALLOWED',
  },
  {
    'id': 'LJ-C5',
    'claim': '三眼井依地势分为上池饮用、中池洗菜、下池洗衣的用水方式。',
    'source': 'LJ-S2',
    'factType': 'VERIFIED CULTURAL PRACTICE',
    'certainty': 'HIGH',
    'proves': '古城水并非纯景观，而有分层生活实践',
    'doesNotProve': 'Architecture B 的虚构摊主真实存在',
    'storyUse': 'rejected Architecture B only',
    'discoveryUse': 'Lv4',
    'status': 'ALLOWED',
  },
];

const lijiangFactFictionLedger = <Map<String, String>>[
  {'item': '清末丽江古城仍处于茶马古道商贸网络与四方街集散语境', 'category': 'VERIFIED HISTORICAL CONDITION', 'status': 'ALLOWED'},
  {'item': '沿街水渠、桥、木构民居以及水系防火功能', 'category': 'VERIFIED PHYSICAL / SPATIAL CONDITION', 'status': 'ALLOWED'},
  {'item': '和清、和素的姓名、年龄、姐弟身份、共同负债', 'category': 'FICTIONAL CHARACTER IDENTITY / BACKSTORY / RELATIONSHIP', 'status': 'ALLOWED'},
  {'item': '散市后邻院突然发生的小火情', 'category': 'FICTIONAL CHARACTER / PRIVATE EVENT', 'status': 'ALLOWED — explicitly fictional, not represented as documented history'},
  {'item': '姐弟共同持有一驮茶及次日买卖', 'category': 'FICTIONAL CHARACTER BACKSTORY / ACTION', 'status': 'ALLOWED'},
  {'item': '和清割绳、茶包落水、邻人递桶、火势被控制', 'category': 'FICTIONAL CHARACTER ACTION / CONSEQUENCE', 'status': 'ALLOWED'},
  {'item': '任何土司、官员、宗教人物或真实名人的私人动机/对话', 'category': 'REAL PERSON HIGH-PROTECTION', 'status': 'NOT USED'},
  {'item': '虚构禁令、虚构处罚、虚构古城统一消防制度', 'category': 'UNSUPPORTED FACTUAL CLAIM', 'status': 'BLOCKED / NOT USED'},
];

const lijiangPlaceCausalMechanism = <String, String>{
  'verifiedFact': '沿街水渠与跨渠桥梁共同组织古城空间，水系有明确防火功能；四方街又是马帮商贸集散中心。',
  'period': '清末（世界条件由宋元以来商贸、水系和明清城镇形态支撑）',
  'placeCondition': '木构街区 + 近距离水渠 + 桥面通行 + 马帮货物同时占据同一生活/商业空间',
  'affects': 'Goal / Conflict / Choice / Cost / Climax / Consequence / Ending',
  'enables': '货物可以真实堵住跨渠通道；清空桥面后，沿街水源能够立即进入虚构灭火行动',
  'limits': '主人公没有抽象的“安全按钮”；必须在共同货物和眼前通道之间做物理选择',
  'fictionalSituation': '一场没有冒充真实史事的邻院小火情',
  'relationshipPressure': '货物属于姐弟两人，弟弟的应急决定同时处置姐姐的一半本钱',
  'goal': '保住次日交易、偿还共同债务',
  'conflict': '共同生计资产占住当下最直接的取水通道',
  'choice': '未经姐姐同意割断捆绳，牺牲共同货物以清空桥面',
  'cost': '茶叶浸水、交易失去、债延后、共同所有权被越过',
  'consequence': '虚构邻人可以跨桥传水，虚构火情未延烧到下一排房屋；姐弟必须共同承担真实可见的货损',
  'genericPlaceTest': 'PASS — 移除丽江“沿街水系兼具防火功能 + 桥与市场货流重叠”的配置后，货物不会因同一原因堵住取水通道，割绳这一 Choice/Climax 必须重建。',
  'otherCityTest': 'PASS — 不是声称世界上只有丽江有水或火，而是当前 Story 的桥、水、马帮货流和木构街区因丽江已验证配置同时发生；替换为普通古城需要重造 cause。',
};

const lijiangStoryIdentityCard = <String, String>{
  'Journey': lijiangOldTownJourneyId,
  'Place': '中国 → 云南省 → 丽江市 → 丽江古城（大研古城）',
  'Period': '清末',
  'TruthMode': 'VERIFIED WORLD + FICTIONAL ORDINARY PEOPLE',
  'Protagonist': '和清，虚构成年普通商贩',
  'LifeContext': '与姐姐合钱做一笔小生意，并共同背着上一季未清的私人债务',
  'RelationshipGeometry': '姐弟共同所有人；姐姐更看重保住共同本钱，弟弟在紧急情境中越过共同决定权',
  'HumanNeed': '既想把债还掉，也想让姐姐承认自己能共同承担生意，而不是只会冲动做主',
  'Goal': '保住一驮茶，在次日买家离城前完成交易并偿还共同债务',
  'WhyToday': '虚构买家次日离城；散市后突然出现虚构火情',
  'WhatCannotWait': '火星已经接近下一排木屋，堵桥货物不能慢慢绕行',
  'HumanStakes': '两人的本钱、债、彼此对“谁有权决定共同损失”的信任',
  'VerifiedLijiangPressure': '沿街水渠、跨渠桥、木构建筑、防火用水与马帮商业空间叠在一起',
  'WhatIsFact': '丽江空间、水系防火功能、四方街商业与茶马古道条件',
  'WhatIsFiction': '人物、债、货、买家、火情、对话、割绳、传桶及私人后果',
  'PrimaryDepth': '共同所有权下的手足信任',
  'SecondaryDepths': '生计脆弱性；邻里互助；紧急行动后的长期责任',
  'Conflict': '要保住还债货物，却正是这批共同货物堵住了最直接的取水桥面',
  'Choice': '割断捆绳，让共同货物受损并清空桥',
  'Cost': '损失交易与延长债务，同时冒着姐姐认为他再次擅自做主的风险',
  'Climax': '刀割断最后一股绳，姐姐伸手欲拦却停住，桥面露出能递水桶的一线空处',
  'Consequence': '火情被控制、货物受损、债仍在；姐姐最终把扁担另一头扛上肩',
  'Transformation': '和清从“证明自己能做主”转成“接受共同损失也要共同承担”；和素从阻拦转为用行动共同承担结果',
  'MemoryMoment': '茶包滚进水里，小桥空出来，第一只水桶越桥。',
  'EndingAction': '姐弟一人一头抬起湿茶回院，没有解释句替他们和解。',
  'WhyLijiangMatters': '水不是布景；它和桥、木屋、市场货流一起制造 Choice、Cost 和可见 Consequence。',
  'GenericOldTownTest': 'PASS',
  'OtherCityTest': 'PASS',
  'NearestGoldRisks': 'Kaiping 的“私人资产/共同安全”；现有 responsible-refusal / evidence-deletion 骨架。通过突发物理风险、共同所有权、直接毁损资产与无外部批准的行动保持区别。',
  'ForbiddenStoryShapes': '学生任务→失败→导师→重做；证据不足→删除；拒绝捷径；旧物→家庭和解；generic stay/leave',
};

const lijiangPrimaryDepth = '共同所有权下的手足信任';
const lijiangSecondaryDepths = <String>['生计脆弱性', '邻里互助', '紧急行动后的长期责任'];

const lijiangTaxonomyGovernance = <Map<String, String>>[
  {
    'proposedFamily': 'privateLivelihoodAssetVsImmediateSharedSafety',
    'causalFunction': '共同生计资产本身阻断眼前公共安全行动，必须承受不可逆物质损失才能解除风险',
    'nearest': 'privateCommemorationVsCommunalSafety; completeResultVsResponsibleBoundary',
    'distinction': 'Kaiping 是远程书信协商私人纪念建筑与长期共同避险；Lijiang 是突发物理风险下共同生计资产直接堵住应急通道，没有等待授权或回信。',
    'journeySpecificNaming': 'PASS',
    'taxonomyLaundering': 'PASS',
  },
  {
    'proposedFamily': 'destroySharedAssetToOpenEmergencyAccess',
    'causalFunction': '通过毁损自己也无权单独处分的共同资产，立即创造救险通行能力',
    'nearest': 'sacrificeIdealResultToPreserveRelationalEvidence; riskReturnToRequestCollectiveConsent',
    'distinction': '不是放弃美学结果，也不是把决定交给远方同意；选择本身是即时物理拆除并承担共同财产损失。',
    'journeySpecificNaming': 'PASS',
    'taxonomyLaundering': 'PASS',
  },
  {
    'proposedFamily': 'distributedWaterInfrastructureEnablesEmergencyResponse',
    'causalFunction': '分布式生活供水基础设施在危险发生时同时成为近距离应急资源',
    'nearest': 'heritageOperationsConstrainSpectacle; historicCourtyardMorphologyConstrainsSharedUse',
    'distinction': '这里的遗产机制不是限制展示或安排共享节奏，而是直接改变救险动作的空间可行性。',
    'journeySpecificNaming': 'PASS',
    'taxonomyLaundering': 'PASS',
  },
];

class _LijiangSegment {
  const _LijiangSegment(this.event, this.from, this.zh, this.vi, this.en);
  final int event;
  final int from;
  final String zh;
  final String vi;
  final String en;
}

const _segments = <_LijiangSegment>[
  _LijiangSegment(0, 1, '清末黄昏，四方街刚散市。虚构商贩和清与姐姐和素守着一驮茶叶；明早买家离城，这笔钱要还两人共同的债。', 'Một buổi chiều cuối thời Thanh, chợ ở Tứ Phương vừa tan. Người buôn hư cấu Hòa Thanh và chị gái Hòa Tố trông một chuyến trà; sáng mai người mua rời thành và số tiền này phải trả món nợ chung của hai chị em.', 'At dusk in the late Qing, the market at Sifang Street has just dispersed. The fictional trader He Qing and his older sister He Su guard a mule-load of tea; the buyer leaves in the morning, and the sale must pay their shared debt.'),
  _LijiangSegment(0, 2, '这驮茶是姐弟俩合钱收下的；和素已经把买家的时辰记在心里，错过这一趟，他们又要多背一季债。', 'Hai chị em đã góp tiền mua lô trà này. Hòa Tố nhớ kỹ giờ hẹn; lỡ chuyến này nghĩa là họ phải gánh món nợ thêm một mùa nữa.', 'The siblings pooled their money for this load. He Su has memorized the buyer’s time; missing this deal means carrying the debt for another season.'),
  _LijiangSegment(0, 7, '下午，和清亲眼看着几支马帮从不同巷口挤进四方街。姐姐踮脚找了三次，才认出约好明早来收茶的人。', 'Thương nhân từ nhiều hướng tụ về Tứ Phương; người mua của hai chị em chỉ là một đoàn trong số đó. Với họ, giao dịch sáng mai không phải phông nền lịch sử mà là cơ hội thực sự để trả nợ.', 'Traders arriving from different directions gather at Sifang Street; the siblings’ buyer is only one group among them. For the pair, tomorrow’s sale is not historical scenery but their immediate chance to clear debt.'),

  _LijiangSegment(1, 1, '邻院突然起火。水渠就在桥下，可他们的驮货正堵着小桥。', 'Một sân nhà bên cạnh bất ngờ bốc cháy. Kênh nước ở ngay dưới cầu, nhưng hàng của họ đang chặn chiếc cầu nhỏ.', 'A neighboring courtyard suddenly catches fire. The canal is directly below, but their loaded goods block the small bridge.'),
  _LijiangSegment(1, 3, '四方街周围的巷子顺着地势和水道展开，桥把两边的铺面连在一起。散市后，人和牲口都在往不同方向退。', 'Các ngõ quanh Tứ Phương đi theo địa hình và dòng nước, những cây cầu nối các cửa hàng hai bờ. Sau khi chợ tan, người và súc vật cùng rút về nhiều hướng.', 'Lanes around Sifang Street follow the terrain and waterways, while bridges join shops on opposite banks. After the market disperses, people and pack animals withdraw in different directions.'),
  _LijiangSegment(1, 5, '烟贴着屋檐压下来。桥窄，满载的骡子不肯倒退；要绕到另一处过水，得穿过刚散去的人群。', 'Khói ép thấp dưới mái hiên. Cầu hẹp, con la chở nặng không chịu lùi; muốn vòng sang chỗ khác lấy nước phải xuyên qua đám đông vừa tan.', 'Smoke presses under the eaves. The bridge is narrow and the loaded mule refuses to back up; reaching another crossing means pushing through the dispersing crowd.'),
  _LijiangSegment(1, 8, '和清低头就看见桥下的水光。离火最近的几户已经把木桶拖到巷口，却被那驮横在桥上的茶挡住。', 'Kênh nước chạy sát các phố ngõ và nhiều cầu bắc thẳng qua dòng nước. Ngày thường chúng kéo buôn bán và đời sống lại gần nhau; khi có cháy, nguồn nước cũng ở rất gần nhà gỗ.', 'Canals run beside the lanes and many bridges cross the water directly. In ordinary life they pull trade and homes close together; during fire they also put water close to timber houses.'),

  _LijiangSegment(2, 1, '和素要他先保住货。和清看见火星已经扑向隔壁木屋。', 'Hòa Tố bảo em phải giữ hàng trước. Hòa Thanh thấy tia lửa đã lao về căn nhà gỗ kế bên.', 'He Su tells him to save the goods first. He Qing sees sparks already reaching toward the neighboring timber house.'),
  _LijiangSegment(2, 4, '和素一把抓住骡缰：“先把货牵出去。”她也有一半本钱压在茶包里。和清伸手去接缰绳，却听见木头炸开一声。', 'Hòa Tố chộp dây cương: “Dắt hàng ra trước.” Một nửa vốn của cô cũng nằm trong những bao trà. Hòa Thanh vừa đưa tay nhận dây thì nghe gỗ nổ đánh một tiếng.', 'He Su grabs the rein. “Get the load out first.” Half her capital is tied up in those tea sacks too. He Qing reaches for the rein and hears timber crack.'),
  _LijiangSegment(2, 9, '和清想起下午两人还为谁去见买家吵过一场。和素说债是两个人的，不能总由弟弟替她决定；现在他偏偏又要替她做一次更大的决定。', 'Hòa Thanh nhớ chiều nay họ còn cãi nhau xem ai sẽ gặp người mua. Hòa Tố nói nợ là của cả hai, em trai không thể luôn quyết thay chị; vậy mà lúc này cậu lại sắp quyết một việc còn lớn hơn.', 'He Qing remembers their argument that afternoon over who would meet the buyer. He Su had said the debt belonged to both of them and her brother could not always decide for her; now he is about to make an even larger decision on her behalf.'),

  _LijiangSegment(3, 1, '他抽刀割断捆绳，把茶包推开，几包直接滚进水里，小桥空了出来。', 'Cậu rút dao cắt dây buộc, đẩy các bao trà sang bên; vài bao lăn thẳng xuống nước và chiếc cầu trống ra.', 'He draws a knife and cuts the lashings, shoving the tea sacks aside. Several roll straight into the water, and the bridge opens.'),
  _LijiangSegment(3, 5, '和清握着刀没有立刻落下。割绳不是毁掉自己的货那么简单，他是在替姐姐决定她那一半本钱也一起受损。', 'Hòa Thanh cầm dao nhưng không hạ xuống ngay. Cắt dây không chỉ là phá hàng của mình; cậu đang quyết thay chị rằng nửa vốn của chị cũng sẽ chịu thiệt.', 'He Qing holds the knife without cutting at once. This is not merely destroying his own goods; he is deciding that his sister’s half of the capital will be damaged too.'),
  _LijiangSegment(3, 6, '和素喊了他的名字。第二声还没出口，火星已经越过院墙，落在靠河一侧的木檐上。和清把刀口压进绳结。', 'Hòa Tố gọi tên em. Chưa kịp gọi lần thứ hai, tia lửa đã vượt qua tường sân và rơi lên mái gỗ phía bờ nước. Hòa Thanh ấn lưỡi dao vào nút dây.', 'He Su calls his name. Before a second call comes, sparks cross the courtyard wall and land on a timber eave beside the water. He Qing presses the blade into the knot.'),
  _LijiangSegment(3, 10, '刀割开最后一股绳时，和素伸手像要拦，又停在半空。茶包落地，桥面露出一线空处。', 'Khi dao cắt đứt sợi cuối, Hòa Tố đưa tay như muốn ngăn rồi dừng giữa không trung. Bao trà rơi xuống và mặt cầu lộ ra một lối hẹp.', 'As the knife severs the last strand, He Su reaches out as if to stop him, then freezes. The tea sacks fall and a narrow strip of bridge appears.'),

  _LijiangSegment(4, 1, '邻人从水渠提水过桥，火终于没有烧到下一排房子。湿茶却卖不成了，债还在。', 'Hàng xóm múc nước từ kênh và chuyển qua cầu; cuối cùng lửa không cháy sang dãy nhà kế tiếp. Nhưng trà ướt không thể bán và món nợ vẫn còn.', 'Neighbors lift water from the canal and carry it across the bridge; the fire does not reach the next row of houses. But the wet tea cannot be sold, and the debt remains.'),
  _LijiangSegment(4, 6, '第一只水桶从桥上递过去时，和清还踩着一包漂在浅水里的茶。和素站在桥头，没有再去牵骡子，只接过下一只桶。', 'Khi xô nước đầu tiên được chuyền qua cầu, Hòa Thanh vẫn đang giẫm lên một bao trà nổi trong nước nông. Hòa Tố đứng đầu cầu, không dắt la nữa mà nhận lấy xô kế tiếp.', 'When the first bucket passes over the bridge, He Qing is still stepping on a tea sack floating in shallow water. He Su stands at the bridgehead, stops trying to lead the mule away, and takes the next bucket.'),
  _LijiangSegment(4, 7, '没人有空问是谁先割了绳。水桶沿桥和巷口一只只传过去，原来被货占住的那几步路，忽然比整驮茶更值钱。', 'Không ai rảnh hỏi ai đã cắt dây trước. Những xô nước chuyền qua cầu và đầu ngõ; mấy bước đường vừa bị hàng chiếm chỗ bỗng quý hơn cả chuyến trà.', 'No one has time to ask who cut the rope. Buckets move one by one across the bridge and lane mouth; the few steps once occupied by cargo suddenly matter more than the entire tea load.'),
  _LijiangSegment(4, 10, '桥另一头有人喊水。和清递下空桶，再接住满桶；湿绳在手腕勒出红印。', 'Có người bên kia cầu gọi nước. Hòa Thanh chuyền xô rỗng xuống rồi nhận xô đầy; sợi dây ướt siết một vệt đỏ quanh cổ tay.', 'Someone across the bridge calls for water. He Qing passes down an empty bucket and catches a full one; the wet rope leaves a red mark on his wrist.'),

  _LijiangSegment(5, 1, '天亮，和清搬起湿茶。和素没说话，只扛起扁担另一头，和他一起往院里走。', 'Trời sáng, Hòa Thanh nhấc những bao trà ướt. Hòa Tố không nói gì, chỉ ghé vai vào đầu kia của đòn gánh và cùng em đi về sân nhà.', 'At dawn, He Qing lifts the wet tea. He Su says nothing; she simply shoulders the other end of the carrying pole and walks back to the courtyard with him.'),
  _LijiangSegment(5, 8, '火势压下去以后，和素蹲在水边摸了一把茶包。她没有看和清，只问：“还能剩几包？”和清说不知道。', 'Sau khi lửa dịu xuống, Hòa Tố ngồi bên nước sờ một bao trà. Cô không nhìn em, chỉ hỏi: “Còn được mấy bao?” Hòa Thanh nói không biết.', 'After the fire subsides, He Su crouches by the water and touches a tea sack. She does not look at He Qing, only asks, “How many can we keep?” He says he does not know.'),
  _LijiangSegment(5, 9, '姐弟俩把没进水的茶搬到墙边。和素数到第五包时停了一下，把还能卖的那一包推到两人中间。', 'Hai chị em chuyển phần trà chưa ngấm nước vào sát tường, không ai nhắc người mua sáng mai. Món nợ chung từ cuộc cãi vã xem ai quyết định trở thành thiệt hại cả hai đều phải gánh.', 'The siblings move the dry sacks to the wall and neither mentions the morning buyer. Their shared debt changes from an argument over who gets to decide into a loss both must carry.'),
  _LijiangSegment(5, 10, '天色发白，买家会不会等仍没答案。和素把扁担往弟弟那边挪了一点，让重量落在两人中间。', 'Trời dần sáng và không ai biết người mua có chờ hay không. Hòa Tố dịch đòn gánh một chút về phía em để sức nặng nằm giữa hai người.', 'Daylight grows and there is still no answer about whether the buyer will wait. He Su shifts the carrying pole slightly toward her brother so the weight settles between them.'),
];

String _pinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

List<JourneyLevelContent> _buildLijiangLevels() {
  const agent = PhoenixLanguageLevelAgent();
  return List<JourneyLevelContent>.generate(10, (index) {
    final level = index + 1;
    final visible = _segments.where((segment) => segment.from <= level).toList(growable: false);
    final first = visible.where((segment) => segment.event <= 2).toList(growable: false);
    final second = visible.where((segment) => segment.event >= 3).toList(growable: false);

    ReadingAnnotation annotationFor(List<_LijiangSegment> segments) => ReadingAnnotation(
          pinyin: _pinyin(segments.map((segment) => segment.zh).join()),
          vietnamese: segments.map((segment) => segment.vi).join(' '),
          english: segments.map((segment) => segment.en).join(' '),
        );

    final storyParagraphs = level <= 2
        ? <String>[visible.map((segment) => segment.zh).join()]
        : <String>[
            first.map((segment) => segment.zh).join(),
            second.map((segment) => segment.zh).join(),
          ];
    final storyAnnotations = level <= 2
        ? <ReadingAnnotation>[annotationFor(visible)]
        : <ReadingAnnotation>[annotationFor(first), annotationFor(second)];
    final discoveries = lijiangDiscoveriesForLevel(level);
    final context = '${storyParagraphs.join()}${discoveries.map((entry) => entry.text).join()}';
    final target = agent.planFor(agent.profileForPhoenixLevel(level)).targetVocabularyCount;
    final words = lijiangOldTownWords
        .where((word) => context.contains(word.word))
        .take(target)
        .toList(growable: false);

    return JourneyLevelContent(
      storyParagraphs: List<String>.unmodifiable(storyParagraphs),
      storyAnnotations: List<ReadingAnnotation>.unmodifiable(storyAnnotations),
      words: List<WordEntry>.unmodifiable(words),
      discoveries: discoveries,
      wonderQuestion: level <= 2
          ? '和清为什么明知道茶叶会受损，还是割断了捆绳？'
          : level <= 6
              ? '水渠和小桥怎样把姐弟的生计冲突变成必须立刻处理的选择？'
              : '丽江的水、桥、市场与木构民居为什么不能被拆成互不相关的“景点知识”？',
      expressQuestion: level <= 2
          ? '请用“先……然后……最后……”复述桥空出来的过程。'
          : level <= 6
              ? '请说明和清的选择损失了什么，又改变了什么。'
              : '请从“空间机制—关系压力—选择—代价—后果”解释这段故事为什么必须发生在这样的丽江古城。',
    );
  }, growable: false);
}

final lijiangOldTownGoldLevels = List<JourneyLevelContent>.unmodifiable(_buildLijiangLevels());

JourneyLevelContent lijiangOldTownGoldLevelContent(int requestedLevel) =>
    lijiangOldTownGoldLevels[requestedLevel.clamp(1, 10).toInt() - 1];

final lijiangOldTownWords = <WordEntry>[
  WordEntry(word: '四方街', pinyin: 'Sìfāng Jiē', partOfSpeech: '专名', simpleChinese: '丽江大研古城的传统商业中心。', translation: 'Phố Tứ Phương, trung tâm thương mại truyền thống của Đại Nghiên.', englishDefinition: 'Sifang Street, Dayan’s traditional commercial center', symbol: '🧭'),
  WordEntry(word: '商贩', pinyin: 'shāngfàn', partOfSpeech: '名词', simpleChinese: '做小规模买卖的人。', translation: 'Người buôn bán nhỏ.', englishDefinition: 'small trader', symbol: '🧺'),
  WordEntry(word: '茶叶', pinyin: 'cháyè', partOfSpeech: '名词', simpleChinese: '加工后用来冲泡的茶。', translation: 'Lá trà đã chế biến.', englishDefinition: 'tea leaves', symbol: '🍵'),
  WordEntry(word: '水渠', pinyin: 'shuǐqú', partOfSpeech: '名词', simpleChinese: '让水流过街巷或田地的渠道。', translation: 'Kênh dẫn nước.', englishDefinition: 'water channel', symbol: '💧'),
  WordEntry(word: '小桥', pinyin: 'xiǎoqiáo', partOfSpeech: '名词', simpleChinese: '跨过小河或水渠的桥。', translation: 'Cầu nhỏ.', englishDefinition: 'small bridge', symbol: '🌉'),
  WordEntry(word: '起火', pinyin: 'qǐhuǒ', partOfSpeech: '动词', simpleChinese: '开始燃烧。', translation: 'Bốc cháy.', englishDefinition: 'to catch fire', symbol: '🔥'),
  WordEntry(word: '捆绳', pinyin: 'kǔnshéng', partOfSpeech: '名词', simpleChinese: '用来把货物捆紧的绳子。', translation: 'Dây buộc hàng.', englishDefinition: 'cargo lashing rope', symbol: '🪢'),
  WordEntry(word: '扁担', pinyin: 'biǎndan', partOfSpeech: '名词', simpleChinese: '放在肩上挑东西的长杆。', translation: 'Đòn gánh.', englishDefinition: 'shoulder carrying pole', symbol: '🪵'),
  WordEntry(word: '债', pinyin: 'zhài', partOfSpeech: '名词', simpleChinese: '需要以后偿还的钱或责任。', translation: 'Khoản nợ.', englishDefinition: 'debt', symbol: '🧾'),
  WordEntry(word: '火星', pinyin: 'huǒxīng', partOfSpeech: '名词', simpleChinese: '燃烧时飞出的细小火点。', translation: 'Tàn lửa.', englishDefinition: 'spark', symbol: '✨'),
  WordEntry(word: '驮货', pinyin: 'tuóhuò', partOfSpeech: '名词', simpleChinese: '由牲口驮运的货物。', translation: 'Hàng chở trên súc vật.', englishDefinition: 'pack-animal cargo', symbol: '🐴'),
  WordEntry(word: '木屋', pinyin: 'mùwū', partOfSpeech: '名词', simpleChinese: '主要使用木材结构的房屋。', translation: 'Nhà gỗ.', englishDefinition: 'timber house', symbol: '🏠'),
  WordEntry(word: '水桶', pinyin: 'shuǐtǒng', partOfSpeech: '名词', simpleChinese: '装水和提水的桶。', translation: 'Xô nước.', englishDefinition: 'water bucket', symbol: '🪣'),
  WordEntry(word: '马帮', pinyin: 'mǎbāng', partOfSpeech: '名词', simpleChinese: '历史上用马、骡等牲口结队运货的商旅队伍。', translation: 'Đoàn ngựa, la vận chuyển hàng hóa.', englishDefinition: 'pack-animal caravan', symbol: '🐎'),
  WordEntry(word: '街巷', pinyin: 'jiēxiàng', partOfSpeech: '名词', simpleChinese: '街道和小巷。', translation: 'Phố và ngõ.', englishDefinition: 'streets and lanes', symbol: '🏘️'),
  WordEntry(word: '地势', pinyin: 'dìshì', partOfSpeech: '名词', simpleChinese: '地面的高低和形状。', translation: 'Địa thế.', englishDefinition: 'terrain', symbol: '⛰️'),
  WordEntry(word: '供水', pinyin: 'gōngshuǐ', partOfSpeech: '动词/名词', simpleChinese: '提供生活或生产需要的水。', translation: 'Cấp nước.', englishDefinition: 'water supply', symbol: '🚰'),
  WordEntry(word: '防火', pinyin: 'fánghuǒ', partOfSpeech: '动词', simpleChinese: '预防或控制火灾风险。', translation: 'Phòng cháy.', englishDefinition: 'fire prevention', symbol: '🧯'),
  WordEntry(word: '三眼井', pinyin: 'sānyǎnjǐng', partOfSpeech: '名词', simpleChinese: '丽江古城依地势连续设置三个井池的传统用水形式。', translation: 'Giếng ba bể truyền thống ở Lệ Giang.', englishDefinition: 'Lijiang three-pool well system', symbol: '💦'),
  WordEntry(word: '茶马古道', pinyin: 'Chámǎ Gǔdào', partOfSpeech: '专名', simpleChinese: '连接滇川藏等地区、长期进行茶马等货物交换的历史交通网络。', translation: 'Trà Mã Cổ Đạo.', englishDefinition: 'Ancient Tea Horse Road trade network', symbol: '🫖'),
  WordEntry(word: '商贸', pinyin: 'shāngmào', partOfSpeech: '名词', simpleChinese: '商品买卖和贸易活动。', translation: 'Thương mại.', englishDefinition: 'commerce and trade', symbol: '⚖️'),
  WordEntry(word: '多民族', pinyin: 'duō mínzú', partOfSpeech: '形容词', simpleChinese: '由多个民族共同参与或形成。', translation: 'Đa dân tộc.', englishDefinition: 'multi-ethnic', symbol: '🤝'),
];

DiscoveryEntry _discovery(String zh, String simple, String vi, String en) => DiscoveryEntry(
      text: zh,
      pinyin: _pinyin(zh),
      simpleChinese: simple,
      vietnamese: vi,
      english: en,
    );

List<DiscoveryEntry> lijiangDiscoveriesForLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final rows = switch (level) {
    1 => <List<String>>[
        ['世界遗产“丽江古城”由大研古城、白沙民居建筑群和束河民居建筑群组成，大研是其中的主要城镇空间。', '世界遗产不是只有大研一个点，还包括白沙和束河。', 'Di sản Phố cổ Lệ Giang gồm Đại Nghiên, cụm dân cư Bạch Sa và Thúc Hà; Đại Nghiên là không gian đô thị chính.', 'The World Heritage property includes Dayan Old Town, Baisha housing cluster, and Shuhe housing cluster; Dayan is its main urban component.'],
        ['玉龙雪山一带的河流与泉水补给丽江坝子，黑龙潭再把水送入沟渠网络，古城因此拥有持续运行的古老供水系统。', '黑龙潭的水进入沟渠，形成古城供水网络。', 'Sông suối từ vùng Núi Tuyết Ngọc Long cấp nước cho đồng bằng Lệ Giang; Hắc Long Đàm đưa nước vào mạng kênh cổ.', 'Rivers and springs from the Yulong Snow Mountain area feed the Lijiang plain, and Black Dragon Pool supplies a canal network that forms the town’s ancient water system.'],
      ],
    2 => <List<String>>[
        ['大研古城在明代发展为商业中心；四方街长期处在古城商贸和人流汇聚的位置。', '大研和四方街长期有重要商业功能。', 'Đại Nghiên phát triển thành trung tâm thương mại thời Minh; phố Tứ Phương lâu nay là nơi tập trung buôn bán và dòng người.', 'Dayan developed as a commercial centre in the Ming dynasty, with Sifang Street serving as a long-standing focus of trade and movement.'],
        ['丽江古城没有把所有道路拉成棋盘格，而是顺着不平的地势、水源和已有生活空间形成街巷。', '街巷会跟着地势和水来走。', 'Phố cổ không ép đường thành ô bàn cờ; ngõ phố hình thành theo địa hình, nguồn nước và không gian sống.', 'Lijiang did not force its streets into a rigid grid; lanes developed with uneven terrain, water sources, and lived space.'],
      ],
    3 => <List<String>>[
        ['主街和小巷常沿着水渠展开，一些建筑跨水而建，许多桥梁把两岸的住宅和买卖空间连接起来。', '街、房子和桥都与水渠直接相连。', 'Đường chính và ngõ nhỏ thường chạy dọc kênh; một số nhà bắc qua nước và nhiều cầu nối hai bờ.', 'Main streets and lanes often follow canals; some buildings cross the water, and many bridges connect homes and commercial spaces on both banks.'],
        ['水系不是后来加上的装饰。UNESCO把水、道路、住宅和地形共同形成的布局视为丽江古城价值的重要部分。', '水参与了城市布局，不只是景观。', 'Mạng nước không phải vật trang trí thêm vào; UNESCO xem quan hệ giữa nước, đường, nhà và địa hình là một phần giá trị của đô thị.', 'The water system is not later decoration: UNESCO treats the relationship among water, streets, homes, and terrain as a core part of Lijiang’s urban value.'],
      ],
    4 => <List<String>>[
        ['传统“三眼井”利用高差形成连续井池：上池取水饮用，中池洗菜，下池浣洗衣物，体现了对同一水源的分层使用。', '三眼井把饮水、洗菜、洗衣分在不同井池。', '“Giếng ba bể” dùng chênh cao: bể trên lấy nước uống, bể giữa rửa rau, bể dưới giặt quần áo.', 'Traditional three-pool wells use elevation: the upper pool for drinking water, the middle for washing vegetables, and the lower for washing clothes.'],
        ['四方街还形成过利用西河与街面高差放水冲洗石板街面的做法，说明水系也参与公共空间的日常维护。', '四方街会利用高差放水冲洗街面。', 'Tứ Phương từng dùng chênh cao của Tây Hà để xả nước rửa mặt đường đá, cho thấy nước tham gia bảo dưỡng không gian công cộng.', 'Sifang Street historically used the height difference from the West River to release water across the stone pavement, showing water’s role in maintaining public space.'],
      ],
    5 => <List<String>>[
        ['从12世纪起，丽江成为四川、云南和西藏之间重要的货物集散地，南方丝绸之路与茶马古道网络在这里发生联系。', '丽江很早就是滇川藏之间的重要贸易节点。', 'Từ thế kỷ XII, Lệ Giang là điểm phân phối hàng hóa quan trọng giữa Tứ Xuyên, Vân Nam và Tây Tạng, nơi các mạng thương lộ gặp nhau.', 'From the 12th century, Lijiang became an important distribution centre for goods between Sichuan, Yunnan, and Tibet, linking southern Silk Road and Tea Horse Road networks.'],
        ['国家文物资料记载，马匹、羊毛、皮革、药材以及茶叶、铁器、盐、糖、粮食等货物曾在丽江集散。', '马帮带来的不只是茶，也有很多生活和生产货物。', 'Tư liệu di sản ghi nhận ngựa, len, da, dược liệu, trà, đồ sắt, muối, đường và lương thực từng được tập kết, trao đổi tại Lệ Giang.', 'Heritage sources record trade in horses, wool, hides, medicines, tea, iron goods, salt, sugar, grain, and other commodities through Lijiang.'],
        ['四方街处于商业中心而不是单纯的观景广场；商贸活动把来自不同方向的人长期带入同一城市空间。', '四方街的核心功能之一是交易与集散。', 'Tứ Phương là trung tâm thương mại chứ không chỉ là quảng trường ngắm cảnh; giao thương đưa người từ nhiều hướng vào cùng không gian.', 'Sifang Street functioned as a commercial centre rather than merely a scenic square, bringing people from different directions into the same urban space.'],
      ],
    6 => <List<String>>[
        ['丽江古城长期处在纳西、汉、藏、白等族群交往的区域，建筑、城市规划、艺术和生活方式都留下多民族交流的结果。', '多民族交流影响了建筑和生活方式。', 'Lệ Giang nằm lâu dài trong vùng giao lưu của người Nạp Tây, Hán, Tạng, Bạch; kiến trúc, quy hoạch, nghệ thuật và đời sống phản ánh sự trao đổi đó.', 'Lijiang long stood within exchange among Naxi, Han, Tibetan, Bai and other communities, leaving multi-ethnic influence in architecture, planning, art, and social life.'],
        ['典型民居多为瓦顶木构、院落式建筑，并吸收不同地区和民族的建筑技术与装饰语言。', '木构、瓦顶、院落和多种建筑传统一起形成民居特色。', 'Nhà ở điển hình có khung gỗ, mái ngói và sân trong, đồng thời tiếp thu kỹ thuật và trang trí của nhiều truyền thống.', 'Typical residences use timber frames, tiled roofs, and courtyards while incorporating building techniques and decoration from several cultural traditions.'],
        ['这种“融合”不是把差异抹掉，而是在纳西文化主体中长期吸收、重组并形成地方性的城市生活。', '丽江的文化价值来自长期交流后形成的地方特点。', 'Sự “hòa trộn” không xóa khác biệt mà cho thấy quá trình tiếp thu và tái tổ chức lâu dài trong bối cảnh Nạp Tây.', 'This blending does not erase difference; it reflects long-term absorption and recombination within a distinctly local Naxi cultural setting.'],
      ],
    7 => <List<String>>[
        ['国家文物资料指出，古城没有城墙，四方街向多方向延伸，马帮可以从不同方向进入并汇聚，开放格局与商贸运行彼此强化。', '没有城墙和多方向街巷让商旅更容易汇聚。', 'Tư liệu di sản cho biết cổ thành không có tường thành; đường từ Tứ Phương tỏa nhiều hướng, tạo điều kiện cho đoàn thương mã hội tụ.', 'National heritage material notes that the old town lacked a city wall and that routes radiating from Sifang Street allowed caravans to converge from several directions.'],
        ['UNESCO明确指出，完整水系同时满足防火、日常生活和生产需要，因此同一条水流可以承担多种城市功能。', '水既用于生活和生产，也有防火功能。', 'UNESCO nêu rõ hệ thống nước phục vụ phòng cháy, đời sống hằng ngày và sản xuất, nên cùng một dòng nước có nhiều chức năng đô thị.', 'UNESCO explicitly states that the water system served fire prevention, daily life, and production, giving the same network multiple urban functions.'],
        ['当市场、住宅、桥梁和水渠彼此靠近时，商贸效率与生活安全并不是两套分开的系统，而会在同一条街上互相影响。', '丽江的商业空间和生活水系会直接相遇。', 'Khi chợ, nhà ở, cầu và kênh ở sát nhau, hiệu quả buôn bán và an toàn đời sống tác động lẫn nhau ngay trên cùng một con phố.', 'When market, homes, bridges, and canals sit close together, commercial efficiency and everyday safety influence one another in the same street space.'],
      ],
    8 => <List<String>>[
        ['丽江古城的水系之所以重要，不只是因为“有水”，而是因为水源、坡度、支渠、桥梁与街巷共同构成可运行的城市基础设施。', '关键不是有水，而是水怎样与地势和街巷一起工作。', 'Điểm quan trọng không chỉ là “có nước”, mà là nguồn nước, độ dốc, nhánh kênh, cầu và đường phố cùng tạo thành hạ tầng vận hành.', 'Lijiang’s water matters not merely because water is present, but because sources, gradients, branches, bridges, and lanes form functioning urban infrastructure.'],
        ['四方街放水冲街利用水位与街面高差，让水直接进入公共空间维护；这种做法把自然地势变成日常城市技术。', '利用高差冲街，是把地形变成城市技术。', 'Việc xả nước rửa phố Tứ Phương dùng chênh cao để biến địa hình tự nhiên thành kỹ thuật bảo dưỡng đô thị hằng ngày.', 'Releasing water to wash Sifang Street uses elevation differences to turn natural topography into everyday urban technology.'],
        ['Story里的火情是虚构的，但“水系可用于防火”是已验证的世界条件；Phoenix 可以虚构人的选择，不能把虚构事件冒充丽江史实。', '故事人物和火情是虚构的，水系防火功能是真实资料支持的。', 'Đám cháy trong truyện là hư cấu, còn chức năng phòng cháy của hệ thống nước là điều kiện lịch sử đã được xác minh.', 'The fire in the Story is fictional, while the water system’s fire-prevention function is a verified world condition; fiction creates the human event, not false history.'],
      ],
    9 => <List<String>>[
        ['UNESCO认为丽江古城至今保留明清时期的整体布局、城市形态、街景和建筑风格；真实性因此包含空间关系，而不只是单栋老房子。', '保护真实性也要保护整体街巷和空间关系。', 'UNESCO cho rằng bố cục, hình thái đô thị, cảnh quan phố và phong cách kiến trúc Minh-Thanh vẫn được giữ; tính xác thực vì thế gồm cả quan hệ không gian.', 'UNESCO considers the Ming-Qing layout, urban morphology, streetscape, and architectural style substantially retained, so authenticity includes spatial relationships, not only individual old buildings.'],
        ['1996年丽江大地震等灾害并没有让遗产判断只剩“原材料是否完全没换过”，保护还要面对修复、生活延续与整体格局。', '经历灾害后，保护需要同时看修复、生活和整体格局。', 'Sau động đất lớn Lệ Giang năm 1996 và các thảm họa khác, bảo tồn không thể chỉ hỏi vật liệu có nguyên vẹn tuyệt đối hay không mà còn phải nhìn phục hồi, đời sống và bố cục tổng thể.', 'After disasters including the 1996 Lijiang earthquake, conservation cannot be reduced to whether every material remained untouched; repair, living continuity, and overall form also matter.'],
        ['东巴文化、纳西文字以及传统民居营造技艺等非物质遗产也被UNESCO列入真实性讨论，说明“古城”同时包含会继续被人使用和传承的知识。', '古城的真实性也包括仍在传承的文化知识。', 'UNESCO cũng xem văn hóa Đông Ba, chữ Nạp Tây và kỹ thuật xây nhà truyền thống là phần của tính xác thực, cho thấy di sản còn chứa tri thức sống.', 'UNESCO also discusses Dongba culture, Naxi writing, and traditional residence-building skills within authenticity, showing that the old town includes knowledge still used and transmitted.'],
      ],
    _ => <List<String>>[
        ['世界遗产保护不仅修房子，还需要持续维护水系、整体城镇格局、居民生活与非物质文化之间的关系。', '真正的整体保护要同时看建筑、水系、格局和生活文化。', 'Bảo vệ di sản không chỉ sửa nhà mà còn duy trì quan hệ giữa hệ thống nước, cấu trúc đô thị, đời sống cư dân và văn hóa phi vật thể.', 'World Heritage conservation involves more than repairing buildings; it must sustain relationships among the water system, urban form, resident life, and intangible culture.'],
        ['UNESCO的管理要求特别提到旅游与商业发展的控制，说明丽江面临的现代问题不是“要不要有人来”，而是如何让发展不损害遗产的突出普遍价值。', '现代保护要管理旅游和商业压力，而不是把古城冻结。', 'Yêu cầu quản lý của UNESCO nhấn mạnh kiểm soát du lịch và thương mại: vấn đề không phải có khách hay không, mà là phát triển không làm hại giá trị di sản.', 'UNESCO management requirements specifically address tourism and commercial development, framing the modern challenge as keeping development from damaging Outstanding Universal Value rather than freezing the town.'],
        ['判断丽江古城是否被真正理解，可以问一个综合问题：如果水渠不再运行、街桥关系被切断、生活传统只剩表演，即使单栋建筑还在，城市遗产是否仍完整？', '高阶理解要同时判断水、空间、生活和保护之间的关系。', 'Câu hỏi tổng hợp là: nếu kênh nước ngừng hoạt động, quan hệ phố-cầu bị cắt và truyền thống sống chỉ còn biểu diễn, liệu di sản đô thị còn toàn vẹn dù từng tòa nhà vẫn đứng?', 'An integrated judgment asks: if canals stopped functioning, street-bridge relations were severed, and living traditions became only performance, would the urban heritage remain intact even if individual buildings survived?'],
      ],
  };

  return List<DiscoveryEntry>.unmodifiable([
    for (final row in rows) _discovery(row[0], row[1], row[2], row[3]),
  ]);
}

final _lijiangEvents = <RemediatedSemanticEvent>[
  for (var event = 0; event < 6; event++)
    RemediatedSemanticEvent(
      id: 'LJ-E${event + 1}',
      coreChinese: _segments.firstWhere((segment) => segment.event == event && segment.from == 1).zh,
      corePinyin: _pinyin(_segments.firstWhere((segment) => segment.event == event && segment.from == 1).zh),
      coreVietnamese: _segments.firstWhere((segment) => segment.event == event && segment.from == 1).vi,
      coreEnglish: _segments.firstWhere((segment) => segment.event == event && segment.from == 1).en,
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11,
    ),
];

final lijiangOldTownGoldJourney = RemediatedJourney(
  id: lijiangOldTownJourneyId,
  title: lijiangOldTownCanonicalTitle,
  protagonist: '和清，虚构清末普通商贩',
  goal: '保住与姐姐共同持有的一驮茶，在次日买家离城前完成交易并偿还共同债务',
  conflict: '四方街散市后的虚构火情中，共同生计货物堵住了沿街水渠旁最直接的跨桥取水通道；处置货物又会越过姐姐的共同所有权',
  eventIds: const ['LJ-E1', 'LJ-E2', 'LJ-E3', 'LJ-E4', 'LJ-E5', 'LJ-E6'],
  events: _lijiangEvents,
  levels: lijiangOldTownGoldLevels,
  words: lijiangOldTownWords,
  wordTraces: [
    for (final word in lijiangOldTownWords)
      RemediatedWordTrace(
        word: word.word,
        eventId: 'LJ-E4',
        usage: 'active Story/Discovery vocabulary only',
        sourceText: word.simpleChinese,
      ),
  ],
  discoveries: [for (var level = 1; level <= 10; level++) ...lijiangDiscoveriesForLevel(level)],
  discoveryTraces: [
    for (var i = 0; i < 26; i++)
      RemediatedDiscoveryTrace(
        discoveryIndex: i,
        storyEventIds: i < 8 ? const ['LJ-E1', 'LJ-E2'] : const <String>[],
        sourceIds: const ['unesco-lijiang-old-town', 'yunnan-lijiang-old-town', 'neac-naxi-customs'],
      ),
  ],
  challenges: const [
    RemediatedChallengeTrace(type: 'paragraphRebuild', storyEventIds: ['LJ-E1', 'LJ-E2', 'LJ-E3', 'LJ-E4', 'LJ-E5', 'LJ-E6'], anchor: '散市与共同债务→火情与堵桥→姐姐阻拦→割绳→传水→共同承担湿茶'),
    RemediatedChallengeTrace(type: 'grammarRepair', storyEventIds: ['LJ-E3', 'LJ-E4', 'LJ-E5'], anchor: '修复让步、把字句、因果与共同所有权表达，不新增历史事实'),
    RemediatedChallengeTrace(type: 'missingSentence', storyEventIds: ['LJ-E2', 'LJ-E3', 'LJ-E4', 'LJ-E5'], anchor: '桥面必须连接“共同货物堵住水路”与“割绳产生应急通行”的因果'),
  ],
  memory: const [
    RemediatedMemoryReview(category: 'choice', prompt: '和清真正做了什么选择？', answer: '他在姐姐反对时割断共同货物的捆绳，让堵住小桥的茶包受损并腾出取水通道。', storyEventIds: ['LJ-E4']),
    RemediatedMemoryReview(category: 'cost', prompt: '这个选择具体失去了什么？', answer: '几包茶叶浸水，次日交易失去，共同债务没有消失；他也越过了姐姐对共同本钱的决定权。', storyEventIds: ['LJ-E4', 'LJ-E5']),
    RemediatedMemoryReview(category: 'place', prompt: '为什么丽江古城的水不是背景？', answer: '沿街水渠和跨渠桥让货流、木屋与防火用水处在同一空间；清空桥面直接改变了虚构火情的行动条件。', storyEventIds: ['LJ-E2', 'LJ-E5']),
    RemediatedMemoryReview(category: 'memory', prompt: '这段旅程最该记住的画面是什么？', answer: '捆绳弹开，茶包滚进水里，小桥露出一线空处，第一只水桶越过桥。', storyEventIds: ['LJ-E4', 'LJ-E5']),
    RemediatedMemoryReview(category: 'relationship', prompt: '故事最后姐弟关系怎样改变？', answer: '和素没有用一句话原谅或赞同弟弟，而是扛起扁担另一头，与他共同承担已经发生的损失。', storyEventIds: ['LJ-E6']),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '你完成了《桥空出来以后》：在真实的丽江水系、桥梁、木构街区与茶马商贸条件中，看见一对虚构姐弟怎样把共同本钱变成共同承担的代价。',
    achievement: '你已经能区分“世界条件是真实的”与“人物私人事件是历史文化小说”。',
    memoryAnchor: '茶包滚进水里，小桥空出来，第一只水桶越桥；天亮后，扁担的重量落在姐弟两个人中间。',
    challengeReward: '完成三种 Challenge 后，你能从故事顺序、中文结构和地方因果三个角度解释这个选择。',
    journeyCompletion: '丽江古城已点亮：记住水不是风景标签，而是组织街、桥、市场、生活与安全的城市机制。',
  ),
  sources: const [
    RemediatedSourceBinding(id: 'unesco-lijiang-old-town', publisher: 'UNESCO World Heritage Centre', scope: 'world model: topography, water, fire prevention, trade, architecture, multi-cultural exchange'),
    RemediatedSourceBinding(id: 'yunnan-lijiang-old-town', publisher: '云南省文化和旅游厅', scope: 'Lijiang water-city relation, living heritage and local historical context'),
    RemediatedSourceBinding(id: 'neac-naxi-customs', publisher: '国家民族事务委员会', scope: 'Naxi residence/water/bridge context and Qing-period architectural exchange'),
  ],
);
