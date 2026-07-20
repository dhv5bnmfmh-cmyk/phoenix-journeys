import '../models/story_content.dart';
import 'daily_journey_experience.dart';
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
    id: 'guangzhou-gov-chen-clan-academy',
    title: '广东民间工艺博物馆',
    publisher: '广州市人民政府',
    url:
        'https://www.gz.gov.cn/zlgz/gzly/wzgz/wbcg/content/mpost_9587900.html',
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

const chengduStoryParagraphs = <String>[
  '午后，你走进成都宽窄巷子。青砖墙、木门和一座座院落，把城市的声音慢慢放低。',
  '这里由宽巷子、窄巷子和井巷子组成。三条平行街巷保留了清代街区的空间，也装进了今天的茶馆、餐厅和小店。',
  '你在院门前停下，听见盖碗茶的杯盖轻轻碰响。老建筑没有停止使用，而是在新的生活方式里继续存在。',
  '宽窄巷子的意义，也许不只是“看古街”，而是观察一座城市怎样把慢生活、商业与历史放在同一个院子里。',
];

const chengduStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Wǔhòu, nǐ zǒujìn Chéngdū Kuānzhǎi Xiàngzi. Qīngzhuān qiáng, mùmén hé yí zuò zuò yuànluò, bǎ chéngshì de shēngyīn mànmàn fàng dī.', vietnamese: 'Buổi chiều, bạn bước vào ngõ Rộng Hẹp ở Thành Đô. Tường gạch xanh, cửa gỗ và những sân nhà khiến âm thanh thành phố dần dịu xuống.', english: 'In the afternoon, you enter Chengdu’s Kuanzhai Alley, where grey-brick walls, wooden doors, and courtyards soften the city’s noise.'),
  ReadingAnnotation(pinyin: 'Zhèlǐ yóu Kuān Xiàngzi, Zhǎi Xiàngzi hé Jǐng Xiàngzi zǔchéng. Sān tiáo píngxíng jiēxiàng bǎoliú le Qīngdài jiēqū de kōngjiān, yě zhuāngjìn le jīntiān de cháguǎn, cāntīng hé xiǎodiàn.', vietnamese: 'Nơi đây gồm ngõ Rộng, ngõ Hẹp và ngõ Giếng. Ba con ngõ song song giữ cấu trúc khu phố thời Thanh và chứa những quán trà, nhà hàng, cửa tiệm hôm nay.', english: 'Three parallel lanes preserve a Qing-era urban pattern while hosting today’s teahouses, restaurants, and shops.'),
  ReadingAnnotation(pinyin: 'Nǐ zài yuànmén qián tíngxià, tīngjiàn gàiwǎnchá de bēigài qīngqīng pèngxiǎng. Lǎo jiànzhù méiyǒu tíngzhǐ shǐyòng, ér shì zài xīn de shēnghuó fāngshì lǐ jìxù cúnzài.', vietnamese: 'Bạn dừng trước cổng sân và nghe nắp chén trà khẽ chạm. Các công trình cũ không ngừng được sử dụng mà tiếp tục sống trong lối sống mới.', english: 'The old buildings remain in use, continuing their lives through contemporary ways of living.'),
  ReadingAnnotation(pinyin: 'Kuānzhǎi Xiàngzi de yìyì, yěxǔ bù zhǐ shì “kàn gǔjiē”, ér shì guānchá yí zuò chéngshì zěnyàng bǎ màn shēnghuó, shāngyè yǔ lìshǐ fàng zài tóng yí gè yuànzi lǐ.', vietnamese: 'Ý nghĩa của ngõ Rộng Hẹp không chỉ là ngắm phố cổ, mà còn là quan sát cách một thành phố đặt nhịp sống chậm, thương mại và lịch sử trong cùng một khoảng sân.', english: 'Kuanzhai Alley shows how slow living, commerce, and history can occupy the same courtyard.'),
];

const chengduWords = <WordEntry>[
  WordEntry(word: '巷子', pinyin: 'xiàngzi', partOfSpeech: '名词', simpleChinese: '城市里比较窄的小路。', translation: 'Ngõ hoặc hẻm nhỏ trong thành phố.', englishDefinition: 'alley or lane', symbol: '🛤️'),
  WordEntry(word: '青砖', pinyin: 'qīngzhuān', partOfSpeech: '名词', simpleChinese: '颜色偏灰青的传统砖。', translation: 'Gạch xanh xám truyền thống.', englishDefinition: 'grey-blue brick', symbol: '🧱'),
  WordEntry(word: '院落', pinyin: 'yuànluò', partOfSpeech: '名词', simpleChinese: '由房屋围成的院子和建筑。', translation: 'Khu nhà và sân được bao quanh.', englishDefinition: 'courtyard compound', symbol: '🏡'),
  WordEntry(word: '平行', pinyin: 'píngxíng', partOfSpeech: '形容词', simpleChinese: '方向相同而不相交。', translation: 'Song song, cùng hướng không giao nhau.', englishDefinition: 'parallel', symbol: '〰️'),
  WordEntry(word: '茶馆', pinyin: 'cháguǎn', partOfSpeech: '名词', simpleChinese: '喝茶、休息和聊天的地方。', translation: 'Quán trà để uống trà và trò chuyện.', englishDefinition: 'teahouse', symbol: '🍵'),
  WordEntry(word: '盖碗茶', pinyin: 'gàiwǎnchá', partOfSpeech: '名词', simpleChinese: '用带盖茶碗冲泡和饮用的茶。', translation: 'Trà pha trong chén có nắp.', englishDefinition: 'tea served in a lidded bowl', symbol: '🫖'),
  WordEntry(word: '保留', pinyin: 'bǎoliú', partOfSpeech: '动词', simpleChinese: '留下来，不让它消失。', translation: 'Giữ lại, bảo tồn.', englishDefinition: 'to preserve or retain', symbol: '📦'),
  WordEntry(word: '慢生活', pinyin: 'màn shēnghuó', partOfSpeech: '名词', simpleChinese: '节奏比较放松的生活方式。', translation: 'Lối sống chậm và thư thái.', englishDefinition: 'slow-paced lifestyle', symbol: '🐢'),
  WordEntry(word: '商业', pinyin: 'shāngyè', partOfSpeech: '名词', simpleChinese: '买卖商品和服务的活动。', translation: 'Hoạt động kinh doanh và thương mại.', englishDefinition: 'commerce', symbol: '🏪'),
];

const chengduDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '宽窄巷子由宽巷子、窄巷子和井巷子三条平行街巷组成。', pinyin: 'Kuānzhǎi Xiàngzi yóu Kuān Xiàngzi, Zhǎi Xiàngzi hé Jǐng Xiàngzi sān tiáo píngxíng jiēxiàng zǔchéng.', simpleChinese: '这个街区有三条主要巷子。', vietnamese: 'Khu phố gồm ba con ngõ song song: ngõ Rộng, ngõ Hẹp và ngõ Giếng.', english: 'The district consists of three parallel lanes: Wide, Narrow, and Well Alley.'),
  DiscoveryEntry(text: '街区保存了较多清代院落和老成都的城市空间。', pinyin: 'Jiēqū bǎocún le jiàoduō Qīngdài yuànluò hé lǎo Chéngdū de chéngshì kōngjiān.', simpleChinese: '这里还能看到清代院落和旧城市格局。', vietnamese: 'Khu phố còn giữ nhiều sân nhà thời Thanh và cấu trúc đô thị Thành Đô xưa.', english: 'The area preserves Qing-era courtyards and traces of old Chengdu’s urban form.'),
  DiscoveryEntry(text: '今天的宽窄巷子把历史建筑与餐饮、茶文化和休闲活动结合起来。', pinyin: 'Jīntiān de Kuānzhǎi Xiàngzi bǎ lìshǐ jiànzhù yǔ cānyǐn, chá wénhuà hé xiūxián huódòng jiéhé qǐlái.', simpleChinese: '老建筑里也有今天的茶馆、餐厅和休闲空间。', vietnamese: 'Ngày nay, công trình lịch sử kết hợp với ẩm thực, văn hóa trà và hoạt động thư giãn.', english: 'Historic buildings now accommodate food, tea culture, and leisure activities.'),
  DiscoveryEntry(text: '街巷的更新说明历史保护也需要考虑居民生活和现代使用。', pinyin: 'Jiēxiàng de gēngxīn shuōmíng lìshǐ bǎohù yě xūyào kǎolǜ jūmín shēnghuó hé xiàndài shǐyòng.', simpleChinese: '保护老街时，也要考虑今天怎样使用它。', vietnamese: 'Việc cải tạo cho thấy bảo tồn lịch sử cũng phải tính đến đời sống và cách sử dụng hiện đại.', english: 'The renewal shows that heritage protection must also consider contemporary use.'),
];

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

const guangzhouStoryParagraphs = <String>[
  '走进广州陈家祠，你最先注意到的也许不是大厅，而是屋脊、门窗和墙面上密密层层的装饰。',
  '木雕、砖雕、石雕、陶塑和灰塑同时出现在建筑上。人物、花鸟和故事被工匠放进梁架、屋顶与墙壁。',
  '这座晚清建筑曾与广东各地陈姓宗族和读书人有关，后来成为广东民间工艺博物馆。',
  '陈家祠像一本不能快速翻完的立体图书。你越靠近细节，越能看见岭南工艺怎样把建筑变成文化记忆。',
];

const guangzhouStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'Zǒujìn Guǎngzhōu Chénjiācí, nǐ zuìxiān zhùyì dào de yěxǔ bú shì dàtīng, ér shì wūjǐ, ménchuāng hé qiángmiàn shàng mìmì céngcéng de zhuāngshì.', vietnamese: 'Bước vào Trần Gia Từ ở Quảng Châu, điều bạn chú ý đầu tiên có lẽ không phải đại sảnh mà là lớp trang trí dày đặc trên nóc, cửa và tường.', english: 'At Chen Clan Ancestral Hall, the first thing you notice may be the dense decoration on roof ridges, doors, windows, and walls.'),
  ReadingAnnotation(pinyin: 'Mùdiāo, zhuāndiāo, shídiāo, táosù hé huīsù tóngshí chūxiàn zài jiànzhù shàng. Rénwù, huāniǎo hé gùshì bèi gōngjiàng fàngjìn liángjià, wūdǐng yǔ qiángbì.', vietnamese: 'Chạm gỗ, chạm gạch, chạm đá, tượng gốm và phù điêu vữa cùng xuất hiện trên kiến trúc; nhân vật, hoa chim và câu chuyện được đặt lên khung, mái và tường.', english: 'Wood, brick, and stone carving, ceramic sculpture, and lime sculpture fill the structure with figures, flowers, birds, and stories.'),
  ReadingAnnotation(pinyin: 'Zhè zuò Wǎnqīng jiànzhù céng yǔ Guǎngdōng gèdì Chén xìng zōngzú hé dúshūrén yǒuguān, hòulái chéngwéi Guǎngdōng Mínjiān Gōngyì Bówùguǎn.', vietnamese: 'Công trình cuối thời Thanh này từng gắn với các dòng họ Trần và người đi học từ nhiều nơi ở Quảng Đông, sau trở thành Bảo tàng Mỹ thuật Dân gian Quảng Đông.', english: 'The late-Qing complex served Chen clans and students from across Guangdong and later became the Guangdong Folk Arts Museum.'),
  ReadingAnnotation(pinyin: 'Chénjiācí xiàng yì běn bùnéng kuàisù fānwán de lìtǐ túshū. Nǐ yuè kàojìn xìjié, yuè néng kànjiàn Lǐngnán gōngyì zěnyàng bǎ jiànzhù biàn chéng wénhuà jìyì.', vietnamese: 'Trần Gia Từ giống một cuốn sách ba chiều không thể lật nhanh. Càng đến gần chi tiết, bạn càng thấy nghệ thuật Lĩnh Nam biến kiến trúc thành ký ức văn hóa.', english: 'The hall is a three-dimensional book: the closer you look, the more clearly Lingnan craft turns architecture into cultural memory.'),
];

const guangzhouWords = <WordEntry>[
  WordEntry(word: '陈家祠', pinyin: 'Chénjiācí', partOfSpeech: '名词（专名）', simpleChinese: '广州著名的祠堂式历史建筑。', translation: 'Trần Gia Từ, công trình từ đường nổi tiếng ở Quảng Châu.', englishDefinition: 'Chen Clan Ancestral Hall', symbol: '🏯'),
  WordEntry(word: '屋脊', pinyin: 'wūjǐ', partOfSpeech: '名词', simpleChinese: '屋顶最高的连接部分。', translation: 'Nóc mái, phần cao nhất của mái nhà.', englishDefinition: 'roof ridge', symbol: '🏠'),
  WordEntry(word: '木雕', pinyin: 'mùdiāo', partOfSpeech: '名词', simpleChinese: '在木头上雕刻图案的工艺。', translation: 'Nghệ thuật chạm khắc gỗ.', englishDefinition: 'wood carving', symbol: '🪵'),
  WordEntry(word: '砖雕', pinyin: 'zhuāndiāo', partOfSpeech: '名词', simpleChinese: '在砖上雕刻图案的工艺。', translation: 'Nghệ thuật chạm khắc gạch.', englishDefinition: 'brick carving', symbol: '🧱'),
  WordEntry(word: '陶塑', pinyin: 'táosù', partOfSpeech: '名词', simpleChinese: '用陶土制作立体装饰。', translation: 'Tượng trang trí bằng gốm.', englishDefinition: 'ceramic sculpture', symbol: '🏺'),
  WordEntry(word: '灰塑', pinyin: 'huīsù', partOfSpeech: '名词', simpleChinese: '用灰泥制作的传统建筑装饰。', translation: 'Phù điêu trang trí bằng vữa.', englishDefinition: 'lime or plaster sculpture', symbol: '🎨'),
  WordEntry(word: '工匠', pinyin: 'gōngjiàng', partOfSpeech: '名词', simpleChinese: '掌握手工技艺的专业劳动者。', translation: 'Thợ thủ công có kỹ năng chuyên môn.', englishDefinition: 'craftsperson or artisan', symbol: '🛠️'),
  WordEntry(word: '宗族', pinyin: 'zōngzú', partOfSpeech: '名词', simpleChinese: '有共同祖先的家族群体。', translation: 'Dòng họ có cùng tổ tiên.', englishDefinition: 'clan or lineage', symbol: '👨‍👩‍👧‍👦'),
  WordEntry(word: '岭南', pinyin: 'Lǐngnán', partOfSpeech: '名词（专名）', simpleChinese: '中国南岭以南的文化地理区域。', translation: 'Vùng văn hóa địa lý phía nam dãy Nam Lĩnh.', englishDefinition: 'Lingnan, the region south of the Nanling Mountains', symbol: '🌺'),
];

const guangzhouDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '陈家祠落成于清代晚期，原名陈氏书院。', pinyin: 'Chénjiācí luòchéng yú Qīngdài wǎnqī, yuánmíng Chénshì Shūyuàn.', simpleChinese: '陈家祠是晚清建筑，也叫陈氏书院。', vietnamese: 'Trần Gia Từ hoàn thành vào cuối thời Thanh và còn gọi là Trần Thị Thư Viện.', english: 'The complex was completed in the late Qing period and is also known as the Chen Clan Academy.'),
  DiscoveryEntry(text: '建筑集中展示木雕、砖雕、石雕、陶塑、灰塑、铸造和彩绘等岭南装饰工艺。', pinyin: 'Jiànzhù jízhōng zhǎnshì mùdiāo, zhuāndiāo, shídiāo, táosù, huīsù, zhùzào hé cǎihuì děng Lǐngnán zhuāngshì gōngyì.', simpleChinese: '这里能看到很多种岭南传统装饰工艺。', vietnamese: 'Kiến trúc tập trung nhiều kỹ thuật trang trí Lĩnh Nam như chạm gỗ, gạch, đá, gốm, vữa, đúc và vẽ màu.', english: 'The building brings together many Lingnan decorative crafts, including carving, ceramic and lime sculpture, casting, and painting.'),
  DiscoveryEntry(text: '陈家祠在一九八八年被公布为全国重点文物保护单位。', pinyin: 'Chénjiācí zài yī jiǔ bā bā nián bèi gōngbù wéi Quánguó Zhòngdiǎn Wénwù Bǎohù Dānwèi.', simpleChinese: '陈家祠是国家重点保护的文物建筑。', vietnamese: 'Năm 1988, Trần Gia Từ được công nhận là đơn vị bảo tồn di tích trọng điểm toàn quốc.', english: 'In 1988, the hall was designated a Major Historical and Cultural Site Protected at the National Level.'),
  DiscoveryEntry(text: '今天这里是广东民间工艺博物馆，收藏和展示多种广东传统工艺。', pinyin: 'Jīntiān zhèlǐ shì Guǎngdōng Mínjiān Gōngyì Bówùguǎn, shōucáng hé zhǎnshì duō zhǒng Guǎngdōng chuántǒng gōngyì.', simpleChinese: '现在这里是一座展示广东民间工艺的博物馆。', vietnamese: 'Ngày nay đây là Bảo tàng Mỹ thuật Dân gian Quảng Đông, sưu tầm và trưng bày nhiều nghề thủ công truyền thống.', english: 'Today it houses the Guangdong Folk Arts Museum and displays a wide range of traditional crafts.'),
];

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
  title: '成都 · 宽窄巷子：在院落里读懂慢生活',
  geoNodeId: 'cn-sichuan-chengdu-kuanzhai',
  tags: const ['成都', '宽窄巷子', '院落', '茶文化', '城市更新'],
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
  id: 'guangzhou-chen-clan-academy',
  title: '广州 · 陈家祠：把建筑读成一本工艺书',
  geoNodeId: 'cn-guangdong-guangzhou-chen-clan',
  tags: const ['广州', '陈家祠', '岭南', '民间工艺', '建筑装饰'],
  paragraphs: guangzhouStoryParagraphs,
  sourceIds: const ['guangzhou-gov-chen-clan-academy'],
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
    storyTitle: '西湖故事',
    headline: '让城市与山水一起呼吸',
    description: '沿苏堤阅读诗意景观、园林设计与人与自然的关系。',
    discoveryTeaser: '西湖为什么不仅是自然风景？',
    distanceLabel: '1,760 km',
    stampSymbol: '湖',
    content: hangzhouWestLakeJourney,
    storyAnnotations: hangzhouStoryAnnotations,
    words: hangzhouWords,
    discoveries: hangzhouDiscoveries,
    wonderQuestion: '如果你能为西湖的一处风景重新命名，你会选择什么名字？为什么？',
    expressQuestion: '请用两到三句话描写你想象中的西湖清晨。',
  ),
  DailyJourneyExperience(
    id: chengduKuanzhaiJourney.id,
    city: '成都',
    cityCode: 'CTU',
    place: '宽窄巷子',
    appBarTitle: '成都 · 宽窄巷子',
    storyTitle: '巷子故事',
    headline: '在院落里读懂成都慢生活',
    description: '走进三条老巷，观察历史街区怎样继续服务今天。',
    discoveryTeaser: '为什么这里既是古街，也是现代生活空间？',
    distanceLabel: '1,020 km',
    stampSymbol: '巷',
    content: chengduKuanzhaiJourney,
    storyAnnotations: chengduStoryAnnotations,
    words: chengduWords,
    discoveries: chengduDiscoveries,
    wonderQuestion: '在宽巷、窄巷和井巷中，你最想在哪一条巷子停下来？为什么？',
    expressQuestion: '请用两到三句话介绍你理想中的成都慢生活。',
  ),
  DailyJourneyExperience(
    id: nanjingQinhuaiJourney.id,
    city: '南京',
    cityCode: 'NKG',
    place: '秦淮河',
    appBarTitle: '南京 · 秦淮河',
    storyTitle: '秦淮故事',
    headline: '沿着灯影寻找城市记忆',
    description: '从夫子庙、贡院与灯会理解南京的教育和民俗传统。',
    discoveryTeaser: '为什么秦淮河不只是一条观光河？',
    distanceLabel: '1,860 km',
    stampSymbol: '淮',
    content: nanjingQinhuaiJourney,
    storyAnnotations: nanjingStoryAnnotations,
    words: nanjingWords,
    discoveries: nanjingDiscoveries,
    wonderQuestion: '如果你夜游秦淮河，最想停在哪一种文化场景前：古桥、贡院、灯会还是小吃街？',
    expressQuestion: '请用两到三句话描写秦淮河夜晚的灯光和声音。',
  ),
  DailyJourneyExperience(
    id: guangzhouChenClanJourney.id,
    city: '广州',
    cityCode: 'CAN',
    place: '陈家祠',
    appBarTitle: '广州 · 陈家祠',
    storyTitle: '岭南工艺故事',
    headline: '把建筑读成一本立体工艺书',
    description: '靠近屋脊与墙面，从细节认识岭南传统工艺。',
    discoveryTeaser: '为什么陈家祠的装饰比建筑本身更抢眼？',
    distanceLabel: '820 km',
    stampSymbol: '艺',
    content: guangzhouChenClanJourney,
    storyAnnotations: guangzhouStoryAnnotations,
    words: guangzhouWords,
    discoveries: guangzhouDiscoveries,
    wonderQuestion: '木雕、砖雕、陶塑和灰塑中，你最想近距离观察哪一种？为什么？',
    expressQuestion: '请用两到三句话介绍陈家祠最吸引你的工艺细节。',
  ),
];
