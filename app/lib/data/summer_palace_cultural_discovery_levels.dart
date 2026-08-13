import '../models/language_proficiency.dart';
import 'journey_data.dart';

const summerPalaceUnescoSourceId = 'unesco-summer-palace-880';
const summerPalaceOverviewSourceId = 'beijing-parks-summer-palace-overview';
const summerPalaceBridgeSourceId = 'beijing-parks-seventeen-arch-bridge';
const summerPalaceWinterLightSourceId =
    'beijing-parks-seventeen-arch-winter-light';

class SummerPalaceDiscoveryUnit {
  const SummerPalaceDiscoveryUnit({
    required this.learnerQuestion,
    required this.newFactOrConcept,
    required this.sourceIds,
    required this.whyDistinct,
    required this.storyBridge,
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final String learnerQuestion;
  final String newFactOrConcept;
  final List<String> sourceIds;
  final String whyDistinct;
  final String storyBridge;
  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;

  DiscoveryEntry get entry => DiscoveryEntry(
        text: chinese,
        simpleChinese: chinese,
        pinyin: pinyin,
        vietnamese: vietnamese,
        english: english,
      );
}

const summerPalaceDiscoveryDepthMatrix = <int, int>{
  1: 2,
  2: 2,
  3: 2,
  4: 2,
  5: 3,
  6: 3,
  7: 3,
  8: 3,
  9: 3,
  10: 3,
};

const summerPalaceDiscoveryUnitsByLevel =
    <int, List<SummerPalaceDiscoveryUnit>>{
  1: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '颐和园最基本的山水框架是什么？',
      newFactOrConcept: '万寿山与昆明湖构成颐和园的基本山水框架。',
      sourceIds: [summerPalaceUnescoSourceId, summerPalaceOverviewSourceId],
      whyDistinct: '回答地点的自然骨架，不讲建筑功能。',
      storyBridge: '许澄的镜头始终在湖、山与建筑之间取舍。',
      chinese: '万寿山和昆明湖构成颐和园最基本的山水框架。山与湖不是两个分开的景点，而是理解整座园林的起点。',
      pinyin: 'Wànshòu Shān hé Kūnmíng Hú gòuchéng Yíhéyuán zuì jīběn de shānshuǐ kuàngjià. Shān yǔ hú bú shì liǎng gè fēnkāi de jǐngdiǎn, ér shì lǐjiě zhěng zuò yuánlín de qǐdiǎn.',
      vietnamese: 'Núi Vạn Thọ và hồ Côn Minh tạo nên khung sơn thủy cơ bản nhất của Di Hòa Viên. Núi và hồ không phải hai điểm tham quan tách rời mà là điểm khởi đầu để hiểu toàn bộ khu vườn.',
      english: 'Longevity Hill and Kunming Lake form the Summer Palace’s basic landscape framework. They are not two separate sights but the starting point for understanding the garden as a whole.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '自然山水之外，皇家园林还有什么？',
      newFactOrConcept: '亭台、殿堂、寺庙、桥梁等人工要素与自然山水共同形成整体。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '回答自然与人工怎样共同组成皇家园林。',
      storyBridge: '许澄不能只拍湖山，也会经过长廊与十七孔桥。',
      chinese: '颐和园把自然山水与亭台、殿堂、寺庙、桥梁等人工要素组织在同一个皇家园林景观中。它的价值来自这些部分之间的整体关系。',
      pinyin: 'Yíhéyuán bǎ zìrán shānshuǐ yǔ tíngtái, diàntáng, sìmiào, qiáoliáng děng réngōng yàosù zǔzhī zài tóng yí gè huángjiā yuánlín jǐngguān zhōng. Tā de jiàzhí láizì zhèxiē bùfen zhījiān de zhěngtǐ guānxì.',
      vietnamese: 'Di Hòa Viên tổ chức cảnh quan tự nhiên cùng đình đài, điện đường, chùa miếu, cầu và các yếu tố nhân tạo trong một tổng thể vườn hoàng gia. Giá trị của nơi này đến từ quan hệ giữa các phần ấy.',
      english: 'The Summer Palace organizes natural scenery together with pavilions, halls, temples, bridges, and other built elements as one imperial-garden landscape. Its value lies in the relationships among those parts.',
    ),
  ],
  2: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '颐和园是自然风景还是建筑群？',
      newFactOrConcept: '两者都不是单独答案，山水与建筑共同构成完整园林。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '明确整体关系，避免把园林拆成自然或建筑二选一。',
      storyBridge: '许澄的“无瑕照片”必须面对自然与人工同时进入画面的现实。',
      chinese: '颐和园既不能只理解成湖山风景，也不能只理解成建筑群。自然地形、水面和人工建筑共同形成完整的皇家园林。',
      pinyin: 'Yíhéyuán jì bù néng zhǐ lǐjiě chéng húshān fēngjǐng, yě bù néng zhǐ lǐjiě chéng jiànzhùqún. Zìrán dìxíng, shuǐmiàn hé réngōng jiànzhù gòngtóng xíngchéng wánzhěng de huángjiā yuánlín.',
      vietnamese: 'Di Hòa Viên không thể chỉ được hiểu là phong cảnh hồ núi, cũng không thể chỉ được hiểu là một quần thể kiến trúc. Địa hình tự nhiên, mặt nước và công trình nhân tạo cùng tạo thành khu vườn hoàng gia hoàn chỉnh.',
      english: 'The Summer Palace is neither merely a lake-and-hill landscape nor merely a group of buildings. Natural terrain, water, and built structures together form the complete imperial garden.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '同一座园林为什么需要不同空间？',
      newFactOrConcept: 'UNESCO记录颐和园包含政治行政、居住、精神和游憩等不同功能。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '从功能解释空间差异，不重复自然人工关系。',
      storyBridge: '人物沿路线移动时会遇到不同类型的空间，而不是固定在一个观景台。',
      chinese: '颐和园并非只用于观景。UNESCO资料指出，它包含政治行政、居住、精神和游憩等不同功能，这些功能共同存在于湖山园林之中。',
      pinyin: 'Yíhéyuán bìngfēi zhǐ yòngyú guānjǐng. UNESCO zīliào zhǐchū, tā bāohán zhèngzhì xíngzhèng, jūzhù, jīngshén hé yóuqì děng bùtóng gōngnéng, zhèxiē gōngnéng gòngtóng cúnzài yú húshān yuánlín zhī zhōng.',
      vietnamese: 'Di Hòa Viên không chỉ dùng để ngắm cảnh. Tư liệu UNESCO cho biết nơi đây có các chức năng chính trị-hành chính, cư trú, tinh thần và giải trí, cùng tồn tại trong cảnh quan hồ núi.',
      english: 'The Summer Palace was not solely for viewing scenery. UNESCO records political-administrative, residential, spiritual, and recreational functions coexisting within its lake-and-hill landscape.',
    ),
  ],
  3: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '颐和园最早何时形成，又经历了什么破坏？',
      newFactOrConcept: '1750年建成，1860年遭受严重破坏。',
      sourceIds: [summerPalaceUnescoSourceId, summerPalaceOverviewSourceId],
      whyDistinct: '先建立建造与损毁的时间层次。',
      storyBridge: '旧照片上的历史日期让“痕迹”具有真实地点历史。',
      chinese: '颐和园始建于一七五〇年，一八六〇年遭受严重破坏。今天看到的园林因此不是一段没有中断的“原样保存”。',
      pinyin: 'Yíhéyuán shǐjiàn yú yī qī wǔ líng nián, yī bā liù líng nián zāoshòu yánzhòng pòhuài. Jīntiān kàndào de yuánlín yīncǐ bú shì yí duàn méiyǒu zhōngduàn de “yuányàng bǎocún”.',
      vietnamese: 'Di Hòa Viên được khởi dựng năm 1750 và bị phá hoại nghiêm trọng năm 1860. Vì thế khu vườn ngày nay không phải là một trạng thái “giữ nguyên bản” hoàn toàn không bị gián đoạn.',
      english: 'The Summer Palace was first built in 1750 and suffered severe destruction in 1860. What survives today is therefore not an uninterrupted state of “original preservation.”',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '破坏之后的颐和园怎样继续存在？',
      newFactOrConcept: '1886年在原有基础上修复，形成可读的历史层次。',
      sourceIds: [summerPalaceUnescoSourceId, summerPalaceOverviewSourceId],
      whyDistinct: '回答损毁之后的修复阶段。',
      storyBridge: '周岚的旧照片把“受损—修复”转化为人物手中的物件。',
      chinese: '一八八六年，颐和园在原有基础上重新修复。建造、损毁和修复共同构成今天理解这处遗产时不能忽略的历史层次。',
      pinyin: 'Yī bā bā liù nián, Yíhéyuán zài yuányǒu jīchǔ shàng chóngxīn xiūfù. Jiànzào, sǔnhuǐ hé xiūfù gòngtóng gòuchéng jīntiān lǐjiě zhè chù yíchǎn shí bù néng hūlüè de lìshǐ céngcì.',
      vietnamese: 'Năm 1886, Di Hòa Viên được phục hồi trên nền tảng vốn có. Xây dựng, hư hại và phục hồi cùng tạo thành những lớp lịch sử không thể bỏ qua khi hiểu di sản hôm nay.',
      english: 'In 1886 the Summer Palace was restored on its existing foundations. Construction, destruction, and restoration together form historical layers that matter to understanding the property today.',
    ),
  ],
  4: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '长廊在山湖之间处于什么位置？',
      newFactOrConcept: '北京官方资料把长廊置于万寿山南麓、面向昆明湖的园林关系中。',
      sourceIds: [summerPalaceOverviewSourceId],
      whyDistinct: '回答长廊的位置与行走视点，不讲借景来源。',
      storyBridge: '周岚在长廊中停步，许澄加快脚步，空间直接改变两人的节奏。',
      chinese: '长廊位于万寿山南麓、临近昆明湖。沿长廊移动时，观看者的位置持续变化，因此湖、山和建筑并不是从一个固定点一次看完。',
      pinyin: 'Chángláng wèiyú Wànshòu Shān nánlù, línjìn Kūnmíng Hú. Yán Chángláng yídòng shí, guānkànzhě de wèizhi chíxù biànhuà, yīncǐ hú, shān hé jiànzhù bìng bú shì cóng yí gè gùdìng diǎn yí cì kàn wán.',
      vietnamese: 'Trường Lang nằm ở chân phía nam núi Vạn Thọ, gần hồ Côn Minh. Khi di chuyển dọc hành lang, vị trí người xem liên tục thay đổi, vì vậy hồ, núi và công trình không được nhìn hết từ một điểm cố định.',
      english: 'The Long Corridor lies at the southern foot of Longevity Hill near Kunming Lake. As a visitor moves through it, the viewing position keeps changing, so lake, hill, and architecture are not absorbed from one fixed point.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '为什么“路线”本身会影响观看？',
      newFactOrConcept: '长廊、湖岸与园林节点让不同景物按移动顺序进入视野。',
      sourceIds: [summerPalaceOverviewSourceId, summerPalaceUnescoSourceId],
      whyDistinct: '回答移动顺序，不重复长廊地理位置。',
      storyBridge: '许澄想摆脱外婆的步速，路线因此成为关系压力。',
      chinese: '从长廊向湖区移动，建筑、湖面和万寿山会在不同位置先后进入视野。颐和园的观看因此与人的路线和停步位置有关。',
      pinyin: 'Cóng Chángláng xiàng húqū yídòng, jiànzhù, húmiàn hé Wànshòu Shān huì zài bùtóng wèizhi xiānhòu jìnrù shìyě. Yíhéyuán de guānkàn yīncǐ yǔ rén de lùxiàn hé tíngbù wèizhi yǒuguān.',
      vietnamese: 'Khi đi từ Trường Lang về khu hồ, công trình, mặt nước và núi Vạn Thọ lần lượt đi vào tầm nhìn ở những vị trí khác nhau. Vì thế việc ngắm Di Hòa Viên gắn với tuyến đi và nơi người xem dừng lại.',
      english: 'Moving from the Long Corridor toward the lake brings architecture, water, and Longevity Hill into view in sequence. Seeing the Summer Palace is therefore connected to route and stopping position.',
    ),
  ],
  5: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '颐和园的借景具体借了什么？',
      newFactOrConcept: '北京官方资料称玉泉山和香山是颐和园不可或缺的借景。',
      sourceIds: [summerPalaceOverviewSourceId],
      whyDistinct: '用官方地点实例说明借景，不给抽象教科书定义。',
      storyBridge: '许澄从“把所有东西塞进画面”转向注意远近关系。',
      chinese: '北京官方资料把园外的玉泉山和香山称为颐和园“不可或缺的借景”。这说明园林的视觉范围可以超过自身边界。',
      pinyin: 'Běijīng guānfāng zīliào bǎ yuánwài de Yùquán Shān hé Xiāng Shān chēngwéi Yíhéyuán “bùkě huòquē de jièjǐng”. Zhè shuōmíng yuánlín de shìjué fànwéi kěyǐ chāoguò zìshēn biānjiè.',
      vietnamese: 'Tư liệu chính thức của Bắc Kinh gọi núi Ngọc Tuyền và Hương Sơn bên ngoài vườn là những cảnh vay mượn “không thể thiếu” của Di Hòa Viên. Điều đó cho thấy phạm vi thị giác của khu vườn có thể vượt qua ranh giới của chính nó.',
      english: 'Official Beijing material calls Yuquan Mountain and Fragrant Hills outside the garden “indispensable borrowed scenery” for the Summer Palace. The garden’s visual field can therefore extend beyond its own boundary.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '借景为什么不是简单增加一座建筑？',
      newFactOrConcept: '借景依赖既有视线与远景关系，而非把远山搬进园内。',
      sourceIds: [summerPalaceOverviewSourceId],
      whyDistinct: '解释借景的关系性。',
      storyBridge: '人物通过移动和构图改变哪些远景进入画面。',
      chinese: '借景不是把远处的山“搬进”园内，而是通过园内位置和视线，让园外景物参与眼前的构图。关键是空间关系，而不是新增物体。',
      pinyin: 'Jièjǐng bú shì bǎ yuǎnchù de shān “bān jìn” yuánnèi, ér shì tōngguò yuánnèi wèizhi hé shìxiàn, ràng yuánwài jǐngwù cānyù yǎnqián de gòutú. Guānjiàn shì kōngjiān guānxì, ér bú shì xīnzēng wùtǐ.',
      vietnamese: 'Mượn cảnh không phải là “đưa” ngọn núi xa vào trong vườn, mà dùng vị trí và đường nhìn trong vườn để cảnh bên ngoài tham gia bố cục trước mắt. Điều cốt lõi là quan hệ không gian, không phải thêm một vật thể.',
      english: 'Borrowed scenery does not move a distant mountain into the garden. Positions and sightlines within the garden allow outside scenery to participate in the composition. The key is spatial relationship, not adding an object.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '园内山湖和园外借景怎样一起形成层次？',
      newFactOrConcept: '万寿山、昆明湖构成内部框架，外部山体扩展远景层次。',
      sourceIds: [summerPalaceOverviewSourceId, summerPalaceUnescoSourceId],
      whyDistinct: '综合内部框架与外部远景，但不重复前两单元。',
      storyBridge: '许澄的构图从“全部清晰”转向近、中、远关系。',
      chinese: '万寿山和昆明湖提供园内的主要山水框架，玉泉山和香山等园外远景又把视线向外延伸。近处园景与远处山体因此形成不同空间层次。',
      pinyin: 'Wànshòu Shān hé Kūnmíng Hú tígōng yuánnèi de zhǔyào shānshuǐ kuàngjià, Yùquán Shān hé Xiāng Shān děng yuánwài yuǎnjǐng yòu bǎ shìxiàn xiàngwài yánshēn. Jìnchù yuánjǐng yǔ yuǎnchù shāntǐ yīncǐ xíngchéng bùtóng kōngjiān céngcì.',
      vietnamese: 'Núi Vạn Thọ và hồ Côn Minh tạo khung sơn thủy chính bên trong vườn, còn các cảnh xa ngoài vườn như núi Ngọc Tuyền và Hương Sơn kéo đường nhìn ra xa. Cảnh gần và núi xa vì thế tạo thành các lớp không gian khác nhau.',
      english: 'Longevity Hill and Kunming Lake provide the garden’s internal framework, while outside views such as Yuquan Mountain and Fragrant Hills extend the sightline. Near garden scenery and distant mountains create different spatial layers.',
    ),
  ],
  6: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '十七孔桥连接哪里？',
      newFactOrConcept: '桥东接东堤，西连南湖岛。',
      sourceIds: [summerPalaceBridgeSourceId, summerPalaceUnescoSourceId],
      whyDistinct: '回答桥的两端，是最基本空间事实。',
      storyBridge: '许澄等待光线的地点由真实湖桥关系限定。',
      chinese: '十七孔桥位于昆明湖上，东接东堤，西连南湖岛。它不是孤立的桥，而是湖区路线中的重要连接。',
      pinyin: 'Shíqīkǒng Qiáo wèiyú Kūnmíng Hú shàng, dōng jiē Dōngdī, xī lián Nánhú Dǎo. Tā bú shì gūlì de qiáo, ér shì húqū lùxiàn zhōng de zhòngyào liánjiē.',
      vietnamese: 'Cầu Thập Thất Khổng nằm trên hồ Côn Minh, nối đê Đông ở phía đông và đảo Nam Hồ ở phía tây. Nó không phải một cây cầu cô lập mà là một kết nối quan trọng trong tuyến đi của khu hồ.',
      english: 'The Seventeen-Arch Bridge crosses Kunming Lake, linking the East Dike on the east with Nanhu Island on the west. It is not an isolated bridge but an important connection in the lake area.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '桥为什么也是湖区整体的一部分？',
      newFactOrConcept: '桥把岛、堤和水面组织为可通行的空间关系。',
      sourceIds: [summerPalaceBridgeSourceId, summerPalaceUnescoSourceId],
      whyDistinct: '从两端事实进一步解释整体关系。',
      storyBridge: '人物的站位和移动因桥、堤、岛的位置而具体。',
      chinese: '十七孔桥把南湖岛与东堤连接起来，使岛、堤和昆明湖水面形成可移动、可观看的空间关系。理解桥也要理解它所连接的两端。',
      pinyin: 'Shíqīkǒng Qiáo bǎ Nánhú Dǎo yǔ Dōngdī liánjiē qǐlái, shǐ dǎo, dī hé Kūnmíng Hú shuǐmiàn xíngchéng kě yídòng, kě guānkàn de kōngjiān guānxì. Lǐjiě qiáo yě yào lǐjiě tā suǒ liánjiē de liǎng duān.',
      vietnamese: 'Cầu Thập Thất Khổng nối đảo Nam Hồ với đê Đông, khiến đảo, đê và mặt hồ Côn Minh tạo thành một quan hệ không gian vừa có thể di chuyển vừa có thể quan sát. Hiểu cây cầu cũng cần hiểu hai đầu mà nó nối.',
      english: 'The Seventeen-Arch Bridge links Nanhu Island with the East Dike, organizing island, dike, and lake surface into a spatial relationship for movement and viewing. Understanding the bridge requires understanding both ends.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '怎样从一座桥读出路线？',
      newFactOrConcept: '观察桥的两端及其连接对象，可以把单体建筑放回园林系统。',
      sourceIds: [summerPalaceBridgeSourceId],
      whyDistinct: '提供观察方法而不新增未经证实事实。',
      storyBridge: '故事中的“站哪里”不再是任意摄影位置。',
      chinese: '观察十七孔桥时，可以先问桥的两端分别通向哪里。东堤、桥和南湖岛连成一条实际空间关系，桥的意义因此超出自身形状。',
      pinyin: 'Guānchá Shíqīkǒng Qiáo shí, kěyǐ xiān wèn qiáo de liǎng duān fēnbié tōngxiàng nǎlǐ. Dōngdī, qiáo hé Nánhú Dǎo liánchéng yì tiáo shíjì kōngjiān guānxì, qiáo de yìyì yīncǐ chāochū zìshēn xíngzhuàng.',
      vietnamese: 'Khi quan sát cầu Thập Thất Khổng, có thể hỏi trước hai đầu cầu dẫn đi đâu. Đê Đông, cây cầu và đảo Nam Hồ tạo thành một quan hệ không gian thực, nên ý nghĩa của cầu vượt ra ngoài hình dáng riêng của nó.',
      english: 'When reading the Seventeen-Arch Bridge, first ask where its two ends lead. The East Dike, bridge, and Nanhu Island form a real spatial relationship, so the bridge means more than its own shape.',
    ),
  ],
  7: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '“金光穿洞”大约何时出现？',
      newFactOrConcept: '北京官方资料记录，从11月下旬到冬至前后，晴朗傍晚可见桥洞逐渐被夕阳照亮。',
      sourceIds: [summerPalaceWinterLightSourceId],
      whyDistinct: '回答季节与时间窗口。',
      storyBridge: '这就是许澄等待一下午、失去后无法重来的具体机会。',
      chinese: '北京官方资料记录，从十一月下旬到冬至前后，晴朗傍晚的夕阳会逐渐照亮十七孔桥的桥洞，形成著名的“金光穿洞”景观。',
      pinyin: 'Běijīng guānfāng zīliào jìlù, cóng shíyī yuè xiàxún dào dōngzhì qiánhòu, qínglǎng bàngwǎn de xīyáng huì zhújiàn zhàoliàng Shíqīkǒng Qiáo de qiáodòng, xíngchéng zhùmíng de “jīnguāng chuān dòng” jǐngguān.',
      vietnamese: 'Tư liệu chính thức của Bắc Kinh ghi nhận rằng từ cuối tháng 11 đến khoảng tiết Đông chí, vào những buổi chiều quang đãng, nắng hoàng hôn dần chiếu sáng các vòm cầu Thập Thất Khổng, tạo nên cảnh “ánh vàng xuyên vòm” nổi tiếng.',
      english: 'Official Beijing material records that from late November to around the winter solstice, clear-evening sunlight gradually illuminates the Seventeen-Arch Bridge arches, creating the famous “golden light through the arches” view.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '为什么冬至前后的角度特别重要？',
      newFactOrConcept: '桥体大致西北—东南走向，冬至前后落日位置偏西南且角度较低，光可进入桥洞东侧内壁。',
      sourceIds: [summerPalaceWinterLightSourceId],
      whyDistinct: '解释现象的空间与太阳角度机制。',
      storyBridge: '光线移动速度制造Choice的物理压力。',
      chinese: '十七孔桥大致呈西北—东南走向。冬至前后落日位置偏西南、角度较低，夕阳可以照进桥洞东侧内壁；这是一种季节、方向和太阳高度共同形成的现象。',
      pinyin: 'Shíqīkǒng Qiáo dàzhì chéng xīběi—dōngnán zǒuxiàng. Dōngzhì qiánhòu luòrì wèizhi piān xīnán, jiǎodù jiào dī, xīyáng kěyǐ zhàojìn qiáodòng dōngcè nèibì; zhè shì yì zhǒng jìjié, fāngxiàng hé tàiyáng gāodù gòngtóng xíngchéng de xiànxiàng.',
      vietnamese: 'Cầu Thập Thất Khổng có hướng gần tây bắc–đông nam. Quanh Đông chí, mặt trời lặn lệch về tây nam và ở góc thấp, nên ánh nắng có thể chiếu vào mặt trong phía đông của các vòm; hiện tượng này hình thành từ mùa, hướng cầu và độ cao mặt trời cùng lúc.',
      english: 'The Seventeen-Arch Bridge runs roughly northwest to southeast. Around the winter solstice, the sunset lies far to the southwest at a low angle, allowing light to reach the eastern inner walls of the arches. Season, orientation, and solar altitude work together.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '观看这个现象为什么也和站位有关？',
      newFactOrConcept: '北京官方资料推荐从西北方向观察，说明同一座桥的季节光影也受观看位置影响。',
      sourceIds: [summerPalaceWinterLightSourceId],
      whyDistinct: '从时间和成因转向观看位置。',
      storyBridge: '许澄特意绕到西北方向等候，因此照片掉落发生在不可随意替换的站位。',
      chinese: '北京官方资料指出，从十七孔桥西北方向观看这一季节性光影较为有利。同一座桥在不同季节、时刻和站位下，会呈现不同的观看结果。',
      pinyin: 'Běijīng guānfāng zīliào zhǐchū, cóng Shíqīkǒng Qiáo xīběi fāngxiàng guānkàn zhè yī jìjiéxìng guāngyǐng jiàowéi yǒulì. Tóng yí zuò qiáo zài bùtóng jìjié, shíkè hé zhànwèi xià, huì chéngxiàn bùtóng de guānkàn jiéguǒ.',
      vietnamese: 'Tư liệu chính thức của Bắc Kinh cho biết quan sát hiện tượng ánh sáng theo mùa này từ phía tây bắc cầu Thập Thất Khổng là thuận lợi hơn. Cùng một cây cầu có thể cho kết quả nhìn khác nhau tùy mùa, thời điểm và vị trí đứng.',
      english: 'Official Beijing material notes that the seasonal light is favorably viewed from the northwest side of the Seventeen-Arch Bridge. The same bridge can look different depending on season, time, and viewing position.',
    ),
  ],
  8: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '颐和园为什么不能只按“景点清单”理解？',
      newFactOrConcept: '不同功能空间与山湖框架共同组成系统。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '从单点转向功能系统。',
      storyBridge: '人物的移动跨越不同空间，地点不再是拍照背景。',
      chinese: '颐和园把政治行政、居住、精神和游憩等不同功能放进同一套山水园林系统。理解它不能只数建筑，还要看这些空间怎样与湖山和路线发生关系。',
      pinyin: 'Yíhéyuán bǎ zhèngzhì xíngzhèng, jūzhù, jīngshén hé yóuqì děng bùtóng gōngnéng fàngjìn tóng yí tào shānshuǐ yuánlín xìtǒng. Lǐjiě tā bù néng zhǐ shǔ jiànzhù, hái yào kàn zhèxiē kōngjiān zěnyàng yǔ húshān hé lùxiàn fāshēng guānxì.',
      vietnamese: 'Di Hòa Viên đặt các chức năng chính trị-hành chính, cư trú, tinh thần và giải trí trong cùng một hệ thống vườn sơn thủy. Hiểu nơi này không thể chỉ đếm công trình mà còn phải xem các không gian liên hệ với hồ núi và tuyến đi ra sao.',
      english: 'The Summer Palace places political-administrative, residential, spiritual, and recreational functions within one landscape system. Understanding it requires more than listing buildings; it requires seeing how spaces relate to lake, hill, and routes.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '廊道在大型园林系统中能做什么？',
      newFactOrConcept: 'UNESCO描述有覆盖廊道连接居住区域并通向长廊相关空间。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '聚焦连接功能，不重复长廊的观看节奏。',
      storyBridge: '周岚和许澄的行走不是随机漫步，而是在被连接的空间中推进。',
      chinese: 'UNESCO资料描述，颐和园的覆盖廊道连接居住区域，并与通向长廊的空间相接。廊道既是建筑，也参与组织人的移动。',
      pinyin: 'UNESCO zīliào miáoshù, Yíhéyuán de fùgài lángdào liánjiē jūzhù qūyù, bìng yǔ tōngxiàng Chángláng de kōngjiān xiāngjiē. Lángdào jì shì jiànzhù, yě cānyù zǔzhī rén de yídòng.',
      vietnamese: 'Tư liệu UNESCO mô tả các hành lang có mái che của Di Hòa Viên nối khu cư trú và liên kết với không gian dẫn tới Trường Lang. Hành lang vừa là kiến trúc vừa tham gia tổ chức sự di chuyển của con người.',
      english: 'UNESCO describes covered corridors connecting residential areas and linking with spaces leading toward the Long Corridor. Corridors are architecture, but they also organize movement.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '怎样把功能、路线和景观看成一个整体？',
      newFactOrConcept: '山、水、建筑、寺庙、桥梁与移动路线共同工作。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '综合系统关系，而非再讲某一单体。',
      storyBridge: 'Story中的长廊、湖岸与桥形成连续行动链。',
      chinese: '在颐和园，山、水、建筑、寺庙和桥梁不是互不相关的对象。它们与人的移动路线一起构成更大的园林系统，功能和景观因此可以同时被阅读。',
      pinyin: 'Zài Yíhéyuán, shān, shuǐ, jiànzhù, sìmiào hé qiáoliáng bú shì hù bù xiāngguān de duìxiàng. Tāmen yǔ rén de yídòng lùxiàn yìqǐ gòuchéng gèng dà de yuánlín xìtǒng, gōngnéng hé jǐngguān yīncǐ kěyǐ tóngshí bèi yuèdú.',
      vietnamese: 'Ở Di Hòa Viên, núi, nước, công trình, chùa miếu và cầu không phải những đối tượng không liên quan. Chúng cùng tuyến di chuyển của con người tạo thành một hệ thống vườn lớn hơn, để chức năng và cảnh quan có thể được đọc đồng thời.',
      english: 'At the Summer Palace, hills, water, buildings, temples, and bridges are not unrelated objects. Together with movement routes they form a larger garden system in which function and landscape can be read at the same time.',
    ),
  ],
  9: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '昆明湖里的岛怎样与岸线连接？',
      newFactOrConcept: '湖中有三座大岛，南部南湖岛通过十七孔桥与东堤相连。',
      sourceIds: [summerPalaceUnescoSourceId, summerPalaceBridgeSourceId],
      whyDistinct: '建立岛屿与东岸连接。',
      storyBridge: '十七孔桥由摄影对象变成湖区结构的一部分。',
      chinese: 'UNESCO资料指出，昆明湖中有三座较大的岛。南部的南湖岛通过十七孔桥与东堤相连，因此岛屿、桥和岸线共同参与湖区空间组织。',
      pinyin: 'UNESCO zīliào zhǐchū, Kūnmíng Hú zhōng yǒu sān zuò jiào dà de dǎo. Nánbù de Nánhú Dǎo tōngguò Shíqīkǒng Qiáo yǔ Dōngdī xiānglián, yīncǐ dǎoyǔ, qiáo hé ànxiàn gòngtóng cānyù húqū kōngjiān zǔzhī.',
      vietnamese: 'Tư liệu UNESCO cho biết hồ Côn Minh có ba đảo lớn. Đảo Nam Hồ ở phía nam nối với đê Đông qua cầu Thập Thất Khổng, vì vậy đảo, cầu và đường bờ cùng tham gia tổ chức không gian khu hồ.',
      english: 'UNESCO notes three large islands in Kunming Lake. The southern Nanhu Island is linked to the East Dike by the Seventeen-Arch Bridge, so island, bridge, and shoreline participate together in the lake’s spatial organization.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '西堤怎样参与昆明湖整体？',
      newFactOrConcept: 'UNESCO记录西堤上有六座桥。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '转向湖区另一条堤岸系统。',
      storyBridge: '提醒学习者十七孔桥并非湖上唯一连接结构。',
      chinese: '昆明湖西侧的西堤也是湖区结构的一部分。UNESCO资料记录西堤上有六座桥，这些桥与堤岸一起塑造湖区的通行和观看关系。',
      pinyin: 'Kūnmíng Hú xīcè de Xīdī yě shì húqū jiégòu de yí bùfen. UNESCO zīliào jìlù Xīdī shàng yǒu liù zuò qiáo, zhèxiē qiáo yǔ dī’àn yìqǐ sùzào húqū de tōngxíng hé guānkàn guānxì.',
      vietnamese: 'Tây Đê ở phía tây hồ Côn Minh cũng là một phần của cấu trúc khu hồ. Tư liệu UNESCO ghi nhận trên Tây Đê có sáu cây cầu; các cầu và đê cùng định hình quan hệ đi lại và quan sát quanh hồ.',
      english: 'The West Dike on the western side of Kunming Lake is also part of the lake system. UNESCO records six bridges on the dike; together, bridges and dike shape movement and viewing relationships around the lake.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '怎样从岛、桥和堤理解更大的园林整体？',
      newFactOrConcept: '东堤、十七孔桥、南湖岛、西堤及其桥梁共同显示湖区由多重连接组成。',
      sourceIds: [summerPalaceUnescoSourceId, summerPalaceBridgeSourceId],
      whyDistinct: '把前两单元综合为湖区网络。',
      storyBridge: 'Story的桥光时刻属于一个更大的湖区系统，不是孤立奇观。',
      chinese: '把东堤、十七孔桥、南湖岛、西堤和西堤上的桥放在一起看，昆明湖就不再只是大片水面，而是一套由岛、岸和连接结构共同形成的园林整体。',
      pinyin: 'Bǎ Dōngdī, Shíqīkǒng Qiáo, Nánhú Dǎo, Xīdī hé Xīdī shàng de qiáo fàng zài yìqǐ kàn, Kūnmíng Hú jiù bú zài zhǐ shì dàpiàn shuǐmiàn, ér shì yí tào yóu dǎo, àn hé liánjiē jiégòu gòngtóng xíngchéng de yuánlín zhěngtǐ.',
      vietnamese: 'Khi nhìn đê Đông, cầu Thập Thất Khổng, đảo Nam Hồ, Tây Đê và các cầu trên Tây Đê cùng nhau, hồ Côn Minh không còn chỉ là một mặt nước lớn mà trở thành một tổng thể vườn được hình thành bởi đảo, bờ và các cấu trúc kết nối.',
      english: 'Seen together, the East Dike, Seventeen-Arch Bridge, Nanhu Island, West Dike, and West Dike bridges turn Kunming Lake from a large body of water into a garden whole formed by islands, shores, and connecting structures.',
    ),
  ],
  10: [
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '颐和园为什么成为世界遗产？',
      newFactOrConcept: '1998年列入《世界遗产名录》，其价值包括自然与人工要素形成的和谐整体。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '建立World Heritage身份与整体价值。',
      storyBridge: '把Story中的湖、山、桥、廊从个人记忆延伸到遗产整体。',
      chinese: '颐和园于一九九八年列入《世界遗产名录》。UNESCO强调自然山水与人工建筑形成的和谐整体，因此遗产价值不是只属于一座著名建筑。',
      pinyin: 'Yíhéyuán yú yī jiǔ jiǔ bā nián lièrù “Shìjiè Yíchǎn Mínglù”. UNESCO qiángdiào zìrán shānshuǐ yǔ réngōng jiànzhù xíngchéng de héxié zhěngtǐ, yīncǐ yíchǎn jiàzhí bú shì zhǐ shǔyú yí zuò zhùmíng jiànzhù.',
      vietnamese: 'Di Hòa Viên được ghi vào Danh mục Di sản Thế giới năm 1998. UNESCO nhấn mạnh tổng thể hài hòa giữa cảnh quan tự nhiên và kiến trúc nhân tạo, nên giá trị di sản không chỉ thuộc về một công trình nổi tiếng.',
      english: 'The Summer Palace was inscribed on the World Heritage List in 1998. UNESCO emphasizes the harmonious whole formed by natural landscape and built elements, so heritage value does not belong to one famous structure alone.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '“完整性”为什么关心关系而不只是单体？',
      newFactOrConcept: 'UNESCO完整性评估关注原有设计、规划、景观和环境关系。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '解释integrity的关系性。',
      storyBridge: '对应Story中地点、路线、光线和旧照片不能彼此替换。',
      chinese: 'UNESCO对颐和园完整性的评价不仅看单个建筑是否存在，也关注原有设计、规划、景观以及遗产与周围环境之间的关系是否仍然清楚。',
      pinyin: 'UNESCO duì Yíhéyuán wánzhěngxìng de píngjià bùjǐn kàn dāngè jiànzhù shìfǒu cúnzài, yě guānzhù yuányǒu shèjì, guīhuà, jǐngguān yǐjí yíchǎn yǔ zhōuwéi huánjìng zhījiān de guānxì shìfǒu réngrán qīngchu.',
      vietnamese: 'Đánh giá tính toàn vẹn của UNESCO đối với Di Hòa Viên không chỉ xem từng công trình còn tồn tại hay không, mà còn quan tâm thiết kế, quy hoạch, cảnh quan ban đầu và quan hệ giữa di sản với môi trường xung quanh có còn rõ hay không.',
      english: 'UNESCO’s integrity assessment looks beyond whether individual buildings survive. It also considers whether original design, planning, landscape, and the relationship between the property and its setting remain legible.',
    ),
    SummerPalaceDiscoveryUnit(
      learnerQuestion: '“真实性”怎样影响保护？',
      newFactOrConcept: 'UNESCO强调历史档案、传统技法与适当材料，用以保存历史信息。',
      sourceIds: [summerPalaceUnescoSourceId],
      whyDistinct: '解释authenticity与保护证据，不编造具体修复工艺。',
      storyBridge: '给周岚旧照片和修复历史提供文化背景，但不把她变成讲解员。',
      chinese: 'UNESCO指出，颐和园保护会参考历史档案，并使用传统技法和适当材料，以维持真实性并保存历史信息。保护因此既关心物质，也关心可核对的历史依据。',
      pinyin: 'UNESCO zhǐchū, Yíhéyuán bǎohù huì cānkǎo lìshǐ dàng’àn, bìng shǐyòng chuántǒng jìfǎ hé shìdàng cáiliào, yǐ wéichí zhēnshíxìng bìng bǎocún lìshǐ xìnxī. Bǎohù yīncǐ jì guānxīn wùzhì, yě guānxīn kě héduì de lìshǐ yījù.',
      vietnamese: 'UNESCO cho biết việc bảo tồn Di Hòa Viên tham khảo tư liệu lịch sử và sử dụng kỹ thuật truyền thống cùng vật liệu phù hợp để duy trì tính xác thực và lưu giữ thông tin lịch sử. Vì vậy bảo tồn quan tâm cả vật chất lẫn căn cứ lịch sử có thể đối chiếu.',
      english: 'UNESCO notes that conservation of the Summer Palace draws on historical archives and uses traditional techniques and appropriate materials to maintain authenticity and preserve historic information. Conservation therefore concerns both material fabric and verifiable historical evidence.',
    ),
  ],
};

List<SummerPalaceDiscoveryUnit> summerPalaceDiscoveryUnitsForLevel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  return List<SummerPalaceDiscoveryUnit>.unmodifiable(
    summerPalaceDiscoveryUnitsByLevel[safeLevel]!,
  );
}

List<DiscoveryEntry> summerPalaceDiscoveryEntriesForLevel(int level) =>
    List<DiscoveryEntry>.unmodifiable(
      summerPalaceDiscoveryUnitsForLevel(level).map((unit) => unit.entry),
    );

const summerPalaceCulturalPilotWords = <WordEntry>[
  WordEntry(
    word: '冬至',
    pinyin: 'dōngzhì',
    partOfSpeech: '名词',
    simpleChinese: '二十四节气之一。',
    translation: 'Đông chí.',
    englishDefinition: 'winter solstice',
    symbol: '☀️',
    examples: [
      WordExample(
        chinese: '冬至前后，十七孔桥会出现季节性夕阳光影。',
        pinyin: 'Dōngzhì qiánhòu, Shíqīkǒng Qiáo huì chūxiàn jìjiéxìng xīyáng guāngyǐng.',
        vietnamese: 'Quanh Đông chí, cầu Thập Thất Khổng xuất hiện hiệu ứng ánh hoàng hôn theo mùa.',
        english: 'Around the winter solstice, seasonal sunset light appears at the Seventeen-Arch Bridge.',
      ),
    ],
  ),
  WordEntry(
    word: '旧照片',
    pinyin: 'jiù zhàopiàn',
    partOfSpeech: '名词',
    simpleChinese: '以前拍摄并保存下来的照片。',
    translation: 'Bức ảnh cũ.',
    englishDefinition: 'old photograph',
    symbol: '📷',
    examples: [
      WordExample(
        chinese: '风把外婆的旧照片吹向石栏。',
        pinyin: 'Fēng bǎ wàipó de jiù zhàopiàn chuī xiàng shílán.',
        vietnamese: 'Gió thổi bức ảnh cũ của bà về phía lan can đá.',
        english: 'The wind blows Grandmother’s old photograph toward the stone railing.',
      ),
    ],
  ),
  WordEntry(
    word: '桥洞',
    pinyin: 'qiáodòng',
    partOfSpeech: '名词',
    simpleChinese: '桥下面形成的拱形或其他开口。',
    translation: 'Vòm hoặc lỗ mở dưới cầu.',
    englishDefinition: 'bridge arch opening',
    symbol: '🌉',
    examples: [
      WordExample(
        chinese: '夕阳逐渐照亮十七孔桥的桥洞。',
        pinyin: 'Xīyáng zhújiàn zhàoliàng Shíqīkǒng Qiáo de qiáodòng.',
        vietnamese: 'Nắng hoàng hôn dần chiếu sáng các vòm cầu Thập Thất Khổng.',
        english: 'The sunset gradually illuminates the Seventeen-Arch Bridge arches.',
      ),
    ],
  ),
  WordEntry(
    word: '金光',
    pinyin: 'jīnguāng',
    partOfSpeech: '名词',
    simpleChinese: '金黄色的光。',
    translation: 'Ánh sáng vàng.',
    englishDefinition: 'golden light',
    symbol: '✨',
    examples: [
      WordExample(
        chinese: '许澄再举机时，桥洞金光已经移动。',
        pinyin: 'Xǔ Chéng zài jǔ jī shí, qiáodòng jīnguāng yǐjīng yídòng.',
        vietnamese: 'Khi Hứa Trừng nâng máy lại, ánh vàng trong các vòm cầu đã dịch chuyển.',
        english: 'When Xu Cheng raises the camera again, the golden light in the arches has moved.',
      ),
    ],
  ),
  WordEntry(
    word: '快门',
    pinyin: 'kuàimén',
    partOfSpeech: '名词',
    simpleChinese: '相机控制曝光时间的装置，也常指拍照动作。',
    translation: 'Màn trập máy ảnh.',
    englishDefinition: 'camera shutter',
    symbol: '📸',
    examples: [
      WordExample(
        chinese: '她必须在按快门和先捡照片之间选。',
        pinyin: 'Tā bìxū zài àn kuàimén hé xiān jiǎn zhàopiàn zhījiān xuǎn.',
        vietnamese: 'Cô phải chọn giữa bấm máy và nhặt bức ảnh trước.',
        english: 'She must choose between pressing the shutter and retrieving the photograph first.',
      ),
    ],
  ),
  WordEntry(
    word: '保存',
    pinyin: 'bǎocún',
    partOfSpeech: '动词',
    simpleChinese: '使东西继续存在而不丢失。',
    translation: 'Gìn giữ, bảo quản.',
    englishDefinition: 'to preserve; to keep safe',
    symbol: '🗂️',
    examples: [
      WordExample(
        chinese: '周岚把旧照片交给许澄保存。',
        pinyin: 'Zhōu Lán bǎ jiù zhàopiàn jiāogěi Xǔ Chéng bǎocún.',
        vietnamese: 'Chu Lam giao bức ảnh cũ cho Hứa Trừng gìn giữ.',
        english: 'Zhou Lan entrusts the old photograph to Xu Cheng for safekeeping.',
      ),
    ],
  ),
  WordEntry(
    word: '东堤',
    pinyin: 'Dōngdī',
    partOfSpeech: '名词（专名）',
    simpleChinese: '昆明湖东侧的重要堤岸。',
    translation: 'Đê Đông của hồ Côn Minh.',
    englishDefinition: 'the East Dike of Kunming Lake',
    symbol: '🧭',
    examples: [
      WordExample(
        chinese: '十七孔桥东接东堤，西连南湖岛。',
        pinyin: 'Shíqīkǒng Qiáo dōng jiē Dōngdī, xī lián Nánhú Dǎo.',
        vietnamese: 'Cầu Thập Thất Khổng nối đê Đông ở phía đông và đảo Nam Hồ ở phía tây.',
        english: 'The Seventeen-Arch Bridge connects the East Dike on the east and Nanhu Island on the west.',
      ),
    ],
  ),
  WordEntry(
    word: '南湖岛',
    pinyin: 'Nánhú Dǎo',
    partOfSpeech: '名词（专名）',
    simpleChinese: '昆明湖中的主要岛屿之一。',
    translation: 'Đảo Nam Hồ trong hồ Côn Minh.',
    englishDefinition: 'Nanhu Island',
    symbol: '🏝️',
    examples: [
      WordExample(
        chinese: '南湖岛通过十七孔桥与东堤相连。',
        pinyin: 'Nánhú Dǎo tōngguò Shíqīkǒng Qiáo yǔ Dōngdī xiānglián.',
        vietnamese: 'Đảo Nam Hồ nối với đê Đông qua cầu Thập Thất Khổng.',
        english: 'Nanhu Island is linked to the East Dike by the Seventeen-Arch Bridge.',
      ),
    ],
  ),
];

const summerPalaceCulturalPilotVocabularyLevels = <String, VocabularyLevelTag>{
  '冬至': VocabularyLevelTag(
    hskLevel: 6,
    tocflLevel: 4,
    kind: VocabularyKind.cultural,
  ),
  '旧照片': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '桥洞': VocabularyLevelTag(
    hskLevel: 6,
    tocflLevel: 4,
    kind: VocabularyKind.cultural,
  ),
  '金光': VocabularyLevelTag(hskLevel: 5, tocflLevel: 4),
  '快门': VocabularyLevelTag(hskLevel: 6, tocflLevel: 5),
  '保存': VocabularyLevelTag(hskLevel: 3, tocflLevel: 2),
  '东堤': VocabularyLevelTag(
    kind: VocabularyKind.properNoun,
    evidence: VocabularyLevelEvidence.cultural,
  ),
  '南湖岛': VocabularyLevelTag(
    kind: VocabularyKind.properNoun,
    evidence: VocabularyLevelEvidence.cultural,
  ),
};
