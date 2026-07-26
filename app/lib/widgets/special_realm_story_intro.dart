import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class SpecialRealmStoryIntro extends StatelessWidget {
  const SpecialRealmStoryIntro({
    super.key,
    required this.journeyId,
    required this.displayText,
  });

  final String journeyId;
  final String Function(String) displayText;

  static bool supports(String journeyId) {
    return const {
      'literary-roaming',
      'myth-tracing',
      'strange-night-talks',
      'folk-secret-land',
    }.contains(journeyId);
  }

  @override
  Widget build(BuildContext context) {
    final data = _data[journeyId]!;
    return Container(
      key: ValueKey('special-story-intro-$journeyId'),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            data.accent.withValues(alpha: .34),
            Colors.black.withValues(alpha: .32),
            data.secondary.withValues(alpha: .22),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: data.accent.withValues(alpha: .55)),
        boxShadow: [
          BoxShadow(
            color: data.accent.withValues(alpha: .14),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  data.secondary.withValues(alpha: .9),
                  data.accent.withValues(alpha: .7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: data.secondary.withValues(alpha: .36),
                  blurRadius: 12,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(data.symbol, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayText(data.chapter),
                  style: const TextStyle(
                    color: PhoenixTheme.gold,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .7,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  displayText(data.hook),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    height: 1.28,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryIntroData {
  const _StoryIntroData({
    required this.chapter,
    required this.hook,
    required this.symbol,
    required this.accent,
    required this.secondary,
  });

  final String chapter;
  final String hook;
  final String symbol;
  final Color accent;
  final Color secondary;
}

const _data = <String, _StoryIntroData>{
  'literary-roaming': _StoryIntroData(
    chapter: '异境第一卷 · 梦蝶无门',
    hook: '你醒来时，蝴蝶正替你做完一个尚未结束的梦。两条路都写着“醒来”，但只有一条留下你的影子。',
    symbol: '🦋',
    accent: Color(0xFF7867F2),
    secondary: Color(0xFF67DDF5),
  ),
  'myth-tracing': _StoryIntroData(
    chapter: '异境第二卷 · 月宫遗简',
    hook: '满月送来一页写着“归去”的竹简。桂树深处，有人已经等待这两个字一千年。',
    symbol: '🌕',
    accent: Color(0xFF688BCB),
    secondary: Color(0xFFFFD778),
  ),
  'strange-night-talks': _StoryIntroData(
    chapter: '异境第三卷 · 无影夜契',
    hook: '客栈住进一名没有影子的客人。他留下的铜钱很冷，门外呼唤你的声音却比记忆还真。',
    symbol: '🏮',
    accent: Color(0xFF8B182A),
    secondary: Color(0xFFFF7A3A),
  ),
  'folk-secret-land': _StoryIntroData(
    chapter: '异境第四卷 · 逆流灯书',
    hook: '万灯顺流，只有写着你名字的那一盏逆水而来。水中的你，比岸上的你老了很多年。',
    symbol: '🌊',
    accent: Color(0xFF4D5FD6),
    secondary: Color(0xFFFFA45A),
  ),
};
