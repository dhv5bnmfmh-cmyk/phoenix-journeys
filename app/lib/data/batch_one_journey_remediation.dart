import 'journey_data.dart';
import 'journey_level_catalog.dart';

const batchOneJourneyIds = <String>{
  'beijing-forbidden-city',
  'shanghai-bund',
};

const batchOneChallengeTypes = <String>[
  'paragraphRebuild',
  'grammarRepair',
  'missingSentence',
];

class RemediatedSourceBinding {
  const RemediatedSourceBinding({
    required this.id,
    required this.publisher,
    required this.scope,
  });

  final String id;
  final String publisher;
  final String scope;
}

class RemediatedWordTrace {
  const RemediatedWordTrace({required this.word, required this.eventId});

  final String word;
  final String eventId;
}

class RemediatedDiscoveryTrace {
  const RemediatedDiscoveryTrace({
    required this.discoveryIndex,
    required this.storyEventIds,
    required this.sourceIds,
  });

  final int discoveryIndex;
  final List<String> storyEventIds;
  final List<String> sourceIds;
}

class RemediatedChallengeTrace {
  const RemediatedChallengeTrace({
    required this.type,
    required this.storyEventIds,
    required this.anchor,
  });

  final String type;
  final List<String> storyEventIds;
  final String anchor;
}

class RemediatedMemoryReview {
  const RemediatedMemoryReview({
    required this.category,
    required this.prompt,
    required this.answer,
    required this.storyEventIds,
  });

  final String category;
  final String prompt;
  final String answer;
  final List<String> storyEventIds;
}

class RemediatedCompletion {
  const RemediatedCompletion({
    required this.journeySummary,
    required this.achievement,
    required this.memoryAnchor,
    required this.challengeReward,
    required this.journeyCompletion,
  });

  final String journeySummary;
  final String achievement;
  final String memoryAnchor;
  final String challengeReward;
  final String journeyCompletion;
}

class RemediatedJourney {
  const RemediatedJourney({
    required this.id,
    required this.title,
    required this.protagonist,
    required this.goal,
    required this.conflict,
    required this.eventIds,
    required this.levels,
    required this.words,
    required this.wordTraces,
    required this.discoveries,
    required this.discoveryTraces,
    required this.challenges,
    required this.memory,
    required this.completion,
    required this.sources,
  });

  final String id;
  final String title;
  final String protagonist;
  final String goal;
  final String conflict;
  final List<String> eventIds;
  final List<JourneyLevelContent> levels;
  final List<WordEntry> words;
  final List<RemediatedWordTrace> wordTraces;
  final List<DiscoveryEntry> discoveries;
  final List<RemediatedDiscoveryTrace> discoveryTraces;
  final List<RemediatedChallengeTrace> challenges;
  final List<RemediatedMemoryReview> memory;
  final RemediatedCompletion completion;
  final List<RemediatedSourceBinding> sources;

  JourneyLevelContent levelContent(int requestedLevel) {
    final level = requestedLevel.clamp(1, 10).toInt();
    final base = levels[level - 1];
    final story = base.storyParagraphs.join();
    final visibleWords = words
        .where((entry) => story.contains(entry.word))
        .take((4 + level).clamp(5, 12))
        .toList(growable: false);
    final start = (level - 1) % discoveries.length;
    final discoveryCount = level <= 2 ? 1 : 2;
    final visibleDiscoveries = <DiscoveryEntry>[
      for (var offset = 0; offset < discoveryCount; offset++)
        discoveries[(start + offset) % discoveries.length],
    ];
    return JourneyLevelContent(
      storyParagraphs: base.storyParagraphs,
      storyAnnotations: base.storyAnnotations,
      words: visibleWords,
      discoveries: visibleDiscoveries,
      wonderQuestion: '',
      expressQuestion: '',
    );
  }
}

class _StoryBlock {
  const _StoryBlock(this.core, this.details);

  final String core;
  final List<String> details;
}

List<JourneyLevelContent> _buildLevels({
  required List<_StoryBlock> blocks,
  required List<int> detailCounts,
  required ReadingAnnotation firstAnnotation,
  required ReadingAnnotation secondAnnotation,
}) {
  return List<JourneyLevelContent>.generate(10, (index) {
    final level = index + 1;
    var remainingDetails = detailCounts[index];
    final paragraphs = <String>[];
    final buffer = StringBuffer();
    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      final block = blocks[blockIndex];
      buffer.write(block.core);
      final take = remainingDetails.clamp(0, block.details.length).toInt();
      for (final detail in block.details.take(take)) {
        buffer.write(detail);
      }
      remainingDetails -= take;
      if (level >= 3 && blockIndex == 3) {
        paragraphs.add(buffer.toString());
        buffer.clear();
      }
    }
    if (buffer.isNotEmpty) paragraphs.add(buffer.toString());
    final annotations = paragraphs.length == 1
        ? <ReadingAnnotation>[
            ReadingAnnotation(
              pinyin: '${firstAnnotation.pinyin} ${secondAnnotation.pinyin}',
              vietnamese:
                  '${firstAnnotation.vietnamese} ${secondAnnotation.vietnamese}',
              english: '${firstAnnotation.english} ${secondAnnotation.english}',
            ),
          ]
        : <ReadingAnnotation>[firstAnnotation, secondAnnotation];
    return JourneyLevelContent(
      storyParagraphs: paragraphs,
      storyAnnotations: annotations,
      words: const <WordEntry>[],
      discoveries: const <DiscoveryEntry>[],
      wonderQuestion: '',
      expressQuestion: '',
    );
  }, growable: false);
}

WordEntry _word({
  required String word,
  required String pinyin,
  required String partOfSpeech,
  required String simpleChinese,
  required String vietnamese,
  required String english,
  required String symbol,
  required String storySentence,
  required String storyPinyin,
  required String storyVietnamese,
  required String storyEnglish,
}) {
  return WordEntry(
    word: word,
    pinyin: pinyin,
    partOfSpeech: partOfSpeech,
    simpleChinese: simpleChinese,
    translation: vietnamese,
    englishDefinition: english,
    symbol: symbol,
    examples: <WordExample>[
      WordExample(
        chinese: storySentence,
        pinyin: storyPinyin,
        vietnamese: storyVietnamese,
        english: storyEnglish,
      ),
      WordExample(
        chinese: '学习者在证据记录中再次确认“$word”。',
        pinyin: 'Xuéxízhě zài zhèngjù jìlù zhōng zàicì quèrèn “$pinyin”.',
        vietnamese: 'Người học xác nhận lại “$word” trong hồ sơ bằng chứng.',
        english: 'The learner checks “$word” again in the evidence record.',
      ),
      WordExample(
        chinese: '只有说明“$word”的位置和含义，别人才能复核。',
        pinyin: 'Zhǐyǒu shuōmíng “$pinyin” de wèizhi hé hányì, biérén cái néng fùhé.',
        vietnamese: 'Chỉ khi nêu rõ vị trí và ý nghĩa của “$word”, người khác mới có thể kiểm tra lại.',
        english: 'Only when the position and meaning of “$word” are clear can others verify it.',
      ),
    ],
  );
}

const _forbiddenCityEvents = <String>[
  'FC-E1-task',
  'FC-E2-conflict',
  'FC-E3-choice',
  'FC-E4-lost-pass',
  'FC-E5-evidence',
  'FC-E6-consequence',
  'FC-E7-growth',
];

const _forbiddenCityBlocks = <_StoryBlock>[
  _StoryBlock(
    '十九岁的古建测绘实习生梁砚在午门开启前接到第一份独立任务。',
    <String>[
      '午门是紫禁城南侧重要入口，门后的空间沿南北中轴逐层展开。',
      '师父沈岚提醒他，门、院、台基和殿宇共同形成外朝的礼仪秩序，测量数字也必须放回建筑关系中解释。',
    ],
  ),
  _StoryBlock(
    '他要在闭馆前复核太和殿屋脊，却发现旧图与新数据矛盾。',
    <String>[
      '太和殿位于外朝核心区域，现存建筑经历过重建与持续修缮，档案中的年代和记录方式不能混为一谈。',
      '异常旁还有近期保护标记，但任务单没有写明对应编号，这个信息缺口让结论更不可靠。',
    ],
  ),
  _StoryBlock(
    '直接上报可能误导修缮，返回核对又会迟交；他选择回档案室确认。',
    <String>[
      '梁砚原想靠速度证明自己，面对选择时却意识到，一份看似完整但未经核对的结论会把风险推给修缮人员。',
      '他在丹陛旁重看照片，发现自己没有清楚记录观察角度和仪器位置。',
    ],
  ),
  _StoryBlock(
    '工牌途中遗失，他按中轴路线和照片时间找回线索，并请苏禾复核。',
    <String>[
      '午门安检时间、太和门照片和东庑附近的记录组成一条行动时间线，宫城清楚的空间序列帮助他缩小寻找范围。',
      '工牌最终由巡查技师苏禾找到，代价是他错过原定交件时刻，也不得不承认急于独立让自己忽略了基本检查。',
    ],
  ),
  _StoryBlock(
    '两人发现旧图量投影，新仪器量斜长，构件并未位移。',
    <String>[
      '苏禾把维修编号、保护标记和两种测量角度并列，说明两组数据各自成立，错误来自把不同口径当成同一长度。',
      '梁砚也重新理解木构建筑：柱、梁、枋和屋顶构件共同工作，不能只凭一个孤立数字判断损坏。',
    ],
  ),
  _StoryBlock(
    '梁砚交出带证据的复核单，虽晚却避免误拆。',
    <String>[
      '复核单写明中轴方位、屋面坡度、基准点、构件编号、照片时间、测量方式和待确认项，让其他人能够重复检查。',
      '第二天的复测证明建筑状态稳定，修缮组采用这份模板，避免把历史图纸差异误判为新的位移。',
      '梁砚没有得到“最快实习生”的评价，却获得下一次独立测绘资格，因为他的判断可以追溯，也愿意接受复核。',
    ],
  ),
  _StoryBlock(
    '他终于明白：真正的独立不是拒绝复核，而是让每个判断都留下证据。',
    <String>[],
  ),
];

final forbiddenCityRemediation = RemediatedJourney(
  id: 'beijing-forbidden-city',
  title: '北京 · 紫禁城：同一个长度',
  protagonist: '梁砚，十九岁的古建测绘实习生',
  goal: '在闭馆前复核太和殿屋脊异常并交出可追溯记录',
  conflict: '速度与证据责任发生冲突，旧图和新数据又使用不同测量口径',
  eventIds: _forbiddenCityEvents,
  levels: _buildLevels(
    blocks: _forbiddenCityBlocks,
    detailCounts: const <int>[0, 1, 2, 4, 5, 7, 8, 10, 11, 13],
    firstAnnotation: const ReadingAnnotation(
      pinyin: 'Shíjiǔ suì de gǔjiàn cèhuì shíxíshēng Liáng Yàn zài Wǔmén kāiqǐ qián jiēdào dúlì rènwù. Tā fāxiàn jiù tú hé xīn shùjù de cèliáng kǒujìng bùtóng, yīncǐ xuǎnzé huí dàng àn shì héduì.',
      vietnamese: 'Lương Nghiên, thực tập sinh đo vẽ kiến trúc cổ mười chín tuổi, nhận nhiệm vụ độc lập trước khi Ngọ Môn mở cửa. Khi phát hiện bản vẽ cũ và dữ liệu mới dùng cách đo khác nhau, cậu chọn quay lại hồ sơ để kiểm tra.',
      english: 'Nineteen-year-old architectural survey intern Liang Yan receives his first independent task before the Meridian Gate opens. When old drawings and new data conflict, he chooses to verify the records.',
    ),
    secondAnnotation: const ReadingAnnotation(
      pinyin: 'Gōngpái yíshī hòu, tā àn zhōngzhóu lùxiàn hé zhàopiàn shíjiān chóngjiàn zhèngjù. Fùhé zhèngmíng gòujiàn méiyǒu xīn wèiyí; tā tíjiāo le biāomíng jīzhǔndiǎn hé bù quèdìngxìng de fùhédān.',
      vietnamese: 'Sau khi mất thẻ làm việc, cậu dựng lại chuỗi bằng chứng theo tuyến trục giữa và thời gian ảnh. Việc kiểm tra cho thấy cấu kiện không dịch chuyển; cậu nộp phiếu có điểm chuẩn và phần chưa chắc chắn.',
      english: 'After losing his pass, he reconstructs the evidence from the central-axis route and photo times. Verification shows no new movement, and his evidence-based report prevents an unnecessary intervention.',
    ),
  ),
  words: <WordEntry>[
    _word(word: '午门', pinyin: 'wǔmén', partOfSpeech: '专有名词', simpleChinese: '紫禁城南侧的重要入口。', vietnamese: 'Ngọ Môn, lối vào quan trọng ở phía nam Tử Cấm Thành.', english: 'the Meridian Gate, an important southern entrance to the Forbidden City', symbol: '🏯', storySentence: '梁砚在午门开启前接到任务。', storyPinyin: 'Liáng Yàn zài Wǔmén kāiqǐ qián jiēdào rènwù.', storyVietnamese: 'Lương Nghiên nhận nhiệm vụ trước khi Ngọ Môn mở.', storyEnglish: 'Liang Yan receives the task before the Meridian Gate opens.'),
    _word(word: '中轴', pinyin: 'zhōngzhóu', partOfSpeech: '名词', simpleChinese: '组织主要门、院和殿宇的中心轴线。', vietnamese: 'Trục trung tâm tổ chức các cổng, sân và điện chính.', english: 'the central axis organizing major gates, courts, and halls', symbol: '🧭', storySentence: '他按中轴路线重建行动时间。', storyPinyin: 'Tā àn zhōngzhóu lùxiàn chóngjiàn xíngdòng shíjiān.', storyVietnamese: 'Cậu dựng lại thời gian di chuyển theo tuyến trục giữa.', storyEnglish: 'He reconstructs his route along the central axis.'),
    _word(word: '太和殿', pinyin: 'tàihédiàn', partOfSpeech: '专有名词', simpleChinese: '紫禁城外朝的核心宫殿之一。', vietnamese: 'Điện Thái Hòa, một cung điện cốt lõi của khu ngoại triều.', english: 'the Hall of Supreme Harmony, a principal Outer Court hall', symbol: '🏛️', storySentence: '他要复核太和殿屋脊。', storyPinyin: 'Tā yào fùhé Tàihé Diàn wūjǐ.', storyVietnamese: 'Cậu phải kiểm tra lại sống mái Điện Thái Hòa.', storyEnglish: 'He must verify the roof ridge of the Hall of Supreme Harmony.'),
    _word(word: '屋脊', pinyin: 'wūjǐ', partOfSpeech: '名词', simpleChinese: '屋顶两面相接形成的高线。', vietnamese: 'Đường cao nơi hai mặt mái gặp nhau.', english: 'the ridge where roof slopes meet', symbol: '🏠', storySentence: '旧图与屋脊的新数据矛盾。', storyPinyin: 'Jiù tú yǔ wūjǐ de xīn shùjù máodùn.', storyVietnamese: 'Bản vẽ cũ mâu thuẫn với dữ liệu mới của sống mái.', storyEnglish: 'The old drawing conflicts with new roof-ridge data.'),
    _word(word: '修缮', pinyin: 'xiūshàn', partOfSpeech: '动词', simpleChinese: '修理并保护历史建筑。', vietnamese: 'Sửa chữa và bảo tồn công trình lịch sử.', english: 'to repair and conserve a historic structure', symbol: '🛠️', storySentence: '草率上报可能误导修缮。', storyPinyin: 'Cǎoshuài shàngbào kěnéng wùdǎo xiūshàn.', storyVietnamese: 'Báo cáo vội vàng có thể làm sai lệch việc tu bổ.', storyEnglish: 'A rushed report could misdirect conservation work.'),
    _word(word: '测绘', pinyin: 'cèhuì', partOfSpeech: '动词', simpleChinese: '测量并绘制位置、尺寸和形态。', vietnamese: 'Đo đạc và lập bản vẽ vị trí, kích thước, hình dạng.', english: 'to survey and map dimensions, positions, and form', symbol: '📐', storySentence: '梁砚获得下一次独立测绘资格。', storyPinyin: 'Liáng Yàn huòdé xià yí cì dúlì cèhuì zīgé.', storyVietnamese: 'Lương Nghiên được giao lần đo vẽ độc lập tiếp theo.', storyEnglish: 'Liang Yan earns another independent survey assignment.'),
    _word(word: '复核', pinyin: 'fùhé', partOfSpeech: '动词', simpleChinese: '再次检查，确认记录和结论。', vietnamese: 'Kiểm tra lại để xác nhận hồ sơ và kết luận.', english: 'to verify by checking again', symbol: '✅', storySentence: '苏禾帮助梁砚复核。', storyPinyin: 'Sū Hé bāngzhù Liáng Yàn fùhé.', storyVietnamese: 'Tô Hòa giúp Lương Nghiên kiểm tra lại.', storyEnglish: 'Su He helps Liang Yan verify the evidence.'),
    _word(word: '基准点', pinyin: 'jīzhǔndiǎn', partOfSpeech: '名词', simpleChinese: '测量时用来比较位置和高度的固定点。', vietnamese: 'Điểm cố định dùng làm chuẩn khi đo vị trí và cao độ.', english: 'a fixed reference point used for measurement', symbol: '📍', storySentence: '复核单写明了基准点。', storyPinyin: 'Fùhédān xiěmíng le jīzhǔndiǎn.', storyVietnamese: 'Phiếu kiểm tra ghi rõ điểm chuẩn.', storyEnglish: 'The verification sheet records the reference point.'),
    _word(word: '木构', pinyin: 'mùgòu', partOfSpeech: '名词', simpleChinese: '以木材构件组成的建筑结构。', vietnamese: 'Kết cấu kiến trúc tạo thành từ các cấu kiện gỗ.', english: 'timber-frame construction', symbol: '🪵', storySentence: '判断木构状态不能只看一个数字。', storyPinyin: 'Pànduàn mùgòu zhuàngtài bù néng zhǐ kàn yí gè shùzì.', storyVietnamese: 'Không thể đánh giá kết cấu gỗ chỉ bằng một con số.', storyEnglish: 'A timber structure cannot be judged from one number alone.'),
    _word(word: '口径', pinyin: 'kǒujìng', partOfSpeech: '名词', simpleChinese: '这里指测量和表达数据所采用的方法。', vietnamese: 'Ở đây chỉ phương pháp dùng để đo và diễn đạt dữ liệu.', english: 'the method or convention used to measure and describe data', symbol: '📏', storySentence: '两张图使用了不同测量口径。', storyPinyin: 'Liǎng zhāng tú shǐyòng le bùtóng cèliáng kǒujìng.', storyVietnamese: 'Hai bản vẽ dùng hai quy ước đo khác nhau.', storyEnglish: 'The two drawings use different measurement conventions.'),
    _word(word: '可追溯', pinyin: 'kě zhuīsù', partOfSpeech: '形容词', simpleChinese: '能够找到记录来源和处理过程。', vietnamese: 'Có thể truy lại nguồn hồ sơ và quá trình xử lý.', english: 'traceable to its source and process', symbol: '🔎', storySentence: '他的新版记录可以追溯。', storyPinyin: 'Tā de xīnbǎn jìlù kěyǐ zhuīsù.', storyVietnamese: 'Hồ sơ mới của cậu có thể truy vết.', storyEnglish: 'His revised record is traceable.'),
    _word(word: '不确定性', pinyin: 'bù quèdìngxìng', partOfSpeech: '名词', simpleChinese: '尚未完全确认的部分。', vietnamese: 'Phần chưa được xác nhận hoàn toàn.', english: 'uncertainty that remains unresolved', symbol: '❓', storySentence: '梁砚在复核单上标明不确定性。', storyPinyin: 'Liáng Yàn zài fùhédān shàng biāomíng bù quèdìngxìng.', storyVietnamese: 'Lương Nghiên ghi rõ phần chưa chắc chắn trên phiếu.', storyEnglish: 'Liang Yan marks uncertainty on the verification sheet.'),
  ],
  wordTraces: const <RemediatedWordTrace>[
    RemediatedWordTrace(word: '午门', eventId: 'FC-E1-task'),
    RemediatedWordTrace(word: '中轴', eventId: 'FC-E4-lost-pass'),
    RemediatedWordTrace(word: '太和殿', eventId: 'FC-E1-task'),
    RemediatedWordTrace(word: '屋脊', eventId: 'FC-E1-task'),
    RemediatedWordTrace(word: '修缮', eventId: 'FC-E2-conflict'),
    RemediatedWordTrace(word: '测绘', eventId: 'FC-E7-growth'),
    RemediatedWordTrace(word: '复核', eventId: 'FC-E5-evidence'),
    RemediatedWordTrace(word: '基准点', eventId: 'FC-E6-consequence'),
    RemediatedWordTrace(word: '木构', eventId: 'FC-E5-evidence'),
    RemediatedWordTrace(word: '口径', eventId: 'FC-E5-evidence'),
    RemediatedWordTrace(word: '可追溯', eventId: 'FC-E7-growth'),
    RemediatedWordTrace(word: '不确定性', eventId: 'FC-E6-consequence'),
  ],
  discoveries: const <DiscoveryEntry>[
    DiscoveryEntry(text: '紫禁城的主要门、院与宫殿沿南北中轴组织，空间次序服务于明清宫廷礼制，也帮助今天的参观与保护工作辨认位置关系。', pinyin: 'Zǐjìnchéng de zhǔyào mén, yuàn yǔ gōngdiàn yán nánběi zhōngzhóu zǔzhī.', simpleChinese: '主要建筑沿南北中轴排列，形成清楚的空间次序。', vietnamese: 'Các cổng, sân và điện chính được tổ chức dọc trục bắc nam, tạo nên trật tự không gian rõ ràng.', english: 'Major gates, courts, and halls are organized along a north-south central axis.'),
    DiscoveryEntry(text: '太和殿属于外朝核心建筑。现存形制经历重建与修缮，因此判断建筑状态时必须同时阅读年代、维修记录与现场证据。', pinyin: 'Tàihé Diàn shǔyú wàicháo héxīn jiànzhù, pànduàn zhuàngtài xū tóngshí yuèdú niándài hé xiūshàn jìlù.', simpleChinese: '太和殿经历过重建和维修，现场数据要和历史记录一起看。', vietnamese: 'Điện Thái Hòa từng được xây dựng lại và tu bổ, vì vậy dữ liệu hiện trường phải được đọc cùng hồ sơ lịch sử.', english: 'The Hall of Supreme Harmony has undergone rebuilding and conservation, so field data must be read with historical records.'),
    DiscoveryEntry(text: '传统木构建筑由柱、梁、枋与屋顶构件共同形成体系。单个尺寸变化只有放回整体结构、测量位置和测量方法中才有意义。', pinyin: 'Chuántǒng mùgòu jiànzhù yóu zhù, liáng, fāng yǔ wūdǐng gòujiàn gòngtóng xíngchéng tǐxì.', simpleChinese: '木构建筑要看整体关系，不能只看一个尺寸。', vietnamese: 'Kiến trúc khung gỗ phải được hiểu như một hệ thống, không thể chỉ dựa vào một kích thước.', english: 'Timber architecture must be understood as a system rather than through one isolated dimension.'),
    DiscoveryEntry(text: '遗产保护记录需要标明位置、时间、测量口径、影像、复核人和未知项。可追溯记录能避免把旧图表达差异误判为新的损坏。', pinyin: 'Yíchǎn bǎohù jìlù xūyào biāomíng wèizhi, shíjiān, cèliáng kǒujìng hé fùhérén.', simpleChinese: '保护记录越清楚，越容易复核并减少误判。', vietnamese: 'Hồ sơ bảo tồn cần ghi rõ vị trí, thời gian, cách đo, hình ảnh, người kiểm tra và phần chưa biết.', english: 'Conservation records should identify location, time, measurement convention, images, reviewers, and unresolved points.'),
  ],
  discoveryTraces: const <RemediatedDiscoveryTrace>[
    RemediatedDiscoveryTrace(discoveryIndex: 0, storyEventIds: <String>['FC-E1-task', 'FC-E4-lost-pass'], sourceIds: <String>['dpm-forbidden-city-guide', 'unesco-imperial-palaces-439']),
    RemediatedDiscoveryTrace(discoveryIndex: 1, storyEventIds: <String>['FC-E2-conflict', 'FC-E5-evidence'], sourceIds: <String>['dpm-forbidden-city-guide', 'beijing-gov-forbidden-city-2025']),
    RemediatedDiscoveryTrace(discoveryIndex: 2, storyEventIds: <String>['FC-E5-evidence'], sourceIds: <String>['dpm-forbidden-city-guide']),
    RemediatedDiscoveryTrace(discoveryIndex: 3, storyEventIds: <String>['FC-E3-choice', 'FC-E6-consequence'], sourceIds: <String>['beijing-gov-forbidden-city-2025']),
  ],
  challenges: const <RemediatedChallengeTrace>[
    RemediatedChallengeTrace(type: 'paragraphRebuild', storyEventIds: <String>['FC-E1-task', 'FC-E3-choice', 'FC-E6-consequence'], anchor: '接到任务 → 返回核对 → 避免误拆'),
    RemediatedChallengeTrace(type: 'grammarRepair', storyEventIds: <String>['FC-E2-conflict', 'FC-E5-evidence'], anchor: '午门、中轴与测量口径'),
    RemediatedChallengeTrace(type: 'missingSentence', storyEventIds: <String>['FC-E4-lost-pass', 'FC-E5-evidence'], anchor: '工牌遗失后按路线和时间重建证据'),
  ],
  memory: const <RemediatedMemoryReview>[
    RemediatedMemoryReview(category: 'protagonist', prompt: '主人公', answer: '梁砚从急于证明速度的实习生，成长为愿意留下证据并接受复核的测绘者。', storyEventIds: <String>['FC-E1-task', 'FC-E7-growth']),
    RemediatedMemoryReview(category: 'events', prompt: '关键事件', answer: '数据冲突、返回档案、工牌遗失、口径澄清、延迟交件和避免误拆构成完整因果链。', storyEventIds: _forbiddenCityEvents),
    RemediatedMemoryReview(category: 'history', prompt: '历史', answer: '紫禁城形成于明代并在明清持续使用，现存建筑和档案可能包含不同时期的修建与维修信息。', storyEventIds: <String>['FC-E2-conflict']),
    RemediatedMemoryReview(category: 'culture', prompt: '文化', answer: '门、院、台基和殿宇沿中轴形成礼仪空间，建筑次序体现宫廷秩序。', storyEventIds: <String>['FC-E1-task']),
    RemediatedMemoryReview(category: 'architecture', prompt: '建筑', answer: '太和殿的木构和屋顶构件必须在整体结构、年代记录与测量方法中判断。', storyEventIds: <String>['FC-E5-evidence']),
    RemediatedMemoryReview(category: 'vocabulary', prompt: '关键词', answer: '午门、中轴、屋脊、修缮、复核、基准点、口径、可追溯。', storyEventIds: <String>['FC-E1-task', 'FC-E5-evidence', 'FC-E6-consequence']),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '梁砚在紫禁城完成一次从冲突数据到可追溯结论的测绘复核。',
    achievement: '证据守门人：能区分测量口径、说明不确定性并保护历史建筑免受误判。',
    memoryAnchor: '真正的独立不是拒绝复核，而是让每个判断都留下证据。',
    challengeReward: '完成短文复原、语病修复与补回句子，获得“中轴复核章”。',
    journeyCompletion: '北京 · 紫禁城 Journey Completion',
  ),
  sources: const <RemediatedSourceBinding>[
    RemediatedSourceBinding(id: 'dpm-forbidden-city-guide', publisher: 'The Palace Museum', scope: '宫殿空间、建筑与保护说明'),
    RemediatedSourceBinding(id: 'unesco-imperial-palaces-439', publisher: 'UNESCO World Heritage Centre', scope: '明清皇宫历史与遗产价值'),
    RemediatedSourceBinding(id: 'beijing-gov-forbidden-city-2025', publisher: 'Beijing Municipal Government', scope: '故宫保护与公共信息'),
  ],
);

const _bundEvents = <String>[
  'BD-E1-photo',
  'BD-E2-caption-conflict',
  'BD-E3-choice',
  'BD-E4-field-check',
  'BD-E5-archive-evidence',
  'BD-E6-consequence',
  'BD-E7-growth',
];

const _bundBlocks = <_StoryBlock>[
  _StoryBlock('二十岁的档案志愿者林乔在外滩展览开幕前收到一张无说明的旧照片。', <String>[
    '照片拍向黄浦江，两岸建筑都在画面里，却没有年代、站位和原始出处。',
    '她的任务不是替照片编故事，而是找到可以核查的时间、地点和来源。',
  ]),
  _StoryBlock('她要当天写完说明牌，同伴却建议直接写“外滩见证浦东一夜崛起”。', <String>[
    '标题醒目，却把跨越多年形成的城市变化压成一个瞬间，也没有解释照片从哪一侧拍摄。',
    '外滩位于黄浦江西岸，历史建筑与浦东天际线隔江相望，方向关系能帮助判断视点。',
  ]),
  _StoryBlock('直接采用能准时开场，暂停核对会让团队等待；林乔选择先查证。', <String>[
    '她暂时放下传播效果，沿江核对堤岸曲线、建筑轮廓和相机高度，又在档案目录中追踪编号。',
    '她也第一次公开承认：没有来源的确定语气，比暂时留白更危险。',
  ]),
  _StoryBlock('她比对钟楼、转角和建筑顺序，发现热门说明把拍摄方向写反了。', <String>[
    '沿江西岸分布的历史建筑来自不同年代，呈现多种建筑风格，不能被说成同一时期一次建成。',
    '今天的滨水步行空间让人同时观察历史街景、江上交通和浦东轮廓，但不同视角对应不同叙事。',
  ]),
  _StoryBlock('旧目录中的底片编号证明照片属于分阶段拍摄的城市记录组，准确日期仍待确认。', <String>[
    '它不是某一天完成的“新旧对照宣传照”，而是系列影像中的一张，原说明在复制过程中遗失。',
    '林乔把可见证据、目录编号和未知部分分别标出，没有把推测写成事实。',
  ]),
  _StoryBlock('她重写说明牌，展览晚开十分钟，却避免了错误年代。', <String>[
    '新版文字说明外滩的历史金融与贸易记忆、黄浦江的空间关系，也明确照片仍需进一步考证。',
    '团队保留她设计的来源栏、视点栏和不确定性标记，后来接收新照片时都用同一方法登记。',
    '林乔没有得到最吸引眼球的标题，却成为下一轮口述史整理负责人，因为她守住了证据边界。',
    '她在结尾补上征集说明，邀请观众提供有出处的家族照片或口述线索，但所有新信息都必须经过交叉核对后才能进入正式记录。',
  ]),
  _StoryBlock('她记住了这次选择：城市可以隔江对话，说明文字必须让证据先开口。', <String>[]),
];

final shanghaiBundRemediation = RemediatedJourney(
  id: 'shanghai-bund',
  title: '上海 · 外滩：让证据先开口',
  protagonist: '林乔，二十岁的城市档案志愿者',
  goal: '在展览开幕前为一张无说明旧照片建立可信的年代、视点和来源记录',
  conflict: '戏剧化热门标题能按时吸引观众，却与照片方向和档案证据冲突',
  eventIds: _bundEvents,
  levels: _buildLevels(
    blocks: _bundBlocks,
    detailCounts: const <int>[0, 1, 2, 4, 5, 7, 9, 11, 12, 14],
    firstAnnotation: const ReadingAnnotation(
      pinyin: 'Èrshí suì de dàng àn zhìyuànzhě Lín Qiáo zài Wàitān zhǎnlǎn kāimù qián shōudào yì zhāng méiyǒu shuōmíng de jiù zhàopiàn. Tā jùjué zhíjiē cǎiyòng xǐngmù biāotí, juédìng xiān héduì pāishè fāngxiàng hé láiyuán.',
      vietnamese: 'Lâm Kiều, tình nguyện viên lưu trữ hai mươi tuổi, nhận một bức ảnh cũ không có chú thích trước giờ khai mạc triển lãm Bến Thượng Hải. Cô từ chối dùng ngay tiêu đề giật gân và chọn kiểm tra hướng chụp cùng nguồn gốc.',
      english: 'Twenty-year-old archive volunteer Lin Qiao receives an unlabeled old photograph before a Bund exhibition opens. She rejects a dramatic caption and chooses to verify its viewpoint and provenance.',
    ),
    secondAnnotation: const ReadingAnnotation(
      pinyin: 'Tā yán Huángpǔ Jiāng bǐduì jiànzhù lúnkuò, yòu zài jiù mùlù zhōng zhǎodào dǐpiàn biānhào. Xīn shuōmíng pái biāomíng yǐzhī zhèngjù hé wèizhī bùfen, suīrán chídào què bìmiǎn le cuòwù niándài.',
      vietnamese: 'Cô đối chiếu đường nét công trình dọc sông Hoàng Phố rồi tìm thấy số âm bản trong mục lục cũ. Chú thích mới tách rõ bằng chứng đã biết và phần chưa biết, mở muộn nhưng tránh ghi sai niên đại.',
      english: 'She compares building outlines along the Huangpu River and finds the negative number in an old catalogue. The revised label separates known evidence from uncertainty and prevents a false date.',
    ),
  ),
  words: <WordEntry>[
    _word(word: '外滩', pinyin: 'wàitān', partOfSpeech: '专有名词', simpleChinese: '上海黄浦江西岸的重要历史滨水地区。', vietnamese: 'Khu Bến Thượng Hải lịch sử ở bờ tây sông Hoàng Phố.', english: 'the Bund, a historic waterfront area on the west bank of the Huangpu River', symbol: '🌆', storySentence: '林乔为外滩展览核对照片。', storyPinyin: 'Lín Qiáo wèi Wàitān zhǎnlǎn héduì zhàopiàn.', storyVietnamese: 'Lâm Kiều kiểm tra ảnh cho triển lãm Bến Thượng Hải.', storyEnglish: 'Lin Qiao verifies a photograph for a Bund exhibition.'),
    _word(word: '黄浦江', pinyin: 'huángpǔ jiāng', partOfSpeech: '专有名词', simpleChinese: '流经上海中心城区的重要河流。', vietnamese: 'Sông quan trọng chảy qua trung tâm Thượng Hải.', english: 'the Huangpu River running through central Shanghai', symbol: '🌊', storySentence: '旧照片拍向黄浦江。', storyPinyin: 'Jiù zhàopiàn pāi xiàng Huángpǔ Jiāng.', storyVietnamese: 'Bức ảnh cũ hướng về sông Hoàng Phố.', storyEnglish: 'The old photograph faces the Huangpu River.'),
    _word(word: '浦东', pinyin: 'pǔdōng', partOfSpeech: '专有名词', simpleChinese: '黄浦江东岸的上海城区。', vietnamese: 'Khu đô thị Thượng Hải ở bờ đông sông Hoàng Phố.', english: 'Pudong, the urban area east of the Huangpu River', symbol: '🏙️', storySentence: '标题把浦东的发展写成一夜完成。', storyPinyin: 'Biāotí bǎ Pǔdōng de fāzhǎn xiě chéng yí yè wánchéng.', storyVietnamese: 'Tiêu đề viết sự phát triển của Phố Đông như thể diễn ra trong một đêm.', storyEnglish: 'The caption compresses Pudong’s development into a single night.'),
    _word(word: '天际线', pinyin: 'tiānjìxiàn', partOfSpeech: '名词', simpleChinese: '建筑轮廓与天空相接形成的线。', vietnamese: 'Đường viền công trình nơi tiếp giáp với bầu trời.', english: 'the skyline formed by building silhouettes', symbol: '🌇', storySentence: '浦东天际线与外滩隔江相望。', storyPinyin: 'Pǔdōng tiānjìxiàn yǔ Wàitān gé jiāng xiāngwàng.', storyVietnamese: 'Đường chân trời Phố Đông đối diện Bến Thượng Hải qua sông.', storyEnglish: 'The Pudong skyline faces the Bund across the river.'),
    _word(word: '档案', pinyin: 'dàng àn', partOfSpeech: '名词', simpleChinese: '保存历史记录和证据的材料。', vietnamese: 'Tài liệu lưu giữ hồ sơ và bằng chứng lịch sử.', english: 'archival records preserving historical evidence', symbol: '🗃️', storySentence: '林乔在档案目录中追踪编号。', storyPinyin: 'Lín Qiáo zài dàng àn mùlù zhōng zhuīzōng biānhào.', storyVietnamese: 'Lâm Kiều lần theo số hiệu trong mục lục lưu trữ.', storyEnglish: 'Lin Qiao traces the number through the archive catalogue.'),
    _word(word: '视点', pinyin: 'shìdiǎn', partOfSpeech: '名词', simpleChinese: '观察或拍摄所在的位置和方向。', vietnamese: 'Vị trí và hướng quan sát hoặc chụp ảnh.', english: 'the position and direction of observation or photography', symbol: '👁️', storySentence: '方向关系帮助她判断视点。', storyPinyin: 'Fāngxiàng guānxì bāngzhù tā pànduàn shìdiǎn.', storyVietnamese: 'Quan hệ phương hướng giúp cô xác định điểm nhìn.', storyEnglish: 'Directional relationships help her identify the viewpoint.'),
    _word(word: '轮廓', pinyin: 'lúnkuò', partOfSpeech: '名词', simpleChinese: '物体外部形状形成的线条。', vietnamese: 'Đường nét tạo thành hình dạng bên ngoài của vật thể.', english: 'the outline or silhouette of an object', symbol: '🏢', storySentence: '她沿江比对建筑轮廓。', storyPinyin: 'Tā yán jiāng bǐduì jiànzhù lúnkuò.', storyVietnamese: 'Cô đối chiếu đường nét công trình dọc sông.', storyEnglish: 'She compares building outlines along the river.'),
    _word(word: '底片', pinyin: 'dǐpiàn', partOfSpeech: '名词', simpleChinese: '传统摄影中记录影像的感光材料。', vietnamese: 'Vật liệu cảm quang ghi hình trong nhiếp ảnh truyền thống.', english: 'a photographic negative', symbol: '🎞️', storySentence: '旧目录中出现了同一底片编号。', storyPinyin: 'Jiù mùlù zhōng chūxiàn le tóng yī dǐpiàn biānhào.', storyVietnamese: 'Cùng một số âm bản xuất hiện trong mục lục cũ.', storyEnglish: 'The same negative number appears in the old catalogue.'),
    _word(word: '编号', pinyin: 'biānhào', partOfSpeech: '名词', simpleChinese: '为了识别和查找而设置的号码。', vietnamese: 'Số dùng để nhận diện và tra cứu.', english: 'an identification or catalogue number', symbol: '🔢', storySentence: '底片编号连接了照片和档案记录。', storyPinyin: 'Dǐpiàn biānhào liánjiē le zhàopiàn hé dàng àn jìlù.', storyVietnamese: 'Số âm bản nối bức ảnh với hồ sơ lưu trữ.', storyEnglish: 'The negative number links the photograph to the archive record.'),
    _word(word: '考证', pinyin: 'kǎozhèng', partOfSpeech: '动词', simpleChinese: '根据材料调查并验证事实。', vietnamese: 'Khảo cứu và xác minh sự thật dựa trên tư liệu.', english: 'to investigate and verify through evidence', symbol: '📚', storySentence: '照片的准确日期仍需考证。', storyPinyin: 'Zhàopiàn de zhǔnquè rìqī réng xū kǎozhèng.', storyVietnamese: 'Ngày chính xác của bức ảnh vẫn cần khảo cứu.', storyEnglish: 'The photograph’s exact date still requires verification.'),
    _word(word: '来源', pinyin: 'láiyuán', partOfSpeech: '名词', simpleChinese: '信息、材料或物品从哪里来。', vietnamese: 'Nguồn gốc của thông tin, tài liệu hoặc hiện vật.', english: 'the source or provenance of information or material', symbol: '🔗', storySentence: '林乔拒绝隐藏照片来源。', storyPinyin: 'Lín Qiáo jùjué yǐncáng zhàopiàn láiyuán.', storyVietnamese: 'Lâm Kiều từ chối che giấu nguồn gốc bức ảnh.', storyEnglish: 'Lin Qiao refuses to hide the photograph’s provenance.'),
    _word(word: '不确定性', pinyin: 'bù quèdìngxìng', partOfSpeech: '名词', simpleChinese: '证据尚不能完全确认的部分。', vietnamese: 'Phần bằng chứng chưa thể xác nhận hoàn toàn.', english: 'an unresolved area of uncertainty', symbol: '❓', storySentence: '说明牌保留了不确定性标记。', storyPinyin: 'Shuōmíngpái bǎoliú le bù quèdìngxìng biāojì.', storyVietnamese: 'Bảng chú thích giữ lại dấu phần chưa chắc chắn.', storyEnglish: 'The label keeps a visible uncertainty marker.'),
  ],
  wordTraces: const <RemediatedWordTrace>[
    RemediatedWordTrace(word: '外滩', eventId: 'BD-E1-photo'),
    RemediatedWordTrace(word: '黄浦江', eventId: 'BD-E1-photo'),
    RemediatedWordTrace(word: '浦东', eventId: 'BD-E2-caption-conflict'),
    RemediatedWordTrace(word: '天际线', eventId: 'BD-E4-field-check'),
    RemediatedWordTrace(word: '档案', eventId: 'BD-E5-archive-evidence'),
    RemediatedWordTrace(word: '视点', eventId: 'BD-E4-field-check'),
    RemediatedWordTrace(word: '轮廓', eventId: 'BD-E4-field-check'),
    RemediatedWordTrace(word: '底片', eventId: 'BD-E5-archive-evidence'),
    RemediatedWordTrace(word: '编号', eventId: 'BD-E5-archive-evidence'),
    RemediatedWordTrace(word: '考证', eventId: 'BD-E6-consequence'),
    RemediatedWordTrace(word: '来源', eventId: 'BD-E3-choice'),
    RemediatedWordTrace(word: '不确定性', eventId: 'BD-E6-consequence'),
  ],
  discoveries: const <DiscoveryEntry>[
    DiscoveryEntry(text: '外滩位于黄浦江西岸。历史建筑群、江面交通和浦东天际线在不同视点中形成层次，观察方向是阅读城市照片的重要线索。', pinyin: 'Wàitān wèiyú Huángpǔ Jiāng xī àn, lìshǐ jiànzhùqún yǔ Pǔdōng tiānjìxiàn gé jiāng xiāngwàng.', simpleChinese: '外滩在黄浦江西岸，隔江可以看见浦东。', vietnamese: 'Bến Thượng Hải nằm ở bờ tây sông Hoàng Phố và nhìn sang đường chân trời Phố Đông.', english: 'The Bund lies on the west bank of the Huangpu River and faces the Pudong skyline.'),
    DiscoveryEntry(text: '外滩历史建筑来自不同年代并呈现多种建筑风格。把它们说成同一时期一次建成，会抹去街区长期形成的历史层次。', pinyin: 'Wàitān lìshǐ jiànzhù láizì bùtóng niándài, bìng chéngxiàn duōzhǒng jiànzhù fēnggé.', simpleChinese: '外滩建筑不是同一年建成，也不是只有一种风格。', vietnamese: 'Các công trình lịch sử ở Bến Thượng Hải thuộc nhiều thời kỳ và phong cách khác nhau.', english: 'The Bund’s historic buildings come from different periods and display multiple architectural styles.'),
    DiscoveryEntry(text: '外滩曾与上海近代金融、贸易和航运活动密切相关。城市记忆需要同时说明建筑、江岸功能与档案来源，不能只靠戏剧化口号。', pinyin: 'Wàitān céng yǔ Shànghǎi jìndài jīnróng, màoyì hé hángyùn huódòng mìqiè xiāngguān.', simpleChinese: '外滩与上海近代金融、贸易和航运历史有关。', vietnamese: 'Bến Thượng Hải gắn với lịch sử tài chính, thương mại và vận tải thủy cận đại của thành phố.', english: 'The Bund is closely connected with Shanghai’s modern history of finance, trade, and shipping.'),
    DiscoveryEntry(text: '历史照片的说明应区分可见证据、目录记录、口述线索和仍未知的部分。来源、视点与不确定性共同决定一条说明是否可信。', pinyin: 'Lìshǐ zhàopiàn de shuōmíng yīng qūfēn kějiàn zhèngjù, mùlù jìlù hé réng wèizhī de bùfen.', simpleChinese: '照片说明要写清证据、来源和还不知道的部分。', vietnamese: 'Chú thích ảnh lịch sử cần phân biệt bằng chứng nhìn thấy, hồ sơ mục lục, lời kể và phần chưa biết.', english: 'Historical-photo captions should distinguish visible evidence, catalogue records, oral clues, and what remains unknown.'),
  ],
  discoveryTraces: const <RemediatedDiscoveryTrace>[
    RemediatedDiscoveryTrace(discoveryIndex: 0, storyEventIds: <String>['BD-E1-photo', 'BD-E4-field-check'], sourceIds: <String>['shanghai-gov-bund-scenic', 'huangpu-gov-bund-heritage']),
    RemediatedDiscoveryTrace(discoveryIndex: 1, storyEventIds: <String>['BD-E4-field-check'], sourceIds: <String>['huangpu-gov-bund-heritage']),
    RemediatedDiscoveryTrace(discoveryIndex: 2, storyEventIds: <String>['BD-E2-caption-conflict', 'BD-E6-consequence'], sourceIds: <String>['shanghai-gov-bund-scenic', 'huangpu-gov-bund-heritage']),
    RemediatedDiscoveryTrace(discoveryIndex: 3, storyEventIds: <String>['BD-E3-choice', 'BD-E5-archive-evidence'], sourceIds: <String>['shanghai-gov-bund-scenic']),
  ],
  challenges: const <RemediatedChallengeTrace>[
    RemediatedChallengeTrace(type: 'paragraphRebuild', storyEventIds: <String>['BD-E1-photo', 'BD-E3-choice', 'BD-E6-consequence'], anchor: '收到旧照片 → 暂停热门说明 → 改写可信说明牌'),
    RemediatedChallengeTrace(type: 'grammarRepair', storyEventIds: <String>['BD-E2-caption-conflict', 'BD-E4-field-check'], anchor: '外滩、浦东两岸与城市层次'),
    RemediatedChallengeTrace(type: 'missingSentence', storyEventIds: <String>['BD-E4-field-check', 'BD-E5-archive-evidence'], anchor: '建筑顺序与底片编号共同纠正拍摄方向'),
  ],
  memory: const <RemediatedMemoryReview>[
    RemediatedMemoryReview(category: 'protagonist', prompt: '主人公', answer: '林乔从追求准时和吸引力的志愿者，成长为愿意公开未知并保护证据边界的档案整理者。', storyEventIds: <String>['BD-E1-photo', 'BD-E7-growth']),
    RemediatedMemoryReview(category: 'events', prompt: '关键事件', answer: '无说明照片、热门标题、暂停发布、沿江比对、目录编号、改写说明牌形成完整因果链。', storyEventIds: _bundEvents),
    RemediatedMemoryReview(category: 'history', prompt: '历史', answer: '外滩与上海近代金融、贸易和航运记忆相关，历史建筑和影像来自不同年代。', storyEventIds: <String>['BD-E2-caption-conflict', 'BD-E6-consequence']),
    RemediatedMemoryReview(category: 'culture', prompt: '文化', answer: '黄浦江两岸的对望使历史街景与现代天际线进入同一城市叙事，但不能把长期变化简化为“一夜崛起”。', storyEventIds: <String>['BD-E2-caption-conflict']),
    RemediatedMemoryReview(category: 'architecture', prompt: '建筑', answer: '外滩历史建筑呈现不同年代和多种风格，轮廓、顺序与视点可帮助判断照片位置。', storyEventIds: <String>['BD-E4-field-check']),
    RemediatedMemoryReview(category: 'vocabulary', prompt: '关键词', answer: '外滩、黄浦江、天际线、视点、轮廓、底片、编号、考证、来源。', storyEventIds: <String>['BD-E1-photo', 'BD-E4-field-check', 'BD-E5-archive-evidence']),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '林乔从一张无说明旧照片出发，用现场方向和档案编号重建可信的城市说明。',
    achievement: '城市证据编辑：能区分可见事实、档案记录、推测与未知项。',
    memoryAnchor: '城市可以隔江对话，说明文字必须让证据先开口。',
    challengeReward: '完成短文复原、语病修复与补回句子，获得“黄浦证据章”。',
    journeyCompletion: '上海 · 外滩 Journey Completion',
  ),
  sources: const <RemediatedSourceBinding>[
    RemediatedSourceBinding(id: 'shanghai-gov-bund-scenic', publisher: 'Shanghai Municipal Government', scope: '外滩地理、城市历史与景观关系'),
    RemediatedSourceBinding(id: 'huangpu-gov-bund-heritage', publisher: 'Huangpu District Government', scope: '外滩历史文化风貌区与建筑遗产'),
  ],
);

final batchOneRemediatedJourneys = <String, RemediatedJourney>{
  forbiddenCityRemediation.id: forbiddenCityRemediation,
  shanghaiBundRemediation.id: shanghaiBundRemediation,
};

RemediatedJourney? batchOneRemediationFor(String journeyId) =>
    batchOneRemediatedJourneys[journeyId];

JourneyLevelContent? batchOneJourneyLevelContentFor(
  String journeyId,
  int level,
) => batchOneRemediationFor(journeyId)?.levelContent(level);
