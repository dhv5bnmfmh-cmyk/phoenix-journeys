import '../models/story_content.dart';
import 'chengdu_kuanzhai_one_pass.dart';
import 'daily_journey_experience.dart';
import 'guangzhou_chen_clan_one_pass.dart';
import 'journey_data.dart';
import 'kaiping_diaolou_gold.dart';

const extendedJourneySources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-hangzhou-west-lake',
    title: 'West Lake Cultural Landscape of Hangzhou',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1334',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-zhejiang-hangzhou-west-lake'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: 'chengdu-gov-kuanzhai-alley',
    title: 'Kuanzhai Alley',
    publisher: 'China Daily Government Portal',
    url:
        'https://govt.chinadaily.com.cn/s/202001/08/WS5e157a62498e1ed196a6bc4d/kuanzhai-alley.html',
    kind: StorySourceKind.government,
    languageCode: 'en',
    geoNodeIds: ['cn-sichuan-chengdu-kuanzhai'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: 'nanjing-gov-fuzimiao-qinhuai',
    title: '南京市夫子庙秦淮风光带风景名胜区条例',
    publisher: '南京市人民政府',
    url: 'https://www.nanjing.gov.cn/zdgk/202103/t20210331_2864878.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-jiangsu-nanjing-qinhuai'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  StorySourceRecord(
    id: guangzhouChenClanSourceRecordId,
    title: '广东民间工艺博物馆',
    publisher: '广州市人民政府',
    url:
        'https://www.gz.gov.cn/zlgz/gzly/wzgz/wbcg/content/post_9587900.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-guangdong-guangzhou-chen-clan'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-20',
  ),
  ...kaipingDiaolouSources,
];

JourneyContentRecord _buildJourney({
  required String id,
  required String title,
  required String geoNodeId,
  required List<String> tags,
  required List<String> paragraphs,
  required List<String> sourceIds,
}) {
  return JourneyContentRecord(
    id: id,
    title: title,
    geoNodeId: geoNodeId,
    languageCode: 'zh-CN',
    verificationStatus: StoryVerificationStatus.published,
    tags: tags,
    sections: List.generate(
      paragraphs.length,
      (index) => JourneyStorySection(
        id: 'story-$index',
        text: paragraphs[index],
        sourceIds: sourceIds,
      ),
    ),
  );
}

const hangzhouStoryParagraphs = <String>[
  '方毓六十九岁，和周绍庭结婚四十三年。最近半年，周绍庭开始把日期、人名和刚说过的话弄混，有时出门后还会忘记原来的方向。女儿替他约了周一的记忆门诊，方毓把预约卡放在包内层，几次想拿出来，又怕他觉得自己被当成病人。',
  '星期六，她说很久没走西湖，拉他从断桥出发。一路上，她不断问“断桥残雪是什么季节”“远处是哪座塔”“他们第一次来时下没下雨”。周绍庭把冬景说成夏天，又说错塔名；第三个问题没有回答。散步渐渐只剩方毓在出题。',
  '雨点落下来，桥边石阶很快湿了。方毓回头看他，脚下一偏，周绍庭下意识扶住她的手肘：“这里一直滑。”四十三年前第一次走这段路时，他也曾在湿石阶上这样扶她。景名和日期都乱了，这个动作却先于回答发生。',
  '方毓把下一道题停住，从包里拿出预约卡，承认今天不是来赏景，而是想证明他还记得两个人的日子。周绍庭没有把卡推回去：“我知道你在怕什么。我也怕。”他看清日期，把卡放进自己的钱包。公交车到站后，他没有让方毓替自己开口，先问司机：“去医院，哪一站下？”',
];

const hangzhouStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin: 'Fāng Yù hé Zhōu Shàotíng jiéhūn sìshísān nián. Tā dài zhe yīyuàn yùyuē kǎ, péi tā cóng Duànqiáo zǒu Xīhú.',
    vietnamese: 'Phương Dục và Chu Thiệu Đình đã kết hôn bốn mươi ba năm. Bà giấu thẻ hẹn khám trong túi khi hai người đi bộ từ Đoạn Kiều.',
    english: 'Fang Yu and Zhou Shaoting have been married for forty-three years. She hides a clinic appointment card during their West Lake walk from Broken Bridge.',
  ),
  ReadingAnnotation(
    pinyin: 'Tāmen cóng Duànqiáo chūfā. Fāng Yù bùduàn wèn Xīhú jǐngmíng, Zhōu Shàotíng dá cuò le liǎng cì.',
    vietnamese: 'Họ xuất phát từ Đoạn Kiều. Phương Dục liên tục hỏi tên cảnh Tây Hồ, còn Chu Thiệu Đình trả lời sai hai lần.',
    english: 'They set out from Broken Bridge. Fang Yu keeps asking West Lake view-name questions, and Zhou Shaoting answers two incorrectly.',
  ),
  ReadingAnnotation(
    pinyin: 'Shíjiē shàng, Zhōu Shàotíng fú zhù tā de shǒuzhǒu. Fāng Yù bù zài chūtí, bǎ yùyuē kǎ jiāo gěi tā.',
    vietnamese: 'Trên bậc đá ướt, ông đỡ khuỷu tay bà theo phản xạ, như nhiều năm trước.',
    english: 'On a wet stone step he instinctively catches her elbow, as he did many years earlier.',
  ),
  ReadingAnnotation(
    pinyin: 'Fāng Yù bù zài chūtí, bǎ yùyuē kǎ jiāo gěi tā. Tā bǎ kǎ fàng jìn zìjǐ de qiánbāo.',
    vietnamese: 'Bà thôi kiểm tra và trao thẳng thẻ hẹn; ông cất nó vào ví rồi chủ động hỏi trạm bệnh viện.',
    english: 'She stops testing and hands over the appointment card; he puts it in his own wallet and asks for the hospital stop.',
  ),
];

const hangzhouWords = <WordEntry>[
  WordEntry(word: '西湖', pinyin: 'Xīhú', partOfSpeech: '名词（专名）', simpleChinese: '杭州的湖泊文化景观。', translation: 'Tây Hồ.', englishDefinition: 'West Lake', symbol: '🌊'),
  WordEntry(word: '断桥', pinyin: 'Duànqiáo', partOfSpeech: '名词（专名）', simpleChinese: '西湖白堤东端附近的著名桥梁。', translation: 'Đoạn Kiều.', englishDefinition: 'Broken Bridge', symbol: '🌉'),
  WordEntry(word: '预约卡', pinyin: 'yùyuē kǎ', partOfSpeech: '名词', simpleChinese: '写有预约时间和地点的卡片。', translation: 'Thẻ hẹn.', englishDefinition: 'appointment card', symbol: '🗓️'),
  WordEntry(word: '记忆', pinyin: 'jìyì', partOfSpeech: '名词', simpleChinese: '保存和想起经历的能力。', translation: 'Trí nhớ.', englishDefinition: 'memory', symbol: '🧠'),
  WordEntry(word: '门诊', pinyin: 'ménzhěn', partOfSpeech: '名词', simpleChinese: '不住院的诊察服务。', translation: 'Khám ngoại trú.', englishDefinition: 'outpatient clinic', symbol: '🏥'),
  WordEntry(word: '石阶', pinyin: 'shíjiē', partOfSpeech: '名词', simpleChinese: '石头做成的台阶。', translation: 'Bậc đá.', englishDefinition: 'stone steps', symbol: '🪨'),
  WordEntry(word: '手肘', pinyin: 'shǒuzhǒu', partOfSpeech: '名词', simpleChinese: '手臂中间弯曲的关节。', translation: 'Khuỷu tay.', englishDefinition: 'elbow', symbol: '💪'),
  WordEntry(word: '下意识', pinyin: 'xiàyìshí', partOfSpeech: '副词', simpleChinese: '没有先思考就自然做出。', translation: 'Theo phản xạ.', englishDefinition: 'instinctively', symbol: '⚡'),
  WordEntry(word: '公交车', pinyin: 'gōngjiāochē', partOfSpeech: '名词', simpleChinese: '按固定路线载客的公共汽车。', translation: 'Xe buýt.', englishDefinition: 'public bus', symbol: '🚌'),
];

const hangzhouDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '西湖文化景观包括湖面、三面环湖的山地，以及堤、岛、桥、塔和园林等人工元素。', pinyin: 'Xīhú Wénhuà Jǐngguān bāokuò húmiàn, sānmiàn huánhú de shāndì, yǐjí dī, dǎo, qiáo, tǎ hé yuánlín děng réngōng yuánsù.', simpleChinese: '西湖由自然山水和许多人造景观共同组成。', vietnamese: 'Cảnh quan văn hóa Tây Hồ gồm mặt hồ, núi bao quanh ba phía cùng đê, đảo, cầu, tháp và vườn.', english: 'The cultural landscape combines the lake and surrounding hills with causeways, islands, bridges, pagodas, and gardens.'),
  DiscoveryEntry(text: '西湖从九世纪以来持续影响诗歌、绘画和园林设计。', pinyin: 'Xīhú cóng jiǔ shìjì yǐlái chíxù yǐngxiǎng shīgē, huìhuà hé yuánlín shèjì.', simpleChinese: '西湖长期影响文学、艺术和园林。', vietnamese: 'Từ thế kỷ 9, Tây Hồ liên tục ảnh hưởng đến thơ ca, hội họa và thiết kế vườn.', english: 'Since the ninth century, West Lake has influenced poetry, painting, and garden design.'),
  DiscoveryEntry(text: '苏堤、白堤和湖中岛屿体现了人们通过治理湖水来创造景观的传统。', pinyin: 'Sūdī, Báidī hé húzhōng dǎoyǔ tǐxiàn le rénmen tōngguò zhìlǐ húshuǐ lái chuàngzào jǐngguān de chuántǒng.', simpleChinese: '堤和岛说明人们长期参与塑造西湖。', vietnamese: 'Các con đê và đảo cho thấy truyền thống con người cải tạo hồ để tạo cảnh quan.', english: 'Causeways and islands show a tradition of shaping the lake to create scenery.'),
  DiscoveryEntry(text: '西湖在二〇一一年被列入世界遗产名录。', pinyin: 'Xīhú zài èr líng yī yī nián bèi lièrù Shìjiè Yíchǎn Mínglù.', simpleChinese: '西湖文化景观是世界文化遗产。', vietnamese: 'Cảnh quan văn hóa Tây Hồ được ghi danh Di sản Thế giới năm 2011.', english: 'The West Lake Cultural Landscape was inscribed on the World Heritage List in 2011.'),
];

final chengduStoryParagraphs = chengduKuanzhaiOnePassLevels[4].storyParagraphs;
final chengduStoryAnnotations = chengduKuanzhaiOnePassLevels[4].storyAnnotations;
final chengduDiscoveries = chengduKuanzhaiOnePassDiscoveries;
final chengduWords = List<WordEntry>.unmodifiable(
  chengduKuanzhaiOnePassWords.where((entry) {
    final context = <String>[
      ...chengduStoryParagraphs,
      ...chengduDiscoveries.map((discovery) => discovery.text),
    ].join();
    return context.contains(entry.word);
  }),
);

const nanjingStoryParagraphs = <String>[
  '夜色降临，你沿着秦淮河走向夫子庙。水面映着灯光，石桥、牌坊和街巷把河岸连接成一条缓慢展开的历史线。',
  '夫子庙是这片风光带的核心，附近还有江南贡院、古桥和传统街区。教育、考试、商业和民俗曾在这里彼此交织。',
  '河边不只有古建筑。灯会、小吃、曲艺和手工艺，让历史文化继续进入今天的节日和日常生活。',
  '当你看见游船从桥下经过，会明白秦淮河保存的不是一个静止的旧南京，而是一种仍然会发光、会说话的城市记忆。',
];

const nanjingStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Yèsè jiànglín, nǐ yánzhe Qínhuái Hé zǒuxiàng Fūzǐmiào. Shuǐmiàn yìngzhe dēngguāng, shíqiáo, páifāng hé jiēxiàng bǎ hé àn liánjiē chéng yì tiáo huǎnmàn zhǎnkāi de lìshǐ xiàn.', vietnamese: 'Khi đêm xuống, bạn đi dọc sông Tần Hoài về phía Phu Tử Miếu. Ánh đèn phản chiếu trên nước, còn cầu đá, cổng bài và ngõ phố nối bờ sông thành một tuyến lịch sử.', english: 'At night, lights on the Qinhuai River connect stone bridges, ceremonial gates, and lanes into a slowly unfolding line of history.'),
  ReadingAnnotation(pinyin: 'Fūzǐmiào shì zhè piàn fēngguāngdài de héxīn, fùjìn hái yǒu Jiāngnán Gòngyuàn, gǔqiáo hé chuántǒng jiēqū. Jiàoyù, kǎoshì, shāngyè hé mínsú céng zài zhèlǐ bǐcǐ jiāozhī.', vietnamese: 'Phu Tử Miếu là trung tâm của khu thắng cảnh; gần đó có Giang Nam Cống Viện, cầu cổ và phố truyền thống. Giáo dục, thi cử, thương mại và dân tục từng đan xen tại đây.', english: 'The Confucius Temple area links education, examinations, commerce, folk culture, historic bridges, and traditional streets.'),
  ReadingAnnotation(pinyin: 'Hébiān bù zhǐ yǒu gǔ jiànzhù. Dēnghuì, xiǎochī, qǔyì hé shǒugōngyì, ràng lìshǐ wénhuà jìxù jìnrù jīntiān de jiérì hé rìcháng shēnghuó.', vietnamese: 'Bên sông không chỉ có kiến trúc cổ. Hội đèn, món ăn, nghệ thuật dân gian và thủ công đưa văn hóa lịch sử vào lễ hội và đời sống hôm nay.', english: 'Lantern festivals, food, folk performance, and crafts carry history into contemporary festivals and daily life.'),
  ReadingAnnotation(pinyin: 'Dāng nǐ kànjiàn yóuchuán cóng qiáoxià jīngguò, huì míngbai Qínhuái Hé bǎocún de bú shì yí gè jìngzhǐ de jiù Nánjīng, ér shì yì zhǒng réngrán huì fāguāng, huì shuōhuà de chéngshì jìyì.', vietnamese: 'Khi thuyền đi qua dưới cầu, bạn hiểu rằng sông Tần Hoài không lưu giữ một Nam Kinh cũ bất động, mà là ký ức đô thị vẫn phát sáng và kể chuyện.', english: 'The river preserves not a frozen old Nanjing, but an urban memory that still shines and speaks.'),
];

const nanjingWords = <WordEntry>[
  WordEntry(word: '秦淮河', pinyin: 'Qínhuái Hé', partOfSpeech: '名词（专名）', simpleChinese: '流经南京历史城区的重要河流。', translation: 'Sông Tần Hoài chảy qua khu lịch sử Nam Kinh.', englishDefinition: 'the Qinhuai River', symbol: '🛶'),
  WordEntry(word: '夫子庙', pinyin: 'Fūzǐmiào', partOfSpeech: '名词（专名）', simpleChinese: '南京著名的孔庙和历史文化区域。', translation: 'Phu Tử Miếu, khu văn hóa lịch sử nổi tiếng.', englishDefinition: 'Nanjing Confucius Temple', symbol: '🏛️'),
  WordEntry(word: '牌坊', pinyin: 'páifāng', partOfSpeech: '名词', simpleChinese: '有纪念或标志作用的传统门式建筑。', translation: 'Cổng bài truyền thống mang ý nghĩa biểu tượng.', englishDefinition: 'ceremonial archway', symbol: '⛩️'),
  WordEntry(word: '贡院', pinyin: 'gòngyuàn', partOfSpeech: '名词', simpleChinese: '古代举行科举考试的场所。', translation: 'Nơi tổ chức khoa cử thời xưa.', englishDefinition: 'imperial examination compound', symbol: '📝'),
  WordEntry(word: '交织', pinyin: 'jiāozhī', partOfSpeech: '动词', simpleChinese: '不同事物互相连接在一起。', translation: 'Đan xen, kết nối với nhau.', englishDefinition: 'to interweave', symbol: '🧶'),
  WordEntry(word: '灯会', pinyin: 'dēnghuì', partOfSpeech: '名词', simpleChinese: '集中展示花灯的节庆活动。', translation: 'Lễ hội đèn lồng.', englishDefinition: 'lantern festival', symbol: '🏮'),
  WordEntry(word: '曲艺', pinyin: 'qǔyì', partOfSpeech: '名词', simpleChinese: '说唱、评书等传统表演艺术。', translation: 'Nghệ thuật kể chuyện và hát nói truyền thống.', englishDefinition: 'Chinese folk performance arts', symbol: '🎭'),
  WordEntry(word: '游船', pinyin: 'yóuchuán', partOfSpeech: '名词', simpleChinese: '供游客乘坐游览的船。', translation: 'Thuyền du lịch.', englishDefinition: 'sightseeing boat', symbol: '⛵'),
  WordEntry(word: '静止', pinyin: 'jìngzhǐ', partOfSpeech: '形容词', simpleChinese: '停止不动。', translation: 'Đứng yên, không chuyển động.', englishDefinition: 'still or motionless', symbol: '⏸️'),
];

const nanjingDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '夫子庙秦淮风光带以夫子庙为核心，并以“十里秦淮”为重要轴线。', pinyin: 'Fūzǐmiào Qínhuái Fēngguāngdài yǐ Fūzǐmiào wéi héxīn, bìng yǐ “Shílǐ Qínhuái” wéi zhòngyào zhóuxiàn.', simpleChinese: '景区围绕夫子庙和秦淮河展开。', vietnamese: 'Khu thắng cảnh lấy Phu Tử Miếu làm trung tâm và sông Tần Hoài làm trục chính.', english: 'The scenic area is centred on the Confucius Temple and organised along the Qinhuai River.'),
  DiscoveryEntry(text: '景区重点保护秦淮河两岸风貌、历史街区、古桥、牌坊和文物建筑。', pinyin: 'Jǐngqū zhòngdiǎn bǎohù Qínhuái Hé liǎng àn fēngmào, lìshǐ jiēqū, gǔqiáo, páifāng hé wénwù jiànzhù.', simpleChinese: '河岸、老街、古桥和历史建筑都属于保护对象。', vietnamese: 'Cảnh quan hai bờ sông, phố cổ, cầu cổ, cổng bài và công trình di sản đều được bảo vệ.', english: 'Protection covers the riverbanks, historic districts, old bridges, archways, and heritage buildings.'),
  DiscoveryEntry(text: '江南贡院记录了古代科举考试与城市教育文化。', pinyin: 'Jiāngnán Gòngyuàn jìlù le gǔdài kējǔ kǎoshì yǔ chéngshì jiàoyù wénhuà.', simpleChinese: '江南贡院与古代考试制度有关。', vietnamese: 'Giang Nam Cống Viện ghi dấu hệ thống khoa cử và văn hóa giáo dục đô thị.', english: 'Jiangnan Examination Hall records the history of imperial examinations and education.'),
  DiscoveryEntry(text: '秦淮灯会、南京剪纸和传统小吃等非物质文化遗产仍在景区中传承。', pinyin: 'Qínhuái Dēnghuì, Nánjīng jiǎnzhǐ hé chuántǒng xiǎochī děng fēiwùzhì wénhuà yíchǎn réng zài jǐngqū zhōng chuánchéng.', simpleChinese: '灯会、剪纸和小吃等传统文化继续被传承。', vietnamese: 'Hội đèn Tần Hoài, cắt giấy Nam Kinh và ẩm thực truyền thống vẫn được lưu truyền.', english: 'Lantern traditions, paper-cutting, and local food crafts continue as living heritage.'),
];

final guangzhouStoryParagraphs = guangzhouChenClanOnePassLevels[4].storyParagraphs;
final guangzhouStoryAnnotations = guangzhouChenClanOnePassLevels[4].storyAnnotations;
final guangzhouWords = guangzhouChenClanOnePassLevelContent(5).words;
final guangzhouDiscoveries = guangzhouChenClanOnePassDiscoveries;

final hangzhouWestLakeJourney = _buildJourney(
  id: 'hangzhou-west-lake',
  title: '杭州 · 西湖：还认得这条路',
  geoNodeId: 'cn-zhejiang-hangzhou-west-lake',
  tags: const ['杭州', '西湖', '断桥', '夫妻', '记忆'],
  paragraphs: hangzhouStoryParagraphs,
  sourceIds: const ['unesco-hangzhou-west-lake'],
);

final chengduKuanzhaiJourney = _buildJourney(
  id: 'chengdu-kuanzhai-alley',
  title: '成都 · 宽窄巷子：仍在使用',
  geoNodeId: 'cn-sichuan-chengdu-kuanzhai',
  tags: const ['成都', '宽窄巷子', '使用痕迹', '院落', '保护更新'],
  paragraphs: chengduStoryParagraphs,
  sourceIds: const ['chengdu-gov-kuanzhai-alley'],
);

final nanjingQinhuaiJourney = _buildJourney(
  id: 'nanjing-qinhuai-river',
  title: '南京 · 秦淮河：一条仍会发光的城市记忆',
  geoNodeId: 'cn-jiangsu-nanjing-qinhuai',
  tags: const ['南京', '秦淮河', '夫子庙', '灯会', '科举'],
  paragraphs: nanjingStoryParagraphs,
  sourceIds: const ['nanjing-gov-fuzimiao-qinhuai'],
);

final guangzhouChenClanJourney = _buildJourney(
  id: guangzhouChenClanJourneyId,
  title: '广州 · 陈家祠：不入镜',
  geoNodeId: 'cn-guangdong-guangzhou-chen-clan',
  tags: const ['广州', '陈家祠', '陈氏书院', '宗族', '名字', '边界'],
  paragraphs: guangzhouStoryParagraphs,
  sourceIds: const [guangzhouChenClanSourceRecordId],
);

final extendedJourneyRecords = <JourneyContentRecord>[
  hangzhouWestLakeJourney,
  chengduKuanzhaiJourney,
  nanjingQinhuaiJourney,
  guangzhouChenClanJourney,
  kaipingDiaolouJourney,
];

final extendedJourneyExperiences = LazyJourneyList(<DailyJourneyExperienceBuilder>[
  () => DailyJourneyExperience(
    id: hangzhouWestLakeJourney.id,
    city: '杭州',
    cityCode: 'HGH',
    place: '西湖',
    appBarTitle: '杭州 · 西湖',
    storyTitle: '还认得这条路',
    headline: '方毓把一次西湖散步变成了不敢说破的记忆测试',
    description: '结婚四十三年后，方毓带周绍庭重走断桥；湿石阶上的一个旧动作，让两个人终于拿出藏着的医院预约。',
    discoveryTeaser: '“断桥残雪”这类题名景观，怎样把地点、季节与观看条件连在一起？',
    distanceLabel: '1,760 km',
    stampSymbol: '湖',
    content: hangzhouWestLakeJourney,
    storyAnnotations: hangzhouStoryAnnotations,
    words: hangzhouWords,
    discoveries: hangzhouDiscoveries,
    wonderQuestion: '方毓为什么在周绍庭扶住她以后停止用西湖景名测试他？',
    expressQuestion: '请按顺序写出方毓隐瞒预约卡、不断出题、湿石阶被扶住和公开交卡四件事。',
  ),
  () => DailyJourneyExperience(
    id: chengduKuanzhaiJourney.id,
    city: '成都',
    cityCode: 'CTU',
    place: '宽窄巷子',
    appBarTitle: '成都 · 宽窄巷子',
    storyTitle: '一把没有固定位置的竹椅',
    headline: '林夏要让停留与通行都在院落里有位置',
    description: '一把竹椅在茶桌、墙边与门槛之间反复让位；当周叔自己把它移开，共享节奏不再只靠林夏维持。',
    discoveryTeaser: '为什么这里既是古街，也是现代生活空间？',
    distanceLabel: '1,020 km',
    stampSymbol: '巷',
    content: chengduKuanzhaiJourney,
    storyAnnotations: chengduStoryAnnotations,
    words: chengduWords,
    discoveries: chengduDiscoveries,
    wonderQuestion: '为什么这把竹椅没有固定位置，反而让院落更容易同时服务停留与通行？',
    expressQuestion: '周叔在没有提醒时主动移椅，怎样证明共享节奏已经不只属于林夏？',
  ),
  () => DailyJourneyExperience(
    id: nanjingQinhuaiJourney.id,
    city: '南京',
    cityCode: 'NKG',
    place: '秦淮河',
    appBarTitle: '南京 · 秦淮河',
    storyTitle: '亮灯以后留下的暗段',
    headline: '七分钟里，魏舟必须决定什么不能抢着修好',
    description: '秦淮灯会开场前发生故障，魏舟拒绝未经确认的临时改线，让主要路线安全亮起，也让一段装饰灯继续黑着。',
    discoveryTeaser: '秦淮河岸、古桥与灯会照明为什么同时受到风貌保护和安全管理约束？',
    distanceLabel: '1,860 km',
    stampSymbol: '淮',
    content: nanjingQinhuaiJourney,
    storyAnnotations: nanjingStoryAnnotations,
    words: nanjingWords,
    discoveries: nanjingDiscoveries,
    wonderQuestion: '为什么魏舟宁可让一段装饰灯继续黑着，也不在最后几分钟改变已经确认的照明安排？',
    expressQuestion: '请用两到三句话说明魏舟做了什么取舍，以及周工最后怎样把责任交给他。',
  ),
  () => DailyJourneyExperience(
    id: guangzhouChenClanJourney.id,
    city: '广州',
    cityCode: 'CAN',
    place: '陈家祠',
    appBarTitle: '广州 · 陈家祠',
    storyTitle: '不入镜',
    headline: '一张迟到三十四年的合照，要不要拍',
    description: '陈秀仪第一次单独见到如今叫刘嘉禾的亲生女儿；亲戚的视频打来后，她必须决定这次见面属于谁。',
    discoveryTeaser: '为什么“陈氏书院”由广东各地陈姓宗族共同兴建，又同时具有合族祠与书院功能？',
    distanceLabel: '820 km',
    stampSymbol: '艺',
    content: guangzhouChenClanJourney,
    storyAnnotations: guangzhouStoryAnnotations,
    words: guangzhouWords,
    discoveries: guangzhouDiscoveries,
    wonderQuestion: guangzhouChenClanReflectionPrompts[4],
    expressQuestion: guangzhouChenClanWritingPrompts[4],
  ),
  () => kaipingDiaolouExperience,
]);
