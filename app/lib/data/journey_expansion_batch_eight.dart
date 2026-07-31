import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchEightSources = <StorySourceRecord>[
  StorySourceRecord(id: 'unesco-taishan', title: 'Mount Taishan', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/437', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-shandong-taian-taishan'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-31'),
  StorySourceRecord(id: 'unesco-lushan', title: 'Lushan National Park', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/778', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-jiangxi-jiujiang-lushan'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-31'),
  StorySourceRecord(id: 'unesco-emei', title: 'Mount Emei Scenic Area, including Leshan Giant Buddha Scenic Area', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/779', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-sichuan-leshan-emeishan'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-31'),
  StorySourceRecord(id: 'unesco-west-lake', title: 'West Lake Cultural Landscape of Hangzhou', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/1334', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-zhejiang-hangzhou-xihu-west-lake'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-31'),
  StorySourceRecord(id: 'unesco-gulangyu', title: 'Kulangsu, a Historic International Settlement', publisher: 'UNESCO World Heritage Centre', url: 'https://whc.unesco.org/en/list/1541', kind: StorySourceKind.unesco, languageCode: 'en', geoNodeIds: ['cn-fujian-xiamen-siming-gulangyu'], verificationStatus: StoryVerificationStatus.verified, accessedOn: '2026-07-31'),
];

JourneyContentRecord _record(String id, String title, String geo, String source, List<String> paragraphs, List<String> tags) => JourneyContentRecord(
  id: id,
  title: title,
  geoNodeId: geo,
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: tags,
  sections: List.generate(paragraphs.length, (i) => JourneyStorySection(id: 'story-$i', text: paragraphs[i], sourceIds: [source])),
);

ReadingAnnotation _a(String p, String v, String e) => ReadingAnnotation(pinyin: p, vietnamese: v, english: e);
WordEntry _w(String w, String p, String c, String v, String e, String s) => WordEntry(word: w, pinyin: p, partOfSpeech: '名词', simpleChinese: c, translation: v, englishDefinition: e, symbol: s);
DiscoveryEntry _d(String t, String p, String c, String v, String e) => DiscoveryEntry(text: t, pinyin: p, simpleChinese: c, vietnamese: v, english: e);

final _items = <({String id, String city, String code, String place, String title, String headline, String teaser, String stamp, String geo, String source, List<String> paragraphs, List<ReadingAnnotation> annotations, List<WordEntry> words, List<DiscoveryEntry> discoveries})>[
  (
    id: 'taishan-sacred-mountain', city: '泰安', code: 'TNA', place: '泰山', title: '泰安 · 泰山', headline: '沿石阶读一座山的信仰记忆', teaser: '为什么泰山不仅是一座自然山峰？', stamp: '岳', geo: 'cn-shandong-taian-taishan', source: 'unesco-taishan',
    paragraphs: ['清晨，石阶从岱庙方向一路抬升。松林、碑刻和山门把登山变成一条有节奏的文化路线。', '泰山长期承载祭祀、朝山和文学书写，帝王题刻与普通游客留下的足迹共同构成山的记忆。', '自然地貌与建筑、文字、仪式在这里重叠，使泰山既是一座山，也是一部被不断续写的文化档案。', '保护泰山需要同时管理古建筑、碑刻、植被和游客流量，让庄严感不被过度商业化稀释。'],
    annotations: [_a('Shíjiē cóng Dàimiào fāngxiàng yílù táishēng.','Bậc đá dần lên cao từ hướng Đại Miếu.','Stone steps rise from the Dai Temple.'),_a('Tàishān chéngzài jìsì, cháoshān hé wénxué jìyì.','Thái Sơn mang ký ức tế lễ, hành hương và văn học.','Taishan carries ritual, pilgrimage, and literary memory.'),_a('Zìrán, jiànzhù hé wénzì zài zhèlǐ chóngdié.','Thiên nhiên, kiến trúc và chữ viết chồng lớp tại đây.','Nature, architecture, and writing overlap here.'),_a('Bǎohù xūyào guǎnlǐ yóukè liúliàng hé gǔjì.','Bảo tồn cần quản lý du khách và di tích.','Protection requires managing visitors and monuments.')],
    words: [_w('石阶','shíjiē','用石头修成的台阶。','Bậc đá.','stone steps','🪨'),_w('岱庙','Dàimiào','泰山脚下的重要古建筑群。','Đại Miếu.','Dai Temple','🏯'),_w('碑刻','bēikè','刻在石碑上的文字。','Văn bia.','stone inscription','📜'),_w('祭祀','jìsì','举行仪式表达敬意。','Tế lễ.','ritual worship','🕯️'),_w('朝山','cháoshān','前往名山礼拜。','Hành hương lên núi.','mountain pilgrimage','🥾'),_w('题刻','tíkè','题写并刻在石头上的文字。','Chữ khắc đề tặng.','inscribed calligraphy','✍️'),_w('仪式','yíshì','有固定程序的活动。','Nghi lễ.','ceremony','🎐'),_w('庄严','zhuāngyán','严肃而令人尊敬。','Trang nghiêm.','solemn','⛰️'),_w('商业化','shāngyèhuà','商业活动过度扩大。','Thương mại hóa.','commercialization','🏪')],
    discoveries: [_d('泰山兼具自然与文化价值。','Tàishān jiānjù zìrán yǔ wénhuà jiàzhí.','泰山同时重要于自然和文化。','Thái Sơn có giá trị tự nhiên và văn hóa.','Taishan has both natural and cultural value.'),_d('碑刻记录了长期登山与祭祀历史。','Bēikè jìlùle chángqī dēngshān yǔ jìsì lìshǐ.','石刻保存历史记忆。','Văn bia ghi lại lịch sử hành hương.','Inscriptions record long ritual history.'),_d('岱庙与山路构成完整文化轴线。','Dàimiào yǔ shānlù gòuchéng wénhuà zhóuxiàn.','山脚与山顶彼此连接。','Đại Miếu và đường núi tạo trục văn hóa.','The temple and route form a cultural axis.'),_d('游客管理是遗产保护的重要部分。','Yóukè guǎnlǐ shì yíchǎn bǎohù de zhòngyào bùfen.','旅行方式会影响遗产。','Quản lý khách là phần quan trọng của bảo tồn.','Visitor management is central to conservation.')]
  ),
  (
    id: 'lushan-cultural-landscape', city: '九江', code: 'JIU', place: '庐山', title: '九江 · 庐山', headline: '在云雾、别墅与诗句之间行走', teaser: '为什么庐山的风景总与文学和近代历史相连？', stamp: '庐', geo: 'cn-jiangxi-jiujiang-lushan', source: 'unesco-lushan',
    paragraphs: ['云雾贴着山谷移动，瀑布声从林间传来。庐山的道路连接峰谷、寺院、书院与近代别墅。', '历代诗人把山水写入诗句，近代不同风格的建筑又为山地景观加入新的历史层次。', '自然景观、教育传统、宗教活动与避暑文化共同塑造庐山，使它成为一处持续变化的文化景观。', '保护庐山不仅是维护单体建筑，也要守住山体、森林、水系与历史社区之间的整体关系。'],
    annotations: [_a('Yúnwù tiēzhe shāngǔ yídòng.','Mây mù trôi sát thung lũng.','Mist moves along the valleys.'),_a('Shīrén bǎ shānshuǐ xiěrù shījù.','Thi nhân đưa núi nước vào thơ.','Poets wrote the landscape into verse.'),_a('Zìrán yǔ jìndài jiànzhù gòngtóng sùzào Lúshān.','Thiên nhiên và kiến trúc cận đại cùng tạo nên Lư Sơn.','Nature and modern architecture shaped Lushan together.'),_a('Bǎohù yào shǒuzhù shāntǐ, sēnlín hé shuǐxì.','Bảo tồn phải giữ núi, rừng và nước.','Conservation must protect mountain, forest, and water systems.')],
    words: [_w('云雾','yúnwù','低空中的云和雾。','Mây mù.','mist and cloud','☁️'),_w('瀑布','pùbù','从高处落下的水流。','Thác nước.','waterfall','💦'),_w('书院','shūyuàn','古代讲学读书的地方。','Thư viện cổ.','academy','📚'),_w('别墅','biéshù','独立的住宅建筑。','Biệt thự.','villa','🏡'),_w('诗句','shījù','诗歌中的句子。','Câu thơ.','verse line','✒️'),_w('避暑','bìshǔ','到凉爽地方躲避炎热。','Tránh nóng.','summer retreat','🌿'),_w('层次','céngcì','不同部分形成的顺序关系。','Tầng lớp.','layer','🧭'),_w('水系','shuǐxì','相互连接的水体系统。','Hệ thống nước.','water system','🌊'),_w('社区','shèqū','共同生活的人群和区域。','Cộng đồng.','community','🏘️')],
    discoveries: [_d('庐山是自然与文化共同形成的景观。','Lúshān shì zìrán yǔ wénhuà gòngtóng xíngchéng de jǐngguān.','山景和文化历史彼此连接。','Lư Sơn là cảnh quan tự nhiên và văn hóa.','Lushan is a combined natural and cultural landscape.'),_d('文学长期影响人们理解庐山的方式。','Wénxué chángqī yǐngxiǎng rénmen lǐjiě Lúshān de fāngshì.','诗歌改变人们看山的方式。','Văn học ảnh hưởng cách nhìn Lư Sơn.','Literature shapes how people see Lushan.'),_d('近代别墅反映多样建筑交流。','Jìndài biéshù fǎnyìng duōyàng jiànzhù jiāoliú.','建筑留下近代交流痕迹。','Biệt thự phản ánh giao lưu kiến trúc.','Villas reflect architectural exchange.'),_d('整体保护比单独修一栋建筑更重要。','Zhěngtǐ bǎohù bǐ dāndú xiū yí dòng jiànzhù gèng zhòngyào.','保护要看整个环境。','Bảo tồn tổng thể quan trọng hơn sửa một tòa nhà.','Landscape-wide conservation matters most.')]
  ),
  (
    id: 'emeishan-sacred-ecology', city: '乐山', code: 'LZH', place: '峨眉山', title: '乐山 · 峨眉山', headline: '从云海走进佛教名山与生态走廊', teaser: '为什么峨眉山同时重要于宗教、建筑与生物多样性？', stamp: '峨', geo: 'cn-sichuan-leshan-emeishan', source: 'unesco-emei',
    paragraphs: ['山路穿过常绿林，海拔变化让植被、温度和云雾不断改变。寺院与山门散落在不同高度。', '峨眉山长期是佛教活动中心，建筑、朝山路线和自然环境共同构成名山文化。', '丰富物种依赖完整森林与水系，因此文化旅游和生态保护必须放在同一张地图上考虑。', '保护这里需要限制干扰野生动物的行为，也要维护古建筑、山路和传统朝山体验。'],
    annotations: [_a('Shānlù chuānguò chánglǜlín.','Đường núi xuyên qua rừng thường xanh.','The mountain path crosses evergreen forest.'),_a('Sìyuàn hé cháoshān lùxiàn gòuchéng míngshān wénhuà.','Chùa và tuyến hành hương tạo văn hóa danh sơn.','Temples and pilgrimage routes form sacred mountain culture.'),_a('Wùzhǒng yīlài wánzhěng sēnlín hé shuǐxì.','Các loài phụ thuộc vào rừng và nước hoàn chỉnh.','Species depend on intact forests and water systems.'),_a('Bǎohù yào jiāngù shēngtài yǔ gǔ jiànzhù.','Bảo tồn phải cân bằng sinh thái và kiến trúc cổ.','Protection must balance ecology and historic buildings.')],
    words: [_w('常绿林','chánglǜlín','一年四季保持绿色的森林。','Rừng thường xanh.','evergreen forest','🌲'),_w('海拔','hǎibá','地点高出海平面的高度。','Độ cao.','elevation','📏'),_w('寺院','sìyuàn','宗教活动和修行的建筑。','Chùa viện.','temple monastery','🏯'),_w('朝山','cháoshān','到名山礼拜。','Hành hương.','pilgrimage','🥾'),_w('物种','wùzhǒng','生物分类中的种类。','Loài sinh vật.','species','🐒'),_w('水系','shuǐxì','相互连接的河流和水体。','Hệ thống nước.','water system','💧'),_w('干扰','gānrǎo','影响正常状态。','Gây nhiễu.','disturbance','⚠️'),_w('山门','shānmén','寺院或名山入口建筑。','Cổng núi.','mountain gate','⛩️'),_w('云海','yúnhǎi','大片云层像海一样展开。','Biển mây.','sea of clouds','☁️')],
    discoveries: [_d('峨眉山兼具文化与自然遗产价值。','Éméi Shān jiānjù wénhuà yǔ zìrán yíchǎn jiàzhí.','这里同时重要于文化和生态。','Nga Mi Sơn có giá trị văn hóa và tự nhiên.','Mount Emei has cultural and natural value.'),_d('海拔变化创造丰富生态带。','Hǎibá biànhuà chuàngzào fēngfù shēngtài dài.','不同高度有不同生态。','Độ cao tạo nhiều đai sinh thái.','Elevation creates diverse ecological zones.'),_d('寺院网络与朝山路线共同形成文化景观。','Sìyuàn wǎngluò yǔ cháoshān lùxiàn gòngtóng xíngchéng wénhuà jǐngguān.','宗教活动连接整座山。','Mạng chùa và đường hành hương tạo cảnh quan văn hóa.','Temple networks and routes create a cultural landscape.'),_d('旅游管理会影响野生动物与古建筑。','Lǚyóu guǎnlǐ huì yǐngxiǎng yěshēng dòngwù yǔ gǔ jiànzhù.','游客行为影响保护。','Quản lý du lịch ảnh hưởng động vật và kiến trúc cổ.','Tourism management affects wildlife and heritage.')]
  ),
  (
    id: 'hangzhou-west-lake', city: '杭州', code: 'HGH', place: '西湖', title: '杭州 · 西湖', headline: '沿湖岸读一座被诗画塑造的城市', teaser: '为什么西湖的景色看起来像经过精心编排？', stamp: '湖', geo: 'cn-zhejiang-hangzhou-xihu-west-lake', source: 'unesco-west-lake',
    paragraphs: ['清晨的湖面很平，苏堤、白堤、岛屿、桥与远山在薄雾中形成层层景深。', '西湖不是未经改变的自然湖泊，而是长期治理、造景和文学想象共同塑造的文化景观。', '诗词、绘画与园林设计影响人们观看湖面的方式，十景等传统名称让路线带上叙事节奏。', '保护西湖需要维护水质、天际线、历史堤岸和城市生活之间的平衡。'],
    annotations: [_a('Húmiàn, dī, dǎoyǔ hé yuǎnshān xíngchéng céngcéng jǐngshēn.','Mặt hồ, đê, đảo và núi xa tạo chiều sâu nhiều lớp.','Lake, causeways, islands, and hills create layered depth.'),_a('Xīhú shì chángqī zhìlǐ hé zàojǐng de jiéguǒ.','Tây Hồ là kết quả của quản trị và tạo cảnh lâu dài.','West Lake is the result of long-term management and design.'),_a('Shīcí hé huìhuà yǐngxiǎng rénmen guānkàn húmiàn de fāngshì.','Thơ và hội họa ảnh hưởng cách nhìn hồ.','Poetry and painting shape how people see the lake.'),_a('Bǎohù yào pínghéng shuǐzhì, tiānjìxiàn hé chéngshì shēnghuó.','Bảo tồn phải cân bằng nước, đường chân trời và đời sống đô thị.','Protection balances water, skyline, and city life.')],
    words: [_w('苏堤','Sūdī','横跨西湖的重要堤岸。','Đê Tô.','Su Causeway','🌉'),_w('白堤','Báidī','西湖著名堤岸之一。','Đê Bạch.','Bai Causeway','🌿'),_w('薄雾','bówù','较轻的雾。','Sương mỏng.','light mist','🌫️'),_w('造景','zàojǐng','有意识地设计景观。','Tạo cảnh.','landscape making','🖼️'),_w('诗词','shīcí','中国传统诗歌体裁。','Thơ từ.','classical poetry','📜'),_w('十景','shíjǐng','传统选出的十处代表景色。','Mười cảnh.','ten scenic views','🔟'),_w('堤岸','dīàn','挡水并连接陆地的岸线。','Bờ đê.','causeway bank','🧱'),_w('天际线','tiānjìxiàn','建筑与天空形成的轮廓。','Đường chân trời.','skyline','🏙️'),_w('水质','shuǐzhì','水的清洁程度。','Chất lượng nước.','water quality','💧')],
    discoveries: [_d('西湖是长期人工治理形成的文化景观。','Xīhú shì chángqī réngōng zhìlǐ xíngchéng de wénhuà jǐngguān.','湖景经过长期设计和管理。','Tây Hồ là cảnh quan văn hóa được quản trị lâu dài.','West Lake is a managed cultural landscape.'),_d('堤、岛、桥与远山共同组织视线。','Dī, dǎo, qiáo yǔ yuǎnshān gòngtóng zǔzhī shìxiàn.','景物安排影响观看。','Đê, đảo, cầu và núi tổ chức tầm nhìn.','Causeways, islands, bridges, and hills organize views.'),_d('诗画传统影响西湖景点命名。','Shīhuà chuántǒng yǐngxiǎng Xīhú jǐngdiǎn mìngmíng.','文学让景色带上故事。','Truyền thống thơ họa ảnh hưởng tên cảnh.','Poetry and painting shape scenic names.'),_d('城市发展必须保护西湖天际线。','Chéngshì fāzhǎn bìxū bǎohù Xīhú tiānjìxiàn.','高楼会改变湖景。','Phát triển đô thị phải bảo vệ đường chân trời.','Urban development must protect the lake skyline.')]
  ),
  (
    id: 'xiamen-gulangyu', city: '厦门', code: 'XMN', place: '鼓浪屿', title: '厦门 · 鼓浪屿', headline: '在海风、花园与琴声中阅读近代交流', teaser: '为什么一座小岛会拥有如此多样的建筑语言？', stamp: '琴', geo: 'cn-fujian-xiamen-siming-gulangyu', source: 'unesco-gulangyu',
    paragraphs: ['渡轮靠岸后，步行小路在坡地、花园和老建筑之间展开。岛上没有普通机动车的喧闹，海风与脚步声更清晰。', '近代国际交流带来不同建筑风格、教育机构和音乐传统，本地工匠又把外来形式转化为适合海岛气候的空间。', '鼓浪屿的价值不只在单栋别墅，而在街巷、花园、公共建筑、海岸线和社区生活构成的整体。', '保护小岛需要控制游客压力、商业招牌和建筑改造，同时让居民日常生活继续存在。'],
    annotations: [_a('Bùxíng xiǎolù zài pōdì, huāyuán hé lǎo jiànzhù zhījiān zhǎnkāi.','Đường đi bộ mở ra giữa sườn dốc, vườn và nhà cổ.','Footpaths unfold among slopes, gardens, and old buildings.'),_a('Guójì jiāoliú dài lái duōyàng jiànzhù hé yīnyuè chuántǒng.','Giao lưu quốc tế mang đến kiến trúc và âm nhạc đa dạng.','International exchange brought diverse architecture and music.'),_a('Jiēxiàng, huāyuán hé hǎi ànxiàn gòuchéng zhěngtǐ.','Phố ngõ, vườn và bờ biển tạo thành tổng thể.','Lanes, gardens, and coastline form one whole.'),_a('Bǎohù yào ràng jūmín shēnghuó jìxù cúnzài.','Bảo tồn phải giữ đời sống cư dân.','Conservation must preserve resident life.')],
    words: [_w('渡轮','dùlún','在两岸之间运送乘客的船。','Phà.','ferry','⛴️'),_w('坡地','pōdì','有坡度的土地。','Đất dốc.','sloping terrain','⛰️'),_w('别墅','biéshù','独立住宅建筑。','Biệt thự.','villa','🏡'),_w('工匠','gōngjiàng','掌握手工技术的人。','Thợ thủ công.','craftsperson','🔨'),_w('海岛','hǎidǎo','海中的岛屿。','Đảo biển.','island','🏝️'),_w('街巷','jiēxiàng','城市中的街道和小巷。','Phố ngõ.','streets and lanes','🛤️'),_w('海岸线','hǎiànxiàn','陆地与海相接的线。','Đường bờ biển.','coastline','🌊'),_w('社区','shèqū','共同生活的人群和区域。','Cộng đồng.','community','🏘️'),_w('游客压力','yóukè yālì','游客过多带来的影响。','Áp lực du khách.','visitor pressure','👣')],
    discoveries: [_d('鼓浪屿是历史国际社区形成的文化景观。','Gǔlàngyǔ shì lìshǐ guójì shèqū xíngchéng de wénhuà jǐngguān.','不同文化长期在岛上交流。','Cổ Lãng Tự là cảnh quan của cộng đồng quốc tế lịch sử.','Gulangyu is a landscape shaped by a historic international community.'),_d('建筑风格经过本地工匠重新解释。','Jiànzhù fēnggé jīngguò běndì gōngjiàng chóngxīn jiěshì.','外来风格被转化为本地形式。','Phong cách được thợ địa phương diễn giải lại.','Local craftspeople adapted imported styles.'),_d('音乐教育是岛上文化传统的重要部分。','Yīnyuè jiàoyù shì dǎoshàng wénhuà chuántǒng de zhòngyào bùfen.','音乐与岛屿历史相连。','Giáo dục âm nhạc là phần quan trọng của đảo.','Music education is central to island culture.'),_d('保护需要兼顾居民生活和旅游。','Bǎohù xūyào jiāngù jūmín shēnghuó hé lǚyóu.','旅游不能挤走日常生活。','Bảo tồn phải cân bằng cư dân và du lịch.','Conservation must balance residents and tourism.')]
  ),
];

final journeyExpansionBatchEightRecords = _items.map((x) => _record(x.id, x.title, x.geo, x.source, x.paragraphs, [x.city, x.place, '文化遗产', '普通旅程'])).toList(growable: false);
final _recordById = {for (final record in journeyExpansionBatchEightRecords) record.id: record};
final journeyExpansionBatchEightExperiences = _items.map((x) => DailyJourneyExperience(
  id: x.id,
  city: x.city,
  cityCode: x.code,
  place: x.place,
  appBarTitle: x.title,
  storyTitle: '${x.place}故事',
  headline: x.headline,
  description: '通过故事、生词、发现与挑战，理解${x.place}的自然、历史和文化层次。',
  discoveryTeaser: x.teaser,
  distanceLabel: '中国文化旅程',
  stampSymbol: x.stamp,
  content: _recordById[x.id]!,
  storyAnnotations: x.annotations,
  words: x.words,
  discoveries: x.discoveries,
  wonderQuestion: '${x.place}最值得被长期保存的关系是什么？为什么？',
  expressQuestion: '请用两到三句话介绍${x.place}最鲜明的景观与文化特征。',
)).toList(growable: false);
