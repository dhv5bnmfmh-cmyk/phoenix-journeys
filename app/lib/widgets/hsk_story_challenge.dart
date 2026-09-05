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
  });

  final StoryChallengeSet challenge;
  final String Function(String) displayText;
  final Future<void> Function() onCompleted;
  final Future<void> Function(String questionId, String text) onNarrate;
  final Future<void> Function(String questionId, bool correct)? onFeedbackAudio;

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
  bool completionReported = false;
  final List<String> built = [];
  late List<String> remaining;
  late List<int?> completionSelections;

  StoryChallengeQuestion get question => widget.challenge.questions[index];

  @override
  void initState() {
    super.initState();
    remaining = List.of(question.characterTiles);
    completionSelections =
        List<int?>.filled(question.completionBlanks.length, null);
  }

  String get modeTitle => switch (question.mode) {
        StoryChallengeMode.sentenceRebuild => '句子复原',
        StoryChallengeMode.grammarRepair => '语病修复',
        StoryChallengeMode.storyCompletion => '补全故事',
      };

  int get modeIndex => index % 4 + 1;

  void _resetQuestion() {
    grammarStep = 0;
    selectedOption = null;
    selectedError = null;
    grammarLocationSubmitted = false;
    submitted = false;
    built.clear();
    remaining = List.of(question.characterTiles);
    completionSelections =
        List<int?>.filled(question.completionBlanks.length, null);
  }

  bool get _correct {
    if (question.mode == StoryChallengeMode.sentenceRebuild) {
      return built.join() == question.answer;
    }
    if (question.mode == StoryChallengeMode.grammarRepair) {
      return selectedError == question.errorSegmentIndex &&
          selectedOption != null &&
          question.options[selectedOption!] == question.answer;
    }
    for (var i = 0; i < question.completionBlanks.length; i++) {
      final selected = completionSelections[i];
      if (selected == null ||
          question.completionBlanks[i].options[selected] !=
              question.completionBlanks[i].answer) {
        return false;
      }
    }
    return true;
  }

  bool get _canSubmit {
    if (question.mode == StoryChallengeMode.sentenceRebuild) {
      return remaining.isEmpty &&
          built.length == question.characterTiles.length;
    }
    if (question.mode == StoryChallengeMode.grammarRepair) {
      return grammarStep == 1 && selectedOption != null;
    }
    return completionSelections.every((selection) => selection != null);
  }

  void _submit() {
    if (question.mode == StoryChallengeMode.grammarRepair && grammarStep == 0) {
      if (selectedError == null) return;
      final correct = selectedError == question.errorSegmentIndex;
      setState(() => grammarLocationSubmitted = true);
      final feedbackAudio = widget.onFeedbackAudio;
      if (feedbackAudio != null) {
        unawaited(feedbackAudio(question.id, correct));
      }
      return;
    }
    if (!_canSubmit) return;
    final correct = _correct;
    setState(() => submitted = true);
    final feedbackAudio = widget.onFeedbackAudio;
    if (feedbackAudio != null) {
      unawaited(feedbackAudio(question.id, correct));
    }
    if (index == widget.challenge.questions.length - 1 &&
        !completionReported) {
      completionReported = true;
      unawaited(widget.onCompleted());
    }
  }

  void _continueGrammarRepair() {
    if (!grammarLocationSubmitted || grammarStep != 0) return;
    setState(() {
      grammarStep = 1;
      selectedOption = null;
    });
  }

  Future<void> _next() async {
    if (index == widget.challenge.questions.length - 1) {
      await widget.onCompleted();
      return;
    }
    setState(() {
      index += 1;
      _resetQuestion();
    });
  }

  String _narrationText() {
    if (submitted) return question.answer;
    if (question.mode != StoryChallengeMode.storyCompletion) {
      return question.narrationText;
    }
    final buffer = StringBuffer();
    for (var i = 0; i < question.completionBlanks.length; i++) {
      buffer.write(question.completionSegments[i]);
      final selection = completionSelections[i];
      buffer.write(
        selection == null
            ? '空位'
            : question.completionBlanks[i].options[selection],
      );
    }
    buffer.write(question.completionSegments.last);
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey('hsk-challenge-question-${question.id}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '$modeTitle $modeIndex/4',
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
        ),
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
        if (!(submitted &&
            index == widget.challenge.questions.length - 1))
          FilledButton(
            key: ValueKey(submitted ? 'challenge-next' : 'challenge-submit'),
            onPressed: submitted
                ? () => unawaited(_next())
                : question.mode == StoryChallengeMode.grammarRepair &&
                        grammarStep == 0
                    ? grammarLocationSubmitted
                        ? _continueGrammarRepair
                        : selectedError != null
                            ? _submit
                            : null
                    : _canSubmit
                        ? _submit
                        : null,
            child: Text(
              submitted
                  ? '下一题'
                  : question.mode == StoryChallengeMode.grammarRepair &&
                          grammarStep == 0
                      ? grammarLocationSubmitted
                          ? '继续修改'
                          : '确认位置'
                      : '提交',
            ),
          ),
      ],
    );
  }

  Widget _questionBody() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (question.mode != StoryChallengeMode.sentenceRebuild || submitted)
            Row(
              children: [
                const Spacer(),
                IconButton(
                  key: ValueKey('challenge-speaker-${question.id}'),
                  tooltip: '朗读当前题目',
                  onPressed: () => unawaited(
                    widget.onNarrate(
                      question.id,
                      widget.displayText(_narrationText()),
                    ),
                  ),
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: PhoenixTheme.gold,
                  ),
                ),
              ],
            ),
          switch (question.mode) {
            StoryChallengeMode.sentenceRebuild => _rebuild(),
            StoryChallengeMode.grammarRepair => _grammar(),
            StoryChallengeMode.storyCompletion => _completion(),
          },
          if (submitted) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white24),
            Text(
              _correct
                  ? '回答正确'
                  : '回答错误 · 红色为你的错误选择，绿色为正确答案',
              key: const ValueKey('challenge-inline-feedback'),
              style: TextStyle(
                color: _correct ? Colors.greenAccent : Colors.redAccent,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (question.mode == StoryChallengeMode.grammarRepair) ...[
              const SizedBox(height: 8),
              _grammarFinalFeedback(),
            ] else if (!_correct) ...[
              const SizedBox(height: 8),
              _errorFeedback(),
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
            if (question.mode == StoryChallengeMode.grammarRepair &&
                question.grammarRevisionRule != null) ...[
              const SizedBox(height: 6),
              Text(
                (selectedOption != null &&
                        question.options[selectedOption!] == question.answer)
                    ? '为什么这样改：${question.grammarRevisionRule}'
                    : '修改原则：${question.grammarRevisionRule}',
                key: const ValueKey('grammar-revision-rule'),
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.45,
                ),
              ),
            ],
          ],
        ],
      );

  Widget _errorFeedback() => switch (question.mode) {
        StoryChallengeMode.sentenceRebuild => _rebuildErrorFeedback(),
        StoryChallengeMode.grammarRepair => _grammarFinalFeedback(),
        StoryChallengeMode.storyCompletion => _completionErrorFeedback(),
      };

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

  Widget _rebuildErrorFeedback() {
    final expected = _rebuildCorrectChunks;
    final rows = <Widget>[];
    for (var i = 0; i < built.length; i++) {
      final expectedChunk = i < expected.length ? expected[i] : '—';
      if (built[i] == expectedChunk) continue;
      rows.add(
        Text(
          '第 ${i + 1} 块位置错误：${built[i]} → 正确应为 $expectedChunk',
          key: ValueKey('challenge-rebuild-error-$i'),
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _grammarFinalFeedback() {
    final errorIndex = question.errorSegmentIndex ?? 0;
    final actual = question.errorSegments[errorIndex];
    final locationCorrect = selectedError == errorIndex;
    final selectedLocation = selectedError == null
        ? '未选择'
        : question.errorSegments[selectedError!];
    final selectedRepair =
        selectedOption == null ? '未选择' : question.options[selectedOption!];
    final repairCorrect = selectedOption != null &&
        question.options[selectedOption!] == question.answer;
    final explanation = selectedOption != null &&
            selectedOption! < question.grammarOptionExplanations.length
        ? question.grammarOptionExplanations[selectedOption!]
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!locationCorrect) ...[
          Text(
            '你的选择（错误位置）：$selectedLocation',
            key: const ValueKey('grammar-wrong-location'),
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
        ],
        Text(
          '正确错误位置：$actual',
          key: const ValueKey('grammar-correct-location-final'),
          style: const TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (question.grammarWhyWrong != null) ...[
          const SizedBox(height: 4),
          Text(
            '为什么这里有语病：${question.grammarWhyWrong}',
            key: const ValueKey('grammar-final-why-wrong'),
            style: const TextStyle(
              color: Colors.white70,
              height: 1.45,
            ),
          ),
        ],
        if (question.grammarFamily != null) ...[
          const SizedBox(height: 4),
          Text(
            '语法点：${question.grammarFamily}',
            key: const ValueKey('grammar-final-family'),
            style: const TextStyle(
              color: PhoenixTheme.gold,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        const SizedBox(height: 5),
        Text(
          repairCorrect ? '修改正确' : '修改错误',
          key: const ValueKey('grammar-repair-feedback'),
          style: TextStyle(
            color: repairCorrect ? Colors.greenAccent : Colors.redAccent,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          repairCorrect ? '你的修改（正确）：$selectedRepair' : '你的修改（错误）：$selectedRepair',
          key: const ValueKey('grammar-selected-repair'),
          style: TextStyle(
            color: repairCorrect ? Colors.greenAccent : Colors.redAccent,
            height: 1.45,
          ),
        ),
        if (explanation.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            repairCorrect ? '选项说明：$explanation' : '为什么不对：$explanation',
            key: const ValueKey('grammar-option-explanation'),
            style: const TextStyle(
              color: Colors.white70,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }

  Widget _completionErrorFeedback() {
    final rows = <Widget>[];
    for (var i = 0; i < question.completionBlanks.length; i++) {
      final blank = question.completionBlanks[i];
      final selectedIndex = completionSelections[i];
      if (selectedIndex == null) continue;
      final selected = blank.options[selectedIndex];
      if (selected == blank.answer) continue;
      rows.add(
        Text(
          '空位 ${i + 1} 填错：$selected → 正确应填 ${blank.answer}',
          key: ValueKey('completion-error-$i'),
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _rebuild() => Column(
        key: const ValueKey('challenge-rebuild-body'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '复原一条与北京 · 紫禁城相关的知识句',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (var i = 0; i < built.length; i++) _builtTile(built[i], i),
            ],
          ),
          const Divider(color: Colors.white24),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (var i = 0; i < remaining.length; i++)
                _remainingTile(remaining[i], i),
            ],
          ),
          Row(
            children: [
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

  Widget _builtTile(String chunk, int index) {
    final expected = _rebuildCorrectChunks;
    final correctPosition =
        index < expected.length && expected[index] == chunk;
    final wrong = submitted && !correctPosition;
    final correct = submitted && correctPosition;
    final backgroundColor = wrong
        ? const Color(0xFF431C1C)
        : correct
            ? const Color(0xFF163D26)
            : const Color(0xF0221815);
    final borderColor = wrong
        ? Colors.redAccent
        : correct
            ? Colors.greenAccent
            : PhoenixTheme.gold.withValues(alpha: .78);
    final textColor = wrong
        ? Colors.redAccent
        : correct
            ? Colors.greenAccent
            : Colors.white;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: submitted
          ? null
          : () => setState(() {
                remaining.add(built.removeAt(index));
              }),
      child: Container(
        key: ValueKey(
          wrong
              ? 'challenge-wrong-rebuild-$index'
              : 'challenge-rebuild-built-$index',
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.1),
        ),
        child: Text(
          chunk,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _remainingTile(String chunk, int remainingIndex) => ActionChip(
        label: Text(chunk),
        onPressed: submitted
            ? null
            : () => setState(() {
                  built.add(remaining.removeAt(remainingIndex));
                }),
      );

  Widget _grammar() {
    final errorIndex = question.errorSegmentIndex ?? 0;
    final locationCorrect =
        grammarLocationSubmitted && selectedError == errorIndex;
    return Column(
      key: const ValueKey('challenge-grammar-body'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        if (grammarStep == 0) ...[
          const Text(
            'STEP 1 · 哪里错？',
            style: TextStyle(color: PhoenixTheme.gold),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < question.errorSegments.length; i++)
            _choice(
              selected: selectedError == i,
              correct: grammarLocationSubmitted && i == errorIndex,
              wrong: grammarLocationSubmitted &&
                  selectedError == i &&
                  i != errorIndex,
              text:
                  '${String.fromCharCode(65 + i)}  ${question.errorSegments[i]}',
              onTap: submitted || grammarLocationSubmitted
                  ? null
                  : () => setState(() => selectedError = i),
            ),
          if (grammarLocationSubmitted) ...[
            const SizedBox(height: 6),
            Text(
              locationCorrect ? '位置正确' : '位置错误',
              key: const ValueKey('grammar-location-feedback'),
              style: TextStyle(
                color: locationCorrect
                    ? Colors.greenAccent
                    : Colors.redAccent,
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
            if (!locationCorrect && selectedError != null) ...[
              const SizedBox(height: 4),
              Text(
                '你选的“${question.errorSegments[selectedError!]}”本身在这个句子里语法成立。',
                key: const ValueKey('grammar-selected-location-explanation'),
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.45,
                ),
              ),
            ],
            if (question.grammarWhyWrong != null) ...[
              const SizedBox(height: 4),
              Text(
                locationCorrect
                    ? '为什么这里错：${question.grammarWhyWrong}'
                    : '真正的问题：${question.grammarWhyWrong}',
                key: const ValueKey('grammar-step1-why-wrong'),
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.45,
                ),
              ),
            ],
            if (question.grammarFamily != null) ...[
              const SizedBox(height: 4),
              Text(
                '语法点：${question.grammarFamily}',
                key: const ValueKey('grammar-family'),
                style: const TextStyle(
                  color: PhoenixTheme.gold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ] else ...[
          const Text(
            'STEP 2 · 怎么改？',
            style: TextStyle(color: PhoenixTheme.gold),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < question.options.length; i++)
            _choice(
              selected: selectedOption == i,
              correct: submitted && question.options[i] == question.answer,
              wrong: submitted &&
                  selectedOption == i &&
                  question.options[i] != question.answer,
              text:
                  '${String.fromCharCode(65 + i)}  ${question.options[i]}',
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
    final showFeedback = grammarLocationSubmitted || submitted;
    final errorIndex = question.errorSegmentIndex;
    return RichText(
      key: const ValueKey('grammar-broken-sentence'),
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white,
          height: 1.45,
          fontWeight: FontWeight.w700,
        ),
        children: [
          for (var i = 0; i < segments.length; i++)
            TextSpan(
              text: segments[i],
              style: showFeedback &&
                      selectedError == i &&
                      i != errorIndex
                  ? const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                    )
                  : showFeedback && i == errorIndex
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

  Widget _completion() {
    final active = completionSelections.indexWhere((value) => value == null);
    final activeIndex =
        active < 0 ? question.completionBlanks.length - 1 : active;
    final blank = question.completionBlanks[activeIndex];
    return Column(
      key: const ValueKey('challenge-completion-body'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _completionPassage(),
        const SizedBox(height: 12),
        Text(
          '空位 ${activeIndex + 1}/${question.completionBlanks.length}',
          key: const ValueKey('completion-blank-progress'),
          style: const TextStyle(
            color: PhoenixTheme.gold,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '选择最适合填入的${blank.answerType}',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < blank.options.length; i++)
          _choice(
            selected: completionSelections[activeIndex] == i,
            correct: submitted && blank.options[i] == blank.answer,
            wrong: submitted &&
                completionSelections[activeIndex] == i &&
                blank.options[i] != blank.answer,
            text: '${String.fromCharCode(65 + i)}  ${blank.options[i]}',
            onTap: submitted
                ? null
                : () => setState(() {
                      completionSelections[activeIndex] = i;
                    }),
          ),
      ],
    );
  }

  Widget _completionPassage() {
    final spans = <InlineSpan>[];
    for (var i = 0; i < question.completionBlanks.length; i++) {
      spans.add(TextSpan(text: question.completionSegments[i]));
      final selection = completionSelections[i];
      final selectedValue = selection == null
          ? null
          : question.completionBlanks[i].options[selection];
      final correct = selectedValue != null &&
          selectedValue == question.completionBlanks[i].answer;
      final wrong = submitted && selectedValue != null && !correct;
      final blankColor = wrong
          ? Colors.redAccent
          : submitted && correct
              ? Colors.greenAccent
              : PhoenixTheme.gold;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            key: ValueKey('completion-passage-blank-$i'),
            behavior: HitTestBehavior.opaque,
            onTap: submitted || selection == null
                ? null
                : () => setState(() {
                      completionSelections[i] = null;
                    }),
            child: Text(
              selection == null
                  ? '〔${i + 1}〕____'
                  : '〔${i + 1}〕$selectedValue',
              style: TextStyle(
                color: blankColor,
                height: 1.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
    }
    spans.add(TextSpan(text: question.completionSegments.last));
    return RichText(
      key: const ValueKey('completion-passage'),
      text: TextSpan(
        style: const TextStyle(color: Colors.white, height: 1.5),
        children: spans,
      ),
    );
  }

  Widget _choice({
    required bool selected,
    required String text,
    required VoidCallback? onTap,
    bool correct = false,
    bool wrong = false,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: InkWell(
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
