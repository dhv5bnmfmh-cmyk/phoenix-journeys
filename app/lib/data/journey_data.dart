class WordExample {
  const WordExample({
    required this.chinese,
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final String chinese;
  final String pinyin;
  final String vietnamese;
  final String english;

  String nativeText(String language) {
    return switch (language) {
      '英语' => english,
      '双语' => vietnamese,
      '中文解释' => chinese,
      _ => vietnamese,
    };
  }
}

class WordEntry {
  const WordEntry({
    required this.word,
    required this.pinyin,
    required this.simpleChinese,
    required this.translation,
    required this.symbol,
    this.partOfSpeech = '词语',
    this.englishDefinition = '',
    this.examples = const <WordExample>[],
  });

  final String word;
  final String pinyin;
  final String simpleChinese;
  final String translation;
  final String symbol;
  final String partOfSpeech;
  final String englishDefinition;
  final List<WordExample> examples;

  String nativeLabel(String language) {
    return switch (language) {
      '英语' => '探索者语言 · English',
      '双语' => '探索者母语 · 越南语',
      '中文解释' => '简明中文',
      _ => '探索者母语 · 越南语',
    };
  }

  String nativeDefinition(String language) {
    return switch (language) {
      '英语' => englishDefinition,
      '双语' => translation,
      '中文解释' => simpleChinese,
      _ => translation,
    };
  }

  List<WordExample> get studyExamples {
    if (examples.length >= 3) return examples;

    return [
      WordExample(
        chinese: '故事里出现了“$word”这个词。',
        pinyin: 'Gùshì lǐ chūxiàn le “$pinyin” zhège cí.',
        vietnamese: 'Từ “$word” xuất hiện trong câu chuyện.',
        english: 'The word “$word” appears in the story.',
      ),
      WordExample(
        chinese: '老师请我解释“$word”的意思。',
        pinyin: 'Lǎoshī qǐng wǒ jiěshì “$pinyin” de yìsi.',
        vietnamese: 'Giáo viên yêu cầu tôi giải thích nghĩa của “$word”.',
        english: 'The teacher asked me to explain the meaning of “$word”.',
      ),
      WordExample(
        chinese: '我想在旅行中学会使用“$word”。',
        pinyin: 'Wǒ xiǎng zài lǚxíng zhōng xuéhuì shǐyòng “$pinyin”.',
        vietnamese: 'Tôi muốn học cách dùng “$word” trong chuyến đi.',
        english: 'I want to learn how to use “$word” during the journey.',
      ),
    ];
  }
}

class ReadingAnnotation {
  const ReadingAnnotation({
    required this.pinyin,
    required this.vietnamese,
    required this.english,
  });

  final String pinyin;
  final String vietnamese;
  final String english;

  String nativeLabel(String language) {
    return switch (language) {
      '英语' => '探索者语言 · English',
      '双语' => '探索者母语 · 越南语',
      '中文解释' => '简明中文',
      _ => '探索者母语 · 越南语',
    };
  }

  String nativeText(String language, String chinese) {
    return switch (language) {
      '英语' => english,
      '双语' => vietnamese,
      '中文解释' => chinese,
      _ => vietnamese,
    };
  }
}

class DiscoveryEntry {
  const DiscoveryEntry({
    required this.text,
    required this.simpleChinese,
    required this.vietnamese,
    required this.english,
    this.pinyin = '',
  });

  final String text;
  final String simpleChinese;
  final String vietnamese;
  final String english;
  final String pinyin;

  String supportText(String language) {
    return switch (language) {
      '越南语' => vietnamese,
      '英语' => english,
      '双语' => '$vietnamese\n$english',
      _ => simpleChinese,
    };
  }

  String supportLabel(String language) {
    return switch (language) {
      '越南语' => '探索者母语 · 越南语',
      '英语' => 'Explorer language · English',
      '双语' => '探索者语言 · 越南语 / English',
      _ => '简明中文',
    };
  }

  String nativeText(String language) {
    return switch (language) {
      '英语' => english,
      '双语' => vietnamese,
      '中文解释' => simpleChinese,
      _ => vietnamese,
    };
  }

  String nativeLabel(String language) {
    return switch (language) {
      '英语' => '探索者语言 · English',
      '双语' => '探索者母语 · 越南语',
      '中文解释' => '简明中文',
      _ => '探索者母语 · 越南语',
    };
  }
}

const storyParagraphs = [
  '清晨，北京的天空刚刚泛白。你站在一扇巨大的红色宫门前，微风从护城河上轻轻吹来。',
  '厚重的宫门慢慢打开。红墙、金色屋顶和宽阔的石路，一点一点出现在你的眼前。',
  '这里曾经是皇帝生活和处理国家事务的地方。今天，它被称为故宫，也被世界认识为紫禁城。',
  '你不是来背诵年代的。你是来看看，一座宫殿怎样保存一个国家数百年的记忆。',
];

const storyAnnotations = [
  ReadingAnnotation(
    pinyin:
        'Qīngchén, Běijīng de tiānkōng gānggāng fànbái. Nǐ zhàn zài yí shàn jùdà de hóngsè gōngmén qián, wēifēng cóng hùchénghé shàng qīngqīng chuī lái.',
    vietnamese:
        'Sáng sớm, bầu trời Bắc Kinh vừa hửng sáng. Bạn đứng trước một cánh cổng cung điện màu đỏ khổng lồ, làn gió nhẹ thổi từ hào nước bao quanh thành.',
    english:
        'At dawn, the sky over Beijing is just beginning to brighten. You stand before a massive red palace gate as a light breeze drifts across the moat.',
  ),
  ReadingAnnotation(
    pinyin:
        'Hòuzhòng de gōngmén mànmàn dǎkāi. Hóngqiáng, jīnsè wūdǐng hé kuānkuò de shílù, yìdiǎn yìdiǎn chūxiàn zài nǐ de yǎnqián.',
    vietnamese:
        'Cánh cổng nặng nề từ từ mở ra. Những bức tường đỏ, mái vàng và con đường đá rộng lớn dần hiện ra trước mắt bạn.',
    english:
        'The heavy palace gate slowly opens. Red walls, golden roofs, and broad stone paths gradually appear before you.',
  ),
  ReadingAnnotation(
    pinyin:
        'Zhèlǐ céngjīng shì huángdì shēnghuó hé chǔlǐ guójiā shìwù de dìfang. Jīntiān, tā bèi chēngwéi Gùgōng, yě bèi shìjiè rènshi wéi Zǐjìnchéng.',
    vietnamese:
        'Nơi đây từng là chỗ hoàng đế sinh sống và xử lý việc quốc gia. Ngày nay, nơi này được gọi là Cố Cung và được thế giới biết đến với tên Tử Cấm Thành.',
    english:
        'This was once where emperors lived and handled affairs of state. Today it is called the Palace Museum and is known around the world as the Forbidden City.',
  ),
  ReadingAnnotation(
    pinyin:
        'Nǐ bú shì lái bèisòng niándài de. Nǐ shì lái kànkan, yí zuò gōngdiàn zěnyàng bǎocún yí gè guójiā shù bǎi nián de jìyì.',
    vietnamese:
        'Bạn không đến đây để học thuộc niên đại. Bạn đến để xem một cung điện đã lưu giữ ký ức của một đất nước suốt hàng trăm năm như thế nào.',
    english:
        'You are not here to memorize dates. You are here to see how a palace can preserve a nation’s memories across centuries.',
  ),
];

const words = [
  WordEntry(
    word: '清晨',
    pinyin: 'qīngchén',
    partOfSpeech: '名词',
    simpleChinese: '天刚亮不久的早晨。',
    englishDefinition: 'dawn; the early morning shortly after daybreak',
    translation: 'Sáng sớm, lúc trời vừa sáng.',
    symbol: '🌅',
  ),
  WordEntry(
    word: '泛白',
    pinyin: 'fànbái',
    partOfSpeech: '动词',
    simpleChinese: '颜色慢慢变白或变亮。',
    englishDefinition: 'to become pale, whitish, or gradually brighter',
    translation: 'Dần chuyển sang màu trắng hoặc sáng lên.',
    symbol: '🌤️',
  ),
  WordEntry(
    word: '宫门',
    pinyin: 'gōngmén',
    partOfSpeech: '名词',
    simpleChinese: '宫殿或皇宫的门。',
    englishDefinition: 'a gate leading into a palace or imperial compound',
    translation: 'Cổng cung điện hoặc hoàng cung.',
    symbol: '🚪',
  ),
  WordEntry(
    word: '微风',
    pinyin: 'wēifēng',
    partOfSpeech: '名词',
    simpleChinese: '轻轻吹来的风。',
    englishDefinition: 'a gentle or light breeze',
    translation: 'Gió nhẹ.',
    symbol: '🍃',
  ),
  WordEntry(
    word: '护城河',
    pinyin: 'hùchénghé',
    partOfSpeech: '名词',
    simpleChinese: '围绕城墙或重要建筑、用于防护的河。',
    englishDefinition: 'a moat surrounding a city wall or fortified building',
    translation: 'Hào nước bao quanh thành hoặc công trình để phòng thủ.',
    symbol: '🌊',
  ),
  WordEntry(
    word: '厚重',
    pinyin: 'hòuzhòng',
    partOfSpeech: '形容词',
    simpleChinese: '又厚又重，也可以形容感觉庄重、沉稳。',
    englishDefinition: 'thick and heavy; also dignified, substantial, or solemn',
    translation: 'Dày và nặng; cũng có thể chỉ cảm giác trang nghiêm, vững chãi.',
    symbol: '🧱',
  ),
  WordEntry(
    word: '红墙',
    pinyin: 'hóngqiáng',
    partOfSpeech: '名词',
    simpleChinese: '红色的墙，故宫建筑的重要视觉特征之一。',
    englishDefinition: 'a red wall, especially the iconic walls of an imperial complex',
    translation: 'Bức tường màu đỏ.',
    symbol: '🟥',
  ),
  WordEntry(
    word: '屋顶',
    pinyin: 'wūdǐng',
    partOfSpeech: '名词',
    simpleChinese: '建筑物最上面的覆盖部分。',
    englishDefinition: 'the roof or upper covering of a building',
    translation: 'Mái nhà hoặc phần trên cùng của công trình.',
    symbol: '🏠',
  ),
  WordEntry(
    word: '宽阔',
    pinyin: 'kuānkuò',
    partOfSpeech: '形容词',
    simpleChinese: '面积大、空间开阔。',
    englishDefinition: 'broad, wide, or spacious',
    translation: 'Rộng rãi, thoáng rộng.',
    symbol: '↔️',
  ),
  WordEntry(
    word: '皇帝',
    pinyin: 'huángdì',
    partOfSpeech: '名词',
    simpleChinese: '中国古代最高统治者的称号。',
    englishDefinition: 'emperor; the supreme ruler in imperial China',
    translation: 'Hoàng đế, danh xưng của người cai trị tối cao thời cổ đại.',
    symbol: '👑',
  ),
  WordEntry(
    word: '国家事务',
    pinyin: 'guójiā shìwù',
    partOfSpeech: '名词短语',
    simpleChinese: '与国家管理和运行有关的事情。',
    englishDefinition: 'affairs of state; matters concerning national governance',
    translation: 'Công việc liên quan đến quản lý và vận hành quốc gia.',
    symbol: '📜',
  ),
  WordEntry(
    word: '故宫',
    pinyin: 'Gùgōng',
    partOfSpeech: '专有名词',
    simpleChinese: '中国古代皇宫建筑群，现在是一座博物院。',
    englishDefinition: 'the Palace Museum in Beijing, located in the former imperial palace',
    translation: 'Cố Cung tại Bắc Kinh, nay là một bảo tàng lớn.',
    symbol: '🏯',
  ),
  WordEntry(
    word: '紫禁城',
    pinyin: 'Zǐjìnchéng',
    partOfSpeech: '专有名词',
    simpleChinese: '北京故宫在历史上的名称。',
    englishDefinition: 'the Forbidden City, the historical name of Beijing’s imperial palace',
    translation: 'Tử Cấm Thành, tên lịch sử của Cố Cung Bắc Kinh.',
    symbol: '🏯',
  ),
  WordEntry(
    word: '背诵',
    pinyin: 'bèisòng',
    partOfSpeech: '动词',
    simpleChinese: '不看文字，把学过的内容说出来。',
    englishDefinition: 'to recite from memory without looking at the text',
    translation: 'Học thuộc và đọc lại mà không nhìn văn bản.',
    symbol: '🗣️',
  ),
  WordEntry(
    word: '年代',
    pinyin: 'niándài',
    partOfSpeech: '名词',
    simpleChinese: '一段历史时期，或某件事发生的时代。',
    englishDefinition: 'an era, period, or historical age',
    translation: 'Niên đại hoặc một giai đoạn lịch sử.',
    symbol: '🕰️',
  ),
  WordEntry(
    word: '宫殿',
    pinyin: 'gōngdiàn',
    partOfSpeech: '名词',
    simpleChinese: '古代帝王居住、办公或举行典礼的大型建筑。',
    englishDefinition: 'a palace or grand hall used by royalty',
    translation: 'Cung điện.',
    symbol: '🏰',
  ),
  WordEntry(
    word: '保存',
    pinyin: 'bǎocún',
    partOfSpeech: '动词',
    simpleChinese: '使事物继续存在，不被破坏或丢失。',
    englishDefinition: 'to preserve, save, or keep something from being lost or damaged',
    translation: 'Bảo tồn, lưu giữ để không bị mất hoặc hư hỏng.',
    symbol: '🛡️',
  ),
  WordEntry(
    word: '记忆',
    pinyin: 'jìyì',
    partOfSpeech: '名词',
    simpleChinese: '人记住的经历、知识或印象。',
    englishDefinition: 'memory; a remembered experience, fact, or impression',
    translation: 'Ký ức hoặc điều được ghi nhớ.',
    symbol: '🧠',
  ),
  WordEntry(
    word: '午门',
    pinyin: 'Wǔmén',
    partOfSpeech: '专有名词',
    simpleChinese: '故宫南面的主要入口，也是重要礼仪空间。',
    englishDefinition: 'the Meridian Gate, the principal southern entrance to the Forbidden City',
    translation: 'Ngọ Môn, cổng chính phía nam của Tử Cấm Thành.',
    symbol: '🚪',
  ),
  WordEntry(
    word: '太和殿',
    pinyin: 'Tàihédiàn',
    partOfSpeech: '专有名词',
    simpleChinese: '故宫中重要的大殿，古代用于举行重大典礼。',
    englishDefinition: 'the Hall of Supreme Harmony, used for major imperial ceremonies',
    translation: 'Điện Thái Hòa, nơi tổ chức các nghi lễ lớn.',
    symbol: '🏛️',
  ),
  WordEntry(
    word: '文物',
    pinyin: 'wénwù',
    partOfSpeech: '名词',
    simpleChinese: '历史留下来的、具有文化或研究价值的物品。',
    englishDefinition: 'a cultural relic, historical artifact, or heritage object',
    translation: 'Di vật văn hóa hoặc hiện vật lịch sử.',
    symbol: '🏺',
  ),
];

const discoveries = [
  DiscoveryEntry(
    text: '故宫并不是一栋建筑，而是由大量宫殿、院落和通道组成的建筑群。',
    pinyin:
        'Gùgōng bìng bú shì yí dòng jiànzhù, ér shì yóu dàliàng gōngdiàn, yuànluò hé tōngdào zǔchéng de jiànzhùqún.',
    simpleChinese: '故宫由许多建筑和院子共同组成，不是一座单独的房子。',
    vietnamese:
        'Cố Cung không phải là một tòa nhà đơn lẻ, mà là một quần thể gồm nhiều cung điện, sân và lối đi.',
    english:
        'The Forbidden City is not one building, but a complex of many halls, courtyards, and passageways.',
  ),
  DiscoveryEntry(
    text: '红墙与黄色琉璃瓦不仅形成强烈视觉识别，也与传统礼制和皇权象征有关。',
    pinyin:
        'Hóngqiáng yǔ huángsè liúlíwǎ bùjǐn xíngchéng qiángliè shìjué shíbié, yě yǔ chuántǒng lǐzhì hé huángquán xiàngzhēng yǒuguān.',
    simpleChinese: '红墙和黄瓦不只是好看，也代表古代的礼制与皇权。',
    vietnamese:
        'Tường đỏ và ngói lưu ly vàng không chỉ tạo dấu ấn thị giác, mà còn liên quan đến lễ chế truyền thống và biểu tượng hoàng quyền.',
    english:
        'The red walls and yellow glazed tiles are visually distinctive and also symbolize traditional ritual order and imperial authority.',
  ),
  DiscoveryEntry(
    text: '木结构带来灵活与美感，同时也使防火成为长期而重要的管理问题。',
    pinyin:
        'Mù jiégòu dàilái línghuó yǔ měigǎn, tóngshí yě shǐ fánghuǒ chéngwéi chángqī ér zhòngyào de guǎnlǐ wèntí.',
    simpleChinese: '木结构很美，也比较灵活，但需要特别注意防火。',
    vietnamese:
        'Kết cấu gỗ tạo nên vẻ đẹp và sự linh hoạt, nhưng cũng khiến việc phòng cháy trở thành nhiệm vụ lâu dài và rất quan trọng.',
    english:
        'Timber structures offer flexibility and beauty, but they also make fire prevention a long-term priority.',
  ),
  DiscoveryEntry(
    text: '故宫今天既是文化遗产，也是持续进行保护、研究和公众教育的博物馆。',
    pinyin:
        'Gùgōng jīntiān jì shì wénhuà yíchǎn, yě shì chíxù jìnxíng bǎohù, yánjiū hé gōngzhòng jiàoyù de bówùguǎn.',
    simpleChinese: '今天的故宫既是文化遗产，也是进行保护、研究和教育的博物馆。',
    vietnamese:
        'Ngày nay, Cố Cung vừa là di sản văn hóa, vừa là bảo tàng liên tục thực hiện công tác bảo tồn, nghiên cứu và giáo dục công chúng.',
    english:
        'Today, the Palace Museum is both cultural heritage and an active museum for conservation, research, and public education.',
  ),
];

const wonderQuestion = '如果你能在故宫安静地停留一个小时，你最想观察哪里？为什么？';
const expressQuestion = '请用两到三句话介绍你最想看的故宫建筑或场景。';
