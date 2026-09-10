import '../models/journey_challenge.dart';

const _journeyId = 'beijing-forbidden-city';

class _Spec {
  const _Spec({
    required this.mode,
    required this.prompt,
    required this.answer,
    required this.options,
    required this.sourceSentence,
    required this.learning,
    required this.knowledge,
    required this.language,
    required this.reasoning,
    required this.why,
    required this.difficulty,
    required this.storyEvidence,
    required this.knowledgeSource,
    this.chunks = const <String>[],
    this.errorSegments = const <String>[],
    this.errorIndex,
    this.grammarFamily,
    this.grammarRule,
  });

  final StoryChallengeMode mode;
  final String prompt;
  final String answer;
  final List<String> options;
  final String sourceSentence;
  final List<String> chunks;
  final List<String> errorSegments;
  final int? errorIndex;
  final String? grammarFamily;
  final String? grammarRule;
  final String learning;
  final String knowledge;
  final String language;
  final String reasoning;
  final String why;
  final String difficulty;
  final String storyEvidence;
  final String knowledgeSource;
}

const _levels = <List<_Spec>>[
  // Lv1 — direct recognition / recall.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：沈砚的起点和方向', answer: '沈砚从午门沿中轴向北走', options: <String>[], sourceSentence: '沈砚从午门出发，沿中轴向北走。', chunks: <String>['沈砚从午门', '沿中轴', '向北走'], learning: '理解人物起点与移动方向', knowledge: '午门与中轴', language: '介词结构与方位短语', reasoning: '按行动顺序组织语义块', why: '起点、空间框架、移动方向按自然中文顺序组成完整句。', difficulty: 'Lv1 直接顺序', storyEvidence: '沈砚从午门出发，沿中轴向北走。', knowledgeSource: '故宫博物院·午门 / 北京中轴资料'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：阿宁怎样到共同节点', answer: '阿宁从东侧来到乾清门前', options: <String>[], sourceSentence: '阿宁从东侧来到乾清门前。', chunks: <String>['阿宁从东侧', '来到', '乾清门前'], learning: '理解另一人物的到达路径', knowledge: '东侧与乾清门', language: '从…来到…', reasoning: '识别起点与终点', why: '人物、起点、到达动作和终点构成唯一自然顺序。', difficulty: 'Lv1 直接顺序', storyEvidence: '阿宁从东侧来到乾清门前。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '沈砚从午门沿中轴向北走了路线。', answer: '沈砚从午门沿中轴向北走。', options: <String>['沈砚从午门沿中轴向北走。','沈砚从午门沿中轴向北走了路线。','沈砚从午门沿中轴把向北走。','沈砚从午门沿中轴向北走着路线。'], sourceSentence: '沈砚从午门沿中轴向北走。', errorSegments: <String>['沈砚从午门','沿中轴','向北走了','路线。'], errorIndex: 2, grammarFamily: '动宾搭配', grammarRule: '移动方向表达完整时，不机械添加不自然宾语。', learning: '辨认基础动宾搭配', knowledge: '午门—中轴行动', language: '方向补语', reasoning: '区分自然搭配与机械加宾语', why: '“走了路线”不自然；Story 表达的是沿中轴向北移动。', difficulty: 'Lv1 基础搭配', storyEvidence: '沈砚从午门出发，沿中轴向北走。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '阿宁因为目标不同，但是走了另一条路线。', answer: '阿宁因为目标不同，所以走了另一条路线。', options: <String>['阿宁因为目标不同，所以走了另一条路线。','阿宁因为目标不同，但是走了另一条路线。','阿宁虽然目标不同，所以走了另一条路线。','阿宁因为目标不同，而且所以走了另一条路线。'], sourceSentence: '阿宁因为目标不同，所以走了另一条路线。', errorSegments: <String>['阿宁因为目标不同，','但是','走了','另一条路线。'], errorIndex: 1, grammarFamily: '关联词', grammarRule: '原因与结果使用匹配的因果关联。', learning: '建立简单因果关系', knowledge: '任务与路线', language: '因为…所以…', reasoning: '从人物目标推到路线结果', why: '“因为”说明原因，后文需要结果关系“所以”。', difficulty: 'Lv1 直接因果', storyEvidence: '她要把记录送回东边，目标和沈砚不同。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '两条路线都到____，所以它们有共同到达点。', answer: '乾清门前', options: <String>['乾清门前','午门外','东侧入口','外朝南端'], sourceSentence: '两条路线都到乾清门前，所以它们有共同到达点。', learning: '用上下文补全共同地点', knowledge: '乾清门共同节点', language: '地点补语', reasoning: '从 Story 直接找共同位置', why: 'Story 明确写出两条路线都到乾清门前。', difficulty: 'Lv1 直接回填', storyEvidence: '两条路线都到乾清门前。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '沈砚最后没有删掉阿宁的线，而是____。', answer: '留下两条路线', options: <String>['留下两条路线','只留下中轴','擦掉东侧路线','改走阿宁的路线'], sourceSentence: '沈砚最后没有删掉阿宁的线，而是留下两条路线。', learning: '补全人物最后行动', knowledge: '两条路线机制', language: '而是结构', reasoning: '从 Story 结局恢复行动', why: 'Story 明确写出沈砚留下两条路线。', difficulty: 'Lv1 直接事件', storyEvidence: '沈砚留下两条路线。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '哪一条 Story 证据最能说明沈砚一开始把自己的路线当成唯一答案？', answer: '他觉得这条路线最正确。', options: <String>['他觉得这条路线最正确。','阿宁从东侧来到乾清门前。','两人重新看图。','周师傅问为什么。'], sourceSentence: '他走到乾清门前，觉得这条路线最正确。', learning: '从原文选择证据', knowledge: '人物初始判断', language: '“最正确”的判断表达', reasoning: '证据句匹配结论', why: '该句直接表达沈砚的排他判断。', difficulty: 'Lv1 直接证据', storyEvidence: '他走到乾清门前，觉得这条路线最正确。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '阿宁说“我们一起看”后，两人下一步实际做了什么？', answer: '重新看图', options: <String>['重新看图','马上分开','只听周师傅解释','把路线图收起来'], sourceSentence: '阿宁说：“我们一起看。”两人重新看图。', learning: '理解事件先后', knowledge: '共同检查行为', language: '动作短语', reasoning: '根据紧邻文本恢复下一事件', why: '原文紧接着写“两人重新看图”。', difficulty: 'Lv1 事件顺序', storyEvidence: '阿宁说：“我们一起看。”两人重新看图。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '按照现有紫禁城知识，午门在 Golden Story 中最适合作为什么？', answer: '沿中轴观察的南侧入口', options: <String>['沿中轴观察的南侧入口','内廷最北端出口','东侧记录点','乾清门后的院落'], sourceSentence: '午门是紫禁城重要南侧入口，并处在中轴空间序列上。', learning: '识别午门的空间作用', knowledge: '午门与中轴', language: '地点功能表达', reasoning: '把建筑事实放回 Story 路线', why: '午门是 Story 中沈砚沿中轴观察的起点。', difficulty: 'Lv1 直接事实', storyEvidence: '沈砚从午门出发，沿中轴向北走。', knowledgeSource: '故宫博物院·午门 / 北京中轴资料'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: 'Story 中两条路线都能到达的具体建筑节点是哪一个？', answer: '乾清门前', options: <String>['乾清门前','午门门洞','故宫博物院出口','北京城外'], sourceSentence: '乾清门前是两条路线的共同到达节点。', learning: '识别共同空间节点', knowledge: '乾清门', language: '建筑专名', reasoning: '把 Story 地点与知识节点对应', why: 'Story 反复把乾清门前作为共同位置。', difficulty: 'Lv1 直接事实', storyEvidence: '两条路线都到乾清门前。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '你按沈砚的图从午门沿中轴走，发现同伴从东侧也到了乾清门前。第一步最合理的是？', answer: '先确认两条路线是否都能到达共同节点', options: <String>['先确认两条路线是否都能到达共同节点','立刻判定同伴走错','把东侧路线从图上删掉','要求同伴改走中轴'], sourceSentence: '两人重新看图。两条路线都到乾清门前。', learning: '在简单冲突中先核实事实', knowledge: '共同节点与路线', language: '行动建议句', reasoning: '先事实后判断', why: 'Story 的处理方式是先共同核对路线。', difficulty: 'Lv1 直接决定', storyEvidence: '两人重新看图。两条路线都到乾清门前。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '如果新人只记住“沿中轴向北走”，却不知道自己的任务，你应提醒他什么？', answer: '先确认目标，再决定路线', options: <String>['先确认目标，再决定路线','所有任务都走同一条线','只记住建筑名字就够了','遇到不同路线就选更长的'], sourceSentence: '她要把记录送回东边，目标和沈砚不同。', learning: '把 Story 原则迁移到新情境', knowledge: '目标影响路线', language: '先…再…结构', reasoning: '从目标推导行动', why: 'Story 的路线差异由不同目标和任务驱动。', difficulty: 'Lv1 简单迁移', storyEvidence: '她要把记录送回东边，目标和沈砚不同。', knowledgeSource: '当前 Story'),
  ],

  // Lv2 — direct cause / shared result.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：为什么路线不同', answer: '任务不同所以两条路线不同', options: <String>[], sourceSentence: '任务不同，所以两条路线不同。', chunks: <String>['任务不同','所以','两条路线不同'], learning: '理解任务与路线的因果', knowledge: '任务影响路线', language: '所以因果句', reasoning: '原因到结果', why: 'Story 用不同任务解释不同路线。', difficulty: 'Lv2 因果顺序', storyEvidence: '两条路线都能到乾清门前，但服务不同任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：两条线共享什么结果', answer: '两条路线都能到乾清门前', options: <String>[], sourceSentence: '两条路线都能到乾清门前。', chunks: <String>['两条路线','都能到','乾清门前'], learning: '识别共同结果', knowledge: '乾清门共同节点', language: '都能到', reasoning: '主体—能力—地点', why: '两条路线共享乾清门前这一到达点。', difficulty: 'Lv2 共同结果', storyEvidence: '两条路线都能到乾清门前，但服务不同任务。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '因为阿宁要送记录回东边，所以她走另一条路线但是。', answer: '因为阿宁要送记录回东边，所以她走另一条路线。', options: <String>['因为阿宁要送记录回东边，所以她走另一条路线。','因为阿宁要送记录回东边，所以她走另一条路线但是。','虽然阿宁要送记录回东边，所以她走另一条路线。','因为阿宁要送记录回东边，但是她走另一条路线。'], sourceSentence: '因为阿宁要送记录回东边，所以她走另一条路线。', errorSegments: <String>['因为阿宁要送记录回东边，','所以她','走另一条路线','但是。'], errorIndex: 3, grammarFamily: '句末成分', grammarRule: '关联词必须有完整对应分句，不能悬空。', learning: '辨认悬空连接词', knowledge: '阿宁任务与路线', language: '因果句完整性', reasoning: '判断关联词是否有对应分句', why: '句末“但是”没有承接转折内容。', difficulty: 'Lv2 完整因果', storyEvidence: '她的任务是把记录送回东边，所以她走了另一条路线。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '沈砚写下两人的目标，也同时又留下两条线。', answer: '沈砚写下两人的目标，也留下两条线。', options: <String>['沈砚写下两人的目标，也留下两条线。','沈砚写下两人的目标，也同时又留下两条线。','沈砚写下两人的目标，同时又也留下两条线。','沈砚写下两人的目标，也一起同时留下两条线。'], sourceSentence: '沈砚写下两人的目标，也留下两条线。', errorSegments: <String>['沈砚写下','两人的目标，','也同时又','留下两条线。'], errorIndex: 2, grammarFamily: '成分赘余', grammarRule: '并列或再发生关系只保留必要副词。', learning: '识别副词赘余', knowledge: '人物结局动作', language: '并列关系', reasoning: '删去重复但不改变事件', why: '“也、同时、又”重复表达关系。', difficulty: 'Lv2 简单赘余', storyEvidence: '沈砚写下两人的目标，也留下两条线。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '阿宁走另一条路线，是因为她要把记录____。', answer: '送回东边', options: <String>['送回东边','留在午门','交给沈砚保存','放到中轴线上'], sourceSentence: '阿宁走另一条路线，是因为她要把记录送回东边。', learning: '根据人物任务补全原因', knowledge: '阿宁任务', language: '趋向补语', reasoning: '由结果追溯原因', why: 'Story 明确说明记录要送回东边。', difficulty: 'Lv2 原因补全', storyEvidence: '她的任务是把记录送回东边，所以她走了另一条路线。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '周师傅没有替他们选一条路线，而是要求他们____。', answer: '说清为什么这样走', options: <String>['说清为什么这样走','只画最短路线','把东侧路线删掉','重新从午门出发'], sourceSentence: '周师傅没有替他们选一条路线，而是要求他们说清为什么这样走。', learning: '理解导师要求', knowledge: '路线理由', language: '为什么解释结构', reasoning: '从角色行为提取学习目标', why: '原文说周师傅只让他们说清为什么这样走。', difficulty: 'Lv2 目的补全', storyEvidence: '周师傅没有选一条，只让他们说清为什么这样走。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '什么证据说明阿宁的路线不是随意绕路？', answer: '她的任务是把记录送回东边', options: <String>['她的任务是把记录送回东边','她比沈砚晚到','周师傅没有说话','沈砚先画了路线'], sourceSentence: '她的任务是把记录送回东边，所以她走了另一条路线。', learning: '用人物目标支持路线选择', knowledge: '任务与路线', language: '因果证据', reasoning: '从目的解释行动', why: '任务提供了路线差异的明确理由。', difficulty: 'Lv2 原因证据', storyEvidence: '她的任务是把记录送回东边，所以她走了另一条路线。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: 'Story 最后为什么保留两条线，而不是选一条？', answer: '因为两条线服务不同任务但都能到共同节点', options: <String>['因为两条线服务不同任务但都能到共同节点','因为两条线完全一样','因为周师傅禁止修改地图','因为他们不知道乾清门在哪里'], sourceSentence: '两条路线都能到乾清门前，但服务不同任务。', learning: '综合两条直接证据', knowledge: '共同节点与不同任务', language: '因果解释', reasoning: '合并两条文本线索', why: '共同到达与不同任务共同支持保留两条路线。', difficulty: 'Lv2 双线索', storyEvidence: '两条路线都能到乾清门前，但服务不同任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '“中轴”在紫禁城学习中更接近哪一种信息？', answer: '组织南北空间关系的结构线索', options: <String>['组织南北空间关系的结构线索','某个人必须走的唯一道路','乾清门的别名','东侧入口的名称'], sourceSentence: '中轴是组织紫禁城南北空间关系的重要结构。', learning: '区分空间结构与个人路线', knowledge: '北京中轴', language: '定义判断', reasoning: '把空间概念与行动方案区分', why: '中轴是空间组织概念，不是个人唯一行动指令。', difficulty: 'Lv2 概念区分', storyEvidence: '沈砚从午门沿中轴向北走。', knowledgeSource: '北京市官方中轴资料'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '乾清门在 Story 中为什么适合用来比较两条路线？', answer: '它是两人都能到达的共同节点', options: <String>['它是两人都能到达的共同节点','它只允许从东侧进入','它位于北京城外','它与中轴没有任何关系'], sourceSentence: '乾清门前是两条路线可以比较的共同节点。', learning: '理解建筑节点的比较价值', knowledge: '乾清门空间节点', language: '共同节点概念', reasoning: '从空间节点支持路线比较', why: '共同节点让不同路线可以放在同一空间关系中比较。', difficulty: 'Lv2 关系事实', storyEvidence: '两条路线都能到乾清门前。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '你要把一份记录送回东侧，但手里只有“午门→中轴→乾清门”的常用线。最合理的做法是？', answer: '先确认任务终点，再检查适合东侧任务的路线', options: <String>['先确认任务终点，再检查适合东侧任务的路线','不看任务，照常用线走到底','把任务改成沿中轴参观','认为任何偏离中轴都错误'], sourceSentence: '任务不同会使合理路线不同。', learning: '把任务约束用于路线选择', knowledge: '任务与空间', language: '先…再…', reasoning: '根据任务筛选路线', why: 'Story 明确显示任务不同会产生不同合理路线。', difficulty: 'Lv2 简单场景', storyEvidence: '她的任务是把记录送回东边，所以她走了另一条路线。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '两个人对路线发生争执，但都说能到乾清门前。下一步怎样做最符合 Story 方法？', answer: '把两条路线放在一起核对共同点和不同任务', options: <String>['把两条路线放在一起核对共同点和不同任务','让先画图的人自动获胜','只比较哪条线画得更粗','把两张图都丢掉重画'], sourceSentence: '阿宁说：“先看路，再决定。”两人重新看图。', learning: '学习共同核对方法', knowledge: '共同节点、不同目标', language: '比较结构', reasoning: '从冲突转为证据比较', why: 'Story 用共同查看路线替代先判谁错。', difficulty: 'Lv2 比较决定', storyEvidence: '阿宁说：“先看路，再决定。”两人重新看图。', knowledgeSource: '当前 Story'),
  ],

  // Lv3 — relationship and simple inference.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：沈砚怎样形成错误判断', answer: '因为路线常用沈砚把它当成唯一答案', options: <String>[], sourceSentence: '因为这条路线清楚、常用，他认定它应该成为图上的唯一答案。', chunks: <String>['因为路线常用','沈砚把它','当成唯一答案'], learning: '理解错误判断的形成', knowledge: '常用路线与唯一答案', language: '因为+把字句', reasoning: '原因与错误结论', why: '常用性是他误推排他结论的原因。', difficulty: 'Lv3 因果判断', storyEvidence: '因为这条路线清楚、常用，他认定它应该成为图上的唯一答案。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：阿宁为核对付出什么代价', answer: '阿宁宁可晚一点也要带沈砚回看位置', options: <String>[], sourceSentence: '她宁可晚一点交记录，也要带沈砚回看刚才经过的几个位置。', chunks: <String>['阿宁宁可晚一点','也要','带沈砚回看位置'], learning: '理解人物选择与代价', knowledge: '证据核对行为', language: '宁可…也要…', reasoning: '让步与选择', why: '语义重点是接受延迟以换取核查。', difficulty: 'Lv3 选择结构', storyEvidence: '她宁可晚一点交记录，也要带沈砚回看刚才经过的几个位置。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '因为路线清楚、常用，但是沈砚认定它是唯一答案。', answer: '因为路线清楚、常用，所以沈砚认定它是唯一答案。', options: <String>['因为路线清楚、常用，所以沈砚认定它是唯一答案。','因为路线清楚、常用，但是沈砚认定它是唯一答案。','虽然路线清楚、常用，所以沈砚认定它是唯一答案。','因为路线清楚、常用，而且所以沈砚认定它是唯一答案。'], sourceSentence: '因为路线清楚、常用，所以沈砚认定它是唯一答案。', errorSegments: <String>['因为路线清楚、常用，','但是','沈砚认定','它是唯一答案。'], errorIndex: 1, grammarFamily: '关联关系', grammarRule: '先判断原因、结果、转折，再选择关联词。', learning: '辨认原因与结论', knowledge: '常用路线误判', language: '因果关联', reasoning: '判断逻辑关系', why: '这里是原因导致判断，不是转折。', difficulty: 'Lv3 逻辑关系', storyEvidence: '因为这条路线清楚、常用，他认定它应该成为图上的唯一答案。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '阿宁带沈砚回看刚才经过位置的。', answer: '阿宁带沈砚回看刚才经过的位置。', options: <String>['阿宁带沈砚回看刚才经过的位置。','阿宁带沈砚回看刚才经过位置的。','阿宁带沈砚回看刚才位置经过。','阿宁带沈砚把刚才经过的位置回看着。'], sourceSentence: '阿宁带沈砚回看刚才经过的位置。', errorSegments: <String>['阿宁带沈砚','回看','刚才经过位置','的。'], errorIndex: 3, grammarFamily: '定中结构', grammarRule: '“的”放在修饰语与中心词之间。', learning: '修复定中结构', knowledge: '回看位置', language: '的字结构', reasoning: '识别修饰关系', why: '“的”不能悬在句末。', difficulty: 'Lv3 定中结构', storyEvidence: '带沈砚回看刚才经过的几个位置。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '阿宁愿意晚一点交记录，是为了____。', answer: '和沈砚回看经过的位置', options: <String>['和沈砚回看经过的位置','证明中轴不存在','避开乾清门','让周师傅替她走'], sourceSentence: '阿宁愿意晚一点交记录，是为了和沈砚回看经过的位置。', learning: '从代价推断目的', knowledge: '证据核对', language: '为了结构', reasoning: '理解选择背后的目的', why: '延迟交记录是为了回看真实经过的位置。', difficulty: 'Lv3 目的补全', storyEvidence: '她宁可晚一点交记录，也要带沈砚回看刚才经过的几个位置。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '两人对照宫门、院落、方向和共同终点后，发现两条路线____。', answer: '都能走通，只是目标不同', options: <String>['都能走通，只是目标不同','只有中轴路线正确','都必须从午门开始','与人物任务无关'], sourceSentence: '两人对照宫门、院落、方向和共同终点后，发现两条路线都能走通，只是目标不同。', learning: '用多项观察补全结论', knowledge: '路线可行性', language: '转折复句', reasoning: '整合位置与目标', why: 'Story 的核对结果是两条线都可行、目标不同。', difficulty: 'Lv3 关系补全', storyEvidence: '发现两条路线都能走通，只是目标不同。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '哪一处最能证明阿宁不是只口头反驳，而是主动提供证据？', answer: '她带沈砚回看刚才经过的几个位置', options: <String>['她带沈砚回看刚才经过的几个位置','她从东侧来到乾清门前','她说自己的路线不同','她最后离开了'], sourceSentence: '她宁可晚一点交记录，也要带沈砚回看刚才经过的几个位置。', learning: '从行动识别证据行为', knowledge: '人物主动性', language: '证据动词', reasoning: '区分说法与验证行动', why: '回看实际位置是具体的核证行为。', difficulty: 'Lv3 行动证据', storyEvidence: '她宁可晚一点交记录，也要带沈砚回看刚才经过的几个位置。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '沈砚为什么最后请阿宁亲手标出她的路线？', answer: '他接受两条路线都成立并尊重阿宁的视角', options: <String>['他接受两条路线都成立并尊重阿宁的视角','他想让阿宁照抄中轴路线','他忘记自己的路线怎么画','周师傅要求只保留东侧路线'], sourceSentence: '沈砚把两条线同时画进一张图，并请阿宁亲手标出她的路线。', learning: '从后续行动推断态度变化', knowledge: '人物关系转变', language: '因果解释', reasoning: '由行为推断认知变化', why: '让阿宁亲手标线说明他不再把她的路线当成应删除的错误。', difficulty: 'Lv3 简单推断', storyEvidence: '沈砚把两条线同时画进一张图，并请阿宁亲手标出她的路线。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '把午门、中轴、乾清门放在同一条学习线里，主要是在观察什么？', answer: '紫禁城的南北空间序列与节点关系', options: <String>['紫禁城的南北空间序列与节点关系','北京所有街道的交通规则','只有东侧区域的院落','某个人的唯一任务'], sourceSentence: '午门、中轴与乾清门可以组成紫禁城空间观察序列。', learning: '理解中轴序列', knowledge: '午门—中轴—乾清门', language: '空间关系表达', reasoning: '由多个节点形成整体结构', why: '这些节点共同帮助理解宫城南北空间组织。', difficulty: 'Lv3 关系知识', storyEvidence: '沈砚随周师傅从午门进入紫禁城。他沿中轴记录宫门和院落。', knowledgeSource: '北京市官方中轴资料 / 故宫博物院'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '“院落”进入 Lv3 Story 后，路线判断比 Lv1 多了什么信息？', answer: '经过哪些具体空间单元', options: <String>['经过哪些具体空间单元','人物的年龄','地图的纸张颜色','谁先说话'], sourceSentence: '院落让路线包含真实经过的空间单元。', learning: '理解路线不只看起终点', knowledge: '宫门与院落', language: '空间单元词汇', reasoning: '从点扩展到路径关系', why: '院落提供路线实际经过的空间单元。', difficulty: 'Lv3 路径关系', storyEvidence: '他沿中轴记录宫门和院落。', knowledgeSource: '故宫博物院'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '现场发现两条线都能到乾清门前，但你仍怀疑其中一条。最符合 Lv3 Story 的下一步是？', answer: '回看两条线实际经过的宫门院落和方向', options: <String>['回看两条线实际经过的宫门院落和方向','只问哪条路线更常用','按画线粗细决定','把不同路线视为错误'], sourceSentence: '两人重新对照宫门、院落、方向和共同终点。', learning: '用空间证据验证路线', knowledge: '宫门、院落、方向', language: '列举结构', reasoning: '从怀疑转向可核查证据', why: 'Story 的验证方法是回看具体空间关系。', difficulty: 'Lv3 证据核查', storyEvidence: '两人重新对照宫门、院落、方向和共同终点。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '新人把“常用路线”写成“唯一正确路线”。最合理的纠正方式是？', answer: '让他比较其他可行路线的目标与空间证据', options: <String>['让他比较其他可行路线的目标与空间证据','把“常用”两个字删掉就结束','要求所有人都改走常用路线','不看路线是否真的能走通'], sourceSentence: '常走的一条路，不等于只有这一条路是对的。', learning: '纠正常用等于唯一的误推', knowledge: '路线判断', language: '比较句', reasoning: '用反例与证据限制结论', why: 'Story 用另一条可行路线与不同目标反驳排他判断。', difficulty: 'Lv3 规则迁移', storyEvidence: '常走的一条路，不等于只有这一条路是对的。', knowledgeSource: '当前 Story'),
  ],

  // Lv4 — conditions versus goals.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：共同建筑能推出共同目标吗', answer: '建筑相同不代表人物目标相同', options: <String>[], sourceSentence: '建筑相同，不代表我们的目标相同。', chunks: <String>['建筑相同','不代表','人物目标相同'], learning: '区分共同环境与不同目标', knowledge: '建筑条件与人物目标', language: '不代表结构', reasoning: '限制共同条件到共同目标的推论', why: '共同建筑不能推出相同任务目标。', difficulty: 'Lv4 关系限制', storyEvidence: '建筑相同，不代表我们的目标相同。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：建筑条件的作用边界', answer: '建筑提供连接条件却不替人物决定目标', options: <String>[], sourceSentence: '建筑提供了可行的连接条件，却没有替他们决定同一个目标。', chunks: <String>['建筑提供连接条件','却不替人物','决定目标'], learning: '理解空间条件与行动选择边界', knowledge: '建筑连接', language: '却转折', reasoning: '区分条件与决定', why: '空间约束可行性，但目标来自人物任务。', difficulty: 'Lv4 条件边界', storyEvidence: '建筑提供了可行的连接条件，却没有替他们决定同一个目标。', knowledgeSource: '故宫博物院 / 当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '如果两人都理解建筑，所以他们的线就应该完全相同。', answer: '如果两人都理解建筑，他们的线也不一定完全相同。', options: <String>['如果两人都理解建筑，他们的线也不一定完全相同。','如果两人都理解建筑，所以他们的线就应该完全相同。','虽然两人都理解建筑，所以他们的线一定相同。','只要两人都理解建筑，他们的任务就完全相同。'], sourceSentence: '如果两人都理解建筑，他们的线也不一定完全相同。', errorSegments: <String>['如果两人','都理解建筑，','所以他们的线','就应该完全相同。'], errorIndex: 2, grammarFamily: '条件与结论', grammarRule: '条件句结论强度必须受 Story 证据约束。', learning: '修复过强条件推论', knowledge: '建筑与任务', language: '如果结构', reasoning: '判断条件是否足以推出结论', why: '理解同一建筑不等于路线或任务完全相同。', difficulty: 'Lv4 推论强度', storyEvidence: '建筑相同，不代表我们的目标相同。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '阿宁把自己原先只顾赶路的记录补充完整完整。', answer: '阿宁把自己原先只顾赶路的记录补充完整。', options: <String>['阿宁把自己原先只顾赶路的记录补充完整。','阿宁把自己原先只顾赶路的记录补充完整完整。','阿宁把自己原先只顾赶路的记录完整补充完整。','阿宁把自己原先只顾赶路的记录补充得完整完整。'], sourceSentence: '阿宁把自己原先只顾赶路的记录补充完整。', errorSegments: <String>['阿宁把','自己原先只顾赶路的记录','补充完整','完整。'], errorIndex: 3, grammarFamily: '结果补语赘余', grammarRule: '结果补语已经表达完成状态，不重复同一成分。', learning: '识别结果补语重复', knowledge: '记录补充', language: '把字句与结果补语', reasoning: '删除重复而保留结果', why: '第二个“完整”重复且破坏自然表达。', difficulty: 'Lv4 结果补语', storyEvidence: '也把自己原先只顾赶路的记录补完整。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '两人先把图放在一边，是为了先看____。', answer: '空间连接', options: <String>['空间连接','谁先画图','路线颜色','谁年龄更大'], sourceSentence: '两人先把图放在一边，是为了先看空间连接。', learning: '从行动理解分析顺序', knowledge: '空间连接', language: '为了结构', reasoning: '先事实结构后路线评价', why: 'Story 明确写“先看空间连接”。', difficulty: 'Lv4 分析顺序', storyEvidence: '她主动请沈砚把图放在一边，先看空间连接。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '沈砚重新画图时，不再用一条线覆盖另一条，而是标出____。', answer: '两人的任务与共同到达点', options: <String>['两人的任务与共同到达点','一个唯一答案','谁先进入紫禁城','所有院落的名称'], sourceSentence: '沈砚重新画图时，不再用一条线覆盖另一条，而是标出两人的任务与共同到达点。', learning: '把空间与人物信息同时纳入图', knowledge: '任务与共同节点', language: '而是结构', reasoning: '选择能解释两条路线的信息', why: 'Story 直接写出任务与共同到达点被标注。', difficulty: 'Lv4 关系补全', storyEvidence: '标出两人的任务与共同到达点。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '哪一句最能证明阿宁把争论从“谁对”转成“先看空间条件”？', answer: '她主动请沈砚把图放在一边先看空间连接', options: <String>['她主动请沈砚把图放在一边先看空间连接','她从东侧来到乾清门前','沈砚沿中轴观察外朝','周师傅走在旁边'], sourceSentence: '她主动请沈砚把图放在一边，先看空间连接。', learning: '从文本找转折行动', knowledge: '空间连接证据', language: '先…结构', reasoning: '识别改变讨论框架的证据', why: '该行动明确把讨论顺序改成先查空间。', difficulty: 'Lv4 关键证据', storyEvidence: '她主动请沈砚把图放在一边，先看空间连接。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '阿宁后来也补完整自己的记录，说明她的变化是什么？', answer: '她也愿意改进自己的记录而不是只要求沈砚改变', options: <String>['她也愿意改进自己的记录而不是只要求沈砚改变','她决定放弃东侧任务','她承认中轴是唯一答案','她不再需要空间证据'], sourceSentence: '阿宁看到他愿意修改判断，也把自己原先只顾赶路的记录补完整。', learning: '理解双向人物成长', knowledge: '合作关系', language: '也结构', reasoning: '从对称行动推断关系变化', why: '她自己的记录也发生改变，说明合作是双向的。', difficulty: 'Lv4 人物推断', storyEvidence: '也把自己原先只顾赶路的记录补完整。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '“外朝”在 Lv4 Story 中属于哪类信息？', answer: '紫禁城的功能空间区域', options: <String>['紫禁城的功能空间区域','某一条个人路线名称','乾清门的别名','北京城外交通区'], sourceSentence: '外朝是紫禁城的重要功能空间区域。', learning: '识别外朝概念', knowledge: '外朝', language: '分类表达', reasoning: '把功能区域与路线区分', why: '外朝是功能空间框架，不是人物路线名称。', difficulty: 'Lv4 分类知识', storyEvidence: '他沿中轴观察外朝的宫门与院落。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '为什么“建筑提供连接条件”不等于“建筑决定同一个目标”？', answer: '空间关系限制可行路径但任务目标来自人物需要', options: <String>['空间关系限制可行路径但任务目标来自人物需要','建筑会替人物自动选择任务','只要有宫门就只有一条路线','目标与空间完全无关'], sourceSentence: '空间关系规定可行连接，人物任务决定为何选择其中一条。', learning: '理解空间条件与目标来源', knowledge: '建筑连接、任务', language: '但结构', reasoning: '区分约束与目的', why: '空间事实和人物目标承担不同逻辑作用。', difficulty: 'Lv4 概念关系', storyEvidence: '建筑提供了可行的连接条件，却没有替他们决定同一个目标。', knowledgeSource: '故宫博物院 / 当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '两条路线共享同一组宫门连接，但人物任务不同。应怎样评价？', answer: '先判断两条路线是否符合空间连接再比较是否服务任务', options: <String>['先判断两条路线是否符合空间连接再比较是否服务任务','共享建筑就必须路线相同','任务不同就不用检查空间可行性','只保留画得更直的一条'], sourceSentence: '空间连接与任务目标需要分别判断。', learning: '同时检查空间与任务', knowledge: '连接条件与目标', language: '先…再…', reasoning: '双条件决策', why: 'Story 把空间可行与任务适配分开评价。', difficulty: 'Lv4 双条件决策', storyEvidence: '建筑提供可行连接条件，却没有替他们决定同一个目标。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '同伴说“建筑环境一样，所以目标也应该一样”。最合理回应是？', answer: '指出共同空间条件不能推出相同任务并请他说明目标', options: <String>['指出共同空间条件不能推出相同任务并请他说明目标','同意并要求所有人走同一路线','只纠正建筑名称','完全忽略空间条件'], sourceSentence: '建筑相同，不代表我们的目标相同。', learning: '识别无效推论', knowledge: '共同环境与目标', language: '不能推出', reasoning: '反驳过度推论', why: 'Story 明确否定“建筑相同→目标相同”。', difficulty: 'Lv4 逻辑决策', storyEvidence: '建筑相同，不代表我们的目标相同。', knowledgeSource: '当前 Story'),
  ],

  // Lv5 — evidence, function and spatial checks.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：判断路线之前先做什么', answer: '阿宁先让证据说话再讨论路线是否准确', options: <String>[], sourceSentence: '阿宁选择先让证据说话。', chunks: <String>['阿宁先让证据说话','再讨论','路线是否准确'], learning: '理解证据优先顺序', knowledge: '路线证据', language: '先…再…', reasoning: '按验证顺序组织复句', why: '证据检查在路线结论之前。', difficulty: 'Lv5 证据顺序', storyEvidence: '阿宁选择先让证据说话。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：两条路线分别有什么功能', answer: '中轴路线说明空间关系东侧路线服务记录任务', options: <String>[], sourceSentence: '自己的线适合说明中轴关系，阿宁的线更直接地服务她的任务。', chunks: <String>['中轴路线说明空间关系','东侧路线','服务记录任务'], learning: '比较两条路线功能', knowledge: '中轴与东侧任务', language: '并列对照', reasoning: '按功能区分两条路线', why: 'Story 明确区分两条线的解释功能与任务功能。', difficulty: 'Lv5 功能对照', storyEvidence: '自己的线适合说明中轴关系，阿宁的线更直接地服务她的任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '阿宁先让证据说话，而且沈砚的路线一定错误。', answer: '阿宁先让证据说话，再判断两条路线是否成立。', options: <String>['阿宁先让证据说话，再判断两条路线是否成立。','阿宁先让证据说话，而且沈砚的路线一定错误。','阿宁先让证据说话，所以东侧路线永远正确。','阿宁先让证据说话，但是不用检查空间关系。'], sourceSentence: '阿宁先让证据说话，再判断两条路线是否成立。', errorSegments: <String>['阿宁先让证据说话，','而且','沈砚的路线','一定错误。'], errorIndex: 1, grammarFamily: '逻辑衔接', grammarRule: '证据导向表达把结论放在核查之后。', learning: '修复论证顺序', knowledge: '证据与判断', language: '先…再…', reasoning: '发现前提与结论冲突', why: '句子一面要求证据，一面预设结论，逻辑冲突。', difficulty: 'Lv5 论证顺序', storyEvidence: '阿宁选择先让证据说话。她请沈砚和她逐点核对。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '沈砚分别标注中轴观察和东侧记录，把两条路线都共同保留。', answer: '沈砚分别标注中轴观察和东侧记录，把两条路线都保留。', options: <String>['沈砚分别标注中轴观察和东侧记录，把两条路线都保留。','沈砚分别标注中轴观察和东侧记录，把两条路线都共同保留。','沈砚分别共同标注中轴观察和东侧记录，把两条路线保留。','沈砚把两条路线都一起共同保留下来。'], sourceSentence: '沈砚分别标注中轴观察和东侧记录，把两条路线都保留。', errorSegments: <String>['沈砚分别标注','中轴观察和东侧记录，','把两条路线','都共同保留。'], errorIndex: 3, grammarFamily: '范围副词赘余', grammarRule: '同一范围意义只保留必要副词。', learning: '识别范围副词赘余', knowledge: '两条路线并存', language: '都/共同', reasoning: '精简但不改变范围', why: '“都”已表达全部，“共同”重复且搭配不自然。', difficulty: 'Lv5 精确表达', storyEvidence: '把两条路线都保留。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '阿宁要求逐点核对：哪里由院落相连，哪里通过宫门转向，哪里两条线在____会合。', answer: '乾清门前', options: <String>['乾清门前','午门外','北京城外','内廷最北端'], sourceSentence: '阿宁要求逐点核对：哪里由院落相连，哪里通过宫门转向，哪里两条线在乾清门前会合。', learning: '完成多项空间核对链', knowledge: '乾清门共同节点', language: '哪里…哪里…', reasoning: '从并列空间线索定位共同点', why: 'Story 明确写两条线在乾清门前会合。', difficulty: 'Lv5 空间序列', storyEvidence: '哪里两条线在乾清门前会合。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '沈砚把两条路线都保留，是因为他发现它们____。', answer: '分别解释空间关系和任务需要', options: <String>['分别解释空间关系和任务需要','实际上完全相同','都必须沿中轴','都不需要建筑证据'], sourceSentence: '沈砚把两条路线都保留，是因为他发现它们分别解释空间关系和任务需要。', learning: '根据证据补全保留理由', knowledge: '路线功能差异', language: '因为结构', reasoning: '综合两条路线功能', why: '两条路线服务不同的信息与任务功能。', difficulty: 'Lv5 原因综合', storyEvidence: '自己的线适合说明中轴关系，阿宁的线更直接地服务她的任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '哪组证据最直接支持“沈砚的线和阿宁的线各有功能”？', answer: '中轴线说明空间关系东侧线服务记录任务', options: <String>['中轴线说明空间关系东侧线服务记录任务','两个人都到了紫禁城','沈砚先画图阿宁后到','两条线颜色不同'], sourceSentence: '自己的线适合说明中轴关系，阿宁的线更直接地服务她的任务。', learning: '选择双证据组合', knowledge: '路线功能', language: '对照关系', reasoning: '两个事实对应一个结论', why: '两条证据分别说明两条线为何有独立价值。', difficulty: 'Lv5 双证据', storyEvidence: '自己的线适合说明中轴关系，阿宁的线更直接地服务她的任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '沈砚“开始先问阿宁看到了什么”最能说明哪种关系变化？', answer: '从先判断对方转向先听取对方证据', options: <String>['从先判断对方转向先听取对方证据','从合作转向拒绝交流','从路线讨论转向只背建筑名','从记录任务转向放弃任务'], sourceSentence: '沈砚开始先问阿宁看到了什么。', learning: '从语言行为推断关系变化', knowledge: '合作方式', language: '从…转向…', reasoning: '由对话顺序推断态度', why: '先问“看到了什么”把阿宁观察当成判断证据。', difficulty: 'Lv5 关系推断', storyEvidence: '沈砚开始先问阿宁看到了什么。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '乾清门前在 Lv5 的路线分析中最重要的作用是什么？', answer: '作为两条路线可以会合和比较的空间节点', options: <String>['作为两条路线可以会合和比较的空间节点','作为所有任务唯一出发点','作为外朝的别名','作为东侧记录本身'], sourceSentence: '乾清门前是不同路线可以会合的空间节点。', learning: '理解节点功能', knowledge: '乾清门', language: '作为结构', reasoning: '从建筑位置推到分析用途', why: '共同会合点让不同路线能在同一空间框架中比较。', difficulty: 'Lv5 功能知识', storyEvidence: '哪里两条线在乾清门前会合。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '沿中轴观察外朝的宫门和院落，最能帮助学习者理解什么？', answer: '紫禁城主要空间如何按序组织', options: <String>['紫禁城主要空间如何按序组织','为什么每个人任务相同','东侧路线一定无效','所有宫门都属于内廷'], sourceSentence: '中轴把连续宫门与院落组织成可理解的空间关系。', learning: '理解中轴观察价值', knowledge: '中轴、外朝、院落', language: '如何结构', reasoning: '从连续节点抽象空间秩序', why: '中轴的学习价值在于组织空间序列。', difficulty: 'Lv5 结构知识', storyEvidence: '沿中轴观察外朝的宫门、院落与方向。', knowledgeSource: '北京市官方中轴资料'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '两条线都能走通但服务不同任务。最好的路线图记录方式是？', answer: '标明每条路线服务的任务和共同节点', options: <String>['标明每条路线服务的任务和共同节点','只保留看起来更直的一条','把两条线合成一条不说明原因','删除任务信息只留建筑名'], sourceSentence: '分别标注中轴观察和东侧记录，并保留共同节点。', learning: '让图保留判断依据', knowledge: '任务与共同节点', language: '标明结构', reasoning: '把证据转化为可读记录', why: 'Story 的改进图同时保留路线与各自用途。', difficulty: 'Lv5 记录决策', storyEvidence: '分别标注“中轴观察”和“东侧记录”，把两条路线都保留。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '同伴说“东侧路线偏离中轴，所以一定不准确”。你应先检查什么？', answer: '它是否利用真实宫门连接并符合当前任务', options: <String>['它是否利用真实宫门连接并符合当前任务','它是不是画得比中轴线短','是谁先提出这条路线','路线名称有没有四个字'], sourceSentence: '路线需要真实空间连接并服务具体任务。', learning: '用双条件核查路线', knowledge: '空间连接与任务', language: '是否结构', reasoning: '拒绝仅凭偏离中轴判断', why: '成立性依赖真实连接与任务适配，而不是是否贴中轴。', difficulty: 'Lv5 双条件核查', storyEvidence: '哪里由院落相连，哪里通过宫门转向。', knowledgeSource: '当前 Story / 故宫博物院'),
  ],

  // Lv6 — feasibility versus task fit.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：路线判断的两个问题', answer: '空间能否连接与路线是否适合任务是两个问题', options: <String>[], sourceSentence: '空间能不能连接，路线是不是适合这个人的任务。', chunks: <String>['空间能否连接','与路线是否适合任务','是两个问题'], learning: '区分可行性与适配性', knowledge: '空间连接与任务', language: '是否结构', reasoning: '拆成两个判断', why: '空间可行与任务适合是不同问题。', difficulty: 'Lv6 双判断', storyEvidence: '空间能不能连接，路线是不是适合这个人的任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：中轴能做什么、不能做什么', answer: '中轴给出观察顺序却不能替所有人选择路线', options: <String>[], sourceSentence: '中轴给了他稳定的观察顺序，但不能替所有人选择路线。', chunks: <String>['中轴给出观察顺序','却不能替所有人','选择路线'], learning: '限制中轴框架作用', knowledge: '中轴与任务', language: '却转折', reasoning: '区分框架与决策', why: '中轴组织观察，但任务决定具体选择。', difficulty: 'Lv6 框架限制', storyEvidence: '中轴给了他稳定的观察顺序，他便误把…当成所有人都应采用的路线。', knowledgeSource: '北京市官方中轴资料 / 当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '空间能不能连接，和路线是不是适合任务，所以是同一个问题。', answer: '空间能不能连接，和路线是不是适合任务，是两个不同的问题。', options: <String>['空间能不能连接，和路线是不是适合任务，是两个不同的问题。','空间能不能连接，和路线是不是适合任务，所以是同一个问题。','空间能不能连接，因此路线一定适合任务。','空间能不能连接，而且任务就自动相同。'], sourceSentence: '空间能不能连接，和路线是不是适合任务，是两个不同的问题。', errorSegments: <String>['空间能不能连接，','和路线是不是适合任务，','所以是','同一个问题。'], errorIndex: 2, grammarFamily: '逻辑判断', grammarRule: '并列概念先区分判断对象，再确定逻辑关系。', learning: '区分两个判断维度', knowledge: '空间连接与任务', language: '并列判断', reasoning: '识别概念混同', why: '可行性与适配性不是同一个判断。', difficulty: 'Lv6 概念区分', storyEvidence: '空间能不能连接，路线是不是适合这个人的任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '他把外朝、内廷、共同节点和两人的任务一起都全部标注在图上。', answer: '他把外朝、内廷、共同节点和两人的任务都标注在图上。', options: <String>['他把外朝、内廷、共同节点和两人的任务都标注在图上。','他把外朝、内廷、共同节点和两人的任务一起都全部标注在图上。','他把外朝、内廷、共同节点和两人的任务全部都一起标注在图上。','他把外朝、内廷、共同节点和两人的任务都全部共同标注在图上。'], sourceSentence: '他把外朝、内廷、共同节点和两人的任务都标注在图上。', errorSegments: <String>['他把外朝、内廷、','共同节点和两人的任务','一起都全部','标注在图上。'], errorIndex: 2, grammarFamily: '范围赘余', grammarRule: '多个范围副词只保留最准确的一项。', learning: '控制复杂列举句赘余', knowledge: '外朝、内廷、任务', language: '把字句', reasoning: '在多项宾语中保持范围清晰', why: '“一起、都、全部”重复表达全体范围。', difficulty: 'Lv6 列举表达', storyEvidence: '把外朝、内廷、共同节点和两人的任务一起标注在图上。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '从乾清门前再向北，空间进入与____关系更密切的区域。', answer: '内廷', options: <String>['内廷','午门','东侧记录点','北京城外'], sourceSentence: '从乾清门前再向北，空间进入与内廷关系更密切的区域。', learning: '根据空间序列补全功能区域', knowledge: '乾清门与内廷', language: '与…关系更密切', reasoning: '结合路线和知识判断区域', why: '现有 Story 与知识都把乾清门北侧关联到内廷。', difficulty: 'Lv6 空间关系', storyEvidence: '从这里再向北，空间进入与内廷关系更密切的区域。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '阿宁把争论拆成两个问题后，沈砚承认自己的图只表达了____。', answer: '一个观察顺序', options: <String>['一个观察顺序','所有人的唯一任务','完整的东侧路线','内廷全部功能'], sourceSentence: '阿宁把争论拆成两个问题后，沈砚承认自己的图只表达了一个观察顺序。', learning: '理解人物重新定义自己的图', knowledge: '中轴观察顺序', language: '只表达', reasoning: '由分析结果修正原判断', why: 'Story 直接写沈砚承认图只表达一个观察顺序。', difficulty: 'Lv6 认知修正', storyEvidence: '沈砚承认自己的图只表达了一个观察顺序。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '哪一句最直接支持“可行路线不一定适合每个人的任务”？', answer: '空间能不能连接路线是不是适合这个人的任务', options: <String>['空间能不能连接路线是不是适合这个人的任务','中轴给了沈砚稳定的观察顺序','阿宁从东侧来到乾清门前','两人都看了路线图'], sourceSentence: '空间能不能连接，路线是不是适合这个人的任务。', learning: '选择概念证据', knowledge: '可行性与适配性', language: '两个疑问句', reasoning: '找明确区分', why: '这句话直接把两个判断拆开。', difficulty: 'Lv6 概念证据', storyEvidence: '空间能不能连接，路线是不是适合这个人的任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '阿宁为什么愿意让沈砚把中轴关系补进她的记录？', answer: '整体空间关系能补充她的局部任务记录', options: <String>['整体空间关系能补充她的局部任务记录','她决定放弃东侧任务','她认为自己的路线完全错误','她只想让记录更长'], sourceSentence: '她原以为他只会守着自己的图，现在愿意让他把中轴关系补进她的记录。', learning: '从合作行为推断互补价值', knowledge: '整体与局部', language: '补进结构', reasoning: '推断双方证据如何互补', why: '她接受中轴关系作为对局部任务记录的补充。', difficulty: 'Lv6 关系推断', storyEvidence: '现在愿意让他把中轴关系补进她的记录。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '乾清门为什么常被视为外朝与内廷关系转换的重要节点？', answer: '它处在外朝与内廷关系转换的重要位置', options: <String>['它处在外朝与内廷关系转换的重要位置','它是北京城最外层城门','它只连接东侧记录点','它与中轴完全无关'], sourceSentence: '乾清门位于外朝与内廷关系转换的重要空间位置。', learning: '理解外朝内廷关系', knowledge: '乾清门、外朝、内廷', language: '处在…之间', reasoning: '建筑位置连接功能分区', why: '现有知识把乾清门作为连接外朝与内廷的重要节点。', difficulty: 'Lv6 功能关系', storyEvidence: '从这里再向北，空间进入与内廷关系更密切的区域。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '“中轴给出稳定观察顺序”最准确的理解是什么？', answer: '它帮助组织空间信息但不自动规定所有任务路线', options: <String>['它帮助组织空间信息但不自动规定所有任务路线','它要求所有人从午门走到同一终点','它只是一条个人捷径','它与宫门院落无关'], sourceSentence: '中轴帮助组织空间信息，但不替每个任务选择路线。', learning: '理解中轴功能边界', knowledge: '中轴', language: '但结构', reasoning: '框架价值与非排他结论', why: '中轴是空间框架，不是所有任务的唯一行动指令。', difficulty: 'Lv6 功能推理', storyEvidence: '中轴给了他稳定的观察顺序。', knowledgeSource: '北京市官方中轴资料'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '在乾清门前判断一条新路线：空间上能走通，但会远离当前记录任务。应怎么判断？', answer: '路线可行但对当前任务未必适合', options: <String>['路线可行但对当前任务未必适合','只要能走通就一定最佳','只要偏离中轴就一定错误','任务不应影响路线选择'], sourceSentence: '空间可行性和任务适配性必须分开判断。', learning: '把可行与适合分开', knowledge: '空间可行性与任务适配', language: '但结构', reasoning: '双维度评价路线', why: '能走通不等于服务当前任务。', difficulty: 'Lv6 情境判断', storyEvidence: '空间能不能连接，路线是不是适合这个人的任务。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '路线图只画中轴观察顺序，却要交给执行东侧任务的人。最合理的补充是？', answer: '标明共同节点东侧任务和可行连接', options: <String>['标明共同节点东侧任务和可行连接','把中轴线画得更粗','删除所有任务信息','规定任何人都不得偏离中轴'], sourceSentence: '完整记录同时给出空间框架、共同节点和任务条件。', learning: '让记录支持不同任务', knowledge: '中轴、共同节点、东侧', language: '标明结构', reasoning: '框架信息与行动条件结合', why: 'Story 的改图把共同节点与两人的任务同时标出。', difficulty: 'Lv6 记录决策', storyEvidence: '他把外朝、内廷、共同节点和两人的任务一起标注在图上。', knowledgeSource: '当前 Story'),
  ],

  // Lv7 — inference and evidence strength.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：建筑连接与任务目标的边界', answer: '建筑允许怎样连接不等于任务要求去哪里', options: <String>[], sourceSentence: '建筑允许怎样连接，不等于任务要求我去哪里。', chunks: <String>['建筑允许怎样连接','不等于','任务要求去哪里'], learning: '理解约束与目标差异', knowledge: '建筑约束、任务', language: '不等于', reasoning: '限制空间事实到行动目标的推论', why: '空间约束只定义可行性，不生成任务。', difficulty: 'Lv7 逻辑限制', storyEvidence: '区分“建筑允许怎样连接”和“任务要求我去哪里”。', knowledgeSource: '当前 Story / 故宫博物院'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：证据怎样改变沈砚', answer: '证据改变了争论也让沈砚撤回排他判断', options: <String>[], sourceSentence: '证据改变了争论。沈砚因此撤回“只有一条正确路线”的判断。', chunks: <String>['证据改变了争论','也让沈砚','撤回排他判断'], learning: '理解证据改变结论', knowledge: '空间证据', language: '也让结构', reasoning: '证据到认知更新', why: '核对结果直接改变了沈砚的排他结论。', difficulty: 'Lv7 证据推理', storyEvidence: '证据改变了争论。沈砚因此撤回“只有一条正确路线”的判断。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '中轴构成沈砚路线的重要骨架，所以阿宁的路线就不能成立。', answer: '中轴构成沈砚路线的重要骨架，但不能因此否定阿宁的路线。', options: <String>['中轴构成沈砚路线的重要骨架，但不能因此否定阿宁的路线。','中轴构成沈砚路线的重要骨架，所以阿宁的路线就不能成立。','中轴构成沈砚路线的重要骨架，因此所有路线都必须相同。','中轴构成沈砚路线的重要骨架，而且阿宁的任务也因此消失。'], sourceSentence: '中轴构成沈砚路线的重要骨架，但不能因此否定阿宁的路线。', errorSegments: <String>['中轴构成','沈砚路线的重要骨架，','所以阿宁的路线','就不能成立。'], errorIndex: 2, grammarFamily: '推论过强', grammarRule: '检查证据能否支持结论强度。', learning: '识别证据不足的过度结论', knowledge: '中轴与东侧路线', language: '但不能因此', reasoning: '评估证据→结论强度', why: '中轴支持沈砚路线，不足以否定另一条有独立证据的路线。', difficulty: 'Lv7 推论强度', storyEvidence: '中轴确实构成沈砚路线的重要骨架；东侧空间与乾清门前的连接也使阿宁的路线成立。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '两人面对的是同一组建筑约束，却从不同任务与视角作出了选择不同。', answer: '两人面对的是同一组建筑约束，却从不同任务与视角作出不同选择。', options: <String>['两人面对的是同一组建筑约束，却从不同任务与视角作出不同选择。','两人面对的是同一组建筑约束，却从不同任务与视角作出了选择不同。','两人面对的是同一组建筑约束，却不同选择从任务与视角作出。','两人面对的是同一组建筑约束，却把不同任务与视角选择。'], sourceSentence: '两人面对的是同一组建筑约束，却从不同任务与视角作出不同选择。', errorSegments: <String>['两人面对的是','同一组建筑约束，','却从不同任务与视角','作出了选择不同。'], errorIndex: 3, grammarFamily: '语序搭配', grammarRule: '修饰成分放在真正限定的中心词前。', learning: '修复复杂句语序', knowledge: '共同约束与不同选择', language: '作出不同选择', reasoning: '根据搭配确定修饰位置', why: '“不同”应修饰“选择”。', difficulty: 'Lv7 复杂语序', storyEvidence: '却从不同任务与视角作出选择。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '阿宁要求沈砚区分“建筑允许怎样连接”和“____”。', answer: '任务要求我去哪里', options: <String>['任务要求我去哪里','谁先拿到图笔','哪条线画得更粗','午门是否存在'], sourceSentence: '阿宁要求沈砚区分“建筑允许怎样连接”和“任务要求我去哪里”。', learning: '补全两类判断', knowledge: '建筑约束、任务目标', language: '并列引用', reasoning: '空间条件转向行动目标', why: '原文正是把这两类问题并列区分。', difficulty: 'Lv7 概念补全', storyEvidence: '区分“建筑允许怎样连接”和“任务要求我去哪里”。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '沈砚撤回“只有一条正确路线”的判断，是因为____。', answer: '两条路线都能在真实建筑约束下成立', options: <String>['两条路线都能在真实建筑约束下成立','阿宁要求他无条件认错','周师傅规定必须画两条线','中轴不再存在'], sourceSentence: '沈砚撤回“只有一条正确路线”的判断，是因为两条路线都能在真实建筑约束下成立。', learning: '从证据链补全认知变化', knowledge: '共同约束、多路线', language: '因为结构', reasoning: '整合两条空间证据', why: '中轴支持一条路线，东侧连接独立支持另一条。', difficulty: 'Lv7 多证据补全', storyEvidence: '中轴确实构成沈砚路线的重要骨架；东侧空间与乾清门前的连接也使阿宁的路线成立。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '哪两处证据共同推翻“只有中轴路线能成立”？', answer: '中轴支持沈砚路线东侧连接也支持阿宁路线', options: <String>['中轴支持沈砚路线东侧连接也支持阿宁路线','沈砚先到阿宁后到','两个人都认识周师傅','两张图使用同一支笔'], sourceSentence: '中轴支持沈砚路线；东侧空间与乾清门前的连接也使阿宁路线成立。', learning: '组合互补证据', knowledge: '共同建筑约束', language: '并列证据', reasoning: '用两条独立证据检验排他结论', why: '两条路线各有真实空间证据，排他结论因此失败。', difficulty: 'Lv7 双证据反驳', storyEvidence: '中轴确实构成沈砚路线的重要骨架；东侧空间与乾清门前的连接也使阿宁的路线成立。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '周师傅让两人交换图笔有什么学习意义？', answer: '让双方把对方的证据纳入自己的表达', options: <String>['让双方把对方的证据纳入自己的表达','让他们比较谁写字更漂亮','证明图笔决定路线','要求他们交换任务'], sourceSentence: '沈砚请阿宁画她的线，阿宁请沈砚补上中轴与外朝的关系。', learning: '从象征行动理解合作', knowledge: '证据交换', language: '让字句', reasoning: '推断行为背后的认知目的', why: '交换图笔让双方实际呈现彼此的证据。', difficulty: 'Lv7 行为推断', storyEvidence: '沈砚请阿宁画她的线，阿宁请沈砚补上中轴与外朝的关系。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '“建筑约束”在路线推理中是什么意思？', answer: '建筑连接限制哪些路线可行但不替人物决定唯一目标', options: <String>['建筑连接限制哪些路线可行但不替人物决定唯一目标','建筑规定所有人必须同一路线','人物目标可以无视真实空间','约束只表示路线更短'], sourceSentence: '建筑约束定义可行范围，不指定唯一行动。', learning: '理解约束概念', knowledge: '宫门院落连接', language: '但结构', reasoning: '区分可行域与选择', why: '约束限制可行范围，不自动决定任务。', difficulty: 'Lv7 抽象知识', storyEvidence: '两人面对的是同一组建筑约束，却从不同任务与视角作出选择。', knowledgeSource: '故宫博物院 / 当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '为什么乾清门前的连接证据能支持阿宁路线？', answer: '它说明东侧路径能在真实空间中接到共同节点', options: <String>['它说明东侧路径能在真实空间中接到共同节点','它证明东侧永远比中轴更好','它说明乾清门只属于东侧','它取消了午门的空间作用'], sourceSentence: '东侧空间与乾清门前的连接为阿宁路线提供可行性证据。', learning: '从节点关系支持路径可行性', knowledge: '乾清门、东侧连接', language: '说明结构', reasoning: '由连接事实支持路线成立', why: '路线成立必须落在真实空间连接上。', difficulty: 'Lv7 空间证据', storyEvidence: '东侧空间与乾清门前的连接也使阿宁的路线成立。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '中轴路线有清楚结构，东侧路线也能通过真实连接到共同节点。结论应怎样写？', answer: '两条路线都可成立但要分别说明任务与视角条件', options: <String>['两条路线都可成立但要分别说明任务与视角条件','中轴重要所以另一条必错','两条都能走所以任务不重要','只写“都对”而不说明依据'], sourceSentence: '两条路线在共同建筑约束内成立，但服务不同任务与视角。', learning: '写出有条件结论', knowledge: '多路线、任务、视角', language: '但结构', reasoning: '从多证据形成受限结论', why: '成熟结论既保留共同可行性，也写出成立条件。', difficulty: 'Lv7 证据结论', storyEvidence: '两人面对的是同一组建筑约束，却从不同任务与视角作出选择。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '一条新路线符合任务，却穿过并不存在的建筑连接。应该怎么处理？', answer: '判定当前路线不成立并先修正空间证据', options: <String>['判定当前路线不成立并先修正空间证据','因为任务重要就直接接受','把不存在的连接写成可能存在','忽略建筑事实只看目标'], sourceSentence: '任务不能把不存在的空间连接变成可行路线。', learning: '让事实约束任务选择', knowledge: '建筑连接', language: '并结构', reasoning: '识别必要条件失败', why: '空间连接是路线可行的必要条件。', difficulty: 'Lv7 必要条件', storyEvidence: '建筑允许怎样连接，是路线判断的第一类问题。', knowledgeSource: '故宫博物院'),
  ],

  // Lv8 — multiple clues and explanation authority.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：高阶路线判断顺序', answer: '先比较空间证据、任务和共同条件再评价路线', options: <String>[], sourceSentence: '先比较空间证据、任务和共同条件，再评价路线。', chunks: <String>['先比较空间证据、任务和共同条件','再评价','路线'], learning: '建立多证据判断顺序', knowledge: '空间证据、任务、共同条件', language: '先…再…', reasoning: '多线索综合', why: '先查三类信息，之后才形成路线评价。', difficulty: 'Lv8 三线索', storyEvidence: '阿宁主动提出三个问题：空间证据、任务、共同建筑条件。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：常用框架为何不等于排他答案', answer: '常用框架有解释力却不能自动取得排他地位', options: <String>[], sourceSentence: '一条路线可以是常用框架，却不能自动取得排他的地位。', chunks: <String>['常用框架有解释力','却不能自动取得','排他地位'], learning: '理解框架价值与边界', knowledge: '中轴框架', language: '却不能', reasoning: '综合评价框架', why: 'Story 保留框架价值，同时限制排他结论。', difficulty: 'Lv8 评价边界', storyEvidence: '一条路线可以是常用框架，却不能自动取得排他的地位。', knowledgeSource: '当前 Story / 北京中轴资料'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '中轴、宫门与院落构成共同空间条件，因此人物的目标也必须相同。', answer: '中轴、宫门与院落构成共同空间条件，但人物的目标仍可以不同。', options: <String>['中轴、宫门与院落构成共同空间条件，但人物的目标仍可以不同。','中轴、宫门与院落构成共同空间条件，因此人物的目标也必须相同。','中轴、宫门与院落构成共同空间条件，所以所有路线解释力相同。','中轴、宫门与院落构成共同空间条件，而且任务差异就不存在。'], sourceSentence: '共同空间条件不推出相同人物目标。', errorSegments: <String>['中轴、宫门与院落','构成共同空间条件，','因此人物的目标','也必须相同。'], errorIndex: 2, grammarFamily: '因果越界', grammarRule: '多前提推理逐步检查证据是否支持结论。', learning: '识别共同条件到相同目标的非法跳跃', knowledge: '共同空间条件、目标', language: '但结构', reasoning: '审查多步推论', why: '共同约束只能说明共享空间条件，不能推出任务相同。', difficulty: 'Lv8 推论审查', storyEvidence: '真正不同的是人物的目标、视角和下一步行动。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '两人的合作从“谁纠正谁”转变成“谁提供哪一种证据”了起来。', answer: '两人的合作从“谁纠正谁”转变成“谁提供哪一种证据”。', options: <String>['两人的合作从“谁纠正谁”转变成“谁提供哪一种证据”。','两人的合作从“谁纠正谁”转变成“谁提供哪一种证据”了起来。','两人的合作把“谁纠正谁”转变“谁提供哪一种证据”。','两人的合作从“谁纠正谁”转变着成为“谁提供哪一种证据”。'], sourceSentence: '两人的合作从“谁纠正谁”转变成“谁提供哪一种证据”。', errorSegments: <String>['两人的合作','从“谁纠正谁”','转变成“谁提供哪一种证据”','了起来。'], errorIndex: 3, grammarFamily: '动态成分', grammarRule: '变化动词已经完整时，不机械叠加动态或趋向成分。', learning: '修复抽象变化句', knowledge: '合作方式', language: '从…转变成…', reasoning: '判断动态成分必要性', why: '“转变成”已完整表达变化，“了起来”使结构拖沓。', difficulty: 'Lv8 抽象表达', storyEvidence: '合作从“谁纠正谁”变成“谁提供哪一种证据”。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '“哪些建筑条件是两人都不能忽略的”是在寻找____。', answer: '共同约束', options: <String>['共同约束','个人偏好','谁先到达','路线名称'], sourceSentence: '“哪些建筑条件是两人都不能忽略的”是在寻找共同约束。', learning: '从问题抽象概念', knowledge: '建筑共同条件', language: '是在寻找', reasoning: '由具体提问抽象推理类别', why: '两人都不能忽略的建筑条件就是共同约束。', difficulty: 'Lv8 概念抽象', storyEvidence: '哪些建筑条件是两人都不能忽略的？', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '沈砚让阿宁决定怎样呈现自己的路线，说明他放弃了____。', answer: '用自己的框架替她做全部解释', options: <String>['用自己的框架替她做全部解释','理解中轴的价值','记录共同节点','检查空间连接'], sourceSentence: '沈砚让阿宁决定怎样呈现自己的路线，说明他放弃了用自己的框架替她做全部解释。', learning: '从行动推断解释权变化', knowledge: '视角与解释权', language: '说明结构', reasoning: '由呈现权推断态度', why: 'Story 明确把路线呈现权交回阿宁。', difficulty: 'Lv8 人物推断', storyEvidence: '他让阿宁决定怎样呈现自己的路线，自己只补充两条线之间的连接说明。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '要证明沈砚的判断方式变了，哪组证据最有力？', answer: '他先比较三类证据再让阿宁决定怎样呈现自己的路线', options: <String>['他先比较三类证据再让阿宁决定怎样呈现自己的路线','他仍然从午门进入','阿宁仍从东侧到达','乾清门仍是共同节点'], sourceSentence: '先比较三类证据，再让阿宁拥有路线呈现权。', learning: '组合过程与结果证据', knowledge: '证据方法、解释权', language: '先…再…', reasoning: '用方法变化与行动变化共同支持结论', why: '前者改变判断方法，后者改变关系中的解释权。', difficulty: 'Lv8 组合证据', storyEvidence: '阿宁主动提出三个问题…他让阿宁决定怎样呈现自己的路线。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '“常用框架不能自动排他”由什么事实支撑？', answer: '另一条路线也符合共同空间条件并服务不同任务', options: <String>['另一条路线也符合共同空间条件并服务不同任务','常用路线画得更粗','周师傅没有提供地图','阿宁比沈砚更熟悉所有建筑'], sourceSentence: '另一条路线也符合共同空间条件并服务不同任务。', learning: '从多个事实支撑抽象结论', knowledge: '多路线合理性', language: '不能自动', reasoning: '由反例限制普遍结论', why: '存在另一条在同一真实约束下成立的路线，足以反驳排他性。', difficulty: 'Lv8 抽象证据', storyEvidence: '中轴、宫门与院落构成共同空间条件；真正不同的是人物的目标、视角和下一步行动。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '把中轴、宫门、院落放在一起分析，属于哪一种更高层空间理解？', answer: '把点状建筑放进共同空间系统理解连接关系', options: <String>['把点状建筑放进共同空间系统理解连接关系','只背每个建筑名称','把任务当成建筑属性','忽略建筑之间关系'], sourceSentence: '中轴、宫门与院落共同形成空间系统。', learning: '构建空间系统观', knowledge: '中轴、宫门、院落', language: '把…放进…', reasoning: '从单点知识整合为关系网络', why: '高层理解关注节点之间的连接，而非孤立名称。', difficulty: 'Lv8 系统知识', storyEvidence: '中轴、宫门与院落构成共同的空间条件。', knowledgeSource: '故宫博物院 / 北京中轴资料'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '乾清门前作为共同节点时，哪项信息仍不能由它单独决定？', answer: '人物接下来服务哪个任务', options: <String>['人物接下来服务哪个任务','两条路线能否在此相遇','它位于紫禁城空间中','它与内外廷关系有关'], sourceSentence: '空间节点不能单独决定人物任务。', learning: '理解节点信息边界', knowledge: '乾清门', language: '不能由…决定', reasoning: '区分位置事实与行动目标', why: '地点关系不自动生成下一步任务。', difficulty: 'Lv8 信息边界', storyEvidence: '真正不同的是人物的目标、视角和下一步行动。', knowledgeSource: '故宫博物院·乾清门'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '你有三类信息：空间连接、人物任务、共同建筑条件。要评价路线，最可靠的顺序是？', answer: '先确认共同条件与连接再判断路线是否服务任务', options: <String>['先确认共同条件与连接再判断路线是否服务任务','只看任务不看空间是否可行','只看中轴不看人物目标','随机选一类信息作为结论'], sourceSentence: '先核空间可行性，再判断任务适配性。', learning: '组织多证据决策', knowledge: '空间、任务、共同条件', language: '先…再…', reasoning: '建立多线索决策顺序', why: '路线先必须空间可行，再谈对具体任务是否适合。', difficulty: 'Lv8 多线索决策', storyEvidence: '阿宁主动提出三个问题。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '团队中两人各自掌握一部分路线证据。怎样做最符合 Lv8 的合作方式？', answer: '明确谁提供哪种证据再把它们放进同一判断', options: <String>['明确谁提供哪种证据再把它们放进同一判断','让职位高的人覆盖另一人的记录','把不同证据分开不比较','只保留最早记录的一份'], sourceSentence: '合作从谁纠正谁变成谁提供哪一种证据。', learning: '把合作变成证据分工', knowledge: '证据贡献', language: '再结构', reasoning: '整合分布式信息', why: 'Story 的新合作方式就是按证据贡献协作。', difficulty: 'Lv8 协作决策', storyEvidence: '合作从“谁纠正谁”变成“谁提供哪一种证据”。', knowledgeSource: '当前 Story'),
  ],

  // Lv9 — layered framework and route preference.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：空间事实与路线偏好如何分层', answer: '共同空间骨架限制可行性人物目标形成路线偏好', options: <String>[], sourceSentence: '共同空间骨架限制可行性，人物目标形成路线偏好。', chunks: <String>['共同空间骨架限制可行性','人物目标','形成路线偏好'], learning: '理解约束与偏好的双层模型', knowledge: '空间骨架、路线偏好', language: '主谓结构', reasoning: '客观约束与任务偏好分层', why: '空间决定可行范围，任务影响偏好。', difficulty: 'Lv9 分层模型', storyEvidence: '外朝连续的宫门与院落让他的观察形成稳定的空间骨架。', knowledgeSource: '当前 Story / 北京中轴资料'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：单一视角会造成什么后果', answer: '如果只用一个人的视角评价行动地图会隐藏任务差异', options: <String>[], sourceSentence: '如果只用沈砚的视角评价所有行动，图会隐藏任务差异。', chunks: <String>['如果只用一个人的视角评价行动','地图会','隐藏任务差异'], learning: '理解单一视角的信息损失', knowledge: '视角、任务', language: '如果条件句', reasoning: '评价方法到信息后果', why: '单一视角会抹去不同任务带来的合理差异。', difficulty: 'Lv9 条件后果', storyEvidence: '如果只用沈砚的视角评价所有行动，图会隐藏任务差异。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '空间骨架限制哪些路线可行，因此它也决定每个人最应该选择哪条路线。', answer: '空间骨架限制哪些路线可行，但具体选择还要结合人物目标。', options: <String>['空间骨架限制哪些路线可行，但具体选择还要结合人物目标。','空间骨架限制哪些路线可行，因此它也决定每个人最应该选择哪条路线。','空间骨架限制哪些路线可行，所以人物目标不再重要。','空间骨架限制哪些路线可行，而且所有人的偏好必须一致。'], sourceSentence: '空间骨架限制哪些路线可行，但具体选择还要结合人物目标。', errorSegments: <String>['空间骨架限制','哪些路线可行，','因此它也决定','每个人最应该选择哪条路线。'], errorIndex: 2, grammarFamily: '必要与充分条件', grammarRule: '限制条件不等于最终选择的充分决定。', learning: '修复约束到偏好的越界', knowledge: '空间骨架、路线偏好', language: '但…还要…', reasoning: '区分必要条件与充分条件', why: '空间骨架规定可行范围，但任务仍决定优先选择。', difficulty: 'Lv9 条件逻辑', storyEvidence: '如果只用沈砚的视角评价所有行动，图会隐藏任务差异。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '阿宁为了证明任务差异，她主动放慢进度并逐点检查路线证据。', answer: '为了证明任务差异，阿宁主动放慢进度并逐点检查路线证据。', options: <String>['为了证明任务差异，阿宁主动放慢进度并逐点检查路线证据。','阿宁为了证明任务差异，她主动放慢进度并逐点检查路线证据。','阿宁为了证明任务差异，所以她主动放慢进度并逐点检查路线证据。','为了证明任务差异，因此阿宁主动放慢进度并逐点检查路线证据。'], sourceSentence: '为了证明任务差异，阿宁主动放慢进度并逐点检查路线证据。', errorSegments: <String>['阿宁为了证明任务差异，','她主动','放慢进度并逐点检查','路线证据。'], errorIndex: 1, grammarFamily: '主语重复', grammarRule: '目的状语前置或保留主语一次即可。', learning: '修复高阶句式主语重复', knowledge: '人物主动验证', language: '为了结构', reasoning: '保持信息密度并避免赘余', why: '“阿宁…她…”在同一句重复主语。', difficulty: 'Lv9 书面表达', storyEvidence: '为了证明这一点，她主动放慢自己的进度，和沈砚逐点检查两条路线的空间证据。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '把空间骨架放在底层、人物路线放在上层，是为了同时看见____。', answer: '共同约束和不同选择', options: <String>['共同约束和不同选择','唯一正确路线','谁先到达','建筑名称长度'], sourceSentence: '把空间骨架放在底层、人物路线放在上层，是为了同时看见共同约束和不同选择。', learning: '理解分层表达目的', knowledge: '空间骨架与路线', language: '为了结构', reasoning: '从图层设计推断信息目标', why: '分层正是为了同时保留共同空间与人物差异。', difficulty: 'Lv9 分层理解', storyEvidence: '图会隐藏任务差异；稳定的空间骨架与人物路线需要分开表达。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '阿宁不否认中轴的重要性，却反对____。', answer: '用一个人的视角评价所有行动', options: <String>['用一个人的视角评价所有行动','检查真实空间证据','标出共同节点','让路线服务任务'], sourceSentence: '阿宁不否认中轴的重要性，却反对用一个人的视角评价所有行动。', learning: '补全人物立场边界', knowledge: '中轴价值、视角', language: '却结构', reasoning: '区分反对框架与反对排他使用', why: '她反对的是单一视角的排他使用，不是中轴本身。', difficulty: 'Lv9 立场边界', storyEvidence: '她不否认中轴的重要性，却指出：如果只用沈砚的视角评价所有行动，图会隐藏任务差异。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '哪组文本最能证明阿宁不是反对中轴本身，而是反对它被当成唯一视角？', answer: '她承认中轴重要同时指出单一视角会隐藏任务差异', options: <String>['她承认中轴重要同时指出单一视角会隐藏任务差异','她从东侧抵达沈砚从午门进入','两人都使用路线图','周师傅在乾清门前会合'], sourceSentence: '她不否认中轴的重要性，却指出单一视角会隐藏任务差异。', learning: '辨认承认价值与限制边界的证据组合', knowledge: '中轴价值、视角边界', language: '不否认…却…', reasoning: '排除全盘否定误读', why: '前半承认价值，后半限制排他使用。', difficulty: 'Lv9 立场证据', storyEvidence: '她不否认中轴的重要性，却指出：如果只用沈砚的视角评价所有行动，图会隐藏任务差异。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '沈砚把空间骨架与人物路线分层表示，说明他的认知发生了什么变化？', answer: '他开始区分共同事实与基于任务形成的路线偏好', options: <String>['他开始区分共同事实与基于任务形成的路线偏好','他认为所有空间事实都是个人意见','他放弃了所有中轴信息','他不再需要人物目标'], sourceSentence: '共同空间骨架与人物路线被分层表示。', learning: '从表达结构推断概念变化', knowledge: '事实与偏好', language: '区分结构', reasoning: '由图层组织推断认知模型', why: '分层显示他不再把空间事实和个人选择混成一层。', difficulty: 'Lv9 抽象推断', storyEvidence: '外朝连续的宫门与院落让他的观察形成稳定的空间骨架。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '“路线偏好”与“空间事实”最关键的区别是什么？', answer: '偏好受任务影响空间事实受真实建筑关系约束', options: <String>['偏好受任务影响空间事实受真实建筑关系约束','两者都只由个人喜好决定','空间事实会随任务改变','偏好可以无视建筑连接'], sourceSentence: '空间事实对所有人共享，路线偏好会因任务与视角不同。', learning: '区分事实与偏好', knowledge: '路线偏好、空间骨架', language: '受…影响', reasoning: '概念边界推理', why: '空间事实共享且受真实建筑约束，偏好则由任务影响。', difficulty: 'Lv9 概念知识', storyEvidence: '稳定的空间骨架…路线偏好…任务差异。', knowledgeSource: '故宫博物院 / 北京中轴资料'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '若两条路线共享同一空间骨架，但任务不同，最合理的知识结论是？', answer: '共同空间条件可以支持不同的合理行动方案', options: <String>['共同空间条件可以支持不同的合理行动方案','共享空间条件必然生成同一路线','任务不同就不受空间事实约束','只有中轴路线能解释空间'], sourceSentence: '共同空间条件可以容纳不同任务下的合理路线。', learning: '从空间系统推到多方案', knowledge: '共同骨架、任务', language: '可以结构', reasoning: '共同约束下的多种受约束选择', why: '共同约束定义可行范围，但不消除任务差异。', difficulty: 'Lv9 综合知识', storyEvidence: '同一组建筑条件；不同任务与视角。', knowledgeSource: '北京市官方中轴资料'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '路线图只画中轴骨架，却没有标任务差异。最大风险是什么？', answer: '读者可能把一种观察框架误当成所有行动的唯一方案', options: <String>['读者可能把一种观察框架误当成所有行动的唯一方案','读者会忘记午门的名称','地图一定无法显示方向','乾清门会从图上消失'], sourceSentence: '单一框架会隐藏任务差异。', learning: '识别信息设计风险', knowledge: '中轴框架、任务差异', language: '可能结构', reasoning: '从缺失信息预测错误判断', why: '缺少任务层会诱发“框架=唯一行动方案”的误读。', difficulty: 'Lv9 风险判断', storyEvidence: '图会隐藏任务差异。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '新任务要求从东侧记录点返回，但团队坚持“中轴最有解释力，所以必须走中轴”。你应怎样处理？', answer: '保留中轴作为空间框架同时比较东侧任务的可行路线和成立条件', options: <String>['保留中轴作为空间框架同时比较东侧任务的可行路线和成立条件','完全删除中轴信息','因为中轴重要就取消任务','只按个人喜好选路不查连接'], sourceSentence: '保留框架价值，同时把任务和成立条件纳入路线决策。', learning: '避免排他同时保留框架价值', knowledge: '中轴、东侧任务', language: '同时结构', reasoning: '综合框架、任务与条件', why: '高阶处理不是否定中轴，而是让任务层与框架层同时存在。', difficulty: 'Lv9 综合决策', storyEvidence: '她不否认中轴的重要性，却指出单一视角会隐藏任务差异。', knowledgeSource: '当前 Story'),
  ],

  // Lv10 — integrated reasoning and decision.
  <_Spec>[
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：完整路线判断要说明什么', answer: '好的路线判断要同时说明空间约束、人物目标和行动后果', options: <String>[], sourceSentence: '好的路线判断要同时说明空间约束、人物目标和行动后果。', chunks: <String>['好的路线判断','要同时说明','空间约束、人物目标和行动后果'], learning: '整合完整判断框架', knowledge: '空间约束、目标、后果', language: '要同时说明', reasoning: '三要素综合', why: 'Lv10 要把空间、目标和后果放在同一个可复核结论里。', difficulty: 'Lv10 综合表达', storyEvidence: '他们把建筑连接、人物目标与行动后果放在一起检验。', knowledgeSource: '当前 Story / 故宫博物院'),
    _Spec(mode: StoryChallengeMode.sentenceRebuild, prompt: '按语义块复原：路线成立是否等于普遍优先', answer: '一条路线成立并不意味着它对所有任务都有相同优先级', options: <String>[], sourceSentence: '一条路线成立，并不意味着它对所有任务都有相同优先级。', chunks: <String>['一条路线成立','并不意味着','它对所有任务都有相同优先级'], learning: '区分成立与优先级', knowledge: '可行性、任务权衡', language: '并不意味着', reasoning: '限制可行性到普遍优先级推论', why: '可行性不等于对所有任务都最优。', difficulty: 'Lv10 逻辑边界', storyEvidence: '空间事实限定可能性，身份与任务改变优先次序。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '只要一条路线在空间上成立，它就一定是所有任务的最佳选择。', answer: '即使一条路线在空间上成立，也要结合任务目标判断它是否合适。', options: <String>['即使一条路线在空间上成立，也要结合任务目标判断它是否合适。','只要一条路线在空间上成立，它就一定是所有任务的最佳选择。','既然路线能走通，所以所有人都应优先选择它。','虽然任务不同，因此空间上成立的路线必然最优。'], sourceSentence: '即使一条路线在空间上成立，也要结合任务目标判断它是否合适。', errorSegments: <String>['只要一条路线','在空间上成立，','它就一定是','所有任务的最佳选择。'], errorIndex: 2, grammarFamily: '条件强度', grammarRule: '区分必要条件、充分条件与权衡条件。', learning: '修复充分条件误用', knowledge: '可行性、任务适配', language: '即使…也要…', reasoning: '评估条件强度与决策边界', why: '空间可行只是必要信息之一，不能推出所有任务都最佳。', difficulty: 'Lv10 条件逻辑', storyEvidence: '空间事实限定可能性，身份与任务改变优先次序。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.grammarRepair, prompt: '沈砚和阿宁共同署名一张图，这张图既保留两条路线，并且也说明各自成立条件。', answer: '沈砚和阿宁共同署名一张图，这张图既保留两条路线，也说明各自成立条件。', options: <String>['沈砚和阿宁共同署名一张图，这张图既保留两条路线，也说明各自成立条件。','沈砚和阿宁共同署名一张图，这张图既保留两条路线，并且也说明各自成立条件。','沈砚和阿宁共同署名一张图，这张图既保留两条路线，所以也说明各自成立条件。','沈砚和阿宁共同署名一张图，这张图既保留两条路线，但是也因此说明各自成立条件。'], sourceSentence: '沈砚和阿宁共同署名一张图，这张图既保留两条路线，也说明各自成立条件。', errorSegments: <String>['沈砚和阿宁共同署名一张图，','这张图既保留两条路线，','并且也说明','各自成立条件。'], errorIndex: 2, grammarFamily: '关联搭配', grammarRule: '复杂并列句使用成套关联词，不叠加同义连接成分。', learning: '修复复杂并列关联', knowledge: '共同署名、成立条件', language: '既…也…', reasoning: '在信息密集句中保持逻辑清晰', why: '“既……也……”已经完整，“并且也”重复连接。', difficulty: 'Lv10 精确书面语', storyEvidence: '共同署名一张保留差异的图。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '最终路线结论不仅要回答“能不能走”，还要回答“____”。', answer: '为什么这个任务应这样走', options: <String>['为什么这个任务应这样走','谁最早画了路线','哪条线颜色更深','谁记住更多建筑名'], sourceSentence: '最终路线结论不仅要回答“能不能走”，还要回答“为什么这个任务应这样走”。', learning: '整合可行性与理由', knowledge: '空间、任务', language: '不仅…还…', reasoning: '从存在判断升级为理由判断', why: '好的判断必须写明成立理由。', difficulty: 'Lv10 综合补全', storyEvidence: '好的判断要说明自己凭什么成立。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyCompletion, prompt: '当空间约束、人物目标和行动后果都被写清后，路线图才真正具备____。', answer: '可复核的成立条件', options: <String>['可复核的成立条件','唯一正确答案','不需要解释的结论','完全主观的偏好'], sourceSentence: '当空间约束、人物目标和行动后果都被写清后，路线图才真正具备可复核的成立条件。', learning: '理解高阶记录质量', knowledge: '成立条件', language: '当…才…', reasoning: '三类信息到可复核性', why: '完整条件使别人能够独立检查路线为何成立。', difficulty: 'Lv10 结果补全', storyEvidence: '保留各自成立的条件。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '要证明 Lv10 的沈砚真正放弃“唯一答案”思维，哪组证据最完整？', answer: '他保留两条路线写明各自成立条件并与阿宁共同署名', options: <String>['他保留两条路线写明各自成立条件并与阿宁共同署名','他仍从午门进入并观察中轴','阿宁仍执行东侧任务','两人都知道乾清门的位置'], sourceSentence: '两条路线都写明成立条件，沈砚与阿宁共同署名。', learning: '组合结论、条件与关系证据', knowledge: '路线成立条件', language: '并列三项', reasoning: '三类变化共同支持高阶结论', why: '保留差异、说明条件、共同署名同时证明认知与关系变化。', difficulty: 'Lv10 三证据综合', storyEvidence: '两条路线都写明成立条件，沈砚与阿宁共同署名。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.storyEvidence, prompt: '“空间事实限定可能性，身份与任务改变优先次序”在 Story 中如何得到支持？', answer: '真实建筑连接限定可行路线不同任务使人物在可行路线中作不同选择', options: <String>['真实建筑连接限定可行路线不同任务使人物在可行路线中作不同选择','建筑事实与任务都完全由个人喜好决定','只要任务不同就可以无视空间','中轴存在就取消所有其他选择'], sourceSentence: '建筑连接、人物目标与行动后果被放在一起检验。', learning: '把全文压缩成因果模型', knowledge: '约束、任务、优先级', language: '而结构', reasoning: '从多层证据概括原则', why: '空间决定可行范围，任务在范围内改变优先选择。', difficulty: 'Lv10 原理概括', storyEvidence: '建筑连接、人物目标与行动后果被放在一起检验。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '为什么“午门→中轴→乾清门”可以是强有力的观察框架，却不是万能路线？', answer: '它清楚呈现南北空间组织但具体行动还受任务和其他连接影响', options: <String>['它清楚呈现南北空间组织但具体行动还受任务和其他连接影响','它只包含虚构建筑','它与外朝内廷没有关系','它要求所有人从同一方向离开'], sourceSentence: '中轴序列具有解释力，但具体路线还取决于任务与真实连接。', learning: '综合中轴框架与任务路线', knowledge: '午门、中轴、乾清门', language: '却不是', reasoning: '建筑知识与行动推理整合', why: '中轴解释空间组织，但解释力不等于所有任务的唯一行动优先级。', difficulty: 'Lv10 综合知识', storyEvidence: '中轴提供整体结构，任务与连接决定具体行动。', knowledgeSource: '北京市官方中轴资料 / 故宫博物院'),
    _Spec(mode: StoryChallengeMode.knowledgeReasoning, prompt: '判断一条穿过外朝、到乾清门前再转向的路线是否合理，至少需要哪三类信息？', answer: '真实空间连接任务目标行动后果', options: <String>['真实空间连接任务目标行动后果','建筑颜色天气画线粗细','人物年龄笔的颜色路线名称','只需要是否沿中轴'], sourceSentence: '高阶路线判断需要真实连接、任务目标和行动后果。', learning: '建立完整路线判断要素', knowledge: '外朝、乾清门、任务', language: '至少需要', reasoning: '多维知识整合', why: '空间可行、行动目的、行动后果共同构成可复核判断。', difficulty: 'Lv10 三维知识', storyEvidence: '建筑连接、人物目标与行动后果。', knowledgeSource: '故宫博物院 / 当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '两条工作路线都可行：A更符合中轴观察，B更直接服务当前东侧记录任务。你负责最终批准。最佳做法是？', answer: '保留两条可行路线明确当前任务优先B并记录各自成立条件', options: <String>['保留两条可行路线明确当前任务优先B并记录各自成立条件','因为A常用就删除B','因为B更直接就宣布A错误','不说明任务随机批准一条'], sourceSentence: '多方案决策要保留可行方案，并按当前任务给出有条件优先级。', learning: '做有条件的最终决策', knowledge: '框架、任务、成立条件', language: '明确…并…', reasoning: '多方案权衡并记录理由', why: '成熟决策承认可行性，同时针对当前任务给优先级并保留证据。', difficulty: 'Lv10 权衡决策', storyEvidence: '两条路线都写明成立条件。', knowledgeSource: '当前 Story'),
    _Spec(mode: StoryChallengeMode.scenarioDecision, prompt: '现场证据突然显示原计划中的一个连接点不可用，但任务目标没有改变。你应怎样更新路线？', answer: '先重算空间可行范围再按任务与后果重新选择', options: <String>['先重算空间可行范围再按任务与后果重新选择','继续按原路线因为目标没变','只修改任务名称不改路线','忽略现场连接证据'], sourceSentence: '约束变化后先更新可行范围，再按任务与后果选择。', learning: '动态更新受约束决策', knowledge: '空间约束、任务、后果', language: '先…再…', reasoning: '约束变化后重新求解', why: '空间约束变化会改变可行集合，之后才能重新比较任务优先级。', difficulty: 'Lv10 动态决策', storyEvidence: '空间事实限定可能性，身份与任务改变优先次序。', knowledgeSource: '故宫博物院 / 当前 Story'),
  ],
];

StoryChallengeSet buildForbiddenCityGoldenChallenge({
  required int level,
  required List<String> storyParagraphs,
}) {
  if (level < 1 || level > 10) {
    throw StateError('Golden Challenge requires explicit Lv1-Lv10 content.');
  }
  final specs = _levels[level - 1];
  if (specs.length != 12) {
    throw StateError('Golden Challenge Lv$level must contain exactly 12 authored questions.');
  }
  final expectedModes = <StoryChallengeMode>[
    StoryChallengeMode.sentenceRebuild,
    StoryChallengeMode.grammarRepair,
    StoryChallengeMode.storyCompletion,
    StoryChallengeMode.storyEvidence,
    StoryChallengeMode.knowledgeReasoning,
    StoryChallengeMode.scenarioDecision,
  ];
  for (final mode in expectedModes) {
    if (specs.where((item) => item.mode == mode).length != 2) {
      throw StateError('Golden Challenge Lv$level requires exactly 2 ${mode.name}.');
    }
  }

  final storyText = storyParagraphs.join('\n');
  final questions = <StoryChallengeQuestion>[];
  for (var index = 0; index < specs.length; index += 1) {
    final spec = specs[index];
    _validateSpec(level, index, spec, storyText);
    final id = 'lv$level-q${index + 1}-${spec.mode.name}';
    final templateSignature = _templateSignature(spec.prompt);
    final semanticSignature = _hash([
      spec.mode.name,
      spec.learning,
      spec.knowledge,
      spec.reasoning,
      spec.sourceSentence,
    ].join('|'));
    final options = List<String>.unmodifiable(spec.options);
    final whyCorrect = spec.why;
    final rationales = <String>[
      for (final option in options)
        option == spec.answer
            ? '正确：$whyCorrect'
            : '错误：不满足“${spec.reasoning}”或与“${spec.knowledge}”证据不一致。',
    ];
    questions.add(
      StoryChallengeQuestion(
        id: id,
        mode: spec.mode,
        sourceSentence: spec.sourceSentence,
        prompt: spec.prompt,
        answer: spec.answer,
        options: options,
        characterTiles: spec.mode == StoryChallengeMode.sentenceRebuild
            ? List<String>.unmodifiable(_scramble(spec.chunks, level, index))
            : const <String>[],
        errorSegments: List<String>.unmodifiable(spec.errorSegments),
        errorSegmentIndex: spec.errorIndex,
        grammarFamily: spec.grammarFamily,
        grammarWhyWrong: spec.mode == StoryChallengeMode.grammarRepair
            ? spec.why
            : null,
        grammarRevisionRule: spec.grammarRule,
        grammarOptionExplanations:
            spec.mode == StoryChallengeMode.grammarRepair
                ? List<String>.unmodifiable(rationales)
                : const <String>[],
        narrationText: spec.prompt,
        learningObjective: spec.learning,
        knowledgeTarget: spec.knowledge,
        languageTarget: spec.language,
        reasoningTarget: spec.reasoning,
        whyCorrect: whyCorrect,
        distractorRationales: List<String>.unmodifiable(rationales),
        difficulty: spec.difficulty,
        storyEvidence: spec.storyEvidence,
        knowledgeSource: spec.knowledgeSource,
        signature: QuestionDesignSignature(
          journeyId: _journeyId,
          sessionLevel: level,
          mode: spec.mode,
          sourceParagraphIndex: 0,
          sourceSentenceIndex: index,
          sourceHash: _hash(spec.sourceSentence),
          syntaxPattern: _syntax(spec.sourceSentence),
          operationType: _operation(spec.mode),
          errorFamily: spec.grammarFamily,
          gapType: spec.mode == StoryChallengeMode.storyCompletion
              ? 'context-completion'
              : null,
          answerShape: spec.mode == StoryChallengeMode.sentenceRebuild
              ? '${spec.chunks.length} semantic chunks'
              : options.isEmpty
                  ? 'constructed answer'
                  : '4-choice',
          distractorStrategy: options.isEmpty
              ? 'semantic-order'
              : 'plausible misconception / evidence mismatch',
          templateSignature: templateSignature,
          semanticSignature: semanticSignature,
        ),
      ),
    );
  }
  return StoryChallengeSet(
    journeyId: _journeyId,
    sessionLevel: level,
    questions: List<StoryChallengeQuestion>.unmodifiable(questions),
  );
}

void _validateSpec(int level, int index, _Spec spec, String storyText) {
  if (spec.learning.trim().isEmpty ||
      spec.knowledge.trim().isEmpty ||
      spec.language.trim().isEmpty ||
      spec.reasoning.trim().isEmpty ||
      spec.why.trim().isEmpty ||
      spec.difficulty.trim().isEmpty ||
      spec.knowledgeSource.trim().isEmpty) {
    throw StateError('Lv$level Q${index + 1} authoring record incomplete.');
  }
  if (spec.mode == StoryChallengeMode.sentenceRebuild) {
    if (spec.chunks.length < 3 || spec.chunks.join() != spec.answer) {
      throw StateError('Lv$level Q${index + 1} semantic rebuild drifted.');
    }
    if (spec.chunks.any(_looksLikeCharacterAtomization)) {
      throw StateError('Lv$level Q${index + 1} character atomization detected.');
    }
    for (final term in const <String>['紫禁城','午门','乾清门','中轴','外朝','内廷','秩序','路线','路径']) {
      if (!spec.answer.contains(term)) continue;
      if (!spec.chunks.any((chunk) => chunk.contains(term))) {
        throw StateError('Lv$level Q${index + 1} protected term split: $term');
      }
    }
  } else {
    if (spec.options.length != 4 ||
        spec.options.toSet().length != 4 ||
        spec.options.where((item) => item == spec.answer).length != 1) {
      throw StateError('Lv$level Q${index + 1} must have four unique options and one answer.');
    }
  }
  if (spec.mode == StoryChallengeMode.grammarRepair) {
    const punctuation = <String>{'。','，','！','？','：','；'};
    if (spec.errorSegments.length != 4 ||
        spec.errorIndex == null ||
        spec.errorIndex! < 0 ||
        spec.errorIndex! >= 4 ||
        spec.errorSegments.join() != spec.prompt ||
        spec.errorSegments.any((segment) =>
            segment.trim().isEmpty || punctuation.contains(segment.trim()))) {
      throw StateError('Lv$level Q${index + 1} Grammar Step 1 invalid.');
    }
    if (spec.options.any(_looksLikeBrokenSentence)) {
      throw StateError('Lv$level Q${index + 1} Grammar Step 2 fragment detected.');
    }
  }
  if (spec.mode == StoryChallengeMode.storyCompletion) {
    if (!spec.prompt.contains('____') || spec.sourceSentence.trim().isEmpty) {
      throw StateError('Lv$level Q${index + 1} Context Completion invalid.');
    }
    final restored = spec.prompt.replaceFirst('____', spec.answer);
    final normalizedRestored = restored.replaceAll(RegExp(r'\s+'), '');
    final normalizedSource = spec.sourceSentence.replaceAll(RegExp(r'\s+'), '');
    if (normalizedRestored != normalizedSource &&
        !normalizedSource.contains(normalizedRestored)) {
      throw StateError('Lv$level Q${index + 1} Context Completion does not restore source.');
    }
  }
  if (spec.mode == StoryChallengeMode.storyEvidence &&
      spec.storyEvidence.trim().isEmpty) {
    throw StateError('Lv$level Q${index + 1} Story Evidence lacks evidence.');
  }
  if (spec.storyEvidence.isNotEmpty) {
    final compactEvidence = spec.storyEvidence
        .replaceAll(RegExp(r'[“”\"…]'), '')
        .replaceAll(RegExp(r'\s+'), '');
    final compactStory = storyText
        .replaceAll(RegExp(r'[“”\"…]'), '')
        .replaceAll(RegExp(r'\s+'), '');
    final meaningfulTokens = compactEvidence
        .split(RegExp(r'[，。；：？！]'))
        .where((token) => token.length >= 4)
        .toList(growable: false);
    if (spec.mode == StoryChallengeMode.storyEvidence &&
        meaningfulTokens.isNotEmpty &&
        !meaningfulTokens.any(compactStory.contains)) {
      throw StateError('Lv$level Q${index + 1} Story Evidence not grounded in current Story.');
    }
  }
}

bool _looksLikeCharacterAtomization(String chunk) {
  final han = RegExp(r'[\u3400-\u9fff]').allMatches(chunk).length;
  return han == 1 && !const <String>{'却','再'}.contains(chunk);
}

bool _looksLikeBrokenSentence(String value) {
  final text = value.trim();
  if (!text.endsWith('。') && !text.endsWith('？') && !text.endsWith('！')) {
    return true;
  }
  return RegExp(r'(写在|内廷往|因为所以|而且所以)[。？！]$').hasMatch(text);
}

List<String> _scramble(List<String> chunks, int level, int index) {
  final result = List<String>.of(chunks.reversed);
  if (result.length > 2) {
    final shift = (level + index) % result.length;
    return <String>[...result.skip(shift), ...result.take(shift)];
  }
  return result;
}

String _operation(StoryChallengeMode mode) => switch (mode) {
      StoryChallengeMode.sentenceRebuild => 'Semantic Sentence Rebuild',
      StoryChallengeMode.grammarRepair => 'Grammar Repair',
      StoryChallengeMode.storyCompletion => 'Context Completion',
      StoryChallengeMode.storyEvidence => 'Story Evidence / Understanding',
      StoryChallengeMode.knowledgeReasoning => 'Forbidden City Knowledge / Spatial Reasoning',
      StoryChallengeMode.scenarioDecision => 'Scenario / Route Decision',
    };

String _templateSignature(String value) {
  var normalized = value
      .replaceAll(RegExp(r'Lv\d+'), 'Lv#')
      .replaceAll(RegExp(r'沈砚|阿宁|周师傅'), '<PERSON>')
      .replaceAll(RegExp(r'紫禁城|午门|乾清门|中轴|外朝|内廷|东侧'), '<PLACE>')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  normalized = normalized.replaceAll(RegExp(r'[A-DＡ-Ｄ]'), '<OPTION>');
  return _hash(normalized);
}

String _syntax(String sentence) {
  if (sentence.contains('把')) return '把字句';
  if (sentence.contains(RegExp(r'因为|所以|因此'))) return '因果结构';
  if (sentence.contains(RegExp(r'虽然|即使|只要|如果'))) return '条件让步';
  if (sentence.contains(RegExp(r'却|但是|而'))) return '转折结构';
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
