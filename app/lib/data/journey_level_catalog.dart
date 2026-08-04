import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'summer_palace_journey.dart';

enum JourneyDifficulty { easy, standard, challenge }

extension JourneyDifficultyPresentation on JourneyDifficulty {
  String get storageValue => switch (this) {
        JourneyDifficulty.easy => 'easy',
        JourneyDifficulty.standard => 'standard',
        JourneyDifficulty.challenge => 'challenge',
      };

  String get label => switch (this) {
        JourneyDifficulty.easy => '轻松',
        JourneyDifficulty.standard => '标准',
        JourneyDifficulty.challenge => '挑战',
      };

  String get hint => switch (this) {
        JourneyDifficulty.easy => '短句 · 重点词 · 慢一点',
        JourneyDifficulty.standard => '完整故事 · 正常节奏',
        JourneyDifficulty.challenge => '文化表达 · 深度思考',
      };

  double get speechRate => switch (this) {
        JourneyDifficulty.easy => .8,
        JourneyDifficulty.standard => 1,
        JourneyDifficulty.challenge => 1.1,
      };
}

JourneyDifficulty parseJourneyDifficulty(String? value) {
  return JourneyDifficulty.values.firstWhere(
    (difficulty) => difficulty.storageValue == value,
    orElse: () => JourneyDifficulty.standard,
  );
}

class JourneyLevelContent {
  const JourneyLevelContent({
    required this.storyParagraphs,
    required this.storyAnnotations,
    required this.words,
    required this.discoveries,
    required this.wonderQuestion,
    required this.expressQuestion,
  });

  factory JourneyLevelContent.fromExperience(
      DailyJourneyExperience experience) {
    return JourneyLevelContent(
      storyParagraphs: experience.content.storyParagraphs,
      storyAnnotations: experience.storyAnnotations,
      words: experience.words,
      discoveries: experience.discoveries,
      wonderQuestion: experience.wonderQuestion,
      expressQuestion: experience.expressQuestion,
    ).withReadingLimit();
  }

  final List<String> storyParagraphs;
  final List<ReadingAnnotation> storyAnnotations;
  final List<WordEntry> words;
  final List<DiscoveryEntry> discoveries;
  final String wonderQuestion;
  final String expressQuestion;

  JourneyLevelContent withReadingLimit({
    int paragraphCount = 2,
    int discoveryCount = 2,
  }) {
    final safeParagraphCount = paragraphCount.clamp(1, 2).toInt();
    final safeDiscoveryCount = discoveryCount.clamp(1, 2).toInt();
    final storyRanges = _balancedRanges(
      storyParagraphs.length,
      safeParagraphCount,
    );
    final discoveryRanges = _balancedRanges(
      discoveries.length,
      safeDiscoveryCount,
    );

    return JourneyLevelContent(
      storyParagraphs: storyRanges
          .map(
            (range) => _joinChinese(
              storyParagraphs.sublist(range.start, range.end),
            ),
          )
          .toList(growable: false),
      storyAnnotations: storyRanges
          .map(
            (range) => _mergeAnnotations(
              storyAnnotations.sublist(
                range.start.clamp(0, storyAnnotations.length).toInt(),
                range.end.clamp(0, storyAnnotations.length).toInt(),
              ),
            ),
          )
          .toList(growable: false),
      words: words,
      discoveries: discoveryRanges
          .map(
            (range) => _mergeDiscoveries(
              discoveries.sublist(range.start, range.end),
            ),
          )
          .toList(growable: false),
      wonderQuestion: wonderQuestion,
      expressQuestion: expressQuestion,
    );
  }
}

class _ContentRange {
  const _ContentRange(this.start, this.end);

  final int start;
  final int end;
}

List<_ContentRange> _balancedRanges(int length, int maximumCount) {
  if (length <= 0) return const <_ContentRange>[];
  final count = length.clamp(1, maximumCount).toInt();
  return List<_ContentRange>.generate(count, (index) {
    final start = (index * length / count).floor();
    final end = ((index + 1) * length / count).floor();
    return _ContentRange(start, end);
  }, growable: false);
}

String _joinChinese(Iterable<String> values) => values
    .map((value) => value.trim())
    .where((value) => value.isNotEmpty)
    .join();

String _joinLatin(Iterable<String> values) => values
    .map((value) => value.trim())
    .where((value) => value.isNotEmpty)
    .join(' ');

ReadingAnnotation _mergeAnnotations(List<ReadingAnnotation> entries) {
  if (entries.isEmpty) {
    return const ReadingAnnotation(pinyin: '', vietnamese: '', english: '');
  }
  return ReadingAnnotation(
    pinyin: _joinLatin(entries.map((entry) => entry.pinyin)),
    vietnamese: _joinLatin(entries.map((entry) => entry.vietnamese)),
    english: _joinLatin(entries.map((entry) => entry.english)),
  );
}

DiscoveryEntry _mergeDiscoveries(List<DiscoveryEntry> entries) {
  return DiscoveryEntry(
    text: _joinChinese(entries.map((entry) => entry.text)),
    pinyin: _joinLatin(entries.map((entry) => entry.pinyin)),
    simpleChinese: _joinChinese(
      entries.map((entry) => entry.simpleChinese),
    ),
    vietnamese: _joinLatin(entries.map((entry) => entry.vietnamese)),
    english: _joinLatin(entries.map((entry) => entry.english)),
  );
}

List<JourneyDifficulty> supportedJourneyDifficulties(
  DailyJourneyExperience experience,
) {
  if (experience.id == 'beijing-summer-palace') {
    return JourneyDifficulty.values;
  }
  return const <JourneyDifficulty>[JourneyDifficulty.standard];
}

JourneyLevelContent resolveJourneyLevel(
  DailyJourneyExperience experience,
  JourneyDifficulty difficulty,
) {
  if (experience.id != 'beijing-summer-palace') {
    return JourneyLevelContent.fromExperience(experience);
  }

  return (switch (difficulty) {
    JourneyDifficulty.easy => summerPalaceEasyLevel,
    JourneyDifficulty.standard =>
      JourneyLevelContent.fromExperience(experience),
    JourneyDifficulty.challenge => summerPalaceChallengeLevel,
  }).withReadingLimit();
}

List<WordEntry> _selectSummerPalaceWords(List<String> selectedWords) {
  return summerPalaceWords
      .where((entry) => selectedWords.contains(entry.word))
      .toList(growable: false);
}

final summerPalaceEasyLevel = JourneyLevelContent(
  storyParagraphs: const <String>[
    '许澄要为校展拍一张完美的颐和园照片。',
    '外婆周岚以前修复过长廊彩画。她让许澄看裂痕，许澄却只想拍没有缺点的风景。',
    '十七孔桥前，外婆的旧照片被风吹落。许澄没有追着阳光，而是先把照片捡回来。',
    '她把外婆的手、旧照片和远山一起拍下，明白修复不是把过去擦掉。',
  ],
  storyAnnotations: const <ReadingAnnotation>[
    ReadingAnnotation(
      pinyin: 'Xǔ Chéng yào wèi xiàozhǎn pāi yì zhāng wánměi de Yíhéyuán zhàopiàn.',
      vietnamese:
          'Hứa Trừng muốn chụp một bức ảnh Di Hòa Viên hoàn hảo cho triển lãm trường.',
      english:
          'Xu Cheng wants to take a perfect Summer Palace photograph for her school exhibition.',
    ),
    ReadingAnnotation(
      pinyin:
          'Wàipó Zhōu Lán yǐqián xiūfù guò Chángláng cǎihuà. Tā ràng Xǔ Chéng kàn lièhén, Xǔ Chéng què zhǐ xiǎng pāi méiyǒu quēdiǎn de fēngjǐng.',
      vietnamese:
          'Bà ngoại Chu Lam từng phục hồi tranh màu Trường Lang. Bà muốn Hứa Trừng nhìn các vết nứt, nhưng cô chỉ muốn phong cảnh không khuyết điểm.',
      english:
          'Her grandmother Zhou Lan once restored Long Corridor paintings. She asks Xu Cheng to see the cracks, but Xu Cheng wants a flawless view.',
    ),
    ReadingAnnotation(
      pinyin:
          'Shíqīkǒng Qiáo qián, wàipó de jiù zhàopiàn bèi fēng chuīluò. Xǔ Chéng méiyǒu zhuīzhe yángguāng, ér shì xiān bǎ zhàopiàn jiǎn huílai.',
      vietnamese:
          'Trước cầu Thập Thất Khổng, ảnh cũ của bà bị gió thổi rơi. Hứa Trừng không chạy theo ánh sáng mà nhặt ảnh trước.',
      english:
          'At the Seventeen-Arch Bridge, her grandmother’s old photograph falls. Xu Cheng stops chasing the light and retrieves it first.',
    ),
    ReadingAnnotation(
      pinyin:
          'Tā bǎ wàipó de shǒu, jiù zhàopiàn hé yuǎnshān yìqǐ pāi xià, míngbai xiūfù bú shì bǎ guòqù cādiào.',
      vietnamese:
          'Cô chụp bàn tay bà, bức ảnh cũ và núi xa cùng nhau, rồi hiểu rằng phục hồi không phải xóa quá khứ.',
      english:
          'She frames her grandmother’s hand, the old photograph, and the distant hill together, understanding that restoration does not erase the past.',
    ),
  ],
  words: _selectSummerPalaceWords(const <String>[
    '颐和园',
    '万寿山',
    '长廊',
    '修复',
    '借景',
    '十七孔桥',
  ]),
  discoveries: const <DiscoveryEntry>[
    DiscoveryEntry(
      text: '长廊的柱子和开口会让远山与湖面随着脚步出现或消失。',
      pinyin:
          'Chángláng de zhùzi hé kāikǒu huì ràng yuǎnshān yǔ húmiàn suízhe jiǎobù chūxiàn huò xiāoshī.',
      simpleChinese: '长廊让风景随着脚步变化。',
      vietnamese:
          'Cột và khoảng mở của Trường Lang làm núi xa và mặt hồ xuất hiện hoặc biến mất theo bước chân.',
      english:
          'The Long Corridor makes distant hills and the lake appear or disappear as a person walks.',
    ),
    DiscoveryEntry(
      text: '借景利用方向和距离，把远处景物放进当前画面。',
      pinyin:
          'Jièjǐng lìyòng fāngxiàng hé jùlí, bǎ yuǎnchù jǐngwù fàng jìn dāngqián huàmiàn.',
      simpleChinese: '借景把远景带进眼前的画面。',
      vietnamese:
          'Mượn cảnh dùng hướng và khoảng cách để đưa cảnh xa vào khung nhìn hiện tại.',
      english:
          'Borrowed scenery uses direction and distance to bring a distant view into the current frame.',
    ),
    DiscoveryEntry(
      text: '修复会保护旧材料，也会记录后来补上的部分。',
      pinyin:
          'Xiūfù huì bǎohù jiù cáiliào, yě huì jìlù hòulái bǔshàng de bùfen.',
      simpleChinese: '修复既保护，也留下记录。',
      vietnamese:
          'Phục hồi bảo vệ vật liệu cũ và ghi lại phần được bổ sung sau này.',
      english:
          'Restoration protects old material and records later additions.',
    ),
  ],
  wonderQuestion: '许澄为什么先捡旧照片？',
  expressQuestion: '请用一到两句话写出许澄最后的选择。',
);

const summerPalaceChallengeLevel = JourneyLevelContent(
  storyParagraphs: <String>[
    '校展截稿前夕，许澄执意寻找一幅“无瑕”的皇家园林图景，以此证明自己的摄影不再依赖外婆周岚。',
    '周岚曾参与长廊彩画修复。她借廊柱的遮蔽与开敞说明：构图和修复一样，都必须决定何者显现、何者退后，却不能伪造未曾受损的过去。',
    '十七孔桥前，理想光线出现的同时，记录修复前长廊及周岚老师的旧照片被风吹落。许澄必须在标准风景与关系记忆之间作出不可兼得的选择。',
    '她放弃追光，以旧照片、外婆扶栏的手和桥孔后的万寿山形成三层对景。失去明信片式画面的后果，换来《留下痕迹的风景》与外婆交付旧照片的信任。',
  ],
  storyAnnotations: <ReadingAnnotation>[
    ReadingAnnotation(
      pinyin:
          'Xiàozhǎn jiégǎo qiánxī, Xǔ Chéng zhíyì xúnzhǎo yì fú wúxiá de huángjiā yuánlín tújǐng, yǐcǐ zhèngmíng zìjǐ de shèyǐng bù zài yīlài wàipó Zhōu Lán.',
      vietnamese:
          'Trước hạn triển lãm, Hứa Trừng cố tìm một hình ảnh vườn hoàng gia “không tì vết” để chứng minh nhiếp ảnh của mình không còn phụ thuộc vào bà ngoại Chu Lam.',
      english:
          'Before the exhibition deadline, Xu Cheng insists on finding a flawless imperial-garden image to prove her photography no longer depends on Zhou Lan.',
    ),
    ReadingAnnotation(
      pinyin:
          'Zhōu Lán céng cānyù Chángláng cǎihuà xiūfù. Tā jiè lángzhù de zhēbì yǔ kāichǎng shuōmíng: gòutú hé xiūfù yíyàng, dōu bìxū juédìng hézhě xiǎnxiàn, hézhě tuìhòu, què bùnéng wěizào wèicéng shòusǔn de guòqù.',
      vietnamese:
          'Chu Lam từng phục hồi tranh màu Trường Lang. Bà dùng nhịp che và mở của cột để giải thích rằng bố cục và phục hồi đều phải chọn điều gì hiện ra, điều gì lùi lại, nhưng không được giả tạo một quá khứ chưa từng tổn hại.',
      english:
          'Zhou Lan uses the corridor’s concealment and opening to explain that composition and restoration both decide what appears and recedes, without fabricating an undamaged past.',
    ),
    ReadingAnnotation(
      pinyin:
          'Shíqīkǒng Qiáo qián, lǐxiǎng guāngxiàn chūxiàn de tóngshí, jìlù xiūfù qián Chángláng jí Zhōu Lán lǎoshī de jiù zhàopiàn bèi fēng chuīluò. Xǔ Chéng bìxū zài biāozhǔn fēngjǐng yǔ guānxì jìyì zhījiān zuòchū bùkě jiāndé de xuǎnzé.',
      vietnamese:
          'Trước cầu Thập Thất Khổng, đúng lúc ánh sáng lý tưởng xuất hiện, bức ảnh cũ ghi Trường Lang trước phục hồi và người thầy của Chu Lam bị gió cuốn. Hứa Trừng phải chọn giữa phong cảnh chuẩn và ký ức quan hệ.',
      english:
          'At the Seventeen-Arch Bridge, ideal light arrives as the old photograph of the unrestored corridor and Zhou Lan’s teacher falls, forcing an exclusive choice between a standard view and relational memory.',
    ),
    ReadingAnnotation(
      pinyin:
          'Tā fàngqì zhuīguāng, yǐ jiù zhàopiàn, wàipó fúlán de shǒu hé qiáokǒng hòu de Wànshòu Shān xíngchéng sān céng duìjǐng. Shīqù míngxìnpiàn shì huàmiàn de hòuguǒ, huànlái Liúxià Hénjì de Fēngjǐng yǔ wàipó jiāofù jiù zhàopiàn de xìnrèn.',
      vietnamese:
          'Cô bỏ ánh sáng lý tưởng, tạo ba lớp đối cảnh bằng ảnh cũ, bàn tay bà và núi Vạn Thọ sau vòm cầu. Việc mất hình ảnh kiểu bưu thiếp đổi lại tác phẩm “Phong cảnh lưu dấu vết” và niềm tin khi bà giao bức ảnh cho cô.',
      english:
          'She abandons the ideal light and composes the old photograph, her grandmother’s hand, and Longevity Hill in three layers. Losing the postcard image leads to a truer work and Zhou Lan’s trust.',
    ),
  ],
  words: summerPalaceWords,
  discoveries: <DiscoveryEntry>[
    DiscoveryEntry(
      text: '颐和园以万寿山和昆明湖建立山水骨架，长廊、桥梁和亭台再通过路线与视线进入整体秩序。',
      pinyin:
          'Yíhéyuán yǐ Wànshòu Shān hé Kūnmíng Hú jiànlì shānshuǐ gǔjià, Chángláng, qiáoliáng hé tíngtái zài tōngguò lùxiàn yǔ shìxiàn jìnrù zhěngtǐ zhìxù.',
      simpleChinese: '山和湖是骨架，建筑通过路线进入整体风景。',
      vietnamese:
          'Núi Vạn Thọ và hồ Côn Minh tạo khung cảnh quan; hành lang, cầu và đình đi vào trật tự chung qua tuyến đường và tầm nhìn.',
      english:
          'Longevity Hill and Kunming Lake form the framework, while corridors, bridges, and pavilions enter through routes and sightlines.',
    ),
    DiscoveryEntry(
      text: '借景把远处景物纳入当前视野，对景在特定位置建立视觉目标；两者都依赖方向、比例和观看者的位置。',
      pinyin:
          'Jièjǐng bǎ yuǎnchù jǐngwù nàrù dāngqián shìyě, duìjǐng zài tèdìng wèizhì jiànlì shìjué mùbiāo; liǎngzhě dōu yīlài fāngxiàng, bǐlì hé guānkànzhě de wèizhì.',
      simpleChinese: '借景和对景都需要安排方向、比例和人的位置。',
      vietnamese:
          'Mượn cảnh đưa cảnh xa vào tầm nhìn, còn đối cảnh tạo mục tiêu thị giác tại vị trí cụ thể; cả hai dựa vào hướng, tỷ lệ và vị trí người xem.',
      english:
          'Borrowed scenery incorporates distant elements; opposite views establish a target. Both depend on direction, proportion, and viewer position.',
    ),
    DiscoveryEntry(
      text: '颐和园经历破坏与重建，修复记录用于区分旧材料、加固部分和后来补绘，避免把历史层次伪装成从未改变。',
      pinyin:
          'Yíhéyuán jīnglì pòhuài yǔ chóngjiàn, xiūfù jìlù yòngyú qūfēn jiù cáiliào, jiāgù bùfen hé hòulái bǔhuì, bìmiǎn bǎ lìshǐ céngcì wěizhuāng chéng cóngwèi gǎibiàn.',
      simpleChinese: '修复记录帮助人们看懂旧材料和后来补上的部分。',
      vietnamese:
          'Hồ sơ phục hồi phân biệt vật liệu cũ, phần gia cố và phần vẽ bổ sung, tránh giả vờ lịch sử chưa từng thay đổi.',
      english:
          'Restoration records distinguish old material, reinforcement, and later retouching instead of disguising historical change.',
    ),
    DiscoveryEntry(
      text: '十七孔桥兼具通行与构图功能，用水平线把石栏、水面和远山组织成有深度的前中远景。',
      pinyin:
          'Shíqīkǒng Qiáo jiānjù tōngxíng yǔ gòutú gōngnéng, yòng shuǐpíngxiàn bǎ shílán, shuǐmiàn hé yuǎnshān zǔzhī chéng yǒu shēndù de qián, zhōng, yuǎnjǐng.',
      simpleChinese: '桥既能通行，也把近景、中景和远景组织在一起。',
      vietnamese:
          'Cầu Thập Thất Khổng vừa để đi lại vừa tổ chức lan can, mặt nước và núi xa thành các lớp có chiều sâu.',
      english:
          'The bridge serves movement and composition, organizing railings, water, and distant hills into foreground, middle ground, and background.',
    ),
  ],
  wonderQuestion: '许澄的摄影选择如何把园林构图原则转化为对历史与关系的判断？',
  expressQuestion: '请用四到六句话分析“无瑕”与“可阅读的修复痕迹”代表的两种遗产态度。',
);
