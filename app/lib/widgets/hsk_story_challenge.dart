import 'dart:async';

import 'package:flutter/material.dart';

import '../models/journey_challenge.dart';
import '../theme/phoenix_theme.dart';

enum ChallengeFeedbackFieldKind {
  userChoice,
  correctAnswer,
  errorLocation,
  explanation,
}

class ChallengeFeedbackField {
  const ChallengeFeedbackField({
    required this.kind,
    required this.label,
    required this.value,
  });

  final ChallengeFeedbackFieldKind kind;
  final String label;
  final String value;

  String text(String Function(String) displayText) =>
      '${displayText(label)}：${displayText(value)}';
}

class ChallengeFeedbackPresentation {
  const ChallengeFeedbackPresentation({
    required this.correct,
    required this.fields,
  });

  final bool correct;
  final List<ChallengeFeedbackField> fields;

  String get statusText => correct ? '回答正确' : '回答错误';

  List<String> lines(String Function(String) displayText) => <String>[
        displayText(statusText),
        ...fields.map((field) => field.text(displayText)),
      ];

  String narrationText(String Function(String) displayText) =>
      lines(displayText).join('。');
}

String _feedbackExplanation(StoryChallengeQuestion question) {
  final why = question.whyCorrect.trim();
  if (why.isNotEmpty) return why;
  final grammarWhy = question.grammarWhyWrong?.trim() ?? '';
  if (grammarWhy.isNotEmpty) return grammarWhy;
  final rule = question.grammarRevisionRule?.trim() ?? '';
  if (rule.isNotEmpty) return rule;
  return '请根据 Story、空间关系和题目条件核对答案。';
}

ChallengeFeedbackPresentation grammarLocationFeedbackPresentation(
  StoryChallengeQuestion question,
  int selectedError,
) {
  final errorIndex = question.errorSegmentIndex ?? 0;
  final actual = question.errorSegments[errorIndex];
  final selected = question.errorSegments[selectedError];
  final correct = selectedError == errorIndex;
  final grammarWhy = question.grammarWhyWrong?.trim() ?? '';
  final explanation =
      grammarWhy.isNotEmpty ? grammarWhy : _feedbackExplanation(question);
  return ChallengeFeedbackPresentation(
    correct: correct,
    fields: <ChallengeFeedbackField>[
      if (!correct)
        ChallengeFeedbackField(
          kind: ChallengeFeedbackFieldKind.userChoice,
          label: '你的选择',
          value: selected,
        ),
      ChallengeFeedbackField(
        kind: ChallengeFeedbackFieldKind.errorLocation,
        label: correct ? '错误位置' : '真正错误位置',
        value: actual,
      ),
      ChallengeFeedbackField(
        kind: ChallengeFeedbackFieldKind.explanation,
        label: '为什么这里错',
        value: explanation,
      ),
    ],
  );
}

ChallengeFeedbackPresentation grammarRepairFeedbackPresentation(
  StoryChallengeQuestion question,
  int selectedOption,
) {
  final selected = question.options[selectedOption];
  final correct = selected == question.answer;
  return ChallengeFeedbackPresentation(
    correct: correct,
    fields: <ChallengeFeedbackField>[
      if (!correct)
        ChallengeFeedbackField(
          kind: ChallengeFeedbackFieldKind.userChoice,
          label: '你的修改',
          value: selected,
        ),
      ChallengeFeedbackField(
        kind: ChallengeFeedbackFieldKind.correctAnswer,
        label: '正确答案',
        value: question.answer,
      ),
      ChallengeFeedbackField(
        kind: ChallengeFeedbackFieldKind.explanation,
        label: '为什么这样改才对',
        value: _feedbackExplanation(question),
      ),
    ],
  );
}

ChallengeFeedbackPresentation singleStepFeedbackPresentation(
  StoryChallengeQuestion question, {
  required String selectedAnswer,
}) {
  final correct = selectedAnswer == question.answer;
  final evidence = question.storyEvidence.trim();
  final why = _feedbackExplanation(question);
  final explanation = !correct && evidence.isNotEmpty && !why.contains(evidence)
      ? '题目里的依据是“$evidence”。$why'
      : why;
  return ChallengeFeedbackPresentation(
    correct: correct,
    fields: <ChallengeFeedbackField>[
      if (!correct)
        ChallengeFeedbackField(
          kind: ChallengeFeedbackFieldKind.userChoice,
          label: '你的选择',
          value: selectedAnswer,
        ),
      ChallengeFeedbackField(
        kind: ChallengeFeedbackFieldKind.correctAnswer,
        label: '正确答案',
        value: question.answer,
      ),
      ChallengeFeedbackField(
        kind: ChallengeFeedbackFieldKind.explanation,
        label: correct ? '为什么这个答案对' : '为什么这个答案才对',
        value: explanation,
      ),
    ],
  );
}

class HskStoryChallenge extends StatefulWidget {
  const HskStoryChallenge({
    super.key,
    required this.challenge,
    required this.displayText,
    required this.onCompleted,
    required this.onNarrate,
    this.onFeedbackAudio,
    this.onQuestionChanged,
    this.onBackStage,
  });

  final StoryChallengeSet challenge;
  final String Function(String) displayText;
  final Future<void> Function() onCompleted;
  final Future<void> Function(String questionId, String text) onNarrate;
  final Future<void> Function(String questionId, String feedbackText)?
      onFeedbackAudio;
  final VoidCallback? onQuestionChanged;
  final VoidCallback? onBackStage;

  @override
  State<HskStoryChallenge> createState() => _HskStoryChallengeState();
}

class _HskStoryChallengeState extends State<HskStoryChallenge> {
  int index = 0;
  int grammarStep = 0;
  int? selectedOption;
  int? selectedError;
  bool grammarLocationSubmitted = false;
  bool submitted = false;
  bool challengeCompleted = false;
  final List<String> built = <String>[];
  late List<String> remaining;

  StoryChallengeQuestion get question => widget.challenge.questions[index];

  @override
  void initState() {
    super.initState();
    remaining = List<String>.of(question.characterTiles);
  }

  String get modeTitle => switch (question.mode) {
        StoryChallengeMode.sentenceRebuild => '语义块复原',
        StoryChallengeMode.grammarRepair => '语病修复',
        StoryChallengeMode.storyCompletion => '情境补全',
        StoryChallengeMode.storyEvidence => '故事证据',
        StoryChallengeMode.knowledgeReasoning => '空间推理',
        StoryChallengeMode.scenarioDecision => '情境决策',
      };

  int get modeIndex => widget.challenge.questions
      .take(index + 1)
      .where((item) => item.mode == question.mode)
      .length;

  ChallengeFeedbackPresentation? get _activeFeedbackPresentation {
    if (question.mode == StoryChallengeMode.grammarRepair &&
        grammarStep == 1 &&
        selectedError != null) {
      return grammarLocationFeedbackPresentation(question, selectedError!);
    }
    if (!submitted) return null;
    if (question.mode == StoryChallengeMode.grammarRepair &&
        selectedOption != null) {
      return grammarRepairFeedbackPresentation(question, selectedOption!);
    }
    if (question.mode == StoryChallengeMode.sentenceRebuild) {
      return singleStepFeedbackPresentation(
        question,
        selectedAnswer: built.join(),
      );
    }
    if (selectedOption != null && question.options.isNotEmpty) {
      return singleStepFeedbackPresentation(
        question,
        selectedAnswer: question.options[selectedOption!],
      );
    }
    return null;
  }

  String get _feedbackAudioText =>
      _activeFeedbackPresentation?.narrationText(widget.displayText) ?? '';

  bool get _canSubmit {
    if (submitted) return false;
    if (question.mode == StoryChallengeMode.sentenceRebuild) {
      return remaining.isEmpty &&
          built.length == question.characterTiles.length;
    }
    if (question.mode == StoryChallengeMode.grammarRepair) {
      if (grammarStep == 0) return selectedError != null;
      if (grammarStep == 2) return selectedOption != null;
      return false;
    }
    return selectedOption != null;
  }

  void _resetQuestion() {
    grammarStep = 0;
    selectedOption = null;
    selectedError = null;
    grammarLocationSubmitted = false;
    submitted = false;
    challengeCompleted = false;
    built.clear();
    remaining = List<String>.of(question.characterTiles);
  }

  void _submit() {
    if (!_canSubmit) return;
    if (question.mode == StoryChallengeMode.grammarRepair && grammarStep == 0) {
      setState(() {
        grammarLocationSubmitted = true;
        grammarStep = 1;
        selectedOption = null;
      });
      return;
    }

    setState(() => submitted = true);
    final feedbackAudio = widget.onFeedbackAudio;
    final feedbackText = _feedbackAudioText;
    if (feedbackAudio != null && feedbackText.isNotEmpty) {
      unawaited(feedbackAudio(question.id, feedbackText));
    }
  }

  void _advanceGrammarStep2() {
    if (question.mode != StoryChallengeMode.grammarRepair || grammarStep != 1) {
      return;
    }
    widget.onQuestionChanged?.call();
    setState(() {
      grammarStep = 2;
      selectedOption = null;
    });
  }

  Future<void> _next() async {
    if (!submitted || challengeCompleted) return;
    widget.onQuestionChanged?.call();
    if (index == widget.challenge.questions.length - 1) {
      setState(() => challengeCompleted = true);
      await widget.onCompleted();
      return;
    }
    setState(() {
      index += 1;
      _resetQuestion();
    });
  }

  void _previous() {
    widget.onQuestionChanged?.call();
    if (index == 0) {
      widget.onBackStage?.call();
      return;
    }
    setState(() {
      index -= 1;
      _resetQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('hsk-challenge-question-${question.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _header(),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
                color: Colors.black.withValues(alpha: .34),
              ),
              child: _questionBody(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _bottomActions(),
      ],
    );
  }

  Widget _header() => Row(
        children: <Widget>[
          Text(
            '$modeTitle $modeIndex/2',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Text(
            '挑战 ${index + 1}/12',
            style: const TextStyle(
              color: PhoenixTheme.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );

  Widget _bottomActions() {
    if (challengeCompleted) return const SizedBox.shrink();
    final stepOneFeedback = question.mode == StoryChallengeMode.grammarRepair &&
        grammarStep == 1 &&
        !submitted;
    return SizedBox(
      key: const ValueKey('challenge-bottom-actions'),
      height: 40,
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton.icon(
              key: const ValueKey('challenge-back'),
              onPressed: index > 0 || widget.onBackStage != null
                  ? _previous
                  : null,
              icon: const Icon(Icons.arrow_back_rounded, size: 17),
              label: const Text('上一步'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              key: ValueKey(
                stepOneFeedback
                    ? 'grammar-step1-continue'
                    : submitted
                        ? 'challenge-next'
                        : 'challenge-submit',
              ),
              onPressed: stepOneFeedback
                  ? _advanceGrammarStep2
                  : submitted
                      ? () => unawaited(_next())
                      : _canSubmit
                          ? _submit
                          : null,
              style: FilledButton.styleFrom(backgroundColor: PhoenixTheme.red),
              icon: Icon(
                stepOneFeedback || submitted
                    ? Icons.arrow_forward_rounded
                    : Icons.check_rounded,
                size: 17,
              ),
              label: Text(
                stepOneFeedback
                    ? '进入 STEP 2'
                    : submitted
                        ? '下一题'
                        : '提交',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionBody() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _audioRow(),
          switch (question.mode) {
            StoryChallengeMode.sentenceRebuild => _rebuild(),
            StoryChallengeMode.grammarRepair => _grammar(),
            StoryChallengeMode.storyCompletion => _directChoice(
                instruction: '根据 Story 情境补全最合理的信息',
              ),
            StoryChallengeMode.storyEvidence => _directChoice(
                instruction: '根据当前 Story 证据作答',
              ),
            StoryChallengeMode.knowledgeReasoning => _directChoice(
                instruction: '根据北京 · 紫禁城知识与空间关系作答',
              ),
            StoryChallengeMode.scenarioDecision => _directChoice(
                instruction: '综合情境、Story 与空间证据作出决定',
              ),
          },
          if (submitted) _finalFeedback(),
        ],
      );

  Widget _audioRow() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            key: ValueKey('challenge-question-speaker-${question.id}'),
            tooltip: '朗读题目',
            onPressed: () => unawaited(
              widget.onNarrate(
                question.id,
                widget.displayText(question.narrationText),
              ),
            ),
            icon: const Icon(
              Icons.record_voice_over_outlined,
              color: Colors.white70,
            ),
          ),
          if (_activeFeedbackPresentation != null &&
              widget.onFeedbackAudio != null)
            IconButton(
              key: ValueKey('challenge-feedback-speaker-${question.id}'),
              tooltip: '朗读答题反馈',
              onPressed: () => unawaited(
                widget.onFeedbackAudio!(question.id, _feedbackAudioText),
              ),
              icon: const Icon(
                Icons.volume_up_rounded,
                color: PhoenixTheme.gold,
              ),
            ),
        ],
      );

  Widget _rebuild() => Column(
        key: const ValueKey('challenge-rebuild-body'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            question.prompt,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '按自然语义块恢复完整句子',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              for (var i = 0; i < built.length; i++) _builtTile(built[i], i),
            ],
          ),
          const Divider(color: Colors.white24),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              for (var i = 0; i < remaining.length; i++)
                ActionChip(
                  key: ValueKey('challenge-rebuild-option-$i'),
                  label: Text(remaining[i]),
                  onPressed: submitted
                      ? null
                      : () => setState(() {
                            built.add(remaining.removeAt(i));
                          }),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              TextButton(
                onPressed: built.isEmpty || submitted
                    ? null
                    : () => setState(() {
                          remaining.add(built.removeLast());
                        }),
                child: const Text('撤销'),
              ),
              TextButton(
                onPressed: submitted ? null : () => setState(_resetQuestion),
                child: const Text('重置'),
              ),
            ],
          ),
        ],
      );

  List<String> get _rebuildCorrectChunks {
    final available = List<String>.of(question.characterTiles);
    final ordered = <String>[];
    var cursor = 0;
    while (available.isNotEmpty && cursor < question.answer.length) {
      final match = available.indexWhere(
        (tile) => question.answer.startsWith(tile, cursor),
      );
      if (match < 0) return const <String>[];
      final tile = available.removeAt(match);
      ordered.add(tile);
      cursor += tile.length;
    }
    return cursor == question.answer.length
        ? List<String>.unmodifiable(ordered)
        : const <String>[];
  }

  Widget _builtTile(String chunk, int tileIndex) {
    final expected = _rebuildCorrectChunks;
    final correctPosition =
        tileIndex < expected.length && expected[tileIndex] == chunk;
    final wrong = submitted && !correctPosition;
    final correct = submitted && correctPosition;
    return GestureDetector(
      onTap: submitted
          ? null
          : () => setState(() {
                remaining.add(built.removeAt(tileIndex));
              }),
      child: Container(
        key: ValueKey(
          wrong
              ? 'challenge-wrong-rebuild-$tileIndex'
              : 'challenge-rebuild-built-$tileIndex',
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: wrong
              ? Colors.red.withValues(alpha: .18)
              : correct
                  ? Colors.green.withValues(alpha: .16)
                  : Colors.white.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: wrong
                ? Colors.redAccent
                : correct
                    ? Colors.greenAccent
                    : PhoenixTheme.gold,
          ),
        ),
        child: Text(
          chunk,
          style: TextStyle(
            color: wrong
                ? Colors.redAccent
                : correct
                    ? Colors.greenAccent
                    : Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _grammar() => Column(
        key: const ValueKey('challenge-grammar-body'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '有语病的完整句子',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          _grammarSentence(),
          const SizedBox(height: 12),
          if (grammarStep <= 1) ...<Widget>[
            const Text(
              'STEP 1 · 哪里错？',
              style: TextStyle(color: PhoenixTheme.gold),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < question.errorSegments.length; i++)
              _choice(
                key: ValueKey('grammar-location-$i'),
                selected: selectedError == i,
                correct: grammarLocationSubmitted &&
                    i == question.errorSegmentIndex,
                wrong: grammarLocationSubmitted &&
                    selectedError == i &&
                    i != question.errorSegmentIndex,
                text:
                    '${String.fromCharCode(65 + i)}  ${question.errorSegments[i]}',
                onTap: grammarLocationSubmitted
                    ? null
                    : () => setState(() => selectedError = i),
              ),
            if (grammarStep == 1) ...<Widget>[
              const SizedBox(height: 6),
              const Divider(color: Colors.white24),
              _feedbackBlock(
                grammarLocationFeedbackPresentation(question, selectedError!),
                prefix: 'grammar-step1',
              ),
            ],
          ] else ...<Widget>[
            const Text(
              'STEP 2 · 怎么改？',
              style: TextStyle(color: PhoenixTheme.gold),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < question.options.length; i++)
              _choice(
                key: ValueKey('grammar-repair-$i'),
                selected: selectedOption == i,
                correct: submitted && question.options[i] == question.answer,
                wrong: submitted &&
                    selectedOption == i &&
                    question.options[i] != question.answer,
                text: '${String.fromCharCode(65 + i)}  ${question.options[i]}',
                onTap: submitted
                    ? null
                    : () => setState(() => selectedOption = i),
              ),
          ],
        ],
      );

  Widget _grammarSentence() {
    final segments = question.errorSegments;
    final errorIndex = question.errorSegmentIndex;
    if (segments.isEmpty || segments.join() != question.prompt) {
      return Text(
        question.prompt,
        key: const ValueKey('grammar-broken-sentence'),
        style: const TextStyle(
          color: Colors.white,
          height: 1.45,
          fontWeight: FontWeight.w700,
        ),
      );
    }
    return RichText(
      key: const ValueKey('grammar-broken-sentence'),
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white,
          height: 1.45,
          fontWeight: FontWeight.w700,
        ),
        children: <InlineSpan>[
          for (var i = 0; i < segments.length; i++)
            TextSpan(
              text: segments[i],
              style: grammarLocationSubmitted &&
                      selectedError == i &&
                      i != errorIndex
                  ? const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                    )
                  : grammarLocationSubmitted && i == errorIndex
                      ? const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w900,
                        )
                      : null,
            ),
        ],
      ),
    );
  }

  Widget _directChoice({required String instruction}) => Column(
        key: ValueKey('challenge-direct-${question.mode.name}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            instruction,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.prompt,
            key: const ValueKey('challenge-direct-prompt'),
            style: const TextStyle(
              color: Colors.white,
              height: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < question.options.length; i++)
            _choice(
              key: ValueKey('challenge-option-$i'),
              selected: selectedOption == i,
              correct: submitted && question.options[i] == question.answer,
              wrong: submitted &&
                  selectedOption == i &&
                  question.options[i] != question.answer,
              text: '${String.fromCharCode(65 + i)}  ${question.options[i]}',
              onTap:
                  submitted ? null : () => setState(() => selectedOption = i),
            ),
        ],
      );

  Widget _finalFeedback() {
    final presentation = _activeFeedbackPresentation;
    if (presentation == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Divider(color: Colors.white24),
          _feedbackBlock(
            presentation,
            prefix: question.mode == StoryChallengeMode.grammarRepair
                ? 'grammar-step2'
                : 'challenge',
          ),
        ],
      ),
    );
  }

  Widget _feedbackBlock(
    ChallengeFeedbackPresentation presentation, {
    required String prefix,
  }) =>
      Column(
        key: ValueKey('$prefix-feedback-block'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.displayText(presentation.statusText),
            key: ValueKey(
              prefix == 'challenge'
                  ? 'challenge-inline-feedback'
                  : '$prefix-status',
            ),
            style: TextStyle(
              color:
                  presentation.correct ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.w900,
            ),
          ),
          for (final field in presentation.fields) ...<Widget>[
            const SizedBox(height: 5),
            Text(
              field.text(widget.displayText),
              key: ValueKey(_feedbackFieldKey(prefix, field.kind)),
              style: TextStyle(
                color: switch (field.kind) {
                  ChallengeFeedbackFieldKind.userChoice => Colors.redAccent,
                  ChallengeFeedbackFieldKind.correctAnswer => Colors.greenAccent,
                  ChallengeFeedbackFieldKind.errorLocation => Colors.greenAccent,
                  ChallengeFeedbackFieldKind.explanation => Colors.white70,
                },
                height: 1.45,
                fontWeight: field.kind == ChallengeFeedbackFieldKind.explanation
                    ? FontWeight.w600
                    : FontWeight.w800,
              ),
            ),
          ],
        ],
      );

  String _feedbackFieldKey(
    String prefix,
    ChallengeFeedbackFieldKind kind,
  ) {
    if (prefix == 'challenge') {
      return switch (kind) {
        ChallengeFeedbackFieldKind.userChoice =>
          'challenge-selected-wrong-answer',
        ChallengeFeedbackFieldKind.correctAnswer =>
          'challenge-inline-correct-answer',
        ChallengeFeedbackFieldKind.errorLocation =>
          'challenge-feedback-error-location',
        ChallengeFeedbackFieldKind.explanation => 'challenge-why-correct',
      };
    }
    return '$prefix-${switch (kind) {
      ChallengeFeedbackFieldKind.userChoice => 'user-choice',
      ChallengeFeedbackFieldKind.correctAnswer => 'correct-answer',
      ChallengeFeedbackFieldKind.errorLocation => 'error-location',
      ChallengeFeedbackFieldKind.explanation => 'explanation',
    }}';
  }

  Widget _choice({
    required Key key,
    required bool selected,
    required String text,
    required VoidCallback? onTap,
    bool correct = false,
    bool wrong = false,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: InkWell(
          key: key,
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: wrong
                  ? Colors.red.withValues(alpha: .18)
                  : correct
                      ? Colors.green.withValues(alpha: .16)
                      : selected
                          ? PhoenixTheme.gold.withValues(alpha: .22)
                          : Colors.white.withValues(alpha: .06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: wrong
                    ? Colors.redAccent
                    : correct
                        ? Colors.greenAccent
                        : selected
                            ? PhoenixTheme.gold
                            : Colors.white24,
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: wrong
                    ? Colors.redAccent
                    : correct
                        ? Colors.greenAccent
                        : Colors.white,
              ),
            ),
          ),
        ),
      );
}
