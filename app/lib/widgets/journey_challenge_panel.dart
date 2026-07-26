import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/language_proficiency.dart';
import '../theme/phoenix_theme.dart';

typedef JourneyChallengeResolved = Future<void> Function(
  String reward,
  String awardId,
);

enum JourneyChallengeType { paragraphRebuild, grammarRepair, missingSentence }

enum JourneyChallengeDifficulty { beginner, standard, advanced }

@visibleForTesting
JourneyChallengeDifficulty challengeDifficultyForProfile(
  ChineseProficiencyProfile? profile,
) {
  return switch (profile?.band) {
    null ||
    PhoenixReadingBand.beginner ||
    PhoenixReadingBand.elementary =>
      JourneyChallengeDifficulty.beginner,
    PhoenixReadingBand.intermediate ||
    PhoenixReadingBand.upperIntermediate =>
      JourneyChallengeDifficulty.standard,
    PhoenixReadingBand.advanced || PhoenixReadingBand.mastery =>
      JourneyChallengeDifficulty.advanced,
  };
}

@visibleForTesting
JourneyChallengeType challengeTypeForSeed(int seed) {
  return JourneyChallengeType.values[seed.abs() % JourneyChallengeType.values.length];
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
    this.initialReward,
  });

  final String journeyId;
  final List<String> storyParagraphs;
  final List<String> discoveryTexts;
  final ChineseProficiencyProfile? profile;
  final int seed;
  final String Function(String) displayText;
  final JourneyChallengeResolved onResolved;
  final String? initialReward;

  @override
  State<JourneyChallengePanel> createState() => _JourneyChallengePanelState();
}

class _JourneyChallengePanelState extends State<JourneyChallengePanel> {
  late _ChallengeSession _session;
  bool _sendingReward = false;

  String t(String value) => widget.displayText(value);

  @override
  void initState() {
    super.initState();
    _session = _ChallengeSession.build(
      journeyId: widget.journeyId,
      storyParagraphs: widget.storyParagraphs,
      discoveryTexts: widget.discoveryTexts,
      profile: widget.profile,
      seed: widget.seed,
      initialReward: widget.initialReward,
    );
  }

  @override
  void didUpdateWidget(covariant JourneyChallengePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.seed == widget.seed &&
        oldWidget.profile?.storageValue == widget.profile?.storageValue &&
        oldWidget.initialReward == widget.initialReward) {
      return;
    }
    _session = _ChallengeSession.build(
      journeyId: widget.journeyId,
      storyParagraphs: widget.storyParagraphs,
      discoveryTexts: widget.discoveryTexts,
      profile: widget.profile,
      seed: widget.seed,
      initialReward: widget.initialReward,
    );
  }

  Future<void> _submit() async {
    if (!_session.canSubmit || _session.resolved || _sendingReward) return;
    late final _ChallengeSubmission result;
    setState(() => result = _session.submit());
    if (!result.resolved || result.reward == null) return;

    setState(() => _sendingReward = true);
    try {
      await widget.onResolved(result.reward!, _session.awardId);
    } finally {
      if (mounted) setState(() => _sendingReward = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('journey-challenge-panel'),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .36)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 9),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: switch (_session.type) {
                JourneyChallengeType.paragraphRebuild => _paragraphBody(),
                JourneyChallengeType.grammarRepair => _grammarBody(),
                JourneyChallengeType.missingSentence => _missingBody(),
              },
            ),
          ),
          if (_session.feedback.isNotEmpty) ...[
            const SizedBox(height: 8),
            _feedbackCard(),
          ],
          if (_session.resolved) ...[
            const SizedBox(height: 8),
            _resolutionCard(),
          ] else ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const ValueKey('challenge-submit'),
                onPressed: _session.canSubmit && !_sendingReward ? _submit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: PhoenixTheme.red,
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
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
                    : const Icon(Icons.check_circle_outline_rounded, size: 17),
                label: Text(
                  t('提交第 ${_session.attempts + 1} / 3 次答案'),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1E17).withValues(alpha: .92),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.extension_rounded, color: PhoenixTheme.gold, size: 17),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  t(_session.typeLabel),
                  key: ValueKey('challenge-type-${_session.type.name}'),
                  style: const TextStyle(
                    color: PhoenixTheme.gold,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                key: ValueKey('challenge-difficulty-${_session.difficulty.name}'),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  t(_session.difficultyLabel),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            t(_session.instruction),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            t(_session.resolved
                ? '挑战已结束'
                : '第 ${_session.attempts + 1} / 3 次 · 一次金币，二次银币，三次铜币'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: .64),
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _paragraphBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _selectedParagraphBox(),
        const SizedBox(height: 8),
        Text(
          t('从下面句子中选出需要的内容，并按照原文逻辑依次点击。'),
          style: const TextStyle(color: Colors.white70, fontSize: 10.5),
        ),
        const SizedBox(height: 7),
        for (var index = 0; index < _session.options.length; index++) ...[
          _optionTile(_session.options[index], index),
          if (index != _session.options.length - 1) const SizedBox(height: 6),
        ],
        const SizedBox(height: 7),
        OutlinedButton.icon(
          key: const ValueKey('challenge-undo'),
          onPressed: _session.resolved || _session.selectedIds.isEmpty
              ? null
              : () => setState(_session.undoParagraphSelection),
          icon: const Icon(Icons.undo_rounded, size: 16),
          label: Text(t('撤回最后一句')),
        ),
      ],
    );
  }

  Widget _selectedParagraphBox() {
    final selected = _session.selectedParagraphOptions;
    return Container(
      key: const ValueKey('challenge-paragraph-answer'),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E4C8),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFD4AF72)),
      ),
      child: selected.isEmpty
          ? Text(
              t('尚未选择 · 需要 ${_session.correctIds.length} 句'),
              style: const TextStyle(
                color: Color(0xFF9A8068),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < selected.length; index++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      '${index + 1}. ${t(selected[index].text)}',
                      style: const TextStyle(
                        color: Color(0xFF34291F),
                        fontSize: 11.5,
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _grammarBody() {
    final grammar = _session.grammar!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('先点击你认为有问题的部分：'),
          style: const TextStyle(color: Colors.white70, fontSize: 10.5),
        ),
        const SizedBox(height: 7),
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
                    : (_) => setState(() => _session.selectedGrammarSegment = index),
                selectedColor: const Color(0xFFFFD89A),
                backgroundColor: const Color(0xFFF1E4C8),
                label: Text(
                  t(grammar.segments[index]),
                  style: const TextStyle(
                    color: Color(0xFF34291F),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          t('再选择最合适的修改：'),
          style: const TextStyle(color: Colors.white70, fontSize: 10.5),
        ),
        const SizedBox(height: 7),
        for (var index = 0; index < _session.options.length; index++) ...[
          _optionTile(_session.options[index], index),
          if (index != _session.options.length - 1) const SizedBox(height: 6),
        ],
      ],
    );
  }

  Widget _missingBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _contextSentence(_session.contextBefore),
        const SizedBox(height: 6),
        Container(
          key: const ValueKey('challenge-missing-slot'),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: PhoenixTheme.gold.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .42)),
          ),
          child: Text(
            _session.selectedSingleOption == null
                ? t('请从下方选一句放在这里')
                : t(_session.selectedSingleOption!.text),
            style: TextStyle(
              color: _session.selectedSingleOption == null
                  ? Colors.white54
                  : Colors.white,
              height: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        _contextSentence(_session.contextAfter),
        const SizedBox(height: 9),
        for (var index = 0; index < _session.options.length; index++) ...[
          _optionTile(_session.options[index], index),
          if (index != _session.options.length - 1) const SizedBox(height: 6),
        ],
      ],
    );
  }

  Widget _contextSentence(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        t(value),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          height: 1.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _optionTile(_ChallengeOption option, int index) {
    final selected = _session.isOptionSelected(option.id);
    final revealedCorrect = _session.resolved && option.isCorrect;
    final selectedWrong = _session.resolved && selected && !option.isCorrect;
    final accent = revealedCorrect
        ? const Color(0xFF79D09D)
        : selectedWrong
            ? const Color(0xFFE07D73)
            : selected
                ? PhoenixTheme.gold
                : Colors.white70;
    return Material(
      key: ValueKey('challenge-option-${option.id}'),
      color: Colors.black.withValues(alpha: .28),
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
            border: Border.all(color: accent.withValues(alpha: selected || revealedCorrect ? .8 : .2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .13),
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
                    height: 1.38,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedbackCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: _session.resolved
            ? const Color(0xFF233F31)
            : const Color(0xFF5A2C26),
        borderRadius: BorderRadius.circular(12),
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
            child: Text(
              t(_session.feedback),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resolutionCard() {
    return Container(
      key: const ValueKey('challenge-explanation'),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0DF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFA5BC91)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monetization_on_rounded, color: Color(0xFF7A5A1D), size: 19),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  t('获得 ${_session.reward ?? '碎银'}'),
                  key: ValueKey('challenge-reward-${_session.rewardCode}'),
                  style: const TextStyle(
                    color: Color(0xFF315B32),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
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
              height: 1.38,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
    required this.instruction,
    required this.explanation,
    required this.memoryTip,
    this.grammar,
    this.contextBefore = '',
    this.contextAfter = '',
    String? initialReward,
  }) {
    if (initialReward != null) {
      reward = initialReward;
      resolved = true;
      correct = initialReward != '碎银';
      feedback = initialReward == '碎银'
          ? '三次机会已经用完，Phoenix 已展示正确答案和讲解。'
          : '这次挑战已经完成。';
      _revealCorrectSelection();
    }
  }

  factory _ChallengeSession.build({
    required String journeyId,
    required List<String> storyParagraphs,
    required List<String> discoveryTexts,
    required ChineseProficiencyProfile? profile,
    required int seed,
    String? initialReward,
  }) {
    final difficulty = challengeDifficultyForProfile(profile);
    final type = challengeTypeForSeed(seed);
    return switch (type) {
      JourneyChallengeType.paragraphRebuild => _buildParagraph(
          journeyId,
          storyParagraphs,
          difficulty,
          seed,
          initialReward,
        ),
      JourneyChallengeType.grammarRepair => _buildGrammar(
          journeyId,
          difficulty,
          seed,
          initialReward,
        ),
      JourneyChallengeType.missingSentence => _buildMissing(
          journeyId,
          storyParagraphs,
          discoveryTexts,
          difficulty,
          seed,
          initialReward,
        ),
    };
  }

  final String journeyId;
  final int seed;
  final JourneyChallengeType type;
  final JourneyChallengeDifficulty difficulty;
  final List<_ChallengeOption> options;
  final List<String> correctIds;
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
          ? '回答正确。请查看钱币奖励和讲解。'
          : '三次机会已结束。Phoenix 已自动展示正确答案，你可以继续旅程。';
      return _ChallengeSubmission(resolved: true, reward: reward);
    }

    feedback = switch (attempts) {
      1 => _firstHint,
      _ => _secondHint,
    };
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

  String get _firstHint => switch (type) {
        JourneyChallengeType.paragraphRebuild =>
          '先找能介绍整体地点或时间的句子，再安排人物行动。',
        JourneyChallengeType.grammarRepair =>
          '先检查句子有没有明确主语，再看关联词是否重复。',
        JourneyChallengeType.missingSentence =>
          '留意前一句的主语，以及后一句的结果或转折。',
      };

  String get _secondHint => switch (type) {
        JourneyChallengeType.paragraphRebuild =>
          '开头通常交代整体，中间写行动，结尾才出现细节或结果。',
        JourneyChallengeType.grammarRepair =>
          '“通过……使……”常会拿走主语；成套关联词也不要重复堆叠。',
        JourneyChallengeType.missingSentence =>
          '正确句既要承接前文，也必须为后文的因果关系铺路。',
      };

  static _ChallengeSession _buildParagraph(
    String journeyId,
    List<String> storyParagraphs,
    JourneyChallengeDifficulty difficulty,
    int seed,
    String? initialReward,
  ) {
    final requiredCount = switch (difficulty) {
      JourneyChallengeDifficulty.beginner => 3,
      JourneyChallengeDifficulty.standard => 4,
      JourneyChallengeDifficulty.advanced => 5,
    };
    final candidateCount = difficulty == JourneyChallengeDifficulty.advanced ? 7 : 6;
    final source = _extractSentences(storyParagraphs);
    final fallback = <String>[
      '清晨，探索者来到今天的目的地。',
      '他沿着主要路线慢慢向前走。',
      '一路上的景色不断发生变化。',
      '人物开始留意建筑和自然的关系。',
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
    final distractorTexts = <String>[
      '游客没有停留，很快就离开了这里。',
      '所有景色完全相同，不需要继续观察。',
      '路线突然中断，故事也没有留下结果。',
      '人物只计算距离，没有注意周围变化。',
      '建筑与环境彼此无关，也没有形成层次。',
      '最后的发现与前面的行动没有任何联系。',
      '天气虽然变化，人物却从未进入这个地点。',
    ];
    final options = <_ChallengeOption>[...correctOptions];
    var distractorIndex = 0;
    while (options.length < candidateCount) {
      options.add(
        _ChallengeOption(
          id: 'distractor-$distractorIndex',
          text: distractorTexts[distractorIndex % distractorTexts.length],
        ),
      );
      distractorIndex += 1;
    }
    _shuffleOptions(options, seed + 17);
    if (_leadingIds(options, correctOptions.length)
        .equals(correctOptions.map((option) => option.id).toList())) {
      options.add(options.removeAt(0));
    }
    return _ChallengeSession(
      journeyId: journeyId,
      seed: seed,
      type: JourneyChallengeType.paragraphRebuild,
      difficulty: difficulty,
      options: options,
      correctIds: correctOptions.map((option) => option.id).toList(),
      instruction: '从至少六个候选句中，选出并复原一段合理短文。',
      explanation: '段落先交代时间或地点，再写人物行动，最后补充观察细节与结果。',
      memoryTip: '记住“整体 → 行动 → 细节 → 结果”，排序会容易很多。',
      initialReward: initialReward,
    );
  }

  static _ChallengeSession _buildGrammar(
    String journeyId,
    JourneyChallengeDifficulty difficulty,
    int seed,
    String? initialReward,
  ) {
    final grammar = switch (difficulty) {
      JourneyChallengeDifficulty.beginner => const _GrammarSpec(
          segments: ['通过参观这里，', '使游客', '可以看到不同的风景。'],
          problemSegmentIndex: 1,
          originalSentence: '通过参观这里，使游客可以看到不同的风景。',
          correctedSentence: '通过参观这里，游客可以看到不同的风景。',
          correctOptionId: 'correct',
          correctReplacement: '游客',
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
          errorType: '搭配不当：前后主语不一致',
          errorLocation: '“而且游客还”',
          whyWrong: '“不但”后的主语是“长廊”，后半句突然换成“游客”，关联结构不平行。',
          revisionRule: '保持前后主语一致，用“可以让游客”承接“长廊”。',
          memoryTip: '使用“不但……而且……”时，要检查两部分的主语和句式是否平行。',
        ),
      JourneyChallengeDifficulty.advanced => const _GrammarSpec(
          segments: ['由于园林采用了借景手法，', '因此使远山', '成为画面的一部分。'],
          problemSegmentIndex: 1,
          originalSentence: '由于园林采用了借景手法，因此使远山成为画面的一部分。',
          correctedSentence: '由于园林采用了借景手法，远山因此成为画面的一部分。',
          correctOptionId: 'correct',
          correctReplacement: '远山因此',
          errorType: '关联词赘余并导致主语缺失',
          errorLocation: '“因此使远山”',
          whyWrong: '“由于”已经引出原因，再用“因此使”会堆叠关系词，同时让结果句缺少自然主语。',
          revisionRule: '让“远山”成为结果句主语，只保留一个自然的因果标记。',
          memoryTip: '“由于”与“因此”可以呼应，但不要再叠加“使”拿走主语。',
        ),
    };
    final distractors = <String>[
      grammar.correctReplacement,
      '因此使游客',
      '所以让游客',
      '而且游客还',
      '并且使游客',
      '让这里的游客',
      '从而使得游客',
    ];
    final options = <_ChallengeOption>[
      for (var index = 0; index < distractors.length; index++)
        _ChallengeOption(
          id: index == 0 ? 'correct' : 'distractor-$index',
          text: distractors[index],
          isCorrect: index == 0,
        ),
    ];
    _shuffleOptions(options, seed + 31);
    return _ChallengeSession(
      journeyId: journeyId,
      seed: seed,
      type: JourneyChallengeType.grammarRepair,
      difficulty: difficulty,
      options: options.take(difficulty == JourneyChallengeDifficulty.advanced ? 7 : 6).toList(),
      correctIds: const ['correct'],
      instruction: '先找出病句位置，再从至少六个修改方案中选出最自然的一项。',
      explanation: grammar.whyWrong,
      memoryTip: grammar.memoryTip,
      grammar: grammar,
      initialReward: initialReward,
    );
  }

  static _ChallengeSession _buildMissing(
    String journeyId,
    List<String> storyParagraphs,
    List<String> discoveryTexts,
    JourneyChallengeDifficulty difficulty,
    int seed,
    String? initialReward,
  ) {
    final source = _extractSentences(storyParagraphs);
    final beginner = difficulty == JourneyChallengeDifficulty.beginner;
    final before = beginner || source.length < 3
        ? '清晨，探索者来到今天的目的地。'
        : source[0];
    final correct = beginner || source.length < 3
        ? '他沿着主要路线慢慢向前走。'
        : source[1];
    final after = beginner || source.length < 3
        ? '一路上的景色因此不断发生变化。'
        : source[2];
    final distractors = <String>[
      correct,
      '他没有进入景区，直接回到了住处。',
      '所有建筑完全一样，所以不必继续观察。',
      '天气突然改变，但这与前后内容没有关系。',
      '游客只计算路程，并没有看见周围景色。',
      '故事在这里结束，后面没有出现任何结果。',
      discoveryTexts.isNotEmpty
          ? discoveryTexts.last
          : '这句话只补充资料，却无法连接前后的行动。',
    ];
    final options = <_ChallengeOption>[
      for (var index = 0; index < distractors.length; index++)
        _ChallengeOption(
          id: index == 0 ? 'correct' : 'distractor-$index',
          text: distractors[index],
          isCorrect: index == 0,
        ),
    ];
    _shuffleOptions(options, seed + 47);
    return _ChallengeSession(
      journeyId: journeyId,
      seed: seed,
      type: JourneyChallengeType.missingSentence,
      difficulty: difficulty,
      options: options.take(difficulty == JourneyChallengeDifficulty.advanced ? 7 : 6).toList(),
      correctIds: const ['correct'],
      instruction: '阅读前后文，从至少六个相近选项中补回最自然的一句。',
      explanation: '中间句承接前文的人物和地点，并为后文“景色发生变化”的结果铺垫。',
      memoryTip: '补句时同时看两边：前一句留下什么，后一句为什么会出现。',
      contextBefore: before,
      contextAfter: after,
      initialReward: initialReward,
    );
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

  static void _shuffleOptions(List<_ChallengeOption> options, int seed) {
    options.shuffle(math.Random(seed));
  }

  static _IdList _leadingIds(List<_ChallengeOption> options, int count) {
    return _IdList(options.take(count).map((option) => option.id).toList());
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
  final String errorType;
  final String errorLocation;
  final String whyWrong;
  final String revisionRule;
  final String memoryTip;
}

class _IdList {
  const _IdList(this.values);

  final List<String> values;

  bool equals(List<String> other) {
    if (values.length != other.length) return false;
    for (var index = 0; index < values.length; index++) {
      if (values[index] != other[index]) return false;
    }
    return true;
  }
}
