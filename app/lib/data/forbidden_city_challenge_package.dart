import 'forbidden_city_journey_runtime.dart';

class ForbiddenCityParagraphRebuild {
  const ForbiddenCityParagraphRebuild({
    required this.level,
    required this.segments,
    required this.correctOrder,
    required this.cognitiveTarget,
    required this.explanation,
  });

  final int level;
  final List<String> segments;
  final List<int> correctOrder;
  final String cognitiveTarget;
  final String explanation;
}

class ForbiddenCityGrammarRepair {
  const ForbiddenCityGrammarRepair({
    required this.level,
    required this.broken,
    required this.correct,
    required this.focus,
    required this.evidenceQuestion,
    required this.evidenceAnswer,
  });

  final int level;
  final String broken;
  final String correct;
  final String focus;
  final String evidenceQuestion;
  final String evidenceAnswer;
}

class ForbiddenCityMissingSentence {
  const ForbiddenCityMissingSentence({
    required this.level,
    required this.before,
    required this.answer,
    required this.after,
    required this.transferQuestion,
    required this.transferOptions,
    required this.transferAnswer,
    required this.sourceEvidence,
  });

  final int level;
  final String before;
  final String answer;
  final String after;
  final String transferQuestion;
  final List<String> transferOptions;
  final String transferAnswer;
  final String sourceEvidence;
}

List<String> _sentences(String story) => RegExp(r'[^。！？!?]+[。！？!?]')
    .allMatches(story)
    .map((match) => match.group(0)!.trim())
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

List<String> _storyWindow(int level) {
  final sentences = _sentences(forbiddenCityLockedStories[level - 1]);
  if (sentences.length < 4) {
    throw StateError('Forbidden City Lv$level needs at least four Story sentences.');
  }
  final start = level <= 3
      ? 0
      : level <= 6
          ? ((sentences.length - 4) ~/ 2)
          : sentences.length - 4;
  return sentences.sublist(start, start + 4);
}

final forbiddenCityParagraphRebuild = <ForbiddenCityParagraphRebuild>[
  for (var level = 1; level <= 10; level += 1)
    (() {
      final ordered = _storyWindow(level);
      return ForbiddenCityParagraphRebuild(
        level: level,
        segments: <String>[ordered[2], ordered[0], ordered[3], ordered[1]],
        correctOrder: const <int>[1, 3, 0, 2],
        cognitiveTarget: level <= 3
            ? 'Story comprehension: 人物、地点、行动与结果顺序'
            : level <= 6
                ? 'Story comprehension: 路线冲突怎样导致重新检查与选择'
                : level <= 8
                    ? 'Story comprehension: 证据怎样改变人物判断'
                    : 'Story comprehension: 多重证据、人物选择与关系变化的叙事链',
        explanation: '先建立当前等级 Story 的事件链，再判断每一步如何制造下一步的原因或结果。',
      );
    })(),
];

const _grammarCorrect = <String>[
  '她要把一份记录送到东边，目标和沈砚不同。',
  '两条线都能到乾清门前，却服务不同任务。',
  '两人重新对照宫门、院落、方向和共同终点，发现两条路线都能走通，只是目标不同。',
  '建筑相同，不代表我们的目标相同。',
  '沈砚发现，自己的线适合说明中轴关系，阿宁的线更直接地服务她的任务。',
  '她的路线没有复制沈砚的线，却同样利用真实的宫门和连接关系。',
  '两人面对的是同一组建筑约束，却从不同任务与视角作出选择。',
  '一条路线可以是常用框架，却不能自动取得排他的地位。',
  '自己的路线偏好来自学习任务，而不是来自一条支配所有行动的答案。',
  '若删掉阿宁的线，图会失去东侧任务的行动逻辑；若否认中轴，阿宁的局部记录又难以放回整体。',
];

const _grammarBroken = <String>[
  '她要把一份记录送到东边，所以目标和沈砚不同。',
  '两条线都能到乾清门前，因此服务不同任务。',
  '两人重新对照宫门、院落、方向和共同终点，发现两条路线都能走通，所以只是目标不同。',
  '因为建筑相同，所以我们的目标也相同。',
  '沈砚发现，自己的线适合说明中轴关系，因此阿宁的线不能服务她的任务。',
  '她的路线没有复制沈砚的线，所以不能利用真实的宫门和连接关系。',
  '两人面对的是同一组建筑约束，因此只能从相同任务与视角作出选择。',
  '一条路线只要是常用框架，就自动取得排他的地位。',
  '自己的路线偏好来自学习任务，所以它就是支配所有行动的答案。',
  '若删掉阿宁的线，图会失去东侧任务的行动逻辑；因此否认中轴也不会影响整体。',
];

const _grammarFocus = <String>[
  '区分并列事实与因果关系：送记录和目标不同并不是简单的“所以”关系。',
  '“却”表达同一终点与不同任务之间的反预期关系，比“因此”准确。',
  '“只是”限制结论范围，不能用“所以”把差异误写成单向因果。',
  '“不代表”用于限制推论：建筑相同不能推出目标相同。',
  '比较关系不能偷换成排除关系：适合中轴观察不否定另一任务路线。',
  '“却同样”保留差异与共同成立，不能把“不同”推成“不可能”。',
  '共同约束与不同选择可以并存，“却”承担关键转折。',
  '“可以……却不能……”区分解释力与排他性，避免过度推论。',
  '“来自……而不是……”纠正把任务偏好升级成普遍答案的逻辑。',
  '“若……；若……”并列两种信息损失，不能把第二个条件错误地取消。',
];

const _evidenceQuestions = <String>[
  '这句话要说明什么关系？',
  '同一终点为什么不等于同一任务？',
  '哪一项事实让“只是目标不同”成立？',
  '为什么不能从建筑相同推出目标相同？',
  '两条路线各自服务什么？',
  '“没有复制”为什么不等于“不成立”？',
  '共同建筑约束为什么仍允许不同选择？',
  '“常用”为什么不能直接推出“排他”？',
  '沈砚的路线偏好来自哪里？',
  '删掉任一路线分别会丢失什么信息？',
];

const _evidenceAnswers = <String>[
  '人物目标本来就不同，送记录只是阿宁行动的一部分。',
  '乾清门前是共同节点，但两人的下一步任务不同。',
  '两人核对同一组空间位置后，两条路线都能走通。',
  '建筑提供共同条件，人物目标仍可以不同。',
  '沈砚的线服务中轴观察，阿宁的线服务东侧记录任务。',
  '阿宁仍使用真实宫门和连接关系，只是行动目标不同。',
  '约束限定可行范围，不替所有人物指定同一目标。',
  '常用只说明一种路线有高频或解释优势，不证明其他可行路线错误。',
  '来自沈砚自己的学习任务与观察方式。',
  '删阿宁会丢失东侧任务逻辑；否认中轴会丢失整体空间关系。',
];

final forbiddenCityGrammarRepair = <ForbiddenCityGrammarRepair>[
  for (var index = 0; index < 10; index += 1)
    ForbiddenCityGrammarRepair(
      level: index + 1,
      broken: _grammarBroken[index],
      correct: _grammarCorrect[index],
      focus: _grammarFocus[index],
      evidenceQuestion: _evidenceQuestions[index],
      evidenceAnswer: _evidenceAnswers[index],
    ),
];

const _transferQuestions = <String>[
  '如果另一位学习者从东侧来到同一地点，你第一步应该怎么判断？',
  '一个人和沈砚到达同一地点，但任务不同。哪种判断最合理？',
  '新任务要求先去东边记录点，再到乾清门前。应该怎样选路线？',
  '看到一条路线没有沿中轴，你应该先检查什么？',
  '两条路线都经过真实宫门，但服务不同任务。图上应该怎么处理？',
  '新角色的路线空间上可连通，却不适合他的任务。应该怎样评价？',
  '两条路线受同一建筑约束，却由不同任务产生。哪项证据最能决定是否都成立？',
  '一种路线很常用，另一种路线更适合当前任务。应该如何判断？',
  '换成一个需要先完成东侧任务、再读整体中轴的人，最好的路线表示是什么？',
  '新情境里有三条可行路线。要判断哪条更合理，最完整的做法是什么？',
];

const _transferAnswers = <String>[
  '先看他的目标和实际连接，不因为方向不同就判错。',
  '比较两人的任务，再看两条路线是否都能在真实空间中走通。',
  '选择满足东侧任务且能连接乾清门前的路线，并说明原因。',
  '先检查建筑连接、目标和下一步行动，再判断。',
  '分别标出任务和路线，让共同节点与差异都可见。',
  '空间可行不等于任务合适，应把“能走”与“适合”分开评价。',
  '检查每条路线是否符合真实空间连接，并分别解释它服务的任务。',
  '保留常用路线的参考价值，同时选择更适合当前任务的可行路线。',
  '把共同空间骨架、中轴关系和任务路线分层表示。',
  '同时权衡建筑连接、人物目标和行动后果，并写明每条路线成立的条件。',
];

const _transferDistractorA = <String>[
  '只要不是中轴路线，就直接判错。',
  '到同一地点就说明任务完全相同。',
  '先选最直的一条，不需要看任务。',
  '只看路线是否漂亮、清楚。',
  '删掉较少使用的那条线。',
  '只要空间能走通，就一定是最佳路线。',
  '只看人物说自己走过，不检查空间关系。',
  '常用路线永远优先，不考虑当前任务。',
  '只画人物路线，不需要整体空间关系。',
  '选择最长的路线，因为证据最多。',
];

const _transferDistractorB = <String>[
  '先要求他把路线改成沈砚的线。',
  '只比较路线长度，不比较目标。',
  '让所有人都从同一个方向进入。',
  '只确认人物身份，不看建筑。',
  '把两条线画成完全一样。',
  '只看任务，不检查空间能否连接。',
  '只要目标不同，就不需要共享任何空间证据。',
  '把另一条路线当成例外，不写理由。',
  '只保留中轴，不标任务层。',
  '只问哪条最常用，不问为什么。',
];

const _transferDistractorC = <String>[
  '等两条线完全重合后再判断。',
  '把不同路线当成地图错误。',
  '把共同终点当成唯一证据。',
  '先问哪条路线更常见，然后停止检查。',
  '只写“都对”，不说明成立条件。',
  '把“能走”和“适合”当成同一个判断。',
  '只比较人物立场，不比较事实。',
  '为了公平，两条路线都不选。',
  '让任务路线服从图面整齐。',
  '把身份、任务和后果全部忽略。',
];

ForbiddenCityMissingSentence _transferRecord(int level) {
  final sentences = _sentences(forbiddenCityLockedStories[level - 1]);
  final answerIndex = (sentences.length - 2).clamp(1, sentences.length - 2).toInt();
  return ForbiddenCityMissingSentence(
    level: level,
    before: sentences[answerIndex - 1],
    answer: sentences[answerIndex],
    after: sentences[answerIndex + 1],
    transferQuestion: _transferQuestions[level - 1],
    transferOptions: <String>[
      _transferAnswers[level - 1],
      _transferDistractorA[level - 1],
      _transferDistractorB[level - 1],
      _transferDistractorC[level - 1],
    ],
    transferAnswer: _transferAnswers[level - 1],
    sourceEvidence: level <= 3
        ? 'Story 中阿宁的目标与路线不同，但两条线都能到乾清门前。'
        : level <= 6
            ? 'Story 与 Discovery 都要求同时检查建筑连接和人物任务。'
            : level <= 8
                ? 'Story 用证据、共同约束与人物视角修正沈砚的判断。'
                : 'Story 把共同空间骨架、路线偏好、任务与行动后果放进同一套判断。',
  );
}

final forbiddenCityMissingSentence = <ForbiddenCityMissingSentence>[
  for (var level = 1; level <= 10; level += 1) _transferRecord(level),
];
