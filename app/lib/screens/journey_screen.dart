import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../services/narration_controller.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/interactive_story_text.dart';
import '../widgets/journey_progress_header.dart';
import '../widgets/narration_player_card.dart';
import '../widgets/word_detail_sheet.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen>
    with WidgetsBindingObserver {
  static const _stepLabels = [
    '故事',
    '生词',
    '发现',
    '思考',
    '表达',
    '回忆',
    '完成',
  ];

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

    if (step == 2) {
      _scheduleDiscoveryAutoStart();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      unawaited(_narration.stop());
      if (_initialized) unawaited(_persistProgress());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_initialized) {
      unawaited(_persistProgress());
    }
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

    setState(() => step = safeStep);
    await _persistProgress(overrideStep: safeStep);

    if (safeStep == 2) {
      _scheduleDiscoveryAutoStart();
    }
  }

  Future<void> _next() => _goToStep(step + 1);

  Future<void> _back() => _goToStep(step - 1);

  void _scheduleDiscoveryAutoStart() {
    if (_discoveryAutoStarted) return;
    _discoveryAutoStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && step == 2) {
        unawaited(_playDiscoveries());
      }
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
              text: entry.value,
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

  @override
  Widget build(BuildContext context) {
    final pages = [
      _story(context),
      _words(context),
      _discover(context),
      _wonder(context),
      _express(context),
      _memory(context),
      _complete(context),
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
        duration: const Duration(milliseconds: 320),
        child: pages[step],
      ),
    );
  }

  Widget _page({
    required String title,
    required Widget child,
    String buttonText = '继续',
    VoidCallback? onNext,
    bool showBack = true,
  }) {
    final state = context.watch<AppState>();

    return ListView(
      key: ValueKey(title),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 40),
      children: [
        JourneyProgressHeader(
          currentStep: step,
          furthestStep: state.beijingJourneyFurthestStep,
          labels: _stepLabels,
          onStepSelected: (value) => unawaited(_goToStep(value)),
        ),
        const SizedBox(height: 22),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 18),
        child,
        const SizedBox(height: 28),
        Row(
          children: [
            if (showBack && step > 0 && step < AppState.beijingJourneyLastStep) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => unawaited(_back()),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('上一步'),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: onNext ?? () => unawaited(_next()),
                icon: Icon(
                  step == AppState.beijingJourneyLastStep
                      ? Icons.home_outlined
                      : Icons.arrow_forward,
                ),
                label: Text(buttonText),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _story(BuildContext context) {
    return _page(
      title: '故事',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'story',
            title: '听完整故事',
            subtitle: '慢速普通话 · ${storyParagraphs.length} 段',
            onPlay: _playStory,
          ),
          const SizedBox(height: 16),
          const _TipCard(
            icon: Icons.touch_app_outlined,
            text: '长按红色虚线词语查看拼音、中文释义和越南语。打开生词时，故事朗读会自动停止。',
          ),
          const SizedBox(height: 18),
          AnimatedBuilder(
            animation: _narration,
            builder: (context, _) {
              return Column(
                children: storyParagraphs.asMap().entries.map((entry) {
                  final isActive = _isNarrating('story', entry.key);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isActive
                          ? PhoenixTheme.red.withValues(alpha: .08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isActive
                            ? PhoenixTheme.red.withValues(alpha: .32)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isActive) ...[
                          const Icon(
                            Icons.graphic_eq,
                            size: 20,
                            color: PhoenixTheme.red,
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: InteractiveStoryText(
                            text: entry.value,
                            entries: words,
                            onWordLongPress: (word) {
                              unawaited(_openWord(word));
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(growable: false),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            '本页重点词语',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
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
                    avatar: Text(entry.symbol),
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

  Widget _words(BuildContext context) {
    final state = context.watch<AppState>();

    return _page(
      title: '生词',
      child: Column(
        children: words
            .map(
              (entry) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => unawaited(_openWord(entry)),
                  onLongPress: () => unawaited(_openWord(entry)),
                  leading: Text(entry.symbol, style: const TextStyle(fontSize: 30)),
                  title: Text(
                    entry.word,
                    style: const TextStyle(fontWeight: FontWeight.w800),
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

  Widget _discover(BuildContext context) {
    return _page(
      title: '发现',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NarrationPlayerCard(
            controller: _narration,
            contentId: 'discovery',
            title: 'Discovery 自动朗读',
            subtitle: '进入本页自动播放 · 可暂停或重播',
            onPlay: _playDiscoveries,
          ),
          const SizedBox(height: 12),
          const Text(
            '当前正在朗读的发现会自动亮起。部分浏览器首次使用时，可能需要手动点一次播放。',
            style: TextStyle(color: Colors.black54, height: 1.45),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _narration,
            builder: (context, _) {
              return Column(
                children: discoveries.asMap().entries.map((entry) {
                  final isActive = _isNarrating('discovery', entry.key);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isActive
                          ? PhoenixTheme.gold.withValues(alpha: .18)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive
                            ? PhoenixTheme.gold
                            : PhoenixTheme.gold.withValues(alpha: .18),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 14,
                          offset: Offset(0, 7),
                          color: Color(0x10000000),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 19,
                          backgroundColor: isActive
                              ? PhoenixTheme.red
                              : PhoenixTheme.gold.withValues(alpha: .18),
                          child: isActive
                              ? const Icon(
                                  Icons.graphic_eq,
                                  size: 20,
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
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              height: 1.55,
                              fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
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

  Widget _wonder(BuildContext context) {
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
              child: Text(aiReply, style: const TextStyle(color: PhoenixTheme.ai)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _express(BuildContext context) {
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
            '后续版本将接入 AI：纠正语法、解释原因，并给出更自然的表达。',
            style: TextStyle(color: PhoenixTheme.translation),
          ),
        ],
      ),
    );
  }

  Widget _memory(BuildContext context) {
    return _page(
      title: '留下今天',
      buttonText: '完成旅程并自动保存',
      onNext: () async {
        final state = context.read<AppState>();
        final memory = memoryController.text;
        await _narration.stop();
        await state.completeJourney(memory);
        if (!mounted) return;
        setState(() => step = AppState.beijingJourneyLastStep);
      },
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
              hintText: '每一次感受都会自动保存，未来可以回来比较自己的变化。',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _complete(BuildContext context) {
    return _page(
      title: '北京已点亮',
      buttonText: '返回首页',
      showBack: false,
      onNext: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          const SizedBox(height: 18),
          const Text('🏯', style: TextStyle(fontSize: 78)),
          const SizedBox(height: 18),
          const Text(
            '你没有完成一堂课。\n你完成了一段旅程。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, height: 1.6),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              await _appState.restartJourney();
              wonderController.clear();
              expressController.clear();
              memoryController.clear();
              aiReply = '';
              _discoveryAutoStarted = false;
              if (mounted) setState(() => step = 0);
            },
            icon: const Icon(Icons.replay),
            label: const Text('重新体验北京 Journey'),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: PhoenixTheme.gold.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: PhoenixTheme.red),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(height: 1.5))),
        ],
      ),
    );
  }
}
