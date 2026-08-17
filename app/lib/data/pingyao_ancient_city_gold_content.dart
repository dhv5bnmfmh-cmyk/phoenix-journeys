import 'package:pinyin/pinyin.dart';

import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const pingyaoAncientCityJourneyId = 'pingyao-ancient-city';
const pingyaoAncientCityCanonicalTitle = '银子没有上路的那天';
const pingyaoActiveGoldStorySourceId = 'pingyao-ancient-city-active-gold-story';
const pingyaoPrimaryDepth = '信任从亲属身体押运转向可核验网络时，责任与在场会重新分配';
const pingyaoSecondaryDepths = <String>['兄弟共同风险的私人证明','制度不能自动修复关系','价值移动与身体移动分离'];

const pingyaoSourceLedger = <Map<String,String>>[
  {'id':'UNESCO-PINGYAO','publisher':'UNESCO World Heritage Centre','url':'https://whc.unesco.org/en/list/812','supports':'完整县城格局；十九世纪至二十世纪初全国金融中心；银行建筑、店铺与民居的遗产价值。'},
  {'id':'SHANXI-PINGYAO','publisher':'山西省文化和旅游厅','url':'https://wlt.shanxi.gov.cn/xwzx/wlxx/202305/t20230517_8565714.shtml','supports':'平遥古城及晋商、票号相关地方文化背景；用于与UNESCO交叉核对地方叙述。'},
  {'id':'GJBMJ-JINSHANG-PIAOHAO','publisher':'国家保密局互联网门户网站','url':'https://www.gjbmj.gov.cn/n1/2020/0911/c413725-31858628.html','supports':'票号异地汇兑；汇票替代现银长途结算；日升昌1823；汇票核验、防伪与分号兑付机制。'},
];
const pingyaoClaimLedger = <Map<String,String>>[
  {'claim':'平遥古城保存传统县城整体格局','source':'UNESCO-PINGYAO','status':'ALLOWED'},
  {'claim':'十九世纪至二十世纪初平遥是全国重要金融中心','source':'UNESCO-PINGYAO','status':'ALLOWED'},
  {'claim':'票号以异地汇兑和存放款为主要业务','source':'GJBMJ-JINSHANG-PIAOHAO','status':'ALLOWED'},
  {'claim':'汇票信用凭证可替代现银长途异地结算','source':'GJBMJ-JINSHANG-PIAOHAO','status':'ALLOWED'},
  {'claim':'日升昌创立于1823年','source':'GJBMJ-JINSHANG-PIAOHAO','status':'ALLOWED'},
  {'claim':'异地分号核验汇票后兑付现银','source':'GJBMJ-JINSHANG-PIAOHAO','status':'ALLOWED'},
  {'claim':'故事中的程砚、程岳、母亲、布店、兄弟分账','source':'FICTION-GOVERNANCE','status':'ALLOWED FICTION'},
];
const pingyaoFactFictionLedger = <Map<String,String>>[
  {'item':'平遥古城、十九世纪金融中心、票号异地汇兑、汇票与分号核验','category':'VERIFIED WORLD','status':'ALLOWED'},
  {'item':'程砚、程岳、母亲病重、北京货款、兄弟共营布店','category':'FICTIONAL ORDINARY PEOPLE / PRIVATE EVENT','status':'ALLOWED'},
  {'item':'兄弟对白、分账、印记与账本移动、母亲咳嗽','category':'FICTIONAL PRIVATE ACTION / CONSEQUENCE','status':'ALLOWED'},
  {'item':'雷履泰、李大全等真实人物的私人动机、对白或未载行动','category':'REAL PERSON HIGH-PROTECTION','status':'NOT USED'},
  {'item':'虚构统一票号法律、政府担保、零风险汇兑、所有票号完全相同流程','category':'UNSUPPORTED FACTUAL CLAIM','status':'BLOCKED / NOT USED'},
];

class PingyaoStoryArchitecture {
  const PingyaoStoryArchitecture({required this.id,required this.engine,required this.humanNeed,required this.relationship,required this.goal,required this.conflict,required this.choice,required this.cost,required this.climax,required this.consequence,required this.selected,required this.rejectedReason});
  final String id, engine, humanNeed, relationship, goal, conflict, choice, cost, climax, consequence, rejectedReason;
  final bool selected;
}
const pingyaoAncientCityArchitectures = <PingyaoStoryArchitecture>[
  PingyaoStoryArchitecture(id:'A',engine:'institutional-trust-changes-who-must-travel',humanNeed:'照料病母与完成异地货款同时成立',relationship:'兄弟共同经营与共同承担风险',goal:'用汇票让价值上路、自己留下',conflict:'哥哥把“身体押运”当责任证明',choice:'让票号汇兑替代亲自押运',cost:'兄弟分账，旧共同风险关系破裂',climax:'汇票出门、银箱不动、账本分开',consequence:'货款可兑付但兄弟关系不能被制度自动兑回',selected:true,rejectedReason:''),
  PingyaoStoryArchitecture(id:'B',engine:'verification-duty-vs-relative-favor',humanNeed:'保住亲戚的一笔急款',relationship:'票号伙计与堂兄',goal:'让不完整凭证先兑付',conflict:'亲缘请求冲撞核验职责',choice:'拒绝跳过核验',cost:'堂兄失去当天资金并疏远',climax:'柜台拒兑',consequence:'公共/职业职责压过私人互惠',selected:false,rejectedReason:'过近于现有“公共职责 vs 私人互惠 / shortcut refusal”Gold 引擎，Rule A/Human de-skin 风险高。'),
  PingyaoStoryArchitecture(id:'C',engine:'redeemed-draft-as-family-keepsake',humanNeed:'保留父亲留下的最后一张旧汇票',relationship:'成年子女与已故父亲记忆',goal:'保留已兑付票据作为私人纪念',conflict:'私人纪念与票据作废/账务处理冲突',choice:'放弃保留原票',cost:'失去私人实物记忆',climax:'旧汇票被注销',consequence:'记忆转到口述与复制记录',selected:false,rejectedReason:'过近于现有“私人旧物→牺牲/公共或制度正确性”Gold 形状，对象替换风险高。'),
];
const pingyaoPlaceCausalMechanism = <String,String>{
  'verifiedFact':'十九世纪平遥票号经营异地汇兑；汇票作为信用凭证可在异地分号核验后兑付，使价值移动不再等于整箱现银长途移动。',
  'period':'清末成熟票号网络背景',
  'placeCondition':'平遥金融中心 + 票号柜台 + 汇票 + 总分号账务与核验 + 跨城商路',
  'affects':'Goal / Relationship / Conflict / Choice / Cost / Climax / Consequence / Ending',
  'enables':'程砚可以让一张可核验的汇票跨城，而让银箱和自己的身体留在平遥；这种分离直接触发兄弟对责任定义的冲突。',
  'limits':'故事不能把票号写成零风险魔法，也不能把制度成功写成兄弟必然和解。',
  'genericPlaceTest':'PASS — 删除票号、汇票、分号核验与异地兑付，核心选择失去可行机制。',
  'otherCityTest':'PASS — 不能只把“平遥”换成任意古城；金融中心与票号网络必须由当地可核查历史支撑。',
};
const pingyaoStoryIdentityCard = <String,String>{
  'Journey':'pingyao-ancient-city',
  'Place':'中国→山西省→晋中市→平遥县→平遥古城',
  'Period':'清末（十九世纪后半叶的成熟票号网络背景）',
  'TruthMode':'真实平遥金融与县城世界 + 普通虚构兄弟与家庭事件',
  'Protagonist':'程砚，虚构普通布店合伙人',
  'LifeContext':'与哥哥程岳共营小布店、共用银箱与总账，母亲病重',
  'RelationshipGeometry':'成年兄弟既是亲属又是商业合伙人，共同风险习惯构成关系压力',
  'HumanNeed':'在母亲病重时留下，同时不让异地货款中断',
  'Goal':'让北京货款完成异地结算，并留在平遥照料母亲',
  'WhyToday':'母亲病重与北京货款到期发生在同一天',
  'WhatCannotWait':'货款需进入异地结算路径；母亲的照料也不能由程砚延后',
  'HumanStakes':'兄弟共同承担方式、商业合伙关系与母亲身边的在场',
  'VerifiedPlacePressure':'平遥票号通过汇票、分号与核验把价值移动和现银长途押运分开',
  'WhatIsFact':'平遥金融中心地位；票号异地汇兑；汇票信用凭证；分号核验兑付',
  'WhatIsFiction':'程砚程岳、布店、病母、北京货款、兄弟对白与分账后果',
  'PrimaryDepth':'信任从亲属身体押运转向可核验网络时，责任与在场会重新分配',
  'SecondaryDepths':'兄弟共同风险的私人证明；制度不能自动修复关系；价值移动与身体移动分离',
  'Conflict':'哥哥把亲自押运银两视为共同责任证明；程砚要用汇兑留下照料母亲',
  'Choice':'程砚把银两存入票号、拿到汇票，让信用凭证上路而自己留下',
  'Cost':'程岳把账本、店章与下一批货单移到另一柜台，两兄弟从此分开结算',
  'Climax':'汇票装进信封离开，银箱仍在柜台下，同时程岳抱走自己的账本',
  'Consequence':'异地货款仍可按票号网络兑付；程砚留在母亲身边；兄弟合伙关系裂成两本账',
  'Transformation':'从把责任理解为亲属身体共同押运，转为接受制度化信用也是真实承担，同时承受关系误读的代价',
  'MemoryMoment':'汇票离开、银箱不动、哥哥的账本从共同柜台移走',
  'EndingAction':'程砚把票号收据夹进新账册，锁好未出城的银箱，转身回母亲屋里',
  'GenericPlaceTest':'PASS — 移除平遥票号的汇票/分号异地兑付机制后，程砚无法让价值上路而身体留下，Choice、Cost、Climax 与 Ending 必须重写',
  'NearestGoldRisks':'Honghe public/private reciprocity；Nanjing shortcut refusal；Summer Palace/Kaiping private object sacrifice；Shanghai trade-document surface similarity',
  'ForbiddenStoryShapes':'拒绝违规捷径；牺牲旧物换正确性；师徒观察后优化；公共职责压倒私人请求',
};
const pingyaoDepthActionGate = <String,String>{
  'result':'PASS — 若移除“信任可从亲属身体押运转向可核验网络”这一 Primary Depth，程砚就没有理由让汇票上路而自己留下，决定性 Choice 必须改变。',
  'actionWithoutDepth':'只能继续亲属押运或改成普通照料冲突，无法保留现有 climax。',
};
const pingyaoRelationshipCausalityGate = <String,String>{
  'result':'PASS — 删除哥哥程岳后，分账这一 Cost、责任误读与两本账的 visible consequence 全部消失，核心 Choice 不再承受同等私人压力。',
};

final pingyaoGoldStories = <int,List<String>>{
  1: <String>[
    '清末，平遥古城的程砚和哥哥程岳合开一家小布店。母亲病着，北京的一笔货款又要送出。程岳想亲自带银两上路，程砚却把银两存进票号，换成汇票，托同行带去北京分号兑付。银箱留在店里，程砚也留下了。程岳沉默地抱走自己的账本，从那天起，两兄弟不再共用一本账。',
  ],
  2: <String>[
    '清末，平遥古城西大街的票号已经能办理异地汇兑。程砚和哥哥程岳合开一家小布店，母亲病着，北京的一笔货款也不能再拖。程岳坚持亲自护送银两，觉得家里的钱要由家里人看着。程砚却把银两存进票号，拿到汇票，托熟识的同行带往北京，由分号验票兑付。银箱没有出城，程砚也能留在母亲身边。代价却落在兄弟之间：程岳把自己的账本抱到另一张柜台，从此两人分开记账。',
  ],
  3: <String>[
    '清末，平遥古城的街巷里已有票号经营异地汇兑。程砚和哥哥程岳合开一家小布店。母亲病重，北京供货商的一笔货款又到了约定日期。程岳收拾银箱，准备亲自押着银两北上。程岳觉得这是兄弟一起担责的办法。程砚听见里屋的咳嗽，没有跟着收拾行李。',
    '他走进票号，把银两存下，拿到汇票。同行带着信用凭证前往北京，分号验票后即可兑付，整箱现银不必长途移动。程岳把自己的账本从共用柜台拿走。银箱留在平遥，程砚也留下；货款能去远方，兄弟的生意却分成了两本账。',
  ],
  4: <String>[
    '清末，平遥古城的商业街上，票号已经把异地汇兑做成成熟业务。程砚和哥哥程岳合开一家小布店，平日共用一只银箱和一本总账。母亲忽然病重时，北京供货商的一笔货款也到了约定日。程岳仍按旧习准备亲自带银两上路，他相信让家里人一路守着现银，才叫没有把责任交给别人。程砚听见里屋咳嗽，第一次觉得“谁必须上路”比“钱怎样上路”更难。',
    '程砚去了票号，把银两存入柜上，核对金额后换成汇票，再托熟识的同行带去北京分号。票号的汇兑网络让远方可以凭信用凭证兑付，沉重的现银不必随人长途移动。程岳看着那张薄纸，没有争吵，只把自己的账本和印记收进包里，搬到另一张柜台。货款的去路因此没有中断，程砚也留在母亲床边；但兄弟原本共用的生意，从那天起有了两本账。',
  ],
  5: <String>[
    '清末，平遥古城的西大街上，票号门面与商铺相邻。程砚和哥哥程岳在巷里合开一家小布店，多年来共用一只银箱、一本总账。母亲忽然病重的那天，北京供货商催来一笔到期货款。程岳把银锭装进木箱，仍想亲自护送上路。他并非不知道票号能做异地汇兑，只是不愿把“家里的责任”交给一张纸和远方分号。程砚听见母亲在里屋叫他们吃饭，手却停在箱扣上。他明白，只要继续用身体押着银两，兄弟中总要有一个人离开。',
    '程砚最后把银两搬进票号。柜台核清数目后开出汇票，同行带着信用凭证北上，北京分号验票即可兑付。银两没有踏上商路，信息和信用却替它跨过距离。程岳站在店门口看了很久，随后抱起自己的账本，把印记也收走，只留下一句：“这笔以后各记各的。”程砚没有追。他把票号收据夹进新账册，回到母亲屋里。远方的货款有了去处，近处的兄弟关系却没有被一张汇票一并结清。',
  ],
  6: <String>[
    '清末的平遥古城仍保持县城街巷与商铺相连的格局，西大街一带的票号则把这里接进更远的金融网络。程砚和哥哥程岳在一条灰砖巷里合开布店，银箱放在柜台下，总账一直由两人轮流记。母亲病重那天，北京供货商的一笔货款也到了约定日。程岳照旧把银锭一块块装进木箱，打算亲自护送。他知道票号可以汇兑，却认定家里的银两要由家里人的眼睛一路看着，责任才没有被稀释。程砚听见里屋母亲咳嗽，忽然看清了这个旧办法的另一面：钱要移动，人的身体也被迫跟着移动。',
    '他把银两送到票号柜台，核对金额后拿到汇票。同行带走的只是一张信用凭证；到了北京，分号验票后再兑付现银。平遥的票号网络把“运一箱银子”改成了“让一张可核验的纸跨城”，于是程砚可以留下。可程岳把这种选择理解成弟弟不再愿意共同承担原来的风险。他没有砸银箱，也没有吵闹，只把自己的账本、店章和下一批货单移到另一张柜台。程砚把票号收据夹进自己的新账册，回到母亲屋里。货款的路径变轻了，兄弟之间的距离反而第一次有了看得见的位置。',
  ],
  7: <String>[
    '清末，平遥古城的城墙、街巷、店铺和院落构成一座仍在运转的县城，而票号把这座内陆城市与远方商路连成一张金融网络。程砚和哥哥程岳在灰砖巷里合开布店，多年来共用银箱、店章和总账。母亲病重那天，北京供货商的一笔货款同时到期。程岳把银锭装箱，准备沿旧办法亲自押送。他并不否认汇兑已经普遍可见，只是坚持认为，家里的钱若不由家里人守着走完全程，出了差错便没人能说自己真正尽过责任。程砚听见母亲在里屋呼吸不稳，第一次意识到，这种“可靠”其实把责任绑在了某个人必须离开的身体上。程岳把这种做法看成兄弟共同担责。',
    '程砚把银两送进票号。柜台核清金额，开出写明异地兑付关系的汇票；同行带走信用凭证，北京分号验票后支付现银。票号并没有取消风险，而是用分号、账簿和可核验票据重新组织信任，使整箱银两不必长途搬运。程砚因此留在平遥，也承担了另一种不可转移的代价。程岳看着薄纸装进信封，随后把自己的账本、店章和下一批货单移到另一张柜台，说以后两边各自结算。程砚没有追出去。他把票号收据夹进新账册，转身走回母亲屋里。银子没有上路，信用去了远方；兄弟原来共用的那本账，却停在了这一天。',
  ],
  8: <String>[
    '清末的平遥古城，一边保持着城墙、街巷、商铺、民居与寺庙组成的传统县城肌理，一边又因票号业成为全国性的金融节点。程砚和哥哥程岳在西大街旁的灰砖巷里合开一家布店，十多年共用银箱、店章和总账。母亲病重那天，北京供货商的一笔货款也到期。程岳照旧把银锭装箱，准备亲自护送。他知道票号早已经营异地汇兑，却仍把“亲手看住银子”理解成兄弟共同承担责任的证明。程砚听见里屋母亲叫了一声，手停在箱扣上。他突然明白，旧办法把金钱的移动和人的离开绑在一起；只要银箱必须由家里人守着跨城，他们就总得在远方付款和近处照料之间牺牲一个位置。程砚没有试图说服哥哥相信一切都安全，只决定换一种承担方式。他把银两存进票号，核对金额和兑付地点，拿到汇票，再托熟识同行将信用凭证带往北京。分号验票后可以兑付现银，长途移动的从沉重银箱变成一张能被核验、入账和结算的票据。票号没有把信任变成抽象口号，而是把它分配给柜台、账本、分号和凭证。',
    '程砚因此留在母亲身边。程岳却把这个选择理解成弟弟退出了他们原来的风险共同体。他没有争吵，只把自己的账本、店章和下一批货单移到另一张柜台。程砚看着两本账之间空出的木纹，把票号收据夹进自己的账册，转身回到里屋。远方的货款仍会被兑付，近处的兄弟却不再共享同一本账；银子没有上路的那天，家里第一次出现了一条比商路更短、也更难跨过的距离。',
  ],
  9: <String>[
    '清末的平遥古城保存着城墙、街巷、店铺、民居与寺庙共同构成的传统县城肌理，同时又因票号与异地汇兑成为十九世纪中国重要的金融中心。程砚和哥哥程岳在西大街旁的灰砖巷里合开布店，十多年共用银箱、店章、客户名册和总账。母亲病重那天，北京供货商的一笔货款也到期。程岳仍按旧办法把银锭装入木箱，打算亲自护送。他当然见过票号的汇票，也知道远方分号可以兑付，却坚持认为：兄弟若不亲手看着自家银两走完全程，责任便被交给了陌生人的信用。程砚听见里屋母亲的咳声，突然意识到，哥哥守护的不只是一箱钱，也是他们长期用身体承担风险的关系方式。旧办法让“谁跟银箱走”成为忠诚的证明；现在真正逼近他的，不是如何找到更快的运输，而是要不要接受一种不再需要兄弟身体全程在场的信任结构。程砚把银两存入票号，核清数目和兑付地点，拿到汇票，托熟识同行带往北京。分号验票后再兑付现银，整箱银两无需跨过漫长商路。票号把信用拆进票据、账本、分号和核验程序，让价值可以异地结算，而一个人的身体可以留在原地。这个机制替程砚保住了陪伴母亲的时间，却没有替他免除私人关系的成本。',
    '程岳没有阻止汇票离开，也没有指责票号不可靠。他只是把自己的账本、店章和下一批货单移到另一张柜台，说今后的生意各自结算。那一刻，程砚才明白哥哥真正失去的，是“风险必须一起背”的旧证明。程砚没有追出去解释，也没有用远方即将兑付的货款证明自己正确。他把票号收据夹进新账册，走回母亲屋里。院外的街声仍沿着古城商路移动，柜台下的银箱却没有出城。钱通过信用去了远方，程砚留在了近处；兄弟之间原来没有名字的共同责任，也第一次被分成两本账。',
  ],
  10: <String>[
    '清末的平遥古城仍保有城墙、街巷、店铺、民居与寺庙相互咬合的县城肌理，却又因票号和异地汇兑成为全国金融网络的重要节点。程砚与哥哥程岳在西大街旁的灰砖巷里合开布店，十多年共用银箱、店章、客户名册和一本总账。母亲病重那天，北京供货商的一笔货款恰好到期。程岳把银锭逐块装进木箱，仍准备亲自护送北上。他当然知道票号，也见过汇票，却坚持认为家里的银两若不由家里人的眼睛守完全程，责任就被交给了一群看不见的人。程砚听见里屋母亲的咳声，手停在箱扣上。他忽然看清，哥哥维护的不只是旧结算办法，而是一套用身体证明亲属责任的方式：谁跟着银箱走，谁就显得更肯承担；谁留下，哪怕有制度接住货款，也可能被理解成退后一步。平遥的金融变化于是直接压进他们的关系里。程砚没有声称票号能消灭风险。他走到票号柜台，把银两存入，逐项核对金额与兑付地点，拿到一张汇票，再托熟识同行带往北京。到了异地，分号验票后才会兑付现银。长途移动的不再是整箱银两，而是一张可以被核验、入账、结算的信用凭证。票号把过去集中在押运者身体上的风险，重新分配给票据、账本、分号与核验程序；它改变的是“价值怎样移动”，也因此改变“谁必须离开”。程砚选择让信用上路，让自己留下。',
    '程岳没有阻拦这笔汇兑。他站在柜台另一边，看着薄薄的汇票装进信封，然后把自己的账本、店章和下一批货单收进包里。他说以后两边各自结算，声音不高，也没有再讨论谁对谁错。程砚这才明白，制度可以替一箱银两跨过距离，却不能替两个人决定新的关系该怎样开始。货款若在北京顺利兑付，只能证明这套金融机制完成了它的工作；它不能自动把哥哥的信任一起兑回来。程砚没有追到街上，也没有用结果逼哥哥承认自己正确。他把票号收据夹进新账册，锁好柜台下那只没有出城的银箱，转身回到母亲屋里。门外，古城的商路仍通向远方；门内，两本账安静地分开。',
  ],
};
final _englishByLevel = <int,List<String>>{
  1: <String>[
    'In late-Qing Pingyao, fictional brothers Cheng Yan and Cheng Yue run a small cloth shop. Their mother is ill and a payment must reach Beijing. Cheng Yan uses a draft bank remittance so the silver chest and he can remain in Pingyao, but Cheng Yue separates their shared accounts.',
  ],
  2: <String>[
    'Late-Qing Pingyao’s draft banks can remit money across regions. Cheng Yan chooses a draft instead of personally escorting silver so he can stay with his sick mother; his brother responds by moving his ledger to another counter.',
  ],
  3: <String>[
    'In late-Qing Pingyao, Cheng Yan and Cheng Yue face a due payment while their mother is seriously ill. Cheng Yue prepares to escort silver north and sees that bodily escort as shared responsibility, while Cheng Yan refuses to prepare for departure.',
    'Cheng Yan deposits the silver at a draft bank and receives a remittance draft. A trusted同行 carries the credit instrument to Beijing for branch verification and payment. The silver chest stays in Pingyao, but the brothers’ business splits into two ledgers.',
  ],
  4: <String>[
    'Draft banks are established businesses in late-Qing Pingyao. Cheng Yan and Cheng Yue share a cloth shop, chest, and ledger until their mother becomes seriously ill on the same day a Beijing payment falls due. Cheng Yue treats personal escort of the silver as family responsibility.',
    'Cheng Yan deposits the silver at a draft bank, receives a draft, and asks a known fellow merchant to carry it to Beijing for branch payment. The remittance keeps the payment moving without the silver chest, but Cheng Yue separates his ledger and seal from the shared counter.',
  ],
  5: <String>[
    'On a late-Qing day in Pingyao, the brothers’ sick mother and a due Beijing payment force a choice. Cheng Yue knows draft banks can remit funds but still sees bodily custody of the silver as proof of family responsibility. Cheng Yan realizes that this old method requires one brother to leave.',
    'Cheng Yan deposits the silver and sends a draft through the branch network. The silver itself does not travel, yet value and credit cross distance. Cheng Yue separates his ledger and seal. Cheng Yan stays with their mother, while the payment path and the brothers’ relationship end in different states.',
  ],
  6: <String>[
    'Pingyao’s county-town fabric and its draft-bank network coexist in the late Qing. The brothers’ shared shop has long relied on one cash chest and one ledger. Their mother’s illness reveals that physically escorting silver also determines whose body must leave home.',
    'At the draft-bank counter, Cheng Yan deposits silver and receives a draft for branch payment in Beijing. Verification, ledgers, and branches reorganize trust rather than abolish risk. He stays, but Cheng Yue moves his ledger, seal, and next order to another counter, making the private cost visible.',
  ],
  7: <String>[
    'Late-Qing Pingyao links a living county town to a wide financial network. Cheng Yue insists that responsibility means a family member personally escorts the silver, while Cheng Yan recognizes that this also binds financial movement to bodily absence at home; Cheng Yue treats that escort itself as the brothers’ shared responsibility.',
    'Cheng Yan uses remittance: silver is deposited in Pingyao, a credit instrument travels, and a Beijing branch verifies it before paying silver. The institutional network lets him remain with their mother, but Cheng Yue interprets this as leaving their old shared-risk relationship and splits the business accounts.',
  ],
  8: <String>[
    'Late-Qing Pingyao preserves a dense county-town fabric while its draft banks connect distant commercial routes. Fictional brothers Cheng Yan and Cheng Yue have shared a cloth shop, chest, seal, and ledger for years. When their mother becomes ill on the day a Beijing payment falls due, Cheng Yue prepares to escort silver personally because bodily custody has become his proof of shared responsibility. Cheng Yan sees that this practice binds the movement of money to the departure of a person. He deposits the silver at a draft bank, verifies the amount and destination, receives a draft, and has a known同行 carry the credit instrument to Beijing. Branch verification and settlement allow the value to move without the heavy silver chest. The network does not make risk disappear; it redistributes trust among documents, ledgers, counters, and branches.',
    'Cheng Yan can stay with their mother, but Cheng Yue sees the choice as withdrawal from their old risk-sharing relationship and separates his ledger, seal, and orders. The remote payment can still be settled, yet the nearby brothers no longer share one set of accounts.',
  ],
  9: <String>[
    'Late-Qing Pingyao is both an exceptionally preserved county town and a major nineteenth-century financial centre. Fictional brothers Cheng Yan and Cheng Yue have run one cloth shop with a shared chest, seal, customer list, and ledger. Their mother’s illness coincides with a due Beijing payment. Cheng Yue knows draft-bank remittance exists, but he treats a family member’s physical escort of the silver as proof that responsibility has not been delegated to strangers. Cheng Yan recognizes that the dispute is therefore not simply about transport efficiency. Their old arrangement makes bodily presence on the commercial road into a test of kinship responsibility, while his mother’s illness gives bodily presence at home a competing meaning. Cheng Yan deposits the silver at a draft bank, confirms the amount and destination, receives a draft, and asks a known fellow merchant to carry it to Beijing. After branch verification, silver can be paid there without the original chest crossing the long road. The system divides trust among the negotiable document, ledgers, branch offices, and verification procedures, allowing value to travel while Cheng Yan stays. The mechanism protects his time with their mother but cannot remove the private cost.',
    'Cheng Yue moves his ledger, seal, and next orders to another counter. Cheng Yan does not use successful settlement as a weapon. He files the receipt in a new ledger and goes back inside; the money travels through credit, while their formerly unnamed shared responsibility becomes two accounts.',
  ],
  10: <String>[
    'Late-Qing Pingyao retains a county-town fabric of walls, streets, shops, dwellings, and temples, while draft banks and interregional remittance make it an important node in a national financial network. Fictional brothers Cheng Yan and Cheng Yue have run a cloth shop beside West Street for more than a decade, sharing a silver chest, shop seal, customer list, and one ledger. On the day their mother becomes seriously ill, a payment to a Beijing supplier also falls due. Cheng Yue prepares to escort the silver himself. He knows the draft banks and has seen remittance drafts, yet still believes that if family silver is not watched throughout the journey by family eyes, responsibility has been transferred to people who cannot be seen. Cheng Yan hears their mother cough and realizes that the older practice is also a relationship rule: whoever accompanies the chest appears more willing to bear the family’s risk, while whoever remains may be judged as stepping back even when an institution carries the payment. Pingyao’s financial mechanism therefore presses directly into the brothers’ private bond. Cheng Yan does not claim that draft banks eliminate risk. He deposits the silver, checks the amount and place of payment, receives a draft, and sends the credit instrument with a known fellow merchant. At the destination, a branch verifies the draft before paying silver. What moves over the long route is no longer the entire chest but a verifiable instrument that can be entered and settled in linked accounts. The network redistributes risk and trust among document, ledger, branch, and verification. It changes how value moves, and therefore who must leave. Cheng Yan chooses to let credit travel while he stays.',
    'Cheng Yue does not stop the remittance. He watches the draft go into an envelope, then packs his ledger, seal, and next orders, saying that the two sides will settle separately from now on. Cheng Yan understands that an institution can bridge the distance for silver but cannot decide how a damaged relationship should begin again. Even successful payment in Beijing can prove only that the financial mechanism worked; it cannot automatically redeem his brother’s trust. Cheng Yan files the receipt in a new ledger, locks the unused chest under the counter, and returns to their mother’s room. Outside, Pingyao’s commercial roads still reach far away; inside, two ledgers rest apart.',
  ],
};
final _vietnameseByLevel = <int,List<String>>{
  1: <String>[
    'Cuối thời Thanh ở Bình Dao, hai anh em hư cấu Trình Nghiên và Trình Nhạc cùng mở tiệm vải. Mẹ đang bệnh và một khoản tiền phải đến Bắc Kinh. Trình Nghiên dùng phiếu hiệu để chuyển tiền, nhờ vậy hòm bạc và anh đều ở lại Bình Dao, nhưng người anh tách sổ chung.',
  ],
  2: <String>[
    'Các phiếu hiệu ở Bình Dao cuối Thanh có thể chuyển tiền liên vùng. Trình Nghiên chọn hối phiếu thay vì tự áp tải bạc để ở lại với mẹ bệnh; người anh chuyển sổ của mình sang quầy khác.',
  ],
  3: <String>[
    'Ở Bình Dao cuối Thanh, mẹ bệnh nặng đúng lúc khoản thanh toán Bắc Kinh đến hạn. Trình Nhạc chuẩn bị áp tải bạc lên phía bắc và xem đó là cách hai anh em cùng gánh trách nhiệm, còn Trình Nghiên không thu xếp hành lý.',
    'Trình Nghiên gửi bạc vào phiếu hiệu và nhận hối phiếu. Một người bạn buôn mang chứng từ tín dụng đến Bắc Kinh để chi nhánh kiểm tra rồi chi trả. Hòm bạc ở lại Bình Dao, nhưng việc làm ăn của hai anh em tách thành hai sổ.',
  ],
  4: <String>[
    'Phiếu hiệu đã là hoạt động trưởng thành ở Bình Dao cuối Thanh. Hai anh em dùng chung tiệm, hòm bạc và sổ cái cho đến khi mẹ bệnh nặng đúng ngày khoản tiền Bắc Kinh đến hạn.',
    'Trình Nghiên gửi bạc vào phiếu hiệu, nhận hối phiếu và nhờ người quen mang đến Bắc Kinh để chi nhánh chi trả. Dòng tiền tiếp tục mà hòm bạc không đi, nhưng Trình Nhạc tách sổ và con dấu khỏi quầy chung.',
  ],
  5: <String>[
    'Một ngày cuối Thanh ở Bình Dao, mẹ bệnh và khoản tiền Bắc Kinh cùng ép hai anh em phải chọn. Trình Nhạc biết có chuyển tiền nhưng vẫn xem việc tự giữ bạc là bằng chứng trách nhiệm gia đình. Trình Nghiên nhận ra cách cũ luôn buộc một người phải rời nhà.',
    'Trình Nghiên gửi bạc và để hối phiếu đi qua mạng lưới chi nhánh. Bạc không lên đường nhưng giá trị và tín dụng vượt khoảng cách. Trình Nhạc tách sổ và con dấu. Trình Nghiên ở lại với mẹ, còn khoản tiền và quan hệ anh em đi tới hai kết quả khác nhau.',
  ],
  6: <String>[
    'Cấu trúc huyện thành Bình Dao và mạng phiếu hiệu cùng tồn tại cuối Thanh. Tiệm của hai anh em lâu nay dùng chung hòm bạc và sổ cái. Bệnh của mẹ làm lộ ra rằng áp tải bạc cũng quyết định ai phải rời nhà.',
    'Tại quầy phiếu hiệu, Trình Nghiên gửi bạc và nhận hối phiếu để chi nhánh Bắc Kinh chi trả. Kiểm tra, sổ sách và chi nhánh tổ chức lại niềm tin chứ không xóa rủi ro. Anh ở lại, nhưng Trình Nhạc chuyển sổ, con dấu và đơn hàng sang quầy khác.',
  ],
  7: <String>[
    'Bình Dao cuối Thanh nối một huyện thành sống động với mạng tài chính xa. Trình Nhạc cho rằng trách nhiệm là người nhà tự áp tải bạc; Trình Nghiên thấy điều đó cũng trói dòng tiền với sự vắng mặt ở nhà; Trình Nhạc xem chính việc áp tải ấy là cách hai anh em cùng gánh trách nhiệm.',
    'Trình Nghiên dùng chuyển tiền: bạc gửi ở Bình Dao, chứng từ tín dụng đi xa và chi nhánh Bắc Kinh kiểm tra trước khi chi trả. Mạng lưới cho anh ở lại với mẹ, nhưng Trình Nhạc hiểu đó là rời khỏi quan hệ cùng gánh rủi ro cũ và tách sổ.',
  ],
  8: <String>[
    'Bình Dao cuối Thanh vừa giữ cấu trúc huyện thành vừa dùng phiếu hiệu nối các tuyến buôn xa. Hai anh em hư cấu đã nhiều năm dùng chung tiệm, hòm bạc, con dấu và sổ. Khi mẹ bệnh đúng ngày khoản tiền Bắc Kinh đến hạn, Trình Nhạc muốn tự áp tải vì việc giữ bạc bằng thân mình đã trở thành bằng chứng trách nhiệm. Trình Nghiên thấy cách này buộc dòng tiền gắn với sự rời đi của một người. Anh gửi bạc vào phiếu hiệu, kiểm tra số tiền và nơi chi trả, nhận hối phiếu rồi nhờ người quen mang chứng từ tới Bắc Kinh. Việc kiểm tra tại chi nhánh cho phép giá trị đi xa mà hòm bạc nặng không phải di chuyển. Mạng lưới không làm rủi ro biến mất; nó phân bổ niềm tin cho chứng từ, sổ sách, quầy và chi nhánh.',
    'Trình Nghiên ở lại với mẹ, nhưng Trình Nhạc xem lựa chọn này là rời khỏi cách cùng gánh rủi ro cũ và tách sổ, dấu, đơn hàng. Khoản tiền xa vẫn có thể được thanh toán, còn hai anh em gần nhau không còn dùng chung một bộ sổ.',
  ],
  9: <String>[
    'Bình Dao cuối Thanh vừa là huyện thành được bảo tồn vừa là trung tâm tài chính quan trọng thế kỷ XIX. Hai anh em hư cấu dùng chung hòm bạc, con dấu, danh sách khách và sổ. Trình Nhạc biết về chuyển tiền nhưng vẫn coi tự áp tải bạc là bằng chứng trách nhiệm. Trình Nghiên nhận ra tranh chấp không chỉ là hiệu suất vận chuyển: cách cũ biến sự có mặt trên đường buôn thành thước đo nghĩa vụ gia đình, trong khi mẹ bệnh khiến sự có mặt ở nhà có ý nghĩa khác. Anh gửi bạc vào phiếu hiệu, xác nhận số tiền và nơi chi trả, nhận hối phiếu rồi nhờ người quen mang tới Bắc Kinh. Chi nhánh kiểm tra trước khi chi bạc. Niềm tin được chia cho chứng từ, sổ, chi nhánh và quy trình, cho phép giá trị đi mà anh ở lại. Cơ chế giữ thời gian bên mẹ nhưng không xóa chi phí riêng tư.',
    'Trình Nhạc chuyển sổ và con dấu sang quầy khác; Trình Nghiên không dùng kết quả thanh toán để ép anh trai thừa nhận mình đúng. Tiền đi bằng tín dụng, còn trách nhiệm chung cũ trở thành hai bộ sổ.',
  ],
  10: <String>[
    'Bình Dao cuối Thanh giữ cấu trúc huyện thành gồm tường, phố, cửa hàng, nhà ở và đền chùa, đồng thời phiếu hiệu và chuyển tiền liên vùng biến nơi đây thành nút quan trọng của mạng tài chính. Hai anh em hư cấu Trình Nghiên và Trình Nhạc đã hơn mười năm dùng chung hòm bạc, con dấu, danh sách khách và sổ cái. Khi mẹ bệnh nặng đúng ngày khoản tiền Bắc Kinh đến hạn, Trình Nhạc vẫn muốn tự áp tải. Anh biết phiếu hiệu nhưng xem việc người nhà trông bạc suốt đường là bằng chứng trách nhiệm. Trình Nghiên nhận ra tập quán này cũng là quy tắc quan hệ: người đi theo hòm bạc dễ được xem là người gánh rủi ro nhiều hơn. Cơ chế tài chính của Bình Dao vì thế ép thẳng vào quan hệ riêng. Trình Nghiên không nói phiếu hiệu xóa được rủi ro. Anh gửi bạc, kiểm tra số tiền và nơi chi trả, nhận hối phiếu rồi để người buôn quen mang chứng từ đi. Chi nhánh ở nơi đến kiểm tra trước khi chi bạc. Trên đường dài, thứ di chuyển không còn là cả hòm bạc mà là chứng từ có thể kiểm tra, ghi sổ và kết toán. Mạng lưới phân bổ rủi ro và niềm tin cho chứng từ, sổ, chi nhánh và kiểm tra; nó thay đổi cách giá trị di chuyển và vì thế thay đổi ai phải rời đi. Trình Nghiên chọn để tín dụng lên đường còn mình ở lại.',
    'Trình Nhạc không ngăn giao dịch, nhưng thu sổ, con dấu và đơn hàng, nói từ nay hai bên tự kết toán. Trình Nghiên hiểu một thể chế có thể nối khoảng cách cho bạc nhưng không quyết định quan hệ bị tổn thương sẽ bắt đầu lại thế nào. Khoản tiền Bắc Kinh dù thanh toán thành công cũng chỉ chứng minh cơ chế tài chính hoạt động, không tự đổi lại lòng tin của anh trai. Anh kẹp biên nhận vào sổ mới, khóa hòm bạc chưa rời thành rồi trở về phòng mẹ. Ngoài cửa, đường buôn vẫn đi xa; trong cửa, hai cuốn sổ nằm tách nhau.',
  ],
};
const pingyaoAncientCityWords = <WordEntry>[
  WordEntry(word:'票号',pinyin:'piàohào',partOfSpeech:'名词',simpleChinese:'旧时经营异地汇兑、存放款等业务的金融商号。',translation:'Hiệu tài chính cổ chuyên chuyển tiền liên vùng.',englishDefinition:'historic draft bank',symbol:'🏦'),
  WordEntry(word:'汇票',pinyin:'huìpiào',partOfSpeech:'名词',simpleChinese:'用于异地结算的信用票据。',translation:'Hối phiếu dùng để thanh toán liên vùng.',englishDefinition:'remittance draft',symbol:'📜'),
  WordEntry(word:'银两',pinyin:'yínliǎng',partOfSpeech:'名词',simpleChinese:'故事时代用于结算的白银货币。',translation:'Bạc dùng làm tiền thanh toán trong bối cảnh lịch sử.',englishDefinition:'silver currency',symbol:'🪙'),
  WordEntry(word:'汇兑',pinyin:'huìduì',partOfSpeech:'名词',simpleChinese:'通过金融机构把价值在异地结算。',translation:'Chuyển tiền và thanh toán giữa các nơi.',englishDefinition:'interregional remittance',symbol:'🔁'),
  WordEntry(word:'分号',pinyin:'fēnhào',partOfSpeech:'名词',simpleChinese:'商号在外地设立的分支机构。',translation:'Chi nhánh của một thương hiệu ở nơi khác.',englishDefinition:'branch office',symbol:'🏪'),
  WordEntry(word:'账本',pinyin:'zhàngběn',partOfSpeech:'名词',simpleChinese:'记录收支与交易的册子。',translation:'Sổ ghi thu chi và giao dịch.',englishDefinition:'ledger',symbol:'📒'),
  WordEntry(word:'信用',pinyin:'xìnyòng',partOfSpeech:'名词',simpleChinese:'使别人愿意相信承诺可以兑现的可靠关系。',translation:'Uy tín và quan hệ đáng tin giúp cam kết được thực hiện.',englishDefinition:'credit and trust',symbol:'🤝'),
  WordEntry(word:'核验',pinyin:'héyàn',partOfSpeech:'动词',simpleChinese:'检查票据、金额或信息是否真实相符。',translation:'Kiểm tra chứng từ và thông tin có khớp, có thật hay không.',englishDefinition:'to verify',symbol:'🔍'),
  WordEntry(word:'兑付',pinyin:'duìfù',partOfSpeech:'动词',simpleChinese:'按票据或约定支付相应款项。',translation:'Chi trả tiền theo chứng từ hoặc thỏa thuận.',englishDefinition:'to redeem or pay',symbol:'💱'),
  WordEntry(word:'柜台',pinyin:'guìtái',partOfSpeech:'名词',simpleChinese:'商店或票号办理业务的台面。',translation:'Quầy giao dịch trong cửa hàng hoặc phiếu hiệu.',englishDefinition:'service counter',symbol:'🧾'),
  WordEntry(word:'印记',pinyin:'yìnjì',partOfSpeech:'名词',simpleChinese:'用于识别或确认文件的印章痕迹。',translation:'Dấu dùng để nhận biết hoặc xác nhận giấy tờ.',englishDefinition:'seal mark',symbol:'🔖'),
  WordEntry(word:'异地',pinyin:'yìdì',partOfSpeech:'名词',simpleChinese:'与当前所在地不同的地方。',translation:'Một nơi khác với nơi hiện tại.',englishDefinition:'another location',symbol:'🧭'),
  WordEntry(word:'商路',pinyin:'shānglù',partOfSpeech:'名词',simpleChinese:'商人和货物往来的路线。',translation:'Tuyến đường thương mại.',englishDefinition:'trade route',symbol:'🛤️'),
  WordEntry(word:'风险',pinyin:'fēngxiǎn',partOfSpeech:'名词',simpleChinese:'可能造成损失或失败的不确定性。',translation:'Rủi ro có thể gây mất mát hoặc thất bại.',englishDefinition:'risk',symbol:'⚠️'),
  WordEntry(word:'信任',pinyin:'xìnrèn',partOfSpeech:'名词',simpleChinese:'愿意把责任交给某人或某种制度的判断。',translation:'Sự tin cậy khi giao trách nhiệm cho người hay thể chế.',englishDefinition:'trust',symbol:'🫱🏻‍🫲🏽'),
  WordEntry(word:'结算',pinyin:'jiésuàn',partOfSpeech:'动词',simpleChinese:'核对交易并完成应付金额。',translation:'Đối chiếu giao dịch và hoàn tất số tiền phải trả.',englishDefinition:'to settle accounts',symbol:'🧮'),
];
final _discoveriesByLevel = <int,List<DiscoveryEntry>>{
  1: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'平遥古城不是单独一座建筑，而是城墙、街巷、店铺、民居和寺庙共同保存下来的传统县城。',
      pinyin:PinyinHelper.getPinyinE('平遥古城不是单独一座建筑，而是城墙、街巷、店铺、民居和寺庙共同保存下来的传统县城。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'古城保存的是一整套城市格局。',vietnamese:'Phố cổ Bình Dao bảo tồn cả một cấu trúc huyện thành, không chỉ một công trình.',english:'Pingyao preserves an integrated county-town fabric, not a single monument.',
    ),
    DiscoveryEntry(
      text:'十九世纪到二十世纪初，平遥是中国重要的金融中心，票号和汇兑相关建筑是世界遗产价值的一部分。',
      pinyin:PinyinHelper.getPinyinE('十九世纪到二十世纪初，平遥是中国重要的金融中心，票号和汇兑相关建筑是世界遗产价值的一部分。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'平遥曾是全国重要金融中心。',vietnamese:'Thế kỷ XIX đến đầu XX, Bình Dao là một trung tâm tài chính quan trọng của Trung Quốc.',english:'Pingyao was a major Chinese financial centre in the nineteenth and early twentieth centuries.',
    ),
  ],
  2: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'票号主要经营异地汇兑等金融业务，使商人不必把大批现银一路搬到远方。',
      pinyin:PinyinHelper.getPinyinE('票号主要经营异地汇兑等金融业务，使商人不必把大批现银一路搬到远方。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'票号能把钱转到异地。',vietnamese:'Phiếu hiệu làm chuyển tiền liên vùng, giảm việc phải chở nhiều bạc đi xa.',english:'Draft banks handled interregional remittance, reducing the need to transport large amounts of silver.',
    ),
    DiscoveryEntry(
      text:'汇兑改变的是结算方式：价值可以通过汇票和分号网络到达异地，原来的银箱不必走同一条路。',
      pinyin:PinyinHelper.getPinyinE('汇兑改变的是结算方式：价值可以通过汇票和分号网络到达异地，原来的银箱不必走同一条路。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'价值能走，银箱不一定走。',vietnamese:'Chuyển tiền cho phép giá trị đến nơi khác qua hối phiếu và chi nhánh mà hòm bạc ban đầu không phải đi cùng.',english:'Remittance lets value reach another place through drafts and branches without the original silver chest taking the same journey.',
    ),
  ],
  3: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'国家保密局资料记载，平遥日升昌票号创立于清道光三年，也就是1823年，并以异地汇兑为重要业务。',
      pinyin:PinyinHelper.getPinyinE('国家保密局资料记载，平遥日升昌票号创立于清道光三年，也就是1823年，并以异地汇兑为重要业务。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'1823年，日升昌在平遥创立。',vietnamese:'Tài liệu của cơ quan bảo mật nhà nước ghi nhận Nhật Thăng Xương được lập ở Bình Dao năm 1823 và kinh doanh chuyển tiền liên vùng.',english:'A State Secrets Administration source records Rishengchang as founded in Pingyao in 1823 with interregional remittance as a core business.',
    ),
    DiscoveryEntry(
      text:'汇票到达异地分号后，需要经过核验才兑付现银；这说明信用凭证并不是一句口头承诺。',
      pinyin:PinyinHelper.getPinyinE('汇票到达异地分号后，需要经过核验才兑付现银；这说明信用凭证并不是一句口头承诺。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'分号先验票，再兑付。',vietnamese:'Tại chi nhánh nơi đến, hối phiếu phải được kiểm tra trước khi bạc được chi trả.',english:'At the destination branch, the draft was verified before silver was paid, so the credit instrument was more than a verbal promise.',
    ),
  ],
  4: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'平遥古城的近四千处传统店铺和民居，是十九世纪商业繁荣留下的物质见证。',
      pinyin:PinyinHelper.getPinyinE('平遥古城的近四千处传统店铺和民居，是十九世纪商业繁荣留下的物质见证。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'店铺和民居也能记录金融历史。',vietnamese:'Gần bốn nghìn cửa hàng và nhà ở truyền thống là chứng tích vật chất của thời kỳ thương mại thịnh vượng.',english:'Nearly four thousand traditional shops and dwellings materially witness Pingyao’s commercial prosperity.',
    ),
    DiscoveryEntry(
      text:'故事里的程砚、程岳、母亲和布店都是虚构人物与私人事件；票号、汇兑、分号核验和古城金融地位来自可核查资料。',
      pinyin:PinyinHelper.getPinyinE('故事里的程砚、程岳、母亲和布店都是虚构人物与私人事件；票号、汇兑、分号核验和古城金融地位来自可核查资料。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'人物可以虚构，历史机制不能乱编。',vietnamese:'Nhân vật và sự việc gia đình là hư cấu; cơ chế phiếu hiệu và vị thế tài chính của Bình Dao dựa trên nguồn kiểm chứng được.',english:'The characters and family events are fictional, while the draft-bank mechanism and Pingyao’s financial role are source-grounded.',
    ),
  ],
  5: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'票号把原来集中在长途押运现银上的一部分风险，改由汇票、账簿、分号和核验程序共同管理。',
      pinyin:PinyinHelper.getPinyinE('票号把原来集中在长途押运现银上的一部分风险，改由汇票、账簿、分号和核验程序共同管理。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'信用需要制度和记录来支撑。',vietnamese:'Phiếu hiệu phân bổ một phần rủi ro trước đây tập trung vào việc áp tải bạc cho hối phiếu, sổ sách, chi nhánh và quy trình kiểm tra.',english:'Draft banks redistributed part of the risk of moving silver across drafts, ledgers, branches, and verification procedures.',
    ),
    DiscoveryEntry(
      text:'一张汇票很轻，但它能成立是因为背后有可识别的票据、账目与异地分号，而不是因为纸本身有价值。',
      pinyin:PinyinHelper.getPinyinE('一张汇票很轻，但它能成立是因为背后有可识别的票据、账目与异地分号，而不是因为纸本身有价值。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'纸很轻，网络和信用让它有作用。',vietnamese:'Hối phiếu nhẹ, nhưng nó có tác dụng nhờ chứng từ, sổ sách và mạng chi nhánh có thể kiểm tra.',english:'A draft is light, but its function depends on verifiable documents, accounts, and a branch network.',
    ),
    DiscoveryEntry(
      text:'平遥的金融历史让“钱怎样移动”和“人是否必须跟着移动”变成两个可以分开的事情。',
      pinyin:PinyinHelper.getPinyinE('平遥的金融历史让“钱怎样移动”和“人是否必须跟着移动”变成两个可以分开的事情。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'汇兑让钱和人的路线分开。',vietnamese:'Lịch sử tài chính Bình Dao cho phép tách câu hỏi giá trị di chuyển thế nào khỏi việc một người có phải đi theo hay không.',english:'Pingyao’s financial history separates how value moves from whether a person must physically travel with it.',
    ),
  ],
  6: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'票号的总号与分号形成跨地区经营网络，异地兑付依靠不同地点之间的账务联系。',
      pinyin:PinyinHelper.getPinyinE('票号的总号与分号形成跨地区经营网络，异地兑付依靠不同地点之间的账务联系。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'分号让异地结算成为网络。',vietnamese:'Tổng hiệu và chi nhánh tạo mạng liên vùng để thanh toán dựa trên liên kết sổ sách giữa nhiều nơi.',english:'Head offices and branches formed an interregional network whose accounts enabled settlement across locations.',
    ),
    DiscoveryEntry(
      text:'历史资料显示，票号汇票发展出水印、密押等防伪办法，说明信用扩张同时需要降低伪造风险。',
      pinyin:PinyinHelper.getPinyinE('历史资料显示，票号汇票发展出水印、密押等防伪办法，说明信用扩张同时需要降低伪造风险。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'信用越远，核验越重要。',vietnamese:'Tư liệu lịch sử ghi nhận các biện pháp chống giả như dấu chìm và mã bí mật, cho thấy tín dụng đi xa cần kiểm chứng.',english:'Historical sources record anti-counterfeit measures such as watermarks and coded checks, showing that distant credit required verification.',
    ),
    DiscoveryEntry(
      text:'平遥的银行建筑与商业街区被保留下来，使今天仍能从空间中看到金融活动曾经怎样嵌入城市生活。',
      pinyin:PinyinHelper.getPinyinE('平遥的银行建筑与商业街区被保留下来，使今天仍能从空间中看到金融活动曾经怎样嵌入城市生活。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'金融史留在街道和建筑里。',vietnamese:'Các công trình ngân hàng và phố buôn bán còn lại cho thấy hoạt động tài chính từng gắn vào đời sống đô thị.',english:'Surviving banking buildings and commercial streets show how finance was embedded in urban life.',
    ),
  ],
  7: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'异地汇兑并不等于风险消失，而是把“谁保管、谁记录、谁核验、谁兑付”的责任拆分到多个环节。',
      pinyin:PinyinHelper.getPinyinE('异地汇兑并不等于风险消失，而是把“谁保管、谁记录、谁核验、谁兑付”的责任拆分到多个环节。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'风险被重新分配，不是被取消。',vietnamese:'Chuyển tiền không xóa rủi ro mà chia trách nhiệm bảo quản, ghi sổ, kiểm tra và chi trả cho nhiều khâu.',english:'Remittance does not erase risk; it distributes custody, recording, verification, and payment across several stages.',
    ),
    DiscoveryEntry(
      text:'票号经营依赖账簿、票据与印记记录，金融网络越大，记录之间能否相互对应就越重要。',
      pinyin:PinyinHelper.getPinyinE('票号经营依赖账簿、票据与印记记录，金融网络越大，记录之间能否相互对应就越重要。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'网络扩大后，账要能对得上。',vietnamese:'Mạng càng lớn, việc sổ và chứng từ giữa các nơi khớp nhau càng quan trọng.',english:'As the network expands, the consistency of ledgers and documents across locations becomes increasingly important.',
    ),
    DiscoveryEntry(
      text:'平遥从内陆县城发展为全国金融中心，说明商业网络可以让一个地方的影响远远超过它的地理范围。',
      pinyin:PinyinHelper.getPinyinE('平遥从内陆县城发展为全国金融中心，说明商业网络可以让一个地方的影响远远超过它的地理范围。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'内陆城市也能成为全国网络节点。',vietnamese:'Việc Bình Dao trở thành trung tâm tài chính cho thấy một huyện thành nội địa có thể ảnh hưởng vượt xa phạm vi địa lý của mình.',english:'Pingyao’s rise as a financial centre shows how an inland county town can become a node with influence far beyond its geography.',
    ),
  ],
  8: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'世界遗产评价特别强调平遥与银行业相关的建筑，因为这些建筑把十九世纪的金融网络留在可以观察的城市空间中。',
      pinyin:PinyinHelper.getPinyinE('世界遗产评价特别强调平遥与银行业相关的建筑，因为这些建筑把十九世纪的金融网络留在可以观察的城市空间中。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'银行建筑把金融网络变成可见遗产。',vietnamese:'UNESCO đặc biệt nhấn mạnh các công trình ngân hàng vì chúng khiến mạng tài chính thế kỷ XIX trở thành di sản có thể quan sát.',english:'UNESCO specifically highlights banking buildings because they make the nineteenth-century financial network visible in the city.',
    ),
    DiscoveryEntry(
      text:'古城中的店铺、院落和街巷既是建筑遗产，也记录了商业活动如何与居住生活共享同一座城。',
      pinyin:PinyinHelper.getPinyinE('古城中的店铺、院落和街巷既是建筑遗产，也记录了商业活动如何与居住生活共享同一座城。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'商业和生活在同一城市结构里。',vietnamese:'Cửa hàng, sân nhà và ngõ phố vừa là di sản kiến trúc vừa ghi lại cách buôn bán và đời sống cùng tồn tại.',english:'Shops, courtyards, and lanes record how commerce and everyday life shared the same urban structure.',
    ),
    DiscoveryEntry(
      text:'从现银押运到汇票结算，关键变化不是“钱变成纸”，而是信用被放进可以跨地点核验的制度关系。',
      pinyin:PinyinHelper.getPinyinE('从现银押运到汇票结算，关键变化不是“钱变成纸”，而是信用被放进可以跨地点核验的制度关系。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'汇票代表可核验的信用关系。',vietnamese:'Thay đổi cốt lõi không phải bạc biến thành giấy, mà tín dụng được đặt vào quan hệ thể chế có thể kiểm tra giữa nhiều nơi.',english:'The key shift was not silver turning into paper, but credit being embedded in institutional relations that could be verified across places.',
    ),
  ],
  9: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'平遥票号说明，金融技术也会改变社会关系：当价值不再必须由同一个人亲自押送，人们对责任、在场和信任的理解可能重新分配。',
      pinyin:PinyinHelper.getPinyinE('平遥票号说明，金融技术也会改变社会关系：当价值不再必须由同一个人亲自押送，人们对责任、在场和信任的理解可能重新分配。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'金融机制也会改变人的责任方式。',vietnamese:'Cơ chế tài chính có thể thay đổi quan hệ xã hội khi giá trị không còn cần cùng một người tự áp tải.',english:'Financial mechanisms can reshape social relations when value no longer requires the same person to escort it.',
    ),
    DiscoveryEntry(
      text:'这种变化不能简单写成“传统落后、制度先进”。票号仍需要人、记录、核验和信用，每种方式都把风险放在不同位置。',
      pinyin:PinyinHelper.getPinyinE('这种变化不能简单写成“传统落后、制度先进”。票号仍需要人、记录、核验和信用，每种方式都把风险放在不同位置。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'新制度不是没有风险，只是组织风险的方法不同。',vietnamese:'Không nên kể thành truyền thống lạc hậu và thể chế tiên tiến; mỗi cách chỉ tổ chức rủi ro ở vị trí khác nhau.',english:'The change should not be reduced to old versus advanced: each system organizes risk differently and still depends on people and verification.',
    ),
    DiscoveryEntry(
      text:'平遥世界遗产的价值同时来自城市格局与金融历史，这使“空间”和“制度”可以在同一地点被一起阅读。',
      pinyin:PinyinHelper.getPinyinE('平遥世界遗产的价值同时来自城市格局与金融历史，这使“空间”和“制度”可以在同一地点被一起阅读。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'看古城也能读制度史。',vietnamese:'Giá trị di sản Bình Dao kết hợp bố cục đô thị với lịch sử tài chính, cho phép đọc không gian và thể chế cùng lúc.',english:'Pingyao’s heritage value joins urban form with financial history, letting visitors read space and institution together.',
    ),
  ],
  10: <DiscoveryEntry>[
    DiscoveryEntry(
      text:'平遥古城的真实性不仅在单体建筑，也在城墙、街巷、店铺、民居和寺庙之间仍然清楚的整体关系。',
      pinyin:PinyinHelper.getPinyinE('平遥古城的真实性不仅在单体建筑，也在城墙、街巷、店铺、民居和寺庙之间仍然清楚的整体关系。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'真实性也存在于建筑之间的关系。',vietnamese:'Tính xác thực nằm cả trong quan hệ còn rõ giữa tường thành, đường phố, cửa hàng, nhà ở và đền chùa.',english:'Authenticity lies not only in individual buildings but also in the surviving relationships among walls, streets, shops, dwellings, and temples.',
    ),
    DiscoveryEntry(
      text:'十九世纪的票号把平遥接入全国金融网络，而今天保存下来的银行建筑让这种看不见的信用网络获得了可见的物质证据。',
      pinyin:PinyinHelper.getPinyinE('十九世纪的票号把平遥接入全国金融网络，而今天保存下来的银行建筑让这种看不见的信用网络获得了可见的物质证据。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'建筑让过去的信用网络变得可见。',vietnamese:'Các công trình ngân hàng còn lại biến mạng tín dụng vô hình của thế kỷ XIX thành bằng chứng vật chất có thể thấy.',english:'Surviving banking buildings give visible material evidence to the otherwise invisible nineteenth-century credit network.',
    ),
    DiscoveryEntry(
      text:'把故事人物设为虚构普通人，可以让“汇兑怎样改变谁必须离开”进入私人生活，同时避免把未经证实的动机和对白强加给真实历史人物。',
      pinyin:PinyinHelper.getPinyinE('把故事人物设为虚构普通人，可以让“汇兑怎样改变谁必须离开”进入私人生活，同时避免把未经证实的动机和对白强加给真实历史人物。', separator:' ', format:PinyinFormat.WITH_TONE_MARK),
      simpleChinese:'虚构人物承受真实机制，世界仍必须真实。',vietnamese:'Nhân vật thường dân hư cấu có thể chịu áp lực của cơ chế lịch sử thật mà không gán động cơ hay lời thoại chưa được chứng minh cho người thật.',english:'Fictional ordinary people can experience a verified historical mechanism without assigning unsupported motives or dialogue to real historical figures.',
    ),
  ],
};
List<DiscoveryEntry> pingyaoDiscoveriesForLevel(int requestedLevel) => List<DiscoveryEntry>.unmodifiable(_discoveriesByLevel[requestedLevel.clamp(1,10).toInt()]!);
final pingyaoAncientCityAllDiscoveries = <DiscoveryEntry>[for (var level=1; level<=10; level++) ..._discoveriesByLevel[level]!];

const _vocabularyTargets = <int>[4,5,6,7,9,10,11,14,15,16];
JourneyLevelContent pingyaoAncientCityGoldLevelContent(int requestedLevel) {
  final level=requestedLevel.clamp(1,10).toInt();
  final paragraphs=pingyaoGoldStories[level]!;
  final english=_englishByLevel[level]!;
  final vietnamese=_vietnameseByLevel[level]!;
  final annotations=<ReadingAnnotation>[
    for (var i=0;i<paragraphs.length;i++) ReadingAnnotation(
      pinyin:PinyinHelper.getPinyinE(paragraphs[i],separator:' ',format:PinyinFormat.WITH_TONE_MARK),
      vietnamese:vietnamese[i],english:english[i],
    ),
  ];
  return JourneyLevelContent(
    storyParagraphs:List<String>.unmodifiable(paragraphs),
    storyAnnotations:List<ReadingAnnotation>.unmodifiable(annotations),
    words:List<WordEntry>.unmodifiable(pingyaoAncientCityWords.take(_vocabularyTargets[level-1])),
    discoveries:pingyaoDiscoveriesForLevel(level),
    wonderQuestion: level <= 4 ? '为什么汇票可以让银箱留在平遥？' : '票号怎样把“价值移动”和“人的移动”分开？',
    expressQuestion: level <= 4 ? '请用“银两、汇票、分号”说明程砚的选择。' : '请解释票号的信用网络为什么能改变程砚与哥哥对责任的理解。',
  );
}
final pingyaoAncientCityGoldLevels = <JourneyLevelContent>[for(var level=1;level<=10;level++) pingyaoAncientCityGoldLevelContent(level)];
const pingyaoMemory = <RemediatedMemoryReview>[
  RemediatedMemoryReview(category:'place',prompt:'平遥的什么机制让银箱不必上路？',answer:'票号用汇票、分号账务与核验完成异地汇兑，让价值跨城而原来的现银不必同路长途移动。',storyEventIds:<String>['remittance-choice']),
  RemediatedMemoryReview(category:'choice',prompt:'程砚真正选择了什么？',answer:'他让信用凭证上路，自己留下照料母亲，并接受哥哥把共同生意拆成两本账的代价。',storyEventIds:<String>['choice','cost']),
  RemediatedMemoryReview(category:'memory',prompt:'故事最后最该记住哪个画面？',answer:'汇票已经离开，银箱仍锁在柜台下，哥哥的账本却从共同柜台移走。',storyEventIds:<String>['climax','ending']),
];
const pingyaoCompletion = RemediatedCompletion(
  journeySummary:'你读懂了平遥票号怎样把异地结算变成人与关系都要承受的真实选择。',
  achievement:'你已完成《银子没有上路的那天》的 Story、Vocabulary、Discovery、Challenge 与 Memory。',
  memoryAnchor:'记住那一刻：汇票出了门，银箱没有走，两本账却分开了。',
  challengeReward:'你能区分史实机制、虚构私人事件与因果推理，并用中文解释汇兑如何改变责任。',
  journeyCompletion:'平遥古城 Journey 完成。你带走的不只是票号知识，而是“价值怎样移动，会改变谁必须在场”的问题。',
);
final pingyaoAncientCityGoldJourney = RemediatedJourney(
  id:pingyaoAncientCityJourneyId,title:pingyaoAncientCityCanonicalTitle,protagonist:'程砚',
  goal:'让北京货款完成异地结算，同时留在平遥照料病重母亲。',
  conflict:'哥哥把亲自押运银两视为共同责任证明，而程砚选择用票号汇兑让自己留下。',
  eventIds:const <String>['opening','pressure','choice','climax','cost','ending'],
  events:const <RemediatedSemanticEvent>[],
  levels:pingyaoAncientCityGoldLevels,words:pingyaoAncientCityWords,wordTraces:const <RemediatedWordTrace>[],
  discoveries:pingyaoAncientCityAllDiscoveries,discoveryTraces:const <RemediatedDiscoveryTrace>[],
  challenges:const <RemediatedChallengeTrace>[
    RemediatedChallengeTrace(type:'paragraphRebuild',storyEventIds:<String>['pressure','choice','cost'],anchor:'价值移动与身体移动分开后的因果顺序'),
    RemediatedChallengeTrace(type:'grammarRepair',storyEventIds:<String>['choice'],anchor:'汇兑、核验与关系结果中的中文结构'),
    RemediatedChallengeTrace(type:'missingSentence',storyEventIds:<String>['climax','ending'],anchor:'制度成功不等于关系自动修复'),
  ],
  memory:pingyaoMemory,completion:pingyaoCompletion,
  sources:const <RemediatedSourceBinding>[
    RemediatedSourceBinding(id:'UNESCO-PINGYAO',publisher:'UNESCO World Heritage Centre',scope:'完整县城格局；十九世纪至二十世纪初全国金融中心；银行建筑、店铺与民居的遗产价值。'),
    RemediatedSourceBinding(id:'SHANXI-PINGYAO',publisher:'山西省文化和旅游厅',scope:'平遥古城及晋商、票号相关地方文化背景；用于与UNESCO交叉核对地方叙述。'),
    RemediatedSourceBinding(id:'GJBMJ-JINSHANG-PIAOHAO',publisher:'国家保密局互联网门户网站',scope:'票号异地汇兑；汇票替代现银长途结算；日升昌1823；汇票核验、防伪与分号兑付机制。'),
  ],
);
