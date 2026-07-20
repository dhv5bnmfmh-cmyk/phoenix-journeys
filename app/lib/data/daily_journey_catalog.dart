import '../models/story_content.dart';

export 'daily_journey_experience.dart';
import 'beijing_story_catalog.dart';
import 'daily_journey_experience.dart';
import 'extended_journey_catalog.dart';
import 'journey_data.dart';

const shanghaiStorySources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'shanghai-gov-bund-scenic',
    title: 'The Bund',
    publisher: 'Shanghai Municipal Government',
    url:
        'https://english.shanghai.gov.cn/en-ScenicSpots/20231205/584672cc6d044eabb5f7f6fc9049a19f.html',
    kind: StorySourceKind.government,
    languageCode: 'en',
    geoNodeIds: ['cn-shanghai-huangpu-bund'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: 'huangpu-gov-bund-heritage',
    title: 'The Bund Historical and Cultural Block',
    publisher: 'Huangpu District Government',
    url:
        'https://english.shanghai.gov.cn/en-HeritageZones/20231208/f2ac293f546a4d32aba936f2e733a47c.html',
    kind: StorySourceKind.government,
    languageCode: 'en',
    geoNodeIds: ['cn-shanghai-huangpu-bund'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
];

const xianStorySources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'shaanxi-gov-xian-city-wall',
    title: 'Xi’an City Wall',
    publisher: 'The Government of Shaanxi Province',
    url:
        'https://en.shaanxi.gov.cn/tourism/aic/xa_2120/201712/t20171210_1595308.html',
    kind: StorySourceKind.government,
    languageCode: 'en',
    geoNodeIds: ['cn-shaanxi-xian-city-wall'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: 'xian-qujiang-city-wall',
    title: '西安城墙',
    publisher: '西安曲江新区管理委员会',
    url:
        'https://qjxq.xa.gov.cn/zjqj/gyqj/tsqj/5df21c5565cbd81235fc1efa.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-shaanxi-xian-city-wall'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
];

const shanghaiStoryParagraphs = <String>[
  '清晨，你站在黄浦江边。江风掠过外滩，老建筑的轮廓在柔和的光线中慢慢清晰。',
  '沿着滨水步道向前走，你会看到一排风格不同的历史建筑。它们曾经见证上海的金融、贸易和城市发展。',
  '江的另一边，浦东的高楼组成现代天际线。旧建筑与新城市隔江相望，像是两个时代正在对话。',
  '外滩最特别的地方，不只是夜晚的灯火，而是它让人看见一座城市怎样保存过去，同时不断走向未来。',
];

const shanghaiStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Qīngchén, nǐ zhàn zài Huángpǔ Jiāng biān. Jiāngfēng lüèguò Wàitān, lǎo jiànzhù de lúnkuò zài róuhé de guāngxiàn zhōng mànmàn qīngxī.',
    vietnamese:
        'Sáng sớm, bạn đứng bên sông Hoàng Phố. Gió sông lướt qua Bến Thượng Hải, đường nét của những tòa nhà cổ dần hiện rõ trong ánh sáng dịu.',
    english:
        'At dawn, you stand beside the Huangpu River. The river breeze crosses the Bund as the outlines of historic buildings slowly sharpen in the soft light.',
  ),
  ReadingAnnotation(
    pinyin:
        'Yánzhe bīnshuǐ bùdào xiàng qián zǒu, nǐ huì kàndào yì pái fēnggé bùtóng de lìshǐ jiànzhù. Tāmen céngjīng jiànzhèng Shànghǎi de jīnróng, màoyì hé chéngshì fāzhǎn.',
    vietnamese:
        'Đi dọc lối đi ven sông, bạn sẽ thấy một dãy công trình lịch sử với nhiều phong cách khác nhau. Chúng từng chứng kiến sự phát triển tài chính, thương mại và đô thị của Thượng Hải.',
    english:
        'Along the waterfront promenade, historic buildings in varied styles recall Shanghai’s financial, trading, and urban development.',
  ),
  ReadingAnnotation(
    pinyin:
        'Jiāng de lìng yì biān, Pǔdōng de gāolóu zǔchéng xiàndài tiānjìxiàn. Jiù jiànzhù yǔ xīn chéngshì gé jiāng xiāngwàng, xiàng shì liǎng gè shídài zhèngzài duìhuà.',
    vietnamese:
        'Bên kia sông, các tòa nhà cao tầng Phố Đông tạo thành đường chân trời hiện đại. Thành phố cũ và mới nhìn nhau qua sông như hai thời đại đang trò chuyện.',
    english:
        'Across the river, Pudong’s towers form a modern skyline. Old and new Shanghai face one another like two eras in conversation.',
  ),
  ReadingAnnotation(
    pinyin:
        'Wàitān zuì tèbié de dìfang, bù zhǐ shì yèwǎn de dēnghuǒ, ér shì tā ràng rén kànjiàn yí zuò chéngshì zěnyàng bǎocún guòqù, tóngshí bùduàn zǒuxiàng wèilái.',
    vietnamese:
        'Điều đặc biệt nhất của Bến Thượng Hải không chỉ là ánh đèn ban đêm, mà là cách nơi đây cho thấy một thành phố gìn giữ quá khứ trong khi không ngừng hướng tới tương lai.',
    english:
        'The Bund is more than its evening lights: it reveals how a city can preserve its past while continually moving toward the future.',
  ),
];

const shanghaiWords = <WordEntry>[
  WordEntry(word: '外滩', pinyin: 'Wàitān', partOfSpeech: '名词（专名）', simpleChinese: '上海黄浦江边著名的历史滨水区域。', translation: 'Bến Thượng Hải, khu ven sông lịch sử nổi tiếng.', englishDefinition: 'the Bund, Shanghai’s historic waterfront', symbol: '🌆'),
  WordEntry(word: '滨水', pinyin: 'bīnshuǐ', partOfSpeech: '形容词', simpleChinese: '靠近河流、湖泊或海边。', translation: 'Nằm ven sông, hồ hoặc biển.', englishDefinition: 'waterfront; beside a body of water', symbol: '🌊'),
  WordEntry(word: '黄浦江', pinyin: 'Huángpǔ Jiāng', partOfSpeech: '名词（专名）', simpleChinese: '流经上海市中心的重要河流。', translation: 'Sông Hoàng Phố chảy qua trung tâm Thượng Hải.', englishDefinition: 'the Huangpu River', symbol: '🚢'),
  WordEntry(word: '轮廓', pinyin: 'lúnkuò', partOfSpeech: '名词', simpleChinese: '物体外部的线条和大致形状。', translation: 'Đường nét hoặc hình dáng bên ngoài.', englishDefinition: 'outline or silhouette', symbol: '✒️'),
  WordEntry(word: '见证', pinyin: 'jiànzhèng', partOfSpeech: '动词', simpleChinese: '亲眼看见并能够证明某件事。', translation: 'Chứng kiến và có thể xác nhận một sự việc.', englishDefinition: 'to witness', symbol: '👁️'),
  WordEntry(word: '金融', pinyin: 'jīnróng', partOfSpeech: '名词', simpleChinese: '与资金、银行和投资有关的经济活动。', translation: 'Hoạt động tài chính, ngân hàng và đầu tư.', englishDefinition: 'finance and financial activity', symbol: '🏦'),
  WordEntry(word: '贸易', pinyin: 'màoyì', partOfSpeech: '名词', simpleChinese: '商品和服务的买卖活动。', translation: 'Hoạt động mua bán hàng hóa và dịch vụ.', englishDefinition: 'trade or commerce', symbol: '📦'),
  WordEntry(word: '天际线', pinyin: 'tiānjìxiàn', partOfSpeech: '名词', simpleChinese: '建筑物顶部与天空形成的整体线条。', translation: 'Đường chân trời do các tòa nhà tạo thành.', englishDefinition: 'skyline', symbol: '🏙️'),
  WordEntry(word: '隔江相望', pinyin: 'gé jiāng xiāngwàng', partOfSpeech: '动词短语', simpleChinese: '在河的两边互相面对。', translation: 'Nhìn nhau từ hai bờ sông.', englishDefinition: 'to face each other across a river', symbol: '↔️'),
  WordEntry(word: '灯火', pinyin: 'dēnghuǒ', partOfSpeech: '名词', simpleChinese: '夜晚亮起的灯光。', translation: 'Ánh đèn vào ban đêm.', englishDefinition: 'lights at night', symbol: '✨'),
  WordEntry(word: '时代', pinyin: 'shídài', partOfSpeech: '名词', simpleChinese: '历史发展中的一个时期。', translation: 'Một thời đại hoặc giai đoạn lịch sử.', englishDefinition: 'era or age', symbol: '⏳'),
  WordEntry(word: '走向', pinyin: 'zǒuxiàng', partOfSpeech: '动词', simpleChinese: '朝着某个方向发展。', translation: 'Phát triển theo một hướng.', englishDefinition: 'to move toward', symbol: '➡️'),
];

const shanghaiDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '外滩是一段约一点五公里长的滨水区域，也是受到保护的历史街区。', pinyin: 'Wàitān shì yí duàn yuē yì diǎn wǔ gōnglǐ cháng de bīnshuǐ qūyù, yě shì shòudào bǎohù de lìshǐ jiēqū.', simpleChinese: '外滩沿江约一点五公里，并受到历史文化保护。', vietnamese: 'Bến Thượng Hải là khu ven sông dài khoảng 1,5 km và là khu lịch sử được bảo vệ.', english: 'The Bund is an approximately 1.5-kilometre waterfront and a protected historic district.'),
  DiscoveryEntry(text: '黄浦江西岸保存着许多不同风格的历史建筑，因此外滩也常被称为露天建筑博物馆。', pinyin: 'Huángpǔ Jiāng xī àn bǎocúnzhe xǔduō bùtóng fēnggé de lìshǐ jiànzhù, yīncǐ Wàitān yě cháng bèi chēngwéi lùtiān jiànzhù bówùguǎn.', simpleChinese: '外滩有很多不同风格的老建筑，像一座露天博物馆。', vietnamese: 'Bờ tây sông Hoàng Phố có nhiều công trình lịch sử đa phong cách, nên thường được gọi là bảo tàng kiến trúc ngoài trời.', english: 'Historic buildings in many styles make the Bund an outdoor museum of architecture.'),
  DiscoveryEntry(text: '外滩过去与银行、贸易公司和城市商业发展密切相关。', pinyin: 'Wàitān guòqù yǔ yínháng, màoyì gōngsī hé chéngshì shāngyè fāzhǎn mìqiè xiāngguān.', simpleChinese: '外滩过去是银行、贸易和商业活动的重要地区。', vietnamese: 'Trong quá khứ, Bến Thượng Hải gắn chặt với ngân hàng, thương mại và sự phát triển kinh doanh.', english: 'The Bund was closely connected to banks, trading firms, and commercial development.'),
  DiscoveryEntry(text: '从外滩看浦东，可以同时观察上海的历史建筑与现代天际线。', pinyin: 'Cóng Wàitān kàn Pǔdōng, kěyǐ tóngshí guānchá Shànghǎi de lìshǐ jiànzhù yǔ xiàndài tiānjìxiàn.', simpleChinese: '站在外滩，可以同时看到老上海和现代浦东。', vietnamese: 'Từ Bến Thượng Hải có thể đồng thời ngắm kiến trúc lịch sử và đường chân trời hiện đại của Phố Đông.', english: 'From the Bund, historic Shanghai and Pudong’s modern skyline appear together.'),
];

const xianStoryParagraphs = <String>[
  '傍晚，你从永宁门走上西安城墙。脚下的砖石向两边延伸，城门、角楼和护城河组成清晰的防御线。',
  '现存城墙的主要规模形成于明代，并在后来的修缮中不断完善。宽阔的墙顶曾经方便守城人员巡查和调动。',
  '站在城墙上向内看，是街巷与老城；向外看，是道路、高楼和不断扩大的现代城市。',
  '绕城墙行走，就像沿着西安的时间边界前进。古都没有停在过去，而是把历史留在今天的生活里。',
];

const xianStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Bàngwǎn, nǐ cóng Yǒngníngmén zǒu shàng Xī’ān Chéngqiáng. Jiǎoxià de zhuānshí xiàng liǎngbiān yánshēn, chéngmén, jiǎolóu hé hùchénghé zǔchéng qīngxī de fángyùxiàn.', vietnamese: 'Chiều tối, bạn bước lên tường thành Tây An từ cổng Vĩnh Ninh. Gạch đá kéo dài sang hai phía, còn cổng thành, tháp góc và hào nước tạo nên một tuyến phòng thủ rõ ràng.', english: 'At dusk, you climb Xi’an City Wall from Yongning Gate. Brickwork, gates, corner towers, and the moat form a clear defensive line.'),
  ReadingAnnotation(pinyin: 'Xiàncún chéngqiáng de zhǔyào guīmó xíngchéng yú Míngdài, bìng zài hòulái de xiūshàn zhōng bùduàn wánshàn. Kuānkuò de qiángdǐng céngjīng fāngbiàn shǒuchéng rényuán xúnchá hé diàodòng.', vietnamese: 'Quy mô chính của tường thành hiện nay được hình thành vào thời Minh và tiếp tục hoàn thiện qua các lần tu bổ. Mặt thành rộng từng giúp binh lính tuần tra và di chuyển.', english: 'The present wall took its main form in the Ming dynasty and was refined through later repairs. Its broad top supported patrol and movement.'),
  ReadingAnnotation(pinyin: 'Zhàn zài chéngqiáng shàng xiàng nèi kàn, shì jiēxiàng yǔ lǎochéng; xiàng wài kàn, shì dàolù, gāolóu hé bùduàn kuòdà de xiàndài chéngshì.', vietnamese: 'Nhìn vào trong từ tường thành là những ngõ phố và khu thành cổ; nhìn ra ngoài là đường sá, nhà cao tầng và đô thị hiện đại đang mở rộng.', english: 'Inside the wall lie lanes and the old city; outside are roads, towers, and an expanding modern metropolis.'),
  ReadingAnnotation(pinyin: 'Rào chéngqiáng xíngzǒu, jiù xiàng yánzhe Xī’ān de shíjiān biānjiè qiánjìn. Gǔdū méiyǒu tíng zài guòqù, ér shì bǎ lìshǐ liú zài jīntiān de shēnghuó lǐ.', vietnamese: 'Đi dọc tường thành giống như bước theo ranh giới thời gian của Tây An. Cố đô không dừng lại trong quá khứ mà giữ lịch sử trong đời sống hôm nay.', english: 'Walking the wall follows Xi’an’s boundary through time. The ancient capital keeps history inside contemporary life.'),
];

const xianWords = <WordEntry>[
  WordEntry(word: '城墙', pinyin: 'chéngqiáng', partOfSpeech: '名词', simpleChinese: '围绕城市、用于保护城市的高墙。', translation: 'Tường thành bao quanh và bảo vệ thành phố.', englishDefinition: 'city wall', symbol: '🧱'),
  WordEntry(word: '永宁门', pinyin: 'Yǒngníngmén', partOfSpeech: '名词（专名）', simpleChinese: '西安城墙南面的重要城门。', translation: 'Cổng Vĩnh Ninh, cổng quan trọng phía nam.', englishDefinition: 'Yongning Gate, the south gate', symbol: '🚪'),
  WordEntry(word: '砖石', pinyin: 'zhuānshí', partOfSpeech: '名词', simpleChinese: '砖和石头等建筑材料。', translation: 'Gạch và đá dùng trong xây dựng.', englishDefinition: 'brick and stone', symbol: '🪨'),
  WordEntry(word: '角楼', pinyin: 'jiǎolóu', partOfSpeech: '名词', simpleChinese: '建在城墙转角处的楼。', translation: 'Tháp xây ở góc tường thành.', englishDefinition: 'corner tower', symbol: '🏯'),
  WordEntry(word: '护城河', pinyin: 'hùchénghé', partOfSpeech: '名词', simpleChinese: '城墙外用于防御的河沟。', translation: 'Hào nước phòng thủ bên ngoài tường thành.', englishDefinition: 'moat', symbol: '🌊'),
  WordEntry(word: '防御', pinyin: 'fángyù', partOfSpeech: '动词', simpleChinese: '保护自己，阻止外来的攻击。', translation: 'Phòng thủ, ngăn chặn tấn công.', englishDefinition: 'defence', symbol: '🛡️'),
  WordEntry(word: '现存', pinyin: 'xiàncún', partOfSpeech: '形容词', simpleChinese: '现在仍然存在。', translation: 'Hiện vẫn còn tồn tại.', englishDefinition: 'still existing', symbol: '📍'),
  WordEntry(word: '规模', pinyin: 'guīmó', partOfSpeech: '名词', simpleChinese: '事物的大小和范围。', translation: 'Quy mô và phạm vi.', englishDefinition: 'scale or extent', symbol: '📐'),
  WordEntry(word: '修缮', pinyin: 'xiūshàn', partOfSpeech: '动词', simpleChinese: '修理并保护建筑。', translation: 'Tu bổ và bảo vệ công trình.', englishDefinition: 'to repair and conserve', symbol: '🔧'),
  WordEntry(word: '巡查', pinyin: 'xúnchá', partOfSpeech: '动词', simpleChinese: '按照路线检查情况。', translation: 'Tuần tra và kiểm tra theo tuyến.', englishDefinition: 'to patrol and inspect', symbol: '🔍'),
  WordEntry(word: '古都', pinyin: 'gǔdū', partOfSpeech: '名词', simpleChinese: '古代曾经作为首都的城市。', translation: 'Cố đô, thành phố từng là kinh đô.', englishDefinition: 'ancient capital', symbol: '🏛️'),
  WordEntry(word: '边界', pinyin: 'biānjiè', partOfSpeech: '名词', simpleChinese: '两个区域之间的分界线。', translation: 'Ranh giới giữa hai khu vực.', englishDefinition: 'boundary', symbol: '〰️'),
];

const xianDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '西安现存城墙的主要结构形成于明代，并建立在更早城市遗迹的基础上。', pinyin: 'Xī’ān xiàncún chéngqiáng de zhǔyào jiégòu xíngchéng yú Míngdài, bìng jiànlì zài gèng zǎo chéngshì yíjì de jīchǔ shàng.', simpleChinese: '今天看到的城墙主要形成于明代，也利用了更早的城市基础。', vietnamese: 'Cấu trúc chính của tường thành Tây An hiện nay hình thành vào thời Minh trên nền dấu tích đô thị sớm hơn.', english: 'The existing wall took its main form in the Ming dynasty on foundations from earlier cities.'),
  DiscoveryEntry(text: '城墙、城门、护城河和城楼共同组成完整的古代城市防御体系。', pinyin: 'Chéngqiáng, chéngmén, hùchénghé hé chénglóu gòngtóng zǔchéng wánzhěng de gǔdài chéngshì fángyù tǐxì.', simpleChinese: '不同设施一起保护古代城市。', vietnamese: 'Tường thành, cổng, hào nước và tháp thành tạo thành một hệ thống phòng thủ đô thị hoàn chỉnh.', english: 'Walls, gates, moat, and towers formed an integrated urban defence system.'),
  DiscoveryEntry(text: '宽阔的墙顶不仅用于防守，也方便人员和物资移动。', pinyin: 'Kuānkuò de qiángdǐng bùjǐn yòngyú fángshǒu, yě fāngbiàn rényuán hé wùzī yídòng.', simpleChinese: '墙顶很宽，可以巡逻和运送物资。', vietnamese: 'Mặt thành rộng không chỉ dùng để phòng thủ mà còn giúp di chuyển người và vật tư.', english: 'The broad top supported defence as well as movement of people and supplies.'),
  DiscoveryEntry(text: '今天的西安城墙通过持续修缮与公共开放，连接文化保护和现代城市生活。', pinyin: 'Jīntiān de Xī’ān Chéngqiáng tōngguò chíxù xiūshàn yǔ gōnggòng kāifàng, liánjiē wénhuà bǎohù hé xiàndài chéngshì shēnghuó.', simpleChinese: '城墙一边被保护，一边继续进入今天的城市生活。', vietnamese: 'Ngày nay, việc tu bổ liên tục và mở cửa công cộng giúp tường thành kết nối bảo tồn văn hóa với đời sống đô thị hiện đại.', english: 'Ongoing conservation and public access connect the wall with modern city life.'),
];

final shanghaiBundJourney = JourneyContentRecord(
  id: 'shanghai-bund',
  title: '上海 · 外滩：两个时代怎样隔江对话',
  geoNodeId: 'cn-shanghai-huangpu-bund',
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['上海', '外滩', '黄浦江', '建筑', '城市发展'],
  sections: List.generate(
    shanghaiStoryParagraphs.length,
    (index) => JourneyStorySection(
      id: 'story-$index',
      text: shanghaiStoryParagraphs[index],
      sourceIds: const [
        'shanghai-gov-bund-scenic',
        'huangpu-gov-bund-heritage',
      ],
    ),
  ),
);

final xianCityWallJourney = JourneyContentRecord(
  id: 'xian-city-wall',
  title: '西安 · 城墙：沿着古都的时间边界行走',
  geoNodeId: 'cn-shaanxi-xian-city-wall',
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['西安', '城墙', '明代', '古都', '城市防御'],
  sections: List.generate(
    xianStoryParagraphs.length,
    (index) => JourneyStorySection(
      id: 'story-$index',
      text: xianStoryParagraphs[index],
      sourceIds: const [
        'shaanxi-gov-xian-city-wall',
        'xian-qujiang-city-wall',
      ],
    ),
  ),
);

final dailyStorySources = <StorySourceRecord>[
  ...beijingStorySources,
  ...shanghaiStorySources,
  ...xianStorySources,
  ...extendedJourneySources,
];

final dailyJourneyRecords = <JourneyContentRecord>[
  beijingForbiddenCityJourney,
  shanghaiBundJourney,
  xianCityWallJourney,
  ...extendedJourneyRecords,
];

final dailyJourneyExperiences = <DailyJourneyExperience>[
  DailyJourneyExperience(
    id: beijingForbiddenCityJourney.id,
    city: '北京',
    cityCode: 'PEK',
    place: '紫禁城',
    appBarTitle: '北京 · 紫禁城',
    storyTitle: '紫禁城故事',
    headline: '第一次走进紫禁城',
    description: '跟随 AI 导游，用故事、词汇和文化打开北京。',
    discoveryTeaser: '为什么故宫的屋顶大多是黄色？',
    distanceLabel: '1,670 km',
    stampSymbol: '宫',
    content: beijingForbiddenCityJourney,
    storyAnnotations: storyAnnotations,
    words: words,
    discoveries: discoveries,
    wonderQuestion: wonderQuestion,
    expressQuestion: expressQuestion,
  ),
  DailyJourneyExperience(
    id: shanghaiBundJourney.id,
    city: '上海',
    cityCode: 'SHA',
    place: '外滩',
    appBarTitle: '上海 · 外滩',
    storyTitle: '外滩故事',
    headline: '在外滩看见两个时代',
    description: '沿黄浦江阅读建筑、贸易与现代城市的交汇。',
    discoveryTeaser: '为什么外滩被称为露天建筑博物馆？',
    distanceLabel: '1,900 km',
    stampSymbol: '滩',
    content: shanghaiBundJourney,
    storyAnnotations: shanghaiStoryAnnotations,
    words: shanghaiWords,
    discoveries: shanghaiDiscoveries,
    wonderQuestion: '如果你能在外滩选择一个位置停留一小时，你想面对老建筑还是浦东天际线？为什么？',
    expressQuestion: '请用两到三句话介绍外滩最吸引你的历史建筑或江景。',
  ),
  DailyJourneyExperience(
    id: xianCityWallJourney.id,
    city: '西安',
    cityCode: 'XIY',
    place: '城墙',
    appBarTitle: '西安 · 城墙',
    storyTitle: '古城墙故事',
    headline: '沿着古都的边界行走',
    description: '登上城墙，从防御建筑读懂古都与现代城市。',
    discoveryTeaser: '为什么西安城墙的墙顶这么宽？',
    distanceLabel: '1,490 km',
    stampSymbol: '城',
    content: xianCityWallJourney,
    storyAnnotations: xianStoryAnnotations,
    words: xianWords,
    discoveries: xianDiscoveries,
    wonderQuestion: '站在西安城墙上，你更想观察城内的老街还是城外的现代城市？为什么？',
    expressQuestion: '请用两到三句话介绍你想从西安城墙上看到的景象。',
  ),
  ...extendedJourneyExperiences,
];

DailyJourneyExperience requireDailyJourneyExperience(String id) {
  return dailyJourneyExperiences.firstWhere(
    (journey) => journey.id == id,
    orElse: () => dailyJourneyExperiences.first,
  );
}

DailyJourneyExperience dailyJourneyForDate(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final epoch = DateTime.utc(2026, 1, 1);
  final dayNumber = day.difference(epoch).inDays;
  final index = dayNumber % dailyJourneyExperiences.length;
  return dailyJourneyExperiences[index < 0 ? index + dailyJourneyExperiences.length : index];
}
