import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import '../models/story_content.dart';
import 'package:pinyin/pinyin.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'luoyang_longmen_gold.dart';

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
    english: 'When the water opens into view again, Cheng Lang has already stopped ahead and is looking back for her. “Grandma, can I still walk in front?” he asks. Chen Yulan adjusts the water-bottle strap on her shoulder and says, “Wait for me at the next place.” He turns away and soon disappears behind a building again. She does not chase after him.',
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
  WordEntry(word: '外婆', pinyin: 'wàipó', partOfSpeech: '名词', simpleChinese: '母亲的母亲。', translation: 'Bà ngoại.', englishDefinition: 'maternal grandmother', symbol: '👵'),
  WordEntry(word: '自己', pinyin: 'zìjǐ', partOfSpeech: '代词', simpleChinese: '本人，不依靠别人。', translation: 'Tự mình.', englishDefinition: 'oneself; independently', symbol: '🚶'),
  WordEntry(word: '转弯', pinyin: 'zhuǎnwān', partOfSpeech: '动词', simpleChinese: '改变行走方向。', translation: 'Rẽ.', englishDefinition: 'to turn a corner', symbol: '↪️', examples: [WordExample(chinese: '长廊转弯后，程朗暂时从外婆的视线里消失。', pinyin: 'Chángláng zhuǎnwān hòu, Chéng Lǎng zànshí cóng wàipó de shìxiàn lǐ xiāoshī.', vietnamese: 'Sau khúc quanh hành lang, Trình Lãng tạm khuất khỏi tầm mắt bà ngoại.', english: 'After the corridor turns, Cheng Lang temporarily disappears from his grandmother’s sight.')]),
  WordEntry(word: '消失', pinyin: 'xiāoshī', partOfSpeech: '动词', simpleChinese: '从视线里看不见了。', translation: 'Biến mất.', englishDefinition: 'to disappear from view', symbol: '👀'),
  WordEntry(word: '视线', pinyin: 'shìxiàn', partOfSpeech: '名词', simpleChinese: '眼睛看出去的方向和范围。', translation: 'Tầm nhìn.', englishDefinition: 'line of sight', symbol: '👁️'),
  WordEntry(word: '抬起', pinyin: 'táiqǐ', partOfSpeech: '动词', simpleChinese: '把手或物体向上举。', translation: 'Giơ lên.', englishDefinition: 'to raise', symbol: '✋'),
  WordEntry(word: '水面', pinyin: 'shuǐmiàn', partOfSpeech: '名词', simpleChinese: '水最上面的表面。', translation: 'Mặt nước.', englishDefinition: 'water surface', symbol: '🌊'),
  WordEntry(word: '回头', pinyin: 'huítóu', partOfSpeech: '动词', simpleChinese: '转头向后看。', translation: 'Ngoảnh lại.', englishDefinition: 'to look back', symbol: '↩️'),
  WordEntry(word: '追上', pinyin: 'zhuīshàng', partOfSpeech: '动词', simpleChinese: '加快脚步赶到前面的人身边。', translation: 'Đuổi kịp.', englishDefinition: 'to catch up', symbol: '🏃'),
  WordEntry(word: '遮挡', pinyin: 'zhēdǎng', partOfSpeech: '动词', simpleChinese: '挡住，使人暂时看不见。', translation: 'Che khuất.', englishDefinition: 'to block from view', symbol: '🧱'),
  WordEntry(word: '世界遗产', pinyin: 'shìjiè yíchǎn', partOfSpeech: '名词', simpleChinese: '被国际认定具有突出价值的文化或自然遗产。', translation: 'Di sản thế giới.', englishDefinition: 'World Heritage', symbol: '🌏'),
  WordEntry(word: '保护', pinyin: 'bǎohù', partOfSpeech: '动词', simpleChinese: '防止重要事物受到损害。', translation: 'Bảo vệ.', englishDefinition: 'to protect; conservation', symbol: '🛡️'),
];

const _suzhouDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '拙政园以水面为园林空间的重要中心，建筑、植物和道路沿水展开，让游人边走边看见不同景色。', pinyin: 'Zhuōzhèng Yuán yǐ shuǐmiàn wéi yuánlín kōngjiān de zhòngyào zhōngxīn, jiànzhù, zhíwù hé dàolù yán shuǐ zhǎnkāi, ràng yóurén biān zǒu biān kànjiàn bùtóng jǐngsè.', simpleChinese: '拙政园围绕水面安排建筑、植物和道路。', vietnamese: 'Chuyết Chính Viên tổ chức kiến trúc, cây cối và lối đi quanh mặt nước, để cảnh vật thay đổi theo bước chân.', english: 'The Humble Administrator’s Garden organizes buildings, planting, and paths around water so views change as visitors walk.'),
  DiscoveryEntry(text: '亭子提供停留和观景的位置，长廊连接不同建筑与院落；它们与池水一起组织游园路线，而不只是在园中摆放装饰。', pinyin: 'Tíngzi tígōng tíngliú hé guānjǐng de wèizhi, chángláng liánjiē bùtóng jiànzhù yǔ yuànluò; tāmen yǔ chíshuǐ yìqǐ zǔzhī yóuyuán lùxiàn, ér bù zhǐshì zài yuán zhōng bǎifàng zhuāngshì.', simpleChinese: '亭子让人停下看景，长廊把建筑和院落连起来。', vietnamese: 'Đình là nơi dừng lại ngắm cảnh, còn hành lang dài nối các công trình và sân; cùng với mặt nước, chúng tổ chức tuyến tham quan.', english: 'Pavilions provide places to pause and look, while corridors connect buildings and courtyards; together with the water, they organize movement through the garden.'),
  DiscoveryEntry(text: '长廊的转折、建筑的墙面和植物的遮挡会暂时收紧视线，使同一条路被分成看得见与暂时看不见的几段。', pinyin: 'Chángláng de zhuǎnzhé, jiànzhù de qiángmiàn hé zhíwù de zhēdǎng huì zànshí shōujǐn shìxiàn, shǐ tóng yì tiáo lù bèi fēnchéng kàndéjiàn yǔ zànshí kànbujiàn de jǐ duàn.', simpleChinese: '廊、墙和植物会让前面的景物暂时看不见。', vietnamese: 'Các khúc ngoặt của hành lang, tường nhà và cây cối tạm thời thu hẹp tầm nhìn, chia một lối đi thành những đoạn thấy và khuất.', english: 'Turns in corridors, building walls, and planting temporarily narrow sightlines, dividing one path into visible and hidden stretches.'),
  DiscoveryEntry(text: '从较窄的廊道或建筑边转向开阔池面时，视野会重新打开；水面把天空、建筑和植物的倒影带进画面，扩大空间感。', pinyin: 'Cóng jiào zhǎi de lángdào huò jiànzhù biān zhuǎnxiàng kāikuò chímiàn shí, shìyě huì chóngxīn dǎkāi; shuǐmiàn bǎ tiānkōng, jiànzhù hé zhíwù de dàoyǐng dài jìn huàmiàn, kuòdà kōngjiāngǎn.', simpleChinese: '从窄处走到池边，视野会重新变开阔。', vietnamese: 'Khi rời hành lang hẹp hoặc mép công trình để hướng ra mặt ao rộng, tầm nhìn mở lại; phản chiếu của trời, nhà và cây làm không gian có vẻ rộng hơn.', english: 'Moving from a narrow corridor or building edge toward open water releases the view; reflections of sky, buildings, and planting enlarge the sense of space.'),
  DiscoveryEntry(text: '回廊、建筑、植物和水面不是各自孤立的景物。它们通过前后遮挡、远近对照和水中倒影形成层次，让有限空间显得更深。', pinyin: 'Huíláng, jiànzhù, zhíwù hé shuǐmiàn bú shì gèzì gūlì de jǐngwù. Tāmen tōngguò qiánhòu zhēdǎng, yuǎnjìn duìzhào hé shuǐzhōng dàoyǐng xíngchéng céngcì, ràng yǒuxiàn kōngjiān xiǎnde gèng shēn.', simpleChinese: '廊、房屋、植物和水面一起形成前后层次。', vietnamese: 'Hành lang, kiến trúc, cây cối và mặt nước không tách rời; che khuất trước sau, đối chiếu gần xa và phản chiếu tạo chiều sâu trong không gian hữu hạn.', english: 'Corridors, buildings, planting, and water work together: overlap, near–far contrast, and reflection create depth within limited space.'),
  DiscoveryEntry(text: '漏窗既让墙保持分隔，也让人透过镂空图案看见另一侧的局部景物。被窗框选中的景色像一幅画，人的位置改变时，画面也会改变。', pinyin: 'Lòuchuāng jì ràng qiáng bǎochí fēngé, yě ràng rén tòuguò lòukōng tú’àn kànjiàn lìng yí cè de júbù jǐngwù. Bèi chuāngkuàng xuǎnzhòng de jǐngsè xiàng yì fú huà, rén de wèizhi gǎibiàn shí, huàmiàn yě huì gǎibiàn.', simpleChinese: '漏窗把另一边的一部分景色框成一幅会变化的画。', vietnamese: 'Cửa sổ hoa vừa giữ sự phân cách của tường vừa cho thấy một phần cảnh phía bên kia; khung cảnh thay đổi khi người xem đổi vị trí.', english: 'Openwork windows preserve a wall’s separation while framing partial views beyond it; the framed scene changes as the viewer moves.'),
  DiscoveryEntry(text: '借景把园外或较远处的景物纳入眼前构图，使视线越过园墙和近处建筑。它不把远景搬进园内，而是通过观看位置让远近景物发生联系。', pinyin: 'Jièjǐng bǎ yuánwài huò jiào yuǎnchù de jǐngwù nàrù yǎnqián gòutú, shǐ shìxiàn yuèguò yuánqiáng hé jìnchù jiànzhù. Tā bù bǎ yuǎnjǐng bānjìn yuánnèi, ér shì tōngguò guānkàn wèizhi ràng yuǎnjìn jǐngwù fāshēng liánxì.', simpleChinese: '借景利用观看位置，把远处景物放进眼前画面。', vietnamese: 'Mượn cảnh đưa cảnh vật ngoài vườn hoặc ở xa vào bố cục trước mắt; không di chuyển cảnh vật mà dùng vị trí nhìn để nối gần với xa.', english: 'Borrowed scenery brings distant or outside features into the present composition, using viewpoint rather than physically moving the distant scene.'),
  DiscoveryEntry(text: '苏州古典园林把水、山石、植物和建筑作为一个整体来设计：水组织开合，山石形成起伏，植物随季节变化，建筑提供行走、停留和观看的位置。', pinyin: 'Sūzhōu Gǔdiǎn Yuánlín bǎ shuǐ, shānshí, zhíwù hé jiànzhù zuòwéi yí gè zhěngtǐ lái shèjì: shuǐ zǔzhī kāihé, shānshí xíngchéng qǐfú, zhíwù suí jìjié biànhuà, jiànzhù tígōng xíngzǒu, tíngliú hé guānkàn de wèizhi.', simpleChinese: '水、石、植物和建筑各有作用，又共同组成园林。', vietnamese: 'Vườn cổ Tô Châu thiết kế nước, đá, cây và kiến trúc như một chỉnh thể: nước tạo đóng mở, đá tạo cao thấp, cây đổi theo mùa, công trình định vị việc đi, dừng và nhìn.', english: 'Suzhou gardens design water, rocks, planting, and architecture as one system: water shapes opening and enclosure, rocks create relief, plants mark seasons, and buildings position movement, pause, and viewing.'),
  DiscoveryEntry(text: '苏州园林在有限城市用地中，通过曲折路线、遮挡与显现、框景和借景连续改变观看关系，使游园过程像逐步展开的山水画，而不是一次看完的全景。', pinyin: 'Sūzhōu Yuánlín zài yǒuxiàn chéngshì yòngdì zhōng, tōngguò qūzhé lùxiàn, zhēdǎng yǔ xiǎnxiàn, kuàngjǐng hé jièjǐng liánxù gǎibiàn guānkàn guānxì, shǐ yóuyuán guòchéng xiàng zhúbù zhǎnkāi de shānshuǐhuà, ér bú shì yí cì kànwán de quánjǐng.', simpleChinese: '园林用转折、遮挡和借景，让景色边走边展开。', vietnamese: 'Trong khu đất đô thị hữu hạn, tuyến đi quanh co, che–hiện, đóng khung và mượn cảnh liên tục thay đổi cách nhìn, khiến khu vườn mở ra từng bước như tranh sơn thủy.', english: 'Within limited urban land, winding routes, concealment and reveal, framed views, and borrowed scenery continually change what can be seen, unfolding the garden like a landscape painting rather than a single panorama.'),
  DiscoveryEntry(text: '拙政园属于“苏州古典园林”世界遗产。世界遗产价值不仅在单座亭子或一片池水，也在整体空间设计和延续至今的造园传统；保护需要维护水体、山石、植物、建筑及其观看关系。', pinyin: 'Zhuōzhèng Yuán shǔyú “Sūzhōu Gǔdiǎn Yuánlín” Shìjiè Yíchǎn. Shìjiè Yíchǎn jiàzhí bùjǐn zài dān zuò tíngzi huò yí piàn chíshuǐ, yě zài zhěngtǐ kōngjiān shèjì hé yánxù zhìjīn de zàoyuán chuántǒng; bǎohù xūyào wéihù shuǐtǐ, shānshí, zhíwù, jiànzhù jí qí guānkàn guānxì.', simpleChinese: '保护拙政园，要保护水、石、植物、建筑和它们组成的整体空间。', vietnamese: 'Chuyết Chính Viên thuộc Di sản Thế giới “Vườn cổ điển Tô Châu”. Giá trị nằm ở thiết kế tổng thể và truyền thống tạo vườn, nên bảo tồn phải giữ cả nước, đá, cây, kiến trúc và quan hệ nhìn giữa chúng.', english: 'The Humble Administrator’s Garden is part of the Classical Gardens of Suzhou World Heritage property. Its value lies in the complete spatial design and continuing garden tradition, so conservation must sustain water, rocks, planting, buildings, and their viewing relationships.'),
];

/// Founder-locked adaptive package for 《下一处等我》. Every level preserves the
/// four approved causal beats; higher levels add detail without changing them.
JourneyLevelContent suzhouGardenCanonicalLevelContent(
  int requestedLevel, {
  ChineseProficiencyProfile? profile,
  Set<String> knownWords = const <String>{},
}) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final story = _suzhouAdaptiveStory(level);
  final discovery = _suzhouDiscoveries[level - 1];
  final support = _suzhouReadingSupport(level);
  final annotations = <ReadingAnnotation>[
    for (var index = 0; index < story.length; index++)
      ReadingAnnotation(
        pinyin: PinyinHelper.getPinyinE(
          story[index],
          separator: ' ',
          format: PinyinFormat.WITH_TONE_MARK,
        ),
        vietnamese: support[index].$1,
        english: support[index].$2,
      ),
  ];
  final searchable = '${story.join()}${discovery.text}';
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(story),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(annotations),
    words: List<WordEntry>.unmodifiable(
      const PhoenixLanguageLevelAgent().selectVocabulary(
        words: _suzhouWords
            .where((entry) => searchable.contains(entry.word)),
        levelCatalog: _suzhouVocabularyLevelCatalog,
        profile: profile ??
            const PhoenixLanguageLevelAgent().profileForPhoenixLevel(level),
        knownWords: knownWords,
      ),
    ),
    discoveries: <DiscoveryEntry>[discovery],
    wonderQuestion: '陈玉兰第二次看不见程朗时，为什么抬起手却没有喊他的名字？',
    expressQuestion: '请写出“下一处等我”在故事开头和结尾分别是谁对谁说，以及这句话的意思怎样改变。',
  );
}

const _suzhouVocabularyLevelCatalog = <String, VocabularyLevelTag>{
  '园林': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '亭子': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2, kind: VocabularyKind.cultural),
  '漏窗': VocabularyLevelTag(hskLevel: 5, tocflLevel: 4, kind: VocabularyKind.cultural),
  '长廊': VocabularyLevelTag(hskLevel: 4, tocflLevel: 3, kind: VocabularyKind.cultural),
  '借景': VocabularyLevelTag(hskLevel: 6, tocflLevel: 5, kind: VocabularyKind.cultural),
  '池水': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '曲桥': VocabularyLevelTag(hskLevel: 5, tocflLevel: 4, kind: VocabularyKind.cultural),
  '山水画': VocabularyLevelTag(hskLevel: 4, tocflLevel: 3, kind: VocabularyKind.cultural),
  '层次': VocabularyLevelTag(hskLevel: 5, tocflLevel: 4),
  '外婆': VocabularyLevelTag(hskLevel: 2, tocflLevel: 1),
  '自己': VocabularyLevelTag(hskLevel: 1, tocflLevel: 1),
  '转弯': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '消失': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '视线': VocabularyLevelTag(hskLevel: 4, tocflLevel: 3),
  '抬起': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '水面': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '回头': VocabularyLevelTag(hskLevel: 2, tocflLevel: 2),
  '追上': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '遮挡': VocabularyLevelTag(hskLevel: 5, tocflLevel: 4),
  '世界遗产': VocabularyLevelTag(hskLevel: 6, tocflLevel: 5, kind: VocabularyKind.cultural),
  '保护': VocabularyLevelTag(hskLevel: 4, tocflLevel: 3),
};

List<(String, String)> _suzhouReadingSupport(int level) => switch (level) {
  1 => const [(
      'Thứ Hai tới, Trình Lãng mười hai tuổi sẽ bắt đầu tự đi xe đến trường. Chủ nhật, bà ngoại Trần Ngọc Lan đưa cậu đến Chuyết Chính Viên. Trình Lãng nói: “Hôm nay để cháu đi trước. Cháu đợi bà ở chỗ kế tiếp.” Sau khúc quanh hành lang, cậu biến khỏi tầm mắt lần đầu và bà lập tức gọi cậu quay lại. Lần thứ hai, cầu cong và góc nhà lại chắn tầm nhìn. Trần Ngọc Lan giơ tay nhưng không gọi, tự đi hết mấy bước ấy. Khi mặt nước mở ra trở lại, Trình Lãng đang đợi phía trước. Bà chỉ nói: “Đợi bà ở chỗ kế tiếp.” Trình Lãng tiếp tục đi, và bà không đuổi theo.',
      'Next Monday, twelve-year-old Cheng Lang will begin traveling to school by himself. On Sunday, his grandmother Chen Yulan takes him to the Humble Administrator’s Garden. Cheng Lang says, “Let me walk ahead today. I’ll wait for you at the next place.” After the corridor turns, he disappears from view for the first time and she immediately calls him back. The second time, a curved bridge and a building corner block her view again. Chen Yulan raises her hand but does not call; she walks those few steps herself. When the water opens into view again, Cheng Lang is waiting ahead. She only says, “Wait for me at the next place.” Cheng Lang continues forward, and Chen Yulan does not chase after him.'
    )],
  2 => const [(
      'Thứ Hai tới, Trình Lãng mười hai tuổi sẽ bắt đầu tự đi xe đến trường cấp hai. Sáu năm qua, bà ngoại Trần Ngọc Lan hầu như ngày nào cũng đón cậu tan học. Chủ nhật này bà đưa cậu đến Chuyết Chính Viên, và cậu lần đầu nghiêm túc nói: “Hôm nay để cháu đi trước. Cháu đợi bà ở chỗ kế tiếp.” Sau khúc quanh hành lang, bóng lưng cậu biến mất lần đầu; bà lập tức gọi tên. Trình Lãng quay lại, không tranh cãi, chỉ đi chậm hơn. Phía trước, cầu cong và góc nhà lại cắt đứt tầm nhìn. Bà giơ tay, tên cậu đã ở đầu môi nhưng bà không gọi; bà tự đi hết mấy bước. Khi mặt nước mở ra, Trình Lãng đang ngoái lại tìm bà. Bà chỉnh dây bình nước: “Đợi bà ở chỗ kế tiếp.” Cậu quay đi tiếp; bà không đuổi theo.',
      'Next Monday, twelve-year-old Cheng Lang will begin traveling to middle school alone. For six years, his grandmother Chen Yulan has met him after school almost every day. This Sunday she takes him to the Humble Administrator’s Garden, where for the first time he says seriously, “Let me walk ahead today. I’ll wait for you at the next place.” After the corridor turns, his back disappears for the first time and she immediately calls his name. Cheng Lang comes back without arguing and merely slows down. Farther on, a curved bridge and building corner cut off her view again. Chen Yulan raises her hand, his name already at her lips, but does not call; she walks those few steps herself. When the water opens again, Cheng Lang is looking back for her. She adjusts her water-bottle strap: “Wait for me at the next place.” He turns and continues; she does not chase him.'
    )],
  3 || 4 || 5 => [
      ('${_suzhouAnnotations[0].vietnamese} ${_suzhouAnnotations[1].vietnamese}', '${_suzhouAnnotations[0].english} ${_suzhouAnnotations[1].english}'),
      ('${_suzhouAnnotations[2].vietnamese} ${_suzhouAnnotations[3].vietnamese}', '${_suzhouAnnotations[2].english} ${_suzhouAnnotations[3].english}'),
    ],
  _ => <(String, String)>[
      (
        '${_suzhouAnnotations[0].vietnamese} ${_suzhouAnnotations[1].vietnamese} ${_suzhouFirstRestatementSupport(level).$1}${level >= 8 ? ' Thứ Hai tới, Trình Lãng sẽ tự đi xe.' : ''}',
        '${_suzhouAnnotations[0].english} ${_suzhouAnnotations[1].english} ${_suzhouFirstRestatementSupport(level).$2}${level >= 8 ? ' Next Monday, Cheng Lang will travel by himself.' : ''}',
      ),
      (
        '${_suzhouAnnotations[2].vietnamese} ${_suzhouSecondRestatementSupport(level).$1} ${_suzhouAnnotations[3].vietnamese}',
        '${_suzhouAnnotations[2].english} ${_suzhouSecondRestatementSupport(level).$2} ${_suzhouAnnotations[3].english}',
      ),
    ],
};

(String, String) _suzhouFirstRestatementSupport(int level) => switch (level) {
  6 => ('Trước khúc quanh đầu, Trình Lãng đi phía trước; sau khúc quanh, cậu quay lại theo tiếng gọi của bà. Trần Ngọc Lan nhìn cậu và chỉ nói: “Đừng đi nhanh quá.”', 'Before the first turn, Cheng Lang walks ahead; after it, he comes back when his grandmother calls. Chen Yulan looks at him and only says, “Don’t walk too fast.”'),
  7 => ('Trước khúc quanh đầu, Trình Lãng đi phía trước; sau khúc quanh, cậu quay lại theo tiếng gọi, chỉ giảm tốc độ. Trần Ngọc Lan nhìn cậu và nói: “Đừng đi nhanh quá.”', 'Before the first turn, Cheng Lang walks ahead; after it, he returns when called and merely slows down. Chen Yulan looks at him and says, “Don’t walk too fast.”'),
  8 => ('Trước khúc quanh đầu, Trình Lãng đi phía trước; sau đó cậu quay lại theo tiếng gọi, không tranh cãi, chỉ đi chậm hơn. Trần Ngọc Lan nói: “Đừng đi nhanh quá.” Hành lang, đình, tường trắng và bóng cây chia cùng một con đường thành những đoạn nhìn thấy và tạm thời không nhìn thấy.', 'Before the first turn, Cheng Lang walks ahead; afterward he comes back when called, does not argue, and merely slows down. Chen Yulan says, “Don’t walk too fast.” Corridors, pavilions, white walls, and tree shadows divide the same path into visible and temporarily hidden stretches.'),
  9 => ('Trước khúc quanh đầu, Trình Lãng đi phía trước; sau đó cậu quay lại theo tiếng gọi, không tranh cãi, chỉ đi chậm hơn. Trần Ngọc Lan nói: “Đừng đi nhanh quá.” Hành lang, đình, tường trắng và bóng cây chia con đường thành những đoạn thấy và khuất. Việc thứ Hai cậu tự đi xe, sáu năm bà đón tan học, và hôm nay lần đầu cậu xin đi trước đều là những điều hai người đã nói.', 'Before the first turn, Cheng Lang walks ahead; afterward he returns when called, does not argue, and merely slows down. Chen Yulan says, “Don’t walk too fast.” Corridors, pavilions, white walls, and tree shadows divide the path into visible and hidden stretches. His traveling alone on Monday, her six years of meeting him after school, and his first request to walk ahead today are all facts the two have spoken aloud.'),
  10 => ('Trước khúc quanh đầu, Trình Lãng đi phía trước; sau đó cậu quay lại theo tiếng gọi, không tranh cãi, chỉ đi chậm hơn. Trần Ngọc Lan nói: “Đừng đi nhanh quá.” Hành lang, đình, tường trắng và bóng cây chia con đường thành những đoạn thấy và khuất. Thứ Hai cậu tự đi xe, sáu năm bà đón tan học, và hôm nay lần đầu cậu xin đi trước đều đã được nói ra. Trình Lãng nói “cháu đợi bà ở chỗ kế tiếp”; phản ứng đầu tiên của bà là gọi tên, nên cậu quay lại khỏi khúc quanh.', 'Before the first turn, Cheng Lang walks ahead; afterward he returns when called, does not argue, and merely slows down. Chen Yulan says, “Don’t walk too fast.” Corridors, pavilions, white walls, and tree shadows divide the path into visible and hidden stretches. His traveling alone on Monday, her six years of meeting him after school, and his first request to walk ahead today have all been stated. Cheng Lang says, “I’ll wait for you at the next place”; her first response is to call his name, so he comes back from the turn.'),
  _ => ('', ''),
};

(String, String) _suzhouSecondRestatementSupport(int level) => switch (level) {
  6 => ('', ''),
  7 => ('Lần thứ hai, Trần Ngọc Lan vẫn đứng trên đoạn đường bị cầu cong và góc nhà chắn tầm nhìn. Bà giơ tay, tên cậu đã ở đầu môi nhưng cuối cùng không gọi, rồi hạ tay xuống. Trình Lãng đang ngoái lại tìm bà.', 'The second time, Chen Yulan still stands where the curved bridge and building corner block her view. She raises her hand, his name at her lips, but ultimately does not call, then lowers her hand. Cheng Lang is looking back for her.'),
  8 => ('Lần thứ hai, cầu cong và góc nhà lại che Trình Lãng, tiếng người dưới hành lang lấn cả tiếng chân. Trần Ngọc Lan giơ tay, tên cậu đã ở đầu môi nhưng không gọi; bà tự đi hết mấy bước rồi hạ tay. Trình Lãng đang ngoái lại tìm bà.', 'The second time, the curved bridge and building corner hide Cheng Lang again, while voices under the corridor cover his footsteps. Chen Yulan raises her hand, his name at her lips, but does not call; she walks those steps alone and lowers her hand. Cheng Lang is looking back for her.'),
  9 => ('Lần thứ hai, cầu cong và góc nhà lại che Trình Lãng, tiếng người lấn tiếng chân. Trần Ngọc Lan giơ tay nhưng không gọi; bà hạ tay và tự đi hết mấy bước. Khi mặt nước mở ra, Trình Lãng đã dừng và ngoái lại tìm bà.', 'The second time, the curved bridge and building corner hide Cheng Lang again, and voices cover his footsteps. Chen Yulan raises her hand but does not call; she lowers it and walks those steps alone. When the water opens into view, Cheng Lang has stopped and is looking back for her.'),
  10 => ('Lần thứ hai, cầu cong và góc nhà lại che Trình Lãng, tiếng người lấn tiếng chân. Trần Ngọc Lan giơ tay nhưng không gọi; bà hạ tay và tự đi hết mấy bước. Khi mặt nước mở ra, Trình Lãng đã dừng và ngoái lại. Cậu hỏi mình còn được đi trước không; bà chỉnh dây bình nước và đáp: “Đợi bà ở chỗ kế tiếp.”', 'The second time, the curved bridge and building corner hide Cheng Lang again, and voices cover his footsteps. Chen Yulan raises her hand but does not call; she lowers it and walks those steps alone. When the water opens into view, Cheng Lang has stopped and is looking back. He asks whether he may still walk ahead; she adjusts her water-bottle strap and answers, “Wait for me at the next place.”'),
  _ => ('', ''),
};

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
      '${_suzhouParagraphs[0]}${_suzhouParagraphs[1]}${_suzhouLockedRestatement(level).$1}${level >= 8 ? '下周一，程朗要自己坐车。' : ''}',
      '${_suzhouParagraphs[2]}${_suzhouLockedRestatement(level).$2}${_suzhouParagraphs[3]}',
    ],
};

/// Higher levels may restate only facts already present in the four Founder-
/// approved paragraphs. They never append an event after the locked ending.
(String, String) _suzhouLockedRestatement(int level) => switch (level) {
  6 => ('第一次转角前，程朗走在前面；转角后，他按外婆的喊声退回来。陈玉兰看了他一眼，只说：“别走太快。”', ''),
  7 => ('第一次转角前，程朗走在前面；转角后，他按外婆的喊声退回来，只把速度放慢。陈玉兰看了他一眼，只说：“别走太快。”', '第二次，陈玉兰仍站在被曲桥和屋角挡住视线的路上；她抬起手，名字到了嘴边，最后没有喊。她把手放下来。程朗正回头找她。'),
  8 => ('第一次转角前，程朗走在前面；转角后，他按外婆的喊声退回来，没有争辩，只把速度放慢。陈玉兰看了他一眼，只说：“别走太快。”长廊、亭子、白墙和树影把同一条路分成看得见与暂时看不见的几段。', '第二次，曲桥和屋角再次挡住程朗，廊下人声又盖住脚步声。陈玉兰抬起手，名字到了嘴边，最后没有喊；她独自走完那几步。她把手放下来。程朗正回头找她。'),
  9 => ('第一次转角前，程朗走在前面；转角后，他按外婆的喊声退回来，没有争辩，只把速度放慢。陈玉兰看了他一眼，只说：“别走太快。”长廊、亭子、白墙和树影把同一条路分成看得见与暂时看不见的几段。下周一自己坐车、六年来外婆接他放学，以及今天第一次要求走在前面，都是两人此时已经说出的事实。', '第二次，曲桥和屋角再次挡住程朗，廊下人声又盖住脚步声。陈玉兰抬起手，名字到了嘴边，最后没有喊；她放下手，独自走完那几步。水面重新打开后，程朗已经停下并回头找她。她把手放下来。程朗正回头找她。'),
  10 => ('第一次转角前，程朗走在前面；转角后，他按外婆的喊声退回来，没有争辩，只把速度放慢。陈玉兰看了他一眼，只说：“别走太快。”长廊、亭子、白墙和树影把同一条路分成看得见与暂时看不见的几段。下周一自己坐车、六年来外婆接他放学，以及今天第一次要求走在前面，都是两人此时已经说出的事实。程朗说的是“我在下一处等你”，陈玉兰第一次回应的是喊他的名字；程朗因此从转角退回。', '第二次，曲桥和屋角再次挡住程朗，廊下人声又盖住脚步声。陈玉兰抬起手，名字到了嘴边，最后没有喊；她放下手，独自走完那几步。水面重新打开后，程朗已经停下并回头找她。他问自己还能不能走在前面，陈玉兰提了提肩上的水壶带，回答“下一处等我”。她把手放下来。程朗正回头找她。'),
  _ => ('', ''),
};

const suzhouGardenMemoryResult =
    '陈玉兰第二次没有喊回程朗，自己走完看不见他的几步；程朗在下一处停下回望。';
const suzhouGardenCulturalPoint =
    '拙政园以池水为中心，长廊、建筑、植物与转折让视线收紧后重新打开，形成层层展开的空间。';
const suzhouGardenMemoryAnchor = '抬起又放下的手，与下一处回望的程朗';
const suzhouGardenCompletionSummary = '下一处等我：两个人都学会在短暂看不见时等对方。';

const _luoyangParagraphs = longmenGoldPublicationParagraphs;
final _luoyangAnnotations = longmenGoldPublicationAnnotations;
const _luoyangWords = longmenGoldWords;
final _luoyangDiscoveries = longmenGoldPublicationDiscoveries;

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
  title: '洛阳 · 龙门石窟：签字页',
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
    storyTitle: luoyangLongmenGoldStoryTitle,
    headline: luoyangLongmenGoldHeadline,
    description: luoyangLongmenGoldDescription,
    discoveryTeaser: luoyangLongmenGoldDiscoveryTeaser,
    distanceLabel: '1,470 km',
    stampSymbol: '石',
    content: luoyangLongmenJourney,
    storyAnnotations: _luoyangAnnotations,
    words: _luoyangWords,
    discoveries: _luoyangDiscoveries,
    wonderQuestion: luoyangLongmenGoldWonderQuestion,
    expressQuestion: luoyangLongmenGoldExpressQuestion,
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
