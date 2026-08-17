import 'package:pinyin/pinyin.dart';

import '../agents/phoenix_language_level_agent.dart';
import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const hongheHaniRiceTerracesJourneyId = 'honghe-hani-rice-terraces';
const hongheHaniRiceTerracesCanonicalTitle = '两道水重新分开以后';
const hongheHaniRiceTerracesHeadline = '她把水分回原来的宽度，也失去了今天借来的牛';
const hongheHaniRiceTerracesDescription =
    '当代元阳春灌前夕，虚构赶沟人罗秋发现朋友私自削宽木刻分水槽。她恢复共同议定的水份额，也承担朋友收回水牛、自己的最后一块田当天无法犁完的私人代价。';
const hongheHaniRiceTerracesDiscoveryTeaser =
    '森林、村寨、沟渠和梯田为什么必须作为一套水系统一起理解？';

class HongheArchitecture {
  const HongheArchitecture({
    required this.id,
    required this.humanNeed,
    required this.protagonist,
    required this.relationship,
    required this.engine,
    required this.choice,
    required this.cost,
    required this.climax,
    required this.transformation,
    required this.memory,
    required this.selected,
    required this.rejectedReason,
  });

  final String id;
  final String humanNeed;
  final String protagonist;
  final String relationship;
  final String engine;
  final String choice;
  final String cost;
  final String climax;
  final String transformation;
  final String memory;
  final bool selected;
  final String rejectedReason;
}

const hongheHaniRiceTerracesArchitectures = <HongheArchitecture>[
  HongheArchitecture(
    id: 'A-divider-and-buffalo',
    humanNeed: '在第一次承担公共水路责任时，不失去一个长期互相帮工的朋友和自己当天急需的劳力。',
    protagonist: '罗秋，当代元阳虚构普通农户、第一次承担赶沟人职责。',
    relationship: '与邻居马岚从小在相邻田埂互相帮工；罗秋刚替马岚补过田埂，马岚原答应当天借水牛还这份人情。',
    engine: '共同议定的木刻分水槽被朋友私自削宽，使森林来水在同一分水口向一户多流、向下方田块少流；罗秋既负责恢复公共分水，又私人依赖朋友的水牛。',
    choice: '当场抽出分水器，按大家议定的尺寸重新凿回凹槽并装回去，不把公共水份额延期到私人帮工结束以后。',
    cost: '马岚牵走原本要借给罗秋的水牛，罗秋自己的最后一块梯田当天不能按计划犁完，友谊也没有当场和解。',
    climax: '重新凿过的硬木压回分水口，两道水恢复议定宽度时，马岚同时牵起牛绳。',
    transformation: '罗秋从以为公共职责只是多巡几趟沟，转为接受公共分配有时会真实穿过私人互惠关系，并由自己承担损失。',
    memory: '木槽重新入水，两道水分开；一边水声恢复，一边牛铃转身远去。',
    selected: true,
    rejectedReason: '',
  ),
  HongheArchitecture(
    id: 'B-breach-own-terrace-for-bypass',
    humanNeed: '保住自己刚修好的田埂，同时让堵塞后的水尽快抵达坡下邻田。',
    protagonist: '虚构普通梯田农户。',
    relationship: '与下方田主是多年互相救急的邻居。',
    engine: '公共沟渠被滑塌堵塞，主人公可挖开自己田埂形成临时旁路。',
    choice: '主动破开自己田埂，让水越过自家田进入下方。',
    cost: '自己的田受损并需要重修。',
    climax: '田埂破开后水改道进入下方田块。',
    transformation: '从保全自家田转为承担共享水路的损失。',
    memory: '水从新开的缺口冲过自家田埂。',
    selected: false,
    rejectedReason: '地点机制真实可行，但“毁损自己的生产资产以恢复共享安全/资源流”与丽江已批准 Gold 的即时资产牺牲引擎过近，跨 Gold 独立性不足。',
  ),
  HongheArchitecture(
    id: 'C-remeasure-without-wrongdoing',
    humanNeed: '在田块变化后保住两户长期合作，不让重新分水变成谁占了便宜的争执。',
    protagonist: '虚构年长农户。',
    relationship: '两户共同使用同一支沟。',
    engine: '田块面积和劳力变化后，原木刻分水比例需要重新协商。',
    choice: '公开重算并重新刻槽，而不是保留旧比例。',
    cost: '自己一户得到的水份额减少。',
    climax: '两户一起看着新木槽第一次分水。',
    transformation: '从把旧比例当传统本身，转向把共同协商视为传统继续运作的条件。',
    memory: '旧木槽与新木槽并排放在沟边。',
    selected: false,
    rejectedReason: '文化机制成立，但主要靠协商与重新证明公平，私人关系代价和不可逆选择较弱，容易退化成“发现证据→重分类/重算”的既有 Phoenix 结构。',
  ),
];

const hongheSourceLedger = <Map<String, String>>[
  {
    'id': 'HH-S1',
    'title': 'Cultural Landscape of Honghe Hani Rice Terraces',
    'authority': 'UNESCO World Heritage Centre',
    'type': 'UNESCO / World Heritage',
    'period': 'historic development over 1,300 years; present living landscape',
    'claimsSupported': 'Ailao slope terraces; forest-water-village-terrace system; channel network; mushroom-house villages; integrated farming; communal channel maintenance',
    'claimsNotSupported': 'Luo Qiu, Ma Lan, altered groove, buffalo promise, private argument',
    'confidence': 'HIGH',
    'storyUse': 'verified four-element water landscape and shared-channel world',
    'discoveryUse': 'Lv1-Lv10 physical, cultural and conservation model',
  },
  {
    'id': 'HH-S2',
    'title': '红河哈尼梯田保护管理相关实施规则',
    'authority': '红河哈尼族彝族自治州人民政府',
    'type': 'prefecture government regulation / heritage governance',
    'period': 'current protection governance',
    'claimsSupported': '赶沟人由社区推选或选定并管理公共沟渠; 木刻分水以用水户协商份额和不同宽度硬木凹槽分水',
    'claimsNotSupported': 'any fictional character, private labor exchange, private retaliation',
    'confidence': 'HIGH',
    'storyUse': 'public role and wooden divider mechanism',
    'discoveryUse': 'Lv5 and Lv10 living governance',
  },
  {
    'id': 'HH-S3',
    'title': '元阳梯田木刻分水与灌溉管理资料',
    'authority': '元阳县人民政府',
    'type': 'county government historical / water-management synthesis',
    'period': 'traditional practice through present protection',
    'claimsSupported': '用水户协商分水; 硬木刻不同宽度凹槽; 沟长/赶沟人巡查维修; 水田持续供水与田埂稳定关系',
    'claimsNotSupported': 'the Story dispute or any exact household allocation',
    'confidence': 'HIGH',
    'storyUse': 'physical divider, agreed dimensions and continuous-water pressure',
    'discoveryUse': 'Lv5-Lv6',
  },
  {
    'id': 'HH-S4',
    'title': '红河哈尼梯田春灌与传统分水实践',
    'authority': '云南省水利厅',
    'type': 'provincial government current water-management reporting',
    'period': '2026 spring irrigation',
    'claimsSupported': '当代春灌仍按海拔与农时推进; 森林来水经村寨沟渠进入梯田; 赶沟人与木刻分水仍在使用',
    'claimsNotSupported': 'Luo Qiu or Ma Lan, their schedule, their buffalo arrangement',
    'confidence': 'HIGH',
    'storyUse': 'contemporary spring-irrigation time setting',
    'discoveryUse': 'Lv6 and Lv10 living continuity',
  },
];

const hongheClaimLedger = <Map<String, String>>[
  {
    'id': 'HH-C1',
    'claim': '红河哈尼梯田的森林、村寨、水系与梯田构成相互依赖的整体，森林来水经沟渠向坡下田块分配。',
    'source': 'HH-S1',
    'factType': 'VERIFIED PHYSICAL / CULTURAL LANDSCAPE CONDITION',
    'certainty': 'HIGH',
    'proves': '水的去向会真实改变不同田块的生产条件，地点不是背景。',
    'doesNotProve': '某一虚构分水纠纷真实发生。',
    'storyUse': 'central Place mechanism',
    'discoveryUse': 'Lv1-Lv4',
    'status': 'ALLOWED',
  },
  {
    'id': 'HH-C2',
    'claim': '赶沟人承担公共沟渠巡查、维修和分水管理职责，并由社区推选或选定。',
    'source': 'HH-S2 + HH-S3',
    'factType': 'VERIFIED COMMUNITY WATER-GOVERNANCE PRACTICE',
    'certainty': 'HIGH',
    'proves': '让虚构普通农户承担赶沟人职责有真实制度基础。',
    'doesNotProve': '罗秋真实存在或她的私人动机。',
    'storyUse': 'protagonist public role',
    'discoveryUse': 'Lv5',
    'status': 'ALLOWED',
  },
  {
    'id': 'HH-C3',
    'claim': '木刻分水把用水户协商后的水份额通过硬木上不同宽度的凹槽落实到分水口。',
    'source': 'HH-S2 + HH-S3',
    'factType': 'VERIFIED MATERIAL / GOVERNANCE PRACTICE',
    'certainty': 'HIGH',
    'proves': '木槽宽窄能够同时是物理水流机制和共同协议的可见载体。',
    'doesNotProve': 'Story 中凹槽被私自削宽这一私人事件。',
    'storyUse': 'Choice / Climax / Memory Moment',
    'discoveryUse': 'Lv5',
    'status': 'ALLOWED',
  },
  {
    'id': 'HH-C4',
    'claim': '梯田需要持续供水，水经上方进水口和下方出水口逐级流动；长期干裂后重新蓄水会增加田埂风险。',
    'source': 'HH-S3',
    'factType': 'VERIFIED AGRICULTURAL / PHYSICAL CONDITION',
    'certainty': 'HIGH',
    'proves': '延迟下方田块获得水并非纯抽象公平问题。',
    'doesNotProve': '任何虚构田块在当天一定受损。',
    'storyUse': 'human pressure only; no fabricated damage consequence',
    'discoveryUse': 'Lv6',
    'status': 'ALLOWED',
  },
  {
    'id': 'HH-C5',
    'claim': '当代元阳仍进行春灌、赶沟和木刻分水，传统水管理与现代水利共同工作。',
    'source': 'HH-S4',
    'factType': 'VERIFIED CONTEMPORARY PRACTICE',
    'certainty': 'HIGH',
    'proves': '采用当代虚构普通农户而非古代人物仍具有强历史文化在场。',
    'doesNotProve': 'Story 的确切日期、人物或私人约定。',
    'storyUse': 'contemporary setting',
    'discoveryUse': 'Lv6/Lv10',
    'status': 'ALLOWED',
  },
];

const hongheFactFictionLedger = <Map<String, String>>[
  {'item': '森林—村寨—水系—梯田四部分相互依赖，沟渠分配高处水源', 'category': 'VERIFIED PHYSICAL / CULTURAL LANDSCAPE CONDITION', 'status': 'ALLOWED'},
  {'item': '赶沟人承担公共沟渠巡查和分水管理', 'category': 'VERIFIED COMMUNITY PRACTICE', 'status': 'ALLOWED'},
  {'item': '木刻分水通过协商份额与不同宽度硬木凹槽分水', 'category': 'VERIFIED MATERIAL / GOVERNANCE PRACTICE', 'status': 'ALLOWED'},
  {'item': '罗秋、马岚的姓名、年龄、友谊、帮工历史与私人水牛约定', 'category': 'FICTIONAL CHARACTER IDENTITY / BACKSTORY / RELATIONSHIP', 'status': 'ALLOWED'},
  {'item': '马岚昨夜私自削宽凹槽以及当天两人的争执', 'category': 'FICTIONAL PRIVATE EVENT', 'status': 'ALLOWED — not represented as documented history'},
  {'item': '罗秋恢复凹槽、马岚牵走水牛、罗秋当天未犁完自己的田', 'category': 'FICTIONAL CHARACTER ACTION / CONSEQUENCE', 'status': 'ALLOWED'},
  {'item': '任何真实赶沟人、干部、村民或历史人物的私人动机/对话', 'category': 'REAL PERSON HIGH-PROTECTION', 'status': 'NOT USED'},
  {'item': '虚构全村罚款、处罚条例、强制没收水牛或未获来源支持的统一配水数字', 'category': 'UNSUPPORTED FACTUAL CLAIM', 'status': 'BLOCKED / NOT USED'},
];

const honghePlaceCausalMechanism = <String, String>{
  'verifiedFact': '森林来水经村寨与公共沟渠进入梯田；木刻分水用共同协商后的不同宽度凹槽在分水口物理分配水量，赶沟人负责维护公共水路。',
  'period': '当代春灌（传统实践仍在活态运行）',
  'placeCondition': '坡地连续梯田 + 共享沟渠 + 物理木刻分水 + 社区水路职责 + 春灌农时',
  'affects': 'Goal / Relationship / Conflict / Choice / Cost / Climax / Consequence / Ending',
  'enables': '朋友多削的一道凹槽会立刻改变两支沟的水量；恢复共同议定宽度必须由主人公在私人帮工依赖仍存在时执行。',
  'limits': '主人公不能用抽象“公平”按钮解决问题，必须亲手改回分水器并接受朋友收回私人劳力。',
  'genericPlaceTest': 'PASS — 移除木刻分水、共享坡地沟渠和赶沟人职责后，故事只剩朋友之间借牛争执，核心 Choice/Climax/Consequence 必须重写。',
  'otherCityTest': 'PASS — 不能把原有木槽、协商水份额和逐级梯田水流原封不动搬到任意景点后仍称地点可替换。',
};

const honghePrimaryDepth = '公共职责与私人互惠不可同时保全时的关系代价';
const hongheSecondaryDepths = <String>[
  '共同水资源治理需要个人承担可见成本',
  '长期友谊在公共角色边界前并不会自动保持无摩擦',
  '活态遗产通过每天的生产与分配继续存在',
];

const hongheStoryIdentityCard = <String, String>{
  'Journey': hongheHaniRiceTerracesJourneyId,
  'Place': '云南省→红河哈尼族彝族自治州→元阳县→哈尼梯田',
  'Period': '当代春灌前夕',
  'TruthMode': '真实活态文化景观与水管理机制 + 普通虚构人物私人事件',
  'Protagonist': '罗秋，虚构普通农户，第一次承担赶沟人职责',
  'LifeContext': '自己的最后一块田也等着春灌整田，私人上依赖邻居当天借来的水牛',
  'RelationshipGeometry': '罗秋与马岚是长期相邻、互相帮工的朋友；公共分水职责与私人互惠依赖交叉',
  'HumanNeed': '既不失去朋友，也不让第一次公共职责变成对朋友的例外',
  'Goal': '恢复共同议定的分水，让下方田块重新获得应有水量，同时按计划完成自己的犁田',
  'WhyToday': '春灌正在进行，朋友约好的水牛只在当天可用',
  'WhatCannotWait': '被削宽的木槽正在持续改变两支沟的水量；自己的犁田约定也在当天',
  'HumanStakes': '朋友关系、互惠劳力和自己的当天农活都会被公共角色选择触碰',
  'VerifiedPlacePressure': '木刻分水的凹槽直接编码共同议定水份额，共享沟渠把上方选择传向下方梯田',
  'WhatIsFact': '森林—村寨—沟渠—梯田系统、赶沟人职责、木刻分水、春灌活态实践',
  'WhatIsFiction': '罗秋马岚、私改凹槽、借水牛、帮工历史、所有私人对话与后果',
  'PrimaryDepth': honghePrimaryDepth,
  'SecondaryDepths': '共同水资源治理；友谊边界；活态生产',
  'Conflict': '恢复公共议定水份额 vs 暂时照顾朋友并保住自己急需的私人帮工',
  'Choice': '罗秋按共同议定尺寸重新凿回凹槽并立即装回',
  'Cost': '马岚牵走水牛，罗秋自己的最后一块梯田当天没犁完，关系没有当场修复',
  'Climax': '木槽重新入水，两道水恢复议定宽度，同时牛铃转身远去',
  'Consequence': '下方支沟重新涨起，公共分水恢复；罗秋自己的农活延后',
  'Transformation': '从把公共职责想成无私人代价的维护工作，转为接受它会穿过真实关系并由自己承担损失',
  'MemoryMoment': '新凿回的木槽入水，两道水分开；水声恢复时牛铃远去',
  'EndingAction': '罗秋没有去解释或借回牛，傍晚赤脚踩实自己未犁田的田埂，听两支沟继续流',
  'WhyThisPlaceMatters': '分水木槽与坡地沟渠使“共同协议”成为可改变真实水流的物理机制，也使私人关系压力直接进入选择',
  'GenericPlaceTest': 'PASS — remove wooden division/shared descending channel and the story loses its causal engine',
  'NearestGoldRisks': 'Nanjing responsibility/refusal; Lijiang livelihood sacrifice; Chengdu shared-use protocol; Guangzhou public/private boundary',
  'ForbiddenStoryShapes': '不写学生任务；不写导师认可；不写拒绝捷径；不写毁掉自家资产救险；不写旧物促家庭和解；不写证据重分类',
};

const hongheDepthActionGate = <String, String>{
  'withPrimaryDepth': '罗秋必须在公共水份额与朋友私人互惠之间作出会损失自己劳力安排的选择。',
  'withoutPrimaryDepth': '如果没有“公共职责与私人互惠冲突”，罗秋只需例行修好分水器，故事退化成无代价维护。',
  'result': 'PASS — removing Primary Depth changes the decisive action from costly human choice to routine maintenance.',
};

const hongheRelationshipCausalityGate = <String, String>{
  'relationship': '罗秋私人依赖马岚承诺借出的水牛，且两人已有互相帮工债。',
  'deletionTest': '删掉马岚与水牛约定，恢复分水器仍可发生，但核心 Cost、犹豫、关系后果和结尾全部消失。',
  'result': 'PASS — relationship is structurally necessary to Human Story.',
};

class _HongheSegment {
  const _HongheSegment(this.event, this.from, this.zh, this.vi, this.en);
  final int event;
  final int from;
  final String zh;
  final String vi;
  final String en;
}

const _segments = <_HongheSegment>[
  _HongheSegment(0, 1, '春灌前一天清晨，元阳山雾未散。罗秋第一次以赶沟人身份巡沟；她和邻居马岚约好中午后用马家的牛犁完罗秋最后一块梯田。', 'Sáng trước ngày tưới vụ xuân, sương trên Nguyên Dương chưa tan. La Thu lần đầu đi tuần kênh với vai trò người quản mương; cô hẹn người hàng xóm Mã Lam buổi trưa sẽ dùng trâu nhà Mã cày nốt thửa ruộng bậc thang cuối cùng của mình.', 'On the morning before spring irrigation, mist still hangs over Yuanyang. Luo Qiu is making her first ditch round as the water keeper; she and her neighbor Ma Lan have arranged to use Ma Lan’s buffalo after noon to plough Luo Qiu’s final terrace.'),
  _HongheSegment(0, 2, '出门前，罗秋还把自家牛轭放在田边，等着马岚牵牛过来。', 'Trước khi đi, La Thu còn đặt ách trâu bên ruộng, chờ Mã Lam dắt trâu sang.', 'Before leaving, Luo Qiu sets her own yoke beside the field, ready for Ma Lan to bring the buffalo.'),
  _HongheSegment(0, 3, '两人从小在相邻的田埂上换着帮工。上周罗秋刚替马岚补过一段田埂，今天这头水牛原本是马岚还她的人情。', 'Hai người lớn lên bên những bờ ruộng kề nhau và thường đổi công. Tuần trước La Thu vừa giúp Mã Lam sửa một đoạn bờ; con trâu hôm nay vốn là cách Mã Lam trả lại sự giúp đỡ ấy.', 'They grew up working across neighboring terrace bunds and trading help. Last week Luo Qiu repaired a stretch of Ma Lan’s bund; today’s buffalo was meant to return that favor.'),
  _HongheSegment(0, 7, '山顶森林蓄下的水穿过村寨，再沿沟渠往坡下走。罗秋一路拨开落叶，听每个分水口的水声，知道哪一支忽然变细都会传到更低的田。', 'Nước do rừng trên đỉnh núi giữ lại đi qua làng rồi theo mương xuống dốc. La Thu gạt lá trên đường, nghe tiếng nước ở từng điểm chia dòng; cô biết một nhánh yếu đi sẽ truyền tác động xuống những thửa thấp hơn.', 'Water held by the mountaintop forest passes through the village and follows channels downslope. Luo Qiu brushes leaves aside and listens at each division point, knowing that a suddenly thinner branch will be felt in fields below.'),

  _HongheSegment(1, 1, '拐到分水口，她发现硬木分水器上，通向马岚田里的凹槽被重新削宽；另一支沟的水已经细下去。', 'Đến chỗ chia nước, cô thấy rãnh gỗ cứng dẫn về ruộng Mã Lam đã bị gọt rộng hơn; dòng ở nhánh kia đã yếu đi.', 'At the water split she sees that the hard-wood groove leading toward Ma Lan’s field has been cut wider; the other branch has already thinned.'),
  _HongheSegment(1, 4, '木头边缘还新，刀痕里挂着湿屑。马岚站在水边，没有装作不知道。', 'Mép gỗ còn mới, mùn ướt mắc trong vết dao. Mã Lam đứng bên nước, không giả vờ như không biết chuyện.', 'The wood edge is fresh and wet shavings cling to the knife marks. Ma Lan stands by the water without pretending not to know.'),
  _HongheSegment(1, 8, '罗秋蹲下来，把手指伸到两道水里。宽槽那边水急，窄槽那边只贴着沟底走；更下方有人正给空田蓄水，等着插秧。', 'La Thu ngồi xổm, đưa ngón tay vào hai dòng nước. Bên rãnh rộng chảy mạnh, bên hẹp chỉ lướt đáy mương; phía dưới có người đang tích nước cho ruộng trống để chờ cấy.', 'Luo Qiu crouches and puts her fingers into both flows. Water runs hard through the wide groove while the narrow side only skims the channel bed; farther below, someone is filling an empty field for transplanting.'),

  _HongheSegment(2, 1, '马岚承认昨夜动了木槽：她家刚整好的田还没蓄满，只求罗秋把宽槽留到中午。', 'Mã Lam thừa nhận tối qua đã sửa rãnh gỗ: ruộng nhà cô vừa làm xong vẫn chưa đủ nước, cô chỉ xin La Thu để rãnh rộng đến trưa.', 'Ma Lan admits altering the wooden groove the night before: her newly prepared field is not yet full, and she asks Luo Qiu to leave the wider groove until noon.'),
  _HongheSegment(2, 5, '她又提醒罗秋：“下午还等不等我家的牛？”这句话比水声轻，却把两人私下的帮工和罗秋刚接下的公事拴在一起。', 'Rồi cô nhắc: “Chiều còn đợi trâu nhà tôi không?” Câu nói nhẹ hơn tiếng nước nhưng buộc việc đổi công riêng của hai người vào trách nhiệm công mà La Thu vừa nhận.', 'Then she reminds Luo Qiu, “Are you still waiting for our buffalo this afternoon?” The words are quieter than the water, but they bind their private exchange of labor to Luo Qiu’s new public duty.'),
  _HongheSegment(2, 9, '罗秋没有马上回答。她原本以为当上赶沟人只是多走几趟沟；此刻她才看见，木头上的宽窄会落到具体的人情上。', 'La Thu không trả lời ngay. Cô từng nghĩ làm người quản mương chỉ là đi thêm vài vòng; giờ cô mới thấy độ rộng hẹp trên miếng gỗ có thể rơi thẳng vào những món nợ tình cụ thể.', 'Luo Qiu does not answer at once. She had thought being the water keeper meant only making extra rounds; now she sees that widths cut into wood can land directly on private obligations.'),

  _HongheSegment(3, 1, '罗秋把分水器抽出来，按照村里议定的尺寸重新凿好凹槽，再压回分水口。', 'La Thu rút bộ chia nước ra, đục lại các rãnh theo kích thước làng đã thống nhất rồi ép nó trở lại điểm chia.', 'Luo Qiu pulls out the divider, recuts the grooves to the dimensions agreed in the village, and presses it back into the split.'),
  _HongheSegment(3, 5, '马岚伸手按住木头一角。罗秋没有甩开她，只说：“尺寸是大家一起议定的。”然后等那只手自己松开。', 'Mã Lam đặt tay lên một góc gỗ. La Thu không hất tay bạn ra, chỉ nói: “Kích thước này mọi người cùng thống nhất.” Rồi cô chờ bàn tay ấy tự buông.', 'Ma Lan puts a hand on one corner of the wood. Luo Qiu does not knock it away. “These dimensions were agreed together,” she says, and waits for the hand to release on its own.'),
  _HongheSegment(3, 6, '木槽入水后先晃了一下。罗秋用石头把两端卡稳，水很快从同一股泉流里分成不同宽度的两道。', 'Rãnh gỗ chao nhẹ khi vào nước. La Thu chèn đá hai đầu; chẳng bao lâu cùng một dòng suối tách thành hai nhánh có bề rộng khác nhau.', 'The wooden divider wobbles once in the water. Luo Qiu braces both ends with stones, and the same spring flow quickly separates into two differently sized streams.'),
  _HongheSegment(3, 10, '她把最后一片木屑从槽口抹掉时，马岚已经牵起牛绳。牛铃响了一声，水面同时换了方向。', 'Khi cô gạt mảnh gỗ cuối khỏi miệng rãnh, Mã Lam đã cầm dây trâu. Chuông trâu kêu một tiếng đúng lúc mặt nước đổi hướng.', 'As she wipes the last shaving from the groove, Ma Lan has already lifted the buffalo rope. The bell sounds once as the water changes direction.'),

  _HongheSegment(4, 1, '较细的那支沟重新涨起来，水继续往下方梯田走。马岚没再说话，牵着牛离开；罗秋当天的犁田约定也跟着没了。', 'Nhánh từng yếu lại đầy lên và nước tiếp tục xuống các ruộng thấp. Mã Lam không nói thêm, dắt trâu đi; cuộc hẹn cày ruộng của La Thu trong ngày cũng mất theo.', 'The thinner branch rises again and water continues toward the terraces below. Ma Lan says nothing more and leads the buffalo away; Luo Qiu’s ploughing arrangement for the day goes with it.'),
  _HongheSegment(4, 6, '下方田主隔着两层田埂喊了一声“水到了”。罗秋没有应，只低头看分水器，两道水都稳定地越过木槽。', 'Một người chủ ruộng phía dưới gọi qua hai bờ ruộng: “Nước tới rồi.” La Thu không đáp, chỉ nhìn xuống bộ chia; cả hai dòng đều chảy ổn định qua gỗ.', 'A farmer two terrace bunds below calls, “The water is here.” Luo Qiu does not answer. She looks down at the divider as both streams pass steadily over the wood.'),
  _HongheSegment(4, 8, '她知道马岚并没有失去自己的水，只是失去了昨夜多削出来的那一份；可这并没有让朋友的背影变得轻一些。', 'Cô biết Mã Lam không mất phần nước của mình, chỉ mất phần đã gọt rộng thêm tối qua; nhưng điều đó không làm bóng lưng của người bạn nhẹ đi.', 'She knows Ma Lan has not lost her own water, only the extra share cut the night before; that does not make her friend’s departing back feel any lighter.'),
  _HongheSegment(4, 10, '太阳升高以后，窄沟里的水已经接上下一处分口。罗秋把锄头扛回肩上，牛铃声早听不见了。', 'Khi mặt trời lên cao, nước trong nhánh hẹp đã nối tới điểm chia kế tiếp. La Thu vác cuốc lên vai; tiếng chuông trâu đã biến mất.', 'By the time the sun rises higher, the narrow channel has joined the next division point. Luo Qiu shoulders her hoe; the buffalo bell can no longer be heard.'),

  _HongheSegment(5, 1, '傍晚，罗秋自己的最后一块田还没犁。她卷起裤腿下田，先沿田埂把松土一脚脚踩实；远处两支沟都在响。', 'Chiều tối, thửa ruộng cuối của La Thu vẫn chưa cày. Cô xắn quần xuống ruộng, giẫm từng bước cho đất bờ chắc lại; hai nhánh nước vẫn vang ở xa.', 'By evening Luo Qiu’s own last terrace is still unploughed. She rolls up her trousers and steps into the field, pressing loose soil firm along the bund while both channels sound in the distance.'),
  _HongheSegment(5, 7, '她没有去马岚家借牛，也没有托人解释。能赶上的活先赶，犁田只能另找一天。', 'Cô không sang nhà Mã Lam mượn trâu, cũng không nhờ ai giải thích. Việc nào kịp thì làm trước; chuyện cày phải để ngày khác.', 'She does not go to Ma Lan’s house to borrow the buffalo and sends no one to explain. She does what work she can; the ploughing will have to wait for another day.'),
  _HongheSegment(5, 9, '天快黑时，她从自己田里抬头，看见分水口上那块新凿过的硬木只露出一条湿亮的边。', 'Khi trời gần tối, cô ngẩng lên từ ruộng mình và thấy miếng gỗ vừa đục ở điểm chia nước chỉ lộ một mép ướt sáng.', 'Near dark she looks up from her own field and sees only a wet bright edge of the newly cut hardwood at the water split.'),
  _HongheSegment(5, 10, '罗秋把鞋放在田埂上，踩进泥里。两道水从村寨下分开，水声不同，她没回头。', 'La Thu đặt giày trên bờ ruộng rồi bước xuống bùn. Hai dòng nước tách nhau dưới làng, âm thanh khác nhau; cô không ngoảnh lại.', 'Luo Qiu leaves her shoes on the bund and steps into the mud. Below the village the two streams divide, sounding different; she does not look back.'),
];

String _pinyin(String text) => PinyinHelper.getPinyinE(
      text,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

DiscoveryEntry _discovery(String zh, String simple, String vi, String en) =>
    DiscoveryEntry(
      text: zh,
      pinyin: _pinyin(zh),
      simpleChinese: simple,
      vietnamese: vi,
      english: en,
    );

List<DiscoveryEntry> hongheDiscoveriesForLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final rows = switch (level) {
    1 => <List<String>>[
        ['红河哈尼梯田位于云南南部哀牢山地，梯田沿陡坡层层展开，是仍在生产的活态文化景观。', '梯田在哀牢山坡上，而且今天仍有人耕作。', 'Ruộng bậc thang Hani Hồng Hà nằm trên sườn dốc Ai Lao ở nam Vân Nam và vẫn là cảnh quan canh tác sống.', 'The Honghe Hani terraces spread across steep Ailao slopes in southern Yunnan and remain a living farming landscape.'],
        ['森林、村寨、沟渠和梯田组成相互依赖的系统：水从高处进入生活与农田，四部分不能当成彼此无关的风景。', '森林、村寨、水路和梯田彼此相连。', 'Rừng, làng, kênh và ruộng tạo thành một hệ phụ thuộc lẫn nhau; nước từ cao đi vào đời sống và đồng ruộng.', 'Forests, villages, channels, and terraces form an interdependent system in which water moves from the heights into daily life and fields.'],
      ],
    2 => <List<String>>[
        ['山顶森林能够涵养降水和泉水，为坡下灌溉提供持续水源。', '山顶森林帮助保存供梯田使用的水。', 'Rừng trên đỉnh giữ nước mưa và nước suối, cung cấp nguồn nước liên tục cho tưới tiêu phía dưới.', 'Mountaintop forests retain rainfall and spring water, sustaining irrigation water downslope.'],
        ['哀牢山的地形和岩层让泉水在高处汇集，再沿沟渠向村寨和梯田流动。', '泉水会沿沟渠流向村寨和梯田。', 'Địa hình và địa chất Ai Lao gom nước suối ở cao rồi dẫn theo kênh tới làng và ruộng.', 'Ailao topography and geology gather springs at elevation, from which channels carry water toward villages and terraces.'],
      ],
    3 => <List<String>>[
        ['世界遗产范围内有八十多个传统村寨，许多村寨位于上方森林与下方梯田之间。', '许多村寨就在森林和梯田之间。', 'Trong khu di sản có hơn tám mươi làng truyền thống, nhiều làng nằm giữa rừng phía trên và ruộng phía dưới.', 'More than eighty traditional villages lie within the property, many between the upper forests and lower terraces.'],
        ['哈尼传统蘑菇房和村寨并不是观景布景；居住空间位于沟渠把水从森林送向梯田的中段。', '村寨也是水从森林到梯田过程中的一部分。', 'Nhà nấm và làng Hani không phải phông cảnh; khu ở nằm giữa đường kênh đưa nước từ rừng xuống ruộng.', 'Hani mushroom houses and villages are not scenery: settlement sits midway in the channel route carrying forest water to the terraces.'],
      ],
    4 => <List<String>>[
        ['哈尼梯田形成了复杂的灌溉网络，主沟和支沟把高处水源分送到不同山谷和田块。', '主沟和支沟把水分到不同田块。', 'Mạng tưới phức tạp dùng mương chính và nhánh để phân nước tới các thung lũng và thửa khác nhau.', 'A complex irrigation network uses main and branch channels to distribute upland water among valleys and fields.'],
        ['UNESCO记录的核心区有四条主干沟和三百九十二条支沟，总长四百多公里，需要社区共同维护。', '很多沟渠需要大家长期一起维护。', 'UNESCO ghi nhận bốn kênh chính và 392 nhánh trong vùng lõi, tổng dài hơn 400 km và cần cộng đồng cùng bảo dưỡng.', 'UNESCO records four trunk canals and 392 branch ditches in the core area, more than 400 kilometres in total and communally maintained.'],
      ],
    5 => <List<String>>[
        ['“木刻分水”把共同议定的用水份额刻在硬木凹槽上，不同宽度的凹槽把水分入不同支沟。', '木头上不同宽度的槽可以分配不同水量。', '“Chia nước khắc gỗ” ghi phần nước đã thống nhất vào các rãnh gỗ cứng có độ rộng khác nhau.', 'Wood-carved water division encodes agreed water shares in hardwood grooves of different widths that direct water into branch channels.'],
        ['分水比例不是一个人临时决定的，而由用水户根据田地和劳动等情况协商议定。', '分多少水需要用水的人一起商量。', 'Tỷ lệ nước không do một người quyết định tức thời mà được người dùng nước thương lượng theo ruộng đất và lao động.', 'Water proportions are not improvised by one person; water users negotiate and agree them with reference to fields and labor.'],
        ['赶沟人由社区推选，负责巡查沟渠、保持水路通畅，并管理分水设施和公共沟渠。', '赶沟人负责看沟、修沟和管理分水。', 'Người quản mương do cộng đồng lựa chọn, đi kiểm tra, giữ dòng chảy và quản lý công trình chia nước.', 'The community selects the water keeper to inspect channels, keep them flowing, and manage shared ditches and division facilities.'],
      ],
    6 => <List<String>>[
        ['水田需要持续供水；长期干裂后突然重新蓄水，田埂可能更容易出现损坏。', '水田长期太干以后再进水，田埂可能更不稳定。', 'Ruộng nước cần dòng liên tục; sau thời gian khô nứt dài, tích nước lại đột ngột có thể làm bờ dễ hư hơn.', 'Paddy terraces need continuing water; after prolonged drying, sudden refilling can make terrace bunds more vulnerable.'],
        ['梯田通常在上方进水、下方出水，水源经沟渠沿坡面逐级进入下一层田块。', '水会从高一层田继续流向低一层田。', 'Nước vào từ phía trên, ra ở phía dưới rồi theo kênh xuống từng tầng ruộng.', 'Water typically enters a terrace above, exits below, and moves through channels step by step downslope.'],
        ['今天的春灌仍会按照海拔和农时推进，为插秧前的蓄水、整田和灌溉做准备。', '今天春天也要先灌水、整田，再准备插秧。', 'Tưới vụ xuân ngày nay vẫn theo độ cao và lịch mùa vụ để tích nước, làm đất và chuẩn bị cấy.', 'Contemporary spring irrigation still follows elevation and farm timing, preparing water and fields before rice transplanting.'],
      ],
    7 => <List<String>>[
        ['红米是梯田的重要作物，水牛、鸭、鱼等也参与田间生产。', '梯田里不只有水稻，也有动物参与生产。', 'Gạo đỏ là cây trồng quan trọng; trâu, vịt và cá cũng tham gia hệ sản xuất.', 'Red rice is an important crop, while buffalo, ducks, fish, and other animals also participate in terrace farming.'],
        ['动物、作物、水和养分在梯田系统中循环，使单块稻田同时连接耕作与生态。', '田里的动物、作物和水会互相影响。', 'Động vật, cây trồng, nước và dinh dưỡng tuần hoàn, nối canh tác với sinh thái.', 'Animals, crops, water, and nutrients cycle through the terrace system, linking cultivation and ecology.'],
        ['水牛不仅是景观中的动物，也长期参与整田等农业劳动。', '水牛会真正帮助农户整田。', 'Trâu không chỉ xuất hiện trong phong cảnh mà còn tham gia lao động làm đất.', 'Buffalo are not merely scenic animals; they have long taken part in field preparation and other farm work.'],
      ],
    8 => <List<String>>[
        ['哈尼人在哀牢山地营造梯田已有一千三百多年，今天仍靠日常耕作维持这一活态文化景观。', '梯田有很长历史，而且今天仍在生产。', 'Người Hani đã tạo ruộng trên Ai Lao hơn 1.300 năm và cảnh quan sống này vẫn dựa vào canh tác hằng ngày.', 'Hani communities have developed terraces in the Ailao Mountains for more than 1,300 years, and daily farming still sustains this living landscape.'],
        ['森林涵养水源、村寨生活、梯田生产和灌溉沟渠需要长期共同维护；木刻分水等实践让共享水路继续运作。', '保护需要长期一起照顾森林、水路、村寨和农田。', 'Rừng giữ nguồn nước, đời sống làng, ruộng và kênh tưới cần được cùng duy trì; chia nước khắc gỗ giúp hệ nước chung tiếp tục hoạt động.', 'Forest water retention, village life, terrace production, and irrigation channels require long-term shared maintenance; wooden water division helps common waterways keep working.'],
        ['二〇一三年，红河哈尼梯田文化景观列入《世界遗产名录》，其价值包括人与山地环境长期形成的互动。', '二〇一三年，这里成为世界遗产。', 'Năm 2013, cảnh quan ruộng bậc thang Hani Hồng Hà vào Danh sách Di sản Thế giới.', 'In 2013 the Cultural Landscape of Honghe Hani Rice Terraces entered the World Heritage List, recognizing long interaction between people and the mountain environment.'],
      ],
    9 => <List<String>>[
        ['这套水资源系统依靠森林涵养水源和沟渠灌溉，对季节性干旱具有一定韧性，但滑坡、极端天气和沟渠受损仍会影响梯田。', '这套系统能面对一些干旱，但仍怕滑坡和沟渠损坏。', 'Hệ nước dựa vào rừng giữ nguồn và kênh tưới có sức chống hạn nhất định, nhưng sạt lở, thời tiết cực đoan và hư kênh vẫn gây rủi ro.', 'The water system gains some drought resilience from forest retention and channel irrigation, but landslides, extreme weather, and channel damage still threaten terraces.'],
        ['保护不仅面对自然风险，也要共同维护公共水路，并面对劳动力变化、红米收益和旅游发展带来的生活压力。', '保护也和农户收入、劳动力和公共水路有关。', 'Bảo tồn còn phải duy trì đường nước chung và đối mặt thay đổi lao động, thu nhập gạo đỏ và áp lực du lịch.', 'Protection also depends on shared waterways while facing labor change, red-rice income pressures, and tourism development.'],
        ['如果农户无法继续从耕作中获得合理收益，木刻分水等活态实践也可能失去维持它的日常劳动。', '没有持续耕作，传统分水也很难继续。', 'Nếu nông dân không thể sống hợp lý từ canh tác, những thực hành sống như chia nước khắc gỗ cũng mất lao động hằng ngày duy trì chúng.', 'If farming no longer provides viable returns, living practices such as wooden water division can lose the everyday labor that sustains them.'],
      ],
    _ => <List<String>>[
        ['当前保护仍强调森林、村寨、梯田和水系的四素同构，不能只把最漂亮的水田当作保护对象。', '保护对象是完整系统，不只是漂亮的水田。', 'Bảo tồn hiện nay vẫn nhấn mạnh cấu trúc bốn yếu tố rừng, làng, ruộng và nước chứ không chỉ các thửa đẹp nhất.', 'Current protection still emphasizes the four-element structure of forest, village, terraces, and water rather than protecting only picturesque fields.'],
        ['现代水利工程可以补充水源和灌溉，但传统赶沟人、木刻分水、沟渠共同维护与森林涵养仍被列为需要延续的实践。', '现代工程和传统水管理可以一起工作。', 'Công trình thủy lợi hiện đại có thể bổ sung nguồn và tưới, nhưng quản mương, chia nước khắc gỗ, cùng bảo dưỡng kênh và rừng giữ nước vẫn cần tiếp tục.', 'Modern water works can supplement supply and irrigation, while water keepers, wooden division, shared channel maintenance, and forest retention remain practices to continue.'],
        ['活态保护的目标不是把梯田冻结成布景，而是让社区、红米生产、水资源管理和传统知识继续共同运作。', '活态保护要让社区和生产继续生活下去。', 'Bảo tồn sống không đóng băng ruộng thành phông cảnh mà giữ cho cộng đồng, sản xuất gạo đỏ, quản lý nước và tri thức tiếp tục vận hành.', 'Living conservation does not freeze terraces into scenery; it keeps community life, red-rice production, water management, and knowledge working together.'],
      ],
  };
  return List<DiscoveryEntry>.unmodifiable([
    for (final row in rows) _discovery(row[0], row[1], row[2], row[3]),
  ]);
}

const hongheHaniRiceTerracesWords = <WordEntry>[
  WordEntry(word: '梯田', pinyin: 'tītián', partOfSpeech: '名词', simpleChinese: '沿山坡一层一层修出的农田。', translation: 'Ruộng bậc thang.', englishDefinition: 'terraced field', symbol: '🌾'),
  WordEntry(word: '沟渠', pinyin: 'gōuqú', partOfSpeech: '名词', simpleChinese: '引水和分水的小河道。', translation: 'Kênh, mương dẫn nước.', englishDefinition: 'irrigation channel', symbol: '〰️'),
  WordEntry(word: '分水口', pinyin: 'fēnshuǐkǒu', partOfSpeech: '名词', simpleChinese: '把一股水分进不同水路的位置。', translation: 'Điểm chia nước.', englishDefinition: 'water division point', symbol: '🔀'),
  WordEntry(word: '凹槽', pinyin: 'āocáo', partOfSpeech: '名词', simpleChinese: '物体表面向下凹进去的槽。', translation: 'Rãnh lõm.', englishDefinition: 'groove', symbol: '🪵'),
  WordEntry(word: '赶沟人', pinyin: 'gǎngōurén', partOfSpeech: '名词', simpleChinese: '负责巡查和维护公共沟渠、管理分水的人。', translation: 'Người quản mương.', englishDefinition: 'community ditch and water keeper', symbol: '🧑‍🌾'),
  WordEntry(word: '春灌', pinyin: 'chūnguàn', partOfSpeech: '名词', simpleChinese: '春季为农田进行的灌水。', translation: 'Tưới vụ xuân.', englishDefinition: 'spring irrigation', symbol: '💧'),
  WordEntry(word: '水源', pinyin: 'shuǐyuán', partOfSpeech: '名词', simpleChinese: '水最初来自的地方。', translation: 'Nguồn nước.', englishDefinition: 'water source', symbol: '🏔️'),
  WordEntry(word: '森林', pinyin: 'sēnlín', partOfSpeech: '名词', simpleChinese: '大片生长树木的区域。', translation: 'Rừng.', englishDefinition: 'forest', symbol: '🌲'),
  WordEntry(word: '村寨', pinyin: 'cūnzhài', partOfSpeech: '名词', simpleChinese: '居民共同生活的乡村聚落。', translation: 'Bản làng.', englishDefinition: 'village settlement', symbol: '🏘️'),
  WordEntry(word: '议定', pinyin: 'yìdìng', partOfSpeech: '动词', simpleChinese: '经过讨论以后共同决定。', translation: 'Thống nhất sau khi bàn bạc.', englishDefinition: 'to agree through deliberation', symbol: '🤝'),
  WordEntry(word: '水牛', pinyin: 'shuǐniú', partOfSpeech: '名词', simpleChinese: '常用于水田劳动的牛。', translation: 'Trâu nước.', englishDefinition: 'water buffalo', symbol: '🐃'),
  WordEntry(word: '田埂', pinyin: 'tiángěng', partOfSpeech: '名词', simpleChinese: '围在田边、挡水和供人行走的土埂。', translation: 'Bờ ruộng.', englishDefinition: 'field bund', symbol: '🟫'),
  WordEntry(word: '灌溉', pinyin: 'guàngài', partOfSpeech: '动词/名词', simpleChinese: '把水送到农田里帮助作物生长。', translation: 'Tưới tiêu.', englishDefinition: 'irrigation', symbol: '🚿'),
  WordEntry(word: '木刻分水', pinyin: 'mùkè fēnshuǐ', partOfSpeech: '名词', simpleChinese: '用硬木上不同宽度的槽来分配水量的传统方式。', translation: 'Cách chia nước bằng rãnh khắc trên gỗ.', englishDefinition: 'traditional wood-carved water allocation', symbol: '🪚'),
  WordEntry(word: '共同维护', pinyin: 'gòngtóng wéihù', partOfSpeech: '动词短语', simpleChinese: '由多人一起长期照顾和修理。', translation: 'Cùng bảo dưỡng.', englishDefinition: 'shared maintenance', symbol: '🛠️'),
  WordEntry(word: '四素同构', pinyin: 'sì sù tónggòu', partOfSpeech: '名词', simpleChinese: '森林、村寨、梯田和水系作为一个整体相互依赖。', translation: 'Cấu trúc đồng bộ bốn yếu tố.', englishDefinition: 'integrated four-element landscape structure', symbol: '🧩'),
  WordEntry(word: '活态', pinyin: 'huótài', partOfSpeech: '形容词', simpleChinese: '仍通过真实生活和生产继续存在。', translation: 'Sống, còn vận hành trong đời sống.', englishDefinition: 'living and actively practiced', symbol: '🌱'),
  WordEntry(word: '红米', pinyin: 'hóngmǐ', partOfSpeech: '名词', simpleChinese: '红河梯田种植的重要稻米。', translation: 'Gạo đỏ.', englishDefinition: 'red rice', symbol: '🍚'),
  WordEntry(word: '涵养', pinyin: 'hányǎng', partOfSpeech: '动词', simpleChinese: '让水分被保存并慢慢补给。', translation: 'Giữ và nuôi dưỡng nguồn nước.', englishDefinition: 'to retain and replenish water', symbol: '🌳'),
  WordEntry(word: '水资源', pinyin: 'shuǐ zīyuán', partOfSpeech: '名词', simpleChinese: '可以被生活、农业和生态使用的水。', translation: 'Tài nguyên nước.', englishDefinition: 'water resources', symbol: '💦'),
];

List<JourneyLevelContent> _buildHongheLevels() {
  const agent = PhoenixLanguageLevelAgent();
  return List<JourneyLevelContent>.generate(10, (index) {
    final level = index + 1;
    final visible = _segments.where((segment) => segment.from <= level).toList(growable: false);
    final first = visible.where((segment) => segment.event <= 2).toList(growable: false);
    final second = visible.where((segment) => segment.event >= 3).toList(growable: false);

    ReadingAnnotation annotationFor(List<_HongheSegment> values) => ReadingAnnotation(
          pinyin: _pinyin(values.map((segment) => segment.zh).join()),
          vietnamese: values.map((segment) => segment.vi).join(' '),
          english: values.map((segment) => segment.en).join(' '),
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
    final discoveries = hongheDiscoveriesForLevel(level);
    final context = '${storyParagraphs.join()}${discoveries.map((entry) => entry.text).join()}';
    final target = agent.planFor(agent.profileForPhoenixLevel(level)).targetVocabularyCount;
    final words = hongheHaniRiceTerracesWords
        .where((word) => context.contains(word.word))
        .take(target)
        .toList(growable: false);

    return JourneyLevelContent(
      storyParagraphs: List<String>.unmodifiable(storyParagraphs),
      storyAnnotations: List<ReadingAnnotation>.unmodifiable(storyAnnotations),
      words: List<WordEntry>.unmodifiable(words),
      discoveries: discoveries,
      wonderQuestion: level <= 2
          ? '罗秋为什么不能先把朋友多出来的那份水留到中午？'
          : level <= 6
              ? '木槽的宽窄怎样把公共水份额和两个人的私人互惠绑在同一个选择里？'
              : '为什么“恢复共同议定的两道水”既是水管理动作，也是一个会留下私人代价的人类选择？',
      expressQuestion: level <= 2
          ? '请用“发现……承认……重新……”复述罗秋处理分水口的过程。'
          : level <= 6
              ? '请说明罗秋恢复了什么，又因此具体失去了什么。'
              : '请从“森林来水—共同分水—关系依赖—选择—代价—后果”解释这段故事为什么必须发生在红河哈尼梯田。',
    );
  }, growable: false);
}

final hongheHaniRiceTerracesGoldLevels =
    List<JourneyLevelContent>.unmodifiable(_buildHongheLevels());

JourneyLevelContent hongheHaniRiceTerracesGoldLevelContent(int requestedLevel) =>
    hongheHaniRiceTerracesGoldLevels[requestedLevel.clamp(1, 10).toInt() - 1];

final hongheHaniRiceTerracesGoldJourney = RemediatedJourney(
  id: hongheHaniRiceTerracesJourneyId,
  title: hongheHaniRiceTerracesCanonicalTitle,
  protagonist: '罗秋，虚构当代普通农户、第一次承担赶沟人职责。',
  goal: '恢复共同议定的分水，同时尽可能完成自己的春灌犁田安排。',
  conflict: '公共分水职责与对朋友私人互惠、水牛劳力的现实依赖正面冲突。',
  eventIds: const ['HH-E1', 'HH-E2', 'HH-E3', 'HH-E4', 'HH-E5', 'HH-E6'],
  events: [
    for (var event = 0; event < 6; event++)
      RemediatedSemanticEvent(
        id: 'HH-E${event + 1}',
        coreChinese: _segments.firstWhere((segment) => segment.event == event && segment.from == 1).zh,
        corePinyin: _pinyin(_segments.firstWhere((segment) => segment.event == event && segment.from == 1).zh),
        coreVietnamese: _segments.firstWhere((segment) => segment.event == event && segment.from == 1).vi,
        coreEnglish: _segments.firstWhere((segment) => segment.event == event && segment.from == 1).en,
        detailChinese: _segments.where((segment) => segment.event == event && segment.from > 1).map((segment) => segment.zh).join(),
        detailPinyin: _pinyin(_segments.where((segment) => segment.event == event && segment.from > 1).map((segment) => segment.zh).join()),
        detailVietnamese: _segments.where((segment) => segment.event == event && segment.from > 1).map((segment) => segment.vi).join(' '),
        detailEnglish: _segments.where((segment) => segment.event == event && segment.from > 1).map((segment) => segment.en).join(' '),
        detailFromLevel: 2,
      ),
  ],
  levels: hongheHaniRiceTerracesGoldLevels,
  words: hongheHaniRiceTerracesWords,
  wordTraces: [
    for (final word in hongheHaniRiceTerracesWords)
      RemediatedWordTrace(
        word: word.word,
        eventId: 'HH-E1',
        usage: 'active Story/Discovery vocabulary only',
        sourceText: word.simpleChinese,
      ),
  ],
  discoveries: [
    for (var level = 1; level <= 10; level++) ...hongheDiscoveriesForLevel(level),
  ],
  discoveryTraces: [
    for (var i = 0; i < 26; i++)
      RemediatedDiscoveryTrace(
        discoveryIndex: i,
        storyEventIds: i < 13 ? const ['HH-E1', 'HH-E2', 'HH-E3'] : const <String>[],
        sourceIds: const ['unesco-honghe', 'honghe-government-water-rules', 'yuanyang-government-water-sharing', 'yunnan-water-spring-irrigation'],
      ),
  ],
  challenges: const [
    RemediatedChallengeTrace(type: 'paragraphRebuild', storyEventIds: ['HH-E1', 'HH-E2', 'HH-E3', 'HH-E4', 'HH-E5', 'HH-E6'], anchor: '春灌与借牛→发现宽槽→朋友请求→恢复议定尺寸→水恢复而牛离开→自己的田未犁'),
    RemediatedChallengeTrace(type: 'grammarRepair', storyEventIds: ['HH-E2', 'HH-E3', 'HH-E4', 'HH-E5'], anchor: '修复结果补语、范围、把字句、让步与条件表达，不新增历史事实'),
    RemediatedChallengeTrace(type: 'missingSentence', storyEventIds: ['HH-E2', 'HH-E3', 'HH-E4', 'HH-E5'], anchor: '分水器必须连接“私人多水”与“恢复公共份额同时失去私人劳力”的因果'),
  ],
  memory: const [
    RemediatedMemoryReview(category: 'choice', prompt: '罗秋真正做了什么选择？', answer: '她没有把朋友多出来的水留到中午，而是按大家议定的尺寸重新凿回木槽并立即装回分水口。', storyEventIds: ['HH-E4']),
    RemediatedMemoryReview(category: 'cost', prompt: '这个选择让罗秋具体失去了什么？', answer: '马岚牵走原本要借给她的水牛，她自己的最后一块梯田当天没有按计划犁完，朋友关系也没有立刻修复。', storyEventIds: ['HH-E5', 'HH-E6']),
    RemediatedMemoryReview(category: 'place', prompt: '为什么哈尼梯田的水不是故事背景？', answer: '森林来水经过共享沟渠和木刻分水向坡下梯田流；木槽宽窄直接改变两支沟的水量，也直接制造了罗秋的选择。', storyEventIds: ['HH-E1', 'HH-E2', 'HH-E4']),
    RemediatedMemoryReview(category: 'memory', prompt: '这段旅程最该记住的画面是什么？', answer: '重新凿过的硬木入水，两道水恢复议定宽度；同一刻牛铃响了一声，马岚牵牛离开。', storyEventIds: ['HH-E4', 'HH-E5']),
    RemediatedMemoryReview(category: 'relationship', prompt: '故事最后两人的关系怎样被保留下来？', answer: '故事没有安排道歉或和解；罗秋接受朋友离开和自己的农活延后，关系成本真实留在结尾。', storyEventIds: ['HH-E5', 'HH-E6']),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '你完成了《两道水重新分开以后》：在真实运行的森林—村寨—沟渠—梯田系统里，看见一个虚构赶沟人怎样恢复共同分水，并由自己的私人生活承担代价。',
    achievement: '你已经能区分“木刻分水和赶沟人是真实活态实践”与“罗秋、马岚及两人的冲突是历史文化小说”。',
    memoryAnchor: '硬木重新压进分水口，两道水分开；水声恢复时牛铃转身远去，傍晚罗秋自己的田仍没有犁完。',
    challengeReward: '完成三种 Challenge 后，你能从故事顺序、中文结构和公共水路因果三个角度解释这一选择。',
    journeyCompletion: '红河哈尼梯田已点亮：记住共同的水如何穿过森林、村寨、木槽和田埂，也穿过真实的人际关系。',
  ),
  sources: const [
    RemediatedSourceBinding(id: 'unesco-honghe', publisher: 'UNESCO World Heritage Centre', scope: 'forest-village-water-terrace integrated landscape, channels, villages, living agriculture'),
    RemediatedSourceBinding(id: 'honghe-government-water-rules', publisher: '红河哈尼族彝族自治州人民政府', scope: 'community water keeper and wooden water-sharing governance'),
    RemediatedSourceBinding(id: 'yuanyang-government-water-sharing', publisher: '元阳县人民政府', scope: 'wooden groove allocation, ditch management, continuous-water and bund context'),
    RemediatedSourceBinding(id: 'yunnan-water-spring-irrigation', publisher: '云南省水利厅', scope: 'contemporary spring irrigation and living water-management practice'),
  ],
);