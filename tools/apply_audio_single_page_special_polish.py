from __future__ import annotations

import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[1]


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f'{label}: expected one match, found {count}')
    return text.replace(old, new, 1)


def regex_once(text: str, pattern: str, replacement: str, label: str) -> str:
    result, count = re.subn(pattern, replacement, text, count=1, flags=re.S)
    if count != 1:
        raise RuntimeError(f'{label}: expected one regex match, found {count}')
    return result


def patch_special_background() -> None:
    path = ROOT / 'app/lib/widgets/special_realm_background.dart'
    text = path.read_text(encoding='utf-8')
    text = replace_once(
        text,
        "import 'package:flutter/material.dart';\n",
        "import 'package:flutter/material.dart';\n\n"
        "import 'special_realm_cinematic_overlay.dart';\n",
        'special cinematic import',
    )
    text = replace_once(
        text,
        "            CustomPaint(\n"
        "              painter: _SpecialRealmPainter(\n"
        "                journeyId: widget.journeyId,\n"
        "                progress: _motion.value,\n"
        "              ),\n"
        "            ),\n"
        "            DecoratedBox(\n",
        "            CustomPaint(\n"
        "              painter: _SpecialRealmPainter(\n"
        "                journeyId: widget.journeyId,\n"
        "                progress: _motion.value,\n"
        "              ),\n"
        "            ),\n"
        "            SpecialRealmCinematicOverlay(\n"
        "              journeyId: widget.journeyId,\n"
        "            ),\n"
        "            DecoratedBox(\n",
        'insert special cinematic overlay',
    )
    path.write_text(text, encoding='utf-8')


def patch_city_stamp() -> None:
    path = ROOT / 'app/lib/widgets/city_journey_stamp.dart'
    text = path.read_text(encoding='utf-8')
    text = replace_once(
        text,
        "import '../theme/phoenix_theme.dart';\n",
        "import '../theme/phoenix_theme.dart';\n"
        "import 'special_journey_stamp.dart';\n",
        'special stamp import',
    )
    text = replace_once(
        text,
        "  @override\n"
        "  Widget build(BuildContext context) {\n"
        "    final foreground = transparentInk\n",
        "  @override\n"
        "  Widget build(BuildContext context) {\n"
        "    if (SpecialJourneyStamp.supports(journey.id)) {\n"
        "      return SpecialJourneyStamp(\n"
        "        journey: journey,\n"
        "        isUnlocked: isUnlocked,\n"
        "        size: size,\n"
        "        transparentInk: transparentInk,\n"
        "      );\n"
        "    }\n\n"
        "    final foreground = transparentInk\n",
        'dispatch special stamp',
    )
    path.write_text(text, encoding='utf-8')


def patch_challenge_panel() -> None:
    path = ROOT / 'app/lib/widgets/journey_challenge_panel.dart'
    text = path.read_text(encoding='utf-8')

    text = replace_once(
        text,
        "import 'dart:math' as math;\n",
        "import 'dart:async';\n"
        "import 'dart:math' as math;\n",
        'challenge async import',
    )
    text = replace_once(
        text,
        "import '../models/language_proficiency.dart';\n",
        "import '../models/language_proficiency.dart';\n"
        "import '../services/narration_controller.dart';\n",
        'challenge narration import',
    )
    text = replace_once(
        text,
        "    required this.onResolved,\n"
        "    required this.onAllCompleted,\n"
        "  });\n",
        "    required this.onResolved,\n"
        "    required this.onAllCompleted,\n"
        "    this.autoNarrate = true,\n"
        "  });\n",
        'challenge constructor auto narration',
    )
    text = replace_once(
        text,
        "  final JourneyChallengeResolved onResolved;\n"
        "  final JourneyChallengeCompleted onAllCompleted;\n",
        "  final JourneyChallengeResolved onResolved;\n"
        "  final JourneyChallengeCompleted onAllCompleted;\n"
        "  final bool autoNarrate;\n",
        'challenge auto narration field',
    )
    text = replace_once(
        text,
        "  final Set<int> _rewardedModes = <int>{};\n",
        "  final Set<int> _rewardedModes = <int>{};\n"
        "  late final NarrationController _narration;\n"
        "  int _narrationToken = 0;\n",
        'challenge narration state',
    )
    text = replace_once(
        text,
        "  void initState() {\n"
        "    super.initState();\n"
        "    _buildSessions();\n"
        "  }\n",
        "  void initState() {\n"
        "    super.initState();\n"
        "    _narration = NarrationController();\n"
        "    _buildSessions();\n"
        "    _scheduleAutoNarration();\n"
        "  }\n",
        'challenge init narration',
    )
    text = replace_once(
        text,
        "    _buildSessions();\n"
        "  }\n\n"
        "  void _buildSessions() {\n",
        "    _buildSessions();\n"
        "    _scheduleAutoNarration();\n"
        "  }\n\n"
        "  @override\n"
        "  void dispose() {\n"
        "    _narration.dispose();\n"
        "    super.dispose();\n"
        "  }\n\n"
        "  void _buildSessions() {\n",
        'challenge update and dispose narration',
    )

    narration_methods = r'''  void _scheduleAutoNarration() {
    if (!widget.autoNarrate) return;
    final token = ++_narrationToken;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || token != _narrationToken) return;
      unawaited(_speak(_questionNarration(_session)));
    });
  }

  Future<void> _speak(String value) async {
    final text = t(value).trim();
    if (text.isEmpty) return;
    await _narration.speakTemporaryText(text, languageCode: 'zh-CN');
  }

  String _questionNarration(_ChallengeSession session) {
    return switch (session.type) {
      JourneyChallengeType.paragraphRebuild =>
        '${session.questionTitle}。${session.instruction}',
      JourneyChallengeType.grammarRepair =>
        '${session.questionTitle}。${session.grammar!.originalSentence}。${session.instruction}',
      JourneyChallengeType.missingSentence =>
        '${session.questionTitle}。${session.contextBefore}。空缺。${session.contextAfter}。${session.instruction}',
    };
  }

  String _explanationNarration(_ChallengeSession session) {
    if (session.type == JourneyChallengeType.grammarRepair) {
      final grammar = session.grammar!;
      return '本模式获得${session.reward ?? '碎银'}。病句类型，${grammar.errorType}。错误位置，${grammar.errorLocation}。原句，${grammar.originalSentence}。修改后，${grammar.correctedSentence}。为什么错误，${grammar.whyWrong}。修改原则，${grammar.revisionRule}。记忆方法，${grammar.memoryTip}。';
    }
    return '本模式获得${session.reward ?? '碎银'}。正确答案，${session.correctAnswerText}。为什么，${session.explanation}。记忆方法，${session.memoryTip}。';
  }

  Widget _speakerButton(
    String value, {
    String keyName = 'challenge-speaker',
    Color color = Colors.white,
    double size = 18,
  }) {
    return IconButton(
      key: ValueKey(keyName),
      tooltip: t('朗读'),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(3),
      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
      onPressed: () => unawaited(_speak(value)),
      icon: Icon(Icons.volume_up_rounded, color: color, size: size),
    );
  }

  Future<void> _showResolutionDialog(_ChallengeSession session) async {
    final finalMode = _activeIndex == _sessions.length - 1;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        key: const ValueKey('challenge-explanation-dialog'),
        titlePadding: const EdgeInsets.fromLTRB(18, 14, 8, 4),
        contentPadding: const EdgeInsets.fromLTRB(14, 4, 14, 8),
        actionsPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        title: Row(
          children: [
            const Icon(Icons.auto_awesome_rounded, color: PhoenixTheme.gold),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                t('${session.typeLabel} · 讲解'),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            _speakerButton(
              _explanationNarration(session),
              keyName: 'challenge-explanation-speaker',
              color: PhoenixTheme.red,
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(dialogContext).height * .62,
          ),
          child: SingleChildScrollView(child: _explanationCard()),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const ValueKey('challenge-dialog-action'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              icon: Icon(
                finalMode ? Icons.verified_rounded : Icons.arrow_forward_rounded,
              ),
              label: Text(
                t(finalMode ? '完成三连挑战' : '进入下一种挑战'),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

'''
    text = replace_once(
        text,
        "  Future<void> _submit() async {\n",
        narration_methods + "  Future<void> _submit() async {\n",
        'insert challenge narration methods',
    )

    submit_replacement = r'''  Future<void> _submit() async {
    final session = _session;
    if (!session.canSubmit || session.resolved || _sendingReward) return;

    late final _ChallengeSubmission result;
    setState(() => result = session.submit());
    if (!result.resolved || result.reward == null) return;

    setState(() => _sendingReward = true);
    try {
      if (_rewardedModes.add(_activeIndex)) {
        await widget.onResolved(result.reward!, session.awardId);
      }
    } finally {
      if (mounted) setState(() => _sendingReward = false);
    }
    if (!mounted) return;

    await _showResolutionDialog(session);
    if (!mounted) return;

    final allCompleted = _sessions.every((item) => item.resolved);
    if (allCompleted && !_completionSent) {
      _completionSent = true;
      await widget.onAllCompleted();
      return;
    }
    _nextMode();
  }

  void _openMode'''
    text = regex_once(
        text,
        r"  Future<void> _submit\(\) async \{.*?\n  \}\n\n  void _openMode",
        submit_replacement,
        'replace challenge submit flow',
    )
    text = replace_once(
        text,
        "    setState(() => _activeIndex = index);\n"
        "  }\n\n"
        "  void _nextMode() {\n",
        "    setState(() => _activeIndex = index);\n"
        "    _scheduleAutoNarration();\n"
        "  }\n\n"
        "  void _nextMode() {\n",
        'challenge open mode narration',
    )
    text = replace_once(
        text,
        "    setState(() => _activeIndex += 1);\n"
        "  }\n",
        "    setState(() => _activeIndex += 1);\n"
        "    _scheduleAutoNarration();\n"
        "  }\n",
        'challenge next mode narration',
    )

    build_replacement = r'''  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('journey-challenge-panel'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _modeStrip(),
        const SizedBox(height: 7),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FittedBox(
                key: const ValueKey('challenge-fit-area'),
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _questionCard(),
                      const SizedBox(height: 7),
                      _answerArea(),
                      if (_session.feedback.isNotEmpty && !_session.resolved) ...[
                        const SizedBox(height: 7),
                        _hintCard(),
                      ],
                      if (!_session.resolved) ...[
                        const SizedBox(height: 7),
                        FilledButton.icon(
                          key: const ValueKey('challenge-submit'),
                          onPressed: _session.canSubmit && !_sendingReward
                              ? _submit
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: PhoenixTheme.red.withValues(alpha: .92),
                            foregroundColor: Colors.white,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                          icon: _sendingReward
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 17,
                                ),
                          label: Text(
                            t('提交第 ${_session.attempts + 1} / 3 次答案'),
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ] else if (_activeIndex == _sessions.length - 1) ...[
                        const SizedBox(height: 7),
                        _modeFinishButton(),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

'''
    text = regex_once(
        text,
        r"  @override\n  Widget build\(BuildContext context\) \{.*?\n  \}\n\n(?=  Widget _modeStrip\(\))",
        build_replacement,
        'replace challenge scrolling layout',
    )

    text = replace_once(
        text,
        "              Container(\n"
        "                key: ValueKey(\n"
        "                  'challenge-difficulty-${_session.difficulty.name}',\n"
        "                ),\n",
        "              _speakerButton(\n"
        "                _questionNarration(_session),\n"
        "                keyName: 'challenge-question-speaker',\n"
        "                color: const Color(0xFF7A4B2B),\n"
        "              ),\n"
        "              const SizedBox(width: 2),\n"
        "              Container(\n"
        "                key: ValueKey(\n"
        "                  'challenge-difficulty-${_session.difficulty.name}',\n"
        "                ),\n",
        'question speaker',
    )

    context_old = """      child: Text(
        t(value),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          height: 1.4,
          fontWeight: FontWeight.w700,
        ),
      ),
"""
    context_new = """      child: Row(
        children: [
          Expanded(
            child: Text(
              t(value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _speakerButton(
            value,
            keyName: 'challenge-context-speaker-${value.hashCode}',
          ),
        ],
      ),
"""
    text = replace_once(text, context_old, context_new, 'context speaker')

    option_old = """              Expanded(
                child: Text(
                  t(option.text),
                  style: TextStyle(
                    color: accent,
                    fontSize: 11.2,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
"""
    option_new = """              Expanded(
                child: Text(
                  t(option.text),
                  style: TextStyle(
                    color: accent,
                    fontSize: 11.2,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _speakerButton(
                option.text,
                keyName: 'challenge-option-speaker-${option.id}',
                color: accent,
                size: 17,
              ),
"""
    text = replace_once(text, option_old, option_new, 'option speakers')

    hint_old = """          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(_session.resolved ? '结果' : '提示'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  t(_session.feedback),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
"""
    hint_new = hint_old + """          _speakerButton(
            _session.feedback,
            keyName: 'challenge-hint-speaker',
          ),
"""
    text = replace_once(text, hint_old, hint_new, 'hint speaker')

    explanation_title_old = """              Expanded(
                child: Text(
                  t('本模式获得 ${_session.reward ?? '碎银'}'),
                  key: ValueKey('challenge-reward-${_session.rewardCode}'),
                  style: const TextStyle(
                    color: Color(0xFF315B32),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
"""
    explanation_title_new = explanation_title_old + """              _speakerButton(
                _explanationNarration(_session),
                keyName: 'challenge-card-explanation-speaker',
                color: const Color(0xFF315B32),
              ),
"""
    text = replace_once(
        text,
        explanation_title_old,
        explanation_title_new,
        'explanation speaker',
    )

    path.write_text(text, encoding='utf-8')


def patch_tests() -> None:
    path = ROOT / 'app/test/journey_challenge_panel_test.dart'
    text = path.read_text(encoding='utf-8')
    text = replace_once(
        text,
        "            onAllCompleted: onAllCompleted ?? () async {},\n"
        "          ),\n",
        "            onAllCompleted: onAllCompleted ?? () async {},\n"
        "            autoNarrate: false,\n"
        "          ),\n",
        'disable auto narration in widget tests',
    )

    text = regex_once(
        text,
        r"Future<void> _tapKey\(WidgetTester tester, String key\) async \{.*?\n\}\n",
        """Future<void> _tapKey(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
""",
        'simplify challenge tap helper',
    )

    text = text.replace(
        "await _tapKey(tester, 'challenge-next-mode');",
        "await _tapKey(tester, 'challenge-dialog-action');",
    )
    text = text.replace(
        "expect(find.byKey(const ValueKey('challenge-next-mode')), findsOneWidget);",
        "expect(find.byKey(const ValueKey('challenge-dialog-action')), findsOneWidget);",
    )
    text = text.replace(
        "    expect(completed, 1);\n"
        "    expect(\n"
        "      find.byKey(const ValueKey('challenge-all-complete')),\n"
        "      findsOneWidget,\n"
        "    );\n",
        "    expect(completed, 0);\n"
        "    await _tapKey(tester, 'challenge-dialog-action');\n"
        "    expect(completed, 1);\n"
        "    expect(\n"
        "      find.byKey(const ValueKey('challenge-all-complete')),\n"
        "      findsOneWidget,\n"
        "    );\n",
    )

    marker = """      expect(
        find.byKey(const ValueKey('challenge-option-distractor-2')),
        findsNothing,
      );
"""
    addition = marker + """      expect(
        find.byKey(const ValueKey('challenge-scroll-area')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('challenge-fit-area')),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.volume_up_rounded), findsWidgets);
"""
    text = replace_once(text, marker, addition, 'single page and speaker assertions')
    path.write_text(text, encoding='utf-8')


def main() -> None:
    patch_special_background()
    patch_city_stamp()
    patch_challenge_panel()
    patch_tests()
    print('audio, single-page challenge, cinematic realm, and collectible stamp patch applied')


if __name__ == '__main__':
    main()
