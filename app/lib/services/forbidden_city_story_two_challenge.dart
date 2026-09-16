import '../models/journey_challenge.dart';
import '../data/journey_story_identity.dart';

class _RebuildSpec {
  const _RebuildSpec(this.prompt, this.answer, this.chunks, this.evidence,
      this.learning, this.reasoning);
  final String prompt;
  final String answer;
  final List<String> chunks;
  final String evidence;
  final String learning;
  final String reasoning;
}

class _GrammarSpec {
  const _GrammarSpec(
    this.prompt,
    this.answer,
    this.options,
    this.segments,
    this.errorIndex,
    this.family,
    this.rule,
    this.evidence,
    this.learning,
  );
  final String prompt;
  final String answer;
  final List<String> options;
  final List<String> segments;
  final int errorIndex;
  final String family;
  final String rule;
  final String evidence;
  final String learning;
}

class _ChoiceSpec {
  const _ChoiceSpec(
    this.prompt,
    this.answer,
    this.options,
    this.source,
    this.evidence,
    this.knowledge,
    this.learning,
    this.reasoning,
    [this.sourceLabel = '当前 Story / Story 2 Discovery']
  );
  final String prompt;
  final String answer;
  final List<String> options;
  final String source;
  final String evidence;
  final String knowledge;
  final String learning;
  final String reasoning;
  final String sourceLabel;
}

class _LevelSpec {
  const _LevelSpec({
    required this.rebuilds,
    required this.grammars,
    required this.completions,
    required this.evidence,
    required this.knowledge,
    required this.decisions,
  });
  final List<_RebuildSpec> rebuilds;
  final List<_GrammarSpec> grammars;
  final List<_ChoiceSpec> completions;
  final List<_ChoiceSpec> evidence;
  final List<_ChoiceSpec> knowledge;
  final List<_ChoiceSpec> decisions;
}

const _levels = <_LevelSpec>[
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('按语义块复原白昀最初的动作。', '白昀把备用灯往前挪了半步', <String>['白昀把备用灯', '往前挪了', '半步'], '她把备用灯往前挪了半步。', '识别人物最初行动', '按人物—对象—方向—幅度组织动作'),
      _RebuildSpec('按语义块复原杜衡的第一个问题。', '这盏灯原来在方案里吗', <String>['这盏灯', '原来', '在方案里吗'], '杜衡只问：“这盏灯原来在方案里吗？”', '理解杜衡先核对条件而非直接禁止', '从现场冲突中恢复先核对方案的提问'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('白昀因为想更亮，所以把备用灯只两分钟。', '白昀想让画面更亮，所以打算把备用灯打开两分钟。', <String>['白昀想让画面更亮，所以打算把备用灯打开两分钟。','白昀因为想更亮，所以把备用灯只两分钟。','白昀想让画面更亮，但是备用灯打开两分钟所以。','白昀把画面想更亮，因此两分钟是备用灯。'], <String>['白昀因为想更亮，','所以把备用灯','只','两分钟。'], 2, '动词缺失与数量补语', '数量短语必须依附明确动作，不能直接代替“打开两分钟”。', '她说“再亮一点，两分钟就够”。', '修复动作与时长关系'),
      _GrammarSpec('杜衡没有说不许，所以先问方案。', '杜衡没有直接说“不许”，而是先问这盏灯是否在方案里。', <String>['杜衡没有直接说“不许”，而是先问这盏灯是否在方案里。','杜衡没有说不许，所以先问方案。','杜衡既然没有说不许，就表示灯一定可以加。','杜衡先问方案，因此他已经同意加灯。'], <String>['杜衡没有说不许，','所以','先问','方案。'], 1, '转折关系', '前后是“没有直接禁止”与“先核对条件”的转折推进，不是简单因果。', '杜衡按住灯架，没有说“不许”，只问方案。', '区分转折推进与错误因果'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('第一遍拍摄结束后，书页右下角仍然____。', '暗', <String>['暗','过曝','离开画面','被移走'], '第一遍拍摄结束后，书页右下角仍然暗。', '纸边沉在阴影里。', '画面直接事实', '从 Story 补全结果', '根据第一遍拍摄结果恢复状态', '当前 Story'),
      _ChoiceSpec('白昀起初把木柱、门槛和暗红墙面只当成____。', '背景', <String>['背景','主角','灯具','出口'], '白昀起初把木柱、门槛和暗红墙面只当成背景。', '她原本只把它们当背景。', '人物初始认知', '识别人物起点认知', '从叙述恢复人物对地点的旧判断', '当前 Story'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪条证据最能说明白昀一开始最在意的是画面亮度？', '她盯着纸边阴影并提出“再亮一点”', <String>['她盯着纸边阴影并提出“再亮一点”','杜衡检查线缆','武英殿闭馆了','门槛在镜头边缘'], '她盯着纸边阴影并提出“再亮一点”。', '监视器里字能看清，纸边沉在阴影里。', '人物目标证据', '选择最直接的欲望证据', '区分人物目标与环境事实', '当前 Story'),
      _ChoiceSpec('杜衡为什么没有把冲突变成“我说不许”？', '他先要求核对灯是否属于既定方案', <String>['他先要求核对灯是否属于既定方案','他不知道灯怎么用','他想让画面更暗','他准备离开现场'], '杜衡先核对灯是否属于既定方案。', '“这盏灯原来在方案里吗？”', '预防性判断起点', '理解人物方法', '从提问方式推断杜衡先事实后判断', '当前 Story'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('为什么木构宫殿里的临时用电不能只被理解成摄影技术问题？', '因为电源、线缆和人员路线同时影响遗产现场风险', <String>['因为电源、线缆和人员路线同时影响遗产现场风险','因为木构建筑不能拍摄','因为所有 LED 都会烧坏木材','因为故宫内完全禁止电力'], '木构遗产的风险判断包含用电与现场组织。', 'Discovery 强调防火和用电管理属于保护建筑本体。', '木构遗产现场安全', '把地点知识用于解释冲突', '由木构特征推出现场风险必须综合判断', '故宫博物院·防火安全'),
      _ChoiceSpec('武英殿在本故事中为什么不能只被当成漂亮背景？', '因为建筑本身属于紫禁城遗产并承载具体历史活动', <String>['因为建筑本身属于紫禁城遗产并承载具体历史活动','因为它的墙一定比书页更亮','因为只有武英殿允许拍摄','因为所有故事都必须发生在宫殿'], '武英殿既是建筑遗产也是历史活动发生的具体空间。', 'Discovery 要求把建筑与历史活动一起理解。', '地点必要性基础', '理解建筑本体与历史功能', '同时考虑建筑身份与历史功能', '故宫博物院·武英殿 / UNESCO'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('你是白昀，发现备用灯不在方案里。下一步最合理的是？', '先把灯退回标记线并检查现有方案还能怎样解决画面', <String>['先把灯退回标记线并检查现有方案还能怎样解决画面','趁两分钟没人注意直接开灯','因为 LED 不热就忽略方案','停止拍摄并认定无法完成'], '备用灯不在既定方案里。', '杜衡让她先把灯退回标记线。', '现场变化处理', '练习先回到已知条件', '先恢复受控状态再解决创作问题', '当前 Story / 防火安全'),
      _ChoiceSpec('如果书页能看清但角落偏暗，最不应该直接推出什么？', '必须立刻增加一个新灯位', <String>['必须立刻增加一个新灯位','可以先检查反光和相机选择','需要判断暗处是否遮住必要信息','需要确认现场边界'], '暗角存在不等于必须改变现场。', '第一遍拍摄保留了一个暗角。', '需求与手段区分', '避免把结果直接绑定唯一手段', '区分“问题存在”与“只有一种解法”', '当前 Story'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原杜衡把问题扩大的那句话。', '多一盏灯改变的不只是亮度', <String>['多一盏灯', '改变的', '不只是亮度'], '多一盏灯，改变的不只是亮度。', '理解现场影响超出单一参数', '从局部亮度转向系统条件'),
      _RebuildSpec('复原白昀采用的替代办法。', '她先用反光板补回已有的光', <String>['她先用反光板', '补回', '已有的光'], '杜衡建议先用反光板。', '识别不增加电源点的替代行动', '把工具与目的组成完整行动'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('低温 LED 不发热，因此现场风险没有变化。', '即使低温 LED 发热较少，现场风险也不只由温度决定。', <String>['即使低温 LED 发热较少，现场风险也不只由温度决定。','低温 LED 不发热，因此现场风险没有变化。','只要 LED 低温，线缆和通道就自动安全。','因为灯只开两分钟，所以任何现场变化都不需要评估。'], <String>['低温 LED 不发热，','因此','现场风险','没有变化。'], 1, '让步与限制推论', '灯具温度只能减少一个变量，不能推出全部风险不变。', '多一盏灯会改变电源、线缆和人员移动。', '限制过度因果'),
      _GrammarSpec('反光板没有增加电源点，所以一定没有任何风险。', '反光板没有增加新的电源点，但仍要按现场条件摆放和使用。', <String>['反光板没有增加新的电源点，但仍要按现场条件摆放和使用。','反光板没有增加电源点，所以一定没有任何风险。','反光板不接电，因此可以放在任何位置。','只要不用灯，人员路线就与拍摄无关。'], <String>['反光板没有增加电源点，','所以','一定没有','任何风险。'], 2, '绝对化判断', '“不增加新电源”不能扩大成“没有任何风险”。', '反光板是替代工具，但现场仍需受控。', '纠正绝对化结论'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('杜衡指出，新增一盏灯会同时改变电源、线缆和____。', '人员移动', <String>['人员移动','书页年代','武英殿名称','镜头标题'], '新增一盏灯会同时改变电源、线缆和人员移动。', '电源、线缆和人员移动都按方案排过。', '现场系统组成', '补全风险维度', '从并列信息恢复缺失项', '当前 Story'),
      _ChoiceSpec('白昀担心如果每一步都这么慢，今晚就____。', '交不了片', <String>['交不了片','不能进入武英殿','找不到复制页','必须改标题'], '如果每一步都这么慢，今晚就交不了片。', '“今晚交不了片。”', '人物压力来源', '恢复时间压力', '把速度焦虑与截止时间连接', '当前 Story'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪条 Story 证据说明“低温”没有解决杜衡真正关心的问题？', '他转而指出地上的电源、线缆和人员路线', <String>['他转而指出地上的电源、线缆和人员路线','白昀说灯只开两分钟','书页仍有纸纹','武英殿很安静'], '杜衡转而指出电源、线缆和人员路线。', '他没有和她争“热不热”，而是把地上的胶带指给她看。', '风险维度变化', '识别争论焦点转移', '从人物回应判断真正关注点', '当前 Story'),
      _ChoiceSpec('为什么“能说明为什么这样做”比单纯“慢一点”更重要？', '因为保护判断要能被复核而不是只服从某个人的节奏', <String>['因为保护判断要能被复核而不是只服从某个人的节奏','因为慢一定比快安全','因为杜衡拥有最终摄影权','因为所有镜头都应该减少亮度'], '杜衡说“慢不是目的，能说明为什么这样做才是”。', '慢不是目的。能说明为什么这样做，才是。', '可说明的判断', '理解程序不是目的本身', '从对白提炼可复核决策原则', '当前 Story'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('在木构遗产现场增加电器设备，哪组因素最需要一起检查？', '电源安排线缆路径人员通行与设备位置', <String>['电源安排线缆路径人员通行与设备位置','只有灯泡色温','只有摄影师是否喜欢','只看镜头分辨率'], '临时设备会改变多个现场条件。', 'Discovery 将电源、线缆、人员通行和现场变化并列。', '预防性保护风险识别', '综合多个现场因素', '拒绝单变量安全判断', '故宫博物院·防火安全'),
      _ChoiceSpec('为什么反光板在这一层是更合适的第一尝试？', '它利用已有光线解决部分视觉问题而不增加新电源点', <String>['它利用已有光线解决部分视觉问题而不增加新电源点','它能让所有阴影自动消失','它证明任何摄影设备都无风险','它可以替代所有保护判断'], '反光板利用已有光线。', '杜衡建议先用反光板，不增加新的电源点。', '已有条件优先', '理解替代方案为什么更小改动', '比较方案对现场条件的改变量', '当前 Story / 防火安全'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('现场需要更亮，但新增电源点会改变线缆路径。第一轮方案比较应怎么做？', '先比较能否用现有光和反光方式满足必要信息', <String>['先比较能否用现有光和反光方式满足必要信息','先新增电源再讨论路线','因为截止时间紧直接忽略线缆','把所有风险都归给杜衡'], '已有光线可以先被重新利用。', '两人先试反光板。', '最小现场改动', '练习替代方案比较', '优先测试不扩大现场变化的手段', '当前 Story'),
      _ChoiceSpec('团队成员说“灯不热，所以不用看走线”。你最合适的回应是？', '温度只是一个因素还要检查电源线缆和人员通道', <String>['温度只是一个因素还要检查电源线缆和人员通道','对低温灯完全不用管理','只要拍得快就没有风险','走线只影响画面不影响现场'], '低温不能代表全部现场条件不变。', '杜衡把问题从温度转向现场组织。', '多因素风险沟通', '反驳单变量推论', '用更完整因素集合修正判断', '故宫博物院·防火安全'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原白昀对地点关系的新认识。', '复制书页被带回了与刊书历史有关的空间', <String>['复制书页', '被带回了', '与刊书历史有关的空间'], '复制书页故意回到与刊书历史有关的空间。', '理解物与地点的历史关联', '把对象、动作和地点关系组成句子'),
      _RebuildSpec('复原这一层最关键的自问。', '把建筑只当摄影棚会不会删掉最重要的关系', <String>['把建筑只当摄影棚', '会不会删掉', '最重要的关系'], '她不确定把建筑当成可无限加灯的摄影棚是否删掉最重要的关系。', '识别认知转折问题', '从知识进入人物判断'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('因为武英殿有刊书史，所以任何书页都来自这里。', '武英殿与宫廷刊书史关系密切，但不能因此认定任何书页都来自这里。', <String>['武英殿与宫廷刊书史关系密切，但不能因此认定任何书页都来自这里。','因为武英殿有刊书史，所以任何书页都来自这里。','只要书页放在武英殿，就自动变成武英殿本。','武英殿本说明所有清代书都在这座殿刊刻。'], <String>['因为武英殿有刊书史，','所以','任何书页','都来自这里。'], 1, '历史事实过度推论', '地点与刊书传统相关，不能推出所有书页来源。', '故事明确说拍摄的是复制书页。', '限制知识推论范围'),
      _GrammarSpec('建筑经历重建，因此它的历史就不真实了。', '建筑经历重建，并不等于它的历史价值或时间层次因此消失。', <String>['建筑经历重建，并不等于它的历史价值或时间层次因此消失。','建筑经历重建，因此它的历史就不真实了。','只要重建过，建筑就没有任何历史证据。','重建以后只能讨论新建筑，不能讨论过去。'], <String>['建筑经历重建，','因此','它的历史','就不真实了。'], 1, '因果过度化', '重建是建筑历史的一部分，不能推出历史价值消失。', '白昀看到损毁、修复和重建资料。', '修复错误因果'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('“武英殿本”与清代宫廷____活动密切相关。', '刊书', <String>['刊书','巡城','园林造景','航运'], '“武英殿本”与清代宫廷刊书活动密切相关。', '资料说明武英殿与宫廷修书、刊书活动关系密切。', '武英殿历史功能', '补全历史知识', '从 Discovery 恢复核心术语', '故宫博物院·武英殿'),
      _ChoiceSpec('白昀第一次意识到，复制书页不是随便放进一座____里。', '古建筑', <String>['古建筑','摄影棚','现代办公室','仓库'], '复制书页不是随便放进一座古建筑里。', '它故意回到与刊书历史有关的空间。', '地点绑定', '恢复地点判断', '由地点关联补全对象类别', '当前 Story'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪条证据最能证明白昀开始把“建筑本身”当作故事信息？', '她抬头看梁架又回看监视器里的阴影', <String>['她抬头看梁架又回看监视器里的阴影','她收到制片人消息','她把灯往前挪','她看见纸纹'], '她抬头看梁架，再看监视器里那块阴影。', '她把建筑经历与画面阴影联系起来。', '认知焦点改变', '识别人物注意力转移', '从动作判断认知转折'),
      _ChoiceSpec('为什么“武英殿本”知识会改变拍摄，而不是只增加百科信息？', '它让白昀理解书页与具体空间有历史因果关系', <String>['它让白昀理解书页与具体空间有历史因果关系','它证明复制页就是原件','它要求镜头一定更亮','它让截止时间自动延后'], '地点知识进入了她的镜头判断。', '她第一次意识到书页故意回到与刊书历史有关的空间。', 'Discovery 改变判断', '区分知识卡与叙事证据', '知识必须改变人物对画面的评价'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('“武英殿本”最合理的理解是什么？', '与武英殿宫廷刊刻传统相关的版本称呼', <String>['与武英殿宫廷刊刻传统相关的版本称呼','武英殿建筑施工图的名称','所有清代书籍的总称','现代复制页的摄影编号'], '武英殿本是与宫廷刊刻传统相关的版本称呼。', 'Discovery 明确解释武英殿本。', '版本史', '准确理解历史术语', '避免把版本名扩大为所有书籍'),
      _ChoiceSpec('为什么武英殿的重建资料与本 Story 有关？', '它提醒白昀建筑本身也有损毁修缮与时间层次', <String>['它提醒白昀建筑本身也有损毁修缮与时间层次','它证明现代灯具来自清代','它说明所有旧建筑必须保持黑暗','它决定了摄影参数'], '建筑现存状态包含修缮与重建的时间层。', '白昀看到重建资料后重新看梁架与阴影。', '建筑历史层', '把修缮史用于叙事判断', '从建筑历史推出“现场本身也是证据”'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('你要拍与某处历史功能有关的文物复制品，最先应问哪个问题？', '这个对象与当前地点的历史关系是什么', <String>['这个对象与当前地点的历史关系是什么','怎样把背景全部压黑','怎样让文物占满画面','怎样省掉所有场地信息'], '对象与地点存在历史关系。', '白昀因刊书史重新理解复制页。', '地点叙事绑定', '把知识用于拍摄设计', '先确认对象与地点的历史关系'),
      _ChoiceSpec('如果更亮的画面让武英殿几乎无法辨认，你应怎样评价？', '先判断这样是否削弱书页与地点的历史关系再决定是否调整', <String>['先判断这样是否削弱书页与地点的历史关系再决定是否调整','只要字更清楚就一定更好','背景消失完全没有信息损失','因为是古建筑就必须全部拍进画面'], '画面选择影响地点关系是否可读。', '白昀开始怀疑无限加灯会删掉重要关系。', '叙事信息权衡', '评估清晰度与地点意义', '比较增加清晰度与丢失空间信息的代价'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原截止时间怎样进入冲突。', '制片人要求今晚必须交一版更亮的主镜头', <String>['制片人要求', '今晚必须交', '一版更亮的主镜头'], '“主镜头太灰，今晚必须给我一版更亮的。”', '识别外部压力', '按要求者—时间—交付物组织信息'),
      _RebuildSpec('复原白昀开始停顿的判断链。', '灯不热功率不大并不能回答线缆和建筑表面的风险', <String>['灯不热功率不大', '并不能回答', '线缆和建筑表面的风险'], '说到线缆、人员通道和建筑表面时，她停住了。', '理解单一理由不足', '从已有理由与缺失维度形成限制结论'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('截止时间很紧，所以现场条件就可以暂时不算。', '即使截止时间很紧，现场条件也不能因此被排除在判断之外。', <String>['即使截止时间很紧，现场条件也不能因此被排除在判断之外。','截止时间很紧，所以现场条件就可以暂时不算。','只要今晚要交片，任何临时变化都自动合理。','因为制片人催片，所以保护人员应该停止提问。'], <String>['截止时间很紧，','所以','现场条件','就可以暂时不算。'], 1, '让步结构', '时间压力会改变人物代价，但不能取消现场事实。', '白昀受到催片压力，却仍必须回答线缆和建筑表面问题。', '在压力下保持条件判断'),
      _GrammarSpec('白昀觉得没事，因此这就是完整依据。', '白昀觉得“没事”只是个人判断，不能因此成为完整依据。', <String>['白昀觉得“没事”只是个人判断，不能因此成为完整依据。','白昀觉得没事，因此这就是完整依据。','只要经验足够，个人感觉可以代替现场条件。','既然灯功率小，就不需要说明其他因素。'], <String>['白昀觉得没事，','因此','这就是','完整依据。'], 1, '主观判断与证据', '个人判断不能自动升级为可复核依据。', '“我觉得没事”并不是一个完整的拍摄依据。', '区分感觉与依据'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('白昀真正害怕的不是重拍，而是第一次负责主镜头就被认为没有____。', '能力', <String>['能力','灯具','书页','通行证'], '白昀害怕第一次负责主镜头就被认为没有能力。', '她怕第一次负责主镜头就被认为没有能力。', '人物内在压力', '补全恐惧', '从心理叙述恢复关键词'),
      _ChoiceSpec('当杜衡问到线缆、人员通道和建筑表面时，白昀____了。', '停住', <String>['停住','马上加灯','离开武英殿','删除素材'], '说到线缆、人员通道和建筑表面时，白昀停住了。', '她发现自己的理由并不完整。', '认知停顿', '补全关键动作', '从理由不足推回人物反应'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪条证据最能说明白昀的决定已被职业自尊影响？', '她没有给杜衡看催片消息并马上拿出第二只灯', <String>['她没有给杜衡看催片消息并马上拿出第二只灯','她读了武英殿资料','她使用反光板','她看见门槛'], '她没有给杜衡看催片消息，随后拿出第二只灯。', '她怕第一次主镜头被认为没有能力。', '动机与行动证据', '从隐藏信息与行动推断动机', '把心理压力与风险行为连接'),
      _ChoiceSpec('为什么杜衡问“哪一项风险没有改变”比直接列禁令更有效？', '它迫使白昀自己检查哪些条件被她漏掉', <String>['它迫使白昀自己检查哪些条件被她漏掉','它表示所有风险其实没变','它让杜衡不用承担责任','它证明第二只灯一定安全'], '哪一项风险没有改变？', '白昀列到线缆、通道和建筑表面时停住。', '自我审查机制', '理解提问如何改变判断者', '从问题触发的人物停顿推断作用'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('临时加灯时，为什么“只开两分钟”仍不足以完成风险评估？', '因为时长只覆盖一个变量现场布局和用电路径仍可能改变', <String>['因为时长只覆盖一个变量现场布局和用电路径仍可能改变','因为两分钟一定会烧坏木构','因为时间从不影响风险','因为所有临时灯都违法'], '短时长不能覆盖全部现场变量。', 'Story 将时长与线缆、通道、建筑表面并列。', '多变量风险', '限制“时间短=安全”推论', '检查被短时长理由遗漏的条件'),
      _ChoiceSpec('世界遗产现场为什么需要可复核的变化依据？', '因为个人压力和偏好不能替代建筑保护条件', <String>['因为个人压力和偏好不能替代建筑保护条件','因为创作者不能做任何决定','因为所有现场都必须完全不变','因为遗产价值只来自规章'], '遗产现场变化需要可说明依据。', '白昀发现“我觉得没事”不够。', '保护决策可复核性', '连接制度与人物判断', '把个人判断放回共同保护条件'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('你收到“今晚必须更亮”的消息，同时发现新增灯位未评估。最佳下一步是？', '把截止压力写进决策但先重新评估新增灯位的现场影响', <String>['把截止压力写进决策但先重新评估新增灯位的现场影响','因为截止时间紧直接加灯','把消息藏起来让别人承担后果','停止沟通并放弃拍摄'], '截止时间是真实压力，但不是取消条件的理由。', '白昀在压力下发现理由不完整。', '压力下决策', '同时承认时间与风险', '不隐藏代价也不让时间取代现场证据'),
      _ChoiceSpec('同事说“我做过很多次，没出过事”。你该补问什么？', '这次现场的电源线缆人员路线和建筑表面条件是否相同', <String>['这次现场的电源线缆人员路线和建筑表面条件是否相同','以前没出事所以这次一定安全','经验多的人不需要方案','只问灯具品牌就够了'], '经验不能证明当前条件完全相同。', 'Story 要求逐项检查具体现场。', '经验与当前证据', '把历史经验转成条件核对', '确认当前场景是否满足经验成立条件'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原白昀新的判断分类。', '她把想要的画面已核定条件和需重评变化分开', <String>['她把想要的画面', '已核定条件', '和需重评变化分开'], '她把判断分成想要的画面、已核定条件和需要重评的变化。', '建立三类决策信息', '按欲望—事实—变化分类'),
      _RebuildSpec('复原白昀对制片人的新回答。', '我需要重新设计不是继续加亮', <String>['我需要重新设计', '不是', '继续加亮'], '“我需要重新设计，不是继续加亮。”', '识别不可逆认知改变', '用“不是…而是…”表达策略转变'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('因为这是我想要的画面，所以它就是已经核定的条件。', '我想要的画面与已经核定的现场条件是两类不同信息。', <String>['我想要的画面与已经核定的现场条件是两类不同信息。','因为这是我想要的画面，所以它就是已经核定的条件。','只要创作目标明确，现场条件就会自动改变。','已核定条件只是审美偏好的一种说法。'], <String>['因为这是我想要的画面，','所以','它就是','已经核定的条件。'], 1, '类别混淆', '创作欲望不能被语法因果偷换成已核定事实。', '杜衡要求白昀把三类信息分开。', '纠正类别偷换'),
      _GrammarSpec('她收回第二只灯，因此画面问题已经完全解决。', '她收回第二只灯，只解决了现场变化问题，画面仍需要重新设计。', <String>['她收回第二只灯，只解决了现场变化问题，画面仍需要重新设计。','她收回第二只灯，因此画面问题已经完全解决。','只要不加灯，主镜头就自动变好。','她既然收灯，就不需要再回应制片人。'], <String>['她收回第二只灯，','因此','画面问题','已经完全解决。'], 1, '局部解决与整体结果', '取消一个风险方案不等于视觉任务完成。', '第二只灯收回后主镜头仍不够“干净”。', '区分风险处理与创作完成'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('杜衡要求她把“想要的画面”和“已经____的条件”分开。', '核定', <String>['核定','想象','删除','忘记'], '杜衡要求她把想要的画面和已经核定的条件分开。', '原方案是已核定条件。', '决策分类术语', '补全核心词', '根据三分类恢复概念'),
      _ChoiceSpec('白昀最后没有继续加亮，而是决定重新____镜头。', '设计', <String>['设计','删除','隐藏','命名'], '白昀决定重新设计镜头。', '“我需要重新设计，不是继续加亮。”', '策略改变', '补全行动', '从对白恢复新策略'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪一处最能证明白昀开始自己承担决定，而不是让杜衡替她拒绝？', '她亲口对制片人说需要重新设计而不是继续加亮', <String>['她亲口对制片人说需要重新设计而不是继续加亮','杜衡递给她反光板','武英殿很暗','第二只灯在箱子里'], '她亲口对制片人说明需要重新设计。', '杜衡没有替她解释。', '责任转移证据', '识别决策主体变化', '从谁对外说明理由判断责任归属'),
      _ChoiceSpec('“只加两分钟”为什么在三分类里更接近愿望而不是证据？', '它描述想少付代价却没有说明现场变化是否仍被控制', <String>['它描述想少付代价却没有说明现场变化是否仍被控制','它包含所有风险数据','它是故宫官方规则','它证明主镜头一定更好'], '“只两分钟”不覆盖现场条件。', '每写下一项，它更像愿望而不是证据。', '理由质量', '评估论据是否完整', '检查理由是否说明关键条件'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('预防性保护最符合哪种处理顺序？', '变化前识别条件和风险再决定是否采用', <String>['变化前识别条件和风险再决定是否采用','先改变现场出问题后再补救','任何变化一律禁止','只由职位最高的人决定'], '预防性保护优先风险发生前的判断。', 'Discovery 强调重新评估比事后补救更符合预防逻辑。', '预防性保护', '识别预防与补救区别', '按风险发生前后排序'),
      _ChoiceSpec('“已核定条件”对创作最合理的作用是什么？', '提供边界并指出哪些变化需要重新讨论', <String>['提供边界并指出哪些变化需要重新讨论','替创作者决定所有构图','要求画面永远保持相同亮度','证明任何新想法都不允许'], '核定条件定义受控边界。', 'Discovery 说明核定条件不是让创作停止。', '保护边界与创作', '理解约束的功能', '把约束理解为重新讨论触发器而非全面禁止'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('一个新方案画面更好，但改变了原核定灯位。成熟做法是？', '把它标成需要重新评估的变化而不是偷偷当作原方案一部分', <String>['把它标成需要重新评估的变化而不是偷偷当作原方案一部分','因为画面更好就自动采用','把原方案文字改掉掩盖变化','让保护人员单独承担决定'], '变化要被识别和重新评估。', 'Story 三分类把变化单独列出。', '变更管理', '明确变化身份', '不把新方案伪装成旧条件'),
      _ChoiceSpec('你已经拒绝一个高风险办法，但任务仍没完成。下一步应该？', '继续设计满足任务且不扩大未评估变化的替代方案', <String>['继续设计满足任务且不扩大未评估变化的替代方案','宣布保护与创作无法共存','重新偷偷采用刚才的办法','只降低交付标准不再尝试'], '风险处理不等于任务完成。', '白昀收灯后仍需重新设计。', '约束下创新', '从“不能这样”走到“还能怎样”', '继续求解而不是把约束当终点'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原白昀的新问题。', '她开始问什么必须看清什么可以留在暗处', <String>['她开始问', '什么必须看清', '什么可以留在暗处'], '她把问题改成“什么必须看清，什么可以留在暗处”。', '识别问题框架变化', '从技术参数转向信息优先级'),
      _RebuildSpec('复原杜衡给出的两种选择。', '让相机适应现场或让现场服从相机', <String>['让相机适应现场', '或', '让现场服从相机'], '你可以让相机适应现场，也可以让现场服从相机。', '理解两类策略的对照', '用选择结构组织策略'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('暗边没有消失，所以镜头一定失败。', '暗边没有消失，但只要必要信息仍可辨认，镜头不一定失败。', <String>['暗边没有消失，但只要必要信息仍可辨认，镜头不一定失败。','暗边没有消失，所以镜头一定失败。','只要画面有阴影，就必须增加灯光。','如果存在暗部，所有历史信息都会消失。'], <String>['暗边没有消失，','所以','镜头','一定失败。'], 1, '条件判断', '阴影本身不能推出失败，关键是必要信息是否被遮住。', '白昀开始问什么必须看清。', '建立有条件的视觉判断'),
      _GrammarSpec('相机可以适应现场，因此现场条件完全不重要。', '相机可以适应现场，正因为现场条件重要，才需要调整拍摄方法。', <String>['相机可以适应现场，正因为现场条件重要，才需要调整拍摄方法。','相机可以适应现场，因此现场条件完全不重要。','只要调高感光度，就不需要任何现场判断。','相机参数能够取消建筑的保护要求。'], <String>['相机可以适应现场，','因此','现场条件','完全不重要。'], 1, '目的与条件关系', '调整相机是回应现场条件，不是证明现场条件无关。', '白昀调整感光度、构图和反光方式。', '修复反向因果'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('白昀把复制页移到已有灯光能够稳定____的位置。', '覆盖', <String>['覆盖','烧毁','避开','隐藏'], '白昀把复制页移到已有灯光能够稳定覆盖的位置。', '她先使用已有光区。', '既有条件利用', '补全动作结果', '根据拍摄调整恢复动词'),
      _ChoiceSpec('要完全消掉暗边，她就必须把光推得更强或把灯位改得更____。', '近', <String>['近','远','低','旧'], '要完全消掉暗边，她必须把光推得更强或把灯位改得更近。', '三次测试都显示相同代价。', '视觉代价', '补全比较条件', '从测试结果恢复变量方向'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪组动作证明白昀真的在让“相机适应现场”？', '移动复制页使用反光板并调整感光度和取景', <String>['移动复制页使用反光板并调整感光度和取景','增加第二只灯并扩大线缆','要求改变建筑表面','只让杜衡决定构图'], '她移动复制页、使用反光板并调整相机。', '这些动作没有新增现场电源点。', '策略证据组合', '识别“改拍法不改现场”', '按改变对象区分策略'),
      _ChoiceSpec('白昀把手从灯架上放下来代表什么？', '她停止把“更亮”当作默认方向开始比较信息与代价', <String>['她停止把“更亮”当作默认方向开始比较信息与代价','她决定彻底不拍','她认为保护人员永远正确','她忘记了截止时间'], '她把手从灯架上放下来。', '随后她改问什么必须看清。', '行动象征认知转向', '从细小动作推断判断改变', '结合前后行动解释动作含义'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('在遗产拍摄中，“阴影存在”与“信息丢失”是什么关系？', '阴影可能存在但要进一步判断是否遮住必要信息', <String>['阴影可能存在但要进一步判断是否遮住必要信息','两者永远完全相同','任何阴影都等于信息丢失','只要曝光正确就没有历史信息问题'], '阴影不是自动失败条件。', 'Discovery 把重点转为判断阴影是否遮住必要信息。', '视觉信息判断', '区分表面状态与功能结果', '用必要信息作为中介条件'),
      _ChoiceSpec('为什么调整相机参数通常比新增现场设备更小幅度？', '它主要改变记录方式而不必新增现场电源和路线条件', <String>['它主要改变记录方式而不必新增现场电源和路线条件','相机参数不会影响任何画面','新增设备永远违法','相机调整能保证零风险'], '改变相机不等于新增现场条件。', 'Story 通过感光度与构图解决部分问题。', '最小干预思路', '比较改变对象与外部影响', '区分记录系统调整和遗产现场调整'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('画面还有一条暗边，但文字与纸纹都清楚。下一步最合理的是？', '先判断暗边是否承担空间层次或遮住必要信息再决定是否继续调整', <String>['先判断暗边是否承担空间层次或遮住必要信息再决定是否继续调整','不分析直接加最强灯','只因为不均匀就判失败','把背景全部裁掉'], '暗边需要按信息功能判断。', '白昀从“消灭阴影”转向“必要信息”。', '视觉权衡', '建立功能性评价', '先评估影响再选手段'),
      _ChoiceSpec('如果不改现场也能通过构图和相机满足任务，应优先怎样做？', '先验证这种较小改动是否足够再考虑扩大现场变化', <String>['先验证这种较小改动是否足够再考虑扩大现场变化','仍先扩大现场变化因为更快','认为相机方案不专业','只看哪个方案更亮'], '较小改动可以先验证。', 'Story 用已有光、反光板和相机解决问题。', '分级干预', '按改动规模安排验证顺序', '先试可逆且不扩展现场条件的方案'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原白昀写下的新镜头原则。', '先看见殿再看见书', <String>['先看见殿', '再', '看见书'], '她重新写：“先看见殿，再看见书。”', '识别地点进入作品的转折', '用先后顺序表达新的观看结构'),
      _RebuildSpec('复原她对过去的两层理解。', '书页有过去建筑也经历自己的过去', <String>['书页有过去', '建筑也经历', '自己的过去'], '她想拍书页上的过去，也意识到建筑经历过的过去。', '理解双重历史层', '并列对象的时间关系'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('武英殿经历过重建，所以今天的建筑没有历史层次。', '武英殿经历过重建，因此今天的建筑更需要按修缮与重建的时间层次理解。', <String>['武英殿经历过重建，因此今天的建筑更需要按修缮与重建的时间层次理解。','武英殿经历过重建，所以今天的建筑没有历史层次。','只要重建过，现存建筑就与过去无关。','重建会自动删除所有历史证据。'], <String>['武英殿经历过重建，','所以','今天的建筑','没有历史层次。'], 1, '历史层次因果', '重建不是历史消失，而是历史层次的一部分。', '杜衡指出修缮与重建也是历史。', '修复对重建的错误推论'),
      _GrammarSpec('阴影保留下来，因此阴影本身就是历史。', '阴影保留下来，不是因为阴影本身就是历史，而是它让建筑与书页的关系仍可辨认。', <String>['阴影保留下来，不是因为阴影本身就是历史，而是它让建筑与书页的关系仍可辨认。','阴影保留下来，因此阴影本身就是历史。','只要画面变暗，就会自动增加历史真实性。','历史建筑应该故意拍得越暗越好。'], <String>['阴影保留下来，','因此','阴影本身','就是历史。'], 1, '象征与事实区分', '阴影是叙事手段，不是历史事实本身。', '暗处仍能辨认柱脚和门槛。', '防止浪漫化阴影'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('白昀意识到建筑经历的修缮与____也是历史的一部分。', '重建', <String>['重建','曝光','剪辑','配音'], '建筑经历的修缮与重建也是历史的一部分。', '杜衡给她看重建资料。', '武英殿历史层', '补全历史过程', '从 Discovery 恢复术语'),
      _ChoiceSpec('测试镜头里，暗处仍能辨认柱脚和____。', '门槛', <String>['门槛','字幕','摄影棚','现代高楼'], '测试镜头里，暗处仍能辨认柱脚和门槛。', '暗部没有吞掉地点信息。', '视觉证据', '补全场景细节', '从当前镜头恢复建筑细节'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪一项最能证明 Lv7 的转折来自白昀自己的判断？', '她主动删掉旧镜头说明并写“先看见殿再看见书”', <String>['她主动删掉旧镜头说明并写“先看见殿再看见书”','杜衡给她看资料','制片人继续催片','反光板仍在现场'], '她自己重写镜头说明。', '这不是杜衡替她做的决定。', '自主决定证据', '区分信息提供者与决策者', '看谁完成最终规则改写'),
      _ChoiceSpec('为什么重建资料会改变她对暗部的评价？', '它让她把建筑自身的时间经历也视为画面需要保留的信息', <String>['它让她把建筑自身的时间经历也视为画面需要保留的信息','它证明暗部一定来自火灾','它要求画面完全无光','它让复制页变成原件'], '建筑也有自己的过去。', '白昀把重建记录与监视器暗部联系起来。', '历史知识改变视觉判断', '解释知识如何进入叙事', '从资料到画面评价建立因果'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('理解武英殿现存建筑时，哪种说法更准确？', '修缮与重建留下的时间层次也是现存状态的一部分', <String>['修缮与重建留下的时间层次也是现存状态的一部分','只有最早材料才有历史价值','重建以后历史从零开始','所有修缮都应该在叙事中隐藏'], '现存状态包含历代修缮与重建。', 'Discovery 强调保护不是制造从未受损的想象状态。', '建筑真实性与时间层', '避免把真实等同于未受损', '以历史连续性理解现存建筑'),
      _ChoiceSpec('“先看见殿，再看见书”为什么具有地点必要性？', '因为武英殿与刊书史相关且建筑本身也是需要被理解的历史对象', <String>['因为武英殿与刊书史相关且建筑本身也是需要被理解的历史对象','因为任何博物馆都必须先拍建筑','因为书页不能独立存在','因为宫殿一定比书更重要'], '地点与刊书史、建筑历史同时关联。', '只有武英殿同时承担两种角色。', '地点不可替换性', '综合地点功能和建筑本体', '用双重角色证明不可替换'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('你发现一处修缮痕迹让画面“不完美”，但它有助于理解建筑历史。最合适的做法是？', '先判断它是否属于需要保留的历史信息再决定构图而不是默认抹掉', <String>['先判断它是否属于需要保留的历史信息再决定构图而不是默认抹掉','为了漂亮直接裁掉','把所有痕迹都故意放大','因为是修缮痕迹就禁止拍摄'], '痕迹可能承载时间信息。', 'Story 把重建与修缮纳入建筑历史。', '历史痕迹取舍', '避免美学先行删除信息', '先评估信息意义再构图'),
      _ChoiceSpec('如果一个视觉元素只是“看起来有历史感”但没有事实依据，应该？', '不要把审美效果误当历史事实应回到可核验资料', <String>['不要把审美效果误当历史事实应回到可核验资料','只要好看就写成历史事实','越暗越能代表古老','让观众自己猜不用核验'], '视觉气氛与历史事实需要区分。', 'Story 不把阴影浪漫化为历史本身。', '事实与审美边界', '防止视觉象征替代史实', '要求历史陈述可核验'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原白昀向制片人提交的比较。', '她同时发出均匀明亮版和保留暗部版', <String>['她同时发出', '均匀明亮版', '和保留暗部版'], '白昀把两版测试都发过去。', '理解比较证据进入沟通', '用并列结构表达两个方案'),
      _RebuildSpec('复原她承担的风险。', '她选择一个不那么漂亮却更诚实的镜头', <String>['她选择一个', '不那么漂亮', '却更诚实的镜头'], '她为一个不那么漂亮、却更诚实的选择承担被否定的风险。', '识别人物真实代价', '用转折表达审美与诚实的冲突'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('第二版更符合地点关系，所以制片人一定会喜欢。', '第二版更符合地点关系，但白昀仍要承担制片人可能不接受的风险。', <String>['第二版更符合地点关系，但白昀仍要承担制片人可能不接受的风险。','第二版更符合地点关系，所以制片人一定会喜欢。','只要理由正确，任何客户都必须接受。','更诚实的画面自动等于更受欢迎的画面。'], <String>['第二版更符合地点关系，','所以','制片人','一定会喜欢。'], 1, '价值与结果不确定性', '理由充分不代表外部接受必然发生。', '制片人仍要求“再推一点”。', '表达有依据但不确定的结果'),
      _GrammarSpec('白昀没有移动灯，因此她什么也没有改变。', '白昀没有移动灯，却通过延长镜头停留和稳定机位改变了观看方式。', <String>['白昀没有移动灯，却通过延长镜头停留和稳定机位改变了观看方式。','白昀没有移动灯，因此她什么也没有改变。','只要现场不变，作品就不可能变化。','她不加灯，所以只能接受原画面。'], <String>['白昀没有移动灯，','因此','她什么','也没有改变。'], 1, '改变对象转移', '她没有改现场，但改了观看时间和记录方式。', '她改用更长镜头停留和更稳机位。', '识别不改变现场仍可改变作品'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('第二版测试保留殿内暗部，书页只被一束____切开。', '侧光', <String>['侧光','阳光','闪电','路灯'], '第二版测试里书页只被一束侧光切开。', '另一版保留暗部。', '视觉方案特征', '补全构图元素', '从两版比较恢复第二版特征'),
      _ChoiceSpec('白昀没有继续推灯，而是让观众有时间____暗部。', '适应', <String>['适应','删除','忽略','照亮'], '白昀让观众有时间适应暗部。', '她用更长的镜头停留。', '观看方式改变', '补全动作目的', '把时间手段与观看效果连接'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪条证据最能说明白昀开始把“理由”也作为交付内容？', '她把两版测试一起发出并解释第二版为何更接近故事关系', <String>['她把两版测试一起发出并解释第二版为何更接近故事关系','她只发了最亮版本','她让杜衡替她回复','她隐藏了所有差异'], '她同时提交比较与解释。', '她没有只写哪一版“更安全”。', '决策透明度', '识别理由如何进入作品沟通', '从交付方式判断责任成熟度'),
      _ChoiceSpec('为什么“不动灯，多停几秒”是这一层的关键动作？', '它把解决方案从改变遗产现场转向改变观众的观看时间', <String>['它把解决方案从改变遗产现场转向改变观众的观看时间','它证明时间可以替代所有安全措施','它让暗部自动变亮','它取消了地点历史'], '她改用更长镜头停留。', 'Discovery 明确说问题从改变现场转到改变观看方式。', '创作策略迁移', '理解媒介内部调整', '识别被改变的是观看方式而非建筑'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('文化遗产现场的创作底线最接近哪一项？', '可以有多种视觉解法但不能把遗产本体当作无限可调的设备', <String>['可以有多种视觉解法但不能把遗产本体当作无限可调的设备','所有视觉解法必须相同','为了保护必须禁止摄影','只要是艺术创作就可以改变现场'], '创作可多样，遗产本体不是无限可调资源。', 'Discovery 明确指出这一底线。', '遗产创作边界', '概括多解与共同边界', '同时保留创作空间和保护限制'),
      _ChoiceSpec('为什么两版测试比只给一个结果更有决策价值？', '它让画面收益和地点信息损失可以被直接比较', <String>['它让画面收益和地点信息损失可以被直接比较','它保证第二版一定获选','它让历史事实可以投票决定','它避免说明任何理由'], '对照能显露不同方案的收益与代价。', '一版更亮却几乎看不见武英殿。', '方案比较', '用对照证据支持选择', '同时观察增益与信息损失'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('客户要求“再亮一点”，但当前版已能读出关键字并保留地点关系。最佳回应是？', '说明再加亮会得到什么也会失去什么并先尝试不改变现场的观看方案', <String>['说明再加亮会得到什么也会失去什么并先尝试不改变现场的观看方案','直接拒绝且不解释','立刻加灯满足客户','故意把画面变得更暗'], '当前版满足必要信息且保留地点。', '白昀用更长停留回应“再推一点”。', '对外权衡沟通', '把客户要求转成可比较代价', '明确收益损失并寻找低改动方案'),
      _ChoiceSpec('你认为一个方案更诚实，但存在被否定风险。成熟做法是？', '清楚说明依据并由自己承担创作选择的后果', <String>['清楚说明依据并由自己承担创作选择的后果','把决定匿名化避免负责','让保护人员背书后自己不再解释','因为可能被拒就改回最讨喜版本'], '白昀主动承担被否定风险。', '她解释第二版为何更接近故事关系。', '责任与不确定性', '在不确定反馈下承担选择', '有依据地决定并接受外部结果'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原正式镜头的光线边界。', '光只到纸边没有追进后面的暗处', <String>['光只到纸边', '没有追进', '后面的暗处'], '光只到纸边，没有追进后面的暗处。', '识别最终视觉选择', '按边界—否定动作—空间组织句子'),
      _RebuildSpec('复原白昀对杜衡的回答。', '我是在决定哪里该停', <String>['我是在决定', '哪里', '该停'], '“我是在决定哪里该停。”', '识别责任内化', '用“哪里该…”表达自我边界'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('杜衡不再站在灯旁，所以保护已经不重要。', '杜衡不再站在灯旁，是因为白昀已经把保护判断纳入自己的拍摄决定。', <String>['杜衡不再站在灯旁，是因为白昀已经把保护判断纳入自己的拍摄决定。','杜衡不再站在灯旁，所以保护已经不重要。','只要保护人员退后，现场规则就自动取消。','杜衡站到监视器后面表示他不再关心建筑。'], <String>['杜衡不再站在灯旁，','所以','保护','已经不重要。'], 1, '关系变化因果', '人物位置变化表示责任转移，不表示保护条件消失。', '杜衡说“现在不是我在替你踩刹车”。', '正确解释关系变化'),
      _GrammarSpec('画面有阴影，但是信息一定看不清。', '画面有阴影，但书页、手和殿内空间仍然形成清楚层次。', <String>['画面有阴影，但书页、手和殿内空间仍然形成清楚层次。','画面有阴影，但是信息一定看不清。','只要阴影存在，层次就一定消失。','暗部与信息是否清楚完全没有关系。'], <String>['画面有阴影，','但是','信息','一定看不清。'], 2, '绝对结论', 'Story 证据说明暗部存在时必要信息仍可辨认。', '阴影没有吞掉信息，反而分出前后层次。', '用证据限制绝对判断'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('正式拍摄时，白昀听见制片人说“还是有点暗”，她让镜头多停了____。', '三秒', <String>['三秒','三小时','一整天','半个月'], '她让镜头多停了三秒。', '镜头没有通过加灯回应。', '关键时间动作', '补全事件细节', '从正式拍摄恢复具体时长'),
      _ChoiceSpec('杜衡最后从灯旁退到了____后面。', '监视器', <String>['监视器','宫门','书架','屋顶'], '杜衡最后站到监视器后面。', '他的角色从阻止转为共同观看。', '关系空间化', '补全人物位置', '从空间位置理解关系变化'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('哪组证据最完整地证明“责任已经内化”？', '白昀不动灯主动多停三秒并说自己在决定哪里该停', <String>['白昀不动灯主动多停三秒并说自己在决定哪里该停','杜衡曾经按住灯架','制片人仍觉得暗','武英殿有木柱'], '白昀自己执行并解释边界。', '杜衡已经退到监视器后。', '责任内化证据链', '组合行动与对白', '同时要求自主行动和自主解释'),
      _ChoiceSpec('阴影为什么在最终镜头里不是“信息缺陷”？', '因为书页手和空间仍可辨认且阴影建立了前后层次', <String>['因为书页手和空间仍可辨认且阴影建立了前后层次','因为所有暗画面都更有艺术感','因为观众不需要看文字','因为阴影本身就是历史事实'], '阴影没有吞掉信息。', '画面分成前后层次。', '视觉功能证据', '评价暗部的实际作用', '以信息可读性和层次而非偏好判断'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('预防性保护真正成熟的结果是什么？', '参与者能在没有外部阻止时自己识别边界和风险', <String>['参与者能在没有外部阻止时自己识别边界和风险','保护人员永远守在设备旁','所有工作都必须停止','每个决定都只由一个人批准'], '保护判断进入参与者自身决策。', '杜衡退到监视器后而白昀自己设限。', '保护能力内化', '理解制度学习的结果', '从外控转向自我判断'),
      _ChoiceSpec('为什么“多停三秒”可能提高暗部可读性而不改变现场？', '观看时间增加让观众有更多时间适应和读取低亮度信息', <String>['观看时间增加让观众有更多时间适应和读取低亮度信息','三秒会自动增加灯的功率','时间能够改变建筑颜色','停留越久现场风险一定越高'], '观看时间是媒介内部变量。', 'Story 使用镜头停留而非新增灯位。', '观看时间与可读性', '理解时间参数的叙事功能', '把可读性从亮度扩展到观看时长'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('保护人员不在设备旁时，摄影师发现一个更亮的新方案。最成熟的判断是？', '仍按同一套地点任务证据和风险条件自行判断而不是把无人阻止当许可', <String>['仍按同一套地点任务证据和风险条件自行判断而不是把无人阻止当许可','没人阻止就默认可以','先做再等保护人员发现','只看客户是否满意'], '边界不依赖某个人站在哪里。', '白昀已经能自己决定哪里该停。', '规则内化', '在监督缺席时保持判断', '把保护原则从人物权威转为共享条件'),
      _ChoiceSpec('如果暗部仍能传达必要信息而且强化空间层次，应如何处理？', '保留它并记录为什么不再继续加光', <String>['保留它并记录为什么不再继续加光','因为不均匀必须消除','把它说成安全规则而不谈画面','故意继续降低曝光'], '暗部具有信息功能。', '最终镜头用暗部建立层次。', '有依据地停止优化', '判断何时停止继续优化', '当边际收益不足以覆盖代价时停止'),
    ],
  ),
  _LevelSpec(
    rebuilds: <_RebuildSpec>[
      _RebuildSpec('复原白昀最后写下的记录。', '亮到这里就够了', <String>['亮到这里', '就', '够了'], '她把拍摄记录最后一栏写成：“亮到这里，就够了。”', '识别故事最终决策语言', '用“就够了”表达主动停止'),
      _RebuildSpec('复原故事最后的地点判断。', '承载历史的建筑也有自己的限度', <String>['承载历史的建筑', '也有', '自己的限度'], '承载历史的建筑也有自己的限度。', '概括地点必要性的最终认识', '从承载关系推出边界'),
    ],
    grammars: <_GrammarSpec>[
      _GrammarSpec('“亮到这里就够了”是规则，所以所有故宫拍摄都必须一样暗。', '“亮到这里，就够了”是这次具体任务与现场条件下的判断，不是通用照明规则。', <String>['“亮到这里，就够了”是这次具体任务与现场条件下的判断，不是通用照明规则。','“亮到这里就够了”是规则，所以所有故宫拍摄都必须一样暗。','只要在紫禁城，任何镜头都应该采用同样曝光。','白昀的个人选择可以直接替代所有现场规范。'], <String>['“亮到这里就够了”是规则，','所以','所有故宫拍摄','都必须一样暗。'], 1, '具体判断与普遍规则', '单一情境中的选择不能被扩大为所有拍摄的统一标准。', 'Story 明确说她没有把这句话当成保护规定。', '限制结论适用范围'),
      _GrammarSpec('制片人用了这版，因此白昀之前的所有选择都没有代价。', '制片人最终采用这版，也不能反推白昀作决定时不存在被否定的代价。', <String>['制片人最终采用这版，也不能反推白昀作决定时不存在被否定的代价。','制片人用了这版，因此白昀之前的所有选择都没有代价。','结果成功说明所有过程风险都可以忽略。','只要最后被接受，任何决策依据都不重要。'], <String>['制片人用了这版，','因此','白昀之前的所有选择','都没有代价。'], 1, '结果偏差', '最终成功不能抹去决策当时真实存在的不确定性和代价。', 'Lv8 白昀主动承担被否定风险。', '防止以后见之明改写决策'),
    ],
    completions: <_ChoiceSpec>[
      _ChoiceSpec('制片人最终说：“用这版。标题别____太多。”', '解释', <String>['解释','拍摄','保存','照亮'], '制片人最终说：“用这版。标题别解释太多。”', '最终版本得到接受。', '结局对白', '补全结局细节', '从最后交流恢复动词'),
      _ChoiceSpec('工作灯一盏盏熄掉后，白昀终于知道什么时候不再加____。', '光', <String>['光','书','人','门'], '她终于知道什么时候不再加光。', '故事最后以停止加光收束。', 'Memory Anchor 结局', '补全核心意象', '从题目标题与结局恢复对象'),
    ],
    evidence: <_ChoiceSpec>[
      _ChoiceSpec('要证明白昀的变化不是“学会听杜衡的话”，哪组证据最完整？', '杜衡退到监视器后白昀仍自主设限并把理由写进拍摄记录', <String>['杜衡退到监视器后白昀仍自主设限并把理由写进拍摄记录','杜衡最初按住灯架','白昀一直使用反光板','制片人最终接受素材'], '监督减弱后白昀仍自主判断。', '她把“亮到这里，就够了”写进自己的记录。', '人物成长证据链', '区分服从与能力内化', '要求在外部权威退出后仍持续行为'),
      _ChoiceSpec('为什么最后“工作灯熄掉”不是简单的漂亮结尾？', '它呼应整篇关于加光与停止的选择并把主动设限变成可记忆动作', <String>['它呼应整篇关于加光与停止的选择并把主动设限变成可记忆动作','因为黑暗一定代表悲伤','因为故宫闭馆后必须没有任何灯','因为制片人要求关灯'], '工作灯熄灭呼应“何时不再加光”。', '结尾回到整篇核心动作。', 'Memory Anchor 结构', '识别意象与因果收束', '用贯穿动作而非抽象总结形成余韵'),
    ],
    knowledge: <_ChoiceSpec>[
      _ChoiceSpec('为什么这个故事不能原样搬到普通摄影棚？', '因为武英殿同时提供刊书史地点关系和需保护的宫殿建筑本体', <String>['因为武英殿同时提供刊书史地点关系和需保护的宫殿建筑本体','因为普通摄影棚没有 LED','因为摄影棚不能拍书','因为只有紫禁城有截止时间'], '地点同时承担历史发生空间与保护对象。', 'Story 的核心两层冲突都绑定武英殿。', 'Place Necessity', '证明不可替换地点', '删除地点后测试核心因果是否仍成立'),
      _ChoiceSpec('对“武英殿本”的使用，哪种表达最谨慎？', '它指向与武英殿宫廷刊刻传统相关的版本史不能据此把所有清代书都归到这里', <String>['它指向与武英殿宫廷刊刻传统相关的版本史不能据此把所有清代书都归到这里','它等于所有清代出版物','只要在武英殿拍摄的书都叫武英殿本','它只是现代摄影术语'], '版本称呼有具体历史范围。', 'Discovery 用谨慎范围说明武英殿本。', '历史事实边界', '在综合结论中保持史实限定', '防止知识标签过度概括'),
    ],
    decisions: <_ChoiceSpec>[
      _ChoiceSpec('新拍摄任务换到另一个木构宫殿、对象和风险也不同。能否直接复制“亮到这里就够了”的参数？', '不能应重新按地点任务证据和风险条件判断但可以保留这种决策方法', <String>['不能应重新按地点任务证据和风险条件判断但可以保留这种决策方法','能因为这已经是故宫通用规则','能只要建筑是木构就完全相同','不能而且之前学到的方法也全部无效'], '方法可迁移，具体阈值不可机械复制。', 'Memory 强调这不是通用照明标准。', '迁移与边界', '区分可迁移原则和具体答案', '迁移判断框架而非复制参数'),
      _ChoiceSpec('你负责最终审核：一版更亮但地点几乎消失，一版稍暗但书页、建筑与关系都可读。应如何决策？', '按任务目标比较信息完整性现场代价和可读性后写明选择依据', <String>['按任务目标比较信息完整性现场代价和可读性后写明选择依据','永远选择更亮版本','永远选择更暗版本','只看哪版先拍完'], '最终判断需要目标、信息、现场代价和可读性。', 'Story 最终同时保留书页与武英殿。', '综合条件决策', '整合 Lv1-Lv10 判断维度', '不用单一亮度替代多维决策'),
    ],
  ),
];

String _hash(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

String _modeLabel(StoryChallengeMode mode) => switch (mode) {
      StoryChallengeMode.sentenceRebuild => 'Semantic Sentence Rebuild',
      StoryChallengeMode.grammarRepair => 'Grammar Repair',
      StoryChallengeMode.storyCompletion => 'Context Completion',
      StoryChallengeMode.storyEvidence => 'Story Evidence / Understanding',
      StoryChallengeMode.knowledgeReasoning => 'Beijing / Place Knowledge & Spatial Reasoning',
      StoryChallengeMode.scenarioDecision => 'Scenario / Decision',
    };

List<String> _scramble(List<String> chunks, int seed) {
  final values = List<String>.of(chunks);
  if (values.length <= 2) return values.reversed.toList(growable: false);
  final shift = seed % values.length;
  final reversed = values.reversed.toList(growable: false);
  return <String>[...reversed.skip(shift), ...reversed.take(shift)];
}

QuestionDesignSignature _signature({
  required int level,
  required int index,
  required StoryChallengeMode mode,
  required String source,
  required String reasoning,
}) =>
    QuestionDesignSignature(
      journeyId: forbiddenCityStoryTwoJourneyId,
      sessionLevel: level,
      mode: mode,
      sourceParagraphIndex: index ~/ 6,
      sourceSentenceIndex: index,
      sourceHash: _hash(source),
      syntaxPattern: source.contains('，') ? '复句' : '主谓结构',
      operationType: _modeLabel(mode),
      errorFamily: mode == StoryChallengeMode.grammarRepair ? 'authored-grammar' : null,
      gapType: mode == StoryChallengeMode.storyCompletion ? 'context-completion' : null,
      answerShape: mode == StoryChallengeMode.sentenceRebuild ? 'semantic-chunks' : '4-choice',
      distractorStrategy: 'story-specific plausible misconception',
      templateSignature: _hash('$level|${mode.name}|$source|$index'),
      semanticSignature: _hash('$level|${mode.name}|$reasoning|$source'),
    );

List<String> _choiceRationales({
  required List<String> options,
  required String answer,
  required String why,
  required String evidence,
  required String reasoning,
}) =>
    <String>[
      for (final option in options)
        if (option == answer)
          '正确：$why'
        else
          '“$option”没有同时满足“$reasoning”；与本题证据“$evidence”相比，它漏掉或扩大了关键条件。',
    ];

StoryChallengeQuestion _rebuildQuestion(
  int level,
  int index,
  _RebuildSpec spec,
) =>
    StoryChallengeQuestion(
      id: 'story2-lv$level-q${index + 1}-rebuild',
      mode: StoryChallengeMode.sentenceRebuild,
      sourceSentence: spec.evidence,
      prompt: spec.prompt,
      answer: spec.answer,
      options: const <String>[],
      characterTiles: List<String>.unmodifiable(_scramble(spec.chunks, level + index)),
      narrationText: spec.prompt,
      learningObjective: spec.learning,
      knowledgeTarget: '当前 Story 的人物行动与地点关系',
      languageTarget: '按有意义语义块复原自然中文',
      reasoningTarget: spec.reasoning,
      whyCorrect: '所有语义块按当前 Story 的事件关系组成唯一自然顺序。',
      distractorRationales: const <String>[],
      difficulty: 'Lv$level semantic rebuild',
      storyEvidence: spec.evidence,
      knowledgeSource: '当前 Story',
      signature: _signature(level: level, index: index, mode: StoryChallengeMode.sentenceRebuild, source: spec.evidence, reasoning: spec.reasoning),
    );

StoryChallengeQuestion _grammarQuestion(
  int level,
  int index,
  _GrammarSpec spec,
) {
  final rationales = _choiceRationales(
    options: spec.options,
    answer: spec.answer,
    why: spec.rule,
    evidence: spec.evidence,
    reasoning: spec.rule,
  );
  return StoryChallengeQuestion(
    id: 'story2-lv$level-q${index + 1}-grammar',
    mode: StoryChallengeMode.grammarRepair,
    sourceSentence: spec.evidence,
    prompt: spec.prompt,
    answer: spec.answer,
    options: List<String>.unmodifiable(spec.options),
    errorSegments: List<String>.unmodifiable(spec.segments),
    errorSegmentIndex: spec.errorIndex,
    grammarFamily: spec.family,
    grammarWhyWrong: spec.rule,
    grammarRevisionRule: spec.rule,
    grammarOptionExplanations: List<String>.unmodifiable(rationales),
    narrationText: spec.prompt,
    learningObjective: spec.learning,
    knowledgeTarget: '当前 Story 的事实关系',
    languageTarget: spec.family,
    reasoningTarget: spec.rule,
    whyCorrect: spec.rule,
    distractorRationales: List<String>.unmodifiable(rationales),
    difficulty: 'Lv$level grammar repair',
    storyEvidence: spec.evidence,
    knowledgeSource: '当前 Story',
    signature: _signature(level: level, index: index, mode: StoryChallengeMode.grammarRepair, source: spec.prompt, reasoning: spec.rule),
  );
}

StoryChallengeQuestion _choiceQuestion(
  int level,
  int index,
  StoryChallengeMode mode,
  _ChoiceSpec spec,
) {
  final rationales = _choiceRationales(
    options: spec.options,
    answer: spec.answer,
    why: spec.learning,
    evidence: spec.evidence,
    reasoning: spec.reasoning,
  );
  return StoryChallengeQuestion(
    id: 'story2-lv$level-q${index + 1}-${mode.name}',
    mode: mode,
    sourceSentence: spec.source,
    prompt: spec.prompt,
    answer: spec.answer,
    options: List<String>.unmodifiable(spec.options),
    narrationText: spec.prompt,
    learningObjective: spec.learning,
    knowledgeTarget: spec.knowledge,
    languageTarget: mode == StoryChallengeMode.storyCompletion ? '语境补全与自然搭配' : '理解并表达有条件的判断',
    reasoningTarget: spec.reasoning,
    whyCorrect: spec.learning,
    distractorRationales: List<String>.unmodifiable(rationales),
    difficulty: 'Lv$level ${_modeLabel(mode)}',
    storyEvidence: spec.evidence,
    knowledgeSource: spec.sourceLabel,
    signature: _signature(level: level, index: index, mode: mode, source: spec.source, reasoning: spec.reasoning),
  );
}

StoryChallengeSet buildForbiddenCityStoryTwoChallenge({
  required int level,
  required List<String> storyParagraphs,
}) {
  if (level < 1 || level > 10) {
    throw RangeError.range(level, 1, 10, 'level');
  }
  final spec = _levels[level - 1];
  final questions = <StoryChallengeQuestion>[];
  var index = 0;
  for (final item in spec.rebuilds) {
    if (item.chunks.length < 3 || item.chunks.join() != item.answer) {
      throw StateError('Story 2 Lv$level semantic rebuild invalid.');
    }
    questions.add(_rebuildQuestion(level, index++, item));
  }
  for (final item in spec.grammars) {
    if (item.segments.length != 4 || item.segments.join() != item.prompt) {
      throw StateError('Story 2 Lv$level Grammar Step 1 invalid.');
    }
    questions.add(_grammarQuestion(level, index++, item));
  }
  for (final item in spec.completions) {
    questions.add(_choiceQuestion(level, index++, StoryChallengeMode.storyCompletion, item));
  }
  for (final item in spec.evidence) {
    questions.add(_choiceQuestion(level, index++, StoryChallengeMode.storyEvidence, item));
  }
  for (final item in spec.knowledge) {
    questions.add(_choiceQuestion(level, index++, StoryChallengeMode.knowledgeReasoning, item));
  }
  for (final item in spec.decisions) {
    questions.add(_choiceQuestion(level, index++, StoryChallengeMode.scenarioDecision, item));
  }

  if (questions.length != 12) {
    throw StateError('Story 2 Lv$level requires exactly 12 questions.');
  }
  for (final mode in StoryChallengeMode.values) {
    if (questions.where((question) => question.mode == mode).length != 2) {
      throw StateError('Story 2 Lv$level requires exactly 2 ${mode.name}.');
    }
  }

  return StoryChallengeSet(
    journeyId: forbiddenCityStoryTwoJourneyId,
    sessionLevel: level,
    questions: List<StoryChallengeQuestion>.unmodifiable(questions),
  );
}

List<StoryChallengeSet> buildForbiddenCityStoryTwoChallengeMatrix(
  List<List<String>> storyParagraphsByLevel,
) {
  if (storyParagraphsByLevel.length != 10) {
    throw StateError('Story 2 Challenge matrix requires Lv1-Lv10 Story source.');
  }
  return List<StoryChallengeSet>.unmodifiable(<StoryChallengeSet>[
    for (var level = 1; level <= 10; level += 1)
      buildForbiddenCityStoryTwoChallenge(
        level: level,
        storyParagraphs: storyParagraphsByLevel[level - 1],
      ),
  ]);
}
