import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const hangzhouWestLakeJourneyId = 'hangzhou-west-lake';

class HangzhouNarrativeDna {
  const HangzhouNarrativeDna({
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

const hangzhouWestLakeNarrativeDna = HangzhouNarrativeDna(
  narrativeIdentity: 'rainfront-sound-archive-redefines-authentic-west-lake-presence',
  protagonistArchetype: 'young-field-recordist-curating-an-urban-sound-archive',
  storyGoal: 'capture-a-perfect-clean-West-Lake-soundscape-before-the-weather-shifts',
  conflictType: 'classical-purity-vs-authentic-layered-cultural-landscape-presence',
  climaxType: 'first-rain-recomposes-the-sound-field-while-she-actively-pans-between-causeway-bridge-and-water',
  resolutionType: 'accept-and-catalog-the-layered-rain-transformed-soundscape-without-purifying-it',
  memoryAnchorType: 'first-raindrop-audibly-entering-the-West-Lake-field-recording',
  movementPattern: 'linear-Su-Causeway-listening-walk-with-bridge-and-waterside-sound-fields',
  temporalPattern: 'single-summer-afternoon-pre-rain-to-first-rain-to-wet-lake',
  supportingStructure: 'solo-fieldwork-with-public-soundscape-no-mentor-explainer',
  endingMechanism: 'next-day-archive-file-is-saved-by-date-Su-Causeway-route-and-title-Presence',
  centralMetaphor: 'authentic-place-is-a-mixed-sound-field-not-a-silenced-picture',
);

class HangzhouDiscoverySpec {
  const HangzhouDiscoverySpec({
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

class HangzhouChallengeSpec {
  const HangzhouChallengeSpec({
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

class HangzhouCompleteSpec {
  const HangzhouCompleteSpec({
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

JourneyLevelContent _hangzhouLevel(List<String> paragraphs) => JourneyLevelContent(
      storyParagraphs: List<String>.unmodifiable(paragraphs),
      storyAnnotations: List<ReadingAnnotation>.unmodifiable([
        for (var i = 0; i < paragraphs.length; i++)
          ReadingAnnotation(
            pinyin: i == 0
                ? 'Xǔ Chéng èrshíyī suì, shì Hángzhōu běndì dàxuéshēng. Xiàtiān wǔhòu, tā cóng Sūdī nán duān kāishǐ lù Xīhú de chéngshì shēngyīn.'
                : 'Yǔ yún kào jìn Xīhú. Dì yī dī yǔ jìnrù màikèfēng hòu, tā zhǔdòng zhuǎndòng màikèfēng, bǎ dīshàng, qiáoxià hé shuǐmiàn de biànhuà shōujìn tóng yì tiáo shēngguǐ.',
            vietnamese: i == 0
                ? 'Hứa Trừng, 21 tuổi, là sinh viên đại học người Hàng Châu. Một buổi chiều mùa hè, cô bắt đầu ghi âm cảnh âm thanh Tây Hồ từ đầu nam đê Tô và ban đầu muốn tạo một bản thu thật “sạch”.'
                : 'Khi mưa tới, cô chủ động xoay micro giữa đê, cầu và mặt nước, ghi lại cùng lúc mưa, chuyển động của con người và âm thanh hồ. Hôm sau cô lưu bản thu theo ngày, tuyến đê Tô và tên “Hiện diện”.',
            english: i == 0
                ? 'Xu Cheng, 21, is a Hangzhou university student. On a summer afternoon she begins a West Lake field recording from the south end of Su Causeway, initially seeking a perfectly clean soundscape.'
                : 'When rain arrives, she deliberately re-aims the microphone across causeway, bridge, and water, recording the changing human and lake sound field together. The next day she archives it by date, Su Causeway route, and the title “Presence”.',
          ),
      ]),
      words: const <WordEntry>[],
      discoveries: const <DiscoveryEntry>[],
      wonderQuestion: '',
      expressQuestion: '',
    );

final hangzhouWestLakeOnePassLevels = List<JourneyLevelContent>.unmodifiable([
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生。夏日下午，她从苏堤南端开始为城市声音档案录西湖，想收下一段“干净”的声音：风、湖水、柳叶和船桨，最好没有人声。刚走上堤，一声自行车铃闯进录音，她皱眉删掉重来。后来，桥下的脚步、说话声和划水声混在一起，她忽然没有再删。乌云压低，第一滴雨落进麦克风，湖面也变了声音。许澄把麦克风转向堤上和水面，让雨声、脚步和人声一起进入录音。第二天，她把文件写成日期、苏堤路线和两个字：“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生，正在参加一个城市声音档案项目。夏日下午，预报说西湖很快会下雨，她带着小录音机从苏堤南端出发，想连续录下一个“完美”的西湖：风过柳树、湖水拍岸、船桨入水，最好听不见现代城市。刚走上堤，一声自行车铃和几句游客说话闯进录音，她立刻停下并删掉这一段。走到桥边，她又听见脚步经过桥面，声音在桥下回荡，和水声、桨声连在一起。她举起手，本想再次删除，却停住了。乌云越来越低，第一滴雨落进麦克风，接着雨点打乱湖面，人们撑伞、加快脚步，船也向岸边移动。许澄把麦克风从湖面转向堤上，再转回水边，让这些变化完整进入录音。第二天整理档案时，她把文件名写成日期、苏堤路线和“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生，参加一个小型城市声音档案项目。夏日下午，天气预报提醒西湖晚些时候有雨。她带着便携录音机从苏堤南端出发，想连续录下一个“完美”的西湖声景：风穿柳叶、湖水轻拍岸边、远处船桨落水，最好没有现代人声。刚走上堤，一声自行车铃和几句游客的谈话突然闯进耳机。她觉得这一段被“污染”了，停下录音，删掉文件，从头再来。',
    '走到桥边时，脚步踩过桥面，声音从桥洞下回荡回来，又和水声、桨声叠在一起。许澄本来准备再次删除，却第一次犹豫：苏堤本就是人长期治理湖水、修筑堤道留下的景观，人走在这里也不是后来才出现的杂音。乌云压低，第一滴雨落进麦克风，湖面由轻响变成密集的雨声，人们撑伞、收摊、加快脚步。她不再追赶“干净”，而是把麦克风转向堤上与水面，让变化同时进入一条录音。第二天，她把文件名写成日期、苏堤路线和“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生，暑假参加一个城市声音档案项目。一天午后，预报说雨云会在傍晚前到达西湖。她带着便携录音机从苏堤南端开始采声，给自己定了一个标准：做一条连续、干净、像古画一样安静的西湖声景。她想要风过柳枝、湖水拍岸、船桨划开的水声，却不想要自行车铃、脚步、谈话和远处城市交通。刚走上堤，一声车铃从身后穿过去，接着有人笑着说话。耳机里的湖忽然“现代”起来，她按停录音，把文件删掉，从头开始。',
    '第二次走到桥边，鞋底、桥面和桥洞把脚步声拉出不同回响，湖上的桨声从另一侧靠近。许澄又摸到删除键，却想到眼前的苏堤并不是天然岸线：西湖长期经过疏浚、筑堤和景观营造，人在水边行走，本来就参与了这里的形状。她把手收回来。乌云压到山边，第一滴雨落进麦克风的防风罩，随后湖面、柳叶、伞布和脚步一起换了节奏。她主动转动麦克风，让堤上人群和水面同时进入声场。第二天整理档案，她没有选最安静的一条，而把这段按日期、苏堤路线存下，标题只有两个字：“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生，暑假参加一个小型城市声音档案项目。七月的一天下午，天气预报显示雨带会在傍晚前抵达西湖。她带着便携录音机从苏堤南端出发，任务是完成一段连续环境录音。许澄私下又加了一条标准：她想录到“最像西湖”的声音。她把这种声音想成一幅没有人的古画，只有柳叶受风、湖水贴着堤岸、远处木桨入水。自行车铃、游客谈话、脚步和城市交通在她看来都是需要避开的污染。刚走上苏堤，一声车铃从背后切进耳机，几个年轻人边走边笑。许澄立刻停下，把这一段删除，回到安静处重新开始。',
    '苏堤桥边，许澄第二次听见脚步在石面和桥洞下形成不同的回声，一艘游船经过，桨声与水波一起靠近。她再次准备删掉，却看见堤上不断有人来去。苏堤本身就来自长期的湖水治理和人工营造，西湖的堤、岛、桥、园林与山水共同组成文化景观；把所有人的声音清掉，反而像把其中一层历史关系擦掉。她没有删除，而在记录表上写下“桥上人流”。不久乌云压低，第一滴雨打进麦克风，湖面迅速密起来，人们开伞、收东西、加快脚步。许澄把麦克风转向堤上，再缓缓转回水面，让雨、人声、脚步和湖水在同一段录音里改变。第二天，她把文件存成日期、苏堤路线和“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，在杭州读大学，也参加学校附近一个小型城市声音档案项目。七月的一天下午，天气预报显示雨带正向西湖移动，傍晚前可能落雨。她带着便携录音机和防风罩，从苏堤南端开始一段连续采声。项目只要求记录环境，她却给自己设了更苛刻的目标：录到“完美的西湖”。在她想象中，那应该接近旧画里的清静，只留下柳叶受风、湖水拍堤、鸟鸣和远处木桨，尽量排除自行车铃、游客谈话、脚步、商贩招呼与城市交通。刚上堤，一声清脆车铃从背后穿进耳机，接着几个人笑着让路。许澄立即按停，把文件删掉，往回走了几十步重新开始。她觉得档案应该保存地方，而不是保存偶然经过的人。',
    '第二次走到一座桥边，情况却更复杂。鞋底落在石面上，桥洞把脚步声送到水面；游船靠近时，桨叶拨水的节奏又和谈话声叠在一起。许澄再次打开删除界面，却迟迟没有确认。眼前的苏堤不是天然岸线，西湖几个世纪的疏浚、筑堤、造岛、建桥和园林营造，让自然水体与人的行动长期重合。她忽然意识到，自己想剔除的“人声”并不都在景观之外。她退出删除，在记录表写下“桥上通行”。乌云很快压到湖面，第一滴雨撞进麦克风，随后雨点敲柳叶、伞面和水面，游客散开，脚步变快，船向岸边调整方向。许澄没有守住一条静态的“好听录音”，而是转动麦克风，主动收进堤上与湖面的变化。第二天，她按日期和苏堤路线归档，最后把这条声景命名为“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生，暑假参加一个小型城市声音档案项目。七月的一天下午，雷达图上的雨带正从西南方向靠近，预报说傍晚前西湖可能下雨。她背着便携录音机、耳机和防风罩，从苏堤南端开始连续采声。项目要求记录一段可供以后研究城市环境的原始声音，她却偷偷把任务改成了审美考试：什么才是“真正的西湖”？她想象的答案接近一幅安静古画，柳叶被风拨动，湖水轻碰堤岸，远处木桨划开水面，最好没有自行车铃、游客谈话、脚步、商贩声音与车辆低鸣。刚走上堤，一声车铃从背后直穿耳机，几名游客笑着让路。许澄皱眉按停，把整段删除，又往回走重新起录。她相信，删得越干净，留下的西湖就越纯。',
    '第二次来到桥边，她听见更难拆开的声层：鞋底落在石面，脚步经桥洞反射到水面；一艘游船靠近，桨叶拨水，岸边谈话忽远忽近。许澄又调出删除界面，却没有确认。苏堤本身就是长期疏浚和水利治理留下的人工堤道，西湖的堤、岛、桥、园林与三面山水共同构成被列入世界遗产的文化景观。她突然发现，自己若把所有人的活动都当成污染，就会把“文化景观”剪成只剩自然背景。她退出删除，在记录表标记“桥、人流、桨声”。乌云压近，第一滴雨撞上防风罩，随后湖面密响，柳叶、伞布、脚步和靠岸的船一起换了节奏。许澄把麦克风从水面转向堤上，再扫回湖面，主动让这些层次进入同一条声轨。第二天整理档案时，她保留了那段不够干净、却完整经历天气变化的录音，文件写着日期、苏堤路线，标题是“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生，暑假参加一个规模不大的城市声音档案项目。七月的一天下午，气象雷达显示雨带正逐渐靠近杭州，预报认为傍晚前西湖有阵雨。她背着便携录音机、指向可调的麦克风和防风罩，从苏堤南端开始一段连续环境采声。项目希望保留城市地点在某个时刻的原始声场，但许澄给自己加了另一个目标：做出一条“足够像古典西湖”的完美录音。她把耳机里的理想景象安排得很整齐：风拨柳条，湖水轻拍堤脚，偶尔一两声鸟鸣，远处木桨切开水面。自行车铃、游客谈话、鞋底摩擦、商贩招呼与城市交通，则被她统统归进应该避开的现代噪声。刚走上苏堤，一声车铃从身后切进录音，几个人笑着让出路。许澄立刻按停，把整段删除，退回安静处重新开始。她以为档案的价值来自筛掉偶然，只留下经典形象。',
    '第二次来到桥边，声场不再允许她轻易分层。石桥让脚步产生短促回响，桥洞把声音送向水面；一艘游船经过时，桨叶、水波和乘客谈话同时靠近。许澄再次打开删除界面，手指却悬住。苏堤并非天然岸线。西湖长期经过疏浚和治理，堤、岛、桥、寺塔、园林与山水一起构成文化景观；从九世纪以来，诗歌、绘画与园林审美又不断参与人们观看西湖的方式。她意识到，自己追求的“无人古画”本身也是被文化塑造的想象。她退出删除，把这一段标为“桥面通行与湖上交通”。此时天光突然变暗，第一滴雨撞进麦克风，随后雨点在柳叶、伞布和湖面上形成不同颗粒，人群开始移动，船只调整方向。许澄主动把麦克风从水面转向堤上，又缓慢扫回湖面，让天气改变人与水的过程完整进入声轨。第二天，她没有挑最安静的一段展示，而按日期、苏堤路线归档这条录音，最后写下标题：“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生，暑假参加一个小型城市声音档案项目。七月的一天下午，气象雷达上的雨带正向杭州靠近，预报提示傍晚前西湖可能出现阵雨。她带着便携录音机、耳机、可调整指向的麦克风和防风罩，从苏堤南端开始一段连续环境采声。项目的原则很简单：尽量忠实记录一个地点在某个时刻的声音。许澄却暗自把任务改成了审美筛选，她想捕捉“真正的西湖”，并把它理解为一幅可以听见的古画：风拨柳条，湖水轻拍堤脚，鸟鸣从树间落下，远处木桨切开水面。自行车铃、游客谈话、鞋底摩擦、商贩声音和道路低鸣，在她的监听耳机里都像后来加上的杂质。刚上堤，一声车铃从背后切进录音，几个游客笑着让路。她毫不犹豫地按停、删除，又退回安静处重新开始。她以为档案越“纯净”，越能保存西湖。',
    '第二次来到桥边，声音却变得无法切割。脚步落在石面上，经桥洞反射到水面；游船靠近时，桨叶拨水、乘客交谈和岸边风声叠成一个不断移动的声场。许澄再次调出删除界面，手指停在确认键上。苏堤并不是天然生成的岸线。西湖的主要人工要素，包括堤与岛，曾在长期疏浚中形成；桥、园林、寺塔和植物配置又把自然水体组织成持续被观看、使用和描写的文化景观。从九世纪以来，诗人、画家和造园者不断塑造这种“看西湖”的方式。她突然意识到，把现代人的活动全部消音，并不会还原一个没有人的过去，只会制造一个从未存在的静音版本。她退出删除，在记录表写下“桥上通行、湖上交通”。乌云压低，第一滴雨撞进麦克风，随后湖面骤然密响，伞布展开，脚步加速，船只向岸边调整。许澄把麦克风从湖面转向堤上人群，再缓慢扫回水面，主动记录这些层次怎样因雨重新排列。第二天整理档案，她保留这条跨过天气变化的原始声轨，文件名写着日期、苏堤路线，标题只有“在场”。'
  ]),
  _hangzhouLevel([
    '许澄二十一岁，是杭州本地大学生，暑假参加一个小型城市声音档案项目。七月的一天下午，气象雷达上的雨带正向杭州靠近，预报提示傍晚前西湖可能出现阵雨。她带着便携录音机、监听耳机、可调整指向的麦克风和防风罩，从苏堤南端开始一段连续环境采声。项目要保存的是某个地点在某个时刻的原始声场，许澄却私下把任务变成一次审美筛选：她想捕捉“真正的西湖”。在她的想象里，那应该像一幅可以听见的古画，只有风拨柳条、湖水轻拍堤脚、树间鸟鸣和远处木桨切开水面的声音。自行车铃、游客谈话、鞋底摩擦、商贩招呼以及城市道路的低鸣，都被她归进后来附着在名胜上的现代杂质。刚走上苏堤，一声车铃从背后突然切进耳机，几名游客笑着侧身让路。许澄立即按停，把整段删除，又退回较安静的位置重新起录。她相信，只要把偶然的人声一层层剥掉，留下的就会更接近西湖的“本来声音”。',
    '第二次来到桥边，她听见的世界却不再允许这种切割。鞋底落在石面上，短促回声经桥洞落到水面；一艘游船靠近，桨叶拨水、乘客交谈与岸边风声在同一刻移动。许澄再次调出删除界面，手指停在确认键上。苏堤不是天然岸线。西湖长期经过疏浚和治理，主要人工堤岛在反复疏浚中形成，桥、园林、寺塔与植物配置又把水体和三面山地组织成持续被观看、使用、书写的文化景观；自九世纪以来，诗歌、绘画和造园传统也不断塑造人们理解这里的方式。她突然明白，自己追求的“无人古画”并不是更真实的过去，而是一种经过选择的想象。她退出删除，在记录表写下“桥上通行、湖上交通”。这时天光沉下来，第一滴雨清楚地撞进麦克风，随后湖面出现密集雨点，柳叶和伞布变得沙沙作响，人群收伞袋、加快脚步，船只调整方向靠岸。许澄没有把麦克风藏到檐下保护那段相对安静的录音，而是转动指向，让堤上、桥下和水面的变化依次进入同一条声轨。第二天整理档案，她保留了这条经过人流与阵雨的原始录音，文件名按项目规则写上日期和苏堤路线，最后加了两个字：“在场”。'
  ])
]);

WordEntry _word(String word, String pinyin, String partOfSpeech, String simpleChinese, String vietnamese, String english, String symbol) => WordEntry(word: word, pinyin: pinyin, partOfSpeech: partOfSpeech, simpleChinese: simpleChinese, translation: vietnamese, englishDefinition: english, symbol: symbol);

final hangzhouWestLakeOnePassWords = List<WordEntry>.unmodifiable([
  _word('西湖', 'Xīhú', '名词（专名）', '杭州著名的湖泊文化景观。', 'Tây Hồ ở Hàng Châu.', 'West Lake in Hangzhou', '🌊'),
  _word('苏堤', 'Sūdī', '名词（专名）', '西湖上的重要人工堤道。', 'Đê Tô trên Tây Hồ.', 'Su Causeway', '🌉'),
  _word('录音', 'lùyīn', '名词/动词', '记录下来的声音，或记录声音的动作。', 'Bản ghi âm; ghi âm.', 'recording; to record', '🎙️'),
  _word('麦克风', 'màikèfēng', '名词', '把声音转换成可记录信号的设备。', 'Micrô.', 'microphone', '🎤'),
  _word('自行车铃', 'zìxíngchē líng', '名词', '自行车上的提示铃声。', 'Chuông xe đạp.', 'bicycle bell', '🚲'),
  _word('湖面', 'húmiàn', '名词', '湖水表面的区域。', 'Mặt hồ.', 'lake surface', '💧'),
  _word('脚步', 'jiǎobù', '名词', '走路时脚落地的动作或声音。', 'Bước chân.', 'footsteps', '👣'),
  _word('在场', 'zàichǎng', '动词/状态', '真实地处在某个现场之中。', 'Hiện diện tại chỗ.', 'to be present; presence', '◉'),
  _word('声景', 'shēngjǐng', '名词', '一个地点由多种声音构成的听觉环境。', 'Cảnh âm thanh.', 'soundscape', '〽️'),
  _word('疏浚', 'shūjùn', '动词', '清除水底淤积，使水体保持通畅。', 'Nạo vét.', 'to dredge', '⛏️'),
  _word('防风罩', 'fángfēngzhào', '名词', '减少风吹麦克风产生杂音的保护罩。', 'Mút/chụp chắn gió cho micrô.', 'microphone windscreen', '🎧'),
  _word('声场', 'shēngchǎng', '名词', '声音在一个空间里的整体分布。', 'Trường âm thanh.', 'sound field', '🔊'),
  _word('文化景观', 'wénhuà jǐngguān', '名词', '自然环境与长期人类活动共同形成的景观。', 'Cảnh quan văn hóa.', 'cultural landscape', '🏞️'),
  _word('堤岸', 'dī’àn', '名词', '沿水体修筑或形成的岸线与堤。', 'Bờ đê.', 'embankment', '🧱'),
  _word('归档', 'guīdàng', '动词', '按规则整理并保存资料。', 'Lưu trữ hồ sơ.', 'to archive', '🗂️'),
  _word('世界遗产', 'shìjiè yíchǎn', '名词', '列入联合国教科文组织《世界遗产名录》的遗产。', 'Di sản Thế giới.', 'World Heritage', '🏛️'),
  _word('声轨', 'shēngguǐ', '名词', '录音中连续保存声音的一条轨道。', 'Rãnh âm thanh.', 'audio track', '🎚️'),
]);

final hangzhouWestLakeWordTraces = List<RemediatedWordTrace>.unmodifiable([
  const RemediatedWordTrace(word: '西湖', eventId: 'HZ-E1-start', usage: 'Lv1 首次出现。', sourceText: '夏日下午，她从苏堤南端开始为城市声音档案录西湖，想收下一段“干净”的声音：风、湖水、柳叶和船桨，最好没有人声。'),
  const RemediatedWordTrace(word: '苏堤', eventId: 'HZ-E1-start', usage: 'Lv1 首次出现。', sourceText: '夏日下午，她从苏堤南端开始为城市声音档案录西湖，想收下一段“干净”的声音：风、湖水、柳叶和船桨，最好没有人声。'),
  const RemediatedWordTrace(word: '录音', eventId: 'HZ-E1-start', usage: 'Lv1 首次出现。', sourceText: '刚走上堤，一声自行车铃闯进录音，她皱眉删掉重来。'),
  const RemediatedWordTrace(word: '麦克风', eventId: 'HZ-E6-rain', usage: 'Lv1 首次出现。', sourceText: '乌云压低，第一滴雨落进麦克风，湖面也变了声音。'),
  const RemediatedWordTrace(word: '自行车铃', eventId: 'HZ-E2-delete', usage: 'Lv1 首次出现。', sourceText: '刚走上堤，一声自行车铃闯进录音，她皱眉删掉重来。'),
  const RemediatedWordTrace(word: '湖面', eventId: 'HZ-E6-rain', usage: 'Lv1 首次出现。', sourceText: '乌云压低，第一滴雨落进麦克风，湖面也变了声音。'),
  const RemediatedWordTrace(word: '脚步', eventId: 'HZ-E3-bridge', usage: 'Lv1 首次出现。', sourceText: '后来，桥下的脚步、说话声和划水声混在一起，她忽然没有再删。'),
  const RemediatedWordTrace(word: '在场', eventId: 'HZ-E7-ending', usage: 'Lv1 首次出现。', sourceText: '第二天，她把文件写成日期、苏堤路线和两个字：“在场”。'),
  const RemediatedWordTrace(word: '声景', eventId: 'HZ-E1-start', usage: 'Lv3 首次出现。', sourceText: '她带着便携录音机从苏堤南端出发，想连续录下一个“完美”的西湖声景：风穿柳叶、湖水轻拍岸边、远处船桨落水，最好没有现代人声。'),
  const RemediatedWordTrace(word: '疏浚', eventId: 'HZ-E4-recognition', usage: 'Lv4 首次出现。', sourceText: '西湖长期经过疏浚、筑堤和景观营造，人在水边行走，本来就参与了这里的形状。'),
  const RemediatedWordTrace(word: '防风罩', eventId: 'HZ-E6-rain', usage: 'Lv4 首次出现。', sourceText: '乌云压到山边，第一滴雨落进麦克风的防风罩，随后湖面、柳叶、伞布和脚步一起换了节奏。'),
  const RemediatedWordTrace(word: '声场', eventId: 'HZ-E6-rain', usage: 'Lv4 首次出现。', sourceText: '她主动转动麦克风，让堤上人群和水面同时进入声场。'),
  const RemediatedWordTrace(word: '文化景观', eventId: 'HZ-E4-recognition', usage: 'Lv5 首次出现。', sourceText: '苏堤本身就来自长期的湖水治理和人工营造，西湖的堤、岛、桥、园林与山水共同组成文化景观；把所有人的声音清掉，反而像把其中一层历史关系擦掉。'),
  const RemediatedWordTrace(word: '堤岸', eventId: 'HZ-E1-start', usage: 'Lv5 首次出现。', sourceText: '她把这种声音想成一幅没有人的古画，只有柳叶受风、湖水贴着堤岸、远处木桨入水。'),
  const RemediatedWordTrace(word: '归档', eventId: 'HZ-E7-ending', usage: 'Lv6 首次出现。', sourceText: '第二天，她按日期和苏堤路线归档，最后把这条声景命名为“在场”。'),
  const RemediatedWordTrace(word: '世界遗产', eventId: 'HZ-E4-recognition', usage: 'Lv7 首次出现。', sourceText: '苏堤本身就是长期疏浚和水利治理留下的人工堤道，西湖的堤、岛、桥、园林与三面山水共同构成被列入世界遗产的文化景观。'),
  const RemediatedWordTrace(word: '声轨', eventId: 'HZ-E6-rain', usage: 'Lv7 首次出现。', sourceText: '许澄把麦克风从水面转向堤上，再扫回湖面，主动让这些层次进入同一条声轨。'),
]);

const hangzhouWestLakeWordFirstAppears = <String, int>{'西湖': 1, '苏堤': 1, '录音': 1, '麦克风': 1, '自行车铃': 1, '湖面': 1, '脚步': 1, '在场': 1, '声景': 3, '疏浚': 4, '防风罩': 4, '声场': 4, '文化景观': 5, '堤岸': 5, '归档': 6, '世界遗产': 7, '声轨': 7};

DiscoveryEntry _discovery(String text, {required String simpleChinese, required String vietnamese, required String english}) => DiscoveryEntry(text: text, pinyin: 'Xīhú shì zìrán shānshuǐ yǔ chángqī rénlèi huódòng gòngtóng xíngchéng de wénhuà jǐngguān.', simpleChinese: simpleChinese, vietnamese: vietnamese, english: english);

final hangzhouWestLakeDiscoverySpecs = List<HangzhouDiscoverySpec>.unmodifiable([
  HangzhouDiscoverySpec(level: 1, title: '西湖不是孤立的水面', storyLink: '许澄从苏堤听湖水，也不断听见城市与人的声音。', entry: _discovery('西湖主体是湖面，南、西、北三面由山地环抱，东面与杭州城区相邻；这种“山—湖—城”的关系是文化景观的重要基础。', simpleChinese: '西湖一边连接山水，一边连接杭州城市。', vietnamese: 'Tây Hồ được núi bao quanh ở ba phía và tiếp giáp đô thị Hàng Châu ở phía đông.', english: 'West Lake is enclosed by hills on three sides and meets the city of Hangzhou on the east.'), keyTerms: const ['湖面', '三面山地', '城市'], learnerInsight: '西湖从来不是与城市完全隔开的自然容器。', check: '西湖东面主要连接什么？', answer: '杭州城区。', sourceIds: const ['unesco-hangzhou-west-lake', 'hangzhou-wgly-west-lake-seasons']),
  HangzhouDiscoverySpec(level: 2, title: '苏堤为什么是“人的痕迹”', storyLink: '许澄把苏堤当成采声路线，后来开始怀疑“人声都在景观之外”这个想法。', entry: _discovery('北宋苏轼在杭州治理西湖时组织疏浚，并利用清出的淤泥等材料修筑长堤；后人称为苏堤。', simpleChinese: '苏堤和西湖治理、疏浚直接相关。', vietnamese: 'Đê Tô gắn trực tiếp với việc Tô Thức tổ chức nạo vét và quản lý Tây Hồ thời Bắc Tống.', english: 'Su Causeway is directly connected to Su Shi’s dredging and water-management work at West Lake.'), keyTerms: const ['苏堤', '疏浚', '水利治理'], learnerInsight: '许澄脚下的路线本身就是自然与人工共同形成的结果。', check: '苏堤与哪类历史行动直接相关？', answer: '西湖疏浚和水利治理。', sourceIds: const ['hangzhou-west-lake-su-shi-water-management']),
  HangzhouDiscoverySpec(level: 3, title: '疏浚怎样改变湖的形状', storyLink: '桥边的声音让许澄开始注意“景观结构”而不只注意好不好听。', entry: _discovery('联合国教科文组织资料指出，西湖两条主要堤道和三座人工岛与九至十二世纪之间反复进行的疏浚工程有关。', simpleChinese: '长期疏浚不仅清理湖水，也参与形成堤和岛。', vietnamese: 'Các đợt nạo vét lặp lại từ thế kỷ 9 đến 12 góp phần hình thành các đê chính và đảo nhân tạo.', english: 'Repeated dredging from the ninth to twelfth centuries helped form the principal causeways and artificial islands.'), keyTerms: const ['疏浚', '堤道', '人工岛'], learnerInsight: '水管理可以同时改变生态条件、交通方式和景观构图。', check: '堤道和人工岛是否完全是天然形成的？', answer: '不是，它们与长期疏浚和人工营造有关。', sourceIds: const ['unesco-hangzhou-west-lake']),
  HangzhouDiscoverySpec(level: 4, title: '什么叫文化景观', storyLink: '许澄在第二次录音中不再把苏堤、桥和人的移动从湖水里分开。', entry: _discovery('西湖文化景观把湖面和三面山地，与堤、岛、桥、亭、塔、园林和植物配置等人工要素组织在同一个整体中。', simpleChinese: '西湖的价值来自自然山水与长期人工营造共同形成的整体。', vietnamese: 'Giá trị của Tây Hồ nằm ở tổng thể kết hợp cảnh quan tự nhiên với đê, đảo, cầu, đình, tháp, vườn và cây cối do con người tạo dựng.', english: 'West Lake’s value lies in the whole composition of natural scenery and long-term human-made elements.'), keyTerms: const ['文化景观', '自然山水', '人工营造'], learnerInsight: '“自然”和“人造”在这里不是互相排斥的两类。', check: '为什么只录湖水而完全排除人工空间，会漏掉西湖的一部分？', answer: '因为堤、岛、桥、园林等人工要素本来就是文化景观整体的一部分。', sourceIds: const ['unesco-hangzhou-west-lake', 'hangzhou-wgly-living-landscape']),
  HangzhouDiscoverySpec(level: 5, title: '文化景观也包含使用', storyLink: '许澄发现堤上的脚步和湖上的船声不是临时贴在风景上的“错误”。', entry: _discovery('西湖的文化景观并非封闭遗址：湖面、堤道、园林与东侧城市今天仍处在参观、通行、游船和日常公共活动之中。', simpleChinese: '西湖今天仍被人使用，不是只供远看的历史画面。', vietnamese: 'Tây Hồ ngày nay vẫn là không gian được đi lại, tham quan, đi thuyền và sử dụng công cộng.', english: 'West Lake remains a lived public landscape used for walking, visiting, boating, and everyday urban activity.'), keyTerms: const ['公共活动', '通行', '游船'], learnerInsight: '“活着的文化景观”会持续产生人的声音。', check: '文化景观是否意味着必须把现代公共生活全部清除？', answer: '不是；保护与当代使用可以在同一景观中并存。', sourceIds: const ['hangzhou-wgly-west-lake-seasons', 'hangzhou-gov-west-lake-evolution']),
  HangzhouDiscoverySpec(level: 6, title: '为什么诗画也塑造西湖', storyLink: '许澄最初想录一幅“可以听见的古画”，后来意识到这种想象本身有文化来源。', entry: _discovery('自九世纪以来，西湖持续吸引诗人、学者和艺术家，并对中国以及日本、朝鲜半岛的园林设计产生影响。', simpleChinese: '人们不仅改造西湖，也用诗歌、绘画和园林审美持续解释西湖。', vietnamese: 'Từ thế kỷ 9, thơ ca, nghệ thuật và thiết kế vườn đã liên tục định hình cách con người nhìn Tây Hồ.', english: 'Since the ninth century, poetry, art, and garden design have continually shaped how people understand West Lake.'), keyTerms: const ['九世纪', '诗歌', '绘画', '园林'], learnerInsight: '许澄想象的“古典纯净”并不是无文化的自然状态。', check: '西湖长期影响了哪些文化领域？', answer: '诗歌、绘画和园林设计等。', sourceIds: const ['unesco-hangzhou-west-lake']),
  HangzhouDiscoverySpec(level: 7, title: '“西湖十景”是一种观看方法', storyLink: '许澄从筛选声音转向辨认不同声层，像从一个固定画面转向多种观察方式。', entry: _discovery('南宋以来形成的“西湖十景”等题名景观，把特定地点、季节、天气和观看方式组合成文化记忆。', simpleChinese: '“西湖十景”不只是十个地点，也包含人们怎样命名和观看景色。', vietnamese: '“Mười cảnh Tây Hồ” không chỉ là địa điểm mà còn là cách đặt tên và nhìn phong cảnh theo thời tiết, mùa và góc nhìn.', english: 'The Ten Views of West Lake are not merely places; they encode named ways of seeing scenery through season, weather, and viewpoint.'), keyTerms: const ['西湖十景', '题名景观', '观看方式'], learnerInsight: '景观经验常由自然条件与文化命名共同形成。', check: '“西湖十景”的意义是否只是列出十个景点？', answer: '不是，它还保存了命名和观看景色的文化方式。', sourceIds: const ['unesco-hangzhou-west-lake', 'hangzhou-wgly-west-lake-seasons']),
  HangzhouDiscoverySpec(level: 8, title: '建筑为什么不能脱离湖来读', storyLink: '许澄在桥下听见回声，发现建筑会直接改变声音。', entry: _discovery('西湖的桥、亭、塔、寺庙、园林和植物并非独立展品，而是与湖面、山地、堤岛共同安排视线、路径和空间体验。', simpleChinese: '建筑和园林元素要放回湖、山、堤与路径的整体关系中理解。', vietnamese: 'Cầu, đình, tháp, chùa và vườn phải được hiểu trong quan hệ tổng thể với hồ, núi, đê và tuyến đi lại.', english: 'Bridges, pavilions, pagodas, temples, and gardens make sense as parts of the larger lake, hill, causeway, and route composition.'), keyTerms: const ['桥', '亭塔', '园林'], learnerInsight: '桥洞回声是故事里的声学细节，也对应真实空间结构。', check: '为什么故事选择桥边作为转折地点之一？', answer: '因为桥同时改变人的路线、视线和声音传播方式。', sourceIds: const ['unesco-hangzhou-west-lake', 'hangzhou-wgly-living-landscape']),
  HangzhouDiscoverySpec(level: 9, title: '为什么西湖以“文化景观”申遗', storyLink: '许澄最后保存的不是无人自然声，而是自然、人工空间与公共生活的叠层。', entry: _discovery('“杭州西湖文化景观”于2011年列入《世界遗产名录》，核心价值强调自然景观与历代人工营造、文化传统长期融合形成的整体。', simpleChinese: '西湖申遗的重点不是“纯自然湖泊”，而是自然与文化共同形成的景观。', vietnamese: 'Tây Hồ được ghi danh Di sản Thế giới năm 2011 với giá trị cốt lõi là sự kết hợp lâu dài giữa tự nhiên, can thiệp của con người và truyền thống văn hóa.', english: 'Inscribed in 2011, the West Lake Cultural Landscape is valued for the long-term fusion of natural scenery, human shaping, and cultural traditions.'), keyTerms: const ['2011年', '世界遗产', '文化景观'], learnerInsight: '许澄对“真实声音”的改变与“文化景观”概念形成同一学习方向。', check: '西湖是以什么类型的遗产概念被理解和保护的？', answer: '文化景观。', sourceIds: const ['unesco-hangzhou-west-lake', 'hangzhou-gov-west-lake-inscription']),
  HangzhouDiscoverySpec(level: 10, title: '活着的景观为什么会有杂音', storyLink: '“在场”这条录音把雨、游客、脚步、船和湖水留在同一时间截面。', entry: _discovery('西湖的遗产价值建立在千年以上持续的自然—人工关系上；今天保护这套格局，并不等于把景观冻结成没有人的历史舞台。', simpleChinese: '文化景观既需要保护，也仍与现实城市生活发生关系。', vietnamese: 'Cảnh quan văn hóa cần được bảo vệ nhưng vẫn tiếp tục có quan hệ với đời sống đô thị hiện tại.', english: 'A cultural landscape requires conservation while continuing to relate to present-day urban life.'), keyTerms: const ['保护', '城市生活', '在场'], learnerInsight: '“真实”不是把所有变化消音，而是知道哪些层次共同构成地点。', check: '为什么许澄最后没有把所有现代声音都删除？', answer: '因为西湖本来就是自然、人类营造与持续城市生活共同形成的文化景观。', sourceIds: const ['unesco-hangzhou-west-lake', 'hangzhou-gov-west-lake-evolution']),
]);

final hangzhouWestLakeOnePassDiscoveries = List<DiscoveryEntry>.unmodifiable([for (final spec in hangzhouWestLakeDiscoverySpecs) spec.entry]);
final hangzhouWestLakeDiscoveryTraces = List<RemediatedDiscoveryTrace>.unmodifiable([for (final spec in hangzhouWestLakeDiscoverySpecs) RemediatedDiscoveryTrace(discoveryIndex: spec.level - 1, storyEventIds: const ['HZ-E3-bridge', 'HZ-E4-recognition', 'HZ-E6-rain'], sourceIds: spec.sourceIds)]);

const _hangzhouMissingSentenceAnswers = <String>['许澄把麦克风转向堤上和水面，让雨声、脚步和人声一起进入录音。', '许澄把麦克风从湖面转向堤上，再转回水边，让这些变化完整进入录音。', '她不再追赶“干净”，而是把麦克风转向堤上与水面，让变化同时进入一条录音。', '她主动转动麦克风，让堤上人群和水面同时进入声场。', '许澄把麦克风转向堤上，再缓缓转回水面，让雨、人声、脚步和湖水在同一段录音里改变。', '许澄没有守住一条静态的“好听录音”，而是转动麦克风，主动收进堤上与湖面的变化。', '许澄把麦克风从水面转向堤上，再扫回湖面，主动让这些层次进入同一条声轨。', '许澄主动把麦克风从水面转向堤上，又缓慢扫回湖面，让天气改变人与水的过程完整进入声轨。', '许澄把麦克风从湖面转向堤上人群，再缓慢扫回水面，主动记录这些层次怎样因雨重新排列。', '许澄没有把麦克风藏到檐下保护那段相对安静的录音，而是转动指向，让堤上、桥下和水面的变化依次进入同一条声轨。'];

final hangzhouWestLakeChallenges = List<HangzhouChallengeSpec>.unmodifiable([for (var level = 1; level <= 10; level++) ...<HangzhouChallengeSpec>[HangzhouChallengeSpec(level: level, type: 'paragraphRebuild', anchor: hangzhouWestLakeOnePassLevels[level - 1].storyParagraphs.first, answer: '按当前等级故事顺序重建许澄从“纯净录音”到雨中重构声场的变化。'), HangzhouChallengeSpec(level: level, type: 'grammarRepair', anchor: hangzhouWestLakeOnePassLevels[level - 1].storyParagraphs.first, answer: hangzhouWestLakeOnePassLevels[level - 1].storyParagraphs.first), HangzhouChallengeSpec(level: level, type: 'missingSentence', anchor: _hangzhouMissingSentenceAnswers[level - 1], answer: _hangzhouMissingSentenceAnswers[level - 1])]]);

final hangzhouWestLakeMemory = List<RemediatedMemoryReview>.unmodifiable([
  const RemediatedMemoryReview(category: 'protagonist', prompt: '谁在苏堤进行这次城市采声？', answer: '许澄，二十一岁的杭州本地大学生，也是城市声音档案项目的参与者。', storyEventIds: ['HZ-E1-start']),
  const RemediatedMemoryReview(category: 'goal', prompt: '许澄一开始怎样理解“完美西湖”？', answer: '她想把风、湖水、柳叶和船桨留下，把现代人声、脚步、车铃和交通尽量排除。', storyEventIds: ['HZ-E1-start', 'HZ-E2-delete']),
  const RemediatedMemoryReview(category: 'route', prompt: '她主要沿什么路线采声？', answer: '从苏堤南端出发，经过堤道、桥边与水面相邻的声场。', storyEventIds: ['HZ-E1-start', 'HZ-E3-bridge']),
  const RemediatedMemoryReview(category: 'history', prompt: '苏堤为什么能证明西湖不是“纯自然”景观？', answer: '苏堤与西湖长期疏浚和水利治理有关，堤与岛等结构本来就包含人的持续营造。', storyEventIds: ['HZ-E4-recognition']),
  const RemediatedMemoryReview(category: 'culture', prompt: '“文化景观”在这段故事里指什么？', answer: '西湖的水体、三面山地与堤、岛、桥、园林、建筑、植物以及持续的人类使用共同构成一个整体。', storyEventIds: ['HZ-E4-recognition']),
  const RemediatedMemoryReview(category: 'conflict', prompt: '故事真正的问题是不是“能否在下雨前录完”？', answer: '不是。真正冲突是：把现代人的声音全部删除，究竟会不会也删除西湖作为活着的文化景观的一部分。', storyEventIds: ['HZ-E2-delete', 'HZ-E4-recognition']),
  const RemediatedMemoryReview(category: 'turningPoint', prompt: '桥边发生了什么变化？', answer: '脚步、桥洞回声、桨声和谈话无法被简单切开，许澄第一次没有确认删除，并开始记录“桥上通行”。', storyEventIds: ['HZ-E3-bridge', 'HZ-E4-recognition']),
  const RemediatedMemoryReview(category: 'climax', prompt: '第一滴雨进入录音后，许澄的关键动作是什么？', answer: '她主动转动麦克风，让堤上、桥下和水面因雨改变的声音依次进入同一条声轨。', storyEventIds: ['HZ-E6-rain']),
  const RemediatedMemoryReview(category: 'anchor', prompt: 'Memory Anchor是什么？', answer: '第一滴雨落进西湖录音里的声音。', storyEventIds: ['HZ-E6-rain', 'HZ-E7-ending']),
  const RemediatedMemoryReview(category: 'ending', prompt: '第二天她怎样归档这条录音？', answer: '按日期和苏堤路线保存，最后把标题写成“在场”。', storyEventIds: ['HZ-E7-ending']),
  const RemediatedMemoryReview(category: 'vocabulary', prompt: '“声场”和“文化景观”怎样在故事里连接？', answer: '声场让许澄听见同一空间里的多层声音；文化景观解释为什么这些自然声与人的活动不能被机械分开。', storyEventIds: ['HZ-E3-bridge', 'HZ-E4-recognition', 'HZ-E6-rain']),
]);

const hangzhouWestLakeCompletion = HangzhouCompleteSpec(journeySummary: '许澄从苏堤出发寻找“纯净”的西湖声景，删除被现代声音打断的第一段录音；桥上的回声与长期人工营造让她重新理解文化景观，阵雨到来时，她主动把变化中的人、水与天气录进同一条声轨。', achievement: '湖雨采声者', memoryAnchor: '第一滴雨落进西湖录音里的声音', anchorMeaning: '这一瞬间同时保存了天气变化、湖面变化和许澄采声标准的改变。', challengeReward: '西湖声纹章', rewardMeaning: '以雨点、水波和声纹为意象，代表对文化景观多层声音的辨认，而不是通行、跨越或路线完成。', rewardUnlockText: '你已完成杭州西湖三种故事挑战，解锁「西湖声纹章」。', journeyCompletion: '第二天，许澄按日期和苏堤路线归档录音，并把标题写成“在场”。');

const hangzhouWestLakeSources = <RemediatedSourceBinding>[
  RemediatedSourceBinding(id: 'unesco-hangzhou-west-lake', publisher: 'UNESCO World Heritage Centre', scope: '文化景观整体格局、九世纪以来文化影响、堤岛与反复疏浚、世界遗产价值'),
  RemediatedSourceBinding(id: 'hangzhou-west-lake-su-shi-water-management', publisher: '杭州西湖风景名胜区管理委员会', scope: '苏轼治理西湖、疏浚与苏堤形成'),
  RemediatedSourceBinding(id: 'hangzhou-wgly-west-lake-seasons', publisher: '杭州市文化广电旅游局', scope: '三面云山一面城、堤岛桥塔园林、九世纪以来文化景观与2011年列入世界遗产'),
  RemediatedSourceBinding(id: 'hangzhou-wgly-living-landscape', publisher: '杭州市文化广电旅游局', scope: '湖、堤、岛、桥、亭等共同形成诗意的活态文化景观'),
  RemediatedSourceBinding(id: 'hangzhou-gov-west-lake-inscription', publisher: '杭州市人民政府', scope: '2011年6月24日杭州西湖文化景观正式列入世界遗产名录'),
  RemediatedSourceBinding(id: 'hangzhou-gov-west-lake-evolution', publisher: '杭州市人民政府', scope: '西湖由自然与人工共同塑造、城市与自然持续融合及现代管理'),
];

const hangzhouWestLakeSemanticEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(id: 'HZ-E1-start', coreChinese: '许澄从苏堤南端开始一次雨前西湖连续采声。', corePinyin: 'Xǔ Chéng cóng Sūdī nán duān kāishǐ yǔ qián cǎishēng.', coreVietnamese: 'Hứa Trừng bắt đầu ghi âm Tây Hồ trước mưa từ đầu nam đê Tô.', coreEnglish: 'Xu Cheng begins a pre-rain West Lake field recording from the south end of Su Causeway.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'HZ-E2-delete', coreChinese: '她把现代人声当成污染，因自行车铃和谈话删掉第一段录音。', corePinyin: 'Tā bǎ xiàndài rénshēng dàngchéng wūrǎn, shānchú dì yī duàn lùyīn.', coreVietnamese: 'Cô xem âm thanh hiện đại là tạp nhiễu và xóa bản thu đầu tiên.', coreEnglish: 'She treats modern human sound as contamination and deletes the first take.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'HZ-E3-bridge', coreChinese: '桥边的脚步、回声、桨声与谈话形成无法简单切割的声层。', corePinyin: 'Qiáobiān de jiǎobù, huíshēng, jiǎngshēng yǔ tánhuà xíngchéng shēngcéng.', coreVietnamese: 'Bước chân, tiếng vọng, mái chèo và lời nói hòa thành nhiều lớp âm thanh ở cầu.', coreEnglish: 'Footsteps, bridge echo, oars, and conversation form inseparable layers.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'HZ-E4-recognition', coreChinese: '苏堤和长期疏浚让她意识到人的营造本就是西湖文化景观的一部分。', corePinyin: 'Sūdī hé shūjùn ràng tā yìshí dào rén de yíngzào shì wénhuà jǐngguān de yí bùfen.', coreVietnamese: 'Đê Tô và lịch sử nạo vét giúp cô nhận ra việc con người tạo dựng là một phần của cảnh quan văn hóa.', coreEnglish: 'Su Causeway and the history of dredging show her that human shaping is part of the cultural landscape.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'HZ-E5-weather', coreChinese: '乌云压近，第一滴雨把声场从雨前状态推入新的节奏。', corePinyin: 'Wūyún yājìn, dì yī dī yǔ gǎibiàn shēngchǎng.', coreVietnamese: 'Mây đen kéo tới và giọt mưa đầu tiên làm thay đổi toàn bộ trường âm.', coreEnglish: 'Clouds close in and the first raindrop changes the entire sound field.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'HZ-E6-rain', coreChinese: '许澄主动转动麦克风，在雨中依次记录堤上、桥下和水面的变化。', corePinyin: 'Xǔ Chéng zhǔdòng zhuǎndòng màikèfēng, jìlù dīshàng, qiáoxià hé shuǐmiàn.', coreVietnamese: 'Hứa Trừng chủ động xoay micro để ghi lại đê, dưới cầu và mặt nước trong mưa.', coreEnglish: 'Xu Cheng deliberately pans the microphone across causeway, bridge, and water in the rain.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
  RemediatedSemanticEvent(id: 'HZ-E7-ending', coreChinese: '第二天她按日期和苏堤路线归档声轨，并把标题写成“在场”。', corePinyin: 'Dì èr tiān tā àn rìqī hé Sūdī lùxiàn guīdàng, biāotí shì Zàichǎng.', coreVietnamese: 'Hôm sau cô lưu trữ theo ngày và tuyến đê Tô, đặt tên “Hiện diện”.', coreEnglish: 'The next day she archives the track by date and Su Causeway route and titles it “Presence”.', detailChinese: '', detailPinyin: '', detailVietnamese: '', detailEnglish: '', detailFromLevel: 10),
];

final hangzhouWestLakeOnePassRemediation = RemediatedJourney(id: hangzhouWestLakeJourneyId, title: '杭州 · 西湖：雨落进录音以后', protagonist: '许澄', goal: '在阵雨到来前沿苏堤完成一段连续环境录音，最初试图得到没有现代人声的“完美西湖”。', conflict: '许澄必须判断：把所有人的声音都当成污染，是否也会删除西湖作为活着的文化景观的一部分。', eventIds: List<String>.unmodifiable([for (final event in hangzhouWestLakeSemanticEvents) event.id]), events: hangzhouWestLakeSemanticEvents, levels: hangzhouWestLakeOnePassLevels, words: hangzhouWestLakeOnePassWords, wordTraces: hangzhouWestLakeWordTraces, discoveries: hangzhouWestLakeOnePassDiscoveries, discoveryTraces: hangzhouWestLakeDiscoveryTraces, challenges: List<RemediatedChallengeTrace>.unmodifiable([for (final challenge in hangzhouWestLakeChallenges) RemediatedChallengeTrace(type: challenge.type, storyEventIds: const ['HZ-E2-delete', 'HZ-E3-bridge', 'HZ-E6-rain'], anchor: challenge.anchor)]), memory: hangzhouWestLakeMemory, completion: const RemediatedCompletion(journeySummary: '许澄从苏堤出发寻找“纯净”的西湖声景，最终在阵雨中主动记录人与湖面共同改变的声场。', achievement: '湖雨采声者', memoryAnchor: '第一滴雨落进西湖录音里的声音', challengeReward: '西湖声纹章：记录雨、水与城市在场关系的声音徽记。', journeyCompletion: '第二天，许澄按日期和苏堤路线归档录音，并把标题写成“在场”。'), sources: hangzhouWestLakeSources);

JourneyLevelContent hangzhouWestLakeOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = hangzhouWestLakeOnePassLevels[level - 1];
  final story = base.storyParagraphs.join();
  final visibleWords = hangzhouWestLakeOnePassWords.where((entry) => story.contains(entry.word)).take((4 + level).clamp(5, 12)).toList(growable: false);
  return JourneyLevelContent(storyParagraphs: base.storyParagraphs, storyAnnotations: base.storyAnnotations, words: List<WordEntry>.unmodifiable(visibleWords), discoveries: List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[hangzhouWestLakeDiscoverySpecs[level - 1].entry]), wonderQuestion: '许澄为什么在桥边开始怀疑“越安静越真实”的录音标准？', expressQuestion: '第一滴雨到来后，堤上、桥下和水面的声音怎样共同改变了许澄记录西湖的方式？');
}
