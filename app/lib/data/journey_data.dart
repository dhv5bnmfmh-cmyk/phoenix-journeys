class WordEntry {
  const WordEntry({
    required this.word,
    required this.pinyin,
    required this.simpleChinese,
    required this.translation,
    required this.symbol,
  });

  final String word;
  final String pinyin;
  final String simpleChinese;
  final String translation;
  final String symbol;
}

const storyParagraphs = [
  '清晨，北京的天空刚刚泛白。你站在一扇巨大的红色宫门前，微风从护城河上轻轻吹来。',
  '厚重的宫门慢慢打开。红墙、金色屋顶和宽阔的石路，一点一点出现在你的眼前。',
  '这里曾经是皇帝生活和处理国家事务的地方。今天，它被称为故宫，也被世界认识为紫禁城。',
  '你不是来背诵年代的。你是来看看，一座宫殿怎样保存一个国家数百年的记忆。',
];

const words = [
  WordEntry(
    word: '清晨',
    pinyin: 'qīngchén',
    simpleChinese: '天刚亮不久的早晨。',
    translation: 'Sáng sớm, lúc trời vừa sáng.',
    symbol: '🌅',
  ),
  WordEntry(
    word: '泛白',
    pinyin: 'fànbái',
    simpleChinese: '颜色慢慢变白或变亮。',
    translation: 'Dần chuyển sang màu trắng hoặc sáng lên.',
    symbol: '🌤️',
  ),
  WordEntry(
    word: '宫门',
    pinyin: 'gōngmén',
    simpleChinese: '宫殿或皇宫的门。',
    translation: 'Cổng cung điện hoặc hoàng cung.',
    symbol: '🚪',
  ),
  WordEntry(
    word: '微风',
    pinyin: 'wēifēng',
    simpleChinese: '轻轻吹来的风。',
    translation: 'Gió nhẹ.',
    symbol: '🍃',
  ),
  WordEntry(
    word: '护城河',
    pinyin: 'hùchénghé',
    simpleChinese: '围绕城墙或重要建筑、用于防护的河。',
    translation: 'Hào nước bao quanh thành hoặc công trình để phòng thủ.',
    symbol: '🌊',
  ),
  WordEntry(
    word: '厚重',
    pinyin: 'hòuzhòng',
    simpleChinese: '又厚又重，也可以形容感觉庄重、沉稳。',
    translation: 'Dày và nặng; cũng có thể chỉ cảm giác trang nghiêm, vững chãi.',
    symbol: '🧱',
  ),
  WordEntry(
    word: '红墙',
    pinyin: 'hóngqiáng',
    simpleChinese: '红色的墙，故宫建筑的重要视觉特征之一。',
    translation: 'Bức tường màu đỏ.',
    symbol: '🟥',
  ),
  WordEntry(
    word: '屋顶',
    pinyin: 'wūdǐng',
    simpleChinese: '建筑物最上面的覆盖部分。',
    translation: 'Mái nhà hoặc phần trên cùng của công trình.',
    symbol: '🏠',
  ),
  WordEntry(
    word: '宽阔',
    pinyin: 'kuānkuò',
    simpleChinese: '面积大、空间开阔。',
    translation: 'Rộng rãi, thoáng rộng.',
    symbol: '↔️',
  ),
  WordEntry(
    word: '皇帝',
    pinyin: 'huángdì',
    simpleChinese: '中国古代最高统治者的称号。',
    translation: 'Hoàng đế, danh xưng của người cai trị tối cao thời cổ đại.',
    symbol: '👑',
  ),
  WordEntry(
    word: '国家事务',
    pinyin: 'guójiā shìwù',
    simpleChinese: '与国家管理和运行有关的事情。',
    translation: 'Công việc liên quan đến quản lý và vận hành quốc gia.',
    symbol: '📜',
  ),
  WordEntry(
    word: '故宫',
    pinyin: 'Gùgōng',
    simpleChinese: '中国古代皇宫建筑群，现在是一座博物院。',
    translation: 'Cố Cung tại Bắc Kinh, nay là một bảo tàng lớn.',
    symbol: '🏯',
  ),
  WordEntry(
    word: '紫禁城',
    pinyin: 'Zǐjìnchéng',
    simpleChinese: '北京故宫在历史上的名称。',
    translation: 'Tử Cấm Thành, tên lịch sử của Cố Cung Bắc Kinh.',
    symbol: '🏯',
  ),
  WordEntry(
    word: '背诵',
    pinyin: 'bèisòng',
    simpleChinese: '不看文字，把学过的内容说出来。',
    translation: 'Học thuộc và đọc lại mà không nhìn văn bản.',
    symbol: '🗣️',
  ),
  WordEntry(
    word: '年代',
    pinyin: 'niándài',
    simpleChinese: '一段历史时期，或某件事发生的时代。',
    translation: 'Niên đại hoặc một giai đoạn lịch sử.',
    symbol: '🕰️',
  ),
  WordEntry(
    word: '宫殿',
    pinyin: 'gōngdiàn',
    simpleChinese: '古代帝王居住、办公或举行典礼的大型建筑。',
    translation: 'Cung điện.',
    symbol: '🏰',
  ),
  WordEntry(
    word: '保存',
    pinyin: 'bǎocún',
    simpleChinese: '使事物继续存在，不被破坏或丢失。',
    translation: 'Bảo tồn, lưu giữ để không bị mất hoặc hư hỏng.',
    symbol: '🛡️',
  ),
  WordEntry(
    word: '记忆',
    pinyin: 'jìyì',
    simpleChinese: '人记住的经历、知识或印象。',
    translation: 'Ký ức hoặc điều được ghi nhớ.',
    symbol: '🧠',
  ),
  WordEntry(
    word: '午门',
    pinyin: 'Wǔmén',
    simpleChinese: '故宫南面的主要入口，也是重要礼仪空间。',
    translation: 'Ngọ Môn, cổng chính phía nam của Tử Cấm Thành.',
    symbol: '🚪',
  ),
  WordEntry(
    word: '太和殿',
    pinyin: 'Tàihédiàn',
    simpleChinese: '故宫中重要的大殿，古代用于举行重大典礼。',
    translation: 'Điện Thái Hòa, nơi tổ chức các nghi lễ lớn.',
    symbol: '🏛️',
  ),
  WordEntry(
    word: '文物',
    pinyin: 'wénwù',
    simpleChinese: '历史留下来的、具有文化或研究价值的物品。',
    translation: 'Di vật văn hóa hoặc hiện vật lịch sử.',
    symbol: '🏺',
  ),
];

const discoveries = [
  '故宫并不是一栋建筑，而是由大量宫殿、院落和通道组成的建筑群。',
  '红墙与黄色琉璃瓦不仅形成强烈视觉识别，也与传统礼制和皇权象征有关。',
  '木结构带来灵活与美感，同时也使防火成为长期而重要的管理问题。',
  '故宫今天既是文化遗产，也是持续进行保护、研究和公众教育的博物馆。',
];

const wonderQuestion = '如果你能在故宫安静地停留一个小时，你最想观察哪里？为什么？';
const expressQuestion = '请用两到三句话介绍你最想看的故宫建筑或场景。';
