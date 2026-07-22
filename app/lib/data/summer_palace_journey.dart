import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

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
  '清晨，你沿着昆明湖慢慢向前走。湖面映着万寿山，远处的亭台像从水和树之间自然生长出来。',
  '走进长廊以后，每一步都像在一幅不断展开的画里。山、水、桥、宫殿和花木彼此连接，却不会互相遮挡。',
  '颐和园最早在一七五〇年建成，后来经历破坏，又在一八八六年按照原有基础重建。它保存的不只是一座皇家园林，也是一段不断修复的历史。',
  '当你走到十七孔桥前，会发现这里真正特别的不是某一座建筑，而是人怎样借用自然，让湖光、山色和建筑共同完成一处风景。',
];

const summerPalaceStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Qīngchén, nǐ yánzhe Kūnmíng Hú mànmàn xiàng qián zǒu. Húmiàn yìngzhe Wànshòu Shān, yuǎnchù de tíngtái xiàng cóng shuǐ hé shù zhījiān zìrán shēngzhǎng chūlái.',
    vietnamese:
        'Sáng sớm, bạn chậm rãi đi dọc hồ Côn Minh. Mặt hồ phản chiếu núi Vạn Thọ, còn những đình đài phía xa như mọc lên tự nhiên giữa nước và cây.',
    english:
        'At dawn, you walk slowly beside Kunming Lake. Longevity Hill is reflected on the water, while distant pavilions seem to grow naturally between the lake and trees.',
  ),
  ReadingAnnotation(
    pinyin:
        'Zǒujìn Chángláng yǐhòu, měi yí bù dōu xiàng zài yì fú bùduàn zhǎnkāi de huà lǐ. Shān, shuǐ, qiáo, gōngdiàn hé huāmù bǐcǐ liánjiē, què bú huì hùxiāng zhēdǎng.',
    vietnamese:
        'Sau khi bước vào Trường Lang, mỗi bước chân giống như đi trong một bức tranh đang dần mở ra. Núi, nước, cầu, cung điện và cây cỏ liên kết với nhau mà không che khuất nhau.',
    english:
        'Inside the Long Corridor, every step feels like moving through an unfolding painting. Hills, water, bridges, halls, and plants connect without blocking one another.',
  ),
  ReadingAnnotation(
    pinyin:
        'Yíhéyuán zuìzǎo zài yī qī wǔ líng nián jiànchéng, hòulái jīnglì pòhuài, yòu zài yī bā bā liù nián ànzhào yuányǒu jīchǔ chóngjiàn. Tā bǎocún de bù zhǐ shì yí zuò huángjiā yuánlín, yě shì yí duàn bùduàn xiūfù de lìshǐ.',
    vietnamese:
        'Di Hòa Viên ban đầu được xây dựng vào năm 1750, sau đó bị phá hủy và được dựng lại trên nền cũ vào năm 1886. Nơi đây lưu giữ không chỉ một khu vườn hoàng gia mà còn cả lịch sử của nhiều lần phục hồi.',
    english:
        'The Summer Palace was first built in 1750, later damaged, and reconstructed on its original foundations in 1886. It preserves both an imperial garden and a history of repeated restoration.',
  ),
  ReadingAnnotation(
    pinyin:
        'Dāng nǐ zǒu dào Shíqīkǒng Qiáo qián, huì fāxiàn zhèlǐ zhēnzhèng tèbié de bú shì mǒu yí zuò jiànzhù, ér shì rén zěnyàng jièyòng zìrán, ràng húguāng, shānsè hé jiànzhù gòngtóng wánchéng yí chù fēngjǐng.',
    vietnamese:
        'Khi đến trước cầu Thập Thất Khổng, bạn sẽ nhận ra điều đặc biệt không nằm ở riêng một công trình, mà ở cách con người mượn thiên nhiên để mặt hồ, núi non và kiến trúc cùng tạo nên phong cảnh.',
    english:
        'At the Seventeen-Arch Bridge, you realize the garden is special not because of one building, but because people borrowed from nature so lake, hills, and architecture could complete one landscape together.',
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
    symbol: '🔭',
  ),
  WordEntry(
    word: '湖光山色',
    pinyin: 'húguāng shānsè',
    partOfSpeech: '成语',
    simpleChinese: '湖水和山景组成的美丽风光。',
    translation: 'Cảnh đẹp hòa hợp giữa hồ nước và núi non.',
    englishDefinition: 'beautiful scenery of lakes and mountains',
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
    text: '颐和园以万寿山和昆明湖为基本框架，把山水与宫殿、亭台、寺庙和桥梁组合成完整的园林。',
    pinyin:
        'Yíhéyuán yǐ Wànshòu Shān hé Kūnmíng Hú wéi jīběn kuàngjià, bǎ shānshuǐ yǔ gōngdiàn, tíngtái, sìmiào hé qiáoliáng zǔhé chéng wánzhěng de yuánlín.',
    simpleChinese: '颐和园用山和湖作为基础，再加入建筑和桥梁。',
    vietnamese:
        'Di Hòa Viên lấy núi Vạn Thọ và hồ Côn Minh làm khung chính, kết hợp cảnh quan với cung điện, đình đài, chùa và cầu.',
    english:
        'The garden uses Longevity Hill and Kunming Lake as its framework, combining landscape with halls, pavilions, temples, and bridges.',
  ),
  DiscoveryEntry(
    text: '颐和园最早建于一七五〇年，一八六〇年受到严重破坏，并在一八八六年按照原有基础重建。',
    pinyin:
        'Yíhéyuán zuìzǎo jiànyú yī qī wǔ líng nián, yī bā liù líng nián shòudào yánzhòng pòhuài, bìng zài yī bā bā liù nián ànzhào yuányǒu jīchǔ chóngjiàn.',
    simpleChinese: '颐和园建于1750年，后来受损，并在1886年重建。',
    vietnamese:
        'Di Hòa Viên được xây dựng lần đầu năm 1750, bị phá hủy nặng năm 1860 và được tái thiết trên nền cũ năm 1886.',
    english:
        'The Summer Palace was first built in 1750, badly damaged in 1860, and reconstructed on its original foundations in 1886.',
  ),
  DiscoveryEntry(
    text: '颐和园约四分之三的面积是水，因此人在园中行走时，湖面一直参与建筑和山景的构图。',
    pinyin:
        'Yíhéyuán yuē sì fēn zhī sān de miànjī shì shuǐ, yīncǐ rén zài yuán zhōng xíngzǒu shí, húmiàn yìzhí cānyù jiànzhù hé shānjǐng de gòutú.',
    simpleChinese: '园内大约四分之三是水，湖面是景观的重要部分。',
    vietnamese:
        'Khoảng ba phần tư diện tích Di Hòa Viên là mặt nước, nên hồ luôn là một phần quan trọng của bố cục cảnh quan.',
    english:
        'Roughly three quarters of the Summer Palace is water, making the lake a central part of every architectural and mountain view.',
  ),
  DiscoveryEntry(
    text: '十七孔桥长一百五十多米，是中国皇家园林中最长的桥之一，夕阳可以穿过桥孔形成独特的光影。',
    pinyin:
        'Shíqīkǒng Qiáo cháng yì bǎi wǔ shí duō mǐ, shì Zhōngguó huángjiā yuánlín zhōng zuì cháng de qiáo zhī yī, xīyáng kěyǐ chuānguò qiáokǒng xíngchéng dútè de guāngyǐng.',
    simpleChinese: '十七孔桥超过150米，夕阳会穿过桥孔。',
    vietnamese:
        'Cầu Thập Thất Khổng dài hơn 150 mét; ánh hoàng hôn có thể xuyên qua các vòm cầu tạo nên hiệu ứng ánh sáng đặc biệt.',
    english:
        'The Seventeen-Arch Bridge is over 150 metres long, and sunset light can pass through its arches to create a distinctive glow.',
  ),
];

final summerPalaceJourneyContent = JourneyContentRecord(
  id: 'beijing-summer-palace',
  title: '北京 · 颐和园：把山水借进一座园林',
  geoNodeId: 'cn-beijing-haidian-summer-palace',
  languageCode: 'zh-CN',
  verificationStatus: StoryVerificationStatus.published,
  tags: const ['北京', '颐和园', '昆明湖', '万寿山', '皇家园林', '世界文化遗产'],
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
  storyTitle: '颐和园故事',
  headline: '沿着昆明湖走进一幅山水画',
  description: '从昆明湖、万寿山与长廊读懂中国皇家园林的借景方法。',
  discoveryTeaser: '为什么颐和园约四分之三的面积都是水？',
  distanceLabel: '1,670 km',
  stampSymbol: '园',
  content: summerPalaceJourneyContent,
  storyAnnotations: summerPalaceStoryAnnotations,
  words: summerPalaceWords,
  discoveries: summerPalaceDiscoveries,
  wonderQuestion: '如果你可以在颐和园停留一个下午，你会选择沿湖散步、走长廊，还是登上万寿山？为什么？',
  expressQuestion: '请用两到三句话介绍颐和园怎样把自然景色和建筑融合在一起。',
);
