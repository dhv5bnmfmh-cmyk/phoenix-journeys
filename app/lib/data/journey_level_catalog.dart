import 'chengdu_kuanzhai_one_pass.dart';
import 'daily_journey_experience.dart';
import 'guangzhou_chen_clan_one_pass.dart';
import 'hangzhou_west_lake_one_pass.dart';
import 'journey_data.dart';
import 'journey_expansion_catalog.dart';
import 'summer_palace_journey.dart';
import 'xian_city_wall_one_pass.dart';

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
        JourneyDifficulty.easy => '短句 · 完整事件链 · 慢一点',
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
    DailyJourneyExperience experience,
  ) {
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
    simpleChinese: _joinChinese(entries.map((entry) => entry.simpleChinese)),
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
  if (experience.id == chengduKuanzhaiJourneyId) {
    final level = switch (difficulty) {
      JourneyDifficulty.easy => 1,
      JourneyDifficulty.standard => 5,
      JourneyDifficulty.challenge => 10,
    };
    return chengduKuanzhaiOnePassLevelContent(level);
  }
  if (experience.id == guangzhouChenClanJourneyId) {
    final level = switch (difficulty) {
      JourneyDifficulty.easy => 1,
      JourneyDifficulty.standard => 5,
      JourneyDifficulty.challenge => 10,
    };
    return guangzhouChenClanOnePassLevelContent(level);
  }
  if (experience.id == 'suzhou-humble-administrators-garden') {
    final level = switch (difficulty) {
      JourneyDifficulty.easy => 1,
      JourneyDifficulty.standard => 5,
      JourneyDifficulty.challenge => 10,
    };
    return suzhouGardenCanonicalLevelContent(level);
  }
  if (experience.id == hangzhouWestLakeJourneyId) {
    final level = switch (difficulty) {
      JourneyDifficulty.easy => 1,
      JourneyDifficulty.standard => 5,
      JourneyDifficulty.challenge => 10,
    };
    return hangzhouWestLakeOnePassLevelContent(level);
  }
  if (experience.id == xianCityWallJourneyId) {
    final level = switch (difficulty) {
      JourneyDifficulty.easy => 1,
      JourneyDifficulty.standard => 5,
      JourneyDifficulty.challenge => 10,
    };
    return xianCityWallOnePassLevelContent(level);
  }
  if (experience.id != 'beijing-summer-palace') {
    return JourneyLevelContent.fromExperience(experience);
  }

  final limited = (switch (difficulty) {
    JourneyDifficulty.easy => summerPalaceEasyLevel,
    JourneyDifficulty.standard => JourneyLevelContent.fromExperience(experience),
    JourneyDifficulty.challenge => summerPalaceChallengeLevel,
  }).withReadingLimit();
  return _withVocabularyInContext(
    _normalizeSummerPalaceEventOrder(limited),
  );
}

JourneyLevelContent _normalizeSummerPalaceEventOrder(
  JourneyLevelContent content,
) {
  String normalizeChinese(String value) => value
      .replaceFirst(
        '校展截稿前一天，十七岁的许澄',
        '十七岁的许澄在校展截稿前一天',
      )
      .replaceFirst(
        '校展截稿前夕，十七岁的学生摄影者许澄',
        '十七岁的学生摄影者许澄在校展截稿前夕',
      )
      .replaceFirst(
        '她放下原来的构图，蹲身拾起照片，又退到桥侧，让近处斑驳的纸角、外婆扶栏的手和远处万寿山形成三层对景。快门落下后，她因此错失最佳光线；',
        '她放下原来的构图，蹲身拾起照片，因此错失最佳光线。她又退到桥侧，让近处斑驳的纸角、外婆扶栏的手和远处万寿山形成三层对景；',
      );

  String normalizePinyin(String value) => value
      .replaceFirst(
        'Xiàozhǎn jiégǎo qián yì tiān, shíqī suì de Xǔ Chéng',
        'Shíqī suì de Xǔ Chéng zài xiàozhǎn jiégǎo qián yì tiān',
      )
      .replaceFirst(
        'Xiàozhǎn jiégǎo qiánxī, shíqī suì de xuéshēng shèyǐngzhě Xǔ Chéng',
        'Shíqī suì de xuéshēng shèyǐngzhě Xǔ Chéng zài xiàozhǎn jiégǎo qiánxī',
      )
      .replaceFirst(
        'Tā fàngxià yuánlái de gòutú, dūnshēn shíqǐ zhàopiàn, ràng bānbó zhǐjiǎo, wàipó fúlán de shǒu hé yuǎnchù Wànshòu Shān xíngchéng sān céng duìjǐng. Guāngxiàn yǐjīng piānyí, tā yīncǐ cuòshī zuìjiā guāngxiàn,',
        'Tā fàngxià yuánlái de gòutú, dūnshēn shíqǐ zhàopiàn, yīncǐ cuòshī zuìjiā guāngxiàn. Tā ràng bānbó zhǐjiǎo, wàipó fúlán de shǒu hé yuǎnchù Wànshòu Shān xíngchéng sān céng duìjǐng; guāngxiàn yǐjīng piānyí,',
      );

  String normalizeVietnamese(String value) => value
      .replaceFirst(
        'Một ngày trước hạn triển lãm trường, Hứa Trừng mười bảy tuổi',
        'Hứa Trừng mười bảy tuổi, vào một ngày trước hạn triển lãm trường,',
      )
      .replaceFirst(
        'Trước hạn triển lãm, Hứa Trừng, một nữ sinh nhiếp ảnh mười bảy tuổi',
        'Hứa Trừng, một nữ sinh nhiếp ảnh mười bảy tuổi, trước hạn triển lãm,',
      )
      .replaceFirst(
        'Cô bỏ bố cục cũ, nhặt ảnh trước rồi đặt góc giấy sờn, bàn tay bà và núi Vạn Thọ thành ba lớp. Cô vì thế lỡ ánh sáng đẹp nhất;',
        'Cô bỏ bố cục cũ và nhặt ảnh trước, vì thế lỡ ánh sáng đẹp nhất. Sau đó cô đặt góc giấy sờn, bàn tay bà và núi Vạn Thọ thành ba lớp;',
      );

  String normalizeEnglish(String value) => value
      .replaceFirst(
        'A day before her school exhibition deadline, seventeen-year-old Xu Cheng',
        'Seventeen-year-old Xu Cheng, a day before her school exhibition deadline,',
      )
      .replaceFirst(
        'Before the exhibition deadline, seventeen-year-old student photographer Xu Cheng',
        'Seventeen-year-old student photographer Xu Cheng, before the exhibition deadline,',
      )
      .replaceFirst(
        'She abandons the old composition, recovers the photograph, and frames worn paper, her grandmother’s hand, and Longevity Hill in three layers. She therefore loses the best light and the postcard view disappears.',
        'She abandons the old composition and recovers the photograph, therefore losing the best light. She then frames worn paper, her grandmother’s hand, and Longevity Hill in three layers as the postcard view disappears.',
      );

  return JourneyLevelContent(
    storyParagraphs: content.storyParagraphs
        .map(normalizeChinese)
        .toList(growable: false),
    storyAnnotations: content.storyAnnotations
        .map(
          (entry) => ReadingAnnotation(
            pinyin: normalizePinyin(entry.pinyin),
            vietnamese: normalizeVietnamese(entry.vietnamese),
            english: normalizeEnglish(entry.english),
          ),
        )
        .toList(growable: false),
    words: content.words,
    discoveries: content.discoveries,
    wonderQuestion: content.wonderQuestion,
    expressQuestion: content.expressQuestion,
  );
}

JourneyLevelContent _withVocabularyInContext(JourneyLevelContent content) {
  final visibleContext = <String>[
    ...content.storyParagraphs,
    ...content.discoveries.map((entry) => entry.text),
  ].join();
  return JourneyLevelContent(
    storyParagraphs: content.storyParagraphs,
    storyAnnotations: content.storyAnnotations,
    words: content.words
        .where((entry) => visibleContext.contains(entry.word))
        .toList(growable: false),
    discoveries: content.discoveries,
    wonderQuestion: content.wonderQuestion,
    expressQuestion: content.expressQuestion,
  );
}

List<WordEntry> _selectSummerPalaceWords(List<String> selectedWords) {
  return summerPalaceWords
      .where((entry) => selectedWords.contains(entry.word))
      .toList(growable: false);
}

final summerPalaceEasyLevel = JourneyLevelContent(
  storyParagraphs: <String>[
    '十七岁的学生摄影者许澄要为校展拍一张颐和园作品，证明自己不需要外婆周岚指导。周岚曾保护长廊彩画，她要许澄看修复痕迹，许澄却只想拍无瑕画面。',
    '十七孔桥旁，最佳光线出现时，旧照片也被风吹落。许澄必须在追光和捡照片之间选择。她放弃原构图，先捡回照片，因此错失光线。她重新拍下斑驳旧照、外婆的手和远处万寿山，作品名为《留下痕迹的风景》。周岚不再替她调整构图，把旧照片交给她保存。许澄不再只想证明独立，也懂得修复要留下关系、时间和痕迹。',
  ],
  storyAnnotations: <ReadingAnnotation>[
    const ReadingAnnotation(
      pinyin:
          'Shíqī suì de xuéshēng shèyǐngzhě Xǔ Chéng yào wèi xiàozhǎn pāi yì zhāng Yíhéyuán zuòpǐn, zhèngmíng zìjǐ bù xūyào wàipó Zhōu Lán zhǐdǎo. Zhōu Lán céng bǎohù Chángláng cǎihuà, tā yào Xǔ Chéng kàn xiūfù hénjì, Xǔ Chéng què zhǐ xiǎng pāi wúxiá huàmiàn.',
      vietnamese:
          'Hứa Trừng, một nữ sinh nhiếp ảnh mười bảy tuổi, phải chụp tác phẩm Di Hòa Viên cho triển lãm trường để chứng minh không cần bà ngoại Chu Lam hướng dẫn. Chu Lam từng bảo tồn tranh màu Trường Lang; bà muốn cô nhìn dấu vết phục hồi, còn cô chỉ muốn khung hình không tì vết.',
      english:
          'Seventeen-year-old student photographer Xu Cheng must make a Summer Palace work for the school exhibition to prove she needs no guidance from Zhou Lan. Zhou Lan once conserved Long Corridor paintings and asks her to see restoration traces, while Xu Cheng wants a flawless image.',
    ),
    const ReadingAnnotation(
      pinyin:
          'Shíqīkǒng Qiáo páng, zuìjiā guāngxiàn chūxiàn shí, jiù zhàopiàn yě bèi fēng chuīluò. Xǔ Chéng bìxū zài zhuīguāng hé jiǎn zhàopiàn zhījiān xuǎnzé. Tā fàngqì yuán gòutú, xiān jiǎn huí zhàopiàn, yīncǐ cuòshī guāngxiàn. Tā chóngxīn pāi xià bānbó jiùzhào, wàipó de shǒu hé yuǎnchù Wànshòu Shān, zuòpǐn míng wéi Liúxià Hénjì de Fēngjǐng. Zhōu Lán bù zài tì tā tiáozhěng gòutú, bǎ jiù zhàopiàn jiāogěi tā bǎocún. Xǔ Chéng bù zài zhǐ xiǎng zhèngmíng dúlì, yě dǒngde xiūfù yào liúxià guānxì, shíjiān hé hénjì.',
      vietnamese:
          'Bên cầu Thập Thất Khổng, ánh sáng đẹp nhất xuất hiện đúng lúc bức ảnh cũ bị gió thổi rơi. Hứa Trừng phải chọn giữa đuổi theo ánh sáng và nhặt ảnh. Cô bỏ bố cục ban đầu, nhặt ảnh trước nên lỡ ánh sáng. Cô chụp lại ảnh cũ sờn, bàn tay bà và núi Vạn Thọ phía xa, đặt tên tác phẩm “Phong cảnh lưu lại dấu vết”. Chu Lam không còn chỉnh bố cục thay cô và giao ảnh cũ cho cô gìn giữ. Hứa Trừng không còn chỉ muốn chứng minh độc lập; cô hiểu phục hồi phải giữ lại quan hệ, thời gian và dấu vết.',
      english:
          'By the Seventeen-Arch Bridge, the best light arrives as the old photograph falls. Xu Cheng must choose between chasing light and retrieving it. She abandons the original composition and retrieves the photograph, losing the light. She reframes the worn image, her grandmother’s hand, and distant Longevity Hill, titling the work “A Landscape That Keeps Its Traces.” Zhou Lan stops adjusting the composition and entrusts the photograph to her. Xu Cheng no longer seeks only independence and understands that restoration keeps relationship, time, and traces.',
    ),
  ],
  words: _selectSummerPalaceWords(const <String>[
    '颐和园',
    '万寿山',
    '长廊',
    '修复',
    '十七孔桥',
  ]),
  discoveries: summerPalaceDiscoveries,
  wonderQuestion: '许澄为什么错过光线，却得到外婆的信任？',
  expressQuestion: '请按顺序写出旧照片掉落、许澄选择、错失光线和外婆托付。',
);

const summerPalaceChallengeLevel = JourneyLevelContent(
  storyParagraphs: <String>[
    '校展截稿前夕，十七岁的学生摄影者许澄执意寻找一幅“无瑕”的皇家园林图景，以此证明自己的摄影不再依赖外婆周岚。周岚曾参与长廊彩画保护，她借廊柱的遮蔽与开敞说明：构图和修复一样，都必须决定何者显现、何者退后，却不能伪造未曾受损的过去。许澄仍坚持把褪色、裂纹和补绘排除在镜头外，两人的价值判断因此直接冲突。',
    '十七孔桥前，理想光线出现的同时，记录修复前长廊、年轻周岚及其已故老师的旧照片被风吹落。许澄必须在标准风景与关系记忆之间作出不可兼得的选择。她放弃追光，先捡回照片，再以斑驳旧照、外婆扶栏的手和桥孔后的万寿山形成三层对景。这个行动使她错失最佳光线，却换来《留下痕迹的风景》：周岚不再替她调整构图，并把旧照片交给她保存。许澄的目标从证明独立转为承担保存关系与时间的责任，也理解修复不是抹去痕迹，而是让损失、选择和守护继续可读。',
  ],
  storyAnnotations: <ReadingAnnotation>[
    ReadingAnnotation(
      pinyin:
          'Xiàozhǎn jiégǎo qiánxī, shíqī suì de xuéshēng shèyǐngzhě Xǔ Chéng zhíyì xúnzhǎo yì fú wúxiá de huángjiā yuánlín tújǐng, yǐcǐ zhèngmíng zìjǐ de shèyǐng bù zài yīlài wàipó Zhōu Lán. Zhōu Lán céng cānyù Chángláng cǎihuà bǎohù, tā jiè lángzhù de zhēbì yǔ kāichǎng shuōmíng: gòutú hé xiūfù yíyàng, dōu bìxū juédìng hézhě xiǎnxiàn, hézhě tuìhòu, què bùnéng wěizào wèicéng shòusǔn de guòqù. Xǔ Chéng réng jiānchí bǎ tuìsè, lièwén hé bǔhuì páichú zài jìngtóu wài, liǎng rén de jiàzhí pànduàn yīncǐ zhíjiē chōngtū.',
      vietnamese:
          'Trước hạn triển lãm, Hứa Trừng, một nữ sinh nhiếp ảnh mười bảy tuổi, cố tìm hình ảnh vườn hoàng gia “không tì vết” để chứng minh không còn phụ thuộc vào bà ngoại Chu Lam. Chu Lam từng bảo tồn tranh màu Trường Lang. Bà dùng nhịp che và mở của cột để giải thích rằng bố cục và phục hồi đều phải chọn điều gì hiện ra, điều gì lùi lại, nhưng không được giả tạo một quá khứ chưa từng hư hại. Hứa Trừng vẫn loại màu phai, vết nứt và phần vẽ bổ sung khỏi ống kính, khiến hai phán đoán giá trị trực tiếp xung đột.',
      english:
          'Before the exhibition deadline, seventeen-year-old student photographer Xu Cheng insists on a flawless imperial-garden image to prove she no longer depends on Zhou Lan. Zhou Lan once conserved Long Corridor paintings and uses the columns’ concealment and opening to explain that composition and restoration decide what appears and recedes without fabricating an undamaged past. Xu Cheng still excludes fading, cracks, and retouching, placing their values in direct conflict.',
    ),
    ReadingAnnotation(
      pinyin:
          'Shíqīkǒng Qiáo qián, lǐxiǎng guāngxiàn chūxiàn de tóngshí, jìlù xiūfù qián Chángláng, niánqīng Zhōu Lán jí qí yǐgù lǎoshī de jiù zhàopiàn bèi fēng chuīluò. Xǔ Chéng bìxū zài biāozhǔn fēngjǐng yǔ guānxì jìyì zhījiān zuòchū bùkě jiāndé de xuǎnzé. Tā fàngqì zhuīguāng, xiān jiǎn huí zhàopiàn, zài yǐ bānbó jiùzhào, wàipó fúlán de shǒu hé qiáokǒng hòu de Wànshòu Shān xíngchéng sān céng duìjǐng. Zhège xíngdòng shǐ tā cuòshī zuìjiā guāngxiàn, què huànlái Liúxià Hénjì de Fēngjǐng: Zhōu Lán bù zài tì tā tiáozhěng gòutú, bìng bǎ jiù zhàopiàn jiāogěi tā bǎocún. Xǔ Chéng de mùbiāo cóng zhèngmíng dúlì zhuǎn wéi chéngdān bǎocún guānxì yǔ shíjiān de zérèn, yě lǐjiě xiūfù bú shì mǒqù hénjì, ér shì ràng sǔnshī, xuǎnzé hé shǒuhù jìxù kě dú.',
      vietnamese:
          'Trước cầu Thập Thất Khổng, đúng lúc ánh sáng lý tưởng xuất hiện, bức ảnh cũ ghi Trường Lang trước phục hồi, Chu Lam trẻ tuổi và người thầy đã mất bị gió cuốn. Hứa Trừng phải chọn giữa phong cảnh chuẩn và ký ức quan hệ. Cô bỏ việc đuổi theo ánh sáng, nhặt ảnh trước rồi tạo ba lớp đối cảnh bằng ảnh cũ sờn, bàn tay bà trên lan can và núi Vạn Thọ sau vòm cầu. Hành động khiến cô lỡ ánh sáng đẹp nhất nhưng tạo ra “Phong cảnh lưu lại dấu vết”: Chu Lam không còn chỉnh bố cục và giao bức ảnh cho cô. Mục tiêu của Hứa Trừng chuyển từ chứng minh độc lập sang trách nhiệm gìn giữ quan hệ và thời gian; cô hiểu phục hồi không xóa dấu vết mà giữ mất mát, lựa chọn và sự bảo vệ ở trạng thái có thể đọc được.',
      english:
          'At the Seventeen-Arch Bridge, ideal light arrives as the old photograph of the unrestored corridor, young Zhou Lan, and her late teacher falls. Xu Cheng must choose between a standard view and relational memory. She abandons the light, retrieves the photograph, and composes three layers: worn image, Zhou Lan’s hand, and Longevity Hill beyond the arches. The action costs the best light but creates “A Landscape That Keeps Its Traces.” Zhou Lan stops adjusting the composition and entrusts the photograph to her. Xu Cheng’s goal changes from proving independence to carrying responsibility for relationship and time, and she understands restoration as keeping loss, choice, and care readable.',
    ),
  ],
  words: summerPalaceWords,
  discoveries: summerPalaceDiscoveries,
  wonderQuestion: '许澄的摄影选择如何把园林构图原则转化为对历史、关系与责任的判断？',
  expressQuestion: '请分析“无瑕”与“可阅读的修复痕迹”代表的两种遗产态度。',
);
