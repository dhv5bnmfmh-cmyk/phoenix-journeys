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

const forbiddenCityParagraphRebuild = <ForbiddenCityParagraphRebuild>[
  ForbiddenCityParagraphRebuild(level: 1, segments: ['沈砚很想进去。', '后来，一道通往更深宫院的门打开了。', '门后正好是他路线图上没有画出来的地方。', '周师傅和顾文澜正在另一边看记录，没有注意沈砚。'], correctOrder: [1, 3, 2, 0]),
  ForbiddenCityParagraphRebuild(level: 2, segments: ['这一次，没有人叫他停下。', '沈砚向前走了几步，来到门槛前。', '他心里反而更乱了。', '门开着。'], correctOrder: [1, 0, 2, 3]),
  ForbiddenCityParagraphRebuild(level: 3, segments: ['没有人阻止他。', '他走到门槛前。', '这反而让选择变得更难。', '这一次，他必须自己决定。'], correctOrder: [1, 0, 2, 3]),
  ForbiddenCityParagraphRebuild(level: 4, segments: ['因为以前的边界来自周师傅的提醒，而现在，真正的边界只存在于他自己的判断中。', '他走到门槛前。', '这一次的停顿，比之前任何一次都困难。', '沈砚盯着门后的院落。'], correctOrder: [1, 2, 0, 3]),
  ForbiddenCityParagraphRebuild(level: 5, segments: ['真正的边界，不再来自别人的命令，而来自他自己的判断。', '他向前走了几步。', '最后停在门槛之前。', '那一刻，他忽然发现，这一次和之前完全不同。'], correctOrder: [1, 2, 3, 0]),
  ForbiddenCityParagraphRebuild(level: 6, segments: ['他突然非常想证明，自己今天真的“看懂”了紫禁城。', '这一次，没有周师傅替他决定。', '沈砚盯着门后的院落，又低头看自己那张还留着空白的地图。', '正因为没有人说“停”，这个选择反而比一路上任何一次都更困难。'], correctOrder: [1, 3, 2, 0]),
  ForbiddenCityParagraphRebuild(level: 7, segments: ['门是打开的。', '边界却没有消失。', '“能够过去”和“应该过去”，原来从来不是同一件事。', '沈砚第一次被迫区分两件事：'], correctOrder: [0, 1, 3, 2]),
  ForbiddenCityParagraphRebuild(level: 8, segments: ['空间不只是容纳人。', '它还区分人。', '同一座宫城，对不同身份的人并不以同一种方式开放。', '自己此刻站在门前，可以偷偷向前，却没有合理的职责要求他进入。'], correctOrder: [3, 2, 0, 1]),
  ForbiddenCityParagraphRebuild(level: 9, segments: ['宫门既连接，也拒绝。', '院落既容纳，也区分。', '中轴既组织建筑，也组织中心与边缘。', '所谓空间等级，并不是建筑师画在图纸上的一个抽象体系，而是无数人的日常行动不断把它变成现实。'], correctOrder: [0, 1, 2, 3]),
  ForbiddenCityParagraphRebuild(level: 10, segments: ['有些理解来自停下。', '并不是所有理解都来自进入。', '来自看到边界之后，不急着把它变成自己的通道。', '此刻回望，他才第一次承认：'], correctOrder: [3, 1, 0, 2]),
];

const forbiddenCityGrammarRepair = <ForbiddenCityGrammarRepair>[
  ForbiddenCityGrammarRepair(level: 1, broken: '沈砚没有跨过去最后。', correct: '最后，沈砚没有跨过去。', focus: '时间副词“最后”的位置'),
  ForbiddenCityGrammarRepair(level: 2, broken: '可是自己知道，他并不应该进去。', correct: '可是他知道，自己并不应该进去。', focus: '主语与反身代词“自己”的指向'),
  ForbiddenCityGrammarRepair(level: 3, broken: '这让选择反而变得更难。', correct: '这反而让选择变得更难。', focus: '“反而”表达与预期相反的结果'),
  ForbiddenCityGrammarRepair(level: 4, broken: '如果现在进去，所以他就能亲眼补上那一块。', correct: '如果现在进去，他就能亲眼补上那一块。', focus: '如果……就……'),
  ForbiddenCityGrammarRepair(level: 5, broken: '此前，他一直把宫中的限制理解自己这个外来学徒的不便。', correct: '此前，他一直把宫中的限制理解为自己这个外来学徒的不便。', focus: '理解为'),
  ForbiddenCityGrammarRepair(level: 6, broken: '这一次，周师傅没有替决定他。', correct: '这一次，没有周师傅替他决定。', focus: '“替 + 人 + 动词”的结构与否定位置'),
  ForbiddenCityGrammarRepair(level: 7, broken: '有时候，一个人在一座建筑中越生活得久，反而越清楚哪些空间并不属于自己的行动范围。', correct: '有时候，一个人在一座建筑中生活得越久，反而越清楚哪些空间并不属于自己的行动范围。', focus: '越……越……中的结构位置'),
  ForbiddenCityGrammarRepair(level: 8, broken: '即使没有大型典礼正在举行，但是空间依然保存着那套组织人与位置的逻辑。', correct: '即使没有大型典礼正在举行，空间依然保存着那套组织人与位置的逻辑。', focus: '即使……依然……'),
  ForbiddenCityGrammarRepair(level: 9, broken: '他对“理解”其实非常接近“占有”的想象仍没有察觉。', correct: '然而，此刻的他仍没有察觉，自己对“理解”的想象其实非常接近“占有”。', focus: '复杂主语与状语顺序'),
  ForbiddenCityGrammarRepair(level: 10, broken: '并不是所有理解来自进入都。', correct: '并不是所有理解都来自进入。', focus: '并不是所有……都……'),
];

const forbiddenCityMissingSentence = <ForbiddenCityMissingSentence>[
  ForbiddenCityMissingSentence(level: 1, before: '沈砚很想进去。', answer: '只要向前走几步，他就能看到更多地方。', after: '他走到门槛前，却停了下来。'),
  ForbiddenCityMissingSentence(level: 2, before: '这一次，没有人叫他停下。', answer: '他心里反而更乱了。', after: '门开着。'),
  ForbiddenCityMissingSentence(level: 3, before: '没有人阻止他。', answer: '这反而让选择变得更难。', after: '以前，每一次停下，都是因为周师傅叫他停。'),
  ForbiddenCityMissingSentence(level: 4, before: '这一刻，沈砚终于理解，宫门并不只是把两个院落连接起来。', answer: '它同时区分空间功能、身份和行动。', after: '所谓空间等级，并不是画在纸上的抽象概念，而是每天通过人的脚步变得真实。'),
  ForbiddenCityMissingSentence(level: 5, before: '一路上，周师傅已经叫停过他很多次。', answer: '可这一次，没有任何人说“不能”。', after: '真正的边界，不再来自别人的命令，而来自他自己的判断。'),
  ForbiddenCityMissingSentence(level: 6, before: '两个人都在紫禁城中。', answer: '但“在这里”并不意味着“哪里都能去”。', after: '沈砚重新看向眼前的门槛。'),
  ForbiddenCityMissingSentence(level: 7, before: '门是打开的。', answer: '边界却没有消失。', after: '沈砚第一次被迫区分两件事：'),
  ForbiddenCityMissingSentence(level: 8, before: '空间不只是容纳人。', answer: '它还区分人。', after: '沈砚重新看向门槛。'),
  ForbiddenCityMissingSentence(level: 9, before: '礼制并不是后来附着在建筑上的说明。', answer: '建筑本身就是礼制秩序的一种空间表达。', after: '这一发现让他兴奋。'),
  ForbiddenCityMissingSentence(level: 10, before: '并不是所有理解都来自进入。', answer: '有些理解来自停下。', after: '来自看到边界之后，不急着把它变成自己的通道。'),
];
