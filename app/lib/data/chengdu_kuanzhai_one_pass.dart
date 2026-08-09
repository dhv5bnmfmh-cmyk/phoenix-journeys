import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const chengduKuanzhaiJourneyId = 'chengdu-kuanzhai-alley';

class ChengduNarrativeDna {
  const ChengduNarrativeDna({
    required this.narrativeIdentity,
    required this.protagonistArchetype,
    required this.storyGoal,
    required this.conflictType,
    required this.climaxType,
    required this.resolutionType,
    required this.memoryAnchorType,
    required this.movementPattern,
    required this.temporalPattern,
    required this.supportingStructure,
    required this.endingMechanism,
    required this.centralMetaphor,
  });

  final String narrativeIdentity;
  final String protagonistArchetype;
  final String storyGoal;
  final String conflictType;
  final String climaxType;
  final String resolutionType;
  final String memoryAnchorType;
  final String movementPattern;
  final String temporalPattern;
  final String supportingStructure;
  final String endingMechanism;
  final String centralMetaphor;
}

const chengduKuanzhaiNarrativeDna = ChengduNarrativeDna(
  narrativeIdentity: 'courtyard-use-trace-survey-revises-preservation-authenticity-judgment',
  protagonistArchetype: 'architecture-researcher-testing-a-preservation-framework-through-field-observation',
  storyGoal: 'document-how-historic-courtyard-space-is-used-today-and-evaluate-authenticity',
  conflictType: 'frozen-preservation-model-vs-lived-commercial-social-use-of-historic-space',
  climaxType: 'survey-form-cross-out-at-tea-table-and-handwritten-still-in-use-reclassification',
  resolutionType: 'retain-modern-use-as-an-evidence-category-rather-than-automatic-authenticity-loss',
  memoryAnchorType: 'crossed-out-commerce-on-field-survey-beside-handwritten-still-in-use',
  movementPattern: 'comparative-field-observation-across-Kuan-Zhai-and-Jing-alleys-with-courtyard-return',
  temporalPattern: 'single-field-study-day-followed-by-next-day-report-submission',
  supportingStructure: 'solo-academic-fieldwork-with-public-courtyard-behavior-no-mentor-lecture',
  endingMechanism: 'next-day-submission-of-uncleaned-survey-page-with-cross-out-and-handwritten-revision-visible',
  centralMetaphor: 'preservation-can-hold-time-through-continuing-use-rather-than-freezing-space',
);

class ChengduDiscoverySpec {
  const ChengduDiscoverySpec({
    required this.level,
    required this.title,
    required this.storyLink,
    required this.entry,
    required this.keyTerms,
    required this.learnerInsight,
    required this.check,
    required this.answer,
    required this.sourceIds,
  });

  final int level;
  final String title;
  final String storyLink;
  final DiscoveryEntry entry;
  final List<String> keyTerms;
  final String learnerInsight;
  final String check;
  final String answer;
  final List<String> sourceIds;
}

class ChengduChallengeSpec {
  const ChengduChallengeSpec({
    required this.level,
    required this.type,
    required this.anchor,
    required this.answer,
  });

  final int level;
  final String type;
  final String anchor;
  final String answer;
}

class ChengduCompleteSpec {
  const ChengduCompleteSpec({
    required this.journeySummary,
    required this.achievement,
    required this.memoryAnchor,
    required this.anchorMeaning,
    required this.challengeReward,
    required this.rewardMeaning,
    required this.rewardUnlockText,
    required this.journeyCompletion,
  });

  final String journeySummary;
  final String achievement;
  final String memoryAnchor;
  final String anchorMeaning;
  final String challengeReward;
  final String rewardMeaning;
  final String rewardUnlockText;
  final String journeyCompletion;
}

JourneyLevelContent _chengduLevel(List<String> paragraphs) => JourneyLevelContent(
      storyParagraphs: List<String>.unmodifiable(paragraphs),
      storyAnnotations: List<ReadingAnnotation>.unmodifiable([
        for (var i = 0; i < paragraphs.length; i++)
          ReadingAnnotation(
            pinyin: i == 0
                ? 'Lín Xià èrshísì suì, shì Chéngdū běndì jiànzhù xì yánjiūshēng. Tā dài zhe shǐyòng hénjì diàochá biǎo zǒujìn Kuānzhǎi Xiàngzi.'
                : 'Tā zài chá zhuō páng chóngxīn héduì diàochá biǎo, huàdiào shāngyè huódòng, zài pángbiān xiěxià réng zài shǐyòng.',
            vietnamese: i == 0
                ? 'Lâm Hạ, 24 tuổi, là nghiên cứu sinh kiến trúc người Thành Đô. Cô mang phiếu khảo sát dấu vết sử dụng vào khu Kuanzhai, ban đầu xem hoạt động thương mại là yếu tố làm giảm tính xác thực lịch sử.'
                : 'Qua việc quan sát cách cửa, sân, bàn trà, ghế và dòng người tiếp tục vận hành trong không gian cũ, cô sửa phân loại của mình. Hôm sau cô nộp nguyên phiếu có dòng gạch bỏ “hoạt động thương mại” và ghi tay “vẫn đang được sử dụng”.',
            english: i == 0
                ? 'Lin Xia, 24, is a Chengdu architecture graduate student. She enters Kuanzhai Alley with a use-trace survey and initially classifies commercial activity as a threat to historical authenticity.'
                : 'Observing doors, courtyards, tea tables, chairs, and circulation still working inside the historic fabric forces her to revise that category. The next day she submits the original sheet with “commercial activity” crossed out and “still in use” handwritten beside it.',
          ),
      ]),
      words: const <WordEntry>[],
      discoveries: const <DiscoveryEntry>[],
      wonderQuestion: '',
      expressQuestion: '',
    );

final chengduKuanzhaiOnePassLevels = List<JourneyLevelContent>.unmodifiable([
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生。她带着“使用痕迹调查”表走进宽窄巷子，认定商业越多，历史越不真实，便在“影响历史真实性”一栏写下“商业活动”。她沿宽巷子看青砖墙、木门、磨亮的门槛和院落，又在窄巷子看见茶桌、椅子、店员和来往的人共享旧空间。到一张院中茶桌旁，她发现椅脚磨出的痕迹和旧门槛一样真实。林夏把“商业活动”四个字轻轻划掉，在旁边写：“仍在使用。”第二天交表时，她没有誊清那一页。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生。老师让她在宽窄巷子做一次“使用痕迹调查”，记录历史街区今天怎样被使用。她原本相信，商业活动越多，历史真实性就越弱，所以刚到宽巷子，便在调查表的“影响历史真实性”一栏写下“商业活动”。她仔细看青砖、木门、院落和被踩亮的门槛，又走过窄巷子和井巷子，记录茶馆、餐厅、小店、椅子与不断变化的人流。院里一张茶桌旁，杯子移开后留下水圈，椅脚附近的地面也有长期使用的磨痕。她低头看表，没有写结论，只把“商业活动”四个字划掉，在旁边补上：“仍在使用。”第二天提交调查时，她保留了这处修改。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生。课程要求她在宽窄巷子完成一份“使用痕迹调查”，观察历史街区的空间今天怎样运转。她的判断框架很清楚：保存应尽量减少现代干扰，商业越密集，历史真实性越容易被削弱。因此走进宽巷子不久，她就在调查表“影响历史真实性的因素”下面写了“商业活动”。她量门洞、看青砖墙，记下木门边缘和门槛被反复摩擦后的亮痕，也把茶馆、餐厅和游客流线标进草图。',
      '走到窄巷子，她发现院落并没有因为有茶桌和店铺就停止发挥空间作用：门仍组织进出，院子仍让人坐下、交谈、绕行。井巷子更紧凑的街面上，旧墙与今天的经营并置。傍晚，她在一张院中茶桌旁重新核对调查表，看到椅脚磨痕、茶水留下的浅圈和门槛上的旧痕连在同一条使用线上。林夏没有写“我明白了”。她只是把“商业活动”四个字轻轻划掉，在旁边写：“仍在使用。”第二天交表，她没有誊写干净版本，那道删除线仍留在纸上。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生。一次城市空间课程把她带到宽窄巷子，任务不是画立面，而是做“使用痕迹调查”：记录历史街区里哪些空间被保留、哪些被改变、今天的人怎样使用它们。林夏一直认为，保存越接近“少干预”，历史真实性越可靠。刚进宽巷子，她看见餐饮招牌和排队的人，便在调查表“影响历史真实性的因素”下先写“商业活动”。随后她把注意力移到建筑本身：青砖墙上有修补差异，木门边缘被手掌磨亮，门槛中央比两侧光滑，院落中的桌椅改变了停留方式，却没有改变门、院、廊之间的基本关系。',
      '窄巷子和井巷子的观察让她的表格越来越难填。店铺确实改变了使用内容，但人仍沿街进入院落，在门内外停顿、交谈、让路；茶桌不是背景装饰，而是让院子继续发生社交的家具。傍晚，她坐在一张茶桌旁核对记录，发现椅脚附近的磨痕、杯底水圈与旧门槛上的凹痕都来自反复使用。她再次看见早先写下的“商业活动”。林夏停了一会儿，把这四个字划掉，在旁边写：“仍在使用。”第二天提交调查，她没有做一份整洁的新表，那道删除线和补写被原样保留。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生。导师布置“使用痕迹调查”时，要求学生不要只拍建筑，而要记录历史街区如何被今天的人真正使用。林夏选择宽窄巷子，因为它由宽巷子、窄巷子和井巷子构成，旧街巷、院落与现代经营挤在一起，正适合检验她熟悉的保护观念。她一直倾向于把“原真”理解成减少后来加入的东西：商业越少，历史空间越纯。进入宽巷子后，餐厅门口的人流和店铺陈设首先进入视线，她很快在调查表“影响历史真实性的因素”下面写了“商业活动”。接着她开始按建筑训练观察：青砖墙的旧新差别、木门被触摸后的颜色变化、门槛中央的磨损、院落里桌椅留下的移动范围，全被标在草图上。',
      '沿窄巷子继续走，她发现经营内容虽然是今天的，空间关系却仍被使用不断解释：门控制进出，院子容纳停留，窄处迫使陌生人侧身让路，茶桌把几个人的谈话固定在院落一角。到井巷子，她又记下旧墙边短暂停留的人和店铺前反复形成的流线。傍晚回到一处院落，她在茶桌旁整理记录。杯底留下的水圈很快会干，椅脚和门槛的磨痕却是日复一日积出的；新活动没有把旧空间变成静止展品，反而持续留下可读的使用证据。林夏翻到第一页，看着自己写的“商业活动”，没有加一句辩解，只把四个字划掉，在旁边写：“仍在使用。”第二天她交上原表，删除线没有被擦掉。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生。城市更新课程要求她完成一份“使用痕迹调查”，目标不是只判断建筑保存了多少旧材料，而是记录历史空间今天怎样被进入、停留和使用。她选择宽窄巷子，因为宽巷子、窄巷子和井巷子既保留街巷与院落格局，也容纳茶馆、餐饮和商店。林夏并不反对经营，但她一直觉得现代商业越明显，历史真实性越容易被遮住。上午进入宽巷子，看见排队的人、菜单和店铺陈设后，她在调查表“影响历史真实性的因素”下面写了“商业活动”。随后她按建筑训练重新观察：青砖墙上旧砖与修补砖的色差、木门被反复触摸后变亮的位置、门槛中央的磨损、桌椅摆放后留下的通行缝隙，都被她画进草图。',
      '窄巷子里，一处院落让她把“商业”拆成具体动作。茶桌旁有人添水、交谈、挪椅让路，服务人员绕过桌角，后来的人在门口等前一组通过；门、廊、院仍在组织这些动作。井巷子更紧凑，穿行、购买和短暂停留形成另一种使用密度。傍晚，她回到院中茶桌旁汇总记录。杯底水圈会很快变淡，椅脚附近和门槛上的磨痕却来自长期接触。她发现今天的活动并没有让旧空间停止发挥作用，反而继续留下能被读出的痕迹。林夏翻到第一页，看着自己先写下的“商业活动”，没有补理论，只把四个字划掉，在旁边写：“仍在使用。”第二天提交报告时，她没有誊清这一页，删除线和补写都留在原表上。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生，研究历史街区更新。课程布置“使用痕迹调查”时，要求学生把建筑当成仍在运转的空间，而不是只看立面是否古旧。她选择宽窄巷子。宽巷子、窄巷子和井巷子组成街区核心，院落与街巷肌理保存下来，同时又有茶馆、餐饮、零售和不断流动的访客。林夏的担心并非没有道理：商业如果过强，确实可能遮住历史信息。只是她习惯在观察之前就把商业列成负面项。上午进入宽巷子，她看见候位、人流和店铺陈设，很快在调查表“影响历史真实性的因素”下写了“商业活动”。写完后，她按研究方法逐项测记：青砖墙修补处的色差、木门手握处的亮面、门槛中部长期踩出的磨损、院内桌椅的移动范围，以及人从街到门、从门到院的转折。',
      '到了窄巷子，她发现原来的分类开始变得粗糙。茶桌周围有人坐下、起身、添水、让路，服务人员沿门廊往返；经营改变了内容，却仍在调用院落原有的尺度和关系。井巷子更窄，购买、穿行和驻足叠在一起，旧街巷的尺度反过来限制着今天的人怎样移动。林夏把“现代用途”和“空间是否仍可读”分开记录。傍晚，她回到茶桌旁核对三条巷子的表格。杯底水圈正在消失，椅脚移动磨亮的砖面和旧门槛上的凹痕却更稳定。调查明明在寻找“使用痕迹”，她最早却把最明显的使用先判成干扰。林夏没有写心得，只把第一页的“商业活动”四个字划掉，在旁边补上：“仍在使用。”第二天，她把这张有删除线、有补写的原表直接交了上去。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生，正在做历史街区更新方向的课程研究。她收到的任务叫“使用痕迹调查”：不是给建筑做年代鉴定，而是观察历史空间在今天怎样被进入、停留、使用和改变。她选择宽窄巷子。宽巷子、窄巷子、井巷子三条核心街巷与院落保留着历史空间特征，保护更新后又持续承载餐饮、茶文化、零售和公共游逛。林夏一直对此保持警惕。她知道商业并非天然错误，但当招牌、消费和游客变得太醒目，历史真实性很容易退到背景。于是上午进入宽巷子，她看到门前排队、菜单和店铺陈设后，仍按原来的分析框架，在调查表“影响历史真实性的因素”下面写了“商业活动”。她随后开始更细的记录：青砖墙上旧砖与修补砖的色差，木门开启时手掌反复接触的位置，门槛中央被脚步磨低的弧度，院落中桌椅摆放后形成的通行缝隙，以及人从街到门、从门到院的转折。',
      '窄巷子的一处院落让她第一次把商业用途拆成具体动作来看。茶桌旁有人添水、交谈、起身，服务人员穿过桌椅之间，后来的人在门口等前一组离开；空间并不是被“商业”这个抽象词占据，而是在持续承受身体、物件和时间。井巷子里，更高密度的穿行与购买又显示另一种关系：旧街巷尺度限制人怎样移动，今天的活动也反过来不断磨出新的使用痕迹。她查阅现场资料时确认，宽窄巷子是成都历史文化街区，保护更新长期同时处理历史遗存与现代使用。傍晚回到茶桌旁，她整理三条巷子的草图。杯底水圈将干未干，椅脚下的砖面已经发亮，旧门槛上的凹痕更深。林夏看见第一页那个写得很肯定的“商业活动”，停了几秒，把四个字划掉，在旁边写：“仍在使用。”第二天交表，她没有把矛盾整理成漂亮结论，而是留下原来的判断、删除线和新的四个字。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生，研究历史街区更新。课程要求完成一份“使用痕迹调查”，重点不是判断某栋房子“古不古”，而是追踪空间在当代如何被进入、停留、经营、维护和重新理解。她选择宽窄巷子作为样本。宽巷子、窄巷子和井巷子构成街区核心的三条街巷，院落与砖木建筑保留了历史空间特征；保护更新后又长期容纳餐饮、茶文化、零售、休闲与访客。林夏知道历史街区不可能没有现实功能，但她仍倾向于一个谨慎的判断：现代商业越强，旧空间越容易变成消费布景，历史真实性也越难辨认。上午进入宽巷子，她看到餐厅门口的候位、人流和商品陈设，便在调查表“影响历史真实性的因素”下面写下“商业活动”。写完后，她按老师要求暂时搁置结论，只记录能被看见的证据：青砖墙上旧砖和修补砖的色差，木门反复开启形成的触摸亮区，门槛中央被长期踩出的磨损，院内桌椅改变停留位置后留下的移动范围，以及人从街巷进入院落时反复出现的转身与让路。',
      '窄巷子里，一处院落的茶桌把她原先的分类逐渐拆开。喝茶的人并没有把院子当摄影背景：有人挪椅子让出通道，有人添水，有人交谈后起身，服务人员沿门、廊和桌边不断往返。院落原来的尺度决定这些动作怎样发生，而这些动作又在砖地、门槛和家具周围留下新的痕迹。井巷子更紧凑，购买、穿行、短暂停留叠在较窄的街面上，却也让她看到“使用”不能只按新旧二分。她把笔记改成两栏：一栏记可能遮蔽历史信息的改变，一栏记仍能读出旧空间结构的当代使用。她随后核对资料：宽窄巷子是成都重要历史文化街区，三条核心巷道和院落肌理在保护更新中被保留，同时又引入现代消费和公共活动。傍晚，林夏回到院中的茶桌旁汇总。杯底水圈正在变淡，椅脚附近的砖面因反复移动发亮，旧门槛上的凹痕则更深；不同年代的接触并没有自动互相取消。她翻到第一页，看见“商业活动”四个字仍被放在单一负面项里。林夏没有写心得，也没有给自己辩护。她用笔把那四个字划掉，在旁边写：“仍在使用。”第二天交调查表时，她没有誊清这一页。被划掉的旧判断和手写的新判断一起留在报告里。'
    ]),
  _chengduLevel([
      '林夏二十四岁，是成都本地建筑系研究生，研究方向是历史街区保护与城市更新。学期末的课程任务不是传统测绘，而是一份“使用痕迹调查”：学生要追踪历史空间今天如何被进入、停留、经营、维护和改变，再判断这些活动究竟遮蔽了什么，又延续了什么。林夏选择宽窄巷子，因为它把她一直没有完全解决的问题摆得很直接。宽巷子、窄巷子和井巷子构成核心街巷，院落及砖木建筑保留着历史空间特征；保护更新之后，餐饮、茶文化、零售、休闲与密集访客又持续进入这些院落。林夏并不主张把商业全部赶走，她的担心更专业也更克制：当消费标识、经营需求和游客流线成为最醒目的层次，旧空间是否会只剩外观？上午刚到宽巷子，她看见候位的人、菜单牌和店铺陈设，仍按原有分析框架，在调查表“影响历史真实性的因素”下面写了“商业活动”。随后她把价值判断放到一边，逐项画证据。青砖墙上旧砖和修补砖有色差，木门把手附近被反复触摸得发亮，门槛中央比两侧磨损更深；院落里桌椅形成新的停留点，人从街到门、从门到院时反复转身、避让，留下稳定的通行带。',
      '窄巷子的一处茶桌让她的分类开始失效。坐下的人添水、挪椅、聊天、起身，服务人员沿门廊往返，后来者在狭窄入口等前一组人通过。林夏原本只想标出“商业占用”，却发现门、廊、院的旧尺度仍在决定今天的身体如何移动。井巷子更紧凑，购买、拍照、穿行与短暂停留重叠，确实产生拥挤和视觉压力，但她无法再把所有现代活动直接等同于历史信息的消失。她把记录重新分成“遮蔽”与“延续”两栏，并核对街区资料：宽窄巷子由三条核心巷道及院落群构成，是成都的重要历史文化街区；保护更新既保留街巷院落机理，也引入餐饮、茶文化、零售与公共活动，相关城市实践明确面对历史传承与现代商业如何融合的问题。傍晚，她回到院中茶桌旁整理草图。杯底的水圈正在蒸发，椅脚反复移动使砖面发亮，门槛上的凹痕则跨过更长时间；新的接触与旧的磨损都证明空间没有停止承担生活。林夏翻到第一页，那四个字“商业活动”仍被她写在单一负面项里。她没有补一段理论，也没有写“我明白了”。只把“商业活动”划掉，在旁边写：“仍在使用。”第二天，她没有把报告誊成没有修改痕迹的干净版本。调查表上被划掉的四个字和那句手写补充一起被提交，成为这次调查最清楚的一处证据。'
    ])
]);

WordEntry _word(String word, String pinyin, String partOfSpeech,
        String simpleChinese, String vietnamese, String english, String symbol) =>
    WordEntry(
      word: word,
      pinyin: pinyin,
      partOfSpeech: partOfSpeech,
      simpleChinese: simpleChinese,
      translation: vietnamese,
      englishDefinition: english,
      symbol: symbol,
    );

final chengduKuanzhaiOnePassWords = List<WordEntry>.unmodifiable([
  _word('使用痕迹', 'shǐyòng hénjì', '名词', '空间或物件因反复使用留下的可观察变化。', 'dấu vết sử dụng', 'visible traces left by repeated use', '🔎'),
  _word('宽窄巷子', 'Kuānzhǎi Xiàngzi', '名词（专名）', '成都由宽巷子、窄巷子和井巷子组成的重要历史街区。', 'Khu ngõ Kuanzhai ở Thành Đô', 'Kuanzhai Alley historic district in Chengdu', '🏘️'),
  _word('调查表', 'diàochá biǎo', '名词', '按项目记录现场观察和判断的表格。', 'phiếu khảo sát', 'survey form', '📋'),
  _word('历史真实性', 'lìshǐ zhēnshíxìng', '名词', '对历史空间真实信息与连续性的判断。', 'tính xác thực lịch sử', 'historical authenticity', '🧭'),
  _word('商业活动', 'shāngyè huódòng', '名词', '餐饮、零售、服务等经营活动。', 'hoạt động thương mại', 'commercial activity', '🏪'),
  _word('青砖', 'qīngzhuān', '名词', '传统建筑中常见的灰青色砖材。', 'gạch xanh xám', 'grey-blue brick', '🧱'),
  _word('门槛', 'ménkǎn', '名词', '门口下方横置、常被脚步经过的构件。', 'ngưỡng cửa', 'door threshold', '🚪'),
  _word('院落', 'yuànluò', '名词', '由建筑围合并组织出入、停留和活动的院子空间。', 'sân nhà khép kín', 'courtyard compound', '🏡'),
  _word('茶桌', 'cházhuō', '名词', '喝茶时使用的桌子，在故事中也是观察院落使用的现场。', 'bàn trà', 'tea table', '🍵'),
  _word('仍在使用', 'réng zài shǐyòng', '短语', '没有被冻成静态展品，而是继续承担现实活动。', 'vẫn đang được sử dụng', 'still in use', '✍️'),
  _word('井巷子', 'Jǐng Xiàngzi', '名词（专名）', '宽窄巷子街区三条核心巷道之一。', 'Ngõ Giếng', 'Jing Alley', '↕️'),
  _word('茶馆', 'cháguǎn', '名词', '提供饮茶、停留和社交的经营空间。', 'quán trà', 'teahouse', '🫖'),
  _word('街巷肌理', 'jiēxiàng jīlǐ', '名词', '街道、巷道、院落等共同形成的空间组织关系。', 'cấu trúc mô hình phố-ngõ', 'street-and-alley urban fabric', '🗺️'),
  _word('砖木建筑', 'zhuānmù jiànzhù', '名词', '以砖和木为主要材料的建筑。', 'kiến trúc gạch và gỗ', 'brick-and-timber architecture', '🏠'),
  _word('保护更新', 'bǎohù gēngxīn', '名词/动词', '在保护历史信息的同时改善和延续现实使用。', 'bảo tồn và cải tạo', 'conservation-led renewal', '♻️')
]);

final chengduKuanzhaiWordTraces = List<RemediatedWordTrace>.unmodifiable([
  RemediatedWordTrace(word: '使用痕迹', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '她带着“使用痕迹调查”表走进宽窄巷子，认定商业越多，历史越不真实，便在“影响历史真实性”一栏写下“商业活动”。'),
  RemediatedWordTrace(word: '宽窄巷子', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '她带着“使用痕迹调查”表走进宽窄巷子，认定商业越多，历史越不真实，便在“影响历史真实性”一栏写下“商业活动”。'),
  RemediatedWordTrace(word: '调查表', eventId: 'CD-E1-survey', usage: 'Lv2 首次出现。', sourceText: '她原本相信，商业活动越多，历史真实性就越弱，所以刚到宽巷子，便在调查表的“影响历史真实性”一栏写下“商业活动”。'),
  RemediatedWordTrace(word: '历史真实性', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '她带着“使用痕迹调查”表走进宽窄巷子，认定商业越多，历史越不真实，便在“影响历史真实性”一栏写下“商业活动”。'),
  RemediatedWordTrace(word: '商业活动', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '她带着“使用痕迹调查”表走进宽窄巷子，认定商业越多，历史越不真实，便在“影响历史真实性”一栏写下“商业活动”。'),
  RemediatedWordTrace(word: '青砖', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '她沿宽巷子看青砖墙、木门、磨亮的门槛和院落，又在窄巷子看见茶桌、椅子、店员和来往的人共享旧空间。'),
  RemediatedWordTrace(word: '门槛', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '她沿宽巷子看青砖墙、木门、磨亮的门槛和院落，又在窄巷子看见茶桌、椅子、店员和来往的人共享旧空间。'),
  RemediatedWordTrace(word: '院落', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '她沿宽巷子看青砖墙、木门、磨亮的门槛和院落，又在窄巷子看见茶桌、椅子、店员和来往的人共享旧空间。'),
  RemediatedWordTrace(word: '茶桌', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '她沿宽巷子看青砖墙、木门、磨亮的门槛和院落，又在窄巷子看见茶桌、椅子、店员和来往的人共享旧空间。'),
  RemediatedWordTrace(word: '仍在使用', eventId: 'CD-E1-survey', usage: 'Lv1 首次出现。', sourceText: '林夏把“商业活动”四个字轻轻划掉，在旁边写：“仍在使用。”'),
  RemediatedWordTrace(word: '井巷子', eventId: 'CD-E1-survey', usage: 'Lv2 首次出现。', sourceText: '她仔细看青砖、木门、院落和被踩亮的门槛，又走过窄巷子和井巷子，记录茶馆、餐厅、小店、椅子与不断变化的人流。'),
  RemediatedWordTrace(word: '茶馆', eventId: 'CD-E1-survey', usage: 'Lv2 首次出现。', sourceText: '她仔细看青砖、木门、院落和被踩亮的门槛，又走过窄巷子和井巷子，记录茶馆、餐厅、小店、椅子与不断变化的人流。'),
  RemediatedWordTrace(word: '街巷肌理', eventId: 'CD-E3-observe', usage: 'Lv7 首次出现。', sourceText: '宽巷子、窄巷子和井巷子组成街区核心，院落与街巷肌理保存下来，同时又有茶馆、餐饮、零售和不断流动的访客。'),
  RemediatedWordTrace(word: '砖木建筑', eventId: 'CD-E3-observe', usage: 'Lv9 首次出现。', sourceText: '宽巷子、窄巷子和井巷子构成街区核心的三条街巷，院落与砖木建筑保留了历史空间特征；保护更新后又长期容纳餐饮、茶文化、零售、休闲与访客。'),
  RemediatedWordTrace(word: '保护更新', eventId: 'CD-E3-observe', usage: 'Lv8 首次出现。', sourceText: '宽巷子、窄巷子、井巷子三条核心街巷与院落保留着历史空间特征，保护更新后又持续承载餐饮、茶文化、零售和公共游逛。')
]);

const chengduKuanzhaiWordFirstAppears = <String, int>{'使用痕迹': 1, '宽窄巷子': 1, '调查表': 2, '历史真实性': 1, '商业活动': 1, '青砖': 1, '门槛': 1, '院落': 1, '茶桌': 1, '仍在使用': 1, '井巷子': 2, '茶馆': 2, '街巷肌理': 7, '砖木建筑': 9, '保护更新': 8};

DiscoveryEntry _discovery(
  String text, {
  required String simpleChinese,
  required String vietnamese,
  required String english,
}) =>
    DiscoveryEntry(
      text: text,
      pinyin:
          'Kuānzhǎi Xiàngzi de lìshǐ kōngjiān yǔ dāngdài shǐyòng xūyào fàng zài tóng yí gè bǎohù hé gēngxīn guānxì zhōng lǐjiě.',
      simpleChinese: simpleChinese,
      vietnamese: vietnamese,
      english: english,
    );

final chengduKuanzhaiDiscoverySpecs =
    List<ChengduDiscoverySpec>.unmodifiable([
  ChengduDiscoverySpec(
    level: 1,
    title: '三条巷子构成什么',
    storyLink: '林夏从宽巷子开始，又把窄巷子和井巷子纳入同一份调查。',
    entry: _discovery(
      '宽窄巷子街区由宽巷子、窄巷子和井巷子三条核心街巷组成，三条巷道与院落共同构成可连续步行和观察的历史空间。',
      simpleChinese: '宽巷子、窄巷子、井巷子不是三个孤立景点，而是同一历史街区的核心部分。',
      vietnamese: 'Khu Kuanzhai gồm ba tuyến ngõ cốt lõi: ngõ Rộng, ngõ Hẹp và ngõ Giếng, cùng các sân nhà tạo thành một không gian lịch sử liên tục.',
      english: 'Kuanzhai Alley is organized around the three core lanes of Kuan, Zhai, and Jing, together with their courtyards.',
    ),
    keyTerms: const ['宽巷子', '窄巷子', '井巷子'],
    learnerInsight: '故事让林夏比较三条巷子的使用方式，而不是把宽窄巷子理解成一个单点地标。',
    check: '宽窄巷子的三条核心街巷叫什么？',
    answer: '宽巷子、窄巷子和井巷子。',
    sourceIds: const ['chengdu-gov-kuanzhai-alley'],
  ),
  ChengduDiscoverySpec(
    level: 2,
    title: '为什么能读到清代以来的空间',
    storyLink: '林夏先看青砖、木门和院落，再记录今天的人流。',
    entry: _discovery(
      '官方资料把宽窄巷子的历史追溯到清代，并指出街区仍保存具有历史特征的街巷、院落和传统建筑空间。',
      simpleChinese: '这里的价值不只来自“老外观”，还来自被保留下来的街巷和院落关系。',
      vietnamese: 'Tư liệu chính thức truy nguồn lịch sử khu phố về thời Thanh và nhấn mạnh việc bảo tồn ngõ, sân nhà và không gian kiến trúc lịch sử.',
      english: 'Official material traces the district\'s history to the Qing period and emphasizes the survival of historic lanes, courtyards, and building fabric.',
    ),
    keyTerms: const ['清代', '院落', '历史空间'],
    learnerInsight: '林夏观察门槛和院落，是在读空间连续性，而不是只给建筑贴年代标签。',
    check: '故事为什么反复写门、院和巷，而不只写立面？',
    answer: '因为街巷与院落的空间关系本身就是历史信息。',
    sourceIds: const ['chengdu-gov-kuanzhai-alley'],
  ),
  ChengduDiscoverySpec(
    level: 3,
    title: '院落为什么是使用系统',
    storyLink: '林夏发现门仍组织进出，院子仍容纳坐下、交谈和绕行。',
    entry: _discovery(
      '宽窄巷子的保护更新强调街、巷、院之间的空间组织；院落不是独立摆设，而是与街巷、入口和内部活动相连的使用单元。',
      simpleChinese: '院落要放回街—巷—院的关系里理解。',
      vietnamese: 'Việc bảo tồn nhấn mạnh quan hệ không gian phố-ngõ-sân; sân nhà là một đơn vị sử dụng liên kết với lối vào và hoạt động bên trong.',
      english: 'Conservation work emphasizes the street-lane-courtyard relationship, treating courtyards as connected spatial units rather than isolated exhibits.',
    ),
    keyTerms: const ['街', '巷', '院'],
    learnerInsight: '茶桌是否“现代”不是唯一问题，更关键的是这些活动怎样进入并使用原有空间。',
    check: '院落为什么不能只当作一张静态照片看？',
    answer: '因为它仍与入口、街巷和人的活动相连。',
    sourceIds: const ['mofcom-kuanzhai-pedestrian-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 4,
    title: '保护为什么不等于只保立面',
    storyLink: '林夏记录修补差异、门槛磨损和桌椅移动，而不是只判断墙面是否古旧。',
    entry: _discovery(
      '历史街区保护既要保存可识别的历史空间和建筑特征，也要处理现实使用、维护与更新；只保留一个“像旧的”外表，不能代表完整的保护。',
      simpleChinese: '保护要同时看历史信息、空间关系和现实使用。',
      vietnamese: 'Bảo tồn khu lịch sử cần giữ thông tin và quan hệ không gian, đồng thời xử lý việc sử dụng, bảo dưỡng và cải tạo hiện tại.',
      english: 'Historic-district conservation must preserve legible historic fabric and spatial relationships while addressing present use, maintenance, and renewal.',
    ),
    keyTerms: const ['保护', '历史信息', '现实使用'],
    learnerInsight: '林夏的调查方法从“看起来旧不旧”转向“空间怎样继续工作”。',
    check: '只保留古旧外观是否足以证明历史空间被完整保护？',
    answer: '不足，还要看历史信息、空间关系和现实使用。',
    sourceIds: const ['sichuan-gov-historic-building-use', 'chengdu-gov-kuanzhai-embedded-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 5,
    title: '茶桌为什么不是成都装饰',
    storyLink: '茶桌旁的挪椅、添水、让路和交谈成为林夏最关键的使用证据。',
    entry: _discovery(
      '宽窄巷子的现实经营包含茶饮、餐饮等活动；在历史院落里，桌椅与服务流线会直接改变人怎样停留和通行，因此可以被当作空间使用证据来观察。',
      simpleChinese: '故事里的茶桌不是“慢生活”符号，而是具体的人与空间发生关系的地方。',
      vietnamese: 'Bàn trà không chỉ là biểu tượng địa phương; trong sân lịch sử, ghế, bàn và lối phục vụ cho thấy con người thực sự sử dụng không gian ra sao.',
      english: 'The tea table is not decorative branding: seating, service, and circulation make contemporary courtyard use observable.',
    ),
    keyTerms: const ['茶桌', '通行', '停留'],
    learnerInsight: '文化学习来自行为和空间关系，而不是一句“成都很悠闲”。',
    check: '茶桌在故事中的主要作用是什么？',
    answer: '让林夏观察院落正在发生的真实使用。',
    sourceIds: const ['chengdu-gov-kuanzhai-alley', 'mofcom-kuanzhai-pedestrian-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 6,
    title: '商业一定等于破坏吗',
    storyLink: '林夏把“商业”拆成添水、挪椅、穿行、购买等具体动作。',
    entry: _discovery(
      '官方更新实践把历史文化传承与现代商业的融合视为需要设计和管理的问题，这并不表示所有商业都自动正确，也不表示商业一出现就等于历史真实性消失。',
      simpleChinese: '关键是判断经营怎样影响历史信息和空间，而不是先把“商业”判成同一种结果。',
      vietnamese: 'Thực tiễn cải tạo xem sự kết hợp giữa di sản và thương mại hiện đại là vấn đề cần thiết kế và quản lý, không phải một kết luận tự động tốt hay xấu.',
      english: 'Official renewal practice treats the relationship between heritage and modern commerce as something to design and manage, not as an automatic good-or-bad verdict.',
    ),
    keyTerms: const ['商业', '融合', '管理'],
    learnerInsight: '这正是林夏为什么需要修改分类，而不是把原来的负面词换成赞美词。',
    check: '林夏划掉“商业活动”是否表示所有商业都不会损害历史街区？',
    answer: '不是，她只是拒绝把商业自动等同于真实性下降。',
    sourceIds: const ['mofcom-kuanzhai-pedestrian-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 7,
    title: '街巷肌理怎样限制今天的动作',
    storyLink: '井巷子更窄，购买、穿行和驻足叠在一起，旧尺度反过来限制人的移动。',
    entry: _discovery(
      '保护街巷肌理意味着保留道路宽度、院落关系、入口节奏等空间特征；这些特征今天仍会影响人流、停留、经营布置和进入院落的方式。',
      simpleChinese: '历史空间不是背景，它会实际约束今天的人怎样移动。',
      vietnamese: 'Cấu trúc phố-ngõ lịch sử vẫn ảnh hưởng đến dòng người, điểm dừng, cách bố trí kinh doanh và lối vào sân ngày nay.',
      english: 'Historic street-and-alley morphology still shapes circulation, stopping, commercial layout, and courtyard access today.',
    ),
    keyTerms: const ['街巷肌理', '人流', '空间尺度'],
    learnerInsight: '“仍在使用”不是抽象口号，而是空间继续对身体和行为产生作用。',
    check: '旧街巷尺度今天还会影响什么？',
    answer: '会影响人流、停留、经营布置和进入院落的方式。',
    sourceIds: const ['mofcom-kuanzhai-pedestrian-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 8,
    title: '什么叫嵌入式更新',
    storyLink: '林夏确认保护更新既处理历史遗存，也处理现代使用。',
    entry: _discovery(
      '成都的城市更新实践提出在既有建筑和街区条件中进行“嵌入式”改善，让新功能进入旧空间时尽量延续原有尺度、院落语言和城市关系，而不是简单拆除重建。',
      simpleChinese: '新用途可以进入旧空间，但应受原有空间关系约束。',
      vietnamese: 'Cải tạo kiểu “nhúng” đưa chức năng mới vào kết cấu hiện hữu, cố gắng duy trì tỷ lệ, ngôn ngữ sân nhà và quan hệ đô thị thay vì phá bỏ xây mới đơn giản.',
      english: 'Embedded renewal introduces new functions into existing fabric while retaining the scale, courtyard language, and urban relationships of the old space.',
    ),
    keyTerms: const ['嵌入式更新', '既有建筑', '院落'],
    learnerInsight: '林夏开始区分“用途是新的”和“空间关系被消失”这两件事。',
    check: '嵌入式更新的方向更接近拆除重建，还是在既有空间中改善使用？',
    answer: '在既有空间中改善并延续使用。',
    sourceIds: const ['chengdu-gov-kuanzhai-embedded-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 9,
    title: '使用痕迹能证明什么',
    storyLink: '杯底水圈、椅脚亮痕和门槛凹痕让林夏把不同年代的接触放在一起读。',
    entry: _discovery(
      '历史建筑保护中的“活化利用”关注建筑在保存历史信息的同时继续承担合适功能；反复开启、行走、停留和维护形成的痕迹，可以帮助观察者理解空间是否仍参与现实生活。',
      simpleChinese: '使用痕迹不是年代证书，却能帮助判断空间今天怎样继续发挥作用。',
      vietnamese: 'Dấu vết sử dụng không tự chứng minh niên đại, nhưng giúp quan sát cách không gian lịch sử tiếp tục tham gia đời sống hiện tại.',
      english: 'Use traces do not prove age by themselves, but they can reveal how historic space continues to participate in present-day life.',
    ),
    keyTerms: const ['使用痕迹', '活化利用', '现实生活'],
    learnerInsight: '调查表最终记录的不只是旧材料，还记录“空间仍承担什么”。',
    check: '椅脚磨痕能否单独证明建筑年代？',
    answer: '不能，但能帮助观察现实使用方式。',
    sourceIds: const ['sichuan-gov-historic-building-use'],
  ),
  ChengduDiscoverySpec(
    level: 10,
    title: '保存是否必须让时间停住',
    storyLink: '林夏提交有删除线的原表，让旧判断和新判断同时可见。',
    entry: _discovery(
      '宽窄巷子的保护与利用实践表明，历史街区可以在保留街巷院落和建筑特征的同时继续承担现实功能；真正需要持续判断的是哪些新活动延续空间、哪些活动会遮蔽或损害历史信息。',
      simpleChinese: '保护不是把街区冻结，也不是放任所有变化，而是持续判断新使用与历史空间的关系。',
      vietnamese: 'Bảo tồn không phải đóng băng khu phố cũng không phải chấp nhận mọi thay đổi; cần liên tục đánh giá cách sử dụng mới tác động đến thông tin và cấu trúc lịch sử.',
      english: 'Conservation is neither freezing a district nor accepting every change; it requires continuing judgment about how new use affects historic information and spatial structure.',
    ),
    keyTerms: const ['保护', '利用', '历史信息'],
    learnerInsight: '调查表上的删除线保留了这种判断过程本身。',
    check: '故事最后为什么不把“商业活动”改成一个完全正面的标签？',
    answer: '因为重点是重新分类和持续判断，而不是把所有商业一律肯定。',
    sourceIds: const ['mofcom-kuanzhai-pedestrian-renewal', 'chengdu-gov-kuanzhai-embedded-renewal'],
  )
]);

final chengduKuanzhaiOnePassDiscoveries =
    List<DiscoveryEntry>.unmodifiable([
  for (final spec in chengduKuanzhaiDiscoverySpecs) spec.entry,
]);

final chengduKuanzhaiDiscoveryTraces =
    List<RemediatedDiscoveryTrace>.unmodifiable([
  for (final spec in chengduKuanzhaiDiscoverySpecs)
    RemediatedDiscoveryTrace(
      discoveryIndex: spec.level - 1,
      storyEventIds: const ['CD-E3-observe', 'CD-E4-tea-table'],
      sourceIds: spec.sourceIds,
    ),
]);

String _storySentence(int level, {required bool last}) {
  final story = chengduKuanzhaiOnePassLevels[level - 1].storyParagraphs.join();
  final matches = RegExp(r'[^。！？!?]+[。！？!?]').allMatches(story).toList();
  if (matches.isEmpty) return story;
  return (last ? matches.last : matches.first).group(0)!;
}

final chengduKuanzhaiChallenges = List<ChengduChallengeSpec>.unmodifiable([
  for (var level = 1; level <= 10; level++) ...[
    ChengduChallengeSpec(
      level: level,
      type: 'paragraphRebuild',
      anchor: _storySentence(level, last: false),
      answer: _storySentence(level, last: false),
    ),
    ChengduChallengeSpec(
      level: level,
      type: 'grammarRepair',
      anchor: _storySentence(level, last: false),
      answer: _storySentence(level, last: false),
    ),
    ChengduChallengeSpec(
      level: level,
      type: 'missingSentence',
      anchor: _storySentence(level, last: true),
      answer: _storySentence(level, last: true),
    ),
  ],
]);

final chengduKuanzhaiMemory = List<RemediatedMemoryReview>.unmodifiable([
  const RemediatedMemoryReview(category: 'protagonist', prompt: '谁完成这次宽窄巷子使用痕迹调查？', answer: '林夏，二十四岁的成都本地建筑系研究生。', storyEventIds: ['CD-E1-survey']),
  const RemediatedMemoryReview(category: 'assignment', prompt: '她的课程任务是什么？', answer: '用调查表记录历史街区今天怎样被进入、停留、经营、维护和使用。', storyEventIds: ['CD-E1-survey']),
  const RemediatedMemoryReview(category: 'initialBelief', prompt: '林夏最初怎样判断商业活动？', answer: '她认为商业越明显，历史真实性越容易被削弱，因此先把“商业活动”写进负面干扰项。', storyEventIds: ['CD-E2-preclassify']),
  const RemediatedMemoryReview(category: 'route', prompt: '她比较了哪些核心街巷？', answer: '宽巷子、窄巷子和井巷子，并把院落、门、门槛和人流放在同一份观察中。', storyEventIds: ['CD-E3-observe']),
  const RemediatedMemoryReview(category: 'space', prompt: '院落为什么不是静止背景？', answer: '门、廊、院仍在组织进出、停留、让路、添水和交谈，旧空间继续影响今天的行为。', storyEventIds: ['CD-E3-observe', 'CD-E4-tea-table']),
  const RemediatedMemoryReview(category: 'history', prompt: '宽窄巷子的历史空间从哪里读出来？', answer: '从三条核心巷道、院落、青砖与砖木建筑等历史空间特征，以及保护更新后仍可读的街巷肌理。', storyEventIds: ['CD-E3-observe']),
  const RemediatedMemoryReview(category: 'preservation', prompt: '故事是否把所有商业都改判为“好”？', answer: '没有。林夏只是停止把商业自动等同于真实性下降，转而判断哪些使用延续空间、哪些变化会遮蔽历史信息。', storyEventIds: ['CD-E5-reclassify']),
  const RemediatedMemoryReview(category: 'turningPoint', prompt: '茶桌旁的什么证据改变了她的分类？', answer: '茶桌旁椅脚磨亮的砖面、杯底水圈、门槛凹痕与持续发生的坐下、起身、让路和服务流线。', storyEventIds: ['CD-E4-tea-table']),
  const RemediatedMemoryReview(category: 'climax', prompt: '林夏在调查表上做了什么？', answer: '她把“商业活动”四个字划掉，在旁边写：“仍在使用。”', storyEventIds: ['CD-E5-reclassify']),
  const RemediatedMemoryReview(category: 'anchor', prompt: 'Memory Anchor是什么？', answer: '调查表上被划掉的“商业活动”四个字，旁边保留手写的“仍在使用。”', storyEventIds: ['CD-E5-reclassify', 'CD-E6-submit']),
  const RemediatedMemoryReview(category: 'ending', prompt: '第二天她为什么不誊清报告？', answer: '她提交原来的调查页，让旧判断、删除线和新判断同时可见。', storyEventIds: ['CD-E6-submit']),
  const RemediatedMemoryReview(category: 'vocabulary', prompt: '“使用痕迹”和“街巷肌理”怎样连接？', answer: '使用痕迹记录身体与物件留下的变化；街巷肌理说明这些变化发生在怎样的门、巷、院空间关系中。', storyEventIds: ['CD-E3-observe', 'CD-E4-tea-table']),
]);

const chengduKuanzhaiCompletion = ChengduCompleteSpec(
  journeySummary: '林夏带着“商业越多、历史越不真实”的判断进入宽窄巷子，通过三条巷道、院落、门槛、茶桌和人流的使用痕迹重新分类现代活动，并把修改保留在原调查表上。',
  achievement: '巷院痕迹观察者',
  memoryAnchor: '调查表上被划掉的“商业活动”四个字',
  anchorMeaning: '删除线保留了林夏原来的学术判断，也让她依据现场证据做出的修正保持可见。',
  challengeReward: '巷院使用印记',
  rewardMeaning: '以调查笔迹与院落使用痕迹为意象，代表能从门、巷、院和现实活动中读出空间连续性。',
  rewardUnlockText: '你已完成成都宽窄巷子三种故事挑战，解锁「巷院使用印记」。',
  journeyCompletion: '第二天，林夏提交原调查表：被划掉的“商业活动”仍在纸上，旁边写着“仍在使用。”',
);

const chengduKuanzhaiSources = <RemediatedSourceBinding>[
  RemediatedSourceBinding(
    id: 'chengdu-gov-kuanzhai-alley',
    publisher: 'China Daily Government Portal',
    scope: '宽巷子、窄巷子、井巷子三条核心街巷，清代以来的历史背景，以及院落、茶饮、餐饮和现实使用',
  ),
  RemediatedSourceBinding(
    id: 'mofcom-kuanzhai-pedestrian-renewal',
    publisher: '中华人民共和国商务部',
    scope: '成都历史文化街区保护利用、街巷院机理，以及历史文化传承与现代商业融合的更新实践',
  ),
  RemediatedSourceBinding(
    id: 'chengdu-gov-kuanzhai-embedded-renewal',
    publisher: '成都市政务服务网',
    scope: '既有建筑和院落中的嵌入式更新、旧空间语言与新功能的协调',
  ),
  RemediatedSourceBinding(
    id: 'sichuan-gov-historic-building-use',
    publisher: '四川省人民政府',
    scope: '历史建筑保护、活化利用与城市有机更新中的现实使用',
  ),
];

const chengduKuanzhaiSemanticEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(id: 'CD-E1-survey', coreChinese: '林夏带着使用痕迹调查表进入宽窄巷子。', corePinyin: 'Lín Xià dài zhe shǐyòng hénjì diàochá biǎo jìnrù Kuānzhǎi Xiàngzi.', coreVietnamese: 'Lâm Hạ mang phiếu khảo sát dấu vết sử dụng vào khu Kuanzhai.', coreEnglish: 'Lin Xia enters Kuanzhai Alley with a use-trace survey.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E2-preclassify', coreChinese: '她先把“商业活动”写成影响历史真实性的负面因素。', corePinyin: 'Tā xiān bǎ shāngyè huódòng xiěchéng lìshǐ zhēnshíxìng de fùmiàn yīnsù.', coreVietnamese: 'Ban đầu cô ghi hoạt động thương mại như một yếu tố tiêu cực đối với tính xác thực lịch sử.', coreEnglish: 'She initially records commercial activity as a negative factor for historical authenticity.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E3-observe', coreChinese: '她比较三条巷子里的门、院、门槛、街巷肌理和现实人流。', corePinyin: 'Tā bǐjiào sān tiáo xiàngzi lǐ de mén, yuàn, ménkǎn, jiēxiàng jīlǐ hé rénliú.', coreVietnamese: 'Cô so sánh cửa, sân, ngưỡng cửa, cấu trúc phố-ngõ và dòng người ở ba ngõ.', coreEnglish: 'She compares doors, courtyards, thresholds, urban fabric, and circulation across the three alleys.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E4-tea-table', coreChinese: '茶桌旁的挪椅、添水、让路和磨痕让她看见院落仍在组织生活。', corePinyin: 'Chá zhuō páng de nuóyǐ, tiānshuǐ, rànglù hé móhén ràng tā kànjiàn yuànluò réng zài zǔzhī shēnghuó.', coreVietnamese: 'Việc kéo ghế, châm nước, nhường đường và dấu mòn quanh bàn trà cho cô thấy sân nhà vẫn đang tổ chức đời sống.', coreEnglish: 'Movement around a tea table shows the courtyard still organizing lived activity.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E5-reclassify', coreChinese: '林夏把“商业活动”划掉，在旁边写“仍在使用。”', corePinyin: 'Lín Xià huàdiào shāngyè huódòng, zài pángbiān xiě réng zài shǐyòng.', coreVietnamese: 'Lâm Hạ gạch bỏ “hoạt động thương mại” và viết bên cạnh “vẫn đang được sử dụng”.', coreEnglish: 'Lin Xia crosses out “commercial activity” and writes “still in use” beside it.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E6-submit', coreChinese: '第二天她提交没有誊清的原调查页，保留删除线和补写。', corePinyin: 'Dì èr tiān tā tíjiāo méiyǒu téngqīng de yuán diàochá yè.', coreVietnamese: 'Hôm sau cô nộp trang khảo sát gốc, giữ nguyên dòng gạch bỏ và phần viết bổ sung.', coreEnglish: 'The next day she submits the original survey page with both the cross-out and handwritten revision visible.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
];

final chengduKuanzhaiOnePassRemediation = RemediatedJourney(
  id: chengduKuanzhaiJourneyId,
  title: '成都 · 宽窄巷子：仍在使用',
  protagonist: '林夏',
  goal: '完成宽窄巷子使用痕迹调查，判断历史院落在现代经营与公共活动中如何继续发挥空间作用。',
  conflict: '林夏必须检验自己的预设：商业活动是否一出现就必然削弱历史真实性，还是某些现实使用本身也构成历史空间继续存在的证据。',
  eventIds: List<String>.unmodifiable([
    for (final event in chengduKuanzhaiSemanticEvents) event.id,
  ]),
  events: chengduKuanzhaiSemanticEvents,
  levels: chengduKuanzhaiOnePassLevels,
  words: chengduKuanzhaiOnePassWords,
  wordTraces: chengduKuanzhaiWordTraces,
  discoveries: chengduKuanzhaiOnePassDiscoveries,
  discoveryTraces: chengduKuanzhaiDiscoveryTraces,
  challenges: List<RemediatedChallengeTrace>.unmodifiable([
    for (final challenge in chengduKuanzhaiChallenges)
      RemediatedChallengeTrace(
        type: challenge.type,
        storyEventIds: const ['CD-E2-preclassify', 'CD-E4-tea-table', 'CD-E5-reclassify'],
        anchor: challenge.anchor,
      ),
  ]),
  memory: chengduKuanzhaiMemory,
  completion: const RemediatedCompletion(
    journeySummary: '林夏从预先把商业活动判为真实性干扰，转向依据院落使用痕迹区分遮蔽与延续，并把这次修正留在原调查表上。',
    achievement: '巷院痕迹观察者',
    memoryAnchor: '调查表上被划掉的“商业活动”四个字',
    challengeReward: '巷院使用印记：由调查笔迹、门槛与院落使用痕迹组成的观察徽记。',
    journeyCompletion: '第二天，林夏提交原调查表；删除线旁仍写着“仍在使用。”',
  ),
  sources: chengduKuanzhaiSources,
);

JourneyLevelContent chengduKuanzhaiOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = chengduKuanzhaiOnePassLevels[level - 1];
  final story = base.storyParagraphs.join();
  final visibleWords = chengduKuanzhaiOnePassWords
      .where((entry) => story.contains(entry.word))
      .take((4 + level).clamp(5, 12))
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: List<WordEntry>.unmodifiable(visibleWords),
    discoveries: List<DiscoveryEntry>.unmodifiable(
      <DiscoveryEntry>[chengduKuanzhaiDiscoverySpecs[level - 1].entry],
    ),
    wonderQuestion: '为什么茶桌旁的使用痕迹让林夏不能继续把“商业活动”当成单一负面因素？',
    expressQuestion: '调查表上的删除线与“仍在使用。”怎样改变你对历史空间保护的理解？',
  );
}
