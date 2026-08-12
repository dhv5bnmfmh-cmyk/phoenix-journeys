import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const journeyExpansionSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-suzhou-classical-gardens',
    title: 'Classical Gardens of Suzhou',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/813',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-jiangsu-suzhou-gusu-humble-administrators-garden'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'suzhou-garden-bureau-humble-administrators-garden',
    title: '拙政园',
    publisher: '苏州市园林和绿化管理局',
    url: 'https://ylj.suzhou.gov.cn/szsylj/sjyc/201905/c1df393edc8745abb20e8a9bd5525782.shtml',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-jiangsu-suzhou-gusu-humble-administrators-garden'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-luoyang-longmen-grottoes',
    title: 'Longmen Grottoes',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1003',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-henan-luoyang-luolong-longmen-grottoes'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'ncha-luoyang-longmen-grottoes',
    title: '龙门石窟',
    publisher: '国家文物局',
    url: 'https://www.ncha.gov.cn/art/2024/8/8/art_2791_190649.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-henan-luoyang-luolong-longmen-grottoes'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-quanzhou-emporium',
    title: 'Quanzhou: Emporium of the World in Song-Yuan China',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1561',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-fujian-quanzhou-licheng-kaiyuan-temple'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'quanzhou-government-kaiyuan-temple',
    title: '开元寺：从海洋贸易中崛起的多元文化家园',
    publisher: '泉州市人民政府',
    url: 'https://www.quanzhou.gov.cn/lyb/lyxw/202104/t20210421_2547183.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-fujian-quanzhou-licheng-kaiyuan-temple'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
];

JourneyContentRecord _journeyRecord({
  required String id,
  required String title,
  required String geoNodeId,
  required List<String> tags,
  required List<String> paragraphs,
  required List<String> sourceIds,
}) {
  return JourneyContentRecord(
    id: id,
    title: title,
    geoNodeId: geoNodeId,
    languageCode: 'zh-CN',
    verificationStatus: StoryVerificationStatus.published,
    tags: tags,
    sections: List.generate(
      paragraphs.length,
      (index) => JourneyStorySection(
        id: 'story-$index',
        text: paragraphs[index],
        sourceIds: sourceIds,
      ),
    ),
  );
}

const _suzhouParagraphs = <String>[
  '下周一，十二岁的程朗要开始自己坐车去初中。六年来，外婆陈玉兰几乎每天都去接他放学；这个星期天，她带他来到拙政园，程朗第一次认真提出：“今天让我走前面吧，我在下一处等你。”陈玉兰看了他一眼，只说：“别走太快。”',
  '沿着池水转过长廊，亭子、白墙和树影叠得像一幅被墙角切开的山水画。程朗的背影第一次从她眼前消失时，陈玉兰立刻喊了他的名字。程朗从转角退回来，没有争辩，只把脚步放慢了一点。',
  '再往前走，曲桥和屋角又一次截断视线，廊下的人声盖住了程朗的脚步声。陈玉兰抬起手，他的名字已经到了嘴边，却没有喊；她把手放下来，自己走完那几步看不见他的路。',
  '下一处水面重新打开时，程朗已经停在前面，正回头找她。他问：“外婆，我还能走前面吗？”陈玉兰把肩上的水壶带往上提了提，说：“下一处等我。”程朗转过去，背影很快又被房屋挡住。陈玉兰没有追上去。',
];

const _suzhouAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin: 'Xià zhōuyī, shí’èr suì de Chéng Lǎng yào kāishǐ zìjǐ zuò chē qù chūzhōng. Liù nián lái, wàipó Chén Yùlán jīhū měitiān dōu qù jiē tā fàngxué; zhège xīngqītiān, tā dài tā láidào Zhuōzhèng Yuán, Chéng Lǎng dì yī cì rènzhēn tíchū: “Jīntiān ràng wǒ zǒu qiánmiàn ba, wǒ zài xià yí chù děng nǐ.” Chén Yùlán kàn le tā yì yǎn, zhǐ shuō: “Bié zǒu tài kuài.”',
    vietnamese: 'Thứ Hai tuần sau, Trình Lãng mười hai tuổi sẽ bắt đầu tự đi xe đến trường trung học cơ sở. Suốt sáu năm, bà ngoại Trần Ngọc Lan gần như ngày nào cũng đón cậu tan học; Chủ nhật này, bà đưa cậu đến Chuyết Chính Viên, và lần đầu cậu nghiêm túc nói: “Hôm nay để cháu đi phía trước nhé, cháu sẽ đợi bà ở chỗ tiếp theo.” Bà nhìn cậu rồi chỉ nói: “Đừng đi nhanh quá.”',
    english: 'Next Monday, twelve-year-old Cheng Lang will begin travelling to middle school on his own. For six years, his grandmother Chen Yulan has picked him up after school almost every day; this Sunday at the Humble Administrator’s Garden, he asks seriously for the first time, “Let me walk ahead today. I’ll wait for you at the next place.” She looks at him and says only, “Don’t go too fast.”',
  ),
  ReadingAnnotation(
    pinyin: 'Yánzhe chíshuǐ zhuǎnguò chángláng, tíngzi, báiqiáng hé shùyǐng dié de xiàng yì fú bèi qiángjiǎo qiēkāi de shānshuǐhuà. Chéng Lǎng de bèiyǐng dì yī cì cóng tā yǎnqián xiāoshī shí, Chén Yùlán lìkè hǎn le tā de míngzi. Chéng Lǎng cóng zhuǎnjiǎo tuì huílái, méiyǒu zhēngbiàn, zhǐ bǎ jiǎobù fàngmàn le yìdiǎn.',
    vietnamese: 'Đi dọc mặt nước rồi rẽ qua hành lang dài, đình, tường trắng và bóng cây xếp lớp như một bức tranh sơn thủy bị góc tường cắt ngang. Lần đầu bóng lưng Trình Lãng biến khỏi tầm mắt, Trần Ngọc Lan lập tức gọi tên cậu. Cậu quay lại từ góc rẽ, không tranh cãi, chỉ đi chậm hơn một chút.',
    english: 'Along the pond and around a long corridor, pavilions, white walls, and tree shadows overlap like a landscape painting cut by the corner of a wall. The first time Cheng Lang disappears from sight, Chen Yulan immediately calls his name. He comes back around the corner without arguing and simply slows his pace a little.',
  ),
  ReadingAnnotation(
    pinyin: 'Zài wǎng qián zǒu, qūqiáo hé wūjiǎo yòu yí cì jiéduàn shìxiàn, lángxià de rénshēng gàizhù le Chéng Lǎng de jiǎobùshēng. Chén Yùlán táiqǐ shǒu, tā de míngzi yǐjīng dào le zuǐbiān, què méiyǒu hǎn; tā bǎ shǒu fàng xiàlái, zìjǐ zǒuwán nà jǐ bù kànbujiàn tā de lù.',
    vietnamese: 'Đi tiếp, cầu cong và góc mái lại cắt đứt tầm nhìn, tiếng người dưới hành lang át cả tiếng bước chân của Trình Lãng. Trần Ngọc Lan giơ tay, tên cậu đã ở ngay đầu môi nhưng bà không gọi; bà hạ tay xuống và tự đi hết mấy bước không nhìn thấy cậu.',
    english: 'Farther on, a curved bridge and the corner of a building cut the sightline again, while voices under the corridor cover Cheng Lang’s footsteps. Chen Yulan raises her hand, his name already at her lips, but does not call. She lowers her hand and walks those few unseen steps herself.',
  ),
  ReadingAnnotation(
    pinyin: 'Xià yí chù shuǐmiàn chóngxīn dǎkāi shí, Chéng Lǎng yǐjīng tíng zài qiánmiàn, zhèng huítóu zhǎo tā. Tā wèn: “Wàipó, wǒ hái néng zǒu qiánmiàn ma?” Chén Yùlán bǎ jiānshàng de shuǐhúdài wǎng shàng tí le tí, shuō: “Xià yí chù děng wǒ.” Chéng Lǎng zhuǎn guòqù, bèiyǐng hěn kuài yòu bèi fángwū dǎngzhù. Chén Yùlán méiyǒu zhuī shàngqù.',
    vietnamese: 'Khi mặt nước ở khoảng tiếp theo lại mở ra, Trình Lãng đã dừng phía trước và đang quay đầu tìm bà. Cậu hỏi: “Bà ơi, cháu vẫn được đi phía trước chứ?” Trần Ngọc Lan kéo quai bình nước trên vai lên rồi nói: “Đợi bà ở chỗ tiếp theo.” Trình Lãng quay đi, bóng lưng nhanh chóng lại bị căn nhà che khuất. Trần Ngọc Lan không đuổi theo.',
    english: 'When the water opens into view again, Cheng Lang has already stopped ahead and is looking back for her. “Grandma, can I still walk in front?” he asks. Chen Yulan adjusts the water-bottle strap on her shoulder and says, “Wait for me at the next place.” He turns away and soon disappears behind a building again. She does not hurry after him.',
  ),
];

const _suzhouWords = <WordEntry>[
  WordEntry(word: '园林', pinyin: 'yuánlín', partOfSpeech: '名词', simpleChinese: '经过设计的庭园和景观。', translation: 'Vườn cảnh được thiết kế.', englishDefinition: 'designed garden landscape', symbol: '🌿'),
  WordEntry(word: '亭子', pinyin: 'tíngzi', partOfSpeech: '名词', simpleChinese: '供人休息观景的小建筑。', translation: 'Đình nhỏ để nghỉ và ngắm cảnh.', englishDefinition: 'pavilion', symbol: '🏯'),
  WordEntry(word: '漏窗', pinyin: 'lòuchuāng', partOfSpeech: '名词', simpleChinese: '带有镂空图案的园林窗。', translation: 'Cửa sổ hoa văn rỗng trong vườn.', englishDefinition: 'decorative openwork window', symbol: '🪟'),
  WordEntry(word: '长廊', pinyin: 'chángláng', partOfSpeech: '名词', simpleChinese: '连接不同空间的长走廊。', translation: 'Hành lang dài nối các không gian.', englishDefinition: 'long covered corridor', symbol: '🚶'),
  WordEntry(word: '借景', pinyin: 'jièjǐng', partOfSpeech: '名词', simpleChinese: '把远处景色引入园内的设计方法。', translation: 'Kỹ thuật mượn cảnh bên ngoài.', englishDefinition: 'borrowed scenery', symbol: '🖼️'),
  WordEntry(word: '池水', pinyin: 'chíshuǐ', partOfSpeech: '名词', simpleChinese: '池塘里的水。', translation: 'Nước trong ao.', englishDefinition: 'pond water', symbol: '💧'),
  WordEntry(word: '曲桥', pinyin: 'qūqiáo', partOfSpeech: '名词', simpleChinese: '弯曲转折的小桥。', translation: 'Cầu nhỏ uốn cong.', englishDefinition: 'curved bridge', symbol: '🌉'),
  WordEntry(word: '山水画', pinyin: 'shānshuǐhuà', partOfSpeech: '名词', simpleChinese: '表现山川自然的中国画。', translation: 'Tranh sơn thủy Trung Hoa.', englishDefinition: 'Chinese landscape painting', symbol: '🖌️'),
  WordEntry(word: '层次', pinyin: 'céngcì', partOfSpeech: '名词', simpleChinese: '空间前后形成的不同层面。', translation: 'Các lớp không gian trước sau.', englishDefinition: 'visual layers and depth', symbol: '🌫️'),
];

const _suzhouDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '苏州古典园林以精细设计在有限空间中重现自然山水。', pinyin: 'Sūzhōu Gǔdiǎn Yuánlín yǐ jīngxì shèjì zài yǒuxiàn kōngjiān zhōng chóngxiàn zìrán shānshuǐ.', simpleChinese: '苏州园林用小空间表现大自然。', vietnamese: 'Vườn cổ điển Tô Châu tái hiện thiên nhiên trong không gian nhỏ bằng thiết kế tinh tế.', english: 'Suzhou gardens recreate natural landscapes within limited space.'),
  DiscoveryEntry(text: '世界遗产项目包括苏州历史城区内九座具有代表性的园林。', pinyin: 'Shìjiè Yíchǎn xiàngmù bāokuò Sūzhōu lìshǐ chéngqū nèi jiǔ zuò jùyǒu dàibiǎoxìng de yuánlín.', simpleChinese: '九座代表性园林共同组成世界遗产。', vietnamese: 'Chín khu vườn tiêu biểu tạo thành quần thể Di sản Thế giới.', english: 'Nine representative gardens form the World Heritage property.'),
  DiscoveryEntry(text: '拙政园以池水为中心，通过回廊、漏窗与借景组织出丰富层次。', pinyin: 'Zhuōzhèng Yuán yǐ chíshuǐ wéi zhōngxīn, tōngguò huíláng, lòuchuāng yǔ jièjǐng zǔzhī chū fēngfù céngcì.', simpleChinese: '池水、回廊和漏窗让园林更有层次。', vietnamese: 'Chuyết Chính Viên lấy ao nước làm trung tâm, dùng hành lang, cửa hoa và mượn cảnh để tạo nhiều lớp không gian.', english: 'Ponds, corridors, openwork windows, and borrowed scenery create layered depth.'),
  DiscoveryEntry(text: '这些园林集中体现水、山石、植物与建筑之间的关系。', pinyin: 'Zhèxiē yuánlín jízhōng tǐxiàn shuǐ, shānshí, zhíwù yǔ jiànzhù zhījiān de guānxì.', simpleChinese: '园林把水、石、植物和建筑组合在一起。', vietnamese: 'Các khu vườn thể hiện mối quan hệ giữa nước, đá, cây và kiến trúc.', english: 'The gardens unite water, rocks, planting, and architecture.'),
];

/// Founder-locked adaptive package for 《下一处等我》. Every level preserves the
/// four approved causal beats; higher levels add detail without changing them.
JourneyLevelContent suzhouGardenCanonicalLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final story = _suzhouAdaptiveStory(level);
  final annotations = story.length == 1
      ? <ReadingAnnotation>[
          ReadingAnnotation(
            pinyin: _suzhouAnnotations.map((item) => item.pinyin).join(' '),
            vietnamese: _suzhouAnnotations.map((item) => item.vietnamese).join(' '),
            english: _suzhouAnnotations.map((item) => item.english).join(' '),
          ),
        ]
      : <ReadingAnnotation>[
          ReadingAnnotation(
            pinyin: '${_suzhouAnnotations[0].pinyin} ${_suzhouAnnotations[1].pinyin}',
            vietnamese: '${_suzhouAnnotations[0].vietnamese} ${_suzhouAnnotations[1].vietnamese}',
            english: '${_suzhouAnnotations[0].english} ${_suzhouAnnotations[1].english}',
          ),
          ReadingAnnotation(
            pinyin: '${_suzhouAnnotations[2].pinyin} ${_suzhouAnnotations[3].pinyin}',
            vietnamese: '${_suzhouAnnotations[2].vietnamese} ${_suzhouAnnotations[3].vietnamese}',
            english: '${_suzhouAnnotations[2].english} ${_suzhouAnnotations[3].english}',
          ),
        ];
  final searchable = '${story.join()}${_suzhouDiscoveries.map((item) => item.text).join()}';
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(story),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(annotations),
    words: List<WordEntry>.unmodifiable(
      _suzhouWords.where((entry) => searchable.contains(entry.word)),
    ),
    discoveries: List<DiscoveryEntry>.unmodifiable(
      _suzhouDiscoveries.take(level <= 3 ? 1 : level <= 7 ? 2 : 4),
    ),
    wonderQuestion: '陈玉兰第二次看不见程朗时，为什么抬起手却没有喊他的名字？',
    expressQuestion: '请写出“下一处等我”在故事开头和结尾分别是谁对谁说，以及这句话的意思怎样改变。',
  );
}

List<String> _suzhouAdaptiveStory(int level) => switch (level) {
  1 => <String>[
      '下周一，十二岁的程朗要开始自己坐车上学。星期天，外婆陈玉兰带他到拙政园。程朗说：“今天让我走前面吧，我在下一处等你。”长廊转弯后，他第一次消失，外婆立刻把他喊回来。第二次，曲桥和屋角又挡住视线。陈玉兰抬起手，却没有喊，自己走完那几步。水面重新打开时，程朗正在前面等她。她只说：“下一处等我。”程朗继续往前，陈玉兰没有追上去。',
    ],
  2 => <String>[
      '下周一，十二岁的程朗要开始自己坐车去初中。六年来，外婆陈玉兰几乎每天都接他放学。这个星期天，她带他到拙政园，程朗第一次认真说：“今天让我走前面吧，我在下一处等你。”转过长廊，他的背影第一次消失，陈玉兰立刻喊了他的名字。程朗退回来，没有争辩，只把脚步放慢。再往前，曲桥和屋角又截断视线。陈玉兰抬起手，名字已经到了嘴边，却没有喊；她自己走完那几步。水面重新打开时，程朗正在前面回头找她。陈玉兰提了提水壶带：“下一处等我。”程朗转身继续走，她没有追上去。',
    ],
  3 || 4 || 5 => <String>[
      '${_suzhouParagraphs[0]}${_suzhouParagraphs[1]}',
      '${_suzhouParagraphs[2]}${_suzhouParagraphs[3]}',
    ],
  _ => <String>[
      '${_suzhouParagraphs[0]}${_suzhouParagraphs[1]}',
      '${_suzhouParagraphs[2]}${_suzhouParagraphs[3]}${_suzhouLevelEnrichment(level)}',
    ],
};

String _suzhouLevelEnrichment(int level) => switch (level) {
  6 => '陈玉兰走得不快。她知道程朗没有真的离开，只是第一次把两个人之间的几步路交给了等待。',
  7 => '陈玉兰走得不快。六年来，她习惯用追上去确认程朗平安；这一次，她把担心留在自己这边，也把下一处停下回望的责任交给他。风从廊下过去，她听不见他的脚步，却仍按自己的速度一步一步往前走。两个人之间多出的不是距离，而是一小段各自走完的路。',
  8 => '陈玉兰走得不快。六年来，她习惯用追上去确认程朗平安；这一次，她把担心留在自己这边，也把下一处停下回望的责任交给他。拙政园的墙、树与屋角不断收紧视线，池水又在转折后把空间打开。风从廊下过去，她听不见他的脚步，却仍按自己的速度一步一步往前走；程朗也没有借着转弯越走越快，而是守着说好的下一处。两个人之间多出的不是失散，而是一小段各自走完、又重新看见对方的路。',
  9 => '陈玉兰走得不快。六年来，她习惯用追上去确认程朗平安；这一次，她把担心留在自己这边，也把下一处停下回望的责任交给他。拙政园的墙、树与屋角不断收紧视线，池水又在转折后把空间打开。第一次消失时，她用一声呼喊把旧日的关系拉回原位；第二次，她放下手，让看不见成为两个人都要承担的几步。程朗没有把走在前面当成甩开外婆，而是在下一处停住。风从廊下过去，她听不见他的脚步，却仍按自己的速度往前走；程朗也没有借着转弯越走越快，没有催促。两个人之间多出的不是失散，而是一小段各自走完、又重新看见对方的路。',
  10 => '陈玉兰走得不快。六年来，她习惯用追上去确认程朗平安；这一次，她把担心留在自己这边，也把下一处停下回望的责任交给他。拙政园的墙、树、曲桥与屋角不断收紧视线，池水又在转折后把空间打开。第一次消失时，她用一声呼喊把旧日的关系拉回原位；第二次，她抬起手又放下，让看不见成为两个人都要承担的几步。程朗没有把走在前面当成甩开外婆，而是在下一处停住，回头确认她仍沿着同一条路来。“下一处等我”不再只是孩子请求放手，也成了外婆提出的新约定：你可以先走，但要学会等；我会担心，却不再每次都追上去。两个人之间多出的不是失散，而是一小段各自走完、又重新看见对方的路。风从廊下过去，两个人都没有催对方。园路还会继续转弯，陈玉兰没有加快脚步，也没有回头。',
  _ => '',
};

const suzhouGardenMemoryResult =
    '陈玉兰第二次没有喊回程朗，自己走完看不见他的几步；程朗在下一处停下回望。';
const suzhouGardenCulturalPoint =
    '拙政园以池水为中心，长廊、建筑、植物与转折让视线收紧后重新打开，形成层层展开的空间。';
const suzhouGardenMemoryAnchor = '抬起又放下的手，与下一处回望的程朗';
const suzhouGardenCompletionSummary = '下一处等我：两个人都学会在短暂看不见时等对方。';

const _luoyangParagraphs = <String>[
  '傍晚，你沿伊河走到龙门石窟。两岸山崖像一道石门，密集的洞窟和佛龛分布在灰色岩壁上。',
  '从北魏到唐代，工匠在这里持续开凿。不同年代的造像留下服饰、面容和雕刻风格的变化。',
  '走近奉先寺，巨大的主像与两侧造像共同形成庄严空间。石头上的细节，让遥远历史突然有了人的尺度。',
  '龙门石窟不仅是一组宏伟雕像，也是一部刻在山崖上的艺术史。河水向前流，石刻则保存着时代留下的表情。',
];

const _luoyangAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Bàngwǎn, nǐ yán Yī Hé zǒudào Lóngmén Shíkū. Liǎng àn shānyá xiàng yí dào shímén, mìjí de dòngkū hé Fókān fēnbù zài huīsè yánbì shàng.', vietnamese: 'Chiều tối, bạn đi dọc sông Y đến hang đá Long Môn. Vách núi hai bờ như một cánh cổng đá, đầy hang và hốc tượng.', english: 'At dusk, you follow the Yi River to Longmen, where cliffs form a stone gate covered with caves and niches.'),
  ReadingAnnotation(pinyin: 'Cóng Běiwèi dào Tángdài, gōngjiàng zài zhèlǐ chíxù kāizáo. Bùtóng niándài de zàoxiàng liúxià fúshì, miànróng hé diāokè fēnggé de biànhuà.', vietnamese: 'Từ Bắc Ngụy đến thời Đường, nghệ nhân liên tục tạc đá, để lại thay đổi về trang phục, gương mặt và phong cách điêu khắc.', english: 'From the Northern Wei through the Tang, artisans recorded changing dress, faces, and carving styles.'),
  ReadingAnnotation(pinyin: 'Zǒujìn Fèngxiān Sì, jùdà de zhǔxiàng yǔ liǎngcè zàoxiàng gòngtóng xíngchéng zhuāngyán kōngjiān. Shítou shàng de xìjié, ràng yáoyuǎn lìshǐ tūrán yǒule rén de chǐdù.', vietnamese: 'Đến gần Phụng Tiên Tự, tượng chính lớn cùng các tượng hai bên tạo nên không gian trang nghiêm. Chi tiết trên đá khiến lịch sử xa xôi trở nên gần với con người.', english: 'At Fengxian Temple, monumental figures create a solemn space whose details bring distant history to human scale.'),
  ReadingAnnotation(pinyin: 'Lóngmén Shíkū bùjǐn shì yì zǔ hóngwěi diāoxiàng, yě shì yí bù kè zài shānyá shàng de yìshùshǐ. Héshuǐ xiàng qián liú, shíkè zé bǎocúnzhe shídài liúxià de biǎoqíng.', vietnamese: 'Long Môn không chỉ là nhóm tượng hùng vĩ mà còn là lịch sử nghệ thuật khắc trên vách núi. Dòng sông trôi đi, còn đá giữ lại nét mặt của thời đại.', english: 'Longmen is art history carved into a cliff: the river moves on while stone preserves the faces of an era.'),
];

const _luoyangWords = <WordEntry>[
  WordEntry(word: '石窟', pinyin: 'shíkū', partOfSpeech: '名词', simpleChinese: '在岩石山体中开凿的洞窟。', translation: 'Hang được đục trong vách đá.', englishDefinition: 'rock-cut grotto', symbol: '🪨'),
  WordEntry(word: '佛龛', pinyin: 'Fókān', partOfSpeech: '名词', simpleChinese: '安放佛像的小空间。', translation: 'Hốc nhỏ đặt tượng Phật.', englishDefinition: 'Buddhist niche', symbol: '🕯️'),
  WordEntry(word: '开凿', pinyin: 'kāizáo', partOfSpeech: '动词', simpleChinese: '在石头上挖掘和雕刻。', translation: 'Đào và tạc vào đá.', englishDefinition: 'to excavate and carve', symbol: '⛏️'),
  WordEntry(word: '造像', pinyin: 'zàoxiàng', partOfSpeech: '名词', simpleChinese: '宗教或纪念用途的雕像。', translation: 'Tượng dùng cho tôn giáo hoặc tưởng niệm.', englishDefinition: 'religious sculpted image', symbol: '🗿'),
  WordEntry(word: '庄严', pinyin: 'zhuāngyán', partOfSpeech: '形容词', simpleChinese: '严肃而令人尊敬。', translation: 'Trang nghiêm và đáng kính.', englishDefinition: 'solemn and dignified', symbol: '✨'),
  WordEntry(word: '山崖', pinyin: 'shānyá', partOfSpeech: '名词', simpleChinese: '陡峭的山壁。', translation: 'Vách núi dựng đứng.', englishDefinition: 'cliff face', symbol: '⛰️'),
  WordEntry(word: '岩壁', pinyin: 'yánbì', partOfSpeech: '名词', simpleChinese: '由岩石形成的陡壁。', translation: 'Vách đá.', englishDefinition: 'rock wall', symbol: '🪨'),
  WordEntry(word: '细节', pinyin: 'xìjié', partOfSpeech: '名词', simpleChinese: '事物中细小而重要的部分。', translation: 'Chi tiết nhỏ nhưng quan trọng.', englishDefinition: 'detail', symbol: '🔍'),
  WordEntry(word: '雕刻', pinyin: 'diāokè', partOfSpeech: '动词', simpleChinese: '在材料上刻出形象或图案。', translation: 'Điêu khắc hình hoặc hoa văn.', englishDefinition: 'to carve or sculpt', symbol: '🔨'),
];

const _luoyangDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '龙门石窟集中保存北魏晚期至唐代的重要佛教石刻艺术。', pinyin: 'Lóngmén Shíkū jízhōng bǎocún Běiwèi wǎnqī zhì Tángdài de zhòngyào Fójiào shíkè yìshù.', simpleChinese: '这里保存了北魏到唐代的重要石刻。', vietnamese: 'Long Môn bảo tồn nghệ thuật khắc đá Phật giáo quan trọng từ cuối Bắc Ngụy đến thời Đường.', english: 'Longmen preserves major Buddhist stone art from the late Northern Wei through the Tang.'),
  DiscoveryEntry(text: '洞窟与佛龛沿伊河两岸的石灰岩山崖分布。', pinyin: 'Dòngkū yǔ Fókān yán Yī Hé liǎng àn de shíhuīyán shānyá fēnbù.', simpleChinese: '许多洞窟分布在伊河边的山崖上。', vietnamese: 'Các hang và hốc tượng phân bố trên vách đá vôi dọc hai bờ sông Y.', english: 'Caves and niches line limestone cliffs beside the Yi River.'),
  DiscoveryEntry(text: '奉先寺的大型造像群以规模、布局和细节形成完整的视觉中心。', pinyin: 'Fèngxiān Sì de dàxíng zàoxiàng qún yǐ guīmó, bùjú hé xìjié xíngchéng wánzhěng de shìjué zhōngxīn.', simpleChinese: '奉先寺的大型造像构成视觉中心。', vietnamese: 'Quần thể tượng lớn ở Phụng Tiên Tự tạo thành một trung tâm thị giác hoàn chỉnh nhờ quy mô, bố cục và chi tiết.', english: 'The monumental figures at Fengxian Temple form a coherent visual focus through scale, arrangement, and detail.'),
  DiscoveryEntry(text: '龙门造像体现了中国石刻艺术在不同历史阶段的发展。', pinyin: 'Lóngmén zàoxiàng tǐxiàn le Zhōngguó shíkè yìshù zài bùtóng lìshǐ jiēduàn de fāzhǎn.', simpleChinese: '不同造像展示了艺术风格的变化。', vietnamese: 'Các tượng Long Môn cho thấy sự phát triển của nghệ thuật điêu khắc đá Trung Hoa.', english: 'The sculptures show the development of Chinese stone carving across periods.'),
];

const _quanzhouParagraphs = <String>[
  '上午，你走进泉州开元寺。东西两座石塔越过树梢，安静地标记着这座古代港口城市的天际线。',
  '宋元时期，泉州与遥远海域保持贸易往来。商人、旅行者和不同信仰的人在这里相遇，留下多元的城市遗产。',
  '开元寺的石塔、殿宇和古树属于这张交流网络的一部分。建筑细节既有地方传统，也见证海上交通带来的文化碰撞。',
  '离开寺院时，你会发现泉州的世界性并不只存在于港口。它藏在石塔、街巷和人们长期共同生活的痕迹里。',
];

const _quanzhouAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Shàngwǔ, nǐ zǒujìn Quánzhōu Kāiyuán Sì. Dōngxī liǎng zuò shítǎ yuèguò shùshāo, ānjìng de biāojìzhe zhè zuò gǔdài gǎngkǒu chéngshì de tiānjìxiàn.', vietnamese: 'Buổi sáng, bạn bước vào chùa Khai Nguyên ở Tuyền Châu. Hai tháp đá đông tây vượt trên ngọn cây, đánh dấu đường chân trời của thành phố cảng cổ.', english: 'In the morning, you enter Kaiyuan Temple. Its east and west stone pagodas mark the skyline of the ancient port city.'),
  ReadingAnnotation(pinyin: 'Sòng Yuán shíqī, Quánzhōu yǔ yáoyuǎn hǎiyù bǎochí màoyì wǎnglái. Shāngrén, lǚxíngzhě hé bùtóng xìnyǎng de rén zài zhèlǐ xiāngyù, liúxià duōyuán de chéngshì yíchǎn.', vietnamese: 'Thời Tống Nguyên, Tuyền Châu giao thương với những vùng biển xa. Thương nhân, lữ khách và người thuộc nhiều tín ngưỡng gặp nhau, để lại di sản đô thị đa dạng.', english: 'During the Song and Yuan periods, merchants, travellers, and many faiths met in Quanzhou’s far-reaching trade network.'),
  ReadingAnnotation(pinyin: 'Kāiyuán Sì de shítǎ, diànyǔ hé gǔshù shǔyú zhè zhāng jiāoliú wǎngluò de yí bùfen. Jiànzhù xìjié jì yǒu dìfāng chuántǒng, yě jiànzhèng hǎishàng jiāotōng dàilái de wénhuà pèngzhuàng.', vietnamese: 'Tháp đá, điện thờ và cây cổ trong chùa là một phần của mạng lưới giao lưu ấy, vừa mang truyền thống địa phương vừa chứng kiến tiếp xúc văn hóa đường biển.', english: 'The temple’s pagodas, halls, and old trees belong to that network, joining local tradition with maritime exchange.'),
  ReadingAnnotation(pinyin: 'Líkāi sìyuàn shí, nǐ huì fāxiàn Quánzhōu de shìjièxìng bìng bù zhǐ cúnzài yú gǎngkǒu. Tā cáng zài shítǎ, jiēxiàng hé rénmen chángqī gòngtóng shēnghuó de hénjì lǐ.', vietnamese: 'Khi rời chùa, bạn nhận ra tính quốc tế của Tuyền Châu không chỉ ở cảng mà còn trong tháp đá, phố ngõ và dấu vết chung sống lâu dài.', english: 'Quanzhou’s global character survives not only at the port, but in pagodas, lanes, and traces of shared life.'),
];

const _quanzhouWords = <WordEntry>[
  WordEntry(word: '石塔', pinyin: 'shítǎ', partOfSpeech: '名词', simpleChinese: '用石材建成的塔。', translation: 'Tháp xây bằng đá.', englishDefinition: 'stone pagoda', symbol: '🗼'),
  WordEntry(word: '港口', pinyin: 'gǎngkǒu', partOfSpeech: '名词', simpleChinese: '船只停靠和装卸货物的地方。', translation: 'Cảng cho tàu thuyền và hàng hóa.', englishDefinition: 'seaport', symbol: '⚓'),
  WordEntry(word: '贸易', pinyin: 'màoyì', partOfSpeech: '名词', simpleChinese: '商品与服务的交换活动。', translation: 'Hoạt động trao đổi hàng hóa và dịch vụ.', englishDefinition: 'trade', symbol: '⛵'),
  WordEntry(word: '信仰', pinyin: 'xìnyǎng', partOfSpeech: '名词', simpleChinese: '人所相信并尊重的宗教或思想。', translation: 'Tín ngưỡng hoặc niềm tin.', englishDefinition: 'faith or belief', symbol: '🕊️'),
  WordEntry(word: '多元', pinyin: 'duōyuán', partOfSpeech: '形容词', simpleChinese: '由多种不同部分组成。', translation: 'Đa dạng, gồm nhiều thành phần.', englishDefinition: 'diverse and plural', symbol: '🌍'),
  WordEntry(word: '殿宇', pinyin: 'diànyǔ', partOfSpeech: '名词', simpleChinese: '寺院或宫殿中的建筑。', translation: 'Điện thờ hoặc công trình trong đền chùa.', englishDefinition: 'temple halls', symbol: '🏛️'),
  WordEntry(word: '古树', pinyin: 'gǔshù', partOfSpeech: '名词', simpleChinese: '生长了很多年的老树。', translation: 'Cây cổ thụ.', englishDefinition: 'ancient tree', symbol: '🌳'),
  WordEntry(word: '街巷', pinyin: 'jiēxiàng', partOfSpeech: '名词', simpleChinese: '城市里的街道和小巷。', translation: 'Đường phố và ngõ nhỏ.', englishDefinition: 'streets and lanes', symbol: '🏘️'),
  WordEntry(word: '海上交通', pinyin: 'hǎishàng jiāotōng', partOfSpeech: '名词', simpleChinese: '通过海洋进行的运输与往来。', translation: 'Giao thông và đi lại trên biển.', englishDefinition: 'maritime transport', symbol: '🚢'),
];

const _quanzhouDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '泉州在宋元时期是连接中国内陆与海外市场的重要海洋商贸中心。', pinyin: 'Quánzhōu zài Sòng Yuán shíqī shì liánjiē Zhōngguó nèilù yǔ hǎiwài shìchǎng de zhòngyào hǎiyáng shāngmào zhōngxīn.', simpleChinese: '宋元时期，泉州是重要的国际港口。', vietnamese: 'Thời Tống Nguyên, Tuyền Châu là trung tâm thương mại biển nối nội địa Trung Quốc với thị trường hải ngoại.', english: 'In the Song-Yuan period, Quanzhou linked China’s interior with overseas markets.'),
  DiscoveryEntry(text: '世界遗产由二十二处代表行政、交通、生产、贸易与多元文化的遗产点组成。', pinyin: 'Shìjiè Yíchǎn yóu èrshíèr chù dàibiǎo xíngzhèng, jiāotōng, shēngchǎn, màoyì yǔ duōyuán wénhuà de yíchǎndiǎn zǔchéng.', simpleChinese: '二十二处遗产点共同讲述港口城市的运作。', vietnamese: 'Di sản gồm 22 địa điểm đại diện cho quản lý, giao thông, sản xuất, thương mại và văn hóa đa dạng.', english: 'Twenty-two component sites explain the port’s administration, transport, production, trade, and diversity.'),
  DiscoveryEntry(text: '开元寺的殿宇、古树与双塔共同保存了古城街巷中的历史层次。', pinyin: 'Kāiyuán Sì de diànyǔ, gǔshù yǔ shuāngtǎ gòngtóng bǎocún le gǔchéng jiēxiàng zhōng de lìshǐ céngcì.', simpleChinese: '殿宇、古树和双塔保留了古城历史。', vietnamese: 'Điện thờ, cây cổ và tháp đôi của Khai Nguyên Tự cùng lưu giữ những lớp lịch sử trong phố cổ.', english: 'Temple halls, old trees, and twin pagodas preserve layers of history in the old city.'),
  DiscoveryEntry(text: '开元寺及其东西塔是泉州系列世界遗产的重要组成部分。', pinyin: 'Kāiyuán Sì jí qí Dōngxī Tǎ shì Quánzhōu xìliè Shìjiè Yíchǎn de zhòngyào zǔchéng bùfen.', simpleChinese: '开元寺和双塔属于泉州世界遗产。', vietnamese: 'Chùa Khai Nguyên và hai tháp đông tây là thành phần quan trọng của Di sản Thế giới Tuyền Châu.', english: 'Kaiyuan Temple and its twin pagodas are important components of the serial World Heritage property.'),
];

final suzhouGardenJourney = _journeyRecord(
  id: 'suzhou-humble-administrators-garden',
  title: '苏州 · 拙政园：下一处等我',
  geoNodeId: 'cn-jiangsu-suzhou-gusu-humble-administrators-garden',
  tags: const ['苏州', '拙政园', '古典园林', '借景', '世界遗产'],
  paragraphs: _suzhouParagraphs,
  sourceIds: const ['unesco-suzhou-classical-gardens', 'suzhou-garden-bureau-humble-administrators-garden'],
);

final luoyangLongmenJourney = _journeyRecord(
  id: 'luoyang-longmen-grottoes',
  title: '洛阳 · 龙门石窟：读一部刻在山崖上的艺术史',
  geoNodeId: 'cn-henan-luoyang-luolong-longmen-grottoes',
  tags: const ['洛阳', '龙门石窟', '北魏', '唐代', '石刻艺术'],
  paragraphs: _luoyangParagraphs,
  sourceIds: const ['unesco-luoyang-longmen-grottoes', 'ncha-luoyang-longmen-grottoes'],
);

final quanzhouKaiyuanJourney = _journeyRecord(
  id: 'quanzhou-kaiyuan-temple',
  title: '泉州 · 开元寺：从双塔读懂海洋商贸之城',
  geoNodeId: 'cn-fujian-quanzhou-licheng-kaiyuan-temple',
  tags: const ['泉州', '开元寺', '海上丝绸之路', '宋元', '世界遗产'],
  paragraphs: _quanzhouParagraphs,
  sourceIds: const ['unesco-quanzhou-emporium', 'quanzhou-government-kaiyuan-temple'],
);

final journeyExpansionRecords = <JourneyContentRecord>[
  suzhouGardenJourney,
  luoyangLongmenJourney,
  quanzhouKaiyuanJourney,
];

final journeyExpansionExperiences = <DailyJourneyExperience>[
  DailyJourneyExperience(
    id: suzhouGardenJourney.id,
    city: '苏州',
    cityCode: 'SZV',
    place: '拙政园',
    appBarTitle: '苏州 · 拙政园',
    storyTitle: '下一处等我',
    headline: '下一处等我',
    description: '外婆第一次让十二岁的外孙走在前面，在拙政园一次次消失又重现的视线里学着不再把他喊回来。',
    discoveryTeaser: '长廊、建筑转折与池水开合怎样让园中视线时而隐藏、时而重新出现？',
    distanceLabel: '1,820 km',
    stampSymbol: '园',
    content: suzhouGardenJourney,
    storyAnnotations: _suzhouAnnotations,
    words: _suzhouWords,
    discoveries: _suzhouDiscoveries,
    wonderQuestion: '如果你是陈玉兰，第二次看不见程朗时，你会喊他回来吗？为什么？',
    expressQuestion: '请用两到三句话写出陈玉兰抬起手却没有喊名字的那个瞬间。',
  ),
  DailyJourneyExperience(
    id: luoyangLongmenJourney.id,
    city: '洛阳',
    cityCode: 'LYA',
    place: '龙门石窟',
    appBarTitle: '洛阳 · 龙门石窟',
    storyTitle: '山崖石刻故事',
    headline: '读一部刻在山崖上的艺术史',
    description: '沿伊河观察洞窟、造像与跨越多个时代的雕刻风格。',
    discoveryTeaser: '为什么同一面山崖能看见不同朝代的艺术？',
    distanceLabel: '1,470 km',
    stampSymbol: '石',
    content: luoyangLongmenJourney,
    storyAnnotations: _luoyangAnnotations,
    words: _luoyangWords,
    discoveries: _luoyangDiscoveries,
    wonderQuestion: '面对龙门石窟，你最想先观察整体规模还是一尊造像的细节？为什么？',
    expressQuestion: '请用两到三句话描写石窟、山崖与伊河形成的景象。',
  ),
  DailyJourneyExperience(
    id: quanzhouKaiyuanJourney.id,
    city: '泉州',
    cityCode: 'JJN',
    place: '开元寺',
    appBarTitle: '泉州 · 开元寺',
    storyTitle: '海洋商贸故事',
    headline: '从双塔读懂海洋商贸之城',
    description: '从开元寺双塔出发，寻找宋元泉州连接世界的城市痕迹。',
    discoveryTeaser: '为什么一座寺院能讲述古代国际港口的故事？',
    distanceLabel: '1,250 km',
    stampSymbol: '海',
    content: quanzhouKaiyuanJourney,
    storyAnnotations: _quanzhouAnnotations,
    words: _quanzhouWords,
    discoveries: _quanzhouDiscoveries,
    wonderQuestion: '如果你是宋元时期来到泉州的旅行者，最想在港口寻找哪一种语言或商品？',
    expressQuestion: '请用两到三句话介绍开元寺双塔与泉州港口历史的关系。',
  ),
];
