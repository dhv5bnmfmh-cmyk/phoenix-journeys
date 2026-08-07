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

class RemediatedSemanticEvent {
  const RemediatedSemanticEvent({
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

  final String id;
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

class RemediatedWordTrace {
  const RemediatedWordTrace({
    required this.word,
    required this.eventId,
    required this.usage,
    required this.sourceText,
  });

  final String word;
  final String eventId;
  final String usage;
  final String sourceText;
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
    required this.events,
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
  final List<RemediatedSemanticEvent> events;
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

List<JourneyLevelContent> _buildLevels({
  required List<RemediatedSemanticEvent> events,
  required int splitAfter,
}) {
  return List<JourneyLevelContent>.generate(10, (index) {
    final level = index + 1;
    final chinese = <String>[];
    final pinyin = <String>[];
    final vietnamese = <String>[];
    final english = <String>[];

    final paragraphs = <String>[];
    final annotations = <ReadingAnnotation>[];

    void flush() {
      if (chinese.isEmpty) return;
      paragraphs.add(chinese.join());
      annotations.add(
        ReadingAnnotation(
          pinyin: pinyin.join(' '),
          vietnamese: vietnamese.join(' '),
          english: english.join(' '),
        ),
      );
      chinese.clear();
      pinyin.clear();
      vietnamese.clear();
      english.clear();
    }

    for (var eventIndex = 0; eventIndex < events.length; eventIndex++) {
      final event = events[eventIndex];
      chinese.add(event.coreChinese);
      pinyin.add(event.corePinyin);
      vietnamese.add(event.coreVietnamese);
      english.add(event.coreEnglish);
      if (level >= event.detailFromLevel && event.detailChinese.isNotEmpty) {
        chinese.add(event.detailChinese);
        pinyin.add(event.detailPinyin);
        vietnamese.add(event.detailVietnamese);
        english.add(event.detailEnglish);
      }
      if (level >= 3 && eventIndex + 1 == splitAfter) flush();
    }
    flush();

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
        chinese: '故事原句：$storySentence',
        pinyin: 'Gùshì yuánjù: $storyPinyin',
        vietnamese: 'Câu gốc trong truyện: $storyVietnamese',
        english: 'Story source: $storyEnglish',
      ),
      WordExample(
        chinese: '回看故事原句：$storySentence',
        pinyin: 'Huíkàn gùshì yuánjù: $storyPinyin',
        vietnamese: 'Xem lại câu gốc trong truyện: $storyVietnamese',
        english: 'Revisit the story sentence: $storyEnglish',
      ),
    ],
  );
}

const _forbiddenCityEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(
    id: 'FC-E1-warning',
    coreChinese: '纪衡在午门内收到雷雨预警。',
    corePinyin: 'Jì Héng zài Wǔmén nèi shōudào léiyǔ yùjǐng.',
    coreVietnamese: 'Kỷ Hành nhận cảnh báo giông mưa bên trong Ngọ Môn.',
    coreEnglish: 'Ji Heng receives a thunderstorm warning inside the Meridian Gate.',
    detailChinese: '天气系统预计半小时内经过，维护团队把重点放在外朝高台的排水风险。',
    detailPinyin: 'Tiānqì xìtǒng yùjì bàn xiǎoshí nèi jīngguò, wéihù tuánduì bǎ zhòngdiǎn fàng zài wàicháo gāotái de páishuǐ fēngxiǎn.',
    detailVietnamese: 'Dự báo cho thấy giông sẽ tới trong vòng nửa giờ, nên đội bảo trì tập trung vào nguy cơ thoát nước ở các nền cao của Ngoại triều.',
    detailEnglish: 'The storm is expected within half an hour, so the conservation team focuses on drainage risk around the elevated Outer Court terraces.',
    detailFromLevel: 2,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E2-goal',
    coreChinese: '他要在闭馆前确认太和殿丹陛排水异常。',
    corePinyin: 'Tā yào zài bìguǎn qián quèrèn Tàihé Diàn dānbì páishuǐ yìcháng.',
    coreVietnamese: 'Cậu phải xác nhận bất thường thoát nước ở nền đá Điện Thái Hòa trước giờ đóng cửa.',
    coreEnglish: 'He must confirm a drainage anomaly on the Hall of Supreme Harmony terrace before closing.',
    detailChinese: '太和殿位于外朝核心，明清时期重要国家仪式在这里举行，三层汉白玉台基把殿宇抬到中轴最高等级。',
    detailPinyin: 'Tàihé Diàn wèiyú wàicháo héxīn, Míng Qīng shíqī zhòngyào guójiā yíshì zài zhèlǐ jǔxíng, sān céng Hànbáiyù táijī bǎ diànyǔ tái dào zhōngzhóu zuì gāo děngjí.',
    detailVietnamese: 'Điện Thái Hòa nằm ở trung tâm Ngoại triều, nơi diễn ra các nghi lễ quốc gia quan trọng thời Minh Thanh; nền đá cẩm thạch trắng ba tầng nâng điện lên cấp bậc cao nhất trên trục giữa.',
    detailEnglish: 'The Hall of Supreme Harmony stands at the heart of the Outer Court, where major Ming and Qing state ceremonies were held; its three-tier white-marble terrace gives it the highest rank on the central axis.',
    detailFromLevel: 4,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E3-ritual-space',
    coreChinese: '中轴尽头，外朝礼仪空间层层抬高。',
    corePinyin: 'Zhōngzhóu jìntóu, wàicháo lǐyí kōngjiān céngcéng táigāo.',
    coreVietnamese: 'Trên trục giữa, không gian nghi lễ Ngoại triều được nâng dần qua từng lớp.',
    coreEnglish: 'Along the central axis, the ritual space of the Outer Court rises layer by layer.',
    detailChinese: '北面的内廷承担皇帝、皇后与后妃的宫寝生活；同一座宫城用空间区分典礼与日常。',
    detailPinyin: 'Běimiàn de nèitíng chéngdān huángdì, huánghòu yǔ hòufēi de gōngqǐn shēnghuó; tóng yí zuò gōngchéng yòng kōngjiān qūfēn diǎnlǐ yǔ rìcháng.',
    detailVietnamese: 'Phía bắc, Nội đình phục vụ đời sống cung cư của hoàng đế, hoàng hậu và các phi tần; cùng một cung thành dùng không gian để phân biệt nghi lễ với sinh hoạt hằng ngày.',
    detailEnglish: 'To the north, the Inner Court housed the emperor, empress, and consorts; the same palace city used space to distinguish ceremony from daily court life.',
    detailFromLevel: 4,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E4-drain',
    coreChinese: '一个石雕龙头不出水，石缝却返潮。',
    corePinyin: 'Yí gè shídiāo lóngtóu bù chūshuǐ, shífèng què fǎncháo.',
    coreVietnamese: 'Một đầu rồng đá không thoát nước, nhưng khe đá bên cạnh lại ẩm ngược.',
    coreEnglish: 'One carved stone dragon outlet is dry while the nearby stone joint is damp.',
    detailChinese: '台基周边的石雕龙头承担排水功能，大雨时多处出水形成“千龙吐水”的景象。',
    detailPinyin: 'Táijī zhōubiān de shídiāo lóngtóu chéngdān páishuǐ gōngnéng, dàyǔ shí duō chù chūshuǐ xíngchéng “qiān lóng tǔ shuǐ” de jǐngxiàng.',
    detailVietnamese: 'Các đầu rồng đá quanh nền điện có chức năng thoát nước; khi mưa lớn, nhiều miệng cùng xả tạo nên cảnh thường gọi là “nghìn rồng phun nước”.',
    detailEnglish: 'Carved dragon heads around the terrace serve as drains; in heavy rain, many discharge together in the scene known as “a thousand dragons spouting water.”',
    detailFromLevel: 2,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E5-history-layer',
    coreChinese: '异常点旁留着旧修缮灰缝。',
    corePinyin: 'Yìcháng diǎn páng liúzhe jiù xiūshàn huīfèng.',
    coreVietnamese: 'Bên điểm bất thường còn giữ một mạch vữa của lần tu bổ cũ.',
    coreEnglish: 'An older conservation mortar joint remains beside the anomaly.',
    detailChinese: '太和殿历经火灾、重建和持续修缮，旧灰缝与编号属于建筑的历史层，不能因“看起来旧”就随意剔除。',
    detailPinyin: 'Tàihé Diàn lìjīng huǒzāi, chóngjiàn hé chíxù xiūshàn, jiù huīfèng yǔ biānhào shǔyú jiànzhù de lìshǐ céng, bùnéng yīn “kàn qǐlái jiù” jiù suíyì tīchú.',
    detailVietnamese: 'Điện Thái Hòa đã trải qua hỏa hoạn, tái thiết và nhiều đợt tu bổ; mạch vữa cũ cùng mã số là một lớp lịch sử của công trình, không thể tùy tiện loại bỏ chỉ vì trông cũ.',
    detailEnglish: 'The hall has endured fires, rebuilding, and continuing conservation; old mortar joints and reference numbers belong to its historical layers and cannot be removed simply because they look old.',
    detailFromLevel: 5,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E6-choice',
    coreChinese: '他必须选择：立刻疏通，还是停手复核。',
    corePinyin: 'Tā bìxū xuǎnzé: lìkè shūtōng, háishì tíngshǒu fùhé.',
    coreVietnamese: 'Cậu phải chọn: thông ngay hay dừng tay để kiểm tra lại.',
    coreEnglish: 'He must choose: clear it immediately or stop and verify first.',
    detailChinese: '直接伸入工具也许能马上见水，却可能刮伤石材或破坏旧修缮层；等待复核则要承担暴雨逼近的压力。',
    detailPinyin: 'Zhíjiē shēnrù gōngjù yěxǔ néng mǎshàng jiàn shuǐ, què kěnéng guāshāng shícái huò pòhuài jiù xiūshàn céng; děngdài fùhé zé yào chéngdān bàoyǔ bījìn de yālì.',
    detailVietnamese: 'Đưa dụng cụ vào có thể khiến nước chảy ngay, nhưng cũng có thể làm xước đá hoặc phá lớp tu bổ cũ; chờ kiểm tra lại thì phải chịu áp lực của trận mưa đang tới.',
    detailEnglish: 'A tool might restore flow at once, but it could scratch stone or damage an older repair layer; waiting for verification means accepting the pressure of the approaching storm.',
    detailFromLevel: 6,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E7-action',
    coreChinese: '纪衡收起工具，记录位置、时间和编号。',
    corePinyin: 'Jì Héng shōuqǐ gōngjù, jìlù wèizhi, shíjiān hé biānhào.',
    coreVietnamese: 'Kỷ Hành cất dụng cụ và ghi lại vị trí, thời gian cùng mã số.',
    coreEnglish: 'Ji Heng puts away the tool and records the location, time, and reference number.',
    detailChinese: '他把异常点放回丹陛排水系统，而不是把一个不出水的龙头当成孤立故障。',
    detailPinyin: 'Tā bǎ yìcháng diǎn fàng huí dānbì páishuǐ xìtǒng, ér bú shì bǎ yí gè bù chūshuǐ de lóngtóu dàngchéng gūlì gùzhàng.',
    detailVietnamese: 'Cậu đặt điểm bất thường trở lại trong toàn bộ hệ thống thoát nước của nền điện, thay vì coi một đầu rồng không chảy là lỗi riêng lẻ.',
    detailEnglish: 'He reads the anomaly within the terrace drainage system rather than treating one dry outlet as an isolated fault.',
    detailFromLevel: 5,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E8-temporary',
    coreChinese: '他申请临时导排，请保护师共同判断。',
    corePinyin: 'Tā shēnqǐng línshí dǎopái, qǐng bǎohùshī gòngtóng pànduàn.',
    coreVietnamese: 'Cậu xin áp dụng dẫn thoát tạm thời và mời chuyên gia bảo tồn cùng đánh giá.',
    coreEnglish: 'He requests temporary drainage and asks a conservator to assess the situation with him.',
    detailChinese: '可逆的临时导排不触碰文物本体，目的是先控制水害，再把永久处理留给有依据的判断。',
    detailPinyin: 'Kěnì de línshí dǎopái bù chùpèng wénwù běntǐ, mùdì shì xiān kòngzhì shuǐhài, zài bǎ yǒngjiǔ chǔlǐ liú gěi yǒu yījù de pànduàn.',
    detailVietnamese: 'Biện pháp dẫn thoát tạm thời có thể hoàn nguyên không chạm vào bản thể di tích; mục tiêu là kiểm soát tác hại của nước trước, rồi để xử lý lâu dài dựa trên bằng chứng.',
    detailEnglish: 'The reversible temporary drainage avoids touching the historic fabric, controlling water risk first while leaving permanent treatment to an evidence-based decision.',
    detailFromLevel: 7,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E9-consequence',
    coreChinese: '因此他错过原定汇报。',
    corePinyin: 'Yīncǐ tā cuòguò yuándìng huìbào.',
    coreVietnamese: 'Vì vậy cậu lỡ giờ báo cáo dự kiến.',
    coreEnglish: 'As a consequence, he misses the planned reporting time.',
    detailChinese: '纪衡原本想用“当场解决”证明独立，此刻只能在记录里明确写出未知项。',
    detailPinyin: 'Jì Héng yuánběn xiǎng yòng “dāngchǎng jiějué” zhèngmíng dúlì, cǐkè zhǐ néng zài jìlù lǐ míngquè xiěchū wèizhī xiàng.',
    detailVietnamese: 'Kỷ Hành vốn muốn chứng minh tính độc lập bằng cách “giải quyết tại chỗ”, nhưng giờ cậu phải ghi rõ những điều chưa biết trong hồ sơ.',
    detailEnglish: 'Ji Heng had hoped to prove independence by fixing the problem on the spot; now he must state the unknowns explicitly in the record.',
    detailFromLevel: 8,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E10-storm',
    coreChinese: '雷雨落下，导排把水带离石缝。',
    corePinyin: 'Léiyǔ luòxià, dǎopái bǎ shuǐ dài lí shífèng.',
    coreVietnamese: 'Mưa giông đổ xuống, đường dẫn tạm đưa nước rời khỏi khe đá.',
    coreEnglish: 'The storm breaks, and the temporary route carries water away from the stone joint.',
    detailChinese: '其余龙头开始排水，那处异常仍安静；临时措施把水引离返潮石缝，最坏风险没有发生。',
    detailPinyin: 'Qíyú lóngtóu kāishǐ páishuǐ, nà chù yìcháng réng ānjìng; línshí cuòshī bǎ shuǐ yǐn lí fǎncháo shífèng, zuì huài fēngxiǎn méiyǒu fāshēng.',
    detailVietnamese: 'Các đầu rồng khác bắt đầu xả nước, còn điểm bất thường vẫn im; biện pháp tạm đưa nước ra khỏi khe ẩm nên kịch bản xấu nhất không xảy ra.',
    detailEnglish: 'Other dragon outlets begin draining while the anomalous one remains quiet; the temporary measure diverts water from the damp joint, preventing the worst risk.',
    detailFromLevel: 3,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E11-finding',
    coreChinese: '次日检查确认，杂物堵在旧修缮层上方。',
    corePinyin: 'Cìrì jiǎnchá quèrèn, záwù dǔ zài jiù xiūshàn céng shàngfāng.',
    coreVietnamese: 'Kiểm tra ngày hôm sau xác nhận mảnh vụn bị kẹt phía trên lớp tu bổ cũ.',
    coreEnglish: 'Inspection the next day confirms that debris is lodged above the older repair layer.',
    detailChinese: '受控检查发现堵塞物停在旧修缮层上方，既没有新位移，也不需要凿开石材寻找原因。',
    detailPinyin: 'Shòukòng jiǎnchá fāxiàn dǔsèwù tíng zài jiù xiūshàn céng shàngfāng, jì méiyǒu xīn wèiyí, yě bù xūyào záokāi shícái xúnzhǎo yuányīn.',
    detailVietnamese: 'Kiểm tra có kiểm soát cho thấy vật tắc nằm trên lớp tu bổ cũ; không có dịch chuyển mới và không cần đục đá để tìm nguyên nhân.',
    detailEnglish: 'Controlled inspection finds the blockage above the older repair layer; there is no new displacement and no need to chisel the stone to find the cause.',
    detailFromLevel: 9,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E12-resolution',
    coreChinese: '最小清理恢复水流，也保住旧材料。',
    corePinyin: 'Zuìxiǎo qīnglǐ huīfù shuǐliú, yě bǎozhù jiù cáiliào.',
    coreVietnamese: 'Việc làm sạch tối thiểu khôi phục dòng nước và giữ lại vật liệu cũ.',
    coreEnglish: 'Minimal cleaning restores the flow while preserving the older material.',
    detailChinese: '保护师只做最小范围清理，复测后水流恢复，旧灰缝、编号和影像都保留下来供以后比较。这份记录也成为下一次雨季复查的可追溯基准。',
    detailPinyin: 'Bǎohùshī zhǐ zuò zuìxiǎo fànwéi qīnglǐ, fùcè hòu shuǐliú huīfù, jiù huīfèng, biānhào hé yǐngxiàng dōu bǎoliú xiàlái gōng yǐhòu bǐjiào. Zhè fèn jìlù yě chéngwéi xià yí cì yǔjì fùchá de kě zhuīsù jīzhǔn.',
    detailVietnamese: 'Chuyên gia chỉ làm sạch trong phạm vi tối thiểu; sau đo lại, dòng nước trở lại, còn mạch vữa cũ, mã số và hình ảnh đều được giữ để so sánh về sau. Hồ sơ ấy trở thành mốc có thể truy xuất cho lần kiểm tra mùa mưa tiếp theo.',
    detailEnglish: 'The conservator cleans only the minimum area; after rechecking, flow returns while the old mortar joint, reference number, and images remain for future comparison. The record becomes a traceable baseline for the next rainy-season inspection.',
    detailFromLevel: 10,
  ),
  RemediatedSemanticEvent(
    id: 'FC-E13-growth',
    coreChinese: '纪衡懂得，独立是让每次干预可复核。',
    corePinyin: 'Jì Héng dǒngde, dúlì shì ràng měi cì gānyù kě fùhé.',
    coreVietnamese: 'Kỷ Hành hiểu rằng độc lập là làm cho mỗi can thiệp đều có thể được kiểm tra lại.',
    coreEnglish: 'Ji Heng understands that independence means making every intervention reviewable.',
    detailChinese: '他也重新理解“修缮”：不是让宫殿失去岁月痕迹，而是在功能、安全与历史证据之间克制地做选择。',
    detailPinyin: 'Tā yě chóngxīn lǐjiě “xiūshàn”: bú shì ràng gōngdiàn shīqù suìyuè hénjì, ér shì zài gōngnéng, ānquán yǔ lìshǐ zhèngjù zhījiān kèzhì de zuò xuǎnzé.',
    detailVietnamese: 'Cậu cũng hiểu lại “tu bổ”: không phải xóa dấu thời gian khỏi cung điện, mà là lựa chọn có kiềm chế giữa chức năng, an toàn và bằng chứng lịch sử.',
    detailEnglish: 'He also redefines conservation: not erasing age from a palace, but making restrained choices among function, safety, and historical evidence.',
    detailFromLevel: 6,
  ),
];

const _forbiddenCityEventIds = <String>[
  'FC-E1-warning',
  'FC-E2-goal',
  'FC-E3-ritual-space',
  'FC-E4-drain',
  'FC-E5-history-layer',
  'FC-E6-choice',
  'FC-E7-action',
  'FC-E8-temporary',
  'FC-E9-consequence',
  'FC-E10-storm',
  'FC-E11-finding',
  'FC-E12-resolution',
  'FC-E13-growth',
];

final forbiddenCityRemediation = RemediatedJourney(
  id: 'beijing-forbidden-city',
  title: '北京 · 紫禁城：雨落丹陛',
  protagonist: '纪衡，二十一岁的石质保护实习生',
  goal: '在雷雨到来前确认太和殿丹陛一处排水异常，并提交可追溯的保护记录',
  conflict: '快速疏通可能减少积水，却可能破坏旧修缮层；等待复核则必须承受暴雨逼近和延迟汇报的压力',
  eventIds: _forbiddenCityEventIds,
  events: _forbiddenCityEvents,
  levels: _buildLevels(events: _forbiddenCityEvents, splitAfter: 7),
  words: <WordEntry>[
    _word(word: '午门', pinyin: 'wǔmén', partOfSpeech: '专有名词', simpleChinese: '紫禁城南侧重要宫门。', vietnamese: 'Ngọ Môn, cổng quan trọng ở phía nam Tử Cấm Thành.', english: 'the Meridian Gate, a major southern gate of the Forbidden City', symbol: '🏯', storySentence: '纪衡在午门内收到雷雨预警。', storyPinyin: 'Jì Héng zài Wǔmén nèi shōudào léiyǔ yùjǐng.', storyVietnamese: 'Kỷ Hành nhận cảnh báo giông mưa bên trong Ngọ Môn.', storyEnglish: 'Ji Heng receives a thunderstorm warning inside the Meridian Gate.'),
    _word(word: '太和殿', pinyin: 'tàihédiàn', partOfSpeech: '专有名词', simpleChinese: '紫禁城外朝核心大殿。', vietnamese: 'Điện Thái Hòa, đại điện trung tâm của Ngoại triều.', english: 'the Hall of Supreme Harmony, the central hall of the Outer Court', symbol: '🏛️', storySentence: '他要在闭馆前确认太和殿丹陛排水异常。', storyPinyin: 'Tā yào zài bìguǎn qián quèrèn Tàihé Diàn dānbì páishuǐ yìcháng.', storyVietnamese: 'Cậu phải xác nhận bất thường thoát nước ở nền đá Điện Thái Hòa trước giờ đóng cửa.', storyEnglish: 'He must confirm a drainage anomaly on the Hall of Supreme Harmony terrace before closing.'),
    _word(word: '丹陛', pinyin: 'dānbì', partOfSpeech: '名词', simpleChinese: '宫殿前高起的石质台阶、台基区域。', vietnamese: 'Khu nền và bậc đá cao trước đại điện.', english: 'the raised stone terrace and stair area before a palace hall', symbol: '🪨', storySentence: '他要在闭馆前确认太和殿丹陛排水异常。', storyPinyin: 'Tā yào zài bìguǎn qián quèrèn Tàihé Diàn dānbì páishuǐ yìcháng.', storyVietnamese: 'Cậu phải xác nhận bất thường thoát nước ở nền đá Điện Thái Hòa trước giờ đóng cửa.', storyEnglish: 'He must confirm a drainage anomaly on the Hall of Supreme Harmony terrace before closing.'),
    _word(word: '中轴', pinyin: 'zhōngzhóu', partOfSpeech: '名词', simpleChinese: '组织主要宫门、院落与殿宇的南北中心轴线。', vietnamese: 'Trục bắc nam tổ chức các cổng, sân và điện chính.', english: 'the central north-south axis organizing major gates, courts, and halls', symbol: '🧭', storySentence: '中轴尽头，外朝礼仪空间层层抬高。', storyPinyin: 'Zhōngzhóu jìntóu, wàicháo lǐyí kōngjiān céngcéng táigāo.', storyVietnamese: 'Trên trục giữa, không gian nghi lễ Ngoại triều được nâng dần qua từng lớp.', storyEnglish: 'Along the central axis, the ritual space of the Outer Court rises layer by layer.'),
    _word(word: '外朝', pinyin: 'wàicháo', partOfSpeech: '名词', simpleChinese: '紫禁城南部以国家礼仪和政务活动为主的宫殿区域。', vietnamese: 'Khu phía nam của Tử Cấm Thành chủ yếu dành cho nghi lễ nhà nước và chính sự.', english: 'the southern Outer Court used principally for state ceremony and government affairs', symbol: '🎴', storySentence: '中轴尽头，外朝礼仪空间层层抬高。', storyPinyin: 'Zhōngzhóu jìntóu, wàicháo lǐyí kōngjiān céngcéng táigāo.', storyVietnamese: 'Trên trục giữa, không gian nghi lễ Ngoại triều được nâng dần qua từng lớp.', storyEnglish: 'Along the central axis, the ritual space of the Outer Court rises layer by layer.'),
    _word(word: '内廷', pinyin: 'nèitíng', partOfSpeech: '名词', simpleChinese: '紫禁城北部与皇帝、皇后和后妃宫寝生活相关的区域。', vietnamese: 'Nội đình phía bắc, gắn với đời sống cung cư của hoàng đế, hoàng hậu và phi tần.', english: 'the northern Inner Court associated with imperial residential life', symbol: '🏮', storySentence: '北面的内廷承担皇帝、皇后与后妃的宫寝生活。', storyPinyin: 'Běimiàn de nèitíng chéngdān huángdì, huánghòu yǔ hòufēi de gōngqǐn shēnghuó.', storyVietnamese: 'Phía bắc, Nội đình phục vụ đời sống cung cư của hoàng đế, hoàng hậu và các phi tần.', storyEnglish: 'To the north, the Inner Court housed the emperor, empress, and consorts.'),
    _word(word: '石雕龙头', pinyin: 'shídiāo lóngtóu', partOfSpeech: '名词', simpleChinese: '台基周边兼具装饰与排水功能的龙首石雕。', vietnamese: 'Đầu rồng đá quanh nền điện, vừa trang trí vừa có chức năng thoát nước.', english: 'carved stone dragon heads around the terrace that also serve as drains', symbol: '🐉', storySentence: '一个石雕龙头不出水，石缝却返潮。', storyPinyin: 'Yí gè shídiāo lóngtóu bù chūshuǐ, shífèng què fǎncháo.', storyVietnamese: 'Một đầu rồng đá không thoát nước, nhưng khe đá bên cạnh lại ẩm ngược.', storyEnglish: 'One carved stone dragon outlet is dry while the nearby stone joint is damp.'),
    _word(word: '千龙吐水', pinyin: 'qiān lóng tǔ shuǐ', partOfSpeech: '名词短语', simpleChinese: '大雨时多个龙首排水口同时出水形成的景象。', vietnamese: 'Cảnh nhiều đầu rồng đá cùng xả nước khi mưa lớn.', english: 'the spectacle of many dragon-head drains discharging together in heavy rain', symbol: '🌧️', storySentence: '大雨时多处出水形成“千龙吐水”的景象。', storyPinyin: 'Dàyǔ shí duō chù chūshuǐ xíngchéng “qiān lóng tǔ shuǐ” de jǐngxiàng.', storyVietnamese: 'Khi mưa lớn, nhiều miệng cùng xả tạo nên cảnh “nghìn rồng phun nước”.', storyEnglish: 'In heavy rain, many outlets discharge together in the scene known as “a thousand dragons spouting water.”'),
    _word(word: '修缮', pinyin: 'xiūshàn', partOfSpeech: '动词 / 名词', simpleChinese: '对历史建筑进行维修、保护与必要处理。', vietnamese: 'Tu bổ, bảo vệ và xử lý cần thiết đối với công trình lịch sử.', english: 'to conserve, repair, and appropriately treat a historic structure', symbol: '🛠️', storySentence: '异常点旁留着旧修缮灰缝。', storyPinyin: 'Yìcháng diǎn páng liúzhe jiù xiūshàn huīfèng.', storyVietnamese: 'Bên điểm bất thường còn giữ một mạch vữa của lần tu bổ cũ.', storyEnglish: 'An older conservation mortar joint remains beside the anomaly.'),
    _word(word: '可逆', pinyin: 'kěnì', partOfSpeech: '形容词', simpleChinese: '可以撤回或恢复，不把临时措施变成永久改变。', vietnamese: 'Có thể hoàn nguyên hoặc tháo bỏ, không biến biện pháp tạm thành thay đổi vĩnh viễn.', english: 'reversible; capable of being removed or undone without making a temporary measure permanent', symbol: '↩️', storySentence: '可逆的临时导排不触碰文物本体。', storyPinyin: 'Kěnì de línshí dǎopái bù chùpèng wénwù běntǐ.', storyVietnamese: 'Biện pháp dẫn thoát tạm thời có thể hoàn nguyên không chạm vào bản thể di tích.', storyEnglish: 'The reversible temporary drainage avoids touching the historic fabric.'),
    _word(word: '复核', pinyin: 'fùhé', partOfSpeech: '动词', simpleChinese: '再次检查并由他人或新的证据确认判断。', vietnamese: 'Kiểm tra lại và xác nhận bằng người khác hoặc bằng chứng mới.', english: 'to verify or review a judgment through another check', symbol: '✅', storySentence: '他必须选择：立刻疏通，还是停手复核。', storyPinyin: 'Tā bìxū xuǎnzé: lìkè shūtōng, háishì tíngshǒu fùhé.', storyVietnamese: 'Cậu phải chọn: thông ngay hay dừng tay để kiểm tra lại.', storyEnglish: 'He must choose: clear it immediately or stop and verify first.'),
    _word(word: '可追溯', pinyin: 'kě zhuīsù', partOfSpeech: '形容词', simpleChinese: '记录能够追查到位置、时间、依据和处理过程。', vietnamese: 'Có thể truy lại vị trí, thời gian, căn cứ và quá trình xử lý.', english: 'traceable to its location, time, evidence, and treatment history', symbol: '🔎', storySentence: '这份记录也成为下一次雨季复查的可追溯基准。', storyPinyin: 'Zhè fèn jìlù yě chéngwéi xià yí cì yǔjì fùchá de kě zhuīsù jīzhǔn.', storyVietnamese: 'Hồ sơ ấy trở thành mốc có thể truy xuất cho lần kiểm tra mùa mưa tiếp theo.', storyEnglish: 'The record becomes a traceable baseline for the next rainy-season inspection.'),
  ],
  wordTraces: const <RemediatedWordTrace>[
    RemediatedWordTrace(word: '午门', eventId: 'FC-E1-warning', usage: '用于说明进入紫禁城与雷雨任务发生的具体位置。', sourceText: '纪衡在午门内收到雷雨预警。'),
    RemediatedWordTrace(word: '太和殿', eventId: 'FC-E2-goal', usage: '与“外朝核心”“国家仪式”连用，说明建筑等级与功能。', sourceText: '太和殿位于外朝核心'),
    RemediatedWordTrace(word: '丹陛', eventId: 'FC-E2-goal', usage: '用于指太和殿前高起的石质台基与排水场景。', sourceText: '太和殿丹陛排水异常'),
    RemediatedWordTrace(word: '中轴', eventId: 'FC-E3-ritual-space', usage: '用于描述紫禁城门、院、殿的空间组织关系。', sourceText: '中轴尽头'),
    RemediatedWordTrace(word: '外朝', eventId: 'FC-E3-ritual-space', usage: '用于说明国家礼仪空间，与内廷形成对照。', sourceText: '外朝礼仪空间'),
    RemediatedWordTrace(word: '内廷', eventId: 'FC-E3-ritual-space', usage: '用于说明皇帝、皇后与后妃的宫寝生活区域。', sourceText: '北面的内廷承担皇帝、皇后与后妃的宫寝生活'),
    RemediatedWordTrace(word: '石雕龙头', eventId: 'FC-E4-drain', usage: '在故事中同时承担建筑装饰与排水功能。', sourceText: '一个石雕龙头不出水'),
    RemediatedWordTrace(word: '千龙吐水', eventId: 'FC-E4-drain', usage: '用于描述大雨时多个龙首排水口同时出水的景象。', sourceText: '“千龙吐水”的景象'),
    RemediatedWordTrace(word: '修缮', eventId: 'FC-E5-history-layer', usage: '用于说明历史建筑不同年代留下的维修与保护层。', sourceText: '旧修缮灰缝'),
    RemediatedWordTrace(word: '可逆', eventId: 'FC-E8-temporary', usage: '用于说明临时措施可以撤回，不把应急处置变成永久改动。', sourceText: '可逆的临时导排'),
    RemediatedWordTrace(word: '复核', eventId: 'FC-E6-choice', usage: '用于表示在干预前再次核对并共同判断。', sourceText: '停手复核'),
    RemediatedWordTrace(word: '可追溯', eventId: 'FC-E12-resolution', usage: '用于说明保护记录未来仍能追查依据和变化。', sourceText: '可追溯基准'),
  ],
  discoveries: const <DiscoveryEntry>[
    DiscoveryEntry(text: '紫禁城以南北中轴组织主要宫门、院落和殿宇。太和殿位于外朝核心，服务重要国家礼仪；北部内廷则与皇帝、皇后和后妃的宫寝生活相关。', pinyin: 'Zǐjìnchéng yǐ nánběi zhōngzhóu zǔzhī zhǔyào gōngmén, yuànluò hé diànyǔ; wàicháo yǔ nèitíng chéngdān bùtóng gōngnéng.', simpleChinese: '中轴把外朝礼仪空间和内廷宫寝空间组织成清楚的次序。', vietnamese: 'Tử Cấm Thành tổ chức các cổng, sân và điện chính theo trục bắc nam; Ngoại triều phục vụ nghi lễ nhà nước, còn Nội đình gắn với đời sống cung cư.', english: 'The Forbidden City organizes its major gates, courts, and halls along a north-south axis; the Outer Court served state ceremony while the Inner Court was associated with imperial residential life.'),
    DiscoveryEntry(text: '太和殿坐落在高起的三层汉白玉台基上。台基周边石雕龙首兼具排水功能，大雨时多处同时出水，形成“千龙吐水”的著名景象。', pinyin: 'Tàihé Diàn zuòluò zài sān céng Hànbáiyù táijī shàng; shídiāo lóngshǒu jiānjù páishuǐ gōngnéng.', simpleChinese: '太和殿高台上的龙首不只是装饰，也参与排水。', vietnamese: 'Điện Thái Hòa nằm trên nền đá cẩm thạch trắng ba tầng; các đầu rồng đá quanh nền cũng làm nhiệm vụ thoát nước.', english: 'The Hall of Supreme Harmony stands on a three-tier white-marble terrace whose carved dragon heads also function as drains.'),
    DiscoveryEntry(text: '紫禁城建筑经历过火灾、重建和持续修缮。今天看到的材料、灰缝和编号可能来自不同历史阶段，因此保护工作必须先判断“这一层是什么”，再决定是否干预。', pinyin: 'Zǐjìnchéng jiànzhù jīnglì guò huǒzāi, chóngjiàn hé chíxù xiūshàn, bǎohù shí yào fēnqīng bùtóng lìshǐ céng.', simpleChinese: '历史建筑会留下不同年代的材料和维修痕迹，不能把“旧”自动当成“坏”。', vietnamese: 'Kiến trúc Tử Cấm Thành đã trải qua hỏa hoạn, tái thiết và tu bổ; vật liệu hay mạch vữa cũ có thể thuộc các lớp lịch sử khác nhau.', english: 'Forbidden City buildings carry layers from fires, rebuilding, and conservation, so older materials or repairs cannot automatically be treated as damage.'),
    DiscoveryEntry(text: '故事中的保护团队先记录位置与编号，再用不触碰文物本体的临时导排控制水害，最后依据检查结果做最小范围清理。这个顺序把应急安全与历史证据同时保留下来。', pinyin: 'Gùshì zhōng de bǎohù tuánduì xiān jìlù, zài línshí dǎopái, zuìhòu yījù jiǎnchá zuò zuìxiǎo qīnglǐ.', simpleChinese: '先控制风险、再确认原因、最后做最小处理，可以避免无依据的永久改动。', vietnamese: 'Trong truyện, đội bảo tồn ghi chép trước, dùng dẫn thoát tạm để kiểm soát nước, rồi chỉ làm sạch tối thiểu sau khi có kết quả kiểm tra.', english: 'In the story, the team documents first, controls water with temporary drainage, and performs only minimal cleaning after inspection, preserving both safety and historical evidence.'),
  ],
  discoveryTraces: const <RemediatedDiscoveryTrace>[
    RemediatedDiscoveryTrace(discoveryIndex: 0, storyEventIds: <String>['FC-E2-goal', 'FC-E3-ritual-space'], sourceIds: <String>['dpm-forbidden-city-guide', 'unesco-imperial-palaces-439']),
    RemediatedDiscoveryTrace(discoveryIndex: 1, storyEventIds: <String>['FC-E2-goal', 'FC-E4-drain'], sourceIds: <String>['dpm-forbidden-city-guide']),
    RemediatedDiscoveryTrace(discoveryIndex: 2, storyEventIds: <String>['FC-E5-history-layer', 'FC-E11-finding'], sourceIds: <String>['dpm-forbidden-city-guide', 'unesco-imperial-palaces-439']),
    RemediatedDiscoveryTrace(discoveryIndex: 3, storyEventIds: <String>['FC-E7-action', 'FC-E8-temporary', 'FC-E12-resolution'], sourceIds: <String>['beijing-gov-forbidden-city-2025']),
  ],
  challenges: const <RemediatedChallengeTrace>[
    RemediatedChallengeTrace(type: 'paragraphRebuild', storyEventIds: <String>['FC-E4-drain', 'FC-E6-choice', 'FC-E8-temporary', 'FC-E10-storm', 'FC-E12-resolution'], anchor: '龙头不出水 → 停手复核 → 临时导排 → 雷雨检验 → 最小清理'),
    RemediatedChallengeTrace(type: 'grammarRepair', storyEventIds: <String>['FC-E2-goal', 'FC-E3-ritual-space', 'FC-E5-history-layer'], anchor: '太和殿、外朝、内廷与历史修缮层的准确表达'),
    RemediatedChallengeTrace(type: 'missingSentence', storyEventIds: <String>['FC-E6-choice', 'FC-E7-action', 'FC-E9-consequence'], anchor: '在“立刻疏通”与“停手复核”之间补回纪衡真正采取的行动与代价'),
  ],
  memory: const <RemediatedMemoryReview>[
    RemediatedMemoryReview(category: 'protagonist', prompt: '主人公', answer: '纪衡从想用“当场解决”证明独立的实习生，成长为愿意在时间压力下记录未知、接受共同复核的保护工作者。', storyEventIds: <String>['FC-E1-warning', 'FC-E9-consequence', 'FC-E13-growth']),
    RemediatedMemoryReview(category: 'events', prompt: '重要事件', answer: '雷雨预警、龙头不出水、旧灰缝出现、停止疏通、临时导排、错过汇报、次日检查和最小清理组成完整因果链。', storyEventIds: _forbiddenCityEventIds),
    RemediatedMemoryReview(category: 'history', prompt: '历史', answer: '太和殿经历火灾、重建与持续修缮，现存建筑包含不同历史阶段留下的材料和维修痕迹。', storyEventIds: <String>['FC-E5-history-layer']),
    RemediatedMemoryReview(category: 'culture', prompt: '文化', answer: '外朝承担重要国家礼仪，内廷连接皇帝、皇后与后妃的宫寝生活；宫城空间把典礼与日常区分开。', storyEventIds: <String>['FC-E2-goal', 'FC-E3-ritual-space']),
    RemediatedMemoryReview(category: 'architecture', prompt: '建筑', answer: '太和殿三层汉白玉台基上的石雕龙首兼有排水功能，丹陛不是静态装饰，而是会在暴雨中工作的建筑系统。', storyEventIds: <String>['FC-E2-goal', 'FC-E4-drain', 'FC-E10-storm']),
    RemediatedMemoryReview(category: 'vocabulary', prompt: '关键词', answer: '午门、中轴、外朝、内廷、太和殿、丹陛、石雕龙头、千龙吐水、修缮、可逆、复核、可追溯。', storyEventIds: <String>['FC-E1-warning', 'FC-E3-ritual-space', 'FC-E4-drain', 'FC-E8-temporary', 'FC-E12-resolution']),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '纪衡在雷雨逼近时没有把排水异常变成一次抢修表演，而是以记录、可逆导排、共同复核和最小清理保护太和殿丹陛。',
    achievement: '丹陛守护者：能把宫殿功能、礼仪空间、历史修缮层与现代保护判断放进同一条证据链。',
    memoryAnchor: '雨落丹陛时，先保住证据，再决定怎样动手。',
    challengeReward: '完成短文复原、语病修复与补回句子，获得“丹陛雨纹章”。',
    journeyCompletion: '北京 · 紫禁城 Journey Completion',
  ),
  sources: const <RemediatedSourceBinding>[
    RemediatedSourceBinding(id: 'dpm-forbidden-city-guide', publisher: 'The Palace Museum', scope: '紫禁城中轴、外朝与内廷、太和殿建筑和丹陛排水'),
    RemediatedSourceBinding(id: 'unesco-imperial-palaces-439', publisher: 'UNESCO World Heritage Centre', scope: '明清皇宫历史、持续使用与世界遗产价值'),
    RemediatedSourceBinding(id: 'beijing-gov-forbidden-city-2025', publisher: 'Beijing Municipal Government', scope: '故宫公共保护与遗产背景'),
  ],
);

const _bundEvents = <RemediatedSemanticEvent>[
  RemediatedSemanticEvent(
    id: 'BD-E1-class',
    coreChinese: '陆潮在外滩准备九点半的金融公开课。',
    corePinyin: 'Lù Cháo zài Wàitān zhǔnbèi jiǔ diǎn bàn de jīnróng gōngkāikè.',
    coreVietnamese: 'Lục Triều chuẩn bị một buổi học công khai về tài chính lúc chín rưỡi ở Bến Thượng Hải.',
    coreEnglish: 'Lu Chao prepares a 9:30 public finance lesson on the Bund.',
    detailChinese: '公开课设在一处外滩历史建筑内，窗外正对黄浦江，对岸就是浦东陆家嘴的现代天际线。',
    detailPinyin: 'Gōngkāikè shè zài yí chù Wàitān lìshǐ jiànzhù nèi, chuāngwài zhèngduì Huángpǔ Jiāng, duì àn jiù shì Pǔdōng Lùjiāzuǐ de xiàndài tiānjìxiàn.',
    detailVietnamese: 'Buổi học diễn ra trong một công trình lịch sử ở Bến Thượng Hải; ngoài cửa sổ là sông Hoàng Phố và đường chân trời hiện đại Lục Gia Chủy ở Phố Đông.',
    detailEnglish: 'The lesson is inside a historic Bund building, with the Huangpu River outside and the modern Lujiazui skyline across in Pudong.',
    detailFromLevel: 2,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E2-goal',
    coreChinese: '他要把外滩与浦东放进一条时间线。',
    corePinyin: 'Tā yào bǎ Wàitān yǔ Pǔdōng fàng jìn yì tiáo shíjiānxiàn.',
    coreVietnamese: 'Cậu muốn đặt Bến Thượng Hải và Phố Đông vào cùng một dòng thời gian.',
    coreEnglish: 'He wants to place the Bund and Pudong on one historical timeline.',
    detailChinese: '陆潮原想用同一时刻的两岸画面证明“上海的金融史就是越来越快”。',
    detailPinyin: 'Lù Cháo yuán xiǎng yòng tóng yī shíkè de liǎng àn huàmiàn zhèngmíng “Shànghǎi de jīnróngshǐ jiù shì yuèláiyuè kuài”.',
    detailVietnamese: 'Ban đầu Lục Triều muốn dùng hình ảnh hai bờ cùng một thời điểm để chứng minh rằng “lịch sử tài chính Thượng Hải chỉ là ngày càng nhanh hơn”.',
    detailEnglish: 'He initially wants a synchronized two-bank image to prove that “Shanghai financial history is simply a story of ever-greater speed.”',
    detailFromLevel: 4,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E3-commerce',
    coreChinese: '黄浦江西岸曾聚集贸易、航运和金融机构。',
    corePinyin: 'Huángpǔ Jiāng xī àn céng jùjí màoyì, hángyùn hé jīnróng jīgòu.',
    coreVietnamese: 'Bờ tây sông Hoàng Phố từng tập trung các tổ chức thương mại, vận tải thủy và tài chính.',
    coreEnglish: 'Trade, shipping, and financial institutions once clustered along the west bank of the Huangpu.',
    detailChinese: '十九世纪开埠以后，外滩一带的贸易、航运、海关和金融活动在多年中集聚，历史建筑也来自不同年代和风格。',
    detailPinyin: 'Shíjiǔ shìjì kāibù yǐhòu, Wàitān yídài de màoyì, hángyùn, hǎiguān hé jīnróng huódòng zài duōnián zhōng jùjí, lìshǐ jiànzhù yě láizì bùtóng niándài hé fēnggé.',
    detailVietnamese: 'Sau khi mở cảng trong thế kỷ XIX, thương mại, vận tải, hải quan và tài chính dần tập trung quanh Bến Thượng Hải qua nhiều năm; các công trình lịch sử cũng thuộc nhiều thời kỳ và phong cách.',
    detailEnglish: 'After the port opened in the nineteenth century, trade, shipping, customs, and finance accumulated around the Bund over many years, while its historic buildings arose in different periods and styles.',
    detailFromLevel: 4,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E4-treaty-port',
    coreChinese: '1843年开埠后，这些功能逐步形成。',
    corePinyin: 'Yī bā sì sān nián kāibù hòu, zhèxiē gōngnéng zhúbù xíngchéng.',
    coreVietnamese: 'Sau khi Thượng Hải mở cảng năm 1843, các chức năng này dần hình thành.',
    coreEnglish: 'After Shanghai opened as a treaty port in 1843, these functions developed gradually.',
    detailChinese: '1843年的开埠处在近代不平等条约体系中，它改变了城市对外贸易条件，却不是一个让金融中心瞬间出现的魔法日期。',
    detailPinyin: 'Yī bā sì sān nián de kāibù chǔ zài jìndài bù píngděng tiáoyuē tǐxì zhōng, tā gǎibiàn le chéngshì duìwài màoyì tiáojiàn, què bú shì yí gè ràng jīnróng zhōngxīn shùnjiān chūxiàn de mófǎ rìqī.',
    detailVietnamese: 'Việc mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng thời cận đại; nó thay đổi điều kiện ngoại thương của thành phố nhưng không phải một ngày thần kỳ khiến trung tâm tài chính xuất hiện tức thì.',
    detailEnglish: 'The 1843 opening occurred within the modern unequal-treaty system; it changed Shanghai’s foreign-trade conditions but was not a magical date on which a financial center appeared overnight.',
    detailFromLevel: 6,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E5-bad-script',
    coreChinese: '赞助动画却说“旧金融一夜被新金融取代”。',
    corePinyin: 'Zànzhù dònghuà què shuō “jiù jīnróng yí yè bèi xīn jīnróng qǔdài”.',
    coreVietnamese: 'Đoạn hoạt họa của nhà tài trợ lại nói rằng “tài chính cũ bị tài chính mới thay thế chỉ sau một đêm”.',
    coreEnglish: 'The sponsor animation claims that “old finance was replaced by new finance overnight.”',
    detailChinese: '动画把近代外滩压成黑白背景，再让浦东高楼一闪而起，既省时间，也最适合直播。',
    detailPinyin: 'Dònghuà bǎ jìndài Wàitān yā chéng hēibái bèijǐng, zài ràng Pǔdōng gāolóu yì shǎn ér qǐ, jì shěng shíjiān, yě zuì shìhé zhíbō.',
    detailVietnamese: 'Đoạn phim ép Bến Thượng Hải cận đại thành một nền đen trắng rồi làm cao ốc Phố Đông bật lên trong chớp mắt, rất tiết kiệm thời gian và hợp với truyền hình trực tiếp.',
    detailEnglish: 'The animation compresses the modern-era Bund into a black-and-white backdrop and makes Pudong towers flash into existence, saving time and fitting the live show perfectly.',
    detailFromLevel: 3,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E6-outage',
    coreChinese: '开场前，跨江直播突然断线。',
    corePinyin: 'Kāichǎng qián, kuàjiāng zhíbō tūrán duànxiàn.',
    coreVietnamese: 'Ngay trước giờ bắt đầu, đường truyền trực tiếp qua sông đột ngột mất kết nối.',
    coreEnglish: 'Just before the start, the cross-river live connection fails.',
    detailChinese: '备用线路也失败，后台只剩一段提前录好的动画。',
    detailPinyin: 'Bèiyòng xiànlù yě shībài, hòutái zhǐ shèng yí duàn tíqián lù hǎo de dònghuà.',
    detailVietnamese: 'Đường dự phòng cũng hỏng, phía sau chỉ còn đoạn hoạt họa đã ghi sẵn.',
    detailEnglish: 'The backup line fails as well, leaving only the prerecorded animation.',
    detailFromLevel: 3,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E7-choice',
    coreChinese: '他必须选择：按时播放，还是改掉错误叙事。',
    corePinyin: 'Tā bìxū xuǎnzé: ànshí bòfàng, háishì gǎidiào cuòwù xùshì.',
    coreVietnamese: 'Cậu phải chọn: phát đúng giờ hay sửa lại câu chuyện sai lệch.',
    coreEnglish: 'He must choose: play it on time or replace the false narrative.',
    detailChinese: '按时播放能保住赞助方的节奏，却会把复杂历史说成“旧被新淘汰”；改讲意味着失去预定的跨江同步效果。',
    detailPinyin: 'Ànshí bòfàng néng bǎozhù zànzhùfāng de jiézòu, què huì bǎ fùzá lìshǐ shuō chéng “jiù bèi xīn táotài”; gǎijiǎng yìwèizhe shīqù yùdìng de kuàjiāng tóngbù xiàoguǒ.',
    detailVietnamese: 'Phát đúng giờ giữ được nhịp của nhà tài trợ nhưng biến lịch sử phức tạp thành “cũ bị mới loại bỏ”; đổi bài nghĩa là mất hiệu ứng đồng bộ hai bờ đã định.',
    detailEnglish: 'Playing on time preserves the sponsor’s rhythm but reduces a complex history to “new replaces old”; changing course means losing the planned synchronized riverfront effect.',
    detailFromLevel: 7,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E8-action',
    coreChinese: '陆潮关掉动画，让观众扮演商人、船运、海关和银行。',
    corePinyin: 'Lù Cháo guāndiào dònghuà, ràng guānzhòng bànyǎn shāngrén, chuányùn, hǎiguān hé yínháng.',
    coreVietnamese: 'Lục Triều tắt hoạt họa và cho khán giả đóng vai thương nhân, vận tải tàu thuyền, hải quan và ngân hàng.',
    coreEnglish: 'Lu Chao turns off the animation and casts the audience as merchants, shipping, customs, and banks.',
    detailChinese: '商人拿货单，船运传舱单，海关核验信息，银行根据票据与信用安排结算；观众必须互相等待，任何一环都不能凭空跳过。',
    detailPinyin: 'Shāngrén ná huòdān, chuányùn chuán cāngdān, hǎiguān héyàn xìnxī, yínháng gēnjù piàojù yǔ xìnyòng ānpái jiésuàn; guānzhòng bìxū hùxiāng děngdài, rènhé yì huán dōu bùnéng píngkōng tiàoguò.',
    detailVietnamese: 'Thương nhân cầm đơn hàng, vận tải chuyển chứng từ khoang, hải quan kiểm thông tin, ngân hàng dựa vào chứng từ và tín dụng để sắp xếp thanh toán; mọi người phải chờ nhau, không khâu nào có thể tự biến mất.',
    detailEnglish: 'Merchants hold orders, shipping passes cargo documents, customs verifies information, and banks arrange settlement through documents and credit; the participants must wait on one another, and no link can simply vanish.',
    detailFromLevel: 5,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E9-simulation',
    coreChinese: '一张票据在角色间传递货物、信用和结算。',
    corePinyin: 'Yì zhāng piàojù zài juésè jiān chuándì huòwù, xìnyòng hé jiésuàn.',
    coreVietnamese: 'Một chứng từ truyền hàng hóa, tín dụng và thanh toán giữa các vai.',
    coreEnglish: 'One document carries goods, credit, and settlement through the roles.',
    detailChinese: '角色游戏让“金融”从高楼里的抽象名词变成与货物、航运、规则和信用相连的一系列承诺。',
    detailPinyin: 'Juésè yóuxì ràng “jīnróng” cóng gāolóu lǐ de chōuxiàng míngcí biànchéng yǔ huòwù, hángyùn, guīzé hé xìnyòng xiānglián de yí xìliè chéngnuò.',
    detailVietnamese: 'Trò chơi nhập vai biến “tài chính” từ một khái niệm trừu tượng trong cao ốc thành chuỗi cam kết gắn với hàng hóa, vận tải, quy tắc và tín dụng.',
    detailEnglish: 'The role-play turns “finance” from an abstract word in a tower into a chain of commitments linking goods, shipping, rules, and credit.',
    detailFromLevel: 5,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E10-consequence',
    coreChinese: '因此他错过九点半的同步画面。',
    corePinyin: 'Yīncǐ tā cuòguò jiǔ diǎn bàn de tóngbù huàmiàn.',
    coreVietnamese: 'Vì vậy cậu bỏ lỡ khung hình đồng bộ lúc chín rưỡi.',
    coreEnglish: 'As a consequence, he misses the planned 9:30 synchronized shot.',
    detailChinese: '赞助方在耳机里提醒他时间超了，但陆潮没有把模拟压缩成一句口号。',
    detailPinyin: 'Zànzhùfāng zài ěrjī lǐ tíxǐng tā shíjiān chāo le, dàn Lù Cháo méiyǒu bǎ mónǐ yāsuō chéng yí jù kǒuhào.',
    detailVietnamese: 'Nhà tài trợ nhắc trong tai nghe rằng cậu đã quá giờ, nhưng Lục Triều không ép phần mô phỏng thành một khẩu hiệu.',
    detailEnglish: 'The sponsor warns through his earpiece that he is over time, but Lu Chao refuses to compress the simulation into a slogan.',
    detailFromLevel: 7,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E11-modern',
    coreChinese: '网络恢复后，浦东端完成转账。',
    corePinyin: 'Wǎngluò huīfù hòu, Pǔdōng duān wánchéng zhuǎnzhàng.',
    coreVietnamese: 'Khi mạng trở lại, phía Phố Đông hoàn tất chuyển tiền.',
    coreEnglish: 'When the connection returns, the Pudong side completes the transfer.',
    detailChinese: '屏幕重新亮起时，浦东端的学生用现代支付界面完成同一笔交易；速度变了，核对对象和承担责任的需求没有消失。',
    detailPinyin: 'Píngmù chóngxīn liàngqǐ shí, Pǔdōng duān de xuéshēng yòng xiàndài zhīfù jièmiàn wánchéng tóng yì bǐ jiāoyì; sùdù biàn le, héduì duìxiàng hé chéngdān zérèn de xūqiú méiyǒu xiāoshī.',
    detailVietnamese: 'Khi màn hình sáng lại, học sinh phía Phố Đông hoàn tất cùng giao dịch bằng giao diện thanh toán hiện đại; tốc độ đã đổi, nhưng nhu cầu xác minh đối tượng và chịu trách nhiệm không biến mất.',
    detailEnglish: 'When the screen returns, students in Pudong complete the same transaction through a modern payment interface; speed has changed, but the need to verify counterparties and bear responsibility has not disappeared.',
    detailFromLevel: 8,
  ),
  RemediatedSemanticEvent(
    id: 'BD-E12-growth',
    coreChinese: '陆潮明白，新旧上海不是替代，而是隔江相连的历史层。',
    corePinyin: 'Lù Cháo míngbai, xīnjiù Shànghǎi bú shì tìdài, ér shì gé jiāng xiānglián de lìshǐ céng.',
    coreVietnamese: 'Lục Triều hiểu rằng Thượng Hải cũ và mới không thay thế nhau mà là các lớp lịch sử nối nhau qua sông.',
    coreEnglish: 'Lu Chao understands that old and new Shanghai are not replacements but historical layers connected across the river.',
    detailChinese: '他最后请观众转身看江面：西岸的历史建筑、航船和东岸天际线同时存在，城市并没有把过去删除后才获得未来。公开课结束后，赞助方删除了“一夜取代”的文案，把下一场课程改成“从票据到数字结算”。',
    detailPinyin: 'Tā zuìhòu qǐng guānzhòng zhuǎnshēn kàn jiāngmiàn: xī àn de lìshǐ jiànzhù, hángchuán hé dōng àn tiānjìxiàn tóngshí cúnzài, chéngshì bìng méiyǒu bǎ guòqù shānchú hòu cái huòdé wèilái. Gōngkāikè jiéshù hòu, zànzhùfāng shānchú le “yí yè qǔdài” de wén àn, bǎ xià yì chǎng kèchéng gǎi chéng “cóng piàojù dào shùzì jiésuàn”.',
    detailVietnamese: 'Cuối cùng cậu mời khán giả quay ra sông: các công trình lịch sử và tàu thuyền ở bờ tây cùng tồn tại với đường chân trời bờ đông; thành phố không cần xóa quá khứ mới có tương lai. Sau buổi học, nhà tài trợ bỏ câu “thay thế chỉ sau một đêm” và đổi chủ đề lần sau thành “từ chứng từ đến thanh toán số”.',
    detailEnglish: 'He asks the audience to turn toward the river: historic west-bank buildings and vessels coexist with the east-bank skyline, and the city did not have to delete its past to gain a future. Afterward, the sponsor removes the “overnight replacement” copy and retitles the next lesson “From documents to digital settlement.”',
    detailFromLevel: 9,
  ),
];

const _bundEventIds = <String>[
  'BD-E1-class',
  'BD-E2-goal',
  'BD-E3-commerce',
  'BD-E4-treaty-port',
  'BD-E5-bad-script',
  'BD-E6-outage',
  'BD-E7-choice',
  'BD-E8-action',
  'BD-E9-simulation',
  'BD-E10-consequence',
  'BD-E11-modern',
  'BD-E12-growth',
];

final shanghaiBundRemediation = RemediatedJourney(
  id: 'shanghai-bund',
  title: '上海 · 外滩：九点半以前',
  protagonist: '陆潮，二十三岁的金融教育实习生',
  goal: '在九点半公开课中把外滩近代贸易金融史与浦东现代金融放进同一条可信的城市时间线',
  conflict: '赞助动画把复杂历史说成“旧金融一夜被新金融取代”，跨江直播又在开场前断线；按时播放与准确叙事无法同时保住',
  eventIds: _bundEventIds,
  events: _bundEvents,
  levels: _buildLevels(events: _bundEvents, splitAfter: 6),
  words: <WordEntry>[
    _word(word: '外滩', pinyin: 'wàitān', partOfSpeech: '专有名词', simpleChinese: '上海黄浦江西岸的历史滨水地区。', vietnamese: 'Bến Thượng Hải, khu ven sông lịch sử ở bờ tây sông Hoàng Phố.', english: 'the Bund, Shanghai’s historic waterfront on the west bank of the Huangpu', symbol: '🌆', storySentence: '陆潮在外滩准备九点半的金融公开课。', storyPinyin: 'Lù Cháo zài Wàitān zhǔnbèi jiǔ diǎn bàn de jīnróng gōngkāikè.', storyVietnamese: 'Lục Triều chuẩn bị một buổi học công khai về tài chính lúc chín rưỡi ở Bến Thượng Hải.', storyEnglish: 'Lu Chao prepares a 9:30 public finance lesson on the Bund.'),
    _word(word: '黄浦江', pinyin: 'huángpǔ jiāng', partOfSpeech: '专有名词', simpleChinese: '穿过上海中心城区、分隔外滩与浦东的重要河流。', vietnamese: 'Sông Hoàng Phố chảy qua trung tâm Thượng Hải, ngăn Bến Thượng Hải với Phố Đông.', english: 'the Huangpu River separating the Bund from Pudong in central Shanghai', symbol: '🌊', storySentence: '黄浦江西岸曾聚集贸易、航运和金融机构。', storyPinyin: 'Huángpǔ Jiāng xī àn céng jùjí màoyì, hángyùn hé jīnróng jīgòu.', storyVietnamese: 'Bờ tây sông Hoàng Phố từng tập trung các tổ chức thương mại, vận tải thủy và tài chính.', storyEnglish: 'Trade, shipping, and financial institutions once clustered along the west bank of the Huangpu.'),
    _word(word: '浦东', pinyin: 'pǔdōng', partOfSpeech: '专有名词', simpleChinese: '黄浦江东岸的上海城区，包含陆家嘴现代天际线。', vietnamese: 'Khu đô thị phía đông sông Hoàng Phố, gồm đường chân trời hiện đại Lục Gia Chủy.', english: 'the urban area east of the Huangpu, including the modern Lujiazui skyline', symbol: '🏙️', storySentence: '网络恢复后，浦东端完成转账。', storyPinyin: 'Wǎngluò huīfù hòu, Pǔdōng duān wánchéng zhuǎnzhàng.', storyVietnamese: 'Khi mạng trở lại, phía Phố Đông hoàn tất chuyển tiền.', storyEnglish: 'When the connection returns, the Pudong side completes the transfer.'),
    _word(word: '天际线', pinyin: 'tiānjìxiàn', partOfSpeech: '名词', simpleChinese: '建筑轮廓与天空相接形成的城市线条。', vietnamese: 'Đường chân trời hình thành bởi đường nét của các tòa nhà.', english: 'the skyline formed by building silhouettes', symbol: '🌇', storySentence: '对岸就是浦东陆家嘴的现代天际线。', storyPinyin: 'Duì àn jiù shì Pǔdōng Lùjiāzuǐ de xiàndài tiānjìxiàn.', storyVietnamese: 'Đối diện là đường chân trời hiện đại Lục Gia Chủy ở Phố Đông.', storyEnglish: 'Across the river is the modern Lujiazui skyline in Pudong.'),
    _word(word: '开埠', pinyin: 'kāibù', partOfSpeech: '动词 / 名词', simpleChinese: '近代城市按条约条件开放为对外通商口岸。', vietnamese: 'Việc mở một cảng thành thương cảng đối ngoại theo điều kiện điều ước trong thời cận đại.', english: 'to open a port to foreign trade under treaty-port conditions', symbol: '⚓', storySentence: '1843年开埠后，这些功能逐步形成。', storyPinyin: 'Yī bā sì sān nián kāibù hòu, zhèxiē gōngnéng zhúbù xíngchéng.', storyVietnamese: 'Sau khi Thượng Hải mở cảng năm 1843, các chức năng này dần hình thành.', storyEnglish: 'After Shanghai opened as a treaty port in 1843, these functions developed gradually.'),
    _word(word: '贸易', pinyin: 'màoyì', partOfSpeech: '名词', simpleChinese: '商品与服务的交换、买卖活动。', vietnamese: 'Hoạt động trao đổi và mua bán hàng hóa, dịch vụ.', english: 'trade or commerce', symbol: '📦', storySentence: '黄浦江西岸曾聚集贸易、航运和金融机构。', storyPinyin: 'Huángpǔ Jiāng xī àn céng jùjí màoyì, hángyùn hé jīnróng jīgòu.', storyVietnamese: 'Bờ tây sông Hoàng Phố từng tập trung các tổ chức thương mại, vận tải thủy và tài chính.', storyEnglish: 'Trade, shipping, and financial institutions once clustered along the west bank of the Huangpu.'),
    _word(word: '航运', pinyin: 'hángyùn', partOfSpeech: '名词', simpleChinese: '利用船舶运输货物或人员的活动。', vietnamese: 'Hoạt động vận chuyển hàng hóa hoặc hành khách bằng tàu thuyền.', english: 'shipping and waterborne transport', symbol: '🚢', storySentence: '黄浦江西岸曾聚集贸易、航运和金融机构。', storyPinyin: 'Huángpǔ Jiāng xī àn céng jùjí màoyì, hángyùn hé jīnróng jīgòu.', storyVietnamese: 'Bờ tây sông Hoàng Phố từng tập trung các tổ chức thương mại, vận tải thủy và tài chính.', storyEnglish: 'Trade, shipping, and financial institutions once clustered along the west bank of the Huangpu.'),
    _word(word: '海关', pinyin: 'hǎiguān', partOfSpeech: '名词', simpleChinese: '管理进出口货物与相关手续的机构。', vietnamese: 'Cơ quan quản lý hàng hóa xuất nhập khẩu và thủ tục liên quan.', english: 'customs authority for imports, exports, and related procedures', symbol: '🧾', storySentence: '陆潮关掉动画，让观众扮演商人、船运、海关和银行。', storyPinyin: 'Lù Cháo guāndiào dònghuà, ràng guānzhòng bànyǎn shāngrén, chuányùn, hǎiguān hé yínháng.', storyVietnamese: 'Lục Triều tắt hoạt họa và cho khán giả đóng vai thương nhân, vận tải tàu thuyền, hải quan và ngân hàng.', storyEnglish: 'Lu Chao turns off the animation and casts the audience as merchants, shipping, customs, and banks.'),
    _word(word: '金融', pinyin: 'jīnróng', partOfSpeech: '名词', simpleChinese: '与资金、信用、银行、投资和结算有关的经济活动。', vietnamese: 'Hoạt động kinh tế liên quan đến vốn, tín dụng, ngân hàng, đầu tư và thanh toán.', english: 'financial activity involving money, credit, banking, investment, and settlement', symbol: '🏦', storySentence: '陆潮在外滩准备九点半的金融公开课。', storyPinyin: 'Lù Cháo zài Wàitān zhǔnbèi jiǔ diǎn bàn de jīnróng gōngkāikè.', storyVietnamese: 'Lục Triều chuẩn bị một buổi học công khai về tài chính lúc chín rưỡi ở Bến Thượng Hải.', storyEnglish: 'Lu Chao prepares a 9:30 public finance lesson on the Bund.'),
    _word(word: '票据', pinyin: 'piàojù', partOfSpeech: '名词', simpleChinese: '记录付款、债权或交易关系的书面凭证。', vietnamese: 'Chứng từ bằng văn bản ghi quan hệ thanh toán, quyền đòi nợ hoặc giao dịch.', english: 'a written financial or commercial instrument documenting payment or transaction rights', symbol: '📄', storySentence: '一张票据在角色间传递货物、信用和结算。', storyPinyin: 'Yì zhāng piàojù zài juésè jiān chuándì huòwù, xìnyòng hé jiésuàn.', storyVietnamese: 'Một chứng từ truyền hàng hóa, tín dụng và thanh toán giữa các vai.', storyEnglish: 'One document carries goods, credit, and settlement through the roles.'),
    _word(word: '信用', pinyin: 'xìnyòng', partOfSpeech: '名词', simpleChinese: '交易中对对方履行承诺和偿付能力的信任。', vietnamese: 'Niềm tin vào việc đối tác thực hiện cam kết và khả năng thanh toán.', english: 'credit or trust in a counterparty’s ability and willingness to meet obligations', symbol: '🤝', storySentence: '一张票据在角色间传递货物、信用和结算。', storyPinyin: 'Yì zhāng piàojù zài juésè jiān chuándì huòwù, xìnyòng hé jiésuàn.', storyVietnamese: 'Một chứng từ truyền hàng hóa, tín dụng và thanh toán giữa các vai.', storyEnglish: 'One document carries goods, credit, and settlement through the roles.'),
    _word(word: '结算', pinyin: 'jiésuàn', partOfSpeech: '动词 / 名词', simpleChinese: '核对并完成一笔交易的付款或账务处理。', vietnamese: 'Đối chiếu và hoàn tất thanh toán hoặc xử lý sổ sách của giao dịch.', english: 'to settle a transaction by completing payment or accounting', symbol: '💳', storySentence: '一张票据在角色间传递货物、信用和结算。', storyPinyin: 'Yì zhāng piàojù zài juésè jiān chuándì huòwù, xìnyòng hé jiésuàn.', storyVietnamese: 'Một chứng từ truyền hàng hóa, tín dụng và thanh toán giữa các vai.', storyEnglish: 'One document carries goods, credit, and settlement through the roles.'),
  ],
  wordTraces: const <RemediatedWordTrace>[
    RemediatedWordTrace(word: '外滩', eventId: 'BD-E1-class', usage: '作为故事舞台，连接历史建筑、黄浦江与金融教育活动。', sourceText: '陆潮在外滩准备九点半的金融公开课。'),
    RemediatedWordTrace(word: '黄浦江', eventId: 'BD-E3-commerce', usage: '用于确定外滩西岸与浦东东岸的地理关系。', sourceText: '黄浦江西岸'),
    RemediatedWordTrace(word: '浦东', eventId: 'BD-E11-modern', usage: '与外滩隔江对照，代表当代城市金融与数字转账场景。', sourceText: '浦东端完成转账'),
    RemediatedWordTrace(word: '天际线', eventId: 'BD-E1-class', usage: '用于描述陆家嘴现代高楼在黄浦江对岸形成的轮廓。', sourceText: '现代天际线'),
    RemediatedWordTrace(word: '开埠', eventId: 'BD-E4-treaty-port', usage: '用于说明1843年上海对外通商条件发生的重要历史变化。', sourceText: '1843年开埠后'),
    RemediatedWordTrace(word: '贸易', eventId: 'BD-E3-commerce', usage: '与航运、海关、金融并列，说明外滩近代商业功能。', sourceText: '贸易、航运和金融机构'),
    RemediatedWordTrace(word: '航运', eventId: 'BD-E3-commerce', usage: '用于连接黄浦江水运、货物移动和商业网络。', sourceText: '贸易、航运和金融机构'),
    RemediatedWordTrace(word: '海关', eventId: 'BD-E8-action', usage: '在角色模拟中负责核验交易与货运信息。', sourceText: '商人、船运、海关和银行'),
    RemediatedWordTrace(word: '金融', eventId: 'BD-E1-class', usage: '故事用金融公开课讨论外滩历史与浦东现代发展的连续关系。', sourceText: '金融公开课'),
    RemediatedWordTrace(word: '票据', eventId: 'BD-E9-simulation', usage: '在模拟中作为连接货物、信用与结算的凭证。', sourceText: '一张票据在角色间传递货物、信用和结算'),
    RemediatedWordTrace(word: '信用', eventId: 'BD-E9-simulation', usage: '用于说明金融交易依赖履约承诺，而不只是技术速度。', sourceText: '货物、信用和结算'),
    RemediatedWordTrace(word: '结算', eventId: 'BD-E9-simulation', usage: '用于表示交易最终完成付款与账务处理的环节。', sourceText: '货物、信用和结算'),
  ],
  discoveries: const <DiscoveryEntry>[
    DiscoveryEntry(text: '外滩位于黄浦江西岸，浦东陆家嘴位于对岸。今天站在外滩，可以在同一视野中看到历史建筑、江上交通和现代天际线，这种地理对望使“旧与新”成为真实的城市空间关系。', pinyin: 'Wàitān wèiyú Huángpǔ Jiāng xī àn, Pǔdōng Lùjiāzuǐ zài duì àn, liǎng àn zài tóng yī chéngshì shìyě zhōng duìwàng.', simpleChinese: '外滩在黄浦江西岸，浦东在东岸；两岸可以同时看到上海的历史与现代。', vietnamese: 'Bến Thượng Hải ở bờ tây sông Hoàng Phố, còn Lục Gia Chủy ở Phố Đông nằm đối diện; cùng một tầm nhìn có thể chứa công trình lịch sử, giao thông đường sông và đường chân trời hiện đại.', english: 'The Bund lies on the west bank of the Huangpu with Lujiazui in Pudong across the river, allowing historic architecture, river traffic, and the modern skyline to share one view.'),
    DiscoveryEntry(text: '上海在1843年于近代不平等条约体系下开埠。开埠改变了对外贸易条件，但外滩的贸易、航运、海关与金融功能是在随后多年中逐步集聚的，不是“一夜形成”。', pinyin: 'Shànghǎi zài yī bā sì sān nián yú jìndài bù píngděng tiáoyuē tǐxì xià kāibù; Wàitān de shāngyè hé jīnróng gōngnéng shì zhúbù jùjí de.', simpleChinese: '1843年开埠是重要转折，但外滩的商业和金融中心功能经过多年才逐渐形成。', vietnamese: 'Thượng Hải mở cảng năm 1843 trong hệ thống điều ước bất bình đẳng; các chức năng thương mại, vận tải, hải quan và tài chính của Bến Thượng Hải hình thành dần trong nhiều năm sau đó.', english: 'Shanghai opened as a treaty port in 1843 under the unequal-treaty system, but the Bund’s trade, shipping, customs, and financial functions accumulated gradually over the following years.'),
    DiscoveryEntry(text: '外滩历史建筑并非同一年建成，也不是单一风格。它们来自不同年代，曾承载银行、商业与公共机构等多种城市功能，因此街区本身就是上海近代城市发展的多层记录。', pinyin: 'Wàitān lìshǐ jiànzhù láizì bùtóng niándài hé fēnggé, céng chéngzài yínháng, shāngyè hé gōnggòng jīgòu děng gōngnéng.', simpleChinese: '外滩建筑有不同年代和风格，也承担过不同的城市功能。', vietnamese: 'Các công trình lịch sử ở Bến Thượng Hải thuộc nhiều thời kỳ và phong cách, từng phục vụ ngân hàng, thương mại và các cơ quan công cộng khác nhau.', english: 'The Bund’s historic buildings come from different periods and styles and have housed varied urban functions, including banking, commerce, and public institutions.'),
    DiscoveryEntry(text: '故事里的角色模拟把贸易、航运、海关、票据、信用与结算串在一起。现代数字转账速度更快，但“谁与谁交易、依据什么信息、谁承担承诺”仍是理解金融活动的重要问题。', pinyin: 'Gùshì lǐ de juésè mónǐ bǎ màoyì, hángyùn, hǎiguān, piàojù, xìnyòng hé jiésuàn chuàn zài yìqǐ.', simpleChinese: '从票据到数字转账，工具会改变，但交易仍需要信息、信用和责任。', vietnamese: 'Mô phỏng trong truyện nối thương mại, vận tải, hải quan, chứng từ, tín dụng và thanh toán; chuyển tiền số nhanh hơn nhưng giao dịch vẫn cần thông tin, niềm tin và trách nhiệm.', english: 'The story’s simulation links trade, shipping, customs, documents, credit, and settlement; digital transfers are faster, but transactions still depend on information, trust, and responsibility.'),
  ],
  discoveryTraces: const <RemediatedDiscoveryTrace>[
    RemediatedDiscoveryTrace(discoveryIndex: 0, storyEventIds: <String>['BD-E1-class', 'BD-E2-goal', 'BD-E11-modern'], sourceIds: <String>['shanghai-gov-bund-scenic', 'huangpu-gov-bund-heritage']),
    RemediatedDiscoveryTrace(discoveryIndex: 1, storyEventIds: <String>['BD-E3-commerce', 'BD-E4-treaty-port'], sourceIds: <String>['shanghai-gov-bund-scenic']),
    RemediatedDiscoveryTrace(discoveryIndex: 2, storyEventIds: <String>['BD-E1-class', 'BD-E3-commerce'], sourceIds: <String>['huangpu-gov-bund-heritage']),
    RemediatedDiscoveryTrace(discoveryIndex: 3, storyEventIds: <String>['BD-E8-action', 'BD-E9-simulation', 'BD-E11-modern'], sourceIds: <String>['shanghai-gov-bund-scenic']),
  ],
  challenges: const <RemediatedChallengeTrace>[
    RemediatedChallengeTrace(type: 'paragraphRebuild', storyEventIds: <String>['BD-E5-bad-script', 'BD-E6-outage', 'BD-E7-choice', 'BD-E8-action', 'BD-E11-modern'], anchor: '错误动画 → 直播断线 → 拒绝捷径 → 角色模拟 → 浦东完成转账'),
    RemediatedChallengeTrace(type: 'grammarRepair', storyEventIds: <String>['BD-E3-commerce', 'BD-E4-treaty-port'], anchor: '1843年开埠以后，贸易、航运、海关和金融功能“逐步形成”，不是“一夜出现”'),
    RemediatedChallengeTrace(type: 'missingSentence', storyEventIds: <String>['BD-E7-choice', 'BD-E10-consequence', 'BD-E12-growth'], anchor: '补回陆潮放弃九点半同步画面后得到的新旧上海结论'),
  ],
  memory: const <RemediatedMemoryReview>[
    RemediatedMemoryReview(category: 'protagonist', prompt: '主人公', answer: '陆潮从把现代金融理解为“更快屏幕”的实习生，成长为能用贸易、信用和责任解释城市金融连续性的教育者。', storyEventIds: <String>['BD-E1-class', 'BD-E2-goal', 'BD-E12-growth']),
    RemediatedMemoryReview(category: 'events', prompt: '重要事件', answer: '九点半公开课、错误赞助动画、跨江断线、现场选择、角色模拟、错过同步画面、浦东转账和文案改写组成完整因果链。', storyEventIds: _bundEventIds),
    RemediatedMemoryReview(category: 'history', prompt: '历史', answer: '上海1843年在近代不平等条约体系下开埠；外滩的贸易、航运、海关与金融功能随后经过多年逐步集聚。', storyEventIds: <String>['BD-E3-commerce', 'BD-E4-treaty-port']),
    RemediatedMemoryReview(category: 'culture', prompt: '城市文化', answer: '黄浦江让历史外滩与现代浦东隔江对望；上海的城市记忆不是删除旧层，而是让不同年代同时可见。', storyEventIds: <String>['BD-E1-class', 'BD-E11-modern', 'BD-E12-growth']),
    RemediatedMemoryReview(category: 'architecture', prompt: '建筑', answer: '外滩历史建筑来自不同年代和风格，曾承载银行、商业和公共机构等功能；它们与浦东现代天际线形成真实的两岸对照。', storyEventIds: <String>['BD-E1-class', 'BD-E3-commerce']),
    RemediatedMemoryReview(category: 'vocabulary', prompt: '关键词', answer: '外滩、黄浦江、浦东、天际线、开埠、贸易、航运、海关、金融、票据、信用、结算。', storyEventIds: <String>['BD-E1-class', 'BD-E3-commerce', 'BD-E4-treaty-port', 'BD-E8-action', 'BD-E9-simulation', 'BD-E11-modern']),
  ],
  completion: const RemediatedCompletion(
    journeySummary: '陆潮在跨江直播失灵后放弃“旧金融一夜被新金融取代”的动画，用一场现场交易模拟把外滩历史商业网络与浦东数字金融重新连成一条时间线。',
    achievement: '黄浦时间编辑：能把开埠、贸易航运、外滩建筑、信用结算与现代浦东放进同一套有历史层次的城市解释。',
    memoryAnchor: '黄浦江两岸不是旧城与新城的替换键，而是一条仍在流动的时间线。',
    challengeReward: '完成短文复原、语病修复与补回句子，获得“黄浦时间章”。',
    journeyCompletion: '上海 · 外滩 Journey Completion',
  ),
  sources: const <RemediatedSourceBinding>[
    RemediatedSourceBinding(id: 'shanghai-gov-bund-scenic', publisher: 'Shanghai Municipal Government', scope: '外滩地理、黄浦江关系、近代贸易金融与城市发展'),
    RemediatedSourceBinding(id: 'huangpu-gov-bund-heritage', publisher: 'Huangpu District Government', scope: '外滩历史文化风貌区、历史建筑年代与多样建筑风格'),
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
