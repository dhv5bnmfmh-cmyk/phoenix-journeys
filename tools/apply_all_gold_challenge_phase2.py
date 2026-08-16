from pathlib import Path

path = Path('app/lib/widgets/journey_challenge_panel.dart')
text = path.read_text(encoding='utf-8')

def replace_once(old, new, label):
    global text
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected 1 occurrence, found {count}')
    text = text.replace(old, new, 1)

replace_once(
    "import '../data/datong_yungang_gold_content.dart';\n",
    "import '../data/all_gold_challenge_gold_profiles.dart';\nimport '../data/datong_yungang_gold_content.dart';\n",
    'profile import',
)

replace_once(
'''    final datongLevel = widget.journeyId == datongYungangJourneyId
        ? _resolveDatongChallengeLevel(widget.storyParagraphs)
        : null;
    _sessions = <_ChallengeSession>[
''',
'''    final datongLevel = widget.journeyId == datongYungangJourneyId
        ? _resolveDatongChallengeLevel(widget.storyParagraphs)
        : null;
    final goldLevel =
        nonDatongGoldChallengeProfileFor(widget.journeyId) == null
            ? null
            : _challengeGoldLevel(widget.profile);
    _sessions = <_ChallengeSession>[
''',
'session gold level',
)

replace_once(
'''          forbiddenCityLevel: forbiddenCityLevel,
          datongLevel: datongLevel,
''',
'''          forbiddenCityLevel: forbiddenCityLevel,
          datongLevel: datongLevel,
          goldLevel: goldLevel,
''',
'session build args',
)

replace_once(
'''    this.grammar,
    this.contextBefore = '',
    this.contextAfter = '',
  });
''',
'''    this.grammar,
    this.contextBefore = '',
    this.contextAfter = '',
    this.trainingGoalOverride,
  });
''',
'session constructor override',
)

replace_once(
'''    int? forbiddenCityLevel,
    int? datongLevel,
  }) {
    if (journeyId == forbiddenCityJourneyId) {
''',
'''    int? forbiddenCityLevel,
    int? datongLevel,
    int? goldLevel,
  }) {
    final goldProfile = nonDatongGoldChallengeProfileFor(journeyId);
    if (goldProfile != null) {
      final level = goldLevel ??
          (throw StateError(
            '$journeyId Challenge Gold requires an active Lv1-Lv10 binding.',
          ));
      return _buildProfiledGold(
        profile: goldProfile,
        level: level,
        storyParagraphs: storyParagraphs,
        difficulty: difficulty,
        type: type,
        seed: seed,
      );
    }
    if (journeyId == forbiddenCityJourneyId) {
''',
'factory profile route',
)

replace_once(
'''  final _GrammarSpec? grammar;
  final String contextBefore;
  final String contextAfter;

  final List<String> selectedIds = <String>[];
''',
'''  final _GrammarSpec? grammar;
  final String contextBefore;
  final String contextAfter;
  final String? trainingGoalOverride;

  final List<String> selectedIds = <String>[];
''',
'training goal field',
)

replace_once(
'''  String get trainingGoal => switch ((type, difficulty)) {
''',
'''  String get trainingGoal {
    final override = trainingGoalOverride;
    if (override != null) return override;
    return switch ((type, difficulty)) {
''',
'training goal getter open',
)

needle = '''    ) =>
      '保持主题链、指代与因果连续',
  };

  String get masteryLabel {
'''
if needle not in text:
    raise SystemExit('training goal getter close: anchor not found')
text = text.replace(
    needle,
    '''    ) =>
      '保持主题链、指代与因果连续',
    };
  }

  String get masteryLabel {
''',
    1,
)

helper = r'''
  static _ChallengeSession _buildProfiledGold({
    required GoldChallengeProfile profile,
    required int level,
    required List<String> storyParagraphs,
    required JourneyChallengeDifficulty difficulty,
    required JourneyChallengeType type,
    required int seed,
  }) {
    if (level < 1 || level > 10) {
      throw RangeError.range(level, 1, 10, 'level');
    }
    return switch (type) {
      JourneyChallengeType.paragraphRebuild => _buildGoldParagraph(
          profile: profile,
          level: level,
          storyParagraphs: storyParagraphs,
          difficulty: difficulty,
          seed: seed,
        ),
      JourneyChallengeType.grammarRepair => _buildGoldGrammar(
          profile: profile,
          level: level,
          difficulty: difficulty,
          seed: seed,
        ),
      JourneyChallengeType.missingSentence => _buildGoldMissing(
          profile: profile,
          level: level,
          storyParagraphs: storyParagraphs,
          difficulty: difficulty,
          seed: seed,
        ),
    };
  }

  static int _goldWindowStart(
    double anchor,
    int sourceLength,
    int count,
  ) {
    final maxStart = math.max(0, sourceLength - count);
    if (maxStart == 0) return 0;
    return (anchor.clamp(0.0, 1.0) * maxStart).round().clamp(0, maxStart);
  }

  static List<String> _goldDistractors({
    required GoldChallengeProfile profile,
    required List<String> correctAnswers,
    required int count,
    required int level,
    required int seed,
  }) {
    final candidates = <String>[
      for (final item in profile.storyDistractors) item.text,
    ];
    if (candidates.length < count) {
      throw StateError(
        '${profile.journeyId} needs at least $count Story misconceptions.',
      );
    }
    final start = (level * 3 + seed.abs()) % candidates.length;
    final rotated = <String>[
      ...candidates.skip(start),
      ...candidates.take(start),
    ];
    return selectBalancedChallengeDistractors(
      correctAnswers: correctAnswers,
      candidates: rotated,
      count: count,
    );
  }

  static _ChallengeSession _buildGoldParagraph({
    required GoldChallengeProfile profile,
    required int level,
    required List<String> storyParagraphs,
    required JourneyChallengeDifficulty difficulty,
    required int seed,
  }) {
    final requiredCount = level <= 2 ? 2 : 3;
    final source = _extractSentences(storyParagraphs);
    if (source.length < requiredCount) {
      throw StateError(
        '${profile.journeyId} Lv$level Story is too short for paragraphRebuild.',
      );
    }
    final start = _goldWindowStart(
      profile.paragraphAnchors[level - 1],
      source.length,
      requiredCount,
    );
    final correctTexts = source
        .skip(start)
        .take(requiredCount)
        .toList(growable: false);
    final correctOptions = <_ChallengeOption>[
      for (var index = 0; index < correctTexts.length; index++)
        _ChallengeOption(
          id: 'correct-$index',
          text: correctTexts[index],
          isCorrect: true,
        ),
    ];
    final distractors = _goldDistractors(
      profile: profile,
      correctAnswers: correctTexts,
      count: journeyChallengeOptionCount - correctTexts.length,
      level: level,
      seed: seed + 17,
    );
    final options = <_ChallengeOption>[
      ...correctOptions,
      for (var index = 0; index < distractors.length; index++)
        _ChallengeOption(
          id: 'distractor-$index',
          text: distractors[index],
        ),
    ]..shuffle(math.Random(seed + 17));
    if (_startsWithCorrectOrder(options, correctOptions)) {
      options.add(options.removeAt(0));
    }

    return _ChallengeSession(
      journeyId: profile.journeyId,
      seed: seed,
      type: JourneyChallengeType.paragraphRebuild,
      difficulty: difficulty,
      options: options,
      correctIds: correctOptions.map((option) => option.id).toList(),
      questionTitle: '重建事件关系',
      instruction:
          '当前 Lv$level：${profile.paragraphPrompt} 不靠原句记忆，先判断动作、关系与因果。',
      explanation:
          '正确排序来自当前 Lv$level active Story 的事件推进；判断重点是前一动作怎样制造后一结果。',
      memoryTip: '先标出人物动作，再找不可逆的选择、成本或结果。',
      trainingGoalOverride: profile.paragraphGoals[level - 1],
    );
  }

  static _ChallengeSession _buildGoldGrammar({
    required GoldChallengeProfile profile,
    required int level,
    required JourneyChallengeDifficulty difficulty,
    required int seed,
  }) {
    final record = profile.grammar[level - 1];
    if (record.correctReplacement == record.brokenSegment ||
        record.correctedSentence == record.brokenSentence) {
      throw StateError(
        '${profile.journeyId} Lv$level grammarRepair has no real repair.',
      );
    }
    final grammar = _GrammarSpec(
      segments: <String>[record.prefix, record.brokenSegment, record.suffix],
      problemSegmentIndex: 1,
      originalSentence: record.brokenSentence,
      correctedSentence: record.correctedSentence,
      correctOptionId: 'correct',
      correctReplacement: record.correctReplacement,
      distractors: record.distractors,
      errorType: record.errorType,
      errorLocation: record.brokenSegment,
      whyWrong: record.whyWrong,
      revisionRule: record.revisionRule,
      memoryTip: record.memoryTip,
    );
    final options = <_ChallengeOption>[
      _ChallengeOption(
        id: 'correct',
        text: record.correctReplacement,
        isCorrect: true,
      ),
      for (var index = 0; index < record.distractors.length; index++)
        _ChallengeOption(
          id: 'distractor-${index + 1}',
          text: record.distractors[index],
        ),
    ]..shuffle(math.Random(seed + 31));

    if (options.map((option) => option.text).toSet().length !=
        journeyChallengeOptionCount) {
      throw StateError(
        '${profile.journeyId} Lv$level grammarRepair options must be unique.',
      );
    }

    return _ChallengeSession(
      journeyId: profile.journeyId,
      seed: seed,
      type: JourneyChallengeType.grammarRepair,
      difficulty: difficulty,
      options: options,
      correctIds: const <String>['correct'],
      questionTitle: '修好这句中文',
      instruction:
          '当前 Lv$level 语言目标：${record.errorType}。先定位不自然部分，再选最小且完整的修复。',
      explanation: record.whyWrong,
      memoryTip: record.memoryTip,
      grammar: grammar,
      trainingGoalOverride: '掌握${record.errorType}',
    );
  }

  static _ChallengeSession _buildGoldMissing({
    required GoldChallengeProfile profile,
    required int level,
    required List<String> storyParagraphs,
    required JourneyChallengeDifficulty difficulty,
    required int seed,
  }) {
    final source = _extractSentences(storyParagraphs);
    if (source.length < 3) {
      throw StateError(
        '${profile.journeyId} Lv$level Story is too short for missingSentence.',
      );
    }
    final start = _goldWindowStart(
      profile.missingAnchors[level - 1],
      source.length,
      3,
    );
    final before = source[start];
    final correct = source[start + 1];
    final after = source[start + 2];
    final distractors = _goldDistractors(
      profile: profile,
      correctAnswers: <String>[correct],
      count: journeyChallengeOptionCount - 1,
      level: level,
      seed: seed + 47,
    );
    final options = <_ChallengeOption>[
      _ChallengeOption(id: 'correct', text: correct, isCorrect: true),
      for (var index = 0; index < distractors.length; index++)
        _ChallengeOption(id: 'distractor-${index + 1}', text: distractors[index]),
    ]..shuffle(math.Random(seed + 47));

    return _ChallengeSession(
      journeyId: profile.journeyId,
      seed: seed,
      type: JourneyChallengeType.missingSentence,
      difficulty: difficulty,
      options: options,
      correctIds: const <String>['correct'],
      questionTitle: '补全上下文关系',
      instruction:
          '当前 Lv$level：${profile.missingPrompt} 答案必须同时承接前句并解释后句。',
      explanation:
          '正确答案与当前 active Story 一致，但判断依据是前后文中的人物、关系与因果，不是关键词重复。',
      memoryTip: '先问“前一句留下什么问题”，再问“后一句为什么能发生”。',
      contextBefore: before,
      contextAfter: after,
      trainingGoalOverride: profile.missingGoals[level - 1],
    );
  }

'''

anchor = "  static _ChallengeSession _buildForbiddenCity({\n"
if anchor not in text:
    raise SystemExit('profile helper insertion anchor missing')
text = text.replace(anchor, helper + anchor, 1)

level_helper = r'''
int _challengeGoldLevel(ChineseProficiencyProfile? profile) {
  final explicit = profile?.phoenixLevel;
  if (explicit != null) return explicit;
  return switch (profile?.band) {
    null || PhoenixReadingBand.beginner => 1,
    PhoenixReadingBand.elementary => 3,
    PhoenixReadingBand.intermediate => 5,
    PhoenixReadingBand.upperIntermediate => 7,
    PhoenixReadingBand.advanced => 8,
    PhoenixReadingBand.mastery => 10,
  };
}

'''
anchor2 = "int _resolveForbiddenCityChallengeLevel(List<String> storyParagraphs) {\n"
if anchor2 not in text:
    raise SystemExit('gold level helper anchor missing')
text = text.replace(anchor2, level_helper + anchor2, 1)

path.write_text(text, encoding='utf-8')
print('patched', path)

profile_path = Path('app/lib/data/all_gold_challenge_gold_profiles.dart')
profile_text = profile_path.read_text(encoding='utf-8')

def profile_replace(old, new, label):
    global profile_text
    count = profile_text.count(old)
    if count != 1:
        raise SystemExit(f'profile {label}: expected 1 occurrence, found {count}')
    profile_text = profile_text.replace(old, new, 1)

profile_replace("prefix: '沈砚把两条路线', brokenSegment: '都清楚地', suffix: '描在同一张纸上。', correctReplacement: '清楚地都', distractors: <String>['都描得清楚', '清楚都地', '都清楚的']", "prefix: '沈砚', brokenSegment: '清楚地把两条路线都', suffix: '描在同一张纸上。', correctReplacement: '把两条路线都清楚地', distractors: <String>['把都两条路线清楚地', '把两条路线清楚都地', '两条路线都把清楚地']", 'forbidden lv1')
profile_replace("prefix: '许澄', brokenSegment: '冬至前专门', suffix: '来到十七孔桥西北侧等光。', correctReplacement: '专门在冬至前'", "prefix: '许澄', brokenSegment: '专门冬至前', suffix: '来到十七孔桥西北侧等光。', correctReplacement: '专门在冬至前'", 'summer lv1')
profile_replace("prefix: '方毓', brokenSegment: '一直偷偷地', suffix: '把预约卡放在包里。', correctReplacement: '一直把预约卡偷偷地', distractors: <String>['偷偷一直地', '把一直预约卡', '一直的偷偷']", "prefix: '方毓', brokenSegment: '一直藏预约卡', suffix: '在包里。', correctReplacement: '一直把预约卡藏', distractors: <String>['一直把预约卡藏着地', '把预约卡一直藏得', '一直预约卡藏']", 'hangzhou lv1')
profile_replace("prefix: '距离亮灯只剩七分钟，', brokenSegment: '使魏舟', suffix: '必须先判断安全条件。', correctReplacement: '魏舟'", "prefix: '距离亮灯只剩七分钟，', brokenSegment: '魏舟必须先安全判断条件', suffix: '。', correctReplacement: '魏舟必须先判断安全条件'", 'nanjing lv1')
profile_replace("prefix: '秀仪', brokenSegment: '在匾额下慢慢地', suffix: '举起手机。', correctReplacement: '慢慢地在匾额下', distractors: <String>['在慢慢匾额下', '匾额下地慢慢', '慢慢的在匾额下']", "prefix: '秀仪', brokenSegment: '手机慢慢地举起', suffix: '，对着来电画面。', correctReplacement: '慢慢地举起手机', distractors: <String>['慢慢的举起手机', '慢慢地手机举起', '举起慢慢地手机']", 'guangzhou lv1')
profile_replace("prefix: '梁海', brokenSegment: '从海外寄回一份', suffix: '带拱券和柱廊的图样。', correctReplacement: '从海外寄回了一份', distractors: <String>['寄回从海外一份', '一份从海外寄回地', '从海外一份寄回']", "prefix: '梁海', brokenSegment: '寄回从海外一份', suffix: '带拱券和柱廊的图样。', correctReplacement: '从海外寄回一份', distractors: <String>['从海外一份寄回', '一份从海外寄回地', '寄从海外回一份']", 'kaiping lv1')
profile_replace("prefix: '周澄', brokenSegment: '认真地', suffix: '查看老照片和来源。', correctReplacement: '认真地', distractors: <String>['认真得', '认真的', '认真了地']", "prefix: '周澄', brokenSegment: '认真的', suffix: '查看老照片和来源。', correctReplacement: '认真地', distractors: <String>['认真得', '认真地去', '认真了']", 'longmen lv2')
profile_replace("prefix: '梁川', brokenSegment: '认真地', suffix: '读哥哥信里的条件。', correctReplacement: '认真地', distractors: <String>['认真得', '认真的', '认真了地']", "prefix: '梁川', brokenSegment: '认真的', suffix: '读哥哥信里的条件。', correctReplacement: '认真地', distractors: <String>['认真得', '认真地去', '认真了']", 'kaiping lv2')

for old, new, label in [
    ("prefix: '轮渡离开西岸后，两岸同时进入视野，', brokenSegment: '因此', suffix: '林岸开始怀疑“过去/未来”的二分。', correctReplacement: '于是'", "prefix: '轮渡离开西岸后，两岸同时进入视野，', brokenSegment: '因此所以', suffix: '林岸开始怀疑“过去/未来”的二分。', correctReplacement: '于是'", 'shanghai cause'),
    ("prefix: '他没有按停跑表，', brokenSegment: '因此', suffix: '路线从城墙继续伸向新家。', correctReplacement: '所以'", "prefix: '他没有按停跑表，', brokenSegment: '因此所以', suffix: '路线从城墙继续伸向新家。', correctReplacement: '所以'", 'xian cause'),
    ("prefix: '湿石阶上那次下意识的搀扶让方毓停住下一题，', brokenSegment: '因此', suffix: '她拿出了预约卡。', correctReplacement: '于是'", "prefix: '湿石阶上那次下意识的搀扶让方毓停住下一题，', brokenSegment: '因此所以', suffix: '她拿出了预约卡。', correctReplacement: '于是'", 'hangzhou cause'),
    ("prefix: '同一块门口既要通行又要坐茶，', brokenSegment: '因此', suffix: '竹椅不能永久占住一个位置。', correctReplacement: '所以'", "prefix: '同一块门口既要通行又要坐茶，', brokenSegment: '因此所以', suffix: '竹椅不能永久占住一个位置。', correctReplacement: '所以'", 'chengdu cause'),
    ("prefix: '剩余时间不足以重新确认改线，', brokenSegment: '所以', suffix: '魏舟没有采用最快方案。', correctReplacement: '因此'", "prefix: '剩余时间不足以重新确认改线，', brokenSegment: '因为所以', suffix: '魏舟没有采用最快方案。', correctReplacement: '因此'", 'nanjing cause'),
    ("prefix: '嘉禾往廊柱旁退了一步，', brokenSegment: '因此', suffix: '秀仪停住了拍照动作。', correctReplacement: '于是'", "prefix: '嘉禾往廊柱旁退了一步，', brokenSegment: '因此所以', suffix: '秀仪停住了拍照动作。', correctReplacement: '于是'", 'guangzhou cause'),
    ("prefix: '程朗在下一处停下等她，', brokenSegment: '因此', suffix: '外婆开始相信短暂看不见不等于走散。', correctReplacement: '于是'", "prefix: '程朗在下一处停下等她，', brokenSegment: '因此所以', suffix: '外婆开始相信短暂看不见不等于走散。', correctReplacement: '于是'", 'suzhou cause'),
    ("prefix: '她说不出模型的具体来源，', brokenSegment: '所以', suffix: '不能把它当作有据复原。', correctReplacement: '因此'", "prefix: '她说不出模型的具体来源，', brokenSegment: '因为所以', suffix: '不能把它当作有据复原。', correctReplacement: '因此'", 'longmen cause'),
    ("prefix: '村里合建众楼还缺一份投入，', brokenSegment: '因此', suffix: '梁川重新考虑只建自家独楼。', correctReplacement: '于是'", "prefix: '村里合建众楼还缺一份投入，', brokenSegment: '因此所以', suffix: '梁川重新考虑只建自家独楼。', correctReplacement: '于是'", 'kaiping cause'),
]:
    profile_replace(old, new, label)

profile_path.write_text(profile_text, encoding='utf-8')
print('patched', profile_path)
