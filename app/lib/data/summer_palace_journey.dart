import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const summerPalacePilotPhaseId = 'PILOT_N1';
const summerPalacePilotPrimaryFinding = 'PROTAGONIST_IDENTITY_MISSING';
const summerPalacePilotProtagonist = '许澄';
const summerPalacePilotRelationship = '外婆周岚';
const summerPalacePilotGoal = '为校展拍出一张她认为不需要外婆指导的“无瑕”颐和园照片';
const summerPalacePilotConflict = '外婆要求她看见修复痕迹，而理想光线与旧照片同时出现，迫使她作出不可兼得的选择';
const summerPalacePilotChoice = '放弃追逐标准风景，先捡回旧照片并把外婆、照片与湖山共同纳入构图';
const summerPalacePilotConsequence = '错过明信片式光线，却完成《留下痕迹的风景》并获得外婆交付旧照片的信任';
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
  '来到十七孔桥前，阳光终于穿过云层，许澄等候的“完美时刻”出现了。就在她举起相机时，周岚扶着石栏停下，手中的旧照片被风吹落。照片里是修复前的长廊，裂开的彩画旁站着年轻的周岚和已经去世的老师。许澄必须选择：追着光线拍下标准风景，还是先捡回照片，把外婆、裂痕与桥孔后的湖山一起收入画面。她放下原来的构图，蹲身拾起照片，又退到桥侧，让近处斑驳的纸角、外婆扶栏的手和远处万寿山形成三层对景。快门落下后，光线已经偏移，明信片式的画面消失了，照片却留下了修复者与被修复园林之间的关系。许澄把作品改名为《留下痕迹的风景》，并在说明中写道：修复不是把损伤假装不存在，而是让后来的人仍能读到失去、选择与守护。周岚第一次没有替她调整构图，只把旧照片交给她保存。',
];

const summerPalaceStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Xiàozhǎn jiégǎo qián yì tiān, shíqī suì de Xǔ Chéng dàizhe xiàngjī láidào Yíhéyuán. Tā xiǎng pāi yì zhāng méiyǒu quēdiǎn de huángjiā yuánlín, zhèngmíng zìjǐ bù xūyào wàipó Zhōu Lán de zhǐdǎo. Zhōu Lán niánqīng shí cānyù guò Chángláng cǎihuà xiūfù, rújīn yǎnjing yǐjīng kàn bù qīng xìjié, què jiānchí péi tā zǒu wán jiù lùxiàn. Zǒujìn Chángláng hòu, Zhōu Lán ràng tā xiān kàn lángzhù zěnyàng zhēzhù yuǎnshān, yòu zěnyàng zài xià yí gè kāikǒu bǎ húmiàn sòng huílai. Xǔ Chéng fāxiàn, jièjǐng bú shì bǎ fēngjǐng quánbù sāi jìn jìngtóu, ér shì xuǎnzé shénme chūxiàn, shénme zànshí tuìhòu.',
    vietnamese:
        'Một ngày trước hạn triển lãm trường, Hứa Trừng mười bảy tuổi mang máy ảnh đến Di Hòa Viên. Cô muốn chụp một “khu vườn hoàng gia không khuyết điểm” để chứng minh mình không cần bà ngoại Chu Lam hướng dẫn. Chu Lam từng tham gia phục hồi tranh màu Trường Lang; nay mắt bà không còn nhìn rõ chi tiết nhưng vẫn đi cùng cháu trên tuyến đường cũ. Trong hành lang, bà bảo Hứa Trừng nhìn cách các cột che núi xa rồi đưa mặt hồ trở lại ở khoảng mở kế tiếp. Cô nhận ra mượn cảnh không phải nhét mọi phong cảnh vào ống kính, mà là lựa chọn điều gì xuất hiện và điều gì tạm lùi lại. Tuy vậy, cô vẫn coi “hoàn chỉnh” là không có vết thương cũ, như thể thời gian cũng phải bị xóa khỏi bức ảnh.',
    english:
        'A day before her school exhibition deadline, seventeen-year-old Xu Cheng comes to the Summer Palace with a camera. She wants a “flawless imperial garden” photograph to prove she no longer needs guidance from her grandmother Zhou Lan. Zhou Lan once helped restore Long Corridor paintings and, despite failing eyesight, insists on retracing the old route with her. Inside the corridor, she asks Xu Cheng to watch how columns conceal the distant hill and return the lake through the next opening. Xu Cheng realizes that borrowed scenery is not a matter of forcing every view into the lens, but of choosing what appears and what recedes. She still equates completeness with the absence of old wounds, as though time itself should be erased from the image.',
  ),
  ReadingAnnotation(
    pinyin:
        'Láidào Shíqīkǒng Qiáo qián, yángguāng zhōngyú chuānguò yúncéng, Xǔ Chéng děnghòu de wánměi shíkè chūxiàn le. Jiù zài tā jǔqǐ xiàngjī shí, Zhōu Lán fúzhe shílán tíngxià, shǒu zhōng de jiù zhàopiàn bèi fēng chuīluò. Xǔ Chéng bìxū xuǎnzé: zhuīzhe guāngxiàn pāi xià biāozhǔn fēngjǐng, háishi xiān jiǎn huí zhàopiàn. Tā fàngxià yuánlái de gòutú, ràng jìnchù bānbó de zhǐjiǎo, wàipó fúlán de shǒu hé yuǎnchù Wànshòu Shān xíngchéng sān céng duìjǐng. Míngxìnpiàn shì de huàmiàn xiāoshī le, zhàopiàn què liúxià le xiūfùzhě yǔ bèi xiūfù yuánlín zhījiān de guānxì. Tā míngbai xiūfù bú shì bǎ sǔnshāng jiǎzhuāng bù cúnzài, ér shì ràng hòulái de rén réng néng dúdào shīqù, xuǎnzé yǔ shǒuhù.',
    vietnamese:
        'Trước cầu Thập Thất Khổng, ánh nắng cuối cùng xuyên mây và khoảnh khắc hoàn hảo Hứa Trừng chờ đợi đã xuất hiện. Đúng lúc cô nâng máy ảnh, Chu Lam dừng bên lan can đá và bức ảnh cũ trong tay bà bị gió thổi rơi. Hứa Trừng phải chọn chạy theo ánh sáng để chụp phong cảnh chuẩn hay nhặt ảnh trước. Cô bỏ bố cục cũ, để góc giấy sờn ở gần, bàn tay bà trên lan can và núi Vạn Thọ ở xa tạo thành ba lớp đối cảnh. Khung hình kiểu bưu thiếp biến mất, nhưng bức ảnh mới giữ lại mối quan hệ giữa người phục hồi và khu vườn được phục hồi. Cô hiểu rằng phục hồi không giả vờ tổn hại chưa từng tồn tại, mà giúp người sau vẫn đọc được mất mát, lựa chọn và sự gìn giữ.',
    english:
        'At the Seventeen-Arch Bridge, sunlight finally breaks through and the perfect moment Xu Cheng has been waiting for arrives. As she raises her camera, Zhou Lan stops at the stone railing and an old photograph falls from her hand. Xu Cheng must choose between chasing the standard view and retrieving the photograph. She abandons her original composition and creates three layers: the worn paper in the foreground, her grandmother’s hand on the railing, and Longevity Hill in the distance. The postcard image disappears, but the new photograph preserves the relationship between a restorer and the garden she helped restore. Xu Cheng understands that restoration does not pretend damage never existed; it allows later viewers to read loss, choice, and care.',
  ),
];

const summerPalaceWords = <WordEntry>[
  WordEntry(
    word: '颐和园',
    pinyin: 'Yíhéyuán',
    partOfSpeech: '名词（专名）',
    simpleChinese: '北京著名的清代皇家园林和世界文化遗产。',
    translation: 'Di Hòa Viên, vườn hoàng gia nổi tiếng ở Bắc Kinh.',
    englishDefinition: 'the Summer Palace, an imperial garden in Beijing',
    symbol: '🏯',
  ),
  WordEntry(
    word: '昆明湖',
    pinyin: 'Kūnmíng Hú',
    partOfSpeech: '名词（专名）',
    simpleChinese: '颐和园内面积最大的湖。',
    translation: 'Hồ Côn Minh, hồ lớn nhất trong Di Hòa Viên.',
    englishDefinition: 'Kunming Lake in the Summer Palace',
    symbol: '🌊',
  ),
  WordEntry(
    word: '万寿山',
    pinyin: 'Wànshòu Shān',
    partOfSpeech: '名词（专名）',
    simpleChinese: '颐和园内与昆明湖相对的重要山景。',
    translation: 'Núi Vạn Thọ, cảnh quan núi chính của Di Hòa Viên.',
    englishDefinition: 'Longevity Hill',
    symbol: '⛰️',
  ),
  WordEntry(
    word: '长廊',
    pinyin: 'chángláng',
    partOfSpeech: '名词',
    simpleChinese: '很长、带有屋顶的走廊。',
    translation: 'Hành lang dài có mái che.',
    englishDefinition: 'a long covered corridor',
    symbol: '🖼️',
  ),
  WordEntry(
    word: '倒影',
    pinyin: 'dàoyǐng',
    partOfSpeech: '名词',
    simpleChinese: '物体映在水面或镜子里的影像。',
    translation: 'Hình phản chiếu trên mặt nước hoặc trong gương.',
    englishDefinition: 'a reflection in water or a mirror',
    examples: [
      WordExample(
        chinese: '昆明湖里有万寿山的倒影。',
        pinyin: 'Kūnmíng Hú lǐ yǒu Wànshòu Shān de dàoyǐng.',
        vietnamese: 'Trong hồ Côn Minh có hình phản chiếu của núi Vạn Thọ.',
        english: 'Longevity Hill is reflected in Kunming Lake.',
      ),
    ],
    symbol: '🪞',
  ),
  WordEntry(
    word: '亭台',
    pinyin: 'tíngtái',
    partOfSpeech: '名词',
    simpleChinese: '园林中的亭子和高台等建筑。',
    translation: 'Đình và đài trong khu vườn truyền thống.',
    englishDefinition: 'pavilions and terraces in a garden',
    symbol: '🏮',
  ),
  WordEntry(
    word: '融合',
    pinyin: 'rónghé',
    partOfSpeech: '动词',
    simpleChinese: '不同事物结合在一起，形成一个整体。',
    translation: 'Hòa quyện nhiều yếu tố thành một thể thống nhất.',
    englishDefinition: 'to blend or integrate into a whole',
    examples: [
      WordExample(
        chinese: '颐和园把山水和建筑融合在一起。',
        pinyin: 'Yíhéyuán bǎ shānshuǐ hé jiànzhù rónghé zài yìqǐ.',
        vietnamese: 'Di Hòa Viên hòa quyện cảnh quan núi nước với kiến trúc.',
        english: 'The Summer Palace blends landscape and architecture together.',
      ),
    ],
    symbol: '🧩',
  ),
  WordEntry(
    word: '皇家园林',
    pinyin: 'huángjiā yuánlín',
    partOfSpeech: '名词',
    simpleChinese: '为皇室建造和使用的园林。',
    translation: 'Khu vườn được xây dựng và sử dụng cho hoàng gia.',
    englishDefinition: 'an imperial or royal garden',
    symbol: '👑',
  ),
  WordEntry(
    word: '修复',
    pinyin: 'xiūfù',
    partOfSpeech: '动词',
    simpleChinese: '把损坏的建筑或物品恢复到较好的状态。',
    translation: 'Khôi phục công trình hoặc đồ vật bị hư hại.',
    englishDefinition: 'to restore or repair',
    symbol: '🛠️',
  ),
  WordEntry(
    word: '借景',
    pinyin: 'jièjǐng',
    partOfSpeech: '名词／动词',
    simpleChinese: '把远处或园外的景色引入当前视野的园林方法。',
    translation:
        'Mượn cảnh quan xa hoặc ngoài vườn để tạo thành một phần của khung cảnh.',
    englishDefinition: 'borrowed scenery in landscape design',
    examples: [
      WordExample(
        chinese: '长廊用借景的方法让远山进入许澄的镜头。',
        pinyin: 'Chángláng yòng jièjǐng de fāngfǎ ràng yuǎnshān jìnrù Xǔ Chéng de jìngtóu.',
        vietnamese:
            'Trường Lang dùng phương pháp mượn cảnh để đưa núi xa vào ống kính của Hứa Trừng.',
        english:
            'The Long Corridor uses borrowed scenery to bring the distant hill into Xu Cheng’s frame.',
      ),
    ],
    symbol: '🔭',
  ),
  WordEntry(
    word: '湖光山色',
    pinyin: 'húguāng shānsè',
    partOfSpeech: '成语',
    simpleChinese: '湖水和山景组成的美丽风光。',
    translation: 'Cảnh đẹp hòa hợp giữa hồ nước và núi non.',
    englishDefinition: 'beautiful scenery of lakes and mountains',
    examples: [
      WordExample(
        chinese: '许澄最后没有只拍湖光山色。',
        pinyin: 'Xǔ Chéng zuìhòu méiyǒu zhǐ pāi húguāng shānsè.',
        vietnamese: 'Cuối cùng Hứa Trừng không chỉ chụp cảnh hồ và núi.',
        english: 'Xu Cheng ultimately photographs more than the lake-and-mountain scenery.',
      ),
    ],
    symbol: '🌄',
  ),
  WordEntry(
    word: '十七孔桥',
    pinyin: 'Shíqīkǒng Qiáo',
    partOfSpeech: '名词（专名）',
    simpleChinese: '颐和园昆明湖上的著名石桥，共有十七个桥孔。',
    translation: 'Cầu Thập Thất Khổng nổi tiếng trên hồ Côn Minh.',
    englishDefinition: 'the Seventeen-Arch Bridge',
    symbol: '🌉',
  ),
];

const summerPalaceDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
    text: '颐和园的整体规划不是把名胜平均摆在一张平面图上，而是利用人的行走次序安排观看。万寿山和昆明湖先构成山水骨架，长廊、亭台、桥梁与岛屿再进入这个骨架。长廊的廊柱和开口会交替遮蔽、放出远景，使同一座山在不同位置呈现不同距离和高度，昆明湖的倒影也会随视角改变湖光山色的层次。园林中的“借景”也不是简单拍到远山，而是通过方向、比例、前景和路线，把园外或远处景物纳入当前画面；“对景”则让人在特定位置获得明确的视觉目标。观看者的脚步因此成为设计的一部分，风景不是一次全部展开，而是在移动中连续重新构图。这种安排也让近处的廊柱、中段的湖面和远处的山峰形成清楚的空间层次。',
    pinyin:
        'Yíhéyuán de zhěngtǐ guīhuà bú shì bǎ míngshèng píngjūn bǎi zài yì zhāng píngmiàntú shàng, ér shì lìyòng rén de xíngzǒu cìxù ānpái guānkàn. Wànshòu Shān hé Kūnmíng Hú xiān gòuchéng shānshuǐ gǔjià, Chángláng, tíngtái, qiáoliáng yǔ dǎoyǔ zài jìnrù zhège gǔjià. Chángláng de lángzhù hé kāikǒu huì jiāotì zhēbì, fàngchū yuǎnjǐng, Kūnmíng Hú de dàoyǐng yě huì suí shìjiǎo gǎibiàn húguāng-shānsè de céngcì. Jièjǐng tōngguò fāngxiàng, bǐlì, qiánjǐng hé lùxiàn bǎ yuánwài huò yuǎnchù jǐngwù nàrù dāngqián huàmiàn; duìjǐng zé ràng rén zài tèdìng wèizhì huòdé míngquè de shìjué mùbiāo. Guānkànzhě de jiǎobù yīncǐ chéngwéi shèjì de yí bùfen, fēngjǐng zài yídòng zhōng liánxù chóngxīn gòutú.',
    simpleChinese:
        '颐和园的规划用山、湖、长廊和桥安排观看路线。倒影会改变湖光山色的层次，借景把远处景物带进当前画面。',
    vietnamese:
        'Quy hoạch tổng thể Di Hòa Viên không đặt các danh thắng đều trên một mặt bằng mà tổ chức việc ngắm theo thứ tự bước chân. Núi Vạn Thọ và hồ Côn Minh tạo bộ khung, sau đó hành lang, đình, cầu và đảo đi vào khung ấy. Các cột và khoảng mở của Trường Lang lần lượt che rồi mở cảnh xa; hình phản chiếu trên hồ Côn Minh cũng thay đổi các lớp cảnh hồ và núi theo góc nhìn. Mượn cảnh dùng hướng, tỷ lệ, tiền cảnh và lộ trình để đưa cảnh xa vào hình hiện tại; đối cảnh tạo mục tiêu thị giác tại một vị trí cụ thể. Vì vậy bước chân người xem trở thành một phần của thiết kế.',
    english:
        'The overall plan of the Summer Palace does not distribute sights evenly across a map; it sequences viewing through movement. Longevity Hill and Kunming Lake form the landscape framework, with corridors, pavilions, bridges, and islands entering that structure. Long Corridor columns alternately conceal and release distant views, while reflections in Kunming Lake change the layers of lake-and-mountain scenery with the viewing angle. Borrowed scenery uses direction, proportion, foreground, and route to incorporate distant elements, while opposite views create a clear visual target. The viewer’s steps therefore become part of the design.',
  ),
  DiscoveryEntry(
    text: '颐和园最早建成于一七五〇年，一八六〇年受到严重破坏，后来于一八八六年在原有基础上重建。今天看到的建筑、彩画和园林空间同时包含原有设计、历史损毁与后续修复。修复工作通常需要区分可保留的旧材料、必须加固的部分和后补内容，并留下足够记录，使后来的人能够判断哪些属于原作、哪些来自修复。十七孔桥既连接湖岸与南湖岛，也用水平线组织近处石栏、开阔水面和远处万寿山。它说明实用功能与景观构图可以同时存在，也解释了为什么颐和园的遗产价值不仅来自华丽建筑，还来自自然、人工、时间与观看方式之间被保存下来的关系。',
    pinyin:
        'Yíhéyuán zuìzǎo jiànchéng yú yī qī wǔ líng nián, yī bā liù líng nián shòudào yánzhòng pòhuài, hòulái yú yī bā bā liù nián zài yuányǒu jīchǔ shàng chóngjiàn. Jīntiān kàndào de jiànzhù, cǎihuà hé yuánlín kōngjiān tóngshí bāohán yuányǒu shèjì, lìshǐ sǔnhuǐ yǔ hòuxù xiūfù. Xiūfù gōngzuò tōngcháng xūyào qūfēn kě bǎoliú de jiù cáiliào, bìxū jiāgù de bùfen hé hòubǔ nèiróng, bìng liúxià jìlù. Shíqīkǒng Qiáo jì liánjiē hú àn yǔ Nánhú Dǎo, yě yòng shuǐpíngxiàn zǔzhī jìnchù shílán, kāikuò shuǐmiàn hé yuǎnchù Wànshòu Shān.',
    simpleChinese:
        '颐和园经历过破坏和重建。修复会保护旧材料、加固损坏部分并记录后来补上的内容。十七孔桥也同时承担通行和构图功能。',
    vietnamese:
        'Di Hòa Viên được xây dựng lần đầu năm 1750, bị phá hủy nặng năm 1860 và được tái thiết trên nền cũ năm 1886. Kiến trúc, tranh màu và không gian hiện nay chứa cả thiết kế ban đầu, tổn hại lịch sử và phần phục hồi sau này. Công việc phục hồi phân biệt vật liệu cũ có thể giữ, phần phải gia cố và nội dung bổ sung, đồng thời lưu hồ sơ để người sau nhận biết. Cầu Thập Thất Khổng vừa nối bờ với đảo Nam Hồ vừa tổ chức lan can gần, mặt nước rộng và núi Vạn Thọ xa bằng một đường ngang.',
    english:
        'The Summer Palace was first completed in 1750, severely damaged in 1860, and rebuilt on its earlier foundations in 1886. Its present buildings, paintings, and spaces contain original design, historical damage, and later restoration. Conservation distinguishes material that can remain, areas requiring reinforcement, and later additions, while preserving records for future interpretation. The Seventeen-Arch Bridge connects the shore and Nanhu Island and also organizes nearby railings, open water, and distant Longevity Hill along a horizontal line, combining practical and compositional functions.',
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
        sourceIds: const [
          'unesco-summer-palace-880',
          'beijing-gov-summer-palace-guide',
        ],
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