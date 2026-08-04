import 'journey_data.dart';
import 'journey_level_catalog.dart';
import 'summer_palace_journey.dart';

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

const summerPalaceN1SemanticEvents = <SummerPalaceN1SemanticEvent>[
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.protagonist,
    coreChinese: '十七岁的学生摄影者许澄来到颐和园。',
    corePinyin: 'Shíqī suì de xuéshēng shèyǐngzhě Xǔ Chéng láidào Yíhéyuán.',
    coreVietnamese: 'Hứa Trừng, một nữ sinh nhiếp ảnh mười bảy tuổi, đến Di Hòa Viên.',
    coreEnglish: 'Seventeen-year-old student photographer Xu Cheng arrives at the Summer Palace.',
    detailChinese: '校展截稿只剩一天，她背着相机沿外婆熟悉的旧路线前行。',
    detailPinyin: 'Xiàozhǎn jiégǎo zhǐ shèng yì tiān, tā bēizhe xiàngjī yán wàipó shúxī de jiù lùxiàn qiánxíng.',
    detailVietnamese: 'Chỉ còn một ngày trước hạn triển lãm, cô mang máy ảnh đi theo tuyến đường cũ mà bà ngoại quen thuộc.',
    detailEnglish: 'With one day left before the exhibition deadline, she carries her camera along the old route her grandmother knows.',
    detailFromLevel: 3,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.schoolExhibitionGoal,
    coreChinese: '她要为校展拍照。',
    corePinyin: 'Tā yào wèi xiàozhǎn pāizhào.',
    coreVietnamese: 'Cô phải chụp một tác phẩm cho triển lãm trường.',
    coreEnglish: 'She must make a photograph for the school exhibition.',
    detailChinese: '她想交出一张完整、明亮、看不见缺点的皇家园林作品。',
    detailPinyin: 'Tā xiǎng jiāochū yì zhāng wánzhěng, míngliàng, kàn bú jiàn quēdiǎn de huángjiā yuánlín zuòpǐn.',
    detailVietnamese: 'Cô muốn nộp một bức ảnh vườn hoàng gia hoàn chỉnh, sáng rõ và không thấy khuyết điểm.',
    detailEnglish: 'She wants to submit a complete, bright imperial-garden image with no visible flaws.',
    detailFromLevel: 5,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.independenceMotive,
    coreChinese: '她想证明不需要外婆周岚指导。',
    corePinyin: 'Tā xiǎng zhèngmíng bù xūyào wàipó Zhōu Lán zhǐdǎo.',
    coreVietnamese: 'Cô muốn chứng minh mình không cần bà ngoại Chu Lam hướng dẫn.',
    coreEnglish: 'She wants to prove she no longer needs guidance from her grandmother Zhou Lan.',
    detailChinese: '对她来说，“无瑕”不只是审美，也是摆脱外婆意见的证明。',
    detailPinyin: 'Duì tā láishuō, wúxiá bù zhǐ shì shěnměi, yě shì bǎituō wàipó yìjiàn de zhèngmíng.',
    detailVietnamese: 'Với cô, “không tì vết” không chỉ là thẩm mỹ mà còn là bằng chứng thoát khỏi ý kiến của bà.',
    detailEnglish: 'For her, flawlessness is not only an aesthetic but proof that she can work without her grandmother’s judgment.',
    detailFromLevel: 6,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.grandmotherConservationBackground,
    coreChinese: '周岚曾保护长廊彩画。',
    corePinyin: 'Zhōu Lán céng bǎohù Chángláng cǎihuà.',
    coreVietnamese: 'Chu Lam từng bảo tồn tranh màu ở Trường Lang.',
    coreEnglish: 'Zhou Lan once conserved the painted decoration of the Long Corridor.',
    detailChinese: '她年轻时参与修复，如今视力衰退，仍记得褪色、裂纹和补绘的位置。',
    detailPinyin: 'Tā niánqīng shí cānyù xiūfù, rújīn shìlì shuāituì, réng jìde tuìsè, lièwén hé bǔhuì de wèizhì.',
    detailVietnamese: 'Bà từng tham gia phục hồi; dù thị lực suy giảm, bà vẫn nhớ vị trí màu phai, vết nứt và phần vẽ bổ sung.',
    detailEnglish: 'She took part in restoration and, despite failing eyesight, remembers the faded pigment, cracks, and retouching.',
    detailFromLevel: 5,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.valuesConflict,
    coreChinese: '许澄要无瑕画面，周岚要她看修复痕迹。',
    corePinyin: 'Xǔ Chéng yào wúxiá huàmiàn, Zhōu Lán yào tā kàn xiūfù hénjì.',
    coreVietnamese: 'Hứa Trừng muốn khung hình không tì vết, còn Chu Lam muốn cô nhìn dấu vết phục hồi.',
    coreEnglish: 'Xu Cheng wants a flawless image, while Zhou Lan asks her to see restoration traces.',
    detailChinese: '长廊里，外婆让她观察廊柱怎样遮住远山，又从下一个开口送回湖面；许澄却坚持把旧伤排除在镜头外。',
    detailPinyin: 'Chángláng lǐ, wàipó ràng tā guānchá lángzhù zěnyàng zhēzhù yuǎnshān, yòu cóng xià yí gè kāikǒu sòng huí húmiàn; Xǔ Chéng què jiānchí bǎ jiùshāng páichú zài jìngtóu wài.',
    detailVietnamese: 'Trong Trường Lang, bà bảo cô quan sát cột che núi xa rồi mở lại mặt hồ ở khoảng tiếp theo; Hứa Trừng vẫn muốn loại các vết thương cũ khỏi ống kính.',
    detailEnglish: 'In the Long Corridor, Zhou Lan shows how columns hide the hill and return the lake at the next opening, but Xu Cheng insists on excluding old damage.',
    detailFromLevel: 4,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.photographFalls,
    coreChinese: '十七孔桥旁，最佳光线出现，旧照片也被风吹落。',
    corePinyin: 'Shíqīkǒng Qiáo páng, zuìjiā guāngxiàn chūxiàn, jiù zhàopiàn yě bèi fēng chuīluò.',
    coreVietnamese: 'Bên cầu Thập Thất Khổng, ánh sáng đẹp nhất xuất hiện đúng lúc bức ảnh cũ bị gió thổi rơi.',
    coreEnglish: 'By the Seventeen-Arch Bridge, the best light arrives just as an old photograph falls in the wind.',
    detailChinese: '照片里是修复前的长廊，裂开彩画旁站着年轻的周岚和已经去世的老师。',
    detailPinyin: 'Zhàopiàn lǐ shì xiūfù qián de Chángláng, lièkāi cǎihuà páng zhànzhe niánqīng de Zhōu Lán hé yǐjīng qùshì de lǎoshī.',
    detailVietnamese: 'Trong ảnh là Trường Lang trước phục hồi, với Chu Lam trẻ tuổi và người thầy đã mất đứng cạnh tranh màu nứt vỡ.',
    detailEnglish: 'The photograph shows the corridor before restoration, with young Zhou Lan and her late teacher beside cracked paintings.',
    detailFromLevel: 3,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.forcedChoice,
    coreChinese: '她必须在追光和捡照片之间选择。',
    corePinyin: 'Tā bìxū zài zhuīguāng hé jiǎn zhàopiàn zhījiān xuǎnzé.',
    coreVietnamese: 'Cô phải chọn giữa đuổi theo ánh sáng và nhặt bức ảnh.',
    coreEnglish: 'She must choose between chasing the light and retrieving the photograph.',
    detailChinese: '两个动作不能同时完成：继续举起相机会保住标准风景，却可能让外婆的旧照片落入湖边。',
    detailPinyin: 'Liǎng gè dòngzuò bùnéng tóngshí wánchéng: jìxù jǔqǐ xiàngjī huì bǎozhù biāozhǔn fēngjǐng, què kěnéng ràng wàipó de jiù zhàopiàn luòrù húbiān.',
    detailVietnamese: 'Hai hành động không thể thực hiện cùng lúc: tiếp tục giơ máy sẽ giữ cảnh chuẩn nhưng có thể để ảnh cũ của bà rơi xuống mép hồ.',
    detailEnglish: 'The actions are incompatible: keeping the camera raised preserves the standard view but risks losing her grandmother’s photograph.',
    detailFromLevel: 7,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.enactedChoice,
    coreChinese: '她放弃原构图，先捡回照片。',
    corePinyin: 'Tā fàngqì yuán gòutú, xiān jiǎn huí zhàopiàn.',
    coreVietnamese: 'Cô bỏ bố cục ban đầu và nhặt bức ảnh trước.',
    coreEnglish: 'She abandons her original composition and retrieves the photograph first.',
    detailChinese: '她放下相机，蹲身拾起斑驳纸角，再退到桥侧重新寻找位置。',
    detailPinyin: 'Tā fàngxià xiàngjī, dūnshēn shíqǐ bānbó zhǐjiǎo, zài tuì dào qiáocè chóngxīn xúnzhǎo wèizhì.',
    detailVietnamese: 'Cô hạ máy, cúi nhặt góc giấy sờn rồi lùi sang bên cầu để tìm lại vị trí.',
    detailEnglish: 'She lowers the camera, crouches to lift the worn paper, and steps to the side of the bridge to find a new position.',
    detailFromLevel: 5,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.lostLight,
    coreChinese: '因此，她错失最佳光线。',
    corePinyin: 'Yīncǐ, tā cuòshī zuìjiā guāngxiàn.',
    coreVietnamese: 'Vì lựa chọn ấy, cô lỡ ánh sáng đẹp nhất.',
    coreEnglish: 'Because of that choice, she loses the best light.',
    detailChinese: '快门再次抬起时，阳光已经偏移，明信片式的湖山画面消失了。',
    detailPinyin: 'Kuàimén zàicì táiqǐ shí, yángguāng yǐjīng piānyí, míngxìnpiàn shì de húshān huàmiàn xiāoshī le.',
    detailVietnamese: 'Khi cô nâng máy trở lại, nắng đã lệch và khung hồ núi kiểu bưu thiếp biến mất.',
    detailEnglish: 'When she raises the camera again, the sunlight has shifted and the postcard lake-and-hill view is gone.',
    detailFromLevel: 2,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.threeLayerComposition,
    coreChinese: '她重拍旧照、外婆的手和远处万寿山。',
    corePinyin: 'Tā chóngpāi jiùzhào, wàipó de shǒu hé yuǎnchù Wànshòu Shān.',
    coreVietnamese: 'Cô chụp lại bức ảnh cũ, bàn tay bà và núi Vạn Thọ phía xa.',
    coreEnglish: 'She reframes the old photograph, her grandmother’s hand, and distant Longevity Hill.',
    detailChinese: '近处斑驳纸角、中间扶栏的手和桥孔后的山形成三层对景，把修复者与被修复园林放进同一关系。',
    detailPinyin: 'Jìnchù bānbó zhǐjiǎo, zhōngjiān fúlán de shǒu hé qiáokǒng hòu de shān xíngchéng sān céng duìjǐng, bǎ xiūfùzhě yǔ bèi xiūfù yuánlín fàng jìn tóng yí guānxì.',
    detailVietnamese: 'Góc giấy sờn ở gần, bàn tay trên lan can ở giữa và ngọn núi sau vòm cầu tạo ba lớp đối cảnh, đặt người phục hồi và khu vườn trong cùng một quan hệ.',
    detailEnglish: 'The worn paper in front, the hand on the railing in the middle, and the hill beyond the arches form three layers linking the restorer and garden.',
    detailFromLevel: 4,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.workTitle,
    coreChinese: '作品名为《留下痕迹的风景》。',
    corePinyin: 'Zuòpǐn míng wéi “Liúxià Hénjì de Fēngjǐng”.',
    coreVietnamese: 'Tác phẩm được đặt tên “Phong cảnh lưu lại dấu vết”.',
    coreEnglish: 'The work is titled “A Landscape That Keeps Its Traces.”',
    detailChinese: '这个名字拒绝把损毁伪装成从未发生，也让校展目标从“无瑕”转向“可阅读”。',
    detailPinyin: 'Zhège míngzi jùjué bǎ sǔnhuǐ wěizhuāng chéng cóngwèi fāshēng, yě ràng xiàozhǎn mùbiāo cóng wúxiá zhuǎnxiàng kě yuèdú.',
    detailVietnamese: 'Tên gọi từ chối giả vờ tổn hại chưa từng xảy ra và chuyển mục tiêu triển lãm từ “không tì vết” sang “có thể đọc được”.',
    detailEnglish: 'The title refuses to pretend damage never happened and turns the exhibition goal from flawlessness toward readability.',
    detailFromLevel: 8,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.trustChange,
    coreChinese: '周岚不再替她调整构图。',
    corePinyin: 'Zhōu Lán bù zài tì tā tiáozhěng gòutú.',
    coreVietnamese: 'Chu Lam không còn chỉnh bố cục thay cô.',
    coreEnglish: 'Zhou Lan no longer adjusts the composition for her.',
    detailChinese: '她第一次用沉默承认许澄已经作出自己的摄影判断。',
    detailPinyin: 'Tā dì yí cì yòng chénmò chéngrèn Xǔ Chéng yǐjīng zuòchū zìjǐ de shèyǐng pànduàn.',
    detailVietnamese: 'Lần đầu tiên, sự im lặng của bà thừa nhận Hứa Trừng đã có phán đoán nhiếp ảnh của riêng mình.',
    detailEnglish: 'For the first time, her silence acknowledges that Xu Cheng has made her own photographic judgment.',
    detailFromLevel: 6,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.photographEntrusted,
    coreChinese: '她把旧照片交给许澄保存。',
    corePinyin: 'Tā bǎ jiù zhàopiàn jiāogěi Xǔ Chéng bǎocún.',
    coreVietnamese: 'Bà giao bức ảnh cũ cho Hứa Trừng gìn giữ.',
    coreEnglish: 'She entrusts the old photograph to Xu Cheng.',
    detailChinese: '这份托付把外婆的修复记忆变成许澄今后要承担的责任。',
    detailPinyin: 'Zhè fèn tuōfù bǎ wàipó de xiūfù jìyì biàn chéng Xǔ Chéng jīnhòu yào chéngdān de zérèn.',
    detailVietnamese: 'Sự gửi gắm biến ký ức phục hồi của bà thành trách nhiệm Hứa Trừng phải mang về sau.',
    detailEnglish: 'The trust turns her grandmother’s conservation memory into a responsibility Xu Cheng will carry.',
    detailFromLevel: 7,
  ),
  SummerPalaceN1SemanticEvent(
    id: SummerPalaceN1EventId.changedUnderstanding,
    coreChinese: '许澄不再只想证明独立。',
    corePinyin: 'Xǔ Chéng bù zài zhǐ xiǎng zhèngmíng dúlì.',
    coreVietnamese: 'Hứa Trừng không còn chỉ muốn chứng minh sự độc lập.',
    coreEnglish: 'Xu Cheng no longer seeks only to prove her independence.',
    detailChinese: '她理解修复不是抹去痕迹，而是让失去、选择、守护与关系继续被后来的人读见。',
    detailPinyin: 'Tā lǐjiě xiūfù bú shì mǒqù hénjì, ér shì ràng shīqù, xuǎnzé, shǒuhù yǔ guānxì jìxù bèi hòulái de rén dújiàn.',
    detailVietnamese: 'Cô hiểu phục hồi không xóa dấu vết mà giúp người sau tiếp tục đọc được mất mát, lựa chọn, gìn giữ và quan hệ.',
    detailEnglish: 'She understands that restoration does not erase traces; it keeps loss, choice, care, and relationship readable for later viewers.',
    detailFromLevel: 2,
  ),
];

List<SummerPalaceN1EventId> summerPalaceN1EventOrderForLevel(int level) =>
    List<SummerPalaceN1EventId>.unmodifiable(
      summerPalaceN1SemanticEvents.map((event) => event.id),
    );

JourneyLevelContent summerPalaceN1LevelForPhoenixLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final paragraphs = _paragraphEventRanges(level);
  final storyParagraphs = <String>[];
  final annotations = <ReadingAnnotation>[];

  for (final range in paragraphs) {
    final events = summerPalaceN1SemanticEvents.sublist(range.$1, range.$2);
    storyParagraphs.add(events.map((event) => _eventChinese(event, level)).join());
    annotations.add(
      ReadingAnnotation(
        pinyin: events.map((event) => _eventPinyin(event, level)).join(' '),
        vietnamese: events.map((event) => _eventVietnamese(event, level)).join(' '),
        english: events.map((event) => _eventEnglish(event, level)).join(' '),
      ),
    );
  }

  final discoveryCount = level <= 2 ? 1 : 2;
  return JourneyLevelContent(
    storyParagraphs: storyParagraphs,
    storyAnnotations: annotations,
    words: const <WordEntry>[],
    discoveries: summerPalaceDiscoveries.take(discoveryCount).toList(growable: false),
    wonderQuestion: level <= 3
        ? '许澄的选择为什么让她错过光线，却得到外婆的信任？'
        : '许澄怎样把“无瑕”的目标改成了对修复、时间与关系的判断？',
    expressQuestion: level <= 3
        ? '请按顺序写出旧照片掉落、许澄选择、错失光线和外婆托付四件事。'
        : '请说明三层构图怎样连接许澄的选择、照片后果与周岚的信任。',
  );
}

List<(int, int)> _paragraphEventRanges(int level) =>
    level <= 2 ? const <(int, int)>[(0, 14)] : const <(int, int)>[(0, 7), (7, 14)];

String _eventChinese(SummerPalaceN1SemanticEvent event, int level) =>
    '${event.coreChinese}${level >= event.detailFromLevel ? event.detailChinese : ''}'
    '${event.id == SummerPalaceN1EventId.changedUnderstanding ? _masteryChinese(level) : ''}';

String _eventPinyin(SummerPalaceN1SemanticEvent event, int level) =>
    '${event.corePinyin}${level >= event.detailFromLevel ? ' ${event.detailPinyin}' : ''}'
    '${event.id == SummerPalaceN1EventId.changedUnderstanding ? _masteryPinyin(level) : ''}';

String _eventVietnamese(SummerPalaceN1SemanticEvent event, int level) =>
    '${event.coreVietnamese}${level >= event.detailFromLevel ? ' ${event.detailVietnamese}' : ''}'
    '${event.id == SummerPalaceN1EventId.changedUnderstanding ? _masteryVietnamese(level) : ''}';

String _eventEnglish(SummerPalaceN1SemanticEvent event, int level) =>
    '${event.coreEnglish}${level >= event.detailFromLevel ? ' ${event.detailEnglish}' : ''}'
    '${event.id == SummerPalaceN1EventId.changedUnderstanding ? _masteryEnglish(level) : ''}';

String _masteryChinese(int level) {
  if (level < 9) return '';
  final analysis = ' 她也看见，所谓独立不是拒绝前人的经验，而是能够说明自己为何选择、愿意承担何种损失。';
  if (level < 10) return analysis;
  return '$analysis 她把园林保护理解为一种可追溯的责任：原作、损伤、补绘与修复者都不该被单一的“完美”遮蔽；摄影则必须公开自己的取舍，使观看者能够辨认时间如何进入画面。';
}

String _masteryPinyin(int level) {
  if (level < 9) return '';
  final analysis = ' Tā yě kànjiàn, suǒwèi dúlì bú shì jùjué qiánrén de jīngyàn, ér shì nénggòu shuōmíng zìjǐ wèihé xuǎnzé, yuànyì chéngdān hézhǒng sǔnshī.';
  if (level < 10) return analysis;
  return '$analysis Tā bǎ yuánlín bǎohù lǐjiě wéi yì zhǒng kě zhuīsù de zérèn: yuánzuò, sǔnshāng, bǔhuì yǔ xiūfùzhě dōu bù gāi bèi dānyī de wánměi zhēbì; shèyǐng zé bìxū gōngkāi zìjǐ de qǔshě, shǐ guānkànzhě nénggòu biànrèn shíjiān rúhé jìnrù huàmiàn.';
}

String _masteryVietnamese(int level) {
  if (level < 9) return '';
  final analysis = ' Cô cũng nhận ra độc lập không phải từ chối kinh nghiệm của người đi trước, mà là giải thích được vì sao mình lựa chọn và sẵn sàng chịu mất mát nào.';
  if (level < 10) return analysis;
  return '$analysis Cô hiểu bảo tồn khu vườn là trách nhiệm có thể truy nguyên: nguyên tác, hư hại, phần vẽ bổ sung và người phục hồi không được che khuất dưới một ý niệm “hoàn hảo”; nhiếp ảnh cũng phải công khai sự lựa chọn để người xem nhận ra thời gian đi vào hình ảnh thế nào.';
}

String _masteryEnglish(int level) {
  if (level < 9) return '';
  final analysis = ' She also sees that independence does not mean rejecting inherited experience, but explaining why she chooses and what loss she accepts.';
  if (level < 10) return analysis;
  return '$analysis She comes to understand conservation as traceable responsibility: original work, damage, retouching, and restorers must not be hidden by a single ideal of perfection; photography must disclose its choices so viewers can recognize how time enters the image.';
}

bool summerPalaceN1ContainsGenericTouristEnrichment(JourneyLevelContent level) {
  final story = level.storyParagraphs.join();
  return const <String>[
    '你先停下来',
    '你沿着主要路线向前',
    '游客举起手机',
    '探索者来到',
    '景点不是孤立',
  ].any(story.contains);
}
