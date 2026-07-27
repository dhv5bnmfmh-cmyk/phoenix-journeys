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
  '清晨，你沿着昆明湖岸慢慢前行，灰蓝色的天光落在水面，万寿山与佛香阁的轮廓从薄雾里一点点显出来。远处的亭台像自然长在山水之间，可当你继续移动，风景也随脚步改变：树木有意遮住部分山峰，桥梁把宽阔的湖面分出远近，屋顶和廊柱又在视线将要散开时把它轻轻收回。走进长廊，湖光从一根根柱子之间闪过，彩画、屋檐与不断变化的开口把一次普通的散步变成缓慢展开的观看。你有时贴近廊柱，看见木构上的纹样；有时越过栏杆望向远山，同一座万寿山也会因为角度不同而显得更近、更高或更安静。长廊并不催你赶往下一个景点，它像一条有节奏的取景框，让你在遮蔽与开敞之间重新认识眼前的湖光山色。这里并不是把所有美景一次摆到眼前，而是让人边走边发现，让山、水、建筑和时间共同完成画面。',
  '颐和园最早在一七五〇年建成，后来在战火中受到严重破坏，并于一八八六年在原有基础上重建。因此今天看到的不是一座从未改变的古园，而是一处同时保存设计、损失与修复痕迹的皇家园林。园中大约四分之三的面积是水，昆明湖并非建筑旁边的空白，它拉开山与人的距离，也把天空、桥梁、岛屿和屋顶收入不断变化的倒影。来到十七孔桥前，桥身没有把湖面切断，反而把岸、岛和远山连接起来；阳光穿过桥孔时，坚硬的石桥也像有了呼吸。走到这里，你会明白颐和园真正特别的地方并不只是一座殿宇、一条长廊或一座桥，而是设计者怎样借景、对景和安排路线，让人工建筑退到山水之后，又在最需要的时候出现。离开前再回头看，湖还是那片湖，山还是那座山，但你的目光已经不同了：你开始看见一处风景如何被设计、被行走、被修复，也被后来的人重新理解。',
];

const summerPalaceStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Qingchen, ni yanzhe Kunming Hu an manman qianxing, hui lanse de tianguang luo zai shuimian, Wanshou Shan yu Fuxiang Ge de lunkuo cong bowu li yidian dian xian chulai. Yuanchu de tingtai xiang ziran zhang zai shanshui zhijian, ke dang ni jixu yidong, fengjing ye sui jiaobu gaibian: shumu youyi zhezhu bufen shanfeng, qiaoliang ba kuankuo de humian fenchu yuanjin, wuding he langzhu you zai shixian jiangyao sankai shi ba ta qingqing shouhui. Zoujin Changlang, huguang cong yi gen gen zhuzi zhijian shanguo, caihua, wuyan yu buduan bianhua de kaikou ba yi ci putong de sanbu biancheng huanman zhankai de guankan. Changlang xiang yi tiao you jiezou de qujingkuang, rang shan, shui, jianzhu he shijian gongtong wancheng huamian.',
    vietnamese:
        'Buổi sớm, bạn chậm rãi đi dọc bờ hồ Côn Minh. Ánh trời xanh xám rơi xuống mặt nước, đường nét của núi Vạn Thọ và Phật Hương Các dần hiện ra trong sương mỏng. Những đình đài phía xa tưởng như mọc tự nhiên giữa núi nước, nhưng khi tiếp tục bước đi, bạn nhận ra cảnh vật thay đổi theo từng bước chân: cây cối cố ý che bớt đỉnh núi, cầu chia mặt hồ thành nhiều lớp xa gần, còn mái nhà và cột hành lang nhẹ nhàng kéo ánh nhìn trở lại. Trong Trường Lang, ánh hồ lóe qua từng hàng cột; tranh màu, mái hiên và những khoảng mở liên tục thay đổi biến một cuộc dạo bộ bình thường thành quá trình ngắm cảnh chậm rãi. Hành lang giống một khung ngắm có nhịp điệu, để núi, nước, kiến trúc và thời gian cùng hoàn thành bức tranh.',
    english:
        'At dawn, you walk slowly beside Kunming Lake as grey-blue light settles on the water and the outlines of Longevity Hill and the Tower of Buddhist Incense emerge through the mist. Distant pavilions appear to grow naturally from the landscape, yet the view changes with every step: trees partly conceal the hills, bridges divide the broad lake into layers, and roofs and columns gently gather the eye. Inside the Long Corridor, flashes of water, painted beams, eaves, and changing openings turn an ordinary walk into a slow act of seeing. The corridor becomes a rhythmic frame through which hills, water, architecture, and time complete the picture together.',
  ),
  ReadingAnnotation(
    pinyin:
        'Yiheyuan zui zao zai yi qi wu ling nian jiancheng, houlai zai zhanhuo zhong shoudao yanzhong pohuai, bing yu yi ba ba liu nian zai yuanyou jichu shang chongjian. Jintian kandao de bushi yi zuo conglai meiyou gaibian de guyuan, er shi yi chu tongshi baocun sheji, sunshi yu xiufu henji de huangjia yuanlin. Yuan zhong dayue si fen zhi san de mianji shi shui, Kunming Hu bingfei jianzhu pangbian de kongbai, ta lakai shan yu ren de juli, ye ba tiankong, qiaoliang, daoyu he wuding shouru buduan bianhua de daoying. Laidao Shiqikong Qiao qian, qiaoshen ba huan, dao he yuanshan lianjie qilai. Ni hui mingbai zhenzheng tebie de shi shejizhe ruhe jie jing, dui jing he anpai luxian, rang rengong jianzhu tui dao shanshui zhihou, you zai zui xuyao de shihou chuxian.',
    vietnamese:
        'Di Hòa Viên được xây dựng lần đầu vào năm 1750, sau đó bị phá hủy nặng trong chiến tranh và được tái thiết trên nền cũ vào năm 1886. Vì vậy khu vườn ngày nay không phải một di tích chưa từng thay đổi, mà đồng thời lưu giữ thiết kế, mất mát và dấu vết phục hồi. Khoảng ba phần tư diện tích là mặt nước; hồ Côn Minh không phải khoảng trống bên cạnh kiến trúc mà kéo giãn khoảng cách giữa con người và núi, đồng thời thu bầu trời, cầu, đảo và mái nhà vào những lớp phản chiếu luôn biến đổi. Trước cầu Thập Thất Khổng, bạn dần hiểu điều đặc biệt không nằm ở một công trình riêng lẻ, mà ở cách người thiết kế mượn cảnh, đối cảnh và tổ chức lộ trình để kiến trúc lùi sau núi nước rồi xuất hiện đúng lúc.',
    english:
        'The Summer Palace was first built in 1750, badly damaged in war, and reconstructed on its original foundations in 1886. What survives is therefore not an untouched garden, but a place that holds design, loss, and restoration together. With roughly three quarters of the site covered by water, Kunming Lake is not empty space beside the buildings. It stretches the distance between visitors and the hills while gathering sky, bridges, islands, and roofs into shifting reflections. At the Seventeen-Arch Bridge, the shore, island, and distant hills come together. The garden becomes remarkable through borrowed scenery, paired views, and carefully arranged routes that let architecture recede behind nature and return at precisely the right moment.',
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
    text: '颐和园的核心并不是把许多宫殿集中在一起，而是先用万寿山和昆明湖建立山水骨架，再让长廊、亭台、寺庙、桥梁和岛屿进入这套秩序。园区约四分之三的面积是水，因此昆明湖承担的不只是观赏功能：它扩大了视线距离，把天空和远山带进园中，也利用倒影让同一组建筑在清晨、正午和黄昏呈现不同气氛。长廊则像一条移动的取景线，人在有屋顶的遮蔽中前进，视野会在廊柱之间不断打开和收拢。所谓“借景”，并不是把远处景物搬进园内，而是通过方向、距离、比例和人的行走路线，让园外远山、园内湖面与近处建筑在某个位置组成完整画面。也因此，颐和园的风景不是静止陈列，而是在脚步中不断重新构图。',
    pinyin:
        'Yiheyuan de hexin bing bushi ba xuduo gongdian jizhong zai yiqi, er shi xian yong Wanshou Shan he Kunming Hu jianli shanshui gujia, zai rang Changlang, tingtai, simiao, qiaoliang he daoyu jinru zhe tao zhixu. Yuanqu yue si fen zhi san de mianji shi shui, yinci Kunming Hu kuoda le shixian juli, ba tiankong he yuanshan daijin yuan zhong, ye liyong daoying rang tong yi zu jianzhu zai butong shiduan chengxian butong qifen. Suowei jie jing, bushi ba yuanchu jingwu ban jin yuan nei, er shi tongguo fangxiang, juli, bili he xingzou luxian, rang yuanshan, humian yu jinchu jianzhu zucheng wanzheng huamian.',
    simpleChinese:
        '颐和园先用山和湖安排整体空间，再让长廊、桥和建筑进入风景。借景是利用方向、距离和行走路线，把远山、湖面与近处建筑组成一幅画。',
    vietnamese:
        'Cốt lõi của Di Hòa Viên không phải tập trung thật nhiều cung điện, mà dùng núi Vạn Thọ và hồ Côn Minh làm bộ khung cảnh quan, sau đó đưa Trường Lang, đình đài, chùa, cầu và đảo vào cùng một trật tự. Khoảng ba phần tư diện tích là mặt nước, vì vậy hồ không chỉ để ngắm mà còn mở rộng tầm nhìn, đưa bầu trời và núi xa vào khu vườn, đồng thời tạo nhiều bầu không khí khác nhau qua phản chiếu. “Mượn cảnh” không phải chuyển cảnh vật ở xa vào bên trong, mà dùng phương hướng, khoảng cách, tỷ lệ và lộ trình đi bộ để núi xa, mặt hồ và kiến trúc gần cùng tạo thành một khung cảnh hoàn chỉnh.',
    english:
        'The Summer Palace is organized around Longevity Hill and Kunming Lake rather than a collection of isolated palaces. Corridors, pavilions, temples, bridges, and islands enter this landscape framework. Because water covers roughly three quarters of the site, the lake extends visual distance, draws sky and distant hills into the garden, and changes the mood of buildings through reflection. Borrowed scenery does not physically bring distant objects inside. It uses direction, distance, proportion, and the visitor route so distant hills, water, and nearby architecture form one complete view.',
  ),
  DiscoveryEntry(
    text: '颐和园最早建成于一七五〇年，一八六〇年受到严重破坏，后来又在一八八六年按照原有基础重建。今天的园林因此同时保留了清代皇家园林的规划理想，也留下了损毁和修复的历史层次。十七孔桥是理解这种整体设计的好位置：它长一百五十多米，连接湖岸与南湖岛，在实用上是一条通道，在景观上又成为水面上的水平线，把近处石栏、开阔湖面和远处万寿山组织成前后层次。夕阳角度合适时，光线会穿过桥孔，桥不再只是坚硬的石构，而成为连接时间、光影与水面的景观装置。颐和园被列入世界文化遗产，并不只因为单体建筑华丽，更因为它把中国园林关于自然、人工、观看和行走的关系，完整地保存在一座大型皇家园林中。',
    pinyin:
        'Yiheyuan zui zao jiancheng yu yi qi wu ling nian, yi ba liu ling nian shoudao yanzhong pohuai, houlai you zai yi ba ba liu nian anzhao yuanyou jichu chongjian. Jintian de yuanlin tongshi baoliu le Qingdai huangjia yuanlin de guihua lixiang, ye liuxia le sunhui he xiufu de lishi cengci. Shiqikong Qiao chang yi bai wu shi duo mi, lianjie huan yu Nanhu Dao, zai jingguan shang chengwei shuimian shang de shuipingxian, ba jinchu shilan, kaikuo humian he yuanchu Wanshou Shan zuzhi cheng qianhou cengci. Yiheyuan de jiazhi bu zhi zai danti jianzhu, geng zai yu ta ba ziran, rengong, guankan he xingzou de guanxi wanzheng baocun xialai.',
    simpleChinese:
        '颐和园经历过破坏和重建。十七孔桥既连接湖岸与岛屿，也把湖面、远山和近处建筑组成有层次的风景。',
    vietnamese:
        'Di Hòa Viên được xây dựng lần đầu năm 1750, bị phá hủy nặng năm 1860 và được tái thiết trên nền cũ vào năm 1886. Vì vậy khu vườn ngày nay vừa giữ lý tưởng quy hoạch của vườn hoàng gia thời Thanh, vừa mang những lớp lịch sử của tổn thất và phục hồi. Cầu Thập Thất Khổng dài hơn 150 mét, nối bờ hồ với đảo Nam Hồ; về công năng đây là lối đi, còn trong bố cục cảnh quan nó tạo một đường ngang trên mặt nước, sắp xếp lan can gần, mặt hồ rộng và núi Vạn Thọ xa thành nhiều lớp. Giá trị di sản của Di Hòa Viên nằm ở cách nơi đây bảo tồn trọn vẹn mối quan hệ giữa thiên nhiên, nhân tạo, cách nhìn và việc di chuyển.',
    english:
        'The Summer Palace was first completed in 1750, severely damaged in 1860, and reconstructed on its original foundations in 1886. The garden therefore preserves both the planning ideals of a Qing imperial landscape and the historical layers of destruction and restoration. The Seventeen-Arch Bridge, more than 150 metres long, connects the shore with Nanhu Island. Functionally it is a route, while visually it forms a horizontal line across the water and arranges nearby stone railings, the open lake, and distant Longevity Hill into depth. Its World Heritage value lies not only in individual buildings, but in the preserved relationship between nature, human design, viewing, and movement.',
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
