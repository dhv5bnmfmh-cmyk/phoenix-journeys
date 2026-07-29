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
  if (journeyId == 'literary-roaming') return _literaryRoamingEnrichment;
  if (journeyId == 'myth-tracing') return _mythTracingEnrichment;
  if (journeyId == 'strange-night-talks') {
    return _strangeNightTalksEnrichment;
  }
  if (journeyId == 'folk-secret-land') return _folkSecretLandEnrichment;
  if (journeyId == 'beijing-forbidden-city') return _forbiddenCityEnrichment;
  if (journeyId == 'beijing-summer-palace') return _summerPalaceEnrichment;
  if (journeyId == 'shanghai-bund') return _bundEnrichment;
  if (journeyId == 'xian-city-wall') return _xianCityWallEnrichment;
  if (journeyId == 'hangzhou-west-lake') return _westLakeEnrichment;
  if (journeyId == 'chengdu-kuanzhai-alley') return _kuanzhaiEnrichment;
  if (journeyId == 'nanjing-qinhuai-river') return _qinhuaiEnrichment;
  if (journeyId == 'guangzhou-chen-clan-academy') {
    return _chenClanAcademyEnrichment;
  }
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

const _literaryRoamingEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '竹影被风拆散又重合，蝴蝶忽远忽近，使梦境没有固定边界。',
    pinyin: 'Zhúyǐng bèi fēng chāisàn yòu chónghé, húdié hū yuǎn hū jìn, shǐ mèngjìng méiyǒu gùdìng biānjiè.',
    vietnamese: 'Bóng tre bị gió tách ra rồi chồng lại; cánh bướm lúc xa lúc gần khiến giấc mộng không có ranh giới cố định.',
    english: 'Bamboo shadows separate and overlap in the wind, while the butterfly makes the dream’s boundary unstable.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '醒来并没有终止疑问：究竟是人梦见蝴蝶，还是身份本来就会随感知改变。',
    pinyin: 'Xǐnglái bìng méiyǒu zhōngzhǐ yíwèn: jiūjìng shì rén mèngjiàn húdié, háishi shēnfèn běnlái jiù huì suí gǎnzhī gǎibiàn.',
    vietnamese: 'Tỉnh dậy không chấm dứt câu hỏi: con người mơ thấy bướm, hay bản ngã vốn thay đổi theo nhận thức.',
    english: 'Waking does not end the question: did a person dream of a butterfly, or does identity shift with perception?',
  ),
];

const _mythTracingEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '桂香从月色里浮出，竹简上的残字却比传说更沉，像在等待另一种解释。',
    pinyin: 'Guìxiāng cóng yuèsè lǐ fúchū, zhújiǎn shàng de cánzì què bǐ chuánshuō gèng chén, xiàng zài děngdài lìng yì zhǒng jiěshì.',
    vietnamese: 'Hương quế nổi lên trong ánh trăng, còn chữ sót trên thẻ tre nặng hơn truyền thuyết như đang chờ một cách giải thích khác.',
    english: 'Osmanthus rises through the moonlight, while the surviving characters on the bamboo slip await another interpretation.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '白兔引你返回人间，也提醒你：神话并非唯一版本，而是每次讲述都重新选择的道路。',
    pinyin: 'Báitù yǐn nǐ fǎnhuí rénjiān, yě tíxǐng nǐ: shénhuà bìngfēi wéiyī bǎnběn, ér shì měi cì jiǎngshù dōu chóngxīn xuǎnzé de dàolù.',
    vietnamese: 'Thỏ trắng dẫn bạn về nhân gian và nhắc rằng thần thoại không có một bản duy nhất; mỗi lần kể là một lần chọn lại con đường.',
    english: 'The white rabbit leads you back and reminds you that myth has no single version; every retelling chooses a path anew.',
  ),
];

const _strangeNightTalksEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '风雨压住客栈的灯火，无影客留下的铜钱却微微发热，使承诺显得比恐惧更真实。',
    pinyin: 'Fēngyǔ yāzhù kèzhàn de dēnghuǒ, wúyǐng kè liúxià de tóngqián què wēiwēi fārè, shǐ chéngnuò xiǎnde bǐ kǒngjù gèng zhēnshí.',
    vietnamese: 'Mưa gió đè thấp ánh đèn quán trọ, nhưng đồng tiền người khách không bóng để lại vẫn ấm, khiến lời hứa thật hơn nỗi sợ.',
    english: 'Stormlight dims in the inn, yet the shadowless guest’s warm coin makes the promise feel more real than fear.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '更鼓一遍遍响起，直到鸡鸣切开黑夜，你才明白守约不是等待奇迹，而是承担选择。',
    pinyin: 'Gēnggǔ yí biàn biàn xiǎngqǐ, zhídào jīmíng qiēkāi hēiyè, nǐ cái míngbai shǒuyuē bú shì děngdài qíjì, ér shì chéngdān xuǎnzé.',
    vietnamese: 'Trống canh vang hết lượt này đến lượt khác; tới khi tiếng gà cắt màn đêm, bạn hiểu giữ lời không phải chờ phép màu mà là gánh lấy lựa chọn.',
    english: 'The watch drum repeats until a rooster splits the night, revealing that keeping faith means carrying a choice, not awaiting a miracle.',
  ),
];

const _folkSecretLandEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '河灯偏离水势，缓慢逆流而上；倒影里出现的不是过去，而是尚未发生的自己。',
    pinyin: 'Hédēng piānlí shuǐshì, huǎnmàn nìliú ér shàng; dàoyǐng lǐ chūxiàn de bú shì guòqù, ér shì shàngwèi fāshēng de zìjǐ.',
    vietnamese: 'Đèn sông rời dòng nước và chậm rãi trôi ngược; trong bóng phản chiếu không phải quá khứ mà là chính bạn chưa xảy đến.',
    english: 'The river lantern turns against the current; its reflection shows not the past but a self that has not yet happened.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '岸边人的说法彼此矛盾，地方传闻因此不是答案，而是逼你决定要追随哪一种未来。',
    pinyin: 'Ànbiān rén de shuōfǎ bǐcǐ máodùn, dìfāng chuánwén yīncǐ bú shì dáàn, ér shì bī nǐ juédìng yào zhuīsuí nǎ yì zhǒng wèilái.',
    vietnamese: 'Những lời kể ven bờ mâu thuẫn nhau; truyền thuyết địa phương không cho đáp án mà buộc bạn chọn tương lai muốn đi theo.',
    english: 'Conflicting voices along the bank turn local lore into no answer at all, but a demand to choose which future to follow.',
  ),
];

const _forbiddenCityEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '午门的城台、门洞与楼阁共同塑造进入宫城的仪式感，人的路线在这里被权力秩序清楚规定。',
    pinyin: 'Wǔmén de chéngtái, méndòng yǔ lóugé gòngtóng sùzào jìnrù gōngchéng de yíshìgǎn, rén de lùxiàn zài zhèlǐ bèi quánlì zhìxù qīngchǔ guīdìng.',
    vietnamese: 'Nền thành, cổng vòm và lầu gác Ngọ Môn tạo nên nghi thức bước vào hoàng thành; lộ trình con người được trật tự quyền lực quy định rõ ràng.',
    english: 'The platform, gateways, and towers of the Meridian Gate choreograph entry into the palace, making power visible through movement.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '黄色琉璃瓦、红墙与中轴线不只是装饰，它们把等级、方向和皇权观念写进可见的空间。',
    pinyin: 'Huángsè liúlíwǎ, hóngqiáng yǔ zhōngzhóuxiàn bù zhǐ shì zhuāngshì, tāmen bǎ děngjí, fāngxiàng hé huángquán guānniàn xiě jìn kějiàn de kōngjiān.',
    vietnamese: 'Ngói lưu ly vàng, tường đỏ và trục giữa không chỉ để trang trí mà còn đưa cấp bậc, phương hướng và quyền lực hoàng gia vào không gian hữu hình.',
    english: 'Yellow glazed tiles, red walls, and the central axis turn hierarchy, direction, and imperial authority into visible space.',
  ),
];

const _summerPalaceEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '昆明湖与万寿山并不是分开的景点，水面倒影、山势和长廊共同组织一场不断变化的观看。',
    pinyin: 'Kūnmíng Hú yǔ Wànshòu Shān bìng bú shì fēnkāi de jǐngdiǎn, shuǐmiàn dàoyǐng, shānshì hé Chángláng gòngtóng zǔzhī yì chǎng bùduàn biànhuà de guānkàn.',
    vietnamese: 'Hồ Côn Minh và núi Vạn Thọ không phải hai điểm tách rời; phản chiếu, thế núi và Trường Lang cùng tạo nên một quá trình ngắm cảnh biến đổi.',
    english: 'Kunming Lake and Longevity Hill are not separate sights; reflection, terrain, and corridor compose a changing act of seeing.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '十七孔桥既连接南湖岛，也在宽阔水面上建立水平尺度，使远山、湖光和近景获得清楚层次。',
    pinyin: 'Shíqīkǒng Qiáo jì liánjiē Nánhú Dǎo, yě zài kuānkuò shuǐmiàn shàng jiànlì shuǐpíng chǐdù, shǐ yuǎnshān, húguāng hé jìnjǐng huòdé qīngchǔ céngcì.',
    vietnamese: 'Cầu Thập Thất Khổng vừa nối đảo Nam Hồ vừa tạo một thước ngang trên mặt nước, phân lớp núi xa, ánh hồ và cảnh gần.',
    english: 'The Seventeen-Arch Bridge links Nanhu Island and sets a horizontal measure across the lake, layering distant hills, water, and foreground.',
  ),
];

const _bundEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '外滩西岸的银行与贸易建筑记录近代商业网络，隔江的浦东天际线则把城市转型放进同一视野。',
    pinyin: 'Wàitān xī àn de yínháng yǔ màoyì jiànzhù jìlù jìndài shāngyè wǎngluò, gé jiāng de Pǔdōng tiānjìxiàn zé bǎ chéngshì zhuǎnxíng fàng jìn tóng yí shìyě.',
    vietnamese: 'Các tòa nhà ngân hàng và thương mại ở bờ tây ghi lại mạng lưới kinh doanh cận đại, còn đường chân trời Phố Đông đặt chuyển đổi đô thị trong cùng tầm nhìn.',
    english: 'Banks and trading houses on the west bank record modern commerce, while Pudong places urban transformation in the same view.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '沿黄浦江行走时，约一点五公里的历史街区不只是建筑展览，也揭示港口、资本与城市生活怎样彼此塑造。',
    pinyin: 'Yán Huángpǔ Jiāng xíngzǒu shí, yuē yì diǎn wǔ gōnglǐ de lìshǐ jiēqū bù zhǐ shì jiànzhù zhǎnlǎn, yě jiēshì gǎngkǒu, zīběn yǔ chéngshì shēnghuó zěnyàng bǐcǐ sùzào.',
    vietnamese: 'Đi dọc sông Hoàng Phố, khu lịch sử dài khoảng 1,5 km không chỉ trưng bày kiến trúc mà còn cho thấy cảng, vốn và đời sống đô thị định hình nhau.',
    english: 'Along the Huangpu, the 1.5-kilometre heritage district reveals how port, capital, architecture, and daily life shaped one another.',
  ),
];

const _xianCityWallEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '永宁门、角楼、护城河与宽阔墙顶构成连续防御系统，单看一座城门无法理解它的军事逻辑。',
    pinyin: 'Yǒngníngmén, jiǎolóu, hùchénghé yǔ kuānkuò qiángdǐng gòuchéng liánxù fángyù xìtǒng, dān kàn yí zuò chéngmén wúfǎ lǐjiě tā de jūnshì luójí.',
    vietnamese: 'Cổng Vĩnh Ninh, tháp góc, hào nước và mặt thành rộng tạo thành một hệ phòng thủ liên tục; nhìn riêng một cổng không thể hiểu logic quân sự.',
    english: 'Yongning Gate, corner towers, moat, and broad wall top form one defensive system whose logic exceeds any single gate.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '从墙顶向内外同时观看，明代形成的城市边界与今天扩张的道路和高楼发生直接对话。',
    pinyin: 'Cóng qiángdǐng xiàng nèiwài tóngshí guānkàn, Míngdài xíngchéng de chéngshì biānjiè yǔ jīntiān kuòzhāng de dàolù hé gāolóu fāshēng zhíjiē duìhuà.',
    vietnamese: 'Nhìn đồng thời vào trong và ra ngoài từ mặt thành, ranh giới đô thị thời Minh đối thoại trực tiếp với đường sá và cao ốc đang mở rộng.',
    english: 'Looking inward and outward from the wall brings a Ming urban boundary into direct dialogue with today’s expanding roads and towers.',
  ),
];

const _westLakeEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '苏堤与白堤把步行路线伸入湖面，桥、柳树与远山在移动中不断改变前后关系。',
    pinyin: 'Sūdī yǔ Báidī bǎ bùxíng lùxiàn shēnrù húmiàn, qiáo, liǔshù yǔ yuǎnshān zài yídòng zhōng bùduàn gǎibiàn qiánhòu guānxì.',
    vietnamese: 'Đê Tô và đê Bạch đưa lối đi sâu vào mặt hồ; cầu, liễu và núi xa liên tục đổi quan hệ trước sau theo bước chân.',
    english: 'The Su and Bai causeways carry walkers into the lake, continually rearranging bridges, willows, and distant hills.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '“西湖十景”把季节、天气、时间与地点连成文化记忆，因此同一湖面在不同条件下会成为不同故事。',
    pinyin: '“Xīhú Shíjǐng” bǎ jìjié, tiānqì, shíjiān yǔ dìdiǎn lián chéng wénhuà jìyì, yīncǐ tóng yì húmiàn zài bùtóng tiáojiàn xià huì chéngwéi bùtóng gùshì.',
    vietnamese: '“Mười cảnh Tây Hồ” nối mùa, thời tiết, thời gian và địa điểm thành ký ức văn hóa, khiến cùng một mặt hồ trở thành những câu chuyện khác nhau.',
    english: 'The Ten Scenes of West Lake bind season, weather, time, and place into cultural memory, giving one lake many stories.',
  ),
];

const _kuanzhaiEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '宽巷子、窄巷子与井巷子的尺度和节奏不同，院落、店铺与茶馆因此形成多层次的街巷生活。',
    pinyin: 'Kuān Xiàngzi, Zhǎi Xiàngzi yǔ Jǐng Xiàngzi de chǐdù hé jiézòu bùtóng, yuànluò, diànpù yǔ cháguǎn yīncǐ xíngchéng duō céngcì de jiēxiàng shēnghuó.',
    vietnamese: 'Ngõ Rộng, ngõ Hẹp và ngõ Giếng có tỷ lệ và nhịp khác nhau, tạo nên đời sống nhiều lớp giữa sân nhà, cửa hàng và quán trà.',
    english: 'Wide, Narrow, and Well alleys differ in scale and rhythm, layering courtyards, shops, teahouses, and street life.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '保护后的街区同时承担居住、商业与旅游功能，成都的“慢”由此既是生活经验，也成为被展示的城市形象。',
    pinyin: 'Bǎohù hòu de jiēqū tóngshí chéngdān jūzhù, shāngyè yǔ lǚyóu gōngnéng, Chéngdū de “màn” yóucǐ jì shì shēnghuó jīngyàn, yě chéngwéi bèi zhǎnshì de chéngshì xíngxiàng.',
    vietnamese: 'Khu phố sau bảo tồn đồng thời phục vụ cư trú, thương mại và du lịch; cái “chậm” của Thành Đô vừa là trải nghiệm sống vừa là hình ảnh đô thị được trình bày.',
    english: 'The conserved quarter serves residents, commerce, and tourism, making Chengdu’s “slowness” both lived experience and displayed identity.',
  ),
];

const _qinhuaiEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '秦淮河把夫子庙、桥梁、街市与灯影连成夜间路线，水面既运输人群，也承载城市记忆。',
    pinyin: 'Qínhuái Hé bǎ Fūzǐmiào, qiáoliáng, jiēshì yǔ dēngyǐng lián chéng yèjiān lùxiàn, shuǐmiàn jì yùnshū rénqún, yě chéngzài chéngshì jìyì.',
    vietnamese: 'Sông Tần Hoài nối Phu Tử Miếu, cầu, phố chợ và ánh đèn thành tuyến đêm; mặt nước vừa đưa người qua lại vừa chở ký ức đô thị.',
    english: 'The Qinhuai links Confucius Temple, bridges, markets, and lantern light into a night route carrying both people and urban memory.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '繁华景象背后还有科举、文人书写与普通居民的生活，河流的文化意义不能只由灯会概括。',
    pinyin: 'Fánhuá jǐngxiàng bèihòu hái yǒu kējǔ, wénrén shūxiě yǔ pǔtōng jūmín de shēnghuó, héliú de wénhuà yìyì bùnéng zhǐ yóu dēnghuì gàikuò.',
    vietnamese: 'Sau cảnh phồn hoa còn có khoa cử, trước tác văn nhân và đời sống cư dân; ý nghĩa văn hóa của dòng sông không thể chỉ gói trong lễ hội đèn.',
    english: 'Behind the spectacle lie examinations, literary writing, and residents’ lives; lantern festivals alone cannot define the river.',
  ),
];

const _chenClanAcademyEnrichment = <JourneyStoryEnrichmentPacket>[
  JourneyStoryEnrichmentPacket(
    chinese: '屋脊上的陶塑、灰塑与木石雕刻把人物、花鸟和故事铺满建筑表面，工艺本身成为阅读岭南文化的入口。',
    pinyin: 'Wūjǐ shàng de táosù, huīsù yǔ mùshí diāokè bǎ rénwù, huāniǎo hé gùshì pūmǎn jiànzhù biǎomiàn, gōngyì běnshēn chéngwéi yuèdú Lǐngnán wénhuà de rùkǒu.',
    vietnamese: 'Gốm, đắp vữa và chạm gỗ đá trên mái phủ nhân vật, hoa chim và truyện tích lên bề mặt; kỹ nghệ trở thành lối vào văn hóa Lĩnh Nam.',
    english: 'Ceramic, plaster, wood, and stone ornament cover the building with figures and stories, making craft an entry into Lingnan culture.',
  ),
  JourneyStoryEnrichmentPacket(
    chinese: '陈家祠原有宗族教育与联络功能，今天作为博物馆开放，使建筑用途改变而社群记忆仍可继续传递。',
    pinyin: 'Chénjiācí yuányǒu zōngzú jiàoyù yǔ liánluò gōngnéng, jīntiān zuòwéi bówùguǎn kāifàng, shǐ jiànzhù yòngtú gǎibiàn ér shèqún jìyì réng kě jìxù chuándì.',
    vietnamese: 'Trần Gia Từ từng phục vụ giáo dục và liên kết dòng họ; nay mở cửa như bảo tàng, công năng đổi nhưng ký ức cộng đồng vẫn được truyền tiếp.',
    english: 'Once serving clan education and connection, the academy now functions as a museum while continuing to transmit community memory.',
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
