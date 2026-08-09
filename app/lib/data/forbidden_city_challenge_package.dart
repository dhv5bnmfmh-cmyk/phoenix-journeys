import 'forbidden_city_journey_runtime.dart';

class ForbiddenCityParagraphRebuild {
  const ForbiddenCityParagraphRebuild({
    required this.level,
    required this.segments,
    required this.correctOrder,
  });

  final int level;
  final List<String> segments;
  final List<int> correctOrder;
}

class ForbiddenCityGrammarRepair {
  const ForbiddenCityGrammarRepair({
    required this.level,
    required this.broken,
    required this.correct,
    required this.focus,
  });

  final int level;
  final String broken;
  final String correct;
  final String focus;
}

class ForbiddenCityMissingSentence {
  const ForbiddenCityMissingSentence({
    required this.level,
    required this.before,
    required this.answer,
    required this.after,
  });

  final int level;
  final String before;
  final String answer;
  final String after;
}

List<String> _sentences(String story) => RegExp(r'[^。！？!?]+[。！？!?]')
    .allMatches(story)
    .map((match) => match.group(0)!.trim())
    .where((sentence) => sentence.isNotEmpty)
    .toList(growable: false);

const _synthesisAnswers = <String>[
  '沈砚没有擦掉任何一条，而是把两条都描清楚。',
  '沈砚决定不删掉任何一条，而是用两种线把它们都保留下来。',
  '他选择把两条线叠在同一张图上，并用不同线型保留它们。',
  '沈砚作出决定：不选一条覆盖另一条，而在同一张纸上用实线和点线保留两种走法。',
  '他把两种线型叠在一张图上，并在交会处标出共同节点。',
  '他选择把两条路线叠进同一张图，用不同线型保存各自的完整路径，而不是删掉一条。',
  '他作出决定，在同一张图上用实线与点线完整保留两条路线，并把交会处标为共享节点。',
  '沈砚选择保留差异：他用两种线型叠画路线，让共同节点、重合段和分岔同时可见。',
  '他主动选择用不同线型完整保存两条路径，再画出共同节点与分岔关系。',
  '沈砚于是选择合成，而不是裁决。',
];

const _grammarCorrect = <String>[
  '两条线在这里相遇，又向不同方向分开。',
  '两条线短暂重合，又向不同方向分开。',
  '两条路线在那里相遇，随后因为两人的事情不同而分开。',
  '到了乾清门前，两条线终于对齐，随后又分向不同方向。',
  '两条线短暂重合；再往后，一条继续服务沈砚的学习观察，另一条随阿宁的事情转向别处。',
  '两人在乾清门前把两张图对齐时，路线短暂合在一起，随后再次分开。',
  '乾清门前成为关键：两条路线在这里接近、重合，再向不同方向展开。',
  '两条路线在共享节点短暂叠合，随后因目的不同而分开。',
  '比较后，他们发现两条路线在这个重要连接节点短暂重合，随后因为角色和目的不同而分岔。',
  '路线在乾清门前短暂重合，又因角色和目的不同向不同方向延伸。',
];

const _grammarBroken = <String>[
  '两条线在这里相遇，又不同方向向分开。',
  '两条线短暂重合，又不同方向向分开。',
  '两条路线在那里相遇，因为随后两人的事情不同而分开。',
  '到了乾清门前，两条线终于对齐，随后不同方向又分向。',
  '两条线短暂重合；再往后，一条继续服务学习观察沈砚，另一条随阿宁的事情转向别处。',
  '两人在乾清门前把两张图对齐时，路线短暂一起合，随后再次分开。',
  '乾清门前成为关键：两条路线在这里接近、重合，再不同方向向展开。',
  '两条路线在共享节点短暂叠合，随后目的因不同而分开。',
  '比较后，他们发现两条路线在这个重要连接节点短暂重合，随后因为角色和目的不同分岔而。',
  '路线在乾清门前短暂重合，又角色和目的因不同向不同方向延伸。',
];

const _grammarFocus = <String>[
  '“向 + 方向 + 动词”的自然语序',
  '方向补语的自然位置',
  '“随后因为……”表示先后与原因',
  '“分向不同方向”的动补结构',
  '定语“沈砚的”修饰“学习观察”',
  '“合在一起”的结果补语',
  '“向不同方向展开”的介词结构',
  '“因……不同而……”因果结构',
  '“分岔”作句末谓语',
  '“因角色和目的不同”原因状语的位置',
];

final forbiddenCityParagraphRebuild = <ForbiddenCityParagraphRebuild>[
  for (var index = 0; index < forbiddenCityLockedStories.length; index += 1)
    (() {
      final sentences = _sentences(forbiddenCityLockedStories[index]);
      final answerIndex = sentences.indexOf(_synthesisAnswers[index]);
      final start = (answerIndex - 2).clamp(0, sentences.length - 4).toInt();
      final ordered = sentences.sublist(start, start + 4);
      return ForbiddenCityParagraphRebuild(
        level: index + 1,
        segments: <String>[ordered[2], ordered[0], ordered[3], ordered[1]],
        correctOrder: const <int>[1, 3, 0, 2],
      );
    })(),
];

final forbiddenCityGrammarRepair = <ForbiddenCityGrammarRepair>[
  for (var index = 0; index < 10; index += 1)
    ForbiddenCityGrammarRepair(
      level: index + 1,
      broken: _grammarBroken[index],
      correct: _grammarCorrect[index],
      focus: _grammarFocus[index],
    ),
];

final forbiddenCityMissingSentence = <ForbiddenCityMissingSentence>[
  for (var index = 0; index < forbiddenCityLockedStories.length; index += 1)
    (() {
      final sentences = _sentences(forbiddenCityLockedStories[index]);
      final answerIndex = sentences.indexOf(_synthesisAnswers[index]);
      if (answerIndex <= 0 || answerIndex >= sentences.length - 1) {
        throw StateError(
          'Forbidden City Lv.${index + 1} synthesis sentence must have before/after context.',
        );
      }
      return ForbiddenCityMissingSentence(
        level: index + 1,
        before: sentences[answerIndex - 1],
        answer: sentences[answerIndex],
        after: sentences[answerIndex + 1],
      );
    })(),
];
