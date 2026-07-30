import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../data/shadowing_passage_catalog.dart';
import '../generated/phoenix_shadowing_training_background.dart';
import '../services/narration_controller.dart';
import '../services/phoenix_level_controller.dart';
import '../services/shadowing_score.dart';
import '../services/shadowing_training_history.dart';
import '../services/shadowing_weakness_library.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/journey_level_selector_button.dart';

class ShadowingTrainingScreen extends StatefulWidget {
  const ShadowingTrainingScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<ShadowingTrainingScreen> createState() =>
      _ShadowingTrainingScreenState();
}

class _ShadowingTrainingScreenState extends State<ShadowingTrainingScreen> {
  final SpeechToText _speech = SpeechToText();
  final NarrationController _narration = NarrationController();
  final Map<String, int> _bestScores = <String, int>{};
  final Map<int, int> _sessionSentenceScores = <int, int>{};
  final List<int> _reviewQueue = <int>[];

  ShadowingTrainingHistory _history = const ShadowingTrainingHistory();
  ShadowingWeaknessLibrary _weaknessLibrary = const ShadowingWeaknessLibrary();
  ShadowingPassage? _passage;
  int _sentenceIndex = 0;
  int _reviewPosition = 0;
  int _attempts = 0;
  bool _loading = true;
  bool _speechReady = false;
  bool _listening = false;
  double _practiceRate = 1;
  String _recognized = '';
  ShadowingScore? _score;
  String? _speechMessage;

  @override
  void initState() {
    super.initState();
    PhoenixLevelController.instance.addListener(_handleLevelChange);
    unawaited(_initialize());
  }

  void _handleLevelChange() {
    if (!mounted) return;
    setState(() {});
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
    _weaknessLibrary = ShadowingWeaknessLibrary.decode(
      prefs.getString('phoenix.shadowing.weaknesses'),
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
    PhoenixLevelController.instance.removeListener(_handleLevelChange);
    unawaited(_speech.cancel());
    _narration.dispose();
    super.dispose();
  }

  String t(String value) => context.read<AppState>().displayText(value);

  void _openPassage(
    ShadowingPassage passage, {
    int startSentenceIndex = 0,
    String? message,
  }) {
    final safeIndex = startSentenceIndex < 0
        ? 0
        : startSentenceIndex >= passage.sentences.length
        ? passage.sentences.length - 1
        : startSentenceIndex;
    setState(() {
      _passage = passage;
      _sentenceIndex = safeIndex;
      _reviewPosition = 0;
      _attempts = 0;
      _reviewQueue.clear();
      _sessionSentenceScores.clear();
      _recognized = '';
      _score = null;
      _speechMessage = message;
    });
  }

  void _closePassage() {
    unawaited(_speech.cancel());
    unawaited(_narration.stop());
    setState(() {
      _passage = null;
      _reviewPosition = 0;
      _reviewQueue.clear();
      _listening = false;
      _recognized = '';
      _score = null;
      _speechMessage = null;
    });
  }

  Future<void> _playText({bool wholePassage = false}) async {
    final passage = _passage;
    if (passage == null) return;
    final text = wholePassage
        ? passage.text
        : passage.sentences[_sentenceIndex];
    await _narration.play(
      contentId:
          'shadowing-${passage.id}-${wholePassage ? 'all' : _sentenceIndex}',
      items: [NarrationItem(id: 'prompt', text: text, label: passage.title)],
      languageCode: context.read<AppState>().isTraditional ? 'zh-TW' : 'zh-CN',
    );
  }

  Future<void> _setPracticeRate(double rate) async {
    await _narration.setSpeechRate(rate);
    if (!mounted) return;
    setState(() => _practiceRate = _narration.speechRate);
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

    final localeId = context.read<AppState>().isTraditional ? 'zh_TW' : 'zh_CN';
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
    final sentence = passage.sentences[_sentenceIndex];
    final score = scoreShadowing(
      reference: sentence,
      recognized: _recognized,
      recognitionConfidence: confidence,
    );
    final attempts = _attempts + 1;
    final weaknessLibrary = _weaknessLibrary.recordAttempt(
      passageId: passage.id,
      passageTitle: passage.title,
      sentenceIndex: _sentenceIndex,
      sentence: sentence,
      recognized: _recognized,
      score: score,
      practicedAt: DateTime.now(),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'phoenix.shadowing.weaknesses',
      weaknessLibrary.encode(),
    );
    if (!mounted) return;
    setState(() {
      _attempts = attempts;
      _score = score;
      _weaknessLibrary = weaknessLibrary;
      final previous = _sessionSentenceScores[_sentenceIndex] ?? 0;
      if (score.overall > previous) {
        _sessionSentenceScores[_sentenceIndex] = score.overall;
      }
      _speechMessage = null;
    });
  }

  void _retryCurrentWeakness(ShadowingScore score) {
    unawaited(_speech.cancel());
    setState(() {
      _listening = false;
      _recognized = '';
      _score = null;
      _speechMessage = '已定位${score.weakestMetric}弱项，先听示范，再跟读一次。';
    });
    unawaited(_playText());
  }

  void _practiceWeakness(ShadowingWeaknessItem item) {
    ShadowingPassage? passage;
    for (final candidate in shadowingPassages) {
      if (candidate.id == item.passageId) {
        passage = candidate;
        break;
      }
    }
    if (passage == null) return;
    _openPassage(
      passage,
      startSentenceIndex: item.sentenceIndex,
      message: '来自个人弱项复练库 · 重点修正${item.weakestMetric}',
    );
  }

  Future<void> _showWeaknessLibrary() async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFF8E9),
      showDragHandle: true,
      builder: (sheetContext) => _WeaknessLibrarySheet(
        library: _weaknessLibrary,
        displayText: context.read<AppState>().displayText,
        onPractice: (item) {
          Navigator.of(sheetContext).pop();
          _practiceWeakness(item);
        },
      ),
    );
  }

  void _nextSentence() {
    final passage = _passage;
    if (passage == null) return;

    if (_reviewQueue.isNotEmpty) {
      if (_reviewPosition >= _reviewQueue.length - 1) {
        unawaited(_showReviewCompletion());
        return;
      }
      setState(() {
        _reviewPosition += 1;
        _sentenceIndex = _reviewQueue[_reviewPosition];
        _attempts = 0;
        _recognized = '';
        _score = null;
        _speechMessage = null;
      });
      return;
    }

    if (_sentenceIndex >= passage.sentences.length - 1) {
      unawaited(_showCompletion());
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

  List<int> _weakSentenceIndexes(ShadowingPassage passage) {
    return List<int>.generate(passage.sentences.length, (index) => index)
        .where((index) => (_sessionSentenceScores[index] ?? 0) < 75)
        .toList(growable: false);
  }

  void _startWeakReview(List<int> sentenceIndexes) {
    if (sentenceIndexes.isEmpty) return;
    setState(() {
      _reviewQueue
        ..clear()
        ..addAll(sentenceIndexes);
      _reviewPosition = 0;
      _sentenceIndex = _reviewQueue.first;
      _attempts = 0;
      _recognized = '';
      _score = null;
      _speechMessage = null;
    });
  }

  Future<int> _savePassageBest(ShadowingPassage passage) async {
    final completedScore = averageShadowingSessionScore(
      sentenceScores: _sessionSentenceScores.values,
      sentenceCount: passage.sentences.length,
    );
    if (completedScore > (_bestScores[passage.id] ?? 0)) {
      _bestScores[passage.id] = completedScore;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'phoenix.shadowing.best.${passage.id}',
        completedScore,
      );
    }
    return completedScore;
  }

  Future<void> _showCompletion() async {
    final passage = _passage;
    if (passage == null || !mounted) return;
    final completedScore = await _savePassageBest(passage);
    final weakSentences = _weakSentenceIndexes(passage);
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
            const Icon(
              Icons.verified_rounded,
              color: PhoenixTheme.red,
              size: 54,
            ),
            const SizedBox(height: 8),
            Text(
              t('短文跟读完成'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              t('已完成《${passage.title}》的全部 ${passage.sentences.length} 句。'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              t('本篇平均 $completedScore 分'),
              style: const TextStyle(
                color: PhoenixTheme.red,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            if (weakSentences.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const ValueKey('shadowing-review-weak-sentences'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _startWeakReview(weakSentences);
                  },
                  icon: const Icon(Icons.replay_rounded),
                  label: Text(t('重练 ${weakSentences.length} 个薄弱句')),
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
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

  Future<void> _showReviewCompletion() async {
    final passage = _passage;
    if (passage == null || !mounted) return;
    final completedScore = await _savePassageBest(passage);
    final weakSentences = _weakSentenceIndexes(passage);
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.trending_up_rounded,
              color: PhoenixTheme.red,
              size: 54,
            ),
            const SizedBox(height: 8),
            Text(
              t('薄弱句复练完成'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              t('更新后的本篇平均分：$completedScore 分'),
              style: const TextStyle(
                color: PhoenixTheme.red,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            if (weakSentences.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _startWeakReview(weakSentences);
                  },
                  icon: const Icon(Icons.replay_rounded),
                  label: Text(t('再练 ${weakSentences.length} 个薄弱句')),
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _closePassage();
                },
                child: Text(t('完成复练')),
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
        title: Text(
          state.displayText(_passage == null ? '跟读训练' : _passage!.title),
        ),
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
      body: Stack(
        children: [
          const Positioned.fill(child: _ShadowingBackground()),
          SafeArea(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _passage == null
                ? _passageLibrary(state)
                : _practicePage(state, _passage!),
          ),
        ],
      ),
    );
  }

  Widget _passageLibrary(AppState state) {
    final level = PhoenixLevelController.instance.level;
    final passages = shadowingPassagesForLevel(level);
    return ListView(
      key: ValueKey('shadowing-passage-library-level-$level'),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
      children: [
        Container(
          key: const ValueKey('shadowing-premium-hero'),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.record_voice_over_rounded,
                  color: Color(0xFFFFD879),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.displayText('跟读训练'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        shadows: PhoenixTheme.contentShadow,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.displayText('听一句 · 跟一句 · 三维诊断 · 薄弱句复练'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        shadows: PhoenixTheme.contentShadow,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE3A0),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  'Lv.$level',
                  key: ValueKey('shadowing-active-level-$level'),
                  style: const TextStyle(
                    color: Color(0xFF7A201B),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _TrainingDashboard(history: _history, displayText: state.displayText),
        const SizedBox(height: 7),
        _WeaknessLibraryCard(
          library: _weaknessLibrary,
          displayText: state.displayText,
          onTap: () => unawaited(_showWeaknessLibrary()),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Text(
              state.displayText('适合当前等级'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .82),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: PhoenixTheme.gold.withValues(alpha: .42),
                ),
              ),
              child: Text(
                state.displayText('${passages.length} 篇短文'),
                style: const TextStyle(
                  color: PhoenixTheme.red,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Column(
            key: ValueKey('shadowing-level-passages-$level'),
            children: [
              for (final passage in passages) ...[
                _PassageCard(
                  passage: passage,
                  bestScore: _bestScores[passage.id] ?? 0,
                  displayText: state.displayText,
                  onTap: () => _openPassage(passage),
                ),
                const SizedBox(height: 6),
              ],
            ],
          ),
        ),
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
            Text(
              state.displayText(
                _reviewQueue.isEmpty
                    ? '第 ${_sentenceIndex + 1} / ${passage.sentences.length} 句'
                    : '薄弱句复练 ${_reviewPosition + 1} / ${_reviewQueue.length}',
              ),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const Spacer(),
            Text(
              state.displayText('已练 $_attempts 次'),
              style: const TextStyle(color: Colors.black54, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: _reviewQueue.isEmpty
              ? (_sentenceIndex + 1) / passage.sentences.length
              : (_reviewPosition + 1) / _reviewQueue.length,
          minHeight: 5,
        ),
        const SizedBox(height: 9),
        Row(
          key: const ValueKey('shadowing-sentence-score-strip'),
          children: [
            for (var index = 0; index < passage.sentences.length; index += 1)
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index == passage.sentences.length - 1 ? 0 : 5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: index == _sentenceIndex
                        ? PhoenixTheme.red
                        : _sessionSentenceScores.containsKey(index)
                        ? const Color(0xFFFFE4AD)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: PhoenixTheme.red.withValues(alpha: .22),
                    ),
                  ),
                  child: Text(
                    _sessionSentenceScores[index]?.toString() ?? '${index + 1}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: index == _sentenceIndex
                          ? Colors.white
                          : const Color(0xFF4A3026),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .30),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .24)),
          ),
          child: Column(
            children: [
              Text(
                state.displayText(sentence),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  height: 1.55,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => unawaited(_playText()),
                      style: _shadowingListenButtonStyle(),
                      icon: const Icon(Icons.volume_up_rounded),
                      label: Text(state.displayText('听本句')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => unawaited(_playText(wholePassage: true)),
                      style: _shadowingListenButtonStyle(),
                      icon: const Icon(Icons.headphones_rounded),
                      label: Text(state.displayText('听全文')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                key: const ValueKey('shadowing-speed-control'),
                children: [
                  Text(
                    state.displayText('示范语速'),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  for (final option in const [
                    ('慢速', .7),
                    ('清晰', .9),
                    ('原速', 1.0),
                  ]) ...[
                    ChoiceChip(
                      label: Text(
                        state.displayText('${option.$1} ${option.$2}×'),
                      ),
                      selected: (_practiceRate - option.$2).abs() < .01,
                      onSelected: (_) => unawaited(_setPracticeRate(option.$2)),
                      visualDensity: VisualDensity.compact,
                    ),
                    if (option.$2 != 1.0) const SizedBox(width: 5),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _listening
                  ? const [Color(0xFFD84A3C), Color(0xFF8D1E1B)]
                  : const [
                      Color(0xFFC13B30),
                      Color(0xFF8B1D1B),
                      Color(0xFFB9862F),
                    ],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFFFD879).withValues(alpha: .78),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D7A201B),
                blurRadius: 17,
                offset: Offset(0, 8),
              ),
              BoxShadow(color: Color(0x33FFD879), blurRadius: 7),
            ],
          ),
          child: FilledButton.icon(
            key: const ValueKey('shadowing-record-button'),
            onPressed: _toggleListening,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            icon: Icon(
              _listening ? Icons.stop_circle_rounded : Icons.mic_rounded,
              size: 28,
            ),
            label: Text(
              state.displayText(
                _listening ? '正在听你朗读 · 点击结束' : '开始跟读 · 让声音带你前进',
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
        ),
        if (_speechMessage != null) ...[
          const SizedBox(height: 10),
          Text(
            state.displayText(_speechMessage!),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: PhoenixTheme.red,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
        if (_recognized.isNotEmpty) ...[
          const SizedBox(height: 12),
          _ResultPanel(
            reference: sentence,
            recognized: _recognized,
            score: score,
            displayText: state.displayText,
            onRetry: score == null ? null : () => _retryCurrentWeakness(score),
          ),
        ],
        if (score != null) ...[
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _nextSentence,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(
              state.displayText(
                _reviewQueue.isNotEmpty
                    ? _reviewPosition == _reviewQueue.length - 1
                          ? '完成薄弱句复练'
                          : '复练下一句'
                    : _sentenceIndex == passage.sentences.length - 1
                    ? '完成这篇短文'
                    : '练习下一句',
              ),
            ),
          ),
        ],
      ],
    );
  }
}

ButtonStyle _shadowingListenButtonStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: PhoenixTheme.red,
    backgroundColor: Colors.white.withValues(alpha: .88),
    side: BorderSide(color: PhoenixTheme.gold.withValues(alpha: .68)),
    elevation: 3,
    shadowColor: const Color(0x29000000),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );
}

class _ShadowingBackground extends StatelessWidget {
  const _ShadowingBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(
          phoenixShadowingTrainingBackgroundBytes,
          key: const ValueKey('phoenix-shadowing-original-background'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          filterQuality: FilterQuality.high,
          gaplessPlayback: true,
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00FFF5DE), Color(0x10FFF7E8), Color(0x2CFFF7E8)],
              stops: [0, .48, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _TrainingDashboard extends StatelessWidget {
  const _TrainingDashboard({required this.history, required this.displayText});

  final ShadowingTrainingHistory history;
  final String Function(String) displayText;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('shadowing-training-history'),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          _HistoryMetric(
            icon: Icons.local_fire_department_rounded,
            value: '${history.currentStreak}',
            label: displayText('连续天数'),
          ),
          Container(
            width: 1,
            height: 30,
            color: PhoenixTheme.gold.withValues(alpha: .28),
          ),
          _HistoryMetric(
            icon: Icons.check_circle_rounded,
            value: '${history.totalSessions}',
            label: displayText('完成篇数'),
          ),
          Container(
            width: 1,
            height: 30,
            color: PhoenixTheme.gold.withValues(alpha: .28),
          ),
          _HistoryMetric(
            icon: Icons.workspace_premium_rounded,
            value: '${history.bestRecentScore}',
            label: displayText('近期最佳'),
          ),
        ],
      ),
    );
  }
}

class _WeaknessLibraryCard extends StatelessWidget {
  const _WeaknessLibraryCard({
    required this.library,
    required this.displayText,
    required this.onTap,
  });

  final ShadowingWeaknessLibrary library;
  final String Function(String) displayText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final todayCount = library.dailyQueue().length;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('shadowing-weakness-library-entry'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0D1).withValues(alpha: .72),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .46)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PhoenixTheme.red.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.psychology_alt_rounded,
                  color: PhoenixTheme.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayText('个人弱项复练库'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      displayText(
                        library.pendingCount == 0
                            ? '当前没有待复练句子 · 已掌握 ${library.masteredCount}'
                            : '今日推荐 $todayCount 句 · 已掌握 ${library.masteredCount}',
                      ),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: library.pendingCount == 0
                      ? const Color(0xFFE2E8D7)
                      : const Color(0xFFFFD8C7),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  displayText('待练 ${library.pendingCount}'),
                  style: TextStyle(
                    color: library.pendingCount == 0
                        ? const Color(0xFF47603E)
                        : PhoenixTheme.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: PhoenixTheme.red,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeaknessLibrarySheet extends StatelessWidget {
  const _WeaknessLibrarySheet({
    required this.library,
    required this.displayText,
    required this.onPractice,
  });

  final ShadowingWeaknessLibrary library;
  final String Function(String) displayText;
  final ValueChanged<ShadowingWeaknessItem> onPractice;

  @override
  Widget build(BuildContext context) {
    final queue = library.dailyQueue(limit: 20);
    final metrics = library.pendingMetricCounts;
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: .74,
        minChildSize: .46,
        maxChildSize: .92,
        builder: (context, controller) => ListView(
          key: const ValueKey('shadowing-weakness-library-sheet'),
          controller: controller,
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          children: [
            Row(
              children: [
                const Icon(
                  Icons.psychology_alt_rounded,
                  color: PhoenixTheme.red,
                  size: 30,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayText('个人弱项复练库'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        displayText('自动积累薄弱句，连续两次稳定达标后标记掌握'),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                _WeaknessSummaryChip(
                  label: displayText('待练 ${library.pendingCount}'),
                ),
                _WeaknessSummaryChip(
                  label: displayText('准确度 ${metrics['准确度'] ?? 0}'),
                ),
                _WeaknessSummaryChip(
                  label: displayText('完整度 ${metrics['完整度'] ?? 0}'),
                ),
                _WeaknessSummaryChip(
                  label: displayText('流利度 ${metrics['流利度'] ?? 0}'),
                ),
                _WeaknessSummaryChip(
                  label: displayText('已掌握 ${library.masteredCount}'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (queue.isEmpty)
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .72),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: PhoenixTheme.gold.withValues(alpha: .30),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF5E7A50),
                      size: 44,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      displayText('今天没有待复练的薄弱句'),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              )
            else ...[
              Text(
                displayText('今日优先复练'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              for (final item in queue) ...[
                _WeaknessItemCard(
                  item: item,
                  displayText: displayText,
                  onPractice: () => onPractice(item),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _WeaknessSummaryChip extends StatelessWidget {
  const _WeaknessSummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .30)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6F4A3B),
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _WeaknessItemCard extends StatelessWidget {
  const _WeaknessItemCard({
    required this.item,
    required this.displayText,
    required this.onPractice,
  });

  final ShadowingWeaknessItem item;
  final String Function(String) displayText;
  final VoidCallback onPractice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .82),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  displayText(item.passageTitle),
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                displayText('最近 ${item.lastScore} · 最佳 ${item.bestScore}'),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            displayText(item.sentence),
            style: const TextStyle(
              fontSize: 15,
              height: 1.42,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _IssueChip(
                icon: Icons.track_changes_rounded,
                label: displayText('重点 ${item.weakestMetric}'),
                active: true,
              ),
              _IssueChip(
                icon: Icons.fact_check_outlined,
                label: displayText(item.issueSummary),
                active: item.issueCount > 0,
              ),
            ],
          ),
          if (item.focusCharacters.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              displayText('重点文字：${item.focusCharacters}'),
              style: const TextStyle(
                color: PhoenixTheme.red,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
          const SizedBox(height: 9),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              key: ValueKey('shadowing-practice-weakness-${item.id}'),
              onPressed: onPractice,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(displayText('开始复练这一句')),
            ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 15,
            color: const Color(0xFFFFD879),
            shadows: PhoenixTheme.contentShadow,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              shadows: PhoenixTheme.contentShadow,
            ),
          ),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                shadows: PhoenixTheme.contentShadow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PassageCard extends StatelessWidget {
  const _PassageCard({
    required this.passage,
    required this.bestScore,
    required this.displayText,
    required this.onTap,
  });

  final ShadowingPassage passage;
  final int bestScore;
  final String Function(String) displayText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: .30),
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: ValueKey('shadowing-passage-${passage.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .20)),
          ),
          child: Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB83931), Color(0xFF7E1C1B)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Lv.${passage.level}',
                  style: const TextStyle(
                    color: Color(0xFFFFDF8A),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayText(passage.title),
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayText(
                        '${passage.theme} · ${passage.sentences.length} 句 · 约 ${passage.estimatedMinutes} 分钟',
                      ),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                    if (bestScore > 0) ...[
                      const SizedBox(height: 5),
                      Text(
                        displayText('最佳成绩 $bestScore 分'),
                        style: const TextStyle(
                          color: PhoenixTheme.red,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 27,
                height: 27,
                decoration: BoxDecoration(
                  color: PhoenixTheme.red.withValues(alpha: .08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: PhoenixTheme.red,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.reference,
    required this.recognized,
    required this.score,
    required this.displayText,
    required this.onRetry,
  });

  final String reference;
  final String recognized;
  final ShadowingScore? score;
  final String Function(String) displayText;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final feedback = score == null
        ? const <ShadowingReferenceUnit>[]
        : buildShadowingReferenceFeedback(
            reference: reference,
            recognized: recognized,
          );

    return Container(
      key: const ValueKey('shadowing-result-panel'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DF).withValues(alpha: .56),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8C788)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (score != null) ...[
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: PhoenixTheme.red,
                  foregroundColor: Colors.white,
                  child: Text(
                    '${score!.overall}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayText(score!.label),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayText('当前重点：${score!.weakestMetric}'),
                        key: const ValueKey('shadowing-primary-weakness'),
                        style: const TextStyle(
                          color: PhoenixTheme.red,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              key: const ValueKey('shadowing-diagnostic-metrics'),
              children: [
                Expanded(
                  child: _DiagnosticMetric(
                    key: const ValueKey('shadowing-metric-accuracy'),
                    label: displayText('准确度'),
                    value: score!.accuracy,
                    highlighted: score!.weakestMetric == '准确度',
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _DiagnosticMetric(
                    key: const ValueKey('shadowing-metric-completeness'),
                    label: displayText('完整度'),
                    value: score!.completeness,
                    highlighted: score!.weakestMetric == '完整度',
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: _DiagnosticMetric(
                    key: const ValueKey('shadowing-metric-fluency'),
                    label: displayText('流利度'),
                    value: score!.fluency,
                    highlighted: score!.weakestMetric == '流利度',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              key: const ValueKey('shadowing-issue-counts'),
              spacing: 6,
              runSpacing: 6,
              children: [
                _IssueChip(
                  icon: Icons.remove_circle_outline_rounded,
                  label: displayText('漏读 ${score!.omittedCharacters}'),
                  active: score!.omittedCharacters > 0,
                ),
                _IssueChip(
                  icon: Icons.change_circle_outlined,
                  label: displayText('错读 ${score!.wrongCharacters}'),
                  active: score!.wrongCharacters > 0,
                ),
                _IssueChip(
                  icon: Icons.add_circle_outline_rounded,
                  label: displayText('多读 ${score!.extraCharacters}'),
                  active: score!.extraCharacters > 0,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Text(
            displayText('识别结果'),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            displayText(recognized),
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            displayText('逐字对照'),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (feedback.isEmpty)
            Text(
              displayText(reference),
              style: const TextStyle(fontSize: 13, height: 1.35),
            )
          else
            Text.rich(
              key: const ValueKey('shadowing-character-feedback'),
              TextSpan(
                children: [
                  for (final unit in feedback)
                    TextSpan(
                      text: displayText(unit.text),
                      style: TextStyle(
                        color: unit.matched
                            ? const Color(0xFF254A32)
                            : PhoenixTheme.red,
                        backgroundColor: unit.matched
                            ? Colors.transparent
                            : const Color(0xFFFFD8CF),
                        fontWeight: unit.matched
                            ? FontWeight.w700
                            : FontWeight.w900,
                      ),
                    ),
                ],
              ),
              style: const TextStyle(fontSize: 16, height: 1.55),
            ),
          if (score != null) ...[
            const SizedBox(height: 9),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .38),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: PhoenixTheme.gold.withValues(alpha: .28),
                ),
              ),
              child: Text(
                displayText(score!.coaching),
                key: const ValueKey('shadowing-coaching'),
                style: const TextStyle(
                  color: Color(0xFF6F4A3B),
                  fontSize: 11.5,
                  height: 1.4,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                key: const ValueKey('shadowing-retry-weakness'),
                onPressed: onRetry,
                icon: const Icon(Icons.replay_circle_filled_rounded),
                label: Text(displayText('针对${score!.weakestMetric}再练一次')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PhoenixTheme.red,
                  backgroundColor: Colors.white.withValues(alpha: .68),
                  side: BorderSide(
                    color: PhoenixTheme.gold.withValues(alpha: .72),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DiagnosticMetric extends StatelessWidget {
  const _DiagnosticMetric({
    super.key,
    required this.label,
    required this.value,
    required this.highlighted,
  });

  final String label;
  final int value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
      decoration: BoxDecoration(
        color: highlighted
            ? const Color(0xFFFFE0C8)
            : Colors.white.withValues(alpha: .54),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted
              ? PhoenixTheme.red.withValues(alpha: .46)
              : PhoenixTheme.gold.withValues(alpha: .24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: highlighted
                        ? PhoenixTheme.red
                        : const Color(0xFF6F4A3B),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                '$value%',
                style: TextStyle(
                  color: highlighted
                      ? PhoenixTheme.red
                      : const Color(0xFF3E4A38),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: value.clamp(0, 100) / 100,
              minHeight: 5,
              backgroundColor: const Color(0xFFEADCC8),
              valueColor: AlwaysStoppedAnimation<Color>(
                highlighted ? PhoenixTheme.red : const Color(0xFF6F8B65),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueChip extends StatelessWidget {
  const _IssueChip({
    required this.icon,
    required this.label,
    required this.active,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFFDDD3)
            : Colors.white.withValues(alpha: .42),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: active
              ? PhoenixTheme.red.withValues(alpha: .38)
              : PhoenixTheme.gold.withValues(alpha: .20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: active ? PhoenixTheme.red : Colors.black38,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: active ? PhoenixTheme.red : Colors.black54,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
