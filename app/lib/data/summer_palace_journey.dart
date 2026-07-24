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
  '清晨，你沿着昆明湖岸慢慢向前走，湖面先接住灰蓝色的天光，万寿山和佛香阁的轮廓随后从薄雾里显出来。远处的亭台看起来像自然生长在山水之间，但当脚步继续移动，你会发现眼前的风景并不是偶然形成的：树木遮住一部分山峰，桥梁把宽阔的水面分出层次，屋顶和廊柱又在视线将要散开时轻轻把它收回来。走进长廊，湖光从一根根柱子之间闪过，彩画、屋檐和不断变化的开口让行走变成一场缓慢展开的观看。你有时靠近画面，有时越过栏杆望向远山，同一座万寿山也会随着位置改变而显得更近、更高或更安静。颐和园最早在一七五〇年建成，后来在战火中受到严重破坏，并于一八八六年在原有基础上重建，因此今天看到的并不是一处从未改变的旧园，而是一座同时保存了设计、损失与修复痕迹的皇家园林。园中大约四分之三的面积是水，昆明湖并不是建筑旁边的空白，而是整个景观最重要的空间：它拉开山与人的距离，也把天空、桥梁、岛屿和屋顶放进同一幅不断变化的倒影。来到十七孔桥前，桥身没有把湖面切断，反而把岸、岛和远处山色连接起来；阳光穿过桥孔时，坚硬的石桥也像有了呼吸。走到这里，你会明白颐和园真正特别的地方并不只是某一座殿宇、某一条长廊或某一座桥，而是设计者怎样借景、对景和安排人的路线，让人工建筑逐渐退到山水之后，又在最需要的时候出现。离开之前再回头看，湖还是那片湖，山还是那座山，但你的目光已经不同了：你开始看见一处风景如何被行走、被修复，也被一代又一代的人重新理解。',
];

const summerPalaceStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Qingchen, ni yanzhe Kunming Hu an manman xiang qian zou. Humian jie zhu hui lanse de tianguang, Wanshou Shan he Fuxiang Ge de lunkuo cong bowu li xian chulai. Suizhe jiaobu yidong, shumu, qiaoliang, wuding he langzhu buduan tiaozheng ni de shixian. Zoujin Changlang, huguang cong zhuzi zhijian shanguo, caihua he wuyan rang xingzou biancheng yi chang huanman zhankai de guankan. Yiheyuan zui zao zai yi qi wu ling nian jiancheng, hou zai zhanhuo zhong shoudao pohuai, bing yu yi ba ba liu nian zai yuanyou jichu shang chongjian. Yuan zhong dayue si fen zhi san de mianji shi shui, Kunming Hu ba tiankong, qiaoliang, daoyu he wuding fangjin tong yi fu buduan bianhua de daoying. Laidao Shiqikong Qiao qian, ni hui mingbai zheli zhenzheng tebie de shi ren ruhe jie jing, dui jing he anpai luxian, rang jianzhu yu shanshui gongtong wancheng yi chu fengjing.',
    vietnamese:
        'Vào buổi sớm, bạn chậm rãi đi dọc bờ hồ Côn Minh. Ánh trời xanh xám trải trên mặt nước, rồi đường nét của núi Vạn Thọ và Phật Hương Các dần hiện ra trong làn sương mỏng. Khi tiếp tục bước đi, bạn nhận ra cảnh vật không hề được sắp đặt ngẫu nhiên: cây cối che bớt đỉnh núi, cầu chia mặt hồ thành nhiều lớp, còn mái nhà và cột hành lang nhẹ nhàng dẫn ánh nhìn trở lại. Trong Trường Lang, ánh hồ lóe qua từng hàng cột, tranh màu và những khoảng mở thay đổi liên tục khiến việc đi bộ trở thành một cách ngắm cảnh chậm rãi. Di Hòa Viên được xây dựng lần đầu vào năm 1750, sau đó bị phá hủy nặng trong chiến tranh và được tái thiết trên nền cũ vào năm 1886, vì vậy khu vườn ngày nay lưu giữ cả thiết kế, mất mát và dấu vết phục hồi. Khoảng ba phần tư diện tích là mặt nước; hồ Côn Minh không phải khoảng trống bên cạnh kiến trúc mà là không gian trung tâm, phản chiếu bầu trời, cầu, đảo và mái nhà. Trước cầu Thập Thất Khổng, bạn dần hiểu điều đặc biệt của Di Hòa Viên không nằm ở một công trình riêng lẻ, mà ở cách con người mượn cảnh, sắp xếp lối đi và để kiến trúc cùng núi nước hoàn thành một phong cảnh.',
    english:
        'At dawn, you walk slowly beside Kunming Lake as grey-blue light settles on the water and the outlines of Longevity Hill and the Tower of Buddhist Incense emerge from the mist. As you move, you realize that the view is carefully composed: trees partly conceal the hills, bridges divide the lake into layers, and roofs and corridor columns guide the eye. Inside the Long Corridor, changing openings, painted beams, and flashes of water turn walking into a slow act of seeing. The Summer Palace was first built in 1750, badly damaged in war, and reconstructed on its original foundations in 1886, so the garden preserves design, loss, and restoration together. With roughly three quarters of its area covered by water, Kunming Lake is not empty space beside the buildings but the centre of the landscape, holding sky, bridges, islands, and roofs in a shifting reflection. At the Seventeen-Arch Bridge, you begin to understand that the garden is remarkable not because of one monument, but because borrowed scenery, carefully arranged paths, architecture, and nature complete the view together.',
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
        english:
            'The Summer Palace blends landscape and architecture together.',
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
        chinese: '设计者用借景的方法把远山带进园林。',
        pinyin: 'Shèjìzhě yòng jièjǐng de fāngfǎ bǎ yuǎnshān dài jìn yuánlín.',
        vietnamese:
            'Người thiết kế dùng phương pháp mượn cảnh để đưa núi xa vào khu vườn.',
        english:
            'The designer used borrowed scenery to bring distant hills into the garden.',
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
        chinese: '站在长廊边可以欣赏湖光山色。',
        pinyin: 'Zhàn zài Chángláng biān kěyǐ xīnshǎng húguāng shānsè.',
        vietnamese: 'Đứng bên Trường Lang có thể thưởng ngoạn cảnh hồ và núi.',
        english:
            'From the Long Corridor, visitors can enjoy the lake-and-mountain scenery.',
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
