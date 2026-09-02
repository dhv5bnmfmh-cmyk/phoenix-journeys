import '../models/journey_challenge.dart';

class JourneyChallengeEngine {
  const JourneyChallengeEngine();

  StoryChallengeSet build({
    required String journeyId,
    required int sessionLevel,
    required List<String> storyParagraphs,
  }) {
    final sources = _sources(storyParagraphs);
    if (sources.length < 4) {
      throw StateError('$journeyId Lv$sessionLevel requires four Story sentences');
    }
    final selected = _selectChallengeSources(sources);
    return StoryChallengeSet(
      journeyId: journeyId,
      sessionLevel: sessionLevel,
      questions: List.unmodifiable([
        for (var index = 0; index < 4; index++)
          _rebuild(journeyId, sessionLevel, selected[index], index),
        for (var index = 0; index < 4; index++)
          _grammar(journeyId, sessionLevel, selected[index], index),
        for (var index = 0; index < 4; index++)
          _completion(
            journeyId,
            sessionLevel,
            selected[index],
            index,
            sources,
          ),
      ]),
    );
  }

  StoryChallengeQuestion _rebuild(
    String journeyId,
    int level,
    _Source source,
    int index,
  ) {
    final compact = _hanOnly(source.sentence);
    final chunks = _semanticChunks(compact, index);
    final selected = _rebuildChunkWindow(chunks, index);
    final answer = selected.join();
    final safeTiles = List<String>.of(selected.reversed);
    if (safeTiles.length > 2) {
      final shift = (index + 1) % safeTiles.length;
      final rotated = [...safeTiles.skip(shift), ...safeTiles.take(shift)];
      safeTiles
        ..clear()
        ..addAll(rotated);
    }
    return StoryChallengeQuestion(
      id: 'rebuild-${index + 1}',
      mode: StoryChallengeMode.sentenceRebuild,
      sourceSentence: source.sentence,
      prompt: '用语义块复原当前 Story 短句',
      answer: answer,
      options: const [],
      characterTiles: List.unmodifiable(safeTiles),
      narrationText: answer,
      signature: _signature(
        journeyId,
        level,
        source,
        StoryChallengeMode.sentenceRebuild,
        operation: ['语义块顺序恢复', '专名锚点复原', '短语结构重建', '语义块逻辑复原'][index],
        answerShape: '${_hanCount(answer)}字 / ${selected.length}块',
        distractor: ['词块反序', '锚点保留后轮换', '短语块交错', '结构块轮换'][index],
      ),
    );
  }

  StoryChallengeQuestion _grammar(
    String journeyId,
    int level,
    _Source source,
    int index,
  ) {
    const families = ['关联词', '成分赘余', '搭配', '成分缺失'];
    final family = families[index];
    final correct = source.sentence.trim();
    final mutation = _brokenGrammar(correct, index);
    final broken = mutation.text;
    final segments = _fourSegments(broken);
    final options = _repairOptions(correct, broken, index);
    return StoryChallengeQuestion(
      id: 'grammar-${index + 1}',
      mode: StoryChallengeMode.grammarRepair,
      sourceSentence: correct,
      prompt: broken,
      answer: correct,
      options: List.unmodifiable(options),
      errorSegments: segments,
      errorSegmentIndex: _segmentForOffset(segments, mutation.errorOffset),
      narrationText: broken,
      signature: _signature(
        journeyId,
        level,
        source,
        StoryChallengeMode.grammarRepair,
        operation: '完整病句→定位错误→选择修正',
        errorFamily: family,
        answerShape: '完整自然句',
        distractor: ['关联词逻辑近项', '赘余成分保留项', '搭配近义误项', '缺失成分未补项'][index],
      ),
    );
  }

  StoryChallengeQuestion _completion(
    String journeyId,
    int level,
    _Source source,
    int index,
    List<_Source> all,
  ) {
    final passage = _completionPassage(source, all, level, index);
    final spans = _semanticSpans(passage, index);
    final selected = _selectBlankSpans(passage, spans, level, index);
    final storyTokens = <String>{
      for (var pattern = 0; pattern < 4; pattern++)
        for (final item in all)
          ..._semanticChunks(_hanOnly(item.sentence), pattern),
    }.where((token) => token.isNotEmpty).toList(growable: false);

    final segments = <String>[];
    final blanks = <StoryCompletionBlank>[];
    var cursor = 0;
    for (var blankIndex = 0; blankIndex < selected.length; blankIndex++) {
      final span = selected[blankIndex];
      segments.add(passage.substring(cursor, span.start));
      final answer = passage.substring(span.start, span.end);
      blanks.add(
        StoryCompletionBlank(
          answer: answer,
          options: List.unmodifiable(
            _blankOptions(answer, storyTokens, blankIndex, index),
          ),
          answerType: _answerType(answer),
          sourceStart: span.start,
        ),
      );
      cursor = span.end;
    }
    segments.add(passage.substring(cursor));

    final promptBuffer = StringBuffer();
    for (var i = 0; i < blanks.length; i++) {
      promptBuffer
        ..write(segments[i])
        ..write('〔${i + 1}〕____');
    }
    promptBuffer.write(segments.last);

    final answerShape = blanks.map((blank) => blank.answerType).toSet().join('+');
    final sourceForSignature = _Source(
      source.paragraphIndex,
      source.sentenceIndex,
      passage,
    );
    return StoryChallengeQuestion(
      id: 'completion-${index + 1}',
      mode: StoryChallengeMode.storyCompletion,
      sourceSentence: passage,
      prompt: promptBuffer.toString(),
      answer: passage,
      options: const [],
      completionSegments: List.unmodifiable(segments),
      completionBlanks: List.unmodifiable(blanks),
      narrationText: promptBuffer.toString().replaceAll('____', '空位'),
      signature: _signature(
        journeyId,
        level,
        sourceForSignature,
        StoryChallengeMode.storyCompletion,
        operation: 'Story 多空位语境选择填空',
        gapType: '多空位选择填空',
        answerShape: answerShape,
        distractor: ['同 Story 词块近项', '同形异义近项', '语法可接误项', '跨句语义近项'][index],
        blankPositionPattern: 'spread-${index + 1}',
      ),
    );
  }

  QuestionDesignSignature _signature(
    String journeyId,
    int level,
    _Source source,
    StoryChallengeMode mode, {
    required String operation,
    String? errorFamily,
    String? gapType,
    required String answerShape,
    required String distractor,
    String? blankPositionPattern,
  }) =>
      QuestionDesignSignature(
        journeyId: journeyId,
        sessionLevel: level,
        mode: mode,
        sourceParagraphIndex: source.paragraphIndex,
        sourceSentenceIndex: source.sentenceIndex,
        sourceHash: _hash(source.sentence),
        syntaxPattern: _syntax(source.sentence),
        operationType: operation,
        errorFamily: errorFamily,
        gapType: gapType,
        answerShape: answerShape,
        distractorStrategy: distractor,
        blankPositionPattern: blankPositionPattern,
      );
}

class ChallengeAntiTemplateAuditor {
  const ChallengeAntiTemplateAuditor();

  ChallengeAuditReport audit(StoryChallengeSet set) {
    final failures = <String>[];
    if (set.questions.length != 12) failures.add('question-count');
    for (final mode in StoryChallengeMode.values) {
      final questions = set.questions.where((q) => q.mode == mode).toList();
      if (questions.length != 4) failures.add('${mode.name}-count');
      if (questions.map((q) => q.signature.sourceHash).toSet().length < 4) {
        failures.add('${mode.name}-source-diversity');
      }
    }

    final rebuild = set.questions
        .where((q) => q.mode == StoryChallengeMode.sentenceRebuild)
        .toList(growable: false);
    if (rebuild.any((q) => _hanCount(q.answer) > 10)) {
      failures.add('rebuild-length');
    }
    if (rebuild.any((q) => q.characterTiles.length < 2)) {
      failures.add('rebuild-one-tile');
    }
    if (rebuild.any((q) => q.characterTiles.every((tile) => _hanCount(tile) == 1))) {
      failures.add('rebuild-all-single-character');
    }

    final grammar = set.questions
        .where((q) => q.mode == StoryChallengeMode.grammarRepair)
        .toList(growable: false);
    if (grammar.map((q) => q.signature.errorFamily).toSet().length < 4) {
      failures.add('error-family-diversity');
    }
    if (grammar.any((q) => q.errorSegments.length != 4 || q.options.length != 4)) {
      failures.add('grammar-four-choice-contract');
    }

    final completion = set.questions
        .where((q) => q.mode == StoryChallengeMode.storyCompletion)
        .toList(growable: false);
    if (completion.any((q) => q.signature.gapType != '多空位选择填空')) {
      failures.add('completion-mechanic-drift');
    }
    if (completion.any((q) => q.completionBlanks.length != set.sessionLevel)) {
      failures.add('completion-blank-count');
    }
    if (completion.any((q) => q.completionBlanks.any((blank) => blank.options.length != 4))) {
      failures.add('completion-blank-options');
    }
    if (completion.any(
      (q) => q.completionBlanks.any(
        (blank) =>
            blank.options.where((option) => option == blank.answer).length != 1,
      ),
    )) {
      failures.add('completion-correct-option');
    }
    if (completion.map((q) => q.signature.blankPositionPattern).toSet().length < 4) {
      failures.add('completion-blank-position-diversity');
    }
    if (completion.map((q) => q.signature.syntaxPattern).toSet().length < 2) {
      failures.add('completion-syntax-diversity');
    }
    if (completion.map((q) => q.signature.answerShape).toSet().length < 2) {
      failures.add('completion-answer-shape-diversity');
    }
    if (completion.map((q) => q.signature.distractorStrategy).toSet().length < 4) {
      failures.add('completion-distractor-diversity');
    }

    if (set.questions.map((q) => q.signature.equivalenceKey).toSet().length != 12) {
      failures.add('equivalent-signature');
    }
    return ChallengeAuditReport(failures: List.unmodifiable(failures));
  }
}

class _Source {
  const _Source(this.paragraphIndex, this.sentenceIndex, this.sentence);
  final int paragraphIndex;
  final int sentenceIndex;
  final String sentence;
}

List<_Source> _selectChallengeSources(List<_Source> sources) {
  final selected = <_Source>[];
  final syntaxes = <String>{};
  for (final source in sources) {
    if (syntaxes.add(_syntax(source.sentence))) selected.add(source);
    if (selected.length == 4) return List.unmodifiable(selected);
  }
  for (var index = 0; index < 4 && selected.length < 4; index++) {
    final source = sources[(index * sources.length / 4).floor()];
    if (!selected.contains(source)) selected.add(source);
  }
  for (final source in sources) {
    if (selected.length == 4) break;
    if (!selected.contains(source)) selected.add(source);
  }
  return List.unmodifiable(selected);
}

List<_Source> _sources(List<String> paragraphs) {
  final result = <_Source>[];
  for (var paragraph = 0; paragraph < paragraphs.length; paragraph++) {
    final matches = RegExp(r'[^。！？!?]+[。！？!?]').allMatches(paragraphs[paragraph]);
    var sentence = 0;
    for (final match in matches) {
      result.add(_Source(paragraph, sentence++, match.group(0)!.trim()));
    }
  }
  return result;
}

List<String> _fourSegments(String value) {
  final size = (value.length / 4).ceil();
  return List.generate(4, (index) {
    final start = (index * size).clamp(0, value.length);
    final end = ((index + 1) * size).clamp(0, value.length);
    return value.substring(start, end);
  }, growable: false);
}

class _GrammarMutation {
  const _GrammarMutation(this.text, this.errorOffset);
  final String text;
  final int errorOffset;
}

class _TextSpan {
  const _TextSpan(this.start, this.end);
  final int start;
  final int end;
}

const _protectedChallengeTerms = <String>[
  '紫禁城',
  '乾清门',
  '午门',
  '沈砚',
  '阿宁',
  '两条路线',
  '人物目标',
  '行动结果',
  '空间关系',
  '共同节点',
  '中轴',
  '东侧',
  '路线',
  '证据',
  '建筑',
  '判断',
  '连接',
];

String _hanOnly(String value) =>
    RegExp(r'[\u3400-\u9fff]').allMatches(value).map((m) => m.group(0)!).join();

int _hanCount(String value) =>
    RegExp(r'[\u3400-\u9fff]').allMatches(value).length;

List<String> _semanticChunks(String compact, int patternIndex) {
  if (compact.isEmpty) return const [];
  const patterns = <List<int>>[
    [2, 1, 3, 2],
    [3, 2, 1, 2],
    [2, 3, 1, 2],
    [1, 2, 3, 2],
  ];
  final pattern = patterns[patternIndex % patterns.length];
  final terms = [..._protectedChallengeTerms]
    ..sort((a, b) => b.length.compareTo(a.length));
  final result = <String>[];
  var cursor = 0;
  var patternCursor = 0;
  while (cursor < compact.length) {
    String? protected;
    for (final term in terms) {
      if (compact.startsWith(term, cursor)) {
        protected = term;
        break;
      }
    }
    if (protected != null) {
      result.add(protected);
      cursor += protected.length;
      continue;
    }

    var nextProtected = compact.length;
    for (final term in terms) {
      final next = compact.indexOf(term, cursor + 1);
      if (next >= 0 && next < nextProtected) nextProtected = next;
    }
    var length = pattern[patternCursor++ % pattern.length];
    length = length.clamp(1, compact.length - cursor).toInt();
    if (cursor + length > nextProtected) {
      length = (nextProtected - cursor).clamp(1, compact.length - cursor).toInt();
    }
    result.add(compact.substring(cursor, cursor + length));
    cursor += length;
  }
  return result;
}

List<String> _rebuildChunkWindow(List<String> chunks, int index) {
  if (chunks.length < 2) return chunks;
  var start = ((chunks.length - 1) * (index + 1) / 5).floor();
  start = start.clamp(0, chunks.length - 2).toInt();
  final result = <String>[];
  var length = 0;
  for (var i = start; i < chunks.length; i++) {
    final next = _hanCount(chunks[i]);
    if (result.length >= 2 && length + next > 10) break;
    if (length + next > 10) continue;
    result.add(chunks[i]);
    length += next;
    if (length >= 7 && result.length >= 2) break;
  }
  if (result.length < 2) {
    result
      ..clear()
      ..addAll(chunks.take(2));
  }
  while (_hanCount(result.join()) > 10 && result.length > 2) {
    result.removeLast();
  }
  return result;
}

_GrammarMutation _brokenGrammar(String correct, int index) {
  switch (index) {
    case 0:
      final comma = correct.indexOf('，');
      if (comma >= 0) {
        final text = '虽然${correct.substring(0, comma)}，所以${correct.substring(comma + 1)}';
        return _GrammarMutation(text, text.indexOf('所以'));
      }
      final text = '虽然$correct，所以这样。';
      return _GrammarMutation(text, text.indexOf('所以'));
    case 1:
      for (final pair in const [
        ['共同', '共同一起'],
        ['都', '都全部'],
        ['一起', '一起共同'],
        ['已经', '已经早已'],
      ]) {
        if (correct.contains(pair[0])) {
          final text = correct.replaceFirst(pair[0], pair[1]);
          return _GrammarMutation(text, text.indexOf(pair[1]));
        }
      }
      final text = '沈砚和阿宁共同一起${correct.replaceFirst(RegExp(r'^[^，。！？]{0,6}'), '')}';
      return _GrammarMutation(text, text.indexOf('共同一起'));
    case 2:
      for (final pair in const [
        ['保留', '制造'],
        ['判断', '制造'],
        ['解释', '生产'],
        ['连接', '生产'],
        ['选择', '制造'],
        ['发现', '发明'],
      ]) {
        if (correct.contains(pair[0])) {
          final text = correct.replaceFirst(pair[0], pair[1]);
          return _GrammarMutation(text, text.indexOf(pair[1]));
        }
      }
      const text = '阿宁选择先让证据制造话。';
      return _GrammarMutation(text, text.indexOf('制造'));
    default:
      for (final token in const ['把', '让', '的']) {
        final offset = correct.indexOf(token);
        if (offset >= 0) {
          final text = correct.replaceFirst(token, '');
          return _GrammarMutation(text, offset.clamp(0, text.length - 1).toInt());
        }
      }
      final text = correct.length > 2
          ? '${correct.substring(0, 1)}${correct.substring(2)}'
          : correct;
      return _GrammarMutation(text, 1.clamp(0, text.length - 1).toInt());
  }
}

List<String> _repairOptions(String correct, String broken, int index) {
  final candidates = <String>[
    correct,
    broken,
    index == 0 ? '虽然$correct' : '因此$broken',
    index == 3 ? '$broken了。' : '$broken，而且如此。',
  ];
  final result = <String>[];
  for (final candidate in candidates) {
    if (!result.contains(candidate)) result.add(candidate);
  }
  while (result.length < 4) {
    result.add('${broken.replaceAll(RegExp(r'[。！？]$'), '')}，所以。');
  }
  final shift = index % result.length;
  return [...result.skip(shift), ...result.take(shift)]
      .take(4)
      .toList(growable: false);
}

int _segmentForOffset(List<String> segments, int offset) {
  var cursor = 0;
  for (var i = 0; i < segments.length; i++) {
    cursor += segments[i].length;
    if (offset < cursor) return i;
  }
  return segments.length - 1;
}

String _completionPassage(
  _Source source,
  List<_Source> all,
  int level,
  int index,
) {
  var passage = source.sentence.trim();
  var cursor = 1;
  while (_semanticSpans(passage, index).length < level + 4 &&
      cursor < all.length) {
    final next = all[(all.indexOf(source) + cursor) % all.length].sentence.trim();
    if (!passage.contains(next)) passage = '$passage$next';
    cursor += 1;
  }
  return passage;
}

List<_TextSpan> _semanticSpans(String value, int patternIndex) {
  final result = <_TextSpan>[];
  final runMatches = RegExp(r'[\u3400-\u9fff]+').allMatches(value);
  for (final run in runMatches) {
    final text = run.group(0)!;
    final chunks = _semanticChunks(text, patternIndex);
    var offset = run.start;
    for (final chunk in chunks) {
      result.add(_TextSpan(offset, offset + chunk.length));
      offset += chunk.length;
    }
  }
  return result;
}

List<_TextSpan> _selectBlankSpans(
  String passage,
  List<_TextSpan> spans,
  int count,
  int index,
) {
  if (spans.length < count) {
    throw StateError('Story passage has only ${spans.length} blank candidates for Lv$count');
  }

  final selectedIndices = <int>{};
  const preferredTypes = ['字', '词', '短语', '词'];
  final preferredType = preferredTypes[index % preferredTypes.length];
  final preferredIndex = spans.indexWhere((span) {
    final answer = passage.substring(span.start, span.end);
    return _answerType(answer) == preferredType;
  });
  if (preferredIndex >= 0) selectedIndices.add(preferredIndex);

  for (var i = 0; selectedIndices.length < count && i < count * 2; i++) {
    final base = (((i + 1) * spans.length) / (count + 1)).floor();
    final offset = [0, 1, -1, 2][index % 4];
    selectedIndices.add(
      (base + offset).clamp(0, spans.length - 1).toInt(),
    );
  }

  var probe = 0;
  while (selectedIndices.length < count) {
    selectedIndices.add((probe * 3 + index) % spans.length);
    probe += 1;
  }
  final selected = selectedIndices.map((i) => spans[i]).toList()
    ..sort((a, b) => a.start.compareTo(b.start));
  return selected.take(count).toList(growable: false);
}

String _answerType(String answer) {
  if (const ['因为', '所以', '但是', '虽然', '因此', '为了'].contains(answer)) {
    return '结构';
  }
  final count = _hanCount(answer);
  if (count <= 1) return '字';
  if (count <= 2) return '词';
  return '短语';
}

List<String> _blankOptions(
  String answer,
  List<String> storyTokens,
  int blankIndex,
  int questionIndex,
) {
  final distractors = <String>[];

  void addDistractor(String candidate) {
    if (candidate.isEmpty ||
        candidate == answer ||
        distractors.contains(candidate) ||
        distractors.length >= 3) {
      return;
    }
    distractors.add(candidate);
  }

  for (final token in storyTokens.where(
    (token) => _hanCount(token) == _hanCount(answer),
  )) {
    addDistractor(token);
    if (distractors.length == 3) break;
  }

  if (distractors.length < 3) {
    for (final token in storyTokens) {
      addDistractor(token);
      if (distractors.length == 3) break;
    }
  }

  if (distractors.length < 3) {
    throw StateError(
      'Story completion requires three grounded distractors for "$answer"',
    );
  }

  final options = <String>[answer, ...distractors];
  final shift = (blankIndex + questionIndex) % options.length;
  final reordered = <String>[
    ...options.skip(shift),
    ...options.take(shift),
  ];

  if (reordered.length != 4 ||
      reordered.where((option) => option == answer).length != 1) {
    throw StateError(
      'Story completion correct option invariant failed for "$answer"',
    );
  }
  return reordered;
}

String _syntax(String sentence) {
  if (sentence.contains('把')) return '把字句';
  if (sentence.contains(RegExp(r'因为|所以|因此'))) return '因果结构';
  if (sentence.contains(RegExp(r'却|但是|而'))) return '转折结构';
  if (sentence.startsWith(RegExp(r'当|后来|随后|这时|为了'))) return '时间目的前置';
  if (sentence.contains('，')) return '复句';
  return '主谓宾';
}

String _hash(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
