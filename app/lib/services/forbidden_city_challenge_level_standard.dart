import '../models/journey_challenge.dart';

const _primaryStoryChallengeId = 'beijing-forbidden-city';

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


StoryChallengeSet applyForbiddenCityLevelChallengeStandard(
  StoryChallengeSet source,
) {
  if (source.journeyId != _primaryStoryChallengeId) {
    return source;
  }

  var rebuildIndex = 0;
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
          _contextualizePrimaryGrammar(
            question,
            level: source.sessionLevel,
          ),
        );
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
  final sentence = _primaryRebuildLevels[safeLevel - 1][index].sentence;
  final han = _hanCount(sentence);
  if (han == 0 || han > 10) {
    throw StateError(
        '$journeyId Lv$safeLevel rebuild-$index has $han Han chars');
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
    prompt: '复原一条与北京 · 紫禁城相关的知识句',
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
  if (journeyId != _primaryStoryChallengeId) {
    throw ArgumentError.value(journeyId, 'journeyId');
  }
  return primary[index];
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


const _protectedTerms = <String>[
  '故宫博物院',
  '紫禁城',
  '乾清门',
  '午门',
  '中轴',
  '外朝',
  '内廷',
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
