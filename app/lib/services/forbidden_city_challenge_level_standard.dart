import '../data/forbidden_city_story_runtime.dart';
import '../models/journey_challenge.dart';
import 'challenge_option_balancer.dart';

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
    _RebuildSpec('乾清门连接不同路线图'),
    _RebuildSpec('故宫文物补充建筑证据'),
  ],
  [
    _RebuildSpec('中轴秩序并不等于路径'),
    _RebuildSpec('午门入口不是唯一路径'),
    _RebuildSpec('乾清门可汇合不同任务'),
    _RebuildSpec('故宫博物院用文物释史'),
  ],
  [
    _RebuildSpec('中轴框架服务空间关系'),
    _RebuildSpec('午门起点取决观察任务'),
    _RebuildSpec('乾清门是任务汇合点'),
    _RebuildSpec('故宫史料来自建筑文物'),
  ],
  [
    _RebuildSpec('中轴框架并非行动路径'),
    _RebuildSpec('午门序列不是唯一答案'),
    _RebuildSpec('乾清门需结合任务辨识'),
    _RebuildSpec('故宫博物院以文物释史'),
  ],
  [
    _RebuildSpec('中轴资料不能替代目标'),
    _RebuildSpec('午门路径需要说明任务'),
    _RebuildSpec('乾清门衔接需结合史料'),
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
    _RebuildSpec('更正前保留景运门旧证'),
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
    _RebuildSpec('景运门待核项不能先改'),
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
  '更正时才能保留错误来源',
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
  '保留景运门旧表错误标记',
  '区分紫禁城已确认项和待核项',
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
  var completionIndex = 0;
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
        break;
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
        break;
      case StoryChallengeMode.storyCompletion:
        questions.add(
          source.journeyId == _secondStoryChallengeId
              ? _secondStoryCompletion(
                  question,
                  level: source.sessionLevel,
                  index: completionIndex,
                )
              : question,
        );
        completionIndex += 1;
        break;
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
  final safeLevel = _requireLevel(level);
  final levels = journeyId == _primaryStoryChallengeId
      ? _primaryRebuildLevels
      : _secondRebuildLevels;
  if (index < 0 || index >= 4) {
    throw StateError('$journeyId Lv$safeLevel requires four Rebuild questions.');
  }
  final sentence = levels[safeLevel - 1][index].sentence;
  final han = _hanCount(sentence);
  if (han == 0 || han > 10) {
    throw StateError(
      '$journeyId Lv$safeLevel rebuild-$index has $han Han chars',
    );
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
    characterTiles:
        List<String>.unmodifiable(_scramble(chunks, index, safeLevel)),
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
      operationType: _rebuildPedagogy(journeyId, index),
      errorFamily: signature.errorFamily,
      gapType: signature.gapType,
      answerShape: '$han字 / ${chunks.length}块',
      distractorStrategy: 'Lv$safeLevel Story-specific semantic chunks',
      blankPositionPattern: signature.blankPositionPattern,
    ),
  );
}

String _rebuildPedagogy(String journeyId, int index) {
  const primary = <String>[
    '宫门位置知识句重建',
    '中轴空间关系知识句重建',
    '内外廷建筑关系知识句重建',
    '故宫历史证据知识句重建',
  ];
  const second = <String>[
    '紫禁城空间框架知识句重建',
    '景运门方位知识句重建',
    '乾清门空间证据知识句重建',
    '交接核对证据知识句重建',
  ];
  return (journeyId == _primaryStoryChallengeId ? primary : second)[index];
}

StoryChallengeQuestion _contextualizePrimaryGrammar(
  StoryChallengeQuestion source, {
  required int level,
}) {
  final safeLevel = _requireLevel(level);
  final context = _primaryGrammarContexts[safeLevel - 1];
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
          '${signature.distractorStrategy} / Lv$safeLevel context',
      blankPositionPattern: signature.blankPositionPattern,
    ),
  );
}

StoryChallengeQuestion _secondStoryGrammar(
  StoryChallengeQuestion source, {
  required int level,
  required int index,
}) {
  final safeLevel = _requireLevel(level);
  if (index < 0 || index >= 4) {
    throw StateError('Second Story Lv$safeLevel requires four Grammar questions.');
  }
  final i = safeLevel - 1;
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
  return _grammarQuestion(
    source,
    levelIndex: levelIndex,
    family: '关联词错误',
    broken: broken,
    correct: correct,
    errorSegments: ['虽然', '$fact，', '所以', '$conclusion。'],
    errorSegmentIndex: 0,
    rawOptions: [
      correct,
      '虽然$fact，但是$conclusion。',
      '如果$fact，那么$conclusion。',
      '即使$fact，也$conclusion。',
    ],
    rawExplanations: const [
      '对。“因为……所以……”准确表达事实依据与结论之间的因果关系。',
      '错。句子变成让步转折关系，弱化了这里明确的事实依据与结果。',
      '错。把已经确认的事实改成假设条件，改变了证据状态。',
      '错。让步关系表示即便条件成立也有结果，不符合这里的核对逻辑。',
    ],
    whyWrong: '“虽然”表示让步，不能和这里需要的确定因果结论“所以”混用。',
    revisionRule: '先判断事实与结论的逻辑关系，再选择完整、成套的关联结构。',
    target: target,
  );
}

StoryChallengeQuestion _collocationGrammar(
  StoryChallengeQuestion source,
  int levelIndex,
  int target,
) {
  final object = _secondObjects[levelIndex];
  final broken = '林乔和许澄制造$object，并准备交接。';
  final correct = '林乔和许澄核对$object，并准备交接。';
  return _grammarQuestion(
    source,
    levelIndex: levelIndex,
    family: '搭配错误',
    broken: broken,
    correct: correct,
    errorSegments: ['林乔和许澄', '制造', object, '，并准备交接。'],
    errorSegmentIndex: 1,
    rawOptions: [
      correct,
      '林乔和许澄整理$object，并准备交接。',
      '林乔和许澄抄录$object，并准备交接。',
      '林乔和许澄归档$object，并准备交接。',
    ],
    rawExplanations: const [
      '对。“核对记录 / 证据”准确表达把已有资料进行比对检查。',
      '错。“整理”可以处理材料，但没有表达验证信息是否一致。',
      '错。“抄录”只是复制内容，不能完成证据核验。',
      '错。“归档”是保存步骤，不是确认记录真伪和一致性的动作。',
    ],
    whyWrong: '这里处理的是已有记录和空间证据，核心动作应是“核对”，不能用“制造”。',
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
  final broken = '两人一起共同$action，随后记录结果。';
  final correct = '两人一起$action，随后记录结果。';
  return _grammarQuestion(
    source,
    levelIndex: levelIndex,
    family: '成分赘余',
    broken: broken,
    correct: correct,
    errorSegments: ['两人', '一起共同', action, '，随后记录结果。'],
    errorSegmentIndex: 1,
    rawOptions: [
      correct,
      broken,
      '两人共同一起$action，随后记录结果。',
      '两人一起又共同$action，随后记录结果。',
    ],
    rawExplanations: const [
      '对。保留“一起”已经能表达共同动作，句子简洁完整。',
      '错。“一起”和“共同”重复表达同一关系。',
      '错。交换“一起 / 共同”的顺序仍然没有消除重复。',
      '错。“一起、又、共同”叠加，让赘余更明显。',
    ],
    whyWrong: '“一起”和“共同”表达相同的共同动作含义，同时保留造成语义重复。',
    revisionRule: '重复表达同一意义的成分只保留一个，同时保持句子完整。',
    target: target,
  );
}

StoryChallengeQuestion _missingComponentGrammar(
  StoryChallengeQuestion source,
  int levelIndex,
  int target,
) {
  final object = _secondWriteObjects[levelIndex];
  final broken = '交接前，许澄把$object写，却没有说明记录位置。';
  final correct = '交接前，许澄把$object写在页边，并保留核对依据。';
  return _grammarQuestion(
    source,
    levelIndex: levelIndex,
    family: '成分缺失',
    broken: broken,
    correct: correct,
    errorSegments: ['交接前，', '许澄把$object', '写，', '却没有说明记录位置。'],
    errorSegmentIndex: 2,
    rawOptions: [
      correct,
      '交接前，许澄把$object写在封面，并保留核对依据。',
      '交接前，许澄把$object抄到新页，并保留核对依据。',
      '交接前，许澄把$object写进标题，并保留核对依据。',
    ],
    rawExplanations: const [
      '对。“写在页边”补足记录位置，也符合故事中保留原记录和核对依据的动作。',
      '错。句子完整，但把核对信息放在封面不符合当前记录语境。',
      '错。句子完整，但“抄到新页”会弱化保留原位置与原标记的追溯关系。',
      '错。句子完整，但标题不是记录具体疑问或更正依据的合理位置。',
    ],
    whyWrong: '原句只说“写”，没有补足记录落在哪里，导致把字句动作信息不完整。',
    revisionRule: '补足动作所需要的处所成分，并让修正后的句子符合当前 Story 的记录方式。',
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
  if (errorSegments.join() != broken ||
      errorSegments.length != 4 ||
      errorSegmentIndex < 0 ||
      errorSegmentIndex >= errorSegments.length) {
    throw StateError('Second Story grammar segmentation contract failed.');
  }
  final punctuationOnly = RegExp(r'^[。，！？：；,.!?;:]+$');
  if (errorSegments.any(
    (segment) =>
        segment.trim().isEmpty || punctuationOnly.hasMatch(segment.trim()),
  )) {
    throw StateError(
      'Second Story Grammar Step 1 requires meaningful grammatical segments.',
    );
  }
  if (rawOptions.length != 4 ||
      rawExplanations.length != 4 ||
      rawOptions.toSet().length != 4 ||
      rawOptions.where((option) => option == correct).length != 1 ||
      rawOptions.any(
        (option) =>
            option.trim().isEmpty ||
            !RegExp(r'[。！？!?]$').hasMatch(option.trim()) ||
            _looksLikeBrokenRepair(option),
      )) {
    throw StateError(
      'Second Story Grammar Step 2 requires four complete plausible candidates.',
    );
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

bool _looksLikeBrokenRepair(String value) {
  final text = value.trim();
  return text.endsWith('写。') ||
      text.endsWith('写在。') ||
      text.endsWith('内廷往。') ||
      text.contains('，所以。');
}

class _CompletionLexeme {
  const _CompletionLexeme(this.value, this.slot);
  final String value;
  final String slot;
}

const _secondCompletionLexemes = <_CompletionLexeme>[
  _CompletionLexeme('下一位接手者', 'PERSON'),
  _CompletionLexeme('接手的人', 'PERSON'),
  _CompletionLexeme('林乔', 'PERSON'),
  _CompletionLexeme('许澄', 'PERSON'),
  _CompletionLexeme('景运门', 'PLACE'),
  _CompletionLexeme('乾清门', 'PLACE'),
  _CompletionLexeme('紫禁城', 'PLACE'),
  _CompletionLexeme('广场', 'PLACE'),
  _CompletionLexeme('东侧位置', 'DIRECTION'),
  _CompletionLexeme('东侧方位', 'DIRECTION'),
  _CompletionLexeme('东侧', 'DIRECTION'),
  _CompletionLexeme('西侧', 'DIRECTION'),
  _CompletionLexeme('中轴', 'FRAME'),
  _CompletionLexeme('整体空间框架', 'FRAME'),
  _CompletionLexeme('空间框架', 'FRAME'),
  _CompletionLexeme('空间序列', 'FRAME'),
  _CompletionLexeme('核对', 'ACTION'),
  _CompletionLexeme('更正', 'ACTION'),
  _CompletionLexeme('留空', 'ACTION'),
  _CompletionLexeme('确认', 'ACTION'),
  _CompletionLexeme('记录', 'ACTION'),
  _CompletionLexeme('保留', 'ACTION'),
  _CompletionLexeme('追查', 'ACTION'),
  _CompletionLexeme('接手', 'ACTION'),
  _CompletionLexeme('签字', 'ACTION'),
  _CompletionLexeme('复核', 'ACTION'),
  _CompletionLexeme('记录册', 'RECORD'),
  _CompletionLexeme('待核项目', 'RECORD'),
  _CompletionLexeme('待核标记', 'RECORD'),
  _CompletionLexeme('核对依据', 'RECORD'),
  _CompletionLexeme('确认结果', 'RECORD'),
  _CompletionLexeme('原记录', 'RECORD'),
  _CompletionLexeme('原标记', 'RECORD'),
  _CompletionLexeme('页码', 'RECORD'),
  _CompletionLexeme('疑问', 'RECORD'),
  _CompletionLexeme('空格', 'RECORD'),
  _CompletionLexeme('证据', 'RECORD'),
  _CompletionLexeme('结论', 'RECORD'),
  _CompletionLexeme('已确认', 'STATE'),
  _CompletionLexeme('不确定处', 'STATE'),
  _CompletionLexeme('不确定', 'STATE'),
  _CompletionLexeme('待核', 'STATE'),
  _CompletionLexeme('已核', 'STATE'),
  _CompletionLexeme('外朝', 'RELATION'),
  _CompletionLexeme('内廷', 'RELATION'),
  _CompletionLexeme('空间关系', 'RELATION'),
  _CompletionLexeme('连接关系', 'RELATION'),
  _CompletionLexeme('方位', 'RELATION'),
];

class _CompletionSpan {
  const _CompletionSpan(this.start, this.end, this.lexeme);
  final int start;
  final int end;
  final _CompletionLexeme lexeme;
}

StoryChallengeQuestion _secondStoryCompletion(
  StoryChallengeQuestion source, {
  required int level,
  required int index,
}) {
  final safeLevel = _requireLevel(level);
  if (index < 0 || index >= 4) {
    throw StateError(
      'Second Story Lv$safeLevel requires four Story Completion questions.',
    );
  }

  final passage = _secondCompletionPassage(safeLevel, index);
  final spans = _completionSpans(passage);
  if (spans.length < safeLevel) {
    throw StateError(
      'Second Story Lv$safeLevel completion-$index has only '
      '${spans.length} semantic blank candidates.',
    );
  }

  final selected = _spreadCompletionSpans(spans, safeLevel, index);
  final positions = balancedChallengeAnswerPositions(
    itemCount: safeLevel * 4,
    seed: '$_secondStoryChallengeId:$safeLevel:completion',
    variationOrdinal: safeLevel,
  );

  final segments = <String>[];
  final blanks = <StoryCompletionBlank>[];
  var cursor = 0;
  for (var blankIndex = 0; blankIndex < selected.length; blankIndex += 1) {
    final span = selected[blankIndex];
    segments.add(passage.substring(cursor, span.start));
    final answer = passage.substring(span.start, span.end);
    final slot = span.lexeme.slot;
    final target = positions[index * safeLevel + blankIndex];
    final options = _completionOptions(
      answer: answer,
      slot: slot,
      target: target,
      seed: '$safeLevel:$index:$blankIndex',
    );
    blanks.add(
      StoryCompletionBlank(
        answer: answer,
        options: List<String>.unmodifiable(options),
        answerType: _answerType(answer),
        semanticSlotType: slot,
        sourceStart: span.start,
      ),
    );
    cursor = span.end;
  }
  segments.add(passage.substring(cursor));

  final rebuilt = StringBuffer();
  for (var i = 0; i < blanks.length; i += 1) {
    rebuilt
      ..write(segments[i])
      ..write(blanks[i].answer);
  }
  rebuilt.write(segments.last);
  if (rebuilt.toString() != passage) {
    throw StateError(
      'Second Story Lv$safeLevel completion-$index cannot restore its natural passage.',
    );
  }

  final prompt = StringBuffer();
  for (var i = 0; i < blanks.length; i += 1) {
    prompt
      ..write(segments[i])
      ..write('〔${i + 1}〕____');
  }
  prompt.write(segments.last);

  final signature = source.signature;
  return StoryChallengeQuestion(
    id: source.id,
    mode: StoryChallengeMode.storyCompletion,
    sourceSentence: passage,
    prompt: prompt.toString(),
    answer: passage,
    options: const <String>[],
    characterTiles: source.characterTiles,
    errorSegments: source.errorSegments,
    errorSegmentIndex: source.errorSegmentIndex,
    grammarFamily: source.grammarFamily,
    grammarWhyWrong: source.grammarWhyWrong,
    grammarRevisionRule: source.grammarRevisionRule,
    grammarOptionExplanations: source.grammarOptionExplanations,
    completionSegments: List<String>.unmodifiable(segments),
    completionBlanks: List<StoryCompletionBlank>.unmodifiable(blanks),
    narrationText: prompt.toString().replaceAll('____', '空位'),
    signature: QuestionDesignSignature(
      journeyId: signature.journeyId,
      sessionLevel: safeLevel,
      mode: StoryChallengeMode.storyCompletion,
      sourceParagraphIndex: signature.sourceParagraphIndex,
      sourceSentenceIndex: signature.sourceSentenceIndex,
      sourceHash: _hash(passage),
      syntaxPattern: _syntax(passage),
      operationType: 'Story 语义槽多空位选择填空',
      errorFamily: signature.errorFamily,
      gapType: '多空位选择填空',
      answerShape: blanks.map((blank) => blank.semanticSlotType).toSet().join('+'),
      distractorStrategy:
          'Second Story Lv$safeLevel same-slot plausible distractors',
      blankPositionPattern: 'semantic-spread-${index + 1}',
    ),
  );
}

String _secondCompletionPassage(int level, int index) {
  final paragraphs =
      forbiddenCitySecondStoryChallengeSourceMaterialForLevel(level);
  final sentences = <String>[
    for (final paragraph in paragraphs)
      ...RegExp(r'[^。！？!?]+[。！？!?]')
          .allMatches(paragraph)
          .map((match) => match.group(0)!.trim()),
  ];
  if (sentences.length < 4) {
    throw StateError('Second Story Lv$level requires at least four Story sentences.');
  }

  var passage = '';
  var cursor = 0;
  while (_completionSpans(passage).length < level || cursor < 2) {
    if (cursor >= sentences.length) {
      throw StateError(
        'Second Story Lv$level Story cannot supply $level semantic Completion blanks.',
      );
    }
    passage += sentences[(index + cursor) % sentences.length];
    cursor += 1;
  }
  return passage;
}

List<_CompletionSpan> _completionSpans(String passage) {
  if (passage.isEmpty) return const <_CompletionSpan>[];
  final lexemes = [..._secondCompletionLexemes]
    ..sort((a, b) => b.value.length.compareTo(a.value.length));
  final spans = <_CompletionSpan>[];
  var cursor = 0;
  while (cursor < passage.length) {
    _CompletionLexeme? match;
    for (final lexeme in lexemes) {
      if (passage.startsWith(lexeme.value, cursor)) {
        match = lexeme;
        break;
      }
    }
    if (match == null) {
      cursor += 1;
      continue;
    }
    spans.add(_CompletionSpan(cursor, cursor + match.value.length, match));
    cursor += match.value.length;
  }
  return spans;
}

List<_CompletionSpan> _spreadCompletionSpans(
  List<_CompletionSpan> spans,
  int count,
  int index,
) {
  if (count == 1) {
    return <_CompletionSpan>[spans[index % spans.length]];
  }
  final selected = <int>{};
  for (var i = 0; i < count; i += 1) {
    final position = ((i * (spans.length - 1)) / (count - 1)).round();
    selected.add((position + index) % spans.length);
  }
  var probe = index;
  while (selected.length < count) {
    selected.add(probe % spans.length);
    probe += 1;
  }
  final result = selected.map((i) => spans[i]).toList()
    ..sort((a, b) => a.start.compareTo(b.start));
  return result.take(count).toList(growable: false);
}

List<String> _completionOptions({
  required String answer,
  required String slot,
  required int target,
  required String seed,
}) {
  final pool = _secondCompletionLexemes
      .where((item) => item.slot == slot && item.value != answer)
      .map((item) => item.value)
      .toSet()
      .toList(growable: false);
  if (pool.length < 3) {
    throw StateError('Second Story Completion slot $slot lacks distractors.');
  }
  pool.sort((a, b) {
    final lengthA = (_hanCount(a) - _hanCount(answer)).abs();
    final lengthB = (_hanCount(b) - _hanCount(answer)).abs();
    if (lengthA != lengthB) return lengthA.compareTo(lengthB);
    return _hash('$seed:$a').compareTo(_hash('$seed:$b'));
  });
  final options = pool.take(3).toList(growable: true);
  options.insert(target.clamp(0, 3), answer);
  if (options.length != 4 ||
      options.toSet().length != 4 ||
      options.where((item) => item == answer).length != 1) {
    throw StateError('Second Story Completion option invariant failed.');
  }
  return options;
}

String _answerType(String answer) {
  final count = _hanCount(answer);
  if (count <= 1) return '字';
  if (count <= 2) return '词';
  return '短语';
}

int _requireLevel(int level) {
  if (level < 1 || level > 10) {
    throw StateError('Forbidden City Challenge requires Lv1-Lv10, got $level');
  }
  return level;
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
  final width = level >= 7
      ? 1
      : level >= 4
          ? 2
          : 3;
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
