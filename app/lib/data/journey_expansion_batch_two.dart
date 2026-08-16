import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'datong_yungang_gold_content.dart';
import 'journey_data.dart';

const journeyExpansionBatchTwoSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-datong-yungang-grottoes',
    title: 'Yungang Grottoes',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1039',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-shanxi-datong-yungang-yungang-grottoes'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'ncha-datong-yungang-grottoes',
    title: '云冈石窟',
    publisher: '国家文物局',
    url: 'https://www.ncha.gov.cn/art/2024/8/8/art_2791_190647.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-shanxi-datong-yungang-yungang-grottoes'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-lijiang-old-town',
    title: 'Old Town of Lijiang',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/811',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-yunnan-lijiang-gucheng-dayan-old-town'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'yunnan-lijiang-old-town',
    title: '古城水韵融四方',
    publisher: '云南省文化和旅游厅',
    url: 'https://dct.yn.gov.cn/html/2511/20_42044.shtml',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-yunnan-lijiang-gucheng-dayan-old-town'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
];

JourneyContentRecord _record({
  required String id,
  required String title,
  required String geoNodeId,
  required List<String> paragraphs,
  required List<String> sources,
  required List<String> tags,
}) =>
    JourneyContentRecord(
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
          sourceIds: sources,
        ),
      ),
    );

// Legacy seed retained only as an inactive migration reference.
// ignore: unused_element
const _datongParagraphs = <String>[
  '午后的光落在大同武州山南麓。你沿着崖壁前行，一座座洞窟在砂岩中展开，远看像沉默的门，近看却布满细密的雕刻。',
  '云冈石窟主要开凿于北魏时期。来自不同地方的工匠在这里相遇，把造像、衣纹、飞天与建筑图案刻进山体，也留下文化交流的痕迹。',
  '走到昙曜五窟附近，巨大的造像与洞窟空间形成庄严尺度。抬头观察，面容、手势与衣褶并不相同，每一处细节都回应着时代审美。',
  '石窟经历漫长岁月，风与水仍会影响岩体。今天的参观不仅是看古代艺术，也是在理解人们如何用研究、记录和修复守护这座石头史书。',
];

// ignore: unused_element
const _datongAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Wǔhòu de guāng luò zài Dàtóng Wǔzhōu Shān nánlù. Nǐ yánzhe yábì qiánxíng, yí zuò zuò dòngkū zài shāyán zhōng zhǎnkāi, yuǎn kàn xiàng chénmò de mén, jìn kàn què bùmǎn xìmì de diāokè.', vietnamese: 'Ánh chiều rơi xuống sườn nam núi Vũ Châu ở Đại Đồng. Dọc vách đá, những hang động mở ra với các chi tiết chạm khắc dày đặc.', english: 'Afternoon light reaches Wuzhou Mountain as carved caves unfold along the sandstone cliff.'),
  ReadingAnnotation(pinyin: 'Yúngāng Shíkū zhǔyào kāizáo yú Běiwèi shíqī. Láizì bùtóng dìfāng de gōngjiàng zài zhèlǐ xiāngyù, bǎ zàoxiàng, yīwén, fēitiān yǔ jiànzhù tú àn kè jìn shāntǐ.', vietnamese: 'Vân Cương chủ yếu được đục tạc thời Bắc Ngụy; nghệ nhân từ nhiều nơi để lại tượng, nếp áo và hoa văn kiến trúc.', english: 'Artisans of the Northern Wei carved figures, drapery, flying beings, and architectural patterns into the mountain.'),
  ReadingAnnotation(pinyin: 'Zǒudào Tányào Wǔkū fùjìn, jùdà de zàoxiàng yǔ dòngkū kōngjiān xíngchéng zhuāngyán chǐdù. Měi yí chù xìjié dōu huíyìngzhe shídài shěnměi.', vietnamese: 'Gần năm hang Đàm Diệu, tượng lớn và không gian hang tạo nên quy mô trang nghiêm; từng chi tiết phản ánh thẩm mỹ thời đại.', english: 'Near the Five Caves of Tanyao, monumental figures and subtle details reveal the aesthetics of an era.'),
  ReadingAnnotation(pinyin: 'Shíkū jīnglì màncháng suìyuè, fēng yǔ shuǐ réng huì yǐngxiǎng yántǐ. Jīntiān de cānguān yě shì zài lǐjiě rénmen rúhé shǒuhù zhè zuò shítou shǐshū.', vietnamese: 'Gió và nước vẫn tác động lên đá; tham quan hôm nay cũng là hiểu cách nghiên cứu và tu bổ bảo vệ cuốn sử bằng đá này.', english: 'Wind and water still affect the rock, making documentation and conservation part of the visit.'),
];

// ignore: unused_element
const _datongWords = <WordEntry>[
  WordEntry(word: '崖壁', pinyin: 'yábì', partOfSpeech: '名词', simpleChinese: '陡直的山崖表面。', translation: 'Bề mặt vách núi dựng đứng.', englishDefinition: 'cliff face', symbol: '⛰️'),
  WordEntry(word: '洞窟', pinyin: 'dòngkū', partOfSpeech: '名词', simpleChinese: '在山体中开出的空间。', translation: 'Hang được tạo trong núi.', englishDefinition: 'rock-cut cave', symbol: '🪨'),
  WordEntry(word: '砂岩', pinyin: 'shāyán', partOfSpeech: '名词', simpleChinese: '由沙粒形成的岩石。', translation: 'Đá sa thạch.', englishDefinition: 'sandstone', symbol: '🟤'),
  WordEntry(word: '开凿', pinyin: 'kāizáo', partOfSpeech: '动词', simpleChinese: '挖掘并形成空间。', translation: 'Đào và tạo không gian.', englishDefinition: 'to excavate', symbol: '⛏️'),
  WordEntry(word: '工匠', pinyin: 'gōngjiàng', partOfSpeech: '名词', simpleChinese: '有专门手艺的人。', translation: 'Nghệ nhân có tay nghề.', englishDefinition: 'artisan', symbol: '🛠️'),
  WordEntry(word: '衣纹', pinyin: 'yīwén', partOfSpeech: '名词', simpleChinese: '雕像衣服上的褶纹。', translation: 'Nếp áo trên tượng.', englishDefinition: 'carved drapery folds', symbol: '〰️'),
  WordEntry(word: '飞天', pinyin: 'fēitiān', partOfSpeech: '名词', simpleChinese: '石窟艺术中的飞行形象。', translation: 'Hình tượng bay trong nghệ thuật hang đá.', englishDefinition: 'flying celestial figure', symbol: '🪽'),
  WordEntry(word: '庄严', pinyin: 'zhuāngyán', partOfSpeech: '形容词', simpleChinese: '严肃而令人尊敬。', translation: 'Trang nghiêm.', englishDefinition: 'solemn', symbol: '✨'),
  WordEntry(word: '修复', pinyin: 'xiūfù', partOfSpeech: '动词', simpleChinese: '把受损部分保护并恢复。', translation: 'Tu bổ phần bị hư hại.', englishDefinition: 'to conserve and restore', symbol: '🧰'),
];

// ignore: unused_element
const _datongDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '云冈石窟的主要洞窟开凿于公元五至六世纪。', pinyin: 'Yúngāng Shíkū de zhǔyào dòngkū kāizáo yú gōngyuán wǔ zhì liù shìjì.', simpleChinese: '主要洞窟来自五到六世纪。', vietnamese: 'Các hang chính được tạc vào thế kỷ V–VI.', english: 'The principal caves were carved in the fifth and sixth centuries.'),
  DiscoveryEntry(text: '昙曜五窟以统一的空间与造像设计成为云冈的重要代表。', pinyin: 'Tányào Wǔkū yǐ tǒngyī de kōngjiān yǔ zàoxiàng shèjì chéngwéi Yúngāng de zhòngyào dàibiǎo.', simpleChinese: '昙曜五窟的设计非常完整。', vietnamese: 'Năm hang Đàm Diệu nổi bật nhờ thiết kế không gian và tượng thống nhất.', english: 'The Five Caves of Tanyao are notable for coherent spatial and sculptural design.'),
  DiscoveryEntry(text: '造像风格体现了多种艺术传统在北魏平城的交流。', pinyin: 'Zàoxiàng fēnggé tǐxiàn le duō zhǒng yìshù chuántǒng zài Běiwèi Píngchéng de jiāoliú.', simpleChinese: '不同艺术传统在这里相遇。', vietnamese: 'Phong cách tượng cho thấy nhiều truyền thống nghệ thuật gặp nhau tại Bình Thành.', english: 'The sculptures show multiple artistic traditions meeting at Northern Wei Pingcheng.'),
  DiscoveryEntry(text: '数字记录、环境监测与岩体修复共同参与石窟保护。', pinyin: 'Shùzì jìlù, huánjìng jiāncè yǔ yántǐ xiūfù gòngtóng cānyù shíkū bǎohù.', simpleChinese: '保护需要记录、监测和修复。', vietnamese: 'Bảo tồn kết hợp ghi chép số, quan trắc môi trường và tu bổ đá.', english: 'Digital records, environmental monitoring, and rock conservation work together.'),
];

const _lijiangParagraphs = <String>[
  '雨后的傍晚，你走进丽江大研古城。石板路顺着地势起伏，清水穿过街巷，在小桥下分成多条水道，灯影随着水面轻轻移动。',
  '丽江古城没有整齐的棋盘格。道路、水系和院落适应山地，自然地连接四方街、住宅与市场，让城市像一张沿水生长的网络。',
  '这里曾是茶马古道上的交流节点。纳西、汉、藏、白等不同文化长期往来，建筑、语言、音乐和生活方式因此留下彼此影响的痕迹。',
  '古城仍有人生活，也面对商业与保护之间的压力。真正的旅程不只寻找漂亮屋顶，更要听见流水、居民日常和传统技艺共同组成的城市声音。',
];

const _lijiangAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Yǔhòu de bàngwǎn, nǐ zǒujìn Lìjiāng Dàyán Gǔchéng. Shíbǎnlù shùnzhe dìshì qǐfú, qīngshuǐ chuānguò jiēxiàng, zài xiǎoqiáo xià fēnchéng duō tiáo shuǐdào.', vietnamese: 'Chiều sau mưa, bạn bước vào Đại Nghiên cổ trấn. Đường đá theo địa hình và dòng nước chia thành nhiều nhánh dưới cầu nhỏ.', english: 'After rain, stone lanes and clear channels wind through Dayan Old Town.'),
  ReadingAnnotation(pinyin: 'Lìjiāng Gǔchéng méiyǒu zhěngqí de qípángé. Dàolù, shuǐxì hé yuànluò shìyìng shāndì, ràng chéngshì xiàng yì zhāng yán shuǐ shēngzhǎng de wǎngluò.', vietnamese: 'Cổ thành không theo ô bàn cờ; đường, nước và sân nhà thích ứng địa hình như một mạng lưới lớn lên theo dòng nước.', english: 'Roads, waterways, and courtyards adapt to the terrain rather than a rigid grid.'),
  ReadingAnnotation(pinyin: 'Zhèlǐ céng shì Chámǎ Gǔdào shàng de jiāoliú jiédiǎn. Bùtóng wénhuà chángqī wǎnglái, liúxià bǐcǐ yǐngxiǎng de hénjì.', vietnamese: 'Đây từng là nút giao trên Trà Mã Cổ Đạo, nơi nhiều nền văn hóa để lại ảnh hưởng lẫn nhau.', english: 'As a Tea Horse Road hub, Lijiang connected several peoples and cultural traditions.'),
  ReadingAnnotation(pinyin: 'Gǔchéng réng yǒu rén shēnghuó, yě miànduì shāngyè yǔ bǎohù zhījiān de yālì. Lǚchéng yě yào tīngjiàn jūmín rìcháng yǔ chuántǒng jìyì.', vietnamese: 'Cổ thành vẫn là nơi sinh sống và phải cân bằng thương mại với bảo tồn; hãy lắng nghe đời sống cư dân và nghề truyền thống.', english: 'The living town must balance commerce with conservation and resident life.'),
];

const _lijiangWords = <WordEntry>[
  WordEntry(word: '石板路', pinyin: 'shíbǎnlù', partOfSpeech: '名词', simpleChinese: '用石板铺成的道路。', translation: 'Đường lát đá.', englishDefinition: 'stone-paved lane', symbol: '🧱'),
  WordEntry(word: '街巷', pinyin: 'jiēxiàng', partOfSpeech: '名词', simpleChinese: '街道和小巷。', translation: 'Đường phố và ngõ nhỏ.', englishDefinition: 'streets and lanes', symbol: '🏘️'),
  WordEntry(word: '水道', pinyin: 'shuǐdào', partOfSpeech: '名词', simpleChinese: '让水流过的通道。', translation: 'Kênh dẫn nước.', englishDefinition: 'water channel', symbol: '💧'),
  WordEntry(word: '棋盘格', pinyin: 'qípángé', partOfSpeech: '名词', simpleChinese: '像棋盘一样整齐的格子。', translation: 'Mạng lưới ô bàn cờ.', englishDefinition: 'grid pattern', symbol: '▦'),
  WordEntry(word: '院落', pinyin: 'yuànluò', partOfSpeech: '名词', simpleChinese: '房屋围成的院子空间。', translation: 'Khoảng sân có nhà bao quanh.', englishDefinition: 'courtyard compound', symbol: '🏡'),
  WordEntry(word: '地势', pinyin: 'dìshì', partOfSpeech: '名词', simpleChinese: '地面的高低形态。', translation: 'Địa thế cao thấp.', englishDefinition: 'terrain', symbol: '🗻'),
  WordEntry(word: '节点', pinyin: 'jiédiǎn', partOfSpeech: '名词', simpleChinese: '网络中重要的连接位置。', translation: 'Điểm kết nối quan trọng.', englishDefinition: 'network hub', symbol: '🔗'),
  WordEntry(word: '往来', pinyin: 'wǎnglái', partOfSpeech: '动词', simpleChinese: '互相来往和交流。', translation: 'Qua lại và giao lưu.', englishDefinition: 'to interact and travel between', symbol: '🐎'),
  WordEntry(word: '技艺', pinyin: 'jìyì', partOfSpeech: '名词', simpleChinese: '经过学习形成的手艺。', translation: 'Kỹ nghệ truyền thống.', englishDefinition: 'craft skill', symbol: '🪡'),
];

const _lijiangDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '丽江古城的道路与水系顺应山地环境，没有采用规则棋盘格。', pinyin: 'Lìjiāng Gǔchéng de dàolù yǔ shuǐxì shùnyìng shāndì huánjìng, méiyǒu cǎiyòng guīzé qípángé.', simpleChinese: '道路和水系跟着地形变化。', vietnamese: 'Đường và kênh nước thích ứng địa hình thay vì theo ô bàn cờ.', english: 'The street and water networks adapt to mountain terrain rather than a fixed grid.'),
  DiscoveryEntry(text: '大研、白沙与束河共同构成世界遗产丽江古城。', pinyin: 'Dàyán, Báishā yǔ Shùhé gòngtóng gòuchéng Shìjiè Yíchǎn Lìjiāng Gǔchéng.', simpleChinese: '三个城镇共同组成遗产。', vietnamese: 'Đại Nghiên, Bạch Sa và Thúc Hà cùng tạo thành di sản.', english: 'Dayan, Baisha, and Shuhe together form the World Heritage property.'),
  DiscoveryEntry(text: '古城水系至今仍参与居民生活与街区环境。', pinyin: 'Gǔchéng shuǐxì zhìjīn réng cānyù jūmín shēnghuó yǔ jiēqū huánjìng.', simpleChinese: '流水现在仍服务古城生活。', vietnamese: 'Hệ thống nước vẫn gắn với đời sống và môi trường khu phố.', english: 'The historic water system still supports daily life and the urban environment.'),
  DiscoveryEntry(text: '茶马古道让丽江成为多民族经济与文化交流节点。', pinyin: 'Chámǎ Gǔdào ràng Lìjiāng chéngwéi duō mínzú jīngjì yǔ wénhuà jiāoliú jiédiǎn.', simpleChinese: '茶马古道连接了不同人群。', vietnamese: 'Trà Mã Cổ Đạo biến Lệ Giang thành nút giao kinh tế và văn hóa đa dân tộc.', english: 'The Tea Horse Road made Lijiang a hub of multi-ethnic exchange.'),
];

final datongYungangJourney = _record(
  id: 'datong-yungang-grottoes',
  title: '大同 · 云冈石窟：听见北魏刻进山崖的回声',
  geoNodeId: 'cn-shanxi-datong-yungang-yungang-grottoes',
  paragraphs: datongYungangGoldLevelContent(5).storyParagraphs,
  sources: const ['unesco-datong-yungang-grottoes', 'ncha-datong-yungang-grottoes'],
  tags: const ['大同', '云冈石窟', '北魏', '石刻', '世界遗产'],
);

final lijiangOldTownJourney = _record(
  id: 'lijiang-old-town',
  title: '丽江 · 大研古城：沿流水读懂山地城市',
  geoNodeId: 'cn-yunnan-lijiang-gucheng-dayan-old-town',
  paragraphs: _lijiangParagraphs,
  sources: const ['unesco-lijiang-old-town', 'yunnan-lijiang-old-town'],
  tags: const ['丽江', '大研古城', '纳西文化', '茶马古道', '水系'],
);

final journeyExpansionBatchTwoRecords = <JourneyContentRecord>[
  datongYungangJourney,
  lijiangOldTownJourney,
];

final journeyExpansionBatchTwoExperiences = <DailyJourneyExperience>[
  DailyJourneyExperience(
    id: datongYungangJourney.id,
    city: '大同',
    cityCode: 'DAT',
    place: '云冈石窟',
    appBarTitle: '大同 · 云冈石窟',
    storyTitle: datongYungangCanonicalTitle,
    headline: datongYungangHeadline,
    description: datongYungangDescription,
    discoveryTeaser: datongYungangDiscoveryTeaser,
    distanceLabel: '1,620 km',
    stampSymbol: '云',
    content: datongYungangJourney,
    storyAnnotations: datongYungangGoldLevelContent(5).storyAnnotations,
    words: datongYungangGoldLevelContent(5).words,
    discoveries: datongYungangGoldLevelContent(5).discoveries,
    wonderQuestion: datongYungangGoldLevelContent(5).wonderQuestion,
    expressQuestion: datongYungangGoldLevelContent(5).expressQuestion,
  ),
  DailyJourneyExperience(
    id: lijiangOldTownJourney.id,
    city: '丽江',
    cityCode: 'LJG',
    place: '大研古城',
    appBarTitle: '丽江 · 大研古城',
    storyTitle: '茶马古道故事',
    headline: '沿流水读懂山地城市',
    description: '跟随石板路与水道，理解古城如何连接地形、贸易与多民族生活。',
    discoveryTeaser: '没有规则棋盘格，丽江古城为什么仍能高效运作？',
    distanceLabel: '1,460 km',
    stampSymbol: '水',
    content: lijiangOldTownJourney,
    storyAnnotations: _lijiangAnnotations,
    words: _lijiangWords,
    discoveries: _lijiangDiscoveries,
    wonderQuestion: '如果你住在古城，你希望水道继续承担哪些日常功能？',
    expressQuestion: '请用两到三句话描写雨后石板路、流水与木屋的声音和光线。',
  ),
];
