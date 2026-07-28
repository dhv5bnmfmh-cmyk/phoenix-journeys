import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/language_level_preference_store.dart';
import '../services/phoenix_level_controller.dart';
import '../theme/phoenix_theme.dart';

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
    await HapticFeedback.selectionClick();
    _controller.setLevel(next);
    await _store.savePhoenixLevel(next);
    if (!mounted) return;
    setState(() => _changing = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 28.0 : 34.0;
    final buttonSize = widget.compact ? 27.0 : 32.0;
    final iconSize = widget.compact ? 14.0 : 17.0;

    return ValueListenableBuilder<int>(
      valueListenable: _controller,
      builder: (context, level, _) {
        final canDecrease = !_loading && !_changing &&
            level > PhoenixLevelController.minimumLevel;
        final canIncrease = !_loading && !_changing &&
            level < PhoenixLevelController.maximumLevel;

        return Semantics(
          label: 'Phoenix 中文难度 $level 级',
          value: '$level',
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
                Container(
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
                      child: FadeTransition(opacity: animation, child: child),
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
