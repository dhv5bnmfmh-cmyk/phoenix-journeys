import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

class SpecialJourneyPassport extends StatelessWidget {
  const SpecialJourneyPassport({super.key, required this.state});

  final AppState state;

  static const _journeys = <_SpecialJourneyPreview>[
    _SpecialJourneyPreview(
      id: 'literary-roaming',
      title: '文学漫游',
      subtitle: '跟随诗句进入古城与山水',
      currency: '金币',
      cost: 2,
      icon: Icons.auto_stories_rounded,
      preview: '沿着诗词中的地点前进，在故事、人物和时代之间寻找被藏起来的句子。',
    ),
    _SpecialJourneyPreview(
      id: 'myth-tracing',
      title: '神话寻踪',
      subtitle: '寻找神兽与古老传说的线索',
      currency: '金币',
      cost: 3,
      icon: Icons.brightness_7_rounded,
      preview: '从月宫、龙门与山海异兽留下的痕迹出发，辨认神话中的象征与变化。',
    ),
    _SpecialJourneyPreview(
      id: 'strange-night-talks',
      title: '志怪夜话',
      subtitle: '进入古代夜谈与离奇传闻',
      currency: '银币',
      cost: 3,
      icon: Icons.nights_stay_rounded,
      preview: '夜色降临后，客栈、古镜与无影来客会讲出真假交织的故事。',
    ),
    _SpecialJourneyPreview(
      id: 'folk-secret-land',
      title: '民俗秘境',
      subtitle: '探索节日、习俗与地方记忆',
      currency: '铜币',
      cost: 4,
      icon: Icons.temple_buddhist_rounded,
      preview: '从灯会、庙市与节令食物进入地方生活，理解习俗背后的愿望与记忆。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('passport-special-journeys'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
      decoration: BoxDecoration(
        color: const Color(0xFF231A2D).withValues(alpha: .82),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .42)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: PhoenixTheme.gold,
                size: 15,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  state.displayText('万象奇旅 · 特别旅程'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                state.displayText('钱币开启 · 永久收藏'),
                style: const TextStyle(color: Colors.white60, fontSize: 8.5),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final journey in _journeys) ...[
                  _journeyCard(context, journey),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _journeyCard(BuildContext context, _SpecialJourneyPreview journey) {
    final unlocked = state.isSpecialJourneyUnlocked(journey.id);
    return Material(
      key: ValueKey('special-journey-${journey.id}'),
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _openJourney(context, journey),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 116,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: unlocked
                ? PhoenixTheme.gold.withValues(alpha: .14)
                : Colors.white.withValues(alpha: .075),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: unlocked
                  ? PhoenixTheme.gold.withValues(alpha: .58)
                  : Colors.white12,
            ),
          ),
          child: Row(
            children: [
              Icon(journey.icon, color: PhoenixTheme.gold, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.displayText(journey.title),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      state.displayText(
                        unlocked
                            ? '已收藏'
                            : '${journey.cost} 枚${journey.currency}',
                      ),
                      style: TextStyle(
                        color: unlocked ? PhoenixTheme.gold : Colors.white60,
                        fontSize: 7.8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                unlocked ? Icons.lock_open_rounded : Icons.lock_rounded,
                color: unlocked ? PhoenixTheme.gold : Colors.white38,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openJourney(
    BuildContext context,
    _SpecialJourneyPreview journey,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) => AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          final unlocked = state.isSpecialJourneyUnlocked(journey.id);
          final balance = state.walletBalance(journey.currency);
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 2, 18, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A1E35),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(journey.icon, color: PhoenixTheme.gold),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.displayText(journey.title),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            state.displayText(journey.subtitle),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4E9D0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: PhoenixTheme.gold.withValues(alpha: .36),
                    ),
                  ),
                  child: Text(
                    state.displayText(journey.preview),
                    style: const TextStyle(
                      color: Color(0xFF3A2D22),
                      height: 1.55,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  state.displayText(
                    unlocked
                        ? '这段万象奇旅已经永久收藏，再次打开不会扣币。'
                        : '开启需要 ${journey.cost} 枚${journey.currency} · 当前 $balance 枚',
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: unlocked ? const Color(0xFF315B32) : Colors.black54,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  key: ValueKey('special-journey-action-${journey.id}'),
                  onPressed: unlocked
                      ? () => _showCollectedPreview(sheetContext, journey)
                      : () => _confirmUnlock(sheetContext, journey),
                  style: FilledButton.styleFrom(
                    backgroundColor: unlocked
                        ? const Color(0xFF315B32)
                        : PhoenixTheme.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  icon: Icon(
                    unlocked
                        ? Icons.auto_stories_rounded
                        : Icons.lock_open_rounded,
                  ),
                  label: Text(
                    state.displayText(
                      unlocked
                          ? '打开旅程预览'
                          : '用 ${journey.cost} 枚${journey.currency}开启',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmUnlock(
    BuildContext sheetContext,
    _SpecialJourneyPreview journey,
  ) async {
    final confirmed = await showDialog<bool>(
      context: sheetContext,
      builder: (dialogContext) => AlertDialog(
        title: Text(state.displayText('确认开启 ${journey.title}？')),
        content: Text(
          state.displayText(
            '将扣除 ${journey.cost} 枚${journey.currency}。开启后会永久收藏，不会再次收费。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(state.displayText('暂不开启')),
          ),
          FilledButton(
            key: ValueKey('confirm-special-journey-${journey.id}'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(state.displayText('确认扣币')),
          ),
        ],
      ),
    );
    if (confirmed != true || !sheetContext.mounted) return;

    final result = await state.unlockSpecialJourney(
      journeyId: journey.id,
      currency: journey.currency,
      cost: journey.cost,
    );
    if (!sheetContext.mounted) return;

    final message = switch (result.status) {
      SpecialJourneyUnlockStatus.unlocked => '${journey.title}已开启，并永久收藏。',
      SpecialJourneyUnlockStatus.alreadyUnlocked =>
        '${journey.title}已经收藏，不会再次扣币。',
      SpecialJourneyUnlockStatus.insufficientFunds =>
        '${journey.currency}不足，还需要 ${result.missing} 枚。',
      SpecialJourneyUnlockStatus.busy => '正在处理，请稍候再试。',
    };
    ScaffoldMessenger.of(
      sheetContext,
    ).showSnackBar(SnackBar(content: Text(state.displayText(message))));
  }

  Future<void> _showCollectedPreview(
    BuildContext context,
    _SpecialJourneyPreview journey,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(journey.icon, color: PhoenixTheme.red, size: 34),
        title: Text(state.displayText('${journey.title} · 已收藏')),
        content: Text(
          state.displayText(
            '${journey.preview}\n\n完整章节正在编写中。你的开启记录已经保存，正式内容上线后可以直接进入。',
          ),
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(state.displayText('收好旅程')),
          ),
        ],
      ),
    );
  }
}

class _SpecialJourneyPreview {
  const _SpecialJourneyPreview({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.currency,
    required this.cost,
    required this.icon,
    required this.preview,
  });

  final String id;
  final String title;
  final String subtitle;
  final String currency;
  final int cost;
  final IconData icon;
  final String preview;
}
