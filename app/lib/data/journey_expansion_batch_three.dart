import '../models/story_content.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';

const journeyExpansionBatchThreeSources = <StorySourceRecord>[
  StorySourceRecord(
    id: 'unesco-dunhuang-mogao-caves',
    title: 'Mogao Caves',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/440',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-gansu-jiuquan-dunhuang-mogao-caves'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'dunhuang-academy-mogao-caves',
    title: '莫高窟概况',
    publisher: '敦煌研究院',
    url: 'https://www.dha.ac.cn/info/1425/3659.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-gansu-jiuquan-dunhuang-mogao-caves'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-chengde-mountain-resort',
    title: 'Mountain Resort and its Outlying Temples, Chengde',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/703',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-hebei-chengde-shuangqiao-mountain-resort'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'chengde-government-mountain-resort',
    title: '承德避暑山庄及周围寺庙',
    publisher: '承德市人民政府',
    url: 'https://www.chengde.gov.cn/art/2025/8/25/art_400_1080161.html',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-hebei-chengde-shuangqiao-mountain-resort'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'unesco-xiamen-kulangsu',
    title: 'Kulangsu, a Historic International Settlement',
    publisher: 'UNESCO World Heritage Centre',
    url: 'https://whc.unesco.org/en/list/1541',
    kind: StorySourceKind.unesco,
    languageCode: 'en',
    geoNodeIds: ['cn-fujian-xiamen-siming-kulangsu'],
    verificationStatus: StoryVerificationStatus.verified,
    accessedOn: '2026-07-29',
  ),
  StorySourceRecord(
    id: 'fujian-government-kulangsu',
    title: '鼓浪屿：历史国际社区',
    publisher: '福建省人民政府',
    url: 'https://fj.gov.cn/zwgk/ztzl/sxzygwzxsgzx/sdjj/wvjj/202408/t20240830_6508715.htm',
    kind: StorySourceKind.government,
    languageCode: 'zh-CN',
    geoNodeIds: ['cn-fujian-xiamen-siming-kulangsu'],
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

const _dunhuangParagraphs = <String>[
  '莫高窟数字记录员沙宁接到任务：风沙到来前补拍一处壁画裂隙。她的外祖父曾负责临摹这里的人物，她一直想把那幅最熟悉的画完整收入档案。',
  '洞窟砾岩不能精细雕刻，泥质造像和壁画又对光线、湿度极敏感。设备只剩半小时电量，沙宁发现相邻陌生图案正在起翘，只能在家族记忆与更紧急的损伤间选择。',
  '她把镜头转向起翘处，先完成定位与低光记录。风沙封闭崖壁时，熟悉的画仍缺一角，却有一处跨越丝绸之路的衣纹被及时纳入修复清单。',
  '沙宁后来把外祖父的旧临本与数字缺口并排存档。鸣沙山余脉下，商旅与信仰曾在此交汇并营造四百九十二个洞窟；守护不是占有完整画面，而是把证据交给下一双手。',
];

const _dunhuangAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'mò gāo kū shù zì jì lù yuán shā níng jiē dào rèn wu ： fēng shā dào lái qián bǔ pāi yí chù bì huà liè xì 。 tā de wài zǔ fù céng fù zé lín mó zhè lǐ de rén wù ， tā yì zhí xiǎng bǎ nà fú zuì shú xī de huà wán zhěng shōu rù dàng àn 。', vietnamese: 'Nhân viên số hóa Sa Ninh phải chụp bổ sung một vết nứt ở Mạc Cao trước khi gió cát đến. Ông ngoại cô từng sao chép nhân vật tại đây, và cô luôn muốn lưu trọn bức tranh quen thuộc ấy.', english: 'Digital recorder Sha Ning must photograph a Mogao mural crack before the sandstorm arrives. Her grandfather once copied its figures, and she has always wanted to preserve that familiar painting in full.'),
  ReadingAnnotation(pinyin: 'dòng kū lì yán bù néng jīng xì diāo kè ， ní zhì zào xiàng hé bì huà yòu duì guāng xiàn 、 shī dù jí mǐn gǎn 。 shè bèi zhī shèng bàn xiǎo shí diàn liàng ， shā níng fā xiàn xiāng lín mò shēng tú àn zhèng zài qǐ qiào ， zhǐ néng zài jiā zú jì yì yǔ gèng jǐn jí de sǔn shāng jiān xuǎn zé 。', vietnamese: 'Vách cuội kết không thể tạc tinh, còn tượng đất và bích họa rất nhạy với ánh sáng, độ ẩm. Thiết bị chỉ còn nửa giờ pin; cô thấy một họa tiết lạ bên cạnh đang bong và phải chọn giữa ký ức gia đình với hư hại cấp bách hơn.', english: 'The conglomerate cliff cannot hold fine carving, while clay figures and murals are highly sensitive to light and humidity. With thirty minutes of battery left, she finds an unfamiliar motif lifting nearby and must choose between family memory and the more urgent damage.'),
  ReadingAnnotation(pinyin: 'tā bǎ jìng tóu zhuǎn xiàng qǐ qiào chù ， xiān wán chéng dìng wèi yǔ dī guāng jì lù 。 fēng shā fēng bì yá bì shí ， shú xī de huà réng quē yì jiǎo ， què yǒu yí chù kuà yuè sī chóu zhī lù de yī wén bèi jí shí nà rù xiū fù qīng dān 。', vietnamese: 'Cô chuyển máy sang chỗ bong, hoàn tất định vị và ghi hình ánh sáng yếu trước. Khi gió cát đóng cửa vách, bức quen thuộc vẫn thiếu một góc, nhưng một nếp áo mang dấu giao lưu Con đường Tơ lụa đã kịp vào danh sách sửa.', english: 'She turns the camera to the lifting paint and completes its location and low-light record first. When sand closes the cliff, the familiar mural remains incomplete, but a Silk Road drapery detail has entered the repair list in time.'),
  ReadingAnnotation(pinyin: 'shā níng hòu lái bǎ wài zǔ fù de jiù lín běn yǔ shù zì quē kǒu bìng pái cún dàng 。 míng shā shān yú mài xià ， shāng lǚ yǔ xìn yǎng céng zài cǐ jiāo huì bìng yíng zào sì bǎi jiǔ shí èr gè dòng kū ； shǒu hù bú shì zhàn yǒu wán zhěng huà miàn ， ér shì bǎ zhèng jù jiāo gěi xià yì shuāng shǒu 。', vietnamese: 'Sau đó Sa Ninh lưu bản sao cũ của ông cạnh khoảng trống số. Dưới nhánh Minh Sa Sơn, thương nhân và tín ngưỡng từng gặp nhau tạo nên 492 hang; bảo vệ không phải sở hữu hình ảnh trọn vẹn mà chuyển bằng chứng cần nhất cho người sau.', english: 'Sha Ning later archives her grandfather\'s copy beside the digital gap. Beneath the Mingsha foothills, travelers and beliefs once met to create 492 caves; care means passing the most needed evidence onward, not possessing a complete image.'),
];

const _dunhuangWords = <WordEntry>[
  WordEntry(word: '余脉', pinyin: 'yúmài', partOfSpeech: '名词', simpleChinese: '大山延伸出来的山脉。', translation: 'Dãy núi kéo dài từ núi chính.', englishDefinition: 'outlying mountain range', symbol: '⛰️'),
  WordEntry(word: '崖壁', pinyin: 'yábì', partOfSpeech: '名词', simpleChinese: '陡直的山崖表面。', translation: 'Vách núi dựng đứng.', englishDefinition: 'cliff face', symbol: '🪨'),
  WordEntry(word: '砾岩', pinyin: 'lìyán', partOfSpeech: '名词', simpleChinese: '由小石块组成的岩石。', translation: 'Đá cuội kết.', englishDefinition: 'conglomerate rock', symbol: '🟤'),
  WordEntry(word: '造像', pinyin: 'zàoxiàng', partOfSpeech: '名词', simpleChinese: '塑造出来的人物形象。', translation: 'Tượng được tạo hình.', englishDefinition: 'sculpted figure', symbol: '🏺'),
  WordEntry(word: '壁画', pinyin: 'bìhuà', partOfSpeech: '名词', simpleChinese: '画在墙壁上的图画。', translation: 'Tranh tường.', englishDefinition: 'mural', symbol: '🎨'),
  WordEntry(word: '营造', pinyin: 'yíngzào', partOfSpeech: '动词', simpleChinese: '规划并建造。', translation: 'Quy hoạch và xây dựng.', englishDefinition: 'to build and create', symbol: '🛠️'),
  WordEntry(word: '商旅', pinyin: 'shānglǚ', partOfSpeech: '名词', simpleChinese: '旅行经商的人。', translation: 'Thương nhân lữ hành.', englishDefinition: 'travelling merchants', symbol: '🐫'),
  WordEntry(word: '交汇', pinyin: 'jiāohuì', partOfSpeech: '动词', simpleChinese: '从不同方向相遇。', translation: 'Gặp nhau từ nhiều hướng.', englishDefinition: 'to converge', symbol: '🔀'),
  WordEntry(word: '湿度', pinyin: 'shīdù', partOfSpeech: '名词', simpleChinese: '空气中水分的多少。', translation: 'Độ ẩm không khí.', englishDefinition: 'humidity', symbol: '💧'),
];

const _dunhuangDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '莫高窟保存四百九十二个洞窟，艺术营造跨越约一千年。', pinyin: 'Mògāo Kū bǎocún sìbǎi jiǔshí èr gè dòngkū, yìshù yíngzào kuàyuè yuē yì qiān nián.', simpleChinese: '这里有四百九十二个洞窟。', vietnamese: 'Mạc Cao lưu giữ 492 hang động qua khoảng một nghìn năm.', english: 'Mogao preserves 492 caves created across roughly a millennium.'),
  DiscoveryEntry(text: '砾岩崖壁不适合精细雕刻，因此工匠发展出泥质造像与壁画。', pinyin: 'Lìyán yábì bù shìhé jīngxì diāokè, yīncǐ gōngjiàng fāzhǎnchū nízhì zàoxiàng yǔ bìhuà.', simpleChinese: '岩石条件影响了艺术方法。', vietnamese: 'Đá cuội kết khiến nghệ nhân phát triển tượng đất và bích họa.', english: 'The conglomerate cliff encouraged clay sculpture and mural painting.'),
  DiscoveryEntry(text: '敦煌位于丝绸之路交汇处，商旅带来多种文化与信仰。', pinyin: 'Dūnhuáng wèiyú Sīchóu Zhīlù jiāohuìchù, shānglǚ dàilái duō zhǒng wénhuà yǔ xìnyǎng.', simpleChinese: '丝绸之路让不同文化在敦煌相遇。', vietnamese: 'Vị trí trên Con đường Tơ lụa đưa nhiều văn hóa và tín ngưỡng đến Đôn Hoàng.', english: 'Silk Road travellers brought diverse cultures and beliefs to Dunhuang.'),
  DiscoveryEntry(text: '环境监测与数字记录帮助研究者控制湿度、光线和风沙风险。', pinyin: 'Huánjìng jiāncè yǔ shùzì jìlù bāngzhù yánjiūzhě kòngzhì shīdù, guāngxiàn hé fēngshā fēngxiǎn.', simpleChinese: '科技参与洞窟保护。', vietnamese: 'Quan trắc và số hóa giúp kiểm soát độ ẩm, ánh sáng và cát gió.', english: 'Monitoring and digital records help manage humidity, light, and sand risks.'),
];

const _chengdeParagraphs = <String>[
  '园林修缮实习生杜青要替承德避暑山庄一座亭榭选补瓦。仓库里最亮的新瓦尺寸合适，旧瓦颜色相近却需要逐片检查；工程队等着她签字，薄雾已经漫过湖岸。',
  '杜青沿宫殿区、湖泊区和平原区反复观察，发现亭榭顺应山势，屋顶只是林木、坡地与远山视线中的一小部分。换成整齐亮瓦能赶工，却会让建筑压过自然。',
  '她选择停下一天，带工匠筛出可用旧瓦，只在受损处补配。延期使她挨了批评，完工后从湖对岸望去，亭顶仍安静藏在树影里。',
  '杜青在验收表上写下：修缮不是让屋顶显得更新，而是顺应地形，维护湖水、寺庙、植被、古建筑与远处山峦在历史格局中的轻重。',
];

const _chengdeAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'yuán lín xiū shàn shí xí shēng dù qīng yào tì chéng dé bì shǔ shān zhuāng yí zuò tíng xiè xuǎn bǔ wǎ 。 cāng kù lǐ zuì liàng de xīn wǎ chǐ cùn hé shì ， jiù wǎ yán sè xiàng jìn què xū yào zhú piàn jiǎn chá ； gōng chéng duì děng zhe tā qiān zì ， bó wù yǐ jīng màn guò hú àn 。', vietnamese: 'Thực tập sinh tu bổ Đỗ Thanh phải chọn ngói thay cho một thủy tạ ở Tị Thử Sơn Trang. Ngói mới sáng vừa kích thước, ngói cũ gần màu nhưng phải kiểm từng viên; đội thi công chờ chữ ký khi sương đã phủ bờ hồ.', english: 'Conservation intern Du Qing must choose replacement tiles for a pavilion at the Chengde Mountain Resort. Bright new tiles fit, while matching old ones require inspection; the crew awaits her signature as mist reaches the lakeshore.'),
  ReadingAnnotation(pinyin: 'dù qīng yán gōng diàn qū 、 hú bó qū hé píng yuán qū fǎn fù guān chá ， fā xiàn tíng xiè shùn yìng shān shì ， wū dǐng zhǐ shì lín mù 、 pō dì yǔ yuǎn shān shì xiàn zhōng de yì xiǎo bù fen 。 huàn chéng zhěng qí liàng wǎ néng gǎn gōng ， què huì ràng jiàn zhù yā guò zì rán 。', vietnamese: 'Đi qua khu cung điện, hồ và đồng bằng, cô thấy thủy tạ thuận theo thế núi, mái chỉ là phần nhỏ trong tầm nhìn của cây, sườn dốc và núi xa. Ngói sáng giúp kịp tiến độ nhưng sẽ lấn át tự nhiên.', english: 'Walking through palace, lake, and plain zones, she sees that the pavilion follows the terrain and its roof is only one part of a view of woods, slopes, and distant hills. Bright tiles meet the schedule but dominate the landscape.'),
  ReadingAnnotation(pinyin: 'tā xuǎn zé tíng xià yì tiān ， dài gōng jiàng shāi chū kě yòng jiù wǎ ， zhī zài shòu sǔn chù bǔ pèi 。 yán qī shǐ tā āi le pī píng ， wán gōng hòu cóng hú duì àn wàng qù ， tíng dǐng réng ān jìng cáng zài shù yǐng lǐ 。', vietnamese: 'Cô dừng một ngày, cùng thợ chọn ngói cũ còn dùng được và chỉ bổ chỗ hỏng. Cô bị phê bình vì chậm, nhưng từ bờ đối diện mái vẫn yên lặng trong bóng cây.', english: 'She pauses for a day, sorts reusable old tiles with the craftspeople, and repairs only damaged areas. She is criticized for delay, but from across the lake the roof still rests quietly in the trees.'),
  ReadingAnnotation(pinyin: 'dù qīng zài yàn shōu biǎo shàng xiě xià ： xiū shàn bú shì ràng wū dǐng xiǎn de gēng xīn ， ér shì shùn yìng dì xíng ， wéi hù hú shuǐ 、 sì miào 、 zhí bèi 、 gǔ jiàn zhù yǔ yuǎn chù shān luán zài lì shǐ gé jú zhōng de qīng zhòng 。', vietnamese: 'Đỗ Thanh ghi rằng tu bổ không phải làm mái trông mới hơn, mà là thuận địa hình và giữ đúng trọng lượng giữa hồ, chùa, cây cối, kiến trúc cổ cùng núi xa trong bố cục lịch sử.', english: 'Du Qing records that conservation does not make a roof look newer; it follows the terrain and preserves the balance among lake, temples, vegetation, historic buildings, and distant ridges.'),
];

const _chengdeWords = <WordEntry>[
  WordEntry(word: '薄雾', pinyin: 'bówù', partOfSpeech: '名词', simpleChinese: '比较淡的雾。', translation: 'Làn sương mỏng.', englishDefinition: 'light mist', symbol: '🌫️'),
  WordEntry(word: '亭榭', pinyin: 'tíngxiè', partOfSpeech: '名词', simpleChinese: '园林中的亭子和水边建筑。', translation: 'Đình và thủy tạ trong vườn.', englishDefinition: 'garden pavilions', symbol: '🏯'),
  WordEntry(word: '山势', pinyin: 'shānshì', partOfSpeech: '名词', simpleChinese: '山地高低变化的形态。', translation: 'Thế núi.', englishDefinition: 'mountain terrain', symbol: '⛰️'),
  WordEntry(word: '山峦', pinyin: 'shānluán', partOfSpeech: '名词', simpleChinese: '连续起伏的山。', translation: 'Những dãy núi nối tiếp.', englishDefinition: 'mountain ridges', symbol: '🗻'),
  WordEntry(word: '园林', pinyin: 'yuánlín', partOfSpeech: '名词', simpleChinese: '结合建筑和自然景色的园子。', translation: 'Vườn cảnh kết hợp kiến trúc và thiên nhiên.', englishDefinition: 'landscape garden', symbol: '🌿'),
  WordEntry(word: '地形', pinyin: 'dìxíng', partOfSpeech: '名词', simpleChinese: '地面的高低和形状。', translation: 'Địa hình.', englishDefinition: 'topography', symbol: '🗺️'),
  WordEntry(word: '寺庙', pinyin: 'sìmiào', partOfSpeech: '名词', simpleChinese: '进行宗教活动的建筑。', translation: 'Chùa, đền tôn giáo.', englishDefinition: 'temple', symbol: '🛕'),
  WordEntry(word: '修缮', pinyin: 'xiūshàn', partOfSpeech: '动词', simpleChinese: '修理并保护旧建筑。', translation: 'Tu bổ công trình cũ.', englishDefinition: 'to repair and conserve', symbol: '🧰'),
  WordEntry(word: '格局', pinyin: 'géjú', partOfSpeech: '名词', simpleChinese: '整体的结构和安排。', translation: 'Bố cục tổng thể.', englishDefinition: 'overall layout', symbol: '▦'),
];

const _chengdeDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '避暑山庄把宫殿、湖泊、平原与山峦组织成完整的皇家园林。', pinyin: 'Bìshǔ Shānzhuāng bǎ gōngdiàn, húpō, píngyuán yǔ shānluán zǔzhīchéng wánzhěng de huángjiā yuánlín.', simpleChinese: '四种景观组成一座大园林。', vietnamese: 'Cung điện, hồ, đồng bằng và núi đồi hợp thành một khu vườn hoàng gia.', english: 'Palace, lakes, plains, and mountains form one imperial landscape.'),
  DiscoveryEntry(text: '建筑顺应天然地形，使亭榭、道路与山水彼此连接。', pinyin: 'Jiànzhù shùnyìng tiānrán dìxíng, shǐ tíngxiè, dàolù yǔ shānshuǐ bǐcǐ liánjiē.', simpleChinese: '建筑跟着地形变化。', vietnamese: 'Kiến trúc thuận theo địa hình để nối đình, đường và cảnh quan.', english: 'Architecture follows the terrain, linking pavilions, paths, and scenery.'),
  DiscoveryEntry(text: '周围寺庙的多样形式记录了清代多民族交往。', pinyin: 'Zhōuwéi sìmiào de duōyàng xíngshì jìlù le Qīngdài duō mínzú jiāowǎng.', simpleChinese: '寺庙记录了不同文化的交流。', vietnamese: 'Nhiều hình thức chùa ghi lại giao lưu đa dân tộc thời Thanh.', english: 'The varied temples record multi-ethnic exchange during the Qing dynasty.'),
  DiscoveryEntry(text: '遗产保护同时关注古建筑修缮、生态环境与历史格局。', pinyin: 'Yíchǎn bǎohù tóngshí guānzhù gǔjiànzhù xiūshàn, shēngtài huánjìng yǔ lìshǐ géjú.', simpleChinese: '保护建筑，也保护周围环境。', vietnamese: 'Bảo tồn chú trọng cả tu bổ, sinh thái và bố cục lịch sử.', english: 'Heritage care includes buildings, ecology, and the historic layout.'),
];

const _xiamenParagraphs = <String>[
  '鼓浪屿邮递员林澈负责一条坡巷，榕树倒枝却封住了常走的石阶。当天有一封医院复诊通知必须送到独居老人手里，导航推荐的宽路却绕过老人真正居住的旧门牌。',
  '林澈沿红砖、花岗岩和廊柱寻找巷道肌理，问过学校门卫与老住户，才知道开港后多种社区名称曾在这里重叠。时间迫近，他必须选择相信标准地址，还是跟随居民记忆穿过狭窄侧巷。',
  '他推车改走侧巷，在一座由本地工匠调整过的折衷住宅后找到老人。通知及时送达，代价是当天其他邮件延误；林澈逐户解释，没有把责任推给复杂街路。',
  '海风再穿过榕树时，他在配送图上补回那条只容一人通过的小巷。保护生活社区不只保存漂亮立面，也要让仍在这里生活的人不从地图上消失。',
];

const _xiamenAnnotations = <ReadingAnnotation>[
  ReadingAnnotation(pinyin: 'gǔ làng yǔ yóu dì yuán lín chè fù zé yì tiáo pō xiàng ， róng shù dǎo zhī què fēng zhù le cháng zǒu de shí jiē 。 dāng tiān yǒu yì fēng yī yuàn fù zhěn tōng zhī bì xū sòng dào dú jū lǎo rén shǒu lǐ ， dǎo háng tuī jiàn de kuān lù què rào guò lǎo rén zhēn zhèng jū zhù de jiù mén pái 。', vietnamese: 'Bưu tá Lâm Triệt phụ trách một ngõ dốc trên đảo Cổ Lãng, nhưng cành đa đổ đã chặn bậc đá quen thuộc. Một giấy hẹn tái khám phải đến tay cụ già sống một mình hôm đó, còn bản đồ chỉ đường rộng lại bỏ qua số nhà cũ thật sự.', english: 'Postman Lin Che serves a hillside lane on Gulangyu, but a fallen banyan branch blocks the usual stone steps. A hospital follow-up notice must reach an elderly resident that day, while the mapped wide road bypasses the real old address.'),
  ReadingAnnotation(pinyin: 'lín chè yán hóng zhuān 、 huā gǎng yán hé láng zhù xún zhǎo hàng dào jī lǐ ， wèn guò xué xiào mén wèi yǔ lǎo zhù hù ， cái zhī dào kāi gǎng hòu duō zhǒng shè qū míng chēng céng zài zhè lǐ chóng dié 。 shí jiān pò jìn ， tā bì xū xuǎn zé xiāng xìn biāo zhǔn dì zhǐ ， hái shì gēn suí jū mín jì yì chuān guò xiá zhǎi cè xiàng 。', vietnamese: 'Anh lần theo cấu trúc ngõ qua gạch đỏ, đá hoa cương và hàng cột, hỏi bảo vệ trường cùng cư dân lâu năm. Nhiều tên cộng đồng từng chồng lên nhau sau khi mở cảng; anh phải chọn địa chỉ chuẩn hay ký ức cư dân trong ngõ hẹp.', english: 'He traces the lane through red brick, granite, and veranda columns, asking a school guard and longtime residents. Community names overlapped after the port opened; he must choose between the standard address and local memory in a narrow side lane.'),
  ReadingAnnotation(pinyin: 'tā tuī chē gǎi zǒu cè xiàng ， zài yí zuò yóu běn dì gōng jiàng tiáo zhěng guò de zhé zhōng zhù zhái hòu zhǎo dào lǎo rén 。 tōng zhī jí shí sòng dá ， dài jià shì dāng tiān qí tā yóu jiàn yán wù ； lín chè zhú hù jiě shì ， méi yǒu bǎ zé rèn tuī gěi fù zá jiē lù 。', vietnamese: 'Anh đẩy xe vào ngõ phụ và tìm thấy cụ già sau một ngôi nhà chiết trung do thợ địa phương điều chỉnh. Thông báo đến kịp, đổi lại thư khác bị chậm; anh giải thích từng nhà thay vì đổ lỗi cho đường phức tạp.', english: 'He pushes his bicycle through the side lane and finds the resident behind an eclectic house adapted by local builders. The notice arrives in time, while other mail is late; he explains the delay door by door rather than blaming the streets.'),
  ReadingAnnotation(pinyin: 'hǎi fēng zài chuān guò róng shù shí ， tā zài pèi sòng tú shàng bǔ huí nà tiáo zhī róng yì rén tōng guò de xiǎo xiàng 。 bǎo hù shēng huó shè qū bù zhī bǎo cún piào liang lì miàn ， yě yào ràng réng zài zhè lǐ shēng huó de rén bù cóng dì tú shàng xiāo shī 。', vietnamese: 'Khi gió biển lại qua tán đa, anh bổ sung con ngõ chỉ đủ một người vào bản đồ phát thư. Bảo vệ cộng đồng sống không chỉ là giữ mặt đứng đẹp mà còn không để người đang sống ở đó biến mất khỏi bản đồ.', english: 'When sea wind returns through the banyan leaves, he adds the one-person lane to his delivery map. Protecting a living community means more than preserving facades; its residents must not disappear from the map.'),
];

const _xiamenWords = <WordEntry>[
  WordEntry(word: '榕树', pinyin: 'róngshù', partOfSpeech: '名词', simpleChinese: '常见于温暖地区的大树。', translation: 'Cây đa nhiệt đới.', englishDefinition: 'banyan tree', symbol: '🌳'),
  WordEntry(word: '花岗岩', pinyin: 'huāgāngyán', partOfSpeech: '名词', simpleChinese: '坚硬的建筑石材。', translation: 'Đá hoa cương.', englishDefinition: 'granite', symbol: '🪨'),
  WordEntry(word: '廊柱', pinyin: 'lángzhù', partOfSpeech: '名词', simpleChinese: '走廊旁边的柱子。', translation: 'Cột bên hành lang.', englishDefinition: 'veranda column', symbol: '🏛️'),
  WordEntry(word: '开港', pinyin: 'kāigǎng', partOfSpeech: '动词', simpleChinese: '开放港口进行贸易往来。', translation: 'Mở cảng giao thương.', englishDefinition: 'to open a port', symbol: '⚓'),
  WordEntry(word: '社区', pinyin: 'shèqū', partOfSpeech: '名词', simpleChinese: '人们共同生活的区域。', translation: 'Cộng đồng dân cư.', englishDefinition: 'community', symbol: '🏘️'),
  WordEntry(word: '肌理', pinyin: 'jīlǐ', partOfSpeech: '名词', simpleChinese: '城市空间形成的纹理和结构。', translation: 'Cấu trúc và đường nét đô thị.', englishDefinition: 'urban fabric', symbol: '🧩'),
  WordEntry(word: '折衷', pinyin: 'zhézhōng', partOfSpeech: '形容词', simpleChinese: '结合不同方法或风格。', translation: 'Chiết trung, kết hợp nhiều phong cách.', englishDefinition: 'eclectic', symbol: '🔀'),
  WordEntry(word: '巷道', pinyin: 'xiàngdào', partOfSpeech: '名词', simpleChinese: '街区中的小路。', translation: 'Ngõ nhỏ trong khu phố.', englishDefinition: 'lane', symbol: '🛤️'),
  WordEntry(word: '立面', pinyin: 'lìmiàn', partOfSpeech: '名词', simpleChinese: '建筑外部正面的样子。', translation: 'Mặt đứng công trình.', englishDefinition: 'building facade', symbol: '🏠'),
];

const _xiamenDiscoveries = <DiscoveryEntry>[
  DiscoveryEntry(text: '厦门开港后，鼓浪屿在一九〇三年正式形成国际社区。', pinyin: 'Xiàmén kāigǎng hòu, Gǔlàngyǔ zài yījiǔlíngsān nián zhèngshì xíngchéng guójì shèqū.', simpleChinese: '鼓浪屿曾是一座国际社区。', vietnamese: 'Sau khi Hạ Môn mở cảng, đảo hình thành khu định cư quốc tế chính thức năm 1903.', english: 'Following Xiamen’s port opening, Kulangsu became a formal international settlement in 1903.'),
  DiscoveryEntry(text: '住宅与公共建筑共同保存历史社区的城市肌理。', pinyin: 'Zhùzhái yǔ gōnggòng jiànzhù gòngtóng bǎocún lìshǐ shèqū de chéngshì jīlǐ.', simpleChinese: '不同建筑一起组成社区。', vietnamese: 'Nhà ở và công trình công cộng cùng lưu giữ cấu trúc đô thị lịch sử.', english: 'Homes and public buildings preserve the historic urban fabric together.'),
  DiscoveryEntry(text: '本地工匠把闽南、南洋与西方形式转化为折衷建筑。', pinyin: 'Běndì gōngjiàng bǎ Mǐnnán, Nányáng yǔ Xīfāng xíngshì zhuǎnhuàwéi zhézhōng jiànzhù.', simpleChinese: '多种风格在岛上融合。', vietnamese: 'Thợ địa phương chuyển hóa các hình thức Mân Nam, Nam Dương và phương Tây thành kiến trúc chiết trung.', english: 'Local builders transformed Minnan, Nanyang, and Western forms into eclectic architecture.'),
  DiscoveryEntry(text: '步行巷道、榕树、花岗岩与海岸视线也是遗产环境的一部分。', pinyin: 'Bùxíng xiàngdào, róngshù, huāgāngyán yǔ hǎiàn shìxiàn yě shì yíchǎn huánjìng de yí bùfen.', simpleChinese: '街道、树木和海景都需要保护。', vietnamese: 'Ngõ đi bộ, cây đa, đá hoa cương và tầm nhìn biển đều thuộc môi trường di sản.', english: 'Walking lanes, banyans, granite, and coastal views all belong to the heritage setting.'),
];

final dunhuangMogaoJourney = _record(
  id: 'dunhuang-mogao-caves',
  title: '敦煌 · 莫高窟：在沙漠崖壁读一千年',
  geoNodeId: 'cn-gansu-jiuquan-dunhuang-mogao-caves',
  paragraphs: _dunhuangParagraphs,
  sources: const ['unesco-dunhuang-mogao-caves', 'dunhuang-academy-mogao-caves'],
  tags: const ['敦煌', '莫高窟', '丝绸之路', '壁画', '世界遗产'],
);

final chengdeMountainResortJourney = _record(
  id: 'chengde-mountain-resort',
  title: '承德 · 避暑山庄：让建筑藏进山水',
  geoNodeId: 'cn-hebei-chengde-shuangqiao-mountain-resort',
  paragraphs: _chengdeParagraphs,
  sources: const ['unesco-chengde-mountain-resort', 'chengde-government-mountain-resort'],
  tags: const ['承德', '避暑山庄', '皇家园林', '多民族交流', '世界遗产'],
);

final xiamenKulangsuJourney = _record(
  id: 'xiamen-kulangsu',
  title: '厦门 · 鼓浪屿：沿海风阅读一座国际社区',
  geoNodeId: 'cn-fujian-xiamen-siming-kulangsu',
  paragraphs: _xiamenParagraphs,
  sources: const ['unesco-xiamen-kulangsu', 'fujian-government-kulangsu'],
  tags: const ['厦门', '鼓浪屿', '国际社区', '建筑融合', '世界遗产'],
);

final journeyExpansionBatchThreeRecords = <JourneyContentRecord>[
  dunhuangMogaoJourney,
  chengdeMountainResortJourney,
  xiamenKulangsuJourney,
];

final journeyExpansionBatchThreeExperiences = <DailyJourneyExperience>[
  DailyJourneyExperience(
    id: dunhuangMogaoJourney.id,
    city: '敦煌',
    cityCode: 'DNH',
    place: '莫高窟',
    appBarTitle: '敦煌 · 莫高窟',
    storyTitle: '丝路洞窟故事',
    headline: '在沙漠崖壁读一千年',
    description: '沿宕泉河与崖壁理解洞窟艺术、丝路交流和现代保护。',
    discoveryTeaser: '为什么莫高窟多用泥塑与壁画，而不是直接雕刻？',
    distanceLabel: '2,100 km',
    stampSymbol: '敦',
    content: dunhuangMogaoJourney,
    storyAnnotations: _dunhuangAnnotations,
    words: _dunhuangWords,
    discoveries: _dunhuangDiscoveries,
    wonderQuestion: '如果你要为未来留下一幅壁画，会画旅途、城市、人物还是自然？为什么？',
    expressQuestion: '请用两到三句话描写晨光、崖壁与沙漠绿洲形成的层次。',
  ),
  DailyJourneyExperience(
    id: chengdeMountainResortJourney.id,
    city: '承德',
    cityCode: 'CDE',
    place: '避暑山庄',
    appBarTitle: '承德 · 避暑山庄',
    storyTitle: '皇家园林故事',
    headline: '让建筑藏进山水',
    description: '沿湖泊与山峦观察皇家园林如何连接自然、多民族文化和保护。',
    discoveryTeaser: '为什么山庄的宫殿没有压过山水？',
    distanceLabel: '1,770 km',
    stampSymbol: '山',
    content: chengdeMountainResortJourney,
    storyAnnotations: _chengdeAnnotations,
    words: _chengdeWords,
    discoveries: _chengdeDiscoveries,
    wonderQuestion: '如果你设计一条山庄路线，会先让人看见湖泊、亭榭、平原还是山峦？',
    expressQuestion: '请用两到三句话描写薄雾、湖面与亭榭共同形成的园林空间。',
  ),
  DailyJourneyExperience(
    id: xiamenKulangsuJourney.id,
    city: '厦门',
    cityCode: 'XMN',
    place: '鼓浪屿',
    appBarTitle: '厦门 · 鼓浪屿',
    storyTitle: '海岛社区故事',
    headline: '沿海风阅读国际社区',
    description: '穿过榕树与石阶，读懂海岛建筑、国际交往和生活社区。',
    discoveryTeaser: '为什么鼓浪屿的建筑很难归入单一风格？',
    distanceLabel: '390 km',
    stampSymbol: '岛',
    content: xiamenKulangsuJourney,
    storyAnnotations: _xiamenAnnotations,
    words: _xiamenWords,
    discoveries: _xiamenDiscoveries,
    wonderQuestion: '如果一座老房子能讲述一次文化相遇，你最想听建筑材料、居民还是海港的故事？',
    expressQuestion: '请用两到三句话描写榕树、石阶、老建筑与海面之间的关系。',
  ),
];
