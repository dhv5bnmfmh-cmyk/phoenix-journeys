from pathlib import Path


def replace_once(source: str, old: str, new: str, label: str) -> str:
    if old not in source:
        raise SystemExit(f'missing anchor: {label}')
    return source.replace(old, new, 1)


screen_path = Path('app/lib/screens/shadowing_training_screen.dart')
screen = screen_path.read_text(encoding='utf-8')

screen = replace_once(
    screen,
    "import '../services/shadowing_score.dart';\n",
    "import '../services/shadowing_daily_plan.dart';\n"
    "import '../services/shadowing_score.dart';\n",
    'daily plan import',
)

screen = replace_once(
    screen,
    "  ShadowingWeaknessLibrary _weaknessLibrary = const ShadowingWeaknessLibrary();\n"
    "  ShadowingPassage? _passage;",
    "  ShadowingWeaknessLibrary _weaknessLibrary = const ShadowingWeaknessLibrary();\n"
    "  ShadowingDailyPlan? _dailyPlan;\n"
    "  String? _activeDailyPlanStepId;\n"
    "  ShadowingPassage? _passage;",
    'daily plan state',
)

screen = replace_once(
    screen,
    '''  void _handleLevelChange() {
    if (!mounted) return;
    setState(() {});
  }
''',
    '''  void _handleLevelChange() {
    if (!mounted) return;
    unawaited(_refreshDailyPlanForLevel());
  }

  Future<void> _refreshDailyPlanForLevel() async {
    final plan = ShadowingDailyPlan.generate(
      date: DateTime.now(),
      level: PhoenixLevelController.instance.level,
      weaknessLibrary: _weaknessLibrary,
      bestScores: _bestScores,
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoenix.shadowing.dailyPlan', plan.encode());
    if (!mounted) return;
    setState(() {
      _dailyPlan = plan;
      _activeDailyPlanStepId = null;
    });
  }
''',
    'level refresh',
)

screen = replace_once(
    screen,
    '''    _weaknessLibrary = ShadowingWeaknessLibrary.decode(
      prefs.getString('phoenix.shadowing.weaknesses'),
    );

    var ready = false;
''',
    '''    _weaknessLibrary = ShadowingWeaknessLibrary.decode(
      prefs.getString('phoenix.shadowing.weaknesses'),
    );
    _dailyPlan = ShadowingDailyPlan.restoreOrGenerate(
      encoded: prefs.getString('phoenix.shadowing.dailyPlan'),
      date: DateTime.now(),
      level: PhoenixLevelController.instance.level,
      weaknessLibrary: _weaknessLibrary,
      bestScores: _bestScores,
    );
    await prefs.setString(
      'phoenix.shadowing.dailyPlan',
      _dailyPlan!.encode(),
    );

    var ready = false;
''',
    'initialize daily plan',
)

screen = replace_once(
    screen,
    '''    int startSentenceIndex = 0,
    String? message,
  }) {''',
    '''    int startSentenceIndex = 0,
    String? message,
    String? dailyPlanStepId,
  }) {''',
    'open passage argument',
)

screen = replace_once(
    screen,
    '''      _score = null;
      _speechMessage = message;
    });
  }
''',
    '''      _score = null;
      _speechMessage = message;
      _activeDailyPlanStepId = dailyPlanStepId;
    });
  }
''',
    'open passage state',
)

screen = replace_once(
    screen,
    '''      _score = null;
      _speechMessage = null;
    });
  }

  Future<void> _playText''',
    '''      _score = null;
      _speechMessage = null;
      _activeDailyPlanStepId = null;
    });
  }

  Future<void> _playText''',
    'close passage state',
)

screen = replace_once(
    screen,
    '''    final weaknessLibrary = _weaknessLibrary.recordAttempt(
      passageId: passage.id,
      passageTitle: passage.title,
      sentenceIndex: _sentenceIndex,
      sentence: sentence,
      recognized: _recognized,
      score: score,
      practicedAt: DateTime.now(),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'phoenix.shadowing.weaknesses',
      weaknessLibrary.encode(),
    );
    if (!mounted) return;
    setState(() {
      _attempts = attempts;
      _score = score;
      _weaknessLibrary = weaknessLibrary;
      final previous = _sessionSentenceScores[_sentenceIndex] ?? 0;
      if (score.overall > previous) {
        _sessionSentenceScores[_sentenceIndex] = score.overall;
      }
      _speechMessage = null;
    });
''',
    '''    final weaknessLibrary = _weaknessLibrary.recordAttempt(
      passageId: passage.id,
      passageTitle: passage.title,
      sentenceIndex: _sentenceIndex,
      sentence: sentence,
      recognized: _recognized,
      score: score,
      practicedAt: DateTime.now(),
    );
    final activeStepId = _activeDailyPlanStepId;
    var dailyPlan = _dailyPlan;
    final wasStepCompleted = activeStepId != null &&
        (dailyPlan?.isStepCompleted(activeStepId) ?? false);
    if (dailyPlan != null && activeStepId != null) {
      dailyPlan = dailyPlan.recordAttempt(
        stepId: activeStepId,
        passageId: passage.id,
        sentenceIndex: _sentenceIndex,
        score: score,
      );
    }
    final completedNow = activeStepId != null &&
        !wasStepCompleted &&
        (dailyPlan?.isStepCompleted(activeStepId) ?? false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'phoenix.shadowing.weaknesses',
      weaknessLibrary.encode(),
    );
    if (dailyPlan != null) {
      await prefs.setString(
        'phoenix.shadowing.dailyPlan',
        dailyPlan.encode(),
      );
    }
    if (!mounted) return;
    setState(() {
      _attempts = attempts;
      _score = score;
      _weaknessLibrary = weaknessLibrary;
      _dailyPlan = dailyPlan;
      final previous = _sessionSentenceScores[_sentenceIndex] ?? 0;
      if (score.overall > previous) {
        _sessionSentenceScores[_sentenceIndex] = score.overall;
      }
      _speechMessage = completedNow
          ? '今日训练目标达成 · ${dailyPlan!.completedCount}/${dailyPlan.steps.length}'
          : null;
    });
''',
    'score daily plan',
)

daily_methods = r'''
  void _startDailyPlanStep(ShadowingDailyPlanStep step) {
    ShadowingPassage? passage;
    for (final candidate in shadowingPassages) {
      if (candidate.id == step.passageId) {
        passage = candidate;
        break;
      }
    }
    if (passage == null) return;
    _openPassage(
      passage,
      startSentenceIndex: step.sentenceIndex,
      message: '今日训练 · ${step.title} · 目标 ${step.targetScore} 分',
      dailyPlanStepId: step.id,
    );
  }

  Future<void> _showDailyPlan() async {
    final plan = _dailyPlan;
    if (plan == null || !mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFF8E9),
      showDragHandle: true,
      builder: (sheetContext) => _DailyPlanSheet(
        plan: plan,
        displayText: context.read<AppState>().displayText,
        onStart: (step) {
          Navigator.of(sheetContext).pop();
          _startDailyPlanStep(step);
        },
      ),
    );
  }

  void _continueDailyPlan() {
    final plan = _dailyPlan;
    if (plan == null) return;
    final activeStep = plan.stepById(_activeDailyPlanStepId);
    if (activeStep != null && !plan.isStepCompleted(activeStep.id)) {
      final score = _score;
      if (score != null) _retryCurrentWeakness(score);
      return;
    }
    final next = plan.firstIncompleteStep;
    if (next == null) {
      unawaited(_showDailyPlanCompletion());
      return;
    }
    _startDailyPlanStep(next);
  }

  Future<void> _showDailyPlanCompletion() async {
    final plan = _dailyPlan;
    if (plan == null || !mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: PhoenixTheme.red,
              size: 54,
            ),
            const SizedBox(height: 8),
            Text(
              t('今日训练路线完成'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 7),
            Text(
              t('已完成 ${plan.steps.length} 个训练站 · 约 ${plan.totalMinutes} 分钟'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const ValueKey('shadowing-daily-plan-finish'),
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  _closePassage();
                },
                icon: const Icon(Icons.verified_rounded),
                label: Text(t('完成今日训练')),
              ),
            ),
          ],
        ),
      ),
    );
  }

'''
screen = replace_once(
    screen,
    '  void _practiceWeakness(ShadowingWeaknessItem item) {',
    daily_methods + '  void _practiceWeakness(ShadowingWeaknessItem item) {',
    'daily plan methods',
)

screen = replace_once(
    screen,
    '''        _TrainingDashboard(history: _history, displayText: state.displayText),
        const SizedBox(height: 7),
        _WeaknessLibraryCard(''',
    '''        _TrainingDashboard(history: _history, displayText: state.displayText),
        const SizedBox(height: 7),
        if (_dailyPlan != null) ...[
          _DailyPlanCard(
            plan: _dailyPlan!,
            displayText: state.displayText,
            onTap: () => unawaited(_showDailyPlan()),
          ),
          const SizedBox(height: 7),
        ],
        _WeaknessLibraryCard(''',
    'daily plan card',
)

screen = replace_once(
    screen,
    '''    final sentence = passage.sentences[_sentenceIndex];
    final score = _score;
    return ListView(''',
    '''    final sentence = passage.sentences[_sentenceIndex];
    final score = _score;
    final activePlanStep = _dailyPlan?.stepById(_activeDailyPlanStepId);
    final activePlanCompleted = activePlanStep != null &&
        (_dailyPlan?.isStepCompleted(activePlanStep.id) ?? false);
    return ListView(''',
    'active plan variables',
)

screen = replace_once(
    screen,
    '''                _reviewQueue.isEmpty
                    ? '第 ${_sentenceIndex + 1} / ${passage.sentences.length} 句'
                    : '薄弱句复练 ${_reviewPosition + 1} / ${_reviewQueue.length}',
''',
    '''                activePlanStep != null
                    ? '今日计划 ${(_dailyPlan?.completedCount ?? 0) + (activePlanCompleted ? 0 : 1)} / ${_dailyPlan?.steps.length ?? 0}'
                    : _reviewQueue.isEmpty
                    ? '第 ${_sentenceIndex + 1} / ${passage.sentences.length} 句'
                    : '薄弱句复练 ${_reviewPosition + 1} / ${_reviewQueue.length}',
''',
    'plan header',
)

screen = replace_once(
    screen,
    '''          value: _reviewQueue.isEmpty
              ? (_sentenceIndex + 1) / passage.sentences.length
              : (_reviewPosition + 1) / _reviewQueue.length,
          minHeight: 5,
        ),
        const SizedBox(height: 9),
        Row(
          key: const ValueKey('shadowing-sentence-score-strip'),''',
    '''          value: activePlanStep != null
              ? _dailyPlan!.progress
              : _reviewQueue.isEmpty
              ? (_sentenceIndex + 1) / passage.sentences.length
              : (_reviewPosition + 1) / _reviewQueue.length,
          minHeight: 5,
        ),
        if (activePlanStep != null) ...[
          const SizedBox(height: 9),
          Container(
            key: const ValueKey('shadowing-daily-plan-active-step'),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8BD).withValues(alpha: .78),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: PhoenixTheme.gold.withValues(alpha: .48),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.route_rounded,
                  color: PhoenixTheme.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.displayText(
                      '${activePlanStep.title} · ${activePlanStep.focusMetric} · 目标 ${activePlanStep.targetScore} 分',
                    ),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                if (activePlanCompleted)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF4E6A43),
                    size: 20,
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 9),
        Row(
          key: const ValueKey('shadowing-sentence-score-strip'),''',
    'active plan banner',
)

screen = replace_once(
    screen,
    '''          FilledButton.icon(
            onPressed: _nextSentence,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(
              state.displayText(
                _reviewQueue.isNotEmpty
                    ? _reviewPosition == _reviewQueue.length - 1
                          ? '完成薄弱句复练'
                          : '复练下一句'
                    : _sentenceIndex == passage.sentences.length - 1
                    ? '完成这篇短文'
                    : '练习下一句',
              ),
            ),
          ),''',
    '''          FilledButton.icon(
            onPressed: activePlanStep != null
                ? _continueDailyPlan
                : _nextSentence,
            icon: Icon(
              activePlanStep != null && !activePlanCompleted
                  ? Icons.replay_rounded
                  : Icons.arrow_forward_rounded,
            ),
            label: Text(
              state.displayText(
                activePlanStep != null
                    ? activePlanCompleted
                          ? _dailyPlan!.completed
                                ? '完成今日训练'
                                : '继续今日计划'
                          : '再练一次达到 ${activePlanStep.targetScore} 分'
                    : _reviewQueue.isNotEmpty
                    ? _reviewPosition == _reviewQueue.length - 1
                          ? '完成薄弱句复练'
                          : '复练下一句'
                    : _sentenceIndex == passage.sentences.length - 1
                    ? '完成这篇短文'
                    : '练习下一句',
              ),
            ),
          ),''',
    'daily plan continue button',
)

widgets = r'''
class _DailyPlanCard extends StatelessWidget {
  const _DailyPlanCard({
    required this.plan,
    required this.displayText,
    required this.onTap,
  });

  final ShadowingDailyPlan plan;
  final String Function(String) displayText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('shadowing-daily-plan-entry'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFE7B8), Color(0xFFFFF4D9)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: PhoenixTheme.gold.withValues(alpha: .62),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: PhoenixTheme.red.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.route_rounded,
                      color: PhoenixTheme.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayText('AI 今日训练路线'),
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          displayText(
                            '${plan.completedCount}/${plan.steps.length} 站 · 约 ${plan.totalMinutes} 分钟 · Lv.${plan.level}',
                          ),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: plan.completed
                          ? const Color(0xFFDDE8D2)
                          : PhoenixTheme.red,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      displayText(
                        plan.completed
                            ? '今日完成'
                            : plan.completedCount == 0
                            ? '开始训练'
                            : '继续训练',
                      ),
                      style: TextStyle(
                        color: plan.completed
                            ? const Color(0xFF41603A)
                            : Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  key: const ValueKey('shadowing-daily-plan-progress'),
                  value: plan.progress,
                  minHeight: 6,
                  backgroundColor: Colors.white.withValues(alpha: .72),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    PhoenixTheme.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyPlanSheet extends StatelessWidget {
  const _DailyPlanSheet({
    required this.plan,
    required this.displayText,
    required this.onStart,
  });

  final ShadowingDailyPlan plan;
  final String Function(String) displayText;
  final ValueChanged<ShadowingDailyPlanStep> onStart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: .74,
        minChildSize: .48,
        maxChildSize: .92,
        builder: (context, controller) => ListView(
          key: const ValueKey('shadowing-daily-plan-sheet'),
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            Row(
              children: [
                const Icon(
                  Icons.route_rounded,
                  color: PhoenixTheme.red,
                  size: 30,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayText('AI 今日训练路线'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        displayText('根据当前等级、历史成绩和个人弱项自动编排'),
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEAC2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: PhoenixTheme.gold.withValues(alpha: .48),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayText(
                        '进度 ${plan.completedCount}/${plan.steps.length} · 约 ${plan.totalMinutes} 分钟',
                      ),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  Text(
                    '${(plan.progress * 100).round()}%',
                    style: const TextStyle(
                      color: PhoenixTheme.red,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            for (var index = 0; index < plan.steps.length; index += 1) ...[
              _DailyPlanStepTile(
                index: index,
                step: plan.steps[index],
                completed: plan.isStepCompleted(plan.steps[index].id),
                displayText: displayText,
                onTap: () => onStart(plan.steps[index]),
              ),
              const SizedBox(height: 7),
            ],
          ],
        ),
      ),
    );
  }
}

class _DailyPlanStepTile extends StatelessWidget {
  const _DailyPlanStepTile({
    required this.index,
    required this.step,
    required this.completed,
    required this.displayText,
    required this.onTap,
  });

  final int index;
  final ShadowingDailyPlanStep step;
  final bool completed;
  final String Function(String) displayText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .70),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: ValueKey('shadowing-daily-plan-step-${step.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: completed
                    ? const Color(0xFFDDE8D2)
                    : PhoenixTheme.red.withValues(alpha: .10),
                foregroundColor: completed
                    ? const Color(0xFF41603A)
                    : PhoenixTheme.red,
                child: completed
                    ? const Icon(Icons.check_rounded, size: 19)
                    : Text(
                        '${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayText(step.title),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      displayText(
                        '${step.focusMetric} · 目标 ${step.targetScore} 分 · ${step.estimatedMinutes} 分钟',
                      ),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                completed
                    ? Icons.replay_rounded
                    : Icons.play_circle_fill_rounded,
                color: PhoenixTheme.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

'''
screen = replace_once(
    screen,
    'class _WeaknessLibraryCard extends StatelessWidget {',
    widgets + 'class _WeaknessLibraryCard extends StatelessWidget {',
    'daily plan widgets',
)

screen_path.write_text(screen, encoding='utf-8')

nav_path = Path('worker/shadowing_navigation.test.mjs')
nav = nav_path.read_text(encoding='utf-8')
nav = replace_once(
    nav,
    "const weaknessLibrary = readFileSync(\n"
    "  new URL('../app/lib/services/shadowing_weakness_library.dart', import.meta.url),\n"
    "  'utf8',\n"
    ");\n",
    "const weaknessLibrary = readFileSync(\n"
    "  new URL('../app/lib/services/shadowing_weakness_library.dart', import.meta.url),\n"
    "  'utf8',\n"
    ");\n"
    "const dailyPlan = readFileSync(\n"
    "  new URL('../app/lib/services/shadowing_daily_plan.dart', import.meta.url),\n"
    "  'utf8',\n"
    ");\n",
    'daily plan worker import',
)
nav += r'''

test('shadowing exposes an adaptive daily route with persistent guided progress', () => {
  assert.match(training, /shadowing-daily-plan-entry/);
  assert.match(training, /shadowing-daily-plan-sheet/);
  assert.match(training, /shadowing-daily-plan-active-step/);
  assert.match(training, /phoenix\.shadowing\.dailyPlan/);
  assert.match(training, /_continueDailyPlan/);
  assert.match(training, /今日训练路线完成/);
  assert.match(dailyPlan, /class ShadowingDailyPlan/);
  assert.match(dailyPlan, /restoreOrGenerate/);
  assert.match(dailyPlan, /firstIncompleteStep/);
  assert.match(dailyPlan, /kind == 'focus'/);
  assert.match(dailyPlan, /kind == 'challenge'/);
});
'''
nav_path.write_text(nav, encoding='utf-8')
