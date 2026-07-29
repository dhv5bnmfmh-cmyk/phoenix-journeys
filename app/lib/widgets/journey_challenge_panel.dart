import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/language_proficiency.dart';
import '../services/challenge_option_balancer.dart';
import '../services/narration_controller.dart';
import '../theme/phoenix_theme.dart';

typedef JourneyChallengeResolved =
    Future<void> Function(String reward, String awardId);
typedef JourneyChallengeCompleted = Future<void> Function();

enum JourneyChallengeType { paragraphRebuild, grammarRepair, missingSentence }

enum JourneyChallengeDifficulty { beginner, standard, advanced }

const fixedJourneyChallengeTypes = <JourneyChallengeType>[
  JourneyChallengeType.paragraphRebuild,
  JourneyChallengeType.grammarRepair,
  JourneyChallengeType.missingSentence,
];

const int journeyChallengeOptionCount = 4;


@visibleForTesting
String adaptiveChallengeHint({
  required JourneyChallengeType type,
  required JourneyChallengeDifficulty difficulty,
  required int attempt,
}) {
  final secondAttempt = attempt >= 2;
  return switch (difficulty) {
    JourneyChallengeDifficulty.beginner => switch (type) {
        JourneyChallengeType.paragraphRebuild => secondAttempt
            ? '先选开头，再找最后发生的变化。'
            : '先找写地点、时间或人物出现的句子。',
        JourneyChallengeType.grammarRepair => secondAttempt
            ? '读一遍修改后的句子，看看主语和动作是否搭配。'
            : '先找主语，再看哪个词让句子变得不自然。',
        JourneyChallengeType.missingSentence => secondAttempt
            ? '正确句要能连接前一句的人物和后一句的结果。'
            : '先看前一句说的是谁，再看后一句发生了什么。',
      },
    JourneyChallengeDifficulty.standard => switch (type) {
        JourneyChallengeType.paragraphRebuild => secondAttempt
            ? '开头介绍整体，中间发生行动，最后才出现观察、决定或结果。'
            : '先找交代地点或时间的句子，再安排人物行动和最后的变化。',
        JourneyChallengeType.grammarRepair => secondAttempt
            ? '检查关联词搭配、主语位置和前后句式是否平行。'
            : '先检查句子有没有明确主语，再看动词与宾语是否自然。',
        JourneyChallengeType.missingSentence => secondAttempt
            ? '正确句必须既接住前文，又能解释后文为什么会出现。'
            : '同时观察前一句留下的主语，以及后一句出现的结果或转折。',
      },
    JourneyChallengeDifficulty.advanced => switch (type) {
        JourneyChallengeType.paragraphRebuild => secondAttempt
            ? '比较叙事视角、时间推进和因果落点，排除只在局部通顺的句子。'
            : '先建立段落骨架，再判断每句承担背景、行动、转折还是收束功能。',
        JourneyChallengeType.grammarRepair => secondAttempt
            ? '比较每个方案的句法中心、语义指向与关联结构，排除表面通顺但逻辑松动的修改。'
            : '先定位错误层级：成分、搭配、指代、语序或逻辑，再选择最小且完整的修正。',
        JourneyChallengeType.missingSentence => secondAttempt
            ? '检验候选句是否同时完成指代回接、逻辑过渡和后文铺垫。'
            : '观察前后文的主题链、时间线与因果关系，不要只凭关键词重复判断。',
      },
  };
}

@visibleForTesting
String adaptiveChallengeExplanation({
  required JourneyChallengeType type,
  required JourneyChallengeDifficulty difficulty,
  required String baseExplanation,
}) {
  return switch (difficulty) {
    JourneyChallengeDifficulty.beginner => switch (type) {
        JourneyChallengeType.paragraphRebuild =>
          '故事通常先介绍地点或人物，再写行动，最后写结果。',
        JourneyChallengeType.grammarRepair =>
          '修改后要有清楚的主语，词语也要和动作自然搭配。',
        JourneyChallengeType.missingSentence =>
          '正确句要接住前一句，并让后一句自然发生。',
      },
    JourneyChallengeDifficulty.standard => baseExplanation,
    JourneyChallengeDifficulty.advanced => switch (type) {
        JourneyChallengeType.paragraphRebuild =>
          '$baseExplanation 还要检查叙事焦点、时间推进与段落收束是否连续。',
        JourneyChallengeType.grammarRepair =>
          '$baseExplanation 判断时应同时验证句法中心、语义指向和关联结构。',
        JourneyChallengeType.missingSentence =>
          '$baseExplanation 高质量衔接还要保持主题链、指代对象和逻辑方向一致。',
      },
  };
}

@visibleForTesting
String adaptiveChallengeMemoryTip({
  required JourneyChallengeType type,
  required JourneyChallengeDifficulty difficulty,
  required String baseTip,
}) {
  return switch (difficulty) {
    JourneyChallengeDifficulty.beginner => switch (type) {
        JourneyChallengeType.paragraphRebuild => '记住：地点 → 行动 → 结果。',
        JourneyChallengeType.grammarRepair => '先找谁，再看做什么。',
        JourneyChallengeType.missingSentence => '前一句是谁，后一句为什么。',
      },
    JourneyChallengeDifficulty.standard => baseTip,
    JourneyChallengeDifficulty.advanced => switch (type) {
        JourneyChallengeType.paragraphRebuild =>
          '$baseTip 再标出每句的篇章功能。',
        JourneyChallengeType.grammarRepair =>
          '$baseTip 优先选择改动最小、结构最完整的方案。',
        JourneyChallengeType.missingSentence =>
          '$baseTip 最后反读整段，确认逻辑没有断层。',
      },
  };
}

@visibleForTesting
JourneyChallengeDifficulty challengeDifficultyForProfile(
  ChineseProficiencyProfile? profile,
) {
  return switch (profile?.band) {
    null ||
    PhoenixReadingBand.beginner ||
    PhoenixReadingBand.elementary => JourneyChallengeDifficulty.beginner,
    PhoenixReadingBand.intermediate ||
    PhoenixReadingBand.upperIntermediate => JourneyChallengeDifficulty.standard,
    PhoenixReadingBand.advanced ||
    PhoenixReadingBand.mastery => JourneyChallengeDifficulty.advanced,
  };
}

class JourneyChallengePanel extends StatefulWidget {
  const JourneyChallengePanel({
    super.key,
    required this.journeyId,
    required this.storyParagraphs,
    required this.discoveryTexts,
    required this.profile,
    required this.seed,
    required this.displayText,
    required this.onResolved,
    required this.onAllCompleted,
    this.autoNarrate = true,
  });

  final String journeyId;
  final List<String> storyParagraphs;
  final List<String> discoveryTexts;
  final ChineseProficiencyProfile? profile;
  final int seed;
  final String Function(String) displayText;
  final JourneyChallengeResolved onResolved;
  final JourneyChallengeCompleted onAllCompleted;
  final bool autoNarrate;

  @override
  State<JourneyChallengePanel> createState() => _JourneyChallengePanelState();
}

class _JourneyChallengePanelState extends State<JourneyChallengePanel> {
  late List<_ChallengeSession> _sessions;
  int _activeIndex = 0;
  bool _sendingReward = false;
  bool _completionSent = false;
  bool _focusedReplayActive = false;
  final Set<int> _rewardedModes = <int>{};
  late final NarrationController _narration;
  int _narrationToken = 0;

  String t(String value) => widget.displayText(value);
  _ChallengeSession get _session => _sessions[_activeIndex];

  @override
  void initState() {
    super.initState();
    _narration = NarrationController();
    _buildSessions();
    _scheduleAutoNarration();
  }

  @override
  void didUpdateWidget(covariant JourneyChallengePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seed == widget.seed &&
        oldWidget.journeyId == widget.journeyId &&
        oldWidget.profile?.storageValue == widget.profile?.storageValue) {
      return;
    }
    _buildSessions();
    _scheduleAutoNarration();
  }

  @override
  void dispose() {
    _narration.dispose();
    super.dispose();
  }

  void _buildSessions() {
    final difficulty = challengeDifficultyForProfile(widget.profile);
    _sessions = <_ChallengeSession>[
      for (var index = 0; index < fixedJourneyChallengeTypes.length; index++)
        _ChallengeSession.build(
          journeyId: widget.journeyId,
          storyParagraphs: widget.storyParagraphs,
          discoveryTexts: widget.discoveryTexts,
          difficulty: difficulty,
          type: fixedJourneyChallengeTypes[index],
          seed: widget.seed + index * 997,
        ),
    ];
    _activeIndex = 0;
    _sendingReward = false;
    _completionSent = false;
    _focusedReplayActive = false;
    _rewardedModes.clear();
  }

  void _scheduleAutoNarration() {
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
      return '本模式获得${session.reward ?? '碎银'}。掌握情况，${session.masteryLabel}。训练目标，${session.trainingGoal}。${session.masteryAdvice}。病句类型，${grammar.errorType}。错误位置，${grammar.errorLocation}。原句，${grammar.originalSentence}。修改后，${grammar.correctedSentence}。为什么错误，${grammar.whyWrong}。修改原则，${grammar.revisionRule}。记忆方法，${grammar.memoryTip}。';
    }
    return '本模式获得${session.reward ?? '碎银'}。掌握情况，${session.masteryLabel}。训练目标，${session.trainingGoal}。${session.masteryAdvice}。正确答案，${session.correctAnswerText}。为什么，${session.explanation}。记忆方法，${session.memoryTip}。';
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

  Future<bool> _showResolutionDialog(_ChallengeSession session) async {
    final showJourneySummary =
        _activeIndex == _sessions.length - 1 || _focusedReplayActive;
    var replayWeakest = false;
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _explanationCard(),
                if (showJourneySummary) ...[
                  const SizedBox(height: 9),
                  _journeyMasterySummary(),
                ],
              ],
            ),
          ),
        ),
        actions: [
          if (showJourneySummary && _needsFocusedReplay) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                key: const ValueKey('challenge-replay-weakest'),
                onPressed: () {
                  replayWeakest = true;
                  Navigator.of(dialogContext).pop();
                },
                icon: const Icon(Icons.replay_rounded),
                label: Text(
                  t('再练重点项'),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: const ValueKey('challenge-dialog-action'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              icon: Icon(
                showJourneySummary
                    ? Icons.verified_rounded
                    : Icons.arrow_forward_rounded,
              ),
              label: Text(
                t(showJourneySummary ? '完成三连挑战' : '进入下一种挑战'),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
    return replayWeakest;
  }

  int get _weakestSessionIndex {
    var weakestIndex = 0;
    for (var index = 1; index < _sessions.length; index++) {
      final current = _sessions[weakestIndex];
      final candidate = _sessions[index];
      if (!candidate.correct && current.correct ||
          candidate.correct == current.correct &&
              candidate.attempts > current.attempts) {
        weakestIndex = index;
      }
    }
    return weakestIndex;
  }

  bool get _needsFocusedReplay => _sessions.any(
        (session) => !session.correct || session.attempts > 1,
      );

  void _restartWeakestMode() {
    final index = _weakestSessionIndex;
    final previous = _sessions[index];
    setState(() {
      _sessions[index] = _ChallengeSession.build(
        journeyId: widget.journeyId,
        storyParagraphs: widget.storyParagraphs,
        discoveryTexts: widget.discoveryTexts,
        difficulty: previous.difficulty,
        type: previous.type,
        seed: previous.seed,
      );
      _activeIndex = index;
      _completionSent = false;
      _focusedReplayActive = true;
    });
    _scheduleAutoNarration();
  }

  Future<void> _submit() async {
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

    final replayWeakest = await _showResolutionDialog(session);
    if (!mounted) return;
    if (replayWeakest) {
      _restartWeakestMode();
      return;
    }

    final allCompleted = _sessions.every((item) => item.resolved);
    if (allCompleted && !_completionSent) {
      _completionSent = true;
      _focusedReplayActive = false;
      await widget.onAllCompleted();
      return;
    }
    _nextMode();
  }

  void _openMode(int index) {
    final canOpen = index <= _activeIndex || _sessions[index].resolved;
    if (!canOpen || index == _activeIndex) return;
    setState(() => _activeIndex = index);
    _scheduleAutoNarration();
  }

  void _nextMode() {
    if (!_session.resolved || _activeIndex >= _sessions.length - 1) return;
    setState(() => _activeIndex += 1);
    _scheduleAutoNarration();
  }

  @override
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
                      if (_session.feedback.isNotEmpty &&
                          !_session.resolved) ...[
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
                            backgroundColor: PhoenixTheme.red.withValues(
                              alpha: .92,
                            ),
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

  Widget _modeStrip() {
    return Row(
      key: const ValueKey('challenge-mode-strip'),
      children: [
        for (var index = 0; index < _sessions.length; index++) ...[
          Expanded(
            child: _ModeChip(
              key: ValueKey('challenge-mode-${_sessions[index].type.name}'),
              number: index + 1,
              label: t(_sessions[index].typeLabel),
              active: index == _activeIndex,
              completed: _sessions[index].resolved,
              enabled: index <= _activeIndex || _sessions[index].resolved,
              onTap: () => _openMode(index),
            ),
          ),
          if (index < _sessions.length - 1) const SizedBox(width: 5),
        ],
      ],
    );
  }

  Widget _questionCard() {
    return Container(
      key: const ValueKey('challenge-question-card'),
      padding: const EdgeInsets.fromLTRB(11, 9, 11, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EBD4).withValues(alpha: .88),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFD9BC82).withValues(alpha: .72),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_session.typeIcon, color: const Color(0xFF7A4B2B), size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  t(_session.questionTitle),
                  style: const TextStyle(
                    color: Color(0xFF3A291D),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _speakerButton(
                _questionNarration(_session),
                keyName: 'challenge-question-speaker',
                color: const Color(0xFF7A4B2B),
              ),
              const SizedBox(width: 2),
              Container(
                key: ValueKey(
                  'challenge-difficulty-${_session.difficulty.name}',
                ),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A4B2B).withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  t('难度 · ${_session.difficultyLabel}'),
                  style: const TextStyle(
                    color: Color(0xFF7A4B2B),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            t(_session.instruction),
            style: const TextStyle(
              color: Color(0xFF49382C),
              fontSize: 11.5,
              height: 1.45,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            key: const ValueKey('challenge-training-goal'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.track_changes_rounded,
                color: Color(0xFF7A4B2B),
                size: 13,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  t('训练目标 · ${_session.trainingGoal}'),
                  style: const TextStyle(
                    color: Color(0xFF7A4B2B),
                    fontSize: 10,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            t(
              _session.resolved
                  ? '本模式已完成'
                  : '第 ${_session.attempts + 1} / 3 次 · 候选答案 ${_session.options.length} 个',
            ),
            style: TextStyle(
              color: const Color(0xFF49382C).withValues(alpha: .62),
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerArea() {
    return Column(
      key: const ValueKey('challenge-answer-area'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        switch (_session.type) {
          JourneyChallengeType.paragraphRebuild => _paragraphBody(),
          JourneyChallengeType.grammarRepair => _grammarBody(),
          JourneyChallengeType.missingSentence => _missingBody(),
        },
      ],
    );
  }

  Widget _paragraphBody() {
    final selected = _session.selectedParagraphOptions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          key: const ValueKey('challenge-paragraph-answer'),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .22),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: .12)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: selected.isEmpty
                    ? Text(
                        t('依次点击 ${_session.correctIds.length} 句，拼回短文'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var index = 0; index < selected.length; index++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${index + 1}. ${t(selected[index].text)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              _speakerButton(
                selected.isEmpty
                    ? '依次点击${_session.correctIds.length}句，拼回短文'
                    : selected.map((item) => item.text).join('。'),
                keyName: 'challenge-paragraph-speaker',
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        _challengeOptions(),
        const SizedBox(height: 7),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            key: const ValueKey('challenge-undo'),
            onPressed: _session.resolved || _session.selectedIds.isEmpty
                ? null
                : () => setState(_session.undoParagraphSelection),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.undo_rounded, size: 16),
            label: Text(t('撤回最后一句')),
          ),
        ),
      ],
    );
  }

  Widget _grammarBody() {
    final grammar = _session.grammar!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          key: const ValueKey('challenge-grammar-sentence'),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .24),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: .12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  t(grammar.originalSentence),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.2,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _speakerButton(
                grammar.originalSentence,
                keyName: 'challenge-grammar-sentence-speaker',
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Text(
          t('第一步 · 点击有问题的部分'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (var index = 0; index < grammar.segments.length; index++)
              ChoiceChip(
                key: ValueKey('challenge-grammar-segment-$index'),
                selected: _session.selectedGrammarSegment == index,
                onSelected: _session.resolved
                    ? null
                    : (_) => setState(() {
                        _session.selectedGrammarSegment = index;
                        _session.feedback = '';
                      }),
                selectedColor: const Color(0xFFFFD89A).withValues(alpha: .96),
                backgroundColor: Colors.black.withValues(alpha: .28),
                side: BorderSide(color: Colors.white.withValues(alpha: .16)),
                label: Text(
                  t(grammar.segments[index]),
                  style: TextStyle(
                    color: _session.selectedGrammarSegment == index
                        ? const Color(0xFF34291F)
                        : Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          t('第二步 · 选择最自然的修改'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        _challengeOptions(),
      ],
    );
  }

  Widget _missingBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _contextSentence(_session.contextBefore),
        const SizedBox(height: 6),
        Container(
          key: const ValueKey('challenge-missing-slot'),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: PhoenixTheme.gold.withValues(alpha: .13),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .54)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _session.selectedSingleOption == null
                      ? t('请选择一句放在这里')
                      : t(_session.selectedSingleOption!.text),
                  style: TextStyle(
                    color: _session.selectedSingleOption == null
                        ? Colors.white60
                        : Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _speakerButton(
                _session.selectedSingleOption?.text ?? '请选择一句放在这里',
                keyName: 'challenge-missing-slot-speaker',
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _contextSentence(_session.contextAfter),
        const SizedBox(height: 8),
        _challengeOptions(),
      ],
    );
  }

  Widget _contextSentence(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
    );
  }

  Widget _challengeOptions() {
    assert(_session.options.length == journeyChallengeOptionCount);
    return Column(
      key: const ValueKey('challenge-four-options'),
      children: [
        for (var index = 0; index < _session.options.length; index++) ...[
          _optionTile(_session.options[index], index),
          if (index < _session.options.length - 1) const SizedBox(height: 6),
        ],
      ],
    );
  }

  Widget _optionTile(_ChallengeOption option, int index) {
    final selected = _session.isOptionSelected(option.id);
    final revealedCorrect = _session.resolved && option.isCorrect;
    final selectedWrong = _session.resolved && selected && !option.isCorrect;
    final accent = revealedCorrect
        ? const Color(0xFF8DDBA9)
        : selectedWrong
        ? const Color(0xFFF08C82)
        : selected
        ? PhoenixTheme.gold
        : Colors.white;

    return Material(
      key: ValueKey('challenge-option-${option.id}'),
      color: Colors.black.withValues(alpha: selected ? .38 : .25),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: _session.resolved
            ? null
            : () => setState(() => _session.selectOption(option)),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.fromLTRB(9, 8, 9, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: accent.withValues(
                alpha: selected || revealedCorrect ? .78 : .18,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _hintCard() {
    return Container(
      key: const ValueKey('challenge-hint-card'),
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: _session.resolved
            ? const Color(0xFF244330).withValues(alpha: .92)
            : const Color(0xFF6B382F).withValues(alpha: .92),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: .12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _session.resolved
                ? Icons.check_circle_rounded
                : Icons.lightbulb_rounded,
            size: 17,
            color: _session.resolved
                ? const Color(0xFFB8E1C1)
                : const Color(0xFFFFD3A2),
          ),
          const SizedBox(width: 7),
          Expanded(
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
          _speakerButton(_session.feedback, keyName: 'challenge-hint-speaker'),
        ],
      ),
    );
  }

  Widget _explanationCard() {
    return Container(
      key: const ValueKey('challenge-explanation'),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0DF).withValues(alpha: .94),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA5BC91)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monetization_on_rounded,
                color: Color(0xFF7A5A1D),
                size: 19,
              ),
              const SizedBox(width: 6),
              Expanded(
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
              _speakerButton(
                _explanationNarration(_session),
                keyName: 'challenge-card-explanation-speaker',
                color: const Color(0xFF315B32),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            key: const ValueKey('challenge-mastery-summary'),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF315B32).withValues(alpha: .07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF315B32).withValues(alpha: .14),
              ),
            ),
            child: Text(
              t(
                '掌握情况 · ${_session.masteryLabel}\n'
                '训练目标 · ${_session.trainingGoal}\n'
                '${_session.masteryAdvice}',
              ),
              style: const TextStyle(
                color: Color(0xFF315B32),
                fontSize: 10,
                height: 1.4,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 2),
          if (_session.type == JourneyChallengeType.grammarRepair)
            ..._grammarExplanationLines()
          else ...[
            _explanationLine('正确答案', _session.correctAnswerText),
            _explanationLine('为什么', _session.adaptiveExplanation),
            _explanationLine('记忆方法', _session.adaptiveMemoryTip),
          ],
        ],
      ),
    );
  }

  Widget _journeyMasterySummary() {
    final passed = _sessions.where((session) => session.correct).length;
    final firstTry = _sessions
        .where((session) => session.correct && session.attempts == 1)
        .length;
    final weakest = _sessions.reduce((current, candidate) {
      if (!candidate.correct && current.correct) return candidate;
      if (candidate.correct == current.correct &&
          candidate.attempts > current.attempts) {
        return candidate;
      }
      return current;
    });
    final headline = firstTry == _sessions.length
        ? '三项能力已掌握'
        : passed == _sessions.length
        ? '三项挑战已完成'
        : '已完成 $passed / ${_sessions.length} 项';

    return Container(
      key: const ValueKey('challenge-journey-mastery-summary'),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EBD4).withValues(alpha: .94),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9BC82)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('旅程学习总结 · $headline'),
            style: const TextStyle(
              color: Color(0xFF5D3B22),
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          for (final session in _sessions)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                key: ValueKey('challenge-summary-${session.type.name}'),
                children: [
                  Icon(
                    session.correct
                        ? Icons.check_circle_rounded
                        : Icons.replay_circle_filled_rounded,
                    color: session.correct
                        ? const Color(0xFF315B32)
                        : const Color(0xFF9A5B31),
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t(
                        '${session.typeLabel} · ${session.masteryLabel}'
                        ' · ${session.attempts} 次',
                      ),
                      style: const TextStyle(
                        color: Color(0xFF49382C),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 2),
          Text(
            t('下一步 · 重点复习${weakest.typeLabel}：${weakest.trainingGoal}。'
                '${weakest.masteryAdvice}'),
            style: const TextStyle(
              color: Color(0xFF6D4A2B),
              fontSize: 10,
              height: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _grammarExplanationLines() {
    final grammar = _session.grammar!;
    return switch (_session.difficulty) {
      JourneyChallengeDifficulty.beginner => [
          _explanationLine('错误位置', grammar.errorLocation),
          _explanationLine('修改后', grammar.correctedSentence),
          _explanationLine('简单规则', grammar.revisionRule),
          _explanationLine('记忆方法', grammar.memoryTip),
        ],
      JourneyChallengeDifficulty.standard => [
          _explanationLine('病句类型', grammar.errorType),
          _explanationLine('错误位置', grammar.errorLocation),
          _explanationLine('原句', grammar.originalSentence),
          _explanationLine('修改后', grammar.correctedSentence),
          _explanationLine('为什么错误', grammar.whyWrong),
          _explanationLine('修改原则', grammar.revisionRule),
          _explanationLine('记忆方法', grammar.memoryTip),
        ],
      JourneyChallengeDifficulty.advanced => [
          _explanationLine('病句类型', grammar.errorType),
          _explanationLine('错误位置', grammar.errorLocation),
          _explanationLine('原句', grammar.originalSentence),
          _explanationLine('修改后', grammar.correctedSentence),
          _explanationLine('为什么错误', grammar.whyWrong),
          _explanationLine('修改原则', grammar.revisionRule),
          _explanationLine(
            '结构分析',
            '${grammar.errorType}。${grammar.whyWrong} ${grammar.revisionRule}',
          ),
          _explanationLine('记忆方法', grammar.memoryTip),
        ],
    };
  }

  Widget _explanationLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t(label),
            style: const TextStyle(
              color: Color(0xFF557751),
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            t(value),
            style: const TextStyle(
              color: Color(0xFF263B27),
              fontSize: 10.5,
              height: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeFinishButton() {
    final finalMode = _activeIndex == _sessions.length - 1;
    return OutlinedButton.icon(
      key: ValueKey(
        finalMode ? 'challenge-all-complete' : 'challenge-next-mode',
      ),
      onPressed: finalMode ? null : _nextMode,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: .42)),
        backgroundColor: Colors.black.withValues(alpha: .18),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      icon: Icon(
        finalMode ? Icons.verified_rounded : Icons.arrow_forward_rounded,
        size: 17,
      ),
      label: Text(
        t(finalMode ? '三种挑战全部完成' : '进入下一种挑战'),
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    super.key,
    required this.number,
    required this.label,
    required this.active,
    required this.completed,
    required this.enabled,
    required this.onTap,
  });

  final int number;
  final String label;
  final bool active;
  final bool completed;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = active || completed ? Colors.white : Colors.white60;
    return Material(
      color: active
          ? PhoenixTheme.red.withValues(alpha: .78)
          : completed
          ? const Color(0xFF315B32).withValues(alpha: .76)
          : Colors.black.withValues(alpha: .2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                completed
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: foreground,
                size: 14,
              ),
              if (!completed) ...[
                Text(
                  '$number',
                  style: TextStyle(
                    color: foreground,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
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

class _ChallengeSession {
  _ChallengeSession({
    required this.journeyId,
    required this.seed,
    required this.type,
    required this.difficulty,
    required this.options,
    required this.correctIds,
    required this.questionTitle,
    required this.instruction,
    required this.explanation,
    required this.memoryTip,
    this.grammar,
    this.contextBefore = '',
    this.contextAfter = '',
  });

  factory _ChallengeSession.build({
    required String journeyId,
    required List<String> storyParagraphs,
    required List<String> discoveryTexts,
    required JourneyChallengeDifficulty difficulty,
    required JourneyChallengeType type,
    required int seed,
  }) {
    return switch (type) {
      JourneyChallengeType.paragraphRebuild => _buildParagraph(
        journeyId,
        storyParagraphs,
        difficulty,
        seed,
      ),
      JourneyChallengeType.grammarRepair => _buildGrammar(
        journeyId,
        difficulty,
        seed,
      ),
      JourneyChallengeType.missingSentence => _buildMissing(
        journeyId,
        storyParagraphs,
        discoveryTexts,
        difficulty,
        seed,
      ),
    };
  }

  final String journeyId;
  final int seed;
  final JourneyChallengeType type;
  final JourneyChallengeDifficulty difficulty;
  final List<_ChallengeOption> options;
  final List<String> correctIds;
  final String questionTitle;
  final String instruction;
  final String explanation;
  final String memoryTip;
  final _GrammarSpec? grammar;
  final String contextBefore;
  final String contextAfter;

  final List<String> selectedIds = <String>[];
  int? selectedGrammarSegment;
  int attempts = 0;
  bool resolved = false;
  bool correct = false;
  String? reward;
  String feedback = '';

  String get awardId => '$journeyId:${type.name}:$seed';

  String get typeLabel => switch (type) {
    JourneyChallengeType.paragraphRebuild => '短文复原',
    JourneyChallengeType.grammarRepair => '语病修复',
    JourneyChallengeType.missingSentence => '补回句子',
  };

  IconData get typeIcon => switch (type) {
    JourneyChallengeType.paragraphRebuild => Icons.reorder_rounded,
    JourneyChallengeType.grammarRepair => Icons.build_circle_outlined,
    JourneyChallengeType.missingSentence => Icons.space_bar_rounded,
  };

  String get difficultyLabel => switch (difficulty) {
    JourneyChallengeDifficulty.beginner => '初级',
    JourneyChallengeDifficulty.standard => '标准',
    JourneyChallengeDifficulty.advanced => '高级',
  };

  String get trainingGoal => switch ((type, difficulty)) {
    (
      JourneyChallengeType.paragraphRebuild,
      JourneyChallengeDifficulty.beginner,
    ) =>
      '辨认地点、行动与结果顺序',
    (
      JourneyChallengeType.paragraphRebuild,
      JourneyChallengeDifficulty.standard,
    ) =>
      '建立背景、行动与转折结构',
    (
      JourneyChallengeType.paragraphRebuild,
      JourneyChallengeDifficulty.advanced,
    ) =>
      '判断叙事视角、因果与收束',
    (
      JourneyChallengeType.grammarRepair,
      JourneyChallengeDifficulty.beginner,
    ) =>
      '找出主语和明显的不自然词语',
    (
      JourneyChallengeType.grammarRepair,
      JourneyChallengeDifficulty.standard,
    ) =>
      '检查搭配、语序与句式平行',
    (
      JourneyChallengeType.grammarRepair,
      JourneyChallengeDifficulty.advanced,
    ) =>
      '分析句法中心、指向与逻辑',
    (
      JourneyChallengeType.missingSentence,
      JourneyChallengeDifficulty.beginner,
    ) =>
      '连接前文人物与后文结果',
    (
      JourneyChallengeType.missingSentence,
      JourneyChallengeDifficulty.standard,
    ) =>
      '同时完成承接与铺垫',
    (
      JourneyChallengeType.missingSentence,
      JourneyChallengeDifficulty.advanced,
    ) =>
      '保持主题链、指代与因果连续',
  };

  String get masteryLabel {
    if (!correct) return '需要复习';
    return switch (attempts) {
      1 => '已掌握',
      2 => '基本掌握',
      _ => '正在巩固',
    };
  }

  String get masteryAdvice {
    if (!correct) {
      return '先按提示重读正确答案，再回到相同训练目标练习一次。';
    }
    return switch (attempts) {
      1 => '可以继续挑战更复杂的表达与逻辑。',
      2 => '已经理解核心方法，建议用记忆提示再检查一次。',
      _ => '已经完成修正，建议复述规则后再进入下一题。',
    };
  }

  bool get canSubmit => switch (type) {
    JourneyChallengeType.paragraphRebuild =>
      selectedIds.length == correctIds.length,
    JourneyChallengeType.grammarRepair =>
      selectedGrammarSegment != null && selectedIds.length == 1,
    JourneyChallengeType.missingSentence => selectedIds.length == 1,
  };

  String get rewardCode => switch (reward) {
    '金币' => 'gold',
    '银币' => 'silver',
    '铜币' => 'bronze',
    _ => 'fragment',
  };

  List<_ChallengeOption> get selectedParagraphOptions => selectedIds
      .map((id) => options.firstWhere((option) => option.id == id))
      .toList(growable: false);

  _ChallengeOption? get selectedSingleOption => selectedIds.isEmpty
      ? null
      : options.firstWhere((option) => option.id == selectedIds.first);

  bool isOptionSelected(String id) => selectedIds.contains(id);

  String get correctAnswerText {
    if (type == JourneyChallengeType.grammarRepair) {
      return grammar!.correctedSentence;
    }
    return correctIds
        .map((id) => options.firstWhere((option) => option.id == id).text)
        .join(type == JourneyChallengeType.paragraphRebuild ? '\n' : '');
  }

  void selectOption(_ChallengeOption option) {
    if (resolved) return;
    if (type == JourneyChallengeType.paragraphRebuild) {
      if (selectedIds.contains(option.id) ||
          selectedIds.length >= correctIds.length) {
        return;
      }
      selectedIds.add(option.id);
    } else {
      selectedIds
        ..clear()
        ..add(option.id);
    }
    feedback = '';
  }

  void undoParagraphSelection() {
    if (resolved || selectedIds.isEmpty) return;
    selectedIds.removeLast();
    feedback = '';
  }

  _ChallengeSubmission submit() {
    if (!canSubmit || resolved) {
      return const _ChallengeSubmission(resolved: false);
    }
    attempts += 1;
    correct = _isCorrect();
    final exhausted = attempts >= 3;
    if (correct || exhausted) {
      resolved = true;
      reward = correct
          ? switch (attempts) {
              1 => '金币',
              2 => '银币',
              _ => '铜币',
            }
          : '碎银';
      if (!correct) _revealCorrectSelection();
      feedback = correct
          ? '回答正确。题目、提示和讲解已经分开显示，请继续查看原因。'
          : '三次机会已经结束。Phoenix 已展示正确答案，你可以继续下一种挑战。';
      return _ChallengeSubmission(resolved: true, reward: reward);
    }

    feedback = attempts == 1 ? firstHint : secondHint;
    selectedIds.clear();
    selectedGrammarSegment = null;
    return const _ChallengeSubmission(resolved: false);
  }

  bool _isCorrect() {
    if (type == JourneyChallengeType.grammarRepair) {
      return selectedGrammarSegment == grammar!.problemSegmentIndex &&
          selectedIds.single == grammar!.correctOptionId;
    }
    if (selectedIds.length != correctIds.length) return false;
    for (var index = 0; index < correctIds.length; index++) {
      if (selectedIds[index] != correctIds[index]) return false;
    }
    return true;
  }

  void _revealCorrectSelection() {
    selectedIds
      ..clear()
      ..addAll(correctIds);
    if (type == JourneyChallengeType.grammarRepair) {
      selectedGrammarSegment = grammar!.problemSegmentIndex;
    }
  }

  String get firstHint => adaptiveChallengeHint(
    type: type,
    difficulty: difficulty,
    attempt: 1,
  );

  String get secondHint => adaptiveChallengeHint(
    type: type,
    difficulty: difficulty,
    attempt: 2,
  );

  String get adaptiveExplanation => adaptiveChallengeExplanation(
    type: type,
    difficulty: difficulty,
    baseExplanation: explanation,
  );

  String get adaptiveMemoryTip => adaptiveChallengeMemoryTip(
    type: type,
    difficulty: difficulty,
    baseTip: memoryTip,
  );

  static _ChallengeSession _buildParagraph(
    String journeyId,
    List<String> storyParagraphs,
    JourneyChallengeDifficulty difficulty,
    int seed,
  ) {
    final requiredCount = switch (difficulty) {
      JourneyChallengeDifficulty.beginner => 2,
      JourneyChallengeDifficulty.standard => 3,
      JourneyChallengeDifficulty.advanced => 3,
    };
    final source = _extractSentences(storyParagraphs);
    final fallback = <String>[
      '清晨，探索者来到今天的目的地。',
      '他沿着主要路线慢慢向前走。',
      '一路上的景色不断发生变化。',
      '最后，他把最深的发现记了下来。',
    ];
    final correctTexts = <String>[];
    for (final sentence in [...source, ...fallback]) {
      if (correctTexts.length >= requiredCount) break;
      if (!correctTexts.contains(sentence)) correctTexts.add(sentence);
    }
    final correctOptions = <_ChallengeOption>[
      for (var index = 0; index < correctTexts.length; index++)
        _ChallengeOption(
          id: 'correct-$index',
          text: correctTexts[index],
          isCorrect: true,
        ),
    ];
    final distractorTexts = selectBalancedChallengeDistractors(
    correctAnswers: correctTexts,
    candidates: _paragraphDistractors(journeyId),
    count: journeyChallengeOptionCount - correctOptions.length,
  );
    final options = <_ChallengeOption>[...correctOptions];
    var distractorIndex = 0;
    while (options.length < journeyChallengeOptionCount) {
      options.add(
        _ChallengeOption(
          id: 'distractor-$distractorIndex',
          text: distractorTexts[distractorIndex % distractorTexts.length],
        ),
      );
      distractorIndex += 1;
    }
    options.shuffle(math.Random(seed + 17));
    if (_startsWithCorrectOrder(options, correctOptions)) {
      options.add(options.removeAt(0));
    }
    return _ChallengeSession(
      journeyId: journeyId,
      seed: seed,
      type: JourneyChallengeType.paragraphRebuild,
      difficulty: difficulty,
      options: options,
      correctIds: correctOptions.map((option) => option.id).toList(),
      questionTitle: '把散开的故事拼回来',
      instruction: '四个候选句中有 ${correctOptions.length} 句属于原文。请按故事发生的顺序依次点击。',
      explanation: '段落通常先交代地点或时间，再写行动，最后出现观察、变化或决定。',
      memoryTip: '记住“整体 → 行动 → 变化”，不要只看单句是否通顺。',
    );
  }

  static _ChallengeSession _buildGrammar(
    String journeyId,
    JourneyChallengeDifficulty difficulty,
    int seed,
  ) {
    final grammar = _grammarForJourney(journeyId, difficulty, seed);

    final replacementCandidates = <String>[
      grammar.correctReplacement,
      ...grammar.distractors,
      grammar.segments[grammar.problemSegmentIndex],
      ...switch (difficulty) {
        JourneyChallengeDifficulty.beginner => <String>[
            '因此${grammar.correctReplacement}',
            '而且${grammar.correctReplacement}',
          ],
        JourneyChallengeDifficulty.standard => <String>[
            '同时${grammar.correctReplacement}',
            '${grammar.correctReplacement}还',
          ],
        JourneyChallengeDifficulty.advanced => <String>[
            '从而${grammar.correctReplacement}',
            '由此${grammar.correctReplacement}',
          ],
      },
    ];
    final distractorTexts = selectBalancedChallengeDistractors(
    correctAnswers: <String>[grammar.correctReplacement],
    candidates: replacementCandidates,
    count: journeyChallengeOptionCount - 1,
  );
  final replacementTexts = <String>[
    grammar.correctReplacement,
    ...distractorTexts,
  ];
    final options = <_ChallengeOption>[
      for (var index = 0;
          index < journeyChallengeOptionCount;
          index++)
        _ChallengeOption(
          id: index == 0 ? 'correct' : 'distractor-$index',
          text: replacementTexts[index],
          isCorrect: index == 0,
        ),
    ]..shuffle(math.Random(seed + 31));

    return _ChallengeSession(
      journeyId: journeyId,
      seed: seed,
      type: JourneyChallengeType.grammarRepair,
      difficulty: difficulty,
      options: options,
      correctIds: const ['correct'],
      questionTitle: '修好这句不自然的话',
      instruction: '先点击病句位置，再从四个长度接近的修改方案中选出最自然的一项。',
      explanation: grammar.whyWrong,
      memoryTip: grammar.memoryTip,
      grammar: grammar,
    );
  }

  static _ChallengeSession _buildMissing(
    String journeyId,
    List<String> storyParagraphs,
    List<String> discoveryTexts,
    JourneyChallengeDifficulty difficulty,
    int seed,
  ) {
    final source = _extractSentences(storyParagraphs);
    final before = source.isNotEmpty ? source[0] : '清晨，探索者来到今天的目的地。';
    final correct = source.length >= 2 ? source[1] : '他沿着主要路线慢慢向前走。';
    final after = source.length >= 3 ? source[2] : '一路上的景色因此不断发生变化。';
    final distractors = selectBalancedChallengeDistractors(
    correctAnswers: <String>[correct],
    candidates: _missingDistractors(
      journeyId,
      discoveryTexts,
      difficulty,
    ),
    count: journeyChallengeOptionCount - 1,
  );
    final optionTexts = <String>[correct, ...distractors];
    final options = <_ChallengeOption>[
      for (var index = 0; index < journeyChallengeOptionCount; index++)
        _ChallengeOption(
          id: index == 0 ? 'correct' : 'distractor-$index',
          text: optionTexts[index],
          isCorrect: index == 0,
        ),
    ]..shuffle(math.Random(seed + 47));

    return _ChallengeSession(
      journeyId: journeyId,
      seed: seed,
      type: JourneyChallengeType.missingSentence,
      difficulty: difficulty,
      options: options,
      correctIds: const ['correct'],
      questionTitle: '补回故事中消失的一句',
      instruction: '阅读前后文，从四个长度接近的答案中选出最能连接上下文的一句。',
      explanation: '正确句承接前文的人物与地点，同时为后文的变化、因果或决定铺路。',
      memoryTip: '补句要同时看两边：前一句留下什么，后一句为什么出现。',
      contextBefore: before,
      contextAfter: after,
    );
  }

  static _GrammarSpec _grammarForJourney(
    String journeyId,
    JourneyChallengeDifficulty difficulty,
    int seed,
  ) {
    final journeySpec = switch (journeyId) {
      'beijing-forbidden-city' ||
      'beijing-summer-palace' ||
      'shanghai-bund' ||
      'xian-city-wall' ||
      'hangzhou-west-lake' ||
      'chengdu-kuanzhai-alley' ||
      'nanjing-qinhuai-river' ||
      'guangzhou-chen-clan-academy' =>
        _adaptiveGrammarForJourney(journeyId, difficulty),
      'literary-roaming' ||
      'myth-tracing' ||
      'strange-night-talks' ||
      'folk-secret-land' =>
        _adaptiveGrammarForJourney(journeyId, difficulty),
      _ => switch (difficulty) {
        JourneyChallengeDifficulty.beginner => const _GrammarSpec(
          segments: ['通过参观这里，', '使游客', '可以看到不同的风景。'],
          problemSegmentIndex: 1,
          originalSentence: '通过参观这里，使游客可以看到不同的风景。',
          correctedSentence: '通过参观这里，游客可以看到不同的风景。',
          correctOptionId: 'correct',
          correctReplacement: '游客',
          distractors: ['因此使游客', '而且游客还', '让游客因此'],
          errorType: '成分残缺：主语缺失',
          errorLocation: '“使游客”中的“使”',
          whyWrong: '“通过……”已经形成介词结构，“使……”又引出结果，整句话便没有明确主语。',
          revisionRule: '删除“使”，让“游客”直接成为主语。',
          memoryTip: '看到“通过……使……”时，先检查句子里还剩不剩主语。',
        ),
        JourneyChallengeDifficulty.standard => const _GrammarSpec(
          segments: ['这条长廊不但可以避雨，', '而且游客还', '看到不同的风景。'],
          problemSegmentIndex: 1,
          originalSentence: '这条长廊不但可以避雨，而且游客还看到不同的风景。',
          correctedSentence: '这条长廊不但可以避雨，而且可以让游客看到不同的风景。',
          correctOptionId: 'correct',
          correctReplacement: '而且可以让游客',
          distractors: ['所以使游客', '并且游客也', '而且游客还会'],
          errorType: '搭配不当：前后主语不一致',
          errorLocation: '“而且游客还”',
          whyWrong: '“不但”后的主语是“长廊”，后半句突然换成“游客”，关联结构不平行。',
          revisionRule: '保持前后主语一致，用“可以让游客”承接“长廊”。',
          memoryTip: '使用“不但……而且……”时，要检查两部分主语和句式是否平行。',
        ),
        JourneyChallengeDifficulty.advanced => const _GrammarSpec(
          segments: ['由于园林采用了借景手法，', '因此使远山', '成为画面的一部分。'],
          problemSegmentIndex: 1,
          originalSentence: '由于园林采用了借景手法，因此使远山成为画面的一部分。',
          correctedSentence: '由于园林采用了借景手法，远山因此成为画面的一部分。',
          correctOptionId: 'correct',
          correctReplacement: '远山因此',
          distractors: ['所以使远山', '而且远山还', '从而让远山也'],
          errorType: '成分赘余：关联词堆叠并导致主语缺失',
          errorLocation: '“因此使远山”',
          whyWrong: '“由于”已经引出原因，再用“因此使”会堆叠关系词，同时让结果句缺少自然主语。',
          revisionRule: '让“远山”成为结果句主语，只保留一个自然的因果标记。',
          memoryTip: '“由于”与“因此”可以呼应，但不要再叠加“使”拿走主语。',
        ),
      },
    };
    // Replays stay anchored to the selected destination and proficiency.
    // Generic grammar drills would break the journey's narrative continuity.
    return journeySpec;
  }

  static _GrammarSpec _adaptiveGrammarForJourney(
    String journeyId,
    JourneyChallengeDifficulty difficulty,
  ) {
    final context = switch (journeyId) {
      'beijing-forbidden-city' => (
          focus: '午门和中轴线',
          insight: '理解宫城的进入秩序',
          subject: '午门',
          action: '规定进入路线',
          result: '感受到宫城秩序',
          cause: '午门控制了进入方向',
          resultSubject: '中轴线',
          resultAction: '显得更加庄严清晰',
        ),
      'beijing-summer-palace' => (
          focus: '昆明湖的倒影',
          insight: '看见万寿山进入画面',
          subject: '长廊',
          action: '连接沿湖景点',
          result: '改变观看节奏',
          cause: '昆明湖产生了倒影',
          resultSubject: '万寿山',
          resultAction: '进入完整的湖山画面',
        ),
      'shanghai-bund' => (
          focus: '外滩与浦东两岸',
          insight: '比较城市的新旧层次',
          subject: '外滩建筑群',
          action: '保存历史街景',
          result: '理解近代商业记忆',
          cause: '黄浦江连接了两岸视线',
          resultSubject: '新旧天际线',
          resultAction: '形成鲜明的时代对照',
        ),
      'xian-city-wall' => (
          focus: '城墙和护城河',
          insight: '看懂连续防御体系',
          subject: '宽阔的墙顶',
          action: '方便守军巡查',
          result: '观察古城格局',
          cause: '城墙围合了古城空间',
          resultSubject: '古今城市边界',
          resultAction: '变得清楚可辨',
        ),
      'hangzhou-west-lake' => (
          focus: '苏堤、桥与远山',
          insight: '发现西湖景色的变化',
          subject: '苏堤',
          action: '组织沿湖路线',
          result: '逐步看见不同景层',
          cause: '天气和季节不断变化',
          resultSubject: '西湖十景',
          resultAction: '呈现不同的观看感受',
        ),
      'chengdu-kuanzhai-alley' => (
          focus: '宽、窄、井三条巷子',
          insight: '分辨不同的生活节奏',
          subject: '院落和茶馆',
          action: '保留街巷生活',
          result: '感受成都的慢节奏',
          cause: '三条巷子的尺度各不相同',
          resultSubject: '街区生活',
          resultAction: '形成丰富的空间层次',
        ),
      'nanjing-qinhuai-river' => (
          focus: '秦淮河的桥梁与灯影',
          insight: '理解夜游路线的文化记忆',
          subject: '秦淮河',
          action: '串联夫子庙和街市',
          result: '读懂夜间文化空间',
          cause: '灯会连接了河流与街市',
          resultSubject: '夜游路线',
          resultAction: '承载更多历史记忆',
        ),
      'guangzhou-chen-clan-academy' => (
          focus: '屋脊陶塑和木石雕刻',
          insight: '读懂其中的岭南故事',
          subject: '陈家祠装饰',
          action: '保存岭南工艺',
          result: '理解宗族文化记忆',
          cause: '多种雕塑共同讲述地方故事',
          resultSubject: '建筑细节',
          resultAction: '成为可阅读的文化线索',
        ),
      'literary-roaming' => (
          focus: '蓝色蝴蝶和竹林梦境',
          insight: '分辨梦与醒的边界',
          subject: '蓝色蝴蝶',
          action: '引导探索者穿过竹林',
          result: '发现梦境深处的岔路',
          cause: '蓝色蝴蝶在岔路前消失',
          resultSubject: '梦境道路',
          resultAction: '显出醒来与继续追寻的两种方向',
        ),
      'myth-tracing' => (
          focus: '月宫遗简和守匣白兔',
          insight: '辨认月光留下的线索',
          subject: '残缺遗简',
          action: '保存月宫旧事',
          result: '追踪白兔守候的秘密',
          cause: '遗简只在月光下显出文字',
          resultSubject: '隐藏线索',
          resultAction: '随着月色逐渐清晰',
        ),
      'strange-night-talks' => (
          focus: '无影夜客和门外呼声',
          insight: '判断客栈异象的来源',
          subject: '夜客留下的铜钱',
          action: '证明陌生人曾经来过',
          result: '怀疑消失的影子',
          cause: '雨夜脚步与敲门声反复出现',
          resultSubject: '客栈走廊',
          resultAction: '变得更加诡异难辨',
        ),
      'folk-secret-land' => (
          focus: '逆流河灯和灯纸姓名',
          insight: '理解祈愿与记忆的联系',
          subject: '逆流河灯',
          action: '承载岸边人们的祈愿',
          result: '寻找名字指向的故事',
          cause: '写有名字的河灯逆流而上',
          resultSubject: '上游倒影',
          resultAction: '显出被遗忘的旧日记忆',
        ),
      _ => throw ArgumentError.value(journeyId, 'journeyId'),
    };

    return switch (difficulty) {
      JourneyChallengeDifficulty.beginner => _GrammarSpec(
          segments: ['通过观察${context.focus}，', '使游客', '可以${context.insight}。'],
          problemSegmentIndex: 1,
          originalSentence:
              '通过观察${context.focus}，使游客可以${context.insight}。',
          correctedSentence:
              '通过观察${context.focus}，游客可以${context.insight}。',
          correctOptionId: 'correct',
          correctReplacement: '游客',
          distractors: const ['因此使游客', '而且游客还', '让游客因此'],
          errorType: '成分残缺：主语缺失',
          errorLocation: '“使游客”中的“使”',
          whyWrong: '“通过……”已经形成介词结构，再用“使”会让整句话没有明确主语。',
          revisionRule: '删除“使”，让“游客”直接成为主语。',
          memoryTip: '看到“通过……使……”时，先检查句子里还剩不剩主语。',
        ),
      JourneyChallengeDifficulty.standard => _GrammarSpec(
          segments: [
            '${context.subject}不但${context.action}，',
            '而且游客还',
            '${context.result}。',
          ],
          problemSegmentIndex: 1,
          originalSentence:
              '${context.subject}不但${context.action}，而且游客还${context.result}。',
          correctedSentence:
              '${context.subject}不但${context.action}，而且让游客${context.result}。',
          correctOptionId: 'correct',
          correctReplacement: '而且让游客',
          distractors: const ['所以游客也', '并且游客还', '而且游客会'],
          errorType: '前后主语与句式不平行',
          errorLocation: '“而且游客还”',
          whyWrong: '“不但”后的主语是景物，后半句突然改用“游客”作主语，关联结构不平行。',
          revisionRule: '保持景物为主语，用“让游客”承接它产生的作用。',
          memoryTip: '使用“不但……而且……”时，要检查两部分主语和句式是否一致。',
        ),
      JourneyChallengeDifficulty.advanced => _GrammarSpec(
          segments: [
            '由于${context.cause}，',
            '因此使${context.resultSubject}',
            '${context.resultAction}。',
          ],
          problemSegmentIndex: 1,
          originalSentence:
              '由于${context.cause}，因此使${context.resultSubject}${context.resultAction}。',
          correctedSentence:
              '由于${context.cause}，${context.resultSubject}因此${context.resultAction}。',
          correctOptionId: 'correct',
          correctReplacement: '${context.resultSubject}因此',
          distractors: [
            '所以使${context.resultSubject}',
            '而且${context.resultSubject}还',
            '从而让${context.resultSubject}',
          ],
          errorType: '关联词赘余并导致主语缺失',
          errorLocation: '“因此使${context.resultSubject}”',
          whyWrong: '“由于”已经引出原因，再叠加“因此使”会让结果句缺少自然主语。',
          revisionRule: '让结果对象直接成为主语，只保留一个自然的因果标记。',
          memoryTip: '“由于”与“因此”可以呼应，但不要再叠加“使”拿走主语。',
        ),
    };
  }


  static List<String> _paragraphDistractors(String journeyId) {
    return switch (journeyId) {
      'literary-roaming' => [
        '蝴蝶停在原地，竹林也从来没有出现变化。',
        '探索者没有做梦，也没有看见任何岔路。',
        '他只沿着直路前进，始终没有回头寻找梦的入口。',
      ],
      'myth-tracing' => [
        '太阳升起以后，遗简才第一次从海底出现。',
        '白兔离开桂林，故事也没有留下任何选择。',
        '探索者把空匣留在岸边，没有继续辨认月光中的文字。',
      ],
      'strange-night-talks' => [
        '客栈从来没有下雨，夜客也一直拥有清楚的影子。',
        '天刚亮时，门外才第一次有人轻轻敲门。',
        '掌柜点亮所有灯火，走廊立刻恢复了白日的安静。',
      ],
      'folk-secret-land' => [
        '所有河灯都停在岸上，从未进入水中。',
        '写着名字的灯顺流远去，没有出现任何倒影。',
        '探索者把灯放回石阶，河面也没有改变流动方向。',
      ],
      _ => _regularJourneyDistractors(journeyId),
    };
  }


  static List<String> _regularJourneyDistractors(String journeyId) {
    return switch (journeyId) {
      'beijing-forbidden-city' => [
        '游客绕过午门，从侧门直接进入了不存在的现代广场。',
        '黄色琉璃瓦说明这里过去只是一处普通民居。',
        '中轴线让所有人随意改变路线，不再区分空间秩序。',
        '红墙与城台只负责装饰，从未影响进入宫城的方式。',
      ],
      'beijing-summer-palace' => [
        '昆明湖的倒影始终不变，与光线和视角没有关系。',
        '长廊只为缩短距离，不会改变游人的观看节奏。',
        '十七孔桥遮住全部远山，使湖面失去空间层次。',
        '万寿山与昆明湖彼此分离，无法组成完整景观。',
      ],
      'shanghai-bund' => [
        '外滩西岸只保留住宅，与银行和贸易没有联系。',
        '浦东天际线与历史建筑属于同一时期，没有对比。',
        '黄浦江把两岸完全隔开，从未参与城市商业发展。',
        '历史街区只有一栋建筑，无法形成连续滨水景观。',
      ],
      'xian-city-wall' => [
        '护城河位于城墙内部，主要用于装饰宫殿庭院。',
        '宽阔墙顶阻止人员移动，因此不能承担巡查功能。',
        '永宁门与角楼彼此独立，没有组成连续防御体系。',
        '站在城墙上只能看见过去，看不到现代城市扩张。',
      ],
      'hangzhou-west-lake' => [
        '苏堤和白堤远离湖面，不会改变游人的观看路线。',
        '西湖十景只记录固定地点，与季节天气没有关系。',
        '桥、柳树与远山始终保持同一位置和视觉层次。',
        '文化命名消除了湖景变化，使每次观看完全相同。',
      ],
      'chengdu-kuanzhai-alley' => [
        '三条巷子的尺度完全相同，也没有不同生活节奏。',
        '院落、茶馆与店铺彼此隔绝，无法形成街巷生活。',
        '保护后的街区只允许游客进入，不再服务居民。',
        '成都的慢生活只是一句广告，与空间使用无关。',
      ],
      'nanjing-qinhuai-river' => [
        '秦淮河只在白天使用，与灯影和夜间路线无关。',
        '夫子庙、桥梁和街市互不相连，无法形成文化空间。',
        '灯会已经概括全部历史，不必讨论科举与文学。',
        '河流只负责分隔两岸，从未承载居民生活记忆。',
      ],
      'guangzhou-chen-clan-academy' => [
        '屋脊装饰全部来自现代印刷，与岭南工艺没有关系。',
        '陶塑、灰塑和木石雕刻只重复一种图案和故事。',
        '陈家祠从未承担宗族教育或成员联络功能。',
        '改为博物馆以后，建筑与社群记忆完全失去联系。',
      ],
      _ => [
        '故事中的地点突然改变，却没有任何前文线索。',
        '人物作出决定以后，后面的结果与决定完全无关。',
        '这一句重复表面景色，却没有推进观察或理解。',
        '时间顺序突然倒转，也没有说明变化发生的原因。',
      ],
    };
  }

  static List<String> _missingDistractors(
    String journeyId,
    List<String> discoveries,
    JourneyChallengeDifficulty difficulty,
  ) {
    final specific = switch (journeyId) {
      'literary-roaming' => [
        '他决定统计竹子的数量，不再观察蝴蝶。',
        '梦境立刻消失，故事也不再讨论醒来。',
        '所有路牌都被收走，因此没有出现选择。',
      ],
      'myth-tracing' => [
        '他把遗简交给山下的商店换了一把雨伞。',
        '月光消失以后，海边突然出现现代高楼。',
        '白兔没有等待任何东西，也没有守着空匣。',
      ],
      'strange-night-talks' => [
        '他打开窗户计算雨滴，没有听见任何声音。',
        '客栈立刻变成白天，夜客也离开了故事。',
        '门外的人只询问房价，从未叫出你的名字。',
      ],
      'folk-secret-land' => [
        '他把所有河灯吹灭，河面从此没有倒影。',
        '灯纸上写的是菜单，与前后的名字无关。',
        '河水完全停止流动，因此不存在上游和下游。',
      ],
      _ => _regularJourneyDistractors(journeyId),
    };
    final discoverySentences = _extractSentences(discoveries);
    final discoveryCandidate = discoverySentences.isEmpty
        ? null
        : discoverySentences.last;
    final levelCandidates = switch (difficulty) {
      JourneyChallengeDifficulty.beginner => <String>[
          ...specific,
          '他很快离开了这里，故事也在这一刻结束。',
          '他继续向前走，却没有留意周围发生的变化。',
        ],
      JourneyChallengeDifficulty.standard => <String>[
          ...specific,
          if (discoveryCandidate != null) discoveryCandidate,
          '他停下脚步，把沿途景色逐一写进记录里。',
          '他沿着原来的路线前进，却忽略了前后线索。',
        ],
      JourneyChallengeDifficulty.advanced => <String>[
          if (discoveryCandidate != null) discoveryCandidate,
          ...specific,
          '他重新检查前文线索，却没有改变原来的判断。',
          '他看似回应了前文，却无法解释后面出现的结果。',
        ],
    };
    final result = <String>[];
    for (final candidate in levelCandidates) {
      final value = candidate.trim();
      if (value.isEmpty || result.contains(value)) continue;
      result.add(value);
    }
    return result;
  }

  static bool _startsWithCorrectOrder(
    List<_ChallengeOption> options,
    List<_ChallengeOption> correct,
  ) {
    if (options.length < correct.length) return false;
    for (var index = 0; index < correct.length; index++) {
      if (options[index].id != correct[index].id) return false;
    }
    return true;
  }

  static List<String> _extractSentences(List<String> paragraphs) {
    final sentences = <String>[];
    final pattern = RegExp(r'[^。！？!?]+[。！？!?]?');
    for (final paragraph in paragraphs) {
      for (final match in pattern.allMatches(paragraph)) {
        var value = match.group(0)?.trim() ?? '';
        if (value.isEmpty) continue;
        if (!RegExp(r'[。！？!?]$').hasMatch(value)) value = '$value。';
        if (!sentences.contains(value)) sentences.add(value);
      }
    }
    return sentences;
  }
}

class _ChallengeSubmission {
  const _ChallengeSubmission({required this.resolved, this.reward});

  final bool resolved;
  final String? reward;
}

class _ChallengeOption {
  const _ChallengeOption({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });

  final String id;
  final String text;
  final bool isCorrect;
}

class _GrammarSpec {
  const _GrammarSpec({
    required this.segments,
    required this.problemSegmentIndex,
    required this.originalSentence,
    required this.correctedSentence,
    required this.correctOptionId,
    required this.correctReplacement,
    required this.distractors,
    required this.errorType,
    required this.errorLocation,
    required this.whyWrong,
    required this.revisionRule,
    required this.memoryTip,
  });

  final List<String> segments;
  final int problemSegmentIndex;
  final String originalSentence;
  final String correctedSentence;
  final String correctOptionId;
  final String correctReplacement;
  final List<String> distractors;
  final String errorType;
  final String errorLocation;
  final String whyWrong;
  final String revisionRule;
  final String memoryTip;
}
