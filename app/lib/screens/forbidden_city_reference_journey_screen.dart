import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/forbidden_city_journey_runtime.dart';
import '../data/journey_data.dart';
import '../data/journey_level_catalog.dart';
import '../services/narration_controller.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/journey_challenge_panel.dart';

Widget? resolveDedicatedJourneyRuntimeScreen(String journeyId) {
  if (journeyId == forbiddenCityJourneyId) {
    return const ForbiddenCityReferenceJourneyScreen();
  }
  return null;
}

class ForbiddenCityReferenceJourneyScreen extends StatefulWidget {
  const ForbiddenCityReferenceJourneyScreen({super.key});

  @override
  State<ForbiddenCityReferenceJourneyScreen> createState() =>
      _ForbiddenCityReferenceJourneyScreenState();
}

class _ForbiddenCityReferenceJourneyScreenState
    extends State<ForbiddenCityReferenceJourneyScreen> {
  static const _referenceLevelKey =
      'phoenix.reference.cn-beijing-dongcheng-forbidden-city.level';

  final NarrationController _narration = NarrationController();
  AppState? _app;
  int _level = 1;
  int _step = 0;
  bool _loading = true;
  bool _levelChosen = false;
  bool _challengeCompleted = false;
  int _challengeSeed = 1007;

  AppState get app => _app!;
  JourneyLevelContent get content => forbiddenCityLevelContent(_level);
  ForbiddenCityMemoryMoment get memory => forbiddenCityMemoryForLevel(_level);
  ForbiddenCityCompletionMoment get completion =>
      forbiddenCityCompletionForLevel(_level);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<AppState>();
    if (identical(_app, state)) return;
    _app = state;
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    await app.activateJourney(forbiddenCityJourneyId);
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getInt(_referenceLevelKey);
    if (!mounted) return;
    setState(() {
      _level = (stored ?? 1).clamp(1, 10).toInt();
      _levelChosen = stored != null;
      _step = app.journeyCompleted
          ? AppState.journeyLastStep
          : app.journeyStep.clamp(0, AppState.journeyLastStep).toInt();
      _challengeCompleted = _step > 3 || app.journeyCompleted;
      _challengeSeed = _level * 1000 + 7;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _narration.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    final value = text.trim();
    if (value.isEmpty) return;
    await _narration.speakTemporaryText(value, languageCode: 'zh-CN');
  }

  String _storySupport(ReadingAnnotation annotation) {
    return switch (app.translationLanguage) {
      '英语' => annotation.english,
      '双语' => '${annotation.vietnamese}\n${annotation.english}',
      '中文解释' => '',
      _ => annotation.vietnamese,
    };
  }

  Future<void> _selectLevel(int level) async {
    if (app.journeyCompleted || app.journeyStep > 0) {
      await app.restartJourney();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_referenceLevelKey, level);
    if (!mounted) return;
    setState(() {
      _level = level;
      _levelChosen = true;
      _step = 0;
      _challengeCompleted = false;
      _challengeSeed = level * 1000 + 7;
    });
  }

  Future<void> _changeLevel() async {
    await app.restartJourney();
    if (!mounted) return;
    setState(() {
      _levelChosen = false;
      _step = 0;
      _challengeCompleted = false;
    });
  }

  Future<void> _advance() async {
    if (_step == 3 && !_challengeCompleted) return;
    if (_step == 4) {
      await app.completeJourney(memory.anchor);
      if (!mounted) return;
      setState(() => _step = 5);
      return;
    }
    if (_step >= 5) return;

    final next = _step + 1;
    if (next == 3) {
      await app.ensureChallengeAttemptIdentity();
    }
    await app.saveJourneyProgress(
      step: next,
      wonder: '',
      express: '',
      memory: next >= 4 ? memory.anchor : '',
    );
    if (!mounted) return;
    setState(() {
      _step = next;
      if (_step == 3) _challengeCompleted = false;
    });
  }

  Future<void> _back() async {
    if (_step <= 0) return;
    final previous = _step - 1;
    await app.saveJourneyProgress(
      step: previous,
      wonder: '',
      express: '',
      memory: previous >= 4 ? memory.anchor : '',
    );
    if (!mounted) return;
    setState(() {
      _step = previous;
      if (_step <= 3) _challengeCompleted = false;
    });
  }

  Future<void> _returnToLocation() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      app.setTab(0);
    }
  }

  Future<void> _restart() async {
    await app.restartJourney();
    if (!mounted) return;
    setState(() {
      _step = 0;
      _challengeCompleted = false;
      _levelChosen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!_levelChosen && !app.journeyCompleted) return _levelSelection();

    return Scaffold(
      appBar: AppBar(
        title: Text(app.displayText('北京 · 紫禁城 · Lv$_level')),
        actions: [
          if (!app.journeyCompleted)
            TextButton(
              key: const ValueKey('forbidden-city-change-level'),
              onPressed: _changeLevel,
              child: Text(app.displayText('换等级')),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _stageHeader(),
              const SizedBox(height: 8),
              Expanded(child: _stageBody()),
              if (_step < 5) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (_step > 0) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const ValueKey('forbidden-city-back'),
                          onPressed: _back,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: Text(app.displayText('上一阶段')),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: FilledButton.icon(
                        key: const ValueKey('forbidden-city-next'),
                        onPressed: _step == 3 && !_challengeCompleted
                            ? null
                            : _advance,
                        style: FilledButton.styleFrom(
                          backgroundColor: PhoenixTheme.red,
                          foregroundColor: Colors.white,
                        ),
                        icon: Icon(
                          _step == 4
                              ? Icons.flag_rounded
                              : Icons.arrow_forward_rounded,
                        ),
                        label: Text(
                          app.displayText(_step == 4 ? '完成旅程' : '进入下一阶段'),
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelSelection() {
    return Scaffold(
      appBar: AppBar(title: Text(app.displayText('北京 · 紫禁城'))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            key: const ValueKey('forbidden-city-level-selection'),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                app.displayText('Phoenix Reference Location 001'),
                style: const TextStyle(
                  color: PhoenixTheme.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                app.displayText('Asia → China → Beijing → Forbidden City'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                app.displayText('选择 Story Journey 等级'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final level = index + 1;
                    return FilledButton(
                      key: ValueKey('forbidden-city-level-$level'),
                      onPressed: () => _selectLevel(level),
                      style: FilledButton.styleFrom(
                        backgroundColor: level == _level
                            ? PhoenixTheme.red
                            : const Color(0xFF533632),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Lv$level',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stageHeader() {
    const labels = <String>[
      'Story',
      'Vocabulary',
      'Discovery',
      'Challenge',
      'Memory',
      'Completion',
    ];
    return Row(
      key: const ValueKey('forbidden-city-six-stage-header'),
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: index == _step
                    ? PhoenixTheme.red
                    : index < _step
                    ? const Color(0xFF315B32)
                    : Colors.black.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: index <= _step ? Colors.white : Colors.black54,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          if (index < labels.length - 1) const SizedBox(width: 3),
        ],
      ],
    );
  }

  Widget _stageBody() {
    return switch (_step) {
      0 => _storyPage(),
      1 => _vocabularyPage(),
      2 => _discoveryPage(),
      3 => _challengePage(),
      4 => _memoryPage(),
      _ => _completionPage(),
    };
  }

  Widget _storyPage() {
    return ListView.separated(
      key: ValueKey('forbidden-city-stage-story-lv-$_level'),
      itemCount: content.storyParagraphs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final paragraph = content.storyParagraphs[index];
        final annotation = content.storyAnnotations[index];
        final support = _storySupport(annotation);
        return _referenceCard(
          title: 'Story ${index + 1}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      app.displayText(paragraph),
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    ),
                  ),
                  IconButton(
                    key: ValueKey('forbidden-city-story-speak-$index'),
                    tooltip: app.displayText('朗读'),
                    onPressed: () => unawaited(_speak(paragraph)),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SelectableText(
                annotation.pinyin,
                key: ValueKey('forbidden-city-pinyin-$index'),
                style: const TextStyle(
                  color: Color(0xFF8A5A43),
                  fontSize: 11,
                  height: 1.45,
                ),
              ),
              if (support.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  support,
                  key: ValueKey('forbidden-city-story-support-$index'),
                  style: const TextStyle(fontSize: 11.5, height: 1.45),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _vocabularyPage() {
    return ListView.separated(
      key: ValueKey('forbidden-city-stage-vocabulary-lv-$_level'),
      itemCount: content.words.length,
      separatorBuilder: (_, __) => const SizedBox(height: 7),
      itemBuilder: (context, index) {
        final word = content.words[index];
        return _referenceCard(
          title: '${word.symbol} ${word.word} · ${word.pinyin}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                word.nativeDefinition(app.translationLanguage),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              for (final example in word.studyExamples) ...[
                Text(
                  app.displayText(example.chinese),
                  style: const TextStyle(fontSize: 11.5, height: 1.4),
                ),
                Text(
                  example.nativeText(app.translationLanguage),
                  style: const TextStyle(
                    color: Color(0xFF755D52),
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _discoveryPage() {
    return ListView.separated(
      key: ValueKey('forbidden-city-stage-discovery-lv-$_level'),
      itemCount: content.discoveries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = content.discoveries[index];
        return _referenceCard(
          title: 'Discovery ${index + 1}',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      app.displayText(item.text),
                      style: const TextStyle(fontSize: 13, height: 1.55),
                    ),
                  ),
                  IconButton(
                    key: ValueKey('forbidden-city-discovery-speak-$index'),
                    onPressed: () => unawaited(_speak(item.text)),
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SelectableText(
                item.pinyin,
                key: ValueKey('forbidden-city-discovery-pinyin-$index'),
                style: const TextStyle(
                  color: Color(0xFF8A5A43),
                  fontSize: 10.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.supportText(app.translationLanguage),
                style: const TextStyle(fontSize: 11, height: 1.4),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _challengePage() {
    return Container(
      key: ValueKey('forbidden-city-stage-challenge-lv-$_level'),
      decoration: BoxDecoration(
        color: const Color(0xFF3B211E),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(9),
      child: JourneyChallengePanel(
        journeyId: forbiddenCityJourneyId,
        storyParagraphs: content.storyParagraphs,
        discoveryTexts: content.discoveries
            .map((item) => item.text)
            .toList(growable: false),
        profile: null,
        seed: _challengeSeed,
        displayText: app.displayText,
        onResolved: (reward, awardId) =>
            app.awardChallengeRewardOnce(reward: reward, awardId: awardId),
        onAllCompleted: () async {
          await app.saveJourneyProgress(
            step: 4,
            wonder: '',
            express: '',
            memory: memory.anchor,
          );
          if (!mounted) return;
          setState(() {
            _challengeCompleted = true;
            _step = 4;
          });
        },
      ),
    );
  }

  Widget _memoryPage() {
    return ListView(
      key: ValueKey('forbidden-city-stage-memory-lv-$_level'),
      children: [
        _referenceCard(
          title: '回想 Story',
          child: Text(app.displayText(memory.recall)),
        ),
        const SizedBox(height: 7),
        _referenceCard(
          title: '人物关系变化',
          child: Text(app.displayText(memory.characterShift)),
        ),
        const SizedBox(height: 7),
        _referenceCard(
          title: 'Memory Anchor',
          child: Text(app.displayText(memory.anchor)),
        ),
        const SizedBox(height: 7),
        _referenceCard(
          title: '离开这里要带走什么',
          child: Text(app.displayText(memory.takeaway)),
        ),
      ],
    );
  }

  Widget _completionPage() {
    return ListView(
      key: ValueKey('forbidden-city-stage-completion-lv-$_level'),
      children: [
        Text(
          app.displayText('Phoenix Reference Location 001 · Completed'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: PhoenixTheme.red,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        _referenceCard(
          title: 'Story closure',
          child: Text(app.displayText(completion.storyClosure)),
        ),
        const SizedBox(height: 6),
        _referenceCard(
          title: 'Discovery takeaway',
          child: Text(app.displayText(completion.discovery)),
        ),
        const SizedBox(height: 6),
        _referenceCard(
          title: 'Learning takeaway',
          child: Text(app.displayText(completion.learning)),
        ),
        const SizedBox(height: 6),
        _referenceCard(
          title: 'Memory Anchor',
          child: Text(app.displayText(completion.memory)),
        ),
        const SizedBox(height: 6),
        _referenceCard(
          title: '人物关系变化',
          child: Text(app.displayText(completion.relationship)),
        ),
        const SizedBox(height: 6),
        _referenceCard(
          title: 'Emotional closure',
          child: Text(app.displayText(completion.emotionalClosure)),
        ),
        const SizedBox(height: 6),
        _referenceCard(
          title: 'Progress / Unlock',
          child: Text(app.displayText(completion.unlockResult)),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          key: const ValueKey('forbidden-city-return'),
          onPressed: _returnToLocation,
          icon: const Icon(Icons.place_outlined),
          label: Text(app.displayText('返回地点')),
        ),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          key: const ValueKey('forbidden-city-restart'),
          onPressed: _restart,
          icon: const Icon(Icons.replay_rounded),
          label: Text(app.displayText('重新体验')),
        ),
      ],
    );
  }

  Widget _referenceCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF7EFE3),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFD7C2A4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            app.displayText(title),
            style: const TextStyle(
              color: Color(0xFF7A4B2B),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}
