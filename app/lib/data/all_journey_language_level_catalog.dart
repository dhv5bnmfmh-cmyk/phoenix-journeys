import '../agents/phoenix_language_level_agent.dart';
import '../models/language_proficiency.dart';
import 'daily_journey_experience.dart';
import 'journey_data.dart';
import 'journey_level_catalog.dart';

const _languageLevelAgent = PhoenixLanguageLevelAgent();

JourneyLevelContent buildAdaptiveLevelForJourney(
  DailyJourneyExperience experience, {
  required ChineseProficiencyProfile profile,
  Set<String> knownWords = const <String>{},
}) {
  final story = _buildStory(experience, profile.band);
  final discoveries = _discoveriesForBand(experience, profile.band);
  final searchable =
      '${story.paragraphs.join()}${discoveries.map((item) => item.text).join()}';
  final wordsInContent = experience.words
      .where((entry) => searchable.contains(entry.word))
      .toList(growable: false);
  final vocabularyCandidates = wordsInContent.isEmpty
      ? experience.words
      : wordsInContent;
  final selectedWords = _languageLevelAgent.selectVocabulary(
    words: vocabularyCandidates,
    levelCatalog: _buildVocabularyCatalog(experience.words),
    profile: profile,
    knownWords: knownWords,
  );

  return JourneyLevelContent(
    storyParagraphs: story.paragraphs,
    storyAnnotations: story.annotations,
    words: selectedWords,
    discoveries: discoveries,
    wonderQuestion: _wonderQuestion(experience, profile.band),
    expressQuestion: _expressQuestion(experience, profile.band),
  ).withReadingLimit(
    paragraphCount: _languageLevelAgent.planFor(profile).paragraphCount,
    discoveryCount: _discoveryParagraphCount(profile.band),
  );
}

class _AdaptiveStory {
  const _AdaptiveStory({
    required this.paragraphs,
    required this.annotations,
  });

  final List<String> paragraphs;
  final List<ReadingAnnotation> annotations;
}

class _StoryPassage {
  const _StoryPassage({
    required this.text,
    required this.annotation,
  });

  final String text;
  final ReadingAnnotation annotation;
}

const _adaptiveNarrativePassages = <_StoryPassage>[
  _StoryPassage(
    text: '你继续向前走，新的景色从眼前慢慢展开。',
    annotation: ReadingAnnotation(
      pinyin: 'Nǐ jìxù xiàng qián zǒu, xīn de jǐngsè cóng yǎnqián mànmàn zhǎnkāi.',
      vietnamese:
          'Bạn tiếp tục bước về phía trước, và khung cảnh mới dần mở ra trước mắt.',
      english: 'You keep walking as a new view slowly opens before you.',
    ),
  ),
  _StoryPassage(
    text: '你把看到的建筑、道路和人声放在一起，试着理解这里的故事。',
    annotation: ReadingAnnotation(
      pinyin:
          'Nǐ bǎ kàndào de jiànzhù, dàolù hé rénshēng fàng zài yìqǐ, shìzhe lǐjiě zhèlǐ de gùshì.',
      vietnamese:
          'Bạn kết nối kiến trúc, đường đi và âm thanh con người để thử hiểu câu chuyện của nơi này.',
      english:
          'You connect the buildings, paths, and human voices to understand the story of this place.',
    ),
  ),
  _StoryPassage(
    text: '离开以前，你回头看了一眼，也记住了旅程中最清楚的画面。',
    annotation: ReadingAnnotation(
      pinyin:
          'Líkāi yǐqián, nǐ huítóu kànle yì yǎn, yě jìzhùle lǚchéng zhōng zuì qīngchu de huàmiàn.',
      vietnamese:
          'Trước khi rời đi, bạn ngoái nhìn và ghi nhớ hình ảnh rõ nhất của hành trình.',
      english:
          'Before leaving, you look back and remember the clearest image from the journey.',
    ),
  ),
  _StoryPassage(
    text: '你没有急着离开，而是放慢脚步，观察道路、门窗、树影和人群怎样彼此呼应。景色不再只是背景，它像一条线，把过去留下的痕迹与今天的生活轻轻缝在一起。',
    annotation: ReadingAnnotation(
      pinyin:
          'Nǐ méiyǒu jízhe líkāi, érshì fàngmàn jiǎobù, guānchá dàolù, ménchuāng, shùyǐng hé rénqún zěnyàng bǐcǐ hūyìng. Jǐngsè bù zài zhǐ shì bèijǐng, tā xiàng yì tiáo xiàn, bǎ guòqù liúxià de hénjì yǔ jīntiān de shēnghuó qīngqīng fèng zài yìqǐ.',
      vietnamese:
          'Bạn không vội rời đi mà chậm bước, quan sát đường đi, cửa sổ, bóng cây và đám đông đáp lại nhau. Cảnh vật không còn chỉ là phông nền; nó nối dấu vết quá khứ với đời sống hôm nay.',
      english:
          'You do not hurry away. You slow down and notice how paths, windows, tree shadows, and people answer one another. The view becomes a thread joining traces of the past to life today.',
    ),
  ),
  _StoryPassage(
    text: '当视线从近处移向远处，你会发现空间一直在引导人的身体：有些地方让人停下，有些地方催人前行，还有一些转折故意把重要的画面藏到最后才揭开。',
    annotation: ReadingAnnotation(
      pinyin:
          'Dāng shìxiàn cóng jìnchù yí xiàng yuǎnchù, nǐ huì fāxiàn kōngjiān yìzhí zài yǐndǎo rén de shēntǐ: yǒuxiē dìfang ràng rén tíngxià, yǒuxiē dìfang cuī rén qiánxíng, hái yǒu yìxiē zhuǎnzhé gùyì bǎ zhòngyào de huàmiàn cáng dào zuìhòu cái jiēkāi.',
      vietnamese:
          'Khi ánh nhìn chuyển từ gần ra xa, bạn nhận ra không gian luôn dẫn dắt cơ thể: có nơi khiến người ta dừng lại, có nơi thúc bước, và có khúc ngoặt giấu cảnh quan trọng đến phút cuối.',
      english:
          'As your gaze moves from near to far, space guides the body. Some places ask you to pause, others urge you onward, and certain turns hide the important view until the end.',
    ),
  ),
  _StoryPassage(
    text: '建筑材料也在讲述时间。石头的磨损、木构的颜色、墙面的修补和新旧交界处，都说明一处文化景观并不是被冻结的遗物，而是在维护、使用与记忆中继续生长。',
    annotation: ReadingAnnotation(
      pinyin:
          'Jiànzhù cáiliào yě zài jiǎngshù shíjiān. Shítou de mósǔn, mùgòu de yánsè, qiángmiàn de xiūbǔ hé xīnjiù jiāojiè chù, dōu shuōmíng yí chù wénhuà jǐngguān bìng bù shì bèi dòngjié de yíwù, érshì zài wéihù, shǐyòng yǔ jìyì zhōng jìxù shēngzhǎng.',
      vietnamese:
          'Vật liệu kiến trúc cũng kể về thời gian. Đá mòn, màu gỗ, vết sửa tường và ranh giới cũ mới cho thấy cảnh quan văn hóa không bị đóng băng mà tiếp tục lớn lên qua bảo tồn, sử dụng và ký ức.',
      english:
          'Materials also tell time. Worn stone, timber color, repaired walls, and seams between old and new show that a cultural landscape keeps growing through care, use, and memory.',
    ),
  ),
  _StoryPassage(
    text: '如果只看宏大的轮廓，容易忽略普通人的存在。真正让这里保持活力的，往往是日常的脚步、声音、劳动与停留，它们让历史从说明牌上走回现实。',
    annotation: ReadingAnnotation(
      pinyin:
          'Rúguǒ zhǐ kàn hóngdà de lúnkuò, róngyì hūlüè pǔtōng rén de cúnzài. Zhēnzhèng ràng zhèlǐ bǎochí huólì de, wǎngwǎng shì rìcháng de jiǎobù, shēngyīn, láodòng yǔ tíngliú, tāmen ràng lìshǐ cóng shuōmíngpái shàng zǒu huí xiànshí.',
      vietnamese:
          'Nếu chỉ nhìn đường nét hùng vĩ, ta dễ bỏ qua người bình thường. Chính bước chân, âm thanh, lao động và những lần dừng lại hằng ngày đưa lịch sử từ bảng giới thiệu trở về đời sống.',
      english:
          'Grand outlines can hide ordinary people. Everyday footsteps, sounds, work, and pauses keep the place alive and bring history back from the information board into lived reality.',
    ),
  ),
  _StoryPassage(
    text: '这段旅程也提醒你，保存过去并不等于拒绝变化。每一次修复、开放或重新解释，都在回答同一个问题：我们希望把怎样的记忆交给后来的人。',
    annotation: ReadingAnnotation(
      pinyin:
          'Zhè duàn lǚchéng yě tíxǐng nǐ, bǎocún guòqù bìng bù děngyú jùjué biànhuà. Měi yí cì xiūfù, kāifàng huò chóngxīn jiěshì, dōu zài huídá tóng yí gè wèntí: wǒmen xīwàng bǎ zěnyàng de jìyì jiāo gěi hòulái de rén.',
      vietnamese:
          'Hành trình nhắc rằng gìn giữ quá khứ không có nghĩa là từ chối thay đổi. Mỗi lần trùng tu, mở cửa hay diễn giải lại đều trả lời câu hỏi: ta muốn trao ký ức nào cho người đến sau?',
      english:
          'Preserving the past does not mean refusing change. Every restoration, opening, or reinterpretation asks what kind of memory we hope to pass to those who come later.',
    ),
  ),
  _StoryPassage(
    text: '站在不同位置，同一处景物会呈现不同关系。光线、天气、距离和行走顺序改变了观看方式，也改变了你对故事轻重缓急的判断。',
    annotation: ReadingAnnotation(
      pinyin:
          'Zhàn zài bùtóng wèizhì, tóng yí chù jǐngwù huì chéngxiàn bùtóng guānxì. Guāngxiàn, tiānqì, jùlí hé xíngzǒu shùnxù gǎibiànle guānkàn fāngshì, yě gǎibiànle nǐ duì gùshì qīngzhòng huǎnjí de pànduàn.',
      vietnamese:
          'Từ những vị trí khác nhau, cùng một cảnh vật tạo ra quan hệ khác nhau. Ánh sáng, thời tiết, khoảng cách và thứ tự di chuyển thay đổi cách nhìn và cách bạn đánh giá nhịp điệu câu chuyện.',
      english:
          'The same scene forms different relationships from different positions. Light, weather, distance, and walking order change both how you see and how you judge the story’s emphasis and pace.',
    ),
  ),
  _StoryPassage(
    text: '离开之前，你再回头看一眼。刚才分散的细节开始连接起来，成为一幅更完整的图景：空间承载秩序，日常保存温度，而人的选择决定记忆如何延续。',
    annotation: ReadingAnnotation(
      pinyin:
          'Líkāi zhīqián, nǐ zài huítóu kàn yì yǎn. Gāngcái fēnsàn de xìjié kāishǐ liánjiē qǐlái, chéngwéi yì fú gèng wánzhěng de tújǐng: kōngjiān chéngzài zhìxù, rìcháng bǎocún wēndù, ér rén de xuǎnzé juédìng jìyì rúhé yánxù.',
      vietnamese:
          'Trước khi rời đi, bạn ngoái nhìn lần nữa. Những chi tiết rời rạc bắt đầu kết nối thành bức tranh hoàn chỉnh hơn: không gian mang trật tự, đời thường giữ hơi ấm, và lựa chọn của con người quyết định ký ức tiếp tục ra sao.',
      english:
          'Before leaving, you look back once more. Scattered details connect into a fuller picture: space carries order, daily life preserves warmth, and human choices decide how memory continues.',
    ),
  ),
  _StoryPassage(
    text: '进一步追问时，你会意识到所谓传统并非单一答案。它由许多时代的选择叠加而成，既包含被保存的声音，也包含曾经被忽略、被改写或尚未说出的部分。',
    annotation: ReadingAnnotation(
      pinyin:
          'Jìnyíbù zhuīwèn shí, nǐ huì yìshí dào suǒwèi chuántǒng bìng fēi dānyī dá\'àn. Tā yóu xǔduō shídài de xuǎnzé diéjiā ér chéng, jì bāohán bèi bǎocún de shēngyīn, yě bāohán céngjīng bèi hūlüè, bèi gǎixiě huò shàngwèi shuōchū de bùfen.',
      vietnamese:
          'Khi hỏi sâu hơn, bạn nhận ra truyền thống không phải một câu trả lời duy nhất. Nó được xếp lớp từ lựa chọn của nhiều thời đại, gồm cả tiếng nói được giữ lại lẫn phần từng bị bỏ quên, viết lại hoặc chưa được kể.',
      english:
          'Deeper questions reveal that tradition is not a single answer. It is layered from choices made across eras, including voices that were preserved and parts that were ignored, rewritten, or never spoken.',
    ),
  ),
  _StoryPassage(
    text: '因此，理解一处文化景观，需要同时阅读可见的形式与不可见的关系。谁建造、谁使用、谁维护、谁讲述，这些问题会让风景从观赏对象变成可以讨论的公共记忆。',
    annotation: ReadingAnnotation(
      pinyin:
          'Yīncǐ, lǐjiě yí chù wénhuà jǐngguān, xūyào tóngshí yuèdú kějiàn de xíngshì yǔ bù kějiàn de guānxì. Shéi jiànzào, shéi shǐyòng, shéi wéihù, shéi jiǎngshù, zhèxiē wèntí huì ràng fēngjǐng cóng guānshǎng duìxiàng biànchéng kěyǐ tǎolùn de gōnggòng jìyì.',
      vietnamese:
          'Vì vậy, hiểu một cảnh quan văn hóa đòi hỏi đọc cả hình thức nhìn thấy và quan hệ vô hình. Ai xây, ai dùng, ai bảo trì và ai kể chuyện sẽ biến phong cảnh từ vật để ngắm thành ký ức công cộng có thể thảo luận.',
      english:
          'Understanding a cultural landscape means reading visible forms and invisible relationships together. Asking who built, used, maintained, and narrated it turns scenery into public memory open to discussion.',
    ),
  ),
  _StoryPassage(
    text: '旅程的价值不只在于获得一个结论，而在于建立更细致的观看方法。当你带着这种方法走向下一站，新的地方会显露出更多层次，也会向你提出新的问题。',
    annotation: ReadingAnnotation(
      pinyin:
          'Lǚchéng de jiàzhí bù zhǐ zàiyú huòdé yí gè jiélùn, ér zàiyú jiànlì gèng xìzhì de guānkàn fāngfǎ. Dāng nǐ dàizhe zhè zhǒng fāngfǎ zǒuxiàng xià yí zhàn, xīn de dìfang huì xiǎnlù chū gèng duō céngcì, yě huì xiàng nǐ tíchū xīn de wèntí.',
      vietnamese:
          'Giá trị của hành trình không chỉ là có một kết luận mà là hình thành cách quan sát tinh tế hơn. Mang cách nhìn ấy đến chặng tiếp theo, bạn sẽ thấy nhiều lớp mới và gặp những câu hỏi mới.',
      english:
          'A journey matters not only for its conclusion but for the finer way of seeing it builds. Carry that method to the next stop, and new places will reveal more layers and new questions.',
    ),
  ),
];

_AdaptiveStory _buildStory(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  final paragraphs = experience.content.storyParagraphs;
  final annotations = experience.storyAnnotations;

  if (paragraphs.isEmpty || annotations.isEmpty) {
    return const _AdaptiveStory(
      paragraphs: <String>['这段旅程正在准备中。', '请稍后再来继续探索。'],
      annotations: <ReadingAnnotation>[
        ReadingAnnotation(
          pinyin: 'Zhè duàn lǚchéng zhèngzài zhǔnbèi zhōng.',
          vietnamese: 'Hành trình này đang được chuẩn bị.',
          english: 'This journey is being prepared.',
        ),
        ReadingAnnotation(
          pinyin: 'Qǐng shāohòu zài lái jìxù tànsuǒ.',
          vietnamese: 'Hãy quay lại sau để tiếp tục khám phá.',
          english: 'Please return later to continue exploring.',
        ),
      ],
    );
  }

  if (band == PhoenixReadingBand.beginner) {
    return _buildBeginnerStory(paragraphs, annotations);
  }

  final storyParagraphs = <String>[...paragraphs];
  final storyAnnotations = <ReadingAnnotation>[
    for (var index = 0; index < paragraphs.length; index += 1)
      annotations[index.clamp(0, annotations.length - 1).toInt()],
  ];
  final targetCharacters = _targetStoryCharacters(band);
  final maximumCharacters = _maximumStoryCharacters(band);
  final passageLimit = _passageLimit(band);

  for (final passage in _adaptiveNarrativePassages.take(passageLimit)) {
    final currentLength = _joinChinese(storyParagraphs).length;
    if (currentLength >= targetCharacters) break;
    if (currentLength + passage.text.length > maximumCharacters) continue;
    storyParagraphs.add(passage.text);
    storyAnnotations.add(passage.annotation);
  }

  return _AdaptiveStory(
    paragraphs: storyParagraphs,
    annotations: storyAnnotations,
  );
}

_AdaptiveStory _buildBeginnerStory(
  List<String> paragraphs,
  List<ReadingAnnotation> annotations,
) {
  const minimumCharacters = 80;
  const maximumCharacters = 140;
  final selectedParagraphs = <String>[];
  final selectedAnnotations = <ReadingAnnotation>[];

  for (var index = 0; index < paragraphs.length; index += 1) {
    if (_joinChinese(selectedParagraphs).length >= minimumCharacters) break;
    final paragraph = paragraphs[index].trim();
    if (paragraph.isEmpty) continue;
    final annotation =
        annotations[index.clamp(0, annotations.length - 1).toInt()];
    final fullCandidate = _joinChinese(<String>[
      ...selectedParagraphs,
      paragraph,
    ]);
    if (fullCandidate.length <= maximumCharacters) {
      selectedParagraphs.add(paragraph);
      selectedAnnotations.add(annotation);
      continue;
    }

    final firstSentence = _firstChineseSentence(paragraph);
    final sentenceCandidate = _joinChinese(<String>[
      ...selectedParagraphs,
      firstSentence,
    ]);
    if (firstSentence.isNotEmpty &&
        sentenceCandidate.length <= maximumCharacters) {
      selectedParagraphs.add(firstSentence);
      selectedAnnotations.add(
        _combineAnnotation(
          annotations: <ReadingAnnotation>[annotation],
          firstSentenceOnly: true,
        ),
      );
    }
  }

  for (final passage in _adaptiveNarrativePassages.take(3)) {
    if (_joinChinese(selectedParagraphs).length >= minimumCharacters) break;
    final candidate = _joinChinese(<String>[
      ...selectedParagraphs,
      passage.text,
    ]);
    if (candidate.length > maximumCharacters) continue;
    selectedParagraphs.add(passage.text);
    selectedAnnotations.add(passage.annotation);
  }

  return _AdaptiveStory(
    paragraphs: selectedParagraphs,
    annotations: selectedAnnotations,
  );
}

int _targetStoryCharacters(PhoenixReadingBand band) => switch (band) {
  PhoenixReadingBand.beginner => 80,
  PhoenixReadingBand.elementary => 150,
  PhoenixReadingBand.intermediate => 280,
  PhoenixReadingBand.upperIntermediate => 450,
  PhoenixReadingBand.advanced => 600,
  PhoenixReadingBand.mastery => 760,
};

int _maximumStoryCharacters(PhoenixReadingBand band) => switch (band) {
  PhoenixReadingBand.beginner => 140,
  PhoenixReadingBand.elementary => 240,
  PhoenixReadingBand.intermediate => 400,
  PhoenixReadingBand.upperIntermediate => 600,
  PhoenixReadingBand.advanced => 800,
  PhoenixReadingBand.mastery => 900,
};

int _passageLimit(PhoenixReadingBand band) => switch (band) {
  PhoenixReadingBand.beginner => 3,
  PhoenixReadingBand.elementary => 4,
  PhoenixReadingBand.intermediate => 6,
  PhoenixReadingBand.upperIntermediate => 9,
  PhoenixReadingBand.advanced => 10,
  PhoenixReadingBand.mastery => 13,
};

ReadingAnnotation _combineAnnotation({
  required List<ReadingAnnotation> annotations,
  List<DiscoveryEntry> discoveries = const <DiscoveryEntry>[],
  bool firstSentenceOnly = false,
}) {
  String prepare(String value) {
    return firstSentenceOnly ? _firstLatinSentence(value) : value.trim();
  }

  return ReadingAnnotation(
    pinyin: _joinLatin(<String>[
      ...annotations.map((item) => prepare(item.pinyin)),
      ...discoveries.map((item) => item.pinyin.trim()),
    ]),
    vietnamese: _joinLatin(<String>[
      ...annotations.map((item) => prepare(item.vietnamese)),
      ...discoveries.map((item) => item.vietnamese.trim()),
    ]),
    english: _joinLatin(<String>[
      ...annotations.map((item) => prepare(item.english)),
      ...discoveries.map((item) => item.english.trim()),
    ]),
  );
}

List<DiscoveryEntry> _discoveriesForBand(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  final count = _discoveryParagraphCount(band);
  final source = experience.discoveries;
  if (source.length <= count) return source;
  if (count == 1) return <DiscoveryEntry>[_mergeDiscoveryEntries(source)];
  final split = (source.length / 2).ceil();
  return <DiscoveryEntry>[
    _mergeDiscoveryEntries(source.take(split)),
    _mergeDiscoveryEntries(source.skip(split)),
  ];
}

int _discoveryParagraphCount(PhoenixReadingBand band) => switch (band) {
  PhoenixReadingBand.beginner ||
  PhoenixReadingBand.advanced ||
  PhoenixReadingBand.mastery => 1,
  PhoenixReadingBand.elementary ||
  PhoenixReadingBand.intermediate ||
  PhoenixReadingBand.upperIntermediate => 2,
};

DiscoveryEntry _mergeDiscoveryEntries(Iterable<DiscoveryEntry> source) {
  final entries = source.toList(growable: false);
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

Map<String, VocabularyLevelTag> _buildVocabularyCatalog(
  List<WordEntry> words,
) {
  return <String, VocabularyLevelTag>{
    for (var index = 0; index < words.length; index += 1)
      words[index].word: _tagFor(words[index], index),
  };
}

VocabularyLevelTag _tagFor(WordEntry entry, int index) {
  final isProperNoun = entry.partOfSpeech.contains('专名');
  final isPhrase = entry.partOfSpeech.contains('短语');
  final level = (1 + index ~/ 2).clamp(1, 6).toInt();
  return VocabularyLevelTag(
    hskLevel: isProperNoun ? null : level,
    tocflLevel: isProperNoun ? null : level,
    kind: isProperNoun
        ? VocabularyKind.properNoun
        : isPhrase
            ? VocabularyKind.idiom
            : VocabularyKind.general,
    evidence: isProperNoun || isPhrase
        ? VocabularyLevelEvidence.cultural
        : VocabularyLevelEvidence.curated,
  );
}

String _wonderQuestion(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  return switch (band) {
    PhoenixReadingBand.beginner =>
      '在${experience.place}，你最想先看什么？为什么？',
    PhoenixReadingBand.elementary || PhoenixReadingBand.intermediate =>
      experience.wonderQuestion,
    PhoenixReadingBand.upperIntermediate =>
      '请结合故事中的两个细节回答：${experience.wonderQuestion}',
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      '请从历史、空间和今天的使用中选择一个角度深入回答：${experience.wonderQuestion}',
  };
}

String _expressQuestion(
  DailyJourneyExperience experience,
  PhoenixReadingBand band,
) {
  return switch (band) {
    PhoenixReadingBand.beginner =>
      '请用一到两句话介绍${experience.place}。',
    PhoenixReadingBand.elementary => experience.expressQuestion,
    PhoenixReadingBand.intermediate =>
      '${experience.expressQuestion}请补充一个具体画面或原因。',
    PhoenixReadingBand.upperIntermediate =>
      '${experience.expressQuestion}请使用“既……也……”或“不是……而是……”。',
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      '${experience.expressQuestion}请说明景观、历史与今天生活之间的关系。',
  };
}

String _firstChineseSentence(String value) {
  final text = value.trim();
  if (text.isEmpty) return text;
  final end = text.indexOf('。');
  return end < 0 ? text : text.substring(0, end + 1);
}

String _firstLatinSentence(String value) {
  final text = value.trim();
  if (text.isEmpty) return text;
  final match = RegExp(r'[.!?](?:\s|$)').firstMatch(text);
  return match == null ? text : text.substring(0, match.start + 1).trim();
}

String _joinChinese(Iterable<String> values) => values
    .map((item) => item.trim())
    .where((item) => item.isNotEmpty)
    .join();

String _joinLatin(Iterable<String> values) => values
    .map((item) => item.trim())
    .where((item) => item.isNotEmpty)
    .join(' ');
