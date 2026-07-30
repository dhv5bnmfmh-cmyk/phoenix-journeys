import 'package:flutter/foundation.dart';

import '../services/shadowing_training_history.dart';

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

  ShadowingPassage copyWith({
    String? id,
    String? title,
    int? level,
    String? theme,
    List<String>? sentences,
  }) {
    return ShadowingPassage(
      id: id ?? this.id,
      title: title ?? this.title,
      level: level ?? this.level,
      theme: theme ?? this.theme,
      sentences: sentences ?? this.sentences,
    );
  }
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
    id: 'station-first-trip',
    title: '第一次独自出发',
    level: 1,
    theme: '旅行启程',
    sentences: [
      '我背好小包，提前来到车站。',
      '车票、手机和水都已经准备好了。',
      '列车开动时，我看着窗外，心里又紧张又期待。',
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
    id: 'night-study-room',
    title: '夜里的自习室',
    level: 3,
    theme: '勤学成长',
    sentences: [
      '晚饭以后，自习室里还亮着灯。',
      '有人练听力，有人把今天的生词重新写了一遍。',
      '窗外很安静，翻书和写字的声音让人慢慢静下心来。',
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
    id: 'museum-time-bridge',
    title: '博物馆里的时间桥',
    level: 5,
    theme: '古今相遇',
    sentences: [
      '展柜里的一封旧信，记录了百年前一次漫长的远行。',
      '旁边的电子地图，把古人的路线重新呈现在今天的城市上。',
      '站在两种时代之间，我忽然明白，出发和思念从来没有真正改变。',
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
    id: 'work-study-journey',
    title: '边工作边看世界',
    level: 7,
    theme: '勤工俭学',
    sentences: [
      '白天完成工作以后，他把晚上的时间留给语言学习。',
      '每存下一点旅费，他就在地图上标记一个想去的地方。',
      '这段旅程走得不快，却让每一次出发都带着努力换来的踏实感。',
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
    id: 'mountain-letter',
    title: '山路上的一封信',
    level: 9,
    theme: '旅途叙事',
    sentences: [
      '山路被晨雾遮住以后，原本熟悉的方向忽然变得难以判断。',
      '同行的人没有催促，而是在路边读起一封从故乡寄来的信。',
      '那些平常的话语在陌生的山谷里显得格外清楚，也让人重新找到继续前行的勇气。',
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
  ShadowingPassage(
    id: 'ancient-modern-phoenix',
    title: '古城上空的凤凰',
    level: 10,
    theme: '古今想象',
    sentences: [
      '古城的屋脊保存着旧时代的秩序，而远处的高楼正把新的生活带向天际线。',
      '想象中的凤凰从两者之间飞过，它没有选择停在过去，也没有催促人们忘记来处。',
      '真正有力量的成长，是带着记忆继续向前，让传统和现代在同一座城市里彼此照亮。',
    ],
  ),
];

List<ShadowingPassage> _availableShadowingPassagesForLevel(int level) {
  final safeLevel = level.clamp(1, 10);
  final available = shadowingPassages
      .where((passage) => passage.level <= safeLevel + 1)
      .toList(growable: false);
  return available.isEmpty ? shadowingPassages.take(1).toList() : available;
}

ShadowingPassage? _passageById(
  Iterable<ShadowingPassage> passages,
  String? passageId,
) {
  if (passageId == null) return null;
  for (final passage in passages) {
    if (passage.id == passageId) return passage;
  }
  return null;
}

String _recommendationReason(
  ShadowingPassage passage,
  Map<String, int> bestScores,
  DateTime day,
) {
  final completedScore = shadowingScoreCompletedOnDay(
    passage.id,
    date: day,
  );
  if (completedScore != null) return '✓ 今日已完成 $completedScore 分';
  if (bestScores.isEmpty) return '适合当前等级';
  final score = bestScores[passage.id] ?? 0;
  if (score == 0) return '新内容优先';
  if (score < 75) return '薄弱内容巩固';
  return '每日轮换';
}

List<ShadowingPassage> shadowingPassagesForLevel(
  int level, {
  DateTime? date,
  Map<String, int> bestScores = const <String, int>{},
}) {
  final day = date ?? DateTime.now();
  final available = _availableShadowingPassagesForLevel(level);
  final resolvedScores =
      bestScores.isEmpty ? recentBestShadowingScores() : bestScores;
  final rememberedId = rememberedShadowingDailyRecommendationForLevel(
    level,
    date: day,
  );
  final recommendation = _passageById(available, rememberedId) ??
      recommendedShadowingPassageForLevel(
        level,
        date: day,
        bestScores: resolvedScores,
      );
  rememberShadowingDailyRecommendation(
    level: level,
    passageId: recommendation.id,
    date: day,
  );
  final recommendedCard = recommendation.copyWith(
    theme:
        '今日推荐 · ${_recommendationReason(recommendation, resolvedScores, day)} · ${recommendation.theme}',
  );
  return <ShadowingPassage>[
    recommendedCard,
    ...available.where((passage) => passage.id != recommendation.id),
  ];
}

ShadowingPassage recommendedShadowingPassageForLevel(
  int level, {
  DateTime? date,
  Map<String, int> bestScores = const <String, int>{},
}) {
  final safeLevel = level.clamp(1, 10);
  final nearby = shadowingPassages
      .where(
        (passage) =>
            passage.level >= safeLevel - 1 && passage.level <= safeLevel + 1,
      )
      .toList(growable: false);
  final candidates = nearby.isEmpty
      ? _availableShadowingPassagesForLevel(safeLevel)
      : nearby;
  final lowestScore = candidates
      .map((passage) => bestScores[passage.id] ?? 0)
      .reduce((current, next) => current < next ? current : next);
  final priorityCandidates = candidates
      .where((passage) => (bestScores[passage.id] ?? 0) == lowestScore)
      .toList(growable: false);
  final day = date ?? DateTime.now();
  final dayKey = DateTime.utc(day.year, day.month, day.day)
      .difference(DateTime.utc(2026))
      .inDays;
  final index = (dayKey + safeLevel * 7).abs() % priorityCandidates.length;
  return priorityCandidates[index];
}
