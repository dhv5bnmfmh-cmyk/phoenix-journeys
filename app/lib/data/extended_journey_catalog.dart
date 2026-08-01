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
  '杭州高中生顾遥每天清晨从苏堤骑车送早餐，今天却要在上课前把一只受伤水鸟送到救护点。封闭维修的堤岸让她只能在迟到与绕行之间选择。',
  '她熟悉西湖并非纯粹自然：疏浚、堤岸、亭台和园林共同安排水与人的距离。为了抄近路穿过草岸，她已经抬起车轮，却看见新栽柳树根旁的警示绳。',
  '顾遥选择沿白堤绕远，请常客接力带走早餐，自己护着纸箱过桥。她错过早读，却让水鸟和脆弱堤岸都没有为她的急切付出代价。',
  '傍晚再经过湖边，顾遥第一次不把倒映当作景点背景。人工设计与山水彼此融合，城市一起呼吸，意味着每个日常决定都要给另一种生命留下位置。',
];

const hangzhouStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(
    pinyin:
        'háng zhōu gāo zhōng shēng gù yáo měi tiān qīng chén cóng sū dī qí chē sòng zǎo cān ， jīn tiān què yào zài shàng kè qián bǎ yì zhī shòu shāng shuǐ niǎo sòng dào jiù hù diǎn 。 fēng bì wéi xiū de dī àn ràng tā zhǐ néng zài chí dào yǔ rào xíng zhī jiān xuǎn zé 。',
    vietnamese:
        'Học sinh Cố Dao thường đạp xe giao bữa sáng qua đê Tô, nhưng hôm nay phải đưa một chim nước bị thương tới trạm cứu hộ trước giờ học. Đoạn đê đóng sửa khiến cô phải chọn đi vòng hay đến muộn.',
    english:
        'Student Gu Yao usually delivers breakfast along Su Causeway, but today she must take an injured waterbird to a rescue station before class. A closure forces her to choose between a detour and being late.',
  ),
  ReadingAnnotation(
    pinyin:
        'tā shú xī xī hú bìng fēi chún cuì zì rán ： shū jùn 、 dī àn 、 tíng tái hé yuán lín gòng tóng ān pái shuǐ yǔ rén de jù lí 。 wèi le chāo jìn lù chuān guò cǎo àn ， tā yǐ jīng tái qǐ chē lún ， què kàn jiàn xīn zāi liǔ shù gēn páng de jǐng shì shéng 。',
    vietnamese:
        'Cô biết Tây Hồ được tạo nên bởi nạo vét, đê, đình và vườn. Định cắt qua bờ cỏ, cô nhìn thấy dây cảnh báo bên rễ liễu mới trồng.',
    english:
        'She knows West Lake was shaped by dredging, causeways, pavilions, and gardens. About to cut across the bank, she notices a warning rope beside newly planted willow roots.',
  ),
  ReadingAnnotation(
    pinyin:
        'gù yáo xuǎn zé yán bái dī rào yuǎn ， qǐng cháng kè jiē lì dài zǒu zǎo cān ， zì jǐ hù zhe zhǐ xiāng guò qiáo 。 tā cuò guò zǎo dú ， què ràng shuǐ niǎo hé cuì ruò dī àn dōu méi yǒu wèi tā de jí qiè fù chū dài jià 。',
    vietnamese:
        'Cố Dao chọn đi vòng qua đê Bạch, nhờ khách quen chuyển bữa sáng và tự bảo vệ chiếc hộp. Cô lỡ giờ đọc bài nhưng không để chim hay bờ đê trả giá cho sự vội vàng.',
    english:
        'Gu Yao detours along Bai Causeway, asks regular customers to relay the breakfasts, and protects the box herself. She misses morning reading but makes neither bird nor embankment pay for her haste.',
  ),
  ReadingAnnotation(
    pinyin:
        'bàng wǎn zài jīng guò hú biān ， gù yáo dì yī cì bù bǎ dǎo yìng dàng zuò jǐng diǎn bèi jǐng 。 rén gōng shè jì yǔ shān shuǐ bǐ cǐ róng hé ， chéng shì yì qǐ hū xī ， yì wèi zhe měi gè rì cháng jué dìng dū yào gěi lìng yì zhǒng shēng mìng liú xià wèi zhì 。',
    vietnamese:
        'Chiều tối, cô không còn xem phản chiếu như phông nền điểm tham quan. Thiết kế nhân tạo hòa với núi nước nghĩa là mỗi quyết định hằng ngày phải chừa chỗ cho sự sống khác.',
    english:
        'That evening, she no longer treats reflections as scenic backdrop. Human design blending with landscape means every daily decision must leave room for another life.',
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
  '成都茶馆学徒余声要在宽窄巷子接待一场直播。老板要求他把盖碗茶动作加快一倍，三分钟卖完套餐，可常来的陈婆婆仍等着他按旧节奏冲第一碗。',
  '宽、窄、井三条巷子同时挤满客人，商业噪声盖过杯盖轻响。余声若照脚本走能得到转正机会，若先照顾老客，直播可能冷场。',
  '镜头亮起时，他选择让陈婆婆教观众听水温，并删掉夸张口号。节奏慢下来，原本催单的人开始问院落怎样继续使用，老板却当场扣掉了他的奖金。',
  '收摊后，陈婆婆把杯盖放回碗上。青砖院落与三条平行巷子仍保留慢生活，余声不反对商业，却不愿老建筑只剩适合镜头的三分钟。',
];

const chengduStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'chéng dū chá guǎn xué tú yú shēng yào zài kuān zhǎi xiàng zǐ jiē dài yì chǎng zhí bō 。 lǎo bǎn yāo qiú tā bǎ gài wǎn chá dòng zuò jiā kuài yí bèi ， sān fēn zhōng mài wán tào cān ， kě cháng lái de chén pó po réng děng zhe tā àn jiù jié zòu chōng dì yī wǎn 。', vietnamese: 'Học việc quán trà Dư Thanh phải đón một buổi phát trực tiếp ở ngõ Rộng Hẹp. Chủ yêu cầu tăng gấp đôi tốc độ pha trà, nhưng bà Trần vẫn chờ chén đầu theo nhịp cũ.', english: 'Teahouse apprentice Yu Sheng must host a livestream in Kuanzhai Alley. His boss demands double-speed tea service, while regular customer Granny Chen waits for the first bowl at the old pace.'),
  ReadingAnnotation(pinyin: 'kuān 、 zhǎi 、 jǐng sān tiáo xiàng zǐ tóng shí jǐ mǎn kè rén ， shāng yè zào shēng gài guò bēi gài qīng xiǎng 。 yú shēng ruò zhào jiǎo běn zǒu néng dé dào zhuǎn zhèng jī huì ， ruò xiān zhào gù lǎo kè ， zhí bō kě néng lěng chǎng 。', vietnamese: 'Ba ngõ Rộng, Hẹp và Giếng đông nghịt, tiếng buôn bán lấn át tiếng nắp chén. Theo kịch bản có thể được chính thức nhận việc; phục vụ khách cũ trước có thể làm buổi phát nguội đi.', english: 'Wide, Narrow, and Well alleys are packed, and commerce drowns the cup-lid sound. Following the script may secure his job; serving the regular first may stall the stream.'),
  ReadingAnnotation(pinyin: 'jìng tóu liàng qǐ shí ， tā xuǎn zé ràng chén pó po jiào guān zhòng tīng shuǐ wēn ， bìng shān diào kuā zhāng kǒu hào 。 jié zòu màn xià lái ， yuán běn cuī dān de rén kāi shǐ wèn yuàn luò zěn yàng jì xù shǐ yòng ， lǎo bǎn què dāng chǎng kòu diào le tā de jiǎng jīn 。', vietnamese: 'Khi máy quay bật, anh để bà Trần dạy khán giả nghe nhiệt độ nước và bỏ khẩu hiệu phóng đại. Khán giả bắt đầu hỏi về đời sống trong sân, nhưng chủ trừ tiền thưởng của anh.', english: 'When the camera starts, he lets Granny Chen teach viewers to hear water temperature and drops the slogans. Viewers ask how courtyards remain in use, but his boss deducts his bonus.'),
  ReadingAnnotation(pinyin: 'shōu tān hòu ， chén pó po bǎ bēi gài fàng huí wǎn shàng 。 qīng zhuān yuàn luò yǔ sān tiáo píng xíng xiàng zi réng bǎo liú màn shēng huó ， yú shēng bù fǎn duì shāng yè ， què bú yuàn lǎo jiàn zhù zhī shèng shì hé jìng tóu de sān fēn zhōng 。', vietnamese: 'Sau giờ đóng cửa, Dư Thanh chọn nhịp kinh doanh của mình: sân gạch xanh và đời sống chậm không thể chỉ còn ba phút phù hợp với máy quay.', english: 'After closing, Yu Sheng chooses the pace at which he wants to work: grey-brick courtyards and slow living cannot be reduced to three camera-friendly minutes.'),
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
  '南京剪纸学徒苏禾为秦淮灯会设计主灯，评审却要她删掉江南贡院考生的小窗，说游客只喜欢大而亮的图案。她若拒绝，师傅的摊位可能失去今年的位置。',
  '苏禾沿夫子庙、古桥和牌坊收集旧纹样，也听曲艺艺人讲考试、商业与民俗怎样在河岸交织。主灯尺寸有限，她必须在夺目的游船轮廓与普通人的窗格之间取舍。',
  '她保留小窗，把最大的灯面剪成可从桥下看见的空格。点灯时，水面反光穿过窗格，观众先看见光，靠近后才发现一个等待放榜的人。',
  '摊位没有拿到最佳位置，师傅却把纸窗挂在秦淮河边。苏禾让城市记忆继续发光的方式，不是把过去做成静止布景，而是没有删掉其中安静的人。',
];

const nanjingStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'nán jīng jiǎn zhǐ xué tú sū hé wèi qín huái dēng huì shè jì zhǔ dēng ， píng shěn què yào tā shān diào jiāng nán gòng yuàn kǎo shēng de xiǎo chuāng ， shuō yóu kè zhī xǐ huan dà ér liàng de tú àn 。 tā ruò jù jué ， shī fu de tān wèi kě néng shī qù jīn nián de wèi zhì 。', vietnamese: 'Học việc cắt giấy Tô Hòa thiết kế đèn chính cho lễ hội Tần Hoài. Ban giám khảo muốn xóa ô cửa nhỏ của thí sinh Cống Viện; nếu từ chối, quầy của thầy có thể mất chỗ.', english: 'Paper-cutting apprentice Su He designs the main Qinhuai lantern. Judges want the examination candidate\'s small window removed; refusing may cost her mentor\'s stall its place.'),
  ReadingAnnotation(pinyin: 'sū hé yán fū zǐ miào 、 gǔ qiáo hé pái fāng shōu jí jiù wén yàng ， yě tīng qǔ yì yì rén jiǎng kǎo shì 、 shāng yè yǔ mín sú zěn yàng zài hé àn jiāo zhī 。 zhǔ dēng chǐ cùn yǒu xiàn ， tā bì xū zài duó mù dì yóu chuán lún kuò yǔ pǔ tōng rén de chuāng gé zhī jiān qǔ shě 。', vietnamese: 'Cô thu thập hoa văn quanh Phu Tử Miếu, cầu cổ và cổng bài, nghe nghệ nhân kể chuyện thi cử, thương mại và dân tục. Mặt đèn có hạn, cô phải chọn đường nét thuyền nổi bật hay ô cửa của người bình thường.', english: 'She gathers patterns near the Confucius Temple, old bridges, and archways, hearing how examinations, commerce, and custom intertwined. Limited space forces a choice between a bright boat and an ordinary person\'s window.'),
  ReadingAnnotation(pinyin: 'tā bǎo liú xiǎo chuāng ， bǎ zuì dà de dēng miàn jiǎn chéng kě cóng qiáo xià kàn jiàn de kòng gé 。 diǎn dēng shí ， shuǐ miàn fǎn guāng chuān guò chuāng gé ， guān zhòng xiān kàn jiàn guāng ， kào jìn hòu cái fā xiàn yí gè děng dài fàng bǎng de rén 。', vietnamese: 'Cô giữ ô cửa và cắt mặt đèn lớn thành khoảng trống nhìn thấy từ dưới cầu. Ánh nước xuyên qua; người xem thấy ánh sáng trước rồi mới thấy người chờ bảng kết quả.', english: 'She keeps the window and cuts the large lantern face into openings visible from beneath the bridge. Reflected light passes through; viewers see the glow before noticing a person awaiting results.'),
  ReadingAnnotation(pinyin: 'tān wèi méi yǒu ná dào zuì jiā wèi zhì ， shī fu què bǎ zhǐ chuāng guà zài qín huái hé biān 。 sū hé ràng chéng shì jì yì jì xù fā guāng de fāng shì ， bú shì bǎ guò qù zuò chéng jìng zhǐ bù jǐng ， ér shì méi yǒu shān diào qí zhōng ān jìng de rén 。', vietnamese: 'Quầy không được chỗ tốt nhất, nhưng thầy treo cửa giấy bên sông. Tô Hòa giữ ký ức đô thị sống động bằng cách không xóa người im lặng khỏi quá khứ.', english: 'The stall does not get the best location, but her mentor hangs the paper window by the river. Su He keeps urban memory alive by refusing to erase its quiet people.'),
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
  '广州灰塑修复学徒陈澄在陈家祠屋脊上找到一只缺翅的陶鸟。师傅让她按对称图样补齐，博物馆开放在即；她却发现另一侧并没有同样的鸟。',
  '陈澄在木雕、砖雕、石雕和陶塑之间寻找线索，人物花鸟各有叙事位置。照模板补最快，也最整齐，但可能把晚清工匠原本故意留下的方向感抹掉。',
  '她选择只加固断面，不凭想象造出翅膀，并把判断依据公开写进修复记录。开放日有人嫌它“不完整”，孩子却沿着鸟的朝向找到了屋脊另一端的故事。',
  '陈澄没有把宗族建筑修成一本崭新的图书。她学会让缺页仍可辨认：岭南工艺的文化记忆，既在精密细节里，也在不伪造答案的克制里。',
];

const guangzhouStoryAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'guǎng zhōu huī sù xiū fù xué tú chén chéng zài chén jiā cí wū jǐ shàng zhǎo dào yì zhī quē chì de táo niǎo 。 shī fu ràng tā àn duì chèn tú yàng bǔ qí ， bó wù guǎn kāi fàng zài jí ； tā què fā xiàn lìng yí cè bìng méi yǒu tóng yàng de niǎo 。', vietnamese: 'Học việc phục chế phù điêu vữa Trần Trừng tìm thấy một chim gốm gãy cánh trên nóc Trần Gia Từ. Thầy bảo bổ theo mẫu đối xứng, nhưng phía kia không có con chim giống vậy.', english: 'Lime-sculpture apprentice Chen Cheng finds a ceramic bird with a broken wing on the Chen Clan Ancestral Hall roof. Her mentor says to restore it symmetrically, but no matching bird exists opposite.'),
  ReadingAnnotation(pinyin: 'chén chéng zài mù diāo 、 zhuān diāo 、 shí diāo hé táo sù zhī jiān xún zhǎo xiàn suǒ ， rén wù huā niǎo gè yǒu xù shì wèi zhì 。 zhào mú bǎn bǔ zuì kuài ， yě zuì zhěng qí ， dàn kě néng bǎ wǎn qīng gōng jiàng yuán běn gù yì liú xià de fāng xiàng gǎn mǒ diào 。', vietnamese: 'Cô tìm manh mối giữa chạm gỗ, gạch, đá và tượng gốm. Làm theo mẫu nhanh và đều, nhưng có thể xóa hướng nhìn mà nghệ nhân cuối Thanh cố ý để lại.', english: 'She searches wood, brick, stone, and ceramic work for clues. A template would be quick and neat but might erase the direction intended by the late-Qing artisan.'),
  ReadingAnnotation(pinyin: 'tā xuǎn zé zhī jiā gù duàn miàn ， bù píng xiǎng xiàng zào chū chì bǎng ， bìng bǎ pàn duàn yī jù gōng kāi xiě jìn xiū fù jì lù 。 kāi fàng rì yǒu rén xián tā “ bù wán zhěng ”， hái zi què yán zhe niǎo de cháo xiàng zhǎo dào le wū jǐ lìng yì duān de gù shì 。', vietnamese: 'Cô chỉ gia cố mặt gãy, không tưởng tượng thêm cánh, và công khai căn cứ trong hồ sơ. Có người chê chưa hoàn chỉnh, nhưng trẻ em theo hướng chim tìm thấy câu chuyện ở đầu mái kia.', english: 'She stabilizes the break without inventing a wing and publishes the reasoning. Some call it incomplete, but children follow the bird\'s direction to another story on the roof.'),
  ReadingAnnotation(pinyin: 'chén chéng méi yǒu bǎ zōng zú jiàn zhù xiū chéng yì běn zhǎn xīn de tú shū 。 tā xué huì ràng quē yè réng kě biàn rèn ： lǐng nán gōng yì de wén huà jì yì ， jì zài jīng mì xì jié lǐ ， yě zài bù wěi zào dá àn de kè zhì lǐ 。', vietnamese: 'Trần Trừng học cách giữ một trang thiếu vẫn đọc được: ký ức thủ công Lĩnh Nam nằm cả trong chi tiết chính xác và sự kiềm chế không bịa đáp án.', english: 'Chen Cheng learns to keep a missing page readable: Lingnan craft memory lies both in precise detail and in the restraint not to invent an answer.'),
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
