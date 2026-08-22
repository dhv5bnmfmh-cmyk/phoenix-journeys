import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/forbidden_city_challenge_package.dart';
import '../data/forbidden_city_journey_runtime.dart';
import '../models/language_proficiency.dart';
import '../theme/phoenix_theme.dart';
import 'journey_challenge_panel_legacy.dart' as legacy;

enum _ReferenceChallengeMode { story, evidence, transfer }

class ForbiddenCityReferenceChallengePanel extends StatefulWidget {
  const ForbiddenCityReferenceChallengePanel({
    super.key,
    required this.journeyId,
    required this.storyParagraphs,
    required this.discoveryTexts,
    required this.profile,
    required this.seed,
    required this.displayText,
    required this.onResolved,
    required this.onAllCompleted,
  });

  final String journeyId;
  final List<String> storyParagraphs;
  final List<String> discoveryTexts;
  final ChineseProficiencyProfile? profile;
  final int seed;
  final String Function(String) displayText;
  final legacy.JourneyChallengeResolved onResolved;
  final legacy.JourneyChallengeCompleted onAllCompleted;

  @override
  State<ForbiddenCityReferenceChallengePanel> createState() =>
      _ForbiddenCityReferenceChallengePanelState();
}

class _ForbiddenCityReferenceChallengePanelState
    extends State<ForbiddenCityReferenceChallengePanel> {
  late int _level;
  _ReferenceChallengeMode _mode = _ReferenceChallengeMode.story;
  final List<int> _storySelection = <int>[];
  int? _selectedChoice;
  int _attempts = 0;
  bool _resolved = false;
  bool _sending = false;
  String _feedback = '';

  ForbiddenCityParagraphRebuild get _storyRecord =>
      forbiddenCityParagraphRebuild.singleWhere((item) => item.level == _level);
  ForbiddenCityGrammarRepair get _evidenceRecord =>
      forbiddenCityGrammarRepair.singleWhere((item) => item.level == _level);
  ForbiddenCityMissingSentence get _transferRecord =>
      forbiddenCityMissingSentence.singleWhere((item) => item.level == _level);

  String t(String value) => widget.displayText(value);

  @override
  void initState() {
    super.initState();
    _level = _resolveLevel();
  }

  @override
  void didUpdateWidget(
    covariant ForbiddenCityReferenceChallengePanel oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    final next = _resolveLevel();
    if (next != _level || oldWidget.seed != widget.seed) {
      _level = next;
      _resetAll();
    }
  }

  int _resolveLevel() {
    final active = widget.storyParagraphs
        .map((item) => item.trim())
        .join('\n\n');
    for (var level = 1; level <= forbiddenCityLockedStories.length; level++) {
      if (forbiddenCityLockedStories[level - 1].trim() == active) return level;
    }
    throw StateError(
      'Forbidden City Reference Challenge requires exact Lv1-Lv10 Story binding.',
    );
  }

  void _resetAll() {
    _mode = _ReferenceChallengeMode.story;
    _resetMode();
  }

  void _resetMode() {
    _storySelection.clear();
    _selectedChoice = null;
    _attempts = 0;
    _resolved = false;
    _sending = false;
    _feedback = '';
  }

  String get _modeLabel => switch (_mode) {
    _ReferenceChallengeMode.story => '故事理解',
    _ReferenceChallengeMode.evidence => '证据推理',
    _ReferenceChallengeMode.transfer => '迁移决策',
  };

  String get _trainingGoal => switch (_mode) {
    _ReferenceChallengeMode.story => _storyRecord.cognitiveTarget,
    _ReferenceChallengeMode.evidence =>
      _level <= 3
          ? '从 Story 找人物、目标与路线证据'
          : _level <= 6
          ? '比较建筑连接、任务与路线理由'
          : _level <= 8
          ? '用多条证据修正人物判断'
          : '识别过度推论并权衡多重空间证据',
    _ReferenceChallengeMode.transfer =>
      _level <= 3
          ? '把基本理解用于新的路线选择'
          : _level <= 6
          ? '迁移“建筑条件 + 人物任务”的判断方法'
          : _level <= 8
          ? '在新情境中选择关键证据'
          : '综合空间约束、目标与行动后果作决定',
  };

  String get _question => switch (_mode) {
    _ReferenceChallengeMode.story =>
      '按人物行动与因果关系，把当前 Lv$_level Story 的四个事件放回正确顺序。',
    _ReferenceChallengeMode.evidence => _evidenceRecord.evidenceQuestion,
    _ReferenceChallengeMode.transfer => _transferRecord.transferQuestion,
  };

  List<_ReferenceChoice> get _choices {
    if (_mode == _ReferenceChallengeMode.evidence) {
      final record = _evidenceRecord;
      final items = <_ReferenceChoice>[
        _ReferenceChoice(record.evidenceAnswer, true),
        _ReferenceChoice(record.broken, false),
        _ReferenceChoice(_evidenceDistractorB[_level - 1], false),
        _ReferenceChoice(_evidenceDistractorC[_level - 1], false),
      ];
      items.shuffle(math.Random(widget.seed + _level * 31));
      return items;
    }
    if (_mode == _ReferenceChallengeMode.transfer) {
      final record = _transferRecord;
      final items = <_ReferenceChoice>[
        for (final text in record.transferOptions)
          _ReferenceChoice(text, text == record.transferAnswer),
      ];
      items.shuffle(math.Random(widget.seed + _level * 47));
      return items;
    }
    return const <_ReferenceChoice>[];
  }

  bool get _canSubmit => _mode == _ReferenceChallengeMode.story
      ? _storySelection.length == _storyRecord.correctOrder.length
      : _selectedChoice != null;

  String get _correctAnswer => switch (_mode) {
    _ReferenceChallengeMode.story =>
      _storyRecord.correctOrder
          .map((index) => _storyRecord.segments[index])
          .join('\n'),
    _ReferenceChallengeMode.evidence => _evidenceRecord.evidenceAnswer,
    _ReferenceChallengeMode.transfer => _transferRecord.transferAnswer,
  };

  String get _explanation => switch (_mode) {
    _ReferenceChallengeMode.story => _storyRecord.explanation,
    _ReferenceChallengeMode.evidence =>
      '${_evidenceRecord.focus} ${_evidenceRecord.evidenceAnswer}',
    _ReferenceChallengeMode.transfer =>
      '把 Journey 原则迁移到新情境，而不是恢复原句。依据：${_transferRecord.sourceEvidence}',
  };

  bool _isCorrect(List<_ReferenceChoice> choices) {
    if (_mode == _ReferenceChallengeMode.story) {
      final answer = _storyRecord.correctOrder;
      if (_storySelection.length != answer.length) return false;
      for (var index = 0; index < answer.length; index++) {
        if (_storySelection[index] != answer[index]) return false;
      }
      return true;
    }
    final selected = _selectedChoice;
    return selected != null && choices[selected].correct;
  }

  Future<void> _submit(List<_ReferenceChoice> choices) async {
    if (!_canSubmit || _resolved || _sending) return;
    final correct = _isCorrect(choices);
    setState(() {
      _attempts += 1;
      if (correct || _attempts >= 3) {
        _resolved = true;
        _feedback = correct ? '回答正确。' : '三次机会结束。请对照正确答案和证据说明。';
      } else {
        _feedback = _mode == _ReferenceChallengeMode.story
            ? '顺序还没有形成完整因果链。先找目标、冲突、选择和结果。'
            : _mode == _ReferenceChallengeMode.evidence
            ? '这个判断存在错误因果、错误动机、错误空间关系或过度推论。'
            : '先检查空间是否可行，再看人物目标、任务和行动后果。';
        _storySelection.clear();
        _selectedChoice = null;
      }
    });
    if (!_resolved) return;

    setState(() => _sending = true);
    final reward = correct
        ? switch (_attempts) {
            1 => '金币',
            2 => '银币',
            _ => '铜币',
          }
        : '碎银';
    try {
      await widget.onResolved(
        reward,
        '${widget.journeyId}:reference-${_mode.name}:lv$_level:${widget.seed}',
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _continue() async {
    if (!_resolved || _sending) return;
    if (_mode == _ReferenceChallengeMode.transfer) {
      await widget.onAllCompleted();
      return;
    }
    setState(() {
      _mode = _mode == _ReferenceChallengeMode.story
          ? _ReferenceChallengeMode.evidence
          : _ReferenceChallengeMode.transfer;
      _resetMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final choices = _choices;
    return Column(
      key: ValueKey('forbidden-city-reference-challenge-lv-$_level'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _modeStrip(),
        const SizedBox(height: 8),
        Container(
          key: const ValueKey('forbidden-city-reference-challenge-question'),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: const Color(0xFFF6EBD4),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFD9BC82)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('$_modeLabel · Lv$_level'),
                style: const TextStyle(
                  color: Color(0xFF5D3B22),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                t(_question),
                style: const TextStyle(
                  color: Color(0xFF49382C),
                  fontSize: 11.5,
                  height: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                t('训练目标 · $_trainingGoal'),
                style: const TextStyle(
                  color: Color(0xFF7A4B2B),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_mode == _ReferenceChallengeMode.story)
                  _storyOptions()
                else ...[
                  if (_mode == _ReferenceChallengeMode.evidence)
                    _evidenceContext(),
                  if (_mode == _ReferenceChallengeMode.transfer)
                    _transferContext(),
                  if (_mode != _ReferenceChallengeMode.story)
                    const SizedBox(height: 7),
                  for (var index = 0; index < choices.length; index++) ...[
                    _choiceTile(choices[index], index),
                    if (index < choices.length - 1) const SizedBox(height: 6),
                  ],
                ],
                if (_feedback.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    t(_feedback),
                    key: const ValueKey('forbidden-city-challenge-feedback'),
                    style: const TextStyle(
                      color: Color(0xFFFFD879),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                if (_resolved) ...[
                  const SizedBox(height: 8),
                  _resolutionCard(),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          key: ValueKey(
            _resolved
                ? 'forbidden-city-challenge-continue'
                : 'forbidden-city-challenge-submit',
          ),
          onPressed: _resolved
              ? _continue
              : (_canSubmit ? () => _submit(choices) : null),
          style: FilledButton.styleFrom(
            backgroundColor: PhoenixTheme.red,
            foregroundColor: Colors.white,
          ),
          icon: Icon(
            _resolved ? Icons.arrow_forward_rounded : Icons.check_rounded,
          ),
          label: Text(
            t(
              _resolved
                  ? (_mode == _ReferenceChallengeMode.transfer
                        ? '完成 Challenge'
                        : '进入下一项')
                  : '提交答案',
            ),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _modeStrip() {
    const labels = <String>['故事理解', '证据推理', '迁移决策'];
    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          Expanded(
            child: Container(
              key: ValueKey('forbidden-city-challenge-mode-$index'),
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: index == _mode.index
                    ? PhoenixTheme.red.withValues(alpha: .88)
                    : Colors.black.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                t(labels[index]),
                style: TextStyle(
                  color: index <= _mode.index ? Colors.white : Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          if (index < labels.length - 1) const SizedBox(width: 5),
        ],
      ],
    );
  }

  Widget _storyOptions() {
    final record = _storyRecord;
    final order = List<int>.generate(record.segments.length, (index) => index)
      ..shuffle(math.Random(widget.seed + _level * 17));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          key: const ValueKey('forbidden-city-story-comprehension-order'),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .22),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _storySelection.isEmpty
                ? t('依次选择 4 个事件')
                : _storySelection
                      .map((index) => t(record.segments[index]))
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) => '${entry.key + 1}. ${entry.value}')
                      .join('\n'),
            style: const TextStyle(color: Colors.white, height: 1.4),
          ),
        ),
        const SizedBox(height: 7),
        for (final index in order) ...[
          OutlinedButton(
            key: ValueKey('forbidden-city-story-option-$index'),
            onPressed: _resolved || _storySelection.contains(index)
                ? null
                : () => setState(() => _storySelection.add(index)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: .3)),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
            ),
            child: Text(t(record.segments[index])),
          ),
          const SizedBox(height: 5),
        ],
        if (!_resolved && _storySelection.isNotEmpty)
          TextButton.icon(
            key: const ValueKey('forbidden-city-story-undo'),
            onPressed: () => setState(() => _storySelection.removeLast()),
            icon: const Icon(Icons.undo_rounded),
            label: Text(t('撤回最后一步')),
          ),
      ],
    );
  }

  Widget _evidenceContext() => Container(
    key: const ValueKey('forbidden-city-evidence-context'),
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .22),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      t(
        '待检验判断 · ${_evidenceRecord.broken}\nStory 证据 · ${_evidenceRecord.correct}',
      ),
      style: const TextStyle(color: Colors.white, height: 1.4),
    ),
  );

  Widget _transferContext() => Container(
    key: const ValueKey('forbidden-city-transfer-context'),
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .22),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      t('已学依据 · ${_transferRecord.sourceEvidence}'),
      style: const TextStyle(color: Colors.white, height: 1.4),
    ),
  );

  Widget _choiceTile(_ReferenceChoice choice, int index) {
    final selected = _selectedChoice == index;
    return OutlinedButton(
      key: ValueKey('forbidden-city-cognition-option-$index'),
      onPressed: _resolved
          ? null
          : () => setState(() => _selectedChoice = index),
      style: OutlinedButton.styleFrom(
        foregroundColor: selected ? const Color(0xFFFFD879) : Colors.white,
        side: BorderSide(
          color: selected ? const Color(0xFFFFD879) : Colors.white30,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(10),
      ),
      child: Text(t(choice.text)),
    );
  }

  Widget _resolutionCard() => Container(
    key: const ValueKey('forbidden-city-challenge-resolution'),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFE9F0DF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t('正确答案'),
          style: const TextStyle(
            color: Color(0xFF315B32),
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          t(_correctAnswer),
          style: const TextStyle(color: Color(0xFF263B27), height: 1.35),
        ),
        const SizedBox(height: 5),
        Text(
          t(_explanation),
          style: const TextStyle(color: Color(0xFF263B27), height: 1.35),
        ),
      ],
    ),
  );
}

class _ReferenceChoice {
  const _ReferenceChoice(this.text, this.correct);

  final String text;
  final bool correct;
}

const _evidenceDistractorB = <String>[
  '人物走法不同，只能说明其中一个人记错了方向。',
  '乾清门前是共同节点，所以两个人下一步也必须一致。',
  '目标不同意味着两条路线不需要共享任何真实空间证据。',
  '只要身份不同，就不必检查宫门、院落和连接关系。',
  '阿宁的任务在东侧，所以中轴对任何判断都没有价值。',
  '路线不同就是建筑关系不同，不需要再比较任务。',
  '既然约束相同，人物视角就不能产生不同选择。',
  '常用路线天然拥有排他性，不需要说明适用条件。',
  '只要沈砚先画出路线，他的视角就应成为默认标准。',
  '只要中轴存在，东侧任务的行动逻辑就不需要记录。',
];

const _evidenceDistractorC = <String>[
  '送记录这一动作本身就证明只有阿宁的路线正确。',
  '任务不同只影响速度，不会改变路线选择。',
  '共同终点是判断路线是否合理的唯一证据。',
  '路线是否合理只看人物自己的说法，不需要空间事实。',
  '两条路线都经过真实宫门，所以它们服务的目标也相同。',
  '只要一条路线能走通，就不必再问它是否适合任务。',
  '人物目标可以完全脱离建筑条件决定路线。',
  '为了避免偏见，两条路线都不应该被保留。',
  '局部任务比整体空间关系更重要，因此后者可以删除。',
  '只比较路线长度，就足以判断哪条路线更合理。',
];
