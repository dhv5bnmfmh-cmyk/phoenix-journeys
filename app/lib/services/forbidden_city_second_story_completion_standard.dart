import '../models/journey_challenge.dart';

class _CompletionBlueprint {
  const _CompletionBlueprint({
    required this.segments,
    required this.answers,
    required this.slotTypes,
  });

  final List<String> segments;
  final List<String> answers;
  final List<String> slotTypes;
}

const _blueprints = <_CompletionBlueprint>[
  _CompletionBlueprint(
    segments: <String>[
      '交接前，林乔和许澄先',
      '记录，再确认',
      '位于乾清门前广场',
      '。他们把',
      '和',
      '分开，保留',
      '与',
      '，并写下',
      '。这样下一位',
      '才能继续',
      '。',
    ],
    answers: <String>[
      '核对',
      '景运门',
      '东侧',
      '已确认项',
      '待核项',
      '原标记',
      '页码',
      '核对依据',
      '接手者',
      '复核',
    ],
    slotTypes: <String>[
      'ACTION',
      'PLACE',
      'DIRECTION',
      'STATUS',
      'STATUS',
      'RECORD',
      'RECORD',
      'EVIDENCE',
      'PERSON',
      'ACTION',
    ],
  ),
  _CompletionBlueprint(
    segments: <String>[
      '读紫禁城地图时，许澄先用',
      '理解',
      '，再以',
      '作为参照，确认',
      '在',
      '。他把中轴标作',
      '，把景运门标作',
      '，并注明',
      '来自',
      '而不是只凭',
      '。',
    ],
    answers: <String>[
      '中轴',
      '南北序列',
      '乾清门前广场',
      '景运门',
      '东侧',
      '空间框架',
      '具体宫门',
      '方位结论',
      '位置证据',
      '整体结构',
    ],
    slotTypes: <String>[
      'CONCEPT',
      'RELATION',
      'PLACE',
      'PLACE',
      'DIRECTION',
      'CONCEPT',
      'CONCEPT',
      'CONCLUSION',
      'EVIDENCE',
      'CONCEPT',
    ],
  ),
  _CompletionBlueprint(
    segments: <String>[
      '更正旧表时，两人先保留',
      '，再写上',
      '，并记录',
      '和',
      '。',
      '可以进入',
      '，',
      '则保留',
      '和',
      '。这样后来的人既能看见结论，也能追到',
      '。',
    ],
    answers: <String>[
      '原标记',
      '东侧',
      '页码',
      '核对依据',
      '已确认项',
      '正式记录',
      '待核项',
      '空位',
      '下一步问题',
      '更正过程',
    ],
    slotTypes: <String>[
      'RECORD',
      'DIRECTION',
      'RECORD',
      'EVIDENCE',
      'STATUS',
      'RECORD',
      'STATUS',
      'RECORD',
      'QUESTION',
      'PROCESS',
    ],
  ),
  _CompletionBlueprint(
    segments: <String>[
      '独立复核时，许澄先找到',
      '，再回到',
      '，确认',
      '的',
      '，最后核验',
      '方位。他把',
      '、',
      '和',
      '分开记录，使',
      '能够沿同一',
      '重复检查结论。',
    ],
    answers: <String>[
      '旧表',
      '图页',
      '乾清门前广场',
      '参照关系',
      '景运门',
      '直接事实',
      '结构线索',
      '待核假设',
      '下一位接手者',
      '证据链',
    ],
    slotTypes: <String>[
      'RECORD',
      'RECORD',
      'PLACE',
      'RELATION',
      'PLACE',
      'EVIDENCE_KIND',
      'EVIDENCE_KIND',
      'EVIDENCE_KIND',
      'PERSON',
      'EVIDENCE',
    ],
  ),
];

const _levelContexts = <String>[
  '先从具体宫门和基本方位开始。',
  '再区分已确认信息与待核信息。',
  '这一等级要求区分空间框架与具体建筑。',
  '这一等级开始保留更正前后的证据。',
  '这一等级把空间知识与交接记录连接起来。',
  '这一等级要求判断不同证据各自能证明什么。',
  '这一等级要求在证据不足时明确保留未决状态。',
  '这一等级把空间事实与记录过程分层核对。',
  '这一等级进一步区分直接事实、推断与待核假设。',
  '这一等级要求整条证据链能够被下一位接手者独立复核。',
];

const _slotPools = <String, List<String>>{
  'ACTION': <String>['核对', '复核', '查验', '比较', '确认', '记录'],
  'PLACE': <String>['景运门', '乾清门', '午门', '乾清门前广场', '内廷', '外朝'],
  'DIRECTION': <String>['东侧', '西侧', '南侧', '北侧'],
  'STATUS': <String>['已确认项', '待核项', '未核项目', '已更正项'],
  'RECORD': <String>['原标记', '页码', '正式记录', '图页', '签名栏', '更正记录'],
  'EVIDENCE': <String>['核对依据', '位置证据', '图页来源', '更正依据', '证据链'],
  'PERSON': <String>['接手者', '核对人', '记录员', '下一位接手者'],
  'CONCEPT': <String>['中轴', '空间框架', '具体宫门', '整体结构', '空间关系'],
  'RELATION': <String>['南北序列', '参照关系', '空间关系', '连接关系'],
  'CONCLUSION': <String>['方位结论', '核对结论', '位置判断', '空间判断'],
  'QUESTION': <String>['下一步问题', '待核疑问', '复核问题', '未决事项'],
  'PROCESS': <String>['更正过程', '核对过程', '交接过程', '复核过程'],
  'EVIDENCE_KIND': <String>['直接事实', '结构线索', '待核假设', '位置证据'],
};

const _blankPatterns = <List<int>>[
  <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
  <int>[2, 4, 6, 8, 0, 1, 3, 5, 7, 9],
  <int>[9, 7, 5, 3, 1, 8, 6, 4, 2, 0],
  <int>[1, 3, 5, 7, 9, 0, 2, 4, 6, 8],
];

StoryChallengeQuestion applySecondStoryCompletionStandard(
  StoryChallengeQuestion source, {
  required int level,
  required int index,
}) {
  final safeLevel = level.clamp(1, 10).toInt();
  final blueprint = _blueprints[index % _blueprints.length];
  if (blueprint.answers.length != 10 ||
      blueprint.segments.length != 11 ||
      blueprint.slotTypes.length != 10) {
    throw StateError('Second Story completion blueprint must expose 10 slots.');
  }

  final selectedSlots = _blankPatterns[index % _blankPatterns.length]
      .take(safeLevel)
      .toSet();
  final orderedSlots = selectedSlots.toList()..sort();
  final completionSegments = <String>[];
  final blanks = <StoryCompletionBlank>[];
  final current = StringBuffer(_levelContexts[safeLevel - 1]);
  var fullOffset = _levelContexts[safeLevel - 1].length;

  for (var slot = 0; slot < 10; slot += 1) {
    current.write(blueprint.segments[slot]);
    fullOffset += blueprint.segments[slot].length;
    final answer = blueprint.answers[slot];
    if (selectedSlots.contains(slot)) {
      completionSegments.add(current.toString());
      current.clear();
      final blankOrdinal = orderedSlots.indexOf(slot);
      blanks.add(
        StoryCompletionBlank(
          answer: answer,
          options: _optionsFor(
            answer,
            blueprint.slotTypes[slot],
            target: (safeLevel + index + blankOrdinal) % 4,
          ),
          answerType: '完整语义短语',
          semanticSlotType: blueprint.slotTypes[slot],
          sourceStart: fullOffset,
        ),
      );
    } else {
      current.write(answer);
    }
    fullOffset += answer.length;
  }
  current.write(blueprint.segments.last);
  completionSegments.add(current.toString());

  final fullSentence = StringBuffer(_levelContexts[safeLevel - 1]);
  for (var slot = 0; slot < 10; slot += 1) {
    fullSentence
      ..write(blueprint.segments[slot])
      ..write(blueprint.answers[slot]);
  }
  fullSentence.write(blueprint.segments.last);

  if (blanks.length != safeLevel ||
      completionSegments.length != safeLevel + 1) {
    throw StateError('Second Story completion Lv$safeLevel blank contract drifted.');
  }

  final rebuilt = StringBuffer();
  for (var i = 0; i < blanks.length; i += 1) {
    rebuilt
      ..write(completionSegments[i])
      ..write(blanks[i].answer);
  }
  rebuilt.write(completionSegments.last);
  if (rebuilt.toString() != fullSentence.toString()) {
    throw StateError('Second Story completion must rebuild a natural authored passage.');
  }

  final signature = source.signature;
  return StoryChallengeQuestion(
    id: source.id,
    mode: StoryChallengeMode.storyCompletion,
    sourceSentence: fullSentence.toString(),
    prompt: '根据“交接前的标记”和紫禁城知识补全记录（Lv$safeLevel · $safeLevel 个空位）',
    answer: fullSentence.toString(),
    options: const <String>[],
    characterTiles: const <String>[],
    errorSegments: const <String>[],
    errorSegmentIndex: null,
    grammarFamily: null,
    grammarWhyWrong: null,
    grammarRevisionRule: null,
    grammarOptionExplanations: const <String>[],
    completionSegments: List<String>.unmodifiable(completionSegments),
    completionBlanks: List<StoryCompletionBlank>.unmodifiable(blanks),
    narrationText: fullSentence.toString(),
    signature: QuestionDesignSignature(
      journeyId: signature.journeyId,
      sessionLevel: signature.sessionLevel,
      mode: StoryChallengeMode.storyCompletion,
      sourceParagraphIndex: signature.sourceParagraphIndex,
      sourceSentenceIndex: signature.sourceSentenceIndex,
      sourceHash: _hash(fullSentence.toString()),
      syntaxPattern: 'StoryB-authored-completion-${index + 1}',
      operationType: '完整自然短文→同槽位语义填空',
      errorFamily: null,
      gapType: '多空位选择填空',
      answerShape: '完整短文 / $safeLevel空',
      distractorStrategy: 'Story B Lv$safeLevel same grammatical slot plausible distractors',
      blankPositionPattern: orderedSlots.join('-'),
    ),
  );
}

List<String> _optionsFor(
  String answer,
  String slotType, {
  required int target,
}) {
  final pool = _slotPools[slotType];
  if (pool == null) throw StateError('Unknown completion slot type: $slotType');
  final distractors = <String>[
    for (final candidate in pool)
      if (candidate != answer) candidate,
  ];
  if (distractors.length < 3) {
    throw StateError('Completion slot $slotType needs three distractors.');
  }
  final raw = <String>[answer, ...distractors.take(3)];
  final result = <String>[...raw.skip(1)]..insert(target.clamp(0, 3), answer);
  if (result.length != 4 || result.toSet().length != 4) {
    throw StateError('Completion options must contain four unique candidates.');
  }
  return List<String>.unmodifiable(result);
}

String _hash(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
