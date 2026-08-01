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
  '颐和园彩画记录员孟秋要在闭园前复核长廊一段褪色纹样。母亲第一次来北京，正等她一起走到昆明湖边看万寿山；工作表与约定都只剩一小时。孟秋沿廊柱移动，湖光在开口间闪过，她却发现旧照片把两幅相似图案标反了。照片只拍到半截屋檐，纸面还留着修复前的水痕；若把错误继续抄进档案，下一次维护就会循着错误位置寻找。照表抄写可以准时离开，重新核对则会让母亲独自等待。她选择停下，用廊柱编号、屋檐、树影和远山的相对位置逐格定位，又蹲下来比对木构上尚存的颜料痕迹。她把问题和预计时间如实发给母亲，没有用一句“快结束了”敷衍。母亲没有催促，而是从十七孔桥慢慢走来，沿途拍下桥孔与湖岸的角度，最后在长廊尽头与她会合。',
  '两人没有赶上计划中的落日位置，只看见昆明湖把桥、亭台和灰蓝天空收入倒影。孟秋原本为失约而难受，母亲却把刚拍的照片递给她：十七孔桥没有截断水面，桥、岛与远山在不同步伐里重新相接。孟秋讲起皇家园林经历设计、损失与修复，今天所见并非从未改变的古园；母亲则指出，每换一个角度，佛香阁都像移动一次，长廊的开口也会把同一片湖分成不同画面。孟秋没有再解释，只在工作表里补上行走方向、光线和对应廊柱，让彩画与借景、对景的关系融合起来。离开前，母亲把最后一张照片交给她：画面里没有预定的落日，只有长廊尽头并肩站着的两个人。湖面起风时，照片里的倒影微微模糊，廊柱编号却仍然十分清楚。孟秋把它夹在修正后的记录旁，湖光山色与廊柱编号落在同一页，她没有追回原来的计划。',
];

const summerPalaceStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'yí hé yuán cǎi huà jì lù yuán mèng qiū yào zài bì yuán qián fù hé cháng láng yí duàn tuì sè wén yàng 。 mǔ qīn dì yī cì lái běi jīng ， zhèng děng tā yì qǐ zǒu dào kūn míng hú biān kàn wàn shòu shān ； gōng zuò biǎo yǔ yuē dìng dū zhī shèng yì xiǎo shí 。 mèng qiū yán láng zhù yí dòng ， hú guāng zài kāi kǒu jiān shǎn guò ， tā què fā xiàn jiù zhào piàn bǎ liǎng fú xiāng sì tú àn biāo fǎn le 。 zhào piàn zhǐ pāi dào bàn jié wū yán ， zhǐ miàn hái liú zhe xiū fù qián de shuǐ hén ； ruò bǎ cuò wù jì xù chāo jìn dàng àn ， xià yí cì wéi hù jiù huì xún zhe cuò wù wèi zhì xún zhǎo 。 zhào biǎo chāo xiě kě yǐ zhǔn shí lí kāi ， chóng xīn hé duì zé huì ràng mǔ qīn dú zì děng dài 。 tā xuǎn zé tíng xià ， yòng láng zhù biān hào 、 wū yán 、 shù yǐng hé yuǎn shān de xiāng duì wèi zhì zhú gé dìng wèi ， yòu dūn xià lái bǐ duì mù gòu shàng shàng cún de yán liào hén jì 。 tā bǎ wèn tí hé yù jì shí jiān rú shí fā gěi mǔ qīn ， méi yǒu yòng yí jù “ kuài jié shù le ” fū yǎn 。 mǔ qīn méi yǒu cuī cù ， ér shì cóng shí qī kǒng qiáo màn màn zǒu lái ， yán tú pāi xià qiáo kǒng yǔ hú àn de jiǎo dù ， zuì hòu zài cháng láng jìn tóu yǔ tā huì hé 。',
    vietnamese:
        'Nhân viên ghi chép tranh màu Mạnh Thu phải kiểm tra một họa tiết phai trong Trường Lang trước giờ đóng cửa, trong khi mẹ đang chờ cùng ngắm hồ Côn Minh. Cô phát hiện hai ảnh cũ bị ghi ngược và dấu sơn còn lại không khớp hồ sơ. Nếu chép theo bảng, cô sẽ đúng hẹn nhưng lần tu bổ sau sẽ tìm sai vị trí. Cô ở lại đối chiếu số cột, mái hiên, bóng cây và núi xa, rồi báo thật thời gian cho mẹ. Mẹ không giục mà đi từ cầu Thập Thất Khổng, chụp các góc cầu và bờ hồ trước khi gặp cô ở cuối hành lang.',
    english:
        'Painted-decoration recorder Meng Qiu must verify a faded Long Corridor motif before closing while her mother waits to see Kunming Lake. She finds two old photographs reversed and surviving paint traces that do not match the record. Copying the sheet would keep their appointment but mislead the next restoration. She stays to compare column numbers, eaves, shadows, and distant hills, then gives her mother an honest delay. Her mother walks from the Seventeen-Arch Bridge, photographing the bridge and shore before meeting her at the corridor\'s end.',
  ),
  ReadingAnnotation(
    pinyin:
        'liǎng rén méi yǒu gǎn shàng jì huà zhōng de luò rì wèi zhì ， zhǐ kàn jiàn kūn míng hú bǎ qiáo 、 tíng tái hé huī lán tiān kōng shōu rù dǎo yǐng 。 mèng qiū yuán běn wèi shī yuē ér nán shòu ， mǔ qīn què bǎ gāng pāi de zhào piàn dì gěi tā ： shí qī kǒng qiáo méi yǒu jié duàn shuǐ miàn ， qiáo 、 dǎo yǔ yuǎn shān zài bù tóng bù fá lǐ chóng xīn xiāng jiē 。 mèng qiū jiǎng qǐ huáng jiā yuán lín jīng lì shè jì 、 sǔn shī yǔ xiū fù ， jīn tiān suǒ jiàn bìng fēi cóng wèi gǎi biàn de gǔ yuán ； mǔ qīn zé zhǐ chū ， měi huàn yí gè jiǎo dù ， fó xiāng gé dōu xiàng yí dòng yí cì ， cháng láng de kāi kǒu yě huì bǎ tóng yí piàn hú fēn chéng bù tóng huà miàn 。 mèng qiū méi yǒu zài jiě shì ， zhǐ zài gōng zuò biǎo lǐ bǔ shàng xíng zǒu fāng xiàng 、 guāng xiàn hé duì yìng láng zhù ， ràng cǎi huà yǔ jiè jǐng 、 duì jǐng de guān xi róng hé qǐ lái 。 lí kāi qián ， mǔ qīn bǎ zuì hòu yì zhāng zhào piàn jiāo gěi tā ： huà miàn lǐ méi yǒu yù dìng de luò rì ， zhǐ yǒu cháng láng jìn tóu bìng jiān zhàn zhe de liǎng gè rén 。 hú miàn qǐ fēng shí ， zhào piàn lǐ de dǎo yǐng wēi wēi mó hu ， láng zhù biān hào què réng rán shí fēn qīng chǔ 。 mèng qiū bǎ tā jiā zài xiū zhèng hòu de jì lù páng ， hú guāng shān sè yǔ láng zhù biān hào luò zài tóng yí yè ， tā méi yǒu zhuī huí yuán lái de jì huà 。',
    vietnamese:
        'Họ lỡ chỗ ngắm hoàng hôn nhưng thấy hồ phản chiếu cầu, đình và trời xanh xám. Mẹ đưa những ảnh vừa chụp và chỉ ra rằng cầu, đảo, núi xa cùng Phật Hương Các đổi quan hệ theo mỗi bước chân. Mạnh Thu không giải thích thêm; cô ghi hướng đi, ánh sáng và số cột để nối tranh màu với mượn cảnh và đối cảnh. Trước khi về, mẹ đưa bức ảnh cuối: không có hoàng hôn dự định, chỉ có hai người đứng cạnh nhau ở cuối Trường Lang. Gió làm bóng nước trong ảnh hơi nhòe, nhưng số cột vẫn rõ. Mạnh Thu kẹp nó bên hồ sơ đã sửa; cảnh hồ núi và số cột nằm trên cùng một trang, còn cô không cố lấy lại kế hoạch cũ.',
    english:
        'They miss their planned sunset spot but see the lake reflect bridges, pavilions, and a grey-blue sky. Her mother shares photographs showing how the bridge, island, distant hills, and Tower of Buddhist Incense change with each step. Meng Qiu offers no further explanation; she records direction, light, and column numbers, connecting painted decoration with borrowed and paired views. Before leaving, her mother gives her the final photograph: no planned sunset, only two people standing together at the Long Corridor\'s end. Wind blurs the reflection in the picture, but the column number stays sharp. Meng Qiu files it beside the corrected record; the lake-and-hill view and column number share one page, and she does not try to recover the old plan.',
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
