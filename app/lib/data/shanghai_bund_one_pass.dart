import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'shanghai_bund_level_support.dart';

const shanghaiBundJourneyId = 'shanghai-bund';

JourneyLevelContent _bundLevel(List<String> paragraphs) {
  final level = shanghaiBundLevelForParagraphs(paragraphs);
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(<ReadingAnnotation>[
      for (var i = 0; i < paragraphs.length; i++)
        shanghaiBundReadingAnnotationFor(level, i, paragraphs[i]),
    ]),
    words: const <WordEntry>[],
    discoveries: const <DiscoveryEntry>[],
    wonderQuestion: '',
    expressQuestion: '',
  );
}

final shanghaiBundOnePassLevels = List<JourneyLevelContent>.unmodifiable([
  _bundLevel([
    '林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。这个晚上，他要去浦东陆家嘴，为第二天的新工作做准备。母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。林岸说，过了黄浦江，就是离开旧上海，进入新上海。母亲没有劝他留下，只把提单递过去。两人沿江向南走，灯光落在历史建筑和水面上，船只从眼前经过。到金陵东路轮渡站时，林岸一度想把提单还给母亲，最后还是把它放进包里。轮渡离开西岸，他看见外滩慢慢退远，陆家嘴的高楼越来越近。他忽然觉得，江没有把上海分成过去和未来。船靠东岸后，他继续走向新的工作，也把那张旧单据带过了江。'
  ]),
  _bundLevel([
    '林岸二十四岁，熟悉家里的货代和报关生意。第二天，他将到陆家嘴一家金融科技公司的结算团队上班。这个晚上，他先到外滩和母亲见面。她处理货运、海关和单据，约他在海关大楼附近碰头，并带来一张外祖父留下的旧海运提单副本。林岸笑着说，自己终于要过江了，像是从旧上海走进新上海。母亲没有反驳，只问他要不要把这张提单带走。两人沿黄浦江西岸向南走，身后是外滩历史建筑，江上船只拖着灯影，东岸的陆家嘴已经亮起来。林岸几次想把旧纸还给母亲。到金陵东路轮渡站，他还是把提单放进包里。轮渡离岸后，海关大楼和沿岸建筑逐渐变小，浦东高楼越来越近。他忽然明白，江没有把上海分成过去和未来；人、货物、信息和钱一直在两岸之间换着方式流动。到东岸后，他没有改变工作选择，却带着旧单据继续走向陆家嘴。'
  ]),
  _bundLevel([
    '林岸二十四岁，从小熟悉家里的货代和报关单。第二天，他要到浦东陆家嘴一家金融科技公司的结算团队上班。傍晚，他先到外滩见母亲。她约他在海关大楼附近碰头，递来一张外祖父留下的旧海运提单副本。林岸望着对岸说，过了黄浦江，就是离开旧上海、进入新上海。母亲没有劝他留下，只问他要不要把提单带走。两人沿江向南走，历史建筑的灯光落在水面，船只从眼前经过。',
    '到金陵东路轮渡站前，林岸几次想把提单还给母亲。她只提起他小时候拿作废报关单折纸船，没有讲大道理。临上船，他还是把提单放进包里。轮渡离开西岸，外滩慢慢退远，陆家嘴越来越近。林岸忽然觉得，江没有把上海分成过去和未来。货物、文件、信用、信息和资金只是换了工具继续流动。到东岸后，他没有回去接家业，也没有放弃新工作，只带着那张普通旧单据继续走向陆家嘴。'
  ]),
  _bundLevel([
    '林岸二十四岁，家里多年做货代与报关文件。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到。他把这份工作想成一次彻底转身：从船、货物和纸张，进入账户与数字结算。傍晚，他来到外滩，在海关大楼附近见母亲。母亲刚结束一天的文件工作，递给他一张外祖父留下的旧海运提单副本。那只是一张普通商业文件。林岸望向黄浦江对岸，说自己终于要“离开旧上海，进入新上海”。母亲没有反对，只问这张纸要不要带走。两人沿滨水空间向南走，外滩历史建筑、江上船灯和东岸高楼同时进入视野。',
    '临近金陵东路轮渡站，林岸反复摸到包里的提单，觉得新公司的系统与这张旧纸毫不相干。母亲没有讲历史，只笑他小时候爱拿作废报关单折纸船。检票前，林岸最终把提单放进电脑包，独自上船。轮渡推开西岸，海关大楼和外滩灯光逐渐缩小，货船仍沿江移动，浦东天际线迎面升高。他忽然明白，江没有把上海分成过去和未来。旧单据记录货物、信用和付款责任，新系统处理更快的数据与结算，但两者都在组织流动。到东岸后，他仍选择新职业，只是不再把旧单据当成必须丢下的过去。'
  ]),
  _bundLevel([
    '林岸二十四岁，成长在一个与上海港口贸易相连的家庭。家里的货代生意不大，桌上却常有订舱资料、报关文件、提单副本和结算凭证。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队上班。他把这份工作想成一次干净的切割：西岸属于船、海关和纸张，东岸属于数据、账户和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。她刚结束文件工作，递给他一张外祖父留下的旧海运提单副本。那不是古董，只记录过一票普通货物的承运、交付和责任。林岸看着江对岸说：“过了江，我就算离开旧上海了。”母亲没有纠正，只问：“那这张纸呢？”两人沿滨水空间向南走，历史建筑、船灯和陆家嘴的高楼一起亮起来。',
    '走到金陵东路轮渡站前，林岸几次想把旧提单还给母亲。他觉得数字结算与这张纸没有关系。母亲没有劝他接班，只提起他小时候常拿作废报关单折纸船。检票前，他们在闸口分开，林岸最后把提单塞进电脑包，独自上船。轮渡离开浦西，外滩与海关钟楼渐渐退后，货船沿主航道穿行，浦东天际线越来越近。就在两岸同时进入视野的几分钟里，他忽然觉得，江没有把上海分成过去和未来。货物、文件、信用、信息、结算和资本从来不是停在一岸的东西，只是载体不断变化。抵达东昌路一侧后，他继续向陆家嘴走，仍然选择新职业，却把那张旧单据一起带了过去。'
  ]),
  _bundLevel([
    '林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母做货代与单证业务，他从小见惯订舱确认、报关资料、提单副本和结算凭证。第二天，他要到浦东陆家嘴一家金融科技公司的结算团队报到，参与更快的跨机构支付与资金交收。他把这份新工作想成一次切割：西岸留下船舶、海关和纸张，东岸属于数据、账户和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。母亲递给他一张外祖父留下的旧海运提单副本，纸面只记录一票普通货物的承运、交付与责任。林岸望向对岸，说：“明天开始，我就从旧上海走进新上海。”母亲没有阻止，只问：“换了工具，就一定要把以前的东西留在这边吗？”两人沿黄浦江西岸向南走，历史建筑、钟声、江上船灯与浦东玻璃幕墙在暮色中并列。',
    '接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。但这些知识一直只是背景。包里的旧提单碰着电脑边角，他几次想还给母亲。母亲没有讲历史，只说他小时候拿作废报关单折纸船。检票前，他们在闸口告别。林岸把提单放进电脑夹层，独自上了轮渡。船离开西岸，外滩与海关大楼慢慢后退，货船继续移动，浦东天际线逐渐抬高。他忽然意识到，江没有把上海分成过去和未来。旧提单把货物、信用、责任和付款写在纸上，新系统把关系变成数据与实时指令；城市改变的是组织流动的方式。到东岸后，他继续走向陆家嘴，旧工作留在身后，旧单据却跟着他过了江。'
  ]),
  _bundLevel([
    '林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母经营货代与单证业务，办公室里没有传奇，只有订舱确认、报关资料、提单副本和反复核对的结算数字。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到，参与跨机构支付与资金交收。他喜欢那种即时、清晰、几乎看不见纸张的方式，也把它理解成与家庭旧行业的决裂：西岸是船、海关和纸面凭证，东岸是数据、账户和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。她递给他一张外祖父留下的旧海运提单副本，只记录一票普通货物的承运、交付和责任。林岸望着黄浦江对岸亮起的陆家嘴，说：“过了江，我就算离开旧上海，进入新上海。”母亲没有反驳，只问：“你真觉得一条江能切得这么开？”两人沿滨水空间向南走，历史建筑、海关钟声、江上船灯和对岸玻璃幕墙叠在暮色里。',
    '走向金陵东路轮渡站时，林岸想起1843年的开埠发生在十九世纪不平等条约体系下，此后贸易、航运、海关、银行与商业功能经过数十年发展，不是某一夜突然完成。他懂这些，却仍觉得它们只属于过去。包里的提单碰着电脑边角，他几次想还回去。母亲没有讲课，只说他小时候会拿作废报关单折纸船。到闸口，两人分开。林岸把提单塞进电脑夹层，独自上了轮渡。船离开浦西，外滩建筑与海关钟楼慢慢后退，货船沿主航道穿行，陆家嘴天际线越来越高。距离反而让两岸同时清楚起来。他忽然觉得，江没有把上海分成过去和未来。旧单据把货物、信用、责任与付款写在纸上，新系统把这些关系变成数据、消息和实时结算；形式更新了，城市仍在重新组织人、货物、信息与资本的流动。到东岸后，他继续向陆家嘴走，不再需要先否定一岸，才能走向另一岸。'
  ]),
  _bundLevel([
    '林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母的货代和单证业务从来不浪漫：改船期、核对报关资料、追提单副本、确认运费和结算条件，都是日常。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到，参与跨机构支付与资金交收。对他而言，这份工作意味着速度、自动化和一种不必再被纸张拖住的生活。他甚至把两岸分成两个时代：西岸留下船舶、海关、银行旧楼和父母的文件柜，东岸代表数据、账户和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。她递给他一张外祖父保存下来的旧海运提单副本。纸已经发黄，却没有秘密，只记录过一票货物的承运、交付与责任。林岸望向黄浦江对岸亮起的陆家嘴，说：“明天我就算离开旧上海，进入新上海。”母亲没有阻止，只问：“你换的是工作，还是要把来路也留在这边？”两人沿滨水空间向南走，外滩历史建筑、海关钟声、船只和对岸玻璃幕墙一起被晚风推到身边。',
    '接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系中，之后贸易、航运、海关、银行和商业机构在黄浦江西岸经历了长期聚集与变化，不是一条可以被“现代化”三个字抹平的直线。包里的旧提单碰着电脑边角，他几次准备递回去。母亲没讲历史，只笑他说小时候爱拿作废报关单折纸船。到了闸口，他们在人流里告别。林岸把提单放进电脑夹层，独自上了轮渡。船离开浦西，外滩建筑和海关钟楼退成发亮的岸线，货船继续移动；浦东天际线从前方抬高。水面距离让两岸同时进入他的视野。他忽然觉得，江没有把上海分成过去和未来。旧提单以纸面记录货物、信用、责任和付款，新系统用数据、消息与实时指令组织结算；工具和速度改变，城市仍在重新安排人、货物、信息与资本怎样抵达彼此。船到东昌路一侧后，他继续向陆家嘴走，仍离开家里的旧工作，也仍期待新职业，只是回望外滩时，西岸不再是必须删除的背景。'
  ]),
  _bundLevel([
    '林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母经营货代与单证业务，日常是更改船期、核对报关资料、追提单副本、确认运费与结算条件。小时候，他只觉得文件占满餐桌；长大后，他选择了另一条路。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到，参与跨机构支付与资金交收系统。自动化的账户连接，让他相信自己终于摆脱了纸张和港口的迟缓。他把黄浦江两岸划成两个时代：西岸留下船舶、海关、银行旧楼和父母的文件柜，东岸属于数据、算法、实时结算和新的金融基础设施。傍晚，他在外滩海关大楼附近见母亲。她递给他一张外祖父留下的旧海运提单副本。那张纸没有收藏价值，也没有秘密，只记录过一票普通货物的承运、交付和责任。林岸望着对岸亮起的陆家嘴，说：“明天开始，我就算离开旧上海，进入新上海。”母亲没有劝他接班，只问：“你换的是工作，还是要把来路也留在这一岸？”他们沿外滩滨水空间向南走，历史建筑、海关钟声、江上船只与浦东玻璃幕墙，被黄浦江同时收进暮色。',
    '接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后贸易、航运、海关、银行与商业机构在外滩及周边经过数十年发展与重组，绝不是“旧城市忽然变成现代城市”的轻快故事。可他一直把这些知识留在课本里。包里的旧提单碰着电脑边角，他几次想还给母亲。母亲没有趁机讲课，只提到他小时候拿她作废的报关单折纸船。到了闸口，他们在人流中告别。林岸把提单放进电脑夹层，独自上了轮渡。船离开浦西，外滩建筑和海关钟楼退成发亮的岸线，货船沿主航道继续向前；浦东天际线从前方抬高。水面距离把两岸同时展开，他觉得自己过去那条“旧到新”的直线太窄。江没有把上海分成过去和未来。旧提单把货物、信用、责任、信息与付款写在纸上，今天的系统把它们变成数据、消息、规则和实时结算；工具改变，组织流动的需要不断重组。船到东昌路一侧后，他走向陆家嘴，没有回去接手家业，也没有怀疑新工作。他只是回头看了一眼：外滩不再是被新天际线淘汰的旧背景，陆家嘴也不再是从零开始的未来。'
  ]),
  _bundLevel([
    '林岸二十四岁，成长在一个与上海港口贸易相连的家庭。父母经营的货代与单证业务，日常是临时更改船期、反复核对报关资料、追一份提单副本、确认运费与结算条件。小时候，他嫌文件占满餐桌；读大学后，他更愿意相信“新”意味着摆脱纸面流程。第二天，他将到浦东陆家嘴一家金融科技公司的结算团队报到，参与跨机构支付与资金交收系统。自动化的账户连接，让他把新职业理解成一次彻底切割：黄浦江西岸留下船舶、海关、银行旧楼和父母的文件柜，东岸属于数据、算法、实时结算和新的金融基础设施。傍晚，他来到外滩，在海关大楼附近见母亲。她递给他一张外祖父留下的旧海运提单副本。纸面泛黄，却没有秘密，只记录过一票普通货物的承运、交付和责任。林岸望着对岸陆家嘴亮起的楼群，说：“明天开始，我就算离开旧上海，进入新上海。”母亲既没有劝他接班，也没有替旧行业辩护，只问：“你换的是工作，还是要把来路也留在这一岸？”他们沿外滩滨水空间向南走，历史建筑、海关钟声、游船和工作船的声音，以及对岸玻璃幕墙反射的夕光，被黄浦江同时收进一个移动的画面。',
    '接近金陵东路轮渡站时，林岸想起自己并非不了解脚下的城市。上海1843年的开埠发生在十九世纪不平等条约体系下，随后贸易、航运、海关、银行与商业机构在外滩及周边经历长期聚集与重组；近代城市经济不是某一天突然启动，现代浦东也没有把西岸的金融与航运历史一键清空。只是这些历史以前属于课本和展板，与他自己的未来隔着一层玻璃。包里的旧提单碰到电脑边角，他几次想把它还给母亲。母亲没有趁机讲历史，只笑着提起他小时候会拿她作废的报关单折纸船。到了闸口，他们在人流里告别。林岸最终把提单放进电脑夹层，独自上了轮渡。船离开浦西，外滩建筑与海关钟楼退成一条发亮的岸线，主航道上的货船继续前进；浦东天际线从前方抬高。水面距离让两岸同时清楚。他忽然觉得，江没有把上海分成过去和未来。旧提单把货物、信用、责任、信息与付款写在纸上，今天的系统把相似关系变成数据、消息、规则和实时结算；工具、速度和天际线改变了，城市仍在重新组织人、货物、信息与资本如何抵达彼此。船到东昌路一侧后，他继续向陆家嘴走，没有回去接手家业，也仍期待新职业。回头时，外滩不再是等待被淘汰的旧背景，陆家嘴也不再需要独占“未来”这个词。那张旧单据已经跟他一起过了江。'
  ]),
]);

WordEntry _w(
  String word,
  String pinyin,
  String pos,
  String zh,
  String vi,
  String en,
  String source,
) =>
    WordEntry(
      word: word,
      pinyin: pinyin,
      partOfSpeech: pos,
      simpleChinese: zh,
      translation: vi,
      englishDefinition: en,
      symbol: '◇',
      examples: shanghaiBundWordExamples(source),
    );

final shanghaiBundOnePassWords = List<WordEntry>.unmodifiable([
  _w('外滩', 'wàitān', '专有名词', '上海黄浦江西岸的历史滨水地区。', 'Bến Thượng Hải.', 'the Bund',
      '这个晚上，他先到外滩和母亲见面。'),
  _w('黄浦江', 'huángpǔ jiāng', '专有名词', '穿过上海中心城区的重要河流。', 'Sông Hoàng Phố.',
      'the Huangpu River', '林岸说，过了黄浦江，就是离开旧上海，进入新上海。'),
  _w('陆家嘴', 'lùjiāzuǐ', '专有名词', '浦东重要金融商务核心区。', 'Lục Gia Chủy.', 'Lujiazui',
      '第二天，他将到陆家嘴一家金融科技公司的结算团队上班。'),
  _w('海关大楼', 'hǎiguān dàlóu', '专有名词', '外滩标志性历史建筑之一。', 'Tòa nhà Hải quan.',
      'the Customs House', '母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。'),
  _w(
      '海运提单',
      'hǎiyùn tídān',
      '名词',
      '海上运输中记录承运、货物与交付关系的商业单据。',
      'Vận đơn đường biển.',
      'maritime bill of lading',
      '母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。'),
  _w('轮渡', 'lúndù', '名词', '往返黄浦江两岸的渡船交通。', 'Phà qua sông.', 'ferry',
      '轮渡离开西岸，他看见外滩慢慢退远，陆家嘴的高楼越来越近。'),
  _w('货运', 'huòyùn', '名词', '货物运输及其组织活动。', 'Vận chuyển hàng hóa.',
      'freight transport', '林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。'),
  _w('报关单', 'bàoguāndān', '名词', '办理海关申报时使用的单据。', 'Tờ khai hải quan.',
      'customs declaration', '林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。'),
  _w('结算', 'jiésuàn', '名词 / 动词', '核对并完成交易付款或账务处理。', 'Thanh toán, quyết toán.',
      'settlement', '第二天，他将到陆家嘴一家金融科技公司的结算团队上班。'),
  _w('信用', 'xìnyòng', '名词', '交易中对履约与偿付能力的信任。', 'Tín dụng.', 'credit',
      '货物、文件、信用、信息和资金只是换了工具继续流动。'),
  _w(
      '开埠',
      'kāibù',
      '动词 / 名词',
      '近代按条约制度开放为通商口岸。',
      'Mở cảng theo chế độ điều ước.',
      'treaty-port opening',
      '接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。'),
  _w(
      '不平等条约',
      'bù píngděng tiáoyuē',
      '名词',
      '十九世纪列强强加给中国、权利义务不对等的条约体系。',
      'Điều ước bất bình đẳng.',
      'unequal treaties',
      '接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。'),
]);

const shanghaiBundWordFirstAppears = <String, int>{
  '外滩': 1,
  '黄浦江': 1,
  '陆家嘴': 1,
  '海关大楼': 1,
  '海运提单': 1,
  '轮渡': 1,
  '货运': 1,
  '报关单': 1,
  '结算': 2,
  '信用': 3,
  '开埠': 6,
  '不平等条约': 6
};

const _events = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(
      id: 'BD2-E1',
      coreChinese: '林岸准备从外滩过江到陆家嘴开始新工作。',
      corePinyin: 'Lín Àn zhǔnbèi guòjiāng.',
      coreVietnamese: 'Lâm Ngạn chuẩn bị qua sông.',
      coreEnglish: 'Lin An prepares to cross the river.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
  RemediatedSemanticEvent(
      id: 'BD2-E2',
      coreChinese: '母亲把外祖父留下的旧海运提单副本交给他。',
      corePinyin: 'Mǔqīn jiāo gěi tā jiù tídān.',
      coreVietnamese: 'Mẹ đưa anh vận đơn cũ.',
      coreEnglish: 'His mother gives him the old bill of lading.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
  RemediatedSemanticEvent(
      id: 'BD2-E3',
      coreChinese: '他把过江理解成离开旧上海进入新上海。',
      corePinyin: 'Tā bǎ guòjiāng lǐjiě chéng líkāi jiù Shànghǎi.',
      coreVietnamese: 'Anh xem việc qua sông là rời Thượng Hải cũ.',
      coreEnglish: 'He treats the crossing as leaving old Shanghai.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
  RemediatedSemanticEvent(
      id: 'BD2-E4',
      coreChinese: '母子沿黄浦江滨水空间向南走。',
      corePinyin: 'Mǔzǐ yán Huángpǔ Jiāng xiàng nán zǒu.',
      coreVietnamese: 'Hai mẹ con đi dọc Hoàng Phố.',
      coreEnglish: 'Mother and son walk south along the Huangpu.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
  RemediatedSemanticEvent(
      id: 'BD2-E5',
      coreChinese: '他知道1843年开埠处于不平等条约体系下。',
      corePinyin: 'Tā zhīdào yī bā sì sān nián kāibù de lìshǐ.',
      coreVietnamese: 'Anh hiểu bối cảnh mở cảng năm 1843.',
      coreEnglish: 'He knows the 1843 treaty-port context.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
  RemediatedSemanticEvent(
      id: 'BD2-E6',
      coreChinese: '到轮渡站前他决定是否把旧提单留在西岸。',
      corePinyin: 'Tā juédìng shìfǒu liúxià jiù tídān.',
      coreVietnamese: 'Anh quyết định có để lại vận đơn hay không.',
      coreEnglish: 'He decides whether to leave the document behind.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
  RemediatedSemanticEvent(
      id: 'BD2-E7',
      coreChinese: '他选择把提单带上轮渡。',
      corePinyin: 'Tā bǎ tídān dài shàng lúndù.',
      coreVietnamese: 'Anh mang vận đơn lên phà.',
      coreEnglish: 'He carries the document onto the ferry.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
  RemediatedSemanticEvent(
      id: 'BD2-E8',
      coreChinese: '江没有把上海分成过去和未来。',
      corePinyin: 'Jiāng méiyǒu bǎ Shànghǎi fēn chéng guòqù hé wèilái.',
      coreVietnamese:
          'Con sông không chia Thượng Hải thành quá khứ và tương lai.',
      coreEnglish: 'The river does not divide Shanghai into past and future.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
  RemediatedSemanticEvent(
      id: 'BD2-E9',
      coreChinese: '他仍去陆家嘴，却不再把外滩当成必须删除的过去。',
      corePinyin: 'Tā réng qù Lùjiāzuǐ.',
      coreVietnamese: 'Anh vẫn đi Lục Gia Chủy.',
      coreEnglish: 'He still goes to Lujiazui.',
      detailChinese: '',
      detailPinyin: '',
      detailVietnamese: '',
      detailEnglish: '',
      detailFromLevel: 11),
];
const _eventIds = <String>[
  'BD2-E1',
  'BD2-E2',
  'BD2-E3',
  'BD2-E4',
  'BD2-E5',
  'BD2-E6',
  'BD2-E7',
  'BD2-E8',
  'BD2-E9'
];
const shanghaiBundOnePassWordTraces = <RemediatedWordTrace>[
  RemediatedWordTrace(
      word: '外滩',
      eventId: 'BD2-E1',
      usage: '故事舞台',
      sourceText: '这个晚上，他先到外滩和母亲见面。'),
  RemediatedWordTrace(
      word: '黄浦江',
      eventId: 'BD2-E3',
      usage: '两岸结构',
      sourceText: '林岸说，过了黄浦江，就是离开旧上海，进入新上海。'),
  RemediatedWordTrace(
      word: '陆家嘴',
      eventId: 'BD2-E1',
      usage: '东岸新职业',
      sourceText: '第二天，他将到陆家嘴一家金融科技公司的结算团队上班。'),
  RemediatedWordTrace(
      word: '海关大楼',
      eventId: 'BD2-E2',
      usage: '外滩具体位置',
      sourceText: '母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。'),
  RemediatedWordTrace(
      word: '海运提单',
      eventId: 'BD2-E2',
      usage: '核心故事对象',
      sourceText: '母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。'),
  RemediatedWordTrace(
      word: '轮渡',
      eventId: 'BD2-E7',
      usage: '真实跨江行动',
      sourceText: '轮渡离开西岸，他看见外滩慢慢退远，陆家嘴的高楼越来越近。'),
  RemediatedWordTrace(
      word: '货运',
      eventId: 'BD2-E1',
      usage: '家庭背景',
      sourceText: '林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。'),
  RemediatedWordTrace(
      word: '报关单',
      eventId: 'BD2-E1',
      usage: '家庭背景',
      sourceText: '林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。'),
  RemediatedWordTrace(
      word: '结算',
      eventId: 'BD2-E1',
      usage: '新职业',
      sourceText: '第二天，他将到陆家嘴一家金融科技公司的结算团队上班。'),
  RemediatedWordTrace(
      word: '信用',
      eventId: 'BD2-E8',
      usage: '流动关系',
      sourceText: '货物、文件、信用、信息和资金只是换了工具继续流动。'),
  RemediatedWordTrace(
      word: '开埠',
      eventId: 'BD2-E5',
      usage: '历史语境',
      sourceText:
          '接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。'),
  RemediatedWordTrace(
      word: '不平等条约',
      eventId: 'BD2-E5',
      usage: '历史治理',
      sourceText:
          '接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。'),
];

const shanghaiBundOnePassDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
      text: '外滩位于黄浦江西岸，是上海重要的历史滨水地区；历史建筑群与浦东天际线形成独特的两岸景观。',
      simpleChinese: '外滩在黄浦江西岸，和浦东隔江相望。',
      vietnamese: 'Ngoại Than nằm ở bờ tây Hoàng Phố và đối diện Phố Đông.',
      english: 'The Bund lies on the west bank of the Huangpu facing Pudong.',
      pinyin:
          'Wàitān wèiyú Huángpǔ Jiāng xī àn, shì Shànghǎi zhòngyào de lìshǐ bīnshuǐ dìqū; lìshǐ jiànzhùqún yǔ Pǔdōng tiānjìxiàn xíngchéng dútè de liǎng àn jǐngguān.'),
  DiscoveryEntry(
      text: '上海1843年的开埠发生在十九世纪不平等条约体系下，不能被描述成中性或单纯庆祝式的现代化事件。',
      simpleChinese: '1843年开埠与不平等条约体系有关。',
      vietnamese:
          'Việc mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng.',
      english:
          'Shanghai’s 1843 treaty-port opening occurred within the unequal-treaty system.',
      pinyin:
          'Shànghǎi yī bā sì sān nián de kāibù fāshēng zài shíjiǔ shìjì bù píngděng tiáoyuē tǐxì xià, bùnéng bèi miáoshù chéng zhōngxìng huò dānchún qìngzhù shì de xiàndàihuà shìjiàn.'),
  DiscoveryEntry(
      text: '外滩及周边的贸易、航运、海关、银行与商业功能经历长期发展与重组，并非一夜形成。',
      simpleChinese: '外滩的商业金融功能经过很多年发展。',
      vietnamese:
          'Các chức năng thương mại, vận tải, hải quan và ngân hàng phát triển trong thời gian dài.',
      english:
          'Trade, shipping, customs, banking, and commerce around the Bund developed over a long period.',
      pinyin:
          'Wàitān jí zhōubiān de màoyì, hángyùn, hǎiguān, yínháng yǔ shāngyè gōngnéng jīnglì chángqī fāzhǎn yǔ chóngzǔ, bìngfēi yī yè xíngchéng.'),
  DiscoveryEntry(
      text: '海运提单等商业文件把货物、承运、交付与责任关系固定下来，是贸易流动中的普通基础工具。',
      simpleChinese: '提单是记录运输和责任关系的普通商业单据。',
      vietnamese:
          'Vận đơn ghi nhận hàng hóa, vận chuyển, giao nhận và trách nhiệm.',
      english:
          'Bills of lading document goods, carriage, delivery, and responsibility.',
      pinyin:
          'Hǎiyùn tídān děng shāngyè wénjiàn bǎ huòwù, chéngyùn, jiāofù yǔ zérèn guānxì gùdìng xiàlái, shì màoyì liúdòng zhōng de pǔtōng jīchǔ gōngjù.'),
  DiscoveryEntry(
      text: '东金线连接浦西金陵东路轮渡站与浦东东昌路轮渡站，黄浦江轮渡至今仍是两岸交通的一部分。',
      simpleChinese: '东金线把金陵东路和东昌路两边连起来。',
      vietnamese: 'Tuyến Đông Kim nối bến Đông Kim Lăng với bến Đông Xương.',
      english:
          'The Dongjin ferry links East Jinling Road in Puxi with Dongchang Road in Pudong.',
      pinyin:
          'Dōngjīn Xiàn liánjiē Pǔxī Jīnlíng Dōng Lù lúndùzhàn yǔ Pǔdōng Dōngchāng Lù lúndùzhàn, Huángpǔ Jiāng lúndù zhìjīn réng shì liǎng àn jiāotōng de yí bùfen.'),
  DiscoveryEntry(
      text: '陆家嘴形成现代金融核心区，不意味着现代浦东简单替代了外滩的历史金融功能；两岸共同构成上海持续变化的金融与城市空间。',
      simpleChinese: '陆家嘴的发展不等于外滩历史被删除。',
      vietnamese:
          'Sự phát triển của Lục Gia Chủy không xóa lịch sử tài chính của Ngoại Than.',
      english:
          'Lujiazui’s development did not erase the Bund’s historical financial role.',
      pinyin:
          'Lùjiāzuǐ xíngchéng xiàndài jīnróng héxīn qū, bù yìwèizhe xiàndài Pǔdōng jiǎndān tìdài le Wàitān de lìshǐ jīnróng gōngnéng; liǎng àn gòngtóng gòuchéng Shànghǎi chíxù biànhuà de jīnróng yǔ chéngshì kōngjiān.'),
  DiscoveryEntry(
    text: '外滩现海关大楼于1927年建成。今天看到的这座建筑属于二十世纪的城市历史，理解外滩时要把现存建筑的建成年代与更早的滨水贸易历史分开。',
    simpleChinese: '现海关大楼1927年建成，不能把不同年代的外滩混成同一时刻。',
    vietnamese:
        'Tòa nhà Hải quan hiện nay ở Ngoại Than được hoàn thành năm 1927. Công trình còn thấy ngày nay thuộc lịch sử đô thị thế kỷ XX, vì vậy niên đại của công trình hiện hữu cần được phân biệt với lịch sử thương mại ven sông sớm hơn.',
    english:
        'The present Bund Customs House was completed in 1927. The building visible today belongs to twentieth-century urban history, so its construction date should be distinguished from earlier waterfront trade history on the Bund.',
    pinyin:
        'Wàitān xiàn Hǎiguān Dàlóu yú yī jiǔ èr qī nián jiànchéng. Jīntiān kàndào de zhè zuò jiànzhù shǔyú èrshí shìjì de chéngshì lìshǐ, lǐjiě Wàitān shí yào bǎ xiàncún jiànzhù de jiànchéng niándài yǔ gèng zǎo de bīnshuǐ màoyì lìshǐ fēnkāi.',
  ),
  DiscoveryEntry(
    text:
        '现代陆家嘴金融城是在1990年浦东开发开放以后持续发展形成的。把这一现代金融空间直接倒置到十九世纪，会混淆外滩近代贸易金融史与浦东后来形成的城市功能。',
    simpleChinese: '现代陆家嘴金融城是在1990年浦东开发开放以后逐步形成的。',
    vietnamese:
        'Khu tài chính Lục Gia Chủy hiện đại phát triển dần sau khi Phố Đông bắt đầu công cuộc khai phát và mở cửa năm 1990; không nên đảo ngược không gian hiện đại này vào thế kỷ XIX.',
    english:
        'Modern Lujiazui Financial City developed after Pudong’s development and opening began in 1990; projecting that modern financial space directly back into the nineteenth century would blur distinct historical stages.',
    pinyin:
        'Xiàndài Lùjiāzuǐ Jīnróngchéng shì zài yī jiǔ jiǔ líng nián Pǔdōng kāifā kāifàng yǐhòu chíxù fāzhǎn xíngchéng de. Bǎ zhè yí xiàndài jīnróng kōngjiān zhíjiē dàozhì dào shíjiǔ shìjì, huì hùnxiáo Wàitān jìndài màoyì jīnróng shǐ yǔ Pǔdōng hòulái xíngchéng de chéngshì gōngnéng.',
  ),
];
const _shanghaiBundDiscoveryPlan = <List<int>>[
  <int>[0],
  <int>[4],
  <int>[3, 0],
  <int>[6, 4],
  <int>[5, 3],
  <int>[6, 1],
  <int>[2, 6],
  <int>[3, 7],
  <int>[7, 5],
  <int>[1, 7],
];

JourneyLevelContent shanghaiBundOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = shanghaiBundOnePassRemediation.levelContent(level);
  final discoveries = _shanghaiBundDiscoveryPlan[level - 1]
      .map((index) => shanghaiBundOnePassDiscoveries[index])
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: base.words,
    discoveries: List<DiscoveryEntry>.unmodifiable(discoveries),
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

const shanghaiBundOnePassDiscoveryTraces = <RemediatedDiscoveryTrace>[
  RemediatedDiscoveryTrace(
      discoveryIndex: 0,
      storyEventIds: <String>['BD2-E4'],
      sourceIds: <String>['shanghai-gov-bund-scenic']),
  RemediatedDiscoveryTrace(
      discoveryIndex: 1,
      storyEventIds: <String>['BD2-E5'],
      sourceIds: <String>['shanghai-municipal-history-governance']),
  RemediatedDiscoveryTrace(discoveryIndex: 2, storyEventIds: <String>[
    'BD2-E5'
  ], sourceIds: <String>[
    'huangpu-bund-finance-history',
    'shanghai-huangpu-river-plan'
  ]),
  RemediatedDiscoveryTrace(
      discoveryIndex: 3,
      storyEventIds: <String>['BD2-E2'],
      sourceIds: <String>['shanghai-port-trade-document-context']),
  RemediatedDiscoveryTrace(
      discoveryIndex: 4,
      storyEventIds: <String>['BD2-E7'],
      sourceIds: <String>['shanghai-gov-huangpu-ferry']),
  RemediatedDiscoveryTrace(discoveryIndex: 5, storyEventIds: <String>[
    'BD2-E9'
  ], sourceIds: <String>[
    'shanghai-huangpu-river-plan',
    'huangpu-bund-finance-history'
  ]),
  RemediatedDiscoveryTrace(
    discoveryIndex: 6,
    storyEventIds: <String>['BD2-E2', 'BD2-E5'],
    sourceIds: <String>['shanghai-gov-customs-house-1927'],
  ),
  RemediatedDiscoveryTrace(
    discoveryIndex: 7,
    storyEventIds: <String>['BD2-E5', 'BD2-E9'],
    sourceIds: <String>['shanghai-gov-pudong-lujiazui-development'],
  ),
];
const shanghaiBundOnePassChallenges = <RemediatedChallengeTrace>[
  RemediatedChallengeTrace(
      type: 'paragraphRebuild',
      storyEventIds: <String>['BD2-E4', 'BD2-E7'],
      anchor: '轮渡离开西岸'),
  RemediatedChallengeTrace(
      type: 'grammarRepair',
      storyEventIds: <String>['BD2-E3', 'BD2-E9'],
      anchor: '他继续走向陆家嘴'),
  RemediatedChallengeTrace(
      type: 'missingSentence',
      storyEventIds: <String>['BD2-E8'],
      anchor: '江没有把上海分成过去和未来。'),
];
const shanghaiBundOnePassMemory = <RemediatedMemoryReview>[
  RemediatedMemoryReview(
      category: 'protagonist',
      prompt: '主人公',
      answer: '林岸，二十四岁，从货代与报关单证家庭走向陆家嘴金融科技结算岗位。',
      storyEventIds: <String>['BD2-E1']),
  RemediatedMemoryReview(
      category: 'events',
      prompt: '重要事件',
      answer: '林岸与母亲在外滩见面、旧海运提单出现、沿黄浦江南行、在金陵东路轮渡站告别、林岸携单过江并从浦东回望外滩。',
      storyEventIds: _eventIds),
  RemediatedMemoryReview(
      category: 'history',
      prompt: '历史',
      answer: '1843年开埠处在十九世纪不平等条约体系下；外滩贸易、航运、海关、银行和商业功能经过长期发展与重组。',
      storyEventIds: <String>['BD2-E5']),
  RemediatedMemoryReview(
      category: 'culture',
      prompt: '城市文化',
      answer: '黄浦江不是背景，而是连接浦西、航运、轮渡、浦东与城市持续流动的空间脊柱。',
      storyEventIds: <String>['BD2-E4', 'BD2-E7', 'BD2-E8']),
  RemediatedMemoryReview(
      category: 'architecture',
      prompt: '建筑与两岸',
      answer: '外滩历史建筑与海关大楼在西岸形成历史城市界面，陆家嘴天际线在东岸形成现代金融城市界面，两者隔江同时可见。',
      storyEventIds: <String>['BD2-E2', 'BD2-E4', 'BD2-E9']),
  RemediatedMemoryReview(
      category: 'vocabulary',
      prompt: '关键词',
      answer: '外滩、黄浦江、陆家嘴、海关大楼、海运提单、轮渡、货运、报关单、结算、信用、开埠、不平等条约。',
      storyEventIds: <String>[
        'BD2-E1',
        'BD2-E2',
        'BD2-E5',
        'BD2-E7',
        'BD2-E8'
      ]),
];
const shanghaiBundOnePassCompletion = RemediatedCompletion(
  journeySummary:
      '林岸仍离开家里的旧工作并过江去陆家嘴，但他选择把外祖父留下的旧海运提单副本带在身上；从江面回望时，他理解两岸属于同一座持续重组流动的上海。',
  achievement: '双岸行者：能从黄浦江的真实跨越理解外滩贸易金融历史与陆家嘴现代结算并非简单替代关系。',
  memoryAnchor: '一张过江的旧提单',
  challengeReward: '完成三类故事挑战，获得“黄浦渡签”——一枚取意于轮渡与商贸单据的旅程凭记。',
  journeyCompletion: '上海 · 外滩《过江之前》Journey Completion',
);
const shanghaiBundOnePassSources = <RemediatedSourceBinding>[
  RemediatedSourceBinding(
      id: 'shanghai-gov-bund-scenic',
      publisher: 'Shanghai Municipal Government',
      scope: '外滩黄浦江位置、历史建筑群与滨水空间'),
  RemediatedSourceBinding(
      id: 'huangpu-bund-finance-history',
      publisher: 'Huangpu District Government',
      scope: '外滩近现代贸易、商业、金融与历史建筑发展'),
  RemediatedSourceBinding(
      id: 'shanghai-huangpu-river-plan',
      publisher: 'Shanghai Municipal Government',
      scope: '外滩—陆家嘴、金融航运服务与黄浦江两岸连续发展'),
  RemediatedSourceBinding(
      id: 'shanghai-gov-huangpu-ferry',
      publisher: 'Shanghai Municipal Government',
      scope: '东金线金陵东路—东昌路跨江关系'),
  RemediatedSourceBinding(
      id: 'shanghai-municipal-history-governance',
      publisher: 'Shanghai Municipal Government',
      scope: '1843开埠的不平等条约历史语境'),
  RemediatedSourceBinding(
      id: 'shanghai-port-trade-document-context',
      publisher: '全国人民代表大会 / 《中华人民共和国海商法》',
      scope: '提单用于证明海上货物运输合同、承运人接收或装船，并作为承运人据以交付货物的单证之法律边界'),
  RemediatedSourceBinding(
    id: 'shanghai-gov-customs-house-1927',
    publisher: '上海市人民政府 / 上海市文化和旅游局',
    scope: '外滩现海关大楼1927年建成及其历史建筑时间边界',
  ),
  RemediatedSourceBinding(
    id: 'shanghai-gov-pudong-lujiazui-development',
    publisher: '上海市人民政府 / 浦东新区人民政府',
    scope: '1990年浦东开发开放以后陆家嘴现代金融城持续发展形成的时间边界',
  ),
];

final shanghaiBundOnePassRemediation = RemediatedJourney(
  id: shanghaiBundJourneyId,
  title: '上海 · 外滩：过江之前',
  protagonist: '林岸，二十四岁，成长于货代与报关单证家庭，即将加入陆家嘴金融科技结算团队',
  goal: '在离开家庭旧行业、开始陆家嘴新职业的同一晚，完成一次真实的黄浦江跨越',
  conflict: '他把过江理解成切断外滩与家庭经济来路，但旧海运提单迫使他决定是否必须丢掉一岸，才能走向另一岸',
  eventIds: _eventIds,
  events: _events,
  levels: shanghaiBundOnePassLevels,
  words: shanghaiBundOnePassWords,
  wordTraces: shanghaiBundOnePassWordTraces,
  discoveries: shanghaiBundOnePassDiscoveries,
  discoveryTraces: shanghaiBundOnePassDiscoveryTraces,
  challenges: shanghaiBundOnePassChallenges,
  memory: shanghaiBundOnePassMemory,
  completion: shanghaiBundOnePassCompletion,
  sources: shanghaiBundOnePassSources,
);
