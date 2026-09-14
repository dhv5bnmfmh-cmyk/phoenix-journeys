import 'package:pinyin/pinyin.dart';

import 'journey_data.dart';
import 'journey_level_catalog.dart';

const templeOfHeavenJourneyId = 'beijing-temple-of-heaven';
const templeOfHeavenCanonicalTitle = '被删掉的最好镜头';
const templeOfHeavenMemoryAnchor = '他们删掉了圜丘上最好看的那一帧，因为祈谷和冬至祭天不能被剪成同一场。';
const templeOfHeavenCoreTakeaway = '好故事可以压缩时间，却不能把不同礼仪压成同一件事。';

class TempleOfHeavenStoryDna {
  const TempleOfHeavenStoryDna({
    required this.centralTheme,
    required this.centralQuestion,
    required this.narrativePremise,
    required this.coreConflict,
    required this.mainCharacterGoal,
    required this.secondaryCharacterGoal,
    required this.characterMotivation,
    required this.avoidance,
    required this.observableEvidence,
    required this.historicalFacts,
    required this.turningPoint,
    required this.decision,
    required this.consequence,
    required this.relationshipChange,
    required this.beginningToEnding,
    required this.placeBinding,
    required this.forbiddenCityNonTransferability,
    required this.memoryAnchor,
  });

  final String centralTheme;
  final String centralQuestion;
  final String narrativePremise;
  final String coreConflict;
  final String mainCharacterGoal;
  final String secondaryCharacterGoal;
  final String characterMotivation;
  final String avoidance;
  final String observableEvidence;
  final String historicalFacts;
  final String turningPoint;
  final String decision;
  final String consequence;
  final String relationshipChange;
  final String beginningToEnding;
  final String placeBinding;
  final String forbiddenCityNonTransferability;
  final String memoryAnchor;
}

const templeOfHeavenStoryDna = TempleOfHeavenStoryDna(
  centralTheme: '在创作压力下守住历史叙事的边界：视觉连贯不等于历史事件相同。',
  centralQuestion: '当两个天坛镜头剪在一起更漂亮，却会让观众把不同礼仪理解成同一场时，创作者应该保住镜头还是保住区别？',
  narrativePremise: '十七岁的学生导演林桥和同学何予要在当天傍晚前完成一支天坛短片。林桥把祈年殿与圜丘剪成一场连续的“求丰收”仪式，何予发现这个漂亮的剪辑改变了历史关系。',
  coreConflict: '校展截止时间与电影叙事的流畅感，撞上祈谷和冬至祭天不能被合并成同一礼仪的事实边界。',
  mainCharacterGoal: '林桥要按时交出一支有记忆点、能进入校展首轮放映的九十秒短片。',
  secondaryCharacterGoal: '何予要让短片足够准确，使观众不会从剪辑中学到一个并不存在的礼仪顺序。',
  characterMotivation: '林桥想证明自己能独立完成导演工作；何予不愿只做挑错的人，也希望事实限制能够成为创作的一部分。',
  avoidance: '林桥害怕删掉最强镜头后作品变平、又错过提交；何予害怕自己的提醒被当成阻碍创意，最后干脆没人愿意听事实。',
  observableEvidence: '两人能看到祈年殿、圜丘、皇穹宇及它们的空间关系，能读现场和官方资料，能回看自己拍摄的素材与剪辑时间线，也能听到试看片观众实际产生的误解。',
  historicalFacts: '天坛是明清皇帝祭天、祈谷的礼仪建筑群；祈年殿服务祈求丰收，圜丘用于冬至祭天；皇穹宇与圜丘祭祀所用神牌有关；建筑在轴线上相联并不等于礼仪发生在同一时刻。',
  turningPoint: '试看片看完粗剪后问“是不是先在祈年殿求丰收，再去圜丘继续求丰收”，把何予担心的误解完整说了出来。',
  decision: '林桥主动删掉原来最漂亮的连续转场，与何予重写旁白，用两个清楚的礼仪语境重新组织镜头。',
  consequence: '他们失去最亮眼的圜丘转场，也错过校展系统的首轮封面截取，但保住最终提交资格，并交出历史关系清楚的版本。',
  relationshipChange: '两人从“导演决定、事实核对者否决”的关系，变成共同决定怎样讲事实的联合作者；林桥把何予的名字加到共同编剧栏。',
  beginningToEnding: '林桥从把历史细节视为服务故事的材料，转为承认剪辑本身会制造历史关系；何予也从只会说不能这样剪，转为提出既准确又能成立的叙事方案。',
  placeBinding: '故事依赖天坛中祈年殿、圜丘、皇穹宇既同属一套祭祀空间、又承担不同礼仪关系这一张力；正因为建筑视觉统一、空间相联，错误合并才如此诱人。',
  forbiddenCityNonTransferability: '紫禁城 Golden 的核心是不同人物任务下路线是否成立；本故事的冲突必须依赖天坛祈谷与冬至祭天的功能和时间区别，以及影像剪辑如何把两个礼仪错误制造成连续事件。搬到紫禁城后，这个冲突本身就不存在。',
  memoryAnchor: templeOfHeavenMemoryAnchor,
);

class TempleNarrativeReview {
  const TempleNarrativeReview({
    required this.level,
    required this.newStoryBeat,
    required this.characterReason,
    required this.consequence,
    required this.memorableImage,
    required this.progression,
  });

  final int level;
  final String newStoryBeat;
  final String characterReason;
  final String consequence;
  final String memorableImage;
  final String progression;
}

const templeNarrativeReviews = <TempleNarrativeReview>[
  TempleNarrativeReview(level: 1, newStoryBeat: '两人拍下祈年殿片头并锁定傍晚提交目标。', characterReason: '林桥要先拿到能撑住全片的漂亮开场。', consequence: '她把“祈求丰收”当成整片的统一叙事词。', memorableImage: '蓝瓦祈年殿装进手机取景框，倒计时贴在画面角落。', progression: 'setup + direct fact'),
  TempleNarrativeReview(level: 2, newStoryBeat: '圜丘现场资料第一次打断“同一场祈谷仪式”的想法。', characterReason: '何予不愿照着错误旁白继续录。', consequence: '两人第一次发生创作分歧。', memorableImage: '何予站在圜丘石阶下，把录音键停在半空。', progression: 'friction + new historical evidence'),
  TempleNarrativeReview(level: 3, newStoryBeat: '林桥用脚步声把两个地点剪成无缝连续动作。', characterReason: '她认为观众只需要一个顺畅故事。', consequence: '粗剪在影像上制造了不存在的连续仪式。', memorableImage: '剪辑线上两段脚步声严丝合缝地接在一起。', progression: 'choice + media causality'),
  TempleNarrativeReview(level: 4, newStoryBeat: '皇穹宇资料提供了第二层功能关系，何予拒绝录误导旁白。', characterReason: '他不想让自己的声音替错误关系背书。', consequence: '林桥独自录临时旁白，两人合作降温。', memorableImage: '空着的第二支耳机挂在长椅边，林桥一个人重录。', progression: 'new evidence + relationship fracture'),
  TempleNarrativeReview(level: 5, newStoryBeat: '校展截止提前，事实争论变成真正有成本的选择。', characterReason: '林桥担心重剪会直接错过首轮提交。', consequence: '她提出用笼统“天坛祭天”盖过区别。', memorableImage: '手机弹出“17:30 截止”，电量只剩一格。', progression: 'constraint + conditional decision'),
  TempleNarrativeReview(level: 6, newStoryBeat: '试看片观众准确说出了粗剪制造的错误理解。', characterReason: '林桥需要知道争论是否真的影响普通观众。', consequence: '她第一次承认问题不只是何予太较真。', memorableImage: '语音消息里传来一句“然后去圜丘继续求丰收吗？”', progression: 'turning evidence + consequence inference'),
  TempleNarrativeReview(level: 7, newStoryBeat: '两人把错误拆到“然后”、连续脚步声和镜头顺序，何予提出新结构。', characterReason: '何予也承认只删镜头会把影片变成知识清单。', consequence: '关系从否决与坚持转为共同设计。', memorableImage: '何予把时间线中间拉开一道空隙，写下“不同礼仪”。', progression: 'multi-clue diagnosis + relationship shift'),
  TempleNarrativeReview(level: 8, newStoryBeat: '夕光下拍到全片最好看的圜丘镜头，林桥仍选择删掉旧转场。', characterReason: '她已经知道保留它会继续制造错误连续性。', consequence: '他们失去最强视觉转场，也错过首轮封面截取。', memorableImage: '金色圜丘定格在删除确认框后消失。', progression: 'decision + cost'),
  TempleNarrativeReview(level: 9, newStoryBeat: '导出前两人处理“整体概述”和“具体礼仪”来源尺度不同的问题。', characterReason: '他们不想从一个错误跳到另一个过度断言。', consequence: '旁白改成既说明天坛整体用途、又区分具体建筑礼仪的表达。', memorableImage: '两条官方资料并排，粗体标注“整体”与“具体”。', progression: 'source-scope uncertainty + synthesis'),
  TempleNarrativeReview(level: 10, newStoryBeat: '试看片观众不再把两个礼仪说成同一场，影片提交，何予成为共同编剧。', characterReason: '林桥把事实判断视为创作责任，而不是外部审查。', consequence: '作品少了最好镜头，却多了真正属于天坛的叙事骨架。', memorableImage: '片尾“编剧：林桥、何予”出现时，圜丘镜头没有回来。', progression: 'result + transformation + closure'),
];

const templeStoryChapters = <List<String>>[
  <String>[
    '下午三点，林桥把手机架在祈年殿前。蓝色屋顶压进取景框，她退了两步，示意何予打板。“片头就从这里开始。”她说，“皇帝来天坛祈求丰收，观众一眼就懂。”何予按下场记板。学校的短片系统傍晚关闭，他们只有这一个下午。第一条拍完，林桥没有重来。风掠过栏杆，祈年殿在屏幕里稳稳停住，她觉得全片已经有了中心。',
  ],
  <String>[
    '四点前，他们到了圜丘。林桥让何予站在石阶下接一句旁白：“然后，皇帝来到这里继续祈求丰收。”何予没有按录音。他刚读过现场资料：圜丘用于冬至祭天，和祈年殿的祈谷不是同一个礼仪任务。他把这句话念给林桥听。林桥看了一眼太阳，又看了一眼空着的录音轨：“都在天坛，也都和祭天有关，先拍，回去再细分。”何予仍把录音键停在半空。两人第一次没有同时往前走。',
  ],
  <String>[
    '林桥最后还是拍了圜丘，只把何予的旁白改成环境声。坐到树荫下剪片时，她发现两个镜头异常合拍：祈年殿前的一步落地，正好能接上圜丘石阶的下一步。她把脚步声拉长，再加一个“然后”，两处空间便像同一段动作自然延续。何予看了两遍，说：“位置可以连起来，不代表礼仪也连续。”林桥没有删。她把这版标成“粗剪一”，理由很简单：九十秒里，顺比解释重要。',
  ],
  <String>[
    '他们继续走到皇穹宇。何予在资料里看到，皇穹宇与圜丘祭祀所用神牌有关，这条关系让“所有镜头都在讲同一场祈谷”更难成立。林桥却已经写好临时旁白，准备把祈年殿、皇穹宇和圜丘压进一句“皇帝在天坛祭天祈福”。何予把耳机摘下来：“这句太省了，省掉以后，观众只会以为三个地方在同一场仪式里接着用。”林桥问他能不能先录，何予说不能。几分钟后，长椅边只剩一副耳机在工作。林桥自己把临时旁白录完了。',
  ],
  <String>[
    '手机忽然弹出校展通知：上传截止从六点提前到五点半。林桥的电量也只剩一格。她把时间线推到何予面前：“我们没有时间重做。写‘天坛是祭天和祈谷的地方’总没有错吧？”何予承认这句整体概述可以成立，却不同意拿它覆盖具体礼仪。他指着两个镜头：“如果一句总称让两个不同场合看起来像同一场，它没有说假话，却会让剪辑替它说错话。”林桥盯着进度条。她第一次不是在问哪句话正确，而是在问：一句正确的话，能不能被错误的镜头关系用坏。',
  ],
  <String>[
    '林桥决定做一次最快的测试。她把粗剪发给正在校内等放映的小满，只问：“你看完觉得皇帝在做什么？”一分钟后，语音消息响起：“是不是先在祈年殿求丰收，然后去圜丘继续求丰收？”长椅旁没有人说话。那句话几乎照抄了剪辑制造的顺序，却不是何予教给他的。林桥把时间线退回祈年殿的最后一帧，又播放一次脚步声。她没有立刻删，只低声说：“所以不是你嫌我剪得太快，是他真的看成了一场。”',
  ],
  <String>[
    '两人开始拆这段误解是怎样被做出来的。何予先指出“然后”，林桥又发现连续的脚步声和相同方向的运动让观众自动补出了时间关系。她说：“那就全删，做成两个知识点。”何予却摇头。他承认自己之前只会阻止错误，却没有给影片留下故事。他把两段素材在时间线上拉开，在空隙处写下：“同一座天坛，不同的礼仪时间与任务。”他们决定不假装两个地点毫无关系，也不把空间相联偷换成事件连续。林桥把另一只耳机递回给他：“这句我们一起写。”',
  ],
  <String>[
    '离开前，夕光忽然落到圜丘石面上。林桥举起手机，拍到全天下午最好的一条：石阶从暗处亮起来，镜头向上抬，天空正好填满画面。它若接在祈年殿之后，比旧转场更漂亮。何予没有催她。回到长椅，林桥把这条镜头放进旧位置看了一遍，又移出来。删除确认框弹出时，她停了三秒，还是按下去。随后她重录旁白：祈年殿讲祈谷，圜丘讲冬至祭天，中间不再用“然后”。因为重剪，他们错过了校展系统自动截取首轮封面的时间。最好看的镜头没能替他们留下一个错误的仪式。',
  ],
  <String>[
    '导出前还剩一个问题。UNESCO 的整体介绍把天坛概括为皇帝祭天并祈求丰收的建筑群；北京市的具体介绍则把祈年殿与祈谷、圜丘与冬至祭天分别说明。林桥问：“两个来源是不是互相冲突？”何予没有马上回答。他们把资料并排重读，才发现一个说的是整座建筑群的总体用途，一个说的是具体建筑与礼仪。林桥删掉“天坛的祭祀只有两种”这句过度概括，改成：“在同一座祭祀建筑群里，不同空间承担不同礼仪关系。”她在字幕旁保留来源，而不是让一个总称替所有细节作证。',
  ],
  <String>[
    '五点二十七分，新版上传完成。林桥又把链接发给小满。这一次，小满看完只说：“原来祈年殿的祈谷和圜丘的冬至祭天不是前后接着的一场。”林桥没有解释，也没有把那条金色圜丘镜头加回来。她打开片尾，把“编剧：林桥”改成“编剧：林桥、何予”。何予看见后笑了一下，把最后一处字幕停留时间调长半秒。屏幕黑下去之前，片中没有出现全天下午最漂亮的镜头；但两个礼仪终于没有被剪成同一件事。',
  ],
];

final templeStoryParagraphsByLevel = <List<String>>[
  templeStoryChapters[0],
  templeStoryChapters[1],
  <String>[templeStoryChapters[1].single, templeStoryChapters[2].single],
  <String>[templeStoryChapters[2].single, templeStoryChapters[3].single],
  <String>[templeStoryChapters[3].single, templeStoryChapters[4].single],
  <String>[
    '${templeStoryChapters[3].single}${templeStoryChapters[4].single}',
    templeStoryChapters[5].single,
  ],
  <String>[
    '${templeStoryChapters[4].single}${templeStoryChapters[5].single}',
    templeStoryChapters[6].single,
  ],
  <String>[
    '${templeStoryChapters[5].single}${templeStoryChapters[6].single}',
    templeStoryChapters[7].single,
  ],
  <String>[
    '${templeStoryChapters[5].single}${templeStoryChapters[6].single}',
    '${templeStoryChapters[7].single}${templeStoryChapters[8].single}',
  ],
  <String>[
    '${templeStoryChapters[6].single}${templeStoryChapters[7].single}',
    '${templeStoryChapters[8].single}${templeStoryChapters[9].single}',
  ],
];

const templeLevelSupportEnglish = <String>[
  'Lin Qiao and He Yu begin a school short film at the Hall of Prayer for Good Harvests, with only one afternoon before submission closes.',
  'At the Circular Mound Altar, He Yu stops a voice-over that would turn the winter-solstice sacrifice to Heaven into a continuation of the harvest-prayer rite.',
  'Lin Qiao creates a seamless edit with footsteps and “then,” making two distinct ritual contexts appear continuous.',
  'Evidence at the Imperial Vault deepens the functional distinction, and He Yu refuses to record a misleading compressed narration.',
  'An earlier deadline makes the choice costly: a broadly true description of the Temple cannot justify a specifically misleading edit.',
  'A test viewer repeats the exact false sequence produced by the rough cut, proving that editing can create an unsupported historical relationship.',
  'They diagnose the misleading clues and design a new structure that keeps spatial connection without inventing ritual continuity.',
  'Lin Qiao deletes their most beautiful Circular Mound transition and accepts a real presentation cost in order to keep the ritual distinction clear.',
  'They compare a broad UNESCO description with a more specific Beijing municipal description and learn to match claims to source scope.',
  'The corrected film is understood accurately, and Lin Qiao credits He Yu as co-writer; their strongest deleted shot becomes the story’s memory anchor.',
];

const templeLevelSupportVietnamese = <String>[
  'Lâm Kiều và Hà Dự bắt đầu quay phim ngắn ở Điện Kỳ Niên, chỉ còn một buổi chiều trước hạn nộp.',
  'Tại Viên Khâu, Hà Dự dừng lời thuyết minh vì tế trời ngày Đông chí không phải phần tiếp theo của nghi lễ cầu mùa ở Điện Kỳ Niên.',
  'Lâm Kiều dùng tiếng bước chân và từ “sau đó” để nối hai cảnh, vô tình tạo cảm giác hai nghi lễ diễn ra liên tục.',
  'Tư liệu ở Hoàng Khung Vũ làm rõ thêm quan hệ chức năng; Hà Dự từ chối đọc lời thuyết minh dễ gây hiểu nhầm.',
  'Hạn nộp sớm hơn khiến lựa chọn có giá: mô tả tổng quát đúng về Thiên Đàn không thể biện minh cho một đoạn dựng cụ thể gây hiểu sai.',
  'Người xem thử lặp lại đúng chuỗi sự kiện sai do bản dựng tạo ra, chứng minh dựng phim có thể tạo quan hệ lịch sử không có căn cứ.',
  'Hai người tách các dấu hiệu gây hiểu nhầm và thiết kế cấu trúc mới, giữ quan hệ không gian nhưng không bịa ra tính liên tục của nghi lễ.',
  'Lâm Kiều xóa cảnh chuyển Viên Khâu đẹp nhất và chấp nhận mất lợi thế trình bày để giữ ranh giới lịch sử.',
  'Họ so sánh mô tả tổng quát của UNESCO với mô tả cụ thể của chính quyền Bắc Kinh và học cách giới hạn kết luận theo phạm vi nguồn.',
  'Bản phim sửa được hiểu đúng; Lâm Kiều ghi Hà Dự là đồng biên kịch, còn cảnh đẹp đã xóa trở thành ký ức riêng của câu chuyện.',
];

ReadingAnnotation _templeAnnotation(int level, String chinese) => ReadingAnnotation(
      pinyin: PinyinHelper.getPinyinE(
        chinese,
        separator: ' ',
        format: PinyinFormat.WITH_TONE_MARK,
      ),
      vietnamese: templeLevelSupportVietnamese[level - 1],
      english: templeLevelSupportEnglish[level - 1],
    );

const templeWords = <WordEntry>[
  WordEntry(word: '取景框', pinyin: 'qǔjǐngkuàng', simpleChinese: '拍摄时用来决定画面范围的框。', translation: 'Khung ngắm khi quay/chụp.', englishDefinition: 'viewfinder or frame used to compose an image', symbol: '🎬'),
  WordEntry(word: '祈谷', pinyin: 'qígǔ', simpleChinese: '为谷物丰收而祈求。', translation: 'Cầu mong mùa màng bội thu.', englishDefinition: 'to pray for a good harvest', symbol: '🌾'),
  WordEntry(word: '圜丘', pinyin: 'Yuánqiū', simpleChinese: '天坛南部的重要祭坛，明清时期用于冬至祭天。', translation: 'Viên Khâu, đàn tế trời vào Đông chí.', englishDefinition: 'the Circular Mound Altar, used for winter-solstice sacrifice to Heaven', symbol: '⭕'),
  WordEntry(word: '粗剪', pinyin: 'cūjiǎn', simpleChinese: '还没有完成细节调整的初步剪辑版本。', translation: 'Bản dựng thô.', englishDefinition: 'rough cut', symbol: '✂️'),
  WordEntry(word: '连续', pinyin: 'liánxù', simpleChinese: '中间没有明显中断。', translation: 'Liên tục.', englishDefinition: 'continuous', symbol: '⏩'),
  WordEntry(word: '皇穹宇', pinyin: 'Huángqióngyǔ', simpleChinese: '天坛中与圜丘祭祀神牌保存有关的建筑。', translation: 'Hoàng Khung Vũ.', englishDefinition: 'Imperial Vault of Heaven', symbol: '🏛️'),
  WordEntry(word: '压缩', pinyin: 'yāsuō', simpleChinese: '把较多内容缩短或集中。', translation: 'Nén, rút gọn.', englishDefinition: 'to compress or condense', symbol: '🗜️'),
  WordEntry(word: '概述', pinyin: 'gàishù', simpleChinese: '用较少的话说明整体情况。', translation: 'Khái quát.', englishDefinition: 'overview or summary', symbol: '🧾'),
  WordEntry(word: '覆盖', pinyin: 'fùgài', simpleChinese: '这里指用一个说法把更具体的区别遮住。', translation: 'Bao phủ; ở đây là che mất khác biệt cụ thể.', englishDefinition: 'to cover or obscure a more specific distinction', symbol: '🪟'),
  WordEntry(word: '试看片', pinyin: 'shìkànpiàn', simpleChinese: '正式发布前给少量观众看的测试版本。', translation: 'Bản phim xem thử.', englishDefinition: 'test screening cut', symbol: '👀'),
  WordEntry(word: '误解', pinyin: 'wùjiě', simpleChinese: '理解错了原来的意思或关系。', translation: 'Hiểu lầm.', englishDefinition: 'misunderstanding', symbol: '↯'),
  WordEntry(word: '线索', pinyin: 'xiànsuǒ', simpleChinese: '帮助判断事情关系的信息。', translation: 'Manh mối.', englishDefinition: 'clue or evidence cue', symbol: '🧩'),
  WordEntry(word: '偷换', pinyin: 'tōuhuàn', simpleChinese: '在没有说明的情况下把一个概念换成另一个。', translation: 'Đánh tráo khái niệm.', englishDefinition: 'to substitute one concept for another without justification', symbol: '🔁'),
  WordEntry(word: '转场', pinyin: 'zhuǎnchǎng', simpleChinese: '影视作品从一个场景进入另一个场景的连接方式。', translation: 'Chuyển cảnh.', englishDefinition: 'scene transition', symbol: '🎞️'),
  WordEntry(word: '冬至', pinyin: 'Dōngzhì', simpleChinese: '二十四节气之一，明清天坛圜丘祭天与此相关。', translation: 'Đông chí.', englishDefinition: 'Winter Solstice', symbol: '❄️'),
  WordEntry(word: '尺度', pinyin: 'chǐdù', simpleChinese: '这里指一个来源能够支持多大范围的说法。', translation: 'Phạm vi, mức độ.', englishDefinition: 'scope or extent of a claim', symbol: '📏'),
  WordEntry(word: '断言', pinyin: 'duànyán', simpleChinese: '很明确地说某件事一定如此。', translation: 'Khẳng định chắc chắn.', englishDefinition: 'assertion', symbol: '📌'),
  WordEntry(word: '编剧', pinyin: 'biānjù', simpleChinese: '负责设计和写影视故事、台词的人。', translation: 'Biên kịch.', englishDefinition: 'screenwriter', symbol: '✍️'),
];

class _TempleDiscoverySeed {
  const _TempleDiscoverySeed(this.text, this.simpleChinese, this.english, this.vietnamese, this.sourceRefs);
  final String text;
  final String simpleChinese;
  final String english;
  final String vietnamese;
  final List<String> sourceRefs;
}

const _unesco = 'unesco-temple-of-heaven-881';
const _beijingGov = 'beijing-gov-temple-of-heaven';

const _templeDiscoveries = <List<_TempleDiscoverySeed>>[
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('祈年殿位于天坛北部，是明清皇帝祈求丰收的重要建筑。', '祈年殿和祈求丰收有关。', 'The Hall of Prayer for Good Harvests is a principal northern structure associated with imperial prayers for a good harvest.', 'Điện Kỳ Niên ở phía bắc Thiên Đàn, gắn với nghi lễ cầu mùa.', <String>[_unesco, _beijingGov]),
    _TempleDiscoverySeed('天坛整体服务明清皇帝祭天与祈谷等国家礼仪，建筑的文化意义来自空间、礼仪和象征关系共同作用。', '天坛不是普通公园建筑，而是国家礼仪空间。', 'The Temple of Heaven was an imperial ritual complex for sacrifice to Heaven and prayers for harvests.', 'Thiên Đàn là quần thể nghi lễ hoàng gia dùng cho tế trời và cầu mùa.', <String>[_unesco, _beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('圜丘位于天坛南部，明清时期用于冬至举行祭天礼仪。', '圜丘和冬至祭天直接相关。', 'The Circular Mound Altar in the south was used for ceremonial sacrifices to Heaven at the Winter Solstice.', 'Viên Khâu ở phía nam được dùng cho lễ tế trời vào Đông chí.', <String>[_beijingGov]),
    _TempleDiscoverySeed('祈年殿的祈谷与圜丘的冬至祭天都属于天坛礼仪体系，但功能与举行语境并不相同。', '同属天坛，不等于同一场礼仪。', 'Both belong to the Temple ritual system, but prayer for harvests and the winter-solstice sacrifice are distinct ritual contexts.', 'Cùng thuộc Thiên Đàn không có nghĩa là cùng một nghi lễ.', <String>[_unesco, _beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('天坛主要礼仪建筑沿南北轴线组织，圜丘、皇穹宇与祈年殿在空间上形成联系。', '建筑在轴线上有联系。', 'Major ritual structures are organized along a north-south axis, creating spatial relationships across the complex.', 'Các công trình nghi lễ chính được tổ chức theo trục bắc-nam.', <String>[_unesco]),
    _TempleDiscoverySeed('空间相连说明建筑属于同一礼仪体系的一部分，却不能单凭“相连”推出两个仪式在时间上连续发生。', '空间关系不能自动证明时间顺序。', 'Spatial connection is evidence of architectural organization, not by itself evidence that separate rites occurred consecutively.', 'Quan hệ không gian không tự chứng minh thứ tự thời gian của nghi lễ.', <String>[_unesco, _beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('皇穹宇位于圜丘以北，相关院落用于保存圜丘祭祀所用的神牌。', '皇穹宇与圜丘祭祀有直接功能关系。', 'The Imperial Vault of Heaven, north of the Circular Mound, housed tablets used for Circular Mound ceremonies.', 'Hoàng Khung Vũ lưu giữ thần vị dùng cho nghi lễ ở Viên Khâu.', <String>[_beijingGov]),
    _TempleDiscoverySeed('判断建筑关系时，功能证据可以补充纯粹的视觉相似或位置关系。', '看起来像一组，不等于用途相同。', 'Functional evidence can refine what visual similarity or proximity alone suggests.', 'Chức năng giúp kiểm tra kết luận chỉ dựa vào hình thức hay vị trí.', <String>[_beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('UNESCO把天坛作为完整的祭祀建筑群理解，强调其布局、建筑与古代宇宙观之间的关系。', '理解天坛要看整体系统。', 'UNESCO treats the Temple as an integrated sacrificial complex whose layout and architecture embody cosmological ideas.', 'UNESCO xem Thiên Đàn như một quần thể nghi lễ thống nhất.', <String>[_unesco]),
    _TempleDiscoverySeed('整体事实“天坛用于祭天与祈谷”不能取代具体事实“哪座建筑与哪种礼仪相关”。', '总称正确，也可能不够具体。', 'A correct statement about the complex as a whole cannot replace a monument-specific ritual claim.', 'Một mô tả tổng quát đúng không thể thay thế thông tin nghi lễ cụ thể.', <String>[_unesco, _beijingGov]),
    _TempleDiscoverySeed('在历史表达中，概括的范围必须和证据的范围一致；越具体的结论，越需要对应的具体来源。', '具体结论需要具体证据。', 'The specificity of a historical claim should match the scope of its evidence.', 'Mức cụ thể của kết luận lịch sử phải phù hợp với phạm vi chứng cứ.', <String>[_unesco, _beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('祈谷与冬至祭天的区别不仅是地点不同，也涉及礼仪目的与举行时间。', '区别包括地点、目的和时间。', 'The distinction involves ritual purpose and timing, not merely different locations.', 'Khác biệt nằm ở mục đích và thời điểm nghi lễ, không chỉ ở địa điểm.', <String>[_beijingGov]),
    _TempleDiscoverySeed('历史短片即使没有说出一句假话，也可能通过“然后”、连续声音或镜头顺序暗示不存在的因果或时间关系。', '影像顺序也会表达关系。', 'Editing order and connective language can imply unsupported temporal or causal relationships even when individual sentences are true.', 'Thứ tự dựng phim có thể ngầm tạo quan hệ thời gian hoặc nhân quả không có căn cứ.', <String>[_unesco, _beijingGov]),
    _TempleDiscoverySeed('Teach-before-test 的关键不是记住两个建筑名，而是能说明为什么“同属天坛”不足以证明“同一场礼仪”。', '要理解关系，不只记名字。', 'The learning target is relational: belonging to one complex does not make two rites one event.', 'Mục tiêu là hiểu quan hệ, không chỉ nhớ tên công trình.', <String>[_unesco, _beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('从圜丘向北经过皇穹宇并继续通向祈年殿，轴线把不同礼仪空间组织成一个整体。', '轴线组织空间，但不会消除功能区别。', 'The axis organizes distinct ritual spaces into one complex without erasing their functional distinctions.', 'Trục không gian tổ chức quần thể nhưng không xóa khác biệt chức năng.', <String>[_unesco]),
    _TempleDiscoverySeed('“同一建筑群”是空间与制度层面的关系；“同一场礼仪”则是事件层面的判断，两者需要不同证据。', '空间关系和事件关系不能偷换。', 'A shared complex is a spatial/institutional relationship; a single rite is an event-level claim requiring different evidence.', 'Quan hệ cùng quần thể và quan hệ cùng một nghi lễ là hai loại kết luận khác nhau.', <String>[_unesco, _beijingGov]),
    _TempleDiscoverySeed('好的解释可以同时保留联系与区别：天坛整体承担祭天、祈谷礼仪，而具体建筑在不同礼仪中有不同作用。', '联系和区别可以同时成立。', 'Accurate interpretation can preserve both unity and distinction across the Temple complex.', 'Giải thích tốt có thể giữ cả tính thống nhất và sự khác biệt.', <String>[_unesco, _beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('圜丘的建筑设计大量使用九或九的倍数，体现传统数字象征，但这种象征信息不能替代它的具体礼仪功能。', '象征和功能是两个知识维度。', 'The Circular Mound uses nine and multiples of nine symbolically; symbolic design and ritual function are related but distinct knowledge dimensions.', 'Viên Khâu dùng số chín và bội số của chín mang tính biểu tượng; biểu tượng không thay thế chức năng nghi lễ.', <String>[_beijingGov]),
    _TempleDiscoverySeed('“最好看”属于创作判断；“能否支持某个历史关系”属于证据判断。两种标准可以同时考虑，但不能互相替代。', '审美不能替代历史证据。', 'Aesthetic quality and evidentiary support are separate criteria that should not be substituted for one another.', 'Giá trị thẩm mỹ và chứng cứ lịch sử là hai tiêu chí khác nhau.', <String>[_unesco, _beijingGov]),
    _TempleDiscoverySeed('删除一个会误导关系的镜头，不等于删除历史；有时它反而保护了建筑之间真实的功能区别。', '少一个镜头，也可以更准确。', 'Removing a misleading transition can preserve rather than diminish historical meaning.', 'Bỏ một cảnh gây hiểu lầm có thể giúp giữ ý nghĩa lịch sử chính xác hơn.', <String>[_unesco, _beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('UNESCO 的整体描述与北京市政府的具体建筑介绍可以同时成立，因为它们回答的是不同尺度的问题。', '不同来源可以互补，不必假设冲突。', 'A broad UNESCO synthesis and monument-specific municipal information can both be correct because they address different scopes.', 'Mô tả tổng quát của UNESCO và thông tin cụ thể của Bắc Kinh có thể bổ sung nhau.', <String>[_unesco, _beijingGov]),
    _TempleDiscoverySeed('评价来源时要先问它在说明整座遗产、某座建筑，还是某项礼仪；来源权威之外，还要看它是否适合当前问题。', '来源可靠，还要范围合适。', 'Source evaluation requires both authority and fit between source scope and the claim being made.', 'Ngoài độ tin cậy, cần xem phạm vi nguồn có phù hợp với câu hỏi hay không.', <String>[_unesco, _beijingGov]),
    _TempleDiscoverySeed('在证据不足时，缩小结论通常比补上一个未经支持的细节更可靠。', '证据不够时应缩小说法。', 'When evidence does not support a broad claim, narrowing the claim is more defensible than inventing specificity.', 'Khi chứng cứ chưa đủ, nên thu hẹp kết luận thay vì thêm chi tiết không có căn cứ.', <String>[_unesco, _beijingGov]),
  ],
  <_TempleDiscoverySeed>[
    _TempleDiscoverySeed('天坛的遗产价值不仅在单体建筑，也在建筑群、空间布局、礼仪功能与思想象征之间保存下来的关系。', '保护遗产也包括理解关系。', 'The Temple’s heritage value lies in relationships among architecture, layout, ritual function, and symbolic ideas, not only in individual buildings.', 'Giá trị di sản của Thiên Đàn còn nằm ở quan hệ giữa kiến trúc, bố cục, nghi lễ và biểu tượng.', <String>[_unesco]),
    _TempleDiscoverySeed('准确区分祈谷与冬至祭天，并不会把天坛拆成互不相关的碎片；它让学习者更清楚地理解整体由哪些不同关系组成。', '区别越清楚，整体反而更可理解。', 'Distinguishing rites clarifies rather than fragments understanding of the complex.', 'Phân biệt nghi lễ giúp hiểu tổng thể rõ hơn chứ không làm nó rời rạc.', <String>[_unesco, _beijingGov]),
    _TempleDiscoverySeed('历史叙事的责任不只是“句句真实”，还包括不要用剪辑、连接词或画面顺序制造证据没有支持的关系。', '关系也必须有证据。', 'Responsible historical narration must avoid creating unsupported relationships through editing or connective language.', 'Kể chuyện lịch sử có trách nhiệm phải tránh tạo quan hệ không có chứng cứ bằng dựng phim hay từ nối.', <String>[_unesco, _beijingGov]),
  ],
];

DiscoveryEntry _discovery(_TempleDiscoverySeed seed) => DiscoveryEntry(
      text: seed.text,
      pinyin: PinyinHelper.getPinyinE(seed.text, separator: ' ', format: PinyinFormat.WITH_TONE_MARK),
      simpleChinese: seed.simpleChinese,
      vietnamese: seed.vietnamese,
      english: seed.english,
      sourceRefs: seed.sourceRefs,
    );

List<WordEntry> templeWordsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  final searchable = <String>[
    ...templeStoryParagraphsByLevel[safeLevel - 1],
    ..._templeDiscoveries[safeLevel - 1].map((item) => item.text),
  ].join();
  final visible = templeWords.where((entry) => searchable.contains(entry.word)).toList(growable: false);
  return List<WordEntry>.unmodifiable(visible.isEmpty ? templeWords.take(4) : visible);
}

JourneyLevelContent templeOfHeavenLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final paragraphs = templeStoryParagraphsByLevel[level - 1];
  final discoveries = _templeDiscoveries[level - 1].map(_discovery).toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(<ReadingAnnotation>[
      for (final paragraph in paragraphs) _templeAnnotation(level, paragraph),
    ]),
    words: templeWordsForLevel(level),
    discoveries: List<DiscoveryEntry>.unmodifiable(discoveries),
    wonderQuestion: switch (level) {
      1 => '林桥为什么一开始把“祈求丰收”当成整支短片的中心？',
      2 => '何予为什么没有照着林桥写的句子继续录音？',
      3 => '“然后”和连续脚步声怎样改变了两个镜头之间的关系？',
      4 => '何予拒绝录旁白以后，两人的合作发生了什么变化？',
      5 => '一句整体正确的话为什么仍可能支持一个错误剪辑？',
      6 => '小满的哪句话让林桥确认误解已经真正发生？',
      7 => '何予为什么不赞成把影片改成两个互不相干的知识点？',
      8 => '林桥删掉最好镜头时真正放弃的是什么，又保住了什么？',
      9 => '两个官方来源为什么不是互相冲突，而是说明尺度不同？',
      _ => '林桥和何予最终改变的，不只是短片内容，还有哪一种合作关系？',
    },
    expressQuestion: switch (level) {
      1 => '用“先…再…”说明林桥和何予开始拍摄时的两个动作。',
      2 => '用“虽然…但是…”说明祈年殿和圜丘同属天坛却不能被说成同一礼仪。',
      3 => '说明空间相连、镜头相连和事件连续三者为什么不能混为一谈。',
      4 => '用因果句说明皇穹宇资料为什么让原旁白更难成立。',
      5 => '在“如果…那么…”结构里解释截止时间怎样改变两人的选择。',
      6 => '按“粗剪→试看片→误解→林桥改变态度”的顺序复述转折。',
      7 => '比较“全部删除”与“保留联系但区分礼仪”两个方案。',
      8 => '用让步句解释林桥为什么明知镜头最好看仍然删除。',
      9 => '说明整体来源与具体来源分别能支持什么范围的结论。',
      _ => '综合人物变化、历史区别和创作代价，解释为什么“被删掉的最好镜头”是这条 Story 的 Memory Anchor。',
    },
  );
}

final templeOfHeavenCanonicalStoryParagraphs = <String>[
  for (final chapter in templeStoryChapters) chapter.single,
];

final templeOfHeavenBaseAnnotations = List<ReadingAnnotation>.unmodifiable(<ReadingAnnotation>[
  for (final paragraph in templeOfHeavenCanonicalStoryParagraphs)
    _templeAnnotation(1, paragraph),
]);

final templeOfHeavenBaseDiscoveries = List<DiscoveryEntry>.unmodifiable(<DiscoveryEntry>[
  _discovery(_templeDiscoveries[0][0]),
  _discovery(_templeDiscoveries[1][0]),
]);
