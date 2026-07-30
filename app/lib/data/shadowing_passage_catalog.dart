import 'package:flutter/foundation.dart';

@immutable
class ShadowingPassage {
  const ShadowingPassage({
    required this.id,
    required this.title,
    required this.level,
    required this.theme,
    required this.sentences,
  });

  final String id;
  final String title;
  final int level;
  final String theme;
  final List<String> sentences;

  String get text => sentences.join();
  int get characterCount => text.runes.length;
  int get estimatedMinutes => (characterCount / 80).ceil().clamp(1, 9);
}

const shadowingPassages = <ShadowingPassage>[
  ShadowingPassage(
    id: 'morning-market',
    title: '清晨的市场',
    level: 1,
    theme: '日常生活',
    sentences: [
      '天刚亮，市场里已经很热闹。',
      '有人买菜，有人坐下来吃早餐。',
      '我听见老板笑着说：“慢慢选，都是今天的新鲜菜。”',
    ],
  ),
  ShadowingPassage(
    id: 'rainy-bus-stop',
    title: '雨天的公交站',
    level: 2,
    theme: '城市观察',
    sentences: [
      '下午突然下起大雨，公交站里挤满了人。',
      '一位学生把雨伞往旁边移了移，给老人留出位置。',
      '车来了，大家没有着急，而是一个接一个地上车。',
    ],
  ),
  ShadowingPassage(
    id: 'old-lane-teahouse',
    title: '老巷里的茶馆',
    level: 4,
    theme: '地方文化',
    sentences: [
      '老巷尽头有一家小茶馆，门口挂着一块已经褪色的木牌。',
      '客人一边喝茶，一边听老板讲这条街过去的故事。',
      '窗外的城市不断变化，茶馆里的时间却好像走得慢一些。',
    ],
  ),
  ShadowingPassage(
    id: 'lake-evening',
    title: '湖边的傍晚',
    level: 6,
    theme: '旅行感受',
    sentences: [
      '傍晚的风从湖面吹来，把白天的暑气慢慢带走。',
      '远处的灯光倒映在水里，随着波纹一层一层地散开。',
      '旅行者没有急着拍照，只是站在岸边，认真记住眼前的颜色和声音。',
    ],
  ),
  ShadowingPassage(
    id: 'city-memory',
    title: '一座城市的记忆',
    level: 8,
    theme: '文化思考',
    sentences: [
      '城市更新常常意味着更便利的生活，也可能让熟悉的街道逐渐失去原来的样子。',
      '真正有价值的保护，并不是把旧建筑与现实隔开，而是让它们继续参与今天的生活。',
      '当居民仍愿意在这里停留、交谈和庆祝时，历史才不只是展板上的说明。',
    ],
  ),
  ShadowingPassage(
    id: 'journey-and-language',
    title: '旅行与语言',
    level: 10,
    theme: '深度表达',
    sentences: [
      '学习一门语言的意义，不只在于准确地交换信息，也在于理解另一种观察世界的方式。',
      '当旅行者能够听懂一句玩笑、回应一次善意，陌生的城市便不再只是地图上的目的地。',
      '语言让短暂的相遇留下温度，而旅行又把书本里的词语变成可以触摸和回忆的经验。',
    ],
  ),
];

List<ShadowingPassage> shadowingPassagesForLevel(int level) {
  final safeLevel = level.clamp(1, 10);
  final available = shadowingPassages
      .where((passage) => passage.level <= safeLevel + 1)
      .toList(growable: false);
  return available.isEmpty ? shadowingPassages.take(1).toList() : available;
}
