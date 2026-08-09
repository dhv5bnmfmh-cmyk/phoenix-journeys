import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const nanjingQinhuaiJourneyId = 'nanjing-qinhuai-river';
const nanjingQinhuaiSourceRecordId = 'nanjing-gov-fuzimiao-qinhuai';
const nanjingQinhuaiCanonicalTitle = '亮灯前七分钟';
const nanjingQinhuaiLegacyOpening = '夜色降临，你沿着秦淮河走向夫子庙';

class NanjingNarrativeDna {
  const NanjingNarrativeDna({
    required this.narrativeIdentity,
    required this.protagonistArchetype,
    required this.storyGoal,
    required this.relationshipType,
    required this.conflictType,
    required this.choiceType,
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
  final String relationshipType;
  final String conflictType;
  final String choiceType;
  final String climaxType;
  final String resolutionType;
  final String memoryAnchorType;
  final String movementPattern;
  final String temporalPattern;
  final String supportingStructure;
  final String endingMechanism;
  final String centralMetaphor;
}

const nanjingQinhuaiNarrativeDna = NanjingNarrativeDna(
  narrativeIdentity:
      'festival-lighting-deadline-rejects-unapproved-reroute-and-keeps-visible-dark-section',
  protagonistArchetype:
      'young-Qinhuai-lighting-technician-seeking-independent-professional-trust',
  storyGoal:
      'restore-a-safe-usable-Qinhuai-Lantern-Festival-route-before-opening',
  relationshipType:
      'assistant-to-trusted-technician-under-senior-lighting-supervisor',
  conflictType:
      'fast-spectacular-total-lighting-vs-approved-safe-heritage-sensitive-operation',
  choiceType:
      'reject-unapproved-last-minute-reroute-and-sacrifice-decorative-lighting',
  climaxType:
      'essential-route-lights-on-while-one-decorative-section-remains-dark',
  resolutionType:
      'safe-reduced-opening-with-visible-imperfection-and-earned-responsibility',
  memoryAnchorType:
      'dark-decorative-section-after-essential-route-lights-come-on',
  movementPattern: 'fixed-Qinhuai-riverside-failure-zone-not-tourism-walk',
  temporalPattern:
      'seven-minute-countdown-to-one-lantern-festival-opening-sequence',
  supportingStructure:
      'mentor-away-during-decision-then-returns-for-responsibility-transfer',
  endingMechanism:
      'mentor-hands-final-lighting-status-record-to-Wei-Zhou-to-own-and-report',
  centralMetaphor: 'successful-operation-can-leave-a-visible-absence',
);

const nanjingQinhuaiSupportedNarrativeFacts = <String>[
  '秦淮河及其两岸风貌属于风景名胜资源保护范围',
  '古桥梁属于受保护的风景名胜资源',
  '秦淮灯会属于保护传承的非物质文化遗产',
  '景区夜景照明受到专门管理',
  '照明等公用设施受规划、维护和安全要求约束',
  '移动或者改变公共设施需要依照规定取得批准',
];

const nanjingQinhuaiExcludedUnsupportedClaims = <String>[
  '电缆不得挂在古桥上',
  '临时照明电缆固定在古桥上被某一具体条文明确禁止',
  '某座具名古桥存在本故事所称的特殊布线禁令',
  '具体电压、回路拓扑、断路器行为或未被来源支持的电气标准',
];

class NanjingDiscoverySpec {
  const NanjingDiscoverySpec({
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

class NanjingChallengeSpec {
  const NanjingChallengeSpec({
    required this.level,
    required this.type,
    required this.prompt,
    required this.anchor,
    required this.answer,
  });

  final int level;
  final String type;
  final String prompt;
  final String anchor;
  final String answer;
}

class NanjingNarrativeDifference {
  const NanjingNarrativeDifference({
    required this.referenceJourneyId,
    required this.opening,
    required this.protagonist,
    required this.role,
    required this.relationship,
    required this.goal,
    required this.conflict,
    required this.choice,
    required this.consequence,
    required this.emotionalArc,
    required this.narrativeEngine,
    required this.climax,
    required this.ending,
    required this.culturalAnchor,
    required this.pace,
    required this.perspective,
    required this.memoryAnchor,
    required this.visualMotif,
    required this.specialMechanism,
  });

  final String referenceJourneyId;
  final String opening;
  final String protagonist;
  final String role;
  final String relationship;
  final String goal;
  final String conflict;
  final String choice;
  final String consequence;
  final String emotionalArc;
  final String narrativeEngine;
  final String climax;
  final String ending;
  final String culturalAnchor;
  final String pace;
  final String perspective;
  final String memoryAnchor;
  final String visualMotif;
  final String specialMechanism;
}

NanjingNarrativeDifference _difference(
  String referenceJourneyId,
  String referenceEngine,
) =>
    NanjingNarrativeDifference(
      referenceJourneyId: referenceJourneyId,
      opening: '七分钟倒计时中的现场故障，而非$referenceEngine的开场机制。',
      protagonist: '魏舟是秦淮灯会灯光技术员，不替换既有主角身份。',
      role: '负责公共开放前灯光状态的现场技术人员。',
      relationship: '周工缺席关键决定，结尾以责任移交改变师徒工作关系。',
      goal: '开场前恢复安全可用的秦淮灯会路线，而非理解景点。',
      conflict: '完整视觉效果与已确认、安全、遗产敏感的运行安排发生直接冲突。',
      choice: '魏舟本人拒绝未经确认的临时改线并主动牺牲装饰效果。',
      consequence: '路线开放，但一段装饰灯继续保持黑暗。',
      emotionalArc: '证明能力→压力→捷径诱惑→犹豫→负责→接受不完整→获得信任。',
      narrativeEngine: '单点运营故障倒计时，而非$referenceEngine。',
      climax: '必要通行灯亮起，同时古桥旁一段装饰灯仍然不亮。',
      ending: '周工把最终灯光状态记录交给魏舟填写和汇报，不做哲理总结。',
      culturalAnchor: '秦淮灯会＋秦淮河夜景＋古桥保护语境＋受管理夜景照明。',
      pace: '七分钟压缩式倒计时。',
      perspective: '第三人称贴近现场技术判断。',
      memoryAnchor: '亮灯以后仍然黑着的那一段装饰灯。',
      visualMotif: '河面反光与装饰暗段同时存在。',
      specialMechanism: '通过可见的不完整结果证明主动取舍，而非事后完美修复。',
    );

final nanjingQinhuaiDifferenceMatrix =
    List<NanjingNarrativeDifference>.unmodifiable([
  _difference('beijing-summer-palace', '摄影取景与旧照片回收'),
  _difference('beijing-forbidden-city', '宫殿维护边界与权限判断'),
  _difference('shanghai-bund', '亲子关系与渡江携带旧单据'),
  _difference('xian-city-wall', '跑步路线与搬家后的延续'),
  _difference('hangzhou-west-lake', '声音记录与雨中重新收音'),
  _difference('chengdu-kuanzhai-alley', '使用痕迹调查与分类修订'),
]);

JourneyLevelContent _nanjingLevel(List<String> paragraphs) {
  final single = paragraphs.length == 1;
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable([
      for (var i = 0; i < paragraphs.length; i++)
        ReadingAnnotation(
          pinyin: single
              ? 'QínHuái Dēnghuì liàngdēng qián qī fēnzhōng, Wèi Zhōu fùzé de gǔqiáo fùjìn dēngguāng fāshēng gùzhàng. Tā jùjué wèi jīng quèrèn de línshí gǎixiàn, bǎ tōngxíng zhàomíng liú zài ānquán pèizhì lǐ. Liàngdēng hòu, yí duàn zhuāngshì dēng réngrán hēizhe, Zhōu Gōng bǎ zuìzhōng zhuàngtài jìlù jiāo gěi tā.'
              : i == 0
                  ? 'QínHuái Dēnghuì liàngdēng qián qī fēnzhōng, Wèi Zhōu fùzé de gǔqiáo fùjìn zhuāngshì dēng fāshēng gùzhàng. Zhōu Gōng zài bié chù chǔlǐ yìcháng, Wèi Zhōu bìxū zìjǐ juédìng shìfǒu gǎibiàn yǐ quèrèn de zhàomíng ānpái.'
                  : 'Wèi Zhōu jùjué wèi jīng quèrèn de línshí gǎixiàn, xiān bǎozhèng tōngxíng zhàomíng. Liàngdēng hòu, hémiàn yǒu fǎnguāng, dàn gǔqiáo páng yí duàn zhuāngshì dēng réngrán hēizhe. Zhōu Gōng bǎ zuìzhōng dēngguāng zhuàngtài jìlù jiāo gěi Wèi Zhōu.',
          vietnamese: single
              ? 'Bảy phút trước khi lễ hội đèn Tần Hoài bật sáng, đoạn đèn gần cầu cổ do Ngụy Chu phụ trách gặp sự cố. Anh từ chối đổi tuyến tạm thời chưa được xác nhận, ưu tiên chiếu sáng lối đi an toàn. Khi mở tuyến, một đoạn đèn trang trí vẫn tối; kỹ sư Chu giao cho anh ghi và báo cáo trạng thái cuối cùng.'
              : i == 0
                  ? 'Bảy phút trước giờ bật đèn Lễ hội đèn Tần Hoài, đèn trang trí gần đoạn cầu cổ do Ngụy Chu phụ trách gặp sự cố. Kỹ sư Chu đang xử lý một lỗi khác, nên Ngụy Chu phải tự quyết định có thay đổi phương án chiếu sáng đã được xác nhận hay không.'
                  : 'Ngụy Chu từ chối đổi tuyến tạm thời chưa được xác nhận và ưu tiên chiếu sáng lối đi. Khi mở tuyến, mặt sông có ánh phản chiếu nhưng một đoạn đèn trang trí gần cầu cổ vẫn tối. Kỹ sư Chu giao cho anh ghi và báo cáo trạng thái cuối cùng.',
          english: single
              ? 'Seven minutes before the Qinhuai Lantern Festival lighting sequence, a section near an old bridge fails under Wei Zhou’s responsibility. He rejects an unconfirmed last-minute reroute and prioritizes safe route lighting. The route opens with one decorative section still dark, and Supervisor Zhou hands him responsibility for the final status record.'
              : i == 0
                  ? 'Seven minutes before the Qinhuai Lantern Festival lighting sequence, a decorative section near an old bridge fails. Supervisor Zhou is handling another fault, so Wei Zhou must decide whether to alter the already confirmed lighting arrangement.'
                  : 'Wei Zhou rejects the unconfirmed reroute and prioritizes route lighting. The river catches enough reflected light while a decorative section near the old bridge remains dark. Supervisor Zhou gives Wei Zhou responsibility for the final lighting status record.',
        ),
    ]),
    words: const <WordEntry>[],
    discoveries: const <DiscoveryEntry>[],
    wonderQuestion: '',
    expressQuestion: '',
  );
}

final nanjingQinhuaiOnePassLevels =
    List<JourneyLevelContent>.unmodifiable([
  _nanjingLevel([
    '离秦淮灯会亮灯还有七分钟，魏舟负责的秦淮河古桥附近一段灯突然不亮了。周工正在另一段处理问题，不能马上回来。魏舟发现，最快的办法是临时改动原来的照明线路，但这项改动没有经过确认，也来不及重新检查安全。他很想把所有灯都亮起来，最后还是停下了手。他保留原有安全方案，把能用的电力留给通行照明，放弃一段装饰灯。倒计时结束，河边的路亮了，人可以安全通过，水面也有灯影，那一段装饰灯仍然黑着。周工回来后没有替他重做，只把最终灯光状态记录交给魏舟填写。',
  ]),
  _nanjingLevel([
    '秦淮灯会亮灯前七分钟，年轻灯光技术员魏舟收到故障提示：秦淮河一处古桥旁的装饰灯没有响应。周工正在上游检查另一段线路，只能让魏舟先处理。魏舟过去一直跟着周工做安装，遇到现场变化常等他拍板，这次却必须自己判断。最快的办法是临时改线，让这段装饰灯重新亮起，可那会改变已经确认的照明安排，而且剩下的时间不够做完整的安全检查。魏舟盯着倒计时，最后没有动那条临时线路。他在原有方案里重新分配可用照明，先保证河边的通行灯，接受一段装饰灯继续熄灭。亮灯时，主要路线可以安全开放，河面有了反光，暗掉的装饰段也清楚可见。周工回来检查后，把最终状态记录递给魏舟：“这一段，你写。”',
  ]),
  _nanjingLevel([
    '离秦淮灯会的亮灯测试只剩七分钟，魏舟的对讲机里传来故障消息：秦淮河古桥附近一组装饰灯没有响应。周工正在更远的一段处理异常，暂时赶不过来。魏舟做过不少安装，却一直是跟着周工执行方案的人；他原本希望今晚能证明自己可以独立处理现场问题。眼前有一个快办法：临时改变已经确认的照明走向，把可用线路挪给故障区，整段灯可能重新亮起来。可是这里属于历史风貌敏感的河岸段，临时改动公用照明安排需要确认，剩下的时间也不够重新完成安全检查。',
    '魏舟把手从临时接线的位置收回来。他没有追求“全亮”，而是在原有安全配置里调整可用灯光：先保留行人需要的通行照明，再关掉一部分装饰负荷。倒计时走完，沿河主要路线亮起，灯光落在秦淮河上，桥边的人流可以继续移动；只有那一段装饰灯保持黑暗。周工赶回来，看了亮着的通行灯，又看了那片暗处，没有补做快捷改线。他把最终灯光状态记录交到魏舟手里，让他写清现场结果和自己的处理。',
  ]),
  _nanjingLevel([
    '秦淮灯会的试亮进入最后七分钟时，魏舟负责的河岸段突然报出故障。问题就在秦淮河古桥附近：一组装饰灯没有响应，而沿河开放时间已经逼近。周工正在上游处理另一处异常，短时间内无法赶回。魏舟跟着他做过多次安装和测试，但关键变化通常由周工决定。今晚他本来想靠一次漂亮的全亮效果证明自己已经不只是助手。故障旁边确实有一个快办法：临时改变既定照明的走向，把还能使用的供电安排挪到装饰段。这样也许能赶上亮灯，却意味着在历史风貌敏感的河岸区域临时改变已确认的照明设施安排，而现场已经没有足够时间重新核对安全。',
    '魏舟看着倒计时，没有执行那条临时改线。他把可用照明留在原有方案范围内，先保证河岸通行所需的灯，再主动减少一段装饰效果。最后几秒结束，主要路线按时亮起，秦淮河水面接到足够的反光，行人可以沿河安全通过；古桥旁却留下了一段清楚的暗区。魏舟知道那不是“全部修好”，也没有再碰快捷方案。周工回来后沿着亮区和暗区检查一遍，问了两句处理过程，随后把最终灯光状态记录递给魏舟，让他自己填写并报出这次缩减后的状态。',
  ]),
  _nanjingLevel([
    '距离秦淮灯会试亮只剩七分钟，魏舟负责的秦淮河河岸段突然出现故障：古桥附近一组装饰灯失去响应。人群已经在外围等待，沿河路线必须在规定时间前具备安全开放条件。周工正在上游处理另一处异常，只通过对讲机让魏舟先判断现场。魏舟跟随周工做了一年多安装与测试，能完成任务，却很少独自决定“少亮一部分”这样的结果。他今晚尤其想证明自己已经能把整段灯光完整交出去。故障点旁有一个诱人的快捷办法：临时改变已经确认的照明走向，把仍可使用的供电安排转向装饰灯。技术上动作不复杂，但它会改变既定设施安排；这里又是秦淮历史风貌敏感的河岸和古桥段，剩下的几分钟不足以完成必要的确认与安全复核。',
    '魏舟把准备动手的工具放下。他没有要求所有装饰灯恢复，而是在原有安全配置里重排可以使用的照明：通行照明优先，靠水一侧保留必要亮度，一段装饰灯被主动留在关闭状态。倒计时归零后，主要路线亮了，光落到秦淮河面上，能看见水流和人的移动；古桥旁那一截装饰灯却一直没有亮。开放没有因为这片黑暗而取消，人流按缩减后的路线条件进入。魏舟站在暗段前，没有再去尝试那条未经确认的临时改线。周工赶回来检查，确认通行区域和最终状态后，把灯光状态记录交给魏舟：“把为什么留暗、现在是什么状态，都由你写。”魏舟接过记录，没有等他替自己下结论。',
  ]),
  _nanjingLevel([
    '秦淮灯会正式亮灯前七分钟，魏舟负责的秦淮河沿岸控制区突然出现故障：古桥附近一段装饰灯没有响应。外围已经开始放行准备，主要通行路线必须在开场前保持可用。周工正被另一处异常拖在上游，只来得及通过对讲机说：“先判断，别等我。”魏舟听见这句话时反而更紧张。他一直想证明自己能独立收尾，却也知道“把灯全点亮”并不是唯一的交付条件。现场有一条最快的补救路径：临时改变已经确认的照明走向，把现有供电重新引向故障装饰段。这样可能救回完整效果，但会在秦淮历史风貌敏感的河岸与古桥附近改变既定设施安排，而且七分钟内无法完成重新确认和安全复核。',
    '魏舟把临时改线方案停在纸面上，没有执行。他按现有批准配置核对还能工作的灯，先保住连续的通行照明，再削减靠桥的一段装饰效果。倒计时归零，主要路线依次亮起；河面接住了足够的光，可以看清水流和行人的移动，但古桥旁仍留着一截明显的黑暗。开场按缩减后的状态继续，没有人去把那块暗处临时补亮。魏舟站在控制点看了几秒，确认它仍然黑着。周工回来后沿线检查，没有替他改回“全亮”。他把最终灯光状态记录和汇报责任一起交给魏舟，让他写明故障、留暗范围和实际开放状态。',
  ]),
  _nanjingLevel([
    '秦淮灯会开场倒计时进入最后七分钟时，魏舟负责的秦淮河沿岸段收到故障告警：古桥附近一组装饰灯停止响应。外围人群已经等待，河岸主要路线必须按时达到安全通行条件。周工正在上游排查另一处异常，无法赶回，只在对讲机里让魏舟自行判断。过去一年多，魏舟能把安装、测试和复查做得很快，但关键的现场取舍总由周工拍板；今晚他原本想用完整的灯光效果证明自己已经能独立负责。故障旁存在一个诱人的捷径：临时改变已经确认的照明与供电走向，把仍可用的部分重新转给装饰段。动作看起来能赶在开场前完成，可它会在秦淮历史风貌敏感的河岸和古桥环境里改变既定设施安排，而剩余时间不足以完成必要授权、核对与安全复核。',
    '魏舟把工具箱合上，明确放弃临时改线。他回到现有配置，逐段确认仍可使用的灯，把连续通行照明列为第一优先，再主动压缩靠桥的装饰亮度，让一整小段装饰灯保持关闭。倒计时结束，河岸主路线按顺序亮起，秦淮河水面出现断续的反光，行人可以看清脚下和前方；古桥旁却留下一个没有被补齐的暗口。那块黑暗一直保留到开放开始。魏舟没有把它当成必须掩盖的缺陷，也没有在最后一刻重新尝试捷径。周工回来后检查亮区、暗区和现场状态，只问魏舟是否确认可以按缩减配置开放。得到回答后，他把最终状态记录递过去，让魏舟自己签写处理说明并完成汇报。',
  ]),
  _nanjingLevel([
    '秦淮灯会亮灯序列启动前只剩七分钟，魏舟负责的秦淮河沿岸段突然出现故障告警：古桥附近一组装饰灯失去响应。外围等待区已经进入开放准备，河岸的连续通行照明必须按计划具备使用条件。周工正被上游另一处异常占住，只能通过对讲机要求魏舟先作现场判断。魏舟跟着周工完成过许多安装和试亮，熟悉设备，却很少承担“哪些效果可以放弃”的决定；他原本希望今晚交出一条完整、漂亮的灯带，让周工看到自己已经能独立负责。故障点恰好有一个速度很快的临时方案：改变既定照明与供电走向，把仍可使用的部分重新引到装饰段。视觉上它最接近“全部恢复”，但这意味着在秦淮历史风貌敏感的河岸和古桥附近临时改变已经确认的设施安排。没有授权，也没有足够时间重新核对安全，魏舟知道这不是一个可以只凭“来得及”就执行的选择。',
    '古桥旁，魏舟把临时方案划掉，转而在现有配置内重排优先级：先保持整段通行照明连续，再降低靠桥区域的装饰负荷，并把故障旁的一小段装饰灯明确留在关闭状态。倒计时归零，主要路线从远处依次亮起。光落进秦淮河，水面能映出移动的人影和灯色；古桥旁却没有出现完整的灯带，那一段黑暗像一道缺口，清楚地留在夜景里。开放按缩减后的状态继续，魏舟没有再去碰未经确认的改线。周工回来后先看通行区域，再看那段暗处，随后让魏舟说明自己的判断。听完后，他没有接过控制权，而是把最终灯光状态记录交给魏舟，让他写明故障、保留的安全照明和主动放弃的装饰范围，并由他完成现场汇报。',
  ]),
  _nanjingLevel([
    '秦淮灯会正式亮灯前七分钟，魏舟负责的秦淮河沿岸控制段突然报出故障：古桥附近的一组装饰灯完全失去响应。外围已经进入开场准备，人群很快就会沿河移动，因此真正不能中断的是连续、可识别的通行照明。周工此时正在上游处理另一处异常，无法赶回，只在对讲机里说了一句：“这段你先判断。”魏舟握着工具时意识到，这正是他一直想等到的机会。他跟随周工完成过安装、试亮和排障，却很少在时间压力下决定“什么可以不恢复”。眼前最快的办法，是临时改变已经确认的照明与供电走向，把仍能使用的部分重新引向故障装饰段。若只看视觉效果，这条路最漂亮；但它会在秦淮历史风貌敏感的河岸和古桥附近改变既定设施安排，而且剩余时间不足以取得必要确认并重新完成安全复核。一个未经确认的变化，即使能让灯带看起来完整，也会把新的未知状态带进马上开放的路线。',
    '魏舟没有执行临时改线。他按现有配置重新排序可用照明：连续通行灯保留，靠水一侧保持必要亮度，古桥旁的装饰负荷被主动削减，故障附近一段灯则明确保持关闭。倒计时走到零，河岸主路线逐段亮起，秦淮河水面收到足够的反光，人的移动清楚可见；与此同时，那截装饰灯始终没有亮，完整的灯带被留下一个缺口。开放没有因此取消，现场按缩减配置进入运行。魏舟在暗段前停了一会儿，没有把“还差一点”变成最后一次冒险。周工赶回来后沿线查看，确认通行状态，再让魏舟复述判断依据。听完，他只把最终灯光状态记录递给魏舟，并让他自己签写留暗范围、开放状态和后续处理。魏舟接过记录，第一次不是等待周工替他决定怎样收尾。',
  ]),
  _nanjingLevel([
    '秦淮灯会的正式亮灯序列进入最后七分钟，魏舟负责的秦淮河沿岸控制段突然发出故障告警：古桥附近一组装饰灯失去响应。外围已经进入开场准备，数分钟后人群将沿河移动，因此现场真正不可缺少的是连续、清晰并保持安全状态的通行照明。周工正被上游另一处异常牵住，无法返回，只通过对讲机让魏舟先作决定。这个指令让魏舟比故障本身更紧张。过去一年多，他能熟练完成安装、试亮和排障，却仍习惯把重大取舍留给周工；今晚他原本想用一条完整的灯带证明自己已经能独立交付。故障点附近确实存在一个最快的补救方案：临时改变已经确认的照明与供电走向，把仍能工作的部分重新引向装饰段。若只追求开场画面，它最接近理想结果；但这意味着在秦淮历史风貌敏感的河岸和古桥环境里，未经授权便改变既定设施安排，而且七分钟不足以重新完成必要的核对与安全复核。那不是一个单纯的技术动作，而是把未经确认的状态直接带进即将开放的公共空间。',
    '魏舟把临时改线从处理方案中删掉，转而在现有批准配置内重新排序目标：连续通行照明必须保留，靠水区域维持必要亮度，能够削减的装饰负荷则主动退出，古桥旁故障附近的一段装饰灯明确保持关闭。倒计时归零，主要路线从远处依次亮起。光落到秦淮河面，水流和移动的人影都能被看见；古桥旁却没有出现完整的灯带，那一截黑暗始终留在夜景里。开场按缩减配置继续，魏舟看见暗段后没有再尝试任何未经确认的补救。周工赶回来，先检查通行区域，再看那处没有亮的装饰段，随后要求魏舟说明为什么保留这个缺口。听完，他没有接管控制台，也没有替魏舟重写结果，只把最终灯光状态记录交给他，让他签写故障、缩减范围、开放状态和后续安排，并由他完成本段汇报。魏舟接过记录，开始填写第一行。',
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
) =>
    WordEntry(
      word: word,
      pinyin: pinyin,
      partOfSpeech: partOfSpeech,
      simpleChinese: simpleChinese,
      translation: vietnamese,
      englishDefinition: english,
      symbol: symbol,
    );

final nanjingQinhuaiOnePassWords = List<WordEntry>.unmodifiable([
  _word('秦淮灯会', 'Qínhuái Dēnghuì', '名词（专名）', '南京秦淮地区延续的灯会文化活动。', 'Lễ hội đèn Tần Hoài', 'Qinhuai Lantern Festival', '🏮'),
  _word('故障', 'gùzhàng', '名词', '设备不能按正常状态工作的情况。', 'sự cố', 'fault or malfunction', '⚠️'),
  _word('照明', 'zhàomíng', '名词/动词', '用灯光让道路或空间可以看清。', 'chiếu sáng', 'lighting or illumination', '💡'),
  _word('临时', 'línshí', '形容词', '为了眼前情况暂时采用的。', 'tạm thời', 'temporary', '⏱️'),
  _word('确认', 'quèrèn', '动词', '检查后确定一件事可以成立或执行。', 'xác nhận', 'to confirm', '✅'),
  _word('通行', 'tōngxíng', '动词/名词', '人可以安全通过一段道路或空间。', 'lưu thông; đi qua', 'passage or circulation', '🚶'),
  _word('装饰灯', 'zhuāngshìdēng', '名词', '主要用于形成视觉效果的灯。', 'đèn trang trí', 'decorative lighting', '✨'),
  _word('倒计时', 'dàojìshí', '名词/动词', '从剩余时间向零计算。', 'đếm ngược', 'countdown', '7️⃣'),
  _word('记录', 'jìlù', '名词/动词', '把现场状态和处理结果写下来。', 'ghi chép; bản ghi', 'record or to record', '📝'),
  _word('技术员', 'jìshùyuán', '名词', '负责技术操作、检查和处理问题的工作人员。', 'kỹ thuật viên', 'technician', '🧰'),
  _word('响应', 'xiǎngyìng', '动词', '设备接到控制后作出预期动作。', 'phản hồi', 'to respond', '📟'),
  _word('判断', 'pànduàn', '动词/名词', '根据现场信息作出决定。', 'phán đoán', 'judgment; to decide based on evidence', '🧭'),
  _word('对讲机', 'duìjiǎngjī', '名词', '现场工作人员短距离通话使用的通信设备。', 'bộ đàm', 'two-way radio', '📻'),
  _word('历史风貌', 'lìshǐ fēngmào', '名词', '历史环境形成并被保护的整体空间特征。', 'diện mạo lịch sử', 'historic character', '🏛️'),
  _word('配置', 'pèizhì', '名词/动词', '设备和资源已经安排好的组合方式。', 'cấu hình; bố trí', 'configuration', '🧩'),
  _word('复核', 'fùhé', '动词', '再次检查前面的判断或结果。', 'kiểm tra lại', 'to re-check or verify', '🔍'),
]);

final nanjingQinhuaiWordTraces =
    List<RemediatedWordTrace>.unmodifiable([
  const RemediatedWordTrace(word: '秦淮灯会', eventId: 'NJ-E1-deadline', usage: 'Lv1 首次出现。', sourceText: '离秦淮灯会亮灯还有七分钟，魏舟负责的秦淮河古桥附近一段灯突然不亮了。'),
  const RemediatedWordTrace(word: '故障', eventId: 'NJ-E1-deadline', usage: 'Lv2 首次出现。', sourceText: '秦淮灯会亮灯前七分钟，年轻灯光技术员魏舟收到故障提示：秦淮河一处古桥旁的装饰灯没有响应。'),
  const RemediatedWordTrace(word: '照明', eventId: 'NJ-E3-shortcut', usage: 'Lv1 首次出现。', sourceText: '魏舟发现，最快的办法是临时改动原来的照明线路，但这项改动没有经过确认，也来不及重新检查安全。'),
  const RemediatedWordTrace(word: '临时', eventId: 'NJ-E3-shortcut', usage: 'Lv1 首次出现。', sourceText: '魏舟发现，最快的办法是临时改动原来的照明线路，但这项改动没有经过确认，也来不及重新检查安全。'),
  const RemediatedWordTrace(word: '确认', eventId: 'NJ-E3-shortcut', usage: 'Lv1 首次出现。', sourceText: '魏舟发现，最快的办法是临时改动原来的照明线路，但这项改动没有经过确认，也来不及重新检查安全。'),
  const RemediatedWordTrace(word: '通行', eventId: 'NJ-E5-reduced-configuration', usage: 'Lv1 首次出现。', sourceText: '他保留原有安全方案，把能用的电力留给通行照明，放弃一段装饰灯。'),
  const RemediatedWordTrace(word: '装饰灯', eventId: 'NJ-E5-reduced-configuration', usage: 'Lv1 首次出现。', sourceText: '他保留原有安全方案，把能用的电力留给通行照明，放弃一段装饰灯。'),
  const RemediatedWordTrace(word: '倒计时', eventId: 'NJ-E6-visible-cost', usage: 'Lv1 首次出现。', sourceText: '倒计时结束，河边的路亮了，人可以安全通过，水面也有灯影，那一段装饰灯仍然黑着。'),
  const RemediatedWordTrace(word: '记录', eventId: 'NJ-E7-trust-transfer', usage: 'Lv1 首次出现。', sourceText: '周工回来后没有替他重做，只把最终灯光状态记录交给魏舟填写。'),
  const RemediatedWordTrace(word: '技术员', eventId: 'NJ-E1-deadline', usage: 'Lv2 首次出现。', sourceText: '秦淮灯会亮灯前七分钟，年轻灯光技术员魏舟收到故障提示：秦淮河一处古桥旁的装饰灯没有响应。'),
  const RemediatedWordTrace(word: '响应', eventId: 'NJ-E1-deadline', usage: 'Lv2 首次出现。', sourceText: '秦淮灯会亮灯前七分钟，年轻灯光技术员魏舟收到故障提示：秦淮河一处古桥旁的装饰灯没有响应。'),
  const RemediatedWordTrace(word: '判断', eventId: 'NJ-E2-responsibility', usage: 'Lv2 首次出现。', sourceText: '魏舟过去一直跟着周工做安装，遇到现场变化常等他拍板，这次却必须自己判断。'),
  const RemediatedWordTrace(word: '对讲机', eventId: 'NJ-E1-deadline', usage: 'Lv3 首次出现。', sourceText: '离秦淮灯会的亮灯测试只剩七分钟，魏舟的对讲机里传来故障消息：秦淮河古桥附近一组装饰灯没有响应。'),
  const RemediatedWordTrace(word: '历史风貌', eventId: 'NJ-E3-shortcut', usage: 'Lv3 首次出现。', sourceText: '可是这里属于历史风貌敏感的河岸段，临时改动公用照明安排需要确认，剩下的时间也不够重新完成安全检查。'),
  const RemediatedWordTrace(word: '配置', eventId: 'NJ-E5-reduced-configuration', usage: 'Lv3 首次出现。', sourceText: '他没有追求“全亮”，而是在原有安全配置里调整可用灯光：先保留行人需要的通行照明，再关掉一部分装饰负荷。'),
  const RemediatedWordTrace(word: '复核', eventId: 'NJ-E3-shortcut', usage: 'Lv5 首次出现。', sourceText: '技术上动作不复杂，但它会改变既定设施安排；这里又是秦淮历史风貌敏感的河岸和古桥段，剩下的几分钟不足以完成必要的确认与安全复核。'),
]);

const nanjingQinhuaiWordFirstAppears = <String, int>{
  '秦淮灯会': 1,
  '故障': 2,
  '照明': 1,
  '临时': 1,
  '确认': 1,
  '通行': 1,
  '装饰灯': 1,
  '倒计时': 1,
  '记录': 1,
  '技术员': 2,
  '响应': 2,
  '判断': 2,
  '对讲机': 3,
  '历史风貌': 3,
  '配置': 3,
  '复核': 5,
};

DiscoveryEntry _discovery(
  String text, {
  required String pinyin,
  required String simpleChinese,
  required String vietnamese,
  required String english,
}) =>
    DiscoveryEntry(
      text: text,
      pinyin: pinyin,
      simpleChinese: simpleChinese,
      vietnamese: vietnamese,
      english: english,
    );

final nanjingQinhuaiDiscoverySpecs =
    List<NanjingDiscoverySpec>.unmodifiable([
  NanjingDiscoverySpec(
    level: 1,
    title: '秦淮河和两岸为什么重要',
    storyLink: '故事发生在秦淮河河岸，路线的安全照明依赖这里的实际空间。',
    entry: _discovery(
      '官方条例把秦淮河以及河道两岸的历史风貌列入需要重点保护的风景名胜资源。',
      pinyin: 'Guānfāng tiáolì bǎ Qínhuái Hé yǐjí hédào liǎng àn de lìshǐ fēngmào lièrù xūyào zhòngdiǎn bǎohù de fēngjǐng míngshèng zīyuán.',
      simpleChinese: '秦淮河不只是水面，两岸形成的历史环境也属于保护内容。',
      vietnamese: 'Quy định chính thức xếp sông Tần Hoài và diện mạo lịch sử hai bờ vào nhóm tài nguyên cảnh quan cần được bảo vệ trọng điểm.',
      english: 'The official regulation identifies the Qinhuai River and the historic character of its two banks as protected scenic resources.',
    ),
    keyTerms: const ['秦淮河', '两岸', '历史风貌'],
    learnerInsight: '保护对象包括河流与两岸共同形成的历史环境。',
    check: '除了河水本身，条例还强调保护什么？',
    answer: '秦淮河两岸的历史风貌。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 2,
    title: '古桥为什么属于保护语境',
    storyLink: '故事只说“古桥附近”，不虚构桥名；古桥本身是官方列出的保护资源类型。',
    entry: _discovery(
      '条例把古桥梁与历史街巷、古建筑等一起列为需要重点保护的风景名胜资源。',
      pinyin: 'Tiáolì bǎ gǔ qiáoliáng yǔ lìshǐ jiēxiàng, gǔ jiànzhù děng yìqǐ lièwéi xūyào zhòngdiǎn bǎohù de fēngjǐng míngshèng zīyuán.',
      simpleChinese: '古桥不是普通背景，它属于景区要保护的历史资源。',
      vietnamese: 'Quy định xếp cầu cổ cùng phố ngõ lịch sử và công trình cổ vào các tài nguyên cảnh quan cần bảo vệ trọng điểm.',
      english: 'Ancient bridges are listed with historic streets and buildings among scenic resources requiring focused protection.',
    ),
    keyTerms: const ['古桥梁', '历史街巷', '保护'],
    learnerInsight: '故事中的古桥作用是建立遗产敏感环境，不需要虚构某座桥的特殊禁令。',
    check: '古桥在条例里属于什么？',
    answer: '需要重点保护的风景名胜资源。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 3,
    title: '秦淮灯会不是一次性活动',
    storyLink: '魏舟的工作发生在秦淮灯会，但 Discovery 解释灯会的文化身份，而不复述故障。',
    entry: _discovery(
      '条例把秦淮灯会列入应当加强保护和传承的非物质文化遗产内容。',
      pinyin: 'Tiáolì bǎ Qínhuái Dēnghuì lièrù yīngdāng jiāqiáng bǎohù hé chuánchéng de fēi wùzhì wénhuà yíchǎn nèiróng.',
      simpleChinese: '秦淮灯会被作为需要保护和传承的活态文化来对待。',
      vietnamese: 'Quy định đưa Lễ hội đèn Tần Hoài vào nội dung di sản văn hóa phi vật thể cần được tăng cường bảo vệ và truyền dạy.',
      english: 'The regulation includes the Qinhuai Lantern Festival among intangible cultural heritage traditions to be protected and transmitted.',
    ),
    keyTerms: const ['秦淮灯会', '非物质文化遗产', '传承'],
    learnerInsight: '灯会既是当代活动，也是被保护传承的文化实践。',
    check: '秦淮灯会在条例中与哪类文化保护有关？',
    answer: '非物质文化遗产的保护和传承。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 4,
    title: '夜景照明也属于管理对象',
    storyLink: '故事需要开场前的夜间灯光运行；Discovery 说明景区夜景照明并非无人管理的装饰。',
    entry: _discovery(
      '条例对风景区的夜景照明作出专门管理要求，夜间灯光属于景区运行管理的一部分。',
      pinyin: 'Tiáolì duì fēngjǐngqū de yèjǐng zhàomíng zuòchū zhuānmén guǎnlǐ yāoqiú, yèjiān dēngguāng shǔyú jǐngqū yùnxíng guǎnlǐ de yí bùfen.',
      simpleChinese: '景区夜间灯光不是随意设置的，它有专门的管理要求。',
      vietnamese: 'Quy định đặt ra yêu cầu quản lý riêng đối với chiếu sáng cảnh quan ban đêm; ánh sáng ban đêm là một phần của vận hành khu thắng cảnh.',
      english: 'The regulation specifically manages scenic-area night lighting as part of site operations.',
    ),
    keyTerms: const ['夜景照明', '管理', '运行'],
    learnerInsight: '故事中的灯光工作有公共运行背景，而不只是舞台效果。',
    check: '夜景照明在景区里是否属于管理事项？',
    answer: '是，条例有专门的夜景照明管理要求。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 5,
    title: '照明设施为什么不能只看效果',
    storyLink: '魏舟的取舍涉及照明设施，但 Discovery 解释一般管理原则，不替他做决定。',
    entry: _discovery(
      '条例要求供电、照明等公用设施符合规划和景观要求，并做好维护。',
      pinyin: 'Tiáolì yāoqiú gōngdiàn, zhàomíng děng gōngyòng shèshī fúhé guīhuà hé jǐngguān yāoqiú, bìng zuòhǎo wéihù.',
      simpleChinese: '照明等设施既要能工作，也要符合景区规划并被维护。',
      vietnamese: 'Quy định yêu cầu các tiện ích công cộng như cấp điện và chiếu sáng phù hợp với quy hoạch, yêu cầu cảnh quan và được bảo trì.',
      english: 'Public utilities such as power and lighting must conform to planning and scenic requirements and be maintained.',
    ),
    keyTerms: const ['供电', '照明', '公用设施'],
    learnerInsight: '在历史景区里，灯光设施同时属于技术系统和环境管理系统。',
    check: '照明设施除了能亮，还要符合什么？',
    answer: '规划和景观要求，并接受维护。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 6,
    title: '公共设施改变需要什么前提',
    storyLink: '故事中的捷径被描述为“未经确认的临时改变”，而不是虚构某种接线禁令。',
    entry: _discovery(
      '条例规定，公共设施需要移动或者改变时，应当依照规定取得批准。',
      pinyin: 'Tiáolì guīdìng, gōnggòng shèshī xūyào yídòng huòzhě gǎibiàn shí, yīngdāng yīzhào guīdìng qǔdé pīzhǔn.',
      simpleChinese: '公共设施不能因为赶时间就随意移动或改变，变动有批准要求。',
      vietnamese: 'Quy định nêu rằng khi cần di chuyển hoặc thay đổi công trình công cộng, phải có phê duyệt theo quy định.',
      english: 'When public facilities need to be moved or altered, approval is required in accordance with the regulation.',
    ),
    keyTerms: const ['公共设施', '改变', '批准'],
    learnerInsight: '这支持“未经确认不临时改变设施安排”的冲突，但不等于某种电缆固定方式被单独禁止。',
    check: '改变公共设施前需要什么？',
    answer: '依照规定取得批准。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 7,
    title: '发现安全隐患后要做什么',
    storyLink: '故事把安全复核时间不足作为拒绝临时改变的职业理由之一。',
    entry: _discovery(
      '条例要求相关公用设施加强维护；发现安全隐患时，应及时采取措施消除隐患。',
      pinyin: 'Tiáolì yāoqiú xiāngguān gōngyòng shèshī jiāqiáng wéihù; fāxiàn ānquán yǐnhuàn shí, yīng jíshí cǎiqǔ cuòshī xiāochú yǐnhuàn.',
      simpleChinese: '设施管理不仅要修好外观，也要及时处理安全问题。',
      vietnamese: 'Quy định yêu cầu tăng cường bảo trì các tiện ích công cộng và kịp thời loại bỏ nguy cơ an toàn khi phát hiện.',
      english: 'The regulation requires maintenance of public utilities and timely action to remove identified safety hazards.',
    ),
    keyTerms: const ['维护', '安全隐患', '消除'],
    learnerInsight: '灯光系统的成功运行包含安全状态，而非只有视觉完整。',
    check: '发现安全隐患后应怎样处理？',
    answer: '及时采取措施消除隐患。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 8,
    title: '夜景设施需要保持什么状态',
    storyLink: '故事里的“缩减配置”仍必须让实际开放所需的照明处于可用状态。',
    entry: _discovery(
      '景区夜景照明设施应当保持安全、完好，运行管理关注的不只是灯光是否漂亮。',
      pinyin: 'Jǐngqū yèjǐng zhàomíng shèshī yīngdāng bǎochí ānquán, wánhǎo, yùnxíng guǎnlǐ guānzhù de bù zhǐshì dēngguāng shìfǒu piàoliang.',
      simpleChinese: '夜景照明设施要保持安全和完好。',
      vietnamese: 'Thiết bị chiếu sáng cảnh quan ban đêm phải được duy trì an toàn và trong tình trạng tốt.',
      english: 'Night-lighting facilities are required to remain safe and in good condition.',
    ),
    keyTerms: const ['夜景照明设施', '安全', '完好'],
    learnerInsight: '视觉效果与设施安全是不同的评价维度。',
    check: '夜景照明设施应保持哪两种状态？',
    answer: '安全、完好。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 9,
    title: '为什么不能任意动公共灯光设施',
    storyLink: '故事避免具体工程禁令，只使用来源支持的公共设施管理边界。',
    entry: _discovery(
      '条例禁止任意占用、移动、拆除或者损坏景区相关公共设施和夜景照明设施。',
      pinyin: 'Tiáolì jìnzhǐ rènyì zhànyòng, yídòng, chāichú huòzhě sǔnhuài jǐngqū xiāngguān gōnggòng shèshī hé yèjǐng zhàomíng shèshī.',
      simpleChinese: '相关设施不能被随意占用、移动、拆掉或损坏。',
      vietnamese: 'Quy định cấm tùy tiện chiếm dụng, di chuyển, tháo dỡ hoặc làm hư hại các công trình công cộng và thiết bị chiếu sáng cảnh quan liên quan.',
      english: 'The regulation prohibits arbitrary occupation, movement, removal, or damage of relevant public and night-lighting facilities.',
    ),
    keyTerms: const ['任意移动', '公共设施', '夜景照明设施'],
    learnerInsight: '故事的职业边界来自“不能任意改变受管理设施”，不是虚构的桥梁布线条款。',
    check: '条例反对对相关设施做哪些任意行为？',
    answer: '任意占用、移动、拆除或者损坏。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
  NanjingDiscoverySpec(
    level: 10,
    title: '夫子庙秦淮风光带怎样围绕秦淮展开',
    storyLink: '故事没有塞入景点介绍，但秦淮河并非可随意替换的背景。',
    entry: _discovery(
      '条例界定的夫子庙秦淮风光带以夫子庙和“十里秦淮”等区域为重要组成，保护对象同时包含水体、两岸风貌、历史街巷和古桥等资源。',
      pinyin: 'Tiáolì jièdìng de Fūzǐmiào Qínhuái Fēngguāngdài yǐ Fūzǐmiào hé “Shílǐ Qínhuái” děng qūyù wéi zhòngyào zǔchéng, bǎohù duìxiàng tóngshí bāohán shuǐtǐ, liǎng àn fēngmào, lìshǐ jiēxiàng hé gǔqiáo děng zīyuán.',
      simpleChinese: '这个风景区把秦淮河、水岸和历史城市空间放在同一保护体系里理解。',
      vietnamese: 'Khu thắng cảnh Phu Tử Miếu–Tần Hoài lấy Phu Tử Miếu và khu “Thập lý Tần Hoài” làm những thành phần quan trọng, đồng thời bảo vệ mặt nước, diện mạo hai bờ, phố ngõ lịch sử và cầu cổ.',
      english: 'The regulation defines the Fuzimiao-Qinhuai scenic area around components including Fuzimiao and the “Ten-Li Qinhuai,” while protecting water, riverbank character, historic streets, and ancient bridges together.',
    ),
    keyTerms: const ['夫子庙', '十里秦淮', '保护体系'],
    learnerInsight: '秦淮的水岸、古桥和夜间活动共享同一受管理的历史环境。',
    check: '为什么故事不能换成普通商业街而保持不变？',
    answer: '因为这里的河流、两岸历史风貌、古桥和夜景管理共同构成冲突背景。',
    sourceIds: const [nanjingQinhuaiSourceRecordId],
  ),
]);

final nanjingQinhuaiOnePassDiscoveries =
    List<DiscoveryEntry>.unmodifiable(
  nanjingQinhuaiDiscoverySpecs.map((spec) => spec.entry),
);

final nanjingQinhuaiChallengeSpecs =
    List<NanjingChallengeSpec>.unmodifiable([
  for (var level = 1; level <= 10; level++) ...[
    NanjingChallengeSpec(
      level: level,
      type: 'paragraphRebuild',
      prompt: '开场前发生了什么问题，为什么必须马上处理？',
      anchor: nanjingQinhuaiOnePassLevels[level - 1].storyParagraphs.first,
      answer: '秦淮灯会亮灯前只剩七分钟，古桥附近的灯光段发生故障，魏舟必须在开场前处理。',
    ),
    NanjingChallengeSpec(
      level: level,
      type: 'grammarRepair',
      prompt: '为什么魏舟没有采用最快的临时改线？',
      anchor: nanjingQinhuaiOnePassLevels[level - 1].storyParagraphs.first,
      answer: '因为那会临时改变已经确认的照明安排，而且没有足够时间完成必要确认和安全检查。',
    ),
    NanjingChallengeSpec(
      level: level,
      type: 'missingSentence',
      prompt: '魏舟的选择付出了什么看得见的代价？',
      anchor: nanjingQinhuaiOnePassLevels[level - 1].storyParagraphs.last,
      answer: '主要路线亮起并开放，但古桥旁有一段装饰灯仍然保持黑暗。',
    ),
  ],
]);

final nanjingQinhuaiDiscoveryTraces =
    List<RemediatedDiscoveryTrace>.unmodifiable([
  for (var level = 1; level <= 10; level++)
    RemediatedDiscoveryTrace(
      discoveryIndex: level - 1,
      storyEventIds: const ['NJ-E3-shortcut', 'NJ-E5-reduced-configuration'],
      sourceIds: const [nanjingQinhuaiSourceRecordId],
    ),
]);

final nanjingQinhuaiChallengeTraces =
    List<RemediatedChallengeTrace>.unmodifiable([
  for (final spec in nanjingQinhuaiChallengeSpecs)
    RemediatedChallengeTrace(
      type: spec.type,
      storyEventIds: const [
        'NJ-E1-deadline',
        'NJ-E3-shortcut',
        'NJ-E4-choice',
        'NJ-E6-visible-cost',
      ],
      anchor: spec.anchor,
    ),
]);

const nanjingQinhuaiMemoryAnchor = '亮灯以后仍然黑着的那一段装饰灯';

const nanjingQinhuaiMemory = <RemediatedMemoryReview>[
  RemediatedMemoryReview(
    category: '选择',
    prompt: '魏舟为什么让一段装饰灯继续黑着？',
    answer: '他拒绝未经确认的临时改线，把可用照明优先留给安全通行。',
    storyEventIds: ['NJ-E3-shortcut', 'NJ-E4-choice', 'NJ-E5-reduced-configuration'],
  ),
  RemediatedMemoryReview(
    category: '画面',
    prompt: '亮灯后，哪个画面最能记住魏舟的决定？',
    answer: '主要路线亮了，秦淮河面有反光，而古桥旁那一段装饰灯仍然黑着。',
    storyEventIds: ['NJ-E6-visible-cost'],
  ),
  RemediatedMemoryReview(
    category: '关系',
    prompt: '周工回来后用什么行动表示责任已经变化？',
    answer: '他把最终灯光状态记录交给魏舟填写并完成汇报，没有替魏舟重做决定。',
    storyEventIds: ['NJ-E7-trust-transfer'],
  ),
];

const nanjingQinhuaiCompletion = RemediatedCompletion(
  journeySummary:
      '七分钟内，魏舟在秦淮灯会灯光故障中拒绝未经确认的临时改线，让路线以减少装饰灯的状态安全开放。',
  achievement: '秦淮灯光现场判断者',
  memoryAnchor: nanjingQinhuaiMemoryAnchor,
  challengeReward: '暗段状态标记',
  journeyCompletion:
      '这次亮灯任务完成：主要路线开放，暗段仍然保留，周工把最终灯光状态记录交给魏舟。秦淮河仍有更多故事。',
);

const nanjingQinhuaiEventIds = <String>[
  'NJ-E1-deadline',
  'NJ-E2-responsibility',
  'NJ-E3-shortcut',
  'NJ-E4-choice',
  'NJ-E5-reduced-configuration',
  'NJ-E6-visible-cost',
  'NJ-E7-trust-transfer',
];

const nanjingQinhuaiEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(
    id: 'NJ-E1-deadline',
    coreChinese: '秦淮灯会亮灯前七分钟，古桥附近的装饰灯发生故障。',
    corePinyin: 'Qínhuái Dēnghuì liàngdēng qián qī fēnzhōng, gǔqiáo fùjìn de zhuāngshì dēng fāshēng gùzhàng.',
    coreVietnamese: 'Bảy phút trước giờ bật đèn Lễ hội Tần Hoài, đèn trang trí gần cầu cổ gặp sự cố.',
    coreEnglish: 'Seven minutes before the Qinhuai Lantern Festival lighting sequence, decorative lights near an old bridge fail.',
    detailChinese: '周工正在另一段处理异常，不能替魏舟立即决定。',
    detailPinyin: 'Zhōu Gōng zhèngzài lìng yí duàn chǔlǐ yìcháng, bùnéng tì Wèi Zhōu lìjí juédìng.',
    detailVietnamese: 'Kỹ sư Chu đang xử lý sự cố ở đoạn khác và không thể quyết định thay Ngụy Chu ngay lúc đó.',
    detailEnglish: 'Supervisor Zhou is handling another fault and cannot make the immediate decision for Wei Zhou.',
    detailFromLevel: 2,
  ),
  RemediatedSemanticEvent(
    id: 'NJ-E2-responsibility',
    coreChinese: '魏舟必须在开场前让主要路线保持安全可用。',
    corePinyin: 'Wèi Zhōu bìxū zài kāichǎng qián ràng zhǔyào lùxiàn bǎochí ānquán kěyòng.',
    coreVietnamese: 'Ngụy Chu phải giữ tuyến chính an toàn và sử dụng được trước giờ mở.',
    coreEnglish: 'Wei Zhou must keep the main route safe and usable before opening.',
    detailChinese: '他想证明自己不再只是等周工拍板的助手。',
    detailPinyin: 'Tā xiǎng zhèngmíng zìjǐ bù zài zhǐshì děng Zhōu Gōng pāibǎn de zhùshǒu.',
    detailVietnamese: 'Anh muốn chứng minh mình không còn chỉ là trợ lý chờ kỹ sư Chu quyết định.',
    detailEnglish: 'He wants to prove he is no longer merely an assistant waiting for Supervisor Zhou to decide.',
    detailFromLevel: 3,
  ),
  RemediatedSemanticEvent(
    id: 'NJ-E3-shortcut',
    coreChinese: '最快的办法会临时改变已经确认的照明安排。',
    corePinyin: 'Zuì kuài de bànfǎ huì línshí gǎibiàn yǐjīng quèrèn de zhàomíng ānpái.',
    coreVietnamese: 'Cách nhanh nhất sẽ tạm thời thay đổi phương án chiếu sáng đã được xác nhận.',
    coreEnglish: 'The fastest workaround would temporarily alter the already confirmed lighting arrangement.',
    detailChinese: '这里是秦淮历史风貌敏感的河岸和古桥环境，剩余时间不足以重新完成必要确认与安全复核。',
    detailPinyin: 'Zhèlǐ shì Qínhuái lìshǐ fēngmào mǐngǎn de héàn hé gǔqiáo huánjìng, shèngyú shíjiān bùzú yǐ chóngxīn wánchéng bìyào quèrèn yǔ ānquán fùhé.',
    detailVietnamese: 'Đây là môi trường ven sông và cầu cổ nhạy cảm về di sản Tần Hoài; thời gian còn lại không đủ để hoàn thành xác nhận và kiểm tra an toàn cần thiết.',
    detailEnglish: 'This is a heritage-sensitive Qinhuai riverside and old-bridge setting, and there is not enough time for the necessary confirmation and safety re-check.',
    detailFromLevel: 3,
  ),
  RemediatedSemanticEvent(
    id: 'NJ-E4-choice',
    coreChinese: '魏舟自己拒绝了未经确认的临时改线。',
    corePinyin: 'Wèi Zhōu zìjǐ jùjué le wèi jīng quèrèn de línshí gǎixiàn.',
    coreVietnamese: 'Ngụy Chu tự mình từ chối đổi tuyến tạm thời chưa được xác nhận.',
    coreEnglish: 'Wei Zhou himself rejects the unconfirmed last-minute reroute.',
    detailChinese: '他接受不能同时保住全部装饰效果。',
    detailPinyin: 'Tā jiēshòu bùnéng tóngshí bǎozhù quánbù zhuāngshì xiàoguǒ.',
    detailVietnamese: 'Anh chấp nhận rằng không thể giữ toàn bộ hiệu ứng trang trí.',
    detailEnglish: 'He accepts that he cannot keep every decorative effect.',
    detailFromLevel: 2,
  ),
  RemediatedSemanticEvent(
    id: 'NJ-E5-reduced-configuration',
    coreChinese: '他优先保留通行照明，并主动减少装饰灯。',
    corePinyin: 'Tā yōuxiān bǎoliú tōngxíng zhàomíng, bìng zhǔdòng jiǎnshǎo zhuāngshì dēng.',
    coreVietnamese: 'Anh ưu tiên chiếu sáng lối đi và chủ động giảm đèn trang trí.',
    coreEnglish: 'He prioritizes route lighting and deliberately reduces decorative lighting.',
    detailChinese: '调整只在现有安全配置范围内完成。',
    detailPinyin: 'Tiáozhěng zhǐ zài xiànyǒu ānquán pèizhì fànwéi nèi wánchéng.',
    detailVietnamese: 'Việc điều chỉnh chỉ diễn ra trong cấu hình an toàn hiện có.',
    detailEnglish: 'The adjustment stays within the existing safe configuration.',
    detailFromLevel: 3,
  ),
  RemediatedSemanticEvent(
    id: 'NJ-E6-visible-cost',
    coreChinese: '主要路线亮起并安全开放，但古桥旁一段装饰灯仍然黑着。',
    corePinyin: 'Zhǔyào lùxiàn liàngqǐ bìng ānquán kāifàng, dàn gǔqiáo páng yí duàn zhuāngshì dēng réngrán hēizhe.',
    coreVietnamese: 'Tuyến chính sáng lên và mở an toàn, nhưng một đoạn đèn trang trí gần cầu cổ vẫn tối.',
    coreEnglish: 'The main route lights and opens safely, while one decorative section near the old bridge remains dark.',
    detailChinese: '秦淮河面有足够反光显示水流与人群移动，暗段始终没有被补亮。',
    detailPinyin: 'Qínhuái Hémiàn yǒu zúgòu fǎnguāng xiǎnshì shuǐliú yǔ rénqún yídòng, ànduàn shǐzhōng méiyǒu bèi bǔliàng.',
    detailVietnamese: 'Mặt sông Tần Hoài có đủ ánh phản chiếu để thấy dòng nước và chuyển động của người đi bộ; đoạn tối không được lấp sáng.',
    detailEnglish: 'The Qinhuai River catches enough light to show water and pedestrian movement, and the dark decorative section is not filled back in.',
    detailFromLevel: 4,
  ),
  RemediatedSemanticEvent(
    id: 'NJ-E7-trust-transfer',
    coreChinese: '周工回来后把最终灯光状态记录交给魏舟填写和汇报。',
    corePinyin: 'Zhōu Gōng huílái hòu bǎ zuìzhōng dēngguāng zhuàngtài jìlù jiāo gěi Wèi Zhōu tiánxiě hé huìbào.',
    coreVietnamese: 'Khi trở lại, kỹ sư Chu giao cho Ngụy Chu ghi và báo cáo trạng thái ánh sáng cuối cùng.',
    coreEnglish: 'When he returns, Supervisor Zhou gives Wei Zhou responsibility for recording and reporting the final lighting status.',
    detailChinese: '他没有替魏舟重做决定，关系从等待指令转为承担专业结果。',
    detailPinyin: 'Tā méiyǒu tì Wèi Zhōu chóngzuò juédìng, guānxì cóng děngdài zhǐlìng zhuǎn wéi chéngdān zhuānyè jiéguǒ.',
    detailVietnamese: 'Ông không làm lại quyết định thay Ngụy Chu; mối quan hệ chuyển từ chờ chỉ thị sang chịu trách nhiệm về kết quả chuyên môn.',
    detailEnglish: 'He does not remake the decision for Wei Zhou; their working relationship shifts from instruction-waiting to ownership of a professional outcome.',
    detailFromLevel: 5,
  ),
];

const nanjingQinhuaiSources = <RemediatedSourceBinding>[
  RemediatedSourceBinding(
    id: nanjingQinhuaiSourceRecordId,
    publisher: '南京市人民政府',
    scope:
        '夫子庙秦淮风光带保护范围、秦淮河及两岸历史风貌、古桥梁、秦淮灯会、夜景照明、公用设施维护安全与改变批准要求',
  ),
];

final nanjingQinhuaiRemediatedJourney = RemediatedJourney(
  id: nanjingQinhuaiJourneyId,
  title: '南京 · 秦淮河：$nanjingQinhuaiCanonicalTitle',
  protagonist: '魏舟',
  goal: '在秦淮灯会开场前恢复安全、可用的沿河照明路线。',
  conflict:
      '最快的完整视觉修复要求临时改变已确认的照明安排，但现场位于历史风貌敏感的秦淮河岸与古桥环境，且没有时间完成必要确认与安全复核。',
  eventIds: nanjingQinhuaiEventIds,
  events: nanjingQinhuaiEvents,
  levels: nanjingQinhuaiOnePassLevels,
  words: nanjingQinhuaiOnePassWords,
  wordTraces: nanjingQinhuaiWordTraces,
  discoveries: nanjingQinhuaiOnePassDiscoveries,
  discoveryTraces: nanjingQinhuaiDiscoveryTraces,
  challenges: nanjingQinhuaiChallengeTraces,
  memory: nanjingQinhuaiMemory,
  completion: nanjingQinhuaiCompletion,
  sources: nanjingQinhuaiSources,
);

JourneyLevelContent nanjingQinhuaiOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = nanjingQinhuaiOnePassLevels[level - 1];
  final story = base.storyParagraphs.join();
  final visibleWords = nanjingQinhuaiOnePassWords
      .where((entry) =>
          (nanjingQinhuaiWordFirstAppears[entry.word] ?? 11) <= level &&
          story.contains(entry.word))
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: visibleWords,
    discoveries: <DiscoveryEntry>[nanjingQinhuaiDiscoverySpecs[level - 1].entry],
    wonderQuestion:
        '为什么魏舟宁可让一段装饰灯继续黑着，也不在最后几分钟改变已经确认的照明安排？',
    expressQuestion:
        '请用两到三句话说明魏舟做了什么取舍，以及周工最后怎样把责任交给他。',
  );
}
