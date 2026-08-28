import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/journey_level_selector_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _translationLanguages = <String>[
    '越南语',
    '英语',
    '中文解释',
    '双语',
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ListView(
      key: const ValueKey('settings-screen'),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
      children: [
        Text(
          state.displayText('学习设置'),
          style: const TextStyle(
            color: Color(0xFF301915),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          state.displayText('在这里设置下一次旅程使用的语言与中文等级。'),
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),
        _SettingsCard(
          icon: Icons.local_fire_department_rounded,
          title: state.displayText('Phoenix 中文等级'),
          subtitle: state.displayText('新的等级将在下一次进入旅程时应用'),
          trailing: const JourneyLevelSelectorButton(),
        ),
        const SizedBox(height: 10),
        _SettingsCard(
          icon: Icons.translate_rounded,
          title: state.displayText('中文字体'),
          subtitle: state.displayText('选择简体或繁体显示'),
          trailing: SegmentedButton<ScriptMode>(
            key: const ValueKey('settings-script-mode'),
            segments: const [
              ButtonSegment(value: ScriptMode.simplified, label: Text('简')),
              ButtonSegment(value: ScriptMode.traditional, label: Text('繁')),
            ],
            selected: <ScriptMode>{state.scriptMode},
            showSelectedIcon: false,
            onSelectionChanged: (selection) {
              if (selection.single != state.scriptMode) {
                unawaited(state.toggleScript());
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        _SettingsCard(
          icon: Icons.language_rounded,
          title: state.displayText('翻译语言'),
          subtitle: state.displayText('选择阅读辅助与词汇解释语言'),
          trailing: DropdownButton<String>(
            key: const ValueKey('settings-translation-language'),
            value: state.translationLanguage,
            underline: const SizedBox.shrink(),
            isDense: true,
            items: [
              for (final language in _translationLanguages)
                DropdownMenuItem(
                  value: language,
                  child: Text(
                    language == '英语'
                        ? 'English'
                        : language == '中文解释'
                            ? '中文'
                            : language,
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) {
                unawaited(state.setTranslationLanguage(value));
              }
            },
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: PhoenixTheme.red.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: PhoenixTheme.red, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF35211D),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 10.5,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          trailing,
        ],
      ),
    );
  }
}
