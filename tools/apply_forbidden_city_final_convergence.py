from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def read(rel):
    return (ROOT / rel).read_text()


def write(rel, text):
    (ROOT / rel).write_text(text)


def replace_once(text, old, new, label):
    if old not in text:
        raise SystemExit(f"missing replacement target: {label}")
    return text.replace(old, new, 1)


def sub_once(text, pattern, repl, label, flags=re.S | re.M):
    text2, count = re.subn(pattern, repl, text, count=1, flags=flags)
    if count != 1:
        raise SystemExit(f"expected one regex match for {label}, got {count}")
    return text2


# 1) Vocabulary trace metadata.
rel = "app/lib/data/forbidden_city_journey_runtime.dart"
text = read(rel)
text = replace_once(
    text,
    """    storySource: '沈砚看见她的线偏离中轴，判断她的方法不够准确；阿宁没有接受这个判断，也没有要求他删掉自己的线。',
    firstAppearsAt: 5,""",
    """    storySource: '沈砚看到两条线不同，立刻判断阿宁走错了。',
    firstAppearsAt: 3,""",
    "判断 firstAppearsAt",
)
text = replace_once(
    text,
    """    storySource: '沈砚把差异当成错误，阿宁却要求他先检查证据。',
    firstAppearsAt: 7,""",
    """    storySource: '阿宁选择先让证据说话。',
    firstAppearsAt: 5,""",
    "证据 firstAppearsAt",
)
write(rel, text)

# 2) Challenge data: add evidence distractors.
rel = "app/lib/data/forbidden_city_challenge_package.dart"
text = read(rel)
text = replace_once(
    text,
    """    required this.evidenceQuestion,
    required this.evidenceAnswer,
  });""",
    """    required this.evidenceQuestion,
    required this.evidenceAnswer,
    required this.distractors,
  });""",
    "GrammarRepair constructor distractors",
)
text = replace_once(
    text,
    """  final String evidenceQuestion;
  final String evidenceAnswer;
}""",
    """  final String evidenceQuestion;
  final String evidenceAnswer;
  final List<String> distractors;
}""",
    "GrammarRepair distractor field",
)
evidence_distractors = r'''
const _evidenceDistractorA = <String>[
  '因为阿宁要送记录，所以沈砚的目标一定和她相反。',
  '只要两条线到同一个地方，两人的任务就应该相同。',
  '只要两条路线都能走通，就说明宫门和院落不影响路线。',
  '建筑相同，所以所有人的目标和行动顺序都应相同。',
  '沈砚的路线沿中轴，因此阿宁的路线只能算错误路线。',
  '阿宁没有复制沈砚的线，说明她没有使用真实建筑关系。',
  '共同建筑约束会自动让所有人选择同一条路线。',
  '一条路线越常用，就越能证明其他路线不合理。',
  '学习任务形成的路线偏好可以直接当成所有人的规则。',
  '只要保留阿宁的线，就可以忽略中轴在整体空间中的作用。',
];

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
'''
text = replace_once(
    text,
    "const _evidenceAnswers = <String>[\n",
    evidence_distractors + "\nconst _evidenceAnswers = <String>[\n",
    "evidence distractor arrays",
)
text = replace_once(
    text,
    """      evidenceQuestion: _evidenceQuestions[index],
      evidenceAnswer: _evidenceAnswers[index],
    ),""",
    """      evidenceQuestion: _evidenceQuestions[index],
      evidenceAnswer: _evidenceAnswers[index],
      distractors: <String>[
        _evidenceDistractorA[index],
        _evidenceDistractorB[index],
        _evidenceDistractorC[index],
      ],
    ),""",
    "evidence distractor wiring",
)
write(rel, text)

# 3) Canonical geography.
rel = "app/lib/models/geo_node.dart"
text = read(rel)
text = replace_once(
    text,
    """enum GeoNodeKind {
  world,
  country,""",
    """enum GeoNodeKind {
  world,
  continent,
  country,""",
    "continent enum",
)
write(rel, text)

rel = "app/lib/data/world_geo_catalog.dart"
text = read(rel)
text = replace_once(
    text,
    """const worldGeoCatalog = <GeoNode>[
  GeoNode(id: 'world', name: '世界', kind: GeoNodeKind.world, localType: '世界'),
  GeoNode(
    id: 'cn',""",
    """const worldGeoCatalog = <GeoNode>[
  GeoNode(id: 'world', name: '世界', kind: GeoNodeKind.world, localType: '世界'),
  GeoNode(
    id: 'asia',
    name: '亚洲',
    kind: GeoNodeKind.continent,
    localType: '洲',
    parentId: 'world',
    aliases: ['Asia'],
  ),
  GeoNode(
    id: 'cn',""",
    "Asia registry node",
)
text = replace_once(
    text,
    """    parentId: 'world',
    countryCode: 'CN',
    aliases: ['China', '中华人民共和国'],""",
    """    parentId: 'asia',
    countryCode: 'CN',
    aliases: ['China', '中华人民共和国'],""",
    "China parent Asia",
)
write(rel, text)

# 4) Remove obsolete Forbidden City Batch One production story.
rel = "app/lib/data/batch_one_journey_remediation.dart"
text = read(rel)
text = text.replace("  'beijing-forbidden-city',\n", "")
text = sub_once(
    text,
    r"^const _forbiddenCityEvents = <RemediatedSemanticEvent>\[.*?^const _bundEvents = <RemediatedSemanticEvent>\[",
    "const _bundEvents = <RemediatedSemanticEvent>[",
    "remove Forbidden City Batch One legacy block",
)
text = text.replace("  forbiddenCityRemediation,\n", "")
text = re.sub(r"^\s*'beijing-forbidden-city'\s*:\s*forbiddenCityRemediation,\s*$\n?", "", text, flags=re.M)
write(rel, text)

# 5) Challenge UI/routing.
rel = "app/lib/widgets/journey_challenge_panel.dart"
text = read(rel)

text = replace_once(
    text,
    """  String _explanationNarration(_ChallengeSession session) {
    if (session.type == JourneyChallengeType.grammarRepair) {""",
    """  String _explanationNarration(_ChallengeSession session) {
    if (session.journeyId == forbiddenCityJourneyId) {
      return '本模式获得${session.reward ?? '碎银'}。掌握情况，${session.masteryLabel}。训练目标，${session.trainingGoal}。${session.masteryAdvice}。正确答案，${session.correctAnswerText}。为什么，${session.explanation}。记忆方法，${session.memoryTip}。';
    }
    if (session.type == JourneyChallengeType.grammarRepair) {""",
    "Forbidden City explanation narration",
)

grammar_special = r'''    if (_session.journeyId == forbiddenCityJourneyId) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            key: const ValueKey('forbidden-city-evidence-claim'),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .24),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: .12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t('待检验判断 · ${grammar.originalSentence}'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.2,
                      height: 1.4,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _speakerButton(
                  grammar.originalSentence,
                  keyName: 'forbidden-city-evidence-claim-speaker',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            t('请选择最符合当前 Story 与空间证据的判断。'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          _challengeOptions(),
        ],
      );
    }
'''
text = replace_once(
    text,
    """  Widget _grammarBody() {
    final grammar = _session.grammar!;
    return Column(""",
    """  Widget _grammarBody() {
    final grammar = _session.grammar!;
""" + grammar_special + """    return Column(""",
    "Forbidden City evidence body",
)

missing_special = r'''    if (_session.journeyId == forbiddenCityJourneyId) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            key: const ValueKey('forbidden-city-transfer-evidence'),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: .12)),
            ),
            child: Text(
              t('已知证据 · ${_session.contextBefore}'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.2,
                height: 1.4,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _challengeOptions(),
        ],
      );
    }
'''
text = replace_once(
    text,
    """  Widget _missingBody() {
    return Column(""",
    """  Widget _missingBody() {
""" + missing_special + """    return Column(""",
    "Forbidden City transfer body",
)

text = sub_once(
    text,
    r"^  List<Widget> _grammarExplanationLines\(_GrammarSpec grammar\) \{.*?^  Widget _explanationLine\(",
    r'''  List<Widget> _grammarExplanationLines(_GrammarSpec grammar) {
    if (_session.journeyId == forbiddenCityJourneyId) {
      return [
        _explanationLine('待检验判断', grammar.originalSentence),
        _explanationLine('证据支持的判断', grammar.correctedSentence),
        _explanationLine('为什么', grammar.whyWrong),
        _explanationLine('判断原则', grammar.revisionRule),
        _explanationLine('记忆方法', grammar.memoryTip),
      ];
    }
    return switch (_session.difficulty) {
      JourneyChallengeDifficulty.beginner => [
        _explanationLine('错误位置', grammar.errorLocation),
        _explanationLine('修改后', grammar.correctedSentence),
        _explanationLine('为什么错误', grammar.whyWrong),
        _explanationLine('记忆方法', grammar.memoryTip),
      ],
      JourneyChallengeDifficulty.standard => [
        _explanationLine('病句类型', grammar.errorType),
        _explanationLine('错误位置', grammar.errorLocation),
        _explanationLine('原句', grammar.originalSentence),
        _explanationLine('修改后', grammar.correctedSentence),
        _explanationLine('为什么错误', grammar.whyWrong),
        _explanationLine('修改原则', grammar.revisionRule),
        _explanationLine('记忆方法', grammar.memoryTip),
      ],
      JourneyChallengeDifficulty.advanced => [
        _explanationLine('病句类型', grammar.errorType),
        _explanationLine('错误位置', grammar.errorLocation),
        _explanationLine('原句', grammar.originalSentence),
        _explanationLine('修改后', grammar.correctedSentence),
        _explanationLine('为什么错误', grammar.whyWrong),
        _explanationLine('修改原则', grammar.revisionRule),
        _explanationLine(
          '结构分析',
          '${grammar.errorType}。${grammar.whyWrong} ${grammar.revisionRule}',
        ),
        _explanationLine('记忆方法', grammar.memoryTip),
      ],
    };
  }

  Widget _explanationLine(''',
    "Forbidden City evidence explanation",
)

text = sub_once(
    text,
    r"^void _validateForbiddenCityChallengeTrace\(int level\) \{.*?^class _ChallengeSession \{",
    r'''void _validateForbiddenCityChallengeTrace(int level) {
  final story = forbiddenCityLockedStories[level - 1];
  final paragraph = forbiddenCityParagraphRebuild.singleWhere(
    (entry) => entry.level == level,
  );
  final evidence = forbiddenCityGrammarRepair.singleWhere(
    (entry) => entry.level == level,
  );
  final transfer = forbiddenCityMissingSentence.singleWhere(
    (entry) => entry.level == level,
  );

  for (final segment in paragraph.segments) {
    if (!story.contains(segment)) {
      throw StateError(
        'Forbidden City Lv$level Story comprehension is not grounded: $segment',
      );
    }
  }
  if (!story.contains(evidence.correct) ||
      evidence.evidenceQuestion.trim().isEmpty ||
      evidence.evidenceAnswer.trim().isEmpty ||
      evidence.distractors.length != 3 ||
      evidence.distractors.toSet().length != 3 ||
      evidence.distractors.contains(evidence.evidenceAnswer)) {
    throw StateError(
      'Forbidden City Lv$level evidence reasoning package is invalid.',
    );
  }
  if (!story.contains(transfer.before) ||
      !story.contains(transfer.answer) ||
      !story.contains(transfer.after) ||
      transfer.transferOptions.length != journeyChallengeOptionCount ||
      transfer.transferOptions.toSet().length != journeyChallengeOptionCount ||
      !transfer.transferOptions.contains(transfer.transferAnswer) ||
      transfer.sourceEvidence.trim().isEmpty) {
    throw StateError(
      'Forbidden City Lv$level transfer package is invalid.',
    );
  }
}

class _ChallengeSession {''',
    "Forbidden City challenge validation",
)

text = re.sub(
    r"^List<String> _forbiddenCityStorySentences\(int level\) \{.*?^\}\n\n",
    "",
    text,
    count=1,
    flags=re.S | re.M,
)

text = sub_once(
    text,
    r"^  String get typeLabel => switch \(type\) \{.*?^  \};\n\n  IconData get typeIcon",
    r'''  String get typeLabel {
    if (journeyId == forbiddenCityJourneyId) {
      return switch (type) {
        JourneyChallengeType.paragraphRebuild => '故事理解',
        JourneyChallengeType.grammarRepair => '证据推理',
        JourneyChallengeType.missingSentence => '迁移决策',
      };
    }
    return switch (type) {
      JourneyChallengeType.paragraphRebuild => '短文复原',
      JourneyChallengeType.grammarRepair => '语病修复',
      JourneyChallengeType.missingSentence => '补回句子',
    };
  }

  IconData get typeIcon''',
    "Challenge type labels",
)

text = replace_once(
    text,
    """    JourneyChallengeType.grammarRepair =>
      selectedGrammarSegment != null && selectedIds.length == 1,""",
    """    JourneyChallengeType.grammarRepair =>
      journeyId == forbiddenCityJourneyId
          ? selectedIds.length == 1
          : selectedGrammarSegment != null && selectedIds.length == 1,""",
    "Forbidden City evidence canSubmit",
)

text = sub_once(
    text,
    r"^  static _ChallengeSession _buildForbiddenCityParagraph\(.*?^  static _ChallengeSession _buildForbiddenCityGrammar\(",
    r'''  static _ChallengeSession _buildForbiddenCityParagraph(
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
      questionTitle: '故事理解',
      instruction: '当前 Lv$level：按人物行动与因果关系还原这段 Story，不靠背一句总结。',
      explanation: record.explanation,
      memoryTip: '先找人物目标，再找冲突、选择和结果。',
      trainingGoalOverride: record.cognitiveTarget,
    );
  }

  static _ChallengeSession _buildForbiddenCityGrammar(''',
    "Forbidden City Story comprehension builder",
)

text = sub_once(
    text,
    r"^  static _ChallengeSession _buildForbiddenCityGrammar\(.*?^  static _ChallengeSession _buildForbiddenCityMissing\(",
    r'''  static _ChallengeSession _buildForbiddenCityGrammar(
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
      correctedSentence: record.evidenceAnswer,
      correctOptionId: 'correct',
      correctReplacement: record.evidenceAnswer,
      distractors: record.distractors,
      errorType: '证据关系',
      errorLocation: record.broken,
      whyWrong: record.focus,
      revisionRule:
          '判断必须同时符合当前 Story 与 Discovery 的空间证据，不能靠错误因果、错误人物动机、错误空间关系或过度推论。',
      memoryTip: '先问“证据真正支持什么”，再排除把常用、相同或可行偷换成唯一的答案。',
    );
    final options = <_ChallengeOption>[
      _ChallengeOption(
        id: 'correct',
        text: record.evidenceAnswer,
        isCorrect: true,
      ),
      for (var index = 0; index < record.distractors.length; index++)
        _ChallengeOption(
          id: 'distractor-${index + 1}',
          text: record.distractors[index],
        ),
    ]..shuffle(math.Random(seed + 31));

    return _ChallengeSession(
      journeyId: forbiddenCityJourneyId,
      seed: seed,
      type: JourneyChallengeType.grammarRepair,
      difficulty: difficulty,
      options: options,
      correctIds: const <String>['correct'],
      questionTitle: '证据推理',
      instruction:
          '当前 Lv$level：${record.evidenceQuestion} 请选择最符合人物目标、Story 证据与空间关系的判断。',
      explanation: '${record.focus} ${record.evidenceAnswer}',
      memoryTip: '错误答案会偷换因果、人物动机、空间关系，或从“常用”过度推出“唯一”。',
      grammar: grammar,
      trainingGoalOverride: level <= 3
          ? '用 Story 证据判断人物与路线关系'
          : level <= 6
              ? '比较建筑连接、人物目标与路线理由'
              : level <= 8
                  ? '用多条证据修正人物判断'
                  : '识别过度推论并权衡多重空间证据',
    );
  }

  static _ChallengeSession _buildForbiddenCityMissing(''',
    "Forbidden City evidence builder",
)

text = sub_once(
    text,
    r"^  static _ChallengeSession _buildForbiddenCityMissing\(.*?^  static _ChallengeSession _buildParagraph\(",
    r'''  static _ChallengeSession _buildForbiddenCityMissing(
    int level,
    JourneyChallengeDifficulty difficulty,
    int seed,
  ) {
    final record = forbiddenCityMissingSentence.singleWhere(
      (entry) => entry.level == level,
    );
    final distractors = record.transferOptions
        .where((item) => item != record.transferAnswer)
        .toList(growable: false);
    final options = <_ChallengeOption>[
      _ChallengeOption(
        id: 'correct',
        text: record.transferAnswer,
        isCorrect: true,
      ),
      for (var index = 0; index < distractors.length; index++)
        _ChallengeOption(
          id: 'distractor-${index + 1}',
          text: distractors[index],
        ),
    ]..shuffle(math.Random(seed + 47));

    return _ChallengeSession(
      journeyId: forbiddenCityJourneyId,
      seed: seed,
      type: JourneyChallengeType.missingSentence,
      difficulty: difficulty,
      options: options,
      correctIds: const <String>['correct'],
      questionTitle: '迁移决策',
      instruction: '当前 Lv$level 新情境：${record.transferQuestion}',
      explanation:
          '这不是恢复原句。你要把当前 Journey 的原则迁移到新任务。依据：${record.sourceEvidence}',
      memoryTip: '先检查空间是否可行，再看人物目标、任务与行动后果。',
      contextBefore: record.sourceEvidence,
      contextAfter: '',
      trainingGoalOverride: level <= 3
          ? '把基本 Story 理解用于新的路线选择'
          : level <= 6
              ? '迁移“建筑条件 + 人物任务”的判断方法'
              : level <= 8
                  ? '在新情境中选择并解释关键证据'
                  : '综合空间约束、目标与后果作迁移决策',
    );
  }

  static _ChallengeSession _buildParagraph(''',
    "Forbidden City transfer builder",
)
write(rel, text)

# 6) JourneyScreen level binding.
rel = "app/lib/screens/journey_screen.dart"
text = read(rel)
text = replace_once(
    text,
    """  String get _readingLevelLabel =>
      _languageProfile?.displayLabel ?? _appState.journeyDifficulty.label;

  String _readingShapeLabel""",
    """  String get _readingLevelLabel =>
      _languageProfile?.displayLabel ?? _appState.journeyDifficulty.label;

  int get _forbiddenCitySelectedLevel {
    final explicit = _languageProfile?.phoenixLevel;
    if (explicit != null) return explicit.clamp(1, 10).toInt();
    return switch (_appState.journeyDifficulty) {
      JourneyDifficulty.easy => 1,
      JourneyDifficulty.standard => 5,
      JourneyDifficulty.challenge => 10,
    };
  }

  String _readingShapeLabel""",
    "selected Forbidden City level getter",
)

text = replace_once(
    text,
    """    if (_isForbiddenCity) {
      return buildJourneyStageNarrationItems(
        stage: 'memory',
        displayedLines: [
          for (final item in forbiddenCityMemoryReviews) ...[
            _appState.displayText(item.prompt),
            _appState.displayText(item.answer),
          ],
        ],
      );
    }""",
    """    if (_isForbiddenCity) {
      final level = _forbiddenCitySelectedLevel;
      final memory = forbiddenCityMemoryForLevel(level);
      return buildJourneyStageNarrationItems(
        stage: 'memory',
        displayedLines: [
          _appState.displayText('Lv$level Memory'),
          _appState.displayText(memory.recall),
          _appState.displayText('人物变化：${memory.characterShift}'),
          _appState.displayText('Memory Anchor：${memory.anchor}'),
          _appState.displayText('带走：${memory.takeaway}'),
        ],
      );
    }""",
    "Memory narration level binding",
)

text = replace_once(
    text,
    """    if (_isForbiddenCity) {
      return buildJourneyStageNarrationItems(
        stage: 'completion',
        displayedLines: const [
          forbiddenCityAchievementName,
          forbiddenCityJourneySummary,
          forbiddenCityMemoryAnchor,
          forbiddenCityChallengeRewardName,
          forbiddenCityChallengeRewardMeaning,
          forbiddenCityJourneyCompletion,
        ],
      );
    }""",
    """    if (_isForbiddenCity) {
      final level = _forbiddenCitySelectedLevel;
      final completion = forbiddenCityCompletionForLevel(level);
      return buildJourneyStageNarrationItems(
        stage: 'completion',
        displayedLines: [
          forbiddenCityAchievementName,
          'Lv$level Completion',
          completion.storyClosure,
          completion.discovery,
          completion.learning,
          completion.memory,
          completion.relationship,
          completion.emotionalClosure,
          completion.unlockResult,
        ],
      );
    }""",
    "Completion narration level binding",
)

text = sub_once(
    text,
    r"^  Widget _forbiddenCityMemoryPage\(\) \{.*?^  Widget _completePage\(\) \{",
    r'''  Widget _forbiddenCityMemoryPage() {
    final level = _forbiddenCitySelectedLevel;
    final memory = forbiddenCityMemoryForLevel(level);
    return _page(
      title: '旅程回忆 · Lv$level',
      narrationStage: 'memory',
      narrationItems: _memoryNarrationItems(),
      buttonText: '结束旅程',
      buttonIcon: Icons.flag_rounded,
      onNext: () => unawaited(_finishJourney()),
      child: ListView(
        key: ValueKey('forbidden-city-memory-lv-$level'),
        padding: const EdgeInsets.only(bottom: 6),
        children: [
          _ForbiddenCityCompleteCard(
            title: '回想 Story',
            body: _appState.displayText(memory.recall),
          ),
          const SizedBox(height: 6),
          _ForbiddenCityCompleteCard(
            title: '人物关系变化',
            body: _appState.displayText(memory.characterShift),
          ),
          const SizedBox(height: 6),
          _ForbiddenCityCompleteCard(
            title: 'Memory Anchor',
            body: _appState.displayText(memory.anchor),
          ),
          const SizedBox(height: 6),
          _ForbiddenCityCompleteCard(
            title: '离开这里要带走什么',
            body: _appState.displayText(memory.takeaway),
          ),
        ],
      ),
    );
  }

  Widget _completePage() {''',
    "Memory page level binding",
)

text = replace_once(
    text,
    """        memory: _isForbiddenCity
            ? forbiddenCityMemoryAnchor
            : memoryController.text.trim(),""",
    """        memory: _isForbiddenCity
            ? forbiddenCityMemoryForLevel(_forbiddenCitySelectedLevel).anchor
            : memoryController.text.trim(),""",
    "Memory persistence level binding",
)

text = sub_once(
    text,
    r"^  Widget _forbiddenCityCompletePage\(\) \{.*?^  \}\n\}\n\nclass _ForbiddenCityCompleteCard",
    r'''  Widget _forbiddenCityCompletePage() {
    final level = _forbiddenCitySelectedLevel;
    final completion = forbiddenCityCompletionForLevel(level);
    return _page(
      title: '北京已点亮 · Lv$level',
      narrationStage: 'completion',
      narrationItems: _completionNarrationItems(),
      buttonText: '返回首页',
      buttonIcon: Icons.home_outlined,
      showBack: false,
      onNext: () => unawaited(_exitJourney()),
      child: SingleChildScrollView(
        key: ValueKey('forbidden-city-completion-lv-$level'),
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedCityJourneyStamp(journey: _experience, size: 96),
            ),
            const SizedBox(height: 8),
            const Text(
              forbiddenCityAchievementName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: PhoenixTheme.red,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            _ForbiddenCityCompleteCard(
              title: 'Story closure',
              body: _appState.displayText(completion.storyClosure),
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: 'Discovery takeaway',
              body: _appState.displayText(completion.discovery),
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: 'Learning takeaway',
              body: _appState.displayText(completion.learning),
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: 'Memory Anchor',
              body: _appState.displayText(completion.memory),
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: '人物关系变化',
              body: _appState.displayText(completion.relationship),
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: 'Emotional closure',
              body: _appState.displayText(completion.emotionalClosure),
            ),
            const SizedBox(height: 6),
            _ForbiddenCityCompleteCard(
              title: 'Progress / Unlock',
              body: _appState.displayText(completion.unlockResult),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Expanded(
                    child: JourneyShareButton(
                      isTraditional: _appState.isTraditional,
                      city: _experience.city,
                      place: _experience.place,
                      compact: true,
                      label: _appState.displayText('分享旅程'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => unawaited(_restartJourney()),
                      icon: const Icon(Icons.replay_rounded, size: 16),
                      label: const Text(
                        '重新体验',
                        style: TextStyle(fontSize: 10.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForbiddenCityCompleteCard''',
    "Completion page level binding",
)
write(rel, text)

print("Forbidden City final convergence patch applied.")
