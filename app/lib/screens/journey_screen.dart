import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_catalog.dart';
import '../data/journey_data.dart';
import '../data/world_story_runtime.dart';
import '../models/journey_background.dart';
import '../models/story_content.dart';
import '../services/narration_controller.dart';
import '../services/phoenix_ai_service.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/city_journey_stamp.dart';
import '../widgets/destination_background.dart';
import '../widgets/interactive_story_text.dart';
import '../widgets/journey_share_button.dart';
import '../widgets/journey_progress_header.dart';
import '../widgets/narration_player_card.dart';
import '../widgets/narration_speed_stepper.dart';
import '../widgets/phoenix_agent_cards.dart';
import '../widgets/word_detail_sheet.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key, this.journeyId});

  final String? journeyId;

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with WidgetsBindingObserver {
  int step = 0;
  final wonderController = TextEditingController();
  final expressController = TextEditingController();
  final memoryController = TextEditingController();
  final wonderFocusNode = FocusNode(debugLabel: 'wonder-writing');
  final expressFocusNode = FocusNode(debugLabel: 'express-writing');
  final memoryFocusNode = FocusNode(debugLabel: 'memory-writing');
  late final NarrationController _narration;
  late final DailyJourneyExperience _experience;
  late final JourneyContentRecord _journeyContent;
  late final PhoenixAiService _ai;
  late AppState _appState;
  PhoenixGuideFeedback? _guideFeedback;
  PhoenixWritingFeedback? _writingFeedback;
  bool _guideLoading = false;
  bool _writingLoading = false;
  bool _initialized = false;
  bool _discoveryAutoStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _narration = NarrationController();
    final worldStoryAgent = createPhoenixWorldStoryAgent();
    final journeyId =
        widget.journeyId ?? dailyJourneyForDate(DateTime.now()).id;
    _experience = requireDailyJourneyExperience(journeyId);
    _journeyContent = requireJourneyContent(worldStoryAgent, _experience.id);
    _ai = PhoenixAiService();
    wonderFocusNode.addListener(_handleWritingFocusChanged);
    expressFocusNode.addListener(_handleWritingFocusChanged);
    memoryFocusNode.addListener(_handleWritingFocusChanged);
  }

  void _handleWritingFocusChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    _appState = context.read<AppState>();
    step = _appState.beijingJourneyStep;
    wonderController.text = _appState.wonderDraft;
    expressController.text = _appState.expressDraft;
    memoryController.text = _appState.memoryDraft;
    if (_appState.hasGuideFeedback) {
      _guideFeedback = PhoenixGuideFeedback(
        reply: _appState.guideFeedbackReply,
        isOfflineFallback: _appState.guideFeedbackOffline,
      );
    }
    if (_appState.hasWritingFeedback) {
      _writingFeedback = PhoenixWritingFeedback(
        corrected: _appState.writingFeedbackCorrected,
        explanation: _appState.writingFeedbackExplanation,
        natural: _appState.writingFeedbackNatural,
        encouragement: _appState.writingFeedbackEncouragement,
        isOfflineFallback: _appState.writingFeedbackOffline,
      );
    }
    _initialized = true;

    if (step == 2) _scheduleDiscoveryAutoStart();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) return;
    unawaited(_narration.stop());
    if (_initialized) unawaited(_persistProgress());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_initialized) unawaited(_persistProgress());
    _narration.dispose();
    _ai.close();
    wonderController.dispose();
    expressController.dispose();
    memoryController.dispose();
    wonderFocusNode.removeListener(_handleWritingFocusChanged);
    expressFocusNode.removeListener(_handleWritingFocusChanged);
    memoryFocusNode.removeListener(_handleWritingFocusChanged);
    wonderFocusNode.dispose();
    expressFocusNode.dispose();
    memoryFocusNode.dispose();
    super.dispose();
  }

  Future<void> _persistProgress({int? overrideStep}) {
    return _appState.saveJourneyProgress(
      step: overrideStep ?? step,
      wonder: wonderController.text,
      express: expressController.text,
      memory: memoryController.text,
    );
  }

  Future<void> _goToStep(int targetStep) async {
    final safeStep = targetStep.clamp(0, AppState.journeyLastStep);
    if (!_appState.journeyCompleted &&
        safeStep != step &&
        safeStep != step - 1 &&
        safeStep != step + 1) {
      return;
    }
    // Discovery autoplay must enter the browser speech API in the same user
    // gesture that pressed Continue. Awaiting storage/animation first can make
    // iOS display "playing" while silently blocking the actual utterance.
    if (safeStep == 2 && safeStep != step) {
      setState(() => step = safeStep);
      _discoveryAutoStarted = true;
      unawaited(_playDiscoveries(stopEngineFirst: false));
      await _persistProgress(overrideStep: safeStep);
      return;
    }

    await _narration.stop();
    if (!mounted || safeStep == step) return;

    if (step == 2 && safeStep != 2) {
      _discoveryAutoStarted = false;
    }

    setState(() => step = safeStep);
    await _persistProgress(overrideStep: safeStep);

    if (safeStep == 2) _scheduleDiscoveryAutoStart();
  }

  void _scheduleDiscoveryAutoStart() {
    if (_discoveryAutoStarted) return;
    _discoveryAutoStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && step == 2) unawaited(_playDiscoveries());
    });
  }

  Future<void> _playStory() {
    return _narration.play(
      contentId: 'story',
      languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      items: _journeyContent.storyParagraphs
          .asMap()
          .entries
          .map(
            (entry) => NarrationItem(
              id: 'story-${entry.key}',
              text: entry.value,
              label: '故事第 ${entry.key + 1} 段',
            ),
          )
          .toList(growable: false),
    );
  }

  Future<void> _playDiscoveries({bool stopEngineFirst = true}) {
    return _narration.play(
      contentId: 'discovery',
      languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      items: _experience.discoveries
          .asMap()
          .entries
          .map(
            (entry) => NarrationItem(
              id: 'discovery-${entry.key}',
              text: entry.value.text,
              label: '今日发现 ${entry.key + 1}',
            ),
          )
          .toList(growable: false),
      stopEngineFirst: stopEngineFirst,
    );
  }

  Future<void> _openWord(WordEntry entry) async {
    final shouldResume = _narration.status == NarrationStatus.playing;
    if (shouldResume) {
      await _narration.pause();
    }
    final resumeOffset = _narration.currentOffset;
    if (!mounted) return;

    final initialIndex = _experience.words.indexWhere(
      (item) => item.word == entry.word,
    );
    await showWordDetail(
      context,
      entry,
      narrationController: _narration,
      entries: _experience.words,
      initialIndex: initialIndex < 0 ? 0 : initialIndex,
      onSpeak: () => _narration.speakWord(
        _appState.displayText(entry.word),
        languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      ),
      onSpeakEntry: (currentEntry) => _narration.speakWord(
        _appState.displayText(currentEntry.word),
        languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      ),
    );
    if (!mounted || !shouldResume) return;

    // Wait until the sheet animation and iOS audio channel have fully closed.
    await Future<void>.delayed(const Duration(milliseconds: 360));
    if (!mounted) return;
    await _narration.resumeFromOffset(resumeOffset);
  }

  Future<void> _enterVocabularyAtFirstWord() async {
    await _goToStep(1);
    if (!mounted || step != 1 || _experience.words.isEmpty) return;

    await WidgetsBinding.instance.endOfFrame;
    if (!mounted || step != 1) return;

    await _openWord(_experience.words.first);
  }

  Future<void> _prepareAgentAction(FocusNode focusNode, String message) async {
    focusNode.unfocus();
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          duration: const Duration(seconds: 20),
          behavior: SnackBarBehavior.floating,
        ),
      );

    await Future<void>.delayed(const Duration(milliseconds: 180));
  }

  void _clearAgentStatus() {
    if (mounted) ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Map<String, dynamic> get _aiLearnerProfile {
    final guideObservations = <String>[
      wonderController.text.trim(),
      _appState.guideFeedbackReply.trim(),
      ..._appState.memories.take(6),
    ].where((value) => value.isNotEmpty).toList(growable: false);
    final writingInsights = <String>[
      _appState.writingFeedbackExplanation.trim(),
      _appState.writingFeedbackNatural.trim(),
      expressController.text.trim(),
    ].where((value) => value.isNotEmpty).toList(growable: false);

    return <String, dynamic>{
      'interfaceLanguage': _appState.translationLanguage,
      'scriptMode': _appState.isTraditional ? 'traditional' : 'simplified',
      'currentLevel': '根据学习者本次中文动态判断',
      'savedWords': _appState.savedWords.toList(growable: false),
      'completedJourneys': _appState.earnedJourneyStampIds.toList(
        growable: false,
      ),
      'recentGuideObservations': guideObservations,
      'recentWritingInsights': writingInsights,
    };
  }

  void _showAgentMessage(String message) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Future<void> _askGuide() async {
    if (_guideLoading) return;
    final answer = wonderController.text.trim();
    if (answer.length < 2) {
      _showAgentMessage('请先写下一点想法。');
      return;
    }

    setState(() => _guideLoading = true);
    await _prepareAgentAction(wonderFocusNode, 'PhoenixGuideAgent 正在思考…');
    if (!mounted) return;

    try {
      final feedback = await _ai.askGuide(
        text: answer,
        language: _appState.translationLanguage,
        journeyId: _experience.id,
        learnerProfile: _aiLearnerProfile,
      );
      await _appState.saveGuideFeedback(
        reply: feedback.reply,
        isOfflineFallback: feedback.isOfflineFallback,
      );
      if (!mounted) return;

      _clearAgentStatus();
      setState(() {
        _guideFeedback = feedback;
        _guideLoading = false;
      });
      await _showGuideFeedback();
    } catch (_) {
      if (!mounted) return;
      _clearAgentStatus();
      _showAgentMessage('PhoenixGuideAgent 暂时没有回应，请再试一次。');
    } finally {
      if (mounted && _guideLoading) {
        setState(() => _guideLoading = false);
      }
    }
  }

  Future<void> _reviewWriting() async {
    if (_writingLoading) return;
    final writing = expressController.text.trim();
    if (writing.length < 2) {
      _showAgentMessage('请先写下至少两个字。');
      return;
    }

    setState(() => _writingLoading = true);
    await _prepareAgentAction(expressFocusNode, 'PhoenixWritingAgent 正在批改…');
    if (!mounted) return;

    try {
      final feedback = await _ai.reviewWriting(
        text: writing,
        language: _appState.translationLanguage,
        journeyId: _experience.id,
        learnerProfile: _aiLearnerProfile,
      );
      await _appState.saveWritingFeedback(
        corrected: feedback.corrected,
        explanation: feedback.explanation,
        natural: feedback.natural,
        encouragement: feedback.encouragement,
        isOfflineFallback: feedback.isOfflineFallback,
      );
      if (!mounted) return;

      _clearAgentStatus();
      setState(() {
        _writingFeedback = feedback;
        _writingLoading = false;
      });
      await _showWritingFeedback();
    } catch (_) {
      if (!mounted) return;
      _clearAgentStatus();
      _showAgentMessage('PhoenixWritingAgent 暂时无法批改，请再试一次。');
    } finally {
      if (mounted && _writingLoading) {
        setState(() => _writingLoading = false);
      }
    }
  }

  Future<void> _showGuideFeedback() async {
    final feedback = _guideFeedback;
    if (feedback == null || !mounted) return;
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .78,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
          child: PhoenixGuideReplyCard(feedback: feedback),
        ),
      ),
    );
  }

  Future<void> _showWritingFeedback() async {
    final feedback = _writingFeedback;
    if (feedback == null || !mounted) return;
    await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: .82,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 20),
          child: PhoenixWritingFeedbackCard(feedback: feedback),
        ),
      ),
    );
  }

  String get _nativeSupportLanguageCode {
    return switch (_appState.translationLanguage) {
      '英语' => 'en-US',
      '中文解释' => _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      _ => 'vi-VN',
    };
  }

  Future<void> _speakSupportText(
    String text, {
    required String languageCode,
  }) async {
    final spoken = await _narration.speakTemporaryText(
      text,
      languageCode: languageCode,
    );
    if (!spoken && mounted) {
      _showAgentMessage('当前设备暂时无法朗读这段文字。');
    }
  }

  Future<void> _showReadingSupport({
    required String title,
    required String pinyin,
    required String nativeLabel,
    required String nativeText,
    required String english,
  }) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * .52;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: _ReadingSupportSheet(
              controller: _narration,
              title: title,
              pinyin: pinyin,
              nativeLabel: nativeLabel,
              nativeText: nativeText,
              english: english,
              onSpeakNative: () => _speakSupportText(
                nativeText,
                languageCode: _nativeSupportLanguageCode,
              ),
              onSpeakEnglish: () =>
                  _speakSupportText(english, languageCode: 'en-US'),
            ),
          ),
        );
      },
    );
  }

  double _fitJourneyTextSize(
    BuildContext context,
    BoxConstraints constraints,
    List<String> texts, {
    required double minSize,
    required double maxSize,
    required double lineHeight,
  }) {
    if (texts.isEmpty || !constraints.hasBoundedHeight) return minSize;

    final availableWidth = (constraints.maxWidth - 58)
        .clamp(120.0, constraints.maxWidth)
        .toDouble();
    final availableHeight = math.max(0.0, constraints.maxHeight - 8);
    final textScaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    var low = minSize;
    var high = maxSize;

    for (var iteration = 0; iteration < 10; iteration += 1) {
      final candidate = (low + high) / 2;
      var totalHeight = 0.0;
      for (final text in texts) {
        final painter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: candidate,
              height: lineHeight,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: direction,
          textScaler: textScaler,
        )..layout(maxWidth: availableWidth);
        totalHeight += math.max(18, painter.height) + 12;
      }

      if (totalHeight <= availableHeight) {
        low = candidate;
      } else {
        high = candidate;
      }
    }
    return low;
  }

  void _onWonderChanged(String _) {
    if (_guideFeedback != null) {
      setState(() => _guideFeedback = null);
      unawaited(_appState.clearGuideFeedback());
    }
    unawaited(_persistProgress());
  }

  void _onExpressChanged(String _) {
    if (_writingFeedback != null) {
      setState(() => _writingFeedback = null);
      unawaited(_appState.clearWritingFeedback());
    }
    unawaited(_persistProgress());
  }

  Future<void> _finishJourney() async {
    await _narration.stop();
    await _appState.completeJourney(memoryController.text);
    if (!mounted) return;
    setState(() => step = AppState.journeyLastStep);
  }

  Future<void> _restartJourney() async {
    await _appState.restartJourney();
    wonderController.clear();
    expressController.clear();
    memoryController.clear();
    _guideFeedback = null;
    _writingFeedback = null;
    _guideLoading = false;
    _writingLoading = false;
    _discoveryAutoStarted = false;
    if (mounted) setState(() => step = 0);
  }

  JourneyBackgroundPage get _backgroundPageType => switch (step) {
    0 => JourneyBackgroundPage.story,
    1 => JourneyBackgroundPage.vocabulary,
    2 => JourneyBackgroundPage.discovery,
    3 => JourneyBackgroundPage.reflection,
    4 => JourneyBackgroundPage.writing,
    5 => JourneyBackgroundPage.memory,
    _ => JourneyBackgroundPage.completion,
  };

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _storyPage(),
      _wordsPage(),
      _discoveryPage(),
      _wonderPage(),
      _expressPage(),
      _memoryPage(),
      _completePage(),
    ];

    return DestinationBackground(
      journeyId: _experience.id,
      pageType: _backgroundPageType,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 44,
          title: Text(
            _appState.displayText(_experience.appBarTitle),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          actions: [
            Consumer<AppState>(
              builder: (_, state, __) => TextButton(
                onPressed: state.toggleScript,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(
                  state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',
                  style: const TextStyle(fontSize: 10.5),
                ),
              ),
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: pages[step],
        ),
      ),
    );
  }

  Widget _page({
    required String title,
    required Widget child,
    String buttonText = '继续',
    IconData buttonIcon = Icons.arrow_forward,
    VoidCallback? onNext,
    bool showBack = true,
    bool keyboardAdaptive = false,
    FocusNode? keyboardFocusNode,
    bool primaryLoading = false,
    bool primaryEnabled = true,
    String? secondaryButtonText,
    IconData secondaryButtonIcon = Icons.auto_awesome_outlined,
    VoidCallback? onSecondary,
  }) {
    final state = context.watch<AppState>();

    return LayoutBuilder(
      key: ValueKey(title),
      builder: (context, constraints) {
        final keyboardVisible =
            keyboardAdaptive &&
            (keyboardFocusNode?.hasFocus ??
                MediaQuery.viewInsetsOf(context).bottom > 0);
        final compact = constraints.maxHeight < 590 || keyboardVisible;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            12,
            keyboardVisible ? 2 : (compact ? 4 : 6),
            12,
            keyboardVisible ? 3 : 8,
          ),
          child: Column(
            children: [
              if (!keyboardVisible) ...[
                JourneyProgressHeader(
                  currentStep: step,
                  furthestStep: state.beijingJourneyFurthestStep,
                  isCompleted: state.journeyCompleted,
                  labels: AppState.journeyStepLabels,
                  onStepSelected: (value) => unawaited(_goToStep(value)),
                ),
                SizedBox(height: compact ? 3 : 5),
              ],
              SizedBox(
                height: keyboardVisible ? 26 : null,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: PhoenixTheme.journeyTitleStyle.copyWith(
                          fontSize: keyboardVisible ? 15 : (compact ? 17 : 19),
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    if (keyboardVisible)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: PhoenixTheme.gold.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Text(
                          '输入中',
                          style: TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: keyboardVisible ? 3 : (compact ? 4 : 6)),
              Expanded(child: child),
              if (!keyboardVisible) ...[
                SizedBox(height: compact ? 4 : 7),
                SizedBox(
                  height: compact ? 36 : 40,
                  child: Row(
                    children: [
                      if (showBack &&
                          step > 0 &&
                          step < AppState.journeyLastStep) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => unawaited(_goToStep(step - 1)),
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              size: 17,
                            ),
                            label: const Text(
                              '上一步',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                      ],
                      if (secondaryButtonText != null &&
                          onSecondary != null) ...[
                        Expanded(
                          child: OutlinedButton.icon(
                            key: ValueKey('journey-secondary-$title'),
                            onPressed: onSecondary,
                            style: OutlinedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                            ),
                            icon: Icon(secondaryButtonIcon, size: 15),
                            label: Text(
                              secondaryButtonText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                      ],

                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: primaryEnabled && !primaryLoading
                              ? onNext ?? () => unawaited(_goToStep(step + 1))
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: PhoenixTheme.red,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          icon: primaryLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(buttonIcon, size: 17),
                          label: Text(
                            buttonText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _storyPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;

    return _page(
      title: '故事',
      onNext: () => unawaited(_enterVocabularyAtFirstWord()),
      child: Column(
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: _appState.displayText(_experience.storyTitle),
            subtitle: '普通话 · ${_journeyContent.storyParagraphs.length} 段',
            compact: true,
            onPlay: _playStory,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: LayoutBuilder(
              key: const ValueKey('adaptive-story-text-area'),
              builder: (context, constraints) {
                final fontSize = _fitJourneyTextSize(
                  context,
                  constraints,
                  _journeyContent.storyParagraphs,
                  minSize: 10.8,
                  maxSize: 16,
                  lineHeight: 1.22,
                );
                return AnimatedBuilder(
                  animation: _narration,
                  builder: (context, _) {
                    return SingleChildScrollView(
                      key: const ValueKey('story-auto-visibility-scroll'),
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _journeyContent.storyParagraphs
                            .asMap()
                            .entries
                            .map((entry) {
                              final annotation =
                                  _experience.storyAnnotations[entry.key];
                              final snapshot = _narration.highlightSnapshot;
                              final isActive =
                                  snapshot?.contentId == 'story' &&
                                  snapshot?.itemId == 'story-${entry.key}';
                              return _CompactTextBlock(
                                index: entry.key + 1,
                                active: isActive,
                                onSupport: () => unawaited(
                                  _showReadingSupport(
                                    title: '故事第 ${entry.key + 1} 段',
                                    pinyin: annotation.pinyin,
                                    nativeLabel: annotation.nativeLabel(
                                      language,
                                    ),
                                    nativeText: annotation.nativeText(
                                      language,
                                      entry.value,
                                    ),
                                    english: annotation.english,
                                  ),
                                ),
                                child: InteractiveStoryText(
                                  text: entry.value,
                                  entries: _experience.words,
                                  narrationController: _narration,
                                  highlightStart: isActive
                                      ? snapshot!.start
                                      : null,
                                  highlightEnd: isActive ? snapshot!.end : null,
                                  narrationContentId: 'story',
                                  narrationItemId: 'story-${entry.key}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSize,
                                    height: 1.22,
                                    fontFamily: PhoenixTheme.chineseFontFamily,
                                    fontFamilyFallback:
                                        PhoenixTheme.chineseFontFallback,
                                    fontWeight: FontWeight.w700,
                                    shadows: const [
                                      Shadow(
                                        color: Color(0xE6000000),
                                        blurRadius: 3,
                                        offset: Offset(0, 1),
                                      ),
                                      Shadow(
                                        color: Color(0x99000000),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                            .toList(growable: false),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _wordsPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;

    return _page(
      title: '单词',
      child: LayoutBuilder(
        builder: (context, constraints) {
          const columns = 3;
          const spacing = 4.0;
          final rows = (_experience.words.length / columns).ceil();
          final cellWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          final cellHeight =
              (constraints.maxHeight - spacing * (rows - 1)) / rows;
          final safeCellHeight = math.max(1.0, cellHeight);
          final ratio = cellWidth / safeCellHeight;
          final showPartOfSpeech = cellHeight >= 52;
          final showNativeMeaning = cellHeight >= 72;
          final showEnglishMeaning = cellHeight >= 96 && language != '英语';
          final showChineseMeaning = cellHeight >= 122 && language != '中文解释';
          final nativeLabel = switch (language) {
            '英语' => 'English',
            '中文解释' => '中文',
            _ => '母语',
          };

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: _experience.words.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: ratio,
            ),
            itemBuilder: (context, index) {
              final entry = _experience.words[index];
              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => unawaited(_openWord(entry)),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                state.displayText(entry.word),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 1,
                                  fontFamily: PhoenixTheme.chineseFontFamily,
                                  fontFamilyFallback:
                                      PhoenixTheme.chineseFontFallback,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 4),
                                  ],
                                ),
                              ),
                            ),
                            if (state.isWordSaved(entry.word)) ...[
                              const SizedBox(width: 2),
                              const Icon(
                                Icons.bookmark_rounded,
                                size: 11,
                                color: PhoenixTheme.red,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.pinyin,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: cellHeight >= 120 ? 10 : 8,
                            height: 1,
                            fontFamily: PhoenixTheme.chineseFontFamily,
                            fontFamilyFallback:
                                PhoenixTheme.chineseFontFallback,
                            shadows: const [
                              Shadow(color: Colors.black, blurRadius: 4),
                            ],
                          ),
                        ),
                        if (showPartOfSpeech) ...[
                          const SizedBox(height: 7),
                          Text(
                            state.displayText(entry.partOfSpeech),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontFamily: PhoenixTheme.chineseFontFamily,
                              fontFamilyFallback:
                                  PhoenixTheme.chineseFontFallback,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                        if (showNativeMeaning) ...[
                          const SizedBox(height: 4),
                          Text(
                            '$nativeLabel · ${state.displayText(entry.nativeDefinition(language))}',
                            maxLines: cellHeight >= 112 ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.6,
                              height: 1.15,
                              fontFamily: PhoenixTheme.chineseFontFamily,
                              fontFamilyFallback:
                                  PhoenixTheme.chineseFontFallback,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                        if (showEnglishMeaning) ...[
                          const SizedBox(height: 3),
                          Text(
                            'EN · ${entry.englishDefinition}',
                            maxLines: cellHeight >= 126 ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.4,
                              height: 1.15,
                              fontFamily: PhoenixTheme.chineseFontFamily,
                              fontFamilyFallback:
                                  PhoenixTheme.chineseFontFallback,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                        if (showChineseMeaning) ...[
                          const SizedBox(height: 3),
                          Text(
                            state.displayText('中 · ${entry.simpleChinese}'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.4,
                              height: 1.15,
                              fontFamily: PhoenixTheme.chineseFontFamily,
                              fontFamilyFallback:
                                  PhoenixTheme.chineseFontFallback,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _discoveryPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;

    return _page(
      title: '发现',
      child: Column(
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'discovery',
            title: 'Discovery',
            subtitle: '中文朗读 · ${_experience.discoveries.length} 段',
            compact: true,
            onPlay: _playDiscoveries,
          ),
          const SizedBox(height: 3),
          Expanded(
            child: LayoutBuilder(
              key: const ValueKey('adaptive-discovery-text-area'),
              builder: (context, constraints) {
                final discoveryTexts = _experience.discoveries
                    .map((item) => item.text)
                    .toList(growable: false);
                final fontSize = _fitJourneyTextSize(
                  context,
                  constraints,
                  discoveryTexts,
                  minSize: 9.9,
                  maxSize: 15,
                  lineHeight: 1.28,
                );
                return AnimatedBuilder(
                  animation: _narration,
                  builder: (context, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _experience.discoveries
                          .asMap()
                          .entries
                          .map((entry) {
                            final item = entry.value;
                            final snapshot = _narration.highlightSnapshot;
                            final isActive =
                                snapshot?.contentId == 'discovery' &&
                                snapshot?.itemId == 'discovery-${entry.key}';
                            return _CompactTextBlock(
                              index: entry.key + 1,
                              active: isActive,
                              onSupport: () => unawaited(
                                _showReadingSupport(
                                  title: '今日发现 ${entry.key + 1}',
                                  pinyin: item.pinyin,
                                  nativeLabel: item.nativeLabel(language),
                                  nativeText: item.nativeText(language),
                                  english: item.english,
                                ),
                              ),
                              child: InteractiveStoryText(
                                text: item.text,
                                entries: _experience.words,
                                narrationController: _narration,
                                highlightStart: isActive
                                    ? snapshot!.start
                                    : null,
                                highlightEnd: isActive ? snapshot!.end : null,
                                narrationContentId: 'discovery',
                                narrationItemId: 'discovery-${entry.key}',
                                style: PhoenixTheme.journeyBodyStyle.copyWith(
                                  fontSize: fontSize,
                                  fontWeight: isActive
                                      ? FontWeight.w900
                                      : FontWeight.w700,
                                ),
                              ),
                            );
                          })
                          .toList(growable: false),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _wonderPage() {
    final keyboardVisible = wonderFocusNode.hasFocus;
    final hasFeedback = _guideFeedback != null;
    return _page(
      title: '思考',
      keyboardAdaptive: true,
      keyboardFocusNode: wonderFocusNode,
      buttonText: hasFeedback
          ? '继续'
          : (_guideLoading ? 'AI 正在回应…' : '问 PhoenixGuideAgent'),
      buttonIcon: hasFeedback ? Icons.arrow_forward : Icons.auto_awesome,
      primaryLoading: _guideLoading,
      primaryEnabled: !_guideLoading,
      onNext: hasFeedback ? null : () => unawaited(_askGuide()),
      secondaryButtonText: hasFeedback ? 'AI 回答' : null,
      secondaryButtonIcon: Icons.forum_outlined,
      onSecondary: hasFeedback ? () => unawaited(_showGuideFeedback()) : null,
      child: _JourneyWritingSurface(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _experience.wonderQuestion,
            maxLines: keyboardVisible ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: PhoenixTheme.journeyWritingQuestionStyle.copyWith(
              fontSize: keyboardVisible ? 11 : 12,
            ),
          ),
          SizedBox(height: keyboardVisible ? 3 : 5),
          if (!keyboardVisible) ...[
            const _InlineTip(
              icon: Icons.explore_outlined,
              text: 'PhoenixGuideAgent 会补充探索角度，并提出下一步问题。',
            ),
            const SizedBox(height: 6),
          ],
          Expanded(
            child: TextField(
              key: const ValueKey('wonder-writing-field'),
              controller: wonderController,
              focusNode: wonderFocusNode,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.only(bottom: 24),
              onChanged: _onWonderChanged,
              style: PhoenixTheme.journeyWritingInputStyle,
              cursorColor: PhoenixTheme.contentAccent,
              decoration: PhoenixTheme.journeyWritingInputDecoration(
                '写下你的想法……',
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _expressPage() {
    final keyboardVisible = expressFocusNode.hasFocus;
    final hasFeedback = _writingFeedback != null;
    return _page(
      title: '表达',
      keyboardAdaptive: true,
      keyboardFocusNode: expressFocusNode,
      buttonText: hasFeedback
          ? '继续'
          : (_writingLoading ? 'AI 正在批改…' : '请 PhoenixWritingAgent 批改'),
      buttonIcon: hasFeedback ? Icons.arrow_forward : Icons.spellcheck_rounded,
      primaryLoading: _writingLoading,
      primaryEnabled: !_writingLoading,
      onNext: hasFeedback ? null : () => unawaited(_reviewWriting()),
      secondaryButtonText: hasFeedback ? 'AI 批改' : null,
      secondaryButtonIcon: Icons.fact_check_outlined,
      onSecondary: hasFeedback ? () => unawaited(_showWritingFeedback()) : null,
      child: _JourneyWritingSurface(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _experience.expressQuestion,
            maxLines: keyboardVisible ? 1 : 2,
            overflow: TextOverflow.ellipsis,
            style: PhoenixTheme.journeyWritingQuestionStyle.copyWith(
              fontSize: keyboardVisible ? 11 : 12,
            ),
          ),
          SizedBox(height: keyboardVisible ? 3 : 5),
          if (!keyboardVisible) ...[
            const _InlineTip(
              icon: Icons.edit_note_outlined,
              text: 'PhoenixWritingAgent 会保留原意，给出修改版和原因。',
            ),
            const SizedBox(height: 6),
          ],
          Expanded(
            child: TextField(
              key: const ValueKey('express-writing-field'),
              controller: expressController,
              focusNode: expressFocusNode,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.only(bottom: 24),
              onChanged: _onExpressChanged,
              style: PhoenixTheme.journeyWritingInputStyle,
              cursorColor: PhoenixTheme.contentAccent,
              decoration: PhoenixTheme.journeyWritingInputDecoration(
                '用中文写下你的表达……',
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _memoryPage() {
    final keyboardVisible = memoryFocusNode.hasFocus;
    return _page(
      title: '旅程回忆',
      keyboardAdaptive: true,
      keyboardFocusNode: memoryFocusNode,
      buttonText: '结束旅程',
      buttonIcon: Icons.flag_rounded,
      onNext: () => unawaited(_finishJourney()),
      child: _JourneyWritingSurface(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '今天最想记住的一件事是什么？',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: PhoenixTheme.journeyWritingQuestionStyle.copyWith(
              fontSize: keyboardVisible ? 11 : 12.5,
            ),
          ),
          SizedBox(height: keyboardVisible ? 3 : 6),
          Expanded(
            child: TextField(
              key: const ValueKey('memory-writing-field'),
              controller: memoryController,
              focusNode: memoryFocusNode,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              scrollPadding: const EdgeInsets.only(bottom: 24),
              onChanged: (_) => unawaited(_persistProgress()),
              style: PhoenixTheme.journeyWritingInputStyle,
              cursorColor: PhoenixTheme.contentAccent,
              decoration: PhoenixTheme.journeyWritingInputDecoration(
                '写下感受，未来回来比较自己的变化。',
              ),
            ),
          ),
          if (!keyboardVisible) ...[
            const SizedBox(height: 6),
            const _InlineTip(
              icon: Icons.approval_outlined,
              text: '结束后自动保存回忆，并由 PhoenixStampAgent 完成盖章。',
            ),
          ],
        ],
        ),
      ),
    );
  }

  Widget _completePage() {
    return _page(
      title: '${_experience.city}已点亮',
      buttonText: '返回首页',
      buttonIcon: Icons.home_outlined,
      showBack: false,
      onNext: () => Navigator.of(context).pop(),
      child: Stack(
        children: [
          Align(
            key: const ValueKey('completion-background-stamp'),
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, right: 2),
              child: FittedBox(
                fit: BoxFit.contain,
                child: AnimatedCityJourneyStamp(
                  journey: _experience,
                  size: 104,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '盖章成功',
                  style: TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  '你完成的不是一堂课，而是一段旅程。',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 12, height: 1.25),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 36,
                  child: Row(
                    children: [
                      Expanded(
                        child: JourneyShareButton(
                          isTraditional: _appState.isTraditional,
                          city: _experience.city,
                          place: _experience.place,
                          compact: true,
                          label: _appState.displayText('分享旅程'),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => unawaited(_restartJourney()),
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          icon: const Icon(Icons.replay_rounded, size: 16),
                          label: const Text(
                            '重新体验',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyWritingSurface extends StatelessWidget {
  const _JourneyWritingSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: PhoenixTheme.journeyWritingPanelDecoration,
      child: child,
    );
  }
}

class _CompactTextBlock extends StatelessWidget {
  const _CompactTextBlock({
    required this.index,
    required this.active,
    required this.child,
    required this.onSupport,
  });

  final int index;
  final bool active;
  final Widget child;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('compact-text-$index-${active ? 'active' : 'idle'}'),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
      decoration: PhoenixTheme.journeyPanelDecoration.copyWith(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: CircleAvatar(
              radius: 9,
              backgroundColor: const Color(0x99000000),
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Color(0xFFFFD879),
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(child: child),
          SizedBox(
            width: 23,
            height: 23,
            child: TextButton(
              onPressed: onSupport,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(23, 23),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text(
                '注',
                style: TextStyle(
                  color: Color(0xFFFFD879),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingSupportSheet extends StatelessWidget {
  const _ReadingSupportSheet({
    required this.controller,
    required this.title,
    required this.pinyin,
    required this.nativeLabel,
    required this.nativeText,
    required this.english,
    required this.onSpeakNative,
    required this.onSpeakEnglish,
  });

  final NarrationController controller;
  final String title;
  final String pinyin;
  final String nativeLabel;
  final String nativeText;
  final String english;
  final Future<void> Function() onSpeakNative;
  final Future<void> Function() onSpeakEnglish;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            NarrationSpeedStepper(
              key: const ValueKey('support-speed-control'),
              controller: controller,
              compact: true,
            ),
          ],
        ),
        const SizedBox(height: 6),
        _SupportLine(label: '拼音', text: pinyin, color: PhoenixTheme.red),
        const SizedBox(height: 5),
        _SupportLine(
          key: const ValueKey('support-native-audio'),
          label: nativeLabel,
          text: nativeText,
          color: PhoenixTheme.translation,
          onSpeak: onSpeakNative,
        ),
        const SizedBox(height: 5),
        _SupportLine(
          key: const ValueKey('support-english-audio'),
          label: 'English',
          text: english,
          color: PhoenixTheme.ai,
          onSpeak: onSpeakEnglish,
        ),
      ],
    );
  }
}

class _SupportLine extends StatelessWidget {
  const _SupportLine({
    required this.label,
    required this.text,
    required this.color,
    this.onSpeak,
    super.key,
  });

  final String label;
  final String text;
  final Color color;
  final Future<void> Function()? onSpeak;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 5, 5, 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (onSpeak != null)
                IconButton(
                  tooltip: '朗读 $label',
                  onPressed: () => unawaited(onSpeak!()),
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints.tightFor(
                    width: 30,
                    height: 30,
                  ),
                  icon: Icon(Icons.volume_up_rounded, size: 18, color: color),
                ),
            ],
          ),
          const SizedBox(height: 1),
          Text(text, style: const TextStyle(fontSize: 11.5, height: 1.28)),
        ],
      ),
    );
  }
}

class _InlineTip extends StatefulWidget {
  const _InlineTip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  State<_InlineTip> createState() => _InlineTipState();
}

class _InlineTipState extends State<_InlineTip> {
  bool _visible = false;

  void _show() {
    if (!_visible) setState(() => _visible = true);
  }

  void _hide() {
    if (_visible) setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '按住提示查看：${widget.text}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            key: ValueKey('press-hint-${widget.text.hashCode}'),
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _show(),
            onTapUp: (_) => _hide(),
            onTapCancel: _hide,
            onLongPressStart: (_) => _show(),
            onLongPressEnd: (_) => _hide(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: PhoenixTheme.red.withValues(alpha: .07),
                borderRadius: BorderRadius.circular(99),
                border: Border.all(
                  color: PhoenixTheme.red.withValues(alpha: .18),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tips_and_updates_outlined,
                    size: 14,
                    color: PhoenixTheme.red,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '提示',
                    style: TextStyle(
                      color: PhoenixTheme.red,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            child: _visible
                ? Container(
                    key: const ValueKey('press-hint-content'),
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: PhoenixTheme.red.withValues(alpha: .06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
