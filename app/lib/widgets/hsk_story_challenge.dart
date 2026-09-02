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
  });

  final StoryChallengeSet challenge;
  final String Function(String) displayText;
  final Future<void> Function() onCompleted;
  final Future<void> Function(String questionId, String text) onNarrate;

  @override
  State<HskStoryChallenge> createState() => _HskStoryChallengeState();
}

class _HskStoryChallengeState extends State<HskStoryChallenge> {
  int index = 0;
  int grammarStep = 0;
  int? selectedOption;
  int? selectedError;
  bool submitted = false;
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
      return selectedOption != null &&
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
      return built.isNotEmpty;
    }
    if (question.mode == StoryChallengeMode.grammarRepair) {
      return grammarStep == 1 && selectedOption != null;
    }
    return completionSelections.every((selection) => selection != null);
  }

  void _submit() {
    if (question.mode == StoryChallengeMode.grammarRepair && grammarStep == 0) {
      if (selectedError == null) return;
      setState(() {
        grammarStep = 1;
        selectedOption = null;
      });
      return;
    }
    if (!_canSubmit) return;
    setState(() => submitted = true);
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
        FilledButton(
          key: ValueKey(submitted ? 'challenge-next' : 'challenge-submit'),
          onPressed: submitted
              ? () => unawaited(_next())
              : (question.mode == StoryChallengeMode.grammarRepair &&
                          grammarStep == 0
                      ? selectedError != null
                      : _canSubmit)
                  ? _submit
                  : null,
          child: Text(
            submitted
                ? (index == 11 ? '完成挑战' : '下一题')
                : grammarStep == 0 &&
                        question.mode == StoryChallengeMode.grammarRepair
                    ? '提交位置'
                    : '提交',
          ),
        ),
      ],
    );
  }

  Widget _questionBody() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              _correct ? '回答正确' : '回答错误',
              key: const ValueKey('challenge-inline-feedback'),
              style: TextStyle(
                color: _correct ? Colors.greenAccent : PhoenixTheme.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '正确答案：${question.answer}',
              style: const TextStyle(color: Colors.white, height: 1.45),
            ),
          ],
        ],
      );

  Widget _rebuild() => Column(
        key: const ValueKey('challenge-rebuild-body'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '用语义块复原当前 Story 短句',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (final chunk in built) _tile(chunk, null),
            ],
          ),
          const Divider(color: Colors.white24),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              for (var i = 0; i < remaining.length; i++)
                _tile(remaining[i], i),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: built.isEmpty
                    ? null
                    : () => setState(() {
                          remaining.add(built.removeLast());
                        }),
                child: const Text('撤销'),
              ),
              TextButton(
                onPressed: () => setState(_resetQuestion),
                child: const Text('重置'),
              ),
            ],
          ),
        ],
      );

  Widget _tile(String chunk, int? remainingIndex) => ActionChip(
        label: Text(chunk),
        onPressed: remainingIndex == null || submitted
            ? null
            : () => setState(() {
                  built.add(remaining.removeAt(remainingIndex));
                }),
      );

  Widget _grammar() => Column(
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
          Text(
            question.prompt,
            key: const ValueKey('grammar-broken-sentence'),
            style: const TextStyle(
              color: Colors.white,
              height: 1.45,
              fontWeight: FontWeight.w700,
            ),
          ),
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
                text:
                    '${String.fromCharCode(65 + i)}  ${question.errorSegments[i]}',
                onTap: submitted
                    ? null
                    : () => setState(() => selectedError = i),
              ),
          ] else ...[
            const Text(
              'STEP 2 · 怎么改？',
              style: TextStyle(color: PhoenixTheme.gold),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < question.options.length; i++)
              _choice(
                selected: selectedOption == i,
                text:
                    '${String.fromCharCode(65 + i)}  ${question.options[i]}',
                onTap: submitted
                    ? null
                    : () => setState(() => selectedOption = i),
              ),
          ],
        ],
      );

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
      spans.add(
        TextSpan(
          text: selection == null
              ? '〔${i + 1}〕____'
              : '〔${i + 1}〕${question.completionBlanks[i].options[selection]}',
          style: const TextStyle(
            color: PhoenixTheme.gold,
            fontWeight: FontWeight.w900,
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
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: selected
                  ? PhoenixTheme.gold.withValues(alpha: .22)
                  : Colors.white.withValues(alpha: .06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? PhoenixTheme.gold : Colors.white24,
              ),
            ),
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ),
      );
}
