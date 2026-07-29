import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchThreeSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-dunhuang-mogao-caves',
    title: 'Mogao Caves',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/440',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-gansu-jiuquan-dunhuang-mogao-caves'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'dunhuang-academy-mogao-caves',
    title: '莫高窟概况',
    publisher: '敦煌研究院',
    url: 'https://www.dha.ac.cn/info/1425/3659.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-gansu-jiuquan-dunhuang-mogao-caves'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-chengde-mountain-resort',
    title: 'Mountain Resort and its Outlying Temples, Chengde',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/703',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-hebei-chengde-shuangqiao-mountain-resort'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'chengde-government-mountain-resort',
    title: '承德避暑山庄及周围寺庙',
    publisher: '承德市人民政府',
    url: 'https://www.chengde.gov.cn/art/2025/8/25/art_400_1080161.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-hebei-chengde-shuangqiao-mountain-resort'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-xiamen-kulangsu',
    title: 'Kulangsu, a Historic International Settlement',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1541',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-fujian-xiamen-siming-kulangsu'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'fujian-government-kulangsu',
    title: '鼓浪屿：历史国际社区',
    publisher: '福建省人民政府',
    url: 'https://fj.gov.cn/zwgk/ztzl/sxzygwzxsgzx/sdjj/wvjj/202408/t20240830_6508715.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-fujian-xiamen-siming-kulangsu'],
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

const _dunhuangParagraphs = <String>[
  '清晨，你从敦煌城向东南出发。鸣沙山余脉渐渐靠近，宕泉河边的树木映出一线绿色，莫高窟的崖壁在晨光里缓缓显现。',
  '洞窟沿崖壁分布约两公里。这里的砾岩不适合直接雕刻，古代工匠先塑造泥质造像，再以壁画铺开人物、建筑与旅途中的故事。',
  '从公元四世纪起，不同年代的营造持续了约一千年。丝绸之路上的商旅、语言与信仰在敦煌交汇，使四百九十二个洞窟成为文化交流的见证。',
  '壁画与造像对光线、湿度和风沙十分敏感。今天，参观者需要遵守限流与保护规则，也能通过数字记录理解研究者如何守护这座沙漠艺术宝库。',
];

const _dunhuangAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Qīngchén, nǐ cóng Dūnhuáng Chéng xiàng dōngnán chūfā. Míngshā Shān yúmài jiànjiàn kàojìn, Dàngquán Hé biān de shùmù yìngchū yí xiàn lǜsè, Mògāo Kū de yábì zài chénguāng lǐ huǎnhuǎn xiǎnxiàn.', vietnamese: 'Sáng sớm, bạn rời Đôn Hoàng về phía đông nam; vách Mạc Cao dần hiện ra bên dải xanh của sông Đãng Tuyền.', english: 'At dawn, the Mogao cliff emerges beyond the green ribbon of the Dangquan River.'),
  ReadingAnnotation(pinyin: 'Dòngkū yán yábì fēnbù yuē liǎng gōnglǐ. Zhèlǐ de lìyán bù shìhé zhíjiē diāokè, gǔdài gōngjiàng xiān sùzào nízhì zàoxiàng, zài yǐ bìhuà pūkāi gùshì.', vietnamese: 'Các hang trải dọc vách khoảng hai kilômét; đá cuội kết không thích hợp để tạc nên nghệ nhân dùng tượng đất và bích họa.', english: 'Because the conglomerate cliff could not be finely carved, artisans used clay figures and wall paintings.'),
  ReadingAnnotation(pinyin: 'Cóng gōngyuán sì shìjì qǐ, bùtóng niándài de yíngzào chíxù le yuē yì qiān nián. Sīchóu Zhīlù shàng de shānglǚ, yǔyán yǔ xìnyǎng zài Dūnhuáng jiāohuì.', vietnamese: 'Từ thế kỷ IV, việc kiến tạo kéo dài khoảng một nghìn năm; thương nhân, ngôn ngữ và tín ngưỡng trên Con đường Tơ lụa gặp nhau tại đây.', english: 'A millennium of construction records the meeting of travellers, languages, and beliefs on the Silk Road.'),
  ReadingAnnotation(pinyin: 'Bìhuà yǔ zàoxiàng duì guāngxiàn, shīdù hé fēngshā shífēn mǐngǎn. Shùzì jìlù bāngzhù rénmen lǐjiě rúhé shǒuhù zhè zuò shāmò yìshù bǎokù.', vietnamese: 'Bích họa và tượng rất nhạy với ánh sáng, độ ẩm và cát gió; ghi chép số hỗ trợ công tác bảo tồn.', english: 'Light, humidity, and sand threaten the art, while digital records support conservation.'),
];

const _dunhuangWords = <WordEntry>[
  WordEntry(word: '余脉', pinyin: 'yúmài', partOfSpeech: '名词', simpleChinese: '大山延伸出来的山脉。', translation: 'Dãy núi kéo dài từ núi chính.', englishDefinition: 'outlying mountain range', symbol: '⛰️'),
  WordEntry(word: '崖壁', pinyin: 'yábì', partOfSpeech: '名词', simpleChinese: '陡直的山崖表面。', translation: 'Vách núi dựng đứng.', englishDefinition: 'cliff face', symbol: '🪨'),
  WordEntry(word: '砾岩', pinyin: 'lìyán', partOfSpeech: '名词', simpleChinese: '由小石块组成的岩石。', translation: 'Đá cuội kết.', englishDefinition: 'conglomerate rock', symbol: '🟤'),
  WordEntry(word: '造像', pinyin: 'zàoxiàng', partOfSpeech: '名词', simpleChinese: '塑造出来的人物形象。', translation: 'Tượng được tạo hình.', englishDefinition: 'sculpted figure', symbol: '🏺'),
  WordEntry(word: '壁画', pinyin: 'bìhuà', partOfSpeech: '名词', simpleChinese: '画在墙壁上的图画。', translation: 'Tranh tường.', englishDefinition: 'mural', symbol: '🎨'),
  WordEntry(word: '营造', pinyin: 'yíngzào', partOfSpeech: '动词', simpleChinese: '规划并建造。', translation: 'Quy hoạch và xây dựng.', englishDefinition: 'to build and create', symbol: '🛠️'),
  WordEntry(word: '商旅', pinyin: 'shānglǚ', partOfSpeech: '名词', simpleChinese: '旅行经商的人。', translation: 'Thương nhân lữ hành.', englishDefinition: 'travelling merchants', symbol: '🐫'),
  WordEntry(word: '交汇', pinyin: 'jiāohuì', partOfSpeech: '动词', simpleChinese: '从不同方向相遇。', translation: 'Gặp nhau từ nhiều hướng.', englishDefinition: 'to converge', symbol: '🔀'),
  WordEntry(word: '湿度', pinyin: 'shīdù', partOfSpeech: '名词', simpleChinese: '空气中水分的多少。', translation: 'Độ ẩm không khí.', englishDefinition: 'humidity', symbol: '💧'),
];

const _dunhuangDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '莫高窟保存四百九十二个洞窟，艺术营造跨越约一千年。', pinyin: 'Mògāo Kū bǎocún sìbǎi jiǔshí èr gè dòngkū, yìshù yíngzào kuàyuè yuē yì qiān nián.', simpleChinese: '这里有四百九十二个洞窟。', vietnamese: 'Mạc Cao lưu giữ 492 hang động qua khoảng một nghìn năm.', english: 'Mogao preserves 492 caves created across roughly a millennium.'),
  DiscoveryEntry(text: '砾岩崖壁不适合精细雕刻，因此工匠发展出泥质造像与壁画。', pinyin: 'Lìyán yábì bù shìhé jīngxì diāokè, yīncǐ gōngjiàng fāzhǎnchū nízhì zàoxiàng yǔ bìhuà.', simpleChinese: '岩石条件影响了艺术方法。', vietnamese: 'Đá cuội kết khiến nghệ nhân phát triển tượng đất và bích họa.', english: 'The conglomerate cliff encouraged clay sculpture and mural painting.'),
  DiscoveryEntry(text: '敦煌位于丝绸之路交汇处，商旅带来多种文化与信仰。', pinyin: 'Dūnhuáng wèiyú Sīchóu Zhīlù jiāohuìchù, shānglǚ dàilái duō zhǒng wénhuà yǔ xìnyǎng.', simpleChinese: '丝绸之路让不同文化在敦煌相遇。', vietnamese: 'Vị trí trên Con đường Tơ lụa đưa nhiều văn hóa và tín ngưỡng đến Đôn Hoàng.', english: 'Silk Road travellers brought diverse cultures and beliefs to Dunhuang.'),
  DiscoveryEntry(text: '环境监测与数字记录帮助研究者控制湿度、光线和风沙风险。', pinyin: 'Huánjìng jiāncè yǔ shùzì jìlù bāngzhù yánjiūzhě kòngzhì shīdù, guāngxiàn hé fēngshā fēngxiǎn.', simpleChinese: '科技参与洞窟保护。', vietnamese: 'Quan trắc và số hóa giúp kiểm soát độ ẩm, ánh sáng và cát gió.', english: 'Monitoring and digital records help manage humidity, light, and sand risks.'),
];

const _chengdeParagraphs = <String>[
  '薄雾从山谷升起，你沿湖岸走进承德避暑山庄。荷叶贴近水面，远处亭榭顺着山势展开，宫殿没有压过自然，反而藏在林木与坡地之间。',
  '山庄始建于清代，宫殿区、湖泊区、平原区和山峦区组成一座规模宏大的皇家园林。道路与建筑借助天然地形，让景色在移动中不断变化。',
  '山庄周围的寺庙采用不同地区的建筑形式。它们与清代多民族交往有关，也让承德成为观察政治、宗教与建筑文化如何相遇的重要地点。',
  '今天，湖水、植被、古建筑与远处山体仍是一个整体。保护山庄不仅要修缮屋瓦，也要维护视线、生态和历史格局之间的平衡。',
];

const _chengdeAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Bówù cóng shāngǔ shēngqǐ, nǐ yán húàn zǒujìn Chéngdé Bìshǔ Shānzhuāng. Tíngxiè shùnzhe shānshì zhǎnkāi, gōngdiàn cáng zài línmù yǔ pōdì zhījiān.', vietnamese: 'Sương mỏng dâng từ thung lũng; đình tạ theo thế núi và cung điện ẩn giữa rừng cây, sườn dốc.', english: 'Mist rises as pavilions and palaces settle gently into the wooded terrain.'),
  ReadingAnnotation(pinyin: 'Shānzhuāng shǐjiàn yú Qīngdài, gōngdiànqū, húpōqū, píngyuánqū hé shānluánqū zǔchéng yí zuò guīmó hóngdà de huángjiā yuánlín.', vietnamese: 'Sơn trang hình thành thời Thanh với khu cung điện, hồ, đồng bằng và núi đồi.', english: 'Palace, lake, plain, and mountain zones form a vast Qing imperial garden.'),
  ReadingAnnotation(pinyin: 'Shānzhuāng zhōuwéi de sìmiào cǎiyòng bùtóng dìqū de jiànzhù xíngshì, ràng Chéngdé chéngwéi guānchá zhèngzhì, zōngjiào yǔ jiànzhù wénhuà jiāoliú de dìdiǎn.', vietnamese: 'Các chùa quanh sơn trang dùng nhiều hình thức vùng miền, phản ánh giao lưu chính trị, tôn giáo và kiến trúc.', english: 'The surrounding temples reflect regional traditions and multi-ethnic exchange.'),
  ReadingAnnotation(pinyin: 'Bǎohù Shānzhuāng bùjǐn yào xiūshàn wūwǎ, yě yào wéihù shìxiàn, shēngtài hé lìshǐ géjú zhījiān de pínghéng.', vietnamese: 'Bảo tồn không chỉ sửa mái ngói mà còn giữ cân bằng giữa tầm nhìn, sinh thái và bố cục lịch sử.', english: 'Conservation protects roofs as well as views, ecology, and the historic layout.'),
];

const _chengdeWords = <WordEntry>[
  WordEntry(word: '薄雾', pinyin: 'bówù', partOfSpeech: '名词', simpleChinese: '比较淡的雾。', translation: 'Làn sương mỏng.', englishDefinition: 'light mist', symbol: '🌫️'),
  WordEntry(word: '亭榭', pinyin: 'tíngxiè', partOfSpeech: '名词', simpleChinese: '园林中的亭子和水边建筑。', translation: 'Đình và thủy tạ trong vườn.', englishDefinition: 'garden pavilions', symbol: '🏯'),
  WordEntry(word: '山势', pinyin: 'shānshì', partOfSpeech: '名词', simpleChinese: '山地高低变化的形态。', translation: 'Thế núi.', englishDefinition: 'mountain terrain', symbol: '⛰️'),
  WordEntry(word: '山峦', pinyin: 'shānluán', partOfSpeech: '名词', simpleChinese: '连续起伏的山。', translation: 'Những dãy núi nối tiếp.', englishDefinition: 'mountain ridges', symbol: '🗻'),
  WordEntry(word: '园林', pinyin: 'yuánlín', partOfSpeech: '名词', simpleChinese: '结合建筑和自然景色的园子。', translation: 'Vườn cảnh kết hợp kiến trúc và thiên nhiên.', englishDefinition: 'landscape garden', symbol: '🌿'),
  WordEntry(word: '地形', pinyin: 'dìxíng', partOfSpeech: '名词', simpleChinese: '地面的高低和形状。', translation: 'Địa hình.', englishDefinition: 'topography', symbol: '🗺️'),
  WordEntry(word: '寺庙', pinyin: 'sìmiào', partOfSpeech: '名词', simpleChinese: '进行宗教活动的建筑。', translation: 'Chùa, đền tôn giáo.', englishDefinition: 'temple', symbol: '🛕'),
  WordEntry(word: '修缮', pinyin: 'xiūshàn', partOfSpeech: '动词', simpleChinese: '修理并保护旧建筑。', translation: 'Tu bổ công trình cũ.', englishDefinition: 'to repair and conserve', symbol: '🧰'),
  WordEntry(word: '格局', pinyin: 'géjú', partOfSpeech: '名词', simpleChinese: '整体的结构和安排。', translation: 'Bố cục tổng thể.', englishDefinition: 'overall layout', symbol: '▦'),
];

const _chengdeDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '避暑山庄把宫殿、湖泊、平原与山峦组织成完整的皇家园林。', pinyin: 'Bìshǔ Shānzhuāng bǎ gōngdiàn, húpō, píngyuán yǔ shānluán zǔzhīchéng wánzhěng de huángjiā yuánlín.', simpleChinese: '四种景观组成一座大园林。', vietnamese: 'Cung điện, hồ, đồng bằng và núi đồi hợp thành một khu vườn hoàng gia.', english: 'Palace, lakes, plains, and mountains form one imperial landscape.'),
  DiscoveryEntry(text: '建筑顺应天然地形，使亭榭、道路与山水彼此连接。', pinyin: 'Jiànzhù shùnyìng tiānrán dìxíng, shǐ tíngxiè, dàolù yǔ shānshuǐ bǐcǐ liánjiē.', simpleChinese: '建筑跟着地形变化。', vietnamese: 'Kiến trúc thuận theo địa hình để nối đình, đường và cảnh quan.', english: 'Architecture follows the terrain, linking pavilions, paths, and scenery.'),
  DiscoveryEntry(text: '周围寺庙的多样形式记录了清代多民族交往。', pinyin: 'Zhōuwéi sìmiào de duōyàng xíngshì jìlù le Qīngdài duō mínzú jiāowǎng.', simpleChinese: '寺庙记录了不同文化的交流。', vietnamese: 'Nhiều hình thức chùa ghi lại giao lưu đa dân tộc thời Thanh.', english: 'The varied temples record multi-ethnic exchange during the Qing dynasty.'),
  DiscoveryEntry(text: '遗产保护同时关注古建筑修缮、生态环境与历史格局。', pinyin: 'Yíchǎn bǎohù tóngshí guānzhù gǔjiànzhù xiūshàn, shēngtài huánjìng yǔ lìshǐ géjú.', simpleChinese: '保护建筑，也保护周围环境。', vietnamese: 'Bảo tồn chú trọng cả tu bổ, sinh thái và bố cục lịch sử.', english: 'Heritage care includes buildings, ecology, and the historic layout.'),
];

const _xiamenParagraphs = <String>[
  '海风穿过榕树枝叶，你从码头走进厦门鼓浪屿。石阶沿坡地转弯，红砖、花岗岩与浅色廊柱在树影中交替出现，巷口偶尔露出一片海面。',
  '十九世纪中期厦门开港后，鼓浪屿逐渐成为国际社区。不同国家和地区的居民在岛上生活，住宅、学校、医院与公共空间共同塑造新的城市肌理。',
  '这里的建筑不是单一风格。闽南传统、中原文化、南洋经验与西方形式经过本地工匠调整，形成适应海岛气候的折衷设计。',
  '鼓浪屿仍是一座可步行的生活社区。保护不只是保存漂亮立面，也要维护巷道尺度、树木、海岸视线和居民日常，让文化融合继续被读懂。',
];

const _xiamenAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Hǎifēng chuānguò róngshù zhīyè, nǐ cóng mǎtóu zǒujìn Xiàmén Gǔlàngyǔ. Shíjiē yán pōdì zhuǎnwān, hóngzhuān, huāgāngyán yǔ qiǎnsè lángzhù zài shùyǐng zhōng jiāotì chūxiàn.', vietnamese: 'Gió biển xuyên qua tán đa; bậc đá, gạch đỏ, đá hoa cương và hành lang sáng màu nối nhau trên sườn đảo.', english: 'Sea breeze, stone steps, red brick, granite, and verandas introduce the island’s layered streetscape.'),
  ReadingAnnotation(pinyin: 'Shíjiǔ shìjì zhōngqī Xiàmén kāigǎng hòu, Gǔlàngyǔ zhújiàn chéngwéi guójì shèqū. Zhùzhái, xuéxiào, yīyuàn yǔ gōnggòng kōngjiān gòngtóng sùzào xīn de chéngshì jīlǐ.', vietnamese: 'Sau khi Hạ Môn mở cảng giữa thế kỷ XIX, đảo dần thành cộng đồng quốc tế với nhà ở, trường học và bệnh viện.', english: 'After Xiamen opened as a port, homes and public institutions shaped an international settlement.'),
  ReadingAnnotation(pinyin: 'Mǐnnán chuántǒng, Zhōngyuán wénhuà, Nányáng jīngyàn yǔ Xīfāng xíngshì jīngguò běndì gōngjiàng tiáozhěng, xíngchéng shìyìng hǎidǎo qìhòu de zhézhōng shèjì.', vietnamese: 'Truyền thống Mân Nam, Trung Nguyên, Nam Dương và phương Tây được thợ địa phương điều chỉnh cho khí hậu đảo.', english: 'Local builders blended several traditions into designs suited to the island climate.'),
  ReadingAnnotation(pinyin: 'Bǎohù bù zhǐshì bǎocún piàoliang lìmiàn, yě yào wéihù xiàngdào chǐdù, shùmù, hǎiàn shìxiàn hé jūmín rìcháng.', vietnamese: 'Bảo tồn còn giữ quy mô ngõ phố, cây xanh, tầm nhìn bờ biển và đời sống cư dân.', english: 'Conservation also protects lane scale, trees, coastal views, and everyday life.'),
];

const _xiamenWords = <WordEntry>[
  WordEntry(word: '榕树', pinyin: 'róngshù', partOfSpeech: '名词', simpleChinese: '常见于温暖地区的大树。', translation: 'Cây đa nhiệt đới.', englishDefinition: 'banyan tree', symbol: '🌳'),
  WordEntry(word: '花岗岩', pinyin: 'huāgāngyán', partOfSpeech: '名词', simpleChinese: '坚硬的建筑石材。', translation: 'Đá hoa cương.', englishDefinition: 'granite', symbol: '🪨'),
  WordEntry(word: '廊柱', pinyin: 'lángzhù', partOfSpeech: '名词', simpleChinese: '走廊旁边的柱子。', translation: 'Cột bên hành lang.', englishDefinition: 'veranda column', symbol: '🏛️'),
  WordEntry(word: '开港', pinyin: 'kāigǎng', partOfSpeech: '动词', simpleChinese: '开放港口进行贸易往来。', translation: 'Mở cảng giao thương.', englishDefinition: 'to open a port', symbol: '⚓'),
  WordEntry(word: '社区', pinyin: 'shèqū', partOfSpeech: '名词', simpleChinese: '人们共同生活的区域。', translation: 'Cộng đồng dân cư.', englishDefinition: 'community', symbol: '🏘️'),
  WordEntry(word: '肌理', pinyin: 'jīlǐ', partOfSpeech: '名词', simpleChinese: '城市空间形成的纹理和结构。', translation: 'Cấu trúc và đường nét đô thị.', englishDefinition: 'urban fabric', symbol: '🧩'),
  WordEntry(word: '折衷', pinyin: 'zhézhōng', partOfSpeech: '形容词', simpleChinese: '结合不同方法或风格。', translation: 'Chiết trung, kết hợp nhiều phong cách.', englishDefinition: 'eclectic', symbol: '🔀'),
  WordEntry(word: '巷道', pinyin: 'xiàngdào', partOfSpeech: '名词', simpleChinese: '街区中的小路。', translation: 'Ngõ nhỏ trong khu phố.', englishDefinition: 'lane', symbol: '🛤️'),
  WordEntry(word: '立面', pinyin: 'lìmiàn', partOfSpeech: '名词', simpleChinese: '建筑外部正面的样子。', translation: 'Mặt đứng công trình.', englishDefinition: 'building facade', symbol: '🏠'),
];

const _xiamenDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '厦门开港后，鼓浪屿在一九〇三年正式形成国际社区。', pinyin: 'Xiàmén kāigǎng hòu, Gǔlàngyǔ zài yījiǔlíngsān nián zhèngshì xíngchéng guójì shèqū.', simpleChinese: '鼓浪屿曾是一座国际社区。', vietnamese: 'Sau khi Hạ Môn mở cảng, đảo hình thành khu định cư quốc tế chính thức năm 1903.', english: 'Following Xiamen’s port opening, Kulangsu became a formal international settlement in 1903.'),
  DiscoveryEntry(text: '住宅与公共建筑共同保存历史社区的城市肌理。', pinyin: 'Zhùzhái yǔ gōnggòng jiànzhù gòngtóng bǎocún lìshǐ shèqū de chéngshì jīlǐ.', simpleChinese: '不同建筑一起组成社区。', vietnamese: 'Nhà ở và công trình công cộng cùng lưu giữ cấu trúc đô thị lịch sử.', english: 'Homes and public buildings preserve the historic urban fabric together.'),
  DiscoveryEntry(text: '本地工匠把闽南、南洋与西方形式转化为折衷建筑。', pinyin: 'Běndì gōngjiàng bǎ Mǐnnán, Nányáng yǔ Xīfāng xíngshì zhuǎnhuàwéi zhézhōng jiànzhù.', simpleChinese: '多种风格在岛上融合。', vietnamese: 'Thợ địa phương chuyển hóa các hình thức Mân Nam, Nam Dương và phương Tây thành kiến trúc chiết trung.', english: 'Local builders transformed Minnan, Nanyang, and Western forms into eclectic architecture.'),
  DiscoveryEntry(text: '步行巷道、榕树、花岗岩与海岸视线也是遗产环境的一部分。', pinyin: 'Bùxíng xiàngdào, róngshù, huāgāngyán yǔ hǎiàn shìxiàn yě shì yíchǎn huánjìng de yí bùfen.', simpleChinese: '街道、树木和海景都需要保护。', vietnamese: 'Ngõ đi bộ, cây đa, đá hoa cương và tầm nhìn biển đều thuộc môi trường di sản.', english: 'Walking lanes, banyans, granite, and coastal views all belong to the heritage setting.'),
];

final dunhuangMogaoJourney = _record(
  id: 'dunhuang-mogao-caves',
  title: '敦煌 · 莫高窟：在沙漠崖壁读一千年',
  geoNodeId: 'cn-gansu-jiuquan-dunhuang-mogao-caves',
  paragraphs: _dunhuangParagraphs,
  sources: const ['unesco-dunhuang-mogao-caves', 'dunhuang-academy-mogao-caves'],
  tags: const ['敦煌', '莫高窟', '丝绸之路', '壁画', '世界遗产'],
);

final chengdeMountainResortJourney = _record(
  id: 'chengde-mountain-resort',
  title: '承德 · 避暑山庄：让建筑藏进山水',
  geoNodeId: 'cn-hebei-chengde-shuangqiao-mountain-resort',
  paragraphs: _chengdeParagraphs,
  sources: const ['unesco-chengde-mountain-resort', 'chengde-government-mountain-resort'],
  tags: const ['承德', '避暑山庄', '皇家园林', '多民族交流', '世界遗产'],
);

final xiamenKulangsuJourney = _record(
  id: 'xiamen-kulangsu',
  title: '厦门 · 鼓浪屿：沿海风阅读一座国际社区',
  geoNodeId: 'cn-fujian-xiamen-siming-kulangsu',
  paragraphs: _xiamenParagraphs,
  sources: const ['unesco-xiamen-kulangsu', 'fujian-government-kulangsu'],
  tags: const ['厦门', '鼓浪屿', '国际社区', '建筑融合', '世界遗产'],
);

final journeyExpansionBatchThreeRecords = <JourneyContentRecord>[
  dunhuangMogaoJourney,
  chengdeMountainResortJourney,
  xiamenKulangsuJourney,
];

final journeyExpansionBatchThreeExperiences = <DailyJourneyExperience>[
  DailyJourneyExperience(
    id: dunhuangMogaoJourney.id,
    city: '敦煌',
    cityCode: 'DNH',
    place: '莫高窟',
    appBarTitle: '敦煌 · 莫高窟',
    storyTitle: '丝路洞窟故事',
    headline: '在沙漠崖壁读一千年',
    description: '沿宕泉河与崖壁理解洞窟艺术、丝路交流和现代保护。',
    discoveryTeaser: '为什么莫高窟多用泥塑与壁画，而不是直接雕刻？',
    distanceLabel: '2,100 km',
    stampSymbol: '敦',
    content: dunhuangMogaoJourney,
    storyAnnotations: _dunhuangAnnotations,
    words: _dunhuangWords,
    discoveries: _dunhuangDiscoveries,
    wonderQuestion: '如果你要为未来留下一幅壁画，会画旅途、城市、人物还是自然？为什么？',
    expressQuestion: '请用两到三句话描写晨光、崖壁与沙漠绿洲形成的层次。',
  ),
  DailyJourneyExperience(
    id: chengdeMountainResortJourney.id,
    city: '承德',
    cityCode: 'CDE',
    place: '避暑山庄',
    appBarTitle: '承德 · 避暑山庄',
    storyTitle: '皇家园林故事',
    headline: '让建筑藏进山水',
    description: '沿湖泊与山峦观察皇家园林如何连接自然、多民族文化和保护。',
    discoveryTeaser: '为什么山庄的宫殿没有压过山水？',
    distanceLabel: '1,770 km',
    stampSymbol: '山',
    content: chengdeMountainResortJourney,
    storyAnnotations: _chengdeAnnotations,
    words: _chengdeWords,
    discoveries: _chengdeDiscoveries,
    wonderQuestion: '如果你设计一条山庄路线，会先让人看见湖泊、亭榭、平原还是山峦？',
    expressQuestion: '请用两到三句话描写薄雾、湖面与亭榭共同形成的园林空间。',
  ),
  DailyJourneyExperience(
    id: xiamenKulangsuJourney.id,
    city: '厦门',
    cityCode: 'XMN',
    place: '鼓浪屿',
    appBarTitle: '厦门 · 鼓浪屿',
    storyTitle: '海岛社区故事',
    headline: '沿海风阅读国际社区',
    description: '穿过榕树与石阶，读懂海岛建筑、国际交往和生活社区。',
    discoveryTeaser: '为什么鼓浪屿的建筑很难归入单一风格？',
    distanceLabel: '390 km',
    stampSymbol: '岛',
    content: xiamenKulangsuJourney,
    storyAnnotations: _xiamenAnnotations,
    words: _xiamenWords,
    discoveries: _xiamenDiscoveries,
    wonderQuestion: '如果一座老房子能讲述一次文化相遇，你最想听建筑材料、居民还是海港的故事？',
    expressQuestion: '请用两到三句话描写榕树、石阶、老建筑与海面之间的关系。',
  ),
];
