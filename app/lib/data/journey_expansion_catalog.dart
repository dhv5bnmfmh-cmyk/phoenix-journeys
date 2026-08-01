import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

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
  '苏州园林实习生沈栀要为一位低视力访客设计拙政园路线。主管只给她一张最上镜的导览图，图上漏窗、曲桥与亭子漂亮，却没有标出长廊的台阶。',
  '沈栀蒙住自己的眼睛，沿池水声和墙面触感试走，才发现借景不仅靠远望，也能由竹叶、回声与脚下转折形成。原路线最短，却会把访客困在窄桥前。',
  '她舍弃必到的摄影点，把路线引向缓坡，并请花匠用不同叶香标记转弯。访客错过一扇著名漏窗，却在长廊尽头准确说出池水与亭台的位置。',
  '沈栀重画地图时不再把园林当作一幅固定山水画。真正的层次来自每个人怎样进入空间，也来自设计者愿不愿为另一种观察方式改变路线。',
];

const _suzhouAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin: 'sū zhōu yuán lín shí xí shēng shěn zhī yào wèi yí wèi dī shì lì fǎng kè shè jì zhuō zhèng yuán lù xiàn 。 zhǔ guǎn zhī gěi tā yì zhāng zuì shàng jìng de dǎo lǎn tú ， tú shàng lòu chuāng 、 qǔ qiáo yǔ tíng zi piào liang ， què méi yǒu biāo chū cháng láng de tái jiē 。',
    vietnamese: 'Thực tập sinh vườn Thẩm Chi phải thiết kế tuyến Chuyết Chính Viên cho khách thị lực yếu. Bản đồ đẹp có cửa hoa, cầu cong và đình nhưng không đánh dấu bậc ở hành lang.',
    english: 'Garden intern Shen Zhi must design a Humble Administrator\'s Garden route for a visitor with low vision. The photogenic map shows windows, bridges, and pavilions but omits corridor steps.',
  ),
  ReadingAnnotation(
    pinyin: 'shěn zhī méng zhù zì jǐ de yǎn jīng ， yán chí shuǐ shēng hé qiáng miàn chù gǎn shì zǒu ， cái fā xiàn jiè jǐng bù jǐn kào yuǎn wàng ， yě néng yóu zhú yè 、 huí shēng yǔ jiǎo xià zhuǎn zhé xíng chéng 。 yuán lù xiàn zuì duǎn ， què huì bǎ fǎng kè kùn zài zhǎi qiáo qián 。',
    vietnamese: 'Cô bịt mắt đi thử theo tiếng nước và mặt tường, nhận ra mượn cảnh cũng có thể hình thành bằng lá tre, tiếng vọng và khúc ngoặt. Tuyến ngắn nhất sẽ chặn khách trước cầu hẹp.',
    english: 'She walks blindfolded by water sound and wall texture, learning that borrowed scenery can also come through leaves, echoes, and turns. The shortest route would strand the visitor at a narrow bridge.',
  ),
  ReadingAnnotation(
    pinyin: 'tā shè qì bì dào de shè yǐng diǎn ， bǎ lù xiàn yǐn xiàng huǎn pō ， bìng qǐng huā jiàng yòng bù tóng yè xiāng biāo jì zhuǎn wān 。 fǎng kè cuò guò yí shàn zhù míng lòu chuāng ， què zài cháng láng jìn tóu zhǔn què shuō chū chí shuǐ yǔ tíng tái de wèi zhì 。',
    vietnamese: 'Cô bỏ điểm chụp bắt buộc, chuyển sang dốc thoải và dùng mùi lá đánh dấu lối rẽ. Khách bỏ lỡ cửa sổ nổi tiếng nhưng xác định đúng ao và đình ở cuối hành lang.',
    english: 'She drops the mandatory photo stop, chooses a gentle slope, and marks turns with leaf scents. The visitor misses a famous window but accurately locates pond and pavilion at the corridor\'s end.',
  ),
  ReadingAnnotation(
    pinyin: 'shěn zhī zhòng huà dì tú shí bú zài bǎ yuán lín dāng zuò yì fú gù dìng shān shuǐ huà 。 zhēn zhèng de céng cì lái zì měi gè rén zěn yàng jìn rù kōng jiān ， yě lái zì shè jì zhě yuàn bu yuàn wèi lìng yì zhǒng guān chá fāng shì gǎi biàn lù xiàn 。',
    vietnamese: 'Khi vẽ lại bản đồ, Thẩm Chi không còn xem vườn là tranh cố định. Chiều sâu đến từ cách mỗi người đi vào không gian và sự sẵn lòng thay đổi tuyến cho một cách quan sát khác.',
    english: 'Redrawing the map, Shen Zhi no longer treats the garden as a fixed painting. Depth comes from how each person enters the space and from willingness to change a route for another way of seeing.',
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

const _luoyangParagraphs = <String>[
  '洛阳美术生唐墨答应替祖母在龙门石窟寻找一张旧照片中的佛龛。照片只剩半张脸，傍晚前他还要赶回学校交一幅奉先寺主像速写。',
  '他沿伊河辨认北魏到唐代不同的服饰、面容与雕刻风格，却发现祖母记错了山崖方向。继续寻找会失去交作业的时间，放弃则让家庭记忆停在模糊纸面。',
  '唐墨收起画板，改用照片残留的衣褶逐窟比对，终于在一处小佛龛旁找到同样石纹。那不是名作中心，却让祖母年轻时的站位重新有了尺度。',
  '他次日交了一张未完成的主像，补上岩壁、小龛与伊河，也标出工匠开凿、雕刻造像的细节。画面不够庄严，唐墨却知道艺术史也由普通人选择凝视哪里而延续。',
];

const _luoyangAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'luò yáng měi shù shēng táng mò dā ying tì zǔ mǔ zài lóng mén shí kū xún zhǎo yì zhāng jiù zhào piàn zhōng de fó kān 。 zhào piàn zhī shèng bàn zhāng liǎn ， bàng wǎn qián tā hái yào gǎn huí xué xiào jiāo yì fú fèng xiān sì zhǔ xiàng sù xiě 。', vietnamese: 'Sinh viên mỹ thuật Đường Mặc hứa giúp bà tìm một hốc tượng trong tấm ảnh cũ ở hang đá Long Môn. Ảnh chỉ còn nửa khuôn mặt, trong khi trước tối cậu còn phải nộp bản phác họa tượng chính ở Phụng Tiên Tự.', english: 'Art student Tang Mo promises to find the niche shown in his grandmother\'s old Longmen photograph. Only half a face remains in the picture, and he must still submit a sketch of Fengxian Temple\'s main figure before evening.'),
  ReadingAnnotation(pinyin: 'tā yán yī hé biàn rèn běi wèi dào táng dài bù tóng de fú shì 、 miàn róng yǔ diāo kè fēng gé ， què fā xiàn zǔ mǔ jì cuò le shān yá fāng xiàng 。 jì xù xún zhǎo huì shī qù jiāo zuò yè de shí jiān ， fàng qì zé ràng jiā tíng jì yì tíng zài mó hu zhǐ miàn 。', vietnamese: 'Dọc sông Y, cậu phân biệt trang phục, gương mặt và phong cách chạm khắc từ Bắc Ngụy đến Đường, rồi phát hiện bà nhớ nhầm phía vách đá. Tìm tiếp sẽ khiến cậu lỡ hạn; bỏ cuộc sẽ để ký ức gia đình mãi mơ hồ.', english: 'Along the Yi River, he compares dress, faces, and carving styles from the Northern Wei to the Tang, then realizes his grandmother remembered the wrong cliff. Continuing risks the deadline; quitting leaves the family memory blurred.'),
  ReadingAnnotation(pinyin: 'táng mò shōu qǐ huà bǎn ， gǎi yòng zhào piàn cán liú de yī zhě zhú kū bǐ duì ， zhōng yú zài yí chù xiǎo fó kān páng zhǎo dào tóng yàng shí wén 。 nà bú shì míng zuò zhōng xīn ， què ràng zǔ mǔ nián qīng shí de zhàn wèi chóng xīn yǒu le chǐ dù 。', vietnamese: 'Đường Mặc cất bảng vẽ, dùng nếp áo còn lại trong ảnh để so từng hang và tìm thấy vân đá giống nhau bên một hốc nhỏ. Đó không phải trung tâm của kiệt tác, nhưng giúp xác định lại nơi bà từng đứng khi còn trẻ.', english: 'Tang Mo puts away his drawing board and compares the surviving drapery fold cave by cave. He finds the same stone pattern beside a small niche—not a celebrated centerpiece, but enough to recover where his grandmother once stood.'),
  ReadingAnnotation(pinyin: 'tā cì rì jiāo le yì zhāng wèi wán chéng de zhǔ xiàng ， bǔ shàng yán bì 、 xiǎo kān yǔ yī hé ， yě biāo chū gōng jiàng kāi záo 、 diāo kè zào xiàng de xì jié 。 huà miàn bú gòu zhuāng yán ， táng mò què zhī dào yì shù shǐ yě yóu pǔ tōng rén xuǎn zé níng shì nǎ lǐ ér yán xù 。', vietnamese: 'Hôm sau, cậu nộp bức tượng chính chưa hoàn tất, bổ sung vách đá, hốc nhỏ, sông Y và chi tiết nghệ nhân tạc tượng. Bức vẽ kém trang nghiêm hơn, nhưng cậu hiểu lịch sử nghệ thuật cũng tiếp nối qua nơi người bình thường chọn nhìn.', english: 'The next day he submits an unfinished main figure, adding the cliff, small niche, Yi River, and details of artisans carving images. The drawing is less monumental, but he learns that art history also endures through what ordinary people choose to see.'),
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
  '泉州中学生蔡海要替祖父修复一只旧木箱，箱底夹着三种文字的货签。祖父坚持它来自开元寺附近的老铺，市场商人却说那只是仿古纪念品。',
  '蔡海沿东西石塔下的街巷寻找同样木纹，向不同信仰的邻居询问旧港贸易。每个人只认出货签的一部分；若急着选一个“正确来历”，就能赶上学校展览。',
  '他选择保留分歧，把木箱放在古树下请三位长者共同讲述。零散词语最终指向同一批海上货物，却仍无法证明具体店铺；蔡海在展签上诚实写下“来源未定”。',
  '祖父起初失望，后来把自己的记忆也署名为口述线索。蔡海懂得港口的多元不是把不同声音揉成一个答案，而是让海上交通、殿宇、石塔与街巷彼此作证。',
];

const _quanzhouAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'quán zhōu zhōng xué shēng cài hǎi yào tì zǔ fù xiū fù yì zhī jiù mù xiāng ， xiāng dǐ jiá zhe sān zhǒng wén zì de huò qiān 。 zǔ fù jiān chí tā lái zì kāi yuán sì fù jìn de lǎo pù ， shì chǎng shāng rén què shuō nà zhǐ shì fǎng gǔ jì niàn pǐn 。', vietnamese: 'Học sinh Thái Hải ở Tuyền Châu sửa một hòm gỗ cũ cho ông nội và tìm thấy nhãn hàng bằng ba thứ tiếng dưới đáy. Ông tin nó đến từ một cửa hiệu gần chùa Khai Nguyên, còn người bán ở chợ cho rằng đó chỉ là đồ lưu niệm giả cổ.', english: 'Quanzhou student Cai Hai repairs an old wooden chest for his grandfather and finds a cargo label in three languages underneath. His grandfather says it came from a shop near Kaiyuan Temple, while a market trader calls it a modern imitation.'),
  ReadingAnnotation(pinyin: 'cài hǎi yán dōng xī shí tǎ xià de jiē xiàng xún zhǎo tóng yàng mù wén ， xiàng bù tóng xìn yǎng de lín jū xún wèn jiù gǎng mào yì 。 měi gè rén zhī rèn chū huò qiān de yí bù fēn ； ruò jí zhe xuǎn yí gè “ zhèng què lái lì ”， jiù néng gǎn shàng xué xiào zhǎn lǎn 。', vietnamese: 'Thái Hải đi qua những ngõ dưới tháp đá đông tây để tìm cùng loại gỗ và hỏi các láng giềng thuộc nhiều tín ngưỡng về thương mại cảng xưa. Mỗi người chỉ đọc được một phần; chọn vội một nguồn gốc sẽ giúp cậu kịp triển lãm trường.', english: 'Cai Hai searches the lanes beneath the east and west pagodas for matching wood and asks neighbors of different faiths about the old port trade. Each recognizes only part of the label; choosing one origin quickly would make the school exhibition deadline.'),
  ReadingAnnotation(pinyin: 'tā xuǎn zé bǎo liú fēn qí ， bǎ mù xiāng fàng zài gǔ shù xià qǐng sān wèi zhǎng zhě gòng tóng jiǎng shù 。 líng sǎn cí yǔ zuì zhōng zhǐ xiàng tóng yì pī hǎi shàng huò wù ， què réng wú fǎ zhèng míng jù tǐ diàn pù ； cài hǎi zài zhǎn qiān shàng chéng shí xiě xià “ lái yuán wèi dìng ”。', vietnamese: 'Cậu giữ nguyên các ý kiến khác nhau, đặt hòm dưới cây cổ và mời ba người lớn tuổi cùng kể. Những từ rời rạc chỉ tới cùng một lô hàng biển nhưng không chứng minh được cửa hiệu; cậu ghi trung thực ‘chưa xác định nguồn’.', english: 'He preserves the disagreement, places the chest beneath an old tree, and invites three elders to speak together. The fragments point to one maritime shipment but not a specific shop, so he honestly labels the origin undetermined.'),
  ReadingAnnotation(pinyin: 'zǔ fù qǐ chū shī wàng ， hòu lái bǎ zì jǐ de jì yì yě shǔ míng wèi kǒu shù xiàn suǒ 。 cài hǎi dǒng de gǎng kǒu de duō yuán bú shì bǎ bù tóng shēng yīn róu chéng yí gè dá àn ， ér shì ràng hǎi shàng jiāo tōng 、 diàn yǔ 、 shí tǎ yǔ jiē xiàng bǐ cǐ zuò zhèng 。', vietnamese: 'Ông nội ban đầu thất vọng rồi ký tên ký ức của mình như một nguồn truyền khẩu. Thái Hải hiểu tính đa dạng của thành cảng không phải ép mọi giọng nói thành một đáp án, mà để giao thông biển, điện thờ, tháp đá và ngõ phố chứng thực lẫn nhau.', english: 'His grandfather is disappointed at first, then signs his memory as oral evidence. Cai Hai learns that a port\'s plurality does not force every voice into one answer; maritime travel, temple halls, pagodas, and lanes can testify alongside one another.'),
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
  title: '苏州 · 拙政园：在转身之间重新看见山水',
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
    storyTitle: '江南园林故事',
    headline: '在转身之间重新看见山水',
    description: '沿池水、长廊与漏窗，读懂苏州园林怎样创造空间层次。',
    discoveryTeaser: '小小园林为什么让人感觉走进大片山水？',
    distanceLabel: '1,820 km',
    stampSymbol: '园',
    content: suzhouGardenJourney,
    storyAnnotations: _suzhouAnnotations,
    words: _suzhouWords,
    discoveries: _suzhouDiscoveries,
    wonderQuestion: '如果你能用一扇漏窗框住园中的景色，你会选择水面、竹影还是亭子？为什么？',
    expressQuestion: '请用两到三句话描写你走进拙政园时最先注意到的景色。',
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
