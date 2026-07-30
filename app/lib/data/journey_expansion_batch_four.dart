import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchFourSources = <StorySourceRecord>[
  StorySourceRecord(id: 'unesco-pingyao', title: 'Ancient City of Ping Yao', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/812', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-shanxi-jinzhong-pingyao-ancient-city'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'shanxi-pingyao', title: '平遥古城：2800岁正青春', publisher: '山西省文化和旅游厅', url: 'https://wlt.shanxi.gov.cn/xwzx/wlxx/202305/t20230517_8565714.shtml', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-shanxi-jinzhong-pingyao-ancient-city'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'unesco-qufu', title: 'Temple and Cemetery of Confucius and the Kong Family Mansion in Qufu', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/704', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-shandong-jining-qufu-confucius-temple'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'shandong-qufu', title: '活起来的文化遗产，火起来的旅游市场', publisher: '山东省文化和旅游厅', url: 'https://whhly.shandong.gov.cn/art/2023/4/21/art_68375_10320513.html', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-shandong-jining-qufu-confucius-temple'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'unesco-leshan', title: 'Mount Emei Scenic Area, including Leshan Giant Buddha Scenic Area', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/779', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-sichuan-leshan-shizhong-giant-buddha'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'leshan-government-buddha', title: '乐山大佛千年石刻该如何保护', publisher: '乐山市人民政府', url: 'https://www.leshan.gov.cn/lsswszf/bmdt/92337825/cc6fc9bf3b254248ac70abcd0f0f748c.html', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-sichuan-leshan-shizhong-giant-buddha'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'unesco-wuyishan', title: 'Mount Wuyi', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/911', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-fujian-nanping-wuyishan-nine-bend-stream'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'fujian-wuyishan', title: '福建日报：一溪贯群山', publisher: '福建省水利厅', url: 'https://slt.fujian.gov.cn/wzsy/mtjj/202501/t20250106_6608039.htm', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-fujian-nanping-wuyishan-nine-bend-stream'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'unesco-honghe', title: 'Cultural Landscape of Honghe Hani Rice Terraces', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/1111', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-yunnan-honghe-yuanyang-hani-terraces'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'yunnan-honghe', title: '千年古梯田焕发新生机', publisher: '云南省农业农村厅', url: 'https://nync.yn.gov.cn/html/2021/yunnongkuanxun-new_0129/376446.html?cid=3016', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-yunnan-honghe-yuanyang-hani-terraces'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
];

JourneyContentRecord _record(String id, String title, String geo, List<String> paragraphs, List<String> sources, List<String> tags) => JourneyContentRecord(
  id: id, title: title, geoNodeId: geo, languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published, tags: tags,
  sections: List.generate(paragraphs.length, (i) => JourneyStorySection(id: 'story-$i', text: paragraphs[i], sourceIds: sources)),
);

const _pingyaoP = <String>[
  '晨光越过城墙，你从迎薰门走进平遥古城。灰砖街巷保持明清县城的格局，市楼、店铺与院落沿中轴和支路展开。',
  '古城并不是一组孤立建筑。城墙、衙署、寺庙、民居和商业街彼此连接，四大街、八小街与众多巷道共同组织居民生活。',
  '十九世纪到二十世纪初，平遥成为重要金融中心。票号用汇兑连接远方商路，深宅院落和店面至今保存晋商经营留下的痕迹。',
  '古城仍有居民生活。保护既要修缮灰砖木构，也要管理消防、排水与游客压力，让活态社区和历史格局继续共存。',
];
const _pingyaoA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Chénguāng yuèguò chéngqiáng, nǐ cóng Yíngxūn Mén zǒujìn Píngyáo Gǔchéng. Huīzhuān jiēxiàng bǎochí Míng-Qīng xiànchéng de géjú.', vietnamese: 'Ánh sớm vượt tường thành; phố gạch xám giữ bố cục huyện thành Minh–Thanh.', english: 'Grey-brick streets preserve the plan of a Ming-Qing county town.'),
  ReadingAnnotation(pinyin: 'Chéngqiáng, yáshǔ, sìmiào, mínjū hé shāngyèjiē bǐcǐ liánjiē, gòngtóng zǔzhī jūmín shēnghuó.', vietnamese: 'Tường thành, nha môn, chùa, nhà ở và phố buôn bán cùng tổ chức đời sống.', english: 'Walls, offices, temples, homes, and markets form one living city.'),
  ReadingAnnotation(pinyin: 'Shíjiǔ shìjì dào èrshí shìjì chū, Píngyáo chéngwéi zhòngyào jīnróng zhōngxīn. Piàohào yòng huìduì liánjiē yuǎnfāng shānglù.', vietnamese: 'Thế kỷ XIX–đầu XX, các phiếu hiệu Bình Dao kết nối thương lộ bằng chuyển tiền.', english: 'Draft banks made Pingyao an important financial centre.'),
  ReadingAnnotation(pinyin: 'Bǎohù jì yào xiūshàn huīzhuān mùgòu, yě yào guǎnlǐ xiāofáng, páishuǐ yǔ yóukè yālì.', vietnamese: 'Bảo tồn gồm tu bổ, phòng cháy, thoát nước và quản lý áp lực du khách.', english: 'Conservation balances repair, fire safety, drainage, and visitor pressure.'),
];
const _pingyaoW = <WordEntry>[
  WordEntry(word:'城墙',pinyin:'chéngqiáng',partOfSpeech:'名词',simpleChinese:'围绕古城的高墙。',translation:'Tường bao quanh thành cổ.',englishDefinition:'city wall',symbol:'🧱'),
  WordEntry(word:'街巷',pinyin:'jiēxiàng',partOfSpeech:'名词',simpleChinese:'街道和小巷。',translation:'Đường và ngõ.',englishDefinition:'streets and lanes',symbol:'🏘️'),
  WordEntry(word:'格局',pinyin:'géjú',partOfSpeech:'名词',simpleChinese:'整体结构和安排。',translation:'Bố cục tổng thể.',englishDefinition:'urban layout',symbol:'▦'),
  WordEntry(word:'衙署',pinyin:'yáshǔ',partOfSpeech:'名词',simpleChinese:'古代官员办公处。',translation:'Nha môn cổ.',englishDefinition:'historic government office',symbol:'🏛️'),
  WordEntry(word:'院落',pinyin:'yuànluò',partOfSpeech:'名词',simpleChinese:'房屋围成的院子。',translation:'Sân nhà truyền thống.',englishDefinition:'courtyard compound',symbol:'🏡'),
  WordEntry(word:'金融',pinyin:'jīnróng',partOfSpeech:'名词',simpleChinese:'资金流通活动。',translation:'Hoạt động tài chính.',englishDefinition:'finance',symbol:'💰'),
  WordEntry(word:'票号',pinyin:'piàohào',partOfSpeech:'名词',simpleChinese:'旧时经营汇兑的商号。',translation:'Hiệu ngân phiếu cổ.',englishDefinition:'draft bank',symbol:'📜'),
  WordEntry(word:'汇兑',pinyin:'huìduì',partOfSpeech:'名词',simpleChinese:'把钱转到异地。',translation:'Chuyển tiền liên vùng.',englishDefinition:'remittance exchange',symbol:'🔁'),
  WordEntry(word:'修缮',pinyin:'xiūshàn',partOfSpeech:'动词',simpleChinese:'修理并保护旧建筑。',translation:'Tu bổ công trình cũ.',englishDefinition:'to conserve',symbol:'🧰'),
];
const _pingyaoD = <DiscoveryEntry>[
  DiscoveryEntry(text:'平遥古城完整保存城墙、街巷、店铺、民居与寺庙组成的县城格局。',pinyin:'Píngyáo Gǔchéng wánzhěng bǎocún xiànchéng géjú.',simpleChinese:'古城的整体结构保存完整。',vietnamese:'Bố cục huyện thành được bảo tồn hoàn chỉnh.',english:'The county-town layout survives as an integrated whole.'),
  DiscoveryEntry(text:'古城与双林寺、镇国寺共同构成世界遗产。',pinyin:'Gǔchéng yǔ Shuānglín Sì, Zhènguó Sì gòngtóng gòuchéng Shìjiè Yíchǎn.',simpleChinese:'遗产包括古城和两座寺庙。',vietnamese:'Di sản gồm thành cổ và hai ngôi chùa.',english:'The property includes the city, Shuanglin Temple, and Zhenguo Temple.'),
  DiscoveryEntry(text:'票号与汇兑业务让平遥成为近代重要金融中心。',pinyin:'Piàohào yǔ huìduì yèwù ràng Píngyáo chéngwéi jīnróng zhōngxīn.',simpleChinese:'票号连接远方资金。',vietnamese:'Phiếu hiệu và chuyển tiền tạo nên trung tâm tài chính.',english:'Draft banks and remittance made Pingyao a financial hub.'),
  DiscoveryEntry(text:'活态保护同时关注居民、消防、排水与古建筑修缮。',pinyin:'Huótài bǎohù tóngshí guānzhù jūmín, xiāofáng, páishuǐ yǔ xiūshàn.',simpleChinese:'保护也要照顾日常生活。',vietnamese:'Bảo tồn sống quan tâm cư dân và hạ tầng.',english:'Living conservation includes residents and infrastructure.'),
];

const _qufuP = <String>[
  '清晨，你沿中轴走进曲阜孔庙。古柏遮住一部分天空，门坊、碑亭与院落层层展开，脚步自然慢下来。',
  '孔庙始建于公元前四百七十八年，后来多次重建扩展。今天的建筑群保存一百多座建筑、众多石碑与古树，记录历代纪念孔子的方式。',
  '孔府曾是孔子后裔生活与处理事务的地方，孔林则保存家族墓地。孔庙、孔府、孔林合称三孔，把教育、礼制与家族记忆连在一起。',
  '参观三孔不只是背诵名句。观察中轴、礼仪空间和碑刻，可以理解儒家思想如何通过建筑、教育与日常秩序长期传播。',
];
const _qufuA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Qīngchén, nǐ yán zhōngzhóu zǒujìn Qūfù Kǒngmiào. Gǔbǎi, ménfāng, bēitíng yǔ yuànluò céngcéng zhǎnkāi.',vietnamese:'Buổi sớm, trục giữa dẫn qua cây bách, cổng, đình bia và sân nối tiếp.',english:'The central axis unfolds through cypress, gates, stele pavilions, and courtyards.'),
  ReadingAnnotation(pinyin:'Kǒngmiào shǐjiàn yú gōngyuánqián sìbǎi qīshíbā nián, hòulái duōcì chóngjiàn kuòzhǎn.',vietnamese:'Khổng Miếu khởi dựng năm 478 TCN và nhiều lần tái thiết, mở rộng.',english:'The temple began in 478 BCE and expanded through repeated rebuilding.'),
  ReadingAnnotation(pinyin:'Kǒngmiào, Kǒngfǔ, Kǒnglín héchēng Sānkǒng, bǎ jiàoyù, lǐzhì yǔ jiāzú jìyì lián zài yìqǐ.',vietnamese:'Ba di tích nối giáo dục, lễ chế và ký ức gia tộc.',english:'The Three Confucian Sites connect education, ritual, and family memory.'),
  ReadingAnnotation(pinyin:'Guānchá zhōngzhóu, lǐyí kōngjiān hé bēikè, kěyǐ lǐjiě Rújiā sīxiǎng rúhé chángqī chuánbō.',vietnamese:'Trục, không gian nghi lễ và bia khắc cho thấy tư tưởng Nho gia được truyền bá.',english:'Axes, ritual spaces, and stelae show how Confucian ideas endured.'),
];
const _qufuW = <WordEntry>[
  WordEntry(word:'中轴',pinyin:'zhōngzhóu',partOfSpeech:'名词',simpleChinese:'建筑群中央的主要线。',translation:'Trục chính giữa.',englishDefinition:'central axis',symbol:'↕️'),
  WordEntry(word:'古柏',pinyin:'gǔbǎi',partOfSpeech:'名词',simpleChinese:'年代久远的柏树。',translation:'Cây bách cổ.',englishDefinition:'ancient cypress',symbol:'🌲'),
  WordEntry(word:'门坊',pinyin:'ménfāng',partOfSpeech:'名词',simpleChinese:'入口处的门和牌坊。',translation:'Cổng và phường môn.',englishDefinition:'ceremonial gateway',symbol:'⛩️'),
  WordEntry(word:'碑亭',pinyin:'bēitíng',partOfSpeech:'名词',simpleChinese:'保护石碑的亭子。',translation:'Đình che bia.',englishDefinition:'stele pavilion',symbol:'🪨'),
  WordEntry(word:'石碑',pinyin:'shíbēi',partOfSpeech:'名词',simpleChinese:'刻有文字的石头。',translation:'Bia đá.',englishDefinition:'stone stele',symbol:'📜'),
  WordEntry(word:'后裔',pinyin:'hòuyì',partOfSpeech:'名词',simpleChinese:'一个人的后代。',translation:'Hậu duệ.',englishDefinition:'descendant',symbol:'🌿'),
  WordEntry(word:'礼制',pinyin:'lǐzhì',partOfSpeech:'名词',simpleChinese:'传统礼仪制度。',translation:'Chế độ lễ nghi.',englishDefinition:'ritual system',symbol:'🎓'),
  WordEntry(word:'碑刻',pinyin:'bēikè',partOfSpeech:'名词',simpleChinese:'石碑上的刻字。',translation:'Văn khắc trên bia.',englishDefinition:'stele inscription',symbol:'✒️'),
  WordEntry(word:'传播',pinyin:'chuánbō',partOfSpeech:'动词',simpleChinese:'向更多地方传开。',translation:'Truyền bá.',englishDefinition:'to transmit',symbol:'📖'),
];
const _qufuD = <DiscoveryEntry>[
  DiscoveryEntry(text:'孔庙为纪念孔子而建，始建于公元前四百七十八年。',pinyin:'Kǒngmiào shǐjiàn yú gōngyuánqián sìbǎi qīshíbā nián.',simpleChinese:'孔庙历史超过两千年。',vietnamese:'Khổng Miếu bắt đầu năm 478 TCN.',english:'The temple was founded in 478 BCE.'),
  DiscoveryEntry(text:'孔庙保存一百多座建筑、一千多通石碑和大量古柏。',pinyin:'Kǒngmiào bǎocún yìbǎi duō zuò jiànzhù hé yìqiān duō tōng shíbēi.',simpleChinese:'建筑、石碑和古树都很丰富。',vietnamese:'Di tích lưu hơn trăm công trình và hơn nghìn bia.',english:'It preserves over a hundred buildings and more than a thousand stelae.'),
  DiscoveryEntry(text:'孔府记录孔子后裔的生活，孔林保存家族墓地。',pinyin:'Kǒngfǔ jìlù Kǒngzǐ hòuyì de shēnghuó, Kǒnglín bǎocún jiāzú mùdì.',simpleChinese:'孔府和孔林保存家族记忆。',vietnamese:'Khổng Phủ và Khổng Lâm lưu ký ức gia tộc.',english:'The mansion and cemetery preserve family history.'),
  DiscoveryEntry(text:'三孔的中轴、礼制空间与碑刻共同传播儒家文化。',pinyin:'Sānkǒng de zhōngzhóu, lǐzhì kōngjiān yǔ bēikè gòngtóng chuánbō Rújiā wénhuà.',simpleChinese:'建筑也是思想的载体。',vietnamese:'Kiến trúc và bia khắc truyền văn hóa Nho gia.',english:'Architecture and inscriptions transmit Confucian culture.'),
];

const _leshanP = <String>[
  '船行到岷江、青衣江和大渡河交汇处，乐山大佛从凌云山崖壁间显现。七十一米高的坐像俯瞰水面，人与山的尺度忽然改变。',
  '大佛开凿于八世纪。工匠直接在红砂岩中塑造头部、肩膀与双足，并把排水沟藏进发髻、衣纹和身体结构，减少雨水侵蚀。',
  '三江水流曾给行船带来风险。大佛营造与人们祈求平安有关，开凿产生的石料也落入江中，改变了岸边部分水势。',
  '红砂岩会受风化、渗水和生物生长影响。今天的保护结合监测、排水和石刻修复，让千年造像继续面对三江。',
];
const _leshanA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Chuán xíngdào Mínjiāng, Qīngyī Jiāng hé Dàdù Hé jiāohuìchù, Lèshān Dàfó cóng Língyún Shān yábì jiān xiǎnxiàn.',vietnamese:'Từ nơi ba sông gặp nhau, Đại Phật Lạc Sơn hiện trên vách Lăng Vân.',english:'The Giant Buddha appears above the confluence of three rivers.'),
  ReadingAnnotation(pinyin:'Dàfó kāizáo yú bā shìjì. Gōngjiàng zài hóngshāyán zhōng sùzào zàoxiàng, bǎ páishuǐgōu cáng jìn fàjì hé yīwén.',vietnamese:'Tượng được tạc thế kỷ VIII, với rãnh thoát nước ẩn trong tóc và nếp áo.',english:'Eighth-century builders hid drainage channels within the sculpture.'),
  ReadingAnnotation(pinyin:'Sānjiāng shuǐliú céng gěi xíngchuán dàilái fēngxiǎn, Dàfó yíngzào yǔ rénmen qíqiú píngān yǒuguān.',vietnamese:'Dòng ba sông từng nguy hiểm; việc tạo tượng gắn với ước nguyện bình an.',english:'The sculpture is tied to hopes for safety at a dangerous confluence.'),
  ReadingAnnotation(pinyin:'Hóngshāyán huì shòu fēnghuà, shènshuǐ hé shēngwù shēngzhǎng yǐngxiǎng.',vietnamese:'Sa thạch đỏ chịu phong hóa, thấm nước và sinh vật phát triển.',english:'Weathering, seepage, and biological growth affect the sandstone.'),
];
const _leshanW = <WordEntry>[
  WordEntry(word:'交汇',pinyin:'jiāohuì',partOfSpeech:'动词',simpleChinese:'不同水流相遇。',translation:'Các dòng nước gặp nhau.',englishDefinition:'to converge',symbol:'🌊'),
  WordEntry(word:'崖壁',pinyin:'yábì',partOfSpeech:'名词',simpleChinese:'陡直的山崖。',translation:'Vách núi.',englishDefinition:'cliff face',symbol:'⛰️'),
  WordEntry(word:'坐像',pinyin:'zuòxiàng',partOfSpeech:'名词',simpleChinese:'坐着姿态的造像。',translation:'Tượng ngồi.',englishDefinition:'seated statue',symbol:'🗿'),
  WordEntry(word:'开凿',pinyin:'kāizáo',partOfSpeech:'动词',simpleChinese:'在岩石中雕刻挖掘。',translation:'Đục tạc đá.',englishDefinition:'to carve',symbol:'⛏️'),
  WordEntry(word:'红砂岩',pinyin:'hóngshāyán',partOfSpeech:'名词',simpleChinese:'红色的砂岩。',translation:'Sa thạch đỏ.',englishDefinition:'red sandstone',symbol:'🟤'),
  WordEntry(word:'排水沟',pinyin:'páishuǐgōu',partOfSpeech:'名词',simpleChinese:'引走雨水的沟。',translation:'Rãnh thoát nước.',englishDefinition:'drainage channel',symbol:'💧'),
  WordEntry(word:'发髻',pinyin:'fàjì',partOfSpeech:'名词',simpleChinese:'盘在头上的头发。',translation:'Búi tóc.',englishDefinition:'hair bun',symbol:'〰️'),
  WordEntry(word:'侵蚀',pinyin:'qīnshí',partOfSpeech:'动词',simpleChinese:'水和风慢慢损坏表面。',translation:'Xói mòn.',englishDefinition:'to erode',symbol:'🌧️'),
  WordEntry(word:'风化',pinyin:'fēnghuà',partOfSpeech:'名词',simpleChinese:'岩石受环境影响变坏。',translation:'Phong hóa.',englishDefinition:'weathering',symbol:'🍃'),
];
const _leshanD = <DiscoveryEntry>[
  DiscoveryEntry(text:'乐山大佛是八世纪在红砂岩崖壁开凿的七十一米坐像。',pinyin:'Lèshān Dàfó shì bā shìjì kāizáo de qīshíyī mǐ zuòxiàng.',simpleChinese:'大佛高七十一米。',vietnamese:'Tượng cao 71 mét, tạc vào thế kỷ VIII.',english:'The 71-metre seated figure was carved in the eighth century.'),
  DiscoveryEntry(text:'大佛面对岷江、青衣江与大渡河交汇处。',pinyin:'Dàfó miànduì sān jiāng jiāohuìchù.',simpleChinese:'大佛面对三江。',vietnamese:'Tượng nhìn ra nơi ba sông gặp nhau.',english:'The Buddha faces the three-river confluence.'),
  DiscoveryEntry(text:'隐藏排水沟利用发髻与衣纹引走雨水，减缓侵蚀。',pinyin:'Yǐncáng páishuǐgōu lìyòng fàjì yǔ yīwén yǐnzǒu yǔshuǐ.',simpleChinese:'排水设计保护石刻。',vietnamese:'Rãnh ẩn dẫn nước qua tóc và nếp áo.',english:'Hidden drains move rainwater through hair and robe patterns.'),
  DiscoveryEntry(text:'监测、排水与修复共同应对红砂岩风化。',pinyin:'Jiāncè, páishuǐ yǔ xiūfù gòngtóng yìngduì hóngshāyán fēnghuà.',simpleChinese:'保护需要多种方法。',vietnamese:'Quan trắc, thoát nước và tu bổ chống phong hóa.',english:'Monitoring, drainage, and repair address sandstone weathering.'),
];

const _wuyiP = <String>[
  '竹筏顺九曲溪缓缓前行，武夷山丹霞峰林从水边升起。近处茶树带着雨珠，远处峡谷和云雾把山水分成多层。',
  '武夷山保存大片亚热带森林，是许多古老与特有物种的栖息地。九曲溪切过红色岩层，水流与峰岩共同塑造独特景观。',
  '这里也是文化交流空间。寺观、书院和摩崖石刻分布山水之间，朱熹曾在此讲学，推动理学发展并影响东亚思想文化。',
  '游览需要尊重河流承载量、森林生态和文化遗迹。保护自然多样性，也保护书院、石刻与山水相依的历史环境。',
];
const _wuyiA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Zhúfá shùn Jiǔqǔ Xī huǎnhuǎn qiánxíng, Wǔyí Shān dānxiá fēnglín cóng shuǐbiān shēngqǐ.',vietnamese:'Bè tre trôi theo Cửu Khúc; núi sa thạch đỏ vươn từ bờ nước.',english:'A bamboo raft follows the Nine Bend River beneath Danxia peaks.'),
  ReadingAnnotation(pinyin:'Wǔyí Shān bǎocún dàpiàn yàrèdài sēnlín, shì xǔduō gǔlǎo yǔ tèyǒu wùzhǒng de qīxīdì.',vietnamese:'Rừng cận nhiệt là nơi sống của nhiều loài cổ và đặc hữu.',english:'Subtropical forests shelter ancient and endemic species.'),
  ReadingAnnotation(pinyin:'Sìguàn, shūyuàn hé móyá shíkè fēnbù shānshuǐ zhījiān, Zhū Xī céng zài cǐ jiǎngxué.',vietnamese:'Chùa quán, thư viện và khắc đá gắn với việc Chu Hy giảng học.',english:'Temples, academies, and cliff inscriptions mark a landscape of learning.'),
  ReadingAnnotation(pinyin:'Bǎohù zìrán duōyàngxìng, yě bǎohù shūyuàn, shíkè yǔ shānshuǐ xiāngyī de lìshǐ huánjìng.',vietnamese:'Bảo vệ đa dạng tự nhiên và môi trường lịch sử gắn với núi nước.',english:'Protection joins biodiversity with the historic cultural setting.'),
];
const _wuyiW = <WordEntry>[
  WordEntry(word:'竹筏',pinyin:'zhúfá',partOfSpeech:'名词',simpleChinese:'竹子做的水上工具。',translation:'Bè tre.',englishDefinition:'bamboo raft',symbol:'🛶'),
  WordEntry(word:'九曲溪',pinyin:'Jiǔqǔ Xī',partOfSpeech:'名词',simpleChinese:'武夷山弯曲的河流。',translation:'Suối Cửu Khúc.',englishDefinition:'Nine Bend River',symbol:'🌊'),
  WordEntry(word:'丹霞',pinyin:'dānxiá',partOfSpeech:'名词',simpleChinese:'红色岩石形成的地貌。',translation:'Địa mạo Đan Hà.',englishDefinition:'Danxia landform',symbol:'⛰️'),
  WordEntry(word:'峡谷',pinyin:'xiágǔ',partOfSpeech:'名词',simpleChinese:'山间深长的谷地。',translation:'Hẻm núi.',englishDefinition:'gorge',symbol:'🏞️'),
  WordEntry(word:'栖息地',pinyin:'qīxīdì',partOfSpeech:'名词',simpleChinese:'生物生活的地方。',translation:'Môi trường sống.',englishDefinition:'habitat',symbol:'🌿'),
  WordEntry(word:'特有',pinyin:'tèyǒu',partOfSpeech:'形容词',simpleChinese:'某地独有。',translation:'Đặc hữu.',englishDefinition:'endemic',symbol:'🦋'),
  WordEntry(word:'书院',pinyin:'shūyuàn',partOfSpeech:'名词',simpleChinese:'古代讲学读书场所。',translation:'Thư viện học thuật cổ.',englishDefinition:'academy',symbol:'📚'),
  WordEntry(word:'摩崖石刻',pinyin:'móyá shíkè',partOfSpeech:'名词',simpleChinese:'刻在山崖上的文字图案。',translation:'Khắc đá trên vách.',englishDefinition:'cliff inscription',symbol:'✒️'),
  WordEntry(word:'承载量',pinyin:'chéngzàiliàng',partOfSpeech:'名词',simpleChinese:'环境可以承受的数量。',translation:'Sức chứa môi trường.',englishDefinition:'carrying capacity',symbol:'⚖️'),
];
const _wuyiD = <DiscoveryEntry>[
  DiscoveryEntry(text:'武夷山是保存亚热带森林多样性的重要栖息地。',pinyin:'Wǔyí Shān shì bǎocún yàrèdài sēnlín duōyàngxìng de zhòngyào qīxīdì.',simpleChinese:'这里保护很多动植物。',vietnamese:'Đây là sinh cảnh quan trọng của rừng cận nhiệt.',english:'Mount Wuyi is an important refuge for subtropical biodiversity.'),
  DiscoveryEntry(text:'九曲溪与丹霞峡谷共同形成武夷山代表性景观。',pinyin:'Jiǔqǔ Xī yǔ dānxiá xiágǔ gòngtóng xíngchéng dàibiǎoxìng jǐngguān.',simpleChinese:'河流和红色山峰相互连接。',vietnamese:'Dòng Cửu Khúc và hẻm Đan Hà tạo cảnh quan đặc trưng.',english:'The river and Danxia gorges form the signature landscape.'),
  DiscoveryEntry(text:'书院与摩崖石刻记录朱子理学在此发展传播。',pinyin:'Shūyuàn yǔ móyá shíkè jìlù Zhūzǐ Lǐxué de fāzhǎn.',simpleChinese:'山水中保存思想文化。',vietnamese:'Thư viện và khắc đá ghi lại sự phát triển Tân Nho học.',english:'Academies and inscriptions record Neo-Confucian learning.'),
  DiscoveryEntry(text:'旅游承载量管理同时保护九曲溪、森林和文化遗迹。',pinyin:'Lǚyóu chéngzàiliàng guǎnlǐ tóngshí bǎohù héliú, sēnlín hé wénhuà yíjì.',simpleChinese:'游客数量也影响保护。',vietnamese:'Quản lý sức chứa bảo vệ sông, rừng và di tích.',english:'Visitor capacity management protects nature and heritage.'),
];

const _hongheP = <String>[
  '日出越过哀牢山，元阳哈尼梯田的水面逐层亮起。森林在山顶蓄水，蘑菇房村寨位于中部，梯田沿陡坡一直延伸到河谷。',
  '哈尼族等各族居民用一千三百多年营造这套农耕系统。沟渠把森林水源引过村寨，分入层层田块，维持红米、水牛、鱼鸭共同参与的生产。',
  '森林、村寨、梯田与水系不是四幅分开的风景。上方森林涵养水源，村寨连接生活与肥料循环，下方梯田利用水和养分，形成完整生态。',
  '梯田仍在生产，也面对缺水、人口变化与旅游压力。保护需要维护沟渠、传统知识和社区收益，让农耕文化继续活在日常劳动中。',
];
const _hongheA = <ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Rìchū yuèguò Āiláo Shān, Yuányáng Hāní Tītián de shuǐmiàn zhúcéng liàngqǐ.',vietnamese:'Mặt nước ruộng bậc thang Nguyên Dương sáng dần dưới bình minh Ai Lao.',english:'Sunrise lights the flooded terraces below Ailao Mountain.'),
  ReadingAnnotation(pinyin:'Gōuqú bǎ sēnlín shuǐyuán yǐnguò cūnzhài, fēnrù céngcéng tiánkuài.',vietnamese:'Kênh dẫn nước rừng qua làng rồi chia vào từng thửa ruộng.',english:'Channels carry forest water through villages into layered fields.'),
  ReadingAnnotation(pinyin:'Sēnlín, cūnzhài, tītián yǔ shuǐxì xíngchéng wánzhěng shēngtài.',vietnamese:'Rừng, làng, ruộng và hệ nước tạo thành một sinh thái hoàn chỉnh.',english:'Forest, villages, terraces, and water form one integrated ecology.'),
  ReadingAnnotation(pinyin:'Bǎohù xūyào wéihù gōuqú, chuántǒng zhīshi hé shèqū shōuyì.',vietnamese:'Bảo tồn cần giữ kênh, tri thức truyền thống và lợi ích cộng đồng.',english:'Conservation sustains channels, knowledge, and community benefit.'),
];
const _hongheW = <WordEntry>[
  WordEntry(word:'梯田',pinyin:'tītián',partOfSpeech:'名词',simpleChinese:'山坡上的阶梯状农田。',translation:'Ruộng bậc thang.',englishDefinition:'rice terrace',symbol:'🌾'),
  WordEntry(word:'蓄水',pinyin:'xùshuǐ',partOfSpeech:'动词',simpleChinese:'保存水。',translation:'Tích nước.',englishDefinition:'to retain water',symbol:'💧'),
  WordEntry(word:'蘑菇房',pinyin:'mógufáng',partOfSpeech:'名词',simpleChinese:'哈尼传统房屋。',translation:'Nhà nấm truyền thống Hani.',englishDefinition:'mushroom-shaped house',symbol:'🏠'),
  WordEntry(word:'村寨',pinyin:'cūnzhài',partOfSpeech:'名词',simpleChinese:'乡村聚居地。',translation:'Bản làng.',englishDefinition:'village settlement',symbol:'🏘️'),
  WordEntry(word:'农耕',pinyin:'nónggēng',partOfSpeech:'名词',simpleChinese:'种田生产活动。',translation:'Canh tác nông nghiệp.',englishDefinition:'farming',symbol:'🌱'),
  WordEntry(word:'沟渠',pinyin:'gōuqú',partOfSpeech:'名词',simpleChinese:'引水的小河道。',translation:'Kênh dẫn nước.',englishDefinition:'irrigation channel',symbol:'〰️'),
  WordEntry(word:'水源',pinyin:'shuǐyuán',partOfSpeech:'名词',simpleChinese:'水的来源。',translation:'Nguồn nước.',englishDefinition:'water source',symbol:'🏔️'),
  WordEntry(word:'涵养',pinyin:'hányǎng',partOfSpeech:'动词',simpleChinese:'保存并补充水分。',translation:'Nuôi dưỡng và giữ nước.',englishDefinition:'to conserve water',symbol:'🌳'),
  WordEntry(word:'循环',pinyin:'xúnhuán',partOfSpeech:'名词',simpleChinese:'不断回到系统中使用。',translation:'Vòng tuần hoàn.',englishDefinition:'cycle',symbol:'♻️'),
];
const _hongheD = <DiscoveryEntry>[
  DiscoveryEntry(text:'哈尼梯田是延续一千三百多年的活态农耕文化景观。',pinyin:'Hāní Tītián shì yánxù yìqiān sānbǎi duō nián de huótài nónggēng jǐngguān.',simpleChinese:'梯田有一千三百多年历史。',vietnamese:'Cảnh quan canh tác sống đã kéo dài hơn 1.300 năm.',english:'The living farming landscape has developed for over 1,300 years.'),
  DiscoveryEntry(text:'森林蓄水，沟渠把水源引过村寨并送入梯田。',pinyin:'Sēnlín xùshuǐ, gōuqú bǎ shuǐyuán yǐnguò cūnzhài bìng sòngrù tītián.',simpleChinese:'水从森林流向梯田。',vietnamese:'Rừng giữ nước, kênh dẫn qua làng tới ruộng.',english:'Forests retain water and channels deliver it through villages to fields.'),
  DiscoveryEntry(text:'蘑菇房村寨位于上方森林与下方梯田之间。',pinyin:'Mógufáng cūnzhài wèiyú sēnlín yǔ tītián zhījiān.',simpleChinese:'村寨连接森林和农田。',vietnamese:'Làng nhà nấm nằm giữa rừng và ruộng.',english:'Mushroom-house villages sit between forest and terraces.'),
  DiscoveryEntry(text:'水、肥料、作物与动物循环维持完整农耕生态。',pinyin:'Shuǐ, féiliào, zuòwù yǔ dòngwù xúnhuán wéichí nónggēng shēngtài.',simpleChinese:'多种资源在系统里循环。',vietnamese:'Nước, phân, cây trồng và vật nuôi tuần hoàn trong hệ thống.',english:'Water, nutrients, crops, and animals cycle through the farming system.'),
];

final pingyaoJourney = _record('pingyao-ancient-city','平遥 · 古城：在灰砖街巷读懂晋商','cn-shanxi-jinzhong-pingyao-ancient-city',_pingyaoP,const ['unesco-pingyao','shanxi-pingyao'],const ['平遥','古城','晋商','票号','世界遗产']);
final qufuJourney = _record('qufu-confucius-sites','曲阜 · 三孔：沿中轴读懂礼与学','cn-shandong-jining-qufu-confucius-temple',_qufuP,const ['unesco-qufu','shandong-qufu'],const ['曲阜','三孔','孔子','儒家','世界遗产']);
final leshanJourney = _record('leshan-giant-buddha','乐山 · 大佛：三江与石刻的千年守望','cn-sichuan-leshan-shizhong-giant-buddha',_leshanP,const ['unesco-leshan','leshan-government-buddha'],const ['乐山','大佛','石刻','三江','世界遗产']);
final wuyishanJourney = _record('wuyishan-nine-bend-stream','武夷山 · 九曲溪：山水之间的理学回声','cn-fujian-nanping-wuyishan-nine-bend-stream',_wuyiP,const ['unesco-wuyishan','fujian-wuyishan'],const ['武夷山','九曲溪','生态','朱子理学','世界遗产']);
final hongheJourney = _record('honghe-hani-rice-terraces','红河 · 哈尼梯田：让森林的水流进稻田','cn-yunnan-honghe-yuanyang-hani-terraces',_hongheP,const ['unesco-honghe','yunnan-honghe'],const ['红河','元阳','哈尼梯田','农耕','世界遗产']);

final journeyExpansionBatchFourRecords=<JourneyContentRecord>[pingyaoJourney,qufuJourney,leshanJourney,wuyishanJourney,hongheJourney];
final journeyExpansionBatchFourExperiences=<DailyJourneyExperience>[
  DailyJourneyExperience(id:pingyaoJourney.id,city:'平遥',cityCode:'PYG',place:'平遥古城',appBarTitle:'平遥 · 古城',storyTitle:'晋商古城故事',headline:'在灰砖街巷读懂晋商',description:'穿过城墙、票号与院落，理解古代县城和金融网络。',discoveryTeaser:'没有现代银行，平遥票号怎样连接远方？',distanceLabel:'1,660 km',stampSymbol:'票',content:pingyaoJourney,storyAnnotations:_pingyaoA,words:_pingyaoW,discoveries:_pingyaoD,wonderQuestion:'如果你经营一家古代票号，最重要的是信用、速度还是安全？为什么？',expressQuestion:'请用两到三句话描写晨光中的城墙、灰砖街巷与市楼。'),
  DailyJourneyExperience(id:qufuJourney.id,city:'曲阜',cityCode:'JNG',place:'孔庙',appBarTitle:'曲阜 · 三孔',storyTitle:'儒家文化故事',headline:'沿中轴读懂礼与学',description:'观察孔庙、孔府与孔林如何连接思想、教育和家族记忆。',discoveryTeaser:'为什么思想需要建筑和礼仪来传播？',distanceLabel:'1,690 km',stampSymbol:'礼',content:qufuJourney,storyAnnotations:_qufuA,words:_qufuW,discoveries:_qufuD,wonderQuestion:'你认为学习空间应该强调秩序、自由还是交流？',expressQuestion:'请用两到三句话描写古柏、石碑和层层院落形成的氛围。'),
  DailyJourneyExperience(id:leshanJourney.id,city:'乐山',cityCode:'LSS',place:'乐山大佛',appBarTitle:'乐山 · 大佛',storyTitle:'三江石刻故事',headline:'三江与石刻的千年守望',description:'从江面观察七十一米石刻、隐蔽排水和现代保护。',discoveryTeaser:'大佛的发髻和衣纹为什么也参与排水？',distanceLabel:'1,210 km',stampSymbol:'佛',content:leshanJourney,storyAnnotations:_leshanA,words:_leshanW,discoveries:_leshanD,wonderQuestion:'面对巨大的山体石刻，你会先观察尺度、表情还是工程细节？',expressQuestion:'请用两到三句话描写三江、红砂岩崖壁与大佛的尺度。'),
  DailyJourneyExperience(id:wuyishanJourney.id,city:'武夷山',cityCode:'WUS',place:'九曲溪',appBarTitle:'武夷山 · 九曲溪',storyTitle:'山水理学故事',headline:'山水之间的理学回声',description:'沿九曲溪认识丹霞森林、生物多样性与朱子文化。',discoveryTeaser:'为什么一条溪流能同时承载自然与思想史？',distanceLabel:'650 km',stampSymbol:'曲',content:wuyishanJourney,storyAnnotations:_wuyiA,words:_wuyiW,discoveries:_wuyiD,wonderQuestion:'如果在九曲溪边设一座现代书院，你希望学生怎样观察自然？',expressQuestion:'请用两到三句话描写竹筏、碧水、丹霞峰林与云雾。'),
  DailyJourneyExperience(id:hongheJourney.id,city:'红河',cityCode:'HHE',place:'哈尼梯田',appBarTitle:'红河 · 哈尼梯田',storyTitle:'山地农耕故事',headline:'让森林的水流进稻田',description:'理解森林、村寨、梯田与水系如何组成活态农耕生态。',discoveryTeaser:'山顶森林为什么决定山下梯田的收成？',distanceLabel:'680 km',stampSymbol:'田',content:hongheJourney,storyAnnotations:_hongheA,words:_hongheW,discoveries:_hongheD,wonderQuestion:'如果只能保护森林、沟渠、村寨或梯田中的一项，你会怎样解释它们不能分开？',expressQuestion:'请用两到三句话描写日出、云海与层层水田的颜色变化。'),
];
