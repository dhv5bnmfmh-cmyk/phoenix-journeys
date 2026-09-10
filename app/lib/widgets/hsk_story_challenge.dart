import 'dart:async';

import 'package:flutter/material.dart';

import '../models/journey_challenge.dart';
import '../theme/phoenix_theme.dart';

class HskStoryChallenge extends StatefulWidget {
  const HskStoryChallenge({
    super.key,
    required this.challenge,
    required this.displayText,
    required this.onCompleted,
    required this.onNarrate,
    this.onFeedbackAudio,
    this.onBackStage,
  });

  final StoryChallengeSet challenge;
  final String Function(String) displayText;
  final Future<void> Function() onCompleted;
  final Future<void> Function(String questionId, String text) onNarrate;
  final Future<void> Function(String questionId, bool correct)? onFeedbackAudio;
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

  bool get _correct {
    if (question.mode == StoryChallengeMode.sentenceRebuild) {
      return built.join() == question.answer;
    }
    if (question.mode == StoryChallengeMode.grammarRepair) {
      return selectedError == question.errorSegmentIndex &&
          selectedOption != null &&
          question.options[selectedOption!] == question.answer;
    }
    return selectedOption != null &&
        question.options[selectedOption!] == question.answer;
  }

  bool get _canSubmit {
    if (submitted) return false;
    if (question.mode == StoryChallengeMode.sentenceRebuild) {
      return remaining.isEmpty && built.length == question.characterTiles.length;
    }
    if (question.mode == StoryChallengeMode.grammarRepair) {
      return grammarStep == 0 ? selectedError != null : selectedOption != null;
    }
    return selectedOption != null;
  }

  void _resetQuestion() {
    grammarStep = 0;
    selectedOption = null;
    selectedError = null;
    grammarLocationSubmitted = false;
    submitted = false;
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

    final correct = _correct;
    setState(() => submitted = true);
    final feedbackAudio = widget.onFeedbackAudio;
    if (feedbackAudio != null) {
      unawaited(feedbackAudio(question.id, correct));
    }
  }

  Future<void> _next() async {
    if (!submitted) return;
    if (index == widget.challenge.questions.length - 1) {
      await widget.onCompleted();
      return;
    }
    setState(() {
      index += 1;
      _resetQuestion();
    });
  }

  void _previous() {
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

  Widget _bottomActions() => SizedBox(
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
                  submitted ? 'challenge-next' : 'challenge-submit',
                ),
                onPressed: submitted
                    ? () => unawaited(_next())
                    : _canSubmit
                        ? _submit
                        : null,
                style: FilledButton.styleFrom(
                  backgroundColor: PhoenixTheme.red,
                ),
                icon: Icon(
                  submitted
                      ? Icons.arrow_forward_rounded
                      : Icons.check_rounded,
                  size: 17,
                ),
                label: Text(submitted ? '下一题' : '提交'),
              ),
            ),
          ],
        ),
      );

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
          if (submitted && widget.onFeedbackAudio != null)
            IconButton(
              key: ValueKey('challenge-feedback-speaker-${question.id}'),
              tooltip: '朗读答题反馈',
              onPressed: () => unawaited(
                widget.onFeedbackAudio!(question.id, _correct),
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

  Widget _grammar() {
    final errorIndex = question.errorSegmentIndex ?? 0;
    final locationCorrect = selectedError == errorIndex;
    return Column(
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
        if (grammarStep == 0) ...<Widget>[
          const Text(
            'STEP 1 · 哪里错？',
            style: TextStyle(color: PhoenixTheme.gold),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < question.errorSegments.length; i++)
            _choice(
              key: ValueKey('grammar-location-$i'),
              selected: selectedError == i,
              text:
                  '${String.fromCharCode(65 + i)}  ${question.errorSegments[i]}',
              onTap: () => setState(() => selectedError = i),
            ),
        ] else ...<Widget>[
          Text(
            locationCorrect ? '位置正确' : '位置错误',
            key: const ValueKey('grammar-location-feedback'),
            style: TextStyle(
              color: locationCorrect ? Colors.greenAccent : Colors.redAccent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '正确错误位置：${question.errorSegments[errorIndex]}',
            key: const ValueKey('grammar-correct-location'),
            style: const TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (!locationCorrect && selectedError != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              '你的选择（错误位置）：${question.errorSegments[selectedError!]}',
              key: const ValueKey('grammar-wrong-location'),
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (question.grammarWhyWrong?.isNotEmpty ?? false) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              '为什么这里错：${question.grammarWhyWrong}',
              key: const ValueKey('grammar-step1-why-wrong'),
              style: const TextStyle(color: Colors.white70, height: 1.45),
            ),
          ],
          const SizedBox(height: 10),
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
  }

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
              style: grammarLocationSubmitted && selectedError == i && i != errorIndex
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
              onTap: submitted
                  ? null
                  : () => setState(() => selectedOption = i),
            ),
        ],
      );

  Widget _finalFeedback() {
    final selected = selectedOption == null || question.options.isEmpty
        ? null
        : question.options[selectedOption!];
    final selectedRationale = selectedOption != null &&
            selectedOption! < question.distractorRationales.length
        ? question.distractorRationales[selectedOption!]
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 12),
        const Divider(color: Colors.white24),
        Text(
          _correct ? '回答正确' : '回答错误',
          key: const ValueKey('challenge-inline-feedback'),
          style: TextStyle(
            color: _correct ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (question.mode == StoryChallengeMode.grammarRepair)
          _grammarFinalFeedback()
        else if (!_correct && selected != null) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            '你的选择：$selected',
            key: const ValueKey('challenge-selected-wrong-answer'),
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (selectedRationale?.isNotEmpty ?? false)
            Text(
              selectedRationale!,
              key: const ValueKey('challenge-selected-rationale'),
              style: const TextStyle(color: Colors.white70, height: 1.45),
            ),
        ],
        const SizedBox(height: 6),
        Text(
          '正确答案：${question.answer}',
          key: const ValueKey('challenge-inline-correct-answer'),
          style: const TextStyle(
            color: Colors.greenAccent,
            height: 1.45,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (question.whyCorrect.isNotEmpty) ...<Widget>[
          const SizedBox(height: 5),
          Text(
            '为什么：${question.whyCorrect}',
            key: const ValueKey('challenge-why-correct'),
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
        ],
      ],
    );
  }

  Widget _grammarFinalFeedback() {
    final errorIndex = question.errorSegmentIndex ?? 0;
    final actual = question.errorSegments[errorIndex];
    final locationCorrect = selectedError == errorIndex;
    final selectedLocation = selectedError == null
        ? '未选择'
        : question.errorSegments[selectedError!];
    final selectedRepair = selectedOption == null
        ? '未选择'
        : question.options[selectedOption!];
    final repairCorrect = selectedOption != null &&
        question.options[selectedOption!] == question.answer;
    final explanation = selectedOption != null &&
            selectedOption! < question.grammarOptionExplanations.length
        ? question.grammarOptionExplanations[selectedOption!]
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!locationCorrect) ...<Widget>[
          const SizedBox(height: 6),
          Text(
            '你的选择（错误位置）：$selectedLocation',
            key: const ValueKey('grammar-wrong-location-final'),
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          '真正错误位置：$actual',
          key: const ValueKey('grammar-correct-location-final'),
          style: const TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (question.grammarWhyWrong?.isNotEmpty ?? false) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            '为什么错：${question.grammarWhyWrong}',
            key: const ValueKey('grammar-final-why-wrong'),
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
        ],
        if (question.grammarRevisionRule?.isNotEmpty ?? false) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            '修正规则：${question.grammarRevisionRule}',
            key: const ValueKey('grammar-revision-rule'),
            style: const TextStyle(color: PhoenixTheme.gold, height: 1.45),
          ),
        ],
        const SizedBox(height: 4),
        Text(
          repairCorrect
              ? '你的修改（正确）：$selectedRepair'
              : '你的修改（错误）：$selectedRepair',
          key: const ValueKey('grammar-selected-repair'),
          style: TextStyle(
            color: repairCorrect ? Colors.greenAccent : Colors.redAccent,
            height: 1.45,
          ),
        ),
        if (explanation.isNotEmpty)
          Text(
            explanation,
            key: const ValueKey('grammar-option-explanation'),
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
      ],
    );
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
