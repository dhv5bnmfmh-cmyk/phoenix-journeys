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
  narrativeIdentity: 'courtyard-chair-handoffs-create-shared-use-rhythm',
  protagonistArchetype: 'young-teahouse-courtyard-host-facilitating-changing-use',
  storyGoal: 'keep-courtyard-usable-for-tea-staying-and-passage-across-changing-moments',
  conflictType: 'fixed-space-assignment-vs-time-dependent-shared-use',
  climaxType: 'regular-participant-independently-reproduces-chair-handoff-before-host-intervenes',
  resolutionType: 'repeated-temporary-handoffs-create-a-shared-use-protocol',
  memoryAnchorType: 'bamboo-chair-without-a-fixed-position',
  movementPattern: 'chair-repeatedly-yields-to-passage-and-returns-to-tea-use-at-courtyard-threshold',
  temporalPattern: 'single-afternoon-use-cycle-without-external-countdown',
  supportingStructure: 'courtyard-host-and-older-regular-negotiate-and-share-the-handoff',
  endingMechanism: 'another-user-moves-the-chair-without-instruction-and-the-host-does-not-intervene',
  centralMetaphor: 'shared-space-can-be-kept-usable-through-handoff-rather-than-permanent-ownership',
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

ReadingAnnotation _chengduAnnotation(int level, int paragraph) => ReadingAnnotation(
      pinyin: paragraph == 0
          ? 'Lín Xià zài Kuānzhǎi Xiàngzi de yuànluò cháguǎn zhàokàn zuòwèi hé chūrù, yì bǎ zhúyǐ zài cházhuō hé tōngxíng zhījiān fǎnfù jiāojiē.'
          : 'Zhōu Shū bù zài děng Lín Xià tíxǐng, zìjǐ yíkāi zhúyǐ ràng rén tōngguò, ránhòu bǎ yǐzi fàng huí cházhuō páng.',
      vietnamese: paragraph == 0
          ? 'Lâm Hạ, 24 tuổi, là nhân viên trẻ phụ trách sân của một quán trà trong khu Kuanzhai. Một chiếc ghế tre phải liên tục nhường chỗ giữa việc ngồi uống trà và lối đi qua cửa sân.'
          : 'Chú Chu, một khách quen lớn tuổi, dần cùng tham gia việc bàn giao chỗ. Ở cao trào, ông tự dời ghế cho người đi qua rồi đặt lại cạnh bàn trà mà không cần Lâm Hạ nhắc.',
      english: paragraph == 0
          ? 'Lin Xia, 24, is a young courtyard host at a teahouse in Kuanzhai Alley. One bamboo chair repeatedly yields between tea seating and passage through the courtyard entrance.'
          : 'Zhou Shu, an older regular, becomes a causal participant in the handoff. At the climax he independently moves the chair for passage and returns it to tea use without waiting for Lin Xia.',
    );

JourneyLevelContent _chengduLevel(int level, List<String> paragraphs) => JourneyLevelContent(
      storyParagraphs: List<String>.unmodifiable(paragraphs),
      storyAnnotations: List<ReadingAnnotation>.unmodifiable([
        for (var i = 0; i < paragraphs.length; i++) _chengduAnnotation(level, i),
      ]),
      words: const <WordEntry>[],
      discoveries: const <DiscoveryEntry>[],
      wonderQuestion: '',
      expressQuestion: '',
    );

final chengduKuanzhaiOnePassLevels = List<JourneyLevelContent>.unmodifiable([
  _chengduLevel(1, [
    '林夏把一把竹椅挪到宽窄巷子一间院落茶馆的门口，刚想请常来的周叔坐下，端茶的同事就要从这里进院。林夏二十四岁，负责照看院里的座位和进出。她把竹椅挪开，让人通过，再把椅子还到茶桌边。没多久，两位客人又到门口，椅子再次挡路。林夏本想给它找一个永远不动的位置，却发现坐茶和通行都要用这块地方。她和周叔约好：有人经过就挪开，门口空了再放回。后来客人再来，林夏还没起身，周叔已经把椅子移开；人过去后，他又把它放回茶桌边。林夏看着那把没有固定位置的竹椅，没有再伸手。'
  ]),
  _chengduLevel(2, [
    '林夏把一把竹椅放到宽窄巷子一间院落茶馆的门口，常来的周叔刚坐下，端着茶盘的同事就需要从门槛进院。二十四岁的林夏负责照看院里的座位和通行，她马上把椅子挪开，等同事过去后又放回茶桌旁。她觉得这样来回太乱，想替竹椅定一个固定位置。可是下午又有两位客人进院，门口需要让路；周叔也正好要坐着喝茶。林夏试着把椅子靠墙，服务的人转身时仍然不方便。她不再找“唯一正确”的位置，而是和周叔商量：通行开始时先让开，门口空下来再把椅子交还给茶桌。下一拨客人来到院门，林夏还没开口，周叔先起身移开竹椅。客人通过后，他把椅子重新放回。林夏第一次没有替别人安排位置，只看着院落里的停留和进出继续轮流发生。'
  ]),
  _chengduLevel(3, [
    '林夏把一把竹椅挪到宽窄巷子一间院落茶馆的入口，准备让常来的周叔坐在茶桌旁。周叔刚落座，端着茶盘的同事就从门口进来，椅背挡住了通行。二十四岁的林夏是这里的年轻院落接待员，平时负责座位、添茶和出入。她先把椅子挪到一旁，让茶盘过去，再把椅子放回周叔身边。几分钟后，两位新客人从巷子走进院落，同一块门口又需要空出来。林夏有点烦，觉得一把椅子不该整天来回移动，于是把它靠墙，想给它一个固定位置。',
    '固定位置很快又失效：靠墙的竹椅让端茶的人转身不便，周叔坐得离茶桌太远。林夏没有把椅子收走，也没有宣布它只属于周叔。她和周叔商量：谁看见通行开始，谁就先把椅子移开；门口空下来，再把它交还给茶桌。下午又一组客人进来时，林夏正给另一桌添水。她还没走到门边，周叔已经起身把竹椅挪开。客人经过后，他顺手将椅子放回茶桌边。林夏没有接手。院门重新打开，茶也继续喝，那把没有固定位置的竹椅又等着下一次交接。'
  ]),
  _chengduLevel(4, [
    '林夏把一把竹椅放到宽窄巷子一间院落茶馆的入口旁，常来的周叔刚坐下，端茶的同事便从门外进来。门槛和茶桌之间的通道不宽，椅背一横，茶盘就不好通过。林夏二十四岁，是负责院落座位、茶水和出入的年轻接待员。她熟练地把竹椅移到院墙边，让同事过去，再还给周叔。她原以为只要找好一个位置，下午就能一直保持整齐。可不久，两位客人从窄巷子方向进院，入口又要空出来；周叔同时还需要椅子喝茶。林夏把椅子再靠墙一点，服务的人转身时却仍被挡住，她第一次对这把总要移动的椅子感到不耐烦。',
    '林夏没有把通行或喝茶中的任何一方当成麻烦。她试着换问题：不是“椅子应该永远放哪儿”，而是“现在这几分钟谁需要这块地方”。她和周叔约定，门口有人进出时就把竹椅让开，通道恢复后再交还给茶桌；谁先看见下一次需要，谁就先动手。第二轮交接后，周叔已经不再等她提醒。下午又有客人跨过门槛，林夏正端着水壶，周叔先起身把竹椅挪到一旁；客人通过后，他又把椅子放回茶桌边。林夏犹豫了一下，没有重新摆正它。院落在停留和通行之间继续转换，一把没有固定位置的竹椅把这种临时交接留在动作里。'
  ]),
  _chengduLevel(5, [
    '林夏午后把一把竹椅放到宽窄巷子一间院落茶馆的入口旁。常来的周叔喜欢坐在靠门的茶桌边，看得到巷子，也方便和熟人打招呼。可他刚坐下，端着茶盘的同事就要跨过门槛，椅背挡住了从巷子进入院落的通道。二十四岁的林夏是茶馆的年轻院落接待员，负责座位、茶水和出入。她把竹椅移开，让茶盘通过，再把椅子交还给周叔。她熟悉这个院子，原以为只要把桌椅摆得足够准确，就能让茶客停留和服务通行同时顺畅。几分钟后，两位新客人从窄巷子方向进来，同一个入口又要让路。林夏把竹椅靠墙，想给它确定一个“正确位置”，但服务人员转身仍不方便，周叔也离茶桌太远。',
    '第二次失败让林夏不再追求永久布局。她没有把周叔赶离门边，也没有把竹椅永久收走，而是和他商量一个临时交接的节奏：有人从巷子进院或服务人员经过时，先把椅子挪开；通道空下来，再把它还给茶桌。周叔点头，并开始留意门口。之后一名同事端水出去，竹椅让开一次；另一桌客人离院，它又让开一次，每次都在通行结束后回到茶桌旁。傍晚前，又一组客人走近门槛，林夏正在院里给客人添茶。她还没开口，周叔已经自己起身，把竹椅移出通道。客人通过后，他顺手把椅子放回原来的茶桌边。林夏看见了，却没有接管。茶继续喝，路继续开合，一把没有固定位置的竹椅开始由不止一双手完成交接。'
  ]),
  _chengduLevel(6, [
    '午后的宽窄巷子人流不断。林夏把一把普通竹椅放到一间院落茶馆的入口旁，常来的周叔坐下喝茶。这个位置对茶客很方便，却也贴近从巷子跨过门槛、进入院落的通道。周叔刚端起茶碗，服务员便托着茶盘进门，椅背让本来就有限的转身空间更窄。林夏二十四岁，是负责院落座位、茶水和进出的年轻接待员。她先把竹椅挪到院墙边，让茶盘通过，再把它推回周叔的茶桌。她一直以为好的接待就是提前把每件东西安排到固定位置，于是趁门口空下，把竹椅重新摆得更靠里，想一次解决冲突。没过多久，两位访客从窄巷子方向进院，仍然需要同一段入口；而竹椅靠得太里，又妨碍服务人员绕过茶桌。',
    '林夏的第二次固定安排也失败了。她开始把注意力放在使用发生的先后，而不是寻找永久位置：周叔坐着喝茶是真的需要，端茶、进院和离院也都是真的需要，只是它们不必在同一秒占住同一块地方。她和周叔商量，谁先看见通行开始，谁就把竹椅移开；门口清空以后，再把椅子交还给茶桌。接下来的一个小时里，竹椅随着服务和客流几次往返，周叔也从被安排的人变成参与交接的人。傍晚前，一对客人走近门槛，林夏正背对入口添水。周叔先看见他们，没等提醒便起身把竹椅挪开。客人通过后，他又把椅子放回茶桌边，继续喝茶。林夏转身时只看见已经恢复的通道，没有再调整。院落的停留与通行开始依靠共同动作轮流发生，那把没有固定位置的竹椅也不再只听从她一个人的安排。'
  ]),
  _chengduLevel(7, [
    '午后，宽窄巷子的巷道里人流一阵紧、一阵松。林夏把一把普通竹椅放在一间院落茶馆入口旁，常来的周叔习惯坐在这里喝茶，既能看见巷子，又离茶桌近。可是院门、门槛和茶桌之间只有一段有限的转身空间。周叔刚坐下，服务员托着茶盘从巷子进入院落，椅背就把通道压窄。二十四岁的林夏是茶馆的年轻院落接待员，负责座位、添茶和出入。她先把竹椅移到墙边，让茶盘过去，再把椅子推回茶桌。她对自己的安排很有把握，觉得只要找到一个最合适的位置，就能让整个下午不再反复搬动。于是她把竹椅重新定在门边一个看似折中的点。几分钟后，两位客人从窄巷子方向进院，这个点仍挡住转身；她又把椅子靠里，下一次服务员端水出去时，茶桌旁的空间又被挤窄。她的固定布局连续两次失效，烦躁也跟着上来。',
    '林夏没有把周叔、访客或服务人员变成“错误的一方”。她终于把问题从永久归位改成时间顺序：同一个入口可以先服务通行，再恢复停留；同一把竹椅可以暂时让开，也可以在通道空下后回到茶桌。她和周叔约定，谁先看见下一次进出，谁就先移动椅子，不必等她批准。周叔第一次照做时还有点犹豫，第二次已经会在客人到门前前先起身。接下来的茶水往返、客人进院和离院，让竹椅反复完成几次短暂交接。傍晚前，一名新客人从宽巷子一侧转进门口，林夏正背对入口给另一桌添水。周叔先看见，自己把竹椅移开，让出门槛；客人通过后，他又把椅子放回茶桌旁。林夏转身时没有重新摆正，也没有表扬谁。院里的人继续喝茶，通道继续开合。她第一次相信，这个小院不必由她把每个位置永远控制住；一把没有固定位置的竹椅，已经把临时使用交给了不止一双手。'
  ]),
  _chengduLevel(8, [
    '午后，宽窄巷子的街巷与院落不断在“走过”和“停下”之间切换。林夏把一把普通竹椅放在一间院落茶馆的入口旁，常来的周叔喜欢坐在靠门的茶桌边，看巷子里的人来人往。院门从巷道收进小院，门槛后的转身空间不大，桌椅一靠近入口，就会直接影响服务和客流。周叔刚坐下，服务员托着茶盘进院，椅背已经挡住路线。二十四岁的林夏是茶馆的年轻院落接待员，负责座位、茶水与出入秩序。她熟练地把竹椅挪到墙边，让茶盘通过，再把它交还给周叔。她一直把“摆好以后不要再动”当成整齐和负责，于是趁门口空下，重新测着距离，把椅子放到一个自认为永久合适的位置。几分钟后，两位客人从窄巷子方向进入院落，同一处门口又需要更宽的转身；她把椅子往里挪，下一轮端水出去时，服务员又被桌角和椅背夹住。固定位置第二次失败，林夏忍不住叹气，周叔也看出她一直在和这把椅子较劲。',
    '林夏没有把冲突解释成谁更有资格占这个位置。喝茶的停留、服务员的往返、访客的进出都合理，真正变化的是发生的时刻。她不再寻找一张永久布局，而是和周叔商量一个简单的临时交接：入口开始通行时，竹椅先退出通道；门槛空下来，再把它放回茶桌；下一次谁先看到需要，谁就先动手。最初林夏仍会下意识伸手，随后她故意慢半拍，让周叔参与。服务员端水出去时，周叔移椅；一桌客人离院后，他又把椅子放回。这个动作不是写在纸上的规定，而是在院门、门槛、茶桌与人的身体之间一次次被练出来。傍晚前，一名第一次来的客人从宽巷子一侧走近院门，林夏正给另一桌添茶，完全没有发出指令。周叔看见来人，自己起身把竹椅移到墙边；客人跨过门槛后，他顺手把椅子还给茶桌。林夏转过身，只看见通道已经重新打开。她没有接管，也没有把椅子搬回所谓标准位置。茶继续喝，服务继续穿行，一把没有固定位置的竹椅让院落形成了可以被别人接续的共享节奏。'
  ]),
  _chengduLevel(9, [
    '午后，宽窄巷子的人流从宽巷子、窄巷子的街面不断进入沿巷院落，停留与通行在入口处交替发生。林夏把一把普通竹椅放在一间院落茶馆门边，常来的周叔习惯坐在靠入口的茶桌旁。这个位置既能看见巷子，也正贴着门槛后的转身区域。周叔刚坐下，服务员托着茶盘从街巷进入院落，椅背让本就有限的通道变得更窄。林夏二十四岁，是负责院落座位、茶水和出入的年轻茶馆接待员。她先把竹椅移到墙边，让茶盘通过，再把它交还给周叔。她对自己的空间安排一向有信心，认为负责就是提前决定每张桌椅该在哪里。于是她趁入口空下，给竹椅找了一个看似兼顾喝茶与通行的固定位置。几分钟后，两位客人从窄巷子方向来到院门，仍需要更大的转身空间；林夏把椅子往内收，下一次服务员端水离院，桌角和椅背又挤住路线。第二种固定位置也失败了。她越想把院子一次摆定，竹椅越随着实际使用被迫移动。',
    '林夏压下不耐烦，没有把周叔赶离茶桌，也没有要求所有进院的人绕路。她开始承认同一个小空间存在几种正当而不同步的需要：坐下喝茶需要停留，茶水服务需要往返，巷道与院落之间的入口需要保持可以打开的通路。宽窄巷子的街—巷—院关系让这些动作在同一个门口相遇，也让“固定分配”很快露出限制。林夏于是做了一个身体上的选择，而不是写规则：她和周叔约定，谁先看见通行开始，谁就先把竹椅退出入口；通行结束，再把它交还给茶桌。第一次周叔等她点头，第二次他主动起身；服务员进出、客人离院、另一组访客到来，让竹椅在下午反复完成短暂的让位和归还。傍晚前，一名第一次来的客人走近门槛，林夏正背对入口添水。周叔没有叫她，直接把竹椅挪到院墙边。客人顺利通过后，他又把椅子放回茶桌旁，继续端起茶碗。林夏转身时停了一瞬，没有重新摆椅。院落的共享使用已经不再只是她个人的安排：停留结束时可以交给通行，通行结束又可以回到停留。一把没有固定位置的竹椅，在不同人的手里维持着这段节奏。'
  ]),
  _chengduLevel(10, [
    '午后，宽窄巷子的街巷人流不断变化。宽巷子、窄巷子与井巷子构成历史街区的核心街巷，沿巷院落把街面的流动收进更小的入口、门槛和内部停留空间。林夏工作的茶馆就在这样一处院落里。她把一把普通竹椅放到门边，常来的周叔习惯坐在靠入口的茶桌旁，既能喝茶，也能看见巷子。这个位置对停留很合适，却紧贴从巷子跨过门槛进入院落的通路。周叔刚落座，服务员托着茶盘进门，椅背便压缩了转身空间。二十四岁的林夏是年轻的院落接待员，负责座位、茶水和进出。她先把竹椅挪到墙边，让茶盘通过，再将椅子交还给周叔。她一向相信，把桌椅一次摆到“正确位置”才算把空间管好，于是趁入口暂时空下，重新调整竹椅，想给它一个整日下午都不用改变的固定位置。几分钟后，两位客人从窄巷子方向来到门口，固定位置仍挡住进院的转身；她又把椅子往内收，下一次服务员端水离院时，桌角与椅背又挤住路线。第二个方案也失败了。林夏开始烦躁，因为每一种永久安排都只适合刚才那一刻。',
    '院落里，林夏没有把周叔的喝茶、服务员的往返或访客的通行判成不合理。真正冲突的是院落入口的有限空间与不断变化的使用时序：同一小块地方不能永久交给一种用途，却可以在不同时间服务不同的人。林夏放弃给竹椅指定永久归属，改成亲手建立交接节奏。她先示范：有人从巷子进院，竹椅就退出门槛；通道清空，椅子再放回茶桌。她邀请周叔一起留意下一次需要，谁先看见，谁先移动，不必等她发令。起初周叔仍看她一眼才动，后来服务员端茶、客人离院、另一桌有人经过，竹椅反复几次让位又归还，动作越来越自然。傍晚前，一名第一次来的客人从街巷转入院门，林夏正在另一桌添水，背对入口。周叔先看见来人，没有喊她，也没有等提示，自己起身把竹椅挪到院墙边；客人跨过门槛进入院落后，他又把椅子推回茶桌旁，继续喝茶。林夏转身时只看见已经打开又恢复的通路。她没有再伸手，也没有把椅子校正到某个标准点。茶客继续停留，服务人员继续穿行，院落在一轮轮临时交接中保持可用。最后，一位离桌的客人顺手又为经过的人移开同一把竹椅。林夏看着那只手完成动作，没有出声。一把没有固定位置的竹椅，已经把共享空间的节奏交给了下一位使用者。'
  ]),
]);

WordEntry _word(
  String word,
  String pinyin,
  String partOfSpeech,
  String simpleChinese,
  String vietnamese,
  String english,
  String symbol,
) => WordEntry(
      word: word,
      pinyin: pinyin,
      partOfSpeech: partOfSpeech,
      simpleChinese: simpleChinese,
      translation: vietnamese,
      englishDefinition: english,
      symbol: symbol,
    );

final chengduKuanzhaiOnePassWords = List<WordEntry>.unmodifiable([
  _word('宽窄巷子', 'Kuānzhǎi Xiàngzi', '名词（专名）', '成都重要历史文化街区。', 'Khu Kuanzhai ở Thành Đô', 'Kuanzhai Alley historic district', '🏘️'),
  _word('竹椅', 'zhúyǐ', '名词', '竹制的椅子；故事中是普通的日常座椅。', 'ghế tre', 'bamboo chair', '🪑'),
  _word('院落', 'yuànluò', '名词', '由建筑围合、连接入口与内部活动的院子空间。', 'sân nhà', 'courtyard', '🏡'),
  _word('茶馆', 'cháguǎn', '名词', '提供饮茶和停留的经营空间。', 'quán trà', 'teahouse', '🫖'),
  _word('茶桌', 'cházhuō', '名词', '喝茶时使用的桌子。', 'bàn trà', 'tea table', '🍵'),
  _word('通行', 'tōngxíng', '动词/名词', '从一个地方顺利经过。', 'đi qua, lưu thông', 'passage; to pass through', '🚶'),
  _word('挪开', 'nuókāi', '动词', '把东西移动到旁边，让出位置。', 'dời sang một bên', 'move aside', '↔️'),
  _word('门口', 'ménkǒu', '名词', '门的内外连接位置。', 'cửa ra vào', 'doorway; entrance', '🚪'),
  _word('门槛', 'ménkǎn', '名词', '门口下方横置、进出时跨过的构件。', 'ngưỡng cửa', 'threshold', '🧱'),
  _word('让路', 'rànglù', '动词', '把通道让出来给别人经过。', 'nhường đường', 'make way', '➡️'),
  _word('轮流', 'lúnliú', '副词/动词', '按先后次序交替进行。', 'luân phiên', 'take turns', '🔁'),
  _word('交接', 'jiāojiē', '动词/名词', '把正在使用或负责的东西交给下一方继续。', 'bàn giao', 'handoff; transfer', '🤝'),
]);

final chengduKuanzhaiWordTraces = List<RemediatedWordTrace>.unmodifiable([
  const RemediatedWordTrace(word: '宽窄巷子', eventId: 'CD-E1-opening', usage: 'Lv1 首次出现。', sourceText: '林夏把一把竹椅挪到宽窄巷子一间院落茶馆的门口，刚想请常来的周叔坐下，端茶的同事就要从这里进院。'),
  const RemediatedWordTrace(word: '竹椅', eventId: 'CD-E1-opening', usage: 'Lv1 首次出现。', sourceText: '林夏把一把竹椅挪到宽窄巷子一间院落茶馆的门口，刚想请常来的周叔坐下，端茶的同事就要从这里进院。'),
  const RemediatedWordTrace(word: '院落', eventId: 'CD-E1-opening', usage: 'Lv1 首次出现。', sourceText: '林夏把一把竹椅挪到宽窄巷子一间院落茶馆的门口，刚想请常来的周叔坐下，端茶的同事就要从这里进院。'),
  const RemediatedWordTrace(word: '茶馆', eventId: 'CD-E1-opening', usage: 'Lv1 首次出现。', sourceText: '林夏把一把竹椅挪到宽窄巷子一间院落茶馆的门口，刚想请常来的周叔坐下，端茶的同事就要从这里进院。'),
  const RemediatedWordTrace(word: '茶桌', eventId: 'CD-E2-first-handoff', usage: 'Lv1 首次出现。', sourceText: '她把竹椅挪开，让人通过，再把椅子还到茶桌边。'),
  const RemediatedWordTrace(word: '通行', eventId: 'CD-E3-fixed-fails', usage: 'Lv1 首次出现。', sourceText: '林夏本想给它找一个永远不动的位置，却发现坐茶和通行都要用这块地方。'),
  const RemediatedWordTrace(word: '挪开', eventId: 'CD-E2-first-handoff', usage: 'Lv1 首次出现。', sourceText: '她把竹椅挪开，让人通过，再把椅子还到茶桌边。'),
  const RemediatedWordTrace(word: '门口', eventId: 'CD-E1-opening', usage: 'Lv1 首次出现。', sourceText: '林夏把一把竹椅挪到宽窄巷子一间院落茶馆的门口，刚想请常来的周叔坐下，端茶的同事就要从这里进院。'),
  const RemediatedWordTrace(word: '门槛', eventId: 'CD-E2-first-handoff', usage: 'Lv2 首次出现。', sourceText: '林夏把一把竹椅放到宽窄巷子一间院落茶馆的门口，常来的周叔刚坐下，端着茶盘的同事就需要从门槛进院。'),
  const RemediatedWordTrace(word: '让路', eventId: 'CD-E3-fixed-fails', usage: 'Lv2 首次出现。', sourceText: '可是下午又有两位客人进院，门口需要让路；周叔也正好要坐着喝茶。'),
  const RemediatedWordTrace(word: '轮流', eventId: 'CD-E7-consequence', usage: 'Lv2 首次出现。', sourceText: '林夏第一次没有替别人安排位置，只看着院落里的停留和进出继续轮流发生。'),
  const RemediatedWordTrace(word: '交接', eventId: 'CD-E4-choice', usage: 'Lv3 首次出现。', sourceText: '院门重新打开，茶也继续喝，那把没有固定位置的竹椅又等着下一次交接。'),
]);

const chengduKuanzhaiWordFirstAppears = <String, int>{
  '宽窄巷子': 1,
  '竹椅': 1,
  '院落': 1,
  '茶馆': 1,
  '茶桌': 1,
  '通行': 1,
  '挪开': 1,
  '门口': 1,
  '门槛': 2,
  '让路': 2,
  '轮流': 2,
  '交接': 3,
};

DiscoveryEntry _discovery(
  String text, {
  required String simpleChinese,
  required String vietnamese,
  required String english,
}) => DiscoveryEntry(
      text: text,
      pinyin: 'Kuānzhǎi Xiàngzi de jiē, xiàng, yuàn yǔ dāngdài shǐyòng yīrán xiānghù liánjiē.',
      simpleChinese: simpleChinese,
      vietnamese: vietnamese,
      english: english,
    );

final chengduKuanzhaiDiscoverySpecs = List<ChengduDiscoverySpec>.unmodifiable([
  ChengduDiscoverySpec(
    level: 1,
    title: '三条核心街巷',
    storyLink: '故事发生在宽窄巷子的沿巷院落，入口直接连接街巷流动与院内停留。',
    entry: _discovery(
      '宽窄巷子街区由宽巷子、窄巷子和井巷子三条核心街巷及沿线院落共同构成。',
      simpleChinese: '宽巷子、窄巷子和井巷子共同组成街区核心。',
      vietnamese: 'Khu Kuanzhai gồm ba ngõ cốt lõi Kuan, Zhai và Jing cùng các sân nhà dọc tuyến.',
      english: 'Kuanzhai is organized around the three core lanes of Kuan, Zhai, and Jing together with courtyards along them.',
    ),
    keyTerms: const ['宽巷子', '窄巷子', '井巷子'],
    learnerInsight: '街巷与院落不是两个无关背景，而是连续的空间系统。',
    check: '宽窄巷子的三条核心街巷是什么？',
    answer: '宽巷子、窄巷子和井巷子。',
    sourceIds: const ['chengdu-gov-kuanzhai-alley'],
  ),
  ChengduDiscoverySpec(
    level: 2,
    title: '历史街区与院落',
    storyLink: '院门和门槛把巷道通行压缩到一个具体入口。',
    entry: _discovery(
      '官方资料把宽窄巷子的历史追溯到清代，并持续强调街巷、院落和传统建筑空间的保存。',
      simpleChinese: '历史价值来自街巷、院落和建筑关系，不只来自外观。',
      vietnamese: 'Tư liệu chính thức truy lịch sử khu phố về thời Thanh và nhấn mạnh việc bảo tồn ngõ, sân và cấu trúc kiến trúc.',
      english: 'Official material traces the district to the Qing period and emphasizes preservation of lanes, courtyards, and historic building fabric.',
    ),
    keyTerms: const ['清代', '院落', '历史空间'],
    learnerInsight: '入口、门槛和院落关系让今天的通行受到历史空间尺度影响。',
    check: '为什么Discovery不只看一面“老墙”？',
    answer: '因为街巷和院落的空间关系本身也是历史信息。',
    sourceIds: const ['chengdu-gov-kuanzhai-alley'],
  ),
  ChengduDiscoverySpec(
    level: 3,
    title: '街—巷—院的连续关系',
    storyLink: '停留与通行在同一个院落入口相遇。',
    entry: _discovery(
      '宽窄巷子的保护利用强调历史街巷和院落关系，院落与入口、街巷和内部活动共同形成连续使用空间。',
      simpleChinese: '院落不是孤立展品，而是街—巷—院关系中的一部分。',
      vietnamese: 'Sân nhà là một phần của quan hệ liên tục phố-ngõ-sân, nối lối vào với hoạt động bên trong.',
      english: 'Courtyards are part of a continuous street-lane-courtyard relationship linking entrances and internal activity.',
    ),
    keyTerms: const ['街', '巷', '院'],
    learnerInsight: '院落尺度会实际影响人怎样进入、停留和让路。',
    check: '院落为什么不能只当静态背景？',
    answer: '因为它仍与入口、街巷和现实活动相连。',
    sourceIds: const ['mofcom-kuanzhai-pedestrian-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 4,
    title: '现实使用与保护',
    storyLink: '故事把空间是否可用表现为停留和通行的实际关系。',
    entry: _discovery(
      '历史街区保护既要保存可识别的历史空间与建筑特征，也需要处理现实使用、维护和更新。',
      simpleChinese: '保护历史空间并不等于让现实使用停止。',
      vietnamese: 'Bảo tồn khu lịch sử vừa giữ thông tin không gian, vừa phải xử lý việc sử dụng, bảo dưỡng và cải tạo hiện tại.',
      english: 'Historic-district conservation preserves legible historic fabric while also addressing present use, maintenance, and renewal.',
    ),
    keyTerms: const ['保护', '现实使用', '更新'],
    learnerInsight: 'Discovery解释保护背景，不替林夏解释“正确答案”。',
    check: '保护是否等于停止所有现实使用？',
    answer: '不是，还需要处理合适的现实使用与维护。',
    sourceIds: const ['sichuan-gov-historic-building-use'],
  ),
  ChengduDiscoverySpec(
    level: 5,
    title: '茶饮为什么是实际使用',
    storyLink: '茶桌在故事中直接占用停留空间，并与服务通行发生关系。',
    entry: _discovery(
      '宽窄巷子的现实经营包含茶饮、餐饮等功能；在院落中，桌椅、服务与通行会共同影响空间怎样被使用。',
      simpleChinese: '茶不是装饰词，它会带来座位、服务和停留。',
      vietnamese: 'Trà không chỉ là hình ảnh trang trí; bàn ghế, phục vụ và việc dừng lại đều trực tiếp sử dụng không gian sân.',
      english: 'Tea use is not decorative branding: seating, service, and stopping directly occupy and organize courtyard space.',
    ),
    keyTerms: const ['茶饮', '座位', '通行'],
    learnerInsight: '茶桌只有进入Goal、Conflict和Choice，才成为故事机制。',
    check: '故事中的茶桌为什么不是成都风格装饰？',
    answer: '因为茶桌产生真实停留需求，并直接参与入口空间冲突。',
    sourceIds: const ['chengdu-gov-kuanzhai-alley', 'mofcom-kuanzhai-pedestrian-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 6,
    title: '商业与历史空间可以怎样相处',
    storyLink: '故事不判断商业“真不真实”，只处理茶馆日常使用怎样在历史空间中发生。',
    entry: _discovery(
      '商务部门对宽窄巷子的改造提升材料强调历史文化传承与现代商业融合，同时要求保护利用历史文化遗产。',
      simpleChinese: '现代功能进入历史街区，需要受历史空间和保护目标约束。',
      vietnamese: 'Tài liệu cải tạo nhấn mạnh sự kết hợp giữa di sản và thương mại hiện đại trong điều kiện bảo vệ giá trị lịch sử.',
      english: 'Official renewal material describes integrating modern commerce with heritage while retaining the duty to protect historic cultural assets.',
    ),
    keyTerms: const ['商业', '保护利用', '融合'],
    learnerInsight: '这项事实学习与林夏的椅子交接故事分层存在，不构成她的戏剧性“改判”。',
    check: 'Discovery是否证明所有商业都自动合适？',
    answer: '不是，现实利用仍需受保护目标和空间条件约束。',
    sourceIds: const ['mofcom-kuanzhai-pedestrian-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 7,
    title: '街巷肌理怎样影响移动',
    storyLink: '有限入口使不同使用不能永久同时占据同一位置。',
    entry: _discovery(
      '保护街巷肌理与空间尺度意味着保留道路、入口和院落之间的关系，这些关系今天仍会影响人流、停留和进入院落的方式。',
      simpleChinese: '历史空间的尺度会继续影响今天的人怎样移动。',
      vietnamese: 'Quy mô và cấu trúc phố-ngõ lịch sử vẫn ảnh hưởng tới dòng người, điểm dừng và cách vào sân.',
      english: 'Historic street-and-lane morphology still shapes circulation, stopping, and courtyard access today.',
    ),
    keyTerms: const ['街巷肌理', '空间尺度', '人流'],
    learnerInsight: '文化锚点的作用是制造具体空间约束，而不是提供地方气氛。',
    check: '街巷肌理今天还能影响什么？',
    answer: '会影响通行、停留和进入院落的方式。',
    sourceIds: const ['mofcom-kuanzhai-pedestrian-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 8,
    title: '嵌入式更新',
    storyLink: '故事中的现实功能发生在既有院落关系内，而不是把院落替换成新空间。',
    entry: _discovery(
      '成都的更新实践提出在既有建筑和街区条件中进行嵌入式改善，使新功能进入旧空间时尽量延续原有尺度与空间关系。',
      simpleChinese: '新功能可以进入旧空间，但应尊重原有空间关系。',
      vietnamese: 'Cải tạo kiểu nhúng đưa chức năng mới vào kết cấu hiện hữu và cố gắng duy trì quy mô cùng quan hệ không gian cũ.',
      english: 'Embedded renewal introduces new functions into existing fabric while seeking to retain established scale and spatial relationships.',
    ),
    keyTerms: const ['嵌入式更新', '既有建筑', '空间关系'],
    learnerInsight: '新的使用节奏受旧院落尺度约束，而不是把旧空间当空白容器。',
    check: '嵌入式更新更接近拆除重建还是在既有条件中改善？',
    answer: '在既有条件中改善并延续使用。',
    sourceIds: const ['chengdu-gov-kuanzhai-embedded-renewal'],
  ),
  ChengduDiscoverySpec(
    level: 9,
    title: '活化利用不是只保立面',
    storyLink: '故事关注院落怎样继续容纳停留、服务和通行。',
    entry: _discovery(
      '四川与成都的历史建筑保护材料把活化利用和城市有机更新作为现实保护工作的一部分。',
      simpleChinese: '历史建筑可以在保护历史信息的同时承担合适的现实功能。',
      vietnamese: 'Bảo tồn công trình lịch sử có thể đi cùng việc sử dụng phù hợp trong đời sống hiện tại.',
      english: 'Historic-building conservation can include appropriate contemporary use as part of ongoing urban renewal.',
    ),
    keyTerms: const ['活化利用', '历史建筑', '现实功能'],
    learnerInsight: '事实层说明“继续使用”存在政策与实践背景，故事层仍只讲一次下午的空间协作。',
    check: '活化利用是否只关心外立面？',
    answer: '不是，也关心历史建筑怎样继续承担合适功能。',
    sourceIds: const ['sichuan-gov-historic-building-use'],
  ),
  ChengduDiscoverySpec(
    level: 10,
    title: '保护与利用的持续协调',
    storyLink: '院落的通行与停留让“现实使用”成为可以具体讨论的空间问题。',
    entry: _discovery(
      '宽窄巷子的保护利用实践说明，历史街区可以在保留街巷、院落和建筑特征的同时承担现实功能；保护与利用需要持续协调。',
      simpleChinese: '保护不是冻结空间，也不是放任变化，而是在历史条件中协调现实使用。',
      vietnamese: 'Bảo tồn không đóng băng không gian cũng không thả nổi thay đổi; việc sử dụng hiện tại cần được điều phối trong điều kiện lịch sử.',
      english: 'Conservation neither freezes space nor accepts every change; contemporary use is coordinated within historic spatial conditions.',
    ),
    keyTerms: const ['保护', '利用', '协调'],
    learnerInsight: '这项学习解释地点背景，但不把椅子故事改写成保护理论结论。',
    check: '保护与利用是否只能二选一？',
    answer: '不是，历史街区需要在保护条件中持续协调现实使用。',
    sourceIds: const ['mofcom-kuanzhai-pedestrian-renewal', 'chengdu-gov-kuanzhai-embedded-renewal'],
  ),
]);

final chengduKuanzhaiOnePassDiscoveries = List<DiscoveryEntry>.unmodifiable([
  for (final spec in chengduKuanzhaiDiscoverySpecs) spec.entry,
]);

final chengduKuanzhaiDiscoveryTraces = List<RemediatedDiscoveryTrace>.unmodifiable([
  for (final spec in chengduKuanzhaiDiscoverySpecs)
    RemediatedDiscoveryTrace(
      discoveryIndex: spec.level - 1,
      storyEventIds: const ['CD-E1-opening', 'CD-E2-first-handoff', 'CD-E7-consequence'],
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
    ChengduChallengeSpec(level: level, type: 'paragraphRebuild', anchor: _storySentence(level, last: false), answer: _storySentence(level, last: false)),
    ChengduChallengeSpec(level: level, type: 'grammarRepair', anchor: _storySentence(level, last: false), answer: _storySentence(level, last: false)),
    ChengduChallengeSpec(level: level, type: 'missingSentence', anchor: _storySentence(level, last: true), answer: _storySentence(level, last: true)),
  ],
]);

final chengduKuanzhaiMemory = List<RemediatedMemoryReview>.unmodifiable([
  const RemediatedMemoryReview(category: 'protagonist', prompt: '林夏是谁？', answer: '林夏，二十四岁，是宽窄巷子一间院落茶馆负责座位、茶水和出入的年轻接待员。', storyEventIds: ['CD-E1-opening']),
  const RemediatedMemoryReview(category: 'participant', prompt: '周叔怎样参与故事？', answer: '周叔是常来的年长茶客，先需要竹椅，后来与林夏一起完成临时让位和归还。', storyEventIds: ['CD-E1-opening', 'CD-E6-climax']),
  const RemediatedMemoryReview(category: 'goal', prompt: '林夏要保持什么？', answer: '让院落既能让茶客停留，也能让服务人员和访客顺利通行。', storyEventIds: ['CD-E2-first-handoff']),
  const RemediatedMemoryReview(category: 'conflict', prompt: '固定位置为什么失败？', answer: '同一块入口空间在不同时间分别需要服务喝茶停留和通行，永久分给一种用途会妨碍另一种用途。', storyEventIds: ['CD-E3-fixed-fails']),
  const RemediatedMemoryReview(category: 'firstHandoff', prompt: '第一次交接发生什么？', answer: '林夏把竹椅挪开让茶盘通过，再把椅子交还给周叔和茶桌。', storyEventIds: ['CD-E2-first-handoff']),
  const RemediatedMemoryReview(category: 'secondHandoff', prompt: '第二次为什么证明固定方案不够？', answer: '新客人和服务人员再次需要入口，竹椅无论固定在门边还是靠里都会在另一个时刻妨碍使用。', storyEventIds: ['CD-E3-fixed-fails']),
  const RemediatedMemoryReview(category: 'choice', prompt: '林夏最后选择怎样管理竹椅？', answer: '她不再决定永久位置，而是让通行时先让位、通道空下后再归还，并让参与者一起完成交接。', storyEventIds: ['CD-E4-choice']),
  const RemediatedMemoryReview(category: 'climax', prompt: '高潮为什么不是林夏自己搬椅子？', answer: '周叔在林夏没有发令时独立把竹椅移开让客人通过，再放回茶桌，说明节奏已经成为共同动作。', storyEventIds: ['CD-E6-climax']),
  const RemediatedMemoryReview(category: 'consequence', prompt: '交接带来什么结果？', answer: '茶客能继续停留，服务和访客也能继续通过，院落在不同用途之间保持可用。', storyEventIds: ['CD-E7-consequence']),
  const RemediatedMemoryReview(category: 'transformation', prompt: '林夏的参与方式怎样改变？', answer: '她从想永久控制每个位置，变成帮助不同使用者把空间临时交给下一种需要。', storyEventIds: ['CD-E4-choice', 'CD-E7-consequence']),
  const RemediatedMemoryReview(category: 'anchor', prompt: 'Memory Anchor是什么？', answer: '一把没有固定位置的竹椅。', storyEventIds: ['CD-E8-ending']),
  const RemediatedMemoryReview(category: 'ending', prompt: '故事最后是谁移动竹椅？', answer: '一位离桌的客人顺手为经过的人移开同一把竹椅，林夏没有出声或接管。', storyEventIds: ['CD-E8-ending']),
]);

const chengduKuanzhaiCompletion = ChengduCompleteSpec(
  journeySummary: '林夏在宽窄巷子院落茶馆里放弃为竹椅寻找永久位置，与周叔通过反复让位和归还建立共享空间的临时交接节奏。',
  achievement: '院落节奏协调者',
  memoryAnchor: '一把没有固定位置的竹椅',
  anchorMeaning: '竹椅不断在茶桌与通道之间移动，记录的是临时使用权被交给下一种需要，而不是一个人的永久控制。',
  challengeReward: '共享交接印记',
  rewardMeaning: '以竹椅让位和归还的动作代表不同使用者可以共同维持历史院落的现实节奏。',
  rewardUnlockText: '你已完成成都宽窄巷子三种故事挑战，解锁「共享交接印记」。',
  journeyCompletion: '另一位使用者再次移动竹椅让出通道，随后茶桌恢复使用；林夏没有介入。',
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
    scope: '成都历史文化街区保护利用、街巷院肌理，以及历史文化传承与现代商业融合的更新实践',
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

const chengduKuanzhaiSourceDiscipline = <String, String>{
  'historic-lanes-courtyards-current-use': 'VERIFIED FACT',
  'street-lane-courtyard-circulation-link': 'SAFE NARRATIVE INFERENCE',
  'Lin-Xia-teahouse-role': 'FICTIONAL CHARACTER ACTION',
  'Zhou-Shu-regular-guest-role': 'FICTIONAL CHARACTER ACTION',
  'bamboo-chair-movement': 'FICTIONAL CHARACTER ACTION',
  'tea-service-and-dialogue': 'FICTIONAL CHARACTER ACTION',
};

const chengduKuanzhaiSemanticEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(id: 'CD-E1-opening', coreChinese: '林夏把一把竹椅放在宽窄巷子院落茶馆入口，周叔的茶座与进院通路立刻争用同一小块空间。', corePinyin: 'Lín Xià bǎ yì bǎ zhúyǐ fàng zài Kuānzhǎi Xiàngzi yuànluò cháguǎn rùkǒu.', coreVietnamese: 'Lâm Hạ đặt một ghế tre cạnh cửa sân; chỗ ngồi của chú Chu và lối vào lập tức cần cùng một khoảng nhỏ.', coreEnglish: 'Lin Xia places a bamboo chair at the courtyard entrance, where Zhou Shu’s tea seat and passage immediately need the same small area.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E2-first-handoff', coreChinese: '她先把竹椅挪开让茶盘通过，再把椅子交还给周叔和茶桌。', corePinyin: 'Tā xiān bǎ zhúyǐ nuókāi ràng chápán tōngguò, zài bǎ yǐzi jiāohuán gěi Zhōu Shū.', coreVietnamese: 'Cô dời ghế cho khay trà đi qua rồi trả ghế lại cho chú Chu.', coreEnglish: 'She first moves the chair aside for passage and returns it to Zhou Shu and the tea table.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E3-fixed-fails', coreChinese: '林夏两次尝试固定竹椅位置，都被下一轮合理的通行或停留需要打破。', corePinyin: 'Lín Xià liǎng cì chángshì gùdìng zhúyǐ wèizhi, dōu bèi xià yì lún shǐyòng dǎpò.', coreVietnamese: 'Hai lần Lâm Hạ cố định vị trí ghế đều thất bại trước nhu cầu sử dụng hợp lý tiếp theo.', coreEnglish: 'Two attempts to fix the chair permanently fail when the next legitimate use arrives.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E4-choice', coreChinese: '林夏放弃永久分配，改为通行时让位、通道清空后归还，并邀请周叔一起完成交接。', corePinyin: 'Lín Xià fàngqì yǒngjiǔ fēnpèi, gǎiwéi tōngxíng shí ràngwèi, qīngkōng hòu guīhuán.', coreVietnamese: 'Lâm Hạ bỏ phân bổ cố định, chuyển sang nhường chỗ khi có người qua và trả ghế sau đó, cùng chú Chu thực hiện bàn giao.', coreEnglish: 'Lin Xia abandons permanent allocation and establishes a yield-and-return handoff with Zhou Shu.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E5-repetition', coreChinese: '服务、进院和离院让竹椅反复在通道与茶桌之间交接。', corePinyin: 'Fúwù, jìnyuàn hé líyuàn ràng zhúyǐ fǎnfù zài tōngdào yǔ cházhuō zhījiān jiāojiē.', coreVietnamese: 'Phục vụ, vào sân và rời sân khiến ghế tre liên tục được bàn giao giữa lối đi và bàn trà.', coreEnglish: 'Service and arrivals repeatedly hand the bamboo chair between passage and tea use.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E6-climax', coreChinese: '林夏没有发令时，周叔独立移开竹椅让新客人通过，随后又把它放回茶桌。', corePinyin: 'Lín Xià méiyǒu fālìng shí, Zhōu Shū dúlì yíkāi zhúyǐ ràng xīn kèrén tōngguò.', coreVietnamese: 'Không cần Lâm Hạ ra hiệu, chú Chu tự dời ghế cho khách mới đi qua rồi đặt lại cạnh bàn trà.', coreEnglish: 'Without Lin Xia directing him, Zhou Shu independently moves the chair for a new arrival and returns it to tea use.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E7-consequence', coreChinese: '院落在茶客停留、服务往返与访客通行之间保持可用，共享节奏不再依赖林夏一个人。', corePinyin: 'Yuànluò zài tíngliú, fúwù yǔ tōngxíng zhījiān bǎochí kěyòng.', coreVietnamese: 'Sân vẫn dùng được giữa việc ngồi trà, phục vụ và đi qua; nhịp dùng chung không còn phụ thuộc riêng Lâm Hạ.', coreEnglish: 'The courtyard remains usable across tea, service, and passage, and the shared rhythm no longer depends on Lin Xia alone.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'CD-E8-ending', coreChinese: '最后，另一位使用者也顺手移动同一把没有固定位置的竹椅，林夏没有介入。', corePinyin: 'Zuìhòu, lìng yí wèi shǐyòngzhě yě shùnshǒu yídòng tóng yì bǎ méiyǒu gùdìng wèizhi de zhúyǐ.', coreVietnamese: 'Cuối cùng, một người dùng khác cũng tự dời chính chiếc ghế không có vị trí cố định, còn Lâm Hạ không can thiệp.', coreEnglish: 'Finally, another user moves the same chair without a fixed position while Lin Xia does not intervene.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
];

final chengduKuanzhaiOnePassRemediation = RemediatedJourney(
  id: chengduKuanzhaiJourneyId,
  title: '成都 · 宽窄巷子：没有固定位置的竹椅',
  protagonist: '林夏',
  goal: '让宽窄巷子院落茶馆同时保持茶客停留与入口通行，而不永久排除任何一种合理使用。',
  conflict: '有限院落入口无法靠一个固定座位布局持续满足随时间变化的茶座、服务与通行需求。',
  eventIds: List<String>.unmodifiable([for (final event in chengduKuanzhaiSemanticEvents) event.id]),
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
        storyEventIds: const ['CD-E2-first-handoff', 'CD-E4-choice', 'CD-E6-climax'],
        anchor: challenge.anchor,
      ),
  ]),
  memory: chengduKuanzhaiMemory,
  completion: const RemediatedCompletion(
    journeySummary: '林夏从永久安排院落位置，转向帮助周叔与其他使用者通过反复让位和归还共同维持空间节奏。',
    achievement: '院落节奏协调者',
    memoryAnchor: '一把没有固定位置的竹椅',
    challengeReward: '共享交接印记：竹椅在通道与茶桌之间反复让位和归还。',
    journeyCompletion: '另一位使用者再次移动竹椅让出通道；林夏没有介入。',
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
    discoveries: List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[chengduKuanzhaiDiscoverySpecs[level - 1].entry]),
    wonderQuestion: '为什么这把竹椅没有固定位置，反而让院落更容易同时服务停留与通行？',
    expressQuestion: '周叔在没有提醒时主动移椅，怎样证明共享节奏已经不只属于林夏？',
  );
}
