import 'batch_one_journey_remediation.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const guangzhouChenClanJourneyId = 'guangzhou-chen-clan-academy';
const guangzhouChenClanSourceRecordId = 'guangzhou-gov-chen-clan-academy';
const guangzhouChenClanCanonicalTitle = '纸桥';
const guangzhouChenClanMemoryAnchor = '纸桥';
const guangzhouChenClanLegacyOpening = '走进广州陈家祠';
const guangzhouChenClanLegacyMetaphor = '立体图书';

class GuangzhouDiscoverySpec {
  const GuangzhouDiscoverySpec({
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

class GuangzhouChallengeSpec {
  const GuangzhouChallengeSpec({
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

ReadingAnnotation _annotation(int paragraphIndex, int paragraphCount) {
  if (paragraphCount == 1) {
    return const ReadingAnnotation(
      pinyin:
          'Èrshí’èr suì de Liáng Yáo hé táoyì tóngxué Hè Zhēn zài Guǎngzhōu Chénjiācí guānchá zhuāngshì. Dì yī jiàn zhǐ yuánxíng yīnwèi zhàobān biǎomiàn xiàn tiáo ér duànkāi. Liáng Yáo gǎixiě liánjiē, liúxià zhǐqiáo. Dì èr jiàn tíqǐ hòu réng shì yí gè zhěngtǐ, Hè Zhēn yě rènchū zhǔyào guānxì. Huídào gōngzuòshì, tā bǎ zhège fāngfǎ yòng dào xīn cáiliào.',
      vietnamese:
          'Lương Dao, 22 tuổi, cùng bạn học gốm Hạ Chân quan sát trang trí tại Trần Gia Từ. Mẫu giấy đầu tiên bị rời thành nhiều phần vì sao chép đường nét bề mặt. Cô đổi cách kết nối bằng các cầu giấy. Mẫu thứ hai khi nhấc lên vẫn liền và Hạ Chân vẫn nhận ra quan hệ chính. Về xưởng, cô áp dụng phương pháp ấy cho vật liệu mới.',
      english:
          'Twenty-two-year-old printmaking student Liang Yao and ceramics-student peer He Zhen observe decoration at the Chen Clan Academy. Her first literal-contour paper prototype breaks apart. She changes the connection logic by leaving paper bridges. The second prototype lifts intact and He Zhen still recognizes the important relation. Back in the studio she applies the method to a new material.',
    );
  }
  if (paragraphIndex == 0) {
    return const ReadingAnnotation(
      pinyin:
          'Èrshí’èr suì de Liáng Yáo hé táoyì tóngxué Hè Zhēn zài Guǎngzhōu Chénjiācí guānchá zhuāngshì, zhǐ zài zìjǐ de cáiliào shàng shìzuò. Dì yī jiàn zhǐ yuánxíng yīnwèi zhàobān kànjiàn de lúnkuò ér duànkāi. Zhǐ de cáiliào yuēshù bǎ biǎomiàn fùzhì biànchéng jiégòu wèntí.',
      vietnamese:
          'Lương Dao, 22 tuổi, cùng bạn học gốm Hạ Chân quan sát trang trí tại Trần Gia Từ và chỉ thử nghiệm trên vật liệu của mình. Mẫu giấy đầu tiên đứt vì cô sao chép từng đường nét thấy được. Giới hạn của giấy biến việc sao chép bề mặt thành một vấn đề cấu trúc.',
      english:
          'Twenty-two-year-old Liang Yao and her ceramics-student peer He Zhen observe decoration at the Chen Clan Academy and test only their own materials. The first paper prototype breaks because Liang Yao copies every visible contour; paper turns literal surface copying into a structural problem.',
    );
  }
  return const ReadingAnnotation(
    pinyin:
        'Liáng Yáo tíngzhǐ zhúxiàn zhàomiáo, zài dì èr zhāng zhǐ shàng chóngxīn ānpái liánjiē, liúxià zhǐqiáo. Tā tíqǐ xīn yuánxíng, zhěng zhāng zhǐ méiyǒu sànkāi; Hè Zhēn réng néng rènchū zhǔyào xíngtǐ de xiāngjiē guānxì. Tā bǎ fāngfǎ dài huí gōngzuòshì, kāishǐ xià yí gè cáiliào yánjiū.',
    vietnamese:
        'Lương Dao ngừng đồ theo từng đường, bố trí lại các kết nối trên tờ giấy thứ hai và để lại những cầu giấy. Cô nhấc mẫu mới lên, toàn bộ tờ vẫn liền; Hạ Chân vẫn nhận ra quan hệ nối chính giữa các hình. Cô mang phương pháp ấy về xưởng và bắt đầu một nghiên cứu vật liệu mới.',
    english:
        'Liang Yao stops tracing every contour, redraws the connections on a second sheet, and leaves paper bridges. She lifts the revised prototype and it stays connected; He Zhen can still identify the key relation. Liang Yao carries that method back to the studio and begins another material study.',
  );
}

JourneyLevelContent _guangzhouLevel(List<String> paragraphs) => JourneyLevelContent(
      storyParagraphs: List<String>.unmodifiable(paragraphs),
      storyAnnotations: List<ReadingAnnotation>.unmodifiable([
        for (var i = 0; i < paragraphs.length; i++) _annotation(i, paragraphs.length),
      ]),
      words: const <WordEntry>[],
      discoveries: const <DiscoveryEntry>[],
      wonderQuestion: '',
      expressQuestion: '',
    );

final guangzhouChenClanOnePassLevels = List<JourneyLevelContent>.unmodifiable([
  _guangzhouLevel([
    '二十二岁的梁遥和陶艺同学贺真在广州陈家祠看建筑装饰。她只观察，在自己的纸上做原型。第一张纸照着看见的线剪，几个部分马上断开；她想做成一张能拿起来、又看得出原来形体相接方式的作品。梁遥没有接受散开的结果，也没有继续照搬。她在第二张纸上改掉连接，在会断开的地方留下窄窄的纸桥。她提起新原型，整张纸没有散；贺真也认出主要形体怎样相接。新作品成功，不是因为少做一点，而是纸的连接方式被改对了。梁遥把“照着表面复制”划掉，回到工作室拿起新材料，先问它靠什么连接，再开始下一次试验。',
  ]),
  _guangzhouLevel([
    '二十二岁的梁遥是版画方向学生，她和学陶艺的同学贺真在广州陈家祠看建筑装饰。两人只看，不把纸贴到建筑上，所有试做都在自己的材料上完成。梁遥想把看到的一组形体做成一张能拿起来的纸原型，同时让关系仍然认得出来。她第一张纸把每条线都照搬，剪完后几个部分断开。纸没有原来材料的支撑，照着表面复制反而让作品失去连接。',
    '梁遥没有把失败当成必须保留的缺口。她换第二张纸，停止逐线照搬，在容易分开的地方留下纸桥，让纸按自己的材料条件重新连接。她从一角提起第二个原型，整张纸保持在一起；贺真没有看草图，也能指出主要形体怎样相接。作品因为改变表达方式而成功。梁遥把第一张碎片收好，回工作室拿起新材料，先找它需要怎样连接，再动手做下一次试验。',
  ]),
  _guangzhouLevel([
    '二十二岁的梁遥和陶艺同学贺真来到广州陈家祠做课程观察。梁遥只把眼睛当工具，不在历史建筑表面描、压、贴或拓；所有切割都发生在她自己的纸上。她想做一件可以从桌上拿起来的纸原型，让看到的主要形体关系仍然成立。第一件原型却失败了：梁遥把每一道可见轮廓都当成必须照搬的边界，剪到两组形体之间时，原本承担连接的纸也被切掉，几个部分立刻断开。冲突变得很具体：轮廓越像表面，纸作为一种材料反而越难保持为一个整体。',
    '梁遥决定不再追着每一道线走。她在第二张自己的纸上重新安排连接，保留主要形体的位置，却在原本会断开的地方留下窄窄的纸桥。纸桥不是她假装在原装饰上看到的新线，而是这张纸为了保持在一起所需要的连接。她剪完后从一角提起作品，第二个原型没有散开。贺真站在旁边，没有看草图，仍能认出主要形体相接的方式。梁遥看到，改变编码并没有让关系消失，反而让它在纸上真正成立。回到工作室，她换一块新材料，先找它自己的连接条件，再开始下一次试验。',
  ]),
  _guangzhouLevel([
    '二十二岁的版画学生梁遥和陶艺同学贺真在广州陈家祠观察装饰。陈家祠把多种岭南装饰工艺集中在建筑中，梁遥因此注意到：不同材料可以表达相似的形体关系，却不必用同一种连接办法。两人只观察，不接触建筑装饰；纸、刀和所有试做材料都属于他们自己。梁遥给自己设下目标，要把一组看到的主要形体关系做成一张可以拿起的纸原型。第一件却在剪完时失败：她逐条照着可见线条走，把本来能连接纸面的部分也剪掉了，几个片段从整体上断开。',
    '梁遥没有把问题解释成“看得不够准”。她看清真正的冲突是字面复制与纸的材料要求：如果仍把每条表面线都当成切割边界，纸就无法承担原来材料里的结构联系。她拿出第二张纸，停止逐线照搬，在关键断点之间留下纸桥，同时保持主要形体的位置和方向。剪完后，她从一角把新原型提起来，整张纸仍连在一起。贺真没有得到答案提示，却准确指出最重要的相接关系。梁遥不再把“像”理解成复制所有线，而开始按材料条件翻译关系。回到工作室，她拿起另一种版画材料，先标出它必须保留的连接，再开始下一张材料试验。',
  ]),
  _guangzhouLevel([
    '二十二岁的版画学生梁遥和陶艺同学贺真在广州陈家祠做材料观察。她不接触历史装饰，只在自己的桌板和纸上试做。目标很明确：把观察到的主要形体做成单张纸解释，成品必须能够拿起、保持一个整体，同时让贺真仍能识别原先重要的相接方式。第一件原型很快暴露问题。梁遥把可见线条逐条当成切割边界，追求表面轮廓的字面相似；剪到两个形体的交界时，纸面上最后一条连接也被切掉，几个部分从桌上分开。她越忠实复制表面，单张纸越无法作为一件东西存在。',
    '梁遥没有选择保留这个失败，也没有把断开的片段粘回去假装问题消失。她重新画第二张纸：主要形体的位置和方向保留，但原本会完全切断的地方改成窄窄的纸桥。纸桥并不是建筑装饰上新增的事实，而是纸这种材料为了连续所需要的编码。她剪完第二件原型，从一个角把它慢慢提起；整张纸没有散开。贺真没有看她的底稿，仍能识别两组主要形体之间原先的相接关系。这个结果说明改变连接不是牺牲，而是让同一关系在新媒介里真正工作。梁遥在笔记上划掉“照着表面复制”，回工作室换一块新材料，先检查它怎样保持连接，再开始下一次研究。',
  ]),
  _guangzhouLevel([
    '二十二岁的版画学生梁遥和陶艺同学贺真在广州陈家祠做课程材料研究。两人只观察建筑装饰的形体与起伏，不把纸贴、压、描或摩擦在任何历史表面上；所有原型都在他们自己的材料上完成。梁遥想把观察到的一组主要形体做成单张纸作品：拿起来必须仍是一件完整对象，同时让一个没有看她草图的人识别重要关系。她的第一件原型却物理失败。她把每道看得见的线都当成必须切开的轮廓，以为表面越像就越忠实；剪到两组形体之间时，纸上承担关系的最后一条连接被切断，几个部分立即分开。她这才面对材料本身提出的限制：原建筑中的形体可以依靠自身材料和基底保持关系，薄纸却不能替孤立的部分提供同样支撑。',
    '梁遥把散开的几片并回原来的位置，看了一遍断口，随后直接换上第二张纸。她在主要形体的关系不变的前提下改变连接方法：停止逐线切割，在容易断开的节点保留纸桥。纸桥是纸的结构需要，不是假装原装饰多出了一条线。第二件剪完后，梁遥从一角把作品提离桌面；整张纸仍连着，没有任何片段掉下。贺真没有看底稿，却指出两组主要形体原先怎样相接。作品因为编码改变而获得可拿取的整体，也没有丢掉关键关系。梁遥从表面复制者开始变成材料翻译者。回到工作室，她拿起新的版材，在画轮廓前先标出“这种材料靠什么连接”，随后开始下一次材料研究。',
  ]),
  _guangzhouLevel([
    '二十二岁的版画学生梁遥和陶艺同学贺真在广州陈家祠进行材料研究。陈家祠的岭南装饰由多种材料共同构成，这让梁遥把注意力从“图案像不像”转向“不同材料怎样让形体成立”。她和贺真只观察，不把纸、颜料或工具接触历史装饰；所有试切都在自己的纸上。梁遥要完成一件单张纸原型：既能被手拿起而保持整体，又保留观察对象中最重要的相接关系。第一件原型却散开。她按可见轮廓逐线切割，把两个主要形体之间最后一段纸也去掉了。几个部分从整体上断开，说明字面复制与纸的结构要求发生了直接冲突。',
    '梁遥把散开的第一件放到桌边，重新铺开第二张纸。她仍要做成一件可以完整拿起的纸作品，只是连接方法必须改变。她在第二张纸上重画连接：保留形体的相对位置和主要方向，在原本会被彻底切开的地方留下纸桥，让结构先满足纸的连续性。剪完以后，她捏住一个角把原型提起，整张纸悬在手里仍是一件完整对象。贺真没有看她的底稿，只看着成品。几秒后，他准确指出两组主要形体之间仍然可读的相接关系。梁遥由此把“复制轮廓”改成“翻译关系”。回到工作室，她拿出一种新的版材，先测试它自己的连接和承力方式，再开始下一件材料练习。',
  ]),
  _guangzhouLevel([
    '二十二岁的版画学生梁遥与学陶艺的同学贺真在广州陈家祠做一次材料观察。陈家祠集中呈现多种岭南装饰工艺，材料差异在同一建筑里并置，梁遥因此把“同一视觉关系换一种材料后怎样成立”作为练习。两人只观察建筑，不触碰、描摹、拓印或粘贴任何历史表面；他们的纸和工具始终留在自己的工作板上。梁遥先做一件单张纸原型，希望拿起时仍保持完整，同时让贺真在没有看底稿的情况下识别主要形体的相接关系。第一件原型很快物理失败：她逐线复制表面轮廓，剪掉了纸上所有空隙，也把两个形体之间最后的连接切走，结果几个部分断开。材料把问题暴露得比解释更清楚。',
    '梁遥不再把忠实等同于逐线复制。她把第二张纸当成一种需要被翻译的媒介：主要形体的相对关系保留，但连接方式重新编码，在会断开的关键位置留下纸桥。那些纸桥不是她声称在历史装饰上发现的新细节，而是新材料为了完整工作而必须拥有的结构。她剪完后从一个角提起第二件原型，整张纸没有散开；贺真看了几秒，仍能识别原先最重要的相接关系。第二张纸的局部轮廓已经改变，但整张纸仍连在一起，那组重要关系也没有消失。梁遥把第一件断开的碎片放进材料袋，在笔记上写下“先问材料怎样连接”。回到工作室，她拿起一块新版材，先观察它的硬度和连接条件，再开始下一次材料研究。',
  ]),
  _guangzhouLevel([
    '二十二岁的版画学生梁遥和陶艺同学贺真在广州陈家祠进行跨材料练习。陈家祠集中展示多种岭南装饰工艺，同一建筑中的材料差异让“形式怎样依靠材料成立”变成一个现场可见的问题。两人只观察，不把纸、工具或颜料放到历史装饰表面；全部试切发生在自己的材料上。梁遥的目标是一件单张纸解释：作品离开桌面后仍须完整，贺真也必须能识别她从建筑装饰中观察到的主要形体关系。第一件原型却在剪完时散开。梁遥把每条可见轮廓都当成切割边界，追求字面复制；当最后一段纸被切掉，几个部分立刻断开。她把断开的几片重新并在桌上，发现最后被剪掉的正是让整张纸保持相连的部分。原来的形体可以依靠材料和基底保持关系，薄纸却需要自己的连接。',
    '梁遥把散开的第一件放到一边，铺开第二张自己的纸。她重新编码连接：主要形体的位置、方向和相互靠近方式继续保留，但原本会完全分离的节点留下窄纸桥。纸桥没有冒充历史装饰的真实线条，只负责让纸的结构连续。她剪完第二件原型，从一角提起；整张纸仍完整连在一起。贺真把草图扣在桌面，只看成品。几秒后，他准确识别两组主要形体之间的相接关系。改变编码让新的纸对象既能工作又保持可读。梁遥从表面复制者转成材料翻译者，把“逐线照搬”改写成“关系在新媒介里怎样成立”。回到工作室，她拿起一块不同的版材，先标出这种材料必须保留的连接，再开始新的材料研究。',
  ]),
  _guangzhouLevel([
    '二十二岁的版画学生梁遥和陶艺同学贺真在广州陈家祠观察建筑装饰。陈家祠集中展示多种岭南装饰工艺，正因为材料并不相同，梁遥把“材料怎样让形体相接”当成观察重点。两人只观察，不把纸贴到、压到、描在或摩擦任何历史表面；所有试切都在自己的材料上完成。梁遥想把自己观察到的一组主要形体关系做成一张单张纸的解释，让它既能拿在手里保持为一个整体，又让贺真仍能认出那组关系。她的第一件原型却在桌面上散开：她把每一道看见的轮廓都当成必须照搬的边界，剪到两组形体之间时，纸上原本承担连接的部分也被一起去掉，几个部分随即断开。她把散开的几片重新并在桌上，发现最后被剪掉的正是让整张纸保持相连的部分。原来的形体可以依靠材料和基底保持关系，单张薄纸却需要自己的连接。字面复制越彻底，单张纸反而越无法成为一件东西。',
    '梁遥把第一件散开的碎片收到一边，重新铺开第二张纸。她停下逐线描摹，在第二张自己的纸上重新编码连接：保留主要形体的相对位置，却在原本会断开的地方留下窄窄的纸桥。纸桥不是她假装在陈家祠装饰上看见的新线，而是纸这种媒介为了保持结构而需要的连接。她剪完第二件原型，从一角把它提起；整张纸没有散开。贺真把草图扣在桌面，只看成品。几秒后，他准确指出两组主要形体之间原先最重要的相接关系。梁遥改变连接后，纸桥改变了局部轮廓，却让整张纸既能被拿起，也没有丢掉那组相接关系。梁遥把第一件散开的碎片收进材料袋。她在笔记本上把“照着表面复制”划掉，写下“先问材料怎样连接”。回到工作室，她拿起一块新的版材，先标出这种材料必须保留的连接，再开始下一次材料研究。',
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

final guangzhouChenClanOnePassWords = List<WordEntry>.unmodifiable([
  _word('陈家祠', 'Chénjiācí', '名词（专名）', '广州的历史建筑与广东民间工艺博物馆所在地。', 'Trần Gia Từ', 'Chen Clan Academy / Chen Clan Ancestral Hall', '🏯'),
  _word('原型', 'yuánxíng', '名词', '为了测试想法先做出的试验版本。', 'nguyên mẫu', 'prototype', '🧪'),
  _word('断开', 'duànkāi', '动词', '原来连着的部分分开了。', 'bị đứt; tách rời', 'to disconnect or break apart', '✂️'),
  _word('纸桥', 'zhǐqiáo', '名词', '为了让纸的不同部分保持相连而留下的窄纸连接。', 'cầu giấy', 'paper bridge connecting parts of a sheet', '🌉'),
  _word('连接', 'liánjiē', '动词/名词', '让两个部分保持相连。', 'kết nối', 'connection; to connect', '🔗'),
  _word('材料', 'cáiliào', '名词', '制作作品所使用的物质。', 'vật liệu', 'material', '🧱'),
  _word('轮廓', 'lúnkuò', '名词', '物体外部或形体边界的线。', 'đường nét', 'contour or outline', '〰️'),
  _word('版画', 'bǎnhuà', '名词', '通过版面制作和印制形成图像的艺术门类。', 'nghệ thuật in', 'printmaking', '🖨️'),
  _word('单张', 'dānzhāng', '数量短语', '只有一整张，不由多张拼成。', 'một tờ duy nhất', 'single-sheet', '📄'),
  _word('识别', 'shíbié', '动词', '看出并认出某个对象或关系。', 'nhận diện', 'to identify or recognize', '👁️'),
  _word('关系', 'guānxì', '名词', '两个或多个部分之间的联系。', 'quan hệ', 'relation', '↔️'),
  _word('结构', 'jiégòu', '名词', '各部分怎样组织、支撑并形成整体。', 'cấu trúc', 'structure', '🧩'),
  _word('翻译', 'fānyì', '动词', '把一种表达转换到另一种表达中，同时保留重要意义。', 'chuyển dịch', 'to translate across forms', '🔄'),
  _word('完整', 'wánzhěng', '形容词', '没有散开或缺失关键部分。', 'hoàn chỉnh', 'complete or intact', '✅'),
  _word('观察', 'guānchá', '动词', '有目的地仔细看并比较。', 'quan sát', 'to observe', '🔎'),
  _word('重新编码', 'chóngxīn biānmǎ', '动词', '为了新的媒介重新安排信息与连接方式。', 'mã hóa lại', 'to re-encode', '🧠'),
]);

const guangzhouChenClanWordFirstAppears = <String, int>{
  '陈家祠': 1,
  '原型': 1,
  '断开': 1,
  '纸桥': 1,
  '连接': 1,
  '材料': 1,
  '轮廓': 3,
  '版画': 2,
  '单张': 5,
  '识别': 5,
  '关系': 2,
  '结构': 4,
  '翻译': 4,
  '完整': 6,
  '观察': 1,
  '重新编码': 8,
};

const guangzhouChenClanCuratedWordNamesByLevel = <int, Set<String>>{
  1: {'陈家祠', '原型', '断开', '纸桥', '连接'},
  2: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料'},
  3: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料', '轮廓'},
  4: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料', '轮廓', '版画'},
  5: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料', '轮廓', '版画', '单张', '识别'},
  6: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料', '轮廓', '版画', '单张', '识别', '关系'},
  7: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料', '轮廓', '版画', '单张', '识别', '关系', '结构'},
  8: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料', '轮廓', '版画', '单张', '识别', '关系', '结构', '翻译', '完整', '观察'},
  9: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料', '轮廓', '版画', '单张', '识别', '关系', '结构', '翻译', '完整', '观察', '重新编码'},
  10: {'陈家祠', '原型', '断开', '纸桥', '连接', '材料', '轮廓', '版画', '单张', '识别', '关系', '结构', '翻译', '完整', '观察', '重新编码'},
};

final guangzhouChenClanWordTraces = List<RemediatedWordTrace>.unmodifiable([
  const RemediatedWordTrace(word: '陈家祠', eventId: 'GZ-E1-observation', usage: 'Lv1 首次出现。', sourceText: '二十二岁的梁遥和陶艺同学贺真在广州陈家祠看建筑装饰。'),
  const RemediatedWordTrace(word: '原型', eventId: 'GZ-E2-first-failure', usage: 'Lv1 首次出现。', sourceText: '她只观察，在自己的纸上做原型。'),
  const RemediatedWordTrace(word: '断开', eventId: 'GZ-E2-first-failure', usage: 'Lv1 首次出现。', sourceText: '第一张纸照着看见的线剪，几个部分马上断开；她想做成一张能拿起来、又看得出原来形体相接方式的作品。'),
  const RemediatedWordTrace(word: '纸桥', eventId: 'GZ-E4-reencode', usage: 'Lv1 首次出现。', sourceText: '她在第二张纸上改掉连接，在会断开的地方留下窄窄的纸桥。'),
  const RemediatedWordTrace(word: '连接', eventId: 'GZ-E4-reencode', usage: 'Lv1 首次出现。', sourceText: '她在第二张纸上改掉连接，在会断开的地方留下窄窄的纸桥。'),
  const RemediatedWordTrace(word: '材料', eventId: 'GZ-E8-next-material', usage: 'Lv1 首次出现。', sourceText: '梁遥把“照着表面复制”划掉，回到工作室拿起新材料，先问它靠什么连接，再开始下一次试验。'),
  const RemediatedWordTrace(word: '轮廓', eventId: 'GZ-E2-first-failure', usage: 'Lv3 首次出现。', sourceText: '第一件原型却失败了：梁遥把每一道可见轮廓都当成必须照搬的边界，剪到两组形体之间时，原本承担连接的纸也被切掉，几个部分立刻断开。'),
  const RemediatedWordTrace(word: '版画', eventId: 'GZ-E1-observation', usage: 'Lv2 首次出现。', sourceText: '二十二岁的梁遥是版画方向学生，她和学陶艺的同学贺真在广州陈家祠看建筑装饰。'),
  const RemediatedWordTrace(word: '单张', eventId: 'GZ-E1-observation', usage: 'Lv5 首次出现。', sourceText: '目标很明确：把观察到的主要形体做成单张纸解释，成品必须能够拿起、保持一个整体，同时让贺真仍能识别原先重要的相接方式。'),
  const RemediatedWordTrace(word: '识别', eventId: 'GZ-E6-legibility', usage: 'Lv5 首次出现。', sourceText: '贺真没有看她的底稿，仍能识别两组主要形体之间原先的相接关系。'),
  const RemediatedWordTrace(word: '关系', eventId: 'GZ-E1-observation', usage: 'Lv2 首次出现。', sourceText: '梁遥想把看到的一组形体做成一张能拿起来的纸原型，同时让关系仍然认得出来。'),
  const RemediatedWordTrace(word: '结构', eventId: 'GZ-E3-medium-conflict', usage: 'Lv4 首次出现。', sourceText: '如果仍把每条表面线都当成切割边界，纸就无法承担原来材料里的结构联系。'),
  const RemediatedWordTrace(word: '翻译', eventId: 'GZ-E7-transformation', usage: 'Lv4 首次出现。', sourceText: '梁遥不再把“像”理解成复制所有线，而开始按材料条件翻译关系。'),
  const RemediatedWordTrace(word: '完整', eventId: 'GZ-E5-second-prototype', usage: 'Lv6 首次出现。', sourceText: '梁遥想把观察到的一组主要形体做成单张纸作品：拿起来必须仍是一件完整对象，同时让一个没有看她草图的人识别重要关系。'),
  const RemediatedWordTrace(word: '观察', eventId: 'GZ-E1-observation', usage: 'Lv1 首次出现。', sourceText: '她只观察，在自己的纸上做原型。'),
  const RemediatedWordTrace(word: '重新编码', eventId: 'GZ-E4-reencode', usage: 'Lv8 首次出现。', sourceText: '她把第二张纸当成一种需要被翻译的媒介：主要形体的相对关系保留，但连接方式重新编码，在会断开的关键位置留下纸桥。'),
]);

DiscoveryEntry _discovery(
  String text, {
  required String pinyin,
  required String simpleChinese,
  required String vietnamese,
  required String english,
}) => DiscoveryEntry(
      text: text,
      pinyin: pinyin,
      simpleChinese: simpleChinese,
      vietnamese: vietnamese,
      english: english,
    );

final guangzhouChenClanDiscoverySpecs = List<GuangzhouDiscoverySpec>.unmodifiable([
  GuangzhouDiscoverySpec(
    level: 1,
    title: '陈家祠与陈氏书院',
    storyLink: '故事把陈家祠作为观察地点，Discovery 说明名称与时代背景。',
    entry: _discovery('陈家祠是清代晚期建筑，也称陈氏书院。', pinyin: 'Chénjiācí shì Qīngdài wǎnqī jiànzhù, yě chēng Chénshì Shūyuàn.', simpleChinese: '陈家祠也叫陈氏书院，是晚清建筑。', vietnamese: 'Trần Gia Từ còn được gọi là Trần Thị Thư Viện và là công trình cuối thời Thanh.', english: 'Chen Clan Academy, also known as Chen Clan Ancestral Hall, is a late-Qing complex.'),
    keyTerms: const ['陈家祠', '陈氏书院', '晚清'],
    learnerInsight: '一个地点可以同时保留常用名与历史名称。',
    check: '陈家祠还有什么名称？',
    answer: '陈氏书院。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 2,
    title: '多种岭南装饰工艺',
    storyLink: 'Story 只需要材料差异，Discovery 展开具体工艺类别。',
    entry: _discovery('陈家祠集中展示木雕、砖雕、石雕、陶塑和灰塑等岭南装饰工艺。', pinyin: 'Chénjiācí jízhōng zhǎnshì mùdiāo, zhuāndiāo, shídiāo, táosù hé huīsù děng Lǐngnán zhuāngshì gōngyì.', simpleChinese: '这里能看到多种不同材料的岭南装饰。', vietnamese: 'Trần Gia Từ tập trung nhiều nghệ thuật trang trí Lĩnh Nam như chạm gỗ, gạch, đá, tượng gốm và phù điêu vữa.', english: 'The complex brings together Lingnan decorative arts including wood, brick, and stone carving, ceramic sculpture, and lime sculpture.'),
    keyTerms: const ['木雕', '砖雕', '石雕', '陶塑', '灰塑'],
    learnerInsight: '岭南装饰并不依赖单一材料。',
    check: '陈家祠的装饰是否只使用一种材料？',
    answer: '不是，官方介绍列出多种装饰工艺。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 3,
    title: '铸造与彩绘也在其中',
    storyLink: 'Story 不罗列七类工艺，Discovery 补足官方列出的范围。',
    entry: _discovery('官方介绍还把铸造和彩绘与多种雕塑、雕刻工艺一起列入陈家祠的装饰特色。', pinyin: 'Guānfāng jièshào hái bǎ zhùzào hé cǎihuì yǔ duō zhǒng diāosù, diāokè gōngyì yìqǐ lièrù Chénjiācí de zhuāngshì tèsè.', simpleChinese: '除了雕刻和塑造，这里还有铸造和彩绘。', vietnamese: 'Giới thiệu chính thức còn liệt kê đúc và vẽ màu cùng với nhiều loại chạm khắc và tạo hình.', english: 'The official description also includes casting and painting among the complex’s decorative crafts.'),
    keyTerms: const ['铸造', '彩绘'],
    learnerInsight: '工艺差异不仅是图案差异，也包括材料和制作媒介的差异。',
    check: '除了雕刻与塑造，官方介绍还提到哪两类？',
    answer: '铸造和彩绘。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 4,
    title: '材料差异为什么值得观察',
    storyLink: 'Story 让材料差异推动制作，Discovery 只陈述多工艺并置事实。',
    entry: _discovery('木、砖、石、陶、灰泥以及用于铸造和彩绘的媒介在同一建筑装饰体系中并置，形成陈家祠鲜明的多工艺特征。', pinyin: 'Mù, zhuān, shí, táo, huīní yǐjí yòngyú zhùzào hé cǎihuì de méijiè zài tóng yī jiànzhù zhuāngshì tǐxì zhōng bìngzhì.', simpleChinese: '同一建筑里可以同时看到不同材料形成的装饰。', vietnamese: 'Trong cùng một hệ trang trí kiến trúc có nhiều vật liệu và hình thức thủ công khác nhau.', english: 'Different material-based decorative crafts are presented together within the same architectural complex.'),
    keyTerms: const ['材料', '多工艺', '建筑装饰'],
    learnerInsight: '多材料并置使比较不同媒介成为可能。',
    check: '陈家祠的工艺特色为什么适合做材料比较？',
    answer: '因为同一建筑中集中呈现多种材料和工艺。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 5,
    title: '今天的博物馆功能',
    storyLink: 'Story 聚焦制作，Discovery 说明场所今天的机构身份。',
    entry: _discovery('今天，陈家祠是广东民间工艺博物馆所在地，收藏和展示多种广东传统工艺。', pinyin: 'Jīntiān, Chénjiācí shì Guǎngdōng Mínjiān Gōngyì Bówùguǎn suǒzàidì, shōucáng hé zhǎnshì duō zhǒng Guǎngdōng chuántǒng gōngyì.', simpleChinese: '现在这里也是广东民间工艺博物馆。', vietnamese: 'Ngày nay đây là nơi đặt Bảo tàng Mỹ thuật Dân gian Quảng Đông, nơi sưu tầm và trưng bày nhiều nghề thủ công truyền thống.', english: 'Today the complex houses the Guangdong Folk Arts Museum, which collects and displays traditional Guangdong crafts.'),
    keyTerms: const ['广东民间工艺博物馆', '收藏', '展示'],
    learnerInsight: '历史建筑今天也承担民间工艺博物馆功能。',
    check: '今天这里是什么博物馆所在地？',
    answer: '广东民间工艺博物馆。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 6,
    title: '文物保护身份',
    storyLink: 'Story 主动保持非接触，Discovery 给出已核实的保护身份。',
    entry: _discovery('陈家祠在一九八八年被公布为全国重点文物保护单位。', pinyin: 'Chénjiācí zài yī jiǔ bā bā nián bèi gōngbù wéi Quánguó Zhòngdiǎn Wénwù Bǎohù Dānwèi.', simpleChinese: '陈家祠是全国重点文物保护单位。', vietnamese: 'Năm 1988, Trần Gia Từ được công bố là đơn vị di tích văn hóa trọng điểm cấp quốc gia.', english: 'In 1988, the complex was designated a Major Historical and Cultural Site Protected at the National Level.'),
    keyTerms: const ['全国重点文物保护单位', '保护'],
    learnerInsight: '观察历史建筑与在自己材料上试做可以清楚分开。',
    check: '陈家祠具有什么国家级保护身份？',
    answer: '全国重点文物保护单位。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 7,
    title: '工艺展示的范围',
    storyLink: 'Story 只用“多材料”作为因果背景，Discovery 保留具体事实。',
    entry: _discovery('广东民间工艺博物馆以广东传统工艺的收藏和展示为重要内容，陈家祠本身的建筑装饰也是认识这些工艺的重要对象。', pinyin: 'Guǎngdōng Mínjiān Gōngyì Bówùguǎn yǐ Guǎngdōng chuántǒng gōngyì de shōucáng hé zhǎnshì wéi zhòngyào nèiróng.', simpleChinese: '博物馆通过收藏、展示和建筑装饰帮助人们认识广东传统工艺。', vietnamese: 'Bảo tàng tập trung vào việc sưu tầm và trưng bày các nghề thủ công truyền thống Quảng Đông.', english: 'The museum’s role includes collecting and displaying Guangdong traditional crafts, while the historic complex itself presents rich decorative craftsmanship.'),
    keyTerms: const ['广东传统工艺', '博物馆'],
    learnerInsight: '建筑与博物馆展示共同支持工艺学习。',
    check: '博物馆的重要内容是什么？',
    answer: '收藏和展示广东传统工艺。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 8,
    title: '雕刻与塑造不是同一种媒介',
    storyLink: 'Story 的翻译问题来自媒介不同，Discovery 用官方类别说明差异存在。',
    entry: _discovery('官方介绍把木雕、砖雕、石雕与陶塑、灰塑分别列出，说明陈家祠的装饰由不同材料类别共同构成。', pinyin: 'Guānfāng jièshào bǎ mùdiāo, zhuāndiāo, shídiāo yǔ táosù, huīsù fēnbié lièchū.', simpleChinese: '雕刻和塑造使用的材料类别不同，却一起构成建筑装饰。', vietnamese: 'Giới thiệu chính thức liệt kê riêng các loại chạm khắc và tạo hình, cho thấy nhiều nhóm vật liệu cùng tạo nên trang trí.', english: 'The official description lists carving and sculptural crafts separately, showing that multiple material categories contribute to the decoration.'),
    keyTerms: const ['雕刻', '塑造', '材料类别'],
    learnerInsight: '同一视觉环境可以由不同媒介共同形成。',
    check: '官方介绍是否把所有装饰都归成同一种工艺？',
    answer: '不是，它分别列出多种雕刻、塑造、铸造和彩绘工艺。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 9,
    title: '历史建筑与活态展示',
    storyLink: 'Story 不把地点写成抽象工作室，Discovery 说明它同时是受保护建筑和博物馆。',
    entry: _discovery('陈家祠既具有全国重点文物保护单位身份，今天又作为广东民间工艺博物馆使用。', pinyin: 'Chénjiācí jì jùyǒu Quánguó Zhòngdiǎn Wénwù Bǎohù Dānwèi shēnfèn, jīntiān yòu zuòwéi Guǎngdōng Mínjiān Gōngyì Bówùguǎn shǐyòng.', simpleChinese: '这里既是受保护的历史建筑，也是今天的工艺博物馆。', vietnamese: 'Nơi đây vừa là di tích được bảo vệ cấp quốc gia, vừa là Bảo tàng Mỹ thuật Dân gian Quảng Đông ngày nay.', english: 'The complex is both a nationally protected historic site and the present home of the Guangdong Folk Arts Museum.'),
    keyTerms: const ['文物保护', '博物馆'],
    learnerInsight: '保护与当代公共文化功能可以同时存在。',
    check: '陈家祠今天同时具有哪两种身份？',
    answer: '受保护的历史建筑与广东民间工艺博物馆所在地。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
  GuangzhouDiscoverySpec(
    level: 10,
    title: '陈家祠为什么是多材料学习场',
    storyLink: 'Story 的因果只需要“多种材料并置”，完整事实留在 Discovery。',
    entry: _discovery('从晚清陈氏书院到今天的广东民间工艺博物馆，陈家祠以受保护的历史建筑保存并展示木雕、砖雕、石雕、陶塑、灰塑、铸造和彩绘等多种岭南工艺。', pinyin: 'Cóng Wǎnqīng Chénshì Shūyuàn dào jīntiān de Guǎngdōng Mínjiān Gōngyì Bówùguǎn, Chénjiācí bǎocún bìng zhǎnshì duō zhǒng Lǐngnán gōngyì.', simpleChinese: '陈家祠把历史建筑、文物保护和多种岭南工艺展示连在一起。', vietnamese: 'Từ Trần Thị Thư Viện cuối Thanh đến Bảo tàng Mỹ thuật Dân gian Quảng Đông ngày nay, công trình được bảo vệ này lưu giữ và trưng bày nhiều nghệ thuật Lĩnh Nam.', english: 'From its late-Qing identity as the Chen Clan Academy to its present museum role, the protected complex preserves and presents multiple Lingnan crafts including carving, sculpture, casting, and painting.'),
    keyTerms: const ['陈氏书院', '岭南工艺', '广东民间工艺博物馆'],
    learnerInsight: '地点的文化价值来自多种工艺、历史建筑与当代展示共同存在。',
    check: '为什么陈家祠不能被任意替换成普通工作室？',
    answer: '因为这里的受保护建筑与多种岭南工艺并置，正是材料比较的文化背景。',
    sourceIds: const [guangzhouChenClanSourceRecordId],
  ),
]);

final guangzhouChenClanOnePassDiscoveries = List<DiscoveryEntry>.unmodifiable(
  guangzhouChenClanDiscoverySpecs.map((spec) => spec.entry),
);

final guangzhouChenClanChallengeSpecs = List<GuangzhouChallengeSpec>.unmodifiable([
  for (var level = 1; level <= 10; level++) ...[
    GuangzhouChallengeSpec(
      level: level,
      type: 'paragraphRebuild',
      prompt: '第一件纸原型为什么会物理失败？',
      anchor: guangzhouChenClanOnePassLevels[level - 1].storyParagraphs.first,
      answer: '梁遥逐线照搬表面轮廓，把纸上承担连接的部分也切掉，因此几个部分断开。',
    ),
    GuangzhouChallengeSpec(
      level: level,
      type: 'grammarRepair',
      prompt: '梁遥在第二张纸上具体改变了什么？',
      anchor: guangzhouChenClanOnePassLevels[level - 1].storyParagraphs.last,
      answer: '她停止逐线照搬，在会断开的地方保留纸桥，用纸的结构需要重新编码连接。',
    ),
    GuangzhouChallengeSpec(
      level: level,
      type: 'missingSentence',
      prompt: '第二件原型怎样证明跨材料翻译成功？',
      anchor: guangzhouChenClanOnePassLevels[level - 1].storyParagraphs.last,
      answer: '梁遥提起原型时整张纸保持连接，贺真又能识别原先重要的形体关系。',
    ),
  ],
]);

final guangzhouChenClanReflectionPrompts = List<String>.unmodifiable([
  for (var level = 1; level <= 10; level++)
    '为什么纸桥不是对原装饰的错误添加，而是梁遥把关系翻译到纸这种材料中的必要连接？',
]);

final guangzhouChenClanWritingPrompts = List<String>.unmodifiable([
  for (var level = 1; level <= 10; level++)
    '请用两到三句话写出“第一件断开 → 改变连接 → 第二件完整且可识别”的因果过程。',
]);

final guangzhouChenClanDiscoveryTraces = List<RemediatedDiscoveryTrace>.unmodifiable([
  for (var level = 1; level <= 10; level++)
    RemediatedDiscoveryTrace(
      discoveryIndex: level - 1,
      storyEventIds: const ['GZ-E1-observation', 'GZ-E3-medium-conflict'],
      sourceIds: const [guangzhouChenClanSourceRecordId],
    ),
]);

final guangzhouChenClanChallengeTraces = List<RemediatedChallengeTrace>.unmodifiable([
  for (final spec in guangzhouChenClanChallengeSpecs)
    RemediatedChallengeTrace(
      type: spec.type,
      storyEventIds: const [
        'GZ-E2-first-failure',
        'GZ-E3-medium-conflict',
        'GZ-E4-reencode',
        'GZ-E5-second-prototype',
        'GZ-E6-legibility',
      ],
      anchor: spec.anchor,
    ),
]);

const guangzhouChenClanMemory = <RemediatedMemoryReview>[
  RemediatedMemoryReview(
    category: '失败',
    prompt: '第一件原型为什么散开？',
    answer: '梁遥逐线复制轮廓，把纸上必须承担连接的部分切掉了。',
    storyEventIds: ['GZ-E2-first-failure', 'GZ-E3-medium-conflict'],
  ),
  RemediatedMemoryReview(
    category: '选择',
    prompt: '纸桥代表梁遥做了什么改变？',
    answer: '她不再复制每条表面线，而按纸的结构要求重新编码连接。',
    storyEventIds: ['GZ-E4-reencode'],
  ),
  RemediatedMemoryReview(
    category: '证明',
    prompt: '第二件原型怎样证明方法有效？',
    answer: '它被提起后仍是一整张，贺真又能识别关键形体关系。',
    storyEventIds: ['GZ-E5-second-prototype', 'GZ-E6-legibility'],
  ),
];

const guangzhouChenClanCompletion = RemediatedCompletion(
  journeySummary: '梁遥让第一件逐线复制的纸原型失败，再用纸桥重新编码连接，使第二件单张纸既完整又保持关键关系可识别。',
  achievement: '跨材料关系翻译者',
  memoryAnchor: guangzhouChenClanMemoryAnchor,
  challengeReward: '纸桥结构标记',
  journeyCompletion:
      '《纸桥》完成：梁遥不再把忠实等同于表面复制，而把新的连接方法带进下一次材料研究。陈家祠仍有更多工艺可以观察。',
);

const guangzhouChenClanEventIds = <String>[
  'GZ-E1-observation',
  'GZ-E2-first-failure',
  'GZ-E3-medium-conflict',
  'GZ-E4-reencode',
  'GZ-E5-second-prototype',
  'GZ-E6-legibility',
  'GZ-E7-transformation',
  'GZ-E8-next-material',
];

const guangzhouChenClanEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(
    id: 'GZ-E1-observation',
    coreChinese: '二十二岁的版画学生梁遥和陶艺同学贺真在广州陈家祠观察建筑装饰，只在自己的材料上试做。',
    corePinyin: 'Èrshí’èr suì de bǎnhuà xuéshēng Liáng Yáo hé táoyì tóngxué Hè Zhēn zài Guǎngzhōu Chénjiācí guānchá.',
    coreVietnamese: 'Lương Dao, sinh viên in 22 tuổi, và bạn học gốm Hạ Chân quan sát trang trí tại Trần Gia Từ và chỉ thử nghiệm trên vật liệu của mình.',
    coreEnglish: 'Twenty-two-year-old printmaking student Liang Yao and ceramics-student peer He Zhen observe decoration at the Chen Clan Academy and work only on their own materials.',
    detailChinese: '多种岭南装饰工艺的材料差异使跨媒介连接成为观察重点。',
    detailPinyin: 'Duō zhǒng Lǐngnán zhuāngshì gōngyì de cáiliào chāyì shǐ kuà méijiè liánjiē chéngwéi guānchá zhòngdiǎn.',
    detailVietnamese: 'Sự khác biệt vật liệu giữa nhiều nghệ thuật trang trí Lĩnh Nam khiến vấn đề kết nối xuyên môi trường trở thành trọng tâm.',
    detailEnglish: 'Material differences among multiple Lingnan decorative crafts make cross-medium connection the focus.',
    detailFromLevel: 4,
  ),
  RemediatedSemanticEvent(
    id: 'GZ-E2-first-failure',
    coreChinese: '第一件逐线复制的纸原型在剪完后断成几个部分。',
    corePinyin: 'Dì yī jiàn zhúxiàn fùzhì de zhǐ yuánxíng zài jiǎnwán hòu duàn chéng jǐ gè bùfen.',
    coreVietnamese: 'Mẫu giấy đầu tiên sao chép từng đường bị đứt thành nhiều phần sau khi cắt.',
    coreEnglish: 'The first literal-contour paper prototype breaks into disconnected pieces after cutting.',
    detailChinese: '梁遥把承担连接的纸也当成轮廓空隙切掉。',
    detailPinyin: 'Liáng Yáo bǎ chéngdān liánjiē de zhǐ yě dàngchéng lúnkuò kòngxì qiēdiào.',
    detailVietnamese: 'Lương Dao cắt mất cả phần giấy cần để kết nối.',
    detailEnglish: 'Liang Yao cuts away paper that the new medium needs for connection.',
    detailFromLevel: 3,
  ),
  RemediatedSemanticEvent(
    id: 'GZ-E3-medium-conflict',
    coreChinese: '字面复制与纸的结构要求发生冲突。',
    corePinyin: 'Zìmiàn fùzhì yǔ zhǐ de jiégòu yāoqiú fāshēng chōngtū.',
    coreVietnamese: 'Sao chép theo bề mặt xung đột với yêu cầu cấu trúc của giấy.',
    coreEnglish: 'Literal copying conflicts with paper-specific structural requirements.',
    detailChinese: '问题不是历史证据分类，而是新材料不能用原媒介的连接逻辑自动保持整体。',
    detailPinyin: 'Wèntí bú shì lìshǐ zhèngjù fēnlèi, ér shì xīn cáiliào bùnéng zìdòng yòng yuán méijiè de liánjiē luójí bǎochí zhěngtǐ.',
    detailVietnamese: 'Vấn đề không phải phân loại bằng chứng lịch sử mà là vật liệu mới không tự giữ được logic kết nối của môi trường cũ.',
    detailEnglish: 'The issue is not historical evidence classification; the new material cannot automatically inherit the source medium’s connection logic.',
    detailFromLevel: 5,
  ),
  RemediatedSemanticEvent(
    id: 'GZ-E4-reencode',
    coreChinese: '梁遥在第二张纸上留下纸桥，重新编码会断开的连接。',
    corePinyin: 'Liáng Yáo zài dì èr zhāng zhǐ shàng liúxià zhǐqiáo, chóngxīn biānmǎ huì duànkāi de liánjiē.',
    coreVietnamese: 'Lương Dao để lại các cầu giấy trên tờ thứ hai và mã hóa lại các điểm kết nối sẽ bị đứt.',
    coreEnglish: 'On the second sheet, Liang Yao leaves paper bridges and re-encodes the connections that would otherwise break.',
    detailChinese: '她保留主要形体关系，但不再把每条表面线都当成切割边界。',
    detailPinyin: 'Tā bǎoliú zhǔyào xíngtǐ guānxì, dàn bù zài bǎ měi tiáo biǎomiàn xiàn dōu dàngchéng qiēgē biānjiè.',
    detailVietnamese: 'Cô giữ quan hệ hình thể chính nhưng không còn coi mọi đường bề mặt là biên cắt.',
    detailEnglish: 'She preserves the important form relation without treating every surface line as a cutting boundary.',
    detailFromLevel: 3,
  ),
  RemediatedSemanticEvent(
    id: 'GZ-E5-second-prototype',
    coreChinese: '第二件原型从一角提起后仍是一张完整相连的纸。',
    corePinyin: 'Dì èr jiàn yuánxíng cóng yì jiǎo tíqǐ hòu réng shì yì zhāng wánzhěng xiānglián de zhǐ.',
    coreVietnamese: 'Mẫu thứ hai khi nhấc từ một góc vẫn là một tờ giấy liền và hoàn chỉnh.',
    coreEnglish: 'The second prototype lifts from one corner as one intact connected sheet.',
    detailChinese: '纸桥让新媒介获得实际结构连续性。',
    detailPinyin: 'Zhǐqiáo ràng xīn méijiè huòdé shíjì jiégòu liánxùxìng.',
    detailVietnamese: 'Cầu giấy tạo tính liên tục cấu trúc thực sự cho môi trường mới.',
    detailEnglish: 'The paper bridges give the new medium real structural continuity.',
    detailFromLevel: 4,
  ),
  RemediatedSemanticEvent(
    id: 'GZ-E6-legibility',
    coreChinese: '贺真不看草图，仍能识别原先重要的相接关系。',
    corePinyin: 'Hè Zhēn bù kàn cǎotú, réng néng shíbié yuánxiān zhòngyào de xiāngjiē guānxì.',
    coreVietnamese: 'Không nhìn bản phác, Hạ Chân vẫn nhận ra quan hệ nối quan trọng ban đầu.',
    coreEnglish: 'Without seeing the sketch, He Zhen can still identify the important original relation.',
    detailChinese: '同伴用可识别性检验翻译结果，而不是以导师身份授予答案。',
    detailPinyin: 'Tóngbàn yòng kě shíbié xìng jiǎnyàn fānyì jiéguǒ, ér bú shì yǐ dǎoshī shēnfèn shòuyǔ dá’àn.',
    detailVietnamese: 'Người bạn kiểm tra tính nhận diện của bản dịch chứ không ban đáp án như một người thầy.',
    detailEnglish: 'The peer tests legibility rather than granting an answer with mentor authority.',
    detailFromLevel: 5,
  ),
  RemediatedSemanticEvent(
    id: 'GZ-E7-transformation',
    coreChinese: '梁遥从表面复制者转为材料翻译者。',
    corePinyin: 'Liáng Yáo cóng biǎomiàn fùzhì zhě zhuǎn wéi cáiliào fānyì zhě.',
    coreVietnamese: 'Lương Dao chuyển từ người sao chép bề mặt thành người dịch qua vật liệu.',
    coreEnglish: 'Liang Yao changes from a surface-copyist into a material translator.',
    detailChinese: '成功标准从逐线相似改为关系在新媒介中既可工作又可读。',
    detailPinyin: 'Chénggōng biāozhǔn cóng zhúxiàn xiāngsì gǎi wéi guānxì zài xīn méijiè zhōng jì kě gōngzuò yòu kě dú.',
    detailVietnamese: 'Tiêu chuẩn thành công chuyển từ giống từng đường sang việc quan hệ vừa hoạt động vừa đọc được trong môi trường mới.',
    detailEnglish: 'Success shifts from line-by-line likeness to a relation that works and remains legible in the new medium.',
    detailFromLevel: 6,
  ),
  RemediatedSemanticEvent(
    id: 'GZ-E8-next-material',
    coreChinese: '回到工作室，梁遥把新的连接方法用于下一种材料研究。',
    corePinyin: 'Huídào gōngzuòshì, Liáng Yáo bǎ xīn de liánjiē fāngfǎ yòngyú xià yì zhǒng cáiliào yánjiū.',
    coreVietnamese: 'Về xưởng, Lương Dao áp dụng cách kết nối mới vào nghiên cứu vật liệu tiếp theo.',
    coreEnglish: 'Back in the studio, Liang Yao applies the changed connection method to the next material study.',
    detailChinese: '她先标出新材料必须保留的连接，再开始画轮廓。',
    detailPinyin: 'Tā xiān biāochū xīn cáiliào bìxū bǎoliú de liánjiē, zài kāishǐ huà lúnkuò.',
    detailVietnamese: 'Cô đánh dấu trước những kết nối vật liệu mới phải giữ rồi mới bắt đầu vẽ đường nét.',
    detailEnglish: 'She marks the connections the new material must retain before drawing contours.',
    detailFromLevel: 7,
  ),
];

const guangzhouChenClanSources = <RemediatedSourceBinding>[
  RemediatedSourceBinding(
    id: guangzhouChenClanSourceRecordId,
    publisher: '广州市人民政府',
    scope:
        '陈家祠／陈氏书院晚清背景、木雕砖雕石雕陶塑灰塑铸造彩绘等岭南装饰工艺、全国重点文物保护单位、广东民间工艺博物馆',
  ),
];

final guangzhouChenClanRemediatedJourney = RemediatedJourney(
  id: guangzhouChenClanJourneyId,
  title: '广州 · 陈家祠：$guangzhouChenClanCanonicalTitle',
  protagonist: '梁遥，22岁，虚构版画学生',
  goal: '把观察到的主要形体关系翻译成一件保持单张连接且仍可识别的纸作品。',
  conflict: '逐线复制表面轮廓会切断纸的结构连接；纸这种新媒介要求重新编码连接方式。',
  eventIds: guangzhouChenClanEventIds,
  events: guangzhouChenClanEvents,
  levels: guangzhouChenClanOnePassLevels,
  words: guangzhouChenClanOnePassWords,
  wordTraces: guangzhouChenClanWordTraces,
  discoveries: guangzhouChenClanOnePassDiscoveries,
  discoveryTraces: guangzhouChenClanDiscoveryTraces,
  challenges: guangzhouChenClanChallengeTraces,
  memory: guangzhouChenClanMemory,
  completion: guangzhouChenClanCompletion,
  sources: guangzhouChenClanSources,
);

JourneyLevelContent guangzhouChenClanOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = guangzhouChenClanOnePassLevels[level - 1];
  final story = base.storyParagraphs.join();
  final selected = guangzhouChenClanCuratedWordNamesByLevel[level] ?? const <String>{};
  final visibleWords = guangzhouChenClanOnePassWords
      .where((entry) => selected.contains(entry.word) && story.contains(entry.word))
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: visibleWords,
    discoveries: <DiscoveryEntry>[guangzhouChenClanDiscoverySpecs[level - 1].entry],
    wonderQuestion: guangzhouChenClanReflectionPrompts[level - 1],
    expressQuestion: guangzhouChenClanWritingPrompts[level - 1],
  );
}
