import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchSixSources = <StorySourceRecord>[
  StorySourceRecord(id:'unesco-mogao',title:'Mogao Caves',publisher:'UNESCO World Heritage Centre',url:'https://whc.unesco.org/en/list/440',kind:StorySourceKind.unesco,languageCode:'en',geoNodeIds:['cn-gansu-dunhuang-mogao'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-31'),
  StorySourceRecord(id:'unesco-suzhou-gardens',title:'Classical Gardens of Suzhou',publisher:'UNESCO World Heritage Centre',url:'https://whc.unesco.org/en/list/813',kind:StorySourceKind.unesco,languageCode:'en',geoNodeIds:['cn-jiangsu-suzhou-classical-gardens'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-31'),
  StorySourceRecord(id:'unesco-quanzhou',title:'Quanzhou: Emporium of the World in Song-Yuan China',publisher:'UNESCO World Heritage Centre',url:'https://whc.unesco.org/en/list/1561',kind:StorySourceKind.unesco,languageCode:'en',geoNodeIds:['cn-fujian-quanzhou-maritime-emporium'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-31'),
  StorySourceRecord(id:'unesco-potala',title:'Historic Ensemble of the Potala Palace, Lhasa',publisher:'UNESCO World Heritage Centre',url:'https://whc.unesco.org/en/list/707',kind:StorySourceKind.unesco,languageCode:'en',geoNodeIds:['cn-tibet-lhasa-potala-palace'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-31'),
  StorySourceRecord(id:'unesco-longmen',title:'Longmen Grottoes',publisher:'UNESCO World Heritage Centre',url:'https://whc.unesco.org/en/list/1003',kind:StorySourceKind.unesco,languageCode:'en',geoNodeIds:['cn-henan-luoyang-longmen-grottoes'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-31'),
];

JourneyContentRecord _record(String id,String title,String geo,List<String> paragraphs,String source,List<String> tags)=>JourneyContentRecord(id:id,title:title,geoNodeId:geo,languageCode:'zh-CN',verificationStatus:StoryVerificationStatus.published,tags:tags,sections:List.generate(paragraphs.length,(i)=>JourneyStorySection(id:'story-$i',text:paragraphs[i],sourceIds:[source])));
ReadingAnnotation _a(String p,String v,String e)=>ReadingAnnotation(pinyin:p,vietnamese:v,english:e);
WordEntry _w(String word,String pinyin,String meaning,String vi,String en,String symbol)=>WordEntry(word:word,pinyin:pinyin,partOfSpeech:'名词',simpleChinese:meaning,translation:vi,englishDefinition:en,symbol:symbol);
DiscoveryEntry _d(String text,String pinyin,String simple,String vi,String en)=>DiscoveryEntry(text:text,pinyin:pinyin,simpleChinese:simple,vietnamese:vi,english:en);

const _mogaoP=<String>[
  '清晨，鸣沙山边的光线慢慢照亮崖壁。莫高窟的洞窟像一排沉默的窗口，保存着跨越多个朝代的壁画、彩塑与题记。',
  '这里曾位于丝绸之路的重要节点。商旅、僧侣和使者带来的图像、语言与信仰，在洞窟中相遇，又被本地工匠重新创造。',
  '走近壁画时，你会发现颜色并非永远不变。光照、湿度、风沙和游客呼吸都会影响脆弱颜料，因此开放与保护必须精细平衡。',
  '数字化记录让更多人看见洞窟细节，也为研究和修复留下依据。真正的旅行，不只是看见古老艺术，也理解它为何需要克制地被观看。',
];
final _mogaoA=<ReadingAnnotation>[
  _a('Qīngchén, Míngshā Shān biān de guāngxiàn mànmàn zhàoliàng yábì.','Buổi sớm, ánh sáng bên núi Minh Sa dần chiếu lên vách đá.','Morning light beside the Singing Sand Dunes slowly reaches the cliff.'),
  _a('Shānglǚ, sēnglǚ hé shǐzhě dài lái de túxiàng yǔ xìnyǎng zài dòngkū zhōng xiāngyù.','Hình ảnh và tín ngưỡng theo thương nhân, tăng lữ và sứ giả gặp nhau trong hang động.','Images and beliefs carried by travellers met inside the caves.'),
  _a('Guāngzhào, shīdù, fēngshā hé yóukè hūxī dōu huì yǐngxiǎng yánliào.','Ánh sáng, độ ẩm, cát gió và hơi thở du khách đều ảnh hưởng sắc tố.','Light, humidity, sand, and visitors can affect fragile pigments.'),
  _a('Shùzìhuà jìlù wèi yánjiū hé xiūfù liúxià yījù.','Số hóa tạo cơ sở cho nghiên cứu và tu bổ.','Digital records support research and conservation.'),
];
final _mogaoW=<WordEntry>[
  _w('洞窟','dòngkū','开凿在岩壁中的空间。','Hang động được đục trong vách đá.','rock-cut cave','🕳️'),_w('壁画','bìhuà','画在墙壁上的图画。','Tranh tường.','mural','🎨'),_w('彩塑','cǎisù','带有颜色的雕塑。','Tượng điêu khắc có màu.','painted sculpture','🗿'),_w('题记','tíjì','写在作品旁的文字记录。','Dòng chữ ghi chú.','inscription','✍️'),_w('丝绸之路','sīchóu zhī lù','连接东西方的古代交通网络。','Con đường Tơ lụa.','Silk Roads','🐫'),_w('颜料','yánliào','绘画使用的有色材料。','Chất màu.','pigment','🟠'),_w('湿度','shīdù','空气中水分的程度。','Độ ẩm.','humidity','💧'),_w('数字化','shùzìhuà','把资料转成数字形式。','Số hóa.','digitization','💾'),
];
final _mogaoD=<DiscoveryEntry>[
  _d('莫高窟保存了跨越多个世纪的壁画和彩塑。','Mògāokū bǎocúnle kuàyuè duō gè shìjì de bìhuà hé cǎisù.','这里保存长期积累的艺术。','Mạc Cao lưu giữ nghệ thuật qua nhiều thế kỷ.','Mogao preserves art created across many centuries.'),
  _d('洞窟艺术反映丝绸之路上的文化交流。','Dòngkū yìshù fǎnyìng Sīchóu Zhī Lù shàng de wénhuà jiāoliú.','不同文化在这里相遇。','Nghệ thuật hang động phản ánh giao lưu trên Con đường Tơ lụa.','The cave art reflects exchange along the Silk Roads.'),
  _d('光照、湿度和风沙都会影响壁画保存。','Guāngzhào, shīdù hé fēngshā dōu huì yǐngxiǎng bìhuà bǎocún.','环境变化会伤害壁画。','Ánh sáng, độ ẩm và cát gió ảnh hưởng bảo tồn.','Light, humidity, and sand affect mural conservation.'),
  _d('数字化不能替代原作，但能帮助记录与研究。','Shùzìhuà bùnéng tìdài yuánzuò, dàn néng bāngzhù jìlù yǔ yánjiū.','数字资料帮助保护。','Số hóa hỗ trợ ghi chép và nghiên cứu.','Digitization supports documentation and study.'),
];

const _suzhouP=<String>[
  '推开园门，城市声音忽然变轻。水池、假山、花窗与曲折廊道把有限空间分成许多层次，每走几步，眼前都像换了一幅画。',
  '苏州园林不复制真正的山野，而是用石、水、植物和建筑浓缩自然。借景让远处塔影进入院中，框景让一扇窗成为画框。',
  '匾额、楹联和书画让园林不仅能看，也能读。季节、天气和观看位置改变景色，同一座园子因此拥有许多不同叙事。',
  '古典园林位于活着的城市之中。保护不仅是修复亭台，还要守住水系、街巷、植物与传统营造技艺之间的关系。',
];
final _suzhouA=<ReadingAnnotation>[
  _a('Tuīkāi yuánmén, chéngshì shēngyīn hūrán biàn qīng.','Mở cổng vườn, âm thanh thành phố bỗng dịu xuống.','Beyond the garden gate, the city suddenly grows quiet.'),
  _a('Jiǎjǐng ràng yuǎnchù tǎyǐng jìnrù yuàn zhōng.','Mượn cảnh đưa bóng tháp xa vào trong vườn.','Borrowed scenery brings a distant pagoda into the garden.'),
  _a('Biǎné, yínglián hé shūhuà ràng yuánlín bùjǐn néng kàn, yě néng dú.','Biển đề, câu đối và thư họa khiến khu vườn vừa để ngắm vừa để đọc.','Plaques, couplets, and calligraphy make the garden readable as well as visible.'),
  _a('Bǎohù yào shǒuzhù shuǐxì, jiēxiàng hé yíngzào jìyì de guānxì.','Bảo tồn phải giữ mối liên hệ giữa nước, phố ngõ và kỹ nghệ xây dựng.','Conservation must preserve relationships among water, lanes, and craft.'),
];
final _suzhouW=<WordEntry>[
  _w('园林','yuánlín','经过设计的园子和景观。','Vườn cảnh.','classical garden','🌿'),_w('假山','jiǎshān','用石头堆成的山景。','Núi giả.','rockery','🪨'),_w('花窗','huāchuāng','带装饰图案的窗。','Cửa sổ hoa văn.','decorative window','🪟'),_w('廊道','lángdào','连接建筑的有顶通道。','Hành lang có mái.','covered corridor','🏮'),_w('借景','jièjǐng','把园外景色引入园中。','Mượn cảnh.','borrowed scenery','🔭'),_w('框景','kuàngjǐng','用门窗形成画框般的景色。','Đóng khung cảnh.','framed view','🖼️'),_w('楹联','yínglián','挂在柱子两侧的对联。','Câu đối trên cột.','pillar couplet','📜'),_w('营造','yíngzào','设计并建造。','Kiến tạo.','design and construction','🛠️'),
];
final _suzhouD=<DiscoveryEntry>[
  _d('苏州古典园林用有限空间创造微缩自然。','Sūzhōu gǔdiǎn yuánlín yòng yǒuxiàn kōngjiān chuàngzào wēisuō zìrán.','小空间可以表现大山水。','Vườn Tô Châu tạo thiên nhiên thu nhỏ trong không gian hữu hạn.','Suzhou gardens create miniature nature in limited space.'),
  _d('借景和框景会改变观看者对空间的感受。','Jièjǐng hé kuàngjǐng huì gǎibiàn guānkànzhě duì kōngjiān de gǎnshòu.','设计引导人怎样看。','Mượn cảnh và đóng khung thay đổi cảm nhận không gian.','Borrowed and framed views reshape spatial perception.'),
  _d('园林中的文字、书画和建筑共同表达文化。','Yuánlín zhōng de wénzì, shūhuà hé jiànzhù gòngtóng biǎodá wénhuà.','园林也是可以阅读的空间。','Chữ viết, hội họa và kiến trúc cùng biểu đạt văn hóa.','Writing, painting, and architecture work together.'),
  _d('保护园林也包括周边水系、街巷和传统技艺。','Bǎohù yuánlín yě bāokuò zhōubiān shuǐxì, jiēxiàng hé chuántǒng jìyì.','园林与城市环境相连。','Bảo tồn gồm cả nước, phố ngõ và kỹ nghệ truyền thống.','Garden conservation includes its urban setting and craft traditions.'),
];

const _quanzhouP=<String>[
  '从古港附近出发，你会在泉州街巷里遇见寺院、清真寺、石塔、古桥和码头遗迹。它们不是孤立景点，而是一张海上贸易网络留下的城市地图。',
  '宋元时期，泉州连接内陆生产、河流运输与远洋航线。瓷器、茶叶和金属制品从这里出海，香料与不同语言也随船进入城市。',
  '多种宗教建筑和碑刻说明，港口繁荣不仅依靠商品，也依靠商人社群、制度、信任和长期交流。城市因此形成开放而复杂的文化层次。',
  '今天阅读泉州，不能只看一座塔或一座桥。把生产遗址、交通节点、宗教空间与海岸环境连起来，才能理解这座港城怎样运转。',
];
final _quanzhouA=<ReadingAnnotation>[
  _a('Tāmen bú shì gūlì jǐngdiǎn, ér shì hǎishàng màoyì wǎngluò liúxià de chéngshì dìtú.','Chúng không phải điểm tham quan rời rạc mà là bản đồ của mạng lưới thương mại biển.','They form a city map left by a maritime trade network.'),
  _a('Quánzhōu liánjiē nèilù shēngchǎn, héliú yùnshū yǔ yuǎnyáng hángxiàn.','Tuyền Châu nối sản xuất nội địa, vận tải sông và tuyến biển xa.','Quanzhou linked inland production, river transport, and ocean routes.'),
  _a('Gǎngkǒu fánróng yīlài shāngrén shèqún, zhìdù, xìnrèn hé jiāoliú.','Sự phồn vinh cảng dựa vào cộng đồng thương nhân, thể chế, niềm tin và giao lưu.','Port prosperity depended on communities, institutions, trust, and exchange.'),
  _a('Bǎ shēngchǎn yízhǐ, jiāotōng jiédiǎn hé hǎi àn huánjìng lián qǐlái.','Hãy nối di tích sản xuất, nút giao thông và môi trường bờ biển.','Connect production sites, transport nodes, and the coastal environment.'),
];
final _quanzhouW=<WordEntry>[
  _w('古港','gǔgǎng','古代使用的港口。','Cảng cổ.','historic port','⚓'),_w('码头','mǎtóu','船只停靠装卸的地方。','Bến tàu.','wharf','🚢'),_w('航线','hángxiàn','船只航行的路线。','Tuyến hàng hải.','shipping route','🧭'),_w('远洋','yuǎnyáng','远距离的海洋航行。','Viễn dương.','ocean-going','🌊'),_w('香料','xiāngliào','有香味并用于调味的材料。','Gia vị thơm.','spice','🌿'),_w('社群','shèqún','有共同联系的一群人。','Cộng đồng.','community','👥'),_w('碑刻','bēikè','刻在石碑上的文字。','Văn khắc bia đá.','stone inscription','🪧'),_w('节点','jiédiǎn','网络中重要的连接点。','Nút kết nối.','network node','🔗'),
];
final _quanzhouD=<DiscoveryEntry>[
  _d('宋元泉州是连接中国内陆与海上贸易的重要港口。','Sòng-Yuán Quánzhōu shì liánjiē Zhōngguó nèilù yǔ hǎishàng màoyì de zhòngyào gǎngkǒu.','泉州连接陆地生产和海洋航线。','Tuyền Châu nối nội địa Trung Quốc với thương mại biển.','Song-Yuan Quanzhou linked inland China to maritime trade.'),
  _d('城市遗产包括生产、运输、宗教和管理设施。','Chéngshì yíchǎn bāokuò shēngchǎn, yùnshū, zōngjiào hé guǎnlǐ shèshī.','遗产不是单一建筑。','Di sản gồm cơ sở sản xuất, vận tải, tôn giáo và quản lý.','The heritage system includes production, transport, religion, and administration.'),
  _d('不同商人社群推动商品与文化共同流动。','Bùtóng shāngrén shèqún tuīdòng shāngpǐn yǔ wénhuà gòngtóng liúdòng.','贸易也带来文化交流。','Các cộng đồng thương nhân thúc đẩy hàng hóa và văn hóa cùng lưu chuyển.','Merchant communities moved culture as well as goods.'),
  _d('理解古港需要把城市与海岸、河流和内陆联系起来。','Lǐjiě gǔgǎng xūyào bǎ chéngshì yǔ hǎi àn, héliú hé nèilù liánxì qǐlái.','港口是一套连接系统。','Hiểu cảng cổ cần nối thành phố với biển, sông và nội địa.','A historic port is a connected territorial system.'),
];

const _potalaP=<String>[
  '清晨的拉萨河谷光线清澈，布达拉宫从红山上层层升起。白宫、红宫与厚重墙体共同形成强烈轮廓，也回应高原气候和地形。',
  '这座建筑群不仅是宫殿，也是宗教、艺术与历史空间。壁画、雕塑、经卷和复杂室内布局保存着长期积累的文化记忆。',
  '布达拉宫、大小昭寺与罗布林卡共同构成拉萨重要历史景观。它们与城市道路、朝圣路线和高原环境保持密切联系。',
  '高海拔、材料老化、游客压力和火灾风险都要求持续监测。尊重参观秩序与宗教空间，是理解遗产价值的一部分。',
];
final _potalaA=<ReadingAnnotation>[
  _a('Bùdálā Gōng cóng Hóngshān shàng céngcéng shēngqǐ.','Cung điện Potala vươn lên từng tầng trên Hồng Sơn.','The Potala Palace rises in tiers from Red Mountain.'),
  _a('Bìhuà, diāosù hé jīngjuàn bǎocúnzhe wénhuà jìyì.','Tranh tường, tượng và kinh sách lưu giữ ký ức văn hóa.','Murals, sculpture, and scriptures preserve cultural memory.'),
  _a('Tāmen yǔ chéngshì dàolù, cháoshèng lùxiàn hé gāoyuán huánjìng mìqiè liánxì.','Chúng gắn với đường phố, tuyến hành hương và môi trường cao nguyên.','They connect closely to streets, pilgrimage routes, and the plateau.'),
  _a('Zūnzhòng cānguān zhìxù yǔ zōngjiào kōngjiān shì lǐjiě yíchǎn de yí bùfen.','Tôn trọng trật tự tham quan và không gian tôn giáo là một phần hiểu di sản.','Respect for visiting rules and sacred space is part of understanding heritage.'),
];
final _potalaW=<WordEntry>[
  _w('高原','gāoyuán','海拔较高而开阔的地区。','Cao nguyên.','plateau','🏔️'),_w('宫殿','gōngdiàn','规模较大的宫廷建筑。','Cung điện.','palace','🏯'),_w('墙体','qiángtǐ','建筑的墙面结构。','Kết cấu tường.','wall structure','🧱'),_w('经卷','jīngjuàn','宗教经典的卷册。','Kinh sách.','scripture','📜'),_w('朝圣','cháoshèng','前往神圣地点礼拜。','Hành hương.','pilgrimage','🚶'),_w('河谷','hégǔ','河流经过的谷地。','Thung lũng sông.','river valley','🏞️'),_w('老化','lǎohuà','材料随时间变旧。','Lão hóa vật liệu.','material ageing','⌛'),_w('监测','jiāncè','持续观察和记录变化。','Quan trắc.','monitoring','🔎'),
];
final _potalaD=<DiscoveryEntry>[
  _d('布达拉宫建在拉萨河谷中央的红山上。','Bùdálā Gōng jiàn zài Lāsà hégǔ zhōngyāng de Hóngshān shàng.','建筑与山体共同形成景观。','Potala nằm trên Hồng Sơn giữa thung lũng Lhasa.','The palace crowns Red Mountain in the Lhasa Valley.'),
  _d('白宫、红宫和附属建筑组成复杂建筑群。','Báigōng, Hónggōng hé fùshǔ jiànzhù zǔchéng fùzá jiànzhùqún.','它不是单一建筑。','Bạch Cung, Hồng Cung và công trình phụ tạo thành quần thể.','The White Palace, Red Palace, and ancillary structures form a complex.'),
  _d('拉萨历史景观还包括大昭寺和罗布林卡。','Lāsà lìshǐ jǐngguān hái bāokuò Dàzhāosì hé Luóbùlínkǎ.','多个地点共同构成遗产。','Cảnh quan lịch sử còn gồm Jokhang và Norbulingka.','The historic ensemble also includes Jokhang and Norbulingka.'),
  _d('高海拔环境和大量参观需要长期保护管理。','Gāo hǎibá huánjìng hé dàliàng cānguān xūyào chángqī bǎohù guǎnlǐ.','环境和客流都需要监测。','Độ cao và lượng khách đòi hỏi quản lý lâu dài.','Altitude and visitation require sustained conservation management.'),
];

const _longmenP=<String>[
  '伊河穿过洛阳南部，两岸石灰岩崖壁上分布着密集洞窟与佛龛。沿河行走，大小造像从远处轮廓逐渐变成清晰表情。',
  '龙门石窟的重要营造集中在北魏晚期至唐代。不同年代的造像比例、衣纹和面容，记录着艺术风格与社会文化的变化。',
  '题记和碑刻让石窟不仅是雕塑群，也是文字档案。它们记录供养者、年代与愿望，为研究古代宗教和社会提供线索。',
  '岩体裂隙、水分、温度变化与游客压力会影响石刻。保护工作需要结构监测、环境控制和对开放区域的谨慎管理。',
];
final _longmenA=<ReadingAnnotation>[
  _a('Yī Hé chuānguò Luòyáng nánbù, liǎng àn yábì shàng fēnbùzhe dòngkū yǔ fókān.','Sông Y chảy qua nam Lạc Dương, hai bờ có nhiều hang và khám Phật.','The Yi River passes cliffs filled with caves and niches.'),
  _a('Bùtóng niándài de zàoxiàng jìlùzhe yìshù fēnggé de biànhuà.','Tượng từ nhiều thời kỳ ghi lại thay đổi phong cách nghệ thuật.','Sculptures from different periods record changes in artistic style.'),
  _a('Tíjì hé bēikè ràng shíkū chéngwéi wénzì dàng’àn.','Đề ký và bia khắc biến hang đá thành kho tư liệu chữ viết.','Inscriptions turn the grottoes into a written archive.'),
  _a('Bǎohù xūyào jiégòu jiāncè, huánjìng kòngzhì hé jǐnshèn kāifàng.','Bảo tồn cần quan trắc kết cấu, kiểm soát môi trường và mở cửa thận trọng.','Conservation requires structural monitoring, environmental control, and careful access.'),
];
final _longmenW=<WordEntry>[
  _w('石窟','shíkū','开凿在岩石中的洞窟。','Hang đá.','grotto','🪨'),_w('佛龛','fókān','安放佛像的小空间。','Khám Phật.','Buddhist niche','🕯️'),_w('造像','zàoxiàng','制作的宗教人物形象。','Tượng tạo tác.','religious image','🗿'),_w('衣纹','yīwén','雕塑衣服上的线条。','Nếp áo điêu khắc.','drapery folds','〰️'),_w('供养者','gòngyǎngzhě','出资营造宗教作品的人。','Người cúng tiến.','patron or donor','🙏'),_w('碑刻','bēikè','刻在石碑上的文字。','Văn bia.','stone inscription','📜'),_w('裂隙','lièxì','岩石中的裂缝。','Khe nứt.','fissure','⚡'),_w('开放区域','kāifàng qūyù','允许游客进入的范围。','Khu vực mở cửa.','public access area','🚧'),
];
final _longmenD=<DiscoveryEntry>[
  _d('龙门石窟分布在伊河两岸约一公里的崖壁上。','Lóngmén Shíkū fēnbù zài Yī Hé liǎng àn yuē yì gōnglǐ de yábì shàng.','洞窟沿河集中分布。','Long Môn phân bố dọc khoảng một km vách đá hai bờ sông Y.','The grottoes line roughly one kilometre of cliffs beside the Yi River.'),
  _d('主要造像反映北魏晚期和唐代石刻艺术。','Zhǔyào zàoxiàng fǎnyìng Běiwèi wǎnqī hé Tángdài shíkè yìshù.','不同朝代留下不同风格。','Tượng phản ánh nghệ thuật Bắc Ngụy muộn và thời Đường.','The sculpture reflects late Northern Wei and Tang artistry.'),
  _d('大量题记为研究历史和社会提供资料。','Dàliàng tíjì wèi yánjiū lìshǐ hé shèhuì tígōng zīliào.','文字让石窟也成为档案。','Nhiều đề ký cung cấp tư liệu lịch sử xã hội.','Inscriptions provide evidence for historical and social research.'),
  _d('水分和岩体裂隙是石刻保护的重要风险。','Shuǐfèn hé yántǐ lièxì shì shíkè bǎohù de zhòngyào fēngxiǎn.','自然变化会影响雕刻。','Nước và khe nứt là rủi ro bảo tồn quan trọng.','Moisture and fissures are major conservation risks.'),
];

final mogaoJourney=_record('dunhuang-mogao-caves','敦煌 · 莫高窟：在沙漠崖壁阅读千年','cn-gansu-dunhuang-mogao',_mogaoP,'unesco-mogao',const['敦煌','莫高窟','丝绸之路','壁画','保护']);
final suzhouJourney=_record('suzhou-classical-gardens','苏州 · 古典园林：一步一景的微缩山水','cn-jiangsu-suzhou-classical-gardens',_suzhouP,'unesco-suzhou-gardens',const['苏州','园林','借景','江南','营造']);
final quanzhouJourney=_record('quanzhou-maritime-emporium','泉州 · 宋元海港：从街巷走向世界','cn-fujian-quanzhou-maritime-emporium',_quanzhouP,'unesco-quanzhou',const['泉州','宋元','海上贸易','古港','多元文化']);
final potalaJourney=_record('lhasa-potala-palace','拉萨 · 布达拉宫：红山上的高原宫城','cn-tibet-lhasa-potala-palace',_potalaP,'unesco-potala',const['拉萨','布达拉宫','高原','建筑','宗教文化']);
final longmenJourney=_record('luoyang-longmen-grottoes','洛阳 · 龙门石窟：伊河两岸的石刻史书','cn-henan-luoyang-longmen-grottoes',_longmenP,'unesco-longmen',const['洛阳','龙门石窟','北魏','唐代','石刻']);

final journeyExpansionBatchSixRecords=<JourneyContentRecord>[mogaoJourney,suzhouJourney,quanzhouJourney,potalaJourney,longmenJourney];
final journeyExpansionBatchSixExperiences=<DailyJourneyExperience>[
  DailyJourneyExperience(id:mogaoJourney.id,city:'敦煌',cityCode:'DNH',place:'莫高窟',appBarTitle:'敦煌 · 莫高窟',storyTitle:'沙漠洞窟故事',headline:'在崖壁阅读千年',description:'沿壁画、彩塑与丝路交流，理解古代艺术和现代保护。',discoveryTeaser:'为什么游客的呼吸也可能影响千年壁画？',distanceLabel:'2,790 km',stampSymbol:'窟',content:mogaoJourney,storyAnnotations:_mogaoA,words:_mogaoW,discoveries:_mogaoD,wonderQuestion:'数字洞窟与真实洞窟分别能带给你什么？',expressQuestion:'请用两到三句话描写晨光、崖壁、洞窟与风沙。'),
  DailyJourneyExperience(id:suzhouJourney.id,city:'苏州',cityCode:'SZV',place:'古典园林',appBarTitle:'苏州 · 古典园林',storyTitle:'江南园林故事',headline:'一步一景的微缩山水',description:'穿过花窗、廊道、假山与水池，学习借景和框景。',discoveryTeaser:'一扇窗为什么能让小园子显得更大？',distanceLabel:'1,850 km',stampSymbol:'园',content:suzhouJourney,storyAnnotations:_suzhouA,words:_suzhouW,discoveries:_suzhouD,wonderQuestion:'你会用什么景物设计一座只属于自己的小园林？',expressQuestion:'请用两到三句话描写花窗、水池、假山和远处塔影。'),
  DailyJourneyExperience(id:quanzhouJourney.id,city:'泉州',cityCode:'JJN',place:'宋元海港',appBarTitle:'泉州 · 宋元海港',storyTitle:'海上贸易故事',headline:'从街巷走向世界',description:'连接古桥、码头、宗教建筑与生产遗址，阅读海港网络。',discoveryTeaser:'一座古港为什么不能只用码头来解释？',distanceLabel:'1,280 km',stampSymbol:'港',content:quanzhouJourney,storyAnnotations:_quanzhouA,words:_quanzhouW,discoveries:_quanzhouD,wonderQuestion:'商品、语言和信仰一起流动时，城市会发生什么变化？',expressQuestion:'请用两到三句话介绍泉州古港的连接网络。'),
  DailyJourneyExperience(id:potalaJourney.id,city:'拉萨',cityCode:'LXA',place:'布达拉宫',appBarTitle:'拉萨 · 布达拉宫',storyTitle:'高原宫城故事',headline:'红山上的高原宫城',description:'从山体、宫殿、宗教空间与城市路线理解拉萨历史景观。',discoveryTeaser:'为什么布达拉宫不能离开红山与拉萨河谷来理解？',distanceLabel:'1,730 km',stampSymbol:'宫',content:potalaJourney,storyAnnotations:_potalaA,words:_potalaW,discoveries:_potalaD,wonderQuestion:'面对神圣空间，旅行者应该怎样调整自己的观看方式？',expressQuestion:'请用两到三句话描写红山、白宫、红宫与高原天空。'),
  DailyJourneyExperience(id:longmenJourney.id,city:'洛阳',cityCode:'LYA',place:'龙门石窟',appBarTitle:'洛阳 · 龙门石窟',storyTitle:'伊河石刻故事',headline:'伊河两岸的石刻史书',description:'观察洞窟、造像与碑刻，理解北魏至唐代的艺术变化。',discoveryTeaser:'石刻的衣纹和面容为什么能告诉我们年代？',distanceLabel:'1,570 km',stampSymbol:'刻',content:longmenJourney,storyAnnotations:_longmenA,words:_longmenW,discoveries:_longmenD,wonderQuestion:'你更想从龙门石窟读到艺术变化，还是普通供养者的愿望？',expressQuestion:'请用两到三句话描写伊河、崖壁、洞窟与造像。'),
];
