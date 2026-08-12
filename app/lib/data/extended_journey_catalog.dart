import '../models/story_content.dart';
import 'chengdu_kuanzhai_one_pass.dart';
import 'daily_journey_experience.dart';
import 'guangzhou_chen_clan_one_pass.dart';
import 'journey_data.dart';

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
  '清晨，你沿着苏堤慢慢向前走。湖面像一张安静的镜子，远处的山、桥和柳树倒映在水中。',
  '西湖不是完全自然形成的风景。历代人们修筑堤岸、疏浚湖水，又建起亭台、宝塔和园林，让自然与人的设计彼此融合。',
  '从唐宋以来，诗人、画家和学者不断描写这里。许多景点因此不仅有形状，也有名字、故事和情感。',
  '站在湖边，你会发现西湖真正特别的地方，是人们没有把自然变成背景，而是让城市生活与山水一起呼吸。',
];

const hangzhouStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'Qīngchén, nǐ yánzhe Sūdī mànmàn xiàng qián zǒu. Húmiàn xiàng yì zhāng ānjìng de jìngzi, yuǎnchù de shān, qiáo hé liǔshù dàoyìng zài shuǐ zhōng.',
    vietnamese:
        'Sáng sớm, bạn chậm rãi đi dọc đê Tô. Mặt hồ như một tấm gương yên tĩnh, phản chiếu núi, cầu và hàng liễu phía xa.',
    english:
        'At dawn, you walk slowly along Su Causeway. The lake is a quiet mirror reflecting distant hills, bridges, and willows.',
  ),
  ReadingAnnotation(
    pinyin:
        'Xīhú bú shì wánquán zìrán xíngchéng de fēngjǐng. Lìdài rénmen xiūzhù dī àn, shūjùn húshuǐ, yòu jiànqǐ tíngtái, bǎotǎ hé yuánlín, ràng zìrán yǔ rén de shèjì bǐcǐ rónghé.',
    vietnamese:
        'Tây Hồ không phải là cảnh quan hoàn toàn tự nhiên. Qua nhiều triều đại, con người xây đê, nạo vét hồ và dựng đình, tháp, vườn để kết hợp thiên nhiên với thiết kế của con người.',
    english:
        'West Lake is not a wholly natural landscape. Generations built causeways, dredged the lake, and added pavilions, pagodas, and gardens.',
  ),
  ReadingAnnotation(
    pinyin:
        'Cóng Táng Sòng yǐlái, shīrén, huàjiā hé xuézhě bùduàn miáoxiě zhèlǐ. Xǔduō jǐngdiǎn yīncǐ bùjǐn yǒu xíngzhuàng, yě yǒu míngzi, gùshì hé qínggǎn.',
    vietnamese:
        'Từ thời Đường Tống, thi nhân, họa sĩ và học giả liên tục miêu tả nơi đây. Vì vậy nhiều thắng cảnh không chỉ có hình dáng mà còn có tên gọi, câu chuyện và cảm xúc.',
    english:
        'Since the Tang and Song periods, poets, painters, and scholars have given the scenery names, stories, and emotion.',
  ),
  ReadingAnnotation(
    pinyin:
        'Zhàn zài húbiān, nǐ huì fāxiàn Xīhú zhēnzhèng tèbié de dìfang, shì rénmen méiyǒu bǎ zìrán biàn chéng bèijǐng, ér shì ràng chéngshì shēnghuó yǔ shānshuǐ yìqǐ hūxī.',
    vietnamese:
        'Đứng bên hồ, bạn nhận ra điều đặc biệt của Tây Hồ là con người không biến thiên nhiên thành phông nền, mà để đời sống đô thị cùng hít thở với núi nước.',
    english:
        'West Lake is special because nature is not merely a backdrop; city life and landscape breathe together.',
  ),
];

const hangzhouWords = <WordEntry>[
  WordEntry(word: '苏堤', pinyin: 'Sūdī', partOfSpeech: '名词（专名）', simpleChinese: '横跨西湖的重要堤道。', translation: 'Đê Tô, con đê nổi tiếng trên Tây Hồ.', englishDefinition: 'Su Causeway', symbol: '🌉'),
  WordEntry(word: '倒映', pinyin: 'dàoyìng', partOfSpeech: '动词', simpleChinese: '物体的影子映在水面或镜面上。', translation: 'Phản chiếu trên mặt nước hoặc gương.', englishDefinition: 'to be reflected', symbol: '🪞'),
  WordEntry(word: '堤岸', pinyin: 'dī’àn', partOfSpeech: '名词', simpleChinese: '防止水流漫出的岸边建筑。', translation: 'Bờ đê ngăn nước tràn.', englishDefinition: 'embankment', symbol: '🧱'),
  WordEntry(word: '疏浚', pinyin: 'shūjùn', partOfSpeech: '动词', simpleChinese: '清理河湖底部，让水道更通畅。', translation: 'Nạo vét để dòng nước thông thoáng.', englishDefinition: 'to dredge', symbol: '⛏️'),
  WordEntry(word: '亭台', pinyin: 'tíngtái', partOfSpeech: '名词', simpleChinese: '园林中的亭子和台阁。', translation: 'Đình và lầu trong vườn cảnh.', englishDefinition: 'pavilions and terraces', symbol: '🏯'),
  WordEntry(word: '融合', pinyin: 'rónghé', partOfSpeech: '动词', simpleChinese: '不同事物结合在一起。', translation: 'Hòa hợp hoặc kết hợp với nhau.', englishDefinition: 'to blend or integrate', symbol: '🫶'),
  WordEntry(word: '景点', pinyin: 'jǐngdiǎn', partOfSpeech: '名词', simpleChinese: '值得参观的风景或地点。', translation: 'Điểm tham quan.', englishDefinition: 'scenic spot', symbol: '📍'),
  WordEntry(word: '山水', pinyin: 'shānshuǐ', partOfSpeech: '名词', simpleChinese: '山和水组成的自然景色。', translation: 'Phong cảnh núi non và sông nước.', englishDefinition: 'mountains-and-water landscape', symbol: '🏞️'),
  WordEntry(word: '彼此', pinyin: 'bǐcǐ', partOfSpeech: '代词', simpleChinese: '双方互相。', translation: 'Lẫn nhau, đôi bên.', englishDefinition: 'each other', symbol: '↔️'),
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
  title: '杭州 · 西湖：让城市与山水一起呼吸',
  geoNodeId: 'cn-zhejiang-hangzhou-west-lake',
  tags: const ['杭州', '西湖', '世界遗产', '园林', '山水'],
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
];

final extendedJourneyExperiences = <DailyJourneyExperience>[
  DailyJourneyExperience(
    id: hangzhouWestLakeJourney.id,
    city: '杭州',
    cityCode: 'HGH',
    place: '西湖',
    appBarTitle: '杭州 · 西湖',
    storyTitle: '雨落进录音以后',
    headline: '许澄要决定哪些声音才算真正的西湖',
    description: '许澄沿苏堤寻找没有人声的“纯净”录音；阵雨到来时，她把人、水与天气留在同一条声轨里。',
    discoveryTeaser: '苏堤、桥、水面与长期人工营造怎样共同形成西湖的文化景观声场？',
    distanceLabel: '1,760 km',
    stampSymbol: '湖',
    content: hangzhouWestLakeJourney,
    storyAnnotations: hangzhouStoryAnnotations,
    words: hangzhouWords,
    discoveries: hangzhouDiscoveries,
    wonderQuestion: '许澄为什么在桥边开始怀疑“越安静越真实”的录音标准？',
    expressQuestion: '第一滴雨到来后，堤上、桥下和水面的声音怎样共同改变了许澄记录西湖的方式？',
  ),
  DailyJourneyExperience(
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
  DailyJourneyExperience(
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
  DailyJourneyExperience(
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
];
