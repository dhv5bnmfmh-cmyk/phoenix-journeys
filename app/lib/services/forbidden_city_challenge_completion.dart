import '../models/journey_challenge.dart';

const primaryForbiddenCityJourneyId = 'beijing-forbidden-city';
const secondForbiddenCityStoryId =
    'story.forbidden_city.modern_evidence_handoff.v1';

const _primaryEvenRebuild = <List<String>?>[
  null,
  <String>['午门居紫禁城南端', '中轴连接宫门院落', '乾清门通向内廷', '故宫保存宫廷文物'],
  null,
  <String>['中轴贯通宫城南北', '午门标出中轴南端', '乾清门衔接内外廷', '故宫古建保存至今'],
  null,
  <String>['中轴提供观察顺序', '午门开启外朝序列', '乾清门连接内外廷', '景运门位于广场东侧'],
  null,
  <String>['中轴骨架容纳侧路', '午门礼制影响通行', '乾清门汇合多条路线', '景运门连接东侧空间'],
  null,
  <String>['中轴框架需结合任务', '午门通行受礼制限制', '乾清门节点连接多向', '景运门方位可核对'],
];

const _secondRebuild = <List<String>>[
  <String>['景运门在广场东侧', '乾清门连接内外廷', '中轴串起主要宫门', '午门是紫禁城正门'],
  <String>['景运门位于乾清门东侧', '乾清门是内廷正门', '中轴组织宫城空间', '午门位于中轴南端'],
  <String>['广场东侧可见景运门', '乾清门连接两类空间', '中轴说明南北次序', '午门开启宫城序列'],
  <String>['景运门方位要先核对', '乾清门处在内外廷间', '中轴不是具体宫门', '午门和中轴信息不同'],
  <String>['核对景运门要看东侧', '乾清门是空间节点', '中轴帮助判断方位', '午门提供入口坐标'],
  <String>['记录更正前先核方位', '景运门东侧位置可核', '乾清门连接内外廷', '中轴提供空间骨架'],
  <String>['疑点要与空间证据核对', '景运门位置需看广场', '乾清门标明转换节点', '中轴不能代替方位'],
  <String>['交接记录应保留疑问', '景运门更正要留旧表', '乾清门关系需能复核', '中轴判断要结合节点'],
  <String>['核对要同时看门与方向', '景运门东侧是空间证据', '乾清门连接关系可查', '中轴是框架不是路线'],
  <String>['记录结论必须可以复核', '景运门方位要有证据', '乾清门节点连接多向', '中轴框架不能替代核对'],
];

const _primaryRelation = <String>[
  '午门位于中轴南端。',
  '中轴连接宫门院落。',
  '乾清门连接外朝内廷。',
  '景运门位于广场东侧。',
  '中轴帮助判断空间层级。',
  '午门开启外朝空间序列。',
  '乾清门是重要转换节点。',
  '侧向宫门补充中轴连接。',
  '路线判断要结合空间证据。',
  '通行判断还要考虑礼制。',
];

const _primaryCollocation = <String>[
  '乾清门连接外朝与内廷。',
  '景运门连接东侧空间。',
  '中轴连接主要宫门。',
  '乾清门连接南北空间。',
  '宫门连接不同院落。',
  '中轴连接连续空间。',
  '乾清门连接多向通路。',
  '侧门连接中轴节点。',
  '乾清门连接功能与空间。',
  '景运门连接东侧区域。',
];

const _primaryRedundancy = <String>[
  '沈砚和阿宁一起核对路线。',
  '沈砚和阿宁一起查看宫门。',
  '沈砚和阿宁一起比较方向。',
  '沈砚和阿宁一起检查节点。',
  '沈砚和阿宁一起整理图页。',
  '沈砚和阿宁一起核实路线。',
  '沈砚和阿宁一起比较任务。',
  '沈砚和阿宁一起补充证据。',
  '沈砚和阿宁一起复核判断。',
  '沈砚和阿宁一起说明依据。',
];

const _primaryMissing = <String>[
  '沈砚把中轴标在图上。',
  '阿宁把东侧路线画在图上。',
  '沈砚把宫门写在图上。',
  '阿宁把节点标在图上。',
  '沈砚把任务写在图边。',
  '阿宁把路线画在图中。',
  '沈砚把证据标在图上。',
  '阿宁把方向写在图边。',
  '沈砚把判断写在图旁。',
  '阿宁把依据标在图上。',
];

const _secondRelation = <String>[
  '景运门在广场东侧。',
  '乾清门连接外朝内廷。',
  '中轴组织宫城空间。',
  '午门位于中轴南端。',
  '景运门方位可以核对。',
  '核对记录要先看位置。',
  '交接前要保留疑问。',
  '更正记录要留下过程。',
  '中轴不能替代方位核对。',
  '空间判断必须可以复核。',
];

const _secondCollocation = <String>[
  '乾清门连接外朝与内廷。',
  '景运门连接东侧空间。',
  '中轴连接主要宫门。',
  '乾清门连接南北空间。',
  '宫门连接不同院落。',
  '中轴连接连续空间。',
  '乾清门连接多向通路。',
  '景运门连接东侧区域。',
  '乾清门连接功能与空间。',
  '中轴连接门与院落。',
];

const _secondRedundancy = <String>[
  '林乔和许澄一起核对记录。',
  '林乔和许澄一起检查页码。',
  '林乔和许澄一起查看旧表。',
  '林乔和许澄一起确认方位。',
  '林乔和许澄一起更正记录。',
  '林乔和许澄一起保留疑问。',
  '林乔和许澄一起复核图页。',
  '林乔和许澄一起检查空格。',
  '林乔和许澄一起核实位置。',
  '林乔和许澄一起完成交接。',
];

const _secondMissing = <String>[
  '许澄把疑问写在页边。',
  '林乔把更正写在旧表上。',
  '许澄把景运门标在图页上。',
  '林乔把东侧写在记录里。',
  '许澄把空格标在表上。',
  '林乔把签名写在更正旁。',
  '许澄把待核项写在页边。',
  '林乔把旧表编号写在页边。',
  '许澄把位置写在记录里。',
  '林乔把结论写在册子上。',
];

StoryChallengeQuestion completeForbiddenCityRebuildQuestion({
  required StoryChallengeQuestion source,
  required String journeyId,
  required int sessionLevel,
  required int index,
}) {
  final level = sessionLevel.clamp(1, 10).toInt();
  String? sentence;
  if (journeyId == primaryForbiddenCityJourneyId) {
    sentence = _primaryEvenRebuild[level - 1]?[index];
    if (sentence == null) return source;
  } else if (journeyId == secondForbiddenCityStoryId) {
    sentence = _secondRebuild[level - 1][index];
  } else {
    return source;
  }

  if (_hanCount(sentence) > 10) {
    throw StateError('Founder Sentence Rebuild exceeds 10 Han: $sentence');
  }
  final tiles = _scramble(_semanticChunks(sentence), level + index);
  return StoryChallengeQuestion(
    id: source.id,
    mode: StoryChallengeMode.sentenceRebuild,
    sourceSentence: '$sentence。',
    prompt: '复原一条与北京 · 紫禁城相关的知识句',
    answer: sentence,
    options: const <String>[],
    characterTiles: List<String>.unmodifiable(tiles),
    narrationText: '$sentence。',
    signature: QuestionDesignSignature(
      journeyId: source.signature.journeyId,
      sessionLevel: level,
      mode: StoryChallengeMode.sentenceRebuild,
      sourceParagraphIndex: source.signature.sourceParagraphIndex,
      sourceSentenceIndex: source.signature.sourceSentenceIndex,
      sourceHash: _hash('$sentence。'),
      syntaxPattern: _syntax(sentence),
      operationType: '北京·紫禁城知识句语义块顺序恢复',
      errorFamily: null,
      gapType: null,
      answerShape: '${_hanCount(sentence)}字 / ${tiles.length}块',
      distractorStrategy: 'Lv$level Story-specific semantic chunks',
      blankPositionPattern: null,
    ),
  );
}

StoryChallengeQuestion completeForbiddenCityGrammarQuestion({
  required StoryChallengeQuestion source,
  required String journeyId,
  required int sessionLevel,
  required int index,
}) {
  if (journeyId != primaryForbiddenCityJourneyId &&
      journeyId != secondForbiddenCityStoryId) {
    return source;
  }
  final level = sessionLevel.clamp(1, 10).toInt();
  final tables = journeyId == primaryForbiddenCityJourneyId
      ? <List<String>>[
          _primaryRelation,
          _primaryCollocation,
          _primaryRedundancy,
          _primaryMissing,
        ]
      : <List<String>>[
          _secondRelation,
          _secondCollocation,
          _secondRedundancy,
          _secondMissing,
        ];
  final correct = tables[index][level - 1];
  final targetIndex = _correctPosition(source);
  final authored = _grammarVariant(
    correct: correct,
    familyIndex: index,
    level: level,
  );
  final orderedOptions = List<String>.of(authored.distractors)
    ..insert(targetIndex, correct);
  final explanations = <String>[
    for (final option in orderedOptions)
      option == correct
          ? '正确：句子完整，语法关系成立，也保留当前北京·紫禁城知识。'
          : authored.wrongExplanation,
  ];

  return StoryChallengeQuestion(
    id: source.id,
    mode: StoryChallengeMode.grammarRepair,
    sourceSentence: correct,
    prompt: authored.broken,
    answer: correct,
    options: List<String>.unmodifiable(orderedOptions),
    errorSegments: List<String>.unmodifiable(authored.errorSegments),
    errorSegmentIndex: authored.errorSegmentIndex,
    grammarFamily: authored.family,
    grammarWhyWrong: authored.whyWrong,
    grammarRevisionRule: authored.revisionRule,
    grammarOptionExplanations: List<String>.unmodifiable(explanations),
    narrationText: authored.broken,
    signature: QuestionDesignSignature(
      journeyId: source.signature.journeyId,
      sessionLevel: level,
      mode: StoryChallengeMode.grammarRepair,
      sourceParagraphIndex: source.signature.sourceParagraphIndex,
      sourceSentenceIndex: source.signature.sourceSentenceIndex,
      sourceHash: _hash(authored.broken),
      syntaxPattern: _syntax(authored.broken),
      operationType: '完整病句→定位错误→选择完整修正',
      errorFamily: authored.family,
      gapType: null,
      answerShape: '完整修正句',
      distractorStrategy: 'Lv$level ${authored.family} Story-specific repairs',
      blankPositionPattern: null,
    ),
  );
}

class _GrammarVariant {
  const _GrammarVariant({
    required this.family,
    required this.broken,
    required this.errorSegments,
    required this.errorSegmentIndex,
    required this.distractors,
    required this.whyWrong,
    required this.revisionRule,
    required this.wrongExplanation,
  });

  final String family;
  final String broken;
  final List<String> errorSegments;
  final int errorSegmentIndex;
  final List<String> distractors;
  final String whyWrong;
  final String revisionRule;
  final String wrongExplanation;
}

_GrammarVariant _grammarVariant({
  required String correct,
  required int familyIndex,
  required int level,
}) {
  final core = correct.substring(0, correct.length - 1);
  switch (familyIndex) {
    case 0:
      const starts = ['虽然', '因为', '只要', '不仅', '尽管'];
      const wrongLinks = ['，所以', '，但是', '，却', '，所以', '，因此'];
      final start = starts[(level - 1) % starts.length];
      final link = wrongLinks[(level - 1) % wrongLinks.length];
      final broken = '$start$core$link这样。';
      return _GrammarVariant(
        family: '关联词错误',
        broken: broken,
        errorSegments: <String>[start, '$core，', link.substring(1), '这样。'],
        errorSegmentIndex: 2,
        distractors: <String>[
          broken,
          '因为虽然$core，所以这样。',
          '$start$core$link。',
        ],
        whyWrong: '前后关联词不能构成清楚一致的逻辑关系。',
        revisionRule: '删除不必要的关联词外壳，恢复能独立成立的完整知识句。',
        wrongExplanation: '关联词仍然搭配错误、重复或造成残缺逻辑。',
      );
    case 1:
      final token = correct.contains('连接') ? '连接' : '位于';
      final wrong = level.isEven ? '制造' : '生产';
      final broken = correct.replaceFirst(token, wrong);
      return _GrammarVariant(
        family: '搭配错误',
        broken: broken,
        errorSegments: _segmentsAround(broken, wrong),
        errorSegmentIndex: 2,
        distractors: <String>[
          broken,
          correct.replaceFirst(token, '种植'),
          correct.replaceFirst(token, '制造'),
        ],
        whyWrong: '动词与宫门、空间关系不能这样搭配。',
        revisionRule: '使用能表达空间关系的动词，如“连接”或“位于”。',
        wrongExplanation: '动词与当前空间知识的宾语搭配不成立。',
      );
    case 2:
      const good = '一起';
      if (!correct.contains(good)) {
        throw StateError('Redundancy blueprint must contain 一起: $correct');
      }
      final broken = correct.replaceFirst(good, '共同一起');
      return _GrammarVariant(
        family: '成分赘余',
        broken: broken,
        errorSegments: _segmentsAround(broken, '共同一起'),
        errorSegmentIndex: 2,
        distractors: <String>[
          broken,
          correct.replaceFirst(good, '一起共同'),
          correct.replaceFirst(good, '共同一起共同'),
        ],
        whyWrong: '“共同”和“一起”在这里重复表达同一层意思。',
        revisionRule: '保留一个表达共同动作的成分即可。',
        wrongExplanation: '句子仍保留重复成分，表达不够准确。',
      );
    case 3:
      final marker = correct.contains('写在')
          ? '写在'
          : correct.contains('标在')
              ? '标在'
              : '画在';
      final markerIndex = correct.indexOf(marker);
      if (markerIndex < 0) {
        throw StateError(
          'Missing-component blueprint lacks location marker: $correct',
        );
      }
      final broken = '${correct.substring(0, markerIndex)}$marker以后。';
      final subjectless = correct.replaceFirst('把', '');
      final noPreposition = correct.replaceFirst(
        marker,
        marker.replaceAll('在', ''),
      );
      return _GrammarVariant(
        family: '成分缺失',
        broken: broken,
        errorSegments: _segmentsAround(broken, '$marker以后'),
        errorSegmentIndex: 2,
        distractors: <String>[broken, subjectless, noPreposition],
        whyWrong: '“$marker”后缺少地点成分，句子意思没有说完整。',
        revisionRule: '补出动作落点，使“把”字句的对象、动作和地点都完整。',
        wrongExplanation: '句子仍缺少必要的介词、地点或“把”字结构成分。',
      );
  }
  throw RangeError.index(familyIndex, const <int>[0, 1, 2, 3]);
}

int _correctPosition(StoryChallengeQuestion source) {
  if (source.options.length == 4) {
    final index =
        source.options.indexWhere((option) => option == source.answer);
    if (index >= 0) return index;
  }
  return source.signature.sessionLevel % 4;
}

List<String> _segmentsAround(String sentence, String token) {
  final start = sentence.indexOf(token);
  if (start < 2) {
    throw StateError(
      'Grammar token must leave a substantial prefix: $sentence / $token',
    );
  }
  final prefix = sentence.substring(0, start);
  final suffix = sentence.substring(start + token.length);
  final split = (prefix.length ~/ 2).clamp(1, prefix.length - 1).toInt();
  return <String>[
    prefix.substring(0, split),
    prefix.substring(split),
    token,
    suffix,
  ];
}

const _semanticTokens = <String>[
  '故宫博物院',
  '紫禁城',
  '乾清门',
  '景运门',
  '空间证据',
  '宫廷文物',
  '空间骨架',
  '转换节点',
  '侧向宫门',
  '内外廷',
  '外朝',
  '内廷',
  '午门',
  '中轴',
  '宫门',
  '宫城',
  '院落',
  '广场',
  '东侧',
  '西侧',
  '路线',
  '任务',
  '记录',
  '核对',
  '交接',
  '更正',
  '留空',
  '疑问',
  '证据',
  '空间',
  '节点',
  '方位',
  '连接',
  '位于',
  '通行',
  '礼制',
  '判断',
  '复核',
  '框架',
  '顺序',
  '观察',
  '汇合',
];

List<String> _semanticChunks(String sentence) {
  final chunks = <String>[];
  var cursor = 0;
  while (cursor < sentence.length) {
    String? match;
    for (final token in _semanticTokens) {
      if (sentence.startsWith(token, cursor) &&
          (match == null || token.length > match.length)) {
        match = token;
      }
    }
    if (match != null) {
      chunks.add(match);
      cursor += match.length;
      continue;
    }
    final next = (cursor + 2).clamp(0, sentence.length).toInt();
    chunks.add(sentence.substring(cursor, next));
    cursor = next;
  }
  if (chunks.join() != sentence || chunks.length < 2) {
    throw StateError('Semantic chunking failed: $sentence / $chunks');
  }
  return chunks;
}

List<String> _scramble(List<String> ordered, int seed) {
  final result = List<String>.of(ordered.reversed);
  if (result.length > 2) {
    final shift = seed % result.length;
    return <String>[...result.skip(shift), ...result.take(shift)];
  }
  return result;
}

int _hanCount(String value) =>
    RegExp(r'[\u3400-\u9fff]').allMatches(value).length;

String _syntax(String sentence) {
  if (sentence.contains('把')) return '把字句';
  if (sentence.contains(RegExp(r'虽然|因为|只要|不仅|尽管'))) return '复句';
  return '主谓宾';
}

String _hash(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
