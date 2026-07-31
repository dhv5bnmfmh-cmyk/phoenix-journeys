import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/phoenix_theme.dart';

class ShadowingPreferencesScreen extends StatefulWidget {
  const ShadowingPreferencesScreen({super.key});

  @override
  State<ShadowingPreferencesScreen> createState() =>
      _ShadowingPreferencesScreenState();
}

class _ShadowingPreferencesScreenState
    extends State<ShadowingPreferencesScreen> {
  static const _prefix = 'phoenix.shadowing.preferences.';

  int _dailyMinutes = 10;
  double _targetSpeed = .9;
  String _difficulty = '自适应';
  String _focus = '综合提升';
  String _hintLevel = '标准';
  bool _autoPlay = true;
  bool _autoAdvance = true;
  bool _vibration = true;
  bool _showPinyin = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _dailyMinutes = prefs.getInt('${_prefix}dailyMinutes') ?? 10;
      _targetSpeed = prefs.getDouble('${_prefix}targetSpeed') ?? .9;
      _difficulty = prefs.getString('${_prefix}difficulty') ?? '自适应';
      _focus = prefs.getString('${_prefix}focus') ?? '综合提升';
      _hintLevel = prefs.getString('${_prefix}hintLevel') ?? '标准';
      _autoPlay = prefs.getBool('${_prefix}autoPlay') ?? true;
      _autoAdvance = prefs.getBool('${_prefix}autoAdvance') ?? true;
      _vibration = prefs.getBool('${_prefix}vibration') ?? true;
      _showPinyin = prefs.getBool('${_prefix}showPinyin') ?? false;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt('${_prefix}dailyMinutes', _dailyMinutes),
      prefs.setDouble('${_prefix}targetSpeed', _targetSpeed),
      prefs.setString('${_prefix}difficulty', _difficulty),
      prefs.setString('${_prefix}focus', _focus),
      prefs.setString('${_prefix}hintLevel', _hintLevel),
      prefs.setBool('${_prefix}autoPlay', _autoPlay),
      prefs.setBool('${_prefix}autoAdvance', _autoAdvance),
      prefs.setBool('${_prefix}vibration', _vibration),
      prefs.setBool('${_prefix}showPinyin', _showPinyin),
    ]);
  }

  Future<void> _reset() async {
    setState(() {
      _dailyMinutes = 10;
      _targetSpeed = .9;
      _difficulty = '自适应';
      _focus = '综合提升';
      _hintLevel = '标准';
      _autoPlay = true;
      _autoAdvance = true;
      _vibration = true;
      _showPinyin = false;
    });
    await _save();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已恢复推荐设置')),
    );
  }

  void _update(VoidCallback action) {
    setState(action);
    _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(
        title: const Text('训练偏好'),
        actions: [
          TextButton(onPressed: _reset, child: const Text('恢复默认')),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
                children: [
                  const _PreferenceHero(),
                  const SizedBox(height: 18),
                  const _SectionTitle('训练目标'),
                  const SizedBox(height: 10),
                  _ChoiceCard<int>(
                    icon: Icons.timer_rounded,
                    title: '每日训练时长',
                    subtitle: '系统会按时长调整短文数量与训练站数量。',
                    value: _dailyMinutes,
                    options: const [5, 10, 15, 20],
                    label: (value) => '$value 分钟',
                    onChanged: (value) =>
                        _update(() => _dailyMinutes = value),
                  ),
                  const SizedBox(height: 10),
                  _ChoiceCard<double>(
                    icon: Icons.speed_rounded,
                    title: '目标语速',
                    subtitle: '训练时优先使用你选择的示范语速。',
                    value: _targetSpeed,
                    options: const [.7, .9, 1.0, 1.1],
                    label: (value) => '${value.toStringAsFixed(1)}×',
                    onChanged: (value) =>
                        _update(() => _targetSpeed = value),
                  ),
                  const SizedBox(height: 18),
                  const _SectionTitle('训练策略'),
                  const SizedBox(height: 10),
                  _ChoiceCard<String>(
                    icon: Icons.tune_rounded,
                    title: '难度策略',
                    subtitle: '自适应会根据近期成绩自动升降难度。',
                    value: _difficulty,
                    options: const ['轻松', '自适应', '挑战'],
                    label: (value) => value,
                    onChanged: (value) =>
                        _update(() => _difficulty = value),
                  ),
                  const SizedBox(height: 10),
                  _ChoiceCard<String>(
                    icon: Icons.track_changes_rounded,
                    title: '重点能力',
                    subtitle: '每日路线会优先安排对应能力训练。',
                    value: _focus,
                    options: const ['综合提升', '准确度', '完整度', '流利度'],
                    label: (value) => value,
                    onChanged: (value) => _update(() => _focus = value),
                  ),
                  const SizedBox(height: 10),
                  _ChoiceCard<String>(
                    icon: Icons.lightbulb_rounded,
                    title: '提示强度',
                    subtitle: '控制逐字标记、修正建议和训练提示数量。',
                    value: _hintLevel,
                    options: const ['简洁', '标准', '详细'],
                    label: (value) => value,
                    onChanged: (value) =>
                        _update(() => _hintLevel = value),
                  ),
                  const SizedBox(height: 18),
                  const _SectionTitle('播放与操作'),
                  const SizedBox(height: 10),
                  _ToggleCard(
                    icon: Icons.volume_up_rounded,
                    title: '自动播放示范',
                    subtitle: '进入新句时自动播放一次标准示范。',
                    value: _autoPlay,
                    onChanged: (value) =>
                        _update(() => _autoPlay = value),
                  ),
                  _ToggleCard(
                    icon: Icons.skip_next_rounded,
                    title: '达标后自动进入下一站',
                    subtitle: '完成当前目标后自动继续训练路线。',
                    value: _autoAdvance,
                    onChanged: (value) =>
                        _update(() => _autoAdvance = value),
                  ),
                  _ToggleCard(
                    icon: Icons.vibration_rounded,
                    title: '操作振动反馈',
                    subtitle: '录音开始、完成和达标时提供轻微反馈。',
                    value: _vibration,
                    onChanged: (value) =>
                        _update(() => _vibration = value),
                  ),
                  _ToggleCard(
                    icon: Icons.translate_rounded,
                    title: '显示拼音辅助',
                    subtitle: '在训练句下方显示拼音，适合初级阶段。',
                    value: _showPinyin,
                    onChanged: (value) =>
                        _update(() => _showPinyin = value),
                  ),
                  const SizedBox(height: 14),
                  const _SavedNotice(),
                ],
              ),
            ),
    );
  }
}

class _PreferenceHero extends StatelessWidget {
  const _PreferenceHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7F1D1D), Color(0xFFB23A2A)],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Row(
        children: [
          Icon(Icons.settings_voice_rounded,
              color: Color(0xFFFFD879), size: 40),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '把训练调成适合你的节奏',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '设置会自动保存，并用于后续每日训练路线。',
                  style: TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      );
}

class _ChoiceCard<T> extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.label,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final T value;
  final List<T> options;
  final String Function(T value) label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: PhoenixTheme.red),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(subtitle,
              style: const TextStyle(color: Colors.black54, height: 1.4)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options
                .map(
                  (option) => ChoiceChip(
                    label: Text(label(option)),
                    selected: option == value,
                    onSelected: (_) => onChanged(option),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  const _ToggleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .84),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: PhoenixTheme.red),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.black54, height: 1.35)),
      ),
    );
  }
}

class _SavedNotice extends StatelessWidget {
  const _SavedNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.cloud_done_rounded, color: PhoenixTheme.red),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '所有修改都会立即保存，无需额外确认。',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
