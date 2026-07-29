import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/shadowing_passage_catalog.dart';
import '../services/narration_controller.dart';
import '../services/phoenix_level_controller.dart';
import '../services/shadowing_score.dart';
import '../services/shadowing_training_history.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/journey_level_selector_button.dart';

class ShadowingTrainingScreen extends StatefulWidget {
  const ShadowingTrainingScreen({
    super.key,
    this.embedded = false,
  });

  final bool embedded;

  @override
  State<ShadowingTrainingScreen> createState() =>
      _ShadowingTrainingScreenState();
}

class _ShadowingTrainingScreenState extends State<ShadowingTrainingScreen> {
  final SpeechToText _speech = SpeechToText();
  final NarrationController _narration = NarrationController();
  final Map<String, int> _bestScores = <String, int>{};
  ShadowingTrainingHistory _history = const ShadowingTrainingHistory();

  ShadowingPassage? _passage;
  int _sentenceIndex = 0;
  int _attempts = 0;
  bool _loading = true;
  bool _speechReady = false;
  bool _listening = false;
  String _recognized = '';
  ShadowingScore? _score;
  String? _speechMessage;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    for (final passage in shadowingPassages) {
      _bestScores[passage.id] =
          prefs.getInt('phoenix.shadowing.best.${passage.id}') ?? 0;
    }
    _history = ShadowingTrainingHistory.decode(
      prefs.getString('phoenix.shadowing.history'),
    );
    var ready = false;
    try {
      ready = await _speech.initialize(
        onStatus: _handleSpeechStatus,
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _listening = false;
            _speechMessage = '没有收到录音，请检查麦克风权限后重试。';
          });
        },
      );
    } catch (_) {
      ready = false;
    }
    if (!mounted) return;
    setState(() {
      _speechReady = ready;
      _loading = false;
    });
  }

  void _handleSpeechStatus(String status) {
    if (!mounted) return;
    final stopped = status == 'done' || status == 'notListening';
    if (stopped && _listening) {
      setState(() => _listening = false);
      if (_recognized.trim().isNotEmpty) _scoreCurrentAttempt();
    }
  }

  @override
  void dispose() {
    unawaited(_speech.cancel());
    _narration.dispose();
    super.dispose();
  }

  String t(String value) => context.read<AppState>().displayText(value);

  void _openPassage(ShadowingPassage passage) {
    setState(() {
      _passage = passage;
      _sentenceIndex = 0;
      _attempts = 0;
      _recognized = '';
      _score = null;
      _speechMessage = null;
    });
  }

  void _closePassage() {
    unawaited(_speech.cancel());
    unawaited(_narration.stop());
    setState(() {
      _passage = null;
      _listening = false;
      _recognized = '';
      _score = null;
      _speechMessage = null;
    });
  }

  Future<void> _playText({bool wholePassage = false}) async {
    final passage = _passage;
    if (passage == null) return;
    final text = wholePassage ? passage.text : passage.sentences[_sentenceIndex];
    await _narration.play(
      contentId: 'shadowing-${passage.id}-${wholePassage ? 'all' : _sentenceIndex}',
      items: [NarrationItem(id: 'prompt', text: text, label: passage.title)],
      languageCode: context.read<AppState>().isTraditional ? 'zh-TW' : 'zh-CN',
    );
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speech.stop();
      if (!mounted) return;
      setState(() => _listening = false);
      if (_recognized.trim().isNotEmpty) _scoreCurrentAttempt();
      return;
    }
    if (!_speechReady) {
      setState(() => _speechMessage = '当前设备未开放语音识别，请允许麦克风权限后重试。');
      return;
    }
    final localeId =
        context.read<AppState>().isTraditional ? 'zh_TW' : 'zh_CN';
    await _narration.stop();
    if (!mounted) return;
    setState(() {
      _recognized = '';
      _score = null;
      _speechMessage = null;
      _listening = true;
    });
    await _speech.listen(
      onResult: _handleSpeechResult,
      listenOptions: SpeechListenOptions(
        localeId: localeId,
        partialResults: true,
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  void _handleSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;
    setState(() => _recognized = result.recognizedWords);
    if (result.finalResult) {
      setState(() => _listening = false);
      _scoreCurrentAttempt(confidence: result.confidence);
    }
  }

  Future<void> _scoreCurrentAttempt({double confidence = 0}) async {
    final passage = _passage;
    if (passage == null || _recognized.trim().isEmpty) return;
    final score = scoreShadowing(
      reference: passage.sentences[_sentenceIndex],
      recognized: _recognized,
      recognitionConfidence: confidence,
    );
    final attempts = _attempts + 1;
    setState(() {
      _attempts = attempts;
      _score = score;
      _speechMessage = null;
    });
    if (score.overall > (_bestScores[passage.id] ?? 0)) {
      _bestScores[passage.id] = score.overall;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('phoenix.shadowing.best.${passage.id}', score.overall);
      if (mounted) setState(() {});
    }
  }

  void _nextSentence() {
    final passage = _passage;
    if (passage == null) return;
    if (_sentenceIndex >= passage.sentences.length - 1) {
      _showCompletion();
      return;
    }
    setState(() {
      _sentenceIndex += 1;
      _attempts = 0;
      _recognized = '';
      _score = null;
      _speechMessage = null;
    });
  }

  Future<void> _showCompletion() async {
    final passage = _passage;
    if (passage == null || !mounted) return;
    final completedScore = _bestScores[passage.id] ?? _score?.overall ?? 0;
    final history = _history.record(
      passageId: passage.id,
      title: passage.title,
      score: completedScore,
      completedAt: DateTime.now(),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoenix.shadowing.history', history.encode());
    if (!mounted) return;
    setState(() => _history = history);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_rounded, color: PhoenixTheme.red, size: 54),
            const SizedBox(height: 8),
            Text(t('短文跟读完成'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(t('已完成《${passage.title}》的全部 ${passage.sentences.length} 句。'), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _closePassage();
                },
                child: Text(t('选择下一篇短文')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      appBar: AppBar(
        title: Text(state.displayText(_passage == null ? '跟读训练' : _passage!.title)),
        automaticallyImplyLeading: false,
        leading: widget.embedded
            ? null
            : IconButton(
                onPressed: _passage == null
                    ? () => Navigator.of(context).pop()
                    : _closePassage,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
        actions: widget.embedded
            ? null
            : const [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: JourneyLevelSelectorButton(compact: true),
                ),
              ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _passage == null
                ? _passageLibrary(state)
                : _practicePage(state, _passage!),
      ),
    );
  }

  Widget _passageLibrary(AppState state) {
    final level = PhoenixLevelController.instance.level;
    final passages = shadowingPassagesForLevel(level);
    return ListView(
      key: const ValueKey('shadowing-passage-library'),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF7B1E1E), Color(0xFFA33A31)]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.record_voice_over_rounded, color: Color(0xFFFFD879), size: 34),
              const SizedBox(height: 8),
              Text(state.displayText('选择一篇短文，听一句，跟一句。'), style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              Text(state.displayText('Phoenix Lv.$level · 已为你显示适合当前等级的练习。'), style: const TextStyle(color: Colors.white70, height: 1.35)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _TrainingDashboard(
          history: _history,
          displayText: state.displayText,
        ),
        const SizedBox(height: 12),
        for (final passage in passages) ...[
          _PassageCard(
            passage: passage,
            bestScore: _bestScores[passage.id] ?? 0,
            displayText: state.displayText,
            onTap: () => _openPassage(passage),
          ),
          const SizedBox(height: 9),
        ],
      ],
    );
  }

  Widget _practicePage(AppState state, ShadowingPassage passage) {
    final sentence = passage.sentences[_sentenceIndex];
    final score = _score;
    return ListView(
      key: const ValueKey('shadowing-practice-page'),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
      children: [
        Row(
          children: [
            Text(state.displayText('第 ${_sentenceIndex + 1} / ${passage.sentences.length} 句'), style: const TextStyle(fontWeight: FontWeight.w900)),
            const Spacer(),
            Text(state.displayText('已练 $_attempts 次'), style: const TextStyle(color: Colors.black54, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(value: (_sentenceIndex + 1) / passage.sentences.length, minHeight: 5),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .55))),
          child: Column(
            children: [
              Text(state.displayText(sentence), textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, height: 1.55, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: OutlinedButton.icon(onPressed: () => unawaited(_playText()), icon: const Icon(Icons.volume_up_rounded), label: Text(state.displayText('听本句')))),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton.icon(onPressed: () => unawaited(_playText(wholePassage: true)), icon: const Icon(Icons.headphones_rounded), label: Text(state.displayText('听全文')))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 58,
          child: FilledButton.icon(
            key: const ValueKey('shadowing-record-button'),
            onPressed: _toggleListening,
            style: FilledButton.styleFrom(backgroundColor: _listening ? const Color(0xFFC53A32) : PhoenixTheme.red),
            icon: Icon(_listening ? Icons.stop_circle_rounded : Icons.mic_rounded, size: 27),
            label: Text(state.displayText(_listening ? '正在听你朗读 · 点击结束' : '点击开始跟读'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
          ),
        ),
        if (_speechMessage != null) ...[
          const SizedBox(height: 10),
          Text(state.displayText(_speechMessage!), textAlign: TextAlign.center, style: const TextStyle(color: PhoenixTheme.red, fontWeight: FontWeight.w800)),
        ],
        if (_recognized.isNotEmpty) ...[
          const SizedBox(height: 12),
          _ResultPanel(reference: sentence, recognized: _recognized, score: score, displayText: state.displayText),
        ],
        if (score != null) ...[
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _nextSentence, icon: const Icon(Icons.arrow_forward_rounded), label: Text(state.displayText(_sentenceIndex == passage.sentences.length - 1 ? '完成这篇短文' : '练习下一句'))),
        ],
      ],
    );
  }
}

class _TrainingDashboard extends StatelessWidget {
  const _TrainingDashboard({
    required this.history,
    required this.displayText,
  });

  final ShadowingTrainingHistory history;
  final String Function(String) displayText;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('shadowing-training-history'),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .42)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayText('训练记录'),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              _HistoryMetric(
                icon: Icons.local_fire_department_rounded,
                value: '${history.currentStreak}',
                label: displayText('连续天数'),
              ),
              _HistoryMetric(
                icon: Icons.check_circle_rounded,
                value: '${history.totalSessions}',
                label: displayText('完成篇数'),
              ),
              _HistoryMetric(
                icon: Icons.workspace_premium_rounded,
                value: '${history.bestRecentScore}',
                label: displayText('近期最佳'),
              ),
            ],
          ),
          if (history.recentSessions.isNotEmpty) ...[
            const Divider(height: 20),
            for (final session in history.recentSessions.take(3))
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      size: 15,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        displayText(session.title),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11.5),
                      ),
                    ),
                    Text(
                      displayText('${session.score} 分'),
                      style: const TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
          ] else
            Text(
              displayText('完成第一篇短文后，这里会保存你的练习轨迹。'),
              style: const TextStyle(color: Colors.black54, fontSize: 11),
            ),
        ],
      ),
    );
  }
}

class _HistoryMetric extends StatelessWidget {
  const _HistoryMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 19, color: PhoenixTheme.red),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 9.5),
          ),
        ],
      ),
    );
  }
}

class _PassageCard extends StatelessWidget {
  const _PassageCard({required this.passage, required this.bestScore, required this.displayText, required this.onTap});
  final ShadowingPassage passage;
  final int bestScore;
  final String Function(String) displayText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        key: ValueKey('shadowing-passage-${passage.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(radius: 25, backgroundColor: PhoenixTheme.red.withValues(alpha: .09), child: Text('Lv.${passage.level}', style: const TextStyle(color: PhoenixTheme.red, fontWeight: FontWeight.w900))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(displayText(passage.title), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(displayText('${passage.theme} · ${passage.sentences.length} 句 · 约 ${passage.estimatedMinutes} 分钟'), style: const TextStyle(color: Colors.black54, fontSize: 11)),
                if (bestScore > 0) Text(displayText('最佳成绩 $bestScore 分'), style: const TextStyle(color: PhoenixTheme.red, fontSize: 10.5, fontWeight: FontWeight.w900)),
              ])),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.reference, required this.recognized, required this.score, required this.displayText});
  final String reference;
  final String recognized;
  final ShadowingScore? score;
  final String Function(String) displayText;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('shadowing-result-panel'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFFFF4DF), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE8C788))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (score != null) Row(children: [
          CircleAvatar(backgroundColor: PhoenixTheme.red, foregroundColor: Colors.white, child: Text('${score!.overall}', style: const TextStyle(fontWeight: FontWeight.w900))),
          const SizedBox(width: 9),
          Expanded(child: Text(displayText('${score!.label} · 完整度 ${score!.completeness}%'), style: const TextStyle(fontWeight: FontWeight.w900))),
        ]),
        const SizedBox(height: 9),
        Text(displayText('识别结果'), style: const TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w900)),
        Text(displayText(recognized), style: const TextStyle(fontSize: 15, height: 1.4, fontWeight: FontWeight.w800)),
        const SizedBox(height: 7),
        Text(displayText('参考句'), style: const TextStyle(color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w900)),
        Text(displayText(reference), style: const TextStyle(fontSize: 13, height: 1.35)),
      ]),
    );
  }
}
