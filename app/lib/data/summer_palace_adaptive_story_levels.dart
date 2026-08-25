import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'summer_palace_cultural_discovery_levels.dart';

enum SummerPalaceN1EventId {
  protagonist,
  schoolExhibitionGoal,
  independenceMotive,
  grandmotherConservationBackground,
  valuesConflict,
  photographFalls,
  forcedChoice,
  enactedChoice,
  lostLight,
  threeLayerComposition,
  workTitle,
  trustChange,
  photographEntrusted,
  changedUnderstanding,
}

const summerPalaceN1RequiredEventOrder = <SummerPalaceN1EventId>[
  SummerPalaceN1EventId.protagonist,
  SummerPalaceN1EventId.schoolExhibitionGoal,
  SummerPalaceN1EventId.independenceMotive,
  SummerPalaceN1EventId.grandmotherConservationBackground,
  SummerPalaceN1EventId.valuesConflict,
  SummerPalaceN1EventId.photographFalls,
  SummerPalaceN1EventId.forcedChoice,
  SummerPalaceN1EventId.enactedChoice,
  SummerPalaceN1EventId.lostLight,
  SummerPalaceN1EventId.threeLayerComposition,
  SummerPalaceN1EventId.workTitle,
  SummerPalaceN1EventId.trustChange,
  SummerPalaceN1EventId.photographEntrusted,
  SummerPalaceN1EventId.changedUnderstanding,
];

class SummerPalaceN1SemanticEvent {
  const SummerPalaceN1SemanticEvent({
    required this.id,
    required this.coreChinese,
    required this.corePinyin,
    required this.coreVietnamese,
    required this.coreEnglish,
    required this.detailChinese,
    required this.detailPinyin,
    required this.detailVietnamese,
    required this.detailEnglish,
    required this.detailFromLevel,
    this.masteryChinese = '',
    this.masteryPinyin = '',
    this.masteryVietnamese = '',
    this.masteryEnglish = '',
    this.masteryFromLevel = 11,
  });

  final SummerPalaceN1EventId id;
  final String coreChinese;
  final String corePinyin;
  final String coreVietnamese;
  final String coreEnglish;
  final String detailChinese;
  final String detailPinyin;
  final String detailVietnamese;
  final String detailEnglish;
  final int detailFromLevel;
  final String masteryChinese;
  final String masteryPinyin;
  final String masteryVietnamese;
  final String masteryEnglish;
  final int masteryFromLevel;
}

const summerPalaceN1SemanticEvents = <SummerPalaceN1SemanticEvent>[
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.protagonist,
    coreChinese: '冬至前，许澄带相机到颐和园。',
    corePinyin: 'Dōngzhì qián, Xǔ Chéng dài xiàngjī dào Yíhéyuán.',
    coreVietnamese: 'Trước Đông chí, Hứa Trừng mang máy ảnh đến Di Hòa Viên.',
    coreEnglish: 'Before the winter solstice, Xu Cheng brings a camera to the Summer Palace.',
    detailChinese: '她专挑晴朗的冬日下午来，因为冬至前后十七孔桥会出现“金光穿洞”。',
    detailPinyin: 'Tā zhuān tiāo qínglǎng de dōngjì xiàwǔ lái, yīnwèi dōngzhì qiánhòu Shíqīkǒng Qiáo huì chūxiàn “jīnguāng chuān dòng”.',
    detailVietnamese: 'Cô cố ý chọn một buổi chiều đông quang đãng vì quanh Đông chí, cầu Thập Thất Khổng xuất hiện hiện tượng “ánh vàng xuyên vòm”.',
    detailEnglish: 'She deliberately chooses a clear winter afternoon because around the winter solstice the Seventeen-Arch Bridge shows the “golden light through the arches” phenomenon.',
    detailFromLevel: 2,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.schoolExhibitionGoal,
    coreChinese: '她要为校展拍一张“无瑕”照片。',
    corePinyin: 'Tā yào wèi xiàozhǎn pāi yì zhāng “wúxiá” zhàopiàn.',
    coreVietnamese: 'Cô muốn chụp một bức ảnh “không tì vết” cho triển lãm trường.',
    coreEnglish: 'She wants to take a “flawless” photograph for a school exhibition.',
    detailChinese: '她等的不是普通夕阳，而是桥洞被落日逐渐照亮的短暂时刻。',
    detailPinyin: 'Tā děng de bú shì pǔtōng xīyáng, ér shì qiáodòng bèi luòrì zhújiàn zhàoliàng de duǎnzàn shíkè.',
    detailVietnamese: 'Điều cô chờ không phải hoàng hôn bình thường mà là khoảnh khắc ngắn khi nắng lặn dần chiếu sáng các vòm cầu.',
    detailEnglish: 'She is not waiting for an ordinary sunset but for the brief moment when the setting sun gradually illuminates the bridge arches.',
    detailFromLevel: 6,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.independenceMotive,
    coreChinese: '她想证明不靠外婆周岚选构图。',
    corePinyin: 'Tā xiǎng zhèngmíng bú kào wàipó Zhōu Lán xuǎn gòutú.',
    coreVietnamese: 'Cô muốn chứng minh mình có thể chọn bố cục mà không dựa vào bà ngoại Chu Lam.',
    coreEnglish: 'She wants to prove she can choose the composition without relying on her grandmother Zhou Lan.',
    detailChinese: '周岚只问她为什么站这里、为什么等这个时刻，许澄把每个问题都听成干涉。',
    detailPinyin: 'Zhōu Lán zhǐ wèn tā wèishénme zhàn zhèlǐ, wèishénme děng zhège shíkè, Xǔ Chéng bǎ měi gè wèntí dōu tīng chéng gānshè.',
    detailVietnamese: 'Chu Lam chỉ hỏi vì sao cô đứng ở đây và vì sao chờ đúng lúc này; Hứa Trừng nghe mỗi câu hỏi như một sự can thiệp.',
    detailEnglish: 'Zhou Lan only asks why she stands here and why she waits for this moment, but Xu Cheng hears every question as interference.',
    detailFromLevel: 6,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.grandmotherConservationBackground,
    coreChinese: '周岚做过园林修复，带着旧照片。',
    corePinyin: 'Zhōu Lán zuò guò yuánlín xiūfù, dàizhe jiù zhàopiàn.',
    coreVietnamese: 'Chu Lam từng làm công việc phục hồi khu vườn và mang theo một bức ảnh cũ.',
    coreEnglish: 'Zhou Lan once worked on garden restoration and carries an old photograph.',
    detailChinese: '旧照片背面写着：“一八六〇年受损，一八八六年开始修复。”许澄想把这行字裁掉，周岚把照片翻回正面。',
    detailPinyin: 'Jiù zhàopiàn bèimiàn xiězhe: “yī bā liù líng nián shòusǔn, yī bā bā liù nián kāishǐ xiūfù.” Xǔ Chéng xiǎng bǎ zhè háng zì cáidiào, Zhōu Lán bǎ zhàopiàn fān huí zhèngmiàn.',
    detailVietnamese: 'Mặt sau ảnh ghi: “bị hư hại năm 1860, bắt đầu được phục hồi vào năm 1886.” Hứa Trừng muốn cắt bỏ dòng chữ ấy, nhưng Chu Lam lật ảnh trở lại mặt trước.',
    detailEnglish: 'The back reads, “damaged in 1860, restoration began in 1886.” Xu Cheng wants to crop out that line, but Zhou Lan turns the photograph face-up again.',
    detailFromLevel: 5,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.valuesConflict,
    coreChinese: '许澄避开旧痕迹，周岚要她多看一眼。',
    corePinyin: 'Xǔ Chéng bìkāi jiù hénjì, Zhōu Lán yào tā duō kàn yì yǎn.',
    coreVietnamese: 'Hứa Trừng tránh những dấu vết cũ; Chu Lam bảo cô nhìn thêm một lần.',
    coreEnglish: 'Xu Cheng avoids the old traces; Zhou Lan asks her to look once more.',
    detailChinese: '走过长廊时，周岚在廊外重新露出昆明湖的地方停了一步，许澄却故意快走，想甩开她的节奏。',
    detailPinyin: 'Zǒuguò Chángláng shí, Zhōu Lán zài lángwài chóngxīn lùchū Kūnmíng Hú de dìfang tíng le yí bù, Xǔ Chéng què gùyì kuài zǒu, xiǎng shuǎikāi tā de jiézòu.',
    detailVietnamese: 'Khi đi qua Trường Lang, Chu Lam dừng một bước ở nơi hồ Côn Minh hiện ra trở lại ngoài hành lang; Hứa Trừng cố ý đi nhanh để thoát khỏi nhịp của bà.',
    detailEnglish: 'Passing through the Long Corridor, Zhou Lan pauses where Kunming Lake appears again beyond it, while Xu Cheng deliberately speeds up to escape her grandmother’s pace.',
    detailFromLevel: 4,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.photographFalls,
    coreChinese: '十七孔桥西北侧，桥洞亮起时，旧照片被风吹落。',
    corePinyin: 'Shíqīkǒng Qiáo xīběi cè, qiáodòng liàng qǐ shí, jiù zhàopiàn bèi fēng chuīluò.',
    coreVietnamese: 'Ở phía tây bắc cầu Thập Thất Khổng, khi các vòm cầu sáng lên, bức ảnh cũ bị gió thổi rơi.',
    coreEnglish: 'On the northwest side of the Seventeen-Arch Bridge, as the arches light up, the old photograph is blown down.',
    detailChinese: '十七孔桥东接东堤、西连南湖岛。许澄为了等桥洞被夕阳照亮，特意绕到西北方向站定；就在桥洞亮起来时，风把照片卷向湖边。',
    detailPinyin: 'Shíqīkǒng Qiáo dōng jiē Dōngdī, xī lián Nánhú Dǎo. Xǔ Chéng wèile děng qiáodòng bèi xīyáng zhàoliàng, tèyì rào dào xīběi fāngxiàng zhàndìng; jiù zài qiáodòng liàng qǐlái shí, fēng bǎ zhàopiàn juǎn xiàng húbiān.',
    detailVietnamese: 'Cầu Thập Thất Khổng nối đê Đông ở phía đông và đảo Nam Hồ ở phía tây. Để chờ hoàng hôn chiếu sáng các vòm, Hứa Trừng cố ý vòng đến hướng tây bắc đứng chờ; đúng lúc các vòm sáng lên, gió cuốn bức ảnh về phía hồ.',
    detailEnglish: 'The bridge links the East Dike on the east with Nanhu Island on the west. Xu Cheng deliberately circles to the northwest to wait for sunset to illuminate the arches; as they brighten, the wind carries the photograph toward the lake.',
    detailFromLevel: 3,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.forcedChoice,
    coreChinese: '她必须在按快门和捡照片之间选择。',
    corePinyin: 'Tā bìxū zài àn kuàimén hé jiǎn zhàopiàn zhījiān xuǎnzé.',
    coreVietnamese: 'Cô phải chọn giữa bấm máy và nhặt bức ảnh.',
    coreEnglish: 'She must choose between pressing the shutter and retrieving the photograph.',
    detailChinese: '她若继续对焦，就能留下等了一下午的季节性画面；若先弯腰，低角度夕阳不会为她停住。',
    detailPinyin: 'Tā ruò jìxù duìjiāo, jiù néng liúxià děng le yí xiàwǔ de jìjiéxìng huàmiàn; ruò xiān wānyāo, dī jiǎodù xīyáng bú huì wèi tā tíngzhù.',
    detailVietnamese: 'Nếu tiếp tục lấy nét, cô có thể giữ lại cảnh theo mùa đã chờ cả buổi chiều; nếu cúi xuống trước, nắng hoàng hôn góc thấp sẽ không dừng lại vì cô.',
    detailEnglish: 'If she keeps focusing, she can capture the seasonal view she has waited all afternoon for; if she bends down first, the low-angle sunset will not stop for her.',
    detailFromLevel: 9,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.enactedChoice,
    coreChinese: '许澄放下相机，先捡回照片。',
    corePinyin: 'Xǔ Chéng fàngxià xiàngjī, xiān jiǎn huí zhàopiàn.',
    coreVietnamese: 'Hứa Trừng hạ máy ảnh và nhặt bức ảnh trước.',
    coreEnglish: 'Xu Cheng lowers the camera and retrieves the photograph first.',
    detailChinese: '她把相机贴回胸口，跨一步按住照片边角，再把它从石栏下捡起。',
    detailPinyin: 'Tā bǎ xiàngjī tiē huí xiōngkǒu, kuà yí bù ànzhù zhàopiàn biānjiǎo, zài bǎ tā cóng shílán xià jiǎn qǐ.',
    detailVietnamese: 'Cô áp máy về ngực, bước tới giữ góc bức ảnh rồi nhặt nó lên từ dưới lan can đá.',
    detailEnglish: 'She brings the camera back to her chest, steps forward to pin the photograph’s edge, then lifts it from below the stone railing.',
    detailFromLevel: 4,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.lostLight,
    coreChinese: '她再举机时，桥洞金光已移动，等了一下午的画面没了。',
    corePinyin: 'Tā zài jǔ jī shí, qiáodòng jīnguāng yǐ yídòng, děng le yí xiàwǔ de huàmiàn méi le.',
    coreVietnamese: 'Khi cô nâng máy lại, ánh vàng trong các vòm đã dịch chuyển; cảnh cô chờ cả buổi chiều đã mất.',
    coreEnglish: 'When she raises the camera again, the golden light in the arches has moved; the view she waited all afternoon for is gone.',
    detailChinese: '太阳继续西下，原本铺在桥洞内壁上的亮色已经移开。',
    detailPinyin: 'Tàiyáng jìxù xīxià, yuánběn pū zài qiáodòng nèibì shàng de liàngsè yǐjīng yíkāi.',
    detailVietnamese: 'Mặt trời tiếp tục lặn về tây, dải sáng trước đó phủ lên mặt trong vòm cầu đã dịch đi.',
    detailEnglish: 'The sun keeps setting westward, and the brightness that had covered the inner arch walls has already shifted away.',
    detailFromLevel: 2,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.threeLayerComposition,
    coreChinese: '她改拍旧照片、外婆的手和暗下的桥洞。',
    corePinyin: 'Tā gǎi pāi jiù zhàopiàn, wàipó de shǒu hé àn xià de qiáodòng.',
    coreVietnamese: 'Cô đổi sang chụp bức ảnh cũ, bàn tay bà và những vòm cầu đang tối đi.',
    coreEnglish: 'She instead photographs the old picture, her grandmother’s hand, and the darkening bridge arches.',
    detailChinese: '她没有追着复制刚才的画面，而把旧照片贴在掌心，等外婆扶稳石栏，再让桥洞余光进入新照片。',
    detailPinyin: 'Tā méiyǒu zhuīzhe fùzhì gāngcái de huàmiàn, ér bǎ jiù zhàopiàn tiē zài zhǎngxīn, děng wàipó fúwěn shílán, zài ràng qiáodòng yúguāng jìnrù xīn zhàopiàn.',
    detailVietnamese: 'Cô không đuổi theo để sao chép khung hình vừa mất, mà đặt ảnh cũ trong lòng bàn tay, đợi bà vịn chắc lan can rồi đưa phần ánh sáng còn lại trong vòm vào bức ảnh mới.',
    detailEnglish: 'She does not chase a copy of the lost view. She holds the old photograph in her palm, waits until Zhou Lan steadies herself on the railing, and lets the remaining arch light enter the new image.',
    detailFromLevel: 5,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.workTitle,
    coreChinese: '作品叫《留下痕迹的风景》。',
    corePinyin: 'Zuòpǐn jiào “Liúxià Hénjì de Fēngjǐng”.',
    coreVietnamese: 'Tác phẩm có tên “Phong cảnh lưu lại dấu vết”.',
    coreEnglish: 'She titles the work “A Landscape That Keeps Its Traces.”',
    detailChinese: '她在校展说明里只写拍摄地点和时节，没有把外婆的选择解释成一句口号。',
    detailPinyin: 'Tā zài xiàozhǎn shuōmíng lǐ zhǐ xiě pāishè dìdiǎn hé shíjié, méiyǒu bǎ wàipó de xuǎnzé jiěshì chéng yí jù kǒuhào.',
    detailVietnamese: 'Trong phần chú thích triển lãm, cô chỉ ghi địa điểm và mùa chụp, không biến lựa chọn liên quan đến bà thành một khẩu hiệu.',
    detailEnglish: 'In the exhibition note she records only the place and season, rather than turning the choice involving her grandmother into a slogan.',
    detailFromLevel: 8,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.trustChange,
    coreChinese: '周岚看完，不再替她调构图。',
    corePinyin: 'Zhōu Lán kàn wán, bú zài tì tā tiáo gòutú.',
    coreVietnamese: 'Chu Lam xem xong và không còn chỉnh bố cục thay cô.',
    coreEnglish: 'After looking, Zhou Lan stops adjusting the composition for her.',
    detailChinese: '周岚只说：“下一张你自己定。”然后把手从相机旁收回。',
    detailPinyin: 'Zhōu Lán zhǐ shuō: “Xià yì zhāng nǐ zìjǐ dìng.” Ránhòu bǎ shǒu cóng xiàngjī páng shōuhuí.',
    detailVietnamese: 'Chu Lam chỉ nói: “Tấm sau con tự quyết.” Rồi bà rút tay khỏi cạnh máy ảnh.',
    detailEnglish: 'Zhou Lan only says, “You decide the next one yourself,” then withdraws her hand from beside the camera.',
    detailFromLevel: 6,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.photographEntrusted,
    coreChinese: '她把旧照片交给许澄保存。',
    corePinyin: 'Tā bǎ jiù zhàopiàn jiāogěi Xǔ Chéng bǎocún.',
    coreVietnamese: 'Bà giao bức ảnh cũ cho Hứa Trừng gìn giữ.',
    coreEnglish: 'She entrusts the old photograph to Xu Cheng for safekeeping.',
    detailChinese: '周岚把旧照片装进透明袋，再放进许澄手里：“这张也归你保管。”',
    detailPinyin: 'Zhōu Lán bǎ jiù zhàopiàn zhuāngjìn tòumíng dài, zài fàngjìn Xǔ Chéng shǒu lǐ: “Zhè zhāng yě guī nǐ bǎoguǎn.”',
    detailVietnamese: 'Chu Lam cho bức ảnh cũ vào một túi trong suốt rồi đặt vào tay Hứa Trừng: “Tấm này cũng giao cho con giữ.”',
    detailEnglish: 'Zhou Lan slips the old photograph into a clear sleeve and places it in Xu Cheng’s hand: “This one is yours to keep too.”',
    detailFromLevel: 7,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.changedUnderstanding,
    coreChinese: '许澄把新旧照片放进相机包。',
    corePinyin: 'Xǔ Chéng bǎ xīn jiù zhàopiàn fàngjìn xiàngjī bāo.',
    coreVietnamese: 'Hứa Trừng đặt ảnh mới và ảnh cũ vào túi máy ảnh.',
    coreEnglish: 'Xu Cheng places the new and old photographs in her camera bag.',
    detailChinese: '她没有删掉“无瑕”这个词，只在旁边画了一道问号。',
    detailPinyin: 'Tā méiyǒu shāndiào “wúxiá” zhège cí, zhǐ zài pángbiān huà le yí dào wènhào.',
    detailVietnamese: 'Cô không xóa từ “không tì vết”, chỉ vẽ một dấu hỏi bên cạnh.',
    detailEnglish: 'She does not delete the word “flawless”; she only draws a question mark beside it.',
    detailFromLevel: 9,
    masteryChinese: '她又在校展记录里写下冬至前后的拍摄时节、十七孔桥西北侧的站位，并注明旧照片来自外婆周岚。',
    masteryPinyin: 'Tā yòu zài xiàozhǎn jìlù lǐ xiěxià dōngzhì qiánhòu de pāishè shíjié, Shíqīkǒng Qiáo xīběi cè de zhànwèi, bìng zhùmíng jiù zhàopiàn láizì wàipó Zhōu Lán.',
    masteryVietnamese: 'Trong ghi chép cho triển lãm trường, cô còn ghi thời điểm chụp quanh Đông chí, vị trí ở phía tây bắc cầu Thập Thất Khổng, và chú thích rằng bức ảnh cũ đến từ bà ngoại Chu Lam.',
    masteryEnglish: 'In her school-exhibition record, she also notes that the photograph was taken around the winter solstice from the northwest side of the Seventeen-Arch Bridge, and identifies the old photograph as coming from her grandmother Zhou Lan.',
    masteryFromLevel: 10,
  ),
];

class SummerPalaceStoryCulturalCausalityRecord {
  const SummerPalaceStoryCulturalCausalityRecord({
    required this.factOrMechanism,
    required this.sourceIds,
    required this.whereItAppears,
    required this.storyActionCaused,
    required this.pressureCaused,
    required this.whyNotExposition,
    required this.whatBreaksIfRemoved,
  });

  final String factOrMechanism;
  final List<String> sourceIds;
  final String whereItAppears;
  final String storyActionCaused;
  final String pressureCaused;
  final String whyNotExposition;
  final String whatBreaksIfRemoved;
}

const summerPalaceStoryCulturalCausality =
    <SummerPalaceStoryCulturalCausalityRecord>[
  SummerPalaceStoryCulturalCausalityRecord(
    factOrMechanism: '冬至前后十七孔桥的季节性低角度夕阳会逐渐照亮桥洞。',
    sourceIds: [summerPalaceWinterLightSourceId],
    whereItAppears: '开场时节、桥边等待、照片掉落、失去光线。',
    storyActionCaused: '许澄选定冬日下午并绕到西北方向等待；照片掉落时她必须立即选择。',
    pressureCaused: '低角度夕阳持续移动，捡照片会真实失去等了一下午的画面。',
    whyNotExposition: '事实先决定时节、站位和倒计时，再制造Choice与Cost。',
    whatBreaksIfRemoved: 'Climax退化为可替换的普通公园夕阳，代价不再属于颐和园。',
  ),
  SummerPalaceStoryCulturalCausalityRecord(
    factOrMechanism: '十七孔桥东接东堤、西连南湖岛，西北方向是季节光影的有利观看方向。',
    sourceIds: [summerPalaceBridgeSourceId, summerPalaceWinterLightSourceId],
    whereItAppears: '许澄绕到桥西北方向站定。',
    storyActionCaused: '她不是随便找湖边，而是为了桥洞光线选择具体站位。',
    pressureCaused: '桥、岛、堤与站位把拍摄机会限制在具体空间。',
    whyNotExposition: '空间事实改变人物走到哪里、在哪里停下。',
    whatBreaksIfRemoved: '十七孔桥只剩专名装饰，摄影位置可被任何地标替换。',
  ),
  SummerPalaceStoryCulturalCausalityRecord(
    factOrMechanism: '长廊位于万寿山南麓、临近昆明湖，路线改变观看位置。',
    sourceIds: [summerPalaceOverviewSourceId, summerPalaceUnescoSourceId],
    whereItAppears: '周岚在湖面重新露出时停步，许澄故意快走。',
    storyActionCaused: '两人用不同步速穿过同一园林路线。',
    pressureCaused: '许澄把外婆的停步和提问都听成控制，关系冲突被空间放大。',
    whyNotExposition: '文化空间直接改变两人的速度和距离。',
    whatBreaksIfRemoved: '冲突只剩口头争论，地点不参与关系推进。',
  ),
  SummerPalaceStoryCulturalCausalityRecord(
    factOrMechanism: '清漪园1750年开始兴建、1860年严重受损、1886年开始修复，1888年改名为颐和园。',
    sourceIds: [summerPalaceUnescoSourceId, summerPalaceOverviewSourceId],
    whereItAppears: '旧照片背面的1860/1886记录。',
    storyActionCaused: '许澄想裁掉历史字样，周岚把照片翻回正面。',
    pressureCaused: '“无瑕”审美与真实损毁、修复历史在一张家庭物件上发生碰撞。',
    whyNotExposition: '年代被写在人物争夺构图权的物件上，并触发动作。',
    whatBreaksIfRemoved: '旧照片会变成普通家庭纪念物，修复冲突失去颐和园历史重量。',
  ),
];

JourneyLevelContent summerPalaceN1LevelForPhoenixLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final ranges = _paragraphEventRanges(level);
  return JourneyLevelContent(
    storyParagraphs: [
      for (final range in ranges)
        summerPalaceN1SemanticEvents
            .sublist(range.$1, range.$2)
            .map((event) => _eventChinese(event, level))
            .join(),
    ],
    storyAnnotations: [
      for (final range in ranges)
        ReadingAnnotation(
          pinyin: summerPalaceN1SemanticEvents
              .sublist(range.$1, range.$2)
              .map((event) => _eventPinyin(event, level))
              .join(' '),
          vietnamese: summerPalaceN1SemanticEvents
              .sublist(range.$1, range.$2)
              .map((event) => _eventVietnamese(event, level))
              .join(' '),
          english: summerPalaceN1SemanticEvents
              .sublist(range.$1, range.$2)
              .map((event) => _eventEnglish(event, level))
              .join(' '),
        ),
    ],
    words: const [],
    discoveries: summerPalaceDiscoveryEntriesForLevel(level),
    wonderQuestion: summerPalaceWonderForLevel(level),
    expressQuestion: summerPalaceExpressForLevel(level),
  );
}

List<SummerPalaceN1EventId> summerPalaceN1EventOrderForLevel(int level) {
  level.clamp(1, 10);
  return List<SummerPalaceN1EventId>.unmodifiable(summerPalaceN1RequiredEventOrder);
}

List<(int, int)> _paragraphEventRanges(int level) =>
    level <= 2 ? const [(0, 14)] : const [(0, 7), (7, 14)];

String _eventChinese(SummerPalaceN1SemanticEvent event, int level) =>
    '${event.coreChinese}${level >= event.detailFromLevel ? event.detailChinese : ''}${level >= event.masteryFromLevel ? event.masteryChinese : ''}';

String _eventPinyin(SummerPalaceN1SemanticEvent event, int level) =>
    '${event.corePinyin}${level >= event.detailFromLevel ? ' ${event.detailPinyin}' : ''}${level >= event.masteryFromLevel ? ' ${event.masteryPinyin}' : ''}';

String _eventVietnamese(SummerPalaceN1SemanticEvent event, int level) =>
    '${event.coreVietnamese}${level >= event.detailFromLevel ? ' ${event.detailVietnamese}' : ''}${level >= event.masteryFromLevel ? ' ${event.masteryVietnamese}' : ''}';

String _eventEnglish(SummerPalaceN1SemanticEvent event, int level) =>
    '${event.coreEnglish}${level >= event.detailFromLevel ? ' ${event.detailEnglish}' : ''}${level >= event.masteryFromLevel ? ' ${event.masteryEnglish}' : ''}';

String summerPalaceWonderForLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  if (level <= 2) {
    return '桥洞的金光正在移动，许澄为什么还是先去捡外婆的旧照片？';
  }
  if (level <= 4) {
    return '十七孔桥的位置、移动的光线和她们走过的路线，怎样改变了许澄当天的行动？';
  }
  if (level <= 6) {
    return '许澄和外婆看到的是同一座颐和园，为什么她们一开始想留下的东西却不一样？';
  }
  if (level <= 8) {
    return '为什么同一座十七孔桥，在不同季节、时间和站位下，会让许澄面对不同的拍摄机会？';
  }
  return '一处经历过损毁和修复的文化遗产，是否应该努力让人看起来它从未受损？为什么？';
}

String summerPalaceExpressForLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  if (level <= 2) {
    return '请用两到三句话写出发生了什么、许澄怎样选择，以及她最后失去了什么、保住了什么。';
  }
  if (level <= 4) {
    return '请用三句话写出十七孔桥、东堤、南湖岛和许澄站的位置，并说明这些地点怎样影响她的行动。';
  }
  if (level <= 6) {
    return '请用三到四句话写出旧照片上的修复记录、许澄想要的“无瑕”画面，以及外婆为什么请她换一种看法。';
  }
  if (level <= 8) {
    return '请用三到四句话说明冬至前后的季节、桥的方向、许澄的站位和桥洞光线怎样共同影响她的拍摄机会。';
  }
  return '请用三到五句话写一段校展说明。结合旧照片、“无瑕”和许澄最后留下的画面，写出你对保存历史痕迹的看法。';
}

bool summerPalaceN1ContainsGenericTouristEnrichment(JourneyLevelContent level) {
  final story = level.storyParagraphs.join();
  return const [
    '你先停下来',
    '你沿着主要路线向前',
    '游客举起手机',
    '探索者来到',
    '景点不是孤立',
  ].any(story.contains);
}
