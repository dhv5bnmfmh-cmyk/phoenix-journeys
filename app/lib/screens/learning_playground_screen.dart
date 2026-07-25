import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/prototype_daily_mix.dart';
import '../widgets/prototype_interactive_drama.dart';
import '../widgets/prototype_role_adventure.dart';

typedef PlaygroundText = String Function(String text);

class LearningPlaygroundScreen extends StatefulWidget {
  const LearningPlaygroundScreen({super.key});

  @override
  State<LearningPlaygroundScreen> createState() =>
      _LearningPlaygroundScreenState();
}

class _LearningPlaygroundScreenState extends State<LearningPlaygroundScreen> {
  int? _selectedMode;

  static const List<_PlaygroundMode> _modes = [
    _PlaygroundMode(
      title: '古城角色冒险',
      subtitle: '选路线、移动取景框、亲自对 NPC 说一句话',
      duration: '约 4 分钟',
      icon: Icons.explore_rounded,
      accent: Color(0xFFB64C3C),
    ),
    _PlaygroundMode(
      title: '每日三小游戏',
      subtitle: '排序、找异常、自由造句，三种操作连续轮换',
      duration: '约 3 分钟',
      icon: Icons.grid_view_rounded,
      accent: Color(0xFF2F7566),
    ),
    _PlaygroundMode(
      title: '互动连续剧',
      subtitle: '搜集证据、选择立场，让剧情走向不同结局',
      duration: '约 5 分钟',
      icon: Icons.theater_comedy_rounded,
      accent: Color(0xFF6652A5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final text = state.displayText;
        return Scaffold(
          backgroundColor: const Color(0xFF14110D),
          appBar: AppBar(
            backgroundColor: const Color(0xFF241A13),
            foregroundColor: const Color(0xFFFFE8B8),
            leading: _selectedMode == null
                ? null
                : IconButton(
                    key: const ValueKey('learning-lab-back'),
                    onPressed: () => setState(() => _selectedMode = null),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
            title: Text(
              text(
                _selectedMode == null
                    ? 'Phoenix 玩法实验室'
                    : _modes[_selectedMode!].title,
              ),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                key: const ValueKey('learning-lab-script-toggle'),
                onPressed: state.toggleScript,
                child: Text(
                  state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',
                  style: const TextStyle(
                    color: Color(0xFFFFE8B8),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: _selectedMode == null
                  ? _buildHub(text)
                  : _buildPrototype(
                      _selectedMode!,
                      text,
                      state.savedWords,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHub(PlaygroundText text) {
    return ListView(
      key: const ValueKey('learning-lab-hub'),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF37251B), Color(0xFF1D1813)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFD7AC65).withValues(alpha: .4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFFFFD98B),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '三种玩法，一次比较',
                    style: TextStyle(
                      color: Color(0xFFFFE8B8),
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                text('每个原型都使用颐和园知识，但操作、节奏和乐趣来源不同。完成后回到这里，再体验下一种。'),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 11),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: [
                  _LabBadge(text: text('不计入正式进度')),
                  _LabBadge(text: text('没有付费与奖励压力')),
                  _LabBadge(text: text('可随时重新体验')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        for (var index = 0; index < _modes.length; index++) ...[
          _ModeCard(
            key: ValueKey<String>('learning-lab-open-$index'),
            mode: _modes[index],
            text: text,
            onTap: () => setState(() => _selectedMode = index),
          ),
          const SizedBox(height: 11),
        ],
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .055),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Text(
            text('体验时只判断三件事：是否马上懂、是否想继续、是否愿意再玩一次。'),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrototype(
    int mode,
    PlaygroundText text,
    Set<String> learnedWords,
  ) {
    return switch (mode) {
      0 => RoleAdventurePrototype(
          key: const ValueKey('learning-lab-role'),
          text: text,
          learnedWords: learnedWords,
        ),
      1 => DailyMixPrototype(
          key: const ValueKey('learning-lab-daily'),
          text: text,
          learnedWords: learnedWords,
        ),
      _ => InteractiveDramaPrototype(
          key: const ValueKey('learning-lab-drama'),
          text: text,
          learnedWords: learnedWords,
        ),
    };
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    super.key,
    required this.mode,
    required this.text,
    required this.onTap,
  });

  final _PlaygroundMode mode;
  final PlaygroundText text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF252019),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: mode.accent.withValues(alpha: .7)),
            boxShadow: [
              BoxShadow(
                color: mode.accent.withValues(alpha: .11),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: mode.accent.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(mode.icon, color: mode.accent, size: 31),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text(mode.title),
                      style: const TextStyle(
                        color: Color(0xFFFFE8B8),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      text(mode.subtitle),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      text(mode.duration),
                      style: TextStyle(
                        color: mode.accent,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.play_circle_fill_rounded,
                color: Color(0xFFFFD98B),
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabBadge extends StatelessWidget {
  const _LabBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: PhoenixTheme.gold.withValues(alpha: .11),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: PhoenixTheme.gold.withValues(alpha: .28),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFFFDF9A),
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PlaygroundMode {
  const _PlaygroundMode({
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String duration;
  final IconData icon;
  final Color accent;
}
