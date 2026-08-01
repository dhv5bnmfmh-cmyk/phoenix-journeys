import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchTwoSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-datong-yungang-grottoes',
    title: 'Yungang Grottoes',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1039',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-shanxi-datong-yungang-yungang-grottoes'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'ncha-datong-yungang-grottoes',
    title: '云冈石窟',
    publisher: '国家文物局',
    url: 'https://www.ncha.gov.cn/art/2024/8/8/art_2791_190647.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-shanxi-datong-yungang-yungang-grottoes'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-lijiang-old-town',
    title: 'Old Town of Lijiang',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/811',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-yunnan-lijiang-gucheng-dayan-old-town'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'yunnan-lijiang-old-town',
    title: '古城水韵融四方',
    publisher: '云南省文化和旅游厅',
    url: 'https://dct.yn.gov.cn/html/2511/20_42044.shtml',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-yunnan-lijiang-gucheng-dayan-old-town'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-jiangmen-kaiping-diaolou',
    title: 'Kaiping Diaolou and Villages',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1112',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-guangdong-jiangmen-kaiping-zili-village'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'kaiping-government-zili-village',
    title: '开平碉楼文化旅游区',
    publisher: '开平市人民政府',
    url: 'https://www.kaiping.gov.cn/kpszfw/zwgk/zdlyxxgkzl/lyscjgzfxx/lyml/content/post_2867978.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-guangdong-jiangmen-kaiping-zili-village'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
];

JourneyContentRecord _record({
  required String id,
  required String title,
  required String geoNodeId,
  required List<String> paragraphs,
  required List<String> sources,
  required List<String> tags,
}) =>
    JourneyContentRecord(
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
          sourceIds: sources,
        ),
      ),
    );

const _datongParagraphs = <String>[
  '大同石窟修复学徒魏真第一次负责记录昙曜五窟的渗水点。导师要求她只按表格编号，父亲却等着她拍一张巨像近照，证明这份工作“值得”。',
  '午后风起，砂岩崖壁落下细屑。魏真在衣纹与飞天旁发现旧编号偏了半米；照旧抄写最快，重新测量会让全组返工，也可能暴露她此前没有复核。',
  '她选择停下记录，当众说明偏差，并用面容、手势和建筑图案重新定位。团队错过开放前的拍摄窗口，却把渗水路线准确连到岩体裂缝。',
  '离开洞窟时，魏真没有带走巨像自拍，只把图交给父亲看。北魏工匠开凿的石头史书，其庄严不在于让她显得重要，而在于她肯为误差承担后果。',
];

const _datongAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'dà tóng shí kū xiū fù xué tú wèi zhēn dì yī cì fù zé jì lù tán yào wǔ kū de shèn shuǐ diǎn 。 dǎo shī yāo qiú tā zhī àn biǎo gé biān hào ， fù qīn què děng zhe tā pāi yì zhāng jù xiàng jìn zhào ， zhèng míng zhè fèn gōng zuò “ zhí dé ”。', vietnamese: 'Thực tập sinh bảo tồn Ngụy Chân lần đầu ghi các điểm thấm nước ở năm hang Đàm Diệu. Người hướng dẫn yêu cầu chỉ điền mã số, còn cha chờ một ảnh tượng lớn để chứng minh công việc của cô ‘đáng giá’.', english: 'Conservation trainee Wei Zhen records seepage in the Five Caves of Tanyao for the first time. Her supervisor wants only catalogue numbers, while her father expects a monumental-statue photograph to prove that her work is worthwhile.'),
  ReadingAnnotation(pinyin: 'wǔ hòu fēng qǐ ， shā yán yá bì luò xià xì xiè 。 wèi zhēn zài yī wén yǔ fēi tiān páng fā xiàn jiù biān hào piān le bàn mǐ ； zhào jiù chāo xiě zuì kuài ， chóng xīn cè liáng huì ràng quán zǔ fǎn gōng ， yě kě néng bào lù tā cǐ qián méi yǒu fù hé 。', vietnamese: 'Gió chiều làm sa thạch rơi vụn. Bên nếp áo và phi thiên, cô phát hiện mã cũ lệch nửa mét; chép theo sẽ nhanh, đo lại khiến cả nhóm làm lại và có thể lộ việc cô từng bỏ qua bước kiểm tra.', english: 'Afternoon wind loosens sandstone grains. Beside carved drapery and flying figures, she finds an old marker half a metre off; copying it is easy, while remeasuring forces a team rework and exposes her earlier failure to verify it.'),
  ReadingAnnotation(pinyin: 'tā xuǎn zé tíng xià jì lù ， dāng zhòng shuō míng piān chā ， bìng yòng miàn róng 、 shǒu shì hé jiàn zhù tú àn chóng xīn dìng wèi 。 tuán duì cuò guò kāi fàng qián de pāi shè chuāng kǒu ， què bǎ shèn shuǐ lù xiàn zhǔn què lián dào yán tǐ liè fèng 。', vietnamese: 'Cô dừng ghi chép, công khai sai lệch và định vị lại bằng gương mặt, thủ ấn cùng hoa văn kiến trúc. Nhóm bỏ lỡ khung giờ chụp trước khi mở cửa, nhưng nối đúng đường thấm với khe nứt trong đá.', english: 'She stops the survey, reports the error, and relocates the point through faces, gestures, and architectural patterns. The team loses its pre-opening photography window but correctly links the seepage route to the rock fracture.'),
  ReadingAnnotation(pinyin: 'lí kāi dòng kū shí ， wèi zhēn méi yǒu dài zǒu jù xiàng zì pāi ， zhī bǎ tú jiāo gěi fù qīn kàn 。 běi wèi gōng jiàng kāi záo de shí tou shǐ shū ， qí zhuāng yán bú zài yú ràng tā xiǎn de zhòng yào ， ér zài yú tā kěn wèi wù chā chéng dān hòu guǒ 。', vietnamese: 'Rời hang, Ngụy Chân không mang ảnh tự chụp với tượng lớn mà chỉ đưa cha bản đồ sửa. Sự trang nghiêm của cuốn sử đá do nghệ nhân Bắc Ngụy tạc nằm ở việc cô dám chịu hậu quả của một sai số nhỏ.', english: 'Leaving the caves, Wei Zhen takes no grand selfie and shows her father only the corrected plan. The dignity of this Northern Wei history in stone lies in her willingness to accept the consequences of a small error.'),
];

const _datongWords = <WordEntry>[
  WordEntry(word: '崖壁', pinyin: 'yábì', partOfSpeech: '名词', simpleChinese: '陡直的山崖表面。', translation: 'Bề mặt vách núi dựng đứng.', englishDefinition: 'cliff face', symbol: '⛰️'),
  WordEntry(word: '洞窟', pinyin: 'dòngkū', partOfSpeech: '名词', simpleChinese: '在山体中开出的空间。', translation: 'Hang được tạo trong núi.', englishDefinition: 'rock-cut cave', symbol: '🪨'),
  WordEntry(word: '砂岩', pinyin: 'shāyán', partOfSpeech: '名词', simpleChinese: '由沙粒形成的岩石。', translation: 'Đá sa thạch.', englishDefinition: 'sandstone', symbol: '🟤'),
  WordEntry(word: '开凿', pinyin: 'kāizáo', partOfSpeech: '动词', simpleChinese: '挖掘并形成空间。', translation: 'Đào và tạo không gian.', englishDefinition: 'to excavate', symbol: '⛏️'),
  WordEntry(word: '工匠', pinyin: 'gōngjiàng', partOfSpeech: '名词', simpleChinese: '有专门手艺的人。', translation: 'Nghệ nhân có tay nghề.', englishDefinition: 'artisan', symbol: '🛠️'),
  WordEntry(word: '衣纹', pinyin: 'yīwén', partOfSpeech: '名词', simpleChinese: '雕像衣服上的褶纹。', translation: 'Nếp áo trên tượng.', englishDefinition: 'carved drapery folds', symbol: '〰️'),
  WordEntry(word: '飞天', pinyin: 'fēitiān', partOfSpeech: '名词', simpleChinese: '石窟艺术中的飞行形象。', translation: 'Hình tượng bay trong nghệ thuật hang đá.', englishDefinition: 'flying celestial figure', symbol: '🪽'),
  WordEntry(word: '庄严', pinyin: 'zhuāngyán', partOfSpeech: '形容词', simpleChinese: '严肃而令人尊敬。', translation: 'Trang nghiêm.', englishDefinition: 'solemn', symbol: '✨'),
  WordEntry(word: '修复', pinyin: 'xiūfù', partOfSpeech: '动词', simpleChinese: '把受损部分保护并恢复。', translation: 'Tu bổ phần bị hư hại.', englishDefinition: 'to conserve and restore', symbol: '🧰'),
];

const _datongDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '云冈石窟的主要洞窟开凿于公元五至六世纪。', pinyin: 'Yúngāng Shíkū de zhǔyào dòngkū kāizáo yú gōngyuán wǔ zhì liù shìjì.', simpleChinese: '主要洞窟来自五到六世纪。', vietnamese: 'Các hang chính được tạc vào thế kỷ V–VI.', english: 'The principal caves were carved in the fifth and sixth centuries.'),
  DiscoveryEntry(text: '昙曜五窟以统一的空间与造像设计成为云冈的重要代表。', pinyin: 'Tányào Wǔkū yǐ tǒngyī de kōngjiān yǔ zàoxiàng shèjì chéngwéi Yúngāng de zhòngyào dàibiǎo.', simpleChinese: '昙曜五窟的设计非常完整。', vietnamese: 'Năm hang Đàm Diệu nổi bật nhờ thiết kế không gian và tượng thống nhất.', english: 'The Five Caves of Tanyao are notable for coherent spatial and sculptural design.'),
  DiscoveryEntry(text: '造像风格体现了多种艺术传统在北魏平城的交流。', pinyin: 'Zàoxiàng fēnggé tǐxiàn le duō zhǒng yìshù chuántǒng zài Běiwèi Píngchéng de jiāoliú.', simpleChinese: '不同艺术传统在这里相遇。', vietnamese: 'Phong cách tượng cho thấy nhiều truyền thống nghệ thuật gặp nhau tại Bình Thành.', english: 'The sculptures show multiple artistic traditions meeting at Northern Wei Pingcheng.'),
  DiscoveryEntry(text: '数字记录、环境监测与岩体修复共同参与石窟保护。', pinyin: 'Shùzì jìlù, huánjìng jiāncè yǔ yántǐ xiūfù gòngtóng cānyù shíkū bǎohù.', simpleChinese: '保护需要记录、监测和修复。', vietnamese: 'Bảo tồn kết hợp ghi chép số, quan trắc môi trường và tu bổ đá.', english: 'Digital records, environmental monitoring, and rock conservation work together.'),
];

const _lijiangParagraphs = <String>[
  '丽江雨后，纳西木匠和川要把修好的院门送到四方街旁。客户要求货车直接开进石板巷，省下搬运费，可古城水道刚涨，轮胎会压住居民临时架起的引水板。',
  '和川熟悉这座不按棋盘格生长的城：道路、水系和院落顺着地势互相让路。若拒绝，客户会扣钱；若照办，下游几户今晚就可能断水。',
  '他选择在桥边卸门，找茶马古道驮运记忆仍在的邻居借来窄架，几个人沿水声步行抬过街巷。院门晚到一小时，客户最终也加入了最后一段搬运。',
  '灯影落进清水时，和川踩着石板路听新门轴与流水一起响。茶马古道让这里成为往来节点；他守住的不只是技艺，也是生意给居民日常留路。',
];

const _lijiangAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'lì jiāng yǔ hòu ， nà xī mù jiàng hé chuān yào bǎ xiū hǎo de yuàn mén sòng dào sì fāng jiē páng 。 kè hù yāo qiú huò chē zhí jiē kāi jìn shí bǎn xiàng ， shěng xià bān yùn fèi ， kě gǔ chéng shuǐ dào gāng zhǎng ， lún tāi huì yā zhù jū mín lín shí jià qǐ de yǐn shuǐ bǎn 。', vietnamese: 'Sau mưa ở Lệ Giang, thợ mộc Nạp Tây Hòa Xuyên phải giao một cánh cửa đã sửa gần Tứ Phương Nhai. Khách yêu cầu lái xe vào ngõ đá cho đỡ phí, nhưng nước đang dâng và bánh xe sẽ đè lên tấm dẫn nước tạm của cư dân.', english: 'After rain in Lijiang, Naxi carpenter He Chuan must deliver a repaired courtyard door near Sifang Street. The customer wants a vehicle driven into the stone lane to save carrying costs, but rising water means its tires would crush residents\' temporary channel board.'),
  ReadingAnnotation(pinyin: 'hé chuān shú xī zhè zuò bú àn qí pán gé shēng cháng de chéng ： dào lù 、 shuǐ xì hé yuàn luò shùn zhe dì shì hù xiāng ràng lù 。 ruò jù jué ， kè hù huì kòu qián ； ruò zhào bàn ， xià yóu jǐ hù jīn wǎn jiù kě néng duàn shuǐ 。', vietnamese: 'Hòa Xuyên hiểu thành cổ không phát triển theo ô bàn cờ: đường, hệ nước và sân nhà nhường nhau theo địa thế. Từ chối sẽ bị trừ tiền; làm theo sẽ khiến vài nhà phía dưới mất nước đêm đó.', english: 'He Chuan knows the old town does not grow as a grid: streets, waterways, and courtyards yield to one another with the terrain. Refusing costs him money; complying may cut off water to downstream homes that night.'),
  ReadingAnnotation(pinyin: 'tā xuǎn zé zài qiáo biān xiè mén ， zhǎo chá mǎ gǔ dào tuó yùn jì yì réng zài de lín jū jiè lái zhǎi jià ， jǐ gè rén yán shuǐ shēng bù xíng tái guò jiē xiàng 。 yuàn mén wǎn dào yì xiǎo shí ， kè hù zuì zhōng yě jiā rù le zuì hòu yí duàn bān yùn 。', vietnamese: 'Anh dỡ cửa bên cầu, mượn khung hẹp từ người hàng xóm còn nhớ cách vận chuyển trên Trà Mã Cổ Đạo, rồi cùng mọi người khiêng theo tiếng nước. Cửa đến muộn một giờ và cuối cùng khách cũng giúp đoạn cuối.', english: 'He unloads the door by the bridge, borrows a narrow carrying frame from a neighbor who remembers Tea Horse Road methods, and follows the water sounds on foot. The door arrives an hour late, and the customer joins the final carry.'),
  ReadingAnnotation(pinyin: 'dēng yǐng luò jìn qīng shuǐ shí ， hé chuān cǎi zhe shí bǎn lù tīng xīn mén zhóu yǔ liú shuǐ yì qǐ xiǎng 。 chá mǎ gǔ dào ràng zhè lǐ chéng wéi wǎng lái jié diǎn ； tā shǒu zhù de bù zhǐ shì jì yì ， yě shì shēng yì gěi jū mín rì cháng liú lù 。', vietnamese: 'Khi ánh đèn rơi xuống nước, Hòa Xuyên nghe bản lề mới hòa cùng dòng chảy. Trên nút giao Trà Mã Cổ Đạo này, anh bảo vệ cả nghề truyền thống lẫn quyền có lối đi của đời sống cư dân.', english: 'As lamplight reaches the water, He Chuan hears the new hinge beside the current. At this Tea Horse Road crossroads, he protects both traditional craft and the space that residents\' daily lives require.'),
];

const _lijiangWords = <WordEntry>[
  WordEntry(word: '石板路', pinyin: 'shíbǎnlù', partOfSpeech: '名词', simpleChinese: '用石板铺成的道路。', translation: 'Đường lát đá.', englishDefinition: 'stone-paved lane', symbol: '🧱'),
  WordEntry(word: '街巷', pinyin: 'jiēxiàng', partOfSpeech: '名词', simpleChinese: '街道和小巷。', translation: 'Đường phố và ngõ nhỏ.', englishDefinition: 'streets and lanes', symbol: '🏘️'),
  WordEntry(word: '水道', pinyin: 'shuǐdào', partOfSpeech: '名词', simpleChinese: '让水流过的通道。', translation: 'Kênh dẫn nước.', englishDefinition: 'water channel', symbol: '💧'),
  WordEntry(word: '棋盘格', pinyin: 'qípángé', partOfSpeech: '名词', simpleChinese: '像棋盘一样整齐的格子。', translation: 'Mạng lưới ô bàn cờ.', englishDefinition: 'grid pattern', symbol: '▦'),
  WordEntry(word: '院落', pinyin: 'yuànluò', partOfSpeech: '名词', simpleChinese: '房屋围成的院子空间。', translation: 'Khoảng sân có nhà bao quanh.', englishDefinition: 'courtyard compound', symbol: '🏡'),
  WordEntry(word: '地势', pinyin: 'dìshì', partOfSpeech: '名词', simpleChinese: '地面的高低形态。', translation: 'Địa thế cao thấp.', englishDefinition: 'terrain', symbol: '🗻'),
  WordEntry(word: '节点', pinyin: 'jiédiǎn', partOfSpeech: '名词', simpleChinese: '网络中重要的连接位置。', translation: 'Điểm kết nối quan trọng.', englishDefinition: 'network hub', symbol: '🔗'),
  WordEntry(word: '往来', pinyin: 'wǎnglái', partOfSpeech: '动词', simpleChinese: '互相来往和交流。', translation: 'Qua lại và giao lưu.', englishDefinition: 'to interact and travel between', symbol: '🐎'),
  WordEntry(word: '技艺', pinyin: 'jìyì', partOfSpeech: '名词', simpleChinese: '经过学习形成的手艺。', translation: 'Kỹ nghệ truyền thống.', englishDefinition: 'craft skill', symbol: '🪡'),
];

const _lijiangDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '丽江古城的道路与水系顺应山地环境，没有采用规则棋盘格。', pinyin: 'Lìjiāng Gǔchéng de dàolù yǔ shuǐxì shùnyìng shāndì huánjìng, méiyǒu cǎiyòng guīzé qípángé.', simpleChinese: '道路和水系跟着地形变化。', vietnamese: 'Đường và kênh nước thích ứng địa hình thay vì theo ô bàn cờ.', english: 'The street and water networks adapt to mountain terrain rather than a fixed grid.'),
  DiscoveryEntry(text: '大研、白沙与束河共同构成世界遗产丽江古城。', pinyin: 'Dàyán, Báishā yǔ Shùhé gòngtóng gòuchéng Shìjiè Yíchǎn Lìjiāng Gǔchéng.', simpleChinese: '三个城镇共同组成遗产。', vietnamese: 'Đại Nghiên, Bạch Sa và Thúc Hà cùng tạo thành di sản.', english: 'Dayan, Baisha, and Shuhe together form the World Heritage property.'),
  DiscoveryEntry(text: '古城水系至今仍参与居民生活与街区环境。', pinyin: 'Gǔchéng shuǐxì zhìjīn réng cānyù jūmín shēnghuó yǔ jiēqū huánjìng.', simpleChinese: '流水现在仍服务古城生活。', vietnamese: 'Hệ thống nước vẫn gắn với đời sống và môi trường khu phố.', english: 'The historic water system still supports daily life and the urban environment.'),
  DiscoveryEntry(text: '茶马古道让丽江成为多民族经济与文化交流节点。', pinyin: 'Chámǎ Gǔdào ràng Lìjiāng chéngwéi duō mínzú jīngjì yǔ wénhuà jiāoliú jiédiǎn.', simpleChinese: '茶马古道连接了不同人群。', vietnamese: 'Trà Mã Cổ Đạo biến Lệ Giang thành nút giao kinh tế và văn hóa đa dân tộc.', english: 'The Tea Horse Road made Lijiang a hub of multi-ethnic exchange.'),
];

const _kaipingParagraphs = <String>[
  '开平自力村的青年陈岸收到海外叔公寄来的旧钥匙，却找不到对应房门。村里准备把空置碉楼布置成展室，他必须在开幕前确认钥匙属于哪座楼，否则家书就只能成为无出处的装饰。',
  '陈岸沿稻田、荷塘逐户询问，从厚墙、拱券和柱式中辨认不同年代。负责人催他把钥匙放进最漂亮的铭石楼展柜，他却发现叔公信中写的洪水刻痕只出现在一座普通民居。',
  '他选择推迟展览，撬开民居发霉的木箱，找到海外积蓄汇回故乡的账页。钥匙并不属于高耸碉楼，而属于曾保管全村汇款记录的小柜。',
  '展室后来把钥匙留在稻田视线可及的位置。陈岸找回的不是传奇密室，而是华侨、侨乡建筑、农业生活与跨海家庭彼此支撑的证据。',
];

const _kaipingAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'kāi píng zì lì cūn de qīng nián chén àn shōu dào hǎi wài shū gōng jì lái de jiù yào shi ， què zhǎo bú dào duì yìng fáng mén 。 cūn lǐ zhǔn bèi bǎ kōng zhì diāo lóu bù zhì chéng zhǎn shì ， tā bì xū zài kāi mù qián què rèn yào shi shǔ yú nǎ zuò lóu ， fǒu zé jiā shū jiù zhǐ néng chéng wéi wú chū chù de zhuāng shì 。', vietnamese: 'Trần Ngạn ở làng Tự Lực nhận chiếc chìa khóa cũ từ ông chú ở nước ngoài nhưng không tìm thấy cửa tương ứng. Trước ngày mở phòng trưng bày điêu lâu, cậu phải xác định nguồn gốc, nếu không thư nhà sẽ chỉ thành đồ trang trí vô danh.', english: 'Chen An in Zili Village receives an old key from an overseas great-uncle but cannot find its door. Before a diaolou exhibition opens, he must establish its origin or the family letters will become anonymous decoration.'),
  ReadingAnnotation(pinyin: 'chén àn yán dào tián 、 hé táng zhú hù xún wèn ， cóng hòu qiáng 、 gǒng xuàn hé zhù shì zhōng biàn rèn bù tóng nián dài 。 fù zé rén cuī tā bǎ yào shi fàng jìn zuì piào liang de míng shí lóu zhǎn guì ， tā què fā xiàn shū gōng xìn zhōng xiě de hóng shuǐ kè hén zhī chū xiàn zài yí zuò pǔ tōng mín jū 。', vietnamese: 'Cậu hỏi từng nhà dọc ruộng lúa và ao sen, phân biệt niên đại qua tường dày, vòm và thức cột. Người phụ trách muốn đặt chìa khóa vào tủ đẹp nhất ở Minh Thạch Lâu, nhưng dấu lũ trong thư chỉ có ở một nhà dân bình thường.', english: 'He asks house by house along rice fields and lotus ponds, reading dates through thick walls, arches, and columns. The curator wants the key in the finest Mingshi Tower case, but the flood mark described in the letter appears only in an ordinary home.'),
  ReadingAnnotation(pinyin: 'tā xuǎn zé tuī chí zhǎn lǎn ， qiào kāi mín jū fā méi de mù xiāng ， zhǎo dào hǎi wài jī xù huì huí gù xiāng de zhàng yè 。 yào shi bìng bù shǔ yú gāo sǒng diāo lóu ， ér shǔ yú céng bǎo guǎn quán cūn huì kuǎn jì lù de xiǎo guì 。', vietnamese: 'Cậu hoãn triển lãm, mở chiếc hòm mốc trong nhà và tìm thấy sổ tiền tiết kiệm gửi từ hải ngoại. Chìa khóa không thuộc một tháp cao mà mở tủ từng giữ hồ sơ chuyển tiền của cả làng.', english: 'He postpones the exhibition, opens a moldy chest in the house, and finds accounts of overseas savings. The key belongs not to a tall tower but to a cabinet that once held the village\'s remittance records.'),
  ReadingAnnotation(pinyin: 'zhǎn shì hòu lái bǎ yào shi liú zài dào tián shì xiàn kě jí de wèi zhì 。 chén àn zhǎo huí de bú shì chuán qí mì shì ， ér shì huá qiáo 、 qiáo xiāng jiàn zhù 、 nóng yè shēng huó yǔ kuà hǎi jiā tíng bǐ cǐ zhī chēng de zhèng jù 。', vietnamese: 'Sau đó chìa khóa được trưng bày trong tầm nhìn ra ruộng. Trần Ngạn không tìm thấy căn phòng bí mật mà tìm được bằng chứng giản dị về cách Hoa kiều, kiến trúc quê hương, nông nghiệp và gia đình xuyên biển nâng đỡ nhau.', english: 'The key is later displayed within sight of the fields. Chen An finds no legendary chamber, only plain evidence of how overseas Chinese, village architecture, farming, and transoceanic families supported one another.'),
];

const _kaipingWords = <WordEntry>[
  WordEntry(word: '稻田', pinyin: 'dàotián', partOfSpeech: '名词', simpleChinese: '种水稻的田地。', translation: 'Ruộng lúa.', englishDefinition: 'rice field', symbol: '🌾'),
  WordEntry(word: '荷塘', pinyin: 'hétáng', partOfSpeech: '名词', simpleChinese: '种有荷花的池塘。', translation: 'Ao sen.', englishDefinition: 'lotus pond', symbol: '🪷'),
  WordEntry(word: '碉楼', pinyin: 'diāolóu', partOfSpeech: '名词', simpleChinese: '兼有居住和防卫功能的高楼。', translation: 'Nhà tháp có chức năng ở và phòng vệ.', englishDefinition: 'defensive tower house', symbol: '🏰'),
  WordEntry(word: '厚墙', pinyin: 'hòuqiáng', partOfSpeech: '名词', simpleChinese: '厚而坚固的墙。', translation: 'Tường dày và chắc.', englishDefinition: 'thick wall', symbol: '🧱'),
  WordEntry(word: '积蓄', pinyin: 'jīxù', partOfSpeech: '名词', simpleChinese: '长期保存下来的钱。', translation: 'Tiền tiết kiệm.', englishDefinition: 'savings', symbol: '💰'),
  WordEntry(word: '拱券', pinyin: 'gǒngquàn', partOfSpeech: '名词', simpleChinese: '建筑中的弧形承重结构。', translation: 'Kết cấu vòm chịu lực.', englishDefinition: 'architectural arch', symbol: '🌉'),
  WordEntry(word: '柱式', pinyin: 'zhùshì', partOfSpeech: '名词', simpleChinese: '柱子的设计形式。', translation: 'Kiểu thức cột.', englishDefinition: 'column order', symbol: '🏛️'),
  WordEntry(word: '华侨', pinyin: 'huáqiáo', partOfSpeech: '名词', simpleChinese: '长期生活在国外的中国公民。', translation: 'Hoa kiều.', englishDefinition: 'overseas Chinese citizen', symbol: '🧳'),
  WordEntry(word: '侨乡', pinyin: 'qiáoxiāng', partOfSpeech: '名词', simpleChinese: '许多华侨来自的家乡。', translation: 'Quê hương của nhiều Hoa kiều.', englishDefinition: 'home region of overseas Chinese', symbol: '🏡'),
];

const _kaipingDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '开平碉楼是集居住、防卫与建筑艺术于一体的多层乡土建筑。', pinyin: 'Kāipíng Diāolóu shì jí jūzhù, fángwèi yǔ jiànzhù yìshù yú yìtǐ de duōcéng xiāngtǔ jiànzhù.', simpleChinese: '碉楼可以居住，也可以防卫。', vietnamese: 'Điêu lâu Khai Bình kết hợp cư trú, phòng vệ và nghệ thuật kiến trúc.', english: 'Kaiping diaolou combine residence, defence, and architectural expression.'),
  DiscoveryEntry(text: '世界遗产包含四组村落中的代表性碉楼。', pinyin: 'Shìjiè Yíchǎn bāohán sì zǔ cūnluò zhōng de dàibiǎoxìng diāolóu.', simpleChinese: '四组村落共同组成遗产。', vietnamese: 'Di sản gồm các điêu lâu tiêu biểu trong bốn nhóm làng.', english: 'The World Heritage property includes representative towers in four village groups.'),
  DiscoveryEntry(text: '中西建筑元素的融合反映了海外开平人与故乡的长期联系。', pinyin: 'Zhōngxī jiànzhù yuánsù de rónghé fǎnyìng le hǎiwài Kāipíng rén yǔ gùxiāng de chángqī liánxì.', simpleChinese: '建筑记录了华侨与家乡的联系。', vietnamese: 'Sự kết hợp kiến trúc Đông–Tây phản ánh liên hệ lâu dài giữa người Khai Bình hải ngoại và quê nhà.', english: 'The hybrid architecture reflects lasting ties between emigrants and home villages.'),
  DiscoveryEntry(text: '自力村的稻田、荷塘、民居与碉楼共同形成完整的乡村景观。', pinyin: 'Zìlì Cūn de dàotián, hétáng, mínjū yǔ diāolóu gòngtóng xíngchéng wánzhěng de xiāngcūn jǐngguān.', simpleChinese: '自然和建筑一起构成村落。', vietnamese: 'Ruộng, ao sen, nhà dân và điêu lâu cùng tạo thành cảnh quan làng hoàn chỉnh.', english: 'Fields, ponds, houses, and towers form an integrated rural landscape.'),
];

final datongYungangJourney = _record(
  id: 'datong-yungang-grottoes',
  title: '大同 · 云冈石窟：听见北魏刻进山崖的回声',
  geoNodeId: 'cn-shanxi-datong-yungang-yungang-grottoes',
  paragraphs: _datongParagraphs,
  sources: const ['unesco-datong-yungang-grottoes', 'ncha-datong-yungang-grottoes'],
  tags: const ['大同', '云冈石窟', '北魏', '石刻', '世界遗产'],
);

final lijiangOldTownJourney = _record(
  id: 'lijiang-old-town',
  title: '丽江 · 大研古城：沿流水读懂山地城市',
  geoNodeId: 'cn-yunnan-lijiang-gucheng-dayan-old-town',
  paragraphs: _lijiangParagraphs,
  sources: const ['unesco-lijiang-old-town', 'yunnan-lijiang-old-town'],
  tags: const ['丽江', '大研古城', '纳西文化', '茶马古道', '水系'],
);

final jiangmenKaipingJourney = _record(
  id: 'jiangmen-kaiping-diaolou',
  title: '江门 · 开平碉楼：一座侨乡建筑里的跨海记忆',
  geoNodeId: 'cn-guangdong-jiangmen-kaiping-zili-village',
  paragraphs: _kaipingParagraphs,
  sources: const ['unesco-jiangmen-kaiping-diaolou', 'kaiping-government-zili-village'],
  tags: const ['江门', '开平碉楼', '自力村', '华侨', '世界遗产'],
);

final journeyExpansionBatchTwoRecords = <JourneyContentRecord>[
  datongYungangJourney,
  lijiangOldTownJourney,
  jiangmenKaipingJourney,
];

final journeyExpansionBatchTwoExperiences = <DailyJourneyExperience>[
  DailyJourneyExperience(
    id: datongYungangJourney.id,
    city: '大同',
    cityCode: 'DAT',
    place: '云冈石窟',
    appBarTitle: '大同 · 云冈石窟',
    storyTitle: '北魏石刻故事',
    headline: '听见刻进山崖的回声',
    description: '沿武州山崖壁观察洞窟、造像与文化交流留下的石刻细节。',
    discoveryTeaser: '为什么云冈造像能看见不同艺术传统的相遇？',
    distanceLabel: '1,620 km',
    stampSymbol: '云',
    content: datongYungangJourney,
    storyAnnotations: _datongAnnotations,
    words: _datongWords,
    discoveries: _datongDiscoveries,
    wonderQuestion: '如果只能选择一个细节记录云冈，你会画面容、手势、衣纹还是洞窟空间？为什么？',
    expressQuestion: '请用两到三句话描写砂岩、光线与造像形成的空间感。',
  ),
  DailyJourneyExperience(
    id: lijiangOldTownJourney.id,
    city: '丽江',
    cityCode: 'LJG',
    place: '大研古城',
    appBarTitle: '丽江 · 大研古城',
    storyTitle: '茶马古道故事',
    headline: '沿流水读懂山地城市',
    description: '跟随石板路与水道，理解古城如何连接地形、贸易与多民族生活。',
    discoveryTeaser: '没有规则棋盘格，丽江古城为什么仍能高效运作？',
    distanceLabel: '1,460 km',
    stampSymbol: '水',
    content: lijiangOldTownJourney,
    storyAnnotations: _lijiangAnnotations,
    words: _lijiangWords,
    discoveries: _lijiangDiscoveries,
    wonderQuestion: '如果你住在古城，你希望水道继续承担哪些日常功能？',
    expressQuestion: '请用两到三句话描写雨后石板路、流水与木屋的声音和光线。',
  ),
  DailyJourneyExperience(
    id: jiangmenKaipingJourney.id,
    city: '江门',
    cityCode: 'JMN',
    place: '开平碉楼',
    appBarTitle: '江门 · 开平碉楼',
    storyTitle: '侨乡建筑故事',
    headline: '一座碉楼里的跨海记忆',
    description: '穿过自力村稻田与荷塘，读懂碉楼如何连接防卫、生活与华侨记忆。',
    discoveryTeaser: '为什么岭南乡村会出现融合多种建筑风格的高楼？',
    distanceLabel: '760 km',
    stampSymbol: '侨',
    content: jiangmenKaipingJourney,
    storyAnnotations: _kaipingAnnotations,
    words: _kaipingWords,
    discoveries: _kaipingDiscoveries,
    wonderQuestion: '如果你从海外回乡建房，会保留哪一种家乡元素，又带回哪一种新设计？',
    expressQuestion: '请用两到三句话介绍碉楼、稻田与荷塘共同形成的侨乡景观。',
  ),
];
