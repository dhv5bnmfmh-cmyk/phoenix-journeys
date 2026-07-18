import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../data/world_story_runtime.dart';
import '../models/story_content.dart';
import '../services/narration_controller.dart';
import '../services/phoenix_ai_service.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/forbidden_city_stamp.dart';
import '../widgets/interactive_story_text.dart';
import '../widgets/journey_progress_header.dart';
import '../widgets/narration_player_card.dart';
import '../widgets/phoenix_agent_cards.dart';
import '../widgets/word_detail_sheet.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with WidgetsBindingObserver {
  int step = 0;
  final wonderController = TextEditingController();
  final expressController = TextEditingController();
  final memoryController = TextEditingController();
  late final NarrationController _narration;
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
    _journeyContent = requireJourneyContent(
      worldStoryAgent,
      'beijing-forbidden-city',
    );
    _ai = PhoenixAiService();
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
    final safeStep = targetStep.clamp(0, AppState.beijingJourneyLastStep);
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

  Future<void> _playDiscoveries() {
    return _narration.play(
      contentId: 'discovery',
      items: discoveries
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
    );
  }

  Future<void> _openWord(WordEntry entry) async {
    final shouldResume = _narration.status == NarrationStatus.playing;
    if (shouldResume) {
      await _narration.pause();
    }
    final resumeOffset = _narration.currentOffset;
    if (!mounted) return;

    final initialIndex = words.indexWhere((item) => item.word == entry.word);
    await showWordDetail(
      context,
      entry,
      entries: words,
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

  Future<void> _askGuide() async {
    if (_guideLoading) return;

    setState(() => _guideLoading = true);
    final feedback = await _ai.askGuide(
      text: wonderController.text,
      language: _appState.translationLanguage,
    );
    if (!mounted) return;

    setState(() {
      _guideFeedback = feedback;
      _guideLoading = false;
    });
    await _showGuideFeedback();
  }

  Future<void> _reviewWriting() async {
    if (_writingLoading) return;

    setState(() => _writingLoading = true);
    final feedback = await _ai.reviewWriting(
      text: expressController.text,
      language: _appState.translationLanguage,
    );
    if (!mounted) return;

    setState(() {
      _writingFeedback = feedback;
      _writingLoading = false;
    });
    await _showWritingFeedback();
  }

  Future<void> _showGuideFeedback() async {
    final feedback = _guideFeedback;
    if (feedback == null || !mounted) return;
    await showModalBottomSheet<void>(
      context: context,
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
    await showModalBottomSheet<void>(
      context: context,
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
      builder: (_) => FractionallySizedBox(
        heightFactor: .72,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: _ReadingSupportSheet(
            title: title,
            pinyin: pinyin,
            nativeLabel: nativeLabel,
            nativeText: nativeText,
            english: english,
          ),
        ),
      ),
    );
  }

  void _onWonderChanged(String _) {
    if (_guideFeedback != null) {
      setState(() => _guideFeedback = null);
    }
    unawaited(_persistProgress());
  }

  void _onExpressChanged(String _) {
    if (_writingFeedback != null) {
      setState(() => _writingFeedback = null);
    }
    unawaited(_persistProgress());
  }

  Future<void> _finishJourney() async {
    await _narration.stop();
    await _appState.completeJourney(memoryController.text);
    if (!mounted) return;
    setState(() => step = AppState.beijingJourneyLastStep);
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

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: const Text(
          '北京 · 紫禁城',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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
    );
  }

  Widget _page({
    required String title,
    required Widget child,
    String buttonText = '继续',
    IconData buttonIcon = Icons.arrow_forward,
    VoidCallback? onNext,
    bool showBack = true,
  }) {
    final state = context.watch<AppState>();

    return LayoutBuilder(
      key: ValueKey(title),
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 590;
        return Padding(
          padding: EdgeInsets.fromLTRB(12, compact ? 4 : 6, 12, 8),
          child: Column(
            children: [
              JourneyProgressHeader(
                currentStep: step,
                furthestStep: state.beijingJourneyFurthestStep,
                labels: AppState.beijingJourneyStepLabels,
                onStepSelected: (value) => unawaited(_goToStep(value)),
              ),
              SizedBox(height: compact ? 3 : 5),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: compact ? 17 : 19,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: PhoenixTheme.gold.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      '单屏模式',
                      style: TextStyle(
                        color: PhoenixTheme.red,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: compact ? 4 : 6),
              Expanded(child: child),
              SizedBox(height: compact ? 4 : 7),
              SizedBox(
                height: compact ? 36 : 40,
                child: Row(
                  children: [
                    if (showBack &&
                        step > 0 &&
                        step < AppState.beijingJourneyLastStep) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => unawaited(_goToStep(step - 1)),
                          style: OutlinedButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          icon: const Icon(Icons.arrow_back_rounded, size: 17),
                          label: const Text(
                            '上一步',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                    ],
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed:
                            onNext ?? () => unawaited(_goToStep(step + 1)),
                        style: FilledButton.styleFrom(
                          backgroundColor: PhoenixTheme.red,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        icon: Icon(buttonIcon, size: 17),
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
      child: Column(
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: '紫禁城故事',
            subtitle: '普通话 · ${_journeyContent.storyParagraphs.length} 段',
            compact: true,
            onPlay: _playStory,
          ),
          const SizedBox(height: 3),
          _NowReadingStrip(
            controller: _narration,
            contentId: 'story',
            totalItems: _journeyContent.storyParagraphs.length,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: AnimatedBuilder(
              animation: _narration,
              builder: (context, _) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _journeyContent.storyParagraphs
                        .asMap()
                        .entries
                        .map((entry) {
                          final annotation = storyAnnotations[entry.key];
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
                                nativeLabel: annotation.nativeLabel(language),
                                nativeText: annotation.nativeText(
                                  language,
                                  entry.value,
                                ),
                                english: annotation.english,
                              ),
                            ),
                            child: InteractiveStoryText(
                              text: entry.value,
                              entries: words,
                              narrationController: _narration,
                              highlightStart: isActive ? snapshot!.start : null,
                              highlightEnd: isActive ? snapshot!.end : null,
                              narrationContentId: 'story',
                              narrationItemId: 'story-${entry.key}',
                              style: const TextStyle(
                                fontSize: 10.8,
                                height: 1.18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
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

    return _page(
      title: '生词',
      child: LayoutBuilder(
        builder: (context, constraints) {
          const columns = 3;
          const spacing = 4.0;
          final rows = (words.length / columns).ceil();
          final cellWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          final cellHeight =
              (constraints.maxHeight - spacing * (rows - 1)) / rows;
          final ratio = cellWidth / cellHeight.clamp(38.0, 70.0);

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: words.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              childAspectRatio: ratio,
            ),
            itemBuilder: (context, index) {
              final entry = words[index];
              return Material(
                color: Colors.white.withValues(alpha: .94),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => unawaited(_openWord(entry)),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: PhoenixTheme.gold.withValues(alpha: .25),
                      ),
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
                                  fontSize: 11,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
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
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 8,
                            height: 1,
                          ),
                        ),
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
            subtitle: '中文朗读 · ${discoveries.length} 段',
            compact: true,
            onPlay: _playDiscoveries,
          ),
          const SizedBox(height: 3),
          _NowReadingStrip(
            controller: _narration,
            contentId: 'discovery',
            totalItems: discoveries.length,
          ),
          const SizedBox(height: 3),
          Expanded(
            child: AnimatedBuilder(
              animation: _narration,
              builder: (context, _) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: discoveries
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
                              entries: words,
                              narrationController: _narration,
                              highlightStart: isActive ? snapshot!.start : null,
                              highlightEnd: isActive ? snapshot!.end : null,
                              narrationContentId: 'discovery',
                              narrationItemId: 'discovery-${entry.key}',
                              style: TextStyle(
                                fontSize: 9.9,
                                height: 1.12,
                                fontWeight: isActive
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _wonderPage() {
    return _page(
      title: '思考',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            wonderQuestion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const _InlineTip(
            icon: Icons.explore_outlined,
            text: 'PhoenixGuideAgent 会补充探索角度，并提出下一步问题。',
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: wonderController,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              onChanged: _onWonderChanged,
              decoration: const InputDecoration(
                hintText: '写下你的想法……',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const ValueKey('ask-phoenix-guide-agent'),
                  onPressed: _guideLoading
                      ? null
                      : () => unawaited(_askGuide()),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: _guideLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome, size: 17),
                  label: Text(
                    _guideLoading ? 'AI 正在回应…' : '问 PhoenixGuideAgent',
                    style: const TextStyle(fontSize: 10.5),
                  ),
                ),
              ),
              if (_guideFeedback != null) ...[
                const SizedBox(width: 6),
                IconButton.filledTonal(
                  tooltip: '查看 AI 回应',
                  onPressed: () => unawaited(_showGuideFeedback()),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.forum_rounded, size: 18),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _expressPage() {
    return _page(
      title: '表达',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            expressQuestion,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              height: 1.25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const _InlineTip(
            icon: Icons.edit_note_outlined,
            text: 'PhoenixWritingAgent 会保留原意，给出修改版和原因。',
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: expressController,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              onChanged: _onExpressChanged,
              decoration: const InputDecoration(
                hintText: '用中文写下你的表达……',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  key: const ValueKey('ask-phoenix-writing-agent'),
                  onPressed: _writingLoading
                      ? null
                      : () => unawaited(_reviewWriting()),
                  style: FilledButton.styleFrom(
                    backgroundColor: PhoenixTheme.red,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: _writingLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.spellcheck_rounded, size: 17),
                  label: Text(
                    _writingLoading ? 'AI 正在批改…' : '请 PhoenixWritingAgent 批改',
                    style: const TextStyle(fontSize: 10.5),
                  ),
                ),
              ),
              if (_writingFeedback != null) ...[
                const SizedBox(width: 6),
                IconButton.filledTonal(
                  tooltip: '查看批改结果',
                  onPressed: () => unawaited(_showWritingFeedback()),
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.fact_check_rounded, size: 18),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _memoryPage() {
    return _page(
      title: '旅程回忆',
      buttonText: '结束旅程',
      buttonIcon: Icons.flag_rounded,
      onNext: () => unawaited(_finishJourney()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '今天最想记住的一件事是什么？',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: TextField(
              controller: memoryController,
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (_) => unawaited(_persistProgress()),
              decoration: const InputDecoration(
                hintText: '写下感受，未来回来比较自己的变化。',
                contentPadding: EdgeInsets.all(11),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const _InlineTip(
            icon: Icons.approval_outlined,
            text: '结束后自动保存回忆，并由 PhoenixStampAgent 完成盖章。',
          ),
        ],
      ),
    );
  }

  Widget _completePage() {
    return _page(
      title: '北京已点亮',
      buttonText: '返回首页',
      buttonIcon: Icons.home_outlined,
      showBack: false,
      onNext: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: AnimatedForbiddenCityStamp(),
              ),
            ),
          ),
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
            height: 34,
            child: OutlinedButton.icon(
              onPressed: () => unawaited(_restartJourney()),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              icon: const Icon(Icons.replay_rounded, size: 16),
              label: const Text(
                '重新体验北京 Journey',
                style: TextStyle(fontSize: 10.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NowReadingStrip extends StatelessWidget {
  const _NowReadingStrip({
    required this.controller,
    required this.contentId,
    required this.totalItems,
  });

  final NarrationController controller;
  final String contentId;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final snapshot = controller.highlightSnapshot;
        final isCurrent = snapshot?.contentId == contentId;
        final status = controller.status;
        final isPlaying = isCurrent && status == NarrationStatus.playing;
        final isPaused = isCurrent && status == NarrationStatus.paused;
        final label = isPlaying
            ? '正在朗读'
            : isPaused
            ? '暂停在'
            : '朗读位置';
        final icon = isPlaying
            ? Icons.graphic_eq_rounded
            : isPaused
            ? Icons.pause_rounded
            : Icons.my_location_rounded;
        final itemNumber = isCurrent ? snapshot!.itemIndex + 1 : null;
        final word = isCurrent
            ? snapshot.itemText.substring(
                snapshot.start.clamp(0, snapshot.itemText.length),
                snapshot.end.clamp(0, snapshot.itemText.length),
              )
            : '';

        return AnimatedContainer(
          key: ValueKey('now-reading-$contentId'),
          duration: const Duration(milliseconds: 160),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isCurrent
                ? const Color(0xFFFFE39B)
                : Colors.white.withValues(alpha: .92),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isCurrent
                  ? PhoenixTheme.red
                  : PhoenixTheme.gold.withValues(alpha: .30),
              width: isCurrent ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isCurrent ? PhoenixTheme.red : Colors.black45,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: isCurrent ? PhoenixTheme.red : Colors.black54,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 6),
              if (isCurrent) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: PhoenixTheme.red,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    '第 $itemNumber/$totalItems 段',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '当前：$word',
                    key: ValueKey('now-reading-word-$contentId'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF65130F),
                      fontSize: 13,
                      height: 1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ] else
                const Expanded(
                  child: Text(
                    '按播放后，这里会显示当前段落和词语',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black45, fontSize: 9.5),
                  ),
                ),
            ],
          ),
        );
      },
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
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.fromLTRB(4, 2, 2, 2),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFFFFE7A8)
            : Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: active
              ? PhoenixTheme.red
              : PhoenixTheme.gold.withValues(alpha: .22),
          width: active ? 1.5 : 1,
        ),
        boxShadow: active
            ? const [
                BoxShadow(
                  color: Color(0x24781E18),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: CircleAvatar(
              radius: 9,
              backgroundColor: active
                  ? PhoenixTheme.red
                  : PhoenixTheme.gold.withValues(alpha: .18),
              child: active
                  ? const Icon(
                      Icons.graphic_eq_rounded,
                      size: 10,
                      color: Colors.white,
                    )
                  : Text(
                      '$index',
                      style: const TextStyle(
                        color: PhoenixTheme.red,
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
                  color: PhoenixTheme.red,
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
    required this.title,
    required this.pinyin,
    required this.nativeLabel,
    required this.nativeText,
    required this.english,
  });

  final String title;
  final String pinyin;
  final String nativeLabel;
  final String nativeText;
  final String english;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        _SupportLine(label: '拼音', text: pinyin, color: PhoenixTheme.red),
        const SizedBox(height: 8),
        _SupportLine(
          label: nativeLabel,
          text: nativeText,
          color: PhoenixTheme.translation,
        ),
        const SizedBox(height: 8),
        _SupportLine(label: 'English', text: english, color: PhoenixTheme.ai),
      ],
    );
  }
}

class _SupportLine extends StatelessWidget {
  const _SupportLine({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(fontSize: 12.5, height: 1.4)),
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
