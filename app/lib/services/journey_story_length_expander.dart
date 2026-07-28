import '../data/daily_journey_experience.dart';
import '../data/journey_data.dart';
import '../data/journey_level_catalog.dart';
import '../models/language_proficiency.dart';
import 'phoenix_story_length_policy.dart';

class JourneyStoryEnrichmentPacket {
  const JourneyStoryEnrichmentPacket({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;
}

class _StoryPacket {
  const _StoryPacket({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  factory _StoryPacket.fromEnrichment(JourneyStoryEnrichmentPacket packet) {
    return _StoryPacket(
      chinese: packet.chinese,
      pinyin: packet.pinyin,
      vietnamese: packet.vietnamese,
      english: packet.english,
    );
  }

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;
}

JourneyLevelContent expandJourneyStoryToTarget(
  DailyJourneyExperience experience,
  JourneyLevelContent content, {
  required ChineseProficiencyProfile profile,
}) {
  final source = _packetsFromContent(content);
  if (source.isEmpty) return content;

  final target = phoenixStoryLengthTargetFor(profile);
  final allEnrichment = _enrichmentFor(experience.id);
  final preferredEnrichment = allEnrichment
      .take(target.enrichmentPacketCount)
      .map(_StoryPacket.fromEnrichment)
      .toList(growable: false);
  final reserveEnrichment = allEnrichment
      .skip(target.enrichmentPacketCount)
      .map(_StoryPacket.fromEnrichment)
      .toList(growable: false);

  final opening = source.first;
  final closing = source.length > 1 ? source.last : null;
  final sourceMiddle = source.length > 2
      ? source.sublist(1, source.length - 1)
      : const <_StoryPacket>[];
  final selected = <_StoryPacket>[opening];
  final candidates = <_StoryPacket>[
    ...sourceMiddle,
    ...preferredEnrichment,
  ];

  for (final packet in candidates) {
    final projected = _characterCount(selected) +
        packet.chinese.runes.length +
        (closing?.chinese.runes.length ?? 0);
    if (projected > target.maximumCharacters) continue;
    selected.add(packet);
    if (projected >= target.preferredCharacters) break;
  }

  if (closing != null) selected.add(closing);

  if (_characterCount(selected) < target.minimumCharacters) {
    final insertionIndex = closing == null ? selected.length : selected.length - 1;
    for (final packet in reserveEnrichment) {
      final projected = _characterCount(selected) + packet.chinese.runes.length;
      if (projected > target.maximumCharacters) continue;
      selected.insert(insertionIndex, packet);
      if (_characterCount(selected) >= target.minimumCharacters) break;
    }
  }

  final groups = _partition(selected, target.paragraphCount);
  return JourneyLevelContent(
    storyParagraphs: groups
        .map((group) => _joinChinese(group.map((packet) => packet.chinese)))
        .toList(growable: false),
    storyAnnotations: groups
        .map(
          (group) => ReadingAnnotation(
            pinyin: _joinLatin(group.map((packet) => packet.pinyin)),
            vietnamese: _joinLatin(group.map((packet) => packet.vietnamese)),
            english: _joinLatin(group.map((packet) => packet.english)),
          ),
        )
        .toList(growable: false),
    words: content.words,
    discoveries: content.discoveries,
    wonderQuestion: content.wonderQuestion,
    expressQuestion: content.expressQuestion,
  );
}

List<_StoryPacket> _packetsFromContent(JourneyLevelContent content) {
  final packets = <_StoryPacket>[];
  for (var paragraphIndex = 0;
      paragraphIndex < content.storyParagraphs.length;
      paragraphIndex += 1) {
    final chinese = _splitChinese(content.storyParagraphs[paragraphIndex]);
    if (chinese.isEmpty) continue;
    final annotation = content.storyAnnotations[
      paragraphIndex.clamp(0, content.storyAnnotations.length - 1).toInt()
    ];
    final pinyin = _splitLatin(annotation.pinyin);
    final vietnamese = _splitLatin(annotation.vietnamese);
    final english = _splitLatin(annotation.english);

    for (var index = 0; index < chinese.length; index += 1) {
      packets.add(
        _StoryPacket(
          chinese: chinese[index],
          pinyin: _mappedSentence(pinyin, index, chinese.length),
          vietnamese: _mappedSentence(vietnamese, index, chinese.length),
          english: _mappedSentence(english, index, chinese.length),
        ),
      );
    }
  }
  return packets;
}

String _mappedSentence(List<String> source, int index, int targetLength) {
  if (source.isEmpty) return '';
  if (source.length == 1 || targetLength <= 1) return source.first;
  final mapped = (index * source.length / targetLength)
      .floor()
      .clamp(0, source.length - 1)
      .toInt();
  return source[mapped];
}

List<List<_StoryPacket>> _partition(
  List<_StoryPacket> packets,
  int paragraphCount,
) {
  if (paragraphCount <= 1 || packets.length <= 1) {
    return <List<_StoryPacket>>[packets];
  }

  var bestSplit = 1;
  var bestScore = 1 << 30;
  final total = _characterCount(packets);
  var leftCharacters = 0;
  for (var split = 1; split < packets.length; split += 1) {
    leftCharacters += packets[split - 1].chinese.runes.length;
    final balance = (leftCharacters * 2 - total).abs();
    final dependentPenalty = _startsWithDependentReference(
      packets[split].chinese,
    )
        ? 1000
        : 0;
    final score = balance + dependentPenalty;
    if (score < bestScore) {
      bestScore = score;
      bestSplit = split;
    }
  }

  return <List<_StoryPacket>>[
    packets.take(bestSplit).toList(growable: false),
    packets.skip(bestSplit).toList(growable: false),
  ];
}

int _characterCount(Iterable<_StoryPacket> packets) => packets.fold(
      0,
      (total, packet) => total + packet.chinese.runes.length,
    );

bool _startsWithDependentReference(String value) => RegExp(
      r'^(它|他|她|他们|她们|这|那|因此|于是|所以|然而|但是|但|同时|其中|此时|后来|随后|最后|而且|也|其|这种|这些|这里|那里)',
    ).hasMatch(value.trim());

List<String> _splitChinese(String value) => RegExp(r'[^。！？!?]+[。！？!?]?')
    .allMatches(value.trim())
    .map((match) => match.group(0)?.trim() ?? '')
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

List<String> _splitLatin(String value) => RegExp(r'[^.!?]+[.!?]?')
    .allMatches(value.trim())
    .map((match) => match.group(0)?.trim() ?? '')
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

String _joinChinese(Iterable<String> values) => values
    .map((value) => value.trim())
    .where((value) => value.isNotEmpty)
    .join();

String _joinLatin(Iterable<String> values) => values
    .map((value) => value.trim())
    .where((value) => value.isNotEmpty)
    .join(' ');

List<JourneyStoryEnrichmentPacket> _enrichmentFor(String journeyId) {
  final category = _categoryPackets(journeyId);
  return <JourneyStoryEnrichmentPacket>[
    ..._openingEnrichment,
    category.first,
    ..._middleEnrichment,
    category.last,
    ..._advancedEnrichment,
  ];
}

List<JourneyStoryEnrichmentPacket> _categoryPackets(String journeyId) {
  if (journeyId.contains('forbidden-city') ||
      journeyId.contains('summer-palace')) {
    return _palaceAndGardenEnrichment;
  }
  if (journeyId.contains('bund') ||
      journeyId.contains('west-lake') ||
      journeyId.contains('qinhuai')) {
    return _waterfrontEnrichment;
  }
  return _urbanHeritageEnrichment;
}

const _openingEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '你先停下来，看看四周的颜色、声音和人。',
    pinyin: 'Nǐ xiān tíng xiàlai, kànkan sìzhōu de yánsè, shēngyīn hé rén.',
    vietnamese: 'Bạn dừng lại trước tiên để quan sát màu sắc, âm thanh và con người xung quanh.',
    english: 'You pause first and notice the colors, sounds, and people around you.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '脚步慢下来以后，原来没有注意的细节开始出现。',
    pinyin: 'Jiǎobù màn xiàlai yǐhòu, yuánlái méiyǒu zhùyì de xìjié kāishǐ chūxiàn.',
    vietnamese: 'Khi bước chân chậm lại, những chi tiết trước đó chưa được chú ý bắt đầu hiện ra.',
    english: 'As your pace slows, details that were previously unnoticed begin to appear.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '近处的门窗、台阶和道路告诉你，人们怎样进入和离开这里。',
    pinyin: 'Jìnchù de ménchuāng, táijiē hé dàolù gàosu nǐ, rénmen zěnyàng jìnrù hé líkāi zhèlǐ.',
    vietnamese: 'Cửa, cửa sổ, bậc thềm và lối đi gần đó cho thấy con người đã vào và rời nơi này như thế nào.',
    english: 'Nearby doors, windows, steps, and paths reveal how people entered and left this place.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '远处的屋顶、树影和天空连在一起，让空间显得更开阔。',
    pinyin: 'Yuǎnchù de wūdǐng, shùyǐng hé tiānkōng lián zài yìqǐ, ràng kōngjiān xiǎnde gèng kāikuò.',
    vietnamese: 'Mái nhà, bóng cây và bầu trời ở xa nối liền với nhau, khiến không gian trở nên rộng mở hơn.',
    english: 'Distant roofs, tree shadows, and sky connect to make the space feel more open.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '你沿着主要路线向前，每走一段就回头比较刚才的景色。',
    pinyin: 'Nǐ yánzhe zhǔyào lùxiàn xiàng qián, měi zǒu yí duàn jiù huítóu bǐjiào gāngcái de jǐngsè.',
    vietnamese: 'Bạn đi theo tuyến chính và thỉnh thoảng quay lại so sánh cảnh vật vừa đi qua.',
    english: 'You follow the main route and occasionally look back to compare the view you just passed.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '同一处景物从不同方向看，会改变距离、层次和重点。',
    pinyin: 'Tóng yí chù jǐngwù cóng bùtóng fāngxiàng kàn, huì gǎibiàn jùlí, céngcì hé zhòngdiǎn.',
    vietnamese: 'Cùng một cảnh vật khi nhìn từ các hướng khác nhau sẽ thay đổi khoảng cách, lớp lang và trọng tâm.',
    english: 'The same scene changes its distance, layers, and emphasis when viewed from different directions.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '阳光移动时，墙面、石路和水面上的颜色也跟着变化。',
    pinyin: 'Yángguāng yídòng shí, qiángmiàn, shílù hé shuǐmiàn shàng de yánsè yě gēnzhe biànhuà.',
    vietnamese: 'Khi ánh nắng dịch chuyển, màu sắc trên tường, đường đá và mặt nước cũng thay đổi theo.',
    english: 'As sunlight moves, the colors on walls, stone paths, and water change with it.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '建筑材料留下磨损和修补的痕迹，时间因此不再只是一个抽象的年代。',
    pinyin: 'Jiànzhù cáiliào liúxià mósǔn hé xiūbǔ de hénjì, shíjiān yīncǐ bú zài zhǐ shì yí gè chōuxiàng de niándài.',
    vietnamese: 'Vật liệu kiến trúc lưu lại dấu mòn và sửa chữa, khiến thời gian không còn chỉ là một niên đại trừu tượng.',
    english: 'Wear and repairs remain in the building materials, making time more than an abstract date.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '有人匆匆经过，有人停下阅读，也有人只是安静观察，旧空间被今天重新使用。',
    pinyin: 'Yǒurén cōngcōng jīngguò, yǒurén tíngxià yuèdú, yě yǒurén zhǐshì ānjìng guānchá, jiù kōngjiān bèi jīntiān chóngxīn shǐyòng.',
    vietnamese: 'Có người vội vàng đi qua, có người dừng lại đọc, có người chỉ lặng lẽ quan sát; không gian cũ đang được hôm nay sử dụng lại.',
    english: 'Some people hurry through, some stop to read, and others quietly observe as the old space is used anew today.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '门、窗、屋檐和道路之间的距离，不只影响外观，也安排人的速度和方向。',
    pinyin: 'Mén, chuāng, wūyán hé dàolù zhījiān de jùlí, bù zhǐ yǐngxiǎng wàiguān, yě ānpái rén de sùdù hé fāngxiàng.',
    vietnamese: 'Khoảng cách giữa cửa, cửa sổ, mái hiên và đường đi không chỉ tạo hình thức mà còn điều chỉnh tốc độ và hướng di chuyển.',
    english: 'Distances among doors, windows, eaves, and paths shape not only appearance but also human speed and direction.',
  ),
];

const _middleEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '你开始理解，景点不是孤立的物件，它与周围街道、气候和日常生活保持联系。',
    pinyin: 'Nǐ kāishǐ lǐjiě, jǐngdiǎn bú shì gūlì de wùjiàn, tā yǔ zhōuwéi jiēdào, qìhòu hé rìcháng shēnghuó bǎochí liánxì.',
    vietnamese: 'Bạn bắt đầu hiểu rằng điểm đến không phải vật thể cô lập mà luôn liên hệ với đường phố, khí hậu và đời sống xung quanh.',
    english: 'You begin to understand that a destination is not isolated but connected to nearby streets, climate, and daily life.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '历史没有直接说话，却藏在保留下来的结构、被修复的表面和仍在使用的路线里。',
    pinyin: 'Lìshǐ méiyǒu zhíjiē shuōhuà, què cáng zài bǎoliú xiàlai de jiégòu, bèi xiūfù de biǎomiàn hé réng zài shǐyòng de lùxiàn lǐ.',
    vietnamese: 'Lịch sử không trực tiếp lên tiếng mà ẩn trong kết cấu được giữ lại, bề mặt đã phục hồi và những tuyến đường vẫn được sử dụng.',
    english: 'History does not speak directly; it hides in preserved structures, repaired surfaces, and routes still in use.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '一次普通的行走逐渐变成比较：什么被保存，什么已经消失，什么又被重新解释。',
    pinyin: 'Yí cì pǔtōng de xíngzǒu zhújiàn biànchéng bǐjiào: shénme bèi bǎocún, shénme yǐjīng xiāoshī, shénme yòu bèi chóngxīn jiěshì.',
    vietnamese: 'Một cuộc đi bộ bình thường dần trở thành sự so sánh: điều gì được giữ lại, điều gì đã mất và điều gì được diễn giải lại.',
    english: 'An ordinary walk becomes a comparison of what was preserved, what disappeared, and what was reinterpreted.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '游客举起手机时，古老空间进入新的记忆；照片记录外形，理解却来自停留和思考。',
    pinyin: 'Yóukè jǔqǐ shǒujī shí, gǔlǎo kōngjiān jìnrù xīn de jìyì; zhàopiàn jìlù wàixíng, lǐjiě què láizì tíngliú hé sīkǎo.',
    vietnamese: 'Khi du khách giơ điện thoại, không gian cổ bước vào ký ức mới; ảnh ghi lại hình dáng, còn sự hiểu biết đến từ việc dừng lại và suy nghĩ.',
    english: 'When visitors raise their phones, old space enters new memory; photographs record form, while understanding comes from pausing and thinking.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '你试着想象过去的人走过同一地点，他们看见相似的天空，却受到不同规则和身份限制。',
    pinyin: 'Nǐ shìzhe xiǎngxiàng guòqù de rén zǒuguò tóng yí dìdiǎn, tāmen kànjiàn xiāngsì de tiānkōng, què shòudào bùtóng guīzé hé shēnfèn xiànzhì.',
    vietnamese: 'Bạn thử hình dung người xưa đi qua cùng địa điểm, nhìn thấy bầu trời tương tự nhưng chịu những quy tắc và giới hạn thân phận khác nhau.',
    english: 'You imagine people in the past crossing the same place under a similar sky but within different rules and social limits.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '保护遗产并不是把它冻结，而是在安全、真实、使用和记忆之间不断作出判断。',
    pinyin: 'Bǎohù yíchǎn bìng bú shì bǎ tā dòngjié, ér shì zài ānquán, zhēnshí, shǐyòng hé jìyì zhījiān bùduàn zuòchū pànduàn.',
    vietnamese: 'Bảo tồn di sản không phải đóng băng nó mà là liên tục cân nhắc giữa an toàn, tính chân thực, sử dụng và ký ức.',
    english: 'Protecting heritage does not freeze it; it requires ongoing judgment among safety, authenticity, use, and memory.',
  ),
];

const _advancedEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '宏大的建筑容易吸引目光，真正说明生活方式的却常是栏杆高度、门槛磨损和道路宽度。',
    pinyin: 'Hóngdà de jiànzhù róngyì xīyǐn mùguāng, zhēnzhèng shuōmíng shēnghuó fāngshì de què cháng shì lángān gāodù, ménkǎn mósǔn hé dàolù kuāndù.',
    vietnamese: 'Công trình đồ sộ dễ thu hút ánh nhìn, nhưng chiều cao lan can, độ mòn ngưỡng cửa và độ rộng con đường thường nói rõ hơn về cách sống.',
    english: 'Monumental buildings attract attention, but railing height, worn thresholds, and road width often reveal everyday life more clearly.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '行走路线像一条看不见的线，把分散的景物、历史事件和个人感受连接起来。',
    pinyin: 'Xíngzǒu lùxiàn xiàng yì tiáo kànbujiàn de xiàn, bǎ fēnsàn de jǐngwù, lìshǐ shìjiàn hé gèrén gǎnshòu liánjiē qǐlai.',
    vietnamese: 'Tuyến đi bộ giống một sợi dây vô hình nối cảnh vật rời rạc, sự kiện lịch sử và cảm nhận cá nhân.',
    english: 'The walking route becomes an invisible thread connecting scattered views, historical events, and personal feelings.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '文化空间从来不是单一声音，它既呈现权力与审美，也包含劳动、迁徙、修复和普通人的经验。',
    pinyin: 'Wénhuà kōngjiān cónglái bú shì dānyī shēngyīn, tā jì chéngxiàn quánlì yǔ shěnměi, yě bāohán láodòng, qiānxǐ, xiūfù hé pǔtōng rén de jīngyàn.',
    vietnamese: 'Không gian văn hóa chưa bao giờ chỉ có một tiếng nói; nó thể hiện quyền lực và thẩm mỹ, đồng thời chứa lao động, di cư, phục hồi và trải nghiệm của người bình thường.',
    english: 'Cultural space never has a single voice; it presents power and aesthetics while containing labor, migration, repair, and ordinary experience.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '任何讲述都会选择重点，因此看见被展示的部分时，也需要想到没有被说出的部分。',
    pinyin: 'Rènhé jiǎngshù dōu huì xuǎnzé zhòngdiǎn, yīncǐ kànjiàn bèi zhǎnshì de bùfen shí, yě xūyào xiǎngdào méiyǒu bèi shuōchū de bùfen.',
    vietnamese: 'Mọi cách kể đều chọn trọng tâm, vì vậy khi nhìn phần được trưng bày, ta cũng cần nghĩ đến phần chưa được nói ra.',
    english: 'Every narrative selects an emphasis, so what is displayed should also make us consider what remains unspoken.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '保存下来的形态并不等于完整的过去，今天的修复、管理和观看方式同样参与塑造意义。',
    pinyin: 'Bǎocún xiàlai de xíngtài bìng bù děngyú wánzhěng de guòqù, jīntiān de xiūfù, guǎnlǐ hé guānkàn fāngshì tóngyàng cānyù sùzào yìyì.',
    vietnamese: 'Hình thái còn lại không đồng nghĩa với quá khứ đầy đủ; cách phục hồi, quản lý và quan sát hôm nay cũng tham gia tạo nghĩa.',
    english: 'Preserved form is not the complete past; present-day repair, management, and viewing also shape meaning.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '空间的价值不只来自年代久远，还来自不同世代持续进入、使用、争论并重新理解它。',
    pinyin: 'Kōngjiān de jiàzhí bù zhǐ láizì niándài jiǔyuǎn, hái láizì bùtóng shìdài chíxù jìnrù, shǐyòng, zhēnglùn bìng chóngxīn lǐjiě tā.',
    vietnamese: 'Giá trị của không gian không chỉ đến từ tuổi đời mà còn từ việc nhiều thế hệ tiếp tục bước vào, sử dụng, tranh luận và hiểu lại nó.',
    english: 'A space gains value not only from age but from generations continuing to enter, use, debate, and reinterpret it.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '当历史证据、空间体验和当代生活彼此印证时，遗产才从静态对象变成可以继续阅读的文本。',
    pinyin: 'Dāng lìshǐ zhèngjù, kōngjiān tǐyàn hé dāngdài shēnghuó bǐcǐ yìnzhèng shí, yíchǎn cái cóng jìngtài duìxiàng biànchéng kěyǐ jìxù yuèdú de wénběn.',
    vietnamese: 'Khi bằng chứng lịch sử, trải nghiệm không gian và đời sống đương đại xác nhận lẫn nhau, di sản mới trở thành một văn bản có thể tiếp tục đọc.',
    english: 'When historical evidence, spatial experience, and contemporary life reinforce one another, heritage becomes a text that can keep being read.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '离开前你再次回望，最初分散的细节已经形成关系，而新的问题比一个标准答案更值得带走。',
    pinyin: 'Líkāi qián nǐ zàicì huíwàng, zuìchū fēnsàn de xìjié yǐjīng xíngchéng guānxì, ér xīn de wèntí bǐ yí gè biāozhǔn dáàn gèng zhíde dàizǒu.',
    vietnamese: 'Trước khi rời đi, bạn nhìn lại: những chi tiết rời rạc ban đầu đã tạo thành quan hệ, và câu hỏi mới đáng mang theo hơn một đáp án chuẩn.',
    english: 'Before leaving, you look back: scattered details now form relationships, and a new question is more valuable than a standard answer.',
  ),
];

const _palaceAndGardenEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '轴线、院落和景框把视线一层层引向深处，秩序感来自反复出现的方向与比例。',
    pinyin: 'Zhóuxiàn, yuànluò hé jǐngkuāng bǎ shìxiàn yì céng céng yǐnxiàng shēnchù, zhìxùgǎn láizì fǎnfù chūxiàn de fāngxiàng yǔ bǐlì.',
    vietnamese: 'Trục, sân và khung cảnh dẫn tầm nhìn vào sâu từng lớp; cảm giác trật tự đến từ phương hướng và tỷ lệ lặp lại.',
    english: 'Axes, courtyards, and framed views guide the eye inward, creating order through repeated directions and proportions.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '山水、廊桥或宫门并非单独存在，它们通过开合、遮挡和借景控制观看。',
    pinyin: 'Shānshuǐ, lángqiáo huò gōngmén bìngfēi dāndú cúnzài, tāmen tōngguò kāihé, zhēdǎng hé jièjǐng kòngzhì guānkàn.',
    vietnamese: 'Núi nước, hành lang cầu hoặc cổng cung không tồn tại riêng lẻ mà điều khiển góc nhìn bằng mở khép, che chắn và mượn cảnh.',
    english: 'Landscape, corridors, bridges, and gates work together through opening, concealment, and borrowed scenery to direct viewing.',
  ),
];

const _waterfrontEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '水面不断改变倒影和距离，岸线因此既是道路，也是观察城市时间的坐标。',
    pinyin: 'Shuǐmiàn bùduàn gǎibiàn dàoyǐng hé jùlí, ànxiàn yīncǐ jì shì dàolù, yě shì guānchá chéngshì shíjiān de zuòbiāo.',
    vietnamese: 'Mặt nước liên tục thay đổi phản chiếu và khoảng cách, vì thế bờ vừa là lối đi vừa là tọa độ để quan sát thời gian đô thị.',
    english: 'Water continually changes reflections and distance, making the shoreline both a route and a measure of urban time.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '桥、堤岸和临水建筑把两边生活连接起来，流动的水也提醒人们城市从未静止。',
    pinyin: 'Qiáo, dīàn hé línshuǐ jiànzhù bǎ liǎngbiān shēnghuó liánjiē qǐlai, liúdòng de shuǐ yě tíxǐng rénmen chéngshì cóngwèi jìngzhǐ.',
    vietnamese: 'Cầu, bờ kè và công trình ven nước nối đời sống hai bên; dòng nước chuyển động nhắc rằng thành phố chưa bao giờ đứng yên.',
    english: 'Bridges, embankments, and waterside buildings connect life on both sides, while flowing water reminds us that cities never stand still.',
  ),
];

const _urbanHeritageEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '街巷、城墙或宗祠把公共生活装进具体尺度，人群的路线让空间持续发生变化。',
    pinyin: 'Jiēxiàng, chéngqiáng huò zōngcí bǎ gōnggòng shēnghuó zhuāng jìn jùtǐ chǐdù, rénqún de lùxiàn ràng kōngjiān chíxù fāshēng biànhuà.',
    vietnamese: 'Phố ngõ, thành tường hoặc từ đường đặt đời sống công cộng vào tỷ lệ cụ thể, còn tuyến người đi khiến không gian tiếp tục thay đổi.',
    english: 'Lanes, walls, and ancestral halls give public life a concrete scale, while people’s routes keep the space changing.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '装饰、材料和结构不仅表达审美，也记录工匠技术、地方经济和社群关系。',
    pinyin: 'Zhuāngshì, cáiliào hé jiégòu bùjǐn biǎodá shěnměi, yě jìlù gōngjiàng jìshù, dìfāng jīngjì hé shèqún guānxì.',
    vietnamese: 'Trang trí, vật liệu và kết cấu không chỉ thể hiện thẩm mỹ mà còn ghi lại kỹ thuật thợ thủ công, kinh tế địa phương và quan hệ cộng đồng.',
    english: 'Decoration, materials, and structure express aesthetics while recording craft, local economy, and community relationships.',
  ),
];
