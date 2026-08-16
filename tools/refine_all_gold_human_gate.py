from pathlib import Path
import re

profile_path = Path('app/lib/data/all_gold_challenge_gold_profiles.dart')
text = profile_path.read_text(encoding='utf-8')


def replace_grammar(journey_id: str, target_id: str, block: str) -> None:
    global text
    start_marker = f"  '{journey_id}': GoldChallengeProfile("
    start = text.find(start_marker)
    if start < 0:
        raise SystemExit(f'missing profile {journey_id}')
    next_start = text.find("  '", start + len(start_marker))
    end = next_start if next_start >= 0 else text.find("};", start)
    section = text[start:end]
    pattern = re.compile(
        r"GoldChallengeGrammarSpec\(\s*targetId: '" + re.escape(target_id) + r"'.*?\n\s*\),",
        re.S,
    )
    matches = list(pattern.finditer(section))
    if len(matches) != 1:
        raise SystemExit(
            f'{journey_id}/{target_id}: expected 1 grammar block, found {len(matches)}'
        )
    section = pattern.sub(block.strip() + ',', section, count=1)
    text = text[:start] + section + text[end:]


replace_grammar(
    'beijing-forbidden-city',
    'subject-completeness',
    r'''GoldChallengeGrammarSpec(
      targetId: 'subject-completeness',
      prefix: '两张路线图叠在一起后，',
      brokenSegment: '使共同节点更清楚',
      suffix: '。',
      correctReplacement: '共同节点变得更清楚',
      distractors: <String>['让共同节点清楚了被看见', '共同节点使得更清楚', '因此使共同节点更清楚'],
      errorType: '成分残缺：使令结构缺少主句主语',
      whyWrong: '“两张路线图叠在一起后”只是背景，直接接“使……”会让主句没有自然主语。',
      revisionRule: '让“共同节点”直接作主语，再用“变得”说明比较结果。',
      memoryTip: '先找主句是谁，再决定要不要用“使”。',
      misconception: '把结果变化一律写成“使……”而忽略主句主语',
    )''',
)
replace_grammar(
    'beijing-forbidden-city',
    'argument-relation',
    r'''GoldChallengeGrammarSpec(
      targetId: 'role-route-causality',
      prefix: '不同角色的行动目的',
      brokenSegment: '对路线的形成受到影响',
      suffix: '。',
      correctReplacement: '会影响路线的形成',
      distractors: <String>['会被路线的形成影响', '对路线的形成会受到', '让路线的形成被目的影响着'],
      errorType: '作用关系：影响者与受影响对象',
      whyWrong: '行动目的是作用来源，路线形成是被影响的结果，原句把主动与被动结构混在一起。',
      revisionRule: '明确“谁影响谁”，再选择主动“影响……”或被动“受到……影响”。',
      memoryTip: '先画出“行动目的 → 路线形成”。',
      misconception: '把影响来源与承受对象的位置写反',
    )''',
)

replace_grammar(
    'beijing-summer-palace',
    'scope',
    r'''GoldChallengeGrammarSpec(
      targetId: 'necessary-condition',
      prefix: '只有把来源和旧痕迹看清楚，许澄',
      brokenSegment: '就',
      suffix: '能说明为什么保留它们。',
      correctReplacement: '才',
      distractors: <String>['也', '还', '因此'],
      errorType: '必要条件：只有…才…',
      whyWrong: '“只有”提出必要条件，后半句应用“才”说明条件满足后才成立的结果。',
      revisionRule: '必要条件用“只有……才……”，不要写成一般充分条件“只要……就……”。',
      memoryTip: '看到“只有”，先检查后半句有没有“才”。',
      misconception: '把必要条件误写成“就”式充分条件',
    )''',
)

replace_grammar(
    'chengdu-kuanzhai-alley',
    'location-word-order',
    r'''GoldChallengeGrammarSpec(
      targetId: 'threshold-word-order',
      prefix: '林夏',
      brokenSegment: '先门口把竹椅',
      suffix: '挪开。',
      correctReplacement: '先把门口的竹椅',
      distractors: <String>['把先门口的竹椅', '先把竹椅的门口', '门口先把的竹椅'],
      errorType: '把字句语序与地点定语',
      whyWrong: '“门口的”修饰竹椅，“先”修饰挪开动作，原句把地点、把字结构和顺序副词混在一起。',
      revisionRule: '按“先 + 把 + 地点定语 + 宾语 + 动作”组织。',
      memoryTip: '先说“哪把椅子”，再说“先做什么”。',
      misconception: '把地点定语拆散并插进把字句',
    )''',
)
replace_grammar(
    'chengdu-kuanzhai-alley',
    'de-di-de',
    r'''GoldChallengeGrammarSpec(
      targetId: 'service-action-adverb',
      prefix: '端茶的同事',
      brokenSegment: '快速的',
      suffix: '从门槛经过。',
      correctReplacement: '快速地',
      distractors: <String>['快速得', '很快的', '快速地去'],
      errorType: '的/地/得：方式状语',
      whyWrong: '“快速”修饰“经过”这个动作，应使用“地”。',
      revisionRule: '修饰动作方式用“地”；“的”通常连接定语与名词。',
      memoryTip: '问“怎样经过？”答案是“快速地”。',
      misconception: '把修饰动作的“地”写成定语标记“的”',
    )''',
)
replace_grammar(
    'chengdu-kuanzhai-alley',
    'time-structure',
    r'''GoldChallengeGrammarSpec(
      targetId: 'handoff-time-condition',
      prefix: '有人经过时，竹椅',
      brokenSegment: '随着就往旁边移',
      suffix: '，给通行留出位置。',
      correctReplacement: '就往旁边移',
      distractors: <String>['才往旁边移', '随着往旁边就移', '就随着往旁边移'],
      errorType: '时间条件：“…时…就…”',
      whyWrong: '“有人经过时”已经建立时间条件，不需要再叠加“随着”。',
      revisionRule: '具体事件条件用“……时，就……”；“随着”更适合持续变化过程。',
      memoryTip: '先判断是一次条件，还是持续变化。',
      misconception: '把“随着”泛化到已经由“……时”表达的条件句',
    )''',
)
replace_grammar(
    'chengdu-kuanzhai-alley',
    'concession',
    r'''GoldChallengeGrammarSpec(
      targetId: 'handoff-condition',
      prefix: '只要有人要从门槛经过，竹椅',
      brokenSegment: '才',
      suffix: '往旁边让开。',
      correctReplacement: '就',
      distractors: <String>['却', '仍', '才会'],
      errorType: '充分条件：只要…就…',
      whyWrong: '这里表达可重复执行的充分条件，应使用“只要……就……”。',
      revisionRule: '“只要”说明条件一出现就触发动作；“只有……才……”表达必要条件。',
      memoryTip: '分清“只要”与“只有”。',
      misconception: '把充分条件与必要条件混淆',
    )''',
)
replace_grammar(
    'chengdu-kuanzhai-alley',
    'reference',
    r'''GoldChallengeGrammarSpec(
      targetId: 'responsibility-transfer',
      prefix: '移动竹椅的责任',
      brokenSegment: '从林夏一个人变成到',
      suffix: '其他使用者手里。',
      correctReplacement: '从林夏一个人手里转到',
      distractors: <String>['由林夏一个人转到从', '从林夏一个人手里变成于', '在林夏一个人手里转为到'],
      errorType: '从…转到…：责任转移',
      whyWrong: '表达责任从一方转到另一方时，“从……转到……”需要保持起点和终点结构完整。',
      revisionRule: '用“从A手里转到B手里”明确责任转移。',
      memoryTip: '先找起点A，再找终点B。',
      misconception: '把“从/到/变成”三种结构杂糅',
    )''',
)
replace_grammar(
    'chengdu-kuanzhai-alley',
    'not-but',
    r'''GoldChallengeGrammarSpec(
      targetId: 'rather-than-fixed-layout',
      prefix: '与其',
      brokenSegment: '给竹椅找一个永远正确的位置，所以不如',
      suffix: '让它在坐茶和通行之间按需要移动。',
      correctReplacement: '给竹椅找一个永远正确的位置，不如',
      distractors: <String>['给竹椅找一个永远正确的位置，但是', '给竹椅找一个永远正确的位置，所以', '给竹椅找一个永远正确的位置，而且'],
      errorType: '与其…不如…：方案比较',
      whyWrong: '句子比较固定布局与临时交接两种方案，应使用完整的“与其……不如……”。',
      revisionRule: '比较两个方案并倾向后者，用“与其A，不如B”。',
      memoryTip: 'A是被放下的方案，B是更合适的方案。',
      misconception: '把方案比较误写成普通因果关系',
    )''',
)
replace_grammar(
    'chengdu-kuanzhai-alley',
    'argument-relation',
    r'''GoldChallengeGrammarSpec(
      targetId: 'shared-use-reason',
      prefix: '院落入口之所以需要不断交接，',
      brokenSegment: '是所以',
      suffix: '同一处空间要同时服务停留、送茶和通行。',
      correctReplacement: '是因为',
      distractors: <String>['因此因为', '虽然是因为', '之所以'],
      errorType: '之所以…是因为…：原因解释',
      whyWrong: '前半句提出需要解释的结果，后半句给出多用途空间这一原因，应使用“是因为”。',
      revisionRule: '“之所以A，是因为B”用于解释A为何发生。',
      memoryTip: '先说要解释的现象，再给出原因。',
      misconception: '把解释结构与结果词“所以”叠在一起',
    )''',
)

replace_grammar(
    'guangzhou-chen-clan-academy',
    'concession',
    r'''GoldChallengeGrammarSpec(
      targetId: 'relationship-even-without-proof',
      prefix: '即使没有公开合照，嘉禾',
      brokenSegment: '但是也',
      suffix: '可以继续和秀仪往下一进院子走。',
      correctReplacement: '也',
      distractors: <String>['所以才', '但是却', '因此就'],
      errorType: '即使…也…：让步条件',
      whyWrong: '“即使”已经引出让步条件，后半句用“也”承接即可，不再叠加“但是”。',
      revisionRule: '“即使A，也B”表达A成立仍不改变B。',
      memoryTip: '看到“即使”，优先检查“也”。',
      misconception: '把两套让步/转折连接词叠加',
    )''',
)
replace_grammar(
    'guangzhou-chen-clan-academy',
    'reference',
    r'''GoldChallengeGrammarSpec(
      targetId: 'image-passive-purpose',
      prefix: '嘉禾的影像',
      brokenSegment: '被秀仪向亲族证明关系',
      suffix: '。',
      correctReplacement: '不该被秀仪拿来向亲族证明关系',
      distractors: <String>['不该被秀仪给亲族受到证明', '不该让亲族被秀仪证明影像', '不该被关系向亲族拿来证明'],
      errorType: '被字句与用途结构',
      whyWrong: '“影像”是被使用的对象，需要“被…拿来…”说明用途；原句缺少能支配“证明关系”的动作。',
      revisionRule: '“A被B拿来做C”要把受事、施事和用途说完整。',
      memoryTip: '先问什么被使用，再问被谁拿来做什么。',
      misconception: '被字句中缺少连接受事与用途的动作',
    )''',
)
replace_grammar(
    'guangzhou-chen-clan-academy',
    'not-but',
    r'''GoldChallengeGrammarSpec(
      targetId: 'rather-lose-proof-than-boundary',
      prefix: '秀仪宁可',
      brokenSegment: '不留下合照，也要不尊重嘉禾的边界',
      suffix: '。',
      correctReplacement: '不留下合照，也不越过嘉禾的边界',
      distractors: <String>['不留下合照，所以不越过嘉禾的边界', '没有留下合照，也要越过嘉禾的边界', '不留下合照，但是也越过嘉禾的边界'],
      errorType: '宁可…也不…：取舍关系',
      whyWrong: '句子表达愿意承受“没有合照”的成本，也不做越过边界的事，应使用“宁可……也不……”。',
      revisionRule: '愿意承受A来避免B，用“宁可A，也不B”。',
      memoryTip: '先找愿意承受的成本，再找拒绝跨过的边界。',
      misconception: '把取舍关系写成“也要”导致意义反转',
    )''',
)
replace_grammar(
    'guangzhou-chen-clan-academy',
    'argument-relation',
    r'''GoldChallengeGrammarSpec(
      targetId: 'consent-necessary-condition',
      prefix: '只有嘉禾愿意，秀仪',
      brokenSegment: '就可以',
      suffix: '把她的名字或影像带进公开亲族关系里。',
      correctReplacement: '才可以',
      distractors: <String>['也可以', '因此可以', '仍可以'],
      errorType: '必要条件：只有…才…',
      whyWrong: '嘉禾的同意是必要条件，“只有”应与“才”呼应。',
      revisionRule: '必要条件用“只有A，才B”。',
      memoryTip: '“只有”不是“只要”。',
      misconception: '把必要条件弱化成一般结果关系',
    )''',
)

replace_grammar(
    'hangzhou-west-lake',
    'concession',
    r'''GoldChallengeGrammarSpec(
      targetId: 'memory-even-if',
      prefix: '即使周绍庭答不出景名，',
      brokenSegment: '但是也',
      suffix: '不能据此否定他下意识护住方毓的动作。',
      correctReplacement: '也',
      distractors: <String>['所以才', '但是却', '因此就'],
      errorType: '即使…也…：让步判断',
      whyWrong: '景名回答与身体照护形成让步关系，“即使”后直接用“也”承接。',
      revisionRule: '“即使A，也B”表示A不改变B。',
      memoryTip: '把语言记忆和身体反应分成两个判断维度。',
      misconception: '叠加“即使/但是”两套连接方式',
    )''',
)
replace_grammar(
    'hangzhou-west-lake',
    'reference',
    r'''GoldChallengeGrammarSpec(
      targetId: 'rather-than-testing',
      prefix: '与其继续追问景名，方毓',
      brokenSegment: '所以不如',
      suffix: '把预约卡拿出来。',
      correctReplacement: '不如',
      distractors: <String>['但是', '所以', '而且'],
      errorType: '与其…不如…：行动选择',
      whyWrong: '前句已经用“与其”提出被放下的方案，后面应直接接“不如”。',
      revisionRule: '在两个行动方案中倾向后者，用“与其A，不如B”。',
      memoryTip: 'A是继续测试，B是公开面对。',
      misconception: '把方案比较误写成因果连接',
    )''',
)
replace_grammar(
    'hangzhou-west-lake',
    'not-but',
    r'''GoldChallengeGrammarSpec(
      targetId: 'why-testing-stopped',
      prefix: '方毓之所以停止测试，',
      brokenSegment: '是所以',
      suffix: '她看见了周绍庭下意识扶住自己的动作。',
      correctReplacement: '是因为',
      distractors: <String>['因此因为', '虽然因为', '之所以'],
      errorType: '之所以…是因为…：原因解释',
      whyWrong: '后半句解释她为什么停止测试，应使用“是因为”完成原因说明。',
      revisionRule: '“之所以A，是因为B”把结果与原因明确分开。',
      memoryTip: '先问“为什么停”，再给原因。',
      misconception: '把解释结构与“所以”重复叠加',
    )''',
)
replace_grammar(
    'hangzhou-west-lake',
    'argument-relation',
    r'''GoldChallengeGrammarSpec(
      targetId: 'not-score-but-facing-change',
      prefix: '两个人最后面对的',
      brokenSegment: '不仅是景名是否答对，所以是',
      suffix: '如何一起面对记忆变化。',
      correctReplacement: '不只是景名是否答对，而是',
      distractors: <String>['不是景名是否答对，所以', '虽然是景名是否答对，但是', '既是景名是否答对，又是'],
      errorType: '不只是…而是…：评价重心',
      whyWrong: '句子要把评价重心从答题结果移到共同面对变化，不能用“所以”制造假因果。',
      revisionRule: '从表层标准转向更核心标准，可用“不只是A，而是B”。',
      memoryTip: 'A是测试分数，B是关系中的行动。',
      misconception: '把评价重心转换误写成因果关系',
    )''',
)

replace_grammar(
    'jiangmen-kaiping-diaolou',
    'concession',
    r'''GoldChallengeGrammarSpec(
      targetId: 'cost-with-responsibility',
      prefix: '即使家里放弃独楼，梁川',
      brokenSegment: '但是仍',
      suffix: '要对哥哥写明的投入条件负责。',
      correctReplacement: '仍',
      distractors: <String>['所以才', '但是却', '因此就'],
      errorType: '即使…仍…：让步与责任',
      whyWrong: '放弃独楼并没有取消对投入条件的责任，“即使”后用“仍”承接即可。',
      revisionRule: '“即使A，仍B”表达A发生也不改变B。',
      memoryTip: '成本变化不等于责任消失。',
      misconception: '叠加“即使/但是”或误把成本当成责任取消',
    )''',
)
replace_grammar(
    'jiangmen-kaiping-diaolou',
    'reference',
    r'''GoldChallengeGrammarSpec(
      targetId: 'ownership-wording-shift',
      prefix: '梁海把那行字',
      brokenSegment: '从“我家的楼”变成到',
      suffix: '“我们家在众楼里的一份”。',
      correctReplacement: '从“我家的楼”改成',
      distractors: <String>['由“我家的楼”改成从', '从“我家的楼”转为到', '把“我家的楼”从改成'],
      errorType: '从A改成B：表述转换',
      whyWrong: '“从……改成……”已经完整表示文字从A变为B，不应叠加“变成到”。',
      revisionRule: '变化表达选择一套完整框架：“从A改成B”或“由A变为B”。',
      memoryTip: '起点A和终点B只配一套变化结构。',
      misconception: '把“从/变成/到”多个变化框架杂糅',
    )''',
)
replace_grammar(
    'jiangmen-kaiping-diaolou',
    'not-but',
    r'''GoldChallengeGrammarSpec(
      targetId: 'rather-than-copying',
      prefix: '与其完整照搬海外柱廊，梁川',
      brokenSegment: '所以不如',
      suffix: '保留适合众楼共同使用的部分。',
      correctReplacement: '不如',
      distractors: <String>['但是', '所以', '而且'],
      errorType: '与其…不如…：形式取舍',
      whyWrong: '句子比较“完整照搬”与“选择性保留”两种方案，应用“与其……不如……”。',
      revisionRule: '比较两个方案并选择后者，用“与其A，不如B”。',
      memoryTip: 'A是整套复制，B是按本地用途选择。',
      misconception: '把形式取舍误写成普通因果',
    )''',
)
replace_grammar(
    'jiangmen-kaiping-diaolou',
    'argument-relation',
    r'''GoldChallengeGrammarSpec(
      targetId: 'communal-function-reason',
      prefix: '梁川之所以最终加入众楼合建，',
      brokenSegment: '是所以',
      suffix: '共同避难功能重新界定了家庭投入的去向。',
      correctReplacement: '是因为',
      distractors: <String>['因此因为', '虽然因为', '之所以'],
      errorType: '之所以…是因为…：功能解释',
      whyWrong: '后半句解释梁川为何改变建造选择，应使用“是因为”。',
      revisionRule: '“之所以A，是因为B”明确选择背后的原因。',
      memoryTip: '先说选择，再说改变选择的功能条件。',
      misconception: '把原因解释结构与结果词混用',
    )''',
)

replace_grammar(
    'nanjing-qinhuai-river',
    'de-di-de',
    r'''GoldChallengeGrammarSpec(
      targetId: 'inspection-action-adverb',
      prefix: '魏舟',
      brokenSegment: '快速的检查',
      suffix: '故障灯组。',
      correctReplacement: '快速地检查',
      distractors: <String>['快速得检查', '很快的检查', '快速检查得'],
      errorType: '的/地/得：方式状语',
      whyWrong: '“快速”修饰“检查”这个动作，应使用“地”。',
      revisionRule: '修饰动作方式用“地”。',
      memoryTip: '问“怎样检查”。',
      misconception: '把方式状语写成定语或程度补语',
    )''',
)
replace_grammar(
    'nanjing-qinhuai-river',
    'concession',
    r'''GoldChallengeGrammarSpec(
      targetId: 'dark-segment-even-if',
      prefix: '即使古桥旁有一段装饰灯保持黑暗，主要通行路线',
      brokenSegment: '但是也能',
      suffix: '按确认过的安全条件开放。',
      correctReplacement: '仍能',
      distractors: <String>['所以才', '但是却能', '因此就能'],
      errorType: '即使…仍…：让步结果',
      whyWrong: '“即使”已经建立让步，后面用“仍”说明安全开放不受装饰缺口改变。',
      revisionRule: '“即使A，仍B”表达A存在但B仍成立。',
      memoryTip: '装饰缺口与通行安全是两个维度。',
      misconception: '叠加“即使/但是”或把局部缺口当成整体失败',
    )''',
)
replace_grammar(
    'nanjing-qinhuai-river',
    'reference',
    r'''GoldChallengeGrammarSpec(
      targetId: 'double-negative-responsibility',
      prefix: '周工回来后，',
      brokenSegment: '既没有接管控制台，而且也没有替魏舟重写记录',
      suffix: '。',
      correctReplacement: '既没有接管控制台，也没有替魏舟重写记录',
      distractors: <String>['不仅没有接管控制台，但是没有替魏舟重写记录', '既没有接管控制台，所以没有替魏舟重写记录', '没有接管控制台，而且既没有替魏舟重写记录'],
      errorType: '既没有…也没有…：并列否定',
      whyWrong: '两个并列的否定动作应保持“既没有……也没有……”结构对称。',
      revisionRule: '并列否定两项行为，用“既没有A，也没有B”。',
      memoryTip: '两个“没有”要放在同一平行结构里。',
      misconception: '在并列否定中混入另一套关联词',
    )''',
)
replace_grammar(
    'nanjing-qinhuai-river',
    'not-but',
    r'''GoldChallengeGrammarSpec(
      targetId: 'rather-dark-than-unverified',
      prefix: '魏舟宁可',
      brokenSegment: '保留一段黑暗，也要采用未确认改线',
      suffix: '。',
      correctReplacement: '保留一段黑暗，也不采用未确认改线',
      distractors: <String>['保留一段黑暗，所以不采用未确认改线', '不保留一段黑暗，也不采用未确认改线', '保留一段黑暗，但是采用未确认改线'],
      errorType: '宁可…也不…：风险取舍',
      whyWrong: '故事表达愿意承受视觉缺口，也不承担未经确认改线的风险。',
      revisionRule: '愿意承受A来避免B，用“宁可A，也不B”。',
      memoryTip: 'A是可接受成本，B是被拒绝风险。',
      misconception: '把风险取舍写成“也要”导致意义反转',
    )''',
)
replace_grammar(
    'nanjing-qinhuai-river',
    'argument-relation',
    r'''GoldChallengeGrammarSpec(
      targetId: 'verification-necessary-condition',
      prefix: '只有完成必要确认和安全复核，临时改线',
      brokenSegment: '就能',
      suffix: '进入实际照明方案。',
      correctReplacement: '才能',
      distractors: <String>['也能', '因此能', '仍能'],
      errorType: '必要条件：只有…才…',
      whyWrong: '完成确认和复核是必要条件，“只有”应与“才”呼应。',
      revisionRule: '必要条件用“只有A，才B”。',
      memoryTip: '“只有”后检查“才”。',
      misconception: '把必要条件误写成“就”式充分条件',
    )''',
)

replace_grammar(
    'shanghai-bund',
    'argument-relation',
    r'''GoldChallengeGrammarSpec(
      targetId: 'carrier-transformation',
      prefix: '承载贸易关系的工具',
      brokenSegment: '由纸面单据变成到',
      suffix: '数字系统。',
      correctReplacement: '由纸面单据转为',
      distractors: <String>['从纸面单据由转为', '由纸面单据转到为', '把纸面单据由变成'],
      errorType: '由A转为B：变化表达',
      whyWrong: '“由……转为……”已经完整表示载体变化，不应把“变成”和“到”叠加进去。',
      revisionRule: '变化表达选择一套完整结构：“由A转为B”或“从A变成B”。',
      memoryTip: '先确定起点A、终点B，再选一套变化框架。',
      misconception: '把多套变化结构杂糅',
    )''',
)

replace_grammar(
    'suzhou-humble-administrators-garden',
    'word-order',
    r'''GoldChallengeGrammarSpec(
      targetId: 'walking-position-order',
      prefix: '程朗',
      brokenSegment: '走慢慢地在前面，',
      suffix: '再转过长廊。',
      correctReplacement: '慢慢地走在前面，',
      distractors: <String>['慢慢的走在前面，', '在前面地慢慢走，', '慢慢得走前面，'],
      errorType: '方式状语与处所位置语序',
      whyWrong: '“慢慢地”修饰“走”，“在前面”说明位置，原句把两个成分顺序打乱。',
      revisionRule: '方式状语贴近动作，再用处所成分说明位置。',
      memoryTip: '先读“怎样走”，再读“走在哪里”。',
      misconception: '把方式状语和处所成分交叉排列',
    )''',
)
replace_grammar(
    'suzhou-humble-administrators-garden',
    'reference',
    r'''GoldChallengeGrammarSpec(
      targetId: 'care-method-shift',
      prefix: '陈玉兰的照护方式',
      brokenSegment: '不再一直喊回程朗，所以是',
      suffix: '允许他走在前面并在下一处等待。',
      correctReplacement: '不再是一直喊回程朗，而是',
      distractors: <String>['不是一直喊回程朗，所以', '不仅一直喊回程朗，而且', '虽然不再喊回程朗，但是'],
      errorType: '不再是…而是…：行为转变',
      whyWrong: '句子要对比旧照护方式和新照护方式，应使用“不再是……而是……”。',
      revisionRule: '表达旧方式被新方式替代，用“不再是A，而是B”。',
      memoryTip: 'A是持续叫回，B是允许走前并约定等待。',
      misconception: '把行为转变误写成因果关系',
    )''',
)
replace_grammar(
    'suzhou-humble-administrators-garden',
    'not-but',
    r'''GoldChallengeGrammarSpec(
      targetId: 'rather-than-constant-visibility',
      prefix: '与其把“看得见”当成唯一安全标准，陈玉兰',
      brokenSegment: '所以不如',
      suffix: '把“会等待、会回头”当成新的约定。',
      correctReplacement: '不如',
      distractors: <String>['但是', '所以', '而且'],
      errorType: '与其…不如…：照护标准比较',
      whyWrong: '句子比较持续可见与相互等待两种照护标准，应用“与其……不如……”。',
      revisionRule: '比较两个方案并选择后者，用“与其A，不如B”。',
      memoryTip: 'A是持续看见，B是可验证的等待与回头。',
      misconception: '把方案比较误写成普通因果',
    )''',
)
replace_grammar(
    'suzhou-humble-administrators-garden',
    'argument-relation',
    r'''GoldChallengeGrammarSpec(
      targetId: 'occlusion-practice-reason',
      prefix: '园林中的短暂遮挡之所以能成为这次练习的一部分，',
      brokenSegment: '是所以',
      suffix: '程朗会在下一处重新出现并等待。',
      correctReplacement: '是因为',
      distractors: <String>['因此因为', '虽然因为', '之所以'],
      errorType: '之所以…是因为…：空间因果解释',
      whyWrong: '后半句解释遮挡为什么可承受，应使用“是因为”完成原因说明。',
      revisionRule: '“之所以A，是因为B”明确空间条件与人物行为的关系。',
      memoryTip: '先问遮挡为何没有变成走散，再给行为原因。',
      misconception: '把解释结构与“所以”重复叠加',
    )''',
)

replace_grammar(
    'xian-city-wall',
    'subject-position',
    r'''GoldChallengeGrammarSpec(
      targetId: 'family-move-word-order',
      prefix: '这个周末，',
      brokenSegment: '周遥要搬家全家',
      suffix: '到城外的新家。',
      correctReplacement: '周遥全家要搬',
      distractors: <String>['全家周遥要搬', '周遥要全家搬', '周遥全家搬要'],
      errorType: '主语与能愿动词语序',
      whyWrong: '“周遥全家”应整体作主语，“要搬”构成谓语，不能把“全家”插进“搬家”内部。',
      revisionRule: '先确定完整主语，再放“要/想/会”等能愿成分。',
      memoryTip: '谁要搬？周遥全家。',
      misconception: '把主语拆开并插入谓语',
    )''',
)
replace_grammar(
    'xian-city-wall',
    'result-complement',
    r'''GoldChallengeGrammarSpec(
      targetId: 'lap-result-complement',
      prefix: '他想',
      brokenSegment: '跑完得',
      suffix: '一整圈。',
      correctReplacement: '跑完',
      distractors: <String>['跑得完了', '跑完成地', '跑着完'],
      errorType: '结果补语：动词+完+宾语',
      whyWrong: '“完”已经是结果补语，表示动作完成，后面直接接宾语即可。',
      revisionRule: '“跑完一圈”是“动词+完+宾语”，不要在“完”后再加“得”。',
      memoryTip: '完成某个数量单位：做完/看完/跑完 + 宾语。',
      misconception: '把程度补语“得”误塞进结果补语结构',
    )''',
)

profile_path.write_text(text, encoding='utf-8')
print('refined Gold grammar human gate profiles')

widget_path = Path('app/lib/widgets/journey_challenge_panel.dart')
widget = widget_path.read_text(encoding='utf-8')
old = "    final pattern = RegExp(r'[^。！？!?]+[。！？!?]?');"
new = "    final pattern = RegExp(r'[^。！？!?]+[。！？!?]?[”’\\\"」』）》】]*');"
if widget.count(old) != 1:
    raise SystemExit(f'sentence extractor anchor expected 1, found {widget.count(old)}')
widget = widget.replace(old, new, 1)
widget_path.write_text(widget, encoding='utf-8')
print('refined sentence extraction to keep closing quotation marks attached')
