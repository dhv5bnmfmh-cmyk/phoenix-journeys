import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchSixSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-mogao',
    title: 'Mogao Caves',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/440',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-gansu-jiuquan-dunhuang-mogao-caves'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'unesco-suzhou-gardens',
    title: 'Classical Gardens of Suzhou',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/813',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-jiangsu-suzhou-gusu-humble-administrators-garden'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'unesco-quanzhou',
    title: 'Quanzhou: Emporium of the World in Song-Yuan China',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1561',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-fujian-quanzhou-licheng-kaiyuan-temple'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'unesco-yungang',
    title: 'Yungang Grottoes',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1039',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-shanxi-datong-yungang-yungang-grottoes'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
  StorySourceRecord(
    id: 'unesco-longmen',
    title: 'Longmen Grottoes',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1003',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-henan-luoyang-luolong-longmen-grottoes'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-31',
  ),
];

JourneyContentRecord _record(
  String id,
  String title,
  String geoNodeId,
  List<String> paragraphs,
  String sourceId,
  List<String> tags,
) {
  return JourneyContentRecord(
    id: id,
    title: title,
    geoNodeId: geoNodeId,
    languageCode: 'zh-CN',
    verificationStatus: StoryVerificationStatus.published,
    tags: tags,
    sections: List<JourneyStorySection>.generate(
      paragraphs.length,
      (index) => JourneyStorySection(
        id: 'story-$index',
        text: paragraphs[index],
        sourceIds: [sourceId],
      ),
    ),
  );
}

ReadingAnnotation _annotation(String pinyin, String vietnamese, String english) =>
    ReadingAnnotation(pinyin: pinyin, vietnamese: vietnamese, english: english);

WordEntry _word(
  String word,
  String pinyin,
  String simpleChinese,
  String vietnamese,
  String english,
  String symbol,
) =>
    WordEntry(
      word: word,
      pinyin: pinyin,
      partOfSpeech: '名词',
      simpleChinese: simpleChinese,
      translation: vietnamese,
      englishDefinition: english,
      symbol: symbol,
    );

DiscoveryEntry _discovery(
  String text,
  String pinyin,
  String simpleChinese,
  String vietnamese,
  String english,
) =>
    DiscoveryEntry(
      text: text,
      pinyin: pinyin,
      simpleChinese: simpleChinese,
      vietnamese: vietnamese,
      english: english,
    );

const _mogaoParagraphs = <String>[
  '清晨，鸣沙山边的光线慢慢照亮崖壁。莫高窟的洞窟像一排沉默的窗口，保存着跨越多个朝代的壁画、彩塑与题记。',
  '这里曾位于丝绸之路的重要节点。商旅、僧侣和使者带来的图像、语言与信仰，在洞窟中相遇，又被本地工匠重新创造。',
  '光照、湿度、风沙和游客呼吸都会影响脆弱颜料，因此开放与保护必须保持精细平衡。',
  '数字化记录让更多人看见洞窟细节，也为研究和修复留下依据。真正的旅行，也包括理解为什么观看需要克制。',
];
final _mogaoAnnotations = <ReadingAnnotation>[
  _annotation('Qīngchén, Míngshā Shān biān de guāngxiàn mànmàn zhàoliàng yábì.', 'Buổi sớm, ánh sáng bên núi Minh Sa dần chiếu lên vách đá.', 'Morning light slowly reaches the cliff beside the Singing Sand Dunes.'),
  _annotation('Shānglǚ hé sēnglǚ dài lái de túxiàng zài dòngkū zhōng xiāngyù.', 'Hình ảnh do thương nhân và tăng lữ mang đến gặp nhau trong hang động.', 'Images carried by merchants and monks met inside the caves.'),
  _annotation('Guāngzhào, shīdù hé fēngshā dōu huì yǐngxiǎng yánliào.', 'Ánh sáng, độ ẩm và cát gió đều ảnh hưởng sắc tố.', 'Light, humidity, and sand all affect the pigments.'),
  _annotation('Shùzìhuà jìlù wèi yánjiū hé xiūfù liúxià yījù.', 'Số hóa tạo cơ sở cho nghiên cứu và tu bổ.', 'Digital records support research and conservation.'),
];
final _mogaoWords = <WordEntry>[
  _word('洞窟', 'dòngkū', '开凿在岩壁中的空间。', 'Hang động đục trong vách đá.', 'rock-cut cave', '🕳️'),
  _word('壁画', 'bìhuà', '画在墙壁上的图画。', 'Tranh tường.', 'mural', '🎨'),
  _word('彩塑', 'cǎisù', '带有颜色的雕塑。', 'Tượng điêu khắc có màu.', 'painted sculpture', '🗿'),
  _word('题记', 'tíjì', '写在作品旁的文字记录。', 'Dòng chữ ghi chú.', 'inscription', '✍️'),
  _word('丝绸之路', 'sīchóu zhī lù', '连接东西方的古代交通网络。', 'Con đường Tơ lụa.', 'Silk Roads', '🐫'),
  _word('颜料', 'yánliào', '绘画使用的有色材料。', 'Chất màu.', 'pigment', '🟠'),
  _word('湿度', 'shīdù', '空气中水分的程度。', 'Độ ẩm.', 'humidity', '💧'),
  _word('数字化', 'shùzìhuà', '把资料转成数字形式。', 'Số hóa.', 'digitization', '💾'),
  _word('修复', 'xiūfù', '恢复文物的稳定状态。', 'Tu bổ.', 'conservation repair', '🛠️'),
];
final _mogaoDiscoveries = <DiscoveryEntry>[
  _discovery('莫高窟保存了跨越多个世纪的壁画和彩塑。', 'Mògāokū bǎocúnle kuàyuè duō gè shìjì de bìhuà hé cǎisù.', '这里保存长期积累的艺术。', 'Mạc Cao lưu giữ nghệ thuật qua nhiều thế kỷ.', 'Mogao preserves art created across many centuries.'),
  _discovery('洞窟艺术反映丝绸之路上的文化交流。', 'Dòngkū yìshù fǎnyìng Sīchóu Zhī Lù shàng de wénhuà jiāoliú.', '不同文化在这里相遇。', 'Nghệ thuật hang động phản ánh giao lưu trên Con đường Tơ lụa.', 'The cave art reflects exchange along the Silk Roads.'),
  _discovery('光照、湿度和风沙都会影响壁画保存。', 'Guāngzhào, shīdù hé fēngshā dōu huì yǐngxiǎng bìhuà bǎocún.', '环境变化会伤害壁画。', 'Ánh sáng, độ ẩm và cát gió ảnh hưởng bảo tồn.', 'Light, humidity, and sand affect mural conservation.'),
  _discovery('数字化不能替代原作，但能帮助记录与研究。', 'Shùzìhuà bùnéng tìdài yuánzuò, dàn néng bāngzhù jìlù yǔ yánjiū.', '数字资料帮助保护。', 'Số hóa hỗ trợ ghi chép và nghiên cứu.', 'Digitization supports documentation and study.'),
];

const _suzhouParagraphs = <String>[
  '推开园门，城市声音忽然变轻。水池、假山、花窗与曲折廊道把有限空间分成许多层次。',
  '苏州园林用石、水、植物和建筑浓缩自然。借景让远处塔影进入院中，框景让一扇窗成为画框。',
  '匾额、楹联和书画让园林不仅能看，也能读。季节、天气和观看位置不断改变景色。',
  '保护园林不仅是修复亭台，还要守住水系、街巷、植物与传统营造技艺之间的关系。',
];
final _suzhouAnnotations = <ReadingAnnotation>[
  _annotation('Tuīkāi yuánmén, chéngshì shēngyīn hūrán biàn qīng.', 'Mở cổng vườn, âm thanh thành phố bỗng dịu xuống.', 'Beyond the garden gate, the city suddenly grows quiet.'),
  _annotation('Jièjǐng ràng yuǎnchù tǎyǐng jìnrù yuàn zhōng.', 'Mượn cảnh đưa bóng tháp xa vào trong vườn.', 'Borrowed scenery brings a distant pagoda into the garden.'),
  _annotation('Biǎné hé yínglián ràng yuánlín bùjǐn néng kàn, yě néng dú.', 'Biển đề và câu đối khiến khu vườn vừa để ngắm vừa để đọc.', 'Plaques and couplets make the garden readable as well as visible.'),
  _annotation('Bǎohù yào shǒuzhù shuǐxì hé yíngzào jìyì de guānxì.', 'Bảo tồn phải giữ mối liên hệ giữa nước và kỹ nghệ xây dựng.', 'Conservation must preserve relationships between water and craft.'),
];
final _suzhouWords = <WordEntry>[
  _word('园林', 'yuánlín', '经过设计的园子和景观。', 'Vườn cảnh.', 'classical garden', '🌿'),
  _word('假山', 'jiǎshān', '用石头堆成的山景。', 'Núi giả.', 'rockery', '🪨'),
  _word('花窗', 'huāchuāng', '带装饰图案的窗。', 'Cửa sổ hoa văn.', 'decorative window', '🪟'),
  _word('廊道', 'lángdào', '连接建筑的有顶通道。', 'Hành lang có mái.', 'covered corridor', '🏮'),
  _word('借景', 'jièjǐng', '把园外景色引入园中。', 'Mượn cảnh.', 'borrowed scenery', '🔭'),
  _word('框景', 'kuàngjǐng', '用门窗形成画框般的景色。', 'Đóng khung cảnh.', 'framed view', '🖼️'),
  _word('楹联', 'yínglián', '挂在柱子两侧的对联。', 'Câu đối trên cột.', 'pillar couplet', '📜'),
  _word('营造', 'yíngzào', '设计并建造。', 'Kiến tạo.', 'design and construction', '🛠️'),
  _word('水系', 'shuǐxì', '相互连接的水体系统。', 'Hệ thống mặt nước.', 'water system', '💦'),
];
final _suzhouDiscoveries = <DiscoveryEntry>[
  _discovery('苏州古典园林用有限空间创造微缩自然。', 'Sūzhōu gǔdiǎn yuánlín yòng yǒuxiàn kōngjiān chuàngzào wēisuō zìrán.', '小空间可以表现大山水。', 'Vườn Tô Châu tạo thiên nhiên thu nhỏ trong không gian hữu hạn.', 'Suzhou gardens create miniature nature in limited space.'),
  _discovery('借景和框景会改变观看者对空间的感受。', 'Jièjǐng hé kuàngjǐng huì gǎibiàn guānkànzhě duì kōngjiān de gǎnshòu.', '设计引导人怎样看。', 'Mượn cảnh và đóng khung thay đổi cảm nhận không gian.', 'Borrowed and framed views reshape spatial perception.'),
  _discovery('文字、书画和建筑共同表达园林文化。', 'Wénzì, shūhuà hé jiànzhù gòngtóng biǎodá yuánlín wénhuà.', '园林也是可以阅读的空间。', 'Chữ viết, hội họa và kiến trúc cùng biểu đạt văn hóa.', 'Writing, painting, and architecture work together.'),
  _discovery('保护园林也包括周边水系、街巷和传统技艺。', 'Bǎohù yuánlín yě bāokuò zhōubiān shuǐxì, jiēxiàng hé chuántǒng jìyì.', '园林与城市环境相连。', 'Bảo tồn gồm cả nước, phố ngõ và kỹ nghệ truyền thống.', 'Garden conservation includes its urban setting and craft traditions.'),
];

const _quanzhouParagraphs = <String>[
  '从古港附近出发，你会在泉州街巷里遇见寺院、清真寺、石塔、古桥和码头遗迹。',
  '宋元时期，泉州连接内陆生产、河流运输与远洋航线。瓷器、茶叶、香料和金属制品在这里转运。',
  '不同信仰留下的建筑说明港口不仅交换商品，也交换语言、技术与生活方式。',
  '今天理解泉州，需要把码头、道路、宗教建筑和生产遗址看成一张彼此连接的网络。',
];
final _quanzhouAnnotations = <ReadingAnnotation>[
  _annotation('Quánzhōu jiēxiàng lǐ yǒu sìyuàn, shítǎ hé gǔqiáo.', 'Trong phố Tuyền Châu có chùa, tháp đá và cầu cổ.', 'Quanzhou streets contain temples, stone towers, and ancient bridges.'),
  _annotation('Sòng Yuán shíqī, Quánzhōu liánjiē nèilù yǔ yuǎnyáng hángxiàn.', 'Thời Tống Nguyên, Tuyền Châu nối nội địa với tuyến biển xa.', 'In the Song-Yuan period, Quanzhou linked the interior with ocean routes.'),
  _annotation('Gǎngkǒu bùzhǐ jiāohuàn shāngpǐn, yě jiāohuàn yǔyán hé jìshù.', 'Cảng không chỉ trao đổi hàng hóa mà còn trao đổi ngôn ngữ và kỹ thuật.', 'The port exchanged languages and technologies as well as goods.'),
  _annotation('Lǐjiě Quánzhōu xūyào kànjiàn yí zhāng liánjiē de wǎngluò.', 'Hiểu Tuyền Châu cần nhìn thấy một mạng lưới kết nối.', 'Understanding Quanzhou requires seeing a connected network.'),
];
final _quanzhouWords = <WordEntry>[
  _word('古港', 'gǔgǎng', '历史悠久的港口。', 'Cảng cổ.', 'historic port', '⚓'),
  _word('码头', 'mǎtóu', '船只停靠装卸的地方。', 'Bến tàu.', 'wharf', '🚢'),
  _word('远洋', 'yuǎnyáng', '航行到很远的海域。', 'Viễn dương.', 'ocean-going', '🌊'),
  _word('转运', 'zhuǎnyùn', '把货物换路线继续运输。', 'Chuyển vận.', 'transshipment', '📦'),
  _word('香料', 'xiāngliào', '带香味的植物材料。', 'Gia vị thơm.', 'spice', '🌿'),
  _word('信仰', 'xìnyǎng', '人们相信并遵循的精神体系。', 'Tín ngưỡng.', 'belief', '🕊️'),
  _word('遗址', 'yízhǐ', '历史活动留下的地点。', 'Di chỉ.', 'historic site', '🏛️'),
  _word('航线', 'hángxiàn', '船只固定行驶的路线。', 'Tuyến hàng hải.', 'shipping route', '🧭'),
  _word('网络', 'wǎngluò', '彼此连接的系统。', 'Mạng lưới.', 'network', '🕸️'),
];
final _quanzhouDiscoveries = <DiscoveryEntry>[
  _discovery('泉州遗产由港口、道路、宗教建筑和生产遗址共同组成。', 'Quánzhōu yíchǎn yóu gǎngkǒu, dàolù hé zōngjiào jiànzhù gòngtóng zǔchéng.', '遗产是一个城市网络。', 'Di sản Tuyền Châu là một mạng lưới đô thị.', 'Quanzhou heritage forms an urban network.'),
  _discovery('宋元泉州连接中国内陆与海上贸易路线。', 'Sòng Yuán Quánzhōu liánjiē Zhōngguó nèilù yǔ hǎishàng màoyì lùxiàn.', '港口连接内陆和海洋。', 'Tuyền Châu nối nội địa Trung Quốc với tuyến thương mại biển.', 'Song-Yuan Quanzhou linked inland China with maritime trade.'),
  _discovery('多种宗教建筑反映长期跨文化交流。', 'Duō zhǒng zōngjiào jiànzhù fǎnyìng chángqī kuà wénhuà jiāoliú.', '不同信仰在港口共存。', 'Nhiều công trình tôn giáo phản ánh giao lưu lâu dài.', 'Religious buildings reflect sustained cross-cultural exchange.'),
  _discovery('开元寺是泉州历史城市景观的重要组成部分。', 'Kāiyuán Sì shì Quánzhōu lìshǐ chéngshì jǐngguān de zhòngyào zǔchéng bùfen.', '寺院与港口历史相连。', 'Chùa Khai Nguyên là phần quan trọng của cảnh quan lịch sử.', 'Kaiyuan Temple is a major part of Quanzhou’s historic landscape.'),
];

const _yungangParagraphs = <String>[
  '走近大同西郊的崖壁，云冈石窟的洞窟和造像从山体中逐渐显现。',
  '石窟主要开凿于北魏时期，巨大佛像、细密浮雕和不同面容记录了多种艺术传统的交汇。',
  '造像并不是孤立的装饰。洞窟布局、服饰纹样和题记共同讲述政治、宗教与工匠技术。',
  '风化、水分和温度变化持续影响砂岩表面，保护工作需要长期监测并控制开放强度。',
];
final _yungangAnnotations = <ReadingAnnotation>[
  _annotation('Yúngāng Shíkū de dòngkū hé zàoxiàng cóng shāntǐ zhōng xiǎnxiàn.', 'Hang và tượng Vân Cương dần hiện ra từ núi.', 'The caves and sculptures of Yungang emerge from the mountain.'),
  _annotation('Shíkū zhǔyào kāizáo yú Běiwèi shíqī.', 'Các hang chủ yếu được tạc thời Bắc Ngụy.', 'The grottoes were mainly carved during the Northern Wei.'),
  _annotation('Dòngkū bùjú hé tíjì gòngtóng jiǎngshù lìshǐ.', 'Bố cục hang và đề ký cùng kể lịch sử.', 'Cave layouts and inscriptions tell history together.'),
  _annotation('Fēnghuà hé shuǐfèn chíxù yǐngxiǎng shāyán biǎomiàn.', 'Phong hóa và nước tiếp tục ảnh hưởng bề mặt sa thạch.', 'Weathering and moisture continue to affect the sandstone.'),
];
final _yungangWords = <WordEntry>[
  _word('石窟', 'shíkū', '开凿在岩石中的洞窟。', 'Hang đá.', 'grotto', '🪨'),
  _word('造像', 'zàoxiàng', '制作的宗教人物形象。', 'Tượng tạo tác.', 'religious image', '🗿'),
  _word('北魏', 'Běiwèi', '中国古代的一个朝代。', 'Bắc Ngụy.', 'Northern Wei dynasty', '🏺'),
  _word('浮雕', 'fúdiāo', '凸出于平面的雕刻。', 'Phù điêu.', 'relief carving', '🧱'),
  _word('纹样', 'wényàng', '装饰性的图案。', 'Hoa văn.', 'decorative pattern', '〰️'),
  _word('工匠', 'gōngjiàng', '掌握手工技术的人。', 'Thợ thủ công.', 'craftsperson', '🔨'),
  _word('砂岩', 'shāyán', '由砂粒形成的岩石。', 'Sa thạch.', 'sandstone', '🟤'),
  _word('风化', 'fēnghuà', '岩石受自然作用逐渐变化。', 'Phong hóa.', 'weathering', '🌬️'),
  _word('监测', 'jiāncè', '持续观察并记录变化。', 'Quan trắc.', 'monitoring', '📡'),
];
final _yungangDiscoveries = <DiscoveryEntry>[
  _discovery('云冈石窟的重要洞窟主要开凿于北魏时期。', 'Yúngāng Shíkū de zhòngyào dòngkū zhǔyào kāizáo yú Běiwèi shíqī.', '主要作品来自北魏。', 'Các hang quan trọng chủ yếu được tạc thời Bắc Ngụy.', 'Major caves were carved during the Northern Wei.'),
  _discovery('造像融合了来自不同地区的艺术传统。', 'Zàoxiàng rónghé le láizì bùtóng dìqū de yìshù chuántǒng.', '多种艺术在这里交汇。', 'Tượng kết hợp truyền thống nghệ thuật từ nhiều vùng.', 'The sculpture combines artistic traditions from several regions.'),
  _discovery('洞窟布局、服饰和题记能够帮助判断年代。', 'Dòngkū bùjú, fúshì hé tíjì nénggòu bāngzhù pànduàn niándài.', '细节提供年代线索。', 'Bố cục, trang phục và đề ký giúp xác định niên đại.', 'Layouts, clothing, and inscriptions help date the caves.'),
  _discovery('砂岩风化是云冈保护的重要挑战。', 'Shāyán fēnghuà shì Yúngāng bǎohù de zhòngyào tiǎozhàn.', '自然变化影响石刻。', 'Phong hóa sa thạch là thách thức lớn.', 'Sandstone weathering is a major conservation challenge.'),
];

const _longmenParagraphs = <String>[
  '伊河穿过洛阳南部，两岸石灰岩崖壁上分布着密集洞窟与佛龛。',
  '龙门石窟的重要营造集中在北魏晚期至唐代，不同年代的比例、衣纹和面容记录艺术风格变化。',
  '题记和碑刻让石窟不仅是雕塑群，也是文字档案，为研究古代宗教和社会提供线索。',
  '岩体裂隙、水分、温度变化与游客压力会影响石刻，保护需要结构监测和谨慎开放。',
];
final _longmenAnnotations = <ReadingAnnotation>[
  _annotation('Yī Hé chuānguò Luòyáng nánbù, liǎng àn yábì shàng fēnbùzhe dòngkū yǔ fókān.', 'Sông Y chảy qua nam Lạc Dương, hai bờ có nhiều hang và khám Phật.', 'The Yi River passes cliffs filled with caves and niches.'),
  _annotation('Bùtóng niándài de zàoxiàng jìlùzhe yìshù fēnggé de biànhuà.', 'Tượng từ nhiều thời kỳ ghi lại thay đổi phong cách nghệ thuật.', 'Sculptures from different periods record changes in artistic style.'),
  _annotation('Tíjì hé bēikè ràng shíkū chéngwéi wénzì dàng’àn.', 'Đề ký và bia khắc biến hang đá thành kho tư liệu chữ viết.', 'Inscriptions turn the grottoes into a written archive.'),
  _annotation('Bǎohù xūyào jiégòu jiāncè hé jǐnshèn kāifàng.', 'Bảo tồn cần quan trắc kết cấu và mở cửa thận trọng.', 'Conservation requires structural monitoring and careful access.'),
];
final _longmenWords = <WordEntry>[
  _word('石窟', 'shíkū', '开凿在岩石中的洞窟。', 'Hang đá.', 'grotto', '🪨'),
  _word('佛龛', 'fókān', '安放佛像的小空间。', 'Khám Phật.', 'Buddhist niche', '🕯️'),
  _word('造像', 'zàoxiàng', '制作的宗教人物形象。', 'Tượng tạo tác.', 'religious image', '🗿'),
  _word('衣纹', 'yīwén', '雕塑衣服上的线条。', 'Nếp áo điêu khắc.', 'drapery folds', '〰️'),
  _word('供养者', 'gòngyǎngzhě', '出资营造宗教作品的人。', 'Người cúng tiến.', 'patron or donor', '🙏'),
  _word('碑刻', 'bēikè', '刻在石碑上的文字。', 'Văn bia.', 'stone inscription', '📜'),
  _word('裂隙', 'lièxì', '岩石中的裂缝。', 'Khe nứt.', 'fissure', '⚡'),
  _word('开放区域', 'kāifàng qūyù', '允许游客进入的范围。', 'Khu vực mở cửa.', 'public access area', '🚧'),
  _word('监测', 'jiāncè', '持续观察并记录变化。', 'Quan trắc.', 'monitoring', '📡'),
];
final _longmenDiscoveries = <DiscoveryEntry>[
  _discovery('龙门石窟分布在伊河两岸约一公里的崖壁上。', 'Lóngmén Shíkū fēnbù zài Yī Hé liǎng àn yuē yì gōnglǐ de yábì shàng.', '洞窟沿河集中分布。', 'Long Môn phân bố dọc khoảng một km vách đá hai bờ sông Y.', 'The grottoes line roughly one kilometre of cliffs beside the Yi River.'),
  _discovery('主要造像反映北魏晚期和唐代石刻艺术。', 'Zhǔyào zàoxiàng fǎnyìng Běiwèi wǎnqī hé Tángdài shíkè yìshù.', '不同朝代留下不同风格。', 'Tượng phản ánh nghệ thuật Bắc Ngụy muộn và thời Đường.', 'The sculpture reflects late Northern Wei and Tang artistry.'),
  _discovery('大量题记为研究历史和社会提供资料。', 'Dàliàng tíjì wèi yánjiū lìshǐ hé shèhuì tígōng zīliào.', '文字让石窟也成为档案。', 'Nhiều đề ký cung cấp tư liệu lịch sử xã hội.', 'Inscriptions provide evidence for historical and social research.'),
  _discovery('水分和岩体裂隙是石刻保护的重要风险。', 'Shuǐfèn hé yántǐ lièxì shì shíkè bǎohù de zhòngyào fēngxiǎn.', '自然变化会影响雕刻。', 'Nước và khe nứt là rủi ro bảo tồn quan trọng.', 'Moisture and fissures are major conservation risks.'),
];

final mogaoJourney = _record(
  'dunhuang-mogao-caves',
  '敦煌 · 莫高窟：在沙漠崖壁阅读千年',
  'cn-gansu-jiuquan-dunhuang-mogao-caves',
  _mogaoParagraphs,
  'unesco-mogao',
  const ['敦煌', '莫高窟', '丝绸之路', '壁画', '保护'],
);
final suzhouJourney = _record(
  'suzhou-classical-gardens',
  '苏州 · 古典园林：一步一景的微缩山水',
  'cn-jiangsu-suzhou-gusu-humble-administrators-garden',
  _suzhouParagraphs,
  'unesco-suzhou-gardens',
  const ['苏州', '园林', '借景', '江南', '营造'],
);
final quanzhouJourney = _record(
  'quanzhou-maritime-emporium',
  '泉州 · 宋元海港：从街巷走向世界',
  'cn-fujian-quanzhou-licheng-kaiyuan-temple',
  _quanzhouParagraphs,
  'unesco-quanzhou',
  const ['泉州', '宋元', '海上贸易', '古港', '多元文化'],
);
final yungangJourney = _record(
  'datong-yungang-grottoes',
  '大同 · 云冈石窟：北魏崖壁上的艺术交汇',
  'cn-shanxi-datong-yungang-yungang-grottoes',
  _yungangParagraphs,
  'unesco-yungang',
  const ['大同', '云冈石窟', '北魏', '造像', '保护'],
);
final longmenJourney = _record(
  'luoyang-longmen-grottoes',
  '洛阳 · 龙门石窟：伊河两岸的石刻史书',
  'cn-henan-luoyang-luolong-longmen-grottoes',
  _longmenParagraphs,
  'unesco-longmen',
  const ['洛阳', '龙门石窟', '北魏', '唐代', '石刻'],
);

final journeyExpansionBatchSixRecords = <JourneyContentRecord>[
  mogaoJourney,
  suzhouJourney,
  quanzhouJourney,
  yungangJourney,
  longmenJourney,
];

final journeyExpansionBatchSixExperiences = <DailyJourneyExperience>[
  DailyJourneyExperience(
    id: mogaoJourney.id,
    city: '敦煌',
    cityCode: 'DNH',
    place: '莫高窟壁画',
    appBarTitle: '敦煌 · 莫高窟',
    storyTitle: '沙漠洞窟故事',
    headline: '在崖壁阅读千年',
    description: '沿壁画、彩塑与丝路交流，理解古代艺术和现代保护。',
    discoveryTeaser: '为什么游客的呼吸也可能影响千年壁画？',
    distanceLabel: '2,790 km',
    stampSymbol: '窟',
    content: mogaoJourney,
    storyAnnotations: _mogaoAnnotations,
    words: _mogaoWords,
    discoveries: _mogaoDiscoveries,
    wonderQuestion: '数字洞窟与真实洞窟分别能带给你什么？',
    expressQuestion: '请用两到三句话描写晨光、崖壁、洞窟与风沙。',
  ),
  DailyJourneyExperience(
    id: suzhouJourney.id,
    city: '苏州',
    cityCode: 'SZV',
    place: '古典园林',
    appBarTitle: '苏州 · 古典园林',
    storyTitle: '江南园林故事',
    headline: '一步一景的微缩山水',
    description: '穿过花窗、廊道、假山与水池，学习借景和框景。',
    discoveryTeaser: '一扇窗为什么能让小园子显得更大？',
    distanceLabel: '1,850 km',
    stampSymbol: '园',
    content: suzhouJourney,
    storyAnnotations: _suzhouAnnotations,
    words: _suzhouWords,
    discoveries: _suzhouDiscoveries,
    wonderQuestion: '你会用什么景物设计一座只属于自己的小园林？',
    expressQuestion: '请用两到三句话描写花窗、水池、假山和远处塔影。',
  ),
  DailyJourneyExperience(
    id: quanzhouJourney.id,
    city: '泉州',
    cityCode: 'JJN',
    place: '宋元海港',
    appBarTitle: '泉州 · 宋元海港',
    storyTitle: '海上贸易故事',
    headline: '从街巷走向世界',
    description: '连接古桥、码头、宗教建筑与生产遗址，阅读海港网络。',
    discoveryTeaser: '一座古港为什么不能只用码头来解释？',
    distanceLabel: '1,280 km',
    stampSymbol: '港',
    content: quanzhouJourney,
    storyAnnotations: _quanzhouAnnotations,
    words: _quanzhouWords,
    discoveries: _quanzhouDiscoveries,
    wonderQuestion: '商品、语言和信仰一起流动时，城市会发生什么变化？',
    expressQuestion: '请用两到三句话介绍泉州古港的连接网络。',
  ),
  DailyJourneyExperience(
    id: yungangJourney.id,
    city: '大同',
    cityCode: 'DAT',
    place: '云冈石窟',
    appBarTitle: '大同 · 云冈石窟',
    storyTitle: '北魏石窟故事',
    headline: '崖壁上的艺术交汇',
    description: '观察洞窟、造像、纹样与砂岩保护，理解北魏艺术。',
    discoveryTeaser: '为什么一尊佛像的面容能反映跨地区交流？',
    distanceLabel: '2,150 km',
    stampSymbol: '云',
    content: yungangJourney,
    storyAnnotations: _yungangAnnotations,
    words: _yungangWords,
    discoveries: _yungangDiscoveries,
    wonderQuestion: '你会从造像、洞窟布局还是题记开始阅读云冈？',
    expressQuestion: '请用两到三句话描写崖壁、洞窟、造像与北方天空。',
  ),
  DailyJourneyExperience(
    id: longmenJourney.id,
    city: '洛阳',
    cityCode: 'LYA',
    place: '龙门石窟',
    appBarTitle: '洛阳 · 龙门石窟',
    storyTitle: '伊河石刻故事',
    headline: '伊河两岸的石刻史书',
    description: '观察洞窟、造像与碑刻，理解北魏至唐代的艺术变化。',
    discoveryTeaser: '石刻的衣纹和面容为什么能告诉我们年代？',
    distanceLabel: '1,570 km',
    stampSymbol: '刻',
    content: longmenJourney,
    storyAnnotations: _longmenAnnotations,
    words: _longmenWords,
    discoveries: _longmenDiscoveries,
    wonderQuestion: '你更想从龙门石窟读到艺术变化，还是普通供养者的愿望？',
    expressQuestion: '请用两到三句话描写伊河、崖壁、洞窟与造像。',
  ),
];
