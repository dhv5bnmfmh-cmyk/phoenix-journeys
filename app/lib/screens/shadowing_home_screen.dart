import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../theme/phoenix_theme.dart';
import 'shadowing_training_screen.dart';

class ShadowingHomeScreen extends StatefulWidget {
  const ShadowingHomeScreen({super.key});

  @override
  State<ShadowingHomeScreen> createState() => _ShadowingHomeScreenState();
}

class _ShadowingHomeScreenState extends State<ShadowingHomeScreen> {
  ShadowingTrainingHistory _history = const ShadowingTrainingHistory();
  ShadowingWeaknessLibrary _weaknesses = const ShadowingWeaknessLibrary();

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _history = ShadowingTrainingHistory.decode(
        prefs.getString('phoenix.shadowing.history'),
      );
      _weaknesses = ShadowingWeaknessLibrary.decode(
        prefs.getString('phoenix.shadowing.weaknesses'),
      );
    });
  }

  Future<void> _openTraining(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ShadowingTrainingScreen(),
      ),
    );
    await _loadSummary();
  }

  Future<void> _showWeaknesses() async {
    final queue = _weaknesses.dailyQueue();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFFFF8E9),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '弱项复练',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              queue.isEmpty
                  ? '目前没有待复练句子。完成一次跟读后，系统会自动收集薄弱句。'
                  : '优先练习 ${queue.length} 个最需要修正的句子。',
              style: const TextStyle(height: 1.45),
            ),
            if (queue.isNotEmpty) ...[
              const SizedBox(height: 14),
              ...queue.map(
                (item) => Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .82),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '《${item.passageTitle}》 · ${item.weakestMetric}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 5),
                      Text(item.sentence, style: const TextStyle(height: 1.4)),
                      const SizedBox(height: 5),
                      Text(
                        '最近 ${item.lastScore} 分 · ${item.issueSummary}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  _openTraining(context);
                },
                icon: const Icon(Icons.replay_rounded),
                label: Text(queue.isEmpty ? '开始一次跟读' : '进入弱项复练'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showProgress() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFFFF8E9),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '历史进步',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _MetricTile(label: '训练次数', value: '${_history.totalSessions}'),
                const SizedBox(width: 10),
                _MetricTile(label: '连续天数', value: '${_history.currentStreak}'),
                const SizedBox(width: 10),
                _MetricTile(label: '最佳成绩', value: '${_history.bestRecentScore}'),
              ],
            ),
            const SizedBox(height: 16),
            if (_history.recentSessions.isEmpty)
              const Text('完成第一篇短文后，这里会出现训练记录与成绩变化。')
            else
              ..._history.recentSessions.take(6).map(
                (session) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFFFE7BE),
                    foregroundColor: PhoenixTheme.red,
                    child: Text('${session.score}'),
                  ),
                  title: Text(
                    session.title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${session.completedAt.month}月${session.completedAt.day}日',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('跟读训练'),
      ),
      body: SafeArea(
        child: ListView(
          key: const ValueKey('shadowing-home'),
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
          children: [
            Container(
              key: const ValueKey('shadowing-home-hero'),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7F1D1D), Color(0xFFB23A2A)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.record_voice_over_rounded,
                    color: Color(0xFFFFD879),
                    size: 42,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    '今天，让中文更像你自己的声音',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      height: 1.25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '听一句、跟一句，获得准确度、完整度与流利度三维诊断。',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .88),
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const ValueKey('shadowing-home-start'),
                      onPressed: () => _openTraining(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD879),
                        foregroundColor: const Color(0xFF542010),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text(
                        '开始今日训练',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '训练入口',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.08,
              children: [
                _TrainingEntryCard(
                  key: const ValueKey('shadowing-home-daily'),
                  icon: Icons.auto_awesome_rounded,
                  title: '今日训练',
                  subtitle: 'AI 自动安排训练路线',
                  badge: '继续',
                  onTap: () => _openTraining(context),
                ),
                _TrainingEntryCard(
                  key: const ValueKey('shadowing-home-weakness'),
                  icon: Icons.healing_rounded,
                  title: '弱项复练',
                  subtitle: '集中修正薄弱句',
                  badge: '${_weaknesses.pendingCount}',
                  onTap: _showWeaknesses,
                ),
                _TrainingEntryCard(
                  key: const ValueKey('shadowing-home-library'),
                  icon: Icons.menu_book_rounded,
                  title: '自由选文',
                  subtitle: '按等级选择短文',
                  onTap: () => _openTraining(context),
                ),
                _TrainingEntryCard(
                  key: const ValueKey('shadowing-home-progress'),
                  icon: Icons.insights_rounded,
                  title: '历史进步',
                  subtitle: '查看成绩与训练记录',
                  badge: '${_history.totalSessions}',
                  onTap: _showProgress,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .82),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x1F7F1D1D)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tips_and_updates_rounded, color: PhoenixTheme.red),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '首次训练建议先听示范，再使用推荐语速跟读。系统会自动记录错读、漏读和多读。',
                      style: TextStyle(height: 1.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .84),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _TrainingEntryCard extends StatelessWidget {
  const _TrainingEntryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .88),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE7BE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: PhoenixTheme.red),
                  ),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: PhoenixTheme.red.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: PhoenixTheme.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: .6),
                  fontSize: 12,
                  height: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
