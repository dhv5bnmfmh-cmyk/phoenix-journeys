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
    word: '故宫',
    pinyin: 'Gùgōng',
    simpleChinese: '中国古代皇宫建筑群，现在是一座博物院。',
    translation: 'Tử Cấm Thành / Cố Cung tại Bắc Kinh.',
    symbol: '🏯',
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
  WordEntry(
    word: '宫殿',
    pinyin: 'gōngdiàn',
    simpleChinese: '古代帝王居住、办公或举行典礼的大型建筑。',
    translation: 'Cung điện.',
    symbol: '🏰',
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
