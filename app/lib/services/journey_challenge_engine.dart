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
    if (journeyId == _forbiddenCityJourneyId) {
      final record = _forbiddenCityRebuildBlueprint(level, index);
      if (record.chunks.join() != record.sentence) {
        throw StateError(
          'Forbidden City rebuild chunks must exactly reconstruct the knowledge sentence.',
        );
      }
      final safeTiles = _scrambleRebuildTiles(record.chunks, index);
      final signatureSource = _Source(
        source.paragraphIndex,
        source.sentenceIndex,
        '${record.sentence}。',
      );
      return StoryChallengeQuestion(
        id: 'rebuild-${index + 1}',
        mode: StoryChallengeMode.sentenceRebuild,
        sourceSentence: '${record.sentence}。',
        prompt: '复原一条与北京 · 紫禁城相关的知识句',
        answer: record.sentence,
        options: const [],
        characterTiles: List.unmodifiable(safeTiles),
        narrationText: '${record.sentence}。',
        signature: _signature(
          journeyId,
          level,
          signatureSource,
          StoryChallengeMode.sentenceRebuild,
          operation: '知识句语义块顺序恢复',
          answerShape:
              '${_hanCount(record.sentence)}字 / ${record.chunks.length}块',
          distractor: [
            '知识块反序',
            '专名锚点轮换',
            '空间关系块交错',
            '文化知识块轮换',
          ][index],
        ),
      );
    }

    final compact = _hanOnly(source.sentence);
    final chunks = _semanticChunks(compact, index);
    final selected = _rebuildChunkWindow(chunks, index);
    final answer = selected.join();
    final safeTiles = _scrambleRebuildTiles(selected, index);
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
        operation: [
          '语义块顺序恢复',
          '专名锚点复原',
          '短语结构重建',
          '语义块逻辑复原',
        ][index],
        answerShape: '${_hanCount(answer)}字 / ${selected.length}块',
        distractor: [
          '词块反序',
          '锚点保留后轮换',
          '短语块交错',
          '结构块轮换',
        ][index],
      ),
    );
  }

  StoryChallengeQuestion _grammar(
    String journeyId,
    int level,
    _Source source,
    int index,
  ) {
    if (journeyId == _forbiddenCityJourneyId) {
      final record = _forbiddenCityGrammarBlueprint(level, index);
      if (record.errorSegments.join() != record.broken) {
        throw StateError(
          'Forbidden City grammar segments must reconstruct the broken sentence.',
        );
      }
      if (record.options.where((option) => option == record.correct).length !=
          1) {
        throw StateError(
          'Forbidden City grammar must contain exactly one correct repair.',
        );
      }
      if (record.optionExplanations.length != record.options.length ||
          record.optionExplanations.any((explanation) => explanation.trim().isEmpty) ||
          record.whyWrong.trim().isEmpty ||
          record.revisionRule.trim().isEmpty) {
        throw StateError(
          'Forbidden City grammar explanations must cover every authored option.',
        );
      }
      final signatureSource = _Source(
        source.paragraphIndex,
        source.sentenceIndex,
        record.broken,
      );
      return StoryChallengeQuestion(
        id: 'grammar-${index + 1}',
        mode: StoryChallengeMode.grammarRepair,
        sourceSentence: record.correct,
        prompt: record.broken,
        answer: record.correct,
        options: List.unmodifiable(record.options),
        errorSegments: List.unmodifiable(record.errorSegments),
        errorSegmentIndex: record.errorSegmentIndex,
        grammarFamily: record.family,
        grammarWhyWrong: record.whyWrong,
        grammarRevisionRule: record.revisionRule,
        grammarOptionExplanations:
            List.unmodifiable(record.optionExplanations),
        narrationText: record.broken,
        signature: _signature(
          journeyId,
          level,
          signatureSource,
          StoryChallengeMode.grammarRepair,
          operation: '完整病句→定位错误→选择完整修正',
          errorFamily: record.family,
          answerShape: '完整修正句',
          distractor: '${[
            '关联词配对误项',
            '搭配近项',
            '赘余保留项',
            '成分仍缺失项',
          ][index]} / Band ${((level - 1) ~/ 2) + 1}',
        ),
      );
    }

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
        distractor: [
          '关联词逻辑近项',
          '赘余成分保留项',
          '搭配近义误项',
          '缺失成分未补项',
        ][index],
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
    final passage = journeyId == _forbiddenCityJourneyId
        ? _forbiddenCityCompletionPassage(source, all, level)
        : _completionPassage(source, all, level, index);
    final spans = journeyId == _forbiddenCityJourneyId
        ? _forbiddenCityCompletionSpans(passage)
        : _semanticSpans(passage, index);
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
      final semanticSlotType = journeyId == _forbiddenCityJourneyId
          ? _forbiddenCitySlotFor(answer)
          : _answerType(answer);
      blanks.add(
        StoryCompletionBlank(
          answer: answer,
          options: List.unmodifiable(
            journeyId == _forbiddenCityJourneyId
                ? _forbiddenCityBlankOptions(
                    answer: answer,
                    slot: semanticSlotType,
                    journeyId: journeyId,
                    level: level,
                    questionId: 'completion-${index + 1}',
                    blankIndex: blankIndex,
                  )
                : _blankOptions(answer, storyTokens, blankIndex, index),
          ),
          answerType: _answerType(answer),
          semanticSlotType: semanticSlotType,
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

    final answerShape = blanks
        .map((blank) => '${blank.answerType}:${blank.semanticSlotType}')
        .toSet()
        .join('+');
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
    if (rebuild.any((q) => _hanCount(q.answer) > 30)) {
      failures.add('rebuild-length');
    }
    if (rebuild.any((q) => q.characterTiles.length < 2)) {
      failures.add('rebuild-one-tile');
    }
    if (rebuild.any((q) => q.characterTiles.every((tile) => _hanCount(tile) == 1))) {
      failures.add('rebuild-all-single-character');
    }
    if (set.sessionLevel >= 7 &&
        rebuild.any((q) => q.characterTiles.length < 4)) {
      failures.add('rebuild-high-level-trivial');
    }
    if (set.journeyId == _forbiddenCityJourneyId &&
        rebuild.any((q) => _protectedChallengeTerms.any(
              (term) =>
                  q.answer.contains(term) &&
                  !q.characterTiles.any((tile) => tile.contains(term)),
            ))) {
      failures.add('rebuild-protected-term-split');
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
    if (grammar.any((q) => q.options.toSet().length != 4)) {
      failures.add('grammar-duplicate-options');
    }
    if (grammar.any((q) =>
        q.grammarOptionExplanations.length != 4 ||
        q.grammarOptionExplanations.any((item) => item.trim().isEmpty))) {
      failures.add('grammar-option-explanations');
    }
    if (set.journeyId == _forbiddenCityJourneyId &&
        grammar.any((q) =>
            !q.signature.distractorStrategy.contains('Band ${((set.sessionLevel - 1) ~/ 2) + 1}'))) {
      failures.add('grammar-level-band');
    }
    if (set.sessionLevel >= 7 &&
        grammar.any((q) {
          final lengths = q.options.map(_hanCount).toList()..sort();
          return lengths.last - lengths.first > 8 ||
              q.errorSegments.any((segment) => _hanCount(segment) < 2);
        })) {
      failures.add('grammar-high-level-plausibility');
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
    if (completion.any((q) => q.completionBlanks.any(
          (blank) => blank.semanticSlotType.trim().isEmpty,
        ))) {
      failures.add('completion-slot-type');
    }
    if (completion.any((q) => q.completionBlanks.any(
          (blank) => blank.options.toSet().length != 4,
        ))) {
      failures.add('completion-duplicate-options');
    }
    if (set.journeyId == _forbiddenCityJourneyId &&
        completion.any((q) => q.completionBlanks.any(
              (blank) => blank.options.any(
                (option) => _forbiddenCitySlotFor(option) != blank.semanticSlotType,
              ),
            ))) {
      failures.add('completion-slot-mismatch');
    }
    if (set.journeyId == _forbiddenCityJourneyId &&
        completion.any((q) => q.completionBlanks.any(
              (blank) => blank.options.any(_looksLikeLexicalFragment),
            ))) {
      failures.add('completion-lexical-fragment');
    }
    if (set.sessionLevel >= 3 &&
        completion.any((q) => q.completionBlanks.any((blank) {
          final answerLength = _hanCount(blank.answer);
          return blank.options
              .where((option) => option != blank.answer)
              .every((option) => (_hanCount(option) - answerLength).abs() > 1);
        }))) {
      failures.add('completion-length-leak');
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
    if (set.journeyId == _forbiddenCityJourneyId) {
      final positions = <int>[
        for (final question in completion)
          for (final blank in question.completionBlanks)
            blank.options.indexOf(blank.answer),
      ];
      if (_hasSimpleFourPositionCycle(positions)) {
        failures.add('completion-correct-position-cycle');
      }
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

// City Standard / Challenge Standard:
// - auto-refresh must not create visual flashing;
// - Challenge content must teach current Journey/Place knowledge, not mechanical fragments;
// - every answer exposes correct/wrong state, audio, error location and correct answer;
// - Grammar requires four genuinely different error families.
const _forbiddenCityJourneyId = 'beijing-forbidden-city';

class _RebuildLearningBlueprint {
  const _RebuildLearningBlueprint(this.sentence, this.chunks);
  final String sentence;
  final List<String> chunks;
}

const _forbiddenCityRebuildBands = <List<_RebuildLearningBlueprint>>[
  <_RebuildLearningBlueprint>[
    _RebuildLearningBlueprint(
      '午门位于紫禁城南侧也是重要入口',
      <String>['午门', '位于紫禁城南侧', '也是重要入口'],
    ),
    _RebuildLearningBlueprint(
      '中轴线串联紫禁城的主要宫殿',
      <String>['中轴线', '串联', '紫禁城', '的主要宫殿'],
    ),
    _RebuildLearningBlueprint(
      '乾清门位于外朝与内廷之间',
      <String>['乾清门', '位于', '外朝', '与内廷之间'],
    ),
    _RebuildLearningBlueprint(
      '故宫博物院保存丰富的宫廷文物',
      <String>['故宫博物院', '保存', '丰富的', '宫廷文物'],
    ),
  ],
  <_RebuildLearningBlueprint>[
    _RebuildLearningBlueprint(
      '紫禁城的中轴线组织主要宫殿的空间秩序',
      <String>['紫禁城', '的中轴线', '组织', '主要宫殿', '的空间秩序'],
    ),
    _RebuildLearningBlueprint(
      '午门既是重要入口也是礼仪空间的一部分',
      <String>['午门', '既是重要入口', '也是', '礼仪空间', '的一部分'],
    ),
    _RebuildLearningBlueprint(
      '乾清门位于外朝与内廷之间的转换位置',
      <String>['乾清门', '位于', '外朝', '与内廷之间', '的转换位置'],
    ),
    _RebuildLearningBlueprint(
      '故宫博物院让古建筑与馆藏文物共同讲述历史',
      <String>['故宫博物院', '让古建筑', '与馆藏文物', '共同讲述', '历史'],
    ),
  ],
  <_RebuildLearningBlueprint>[
    _RebuildLearningBlueprint(
      '紫禁城以中轴线统摄主要宫殿形成严整的空间秩序',
      <String>['紫禁城', '以中轴线', '统摄主要宫殿', '形成', '严整的空间秩序'],
    ),
    _RebuildLearningBlueprint(
      '午门不仅承担出入功能也参与塑造礼仪性的空间序列',
      <String>['午门', '不仅承担出入功能', '也参与塑造', '礼仪性的', '空间序列'],
    ),
    _RebuildLearningBlueprint(
      '乾清门处在外朝与内廷转换的关键位置',
      <String>['乾清门', '处在', '外朝与内廷转换', '的关键位置'],
    ),
    _RebuildLearningBlueprint(
      '故宫博物院把宫殿建筑与馆藏文物置于同一历史语境中',
      <String>['故宫博物院', '把宫殿建筑', '与馆藏文物', '置于', '同一历史语境中'],
    ),
  ],
  <_RebuildLearningBlueprint>[
    _RebuildLearningBlueprint(
      '沿中轴观察时仍要区分建筑秩序与人物任务',
      <String>['沿中轴观察时', '仍要区分', '建筑秩序', '与人物任务'],
    ),
    _RebuildLearningBlueprint(
      '从午门进入形成的是观察顺序而不是唯一路线',
      <String>['从午门进入', '形成的是', '观察顺序', '而不是', '唯一路线'],
    ),
    _RebuildLearningBlueprint(
      '乾清门既连接空间也让不同任务在此会合',
      <String>['乾清门', '既连接空间', '也让不同任务', '在此会合'],
    ),
    _RebuildLearningBlueprint(
      '故宫博物院以建筑现场和馆藏证据共同解释历史',
      <String>['故宫博物院', '以建筑现场', '和馆藏证据', '共同解释历史'],
    ),
  ],
  <_RebuildLearningBlueprint>[
    _RebuildLearningBlueprint(
      '中轴提供整体框架却不替人物决定行动路线',
      <String>['中轴', '提供整体框架', '却不替人物', '决定行动路线'],
    ),
    _RebuildLearningBlueprint(
      '午门所开启的空间序列不能被等同于唯一答案',
      <String>['午门所开启的', '空间序列', '不能被等同于', '唯一答案'],
    ),
    _RebuildLearningBlueprint(
      '只有同时核对任务与连接乾清门才成为有效证据',
      <String>['只有同时核对', '任务与连接', '乾清门', '才成为有效证据'],
    ),
    _RebuildLearningBlueprint(
      '故宫博物院把空间事实放回制度与历史语境解释',
      <String>['故宫博物院', '把空间事实', '放回制度', '与历史语境解释'],
    ),
  ],
];

_RebuildLearningBlueprint _forbiddenCityRebuildBlueprint(
  int level,
  int index,
) {
  final band = ((level.clamp(1, 10).toInt() - 1) ~/ 2).clamp(0, 4);
  return _forbiddenCityRebuildBands[band][index];
}

List<String> _scrambleRebuildTiles(List<String> ordered, int index) {
  final safeTiles = List<String>.of(ordered.reversed);
  if (safeTiles.length > 2) {
    final shift = (index + 1) % safeTiles.length;
    final rotated = <String>[
      ...safeTiles.skip(shift),
      ...safeTiles.take(shift),
    ];
    safeTiles
      ..clear()
      ..addAll(rotated);
  }
  return safeTiles;
}

class _ForbiddenCityGrammarBlueprint {
  const _ForbiddenCityGrammarBlueprint({
    required this.family,
    required this.broken,
    required this.correct,
    required this.errorSegments,
    required this.errorSegmentIndex,
    required this.options,
    required this.whyWrong,
    required this.revisionRule,
    required this.optionExplanations,
  });

  final String family;
  final String broken;
  final String correct;
  final List<String> errorSegments;
  final int errorSegmentIndex;
  final List<String> options;
  final String whyWrong;
  final String revisionRule;
  final List<String> optionExplanations;
}

const _forbiddenCityGrammarBlueprints = <_ForbiddenCityGrammarBlueprint>[
  _ForbiddenCityGrammarBlueprint(
    family: '关联词错误',
    broken: '虽然紫禁城的主要建筑沿中轴线展开，所以参观者能清楚观察空间层次。',
    correct: '因为紫禁城的主要建筑沿中轴线展开，所以参观者能清楚观察空间层次。',
    errorSegments: <String>[
      '虽然',
      '紫禁城的主要建筑沿中轴线展开，',
      '所以参观者能清楚观察',
      '空间层次。',
    ],
    errorSegmentIndex: 0,
    options: <String>[
      '虽然紫禁城的主要建筑沿中轴线展开，但是参观者能清楚观察空间层次。',
      '因为紫禁城的主要建筑沿中轴线展开，所以参观者能清楚观察空间层次。',
      '不但紫禁城的主要建筑沿中轴线展开，所以参观者能清楚观察空间层次。',
      '由于紫禁城的主要建筑沿中轴线展开，但是参观者能清楚观察空间层次。',
    ],
    whyWrong:
        '“虽然……所以……”关联关系冲突。“虽然”表示转折或让步，通常与“但是 / 但”呼应；本句表达原因与结果，应使用“因为……所以……”。',
    revisionRule: '关联词必须与句子的逻辑关系一致，并且正确配对。',
    optionExplanations: <String>[
      '错。虽然……但是……本身是转折或让步结构，但这里需要表达“原因→结果”的因果关系。',
      '对。因为……所以……准确表达原因和结果，关联词配对正确。',
      '错。不但……所以……不是规范配对，句子的逻辑关系也不成立。',
      '错。由于……但是……把因果与转折关系混在一起，关联词关系冲突。',
    ],
  ),
  _ForbiddenCityGrammarBlueprint(
    family: '搭配错误',
    broken: '午门发挥着紫禁城南侧主要入口的景观。',
    correct: '午门发挥着紫禁城南侧主要入口的作用。',
    errorSegments: <String>[
      '午门',
      '发挥着',
      '紫禁城南侧主要入口',
      '的景观。',
    ],
    errorSegmentIndex: 3,
    options: <String>[
      '午门发挥着紫禁城南侧主要入口的景观。',
      '午门形成着紫禁城南侧主要入口的作用。',
      '午门发挥着紫禁城南侧主要入口的作用。',
      '午门发挥着紫禁城南侧主要入口的建筑。',
    ],
    whyWrong: '“发挥”通常与“作用 / 功能”等搭配，不能与“景观”搭配。',
    revisionRule: '动词和宾语必须构成自然、规范的搭配。',
    optionExplanations: <String>[
      '错。“发挥……景观”搭配不成立。',
      '错。“形成作用”不如“发挥作用”自然规范。',
      '对。“发挥作用”是自然、规范的动宾搭配。',
      '错。“发挥……建筑”搭配不成立。',
    ],
  ),
  _ForbiddenCityGrammarBlueprint(
    family: '成分赘余',
    broken: '沈砚和阿宁一起共同沿着中轴线向前走。',
    correct: '沈砚和阿宁一起沿着中轴线向前走。',
    errorSegments: <String>[
      '沈砚和阿宁',
      '一起共同',
      '沿着中轴线',
      '向前走。',
    ],
    errorSegmentIndex: 1,
    options: <String>[
      '沈砚和阿宁共同一起沿着中轴线向前走。',
      '沈砚和阿宁一起共同都沿着中轴线向前走。',
      '沈砚和阿宁一起沿着中轴线向前走。',
      '沈砚和阿宁一起共同沿着中轴线向前走。',
    ],
    whyWrong: '“一起”和“共同”语义重复，同时保留会造成成分赘余。',
    revisionRule: '表达同一语义的重复成分应删去一个，使句子简洁而完整。',
    optionExplanations: <String>[
      '错。“共同”和“一起”仍然重复，只是交换了顺序。',
      '错。“一起”“共同”“都”叠加，赘余更明显。',
      '对。保留“一起”，删去语义重复的“共同”，表达简洁完整。',
      '错。原来的“一起共同”仍同时保留，赘余没有消除。',
    ],
  ),
  _ForbiddenCityGrammarBlueprint(
    family: '成分缺失',
    broken: '乾清门位于外朝与内廷之间，是连接的重要空间节点。',
    correct: '乾清门位于外朝与内廷之间，是连接两者的重要空间节点。',
    errorSegments: <String>[
      '乾清门位于',
      '外朝与内廷之间，',
      '是连接的重要',
      '空间节点。',
    ],
    errorSegmentIndex: 2,
    options: <String>[
      '乾清门位于外朝与内廷之间，是连接的重要空间节点。',
      '乾清门位于外朝与内廷之间，是连接两者的重要空间节点。',
      '乾清门位于外朝与内廷之间，是连接两处之间的重要空间节点。',
      '乾清门位于外朝与内廷之间，是连接于的重要空间节点。',
    ],
    whyWrong: '“连接”后缺少宾语，没有说明连接什么。',
    revisionRule: '及物动词需要完整的支配对象；这里应补充“两者”。',
    optionExplanations: <String>[
      '错。“连接”后仍然没有宾语，没有说明连接的对象。',
      '对。补出“两者”，明确“连接”的对象是外朝和内廷。',
      '错。“两处之间”与前面的“外朝与内廷之间”语义重复，结构也显得累赘。',
      '错。“连接于”结构不完整，仍没有给出“连接”的宾语。',
    ],
  ),
];

class _GrammarRepairPattern {
  const _GrammarRepairPattern({
    required this.family,
    required this.segments,
    required this.errorSegmentIndex,
    required this.correctSegment,
    required this.candidateSegments,
    required this.whyWrong,
    required this.revisionRule,
    required this.optionExplanations,
  });

  final String family;
  final List<String> segments;
  final int errorSegmentIndex;
  final String correctSegment;
  final List<String> candidateSegments;
  final String whyWrong;
  final String revisionRule;
  final List<String> optionExplanations;
}

const _forbiddenCityIntermediateGrammar = <_GrammarRepairPattern>[
  _GrammarRepairPattern(
    family: '关联词错误',
    segments: <String>['虽然任务不同，', '两条路线都利用真实连接，', '所以它们应被判断为', '同一种路线。'],
    errorSegmentIndex: 2,
    correctSegment: '却不能因此被判断为',
    candidateSegments: <String>[
      '所以它们应被判断为',
      '却不能因此被判断为',
      '因此它们自然成为',
      '而且它们必须成为',
    ],
    whyWrong: '前文强调任务不同，后文应限制“共享连接”所能推出的结论，不能用“所以”导出路线相同。',
    revisionRule: '关联词不仅要配对，还要准确表示证据与结论之间是推出、转折还是限制。',
    optionExplanations: <String>[
      '“所以”把共享连接误当成路线相同的充分理由，推论过强。',
      '“却不能因此”既承接共同事实，也准确限制其结论范围。',
      '“自然成为”仍把可能性写成必然结论，不符合任务差异。',
      '“而且必须”增加了原句没有的强制关系，改变了逻辑。',
    ],
  ),
  _GrammarRepairPattern(
    family: '搭配错误',
    segments: <String>['沈砚用中轴路线', '承担整座宫城的', '唯一解释，', '忽略了任务差异。'],
    errorSegmentIndex: 1,
    correctSegment: '作为理解空间的',
    candidateSegments: <String>[
      '承担整座宫城的',
      '作为理解空间的',
      '执行观察结果的',
      '形成全部任务的',
    ],
    whyWrong: '路线可以“作为解释框架”，却不能“承担解释”；“承担”通常支配任务、责任等对象。',
    revisionRule: '判断搭配时要同时检查动词的支配对象和句子真正要表达的功能。',
    optionExplanations: <String>[
      '“路线承担解释”支配关系不自然，且夸大了中轴路线的作用。',
      '“作为理解空间的唯一解释”搭配完整，并保留原句要批评的判断。',
      '“执行观察结果”搭配不当，结果不能由路线执行。',
      '“形成全部任务”语义不成立，路线不会生成所有任务。',
    ],
  ),
  _GrammarRepairPattern(
    family: '成分赘余',
    segments: <String>['在核对共同节点之后，', '沈砚又再次', '比较两人的任务条件，', '才修改判断。'],
    errorSegmentIndex: 1,
    correctSegment: '沈砚再次',
    candidateSegments: <String>['沈砚又再次', '沈砚再次', '沈砚又重新再次', '沈砚仍旧又'],
    whyWrong: '“又”和“再次”都表示动作重复，同时使用造成语义叠加。',
    revisionRule: '删去重复时间或频率意义，只保留一个能准确连接上下文的成分。',
    optionExplanations: <String>[
      '“又再次”重复表达动作再发生。',
      '“再次”独立承担重复意义，句子简洁完整。',
      '“又、重新、再次”三层叠加，赘余更重。',
      '“仍旧又”既重复又模糊了动作是否重新发生。',
    ],
  ),
  _GrammarRepairPattern(
    family: '成分缺失',
    segments: <String>['阿宁请沈砚根据', '宫门与院落的连接，', '判断路线是否适合，', '再写明成立条件。'],
    errorSegmentIndex: 2,
    correctSegment: '判断路线是否适合各自任务，',
    candidateSegments: <String>[
      '判断路线是否适合，',
      '判断路线是否适合各自任务，',
      '判断路线是否适合的条件，',
      '判断路线是否对任务，',
    ],
    whyWrong: '“适合”缺少对象，读者无法判断路线究竟适合什么。',
    revisionRule: '形容或判断“适合”时应补足适用对象，并与人物任务建立明确关系。',
    optionExplanations: <String>[
      '仍未交代“适合”的对象，信息不完整。',
      '补出“各自任务”，完整连接路线选择与人物目标。',
      '“是否适合的条件”改变了判断对象，句意不完整。',
      '“适合对任务”介词关系错误，不能补足原句。',
    ],
  ),
];

const _forbiddenCityMasteryGrammar = <_GrammarRepairPattern>[
  _GrammarRepairPattern(
    family: '关联词错误',
    segments: <String>['中轴确实提供整体框架，', '阿宁的路线也符合真实连接，', '既然两者都成立，', '就必然具有相同解释力。'],
    errorSegmentIndex: 2,
    correctSegment: '但两者成立的条件不同，',
    candidateSegments: <String>[
      '既然两者都成立，',
      '但两者成立的条件不同，',
      '只要两者都成立，',
      '即使两者同时成立，',
    ],
    whyWrong: '“既然……就必然……”把“各自可行”偷换成“解释力相同”，超出了证据允许的范围。',
    revisionRule: '高阶关联关系要控制推论强度：事实并存不等于功能、条件或解释力相同。',
    optionExplanations: <String>[
      '句法自然，但把可行性直接推出相同解释力，结论过强。',
      '准确保留两条路线都成立，同时指出成立条件不同。',
      '“只要”把并存事实写成充分条件，仍造成过度推论。',
      '“即使”需要与让步结论呼应，此处后文“必然相同”仍不成立。',
    ],
  ),
  _GrammarRepairPattern(
    family: '搭配错误',
    segments: <String>['这张图通过共同节点', '论证了两条路线的', '空间条件，', '却没有替人物决定目标。'],
    errorSegmentIndex: 1,
    correctSegment: '呈现了两条路线的',
    candidateSegments: <String>[
      '论证了两条路线的',
      '呈现了两条路线的',
      '证明了两条路线的',
      '确认了两条路线的',
    ],
    whyWrong: '地图可以“呈现”空间条件；“论证条件”把图面表达与逻辑论证混为一谈。',
    revisionRule: '近义动词都可能通顺时，要选择与材料功能最精确的搭配。',
    optionExplanations: <String>[
      '局部通顺，但“论证条件”误写了地图的表达功能。',
      '“呈现空间条件”准确描述图把连接关系显示出来。',
      '“证明空间条件”语气过强，图本身不是全部证明过程。',
      '“确认空间条件”更适合人的核对行为，不适合以图为主语。',
    ],
  ),
  _GrammarRepairPattern(
    family: '成分赘余',
    segments: <String>['沈砚保留两条路线，', '并分别各自写明', '它们成立的任务条件，', '使差异能够被检验。'],
    errorSegmentIndex: 1,
    correctSegment: '并分别写明',
    candidateSegments: <String>['并分别各自写明', '并分别写明', '并各自分别标注', '并逐一分别写明'],
    whyWrong: '“分别”和“各自”在这里承担同一分配意义，同时保留使表达重复。',
    revisionRule: '书面表达应区分必要强调与同义叠加，在不损失关系信息时删去重复成分。',
    optionExplanations: <String>[
      '“分别各自”意义重叠，句子虽可读但不够简洁。',
      '保留“分别”即可清楚对应两条路线与两组条件。',
      '“各自分别”仍然重复，并无新的关系信息。',
      '“逐一分别”在两条路线语境中重复表达分配过程。',
    ],
  ),
  _GrammarRepairPattern(
    family: '成分缺失',
    segments: <String>['若只保留中轴路线，', '图仍能说明整体秩序，', '却无法解释阿宁为何', '必须返回。'],
    errorSegmentIndex: 3,
    correctSegment: '必须返回东侧完成记录。',
    candidateSegments: <String>[
      '必须返回。',
      '必须返回东侧完成记录。',
      '必须返回路线。',
      '必须返回这个判断。',
    ],
    whyWrong: '“返回”缺少目的地和任务结果，无法回答阿宁行动路线形成的原因。',
    revisionRule: '高阶成分完整不仅是补宾语，还要补足使因果链成立的地点与目的。',
    optionExplanations: <String>[
      '句法勉强完整，但关键信息缺失，不能解释路线选择。',
      '同时补足东侧目的地与记录任务，使人物行动因果完整。',
      '“返回路线”对象关系不成立，也没有交代任务。',
      '“返回判断”语义搭配不当，无法解释阿宁的行动。',
    ],
  ),
];

_ForbiddenCityGrammarBlueprint _patternBlueprint(_GrammarRepairPattern pattern) {
  final broken = pattern.segments.join();
  String replace(String value) {
    final segments = List<String>.of(pattern.segments);
    segments[pattern.errorSegmentIndex] = value;
    return segments.join();
  }

  return _ForbiddenCityGrammarBlueprint(
    family: pattern.family,
    broken: broken,
    correct: replace(pattern.correctSegment),
    errorSegments: pattern.segments,
    errorSegmentIndex: pattern.errorSegmentIndex,
    options: pattern.candidateSegments.map(replace).toList(growable: false),
    whyWrong: pattern.whyWrong,
    revisionRule: pattern.revisionRule,
    optionExplanations: pattern.optionExplanations,
  );
}

_ForbiddenCityGrammarBlueprint _contextualizeGrammar(
  _ForbiddenCityGrammarBlueprint source,
  String context,
) =>
    _ForbiddenCityGrammarBlueprint(
      family: source.family,
      broken: '$context${source.broken}',
      correct: '$context${source.correct}',
      errorSegments: <String>[
        '$context${source.errorSegments.first}',
        ...source.errorSegments.skip(1),
      ],
      errorSegmentIndex: source.errorSegmentIndex,
      options: source.options.map((option) => '$context$option').toList(),
      whyWrong: source.whyWrong,
      revisionRule: source.revisionRule,
      optionExplanations: source.optionExplanations,
    );

_ForbiddenCityGrammarBlueprint _forbiddenCityGrammarBlueprint(
  int level,
  int index,
) {
  final band = ((level.clamp(1, 10).toInt() - 1) ~/ 2).clamp(0, 4);
  return switch (band) {
    0 => _forbiddenCityGrammarBlueprints[index],
    1 => _contextualizeGrammar(
        _forbiddenCityGrammarBlueprints[index],
        '读完路线图后，',
      ),
    2 => _contextualizeGrammar(
        _patternBlueprint(_forbiddenCityIntermediateGrammar[index]),
        '在紫禁城中，',
      ),
    3 => _contextualizeGrammar(
        _patternBlueprint(_forbiddenCityIntermediateGrammar[index]),
        '综合紫禁城空间事实与人物任务后，',
      ),
    _ => _contextualizeGrammar(
        _patternBlueprint(_forbiddenCityMasteryGrammar[index]),
        '讨论紫禁城路线时，',
      ),
  };
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

class _CompletionLexeme {
  const _CompletionLexeme(this.value, this.slot);
  final String value;
  final String slot;
}

const _forbiddenCityCompletionLexemes = <_CompletionLexeme>[
  _CompletionLexeme('沈砚', 'PERSON'),
  _CompletionLexeme('阿宁', 'PERSON'),
  _CompletionLexeme('周师傅', 'PERSON'),
  _CompletionLexeme('参观者', 'PERSON'),
  _CompletionLexeme('紫禁城', 'PLACE'),
  _CompletionLexeme('宫城', 'PLACE'),
  _CompletionLexeme('午门', 'PLACE'),
  _CompletionLexeme('乾清门', 'PLACE'),
  _CompletionLexeme('外朝', 'PLACE'),
  _CompletionLexeme('内廷', 'PLACE'),
  _CompletionLexeme('中轴', 'DIRECTION'),
  _CompletionLexeme('中轴线', 'DIRECTION'),
  _CompletionLexeme('东侧', 'DIRECTION'),
  _CompletionLexeme('东边', 'DIRECTION'),
  _CompletionLexeme('北侧', 'DIRECTION'),
  _CompletionLexeme('西侧', 'DIRECTION'),
  _CompletionLexeme('观察', 'ACTION'),
  _CompletionLexeme('记录', 'ACTION'),
  _CompletionLexeme('比较', 'ACTION'),
  _CompletionLexeme('核对', 'ACTION'),
  _CompletionLexeme('判断', 'ACTION'),
  _CompletionLexeme('标出', 'ACTION'),
  _CompletionLexeme('保留', 'ACTION'),
  _CompletionLexeme('连接', 'ACTION'),
  _CompletionLexeme('整理', 'ACTION'),
  _CompletionLexeme('选择', 'ACTION'),
  _CompletionLexeme('路线', 'OBJECT'),
  _CompletionLexeme('路线图', 'OBJECT'),
  _CompletionLexeme('任务', 'OBJECT'),
  _CompletionLexeme('任务条件', 'OBJECT'),
  _CompletionLexeme('证据', 'OBJECT'),
  _CompletionLexeme('目标', 'OBJECT'),
  _CompletionLexeme('记录点', 'OBJECT'),
  _CompletionLexeme('共同终点', 'OBJECT'),
  _CompletionLexeme('宫门', 'OBJECT'),
  _CompletionLexeme('院落', 'OBJECT'),
  _CompletionLexeme('空间', 'CULTURAL_CONCEPT'),
  _CompletionLexeme('空间关系', 'CULTURAL_CONCEPT'),
  _CompletionLexeme('礼制', 'CULTURAL_CONCEPT'),
  _CompletionLexeme('秩序', 'CULTURAL_CONCEPT'),
  _CompletionLexeme('功能', 'CULTURAL_CONCEPT'),
  _CompletionLexeme('中轴关系', 'CULTURAL_CONCEPT'),
  _CompletionLexeme('空间秩序', 'CULTURAL_CONCEPT'),
  _CompletionLexeme('共同节点', 'CULTURAL_CONCEPT'),
  _CompletionLexeme('因为', 'CONNECTOR'),
  _CompletionLexeme('所以', 'CONNECTOR'),
  _CompletionLexeme('虽然', 'CONNECTOR'),
  _CompletionLexeme('但是', 'CONNECTOR'),
  _CompletionLexeme('却', 'CONNECTOR'),
  _CompletionLexeme('而是', 'CONNECTOR'),
  _CompletionLexeme('为了', 'CONNECTOR'),
  _CompletionLexeme('因此', 'CONNECTOR'),
  _CompletionLexeme('不同', 'ATTRIBUTE'),
  _CompletionLexeme('相同', 'ATTRIBUTE'),
  _CompletionLexeme('清楚', 'ATTRIBUTE'),
  _CompletionLexeme('完整', 'ATTRIBUTE'),
];

String _forbiddenCitySlotFor(String value) => _forbiddenCityCompletionLexemes
    .firstWhere(
      (item) => item.value == value,
      orElse: () => const _CompletionLexeme('', 'SHORT_PHRASE'),
    )
    .slot;

bool _looksLikeLexicalFragment(String value) =>
    value.trim().isEmpty ||
    const {'的任', '是把', '路线因', '的一', '任务的'}.contains(value);

List<_TextSpan> _forbiddenCityCompletionSpans(String passage) {
  final lexemes = [..._forbiddenCityCompletionLexemes]
    ..sort((a, b) => b.value.length.compareTo(a.value.length));
  final spans = <_TextSpan>[];
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
    spans.add(_TextSpan(cursor, cursor + match.value.length));
    cursor += match.value.length;
  }
  return spans;
}

String _forbiddenCityCompletionPassage(
  _Source source,
  List<_Source> all,
  int level,
) {
  var passage = source.sentence.trim();
  var cursor = 1;
  while (_forbiddenCityCompletionSpans(passage).length < level &&
      cursor < all.length) {
    final next = all[(all.indexOf(source) + cursor) % all.length].sentence.trim();
    if (!passage.contains(next)) passage = '$passage$next';
    cursor += 1;
  }
  if (_forbiddenCityCompletionSpans(passage).length < level) {
    throw StateError('Forbidden City Lv$level lacks whole lexical blank spans.');
  }
  return passage;
}

List<String> _forbiddenCityBlankOptions({
  required String answer,
  required String slot,
  required String journeyId,
  required int level,
  required String questionId,
  required int blankIndex,
}) {
  final pool = _forbiddenCityCompletionLexemes
      .where((item) => item.slot == slot && item.value != answer)
      .map((item) => item.value)
      .toList(growable: false);
  final ranked = [...pool]
    ..sort((a, b) {
      final lengthA = (_hanCount(a) - _hanCount(answer)).abs();
      final lengthB = (_hanCount(b) - _hanCount(answer)).abs();
      if (lengthA != lengthB) return lengthA.compareTo(lengthB);
      return _hash('$questionId:$blankIndex:$a')
          .compareTo(_hash('$questionId:$blankIndex:$b'));
    });
  if (ranked.length < 3) {
    throw StateError('Forbidden City slot $slot needs three distractors.');
  }
  final options = <String>[answer, ...ranked.take(3)];
  return _stableHashShuffle(
    options,
    '$journeyId:$level:$questionId:$blankIndex',
  );
}

List<String> _stableHashShuffle(List<String> values, String seed) {
  final result = List<String>.of(values);
  var state = int.parse(_hash(seed), radix: 16);
  for (var index = result.length - 1; index > 0; index--) {
    state = (state * 1664525 + 1013904223) & 0xffffffff;
    final swap = state % (index + 1);
    final value = result[index];
    result[index] = result[swap];
    result[swap] = value;
  }
  return result;
}

bool _hasSimpleFourPositionCycle(List<int> positions) {
  if (positions.length < 8) return false;
  for (var index = 4; index < positions.length; index++) {
    if (positions[index] != positions[index % 4]) return false;
  }
  return true;
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
