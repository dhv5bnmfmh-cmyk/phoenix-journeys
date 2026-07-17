import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../services/narration_controller.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/annotated_reading_card.dart';
import '../widgets/forbidden_city_stamp.dart';
import '../widgets/interactive_story_text.dart';
import '../widgets/journey_progress_header.dart';
import '../widgets/narration_player_card.dart';
import '../widgets/word_detail_sheet.dart';
import '../widgets/word_mark.dart';

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
  late AppState _appState;
  String aiReply = '';
  bool _initialized = false;
  bool _discoveryAutoStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _narration = NarrationController();
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
      items: storyParagraphs
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
    await _narration.stop();
    if (!mounted) return;
    await showWordDetail(context, entry);
  }

  bool _isNarrating(String contentId, int itemIndex) {
    final isActive = _narration.status == NarrationStatus.playing ||
        _narration.status == NarrationStatus.paused;
    return isActive &&
        _narration.contentId == contentId &&
        _narration.currentItemIndex == itemIndex;
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
    aiReply = '';
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
        title: const Text('北京 · 紫禁城'),
        actions: [
          Consumer<AppState>(
            builder: (_, state, __) => TextButton(
              onPressed: state.toggleScript,
              child: Text(
                state.scriptMode == ScriptMode.simplified ? '简 / 繁' : '繁 / 简',
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

    return ListView(
      key: ValueKey(title),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: [
        JourneyProgressHeader(
          currentStep: step,
          furthestStep: state.beijingJourneyFurthestStep,
          labels: AppState.beijingJourneyStepLabels,
          onStepSelected: (value) => unawaited(_goToStep(value)),
        ),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 26),
        Row(
          children: [
            if (showBack &&
                step > 0 &&
                step < AppState.beijingJourneyLastStep) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => unawaited(_goToStep(step - 1)),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('上一步'),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: onNext ?? () => unawaited(_goToStep(step + 1)),
                icon: Icon(buttonIcon),
                label: Text(buttonText),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _storyPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;

    return _page(
      title: '故事',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: '紫禁城故事',
            subtitle: '普通话 · ${storyParagraphs.length} 段',
            onPlay: _playStory,
          ),
          const SizedBox(height: 8),
          const _InlineTip(
            icon: Icons.touch_app_outlined,
            text: '长按红色词语查词；点每段右侧的小“注”查看拼音、母语与英文',
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: _narration,
            builder: (context, _) {
              return Column(
                children: storyParagraphs.asMap().entries.map((entry) {
                  final annotation = storyAnnotations[entry.key];
                  final isActive = _isNarrating('story', entry.key);

                  return AnnotatedReadingCard(
                    id: 'story-${entry.key}',
                    isActive: isActive,
                    pinyin: annotation.pinyin,
                    nativeLabel: annotation.nativeLabel(language),
                    nativeText: annotation.nativeText(language, entry.value),
                    english: annotation.english,
                    leading: isActive
                        ? const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.graphic_eq,
                              size: 18,
                              color: PhoenixTheme.red,
                            ),
                          )
                        : null,
                    mainText: InteractiveStoryText(
                      text: entry.value,
                      entries: words,
                      onWordLongPress: (word) {
                        unawaited(_openWord(word));
                      },
                    ),
                  );
                }).toList(growable: false),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            '本页重点词语',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words
                .where(
                  (entry) => storyParagraphs.any(
                    (paragraph) => paragraph.contains(entry.word),
                  ),
                )
                .take(8)
                .map(
                  (entry) => ActionChip(
                    avatar: WordMark(word: entry.word, size: 24),
                    label: Text('${entry.word} · ${entry.pinyin}'),
                    onPressed: () => unawaited(_openWord(entry)),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _wordsPage() {
    final state = context.watch<AppState>();

    return _page(
      title: '生词',
      child: Column(
        children: words
            .map(
              (entry) => Card(
                margin: const EdgeInsets.only(bottom: 9),
                child: ListTile(
                  onTap: () => unawaited(_openWord(entry)),
                  onLongPress: () => unawaited(_openWord(entry)),
                  leading: WordMark(word: entry.word, size: 48),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.word,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: PhoenixTheme.gold.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          entry.partOfSpeech,
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(entry.pinyin),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.isWordSaved(entry.word))
                        const Icon(
                          Icons.bookmark,
                          size: 19,
                          color: PhoenixTheme.red,
                        ),
                      const SizedBox(width: 3),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _discoveryPage() {
    final state = context.watch<AppState>();
    final language = state.translationLanguage;

    return _page(
      title: '发现',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'discovery',
            title: 'Discovery',
            subtitle: '中文朗读 · ${discoveries.length} 段',
            onPlay: _playDiscoveries,
          ),
          const SizedBox(height: 8),
          const _InlineTip(
            icon: Icons.notes_rounded,
            text: '每段右侧点“注”展开拼音、探索者母语和 English；播放器可暂停、停止、重播和调速',
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _narration,
            builder: (context, _) {
              return Column(
                children: discoveries.asMap().entries.map((entry) {
                  final item = entry.value;
                  final isActive = _isNarrating('discovery', entry.key);

                  return AnnotatedReadingCard(
                    id: 'discovery-${entry.key}',
                    elevated: true,
                    isActive: isActive,
                    padding: const EdgeInsets.all(14),
                    pinyin: item.pinyin,
                    nativeLabel: item.nativeLabel(language),
                    nativeText: item.nativeText(language),
                    english: item.english,
                    leading: CircleAvatar(
                      radius: 17,
                      backgroundColor: isActive
                          ? PhoenixTheme.red
                          : PhoenixTheme.gold.withValues(alpha: .18),
                      child: isActive
                          ? const Icon(
                              Icons.graphic_eq,
                              size: 18,
                              color: Colors.white,
                            )
                          : Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: PhoenixTheme.red,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                    mainText: Text(
                      item.text,
                      style: TextStyle(
                        height: 1.55,
                        fontSize: 15.5,
                        fontWeight:
                            isActive ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(growable: false),
              );
            },
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
          const Text(wonderQuestion),
          const SizedBox(height: 14),
          TextField(
            controller: wonderController,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => unawaited(_persistProgress()),
            decoration: const InputDecoration(
              hintText: '写下你的想法……',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              final answer = wonderController.text.trim();
              setState(() {
                aiReply = answer.isEmpty
                    ? '先写一点你的想法，我会认真回应。'
                    : '你的观察很有意思。你已经开始把建筑与人的生活连接起来了；下一次可以再补充一个具体细节，让表达更有画面。';
              });
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('请 AI 回应'),
          ),
          if (aiReply.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: PhoenixTheme.ai.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                aiReply,
                style: const TextStyle(color: PhoenixTheme.ai),
              ),
            ),
          ],
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
          const Text(expressQuestion),
          const SizedBox(height: 14),
          TextField(
            controller: expressController,
            minLines: 4,
            maxLines: 8,
            onChanged: (_) => unawaited(_persistProgress()),
            decoration: const InputDecoration(
              hintText: '用中文写下你的表达……',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '后续接入 AI 后，将纠正语法、解释原因，并给出更自然的表达。',
            style: TextStyle(color: PhoenixTheme.translation),
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
          const Text('今天最想记住的一件事是什么？'),
          const SizedBox(height: 14),
          TextField(
            controller: memoryController,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => unawaited(_persistProgress()),
            decoration: const InputDecoration(
              hintText: '写下感受，未来可以回来比较自己的变化。',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          const _InlineTip(
            icon: Icons.approval_outlined,
            text: '结束后会自动保存回忆，由 PhoenixStampAgent 完成原创盖章动画',
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
          const AnimatedForbiddenCityStamp(),
          const SizedBox(height: 10),
          const Text(
            '盖章成功',
            style: TextStyle(
              color: PhoenixTheme.red,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '你没有完成一堂课。\n你完成了一段旅程。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19, height: 1.6),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => unawaited(_restartJourney()),
            icon: const Icon(Icons.replay),
            label: const Text('重新体验北京 Journey'),
          ),
        ],
      ),
    );
  }
}

class _InlineTip extends StatelessWidget {
  const _InlineTip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: PhoenixTheme.red),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 11.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
