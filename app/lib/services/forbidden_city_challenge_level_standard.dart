import '../models/journey_challenge.dart';

const _primaryStoryChallengeId = 'beijing-forbidden-city';
const _secondStoryChallengeId =
    'story.forbidden_city.modern_evidence_handoff.v1';

class _RebuildSpec {
  const _RebuildSpec(this.sentence);
  final String sentence;
}

const _primaryRebuildLevels = <List<_RebuildSpec>>[
  [
    _RebuildSpec('午门是紫禁城南面正门'),
    _RebuildSpec('中轴串起紫禁城宫殿群'),
    _RebuildSpec('乾清门连接外朝和内廷'),
    _RebuildSpec('故宫博物院藏宫廷文物'),
  ],
  [
    _RebuildSpec('午门位于紫禁城最南端'),
    _RebuildSpec('中轴组织宫城南北秩序'),
    _RebuildSpec('乾清门分隔外朝与内廷'),
    _RebuildSpec('故宫文物见证宫廷历史'),
  ],
  [
    _RebuildSpec('紫禁城中轴组织宫殿群'),
    _RebuildSpec('午门兼有入口礼仪功能'),
    _RebuildSpec('乾清门处在内外廷之间'),
    _RebuildSpec('故宫博物院保存古建筑'),
  ],
  [
    _RebuildSpec('中轴连接宫门院落次序'),
    _RebuildSpec('午门进入外朝第一道门'),
    _RebuildSpec('乾清门连接内廷外朝路'),
    _RebuildSpec('故宫建筑承载历史证据'),
  ],
  [
    _RebuildSpec('中轴形成宫城空间层级'),
    _RebuildSpec('午门开启宫城礼仪序列'),
    _RebuildSpec('乾清门是内外廷转换处'),
    _RebuildSpec('故宫博物院藏历代文物'),
  ],
  [
    _RebuildSpec('中轴帮助判断空间关系'),
    _RebuildSpec('午门位置标明南侧入口'),
    _RebuildSpec('乾清门前连接不同路线'),
    _RebuildSpec('故宫文物补充建筑证据'),
  ],
  [
    _RebuildSpec('中轴秩序并不等于路线'),
    _RebuildSpec('午门入口不是唯一路线'),
    _RebuildSpec('乾清门可汇合不同任务'),
    _RebuildSpec('故宫博物院用文物释史'),
  ],
  [
    _RebuildSpec('中轴框架服务空间判断'),
    _RebuildSpec('午门起点取决观察任务'),
    _RebuildSpec('乾清门是路线共同节点'),
    _RebuildSpec('故宫证据来自建筑文物'),
  ],
  [
    _RebuildSpec('中轴框架并非行动路线'),
    _RebuildSpec('午门序列不是唯一答案'),
    _RebuildSpec('乾清门需结合任务判断'),
    _RebuildSpec('故宫博物院以证据释史'),
  ],
  [
    _RebuildSpec('中轴证据不能替代目标'),
    _RebuildSpec('午门路线需要说明任务'),
    _RebuildSpec('乾清门连接需结合证据'),
    _RebuildSpec('故宫释史需核建筑文物'),
  ],
];

const _secondRebuildLevels = <List<_RebuildSpec>>[
  [
    _RebuildSpec('中轴串联紫禁城宫门'),
    _RebuildSpec('景运门在广场东侧'),
    _RebuildSpec('乾清门连接外朝内廷'),
    _RebuildSpec('交接前先核对记录'),
  ],
  [
    _RebuildSpec('景运门位于东侧'),
    _RebuildSpec('中轴帮助核对方位'),
    _RebuildSpec('乾清门前要核方向'),
    _RebuildSpec('交接记录保留疑问'),
  ],
  [
    _RebuildSpec('中轴不是具体宫门'),
    _RebuildSpec('景运门是具体宫门'),
    _RebuildSpec('乾清门前分东西侧'),
    _RebuildSpec('核对要区分名称方位'),
  ],
  [
    _RebuildSpec('景运门应标在东侧'),
    _RebuildSpec('乾清门前广场可定位'),
    _RebuildSpec('中轴描述南北序列'),
    _RebuildSpec('更正前先保留旧证'),
  ],
  [
    _RebuildSpec('中轴用于组织空间'),
    _RebuildSpec('景运门位置要核证'),
    _RebuildSpec('乾清门连接内外廷'),
    _RebuildSpec('交接记录注明待核'),
  ],
  [
    _RebuildSpec('景运门在乾清门东侧'),
    _RebuildSpec('中轴和宫门信息不同'),
    _RebuildSpec('核对需要建筑证据'),
    _RebuildSpec('交接要留下核对方法'),
  ],
  [
    _RebuildSpec('乾清门前可比较方位'),
    _RebuildSpec('景运门位置来自核证'),
    _RebuildSpec('中轴帮助读空间关系'),
    _RebuildSpec('待核项目不能先改'),
  ],
  [
    _RebuildSpec('核对方位要看广场关系'),
    _RebuildSpec('景运门东侧是空间事实'),
    _RebuildSpec('中轴不能替代具体位置'),
    _RebuildSpec('交接更正要保留证据'),
  ],
  [
    _RebuildSpec('景运门定位要有证据'),
    _RebuildSpec('乾清门前关系需核证'),
    _RebuildSpec('中轴与宫门要分类读'),
    _RebuildSpec('交接记录区分已核待核'),
  ],
  [
    _RebuildSpec('景运门方位可被复核'),
    _RebuildSpec('乾清门连接帮助定位'),
    _RebuildSpec('中轴提供结构不替方位'),
    _RebuildSpec('交接证据必须可追溯'),
  ],
];

const _primaryGrammarContexts = <String>[
  '观察紫禁城基础空间时，',
  '比较两条可行路线后，',
  '区分宫门与中轴信息时，',
  '核对人物任务和空间关系后，',
  '把共同节点写进路线图时，',
  '比较中轴框架与东侧任务时，',
  '让空间证据改变原判断后，',
  '区分建筑条件和行动目标时，',
  '综合故宫建筑与任务证据时，',
  '要求路线结论可以被复核时，',
];

const _secondFacts = <String>[
  '景运门位于乾清门前广场东侧',
  '中轴描述紫禁城南北空间序列',
  '乾清门连接外朝与内廷',
  '旧表把景运门错标在西侧',
  '待核项目必须与已确认项分开',
  '景运门方位需要具体位置证据',
  '交接记录要保留页码和疑问',
  '空间事实与记录过程要分别核对',
  '更正应保留原标记和核对依据',
  '下一位接手者应能独立复核结论',
];

const _secondConclusions = <String>[
  '记录才能被正确使用',
  '宫门名称才不会和空间框架混淆',
  '接手者才能理解宫城连接关系',
  '更正时必须保留原来的错误证据',
  '记录册才能清楚表达确认状态',
  '不能只凭中轴框架推断具体位置',
  '下一位接手者才能继续追查',
  '结论和核对方法才不会混在一起',
  '不同接手者才能追到同一依据',
  '这次交接才形成完整证据链',
];

const _secondObjects = <String>[
  '景运门的方位记录',
  '中轴和宫门的分类记录',
  '乾清门的连接记录',
  '旧表中的东西方位',
  '已确认项和待核项',
  '景运门的位置证据',
  '页码和疑问记录',
  '空间事实和操作记录',
  '原标记和更正依据',
  '整套交接证据链',
];

const _secondActions = <String>[
  '核对景运门方位',
  '比较中轴和具体宫门',
  '检查乾清门连接关系',
  '保留旧表错误标记',
  '区分已确认项和待核项',
  '查验景运门位置证据',
  '记录页码和未决疑问',
  '核对空间事实与过程',
  '保存原标记和核对依据',
  '整理可复核的交接证据',
];

const _secondWriteObjects = <String>[
  '景运门的东侧位置',
  '中轴和宫门的区别',
  '乾清门的连接关系',
  '旧表的西侧错误',
  '尚未确认的待核项目',
  '景运门的位置依据',
  '相关页码和疑问',
  '空间事实的核对结果',
  '原标记和更正依据',
  '可复核的最终结论',
];

StoryChallengeSet applyForbiddenCityLevelChallengeStandard(
  StoryChallengeSet source,
) {
  if (source.journeyId != _primaryStoryChallengeId &&
      source.journeyId != _secondStoryChallengeId) {
    return source;
  }

  var rebuildIndex = 0;
  var grammarIndex = 0;
  final questions = <StoryChallengeQuestion>[];
  for (final question in source.questions) {
    switch (question.mode) {
      case StoryChallengeMode.sentenceRebuild:
        questions.add(
          _standardRebuild(
            question,
            journeyId: source.journeyId,
            level: source.sessionLevel,
            index: rebuildIndex++,
          ),
        );
      case StoryChallengeMode.grammarRepair:
        questions.add(
          source.journeyId == _primaryStoryChallengeId
              ? _contextualizePrimaryGrammar(
                  question,
                  level: source.sessionLevel,
                )
              : _secondStoryGrammar(
                  question,
                  level: source.sessionLevel,
                  index: grammarIndex,
                ),
        );
        grammarIndex += 1;
      case StoryChallengeMode.storyCompletion:
        questions.add(question);
    }
  }

  return StoryChallengeSet(
    journeyId: source.journeyId,
    sessionLevel: source.sessionLevel,
    questions: List<StoryChallengeQuestion>.unmodifiable(questions),
  );
}

StoryChallengeQuestion _standardRebuild(
  StoryChallengeQuestion source, {
  required String journeyId,
  required int level,
  required int index,
}) {
  final safeLevel = level.clamp(1, 10).toInt();
  final levels = journeyId == _primaryStoryChallengeId
      ? _primaryRebuildLevels
      : _secondRebuildLevels;
  final sentence = levels[safeLevel - 1][index].sentence;
  final han = _hanCount(sentence);
  if (han == 0 || han > 10) {
    throw StateError('$journeyId Lv$safeLevel rebuild-$index has $han Han chars');
  }
  final chunks = _chunks(sentence, safeLevel);
  if (chunks.join() != sentence || chunks.length < 2) {
    throw StateError('$journeyId Lv$safeLevel rebuild chunks drifted');
  }
  final punctuation = '$sentence。';
  final signature = source.signature;
  return StoryChallengeQuestion(
    id: source.id,
    mode: source.mode,
    sourceSentence: punctuation,
    prompt: journeyId == _primaryStoryChallengeId
        ? '复原一条与北京 · 紫禁城相关的知识句'
        : '复原一条来自“交接前的标记”的紫禁城知识句',
    answer: sentence,
    options: source.options,
    characterTiles: List<String>.unmodifiable(_scramble(chunks, index, safeLevel)),
    errorSegments: source.errorSegments,
    errorSegmentIndex: source.errorSegmentIndex,
    grammarFamily: source.grammarFamily,
    grammarWhyWrong: source.grammarWhyWrong,
    grammarRevisionRule: source.grammarRevisionRule,
    grammarOptionExplanations: source.grammarOptionExplanations,
    completionSegments: source.completionSegments,
    completionBlanks: source.completionBlanks,
    narrationText: punctuation,
    signature: QuestionDesignSignature(
      journeyId: signature.journeyId,
      sessionLevel: signature.sessionLevel,
      mode: signature.mode,
      sourceParagraphIndex: signature.sourceParagraphIndex,
      sourceSentenceIndex: signature.sourceSentenceIndex,
      sourceHash: _hash(punctuation),
      syntaxPattern: _syntax(punctuation),
      operationType: '知识句语义块顺序恢复',
      errorFamily: signature.errorFamily,
      gapType: signature.gapType,
      answerShape: '$han字 / ${chunks.length}块',
      distractorStrategy: 'Lv$safeLevel Story-specific semantic chunks',
      blankPositionPattern: signature.blankPositionPattern,
    ),
  );
}

StoryChallengeQuestion _contextualizePrimaryGrammar(
  StoryChallengeQuestion source, {
  required int level,
}) {
  final context = _primaryGrammarContexts[level.clamp(1, 10).toInt() - 1];
  final signature = source.signature;
  return StoryChallengeQuestion(
    id: source.id,
    mode: source.mode,
    sourceSentence: '$context${source.sourceSentence}',
    prompt: '$context${source.prompt}',
    answer: '$context${source.answer}',
    options: List<String>.unmodifiable(
      source.options.map((option) => '$context$option'),
    ),
    characterTiles: source.characterTiles,
    errorSegments: source.errorSegments.isEmpty
        ? source.errorSegments
        : List<String>.unmodifiable([
            '$context${source.errorSegments.first}',
            ...source.errorSegments.skip(1),
          ]),
    errorSegmentIndex: source.errorSegmentIndex,
    grammarFamily: source.grammarFamily,
    grammarWhyWrong: source.grammarWhyWrong,
    grammarRevisionRule: source.grammarRevisionRule,
    grammarOptionExplanations: source.grammarOptionExplanations,
    completionSegments: source.completionSegments,
    completionBlanks: source.completionBlanks,
    narrationText: '$context${source.narrationText}',
    signature: QuestionDesignSignature(
      journeyId: signature.journeyId,
      sessionLevel: signature.sessionLevel,
      mode: signature.mode,
      sourceParagraphIndex: signature.sourceParagraphIndex,
      sourceSentenceIndex: signature.sourceSentenceIndex,
      sourceHash: _hash('$context${source.prompt}'),
      syntaxPattern: _syntax('$context${source.prompt}'),
      operationType: signature.operationType,
      errorFamily: source.grammarFamily ?? signature.errorFamily,
      gapType: signature.gapType,
      answerShape: signature.answerShape,
      distractorStrategy:
          '${signature.distractorStrategy} / Lv${level.clamp(1, 10)} context',
      blankPositionPattern: signature.blankPositionPattern,
    ),
  );
}

StoryChallengeQuestion _secondStoryGrammar(
  StoryChallengeQuestion source, {
  required int level,
  required int index,
}) {
  final i = level.clamp(1, 10).toInt() - 1;
  final target = source.options.indexOf(source.answer);
  final targetIndex = target < 0 ? index % 4 : target;
  return switch (index) {
    0 => _associationGrammar(source, i, targetIndex),
    1 => _collocationGrammar(source, i, targetIndex),
    2 => _redundancyGrammar(source, i, targetIndex),
    _ => _missingComponentGrammar(source, i, targetIndex),
  };
}

StoryChallengeQuestion _associationGrammar(
  StoryChallengeQuestion source,
  int levelIndex,
  int target,
) {
  final fact = _secondFacts[levelIndex];
  final conclusion = _secondConclusions[levelIndex];
  final broken = '虽然$fact，所以$conclusion。';
  final correct = '因为$fact，所以$conclusion。';
  final raw = <String>[
    correct,
    '虽然$fact，所以$conclusion。',
    '因为$fact，但是$conclusion。',
    '不但$fact，所以$conclusion。',
  ];
  return _grammarQuestion(
    source,
    levelIndex: levelIndex,
    family: '关联词错误',
    broken: broken,
    correct: correct,
    errorSegments: ['虽然', '$fact，', '所以$conclusion', '。'],
    errorSegmentIndex: 0,
    rawOptions: raw,
    rawExplanations: const [
      '对。“因为……所以……”准确表达事实依据与结论之间的因果关系。',
      '错。“虽然……所以……”把让步和因果关联词混在一起。',
      '错。“因为……但是……”把因果和转折关系混在一起。',
      '错。“不但……所以……”不是规范的关联词配对。',
    ],
    whyWrong: '“虽然”表示让步或转折，不能和表达结果的“所以”组成这里需要的因果关系。',
    revisionRule: '先判断句子的逻辑关系，再选择成套、匹配的关联词。',
    target: target,
  );
}

StoryChallengeQuestion _collocationGrammar(
  StoryChallengeQuestion source,
  int levelIndex,
  int target,
) {
  final object = _secondObjects[levelIndex];
  final broken = '林乔和许澄制造$object。';
  final correct = '林乔和许澄核对$object。';
  return _grammarQuestion(
    source,
    levelIndex: levelIndex,
    family: '搭配错误',
    broken: broken,
    correct: correct,
    errorSegments: ['林乔和许澄', '制造', object, '。'],
    errorSegmentIndex: 1,
    rawOptions: [
      correct,
      broken,
      '林乔和许澄生产$object。',
      '林乔和许澄发明$object。',
    ],
    rawExplanations: const [
      '对。“核对记录 / 证据”符合故事中的工作动作和自然动宾搭配。',
      '错。“制造记录 / 方位证据”不能表达把已有资料进行比对检查。',
      '错。“生产”用于制造产品，不适合这里的记录核查动作。',
      '错。“发明”表示创造新事物，不是核验已有信息。',
    ],
    whyWrong: '这里处理的是已有记录和空间证据，动作应是“核对”，不能用“制造”。',
    revisionRule: '动词必须与宾语和真实任务形成自然、准确的搭配。',
    target: target,
  );
}

StoryChallengeQuestion _redundancyGrammar(
  StoryChallengeQuestion source,
  int levelIndex,
  int target,
) {
  final action = _secondActions[levelIndex];
  final broken = '两人一起共同$action。';
  final correct = '两人一起$action。';
  return _grammarQuestion(
    source,
    levelIndex: levelIndex,
    family: '成分赘余',
    broken: broken,
    correct: correct,
    errorSegments: ['两人', '一起共同', action, '。'],
    errorSegmentIndex: 1,
    rawOptions: [
      correct,
      broken,
      '两人共同一起$action。',
      '两人一起共同都$action。',
    ],
    rawExplanations: const [
      '对。保留“一起”已经能表达共同完成动作，句子简洁完整。',
      '错。“一起”和“共同”语义重复。',
      '错。交换“一起 / 共同”的位置仍然没有消除重复。',
      '错。“一起、共同、都”叠加造成更明显的赘余。',
    ],
    whyWrong: '“一起”和“共同”表达相同的共同动作含义，同时保留造成语义重复。',
    revisionRule: '重复表达同一意义的成分只保留一个。',
    target: target,
  );
}

StoryChallengeQuestion _missingComponentGrammar(
  StoryChallengeQuestion source,
  int levelIndex,
  int target,
) {
  final object = _secondWriteObjects[levelIndex];
  final broken = '许澄把$object写。';
  final correct = '许澄把$object写在页边。';
  return _grammarQuestion(
    source,
    levelIndex: levelIndex,
    family: '成分缺失',
    broken: broken,
    correct: correct,
    errorSegments: ['许澄把', object, '写', '。'],
    errorSegmentIndex: 2,
    rawOptions: [
      correct,
      broken,
      '许澄把$object在页边。',
      '许澄把$object写在。',
    ],
    rawExplanations: const [
      '对。“写在页边”补足动作的处所，句意和交接记录动作都完整。',
      '错。“写”后缺少必要的处所补语，动作没有说完整。',
      '错。句子有处所却缺少核心动作“写”。',
      '错。“写在”后缺少处所宾语，句子仍不完整。',
    ],
    whyWrong: '“把”字句中的处理动作没有说完整；只说“写”不能交代记录落在哪里。',
    revisionRule: '补足动作所需要的处所或结果成分，使“把”字句表达完整。',
    target: target,
  );
}

StoryChallengeQuestion _grammarQuestion(
  StoryChallengeQuestion source, {
  required int levelIndex,
  required String family,
  required String broken,
  required String correct,
  required List<String> errorSegments,
  required int errorSegmentIndex,
  required List<String> rawOptions,
  required List<String> rawExplanations,
  required String whyWrong,
  required String revisionRule,
  required int target,
}) {
  if (errorSegments.join() != broken) {
    throw StateError('Second Story grammar segments must reconstruct prompt');
  }
  if (rawOptions.length != 4 ||
      rawExplanations.length != 4 ||
      rawOptions.toSet().length != 4) {
    throw StateError('Second Story grammar requires four unique options');
  }
  final order = <int>[1, 2, 3]..insert(target.clamp(0, 3), 0);
  final options = <String>[for (final index in order) rawOptions[index]];
  final explanations = <String>[
    for (final index in order) rawExplanations[index],
  ];
  final signature = source.signature;
  return StoryChallengeQuestion(
    id: source.id,
    mode: StoryChallengeMode.grammarRepair,
    sourceSentence: correct,
    prompt: broken,
    answer: correct,
    options: List<String>.unmodifiable(options),
    errorSegments: List<String>.unmodifiable(errorSegments),
    errorSegmentIndex: errorSegmentIndex,
    grammarFamily: family,
    grammarWhyWrong: whyWrong,
    grammarRevisionRule: revisionRule,
    grammarOptionExplanations: List<String>.unmodifiable(explanations),
    narrationText: broken,
    signature: QuestionDesignSignature(
      journeyId: signature.journeyId,
      sessionLevel: signature.sessionLevel,
      mode: StoryChallengeMode.grammarRepair,
      sourceParagraphIndex: signature.sourceParagraphIndex,
      sourceSentenceIndex: signature.sourceSentenceIndex,
      sourceHash: _hash(broken),
      syntaxPattern: _syntax(broken),
      operationType: '完整病句→定位错误→选择完整修正',
      errorFamily: family,
      gapType: signature.gapType,
      answerShape: '完整修正句',
      distractorStrategy:
          'Second Story Lv${levelIndex + 1} $family plausible repairs',
      blankPositionPattern: signature.blankPositionPattern,
    ),
  );
}

const _protectedTerms = <String>[
  '故宫博物院',
  '紫禁城',
  '乾清门',
  '景运门',
  '午门',
  '中轴',
  '外朝',
  '内廷',
  '交接记录',
  '待核项目',
  '空间关系',
  '建筑文物',
  '宫廷文物',
];

List<String> _chunks(String sentence, int level) {
  final terms = [..._protectedTerms]
    ..sort((a, b) => b.length.compareTo(a.length));
  final result = <String>[];
  var cursor = 0;
  final width = level >= 7 ? 1 : level >= 4 ? 2 : 3;
  while (cursor < sentence.length) {
    String? protected;
    for (final term in terms) {
      if (sentence.startsWith(term, cursor)) {
        protected = term;
        break;
      }
    }
    if (protected != null) {
      result.add(protected);
      cursor += protected.length;
      continue;
    }
    var nextProtected = sentence.length;
    for (final term in terms) {
      final next = sentence.indexOf(term, cursor);
      if (next > cursor && next < nextProtected) nextProtected = next;
    }
    final remaining = nextProtected - cursor;
    final take = remaining.clamp(1, width).toInt();
    result.add(sentence.substring(cursor, cursor + take));
    cursor += take;
  }
  return result;
}

List<String> _scramble(List<String> chunks, int index, int level) {
  final result = List<String>.of(chunks.reversed);
  if (result.length > 2) {
    final shift = (index + level) % result.length;
    return <String>[...result.skip(shift), ...result.take(shift)];
  }
  return result;
}

int _hanCount(String value) =>
    RegExp(r'[\u3400-\u9fff]').allMatches(value).length;

String _hash(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

String _syntax(String sentence) {
  if (sentence.contains('把')) return '把字句';
  if (sentence.contains(RegExp(r'因为|所以|因此'))) return '因果结构';
  if (sentence.contains(RegExp(r'却|但是|而'))) return '转折结构';
  if (sentence.startsWith(RegExp(r'当|后来|随后|这时|为了'))) {
    return '时间目的前置';
  }
  if (sentence.contains('，')) return '复句';
  return '主谓宾';
}
