import '../models/story_content.dart';

export 'daily_journey_experience.dart';
import 'beijing_story_catalog.dart';
import 'daily_journey_experience.dart';
import 'extended_journey_catalog.dart';
import 'journey_data.dart';
import 'journey_expansion_catalog.dart';
import 'journey_expansion_batch_two.dart';
import 'journey_expansion_batch_three.dart';
import 'journey_expansion_batch_four.dart';
import 'journey_expansion_batch_five.dart';
import 'summer_palace_journey.dart';
import 'special_journey_catalog.dart';

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
    url: 'https://qjxq.xa.gov.cn/zjqj/gyqj/tsqj/5df21c5565cbd81235fc1efa.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-shaanxi-xian-city-wall'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
];

const shanghaiStoryParagraphs = <String>[
  '上海实习记者许棠清晨赶到外滩，要采访一位即将退休的轮渡调度员。编辑只要浦东天际线的漂亮镜头，老人却坚持先带她看黄浦江水位记录。',
  '滨水步道旁的历史建筑见证金融与贸易，江对岸高楼催着城市向前。突发浓雾使一班轮渡延误，编辑要求许棠放弃老人，立刻直播乘客抱怨。',
  '她选择关掉直播提示，帮助调度员核对水位与能见度，再让被耽搁的通勤者讲述每天为何过江。新闻晚了十分钟，却解释了等待背后的安全选择。',
  '灯火亮起时，许棠把标题从“雾锁外滩”改成“看不见天际线的十分钟”。老建筑轮廓与高楼隔江相望，她不再用两个时代“走向未来”的套话，而写人怎样承担城市运行的责任。',
];

const shanghaiStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'shàng hǎi shí xí jì zhě xǔ táng qīng chén gǎn dào wài tān ， yào cǎi fǎng yí wèi jí jiāng tuì xiū de lún dù diào dù yuán 。 biān jí zhǐ yào pǔ dōng tiān jì xiàn de piào liang jìng tóu ， lǎo rén què jiān chí xiān dài tā kàn huáng pǔ jiāng shuǐ wèi jì lù 。',
    vietnamese:
        'Phóng viên thực tập Hứa Đường đến Bến Thượng Hải phỏng vấn một điều độ viên phà sắp nghỉ hưu. Biên tập chỉ muốn cảnh đường chân trời Phố Đông, còn ông muốn cô xem hồ sơ mực nước.',
    english:
        'Intern reporter Xu Tang reaches the Bund to interview a retiring ferry dispatcher. Her editor wants a Pudong skyline shot, while the dispatcher insists she first examine the Huangpu water-level records.',
  ),
  ReadingAnnotation(
    pinyin:
        'bīn shuǐ bù dào páng de lì shǐ jiàn zhù jiàn zhèng jīn róng yǔ mào yì ， jiāng duì àn gāo lóu cuī zhe chéng shì xiàng qián 。 tū fā nóng wù shǐ yì bān lún dù yán wù ， biān jí yāo qiú xǔ táng fàng qì lǎo rén ， lì kè zhí bō chéng kè bào yuàn 。',
    vietnamese:
        'Các công trình lịch sử chứng kiến tài chính và thương mại, còn cao ốc bên kia sông thúc thành phố tiến lên. Sương dày làm phà chậm, và biên tập yêu cầu cô bỏ cuộc phỏng vấn để phát trực tiếp lời phàn nàn.',
    english:
        'Historic waterfront buildings witnessed finance and trade while towers across the river push the city forward. Fog delays a ferry, and the editor orders her to abandon the interview and stream complaints.',
  ),
  ReadingAnnotation(
    pinyin:
        'tā xuǎn zé guān diào zhí bō tí shì ， bāng zhù diào dù yuán hé duì shuǐ wèi yǔ néng jiàn dù ， zài ràng bèi dān gē de tōng qín zhě jiǎng shù měi tiān wèi hé guò jiāng 。 xīn wén wǎn le shí fēn zhōng ， què jiě shì le děng dài bèi hòu de ān quán xuǎn zé 。',
    vietnamese:
        'Cô tắt nhắc phát sóng, giúp kiểm tra mực nước và tầm nhìn rồi lắng nghe người đi làm. Bản tin muộn mười phút nhưng giải thích lựa chọn an toàn phía sau sự chờ đợi.',
    english:
        'She turns off the live prompt, helps check water level and visibility, and listens to commuters. The report is ten minutes late but explains the safety decision behind the wait.',
  ),
  ReadingAnnotation(
    pinyin:
        'dēng huǒ liàng qǐ shí ， xǔ táng bǎ biāo tí cóng “ wù suǒ wài tān ” gǎi chéng “ kàn bú jiàn tiān jì xiàn de shí fēn zhōng ”。 lǎo jiàn zhù lún kuò yǔ gāo lóu gé jiāng xiāng wàng ， tā bú zài yòng liǎng gè shí dài “ zǒu xiàng wèi lái ” de tào huà ， ér xiě rén zěn yàng chéng dān chéng shì yùn xíng de zé rèn 。',
    vietnamese:
        'Khi đèn sáng, Hứa Đường đổi tiêu đề thành ‘Mười phút không thấy đường chân trời’. Cô viết về trách nhiệm giúp thành phố vận hành thay vì sáo ngữ về hai thời đại.',
    english:
        'When the lights come on, Xu Tang retitles the story ‘Ten Minutes Without a Skyline.’ She writes about responsibility that keeps a city running rather than clichés about two eras.',
  ),
];

const shanghaiWords = <WordEntry>[
  WordEntry(
    word: '外滩',
    pinyin: 'Wàitān',
    partOfSpeech: '名词（专名）',
    simpleChinese: '上海黄浦江边著名的历史滨水区域。',
    translation: 'Bến Thượng Hải, khu ven sông lịch sử nổi tiếng.',
    englishDefinition: 'the Bund, Shanghai’s historic waterfront',
    symbol: '🌆',
  ),
  WordEntry(
    word: '滨水',
    pinyin: 'bīnshuǐ',
    partOfSpeech: '形容词',
    simpleChinese: '靠近河流、湖泊或海边。',
    translation: 'Nằm ven sông, hồ hoặc biển.',
    englishDefinition: 'waterfront; beside a body of water',
    symbol: '🌊',
  ),
  WordEntry(
    word: '黄浦江',
    pinyin: 'Huángpǔ Jiāng',
    partOfSpeech: '名词（专名）',
    simpleChinese: '流经上海市中心的重要河流。',
    translation: 'Sông Hoàng Phố chảy qua trung tâm Thượng Hải.',
    englishDefinition: 'the Huangpu River',
    symbol: '🚢',
  ),
  WordEntry(
    word: '轮廓',
    pinyin: 'lúnkuò',
    partOfSpeech: '名词',
    simpleChinese: '物体外部的线条和大致形状。',
    translation: 'Đường nét hoặc hình dáng bên ngoài.',
    englishDefinition: 'outline or silhouette',
    symbol: '✒️',
  ),
  WordEntry(
    word: '见证',
    pinyin: 'jiànzhèng',
    partOfSpeech: '动词',
    simpleChinese: '亲眼看见并能够证明某件事。',
    translation: 'Chứng kiến và có thể xác nhận một sự việc.',
    englishDefinition: 'to witness',
    symbol: '👁️',
  ),
  WordEntry(
    word: '金融',
    pinyin: 'jīnróng',
    partOfSpeech: '名词',
    simpleChinese: '与资金、银行和投资有关的经济活动。',
    translation: 'Hoạt động tài chính, ngân hàng và đầu tư.',
    englishDefinition: 'finance and financial activity',
    symbol: '🏦',
  ),
  WordEntry(
    word: '贸易',
    pinyin: 'màoyì',
    partOfSpeech: '名词',
    simpleChinese: '商品和服务的买卖活动。',
    translation: 'Hoạt động mua bán hàng hóa và dịch vụ.',
    englishDefinition: 'trade or commerce',
    symbol: '📦',
  ),
  WordEntry(
    word: '天际线',
    pinyin: 'tiānjìxiàn',
    partOfSpeech: '名词',
    simpleChinese: '建筑物顶部与天空形成的整体线条。',
    translation: 'Đường chân trời do các tòa nhà tạo thành.',
    englishDefinition: 'skyline',
    symbol: '🏙️',
  ),
  WordEntry(
    word: '隔江相望',
    pinyin: 'gé jiāng xiāngwàng',
    partOfSpeech: '动词短语',
    simpleChinese: '在河的两边互相面对。',
    translation: 'Nhìn nhau từ hai bờ sông.',
    englishDefinition: 'to face each other across a river',
    symbol: '↔️',
  ),
  WordEntry(
    word: '灯火',
    pinyin: 'dēnghuǒ',
    partOfSpeech: '名词',
    simpleChinese: '夜晚亮起的灯光。',
    translation: 'Ánh đèn vào ban đêm.',
    englishDefinition: 'lights at night',
    symbol: '✨',
  ),
  WordEntry(
    word: '时代',
    pinyin: 'shídài',
    partOfSpeech: '名词',
    simpleChinese: '历史发展中的一个时期。',
    translation: 'Một thời đại hoặc giai đoạn lịch sử.',
    englishDefinition: 'era or age',
    symbol: '⏳',
  ),
  WordEntry(
    word: '走向',
    pinyin: 'zǒuxiàng',
    partOfSpeech: '动词',
    simpleChinese: '朝着某个方向发展。',
    translation: 'Phát triển theo một hướng.',
    englishDefinition: 'to move toward',
    symbol: '➡️',
  ),
];

const shanghaiDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
    text: '外滩是一段约一点五公里长的滨水区域，也是受到保护的历史街区。',
    pinyin:
        'Wàitān shì yí duàn yuē yì diǎn wǔ gōnglǐ cháng de bīnshuǐ qūyù, yě shì shòudào bǎohù de lìshǐ jiēqū.',
    simpleChinese: '外滩沿江约一点五公里，并受到历史文化保护。',
    vietnamese:
        'Bến Thượng Hải là khu ven sông dài khoảng 1,5 km và là khu lịch sử được bảo vệ.',
    english:
        'The Bund is an approximately 1.5-kilometre waterfront and a protected historic district.',
  ),
  DiscoveryEntry(
    text: '黄浦江西岸保存着许多不同风格的历史建筑，因此外滩也常被称为露天建筑博物馆。',
    pinyin:
        'Huángpǔ Jiāng xī àn bǎocúnzhe xǔduō bùtóng fēnggé de lìshǐ jiànzhù, yīncǐ Wàitān yě cháng bèi chēngwéi lùtiān jiànzhù bówùguǎn.',
    simpleChinese: '外滩有很多不同风格的老建筑，像一座露天博物馆。',
    vietnamese:
        'Bờ tây sông Hoàng Phố có nhiều công trình lịch sử đa phong cách, nên thường được gọi là bảo tàng kiến trúc ngoài trời.',
    english:
        'Historic buildings in many styles make the Bund an outdoor museum of architecture.',
  ),
  DiscoveryEntry(
    text: '外滩过去与银行、贸易公司和城市商业发展密切相关。',
    pinyin:
        'Wàitān guòqù yǔ yínháng, màoyì gōngsī hé chéngshì shāngyè fāzhǎn mìqiè xiāngguān.',
    simpleChinese: '外滩过去是银行、贸易和商业活动的重要地区。',
    vietnamese:
        'Trong quá khứ, Bến Thượng Hải gắn chặt với ngân hàng, thương mại và sự phát triển kinh doanh.',
    english:
        'The Bund was closely connected to banks, trading firms, and commercial development.',
  ),
  DiscoveryEntry(
    text: '从外滩看浦东，可以同时观察上海的历史建筑与现代天际线。',
    pinyin:
        'Cóng Wàitān kàn Pǔdōng, kěyǐ tóngshí guānchá Shànghǎi de lìshǐ jiànzhù yǔ xiàndài tiānjìxiàn.',
    simpleChinese: '站在外滩，可以同时看到老上海和现代浦东。',
    vietnamese:
        'Từ Bến Thượng Hải có thể đồng thời ngắm kiến trúc lịch sử và đường chân trời hiện đại của Phố Đông.',
    english:
        'From the Bund, historic Shanghai and Pudong’s modern skyline appear together.',
  ),
];

const xianStoryParagraphs = <String>[
  '西安自行车维修员马骁在城墙闭园前接到一辆坏车，车主是赶去角楼参加演出的学生。若推到下个服务点，她一定迟到；私自拆护链又可能损伤城砖。',
  '马骁熟悉明代城墙宽阔墙顶的坡度，也看得见城内街巷与城外新路同时展开。他想迅速解决问题，却发现真正卡住车轮的是游客丢下的金属扣。',
  '他选择不冒险拆车，而是用工具取出金属扣，再陪学生跑完最后一段。演出开场晚了，学生当众说明原因，并把沿路杂物交给巡护员。',
  '暮色落在永宁门和护城河时，马骁踩着砖石返回。现存防御规模来自明代并经修缮延续；城墙连接过去与古都今天，也因人们肯让速度服从巡查与保护边界。',
];

const xianStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'xī ān zì xíng chē wéi xiū yuán mǎ xiāo zài chéng qiáng bì yuán qián jiē dào yí liàng huài chē ， chē zhǔ shì gǎn qù jiǎo lóu cān jiā yǎn chū de xué shēng 。 ruò tuī dào xià gè fú wù diǎn ， tā yí dìng chí dào ； sī zì chāi hù liàn yòu kě néng sǔn shāng chéng zhuān 。',
    vietnamese:
        'Thợ sửa xe Mã Kiêu nhận một chiếc xe hỏng trước giờ đóng cửa tường thành. Chủ xe phải đến tháp góc biểu diễn; đẩy tới trạm sau sẽ muộn, còn tự tháo xích bảo vệ có thể làm hại gạch thành.',
    english:
        'Bicycle mechanic Ma Xiao receives a broken bike before the city wall closes. Its owner must reach a corner-tower performance; pushing it to the next station means being late, while removing the guard may damage the bricks.',
  ),
  ReadingAnnotation(
    pinyin:
        'mǎ xiāo shú xī míng dài chéng qiáng kuān kuò qiáng dǐng de pō dù ， yě kàn dé jiàn chéng nèi jiē xiàng yǔ chéng wài xīn lù tóng shí zhǎn kāi 。 tā xiǎng xùn sù jiě jué wèn tí ， què fā xiàn zhēn zhèng kǎ zhù chē lún de shì yóu kè diū xià de jīn shǔ kòu 。',
    vietnamese:
        'Anh hiểu độ dốc của mặt thành thời Minh và nhìn thấy phố cũ cùng đường mới. Muốn xử lý thật nhanh, anh phát hiện một khóa kim loại do du khách bỏ lại mới là thứ kẹt bánh.',
    english:
        'He knows the slope of the broad Ming wall and sees old lanes and new roads together. Eager for a quick fix, he discovers that a discarded metal clasp is jamming the wheel.',
  ),
  ReadingAnnotation(
    pinyin:
        'tā xuǎn zé bú mào xiǎn chāi chē ， ér shì yòng gōng jù qǔ chū jīn shǔ kòu ， zài péi xué shēng pǎo wán zuì hòu yí duàn 。 yǎn chū kāi chǎng wǎn le ， xué shēng dāng zhòng shuō míng yuán yīn ， bìng bǎ yán lù zá wù jiāo gěi xún hù yuán 。',
    vietnamese:
        'Anh không mạo hiểm tháo xe mà lấy khóa ra rồi chạy cùng học sinh đoạn cuối. Buổi diễn bắt đầu muộn; cô giải thích nguyên nhân và giao rác nhặt được cho người tuần tra.',
    english:
        'He avoids risky dismantling, removes the clasp, and runs the final stretch with the student. The performance starts late; she explains why and hands collected debris to a patrol worker.',
  ),
  ReadingAnnotation(
    pinyin:
        'mù sè luò zài yǒng níng mén hé hù chéng hé shí ， mǎ xiāo cǎi zhe zhuān shí fǎn huí 。 xiàn cún fáng yù guī mó lái zì míng dài bìng jīng xiū shàn yán xù ； chéng qiáng lián jiē guò qù yǔ gǔ dōu jīn tiān ， yě yīn rén men kěn ràng sù dù fú cóng xún chá yǔ bǎo hù biān jiè 。',
    vietnamese:
        'Trong hoàng hôn ở Vĩnh Ninh Môn, Mã Kiêu hiểu tường thành nối quá khứ với hôm nay vì con người để tốc độ tuân theo ranh giới tuần tra và bảo vệ.',
    english:
        'At dusk by Yongning Gate, Ma Xiao understands that the wall connects past and present because people let speed yield to inspection and conservation boundaries.',
  ),
];

const xianWords = <WordEntry>[
  WordEntry(
    word: '城墙',
    pinyin: 'chéngqiáng',
    partOfSpeech: '名词',
    simpleChinese: '围绕城市、用于保护城市的高墙。',
    translation: 'Tường thành bao quanh và bảo vệ thành phố.',
    englishDefinition: 'city wall',
    symbol: '🧱',
  ),
  WordEntry(
    word: '永宁门',
    pinyin: 'Yǒngníngmén',
    partOfSpeech: '名词（专名）',
    simpleChinese: '西安城墙南面的重要城门。',
    translation: 'Cổng Vĩnh Ninh, cổng quan trọng phía nam.',
    englishDefinition: 'Yongning Gate, the south gate',
    symbol: '🚪',
  ),
  WordEntry(
    word: '砖石',
    pinyin: 'zhuānshí',
    partOfSpeech: '名词',
    simpleChinese: '砖和石头等建筑材料。',
    translation: 'Gạch và đá dùng trong xây dựng.',
    englishDefinition: 'brick and stone',
    symbol: '🪨',
  ),
  WordEntry(
    word: '角楼',
    pinyin: 'jiǎolóu',
    partOfSpeech: '名词',
    simpleChinese: '建在城墙转角处的楼。',
    translation: 'Tháp xây ở góc tường thành.',
    englishDefinition: 'corner tower',
    symbol: '🏯',
  ),
  WordEntry(
    word: '护城河',
    pinyin: 'hùchénghé',
    partOfSpeech: '名词',
    simpleChinese: '城墙外用于防御的河沟。',
    translation: 'Hào nước phòng thủ bên ngoài tường thành.',
    englishDefinition: 'moat',
    symbol: '🌊',
  ),
  WordEntry(
    word: '防御',
    pinyin: 'fángyù',
    partOfSpeech: '动词',
    simpleChinese: '保护自己，阻止外来的攻击。',
    translation: 'Phòng thủ, ngăn chặn tấn công.',
    englishDefinition: 'defence',
    symbol: '🛡️',
  ),
  WordEntry(
    word: '现存',
    pinyin: 'xiàncún',
    partOfSpeech: '形容词',
    simpleChinese: '现在仍然存在。',
    translation: 'Hiện vẫn còn tồn tại.',
    englishDefinition: 'still existing',
    symbol: '📍',
  ),
  WordEntry(
    word: '规模',
    pinyin: 'guīmó',
    partOfSpeech: '名词',
    simpleChinese: '事物的大小和范围。',
    translation: 'Quy mô và phạm vi.',
    englishDefinition: 'scale or extent',
    symbol: '📐',
  ),
  WordEntry(
    word: '修缮',
    pinyin: 'xiūshàn',
    partOfSpeech: '动词',
    simpleChinese: '修理并保护建筑。',
    translation: 'Tu bổ và bảo vệ công trình.',
    englishDefinition: 'to repair and conserve',
    symbol: '🔧',
  ),
  WordEntry(
    word: '巡查',
    pinyin: 'xúnchá',
    partOfSpeech: '动词',
    simpleChinese: '按照路线检查情况。',
    translation: 'Tuần tra và kiểm tra theo tuyến.',
    englishDefinition: 'to patrol and inspect',
    symbol: '🔍',
  ),
  WordEntry(
    word: '古都',
    pinyin: 'gǔdū',
    partOfSpeech: '名词',
    simpleChinese: '古代曾经作为首都的城市。',
    translation: 'Cố đô, thành phố từng là kinh đô.',
    englishDefinition: 'ancient capital',
    symbol: '🏛️',
  ),
  WordEntry(
    word: '边界',
    pinyin: 'biānjiè',
    partOfSpeech: '名词',
    simpleChinese: '两个区域之间的分界线。',
    translation: 'Ranh giới giữa hai khu vực.',
    englishDefinition: 'boundary',
    symbol: '〰️',
  ),
];

const xianDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(
    text: '西安现存城墙的主要结构形成于明代，并建立在更早城市遗迹的基础上。',
    pinyin:
        'Xī’ān xiàncún chéngqiáng de zhǔyào jiégòu xíngchéng yú Míngdài, bìng jiànlì zài gèng zǎo chéngshì yíjì de jīchǔ shàng.',
    simpleChinese: '今天看到的城墙主要形成于明代，也利用了更早的城市基础。',
    vietnamese:
        'Cấu trúc chính của tường thành Tây An hiện nay hình thành vào thời Minh trên nền dấu tích đô thị sớm hơn.',
    english:
        'The existing wall took its main form in the Ming dynasty on foundations from earlier cities.',
  ),
  DiscoveryEntry(
    text: '城墙、城门、护城河和城楼共同组成完整的古代城市防御体系。',
    pinyin:
        'Chéngqiáng, chéngmén, hùchénghé hé chénglóu gòngtóng zǔchéng wánzhěng de gǔdài chéngshì fángyù tǐxì.',
    simpleChinese: '不同设施一起保护古代城市。',
    vietnamese:
        'Tường thành, cổng, hào nước và tháp thành tạo thành một hệ thống phòng thủ đô thị hoàn chỉnh.',
    english:
        'Walls, gates, moat, and towers formed an integrated urban defence system.',
  ),
  DiscoveryEntry(
    text: '宽阔的墙顶不仅用于防守，也方便人员和物资移动。',
    pinyin:
        'Kuānkuò de qiángdǐng bùjǐn yòngyú fángshǒu, yě fāngbiàn rényuán hé wùzī yídòng.',
    simpleChinese: '墙顶很宽，可以巡逻和运送物资。',
    vietnamese:
        'Mặt thành rộng không chỉ dùng để phòng thủ mà còn giúp di chuyển người và vật tư.',
    english:
        'The broad top supported defence as well as movement of people and supplies.',
  ),
  DiscoveryEntry(
    text: '今天的西安城墙通过持续修缮与公共开放，连接文化保护和现代城市生活。',
    pinyin:
        'Jīntiān de Xī’ān Chéngqiáng tōngguò chíxù xiūshàn yǔ gōnggòng kāifàng, liánjiē wénhuà bǎohù hé xiàndài chéngshì shēnghuó.',
    simpleChinese: '城墙一边被保护，一边继续进入今天的城市生活。',
    vietnamese:
        'Ngày nay, việc tu bổ liên tục và mở cửa công cộng giúp tường thành kết nối bảo tồn văn hóa với đời sống đô thị hiện đại.',
    english:
        'Ongoing conservation and public access connect the wall with modern city life.',
  ),
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
      sourceIds: const ['shaanxi-gov-xian-city-wall', 'xian-qujiang-city-wall'],
    ),
  ),
);

final dailyStorySources = <StorySourceRecord>[
  ...beijingStorySources,
  ...summerPalaceStorySources,
  ...shanghaiStorySources,
  ...xianStorySources,
  ...extendedJourneySources,
  ...journeyExpansionSources,
  ...journeyExpansionBatchTwoSources,
  ...journeyExpansionBatchThreeSources,
  ...journeyExpansionBatchFourSources,
  ...journeyExpansionBatchFiveSources,
];

final dailyJourneyRecords = <JourneyContentRecord>[
  beijingForbiddenCityJourney,
  summerPalaceJourneyContent,
  shanghaiBundJourney,
  xianCityWallJourney,
  ...extendedJourneyRecords,
  ...journeyExpansionRecords,
  ...journeyExpansionBatchTwoRecords,
  ...journeyExpansionBatchThreeRecords,
  ...journeyExpansionBatchFourRecords,
  ...journeyExpansionBatchFiveRecords,
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
  summerPalaceJourneyExperience,
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
  ...journeyExpansionExperiences,
  ...journeyExpansionBatchTwoExperiences,
  ...journeyExpansionBatchThreeExperiences,
  ...journeyExpansionBatchFourExperiences,
  ...journeyExpansionBatchFiveExperiences,
];

final allJourneyExperiences = <DailyJourneyExperience>[
  ...dailyJourneyExperiences,
  ...specialJourneyExperiences,
];

final List<WordEntry> allDailyJourneyWords = List<WordEntry>.unmodifiable(
  <String, WordEntry>{
    for (final journey in allJourneyExperiences)
      for (final entry in journey.words) entry.word: entry,
  }.values,
);

DailyJourneyExperience requireDailyJourneyExperience(String id) {
  return allJourneyExperiences.firstWhere(
    (journey) => journey.id == id,
    orElse: () => dailyJourneyExperiences.first,
  );
}

DailyJourneyExperience dailyJourneyForDate(DateTime date) {
  final day = DateTime.utc(date.year, date.month, date.day);
  final epoch = DateTime.utc(2026, 1, 1);
  final dayNumber = day.difference(epoch).inDays;
  final index = dayNumber % dailyJourneyExperiences.length;
  return dailyJourneyExperiences[index < 0
      ? index + dailyJourneyExperiences.length
      : index];
}
