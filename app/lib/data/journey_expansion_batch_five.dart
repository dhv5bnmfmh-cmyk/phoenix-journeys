import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchFiveSources = <StorySourceRecord>[
  StorySourceRecord(id:'unesco-huangshan',title:'Mount Huangshan',publisher:'UNESCO World Heritage Centre',url:'https://whc.unesco.org/en/list/547',kind:StorySourceKind.unesco,languageCode:'en',geoNodeIds:['cn-anhui-huangshan-scenic-area'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'huangshan-government',title:'黄山亮相国家林草局新闻发布会',publisher:'黄山市人民政府',url:'https://www.huangshan.gov.cn/zxzx/zwyw/8419211.html',kind:StorySourceKind.government,languageCode:'zh-CN',geoNodeIds:['cn-anhui-huangshan-scenic-area'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'unesco-wulingyuan',title:'Wulingyuan Scenic and Historic Interest Area',publisher:'UNESCO World Heritage Centre',url:'https://whc.unesco.org/en/list/640',kind:StorySourceKind.unesco,languageCode:'en',geoNodeIds:['cn-hunan-zhangjiajie-wulingyuan-scenic-area'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'unesco-wulingyuan-conservation',title:'IUCN Technical Evaluation — Wulingyuan',publisher:'International Union for Conservation of Nature (IUCN)',url:'https://whc.unesco.org/en/list/640/documents/',kind:StorySourceKind.unesco,languageCode:'en',geoNodeIds:['cn-hunan-zhangjiajie-wulingyuan-scenic-area'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'henan-kaifeng',title:'古都开封焕新迎客，全景呈现风雅宋韵画卷',publisher:'河南省文化和旅游厅',url:'https://hct.henan.gov.cn/2025/06-20/3172099.html',kind:StorySourceKind.government,languageCode:'zh-CN',geoNodeIds:['cn-henan-kaifeng-song-capital'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'henan-kaifeng-museum',title:'漫游开封开启一场寻古访今的奇妙之旅',publisher:'开封市博物馆（河南省文化和旅游厅转载）',url:'https://hct.henan.gov.cn/2024/01-12/2884894.html',kind:StorySourceKind.government,languageCode:'zh-CN',geoNodeIds:['cn-henan-kaifeng-song-capital'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'dali-government',title:'大理白族自治州人民政府',publisher:'大理白族自治州人民政府',url:'https://www.dali.gov.cn/',kind:StorySourceKind.government,languageCode:'zh-CN',geoNodeIds:['cn-yunnan-dali-ancient-city'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'dali-erhai',title:'洱海',publisher:'洱海管理局（大理州人民政府发布）',url:'https://www.dali.gov.cn/dlzrmzf/c101724/pc/content/1968886945315655680/content_1968886945315655680.html',kind:StorySourceKind.government,languageCode:'zh-CN',geoNodeIds:['cn-yunnan-dali-ancient-city'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'heilongjiang-central-street',title:'哈尔滨：让历史文化建筑“活”在当下',publisher:'黑龙江省文化和旅游厅',url:'https://wlt.hlj.gov.cn/wlt/c116548/202504/c00_31830093.shtml',kind:StorySourceKind.government,languageCode:'zh-CN',geoNodeIds:['cn-heilongjiang-harbin-daoli-central-street'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
  StorySourceRecord(id:'heilongjiang-historic-district',title:'黑龙江省人民政府关于公布第一批历史文化街区的通知',publisher:'黑龙江省人民政府',url:'https://www.hlj.gov.cn/hlj/c107949/202007/c00_30631203.shtml',kind:StorySourceKind.government,languageCode:'zh-CN',geoNodeIds:['cn-heilongjiang-harbin-daoli-central-street'],verificationStatus:StoryVerificationStatus.verified,accessedOn:'2026-07-30'),
];

JourneyContentRecord _record(String id,String title,String geo,List<String> paragraphs,List<String> sources,List<String> tags)=>JourneyContentRecord(
  id:id,title:title,geoNodeId:geo,languageCode:'zh-CN',verificationStatus:StoryVerificationStatus.published,tags:tags,
  sections:List.generate(paragraphs.length,(i)=>JourneyStorySection(id:'story-$i',text:paragraphs[i],sourceIds:sources)),
);

const _huangshanP=<String>[
  '天还没有亮，你沿石阶走向黄山观景台。花岗岩峰从夜色中浮出轮廓，云层在山谷里缓慢移动，迎客松一类的黄山松扎根在岩缝之间。',
  '太阳越过云海时，峰林被分成明暗不同的层次。黄山以花岗岩峰、奇松、云海、温泉和冬雪闻名，自古进入诗歌、绘画与旅行书写。',
  '山水之美也依赖脆弱生态。高差、气候和岩石环境形成多样栖息地，古树根系、薄土和山顶植被经不起离开步道的反复踩踏。',
  '今天的游览用步道、索道、容量管理和监测平衡体验与保护。看见壮阔云海时，也要意识到每一条安全边界都在守护山体与生命。',
];
const _huangshanA=<ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Tiān hái méiyǒu liàng, nǐ yán shíjiē zǒuxiàng Huángshān guānjǐngtái.',vietnamese:'Trước bình minh, bạn theo bậc đá lên điểm ngắm Hoàng Sơn.',english:'Before dawn, you climb stone steps toward a Huangshan overlook.'),
  ReadingAnnotation(pinyin:'Tàiyáng yuèguò yúnhǎi shí, fēnglín bèi fēn chéng míng’àn bùtóng de céngcì.',vietnamese:'Khi mặt trời vượt biển mây, các đỉnh núi tách thành nhiều lớp sáng tối.',english:'Sunrise divides the peaks into layers of light and shadow.'),
  ReadingAnnotation(pinyin:'Gǔshù gēnxì, báotǔ hé shāndǐng zhíbèi jīngbuqǐ fǎnfù cǎità.',vietnamese:'Rễ cây cổ, đất mỏng và thảm thực vật không chịu được giẫm đạp.',english:'Ancient roots, thin soil, and summit plants cannot withstand trampling.'),
  ReadingAnnotation(pinyin:'Bùdào, suǒdào, róngliàng guǎnlǐ hé jiāncè pínghéng tǐyàn yǔ bǎohù.',vietnamese:'Đường đi, cáp treo, giới hạn sức chứa và quan trắc cân bằng trải nghiệm với bảo tồn.',english:'Trails, cableways, capacity limits, and monitoring balance access with protection.'),
];
const _huangshanW=<WordEntry>[
  WordEntry(word:'云海',pinyin:'yúnhǎi',partOfSpeech:'名词',simpleChinese:'像大海一样铺开的云。',translation:'Biển mây.',englishDefinition:'sea of clouds',symbol:'☁️'),
  WordEntry(word:'峰林',pinyin:'fēnglín',partOfSpeech:'名词',simpleChinese:'许多山峰组成的景观。',translation:'Quần thể đỉnh núi.',englishDefinition:'forest of peaks',symbol:'⛰️'),
  WordEntry(word:'花岗岩',pinyin:'huāgāngyán',partOfSpeech:'名词',simpleChinese:'坚硬的岩石。',translation:'Đá granit.',englishDefinition:'granite',symbol:'🪨'),
  WordEntry(word:'岩缝',pinyin:'yánfèng',partOfSpeech:'名词',simpleChinese:'岩石之间的缝隙。',translation:'Khe đá.',englishDefinition:'rock crevice',symbol:'〰️'),
  WordEntry(word:'轮廓',pinyin:'lúnkuò',partOfSpeech:'名词',simpleChinese:'物体外部的形状。',translation:'Đường nét.',englishDefinition:'outline',symbol:'◒'),
  WordEntry(word:'栖息地',pinyin:'qīxīdì',partOfSpeech:'名词',simpleChinese:'生物生活的环境。',translation:'Môi trường sống.',englishDefinition:'habitat',symbol:'🌿'),
  WordEntry(word:'踩踏',pinyin:'cǎità',partOfSpeech:'动词',simpleChinese:'用脚反复踏压。',translation:'Giẫm đạp.',englishDefinition:'to trample',symbol:'👣'),
  WordEntry(word:'容量',pinyin:'róngliàng',partOfSpeech:'名词',simpleChinese:'可以容纳的数量。',translation:'Sức chứa.',englishDefinition:'capacity',symbol:'⚖️'),
  WordEntry(word:'监测',pinyin:'jiāncè',partOfSpeech:'动词',simpleChinese:'长期观察变化。',translation:'Quan trắc.',englishDefinition:'to monitor',symbol:'🔎'),
];
const _huangshanD=<DiscoveryEntry>[
  DiscoveryEntry(text:'黄山以花岗岩峰、黄山松和云海景观闻名。',pinyin:'Huángshān yǐ huāgāngyán fēng, Huángshānsōng hé yúnhǎi wénmíng.',simpleChinese:'岩峰、松树和云海是代表景观。',vietnamese:'Đỉnh granit, thông Hoàng Sơn và biển mây là cảnh quan tiêu biểu.',english:'Granite peaks, Huangshan pines, and cloud seas define the landscape.'),
  DiscoveryEntry(text:'黄山长期影响中国山水绘画、文学与旅行文化。',pinyin:'Huángshān chángqī yǐngxiǎng Zhōngguó shānshuǐ huìhuà yǔ wénxué.',simpleChinese:'黄山也是文化意象。',vietnamese:'Hoàng Sơn ảnh hưởng lâu dài đến hội họa và văn học sơn thủy.',english:'Huangshan has long shaped Chinese landscape art and literature.'),
  DiscoveryEntry(text:'薄土、古树根系和山顶植被容易受到踩踏。',pinyin:'Báotǔ, gǔshù gēnxì hé shāndǐng zhíbèi róngyì shòudào cǎità.',simpleChinese:'离开步道可能伤害生态。',vietnamese:'Đất mỏng và cây trên đỉnh dễ bị tổn thương do giẫm đạp.',english:'Thin soils and summit vegetation are vulnerable to trampling.'),
  DiscoveryEntry(text:'游客容量和环境监测是遗产保护的一部分。',pinyin:'Yóukè róngliàng hé huánjìng jiāncè shì yíchǎn bǎohù de yí bùfen.',simpleChinese:'保护也包括管理游客数量。',vietnamese:'Giới hạn khách và quan trắc là một phần của bảo tồn.',english:'Visitor capacity and environmental monitoring support conservation.'),
];

const _zhangjiajieP=<String>[
  '清晨的雾从峡谷升起，武陵源数千根石英砂岩柱逐渐出现。峰柱狭长而陡峭，森林覆盖顶部与坡脚，溪流在深谷中连接水潭和瀑布。',
  '这些峰柱并不是突然形成。岩层经过抬升、流水切割、风化和崩塌，长期分离成今天的峰林、峡谷、洞穴与天然桥。',
  '武陵源也保存多样植物和动物。垂直岩壁、谷底水系与不同海拔森林提供多种微环境，景观价值和生态价值不能分开。',
  '观景设施让人接近高差巨大的峰林，也带来客流、工程和噪声压力。遵守步道与容量管理，是把震撼留给下一位旅行者。',
];
const _zhangjiajieA=<ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Qīngchén de wù cóng xiágǔ shēngqǐ, Wǔlíngyuán shùqiān gēn shíyīng shāyánzhù zhújiàn chūxiàn.',vietnamese:'Sương sớm dâng từ hẻm núi, để lộ hàng nghìn cột sa thạch thạch anh.',english:'Morning mist reveals thousands of quartz-sandstone pillars.'),
  ReadingAnnotation(pinyin:'Yáncéng jīngguò táishēng, liúshuǐ qiēgē, fēnghuà hé bēngtā, chángqī fēnlí chéng fēnglín.',vietnamese:'Nâng địa tầng, xói cắt, phong hóa và sụp đổ dần tạo nên rừng đỉnh.',english:'Uplift, erosion, weathering, and collapse shaped the pillar landscape.'),
  ReadingAnnotation(pinyin:'Chuízhí yánbì, gǔdǐ shuǐxì yǔ bùtóng hǎibá sēnlín tígōng duōzhǒng wēihuánjìng.',vietnamese:'Vách đứng, nước đáy thung và rừng theo độ cao tạo nhiều vi môi trường.',english:'Cliffs, valley waters, and elevational forests create varied microhabitats.'),
  ReadingAnnotation(pinyin:'Zūnshǒu bùdào yǔ róngliàng guǎnlǐ, shì bǎ zhènhàn liú gěi xià yí wèi lǚxíngzhě.',vietnamese:'Tuân thủ đường đi và sức chứa giúp giữ cảnh quan cho người đến sau.',english:'Trail and capacity rules preserve the experience for future visitors.'),
];
const _zhangjiajieW=<WordEntry>[
  WordEntry(word:'峰柱',pinyin:'fēngzhù',partOfSpeech:'名词',simpleChinese:'像柱子一样的山峰。',translation:'Cột núi.',englishDefinition:'stone pillar peak',symbol:'🗿'),
  WordEntry(word:'石英砂岩',pinyin:'shíyīng shāyán',partOfSpeech:'名词',simpleChinese:'含石英的砂岩。',translation:'Sa thạch thạch anh.',englishDefinition:'quartz sandstone',symbol:'🪨'),
  WordEntry(word:'峡谷',pinyin:'xiágǔ',partOfSpeech:'名词',simpleChinese:'山间深谷。',translation:'Hẻm núi.',englishDefinition:'gorge',symbol:'🏞️'),
  WordEntry(word:'抬升',pinyin:'táishēng',partOfSpeech:'动词',simpleChinese:'地层向上升高。',translation:'Nâng lên.',englishDefinition:'geological uplift',symbol:'⬆️'),
  WordEntry(word:'切割',pinyin:'qiēgē',partOfSpeech:'动词',simpleChinese:'水流切开地表。',translation:'Xói cắt.',englishDefinition:'to incise',symbol:'🌊'),
  WordEntry(word:'崩塌',pinyin:'bēngtā',partOfSpeech:'动词',simpleChinese:'岩石突然倒落。',translation:'Sụp đổ.',englishDefinition:'to collapse',symbol:'⚠️'),
  WordEntry(word:'天然桥',pinyin:'tiānránqiáo',partOfSpeech:'名词',simpleChinese:'自然形成的石桥。',translation:'Cầu đá tự nhiên.',englishDefinition:'natural bridge',symbol:'🌉'),
  WordEntry(word:'微环境',pinyin:'wēihuánjìng',partOfSpeech:'名词',simpleChinese:'很小范围内的环境。',translation:'Vi môi trường.',englishDefinition:'microhabitat',symbol:'🌱'),
  WordEntry(word:'高差',pinyin:'gāochā',partOfSpeech:'名词',simpleChinese:'高低之间的差距。',translation:'Chênh cao.',englishDefinition:'elevation difference',symbol:'↕️'),
];
const _zhangjiajieD=<DiscoveryEntry>[
  DiscoveryEntry(text:'武陵源分布三千多根狭长砂岩峰柱。',pinyin:'Wǔlíngyuán fēnbù sānjiān duō gēn xiácháng shāyán fēngzhù.',simpleChinese:'这里有三千多根峰柱。',vietnamese:'Vũ Lăng Nguyên có hơn ba nghìn cột sa thạch.',english:'Wulingyuan contains more than 3,000 narrow sandstone pillars.'),
  DiscoveryEntry(text:'峡谷中还有溪流、水潭、瀑布、洞穴和天然桥。',pinyin:'Xiágǔ zhōng hái yǒu xīliú, shuǐtán, pùbù, dòngxué hé tiānránqiáo.',simpleChinese:'地貌不只有峰柱。',vietnamese:'Hẻm núi còn có suối, hồ, thác, hang và cầu tự nhiên.',english:'The landscape also includes streams, pools, caves, and natural bridges.'),
  DiscoveryEntry(text:'不同高度和湿度形成多样微环境。',pinyin:'Bùtóng gāodù hé shīdù xíngchéng duōyàng wēihuánjìng.',simpleChinese:'高低和水分影响生态。',vietnamese:'Độ cao và độ ẩm khác nhau tạo nhiều vi môi trường.',english:'Elevation and moisture create diverse microhabitats.'),
  DiscoveryEntry(text:'旅游设施与客流需要服从遗产完整性保护。',pinyin:'Lǚyóu shèshī yǔ kèliú xūyào fúcóng yíchǎn wánzhěngxìng bǎohù.',simpleChinese:'便利不能破坏峰林。',vietnamese:'Hạ tầng và lượng khách phải bảo vệ tính toàn vẹn di sản.',english:'Tourism infrastructure must protect the property’s integrity.'),
];

const _kaifengP=<String>[
  '晨光照亮开封城墙和水系。你从古城街巷走向铁塔，今天看到的城市由不同时代的遗迹、重建空间和持续生活共同组成。',
  '北宋时期，东京开封府是人口密集、商业活跃的都城。街市、河道、桥梁、寺院与官署交织，夜市和坊市变化反映城市管理的新方式。',
  '黄河带来交通与土地，也多次改变城市。洪水和泥沙让旧城遗址层层叠压，因此理解开封不能只看地面建筑，还要关注考古与城市水系。',
  '今天的宋都体验需要区分历史遗存、考古证据和现代演绎。旅行不是把复原场景当作原物，而是学习它们依据什么讲述过去。',
];
const _kaifengA=<ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Chénguāng zhàoliàng Kāifēng chéngqiáng hé shuǐxì.',vietnamese:'Ánh sớm chiếu lên tường thành và hệ nước Khai Phong.',english:'Morning light reaches Kaifeng’s walls and waterways.'),
  ReadingAnnotation(pinyin:'Běisòng shíqī, Dōngjīng Kāifēng Fǔ shì rénkǒu mìjí, shāngyè huóyuè de dūchéng.',vietnamese:'Thời Bắc Tống, Đông Kinh Khai Phong là kinh đô đông dân và thương mại sôi động.',english:'Northern Song Kaifeng was a dense and commercially active capital.'),
  ReadingAnnotation(pinyin:'Hóngshuǐ hé níshā ràng jiùchéng yízhǐ céngcéng diéyā.',vietnamese:'Lũ và phù sa khiến di tích các thành cũ chồng lớp.',english:'Floods and sediment buried successive layers of the old city.'),
  ReadingAnnotation(pinyin:'Sòngdū tǐyàn xūyào qūfēn lìshǐ yícún, kǎogǔ zhèngjù hé xiàndài yǎnyì.',vietnamese:'Trải nghiệm Tống đô phải phân biệt di tích, chứng cứ khảo cổ và diễn giải hiện đại.',english:'Visitors should distinguish remains, archaeological evidence, and modern interpretation.'),
];
const _kaifengW=<WordEntry>[
  WordEntry(word:'都城',pinyin:'dūchéng',partOfSpeech:'名词',simpleChinese:'国家首都。',translation:'Kinh đô.',englishDefinition:'imperial capital',symbol:'🏯'),
  WordEntry(word:'街市',pinyin:'jiēshì',partOfSpeech:'名词',simpleChinese:'有商店和交易的街道。',translation:'Phố chợ.',englishDefinition:'market street',symbol:'🏘️'),
  WordEntry(word:'河道',pinyin:'hédào',partOfSpeech:'名词',simpleChinese:'河水流过的路线。',translation:'Lòng sông.',englishDefinition:'watercourse',symbol:'🌊'),
  WordEntry(word:'官署',pinyin:'guānshǔ',partOfSpeech:'名词',simpleChinese:'官员办公建筑。',translation:'Công sở cổ.',englishDefinition:'government office',symbol:'🏛️'),
  WordEntry(word:'夜市',pinyin:'yèshì',partOfSpeech:'名词',simpleChinese:'夜间营业的市场。',translation:'Chợ đêm.',englishDefinition:'night market',symbol:'🏮'),
  WordEntry(word:'泥沙',pinyin:'níshā',partOfSpeech:'名词',simpleChinese:'水中携带的土和沙。',translation:'Bùn cát.',englishDefinition:'sediment',symbol:'🟤'),
  WordEntry(word:'叠压',pinyin:'diéyā',partOfSpeech:'动词',simpleChinese:'一层压在另一层上。',translation:'Chồng lớp.',englishDefinition:'to overlay',symbol:'▤'),
  WordEntry(word:'考古',pinyin:'kǎogǔ',partOfSpeech:'名词',simpleChinese:'研究古代遗迹。',translation:'Khảo cổ.',englishDefinition:'archaeology',symbol:'⛏️'),
  WordEntry(word:'演绎',pinyin:'yǎnyì',partOfSpeech:'名词',simpleChinese:'根据资料重新表现。',translation:'Diễn giải.',englishDefinition:'interpretation',symbol:'🎭'),
];
const _kaifengD=<DiscoveryEntry>[
  DiscoveryEntry(text:'北宋东京是人口密集、商业活跃的都城。',pinyin:'Běisòng Dōngjīng shì rénkǒu mìjí, shāngyè huóyuè de dūchéng.',simpleChinese:'开封曾是繁华首都。',vietnamese:'Đông Kinh Bắc Tống từng là kinh đô đông đúc và thương mại phát triển.',english:'Northern Song Dongjing was a populous commercial capital.'),
  DiscoveryEntry(text:'河道、桥梁与街市共同组织城市交通和商业。',pinyin:'Hédào, qiáoliáng yǔ jiēshì gòngtóng zǔzhī chéngshì.',simpleChinese:'水路和街道一起连接城市。',vietnamese:'Sông, cầu và phố chợ cùng tổ chức giao thông và thương mại.',english:'Waterways, bridges, and markets organized urban life.'),
  DiscoveryEntry(text:'黄河洪水和泥沙形成开封城摞城现象。',pinyin:'Huánghé hóngshuǐ hé níshā xíngchéng Kāifēng chéng luò chéng xiànxiàng.',simpleChinese:'旧城遗址埋在新城下面。',vietnamese:'Lũ và phù sa tạo hiện tượng thành chồng thành.',english:'Floods and sediment produced Kaifeng’s layered buried cities.'),
  DiscoveryEntry(text:'现代景区复原不等于原址原物，需要说明证据。',pinyin:'Xiàndài jǐngqū fùyuán bù děngyú yuánzhǐ yuánwù.',simpleChinese:'复原场景要和真遗迹区分。',vietnamese:'Phục dựng hiện đại không đồng nghĩa với di tích gốc.',english:'Modern reconstructions must be distinguished from original remains.'),
];

const _daliP=<String>[
  '清晨，苍山在洱海西岸拉出长长的山影。你从大理古城的石板路出发，白墙灰瓦、院落和远处湖面组成山、城、水三层景象。',
  '大理曾是南诏和大理国的重要中心，也是多民族往来之地。古城格局、崇圣寺三塔、白族建筑与手工艺记录不同历史阶段。',
  '洱海不是城市背景板，而是高原湖泊生态系统。入湖河流、湿地、村落生活和旅游活动都会影响水质与湖岸空间。',
  '理解大理，需要同时观察文化延续和生态边界。尊重社区、减少污染、不过度装饰传统，才能让苍山洱海保持真实层次。',
];
const _daliA=<ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Qīngchén, Cāngshān zài Ěrhǎi xī’àn lāchū chángcháng de shānyǐng.',vietnamese:'Buổi sớm, Thương Sơn đổ bóng dài trên bờ tây Nhĩ Hải.',english:'At dawn, Cangshan casts a long shadow along Erhai’s western shore.'),
  ReadingAnnotation(pinyin:'Dàlǐ céng shì Nánzhào hé Dàlǐ Guó de zhòngyào zhōngxīn, yě shì duō mínzú wǎnglái zhī dì.',vietnamese:'Đại Lý từng là trung tâm của Nam Chiếu, Đại Lý và giao lưu nhiều dân tộc.',english:'Dali was a centre of Nanzhao, the Dali Kingdom, and multiethnic exchange.'),
  ReadingAnnotation(pinyin:'Ěrhǎi shì gāoyuán húpō shēngtài xìtǒng, bù shì chéngshì bèijǐngbǎn.',vietnamese:'Nhĩ Hải là hệ sinh thái hồ cao nguyên, không chỉ là phông nền đô thị.',english:'Erhai is a plateau-lake ecosystem, not merely a city backdrop.'),
  ReadingAnnotation(pinyin:'Zūnzhòng shèqū, jiǎnshǎo wūrǎn, bù guòdù zhuāngshì chuántǒng.',vietnamese:'Tôn trọng cộng đồng, giảm ô nhiễm và không trang trí hóa truyền thống.',english:'Respect communities, reduce pollution, and avoid turning tradition into decoration.'),
];
const _daliW=<WordEntry>[
  WordEntry(word:'苍山',pinyin:'Cāngshān',partOfSpeech:'名词',simpleChinese:'大理西侧的山脉。',translation:'Núi Thương Sơn.',englishDefinition:'Cangshan Mountains',symbol:'⛰️'),
  WordEntry(word:'洱海',pinyin:'Ěrhǎi',partOfSpeech:'名词',simpleChinese:'大理的高原湖泊。',translation:'Hồ Nhĩ Hải.',englishDefinition:'Erhai Lake',symbol:'🌊'),
  WordEntry(word:'院落',pinyin:'yuànluò',partOfSpeech:'名词',simpleChinese:'房屋围合的院子。',translation:'Sân nhà.',englishDefinition:'courtyard compound',symbol:'🏡'),
  WordEntry(word:'南诏',pinyin:'Nánzhào',partOfSpeech:'名词',simpleChinese:'云南历史政权。',translation:'Nam Chiếu.',englishDefinition:'Nanzhao Kingdom',symbol:'📜'),
  WordEntry(word:'多民族',pinyin:'duō mínzú',partOfSpeech:'形容词',simpleChinese:'包含多个民族。',translation:'Đa dân tộc.',englishDefinition:'multiethnic',symbol:'🤝'),
  WordEntry(word:'手工艺',pinyin:'shǒugōngyì',partOfSpeech:'名词',simpleChinese:'手工制作的技艺。',translation:'Thủ công mỹ nghệ.',englishDefinition:'handicraft',symbol:'🧵'),
  WordEntry(word:'高原湖泊',pinyin:'gāoyuán húpō',partOfSpeech:'名词',simpleChinese:'高海拔地区的湖。',translation:'Hồ cao nguyên.',englishDefinition:'plateau lake',symbol:'🏔️'),
  WordEntry(word:'水质',pinyin:'shuǐzhì',partOfSpeech:'名词',simpleChinese:'水的清洁和健康状态。',translation:'Chất lượng nước.',englishDefinition:'water quality',symbol:'💧'),
  WordEntry(word:'生态边界',pinyin:'shēngtài biānjiè',partOfSpeech:'名词',simpleChinese:'保护生态需要遵守的范围。',translation:'Ranh giới sinh thái.',englishDefinition:'ecological boundary',symbol:'🌿'),
];
const _daliD=<DiscoveryEntry>[
  DiscoveryEntry(text:'大理位于苍山与洱海之间，山、城、湖彼此关联。',pinyin:'Dàlǐ wèiyú Cāngshān yǔ Ěrhǎi zhījiān.',simpleChinese:'大理的空间由山和湖共同决定。',vietnamese:'Đại Lý nằm giữa Thương Sơn và Nhĩ Hải.',english:'Dali’s setting is shaped by Cangshan and Erhai.'),
  DiscoveryEntry(text:'南诏、大理国与多民族交流留下多层文化。',pinyin:'Nánzhào, Dàlǐ Guó yǔ duō mínzú jiāoliú liúxià duōcéng wénhuà.',simpleChinese:'大理文化来自多个历史阶段。',vietnamese:'Nam Chiếu, Đại Lý và giao lưu dân tộc để lại nhiều lớp văn hóa.',english:'Nanzhao, the Dali Kingdom, and ethnic exchange created layered heritage.'),
  DiscoveryEntry(text:'洱海水质受到河流、村落与旅游活动共同影响。',pinyin:'Ěrhǎi shuǐzhì shòudào héliú, cūnluò yǔ lǚyóu huódòng yǐngxiǎng.',simpleChinese:'保护湖泊需要共同治理。',vietnamese:'Chất lượng Nhĩ Hải chịu tác động của sông, làng và du lịch.',english:'Rivers, settlements, and tourism all affect Erhai’s water quality.'),
  DiscoveryEntry(text:'文化保护应避免把白族传统简化成装饰。',pinyin:'Wénhuà bǎohù yīng bìmiǎn bǎ Báizú chuántǒng jiǎnhuà chéng zhuāngshì.',simpleChinese:'传统不只是视觉风格。',vietnamese:'Không nên giản lược truyền thống Bạch thành trang trí.',english:'Bai tradition should not be reduced to decoration.'),
];

const _harbinP=<String>[
  '冬日清晨，松花江边的冷雾慢慢散开。你走进中央大街，面包石路面、砖墙、圆拱窗和积雪一起讲述这座城市不长却复杂的现代史。',
  '十九世纪末到二十世纪初，铁路建设和人口迁移推动哈尔滨快速发展。不同背景的居民带来建筑、商业、宗教、音乐与饮食交流。',
  '中央大街保存文艺复兴、巴洛克、折衷主义和新艺术运动等多种建筑影响，但这些建筑已经进入中国东北的气候、材料和城市生活。',
  '历史街区保护不只修外墙，还要记录用途、结构和居民记忆。活化利用如果失去真实信息，漂亮立面也可能变成没有内容的布景。',
];
const _harbinA=<ReadingAnnotation>[
  ReadingAnnotation(pinyin:'Dōngrì qīngchén, Sōnghuā Jiāng biān de lěngwù mànmàn sànkāi.',vietnamese:'Sáng mùa đông, sương lạnh bên sông Tùng Hoa dần tan.',english:'On a winter morning, cold mist lifts from the Songhua River.'),
  ReadingAnnotation(pinyin:'Tiělù jiànshè hé rénkǒu qiānyí tuīdòng Hā’ěrbīn kuàisù fāzhǎn.',vietnamese:'Đường sắt và di cư thúc đẩy Cáp Nhĩ Tân phát triển nhanh.',english:'Railway construction and migration accelerated Harbin’s growth.'),
  ReadingAnnotation(pinyin:'Duōzhǒng jiànzhù yǐngxiǎng jìnrù Zhōngguó Dōngběi de qìhòu, cáiliào hé chéngshì shēnghuó.',vietnamese:'Nhiều ảnh hưởng kiến trúc thích nghi với khí hậu, vật liệu và đời sống Đông Bắc.',english:'Architectural influences adapted to Northeast China’s climate and urban life.'),
  ReadingAnnotation(pinyin:'Lìshǐ jiēqū bǎohù bù zhǐ xiū wàiqiáng, hái yào jìlù yòngtú, jiégòu hé jūmín jìyì.',vietnamese:'Bảo tồn khu lịch sử không chỉ sửa mặt tiền mà còn ghi chức năng, kết cấu và ký ức cư dân.',english:'Historic-district conservation includes use, structure, and community memory.'),
];
const _harbinW=<WordEntry>[
  WordEntry(word:'冷雾',pinyin:'lěngwù',partOfSpeech:'名词',simpleChinese:'低温形成的雾。',translation:'Sương lạnh.',englishDefinition:'cold mist',symbol:'🌫️'),
  WordEntry(word:'面包石',pinyin:'miànbāoshí',partOfSpeech:'名词',simpleChinese:'中央大街的圆形铺路石。',translation:'Đá lát hình bánh mì.',englishDefinition:'bread-shaped paving stone',symbol:'🪨'),
  WordEntry(word:'圆拱窗',pinyin:'yuángǒngchuāng',partOfSpeech:'名词',simpleChinese:'上部是圆弧的窗。',translation:'Cửa sổ vòm tròn.',englishDefinition:'round-arched window',symbol:'🪟'),
  WordEntry(word:'铁路',pinyin:'tiělù',partOfSpeech:'名词',simpleChinese:'火车运行的道路。',translation:'Đường sắt.',englishDefinition:'railway',symbol:'🚂'),
  WordEntry(word:'迁移',pinyin:'qiānyí',partOfSpeech:'动词',simpleChinese:'从一地移动到另一地。',translation:'Di cư.',englishDefinition:'migration',symbol:'🧳'),
  WordEntry(word:'折衷主义',pinyin:'zhézhōng zhǔyì',partOfSpeech:'名词',simpleChinese:'组合多种建筑风格。',translation:'Chủ nghĩa chiết trung.',englishDefinition:'eclecticism',symbol:'🏛️'),
  WordEntry(word:'气候',pinyin:'qìhòu',partOfSpeech:'名词',simpleChinese:'长期天气特点。',translation:'Khí hậu.',englishDefinition:'climate',symbol:'❄️'),
  WordEntry(word:'活化利用',pinyin:'huóhuà lìyòng',partOfSpeech:'名词',simpleChinese:'保护后继续使用旧建筑。',translation:'Tái sử dụng thích ứng.',englishDefinition:'adaptive reuse',symbol:'🔄'),
  WordEntry(word:'布景',pinyin:'bùjǐng',partOfSpeech:'名词',simpleChinese:'为表演制作的背景。',translation:'Phông cảnh.',englishDefinition:'stage set',symbol:'🎭'),
];
const _harbinD=<DiscoveryEntry>[
  DiscoveryEntry(text:'中央大街是黑龙江省首批历史文化街区之一。',pinyin:'Zhōngyāng Dàjiē shì Hēilóngjiāng Shěng shǒupī lìshǐ wénhuà jiēqū zhī yī.',simpleChinese:'中央大街受到历史街区保护。',vietnamese:'Phố Trung Ương thuộc nhóm khu lịch sử đầu tiên của Hắc Long Giang.',english:'Central Street is among Heilongjiang’s first designated historic districts.'),
  DiscoveryEntry(text:'铁路与人口迁移推动哈尔滨在近代快速形成。',pinyin:'Tiělù yǔ rénkǒu qiānyí tuīdòng Hā’ěrbīn kuàisù xíngchéng.',simpleChinese:'哈尔滨的城市发展与铁路密切相关。',vietnamese:'Đường sắt và di cư thúc đẩy thành phố hình thành nhanh.',english:'Railways and migration drove Harbin’s rapid modern development.'),
  DiscoveryEntry(text:'中央大街建筑体现多种风格在东北城市中的融合。',pinyin:'Zhōngyāng Dàjiē jiànzhù tǐxiàn duōzhǒng fēnggé de rónghé.',simpleChinese:'多种建筑影响在这里相遇。',vietnamese:'Kiến trúc thể hiện sự giao thoa nhiều phong cách trong đô thị Đông Bắc.',english:'The street shows architectural influences merging in a Northeast Chinese city.'),
  DiscoveryEntry(text:'保护历史建筑也要保存结构、用途和社会记忆。',pinyin:'Bǎohù lìshǐ jiànzhù yě yào bǎocún jiégòu, yòngtú hé shèhuì jìyì.',simpleChinese:'保护不只是修漂亮外墙。',vietnamese:'Bảo tồn cần giữ kết cấu, công năng và ký ức xã hội.',english:'Conservation preserves structure, use, and social memory, not façades alone.'),
];

final huangshanJourney=_record('huangshan-cloud-peaks','黄山 · 云海松峰：在岩缝与云层之间','cn-anhui-huangshan-scenic-area',_huangshanP,const['unesco-huangshan','huangshan-government'],const['黄山','云海','黄山松','花岗岩','世界遗产']);
final zhangjiajieJourney=_record('zhangjiajie-wulingyuan','张家界 · 武陵源：穿过三千峰柱','cn-hunan-zhangjiajie-wulingyuan-scenic-area',_zhangjiajieP,const['unesco-wulingyuan','unesco-wulingyuan-conservation'],const['张家界','武陵源','峰柱','峡谷','世界遗产']);
final kaifengJourney=_record('kaifeng-song-capital','开封 · 宋都古城：在叠城中寻找东京','cn-henan-kaifeng-song-capital',_kaifengP,const['henan-kaifeng','henan-kaifeng-museum'],const['开封','北宋','东京城','考古','古都']);
final daliJourney=_record('dali-cangshan-erhai','大理 · 苍山洱海：山城湖的共同呼吸','cn-yunnan-dali-ancient-city',_daliP,const['dali-government','dali-erhai'],const['大理','苍山','洱海','白族','生态']);
final harbinJourney=_record('harbin-central-street','哈尔滨 · 中央大街：冰雪里的建筑记忆','cn-heilongjiang-harbin-daoli-central-street',_harbinP,const['heilongjiang-central-street','heilongjiang-historic-district'],const['哈尔滨','中央大街','历史建筑','铁路','冰雪']);

final journeyExpansionBatchFiveRecords=<JourneyContentRecord>[huangshanJourney,zhangjiajieJourney,kaifengJourney,daliJourney,harbinJourney];
final journeyExpansionBatchFiveExperiences=<DailyJourneyExperience>[
  DailyJourneyExperience(id:huangshanJourney.id,city:'黄山',cityCode:'HSG',place:'黄山风景区',appBarTitle:'黄山 · 云海松峰',storyTitle:'岩峰云海故事',headline:'在岩缝与云层之间',description:'穿过花岗岩峰、黄山松与云海，理解壮阔景观背后的脆弱生态。',discoveryTeaser:'为什么离开一步步道，也可能伤害百年古松？',distanceLabel:'1,120 km',stampSymbol:'云',content:huangshanJourney,storyAnnotations:_huangshanA,words:_huangshanW,discoveries:_huangshanD,wonderQuestion:'面对云海，你更想记录画面，还是理解它形成和被保护的方式？',expressQuestion:'请用两到三句话描写日出、云海、岩峰和黄山松的层次。'),
  DailyJourneyExperience(id:zhangjiajieJourney.id,city:'张家界',cityCode:'DYG',place:'武陵源',appBarTitle:'张家界 · 武陵源',storyTitle:'峰林地质故事',headline:'穿过三千峰柱',description:'在石英砂岩峰柱、峡谷和森林之间，阅读亿万年的地貌变化。',discoveryTeaser:'笔直峰柱是怎样从完整岩层中分离出来的？',distanceLabel:'860 km',stampSymbol:'峰',content:zhangjiajieJourney,storyAnnotations:_zhangjiajieA,words:_zhangjiajieW,discoveries:_zhangjiajieD,wonderQuestion:'如果只能用一个词描述武陵源的尺度，你会选择高、深、密还是远？',expressQuestion:'请用两到三句话描写雾、峰柱、森林和峡谷的空间层次。'),
  DailyJourneyExperience(id:kaifengJourney.id,city:'开封',cityCode:'KFS',place:'宋都古城',appBarTitle:'开封 · 宋都古城',storyTitle:'北宋城市故事',headline:'在叠城中寻找东京',description:'从街市、河道、考古与现代演绎之间，理解北宋都城。',discoveryTeaser:'为什么开封的旧城会一层一层埋在地下？',distanceLabel:'1,620 km',stampSymbol:'宋',content:kaifengJourney,storyAnnotations:_kaifengA,words:_kaifengW,discoveries:_kaifengD,wonderQuestion:'面对复原古城，你会怎样判断哪些是证据，哪些是想象？',expressQuestion:'请用两到三句话描写晨光中的城墙、河道、桥梁与铁塔。'),
  DailyJourneyExperience(id:daliJourney.id,city:'大理',cityCode:'DLU',place:'苍山洱海古城',appBarTitle:'大理 · 苍山洱海',storyTitle:'山城湖故事',headline:'山城湖的共同呼吸',description:'连接白族古城、苍山与洱海，理解文化生活和湖泊生态。',discoveryTeaser:'为什么洱海不能只被当作旅行背景？',distanceLabel:'590 km',stampSymbol:'洱',content:daliJourney,storyAnnotations:_daliA,words:_daliW,discoveries:_daliD,wonderQuestion:'旅行带来收入也带来压力，你会怎样守住洱海和社区的边界？',expressQuestion:'请用两到三句话描写苍山、白墙灰瓦与洱海的三层景象。'),
  DailyJourneyExperience(id:harbinJourney.id,city:'哈尔滨',cityCode:'HRB',place:'中央大街',appBarTitle:'哈尔滨 · 中央大街',storyTitle:'冰城建筑故事',headline:'冰雪里的建筑记忆',description:'沿面包石和历史建筑，理解铁路、迁移与东北城市文化交融。',discoveryTeaser:'为什么修好一面外墙，还不等于保护一座建筑？',distanceLabel:'2,760 km',stampSymbol:'冰',content:harbinJourney,storyAnnotations:_harbinA,words:_harbinW,discoveries:_harbinD,wonderQuestion:'一座城市应该怎样让老建筑继续被真实使用，而不是变成布景？',expressQuestion:'请用两到三句话描写积雪、面包石、砖墙与暖色窗光。'),
];
