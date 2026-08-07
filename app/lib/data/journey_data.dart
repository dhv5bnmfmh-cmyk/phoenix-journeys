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
    this.usageNote = '',
    this.storySource = '',
    this.firstAppearsAt = 1,
  });

  final String word;
  final String pinyin;
  final String simpleChinese;
  final String translation;
  final String symbol;
  final String partOfSpeech;
  final String englishDefinition;
  final List<WordExample> examples;
  final String usageNote;
  final String storySource;
  final int firstAppearsAt;

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
    simpleChinese: '又厚又有重量感，也可以形容感觉庄重。',
    englishDefinition: 'thick and weighty; substantial',
    translation: 'Dày, nặng và tạo cảm giác vững chắc.',
    symbol: '🧱',
  ),
  WordEntry(
    word: '红墙',
    pinyin: 'hóngqiáng',
    partOfSpeech: '名词',
    simpleChinese: '红色的墙。',
    englishDefinition: 'red wall',
    translation: 'Tường màu đỏ.',
    symbol: '🟥',
  ),
  WordEntry(
    word: '屋顶',
    pinyin: 'wūdǐng',
    partOfSpeech: '名词',
    simpleChinese: '建筑物最上面的覆盖部分。',
    englishDefinition: 'roof',
    translation: 'Mái nhà hoặc mái công trình.',
    symbol: '🏯',
  ),
  WordEntry(
    word: '宽阔',
    pinyin: 'kuānkuò',
    partOfSpeech: '形容词',
    simpleChinese: '空间很大、很开。',
    englishDefinition: 'broad and spacious',
    translation: 'Rộng rãi, thoáng.',
    symbol: '↔️',
  ),
  WordEntry(
    word: '石路',
    pinyin: 'shílù',
    partOfSpeech: '名词',
    simpleChinese: '用石头铺成的路。',
    englishDefinition: 'stone-paved road',
    translation: 'Con đường lát đá.',
    symbol: '🪨',
  ),
  WordEntry(
    word: '皇帝',
    pinyin: 'huángdì',
    partOfSpeech: '名词',
    simpleChinese: '古代国家的最高君主。',
    englishDefinition: 'emperor',
    translation: 'Hoàng đế.',
    symbol: '👑',
  ),
  WordEntry(
    word: '国家事务',
    pinyin: 'guójiā shìwù',
    partOfSpeech: '名词短语',
    simpleChinese: '与国家管理有关的重要事情。',
    englishDefinition: 'affairs of state',
    translation: 'Công việc quốc gia.',
    symbol: '📜',
  ),
  WordEntry(
    word: '故宫',
    pinyin: 'Gùgōng',
    partOfSpeech: '名词（专名）',
    simpleChinese: '北京明清皇宫建筑群及今天的故宫博物院所在地。',
    englishDefinition: 'the Forbidden City / Palace Museum complex in Beijing',
    translation: 'Cố Cung ở Bắc Kinh.',
    symbol: '🏯',
  ),
  WordEntry(
    word: '紫禁城',
    pinyin: 'Zǐjìnchéng',
    partOfSpeech: '名词（专名）',
    simpleChinese: '北京明清两代的皇宫。',
    englishDefinition: 'the Forbidden City',
    translation: 'Tử Cấm Thành.',
    symbol: '🏛️',
  ),
  WordEntry(
    word: '背诵',
    pinyin: 'bèisòng',
    partOfSpeech: '动词',
    simpleChinese: '不看文字，把内容说出来。',
    englishDefinition: 'to recite from memory',
    translation: 'Học thuộc và đọc lại.',
    symbol: '🗣️',
  ),
  WordEntry(
    word: '年代',
    pinyin: 'niándài',
    partOfSpeech: '名词',
    simpleChinese: '历史中的某一时期或年份范围。',
    englishDefinition: 'era or period',
    translation: 'Niên đại, thời kỳ.',
    symbol: '📅',
  ),
  WordEntry(
    word: '宫殿',
    pinyin: 'gōngdiàn',
    partOfSpeech: '名词',
    simpleChinese: '帝王居住、办公或举行典礼的建筑。',
    englishDefinition: 'palace hall or palace building',
    translation: 'Cung điện.',
    symbol: '🏯',
  ),
  WordEntry(
    word: '保存',
    pinyin: 'bǎocún',
    partOfSpeech: '动词',
    simpleChinese: '让东西继续存在，不被破坏或失去。',
    englishDefinition: 'to preserve or keep',
    translation: 'Bảo tồn, lưu giữ.',
    symbol: '🫶',
  ),
  WordEntry(
    word: '数百年',
    pinyin: 'shù bǎi nián',
    partOfSpeech: '数量短语',
    simpleChinese: '几百年的时间。',
    englishDefinition: 'several hundred years',
    translation: 'Vài trăm năm.',
    symbol: '⌛',
  ),
  WordEntry(
    word: '记忆',
    pinyin: 'jìyì',
    partOfSpeech: '名词',
    simpleChinese: '被人或社会记住的过去。',
    englishDefinition: 'memory',
    translation: 'Ký ức.',
    symbol: '🧠',
  ),
];

const discoveries = [
  DiscoveryEntry(
    text: '紫禁城的营建始于明代永乐时期，主要宫殿建筑在十五世纪初形成，并在明清两代长期使用和修缮。',
    pinyin:
        'Zǐjìnchéng de yíngjiàn shǐyú Míngdài Yǒnglè shíqī, zhǔyào gōngdiàn jiànzhù zài shíwǔ shìjì chū xíngchéng, bìng zài Míng Qīng liǎng dài chángqī shǐyòng hé xiūshàn.',
    simpleChinese: '紫禁城在明代开始建设，后来在明清两代长期使用和维修。',
    vietnamese:
        'Tử Cấm Thành bắt đầu được xây dựng dưới thời Vĩnh Lạc nhà Minh; quần thể cung điện chính hình thành vào đầu thế kỷ XV và được sử dụng, tu bổ lâu dài trong hai triều Minh–Thanh.',
    english:
        'Construction of the Forbidden City began in the Yongle reign of the Ming dynasty; its principal palace complex took shape in the early fifteenth century and was used and repaired throughout the Ming and Qing dynasties.',
  ),
  DiscoveryEntry(
    text: '紫禁城位于北京传统城市中轴线上，主要宫殿和宫门按照清晰的轴线与院落关系组织。',
    pinyin:
        'Zǐjìnchéng wèiyú Běijīng chuántǒng chéngshì zhōngzhóu xiàn shàng, zhǔyào gōngdiàn hé gōngmén ànzhào qīngxī de zhóuxiàn yǔ yuànluò guānxì zǔzhī.',
    simpleChinese: '紫禁城的重要建筑沿北京中轴线和院落层次安排。',
    vietnamese:
        'Tử Cấm Thành nằm trên trục trung tâm truyền thống của Bắc Kinh; các cung điện và cổng chính được tổ chức theo trục và hệ thống sân viện rõ ràng.',
    english:
        'The Forbidden City lies on Beijing’s traditional central axis, with major halls and gates organized through clear axial and courtyard relationships.',
  ),
  DiscoveryEntry(
    text: '外朝与重要国家典礼和政务活动联系密切，内廷则与皇帝、后妃等宫廷成员的生活联系更紧密。',
    pinyin:
        'Wàicháo yǔ zhòngyào guójiā diǎnlǐ hé zhèngwù huódòng liánxì mìqiè, Nèitíng zé yǔ huángdì, hòufēi děng gōngtíng chéngyuán de shēnghuó liánxì gèng jǐnmì.',
    simpleChinese: '外朝更偏向国家典礼与政务，内廷更接近宫廷生活。',
    vietnamese:
        'Ngoại triều gắn nhiều hơn với nghi lễ quốc gia và chính vụ, còn Nội đình gắn chặt hơn với đời sống của hoàng đế, hậu phi và các thành viên cung đình.',
    english:
        'The Outer Court was closely associated with major state ceremonies and government affairs, while the Inner Court was more closely tied to the lives of the emperor, imperial consorts, and other palace residents.',
  ),
  DiscoveryEntry(
    text: '太和殿、中和殿、保和殿组成外朝中路的重要建筑序列，但三座殿在历史上的具体用途并不完全相同。',
    pinyin:
        'Tàihé Diàn, Zhōnghé Diàn, Bǎohé Diàn zǔchéng Wàicháo zhōnglù de zhòngyào jiànzhù xùliè, dàn sān zuò diàn zài lìshǐ shàng de jùtǐ yòngtú bìng bù wánquán xiāngtóng.',
    simpleChinese: '外朝三大殿沿中轴排列，但用途不完全一样。',
    vietnamese:
        'Điện Thái Hòa, Trung Hòa và Bảo Hòa tạo thành chuỗi kiến trúc quan trọng trên trục Ngoại triều, nhưng công năng lịch sử của ba điện không hoàn toàn giống nhau.',
    english:
        'The Halls of Supreme, Central, and Preserving Harmony form a major architectural sequence in the Outer Court, but their historical functions were not identical.',
  ),
  DiscoveryEntry(
    text: '乾清门是内廷的重要宫门，也是连接外朝与内廷空间的重要节点；清代这里还曾与御门听政等活动有关。',
    pinyin:
        'Qiánqīng Mén shì Nèitíng de zhòngyào gōngmén, yě shì liánjiē Wàicháo yǔ Nèitíng kōngjiān de zhòngyào jiédiǎn; Qīngdài zhèlǐ hái céng yǔ yùmén tīngzhèng děng huódòng yǒuguān.',
    simpleChinese: '乾清门连接外朝与内廷，历史功能也不只是简单的通道。',
    vietnamese:
        'Càn Thanh Môn là cổng quan trọng của Nội đình và là nút nối với Ngoại triều; dưới thời Thanh, nơi đây còn liên quan đến hoạt động ngự môn thính chính.',
    english:
        'The Gate of Heavenly Purity is a major gate of the Inner Court and an important connection with the Outer Court; in the Qing dynasty it was also associated with court audiences held at the gate.',
  ),
  DiscoveryEntry(
    text: '宫门、院落、轴线和建筑尺度不仅形成视觉秩序，也影响人在宫城中的进入、等待、转向和停留。',
    pinyin:
        'Gōngmén, yuànluò, zhóuxiàn hé jiànzhù chǐdù bùjǐn xíngchéng shìjué zhìxù, yě yǐngxiǎng rén zài gōngchéng zhōng de jìnrù, děngdài, zhuǎnxiàng hé tíngliú.',
    simpleChinese: '紫禁城的建筑安排也会影响人怎样走。',
    vietnamese:
        'Cổng, sân viện, trục và quy mô kiến trúc không chỉ tạo trật tự thị giác mà còn ảnh hưởng cách con người đi vào, chờ đợi, đổi hướng và dừng lại trong cung thành.',
    english:
        'Gates, courtyards, axes, and architectural scale create visual order while also shaping how people enter, wait, turn, and remain within the palace city.',
  ),
];

const wonderQuestion = '如果一道门就在你面前打开，“能够进去”和“应该进去”有什么不同？';
const expressQuestion = '请用两到三句话说明中轴、宫门或院落怎样影响人在紫禁城中的行动。';
