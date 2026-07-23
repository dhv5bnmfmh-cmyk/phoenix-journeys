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

  factory JourneyLevelContent.fromExperience(DailyJourneyExperience experience) {
    return JourneyLevelContent(
      storyParagraphs: experience.content.storyParagraphs,
      storyAnnotations: experience.storyAnnotations,
      words: experience.words,
      discoveries: experience.discoveries,
      wonderQuestion: experience.wonderQuestion,
      expressQuestion: experience.expressQuestion,
    );
  }

  final List<String> storyParagraphs;
  final List<ReadingAnnotation> storyAnnotations;
  final List<WordEntry> words;
  final List<DiscoveryEntry> discoveries;
  final String wonderQuestion;
  final String expressQuestion;
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

  return switch (difficulty) {
    JourneyDifficulty.easy => summerPalaceEasyLevel,
    JourneyDifficulty.standard => JourneyLevelContent.fromExperience(experience),
    JourneyDifficulty.challenge => summerPalaceChallengeLevel,
  };
}

List<WordEntry> _selectSummerPalaceWords(List<String> selectedWords) {
  return summerPalaceWords
      .where((entry) => selectedWords.contains(entry.word))
      .toList(growable: false);
}

final summerPalaceEasyLevel = JourneyLevelContent(
  storyParagraphs: const <String>[
    '清晨，你来到颐和园。昆明湖很安静，万寿山倒映在水里。',
    '你沿着长廊散步。长廊旁边有树、花和古老的建筑。',
    '颐和园以前是皇家园林。它受过破坏，也经过重建和修复。',
    '十七孔桥连接湖岸和小岛。湖、山、桥和建筑组成一幅美丽的画。',
  ],
  storyAnnotations: const <ReadingAnnotation>[
    ReadingAnnotation(
      pinyin:
          'Qīngchén, nǐ láidào Yíhéyuán. Kūnmíng Hú hěn ānjìng, Wànshòu Shān dàoyìng zài shuǐ lǐ.',
      vietnamese:
          'Sáng sớm, bạn đến Di Hòa Viên. Hồ Côn Minh rất yên tĩnh và núi Vạn Thọ phản chiếu trên mặt nước.',
      english:
          'In the early morning, you arrive at the Summer Palace. Kunming Lake is quiet, with Longevity Hill reflected in the water.',
    ),
    ReadingAnnotation(
      pinyin:
          'Nǐ yánzhe Chángláng sànbù. Chángláng pángbiān yǒu shù, huā hé gǔlǎo de jiànzhù.',
      vietnamese:
          'Bạn đi dạo dọc Trường Lang. Bên cạnh hành lang có cây, hoa và những công trình cổ.',
      english:
          'You walk along the Long Corridor. Trees, flowers, and old buildings stand beside it.',
    ),
    ReadingAnnotation(
      pinyin:
          'Yíhéyuán yǐqián shì huángjiā yuánlín. Tā shòuguò pòhuài, yě jīngguò chóngjiàn hé xiūfù.',
      vietnamese:
          'Di Hòa Viên trước đây là vườn hoàng gia. Nơi này từng bị phá hủy và cũng đã được xây dựng, tu sửa lại.',
      english:
          'The Summer Palace was once an imperial garden. It was damaged and later rebuilt and restored.',
    ),
    ReadingAnnotation(
      pinyin:
          'Shíqīkǒng Qiáo liánjiē hú àn hé xiǎodǎo. Hú, shān, qiáo hé jiànzhù zǔchéng yì fú měilì de huà.',
      vietnamese:
          'Cầu Thập Thất Khổng nối bờ hồ với hòn đảo nhỏ. Hồ, núi, cầu và kiến trúc tạo thành một bức tranh đẹp.',
      english:
          'The Seventeen-Arch Bridge connects the shore and an island. Lake, hill, bridge, and buildings form a beautiful picture.',
    ),
  ],
  words: _selectSummerPalaceWords(const <String>[
    '颐和园',
    '昆明湖',
    '万寿山',
    '长廊',
    '修复',
    '十七孔桥',
  ]),
  discoveries: const <DiscoveryEntry>[
    DiscoveryEntry(
      text: '颐和园在北京，昆明湖和万寿山是这里最重要的景观。',
      pinyin:
          'Yíhéyuán zài Běijīng, Kūnmíng Hú hé Wànshòu Shān shì zhèlǐ zuì zhòngyào de jǐngguān.',
      simpleChinese: '颐和园在北京，主要景色是湖和山。',
      vietnamese:
          'Di Hòa Viên nằm ở Bắc Kinh; hồ Côn Minh và núi Vạn Thọ là hai cảnh quan quan trọng nhất.',
      english:
          'The Summer Palace is in Beijing, and Kunming Lake and Longevity Hill are its main landscapes.',
    ),
    DiscoveryEntry(
      text: '颐和园大约四分之三的面积是水，所以昆明湖在风景中非常重要。',
      pinyin:
          'Yíhéyuán dàyuē sì fēn zhī sān de miànjī shì shuǐ, suǒyǐ Kūnmíng Hú zài fēngjǐng zhōng fēicháng zhòngyào.',
      simpleChinese: '园里大部分面积是水。',
      vietnamese:
          'Khoảng ba phần tư diện tích Di Hòa Viên là mặt nước, vì vậy hồ Côn Minh rất quan trọng trong cảnh quan.',
      english:
          'About three quarters of the Summer Palace is water, so Kunming Lake is central to the scenery.',
    ),
    DiscoveryEntry(
      text: '十七孔桥有十七个桥孔，是颐和园最有代表性的桥之一。',
      pinyin:
          'Shíqīkǒng Qiáo yǒu shíqī gè qiáokǒng, shì Yíhéyuán zuì yǒu dàibiǎoxìng de qiáo zhī yī.',
      simpleChinese: '这座桥有十七个桥孔。',
      vietnamese:
          'Cầu Thập Thất Khổng có mười bảy vòm và là một trong những cây cầu tiêu biểu nhất của Di Hòa Viên.',
      english:
          'The Seventeen-Arch Bridge has seventeen arches and is one of the garden’s best-known bridges.',
    ),
  ],
  wonderQuestion: '颐和园里有湖、山、长廊和桥。你最想先去哪里？为什么？',
  expressQuestion: '请用一到两句话介绍颐和园里你最喜欢的景色。',
);

final summerPalaceChallengeLevel = JourneyLevelContent(
  storyParagraphs: const <String>[
    '清晨的薄雾尚未散尽，昆明湖已经把万寿山的轮廓收进水面。远处亭台若隐若现，使人工营造的园林看起来像自然生成的山水。',
    '长廊并非单纯连接景点的通道。它用连续的彩画、开合变化的视野和行走节奏，把湖岸上的不同空间组织成一场缓慢展开的观看。',
    '从清漪园到颐和园，这座皇家园林经历兴建、破坏与重建。历史留下的裂痕并未完全消失，反而让修复本身也成为园林记忆的一部分。',
    '站在十七孔桥前回望，所谓借景并不是复制自然，而是选择视线、距离和比例，让湖光山色与建筑彼此成全。',
  ],
  storyAnnotations: const <ReadingAnnotation>[
    ReadingAnnotation(
      pinyin:
          'Qīngchén de báowù shàngwèi sànjìn, Kūnmíng Hú yǐjīng bǎ Wànshòu Shān de lúnkuò shōu jìn shuǐmiàn. Yuǎnchù tíngtái ruòyǐn-ruòxiàn, shǐ réngōng yíngzào de yuánlín kàn qǐlái xiàng zìrán shēngchéng de shānshuǐ.',
      vietnamese:
          'Sương sớm chưa tan hết, mặt hồ Côn Minh đã thu đường nét núi Vạn Thọ vào trong nước. Đình đài xa xa ẩn hiện khiến khu vườn nhân tạo trông như cảnh sơn thủy tự nhiên.',
      english:
          'Before the morning mist has cleared, Kunming Lake gathers the outline of Longevity Hill into its surface. Distant pavilions make the designed garden appear naturally formed.',
    ),
    ReadingAnnotation(
      pinyin:
          'Chángláng bìngfēi dānchún liánjiē jǐngdiǎn de tōngdào. Tā yòng liánxù de cǎihuà, kāihé biànhuà de shìyě hé xíngzǒu jiézòu, bǎ hú àn shàng de bùtóng kōngjiān zǔzhī chéng yì chǎng huǎnmàn zhǎnkāi de guānkàn.',
      vietnamese:
          'Trường Lang không chỉ là lối nối các điểm tham quan. Tranh màu liên tục, tầm nhìn đóng mở và nhịp bước chân tổ chức các không gian ven hồ thành một quá trình ngắm cảnh từ từ mở ra.',
      english:
          'The Long Corridor is more than a passage. Painted scenes, shifting views, and walking rhythm organize the lakeside into a slowly unfolding act of seeing.',
    ),
    ReadingAnnotation(
      pinyin:
          'Cóng Qīngyīyuán dào Yíhéyuán, zhè zuò huángjiā yuánlín jīnglì xīngjiàn, pòhuài yǔ chóngjiàn. Lìshǐ liúxià de lièhén bìngwèi wánquán xiāoshī, fǎn'ér ràng xiūfù běnshēn yě chéngwéi yuánlín jìyì de yí bùfen.',
      vietnamese:
          'Từ Thanh Y Viên đến Di Hòa Viên, khu vườn hoàng gia này trải qua xây dựng, phá hủy và tái thiết. Những vết nứt lịch sử không biến mất hoàn toàn mà khiến chính việc phục hồi trở thành một phần ký ức của khu vườn.',
      english:
          'From the Garden of Clear Ripples to the Summer Palace, the site experienced construction, destruction, and rebuilding. Restoration itself became part of its memory.',
    ),
    ReadingAnnotation(
      pinyin:
          'Zhàn zài Shíqīkǒng Qiáo qián huíwàng, suǒwèi jièjǐng bìng bú shì fùzhì zìrán, ér shì xuǎnzé shìxiàn, jùlí hé bǐlì, ràng húguāng-shānsè yǔ jiànzhù bǐcǐ chéngquán.',
      vietnamese:
          'Đứng trước cầu Thập Thất Khổng nhìn lại, “mượn cảnh” không phải sao chép thiên nhiên mà là lựa chọn đường nhìn, khoảng cách và tỷ lệ để núi hồ và kiến trúc nâng đỡ lẫn nhau.',
      english:
          'Looking back from the Seventeen-Arch Bridge, borrowed scenery is not a copy of nature but a selection of sightline, distance, and proportion so landscape and architecture complete one another.',
    ),
  ],
  words: summerPalaceWords,
  discoveries: const <DiscoveryEntry>[
    DiscoveryEntry(
      text: '颐和园的价值不仅在于单体建筑，而在于它把中国园林关于山水秩序的想象集中呈现在一个大型皇家园林中。',
      pinyin:
          'Yíhéyuán de jiàzhí bùjǐn zàiyú dāntǐ jiànzhù, ér zàiyú tā bǎ Zhōngguó yuánlín guānyú shānshuǐ zhìxù de xiǎngxiàng jízhōng chéngxiàn zài yí gè dàxíng huángjiā yuánlín zhōng.',
      simpleChinese: '它的重要性来自山水和建筑组成的整体。',
      vietnamese:
          'Giá trị của Di Hòa Viên không chỉ nằm ở từng công trình mà còn ở cách nơi đây tập trung quan niệm trật tự núi nước của vườn Trung Hoa trong một khu vườn hoàng gia lớn.',
      english:
          'Its significance lies not only in individual buildings, but in the complete landscape order presented across a large imperial garden.',
    ),
    DiscoveryEntry(
      text: '大面积水面既扩大了视觉距离，也通过倒影和光线变化，使同一组建筑在不同时间呈现不同气氛。',
      pinyin:
          'Dà miànjī shuǐmiàn jì kuòdà le shìjué jùlí, yě tōngguò dàoyǐng hé guāngxiàn biànhuà, shǐ tóng yì zǔ jiànzhù zài bùtóng shíjiān chéngxiàn bùtóng qìfēn.',
      simpleChinese: '湖面让景色看起来更远，也会改变建筑的倒影和气氛。',
      vietnamese:
          'Mặt nước rộng mở rộng khoảng cách thị giác; phản chiếu và ánh sáng thay đổi cũng khiến cùng một nhóm kiến trúc mang bầu không khí khác nhau theo thời gian.',
      english:
          'The broad water surface extends visual distance, while reflections and changing light give the same buildings different moods throughout the day.',
    ),
    DiscoveryEntry(
      text: '长廊让移动本身成为观景方法：人在遮蔽与开敞之间前进，画面也随脚步不断重新构图。',
      pinyin:
          'Chángláng ràng yídòng běnshēn chéngwéi guānjǐng fāngfǎ: rén zài zhēbì yǔ kāichǎng zhījiān qiánjìn, huàmiàn yě suí jiǎobù bùduàn chóngxīn gòutú.',
      simpleChinese: '人在长廊里边走边看，景色会不断变化。',
      vietnamese:
          'Trường Lang biến việc di chuyển thành một cách ngắm cảnh: khi người đi qua những khoảng kín và mở, khung cảnh liên tục được bố cục lại theo bước chân.',
      english:
          'The corridor turns movement into a viewing method: as visitors pass between enclosure and openness, the scene is continually recomposed.',
    ),
    DiscoveryEntry(
      text: '十七孔桥在功能上连接湖岸与岛屿，在构图上又成为水面上的水平线，使远山、湖面和近处建筑形成层次。',
      pinyin:
          'Shíqīkǒng Qiáo zài gōngnéng shàng liánjiē hú àn yǔ dǎoyǔ, zài gòutú shàng yòu chéngwéi shuǐmiàn shàng de shuǐpíngxiàn, shǐ yuǎnshān, húmiàn hé jìnchù jiànzhù xíngchéng céngcì.',
      simpleChinese: '桥连接两地，也让远山、湖和建筑看起来更有层次。',
      vietnamese:
          'Cầu Thập Thất Khổng vừa nối bờ hồ với đảo, vừa tạo một đường ngang trên mặt nước để núi xa, hồ và kiến trúc gần tạo thành nhiều lớp.',
      english:
          'The bridge links shore and island while forming a horizontal line that layers distant hills, water, and nearby architecture.',
    ),
  ],
  wonderQuestion: '颐和园通过借景、倒影和行走视线组织风景。你认为这种设计是在模仿自然，还是在重新解释自然？为什么？',
  expressQuestion: '请用三到五句话分析长廊或十七孔桥怎样同时承担实用功能和景观构图功能。',
);
