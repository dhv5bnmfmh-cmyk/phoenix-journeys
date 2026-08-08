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
  ForbiddenCityParagraphRebuild(level: 1, segments: ['沈砚走到门槛前，却停下了。', '门后正是地图上的空白，沈砚很想进去。', '一个年幼侍役从规定的路匆匆走过。', '他明白门开着，不等于自己应该进去。'], correctOrder: [1, 2, 0, 3]),
  ForbiddenCityParagraphRebuild(level: 2, segments: ['于是沈砚没有跨过去。', '门后正好是地图上的空白。', '沈砚走到门槛前，一个年幼侍役从规定路线匆匆经过。', '他忽然想到：侍役天天在宫里，也不能想去哪里就去哪里。'], correctOrder: [1, 2, 3, 0]),
  ForbiddenCityParagraphRebuild(level: 3, segments: ['沈砚最终没有跨过去。', '门后正是沈砚地图上的空白。', '他走到门槛前，看见一个年幼侍役沿规定路线匆匆经过，突然明白同在宫中，不同身份的人也有不同的路。', '门关上后，他在第二张地图上写下“界”，有意留下空白。'], correctOrder: [1, 2, 0, 3]),
  ForbiddenCityParagraphRebuild(level: 4, segments: ['沈砚没有跨过去。', '门后的院落正是地图上的空白。', '沈砚走到门槛前，心里既兴奋又不安。', '一个年幼侍役从规定路线匆匆经过，他忽然看见身份与空间之间的边界：有人必须经过某些地方，也有人即使门开着也不应进入。'], correctOrder: [1, 2, 3, 0]),
  ForbiddenCityParagraphRebuild(level: 5, segments: ['他最终没有跨过去。', '沈砚知道自己不该进去，可门后恰好是那块最刺眼的空白。', '他向前走到门槛，甚至为自己找好理由：只是学习，只看一眼。', '就在这时，年幼侍役沿规定路线匆匆经过。'], correctOrder: [1, 2, 3, 0]),
  ForbiddenCityParagraphRebuild(level: 6, segments: ['于是他没有跨过门槛。', '他走到门槛前，没有人阻止，于是选择第一次真正落到自己手里。', '他想进去，却看见年幼侍役沿规定路线匆匆经过。', '沈砚忽然明白，门既连接空间，也界定谁能够进入。'], correctOrder: [1, 2, 3, 0]),
  ForbiddenCityParagraphRebuild(level: 7, segments: ['于是他没有跨过去。', '他走到门槛前，没有人命令他停。', '恰在此时，年幼侍役沿规定路线匆匆经过。', '沈砚忽然看见，同一座宫城并不会以同一种方式向所有身份开放：侍役有必须履行的职责，也有不能任意跨越的行动边界；自己有机会，却没有进入的理由。'], correctOrder: [1, 2, 3, 0]),
  ForbiddenCityParagraphRebuild(level: 8, segments: ['于是沈砚没有跨过门槛。', '他走到门槛前，发现最危险的理由并不是“我想违规”，而是“我是来学习，所以多看一点也合理”。', '年幼侍役恰好沿规定路线匆匆经过，让沈砚看见空间与身份的双向关系：同一扇门对不同的人意味着不同的许可、职责与限制。', '若他跨过去，地图会更满，却可能把“理解”变成对空间的占有。'], correctOrder: [1, 2, 3, 0]),
  ForbiddenCityParagraphRebuild(level: 9, segments: ['于是他没有跨过去。', '他走到门槛前，看见年幼侍役沿规定路线匆匆经过，忽然意识到所谓空间等级并非图纸上的抽象概念，而是不同身份的人每天以行走、等待、转向和禁止进入不断实现的历史现实。', '对侍役而言，某些路线是职责；对沈砚而言，这扇开着的门却只是机会。', '若把机会误认成资格，他得到的只会是更多景象，而不是更准确的理解。'], correctOrder: [1, 2, 3, 0]),
  ForbiddenCityParagraphRebuild(level: 10, segments: ['于是沈砚停下，没有跨过门槛。', '那道身影让沈砚突然看清，紫禁城的空间并非同质地向所有人开放。', '宫门既连接也区分，行动既受建筑引导，也受身份与职责限定；历史中的宏伟秩序与个人限制，往往属于同一个空间系统。', '若他只因为门开着就跨过去，便会把“可以进入”误成“有理由进入”，也把理解偷偷变成占有。'], correctOrder: [1, 2, 3, 0]),
];

const forbiddenCityGrammarRepair = <ForbiddenCityGrammarRepair>[
  ForbiddenCityGrammarRepair(level: 1, broken: '门开着，等于自己应该进去。', correct: '他明白门开着，不等于自己应该进去。', focus: '“不等于”表达条件与结论不能直接画等号'),
  ForbiddenCityGrammarRepair(level: 2, broken: '于是没有沈砚跨过去。', correct: '于是沈砚没有跨过去。', focus: '主语与否定副词的位置'),
  ForbiddenCityGrammarRepair(level: 3, broken: '外朝与内廷不只是建筑不同，人的行动方式不同也。', correct: '沈砚第一次发现，外朝与内廷不只是建筑不同，人的行动方式也不同。', focus: '“不只是……也……”结构'),
  ForbiddenCityGrammarRepair(level: 4, broken: '也有人即使门开着也应该不进入。', correct: '一个年幼侍役从规定路线匆匆经过，他忽然看见身份与空间之间的边界：有人必须经过某些地方，也有人即使门开着也不应进入。', focus: '“即使……也……”与“不应”的自然位置'),
  ForbiddenCityGrammarRepair(level: 5, broken: '而自己没有职责，却把好奇想解释资格成。', correct: '沈砚突然意识到，别人每天生活在这里，也被身份和职责限定，而自己没有职责，却想把好奇解释成资格。', focus: '“把……解释成……”结构'),
  ForbiddenCityGrammarRepair(level: 6, broken: '门既连接空间，也谁能够进入界定。', correct: '沈砚忽然明白，门既连接空间，也界定谁能够进入。', focus: '“既……也……”与动宾语序'),
  ForbiddenCityGrammarRepair(level: 7, broken: '同一座宫城不会并以同一种方式向所有身份开放。', correct: '沈砚忽然看见，同一座宫城并不会以同一种方式向所有身份开放：侍役有必须履行的职责，也有不能任意跨越的行动边界；自己有机会，却没有进入的理由。', focus: '“并不会”副词顺序'),
  ForbiddenCityGrammarRepair(level: 8, broken: '若他跨过去，地图会更满，却可能把“理解”变成占有对空间的。', correct: '若他跨过去，地图会更满，却可能把“理解”变成对空间的占有。', focus: '“把 A 变成 B”的宾语结构'),
  ForbiddenCityGrammarRepair(level: 9, broken: '若把机会误认成资格，他只会得到更多景象，而是更准确的理解。', correct: '若把机会误认成资格，他得到的只会是更多景象，而不是更准确的理解。', focus: '“而不是”对照结构'),
  ForbiddenCityGrammarRepair(level: 10, broken: '若他只因为门开着就跨过去，也会便把理解偷偷变成占有。', correct: '若他只因为门开着就跨过去，便会把“可以进入”误成“有理由进入”，也把理解偷偷变成占有。', focus: '条件句中的“便会”与并列谓语'),
];

const forbiddenCityMissingSentence = <ForbiddenCityMissingSentence>[
  ForbiddenCityMissingSentence(level: 1, before: '一个年幼侍役从规定的路匆匆走过。', answer: '沈砚走到门槛前，却停下了。', after: '他明白门开着，不等于自己应该进去。'),
  ForbiddenCityMissingSentence(level: 2, before: '沈砚走到门槛前，一个年幼侍役从规定路线匆匆经过。', answer: '他忽然想到：侍役天天在宫里，也不能想去哪里就去哪里。', after: '于是沈砚没有跨过去。'),
  ForbiddenCityMissingSentence(level: 3, before: '门后正是沈砚地图上的空白。', answer: '他走到门槛前，看见一个年幼侍役沿规定路线匆匆经过，突然明白同在宫中，不同身份的人也有不同的路。', after: '沈砚最终没有跨过去。'),
  ForbiddenCityMissingSentence(level: 4, before: '沈砚走到门槛前，心里既兴奋又不安。', answer: '一个年幼侍役从规定路线匆匆经过，他忽然看见身份与空间之间的边界：有人必须经过某些地方，也有人即使门开着也不应进入。', after: '沈砚没有跨过去。'),
  ForbiddenCityMissingSentence(level: 5, before: '他向前走到门槛，甚至为自己找好理由：只是学习，只看一眼。', answer: '就在这时，年幼侍役沿规定路线匆匆经过。', after: '沈砚突然意识到，别人每天生活在这里，也被身份和职责限定，而自己没有职责，却想把好奇解释成资格。'),
  ForbiddenCityMissingSentence(level: 6, before: '两个人都在紫禁城中，但身份、职责和行动范围并不相同。', answer: '沈砚忽然明白，门既连接空间，也界定谁能够进入。', after: '于是他没有跨过门槛。'),
  ForbiddenCityMissingSentence(level: 7, before: '恰在此时，年幼侍役沿规定路线匆匆经过。', answer: '沈砚忽然看见，同一座宫城并不会以同一种方式向所有身份开放：侍役有必须履行的职责，也有不能任意跨越的行动边界；自己有机会，却没有进入的理由。', after: '于是他没有跨过去。'),
  ForbiddenCityMissingSentence(level: 8, before: '年幼侍役恰好沿规定路线匆匆经过，让沈砚看见空间与身份的双向关系：同一扇门对不同的人意味着不同的许可、职责与限制。', answer: '若他跨过去，地图会更满，却可能把“理解”变成对空间的占有。', after: '于是沈砚没有跨过门槛。'),
  ForbiddenCityMissingSentence(level: 9, before: '对侍役而言，某些路线是职责；对沈砚而言，这扇开着的门却只是机会。', answer: '若把机会误认成资格，他得到的只会是更多景象，而不是更准确的理解。', after: '于是他没有跨过去。'),
  ForbiddenCityMissingSentence(level: 10, before: '宫门既连接也区分，行动既受建筑引导，也受身份与职责限定；历史中的宏伟秩序与个人限制，往往属于同一个空间系统。', answer: '若他只因为门开着就跨过去，便会把“可以进入”误成“有理由进入”，也把理解偷偷变成占有。', after: '于是沈砚停下，没有跨过门槛。'),
];
