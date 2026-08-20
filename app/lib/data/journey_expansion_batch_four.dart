import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'honghe_hani_rice_terraces_gold_content.dart';
import 'pingyao_ancient_city_gold_content.dart';

const journeyExpansionBatchFourSources = <StorySourceRecord>[
  StorySourceRecord(id: 'unesco-pingyao', title: 'Ancient City of Ping Yao', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/812', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-shanxi-jinzhong-pingyao-ancient-city'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'shanxi-pingyao', title: '平遥古城：2800岁正青春', publisher: '山西省文化和旅游厅', url: 'https://wlt.shanxi.gov.cn/xwzx/wlxx/202305/t20230517_8565714.shtml', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-shanxi-jinzhong-pingyao-ancient-city'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-29'),
  StorySourceRecord(id: 'gjbmj-jinshang-piaohao', title: '晋商票号：防伪保密制度的创制者', publisher: '国家保密局互联网门户网站', url: 'https://www.gjbmj.gov.cn/n1/2020/0911/c413725-31858628.html', kind: StorySourceKind.government, languageCode: 'zh-CN', geoNodeIds: ['cn-shanxi-jinzhong-pingyao-ancient-city'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-08-17'),
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


final pingyaoJourney = _record(pingyaoAncientCityJourneyId,pingyaoAncientCityCanonicalTitle,'cn-shanxi-jinzhong-pingyao-ancient-city',pingyaoAncientCityGoldLevelContent(5).storyParagraphs,const ['unesco-pingyao','shanxi-pingyao','gjbmj-jinshang-piaohao'],const ['平遥','古城','晋商','票号','汇票','异地汇兑','世界遗产']);
final qufuJourney = _record('qufu-confucius-sites','曲阜 · 三孔：沿中轴读懂礼与学','cn-shandong-jining-qufu-confucius-temple',_qufuP,const ['unesco-qufu','shandong-qufu'],const ['曲阜','三孔','孔子','儒家','世界遗产']);
final leshanJourney = _record('leshan-giant-buddha','乐山 · 大佛：三江与石刻的千年守望','cn-sichuan-leshan-shizhong-giant-buddha',_leshanP,const ['unesco-leshan','leshan-government-buddha'],const ['乐山','大佛','石刻','三江','世界遗产']);
final wuyishanJourney = _record('wuyishan-nine-bend-stream','武夷山 · 九曲溪：山水之间的理学回声','cn-fujian-nanping-wuyishan-nine-bend-stream',_wuyiP,const ['unesco-wuyishan','fujian-wuyishan'],const ['武夷山','九曲溪','生态','朱子理学','世界遗产']);
final hongheJourney = _record('honghe-hani-rice-terraces',hongheHaniRiceTerracesCanonicalTitle,'cn-yunnan-honghe-yuanyang-hani-terraces',hongheHaniRiceTerracesGoldLevelContent(5).storyParagraphs,const ['unesco-honghe','yunnan-honghe'],const ['红河','元阳','哈尼梯田','赶沟人','木刻分水','世界遗产']);

final journeyExpansionBatchFourRecords=<JourneyContentRecord>[pingyaoJourney,qufuJourney,leshanJourney,wuyishanJourney,hongheJourney];
final journeyExpansionBatchFourExperiences=LazyJourneyList(<DailyJourneyExperienceBuilder>[
  () => DailyJourneyExperience(id:pingyaoJourney.id,city:'平遥',cityCode:'PYG',place:'平遥古城',appBarTitle:'平遥 · 古城',storyTitle:pingyaoAncientCityCanonicalTitle,headline:'一张汇票让谁留下',description:'跟随程砚在票号、银箱与两本账之间，看异地汇兑怎样改变人的在场与责任。',discoveryTeaser:'银子没有上路，远方为什么仍能兑付？',distanceLabel:'1,660 km',stampSymbol:'票',content:pingyaoJourney,storyAnnotations:pingyaoAncientCityGoldLevelContent(5).storyAnnotations,words:pingyaoAncientCityWords,discoveries:pingyaoAncientCityGoldLevelContent(5).discoveries,wonderQuestion:pingyaoAncientCityGoldLevelContent(5).wonderQuestion,expressQuestion:pingyaoAncientCityGoldLevelContent(5).expressQuestion),
  () => DailyJourneyExperience(id:qufuJourney.id,city:'曲阜',cityCode:'JNG',place:'孔庙',appBarTitle:'曲阜 · 三孔',storyTitle:'儒家文化故事',headline:'沿中轴读懂礼与学',description:'观察孔庙、孔府与孔林如何连接思想、教育和家族记忆。',discoveryTeaser:'为什么思想需要建筑和礼仪来传播？',distanceLabel:'1,690 km',stampSymbol:'礼',content:qufuJourney,storyAnnotations:_qufuA,words:_qufuW,discoveries:_qufuD,wonderQuestion:'你认为学习空间应该强调秩序、自由还是交流？',expressQuestion:'请用两到三句话描写古柏、石碑和层层院落形成的氛围。'),
  () => DailyJourneyExperience(id:leshanJourney.id,city:'乐山',cityCode:'LSS',place:'乐山大佛',appBarTitle:'乐山 · 大佛',storyTitle:'三江石刻故事',headline:'三江与石刻的千年守望',description:'从江面观察七十一米石刻、隐蔽排水和现代保护。',discoveryTeaser:'大佛的发髻和衣纹为什么也参与排水？',distanceLabel:'1,210 km',stampSymbol:'佛',content:leshanJourney,storyAnnotations:_leshanA,words:_leshanW,discoveries:_leshanD,wonderQuestion:'面对巨大的山体石刻，你会先观察尺度、表情还是工程细节？',expressQuestion:'请用两到三句话描写三江、红砂岩崖壁与大佛的尺度。'),
  () => DailyJourneyExperience(id:wuyishanJourney.id,city:'武夷山',cityCode:'WUS',place:'九曲溪',appBarTitle:'武夷山 · 九曲溪',storyTitle:'山水理学故事',headline:'山水之间的理学回声',description:'沿九曲溪认识丹霞森林、生物多样性与朱子文化。',discoveryTeaser:'为什么一条溪流能同时承载自然与思想史？',distanceLabel:'650 km',stampSymbol:'曲',content:wuyishanJourney,storyAnnotations:_wuyiA,words:_wuyiW,discoveries:_wuyiD,wonderQuestion:'如果在九曲溪边设一座现代书院，你希望学生怎样观察自然？',expressQuestion:'请用两到三句话描写竹筏、碧水、丹霞峰林与云雾。'),
  () => DailyJourneyExperience(id:hongheJourney.id,city:'红河',cityCode:'HHE',place:'哈尼梯田',appBarTitle:'红河 · 哈尼梯田',storyTitle:hongheHaniRiceTerracesCanonicalTitle,headline:hongheHaniRiceTerracesHeadline,description:hongheHaniRiceTerracesDescription,discoveryTeaser:hongheHaniRiceTerracesDiscoveryTeaser,distanceLabel:'680 km',stampSymbol:'田',content:hongheJourney,storyAnnotations:hongheHaniRiceTerracesGoldLevelContent(5).storyAnnotations,words:hongheHaniRiceTerracesGoldLevelContent(5).words,discoveries:hongheHaniRiceTerracesGoldLevelContent(5).discoveries,wonderQuestion:hongheHaniRiceTerracesGoldLevelContent(5).wonderQuestion,expressQuestion:hongheHaniRiceTerracesGoldLevelContent(5).expressQuestion),
]);
