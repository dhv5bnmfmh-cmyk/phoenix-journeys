import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const summerPalacePilotPhaseId = 'PILOT_N1';
const summerPalacePilotPrimaryFinding = 'PROTAGONIST_IDENTITY_MISSING';
const summerPalacePilotProtagonist = '许澄';
const summerPalacePilotRelationship = '外婆周岚';
const summerPalacePilotGoal = '为校展拍出一张她认为不需要外婆指导的“无瑕”颐和园照片';
const summerPalacePilotConflict =
    '外婆要求她看见修复痕迹，而理想光线与旧照片同时出现，迫使她作出不可兼得的选择';
const summerPalacePilotChoice =
    '放弃追逐标准风景，先捡回旧照片并把外婆、照片与湖山共同纳入构图';
const summerPalacePilotConsequence =
    '错过明信片式光线，却完成《留下痕迹的风景》并获得外婆交付旧照片的信任';
const summerPalaceStoryFunctionContract =
    '通过许澄与外婆周岚围绕“无瑕风景”和修复痕迹的冲突、选择与后果，让探索者体验修复如何保存关系与时间。';
const summerPalaceDiscoveryFunctionContract =
    '独立解释颐和园借景、对景、长廊视线组织与历史修复方法，不复述许澄的事件链。';

const summerPalaceStorySources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-summer-palace-880',
    title: 'Summer Palace, an Imperial Garden in Beijing',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/880/',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-haidian-summer-palace'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-22',
  ),
  StorySourceRecord(
    id: 'beijing-gov-summer-palace-guide',
    title: 'Summer Palace',
    publisher: 'The People’s Government of Beijing Municipality',
    url:
        'https://english.beijing.gov.cn/specials/parktours/guidevisitors/summerpalace/',
    kind: StorySourceKind.government,
    languageCode: 'en',
    geoNodeIds: ['cn-beijing-haidian-summer-palace'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-22',
  ),
];

const summerPalaceStoryParagraphs = <String>[
  '校展截稿前一天，十七岁的许澄带着相机来到颐和园。她想拍一张“没有缺点的皇家园林”，证明自己不需要外婆周岚的指导。周岚年轻时参与过长廊彩画修复，如今眼睛已经看不清细节，却坚持陪她走完旧路线。许澄嫌外婆总把镜头停在褪色、裂纹和补绘处，只想等昆明湖上的雾散去，拍到万寿山、佛香阁和长廊同时清晰的画面。走进长廊后，周岚让她别急着按快门，先看廊柱怎样遮住远山，又怎样在下一个开口把湖面送回来。许澄发现，同一座山会随着脚步忽近忽远，所谓借景不是把风景全部塞进镜头，而是选择什么出现、什么暂时退后。可她仍认定，校展需要一张完整、明亮、没有修补痕迹的作品。她还把“完整”理解为没有任何旧伤，仿佛时间也该从画面里被擦去。',
  '来到十七孔桥前，阳光终于穿过云层，许澄等候的“完美时刻”出现了。就在她举起相机时，周岚扶着石栏停下，手中的旧照片被风吹落。照片里是修复前的长廊，裂开的彩画旁站着年轻的周岚和已经去世的老师。许澄必须选择：追着光线拍下标准风景，还是先捡回照片，把外婆、裂痕与桥孔后的湖山一起收入画面。她放下原来的构图，蹲身拾起照片，又退到桥侧，让近处斑驳的纸角、外婆扶栏的手和远处万寿山形成三层对景。快门落下后，她因此错失最佳光线；阳光已经偏移，明信片式的画面消失了，照片却留下了修复者与被修复园林之间的关系。许澄把作品改名为《留下痕迹的风景》，并在说明中写道：修复不是把损伤假装不存在，而是让后来的人仍能读到失去、选择与守护。周岚不再替她调整构图，只把旧照片交给她保存。',
];

const summerPalaceStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Xiàozhǎn jiégǎo qián yì tiān, shíqī suì de Xǔ Chéng dàizhe xiàngjī láidào Yíhéyuán. Tā xiǎng pāi yì zhāng méiyǒu quēdiǎn de huángjiā yuánlín, zhèngmíng zìjǐ bù xūyào wàipó Zhōu Lán de zhǐdǎo. Zhōu Lán niánqīng shí cānyù guò Chángláng cǎihuà xiūfù, rújīn yǎnjing yǐjīng kàn bù qīng xìjié, què jiānchí péi tā zǒu wán jiù lùxiàn. Xǔ Chéng xián wàipó zǒng bǎ jìngtóu tíng zài tuìsè, lièwén hé bǔhuì chù, zhǐ xiǎng děng Kūnmíng Hú shàng de wù sànqù, pāi dào Wànshòu Shān, Fóxiāng Gé hé Chángláng tóngshí qīngxī de huàmiàn. Zǒujìn Chángláng hòu, Zhōu Lán ràng tā bié jízhe àn kuàimén, xiān kàn lángzhù zěnyàng zhēzhù yuǎnshān, yòu zěnyàng zài xià yí gè kāikǒu bǎ húmiàn sòng huílai. Xǔ Chéng fāxiàn, tóng yí zuò shān huì suízhe jiǎobù hū jìn hū yuǎn, suǒwèi jièjǐng bú shì bǎ fēngjǐng quánbù sāi jìn jìngtóu, ér shì xuǎnzé shénme chūxiàn, shénme zànshí tuìhòu. Kě tā réng rèndìng, xiàozhǎn xūyào yì zhāng wánzhěng, míngliàng, méiyǒu xiūbǔ hénjì de zuòpǐn. Tā hái bǎ wánzhěng lǐjiě wéi méiyǒu rènhé jiùshāng, fǎngfú shíjiān yě gāi cóng huàmiàn lǐ bèi cāqù.',
    vietnamese:
        'Một ngày trước hạn triển lãm trường, Hứa Trừng mười bảy tuổi mang máy ảnh đến Di Hòa Viên. Cô muốn chụp một khu vườn hoàng gia không khuyết điểm để chứng minh mình không cần bà ngoại Chu Lam hướng dẫn. Chu Lam từng phục hồi tranh màu Trường Lang và muốn cô nhìn màu phai, vết nứt cùng phần vẽ bổ sung. Trong hành lang, bà chỉ cách cột che núi xa rồi đưa mặt hồ trở lại ở khoảng mở kế tiếp. Hứa Trừng hiểu mượn cảnh là lựa chọn điều gì xuất hiện và điều gì lùi lại, nhưng vẫn tin triển lãm cần một hình ảnh sáng rõ, không có vết thương cũ.',
    english:
        'A day before her school exhibition deadline, seventeen-year-old Xu Cheng arrives at the Summer Palace with a camera. She wants a flawless imperial-garden photograph to prove she no longer needs guidance from Zhou Lan. Zhou Lan once restored Long Corridor paintings and asks her to see fading, cracks, and retouching. In the corridor she shows how columns conceal the hill and return the lake at the next opening. Xu Cheng understands borrowed scenery as a choice about what appears and recedes, yet still believes the exhibition requires a bright image without old wounds.',
  ),
  ReadingAnnotation(
    pinyin:
        'Láidào Shíqīkǒng Qiáo qián, yángguāng zhōngyú chuānguò yúncéng, Xǔ Chéng děnghòu de wánměi shíkè chūxiàn le. Jiù zài tā jǔqǐ xiàngjī shí, Zhōu Lán fúzhe shílán tíngxià, shǒu zhōng de jiù zhàopiàn bèi fēng chuīluò. Zhàopiàn lǐ shì xiūfù qián de Chángláng, lièkāi de cǎihuà páng zhànzhe niánqīng de Zhōu Lán hé yǐjīng qùshì de lǎoshī. Xǔ Chéng bìxū xuǎnzé: zhuīzhe guāngxiàn pāi xià biāozhǔn fēngjǐng, háishi xiān jiǎn huí zhàopiàn. Tā fàngxià yuánlái de gòutú, dūnshēn shíqǐ zhàopiàn, ràng bānbó zhǐjiǎo, wàipó fúlán de shǒu hé yuǎnchù Wànshòu Shān xíngchéng sān céng duìjǐng. Guāngxiàn yǐjīng piānyí, tā yīncǐ cuòshī zuìjiā guāngxiàn, míngxìnpiàn shì de huàmiàn xiāoshī le. Xǔ Chéng bǎ zuòpǐn gǎimíng wéi Liúxià Hénjì de Fēngjǐng, míngbai xiūfù bú shì mǒqù hénjì. Zhōu Lán bù zài tì tā tiáozhěng gòutú, bǎ jiù zhàopiàn jiāogěi tā bǎocún.',
    vietnamese:
        'Trước cầu Thập Thất Khổng, ánh sáng hoàn hảo xuất hiện đúng lúc bức ảnh cũ của Chu Lam bị gió thổi rơi. Hứa Trừng phải chọn giữa đuổi theo ánh sáng và nhặt ảnh. Cô bỏ bố cục cũ, nhặt ảnh trước rồi đặt góc giấy sờn, bàn tay bà và núi Vạn Thọ thành ba lớp. Cô vì thế lỡ ánh sáng đẹp nhất; khung kiểu bưu thiếp biến mất. Cô đặt tên tác phẩm “Phong cảnh lưu lại dấu vết” và hiểu phục hồi không xóa dấu vết. Chu Lam không còn chỉnh bố cục thay cô, chỉ giao bức ảnh cũ cho cô gìn giữ.',
    english:
        'At the Seventeen-Arch Bridge, perfect light arrives as Zhou Lan’s old photograph falls. Xu Cheng must choose between chasing the light and retrieving it. She abandons the old composition, recovers the photograph, and frames worn paper, her grandmother’s hand, and Longevity Hill in three layers. She therefore loses the best light and the postcard view disappears. She titles the work “A Landscape That Keeps Its Traces” and understands that restoration does not erase traces. Zhou Lan no longer adjusts the composition and entrusts the old photograph to her.',
  ),
];

const summerPalaceWords = <WordEntry>[
  WordEntry(word: '颐和园', pinyin: 'Yíhéyuán', partOfSpeech: '名词（专名）', simpleChinese: '北京著名的清代皇家园林和世界文化遗产。', translation: 'Di Hòa Viên ở Bắc Kinh.', englishDefinition: 'the Summer Palace', symbol: '🏯'),
  WordEntry(word: '昆明湖', pinyin: 'Kūnmíng Hú', partOfSpeech: '名词（专名）', simpleChinese: '颐和园内面积最大的湖。', translation: 'Hồ Côn Minh.', englishDefinition: 'Kunming Lake', symbol: '🌊'),
  WordEntry(word: '万寿山', pinyin: 'Wànshòu Shān', partOfSpeech: '名词（专名）', simpleChinese: '颐和园内的重要山景。', translation: 'Núi Vạn Thọ.', englishDefinition: 'Longevity Hill', symbol: '⛰️'),
  WordEntry(word: '长廊', pinyin: 'chángláng', partOfSpeech: '名词', simpleChinese: '很长、带有屋顶的走廊。', translation: 'Hành lang dài có mái che.', englishDefinition: 'a long covered corridor', symbol: '🖼️'),
  WordEntry(word: '皇家园林', pinyin: 'huángjiā yuánlín', partOfSpeech: '名词', simpleChinese: '为皇室建造和使用的园林。', translation: 'Vườn hoàng gia.', englishDefinition: 'an imperial garden', symbol: '👑'),
  WordEntry(word: '修复', pinyin: 'xiūfù', partOfSpeech: '动词', simpleChinese: '保护、加固并修补损坏的事物。', translation: 'Phục hồi và bảo tồn.', englishDefinition: 'to restore or conserve', symbol: '🛠️'),
  WordEntry(word: '借景', pinyin: 'jièjǐng', partOfSpeech: '名词／动词', simpleChinese: '把远处景物引入当前视野。', translation: 'Mượn cảnh xa.', englishDefinition: 'borrowed scenery', symbol: '🔭'),
  WordEntry(word: '湖光山色', pinyin: 'húguāng shānsè', partOfSpeech: '成语', simpleChinese: '湖水和山景组成的风光。', translation: 'Cảnh hồ và núi.', englishDefinition: 'lake-and-mountain scenery', symbol: '🌄'),
  WordEntry(word: '十七孔桥', pinyin: 'Shíqīkǒng Qiáo', partOfSpeech: '名词（专名）', simpleChinese: '昆明湖上的十七孔石桥。', translation: 'Cầu Thập Thất Khổng.', englishDefinition: 'the Seventeen-Arch Bridge', symbol: '🌉'),
];

const summerPalaceDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
    text: '颐和园的规划利用人的行走次序安排观看。万寿山和昆明湖构成山水骨架，长廊、亭台、桥梁与岛屿进入这个骨架。廊柱和开口交替遮蔽、放出远景，昆明湖倒影也随视角改变湖光山色的层次。“借景”通过方向、比例、前景和路线把远处景物纳入当前画面；“对景”让人在特定位置获得明确目标。观看者的脚步因此成为设计的一部分，风景在移动中连续重新构图，近处廊柱、中段湖面与远处山峰形成清楚层次。这种连续画框不是装饰性的巧合：游人从长廊转向桥岸时，视线先被建筑收紧，再被湖面打开；同一万寿山因前景变化而获得不同距离感，路线、停顿和回望共同决定景观如何被理解。',
    pinyin: 'Yíhéyuán de guīhuà lìyòng rén de xíngzǒu cìxù ānpái guānkàn. Wànshòu Shān hé Kūnmíng Hú gòuchéng shānshuǐ gǔjià. Jièjǐng bǎ yuǎnchù jǐngwù nàrù dāngqián huàmiàn, duìjǐng ràng rén huòdé míngquè mùbiāo. Zhè zhǒng liánxù huàkuāng ràng shìxiàn xiān bèi jiànzhù shōujǐn, zài bèi húmiàn dǎkāi; lùxiàn, tíngdùn hé huíwàng gòngtóng juédìng jǐngguān rúhé bèi lǐjiě.',
    simpleChinese: '颐和园用山、湖、长廊和桥安排观看路线。借景把远处景物带进当前画面，路线和停顿也会改变人怎样理解景观。',
    vietnamese: 'Di Hòa Viên tổ chức tầm nhìn theo bước chân. Núi Vạn Thọ và hồ Côn Minh tạo khung; mượn cảnh đưa cảnh xa vào hình, còn đối cảnh tạo mục tiêu rõ ràng. Khi người xem rời Trường Lang hướng về bờ cầu, kiến trúc thu hẹp tầm nhìn rồi mặt hồ mở nó ra; tuyến đi, điểm dừng và cái ngoái nhìn cùng quyết định cách cảnh quan được hiểu.',
    english: 'The Summer Palace sequences views through movement. Longevity Hill and Kunming Lake form a framework; borrowed scenery brings distant elements into the frame and opposite views create a target. As visitors move from the Long Corridor toward the bridge, architecture narrows the sightline before the lake opens it again; route, pause, and looking back shape how the landscape is understood.',
  ),
  DiscoveryEntry(
    text: '颐和园最早建成于一七五〇年，一八六〇年受到严重破坏，后来于一八八六年重建。今天的建筑、彩画和园林空间同时包含原有设计、历史损毁与后续修复。修复需要区分可保留的旧材料、必须加固的部分和后补内容，并留下记录，使后来的人判断哪些属于原作、哪些来自修复。十七孔桥既连接湖岸与南湖岛，也用水平线组织近处石栏、开阔水面和远处万寿山。遗产价值因此来自自然、人工、时间与观看方式之间被保存的关系，修复记录让这种关系能够被核对。保护人员还会通过材料分析、照片、图样和施工档案建立可追溯证据；新补部分应与旧物协调，却不能冒充原作。公开记录既帮助下一次维护，也让公众理解今日所见是长期选择的结果。',
    pinyin: 'Yíhéyuán jiànchéng yú yī qī wǔ líng nián, yī bā liù líng nián shòudào pòhuài, hòulái yú yī bā bā liù nián chóngjiàn. Xiūfù xūyào qūfēn jiù cáiliào, jiāgù bùfen hé hòubǔ nèiróng, bìng liúxià jìlù. Bǎohù rényuán hái huì tōngguò cáiliào fēnxī, zhàopiàn, túyàng hé shīgōng dàng’àn jiànlì kě zhuīsù zhèngjù; xīn bǔ bùfen bùnéng màochōng yuánzuò.',
    simpleChinese: '颐和园经历过破坏和重建。修复会保护旧材料、加固损坏部分、记录补上的内容，并用照片和档案留下可以核对的证据。',
    vietnamese: 'Di Hòa Viên được xây năm 1750, bị phá hủy năm 1860 và tái thiết năm 1886. Bảo tồn phân biệt vật liệu cũ, phần gia cố và phần bổ sung, đồng thời lưu hồ sơ. Chuyên gia còn dùng phân tích vật liệu, ảnh, bản vẽ và hồ sơ thi công để tạo bằng chứng có thể truy nguyên; phần mới phải hài hòa nhưng không được giả làm nguyên tác.',
    english: 'The Summer Palace was built in 1750, damaged in 1860, and rebuilt in 1886. Conservation distinguishes surviving material, reinforcement, and later additions while preserving records. Conservators also use material analysis, photographs, drawings, and construction archives to create traceable evidence; new work should harmonize with old fabric without pretending to be original.',
  ),
];

final summerPalaceJourneyContent = JourneyContentRecord(
  id: 'beijing-summer-palace',
  title: '北京 · 颐和园：留下痕迹的风景',
  geoNodeId: 'cn-beijing-haidian-summer-palace',
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['北京', '颐和园', '昆明湖', '万寿山', '长廊修复', '借景', '世界文化遗产'],
  sections: [
    for (var index = 0; index < summerPalaceStoryParagraphs.length; index++)
      JourneyStorySection(
        id: 'story-$index',
        text: summerPalaceStoryParagraphs[index],
        sourceIds: const ['unesco-summer-palace-880', 'beijing-gov-summer-palace-guide'],
      ),
  ],
);

final summerPalaceJourneyExperience = DailyJourneyExperience(
  id: summerPalaceJourneyContent.id,
  city: '北京',
  cityCode: 'PEK',
  place: '颐和园',
  appBarTitle: '北京 · 颐和园',
  storyTitle: '留下痕迹的风景',
  headline: '许澄必须决定镜头里要留下什么',
  description: '跟随许澄与外婆周岚，在长廊借景与园林修复之间完成一次真正的选择。',
  discoveryTeaser: '借景、对景与修复记录怎样让时间留在园林里？',
  distanceLabel: '1,670 km',
  stampSymbol: '园',
  content: summerPalaceJourneyContent,
  storyAnnotations: summerPalaceStoryAnnotations,
  words: summerPalaceWords,
  discoveries: summerPalaceDiscoveries,
  wonderQuestion: '许澄放弃“无瑕风景”后，真正改变的是照片、她对外婆的理解，还是她对修复的看法？为什么？',
  expressQuestion: '请用三到五句话写一段校展说明：解释许澄的选择怎样让“修复不是抹去痕迹”变得可见。',
);
