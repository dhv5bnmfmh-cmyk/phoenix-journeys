import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../services/sentence_recognition_service.dart';
import '../theme/phoenix_theme.dart';

@immutable
class ShadowingEvaluation {
  const ShadowingEvaluation({
    required this.score,
    required this.matchedCharacters,
    required this.targetCharacters,
  });

  final int score;
  final int matchedCharacters;
  final int targetCharacters;

  bool get passed => score >= 72;
  bool get excellent => score >= 90;
}

@visibleForTesting
String normalizeShadowingText(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[\s，。！？；：、“”‘’（）()《》〈〉【】\[\],.!?;:\-—…]'), '');
}

@visibleForTesting
ShadowingEvaluation evaluateShadowing({
  required String target,
  required String spoken,
}) {
  final expected = normalizeShadowingText(target);
  final actual = normalizeShadowingText(spoken);
  if (expected.isEmpty) {
    return const ShadowingEvaluation(
      score: 0,
      matchedCharacters: 0,
      targetCharacters: 0,
    );
  }

  final rows = List<int>.filled(actual.length + 1, 0);
  for (var targetIndex = 1; targetIndex <= expected.length; targetIndex += 1) {
    var previousDiagonal = 0;
    for (var spokenIndex = 1; spokenIndex <= actual.length; spokenIndex += 1) {
      final previousRow = rows[spokenIndex];
      if (expected[targetIndex - 1] == actual[spokenIndex - 1]) {
        rows[spokenIndex] = previousDiagonal + 1;
      } else {
        rows[spokenIndex] = math.max(rows[spokenIndex], rows[spokenIndex - 1]);
      }
      previousDiagonal = previousRow;
    }
  }

  final matched = rows.last;
  final recall = matched / expected.length;
  final precision = actual.isEmpty ? 0.0 : matched / actual.length;
  final score = actual.isEmpty
      ? 0
      : ((recall * .72 + precision * .28) * 100).round().clamp(0, 100);
  return ShadowingEvaluation(
    score: score,
    matchedCharacters: matched,
    targetCharacters: expected.length,
  );
}

class SentenceShadowingPractice extends StatefulWidget {
  const SentenceShadowingPractice({
    required this.sentence,
    required this.foreground,
    required this.activeColor,
    required this.dark,
    required this.onBeforeListen,
    super.key,
  });

  final String sentence;
  final Color foreground;
  final Color activeColor;
  final bool dark;
  final Future<void> Function() onBeforeListen;

  @override
  State<SentenceShadowingPractice> createState() =>
      _SentenceShadowingPracticeState();
}

class _SentenceShadowingPracticeState extends State<SentenceShadowingPractice> {
  final SentenceRecognitionService _speech = SentenceRecognitionService();
  bool _initializing = false;
  bool _listening = false;
  String _recognized = '';
  ShadowingEvaluation? _evaluation;
  String? _message;

  @override
  void didUpdateWidget(covariant SentenceShadowingPractice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sentence != widget.sentence) {
      _speech.cancel();
      _listening = false;
      _recognized = '';
      _evaluation = null;
      _message = null;
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) _finishEvaluation();
      return;
    }
    if (_initializing) return;

    setState(() {
      _initializing = true;
      _recognized = '';
      _evaluation = null;
      _message = null;
    });
    await widget.onBeforeListen();
    if (!mounted) return;

    final started = await _speech.start(
      onResult: (text, {required isFinal}) {
        if (!mounted) return;
        setState(() => _recognized = text);
        if (isFinal) _finishEvaluation();
      },
      onComplete: () {
        if (mounted && _listening) _finishEvaluation();
      },
      onError: () {
        if (!mounted) return;
        setState(() {
          _listening = false;
          _initializing = false;
          _message = '没有听清，请再试一次';
        });
      },
    );
    if (!mounted) return;
    if (!started) {
      setState(() {
        _initializing = false;
        _message = '当前浏览器暂不支持跟读识别';
      });
      return;
    }

    setState(() {
      _initializing = false;
      _listening = true;
    });
  }

  void _finishEvaluation() {
    if (!mounted) return;
    final evaluation = evaluateShadowing(
      target: widget.sentence,
      spoken: _recognized,
    );
    setState(() {
      _listening = false;
      _initializing = false;
      _evaluation = evaluation;
      _message = _recognized.trim().isEmpty
          ? '没有听清，请再试一次'
          : evaluation.excellent
          ? '非常自然，继续下一句'
          : evaluation.passed
          ? '已经很接近，再读一次会更稳'
          : '放慢一点，注意句子中的关键词';
    });
  }

  @override
  Widget build(BuildContext context) {
    final evaluation = _evaluation;
    final foreground = widget.dark ? Colors.white : PhoenixTheme.red;
    final resultColor = evaluation == null
        ? widget.activeColor
        : evaluation.passed
        ? const Color(0xFF2F8B67)
        : const Color(0xFFC46B36);

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                button: true,
                label: _listening ? '停止跟读录音' : '开始跟读当前句子',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const ValueKey('sentence-shadowing-action'),
                    onTap: _toggleListening,
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: resultColor.withValues(alpha: widget.dark ? .18 : .11),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: resultColor.withValues(alpha: .36)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _listening ? Icons.stop_rounded : Icons.mic_none_rounded,
                            size: 12,
                            color: foreground,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _initializing
                                ? '准备中'
                                : _listening
                                ? '正在听 · 点击结束'
                                : evaluation == null
                                ? '跟读这句'
                                : '再读一次',
                            style: TextStyle(
                              color: foreground,
                              fontSize: 8.5,
                              height: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (evaluation != null && _recognized.trim().isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  '${evaluation.score}分',
                  key: const ValueKey('sentence-shadowing-score'),
                  style: TextStyle(
                    color: resultColor,
                    fontSize: 9,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ],
          ),
          if (_listening || _message != null) ...[
            const SizedBox(height: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 230),
              child: Text(
                _listening
                    ? (_recognized.isEmpty ? '请读出上面的句子…' : _recognized)
                    : _message!,
                key: const ValueKey('sentence-shadowing-feedback'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: widget.dark ? Colors.white70 : Colors.black54,
                  fontSize: 8,
                  height: 1.25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
