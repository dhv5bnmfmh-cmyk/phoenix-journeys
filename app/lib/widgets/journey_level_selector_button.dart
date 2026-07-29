import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/language_level_preference_store.dart';
import '../services/phoenix_level_controller.dart';
import '../services/phoenix_story_length_policy.dart';
import '../theme/phoenix_theme.dart';

@visibleForTesting
String phoenixLevelReadingModeLabel(int level) {
  final safeLevel = level.clamp(1, 10).toInt();
  return switch (safeLevel) {
    <= 2 => '轻松起步',
    <= 4 => '稳步进阶',
    <= 6 => '完整阅读',
    <= 8 => '深度阅读',
    _ => '高阶沉浸',
  };
}

@visibleForTesting
String phoenixLevelReadingTimeLabel(int level) {
  final target = phoenixStoryLengthTargetForLevel(level);
  const comfortableCharactersPerMinute = 180;
  final minimumMinutes = math.max(
    1,
    (target.minimumCharacters / comfortableCharactersPerMinute).ceil(),
  );
  final maximumMinutes = math.max(
    minimumMinutes,
    (target.maximumCharacters / comfortableCharactersPerMinute).ceil(),
  );
  return minimumMinutes == maximumMinutes
      ? '约 $minimumMinutes 分钟'
      : '约 $minimumMinutes–$maximumMinutes 分钟';
}

class JourneyLevelSelectorButton extends StatefulWidget {
  const JourneyLevelSelectorButton({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  State<JourneyLevelSelectorButton> createState() =>
      _JourneyLevelSelectorButtonState();
}

class _JourneyLevelSelectorButtonState
    extends State<JourneyLevelSelectorButton> {
  static final PhoenixLevelController _controller =
      PhoenixLevelController.instance;
  static const LanguageLevelPreferenceStore _store =
      LanguageLevelPreferenceStore();

  bool _loading = true;
  bool _changing = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    await _store.initializePhoenixLevel();
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _adjust(int delta) async {
    if (_loading || _changing) return;
    final current = _controller.level;
    final next = (current + delta)
        .clamp(
          PhoenixLevelController.minimumLevel,
          PhoenixLevelController.maximumLevel,
        )
        .toInt();
    if (next == current) return;

    setState(() => _changing = true);
    _controller.setLevel(next);
    unawaited(HapticFeedback.selectionClick());

    try {
      await _store.savePhoenixLevel(next);
    } finally {
      if (mounted) setState(() => _changing = false);
    }
  }

  Future<void> _showLevelGuide(int level) async {
    if (_loading || !mounted) return;
    unawaited(HapticFeedback.selectionClick());
    final target = phoenixStoryLengthTargetForLevel(level);
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFFFFBF3),
      builder: (sheetContext) => _PhoenixLevelGuideSheet(
        level: level,
        minimumCharacters: target.minimumCharacters,
        maximumCharacters: target.maximumCharacters,
        paragraphCount: target.paragraphCount,
        readingMode: phoenixLevelReadingModeLabel(level),
        readingTime: phoenixLevelReadingTimeLabel(level),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 28.0 : 34.0;
    final buttonSize = widget.compact ? 27.0 : 32.0;
    final iconSize = widget.compact ? 14.0 : 17.0;

    return ValueListenableBuilder<int>(
      valueListenable: _controller,
      builder: (context, level, _) {
        final canDecrease = !_loading &&
            !_changing &&
            level > PhoenixLevelController.minimumLevel;
        final canIncrease = !_loading &&
            !_changing &&
            level < PhoenixLevelController.maximumLevel;

        return Semantics(
          label: 'Phoenix 中文难度 $level 级',
          value: '$level',
          hint: '点击等级查看当前阅读长度和预计时间',
          child: Container(
            key: const ValueKey('global-journey-level-selector'),
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFFDF4DF).withValues(alpha: .96),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: PhoenixTheme.gold.withValues(alpha: .72),
                width: .8,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x21000000),
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _LevelIconButton(
                  key: const ValueKey('phoenix-level-minus'),
                  tooltip: '降低当前难度',
                  icon: Icons.remove_rounded,
                  enabled: canDecrease,
                  size: buttonSize,
                  iconSize: iconSize,
                  onPressed: () => unawaited(_adjust(-1)),
                ),
                Tooltip(
                  message: '查看 Lv.$level 阅读强度',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: const ValueKey('phoenix-level-guide'),
                      borderRadius: BorderRadius.circular(99),
                      onTap: _loading ? null : () => unawaited(_showLevelGuide(level)),
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: widget.compact ? 37 : 44,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.compact ? 2 : 4,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          transitionBuilder: (child, animation) => ScaleTransition(
                            scale: CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            ),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                          child: Text(
                            _loading ? 'Lv.…' : 'Lv.$level',
                            key: ValueKey('phoenix-level-value-$level'),
                            maxLines: 1,
                            style: TextStyle(
                              color: PhoenixTheme.red,
                              fontSize: widget.compact ? 9.5 : 11.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -.25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _LevelIconButton(
                  key: const ValueKey('phoenix-level-plus'),
                  tooltip: '提高当前难度',
                  icon: Icons.add_rounded,
                  enabled: canIncrease,
                  size: buttonSize,
                  iconSize: iconSize,
                  onPressed: () => unawaited(_adjust(1)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhoenixLevelGuideSheet extends StatelessWidget {
  const _PhoenixLevelGuideSheet({
    required this.level,
    required this.minimumCharacters,
    required this.maximumCharacters,
    required this.paragraphCount,
    required this.readingMode,
    required this.readingTime,
  });

  final int level;
  final int minimumCharacters;
  final int maximumCharacters;
  final int paragraphCount;
  final String readingMode;
  final String readingTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC4372E), Color(0xFF8E1F1B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$level',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phoenix Lv.$level',
                      style: const TextStyle(
                        color: Color(0xFF301915),
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      readingMode,
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _LevelTrack(level: level),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _GuideMetric(
                  icon: Icons.notes_rounded,
                  label: '故事长度',
                  value: '$minimumCharacters–$maximumCharacters 字',
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _GuideMetric(
                  icon: Icons.view_agenda_outlined,
                  label: '内容结构',
                  value: paragraphCount == 1 ? '1 段长文' : '$paragraphCount 段短文',
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _GuideMetric(
                  icon: Icons.schedule_rounded,
                  label: '阅读时间',
                  value: readingTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PhoenixTheme.gold.withValues(alpha: .11),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: PhoenixTheme.gold.withValues(alpha: .28),
              ),
            ),
            child: const Text(
              '使用 − / + 调整等级后，当前故事、重点词汇、文化发现、挑战与朗读速度会立即同步更新。',
              style: TextStyle(
                color: Color(0xFF5B4237),
                fontSize: 11.5,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelTrack extends StatelessWidget {
  const _LevelTrack({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(10, (index) {
        final active = index < level;
        final current = index == level - 1;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: current ? 8 : 5,
            margin: EdgeInsets.only(right: index == 9 ? 0 : 4),
            decoration: BoxDecoration(
              color: active
                  ? current
                      ? PhoenixTheme.red
                      : PhoenixTheme.gold
                  : const Color(0xFFE7DDD0),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}

class _GuideMetric extends StatelessWidget {
  const _GuideMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE9DED1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 17, color: PhoenixTheme.red),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF8A7569),
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              color: Color(0xFF35211D),
              fontSize: 10.5,
              height: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelIconButton extends StatelessWidget {
  const _LevelIconButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.enabled,
    required this.size,
    required this.iconSize,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final bool enabled;
  final double size;
  final double iconSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        tooltip: tooltip,
        onPressed: enabled ? onPressed : null,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        constraints: BoxConstraints.tightFor(width: size, height: size),
        splashRadius: size * .48,
        icon: Icon(
          icon,
          size: iconSize,
          color: enabled
              ? PhoenixTheme.red
              : PhoenixTheme.red.withValues(alpha: .25),
        ),
      ),
    );
  }
}
