import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../theme/phoenix_theme.dart';
import 'shadowing_plan_screen.dart';
import 'shadowing_section_screen.dart';
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

  Future<void> _openTraining() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const ShadowingTrainingScreen(),
      ),
    );
    await _loadSummary();
  }

  Future<void> _openSection(ShadowingSection section) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ShadowingSectionScreen(
          section: section,
          history: _history,
          weaknesses: _weaknesses,
          onStartTraining: _openTraining,
        ),
      ),
    );
    await _loadSummary();
  }

  Future<void> _openPlan() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ShadowingPlanScreen(
          history: _history,
          weaknesses: _weaknesses,
          onStartTraining: _openTraining,
          onOpenWeakness: () => _openSection(ShadowingSection.weakness),
          onOpenLibrary: () => _openSection(ShadowingSection.library),
          onOpenProgress: () => _openSection(ShadowingSection.progress),
        ),
      ),
    );
    await _loadSummary();
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
                      onPressed: () => _openSection(ShadowingSection.daily),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD879),
                        foregroundColor: const Color(0xFF542010),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text(
                        '查看今日训练',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Material(
              color: const Color(0xFFFFF4D8),
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                key: const ValueKey('shadowing-home-plan'),
                borderRadius: BorderRadius.circular(22),
                onTap: _openPlan,
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE7BE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.route_rounded,
                          color: PhoenixTheme.red,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '训练计划中心',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '周目标、趋势、弱项与推荐素材集中查看',
                              style: TextStyle(
                                color: Colors.black.withValues(alpha: .58),
                                fontSize: 12,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
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
                  onTap: () => _openSection(ShadowingSection.daily),
                ),
                _TrainingEntryCard(
                  key: const ValueKey('shadowing-home-weakness'),
                  icon: Icons.healing_rounded,
                  title: '弱项复练',
                  subtitle: '集中修正薄弱句',
                  badge: '${_weaknesses.pendingCount}',
                  onTap: () => _openSection(ShadowingSection.weakness),
                ),
                _TrainingEntryCard(
                  key: const ValueKey('shadowing-home-library'),
                  icon: Icons.menu_book_rounded,
                  title: '自由选文',
                  subtitle: '按等级选择短文',
                  onTap: () => _openSection(ShadowingSection.library),
                ),
                _TrainingEntryCard(
                  key: const ValueKey('shadowing-home-progress'),
                  icon: Icons.insights_rounded,
                  title: '历史进步',
                  subtitle: '查看成绩与训练记录',
                  badge: '${_history.totalSessions}',
                  onTap: () => _openSection(ShadowingSection.progress),
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
