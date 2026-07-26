import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/language_proficiency.dart';
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
                finalMode
                    ? Icons.verified_rounded
                    : Icons.arrow_forward_rounded,
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
                  t(_session.difficultyLabel),
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
          Text(
            t(
              _session.resolved
                  ? '本模式已完成'
                  : '第 ${_session.attempts + 1} / 3 次 · 候选答案固定为 4 个',
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
        const SizedBox(height: 7),
        _fourOptions(),
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
        _fourOptions(),
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
        const SizedBox(height: 6),
        _contextSentence(_session.contextAfter),
        const SizedBox(height: 8),
        _fourOptions(),
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

  Widget _fourOptions() {
    assert(_session.options.length == 4);
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
          if (_session.type == JourneyChallengeType.grammarRepair)
            ..._grammarExplanationLines()
          else ...[
            _explanationLine('正确答案', _session.correctAnswerText),
            _explanationLine('为什么', _session.explanation),
            _explanationLine('记忆方法', _session.memoryTip),
          ],
        ],
      ),
    );
  }

  List<Widget> _grammarExplanationLines() {
    final grammar = _session.grammar!;
    return [
      _explanationLine('病句类型', grammar.errorType),
      _explanationLine('错误位置', grammar.errorLocation),
      _explanationLine('原句', grammar.originalSentence),
      _explanationLine('修改后', grammar.correctedSentence),
      _explanationLine('为什么错误', grammar.whyWrong),
      _explanationLine('修改原则', grammar.revisionRule),
      _explanationLine('记忆方法', grammar.memoryTip),
    ];
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
    JourneyChallengeDifficulty.beginner => '轻松',
    JourneyChallengeDifficulty.standard => '标准',
    JourneyChallengeDifficulty.advanced => '挑战',
  };

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

  String get firstHint => switch (type) {
    JourneyChallengeType.paragraphRebuild => '先找交代地点或时间的句子，再安排人物行动和最后的变化。',
    JourneyChallengeType.grammarRepair => '先检查句子有没有明确主语，再看关联词和前后句式是否平行。',
    JourneyChallengeType.missingSentence => '同时观察前一句留下的主语，以及后一句出现的结果或转折。',
  };

  String get secondHint => switch (type) {
    JourneyChallengeType.paragraphRebuild => '开头介绍整体，中间发生行动，最后才出现观察、决定或结果。',
    JourneyChallengeType.grammarRepair =>
      '“通过……使……”容易拿走主语；“不但……而且……”要保持前后结构一致。',
    JourneyChallengeType.missingSentence => '正确句必须既接住前文，又能解释后文为什么会出现。',
  };

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
    final distractorTexts = _paragraphDistractors(journeyId);
    final options = <_ChallengeOption>[...correctOptions];
    var distractorIndex = 0;
    while (options.length < 4) {
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
    final grammar = _grammarForJourney(journeyId, difficulty);
    final replacementTexts = <String>[
      grammar.correctReplacement,
      ...grammar.distractors,
    ];
    final options = <_ChallengeOption>[
      for (var index = 0; index < 4; index++)
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
      instruction: '先点击病句位置，再从四个修改方案中选出最自然的一项。',
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
    final distractors = _missingDistractors(journeyId, discoveryTexts);
    final optionTexts = <String>[correct, ...distractors];
    final options = <_ChallengeOption>[
      for (var index = 0; index < 4; index++)
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
      instruction: '阅读前后文，从四个相近答案中选出最能连接上下文的一句。',
      explanation: '正确句承接前文的人物与地点，同时为后文的变化、因果或决定铺路。',
      memoryTip: '补句要同时看两边：前一句留下什么，后一句为什么出现。',
      contextBefore: before,
      contextAfter: after,
    );
  }

  static _GrammarSpec _grammarForJourney(
    String journeyId,
    JourneyChallengeDifficulty difficulty,
  ) {
    return switch (journeyId) {
      'literary-roaming' => const _GrammarSpec(
        segments: ['通过追随蓝色蝴蝶，', '使探索者', '进入了更深的梦境。'],
        problemSegmentIndex: 1,
        originalSentence: '通过追随蓝色蝴蝶，使探索者进入了更深的梦境。',
        correctedSentence: '通过追随蓝色蝴蝶，探索者进入了更深的梦境。',
        correctOptionId: 'correct',
        correctReplacement: '探索者',
        distractors: ['因此使探索者', '而且探索者还', '让探索者因此'],
        errorType: '成分残缺：主语缺失',
        errorLocation: '“使探索者”中的“使”',
        whyWrong: '“通过……”已经形成介词结构，再用“使”引出结果，整句便没有明确主语。',
        revisionRule: '删除“使”，让“探索者”直接成为主语。',
        memoryTip: '看到“通过……使……”时，先检查主语还在不在。',
      ),
      'myth-tracing' => const _GrammarSpec(
        segments: ['由于遗简已经残缺，', '因此使线索', '变得更难理解。'],
        problemSegmentIndex: 1,
        originalSentence: '由于遗简已经残缺，因此使线索变得更难理解。',
        correctedSentence: '由于遗简已经残缺，线索因此变得更难理解。',
        correctOptionId: 'correct',
        correctReplacement: '线索因此',
        distractors: ['所以使线索', '而且线索还', '因此让线索也'],
        errorType: '关联词赘余并导致主语缺失',
        errorLocation: '“因此使线索”',
        whyWrong: '“由于”已经说明原因，“因此使”又叠加关系词，并把结果句的主语变得不自然。',
        revisionRule: '让“线索”成为主语，只保留自然的因果标记。',
        memoryTip: '“由于”可以和“因此”呼应，但不要再叠加“使”。',
      ),
      'strange-night-talks' => const _GrammarSpec(
        segments: ['夜客不但留下了铜钱，', '而且门外的声音还', '不断叫你的名字。'],
        problemSegmentIndex: 1,
        originalSentence: '夜客不但留下了铜钱，而且门外的声音还不断叫你的名字。',
        correctedSentence: '夜客留下了铜钱，而门外的声音还不断叫你的名字。',
        correctOptionId: 'correct',
        correctReplacement: '而门外的声音还',
        distractors: ['而且夜客也', '所以门外声音', '并且使声音还'],
        errorType: '关联结构不平行',
        errorLocation: '“不但……而且……”连接了两个不同主语',
        whyWrong: '前半句主语是“夜客”，后半句突然换成“门外的声音”，不适合直接用成套递进结构。',
        revisionRule: '改用“而”表示并列或转折，让两个不同主语各自完整。',
        memoryTip: '使用“不但……而且……”时，检查前后主语和句式是否平行。',
      ),
      'folk-secret-land' => const _GrammarSpec(
        segments: ['河灯不仅承载祈愿，', '而且人们还', '把它放进水中。'],
        problemSegmentIndex: 1,
        originalSentence: '河灯不仅承载祈愿，而且人们还把它放进水中。',
        correctedSentence: '河灯不仅承载祈愿，也被人们放进水中。',
        correctOptionId: 'correct',
        correctReplacement: '也被人们',
        distractors: ['而且人们也', '所以让人们', '并且人们还'],
        errorType: '前后主语与句式不平行',
        errorLocation: '“而且人们还”',
        whyWrong: '“不仅”后的主语是“河灯”，后半句突然换成“人们”，两部分结构不一致。',
        revisionRule: '保持“河灯”为主语，把后半句改成被动结构。',
        memoryTip: '关联词连接的两部分，最好保持同一个主语和相近句式。',
      ),
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
          errorType: '关联词赘余并导致主语缺失',
          errorLocation: '“因此使远山”',
          whyWrong: '“由于”已经引出原因，再用“因此使”会堆叠关系词，同时让结果句缺少自然主语。',
          revisionRule: '让“远山”成为结果句主语，只保留一个自然的因果标记。',
          memoryTip: '“由于”与“因此”可以呼应，但不要再叠加“使”拿走主语。',
        ),
      },
    };
  }

  static List<String> _paragraphDistractors(String journeyId) {
    return switch (journeyId) {
      'literary-roaming' => ['蝴蝶停在原地，竹林也从来没有出现变化。', '探索者没有做梦，也没有看见任何岔路。'],
      'myth-tracing' => ['太阳升起以后，遗简才第一次从海底出现。', '白兔离开桂林，故事也没有留下任何选择。'],
      'strange-night-talks' => ['客栈从来没有下雨，夜客也一直拥有清楚的影子。', '天刚亮时，门外才第一次有人轻轻敲门。'],
      'folk-secret-land' => ['所有河灯都停在岸上，从未进入水中。', '写着名字的灯顺流远去，没有出现任何倒影。'],
      _ => ['游客没有停留，很快就离开了这里。', '所有景色完全相同，不需要继续观察。', '故事突然中断，也没有留下任何结果。'],
    };
  }

  static List<String> _missingDistractors(
    String journeyId,
    List<String> discoveries,
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
      _ => ['他没有进入景区，直接回到了住处。', '所有建筑完全一样，所以不必继续观察。', '天气突然改变，但这与前后内容没有关系。'],
    };
    if (discoveries.isNotEmpty && specific.length < 3) {
      return [...specific, discoveries.last];
    }
    return specific;
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
