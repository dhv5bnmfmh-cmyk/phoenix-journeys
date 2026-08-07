from pathlib import Path

path = Path('app/lib/widgets/journey_challenge_panel.dart')
text = path.read_text()

old = "import 'package:flutter/material.dart';\n\nimport '../models/language_proficiency.dart';"
new = "import 'package:flutter/material.dart';\n\nimport '../data/forbidden_city_challenge_package.dart';\nimport '../data/forbidden_city_journey_runtime.dart';\nimport '../models/language_proficiency.dart';"
assert old in text
text = text.replace(old, new, 1)

old = """  void _buildSessions() {
    final difficulty = challengeDifficultyForProfile(widget.profile);
    _sessions = <_ChallengeSession>[
      for (var index = 0; index < fixedJourneyChallengeTypes.length; index++)
        _ChallengeSession.build(
          journeyId: widget.journeyId,
          storyParagraphs: widget.storyParagraphs,
          discoveryTexts: widget.discoveryTexts,
          difficulty: difficulty,
          type: fixedJourneyChallengeTypes[index],
          seed: widget.seed + index * 997,
        ),
    ];"""
new = """  void _buildSessions() {
    final difficulty = challengeDifficultyForProfile(widget.profile);
    final forbiddenCityLevel = widget.journeyId == forbiddenCityJourneyId
        ? _resolveForbiddenCityChallengeLevel(widget.storyParagraphs)
        : null;
    _sessions = <_ChallengeSession>[
      for (var index = 0; index < fixedJourneyChallengeTypes.length; index++)
        _ChallengeSession.build(
          journeyId: widget.journeyId,
          storyParagraphs: widget.storyParagraphs,
          discoveryTexts: widget.discoveryTexts,
          difficulty: difficulty,
          type: fixedJourneyChallengeTypes[index],
          seed: widget.seed + index * 997,
          forbiddenCityLevel: forbiddenCityLevel,
        ),
    ];"""
assert old in text
text = text.replace(old, new, 1)

anchor = 'class _ChallengeSession {'
helper = r'''String _normalizeForbiddenCityChallengeText(String value) =>
    value.replaceAll(RegExp(r'\s+'), '');

int _resolveForbiddenCityChallengeLevel(List<String> storyParagraphs) {
  final activeStory = _normalizeForbiddenCityChallengeText(
    storyParagraphs.join('\n\n'),
  );
  for (var index = 0; index < forbiddenCityLockedStories.length; index++) {
    if (_normalizeForbiddenCityChallengeText(
          forbiddenCityLockedStories[index],
        ) ==
        activeStory) {
      return index + 1;
    }
  }
  throw StateError(
    'Forbidden City Challenge requires an exact locked Lv1-Lv10 Story binding.',
  );
}

JourneyChallengeDifficulty _forbiddenCityChallengeDifficulty(int level) {
  if (level <= 3) return JourneyChallengeDifficulty.beginner;
  if (level <= 7) return JourneyChallengeDifficulty.standard;
  return JourneyChallengeDifficulty.advanced;
}

List<String> _forbiddenCityStorySentences(int level) {
  return forbiddenCityLockedStories[level - 1]
      .split(RegExp(r'(?<=[。！？])'))
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty)
      .toList(growable: false);
}

void _validateForbiddenCityChallengeTrace(int level) {
  final story = forbiddenCityLockedStories[level - 1];
  final paragraph = forbiddenCityParagraphRebuild.singleWhere(
    (entry) => entry.level == level,
  );
  final grammar = forbiddenCityGrammarRepair.singleWhere(
    (entry) => entry.level == level,
  );
  final missing = forbiddenCityMissingSentence.singleWhere(
    (entry) => entry.level == level,
  );

  for (final segment in paragraph.segments) {
    if (!story.contains(segment)) {
      throw StateError(
        'Forbidden City Lv$level paragraphRebuild segment is not in locked Story: $segment',
      );
    }
  }
  for (final sentence in <String>[missing.before, missing.answer, missing.after]) {
    if (!story.contains(sentence)) {
      throw StateError(
        'Forbidden City Lv$level missingSentence trace is not in locked Story: $sentence',
      );
    }
  }

  final grammarSentences = grammar.correct
      .split(RegExp(r'(?<=[。！？])'))
      .map((value) => value.trim())
      .where((value) => value.isNotEmpty);
  for (final sentence in grammarSentences) {
    if (!story.contains(sentence)) {
      throw StateError(
        'Forbidden City Lv$level grammarRepair answer is not grounded in locked Story: $sentence',
      );
    }
  }
}

'''
assert anchor in text
text = text.replace(anchor, helper + anchor, 1)

old = """  factory _ChallengeSession.build({
    required String journeyId,
    required List<String> storyParagraphs,
    required List<String> discoveryTexts,
    required JourneyChallengeDifficulty difficulty,
    required JourneyChallengeType type,
    required int seed,
  }) {
    return switch (type) {"""
new = """  factory _ChallengeSession.build({
    required String journeyId,
    required List<String> storyParagraphs,
    required List<String> discoveryTexts,
    required JourneyChallengeDifficulty difficulty,
    required JourneyChallengeType type,
    required int seed,
    int? forbiddenCityLevel,
  }) {
    if (journeyId == forbiddenCityJourneyId) {
      final level = forbiddenCityLevel;
      if (level == null) {
        throw StateError('Forbidden City Challenge level was not resolved.');
      }
      _validateForbiddenCityChallengeTrace(level);
      return _buildForbiddenCity(
        level: level,
        type: type,
        seed: seed,
      );
    }
    return switch (type) {"""
assert old in text
text = text.replace(old, new, 1)

anchor = '  static _ChallengeSession _buildParagraph(\n'
custom = r'''  static _ChallengeSession _buildForbiddenCity({
    required int level,
    required JourneyChallengeType type,
    required int seed,
  }) {
    final difficulty = _forbiddenCityChallengeDifficulty(level);
    return switch (type) {
      JourneyChallengeType.paragraphRebuild =>
        _buildForbiddenCityParagraph(level, difficulty, seed),
      JourneyChallengeType.grammarRepair =>
        _buildForbiddenCityGrammar(level, difficulty, seed),
      JourneyChallengeType.missingSentence =>
        _buildForbiddenCityMissing(level, difficulty, seed),
    };
  }

  static _ChallengeSession _buildForbiddenCityParagraph(
    int level,
    JourneyChallengeDifficulty difficulty,
    int seed,
  ) {
    final record = forbiddenCityParagraphRebuild.singleWhere(
      (entry) => entry.level == level,
    );
    final options = <_ChallengeOption>[
      for (var index = 0; index < record.segments.length; index++)
        _ChallengeOption(
          id: 'story-$index',
          text: record.segments[index],
          isCorrect: true,
        ),
    ]..shuffle(math.Random(seed + 17));
    final correctIds = record.correctOrder
        .map((index) => 'story-$index')
        .toList(growable: false);

    return _ChallengeSession(
      journeyId: forbiddenCityJourneyId,
      seed: seed,
      type: JourneyChallengeType.paragraphRebuild,
      difficulty: difficulty,
      options: options,
      correctIds: correctIds,
      questionTitle: '把散开的故事拼回来',
      instruction: '四句全部来自当前 Lv$level 故事，请按原文顺序依次点击。',
      explanation: '正确顺序完全依据当前等级的锁定故事，不使用其他等级句子。',
      memoryTip: '先找时间、动作与转折，再按原文事件推进复原。',
    );
  }

  static _ChallengeSession _buildForbiddenCityGrammar(
    int level,
    JourneyChallengeDifficulty difficulty,
    int seed,
  ) {
    final record = forbiddenCityGrammarRepair.singleWhere(
      (entry) => entry.level == level,
    );
    final grammar = _GrammarSpec(
      segments: <String>[record.broken],
      problemSegmentIndex: 0,
      originalSentence: record.broken,
      correctedSentence: record.correct,
      correctOptionId: 'correct',
      correctReplacement: record.correct,
      distractors: <String>[
        record.broken,
        '因此${record.correct}',
        '而且${record.correct}',
      ],
      errorType: record.focus,
      errorLocation: record.broken,
      whyWrong: '原句破坏了“${record.focus}”所要求的自然结构。',
      revisionRule: record.focus,
      memoryTip: '回到当前 Lv$level 故事的原句，比较语序、搭配和逻辑。',
    );
    final options = <_ChallengeOption>[
      _ChallengeOption(id: 'correct', text: record.correct, isCorrect: true),
      _ChallengeOption(id: 'broken', text: record.broken),
      _ChallengeOption(id: 'distractor-1', text: '因此${record.correct}'),
      _ChallengeOption(id: 'distractor-2', text: '而且${record.correct}'),
    ]..shuffle(math.Random(seed + 31));

    return _ChallengeSession(
      journeyId: forbiddenCityJourneyId,
      seed: seed,
      type: JourneyChallengeType.grammarRepair,
      difficulty: difficulty,
      options: options,
      correctIds: const <String>['correct'],
      questionTitle: '修好这句不自然的话',
      instruction: '先点击病句，再选择与当前 Lv$level Story 原句一致的修复。',
      explanation: record.focus,
      memoryTip: '正确答案以当前等级锁定 Story 为唯一依据。',
      grammar: grammar,
    );
  }

  static _ChallengeSession _buildForbiddenCityMissing(
    int level,
    JourneyChallengeDifficulty difficulty,
    int seed,
  ) {
    final record = forbiddenCityMissingSentence.singleWhere(
      (entry) => entry.level == level,
    );
    final candidates = _forbiddenCityStorySentences(level)
        .where(
          (sentence) =>
              sentence != record.answer &&
              sentence != record.before &&
              sentence != record.after,
        )
        .toList(growable: false)
      ..sort(
        (a, b) =>
            (a.length - record.answer.length).abs().compareTo(
                  (b.length - record.answer.length).abs(),
                ),
      );
    if (candidates.length < 3) {
      throw StateError(
        'Forbidden City Lv$level does not have enough Story-grounded missingSentence distractors.',
      );
    }
    final options = <_ChallengeOption>[
      _ChallengeOption(id: 'correct', text: record.answer, isCorrect: true),
      for (var index = 0; index < 3; index++)
        _ChallengeOption(id: 'distractor-$index', text: candidates[index]),
    ]..shuffle(math.Random(seed + 47));

    return _ChallengeSession(
      journeyId: forbiddenCityJourneyId,
      seed: seed,
      type: JourneyChallengeType.missingSentence,
      difficulty: difficulty,
      options: options,
      correctIds: const <String>['correct'],
      questionTitle: '补回故事中消失的一句',
      instruction: '前后文与正确答案全部来自当前 Lv$level 锁定 Story。',
      explanation: '正确句必须是当前等级 Story 中位于这段语境里的原句。',
      memoryTip: '同时核对前句、缺句和后句的原文连续关系。',
      contextBefore: record.before,
      contextAfter: record.after,
    );
  }

'''
assert anchor in text
text = text.replace(anchor, custom + anchor, 1)

path.write_text(text)
