from pathlib import Path
import re

path = Path('app/lib/data/all_gold_challenge_gold_profiles.dart')
text = path.read_text(encoding='utf-8')


def bounds(journey_id: str) -> tuple[int, int]:
    start_marker = f"  '{journey_id}': GoldChallengeProfile("
    start = text.find(start_marker)
    if start < 0:
        raise SystemExit(f'missing profile {journey_id}')
    matches = list(re.finditer(r"(?m)^  '[^']+': GoldChallengeProfile\(", text))
    following = [m.start() for m in matches if m.start() > start]
    end = min(following) if following else text.find('};', start)
    if end < 0:
        raise SystemExit(f'missing end for {journey_id}')
    return start, end


def replace_by_broken(journey_id: str, broken_segment: str, block: str) -> None:
    global text
    start, end = bounds(journey_id)
    section = text[start:end]
    needle = "brokenSegment: '" + broken_segment.replace("'", "\\'") + "'"
    pos = section.find(needle)
    if pos < 0:
        raise SystemExit(f'{journey_id}: missing broken segment {broken_segment!r}')
    block_start = section.rfind('GoldChallengeGrammarSpec(', 0, pos)
    if block_start < 0:
        raise SystemExit(f'{journey_id}: missing grammar start for {broken_segment!r}')
    next_start = section.find('GoldChallengeGrammarSpec(', pos)
    grammar_end = section.find('\n      ),', pos)
    if grammar_end < 0 or (next_start >= 0 and next_start < grammar_end):
        raise SystemExit(f'{journey_id}: malformed grammar block for {broken_segment!r}')
    grammar_end += len('\n      ),')
    section = section[:block_start] + block.strip() + ',' + section[grammar_end:]
    text = text[:start] + section + text[end:]


# Forbidden City: evidence/route language rather than inherited connector drills.
replace_by_broken('beijing-forbidden-city', '因此所以', r'''GoldChallengeGrammarSpec(
        targetId: 'until-cai',
        prefix: '沈砚原先只想找一条路线，',
        brokenSegment: '到两条线在共同节点相遇，他就才开始',
        suffix: '比较它们之后怎样分开。',
        correctReplacement: '直到两条线在共同节点相遇，他才开始',
        distractors: <String>['等到两条线相遇，他才就开始', '直到两条线相遇，他就开始才', '两条线直到相遇，他开始才'],
        errorType: '直到…才…：时间条件与认知转折',
        whyWrong: '“就才”把两个不同的时间副词叠在一起；这里要表达共同节点出现之后，比较才真正开始。',
        revisionRule: '用“直到A，才B”表达B在A出现之后才发生。',
        memoryTip: '先找改变判断的那个节点，再用“直到…才…”。',
        misconception: '把共同节点出现前后的时间门槛写成“就才”叠加',
      )''')
replace_by_broken('beijing-forbidden-city', '所以', r'''GoldChallengeGrammarSpec(
        targetId: 'different-yet-valid',
        prefix: '两人的行动目的',
        brokenSegment: '尽管不同，所以',
        suffix: '两条路线仍能在同一空间骨架中成立。',
        correctReplacement: '尽管不同，仍然',
        distractors: <String>['因为不同，所以', '不同，于是就', '虽然不同，因此'],
        errorType: '尽管…仍…：差异与共存',
        whyWrong: '行动目的不同并不是路线成立的原因；这里强调的是“存在差异，仍可共存”。',
        revisionRule: '让步关系可以用“尽管A，仍B”保持两个事实同时成立。',
        memoryTip: '路线不同不是因果失败，而是同一空间里的共存。',
        misconception: '把角色目的差异误当成路线成立的直接原因',
      )''')
replace_by_broken('beijing-forbidden-city', '这个', r'''GoldChallengeGrammarSpec(
        targetId: 'redundant-distribution',
        prefix: '沈砚和阿宁',
        brokenSegment: '各自分别沿',
        suffix: '自己的路线继续行动。',
        correctReplacement: '各自沿',
        distractors: <String>['分别各自都沿', '各自分别都沿', '分别各自沿着都'],
        errorType: '副词赘余：“各自”与“分别”重复分配',
        whyWrong: '“各自”和“分别”在这里都表示两人按不同路线行动，叠用会显得重复。',
        revisionRule: '同一层分配关系保留一个清楚的副词。',
        memoryTip: '已经有“各自”，就不必再用“分别”重复一次。',
        misconception: '认为两个分配副词叠加会让两条路线更清楚',
      )''')
replace_by_broken('beijing-forbidden-city', '不是谁的路线更正确就是', r'''GoldChallengeGrammarSpec(
        targetId: 'question-reframing',
        prefix: '到了复合图阶段，沈砚',
        brokenSegment: '不再把问题问成“谁更正确”，而开始问成',
        suffix: '“同一空间怎样容纳不同目的”。',
        correctReplacement: '不再问“谁更正确”，而开始问',
        distractors: <String>['不再问成“谁更正确”，而开始去问成', '没有问“谁更正确”，所以开始问成', '不再把“谁更正确”问，而把开始问'],
        errorType: '动词搭配：“问”与问题内容',
        whyWrong: '“问成”通常表示把话问成某种结果，这里只是把问题焦点从一件事转到另一件事。',
        revisionRule: '直接用“问 + 问题内容”，不要把焦点转换误写成结果补语。',
        memoryTip: '这里改变的是提问内容，不是把一句话“问成”另一种结果。',
        misconception: '把认知焦点的转换误写成“问成”的结果补语',
      )''')

# Summer Palace: light timing / archival traces.
replace_by_broken('beijing-summer-palace', '所以', r'''GoldChallengeGrammarSpec(
        targetId: 'napa-ye',
        prefix: '许澄',
        brokenSegment: '哪怕失去了等了一下午的金光，所以仍',
        suffix: '保留了捡回旧照片的选择。',
        correctReplacement: '哪怕失去了等了一下午的金光，也',
        distractors: <String>['因为失去了金光，也', '哪怕失去了金光，因此', '既然失去了金光，就'],
        errorType: '哪怕…也…：成本与选择并存',
        whyWrong: '“哪怕”先承认拍摄成本，后面要用“也”说明选择仍成立，而不是推出一个因果结果。',
        revisionRule: '“哪怕A，也B”表示即使付出A，B仍成立。',
        memoryTip: '先承认失去金光，再看她仍然做了什么。',
        misconception: '把失去金光的成本误写成捡照片的直接原因',
      )''')
replace_by_broken('beijing-summer-palace', '不是把痕迹全部遮掉就是', r'''GoldChallengeGrammarSpec(
        targetId: 'biqi-geng-important',
        prefix: '对许澄来说，',
        brokenSegment: '比起把旧痕迹全部遮掉，所以更重要的是',
        suffix: '让历史依据与当下观看同时可见。',
        correctReplacement: '比起把旧痕迹全部遮掉，更重要的是',
        distractors: <String>['因为把旧痕迹遮掉，更重要的是', '比起把旧痕迹遮掉，所以要', '与把旧痕迹遮掉，因为更重要'],
        errorType: '比起…更…：比较重心',
        whyWrong: '“比起”已经建立比较基准，后面直接用“更重要”提出评价，不需要再插入因果词。',
        revisionRule: '“比起A，更B”表达比较后的重心转移。',
        memoryTip: '比较结构不是因果结构。',
        misconception: '把作品价值的比较重心误写成原因结果',
      )''')
replace_by_broken('beijing-summer-palace', '就', r'''GoldChallengeGrammarSpec(
        targetId: 'yihou-cai',
        prefix: '许澄',
        brokenSegment: '把来源和旧痕迹看清楚以后就',
        suffix: '能说明为什么保留它们。',
        correctReplacement: '把来源和旧痕迹看清楚以后才',
        distractors: <String>['把来源看清楚以前才', '把来源看清楚以后又就', '把来源看清楚才以后'],
        errorType: '…以后才…：先决理解与后续说明',
        whyWrong: '这里强调先完成来源辨认，之后才具备解释保留痕迹的条件；“就”弱化了这层先决关系。',
        revisionRule: '强调前一步完成后才出现后一步，用“……以后才……”。',
        memoryTip: '先看清依据，才谈为什么保留。',
        misconception: '把需要先完成的来源辨认写成普通紧接结果',
      )''')

# Chengdu: rotating shared-space use rather than generic connector ladders.
replace_by_broken('chengdu-kuanzhai-alley', '因此所以', r'''GoldChallengeGrammarSpec(
        targetId: 'yi-jiu',
        prefix: '门口',
        brokenSegment: '一有人经过，所以竹椅',
        suffix: '要往旁边让开。',
        correctReplacement: '一有人经过，竹椅就',
        distractors: <String>['只要有人经过，竹椅才', '因为有人经过，竹椅一', '一有人经过，因此竹椅才'],
        errorType: '一…就…：触发式动作',
        whyWrong: '这里写的是通行一出现，移椅动作立刻发生；“一……就……”比额外插入“所以”更直接。',
        revisionRule: '即时触发关系可用“一A，就B”。',
        memoryTip: '有人经过，就是这把椅子让路的触发点。',
        misconception: '把即时触发关系写成普通解释性因果句',
      )''')
replace_by_broken('chengdu-kuanzhai-alley', '既服务坐茶，而且又', r'''GoldChallengeGrammarSpec(
        targetId: 'yihuir-yihuir',
        prefix: '这把竹椅',
        brokenSegment: '一会儿服务坐茶，而且一会儿又',
        suffix: '要给经过的人让路。',
        correctReplacement: '一会儿服务坐茶，一会儿',
        distractors: <String>['一会儿服务坐茶，所以一会儿', '既一会儿服务坐茶，又一会儿', '一会儿服务坐茶，而且又一会儿'],
        errorType: '一会儿…一会儿…：轮换用途',
        whyWrong: '两个用途按时间轮换，用成对的“一会儿……一会儿……”即可，不必叠加其他并列词。',
        revisionRule: '表达同一对象在两个状态间轮换，可用“一会儿A，一会儿B”。',
        memoryTip: '这把椅子没有永久用途，而是在两种使用之间切换。',
        misconception: '把时间轮换写成多套并列关联词叠加',
      )''')
replace_by_broken('chengdu-kuanzhai-alley', '从林夏一个人手里转到', r'''GoldChallengeGrammarSpec(
        targetId: 'buzai-zhiyou',
        prefix: '后来，',
        brokenSegment: '移动竹椅的人仍然只有林夏，也包括',
        suffix: '其他使用者。',
        correctReplacement: '移动竹椅的人不再只有林夏，也包括',
        distractors: <String>['移动竹椅的人只有林夏，所以包括', '移动竹椅的人不再林夏，也只有', '移动竹椅的人仍只有林夏，并且包括'],
        errorType: '不再只有…也包括…：责任扩展',
        whyWrong: '“仍然只有林夏”与后面的“也包括其他使用者”相互冲突。',
        revisionRule: '从单一主体扩展到多人时，可用“不再只有A，也包括B”。',
        memoryTip: '责任扩大后，“只有”前必须先被“不再”取消。',
        misconception: '一边说责任仍属一人，一边又把其他人加入主体',
      )''')

# Guangzhou: privacy boundary / consent language.
replace_by_broken('guangzhou-chen-clan-academy', '因此所以', r'''GoldChallengeGrammarSpec(
        targetId: 'yi-bian',
        prefix: '嘉禾往廊柱旁',
        brokenSegment: '一退，因此秀仪便',
        suffix: '停住了拍照动作。',
        correctReplacement: '一退，秀仪便',
        distractors: <String>['退了一步，所以便', '一退，秀仪才所以', '因为一退，秀仪便因此'],
        errorType: '一…便…：动作触发',
        whyWrong: '“一退……便……”已经完整表达动作触发，再加“因此”会重复标记结果。',
        revisionRule: '紧接发生的动作可用“一A，B便……”。',
        memoryTip: '嘉禾退一步，秀仪的动作随即停下。',
        misconception: '在已经完整的动作触发结构中再次加入因果标记',
      )''')
replace_by_broken('guangzhou-chen-clan-academy', '既确认了嘉禾，而且又', r'''GoldChallengeGrammarSpec(
        targetId: 'verb-object-confirm',
        prefix: '秀仪说“她叫刘嘉禾”，',
        brokenSegment: '把嘉禾现在的姓名作了确认',
        suffix: '。',
        correctReplacement: '确认了嘉禾现在使用的姓名',
        distractors: <String>['对嘉禾姓名确认起来了', '把嘉禾姓名确认作为', '确认给嘉禾现在的姓名'],
        errorType: '动宾搭配：“确认”直接带宾语',
        whyWrong: '这里要表达秀仪确认嘉禾现用姓名，直接说“确认了姓名”更自然，“作了确认”把动作写得僵硬。',
        revisionRule: '可直接支配宾语的动词，不必机械改成“作 + 名词”。',
        memoryTip: '谁确认什么：秀仪确认嘉禾现在使用的姓名。',
        misconception: '把直接的关系确认写成生硬的名词化结构',
      )''')
replace_by_broken('guangzhou-chen-clan-academy', '即使没有公开合照，嘉禾但是也', r'''GoldChallengeGrammarSpec(
        targetId: 'bingbu-fangai',
        prefix: '',
        brokenSegment: '没有公开合照，就妨碍嘉禾',
        suffix: '继续和秀仪往下一进院子走。',
        correctReplacement: '没有公开合照，并不妨碍嘉禾',
        distractors: <String>['没有公开合照，因此妨碍嘉禾', '没有公开合照，才妨碍嘉禾', '没有公开合照，却必须妨碍嘉禾'],
        errorType: '并不妨碍：否定错误因果',
        whyWrong: '没有合照并不必然阻断两人继续同行；这里要否定“没有公开证明=关系不能继续”的推论。',
        revisionRule: '否定某条件会阻止后续行动，可用“A并不妨碍B”。',
        memoryTip: '没有公开照片，不等于没有继续相处的空间。',
        misconception: '把缺少公开证明误当成关系继续的障碍',
      )''')
replace_by_broken('guangzhou-chen-clan-academy', '才可以', r'''GoldChallengeGrammarSpec(
        targetId: 'weijing-buneng',
        prefix: '',
        brokenSegment: '嘉禾没有同意，秀仪仍可以',
        suffix: '把她的名字或影像带进公开亲族关系里。',
        correctReplacement: '未经嘉禾同意，秀仪不能',
        distractors: <String>['嘉禾尚未同意，秀仪就应当', '即使嘉禾不同意，秀仪仍要', '没有嘉禾同意，秀仪因此可以'],
        errorType: '未经…不能…：同意作为边界',
        whyWrong: '公开使用嘉禾的名字或影像需要她的同意；原句把缺少同意写成仍可行动，逻辑与语义都相反。',
        revisionRule: '表达权限边界，可用“未经A同意，不能B”。',
        memoryTip: '先问谁有权决定影像进入公开关系。',
        misconception: '把当事人的同意从公开使用的必要边界中移除',
      )''')

# Hangzhou: memory concern and relational response.
replace_by_broken('hangzhou-west-lake', '因此所以', r'''GoldChallengeGrammarSpec(
        targetId: 'zhengyinwei-cai',
        prefix: '',
        brokenSegment: '正因为周绍庭下意识扶住她，所以方毓才',
        suffix: '停住下一题并拿出预约卡。',
        correctReplacement: '正因为周绍庭下意识扶住她，方毓才',
        distractors: <String>['虽然周绍庭扶住她，方毓才', '正因为周绍庭扶住她，因此所以方毓', '周绍庭正因为扶住她，所以才方毓'],
        errorType: '正因为…才…：强调性因果',
        whyWrong: '“正因为”和“才”已经构成强调性因果，不需要再插入“所以”。',
        revisionRule: '“正因为A，B才……”用于突出关键原因。',
        memoryTip: '关键不是景名答对，而是那个下意识动作触发了方毓的改变。',
        misconception: '在强调性因果结构中重复加入普通结果词',
      )''')
replace_by_broken('hangzhou-west-lake', '即使周绍庭答不出景名，但是也', r'''GoldChallengeGrammarSpec(
        targetId: 'budengyu',
        prefix: '',
        brokenSegment: '答不出景名，就等于',
        suffix: '他不再会下意识护住方毓。',
        correctReplacement: '答不出景名，并不等于',
        distractors: <String>['答不出景名，所以一定', '答不出景名，也就证明', '因为答不出景名，就等于'],
        errorType: '并不等于：拆开两种能力',
        whyWrong: '景名回忆与下意识照护不是同一能力，不能用“就等于”把两者直接画上等号。',
        revisionRule: '否定错误等同关系，用“A并不等于B”。',
        memoryTip: '记忆测试结果不能替代对关系动作的观察。',
        misconception: '把景名回忆能力与关系中的照护动作直接等同',
      )''')
replace_by_broken('hangzhou-west-lake', '不如', r'''GoldChallengeGrammarSpec(
        targetId: 'zhuaner',
        prefix: '方毓没有继续追问景名，',
        brokenSegment: '并且又拿出',
        suffix: '预约卡。',
        correctReplacement: '转而拿出',
        distractors: <String>['所以又拿出', '而且再拿出', '同时因此拿出'],
        errorType: '转而：行动方向改变',
        whyWrong: '这里不是简单增加第二个动作，而是从“继续测试”转向“面对检查”。',
        revisionRule: '前一行动停止、后一行动取代它时，可用“转而”。',
        memoryTip: '先问第二个动作是补充，还是替代第一个动作。',
        misconception: '把停止测试后的行动转向误写成普通并列动作',
      )''')
replace_by_broken('hangzhou-west-lake', '是因为', r'''GoldChallengeGrammarSpec(
        targetId: 'yuanyin-zaiyu',
        prefix: '方毓停止测试，',
        brokenSegment: '原因是所以',
        suffix: '她看见周绍庭下意识扶住自己的动作。',
        correctReplacement: '原因在于',
        distractors: <String>['原因因为', '原因所以在', '原因于是'],
        errorType: '原因在于：名词性原因说明',
        whyWrong: '“原因”后直接叠加“是所以”不自然；用“原因在于……”可以清楚引出解释。',
        revisionRule: '名词“原因”后可用“在于”引出具体原因。',
        memoryTip: '“原因在于什么”，比“原因是所以什么”清楚。',
        misconception: '把名词性原因说明和结果关联词混在一起',
      )''')
replace_by_broken('hangzhou-west-lake', '不只是景名是否答对，而是', r'''GoldChallengeGrammarSpec(
        targetId: 'guanjian-buzai-erzai',
        prefix: '两个人最后面对的关键',
        brokenSegment: '不是在景名是否答对，而是在',
        suffix: '如何一起面对记忆变化。',
        correctReplacement: '不在于景名是否答对，而在于',
        distractors: <String>['不在景名是否答对，所以在', '不仅在景名是否答对，而且在', '虽然不在景名是否答对，但是在'],
        errorType: '不在于…而在于…：评价焦点',
        whyWrong: '讨论“关键”时，用“在于”引出评价焦点更自然；“不是在”把位置表达误套到抽象重心上。',
        revisionRule: '抽象评价重心可用“关键不在于A，而在于B”。',
        memoryTip: '这里问的是关键“在于什么”，不是关键“在哪里”。',
        misconception: '把抽象评价焦点误写成空间位置结构',
      )''')

# Kaiping: family-purpose allocation and shared responsibility.
replace_by_broken('jiangmen-kaiping-diaolou', '因此所以', r'''GoldChallengeGrammarSpec(
        targetId: 'zherang',
        prefix: '众楼合建还缺一份投入，',
        brokenSegment: '这个所以让',
        suffix: '梁川重新考虑只建自家独楼的打算。',
        correctReplacement: '这让',
        distractors: <String>['这所以让', '这个因此让所以', '因为这个让'],
        errorType: '这让…：前句事实作为触发原因',
        whyWrong: '“这”已经回指前句“还缺一份投入”，直接用“这让……”承接即可，不需要再叠加结果词。',
        revisionRule: '用“这让……”把上一句事实直接接到人物判断变化。',
        memoryTip: '“这”指的就是众楼还缺投入。',
        misconception: '在已经有回指主语的因果承接中重复加入结果词',
      )''')
replace_by_broken('jiangmen-kaiping-diaolou', '仍', r'''GoldChallengeGrammarSpec(
        targetId: 'bingbu-jiechu',
        prefix: '',
        brokenSegment: '放弃独楼，就解除梁川',
        suffix: '对哥哥写明投入条件的责任。',
        correctReplacement: '放弃独楼，并不解除梁川',
        distractors: <String>['放弃独楼，因此解除梁川', '只要放弃独楼，就解除梁川', '放弃独楼，也就自动解除梁川'],
        errorType: '并不解除：选择变化与责任延续',
        whyWrong: '方案从独楼改为众楼，不等于哥哥写明的投入条件自动消失。',
        revisionRule: '表达“发生A但责任仍存在”，可直接否定“A会解除责任”。',
        memoryTip: '方案变了，责任边界没有自动消失。',
        misconception: '把放弃私家方案误认为自动取消兄弟之间的投入责任',
      )''')
replace_by_broken('jiangmen-kaiping-diaolou', '从“我家的楼”改成', r'''GoldChallengeGrammarSpec(
        targetId: 'gaixiewei',
        prefix: '梁海把那行字',
        brokenSegment: '改写成为到',
        suffix: '“我们家在众楼里的一份”。',
        correctReplacement: '改写为',
        distractors: <String>['改写成到', '改为成为', '改写为了成'],
        errorType: '改写为：文本内容变更',
        whyWrong: '“改写为”已经完整表达文字从旧说法变成新说法，“成为到”叠加了不相容的变化结构。',
        revisionRule: '说明文字、条款、称呼被修改后的内容，可用“改写为……”。',
        memoryTip: '这里改的是信上的一句话，不是物体移动到某处。',
        misconception: '把文字改写误套成方向补语和状态变化的混合结构',
      )''')
replace_by_broken('jiangmen-kaiping-diaolou', '不如', r'''GoldChallengeGrammarSpec(
        targetId: 'meiyou-erzhi',
        prefix: '梁川',
        brokenSegment: '没有完整照搬海外柱廊，但是只',
        suffix: '保留适合众楼共同使用的部分。',
        correctReplacement: '没有完整照搬海外柱廊，而只',
        distractors: <String>['没有完整照搬海外柱廊，所以只', '虽然没有照搬海外柱廊，但是只', '没有完整照搬海外柱廊，因为只'],
        errorType: '而只：否定后的取舍收束',
        whyWrong: '后半句不是与前句对立的意外结果，而是在说明“没有照搬”之后实际保留了什么。',
        revisionRule: '“没有A，而只B”可说明放弃整体、保留部分的取舍。',
        memoryTip: '先否定照搬，再说具体保留。',
        misconception: '把“舍弃整体、保留部分”的取舍关系误写成普通转折',
      )''')
replace_by_broken('jiangmen-kaiping-diaolou', '是因为', r'''GoldChallengeGrammarSpec(
        targetId: 'argument-reallocation',
        prefix: '共同避难功能',
        brokenSegment: '对家庭投入的去向受到重新界定',
        suffix: '。',
        correctReplacement: '重新界定了家庭投入的去向',
        distractors: <String>['被家庭投入的去向重新界定', '对家庭投入去向被重新界定', '受到家庭投入去向重新界定'],
        errorType: '论元关系：谁重新界定谁',
        whyWrong: '这里“共同避难功能”是改变投入去向理解的因素，应作施事方向，而不是写成“对……受到”。',
        revisionRule: '先明确作用方向：功能重新界定投入去向。',
        memoryTip: '画出“共同功能 → 投入去向”的作用箭头。',
        misconception: '把共同避难功能和家庭投入去向的作用方向颠倒',
      )''')

# Longmen: evidence-source and evidentiary limits.
replace_by_broken('luoyang-longmen-grottoes', '因此', r'''GoldChallengeGrammarSpec(
        targetId: 'no-source-no-use',
        prefix: '这层模型',
        brokenSegment: '说不出具体来源，因为就',
        suffix: '不能把它当作有据复原。',
        correctReplacement: '说不出具体来源，就',
        distractors: <String>['说不出具体来源，因为所以', '说不出具体来源，虽然就', '说不出具体来源，而且才'],
        errorType: '…就不能…：缺少依据的直接限制',
        whyWrong: '“因为就”混合了两个框架；这里直接表达“来源说不清 → 不能当作有据复原”。',
        revisionRule: '条件不足带来直接限制时，可用“A，就不能B”。',
        memoryTip: '先问来源能不能说清，再决定能不能使用。',
        misconception: '把直接的证据使用限制写成两套因果框架叠加',
      )''')
replace_by_broken('luoyang-longmen-grottoes', '但', r'''GoldChallengeGrammarSpec(
        targetId: 'guran-reng',
        prefix: '',
        brokenSegment: '删掉模型当然让转场不顺，所以林砚仍',
        suffix: '决定不用它。',
        correctReplacement: '删掉模型固然让转场不顺，林砚仍',
        distractors: <String>['删掉模型既然让转场不顺，林砚所以', '删掉模型因为让转场不顺，林砚仍', '删掉模型固然让转场不顺，所以林砚'],
        errorType: '固然…仍…：承认成本后维持判断',
        whyWrong: '这里先承认删除模型会损失转场效果，再说明证据标准仍不改变；“固然……仍……”更符合这层关系。',
        revisionRule: '先承认一个真实成本，再维持原判断，可用“固然A，仍B”。',
        memoryTip: '转场损失是真的，但不能因此改变证据标准。',
        misconception: '把承认制作成本误写成推出继续使用模型的因果理由',
      )''')
replace_by_broken('luoyang-longmen-grottoes', '之所以不能凭风格补满，是因为', r'''GoldChallengeGrammarSpec(
        targetId: 'zhineng-buneng',
        prefix: '历史照片和题记',
        brokenSegment: '足以只支持有限判断，而且能',
        suffix: '为凭风格补满提供依据。',
        correctReplacement: '只能支持有限判断，不能',
        distractors: <String>['只足以支持有限判断，所以能', '只能支持有限判断，而且足以', '既只支持有限判断，又能完全'],
        errorType: '只能…不能…：证据边界',
        whyWrong: '“足以只支持有限判断”语序别扭，而且后半句又把有限证据说成足以支持完整补满，逻辑冲突。',
        revisionRule: '用“只能A，不能B”清楚划定证据支持范围。',
        memoryTip: '证据能支持到哪里，也同时说明不能支持到哪里。',
        misconception: '一边承认证据有限，一边又把它扩大成完整复原依据',
      )''')

# Nanjing: safety review / reduced lighting responsibility.
replace_by_broken('nanjing-qinhuai-river', '因此', r'''GoldChallengeGrammarSpec(
        targetId: 'yiner',
        prefix: '剩余时间不足以重新确认改线，',
        brokenSegment: '因为魏舟因而所以',
        suffix: '没有采用最快方案。',
        correctReplacement: '魏舟因而',
        distractors: <String>['魏舟因为所以', '所以魏舟因而', '魏舟虽然因而'],
        errorType: '因而：书面因果承接',
        whyWrong: '前句已经给出原因，“因而”即可承接结果；“因为…因而所以”把原因和多个结果标记堆在一起。',
        revisionRule: '前句原因明确时，可用“因而”简洁引出结果。',
        memoryTip: '剩余时间不足，所以结果只需要一个承接词。',
        misconception: '把已经明确的安全原因重复标记成多层因果连接',
      )''')
replace_by_broken('nanjing-qinhuai-river', '既保留通行照明，又', r'''GoldChallengeGrammarSpec(
        targetId: 'tongshi',
        prefix: '缩减方案',
        brokenSegment: '保留通行照明，同时又同时',
        suffix: '主动放弃一段装饰灯。',
        correctReplacement: '保留通行照明，同时',
        distractors: <String>['保留通行照明，所以同时', '既保留通行照明，同时又', '保留通行照明，而且同时又'],
        errorType: '同时：两个并行结果',
        whyWrong: '“同时”已经说明两个结果并行，再重复“又同时”会造成赘余。',
        revisionRule: '两个并行结果可用一次“同时”连接。',
        memoryTip: '缩减不是只做一件事：保留通行，也放弃装饰。',
        misconception: '为了强调并行结果而重复叠加同义连接词',
      )''')
replace_by_broken('nanjing-qinhuai-river', '仍能', r'''GoldChallengeGrammarSpec(
        targetId: 'sui-reng',
        prefix: '古桥旁',
        brokenSegment: '虽有一段装饰灯保持黑暗，所以主要通行路线仍',
        suffix: '能按确认过的安全条件开放。',
        correctReplacement: '虽有一段装饰灯保持黑暗，主要通行路线仍',
        distractors: <String>['因为有一段灯保持黑暗，主要路线仍', '虽有一段灯保持黑暗，因此主要路线才', '有一段灯保持黑暗，所以主要路线仍'],
        errorType: '虽…仍…：缩减与开放并存',
        whyWrong: '暗一段并不是安全开放的原因；这里是承认装饰不完整，同时说明主要通行仍可开放。',
        revisionRule: '“虽A，仍B”表达A存在但B仍成立。',
        memoryTip: '不全亮与可安全通行可以同时成立。',
        misconception: '把装饰灯保持黑暗误当成主要路线开放的原因',
      )''')
replace_by_broken('nanjing-qinhuai-river', '既没有接管控制台，也没有替魏舟重写记录', r'''GoldChallengeGrammarSpec(
        targetId: 'mei-ye-mei',
        prefix: '周工回来后，',
        brokenSegment: '没有接管控制台，而且也没有',
        suffix: '替魏舟重写记录。',
        correctReplacement: '没有接管控制台，也没有',
        distractors: <String>['没有接管控制台，所以也没有', '既没有接管控制台，而且也没有', '没有接管控制台，但是也没有'],
        errorType: '没有…也没有…：并列否定',
        whyWrong: '两个动作都没有发生，直接用“没有A，也没有B”最自然，不需要“而且也”叠加。',
        revisionRule: '两个并列否定可用“没有A，也没有B”。',
        memoryTip: '周工既不接管，也不代写，两个否定是同一层。',
        misconception: '把简单的双重否定写成多重并列关联词',
      )''')

# Shanghai: continuity across two banks, paper record and digital systems.
replace_by_broken('shanghai-bund', '于是', r'''GoldChallengeGrammarSpec(
        targetId: 'yihou-bian',
        prefix: '轮渡离开西岸后，两岸同时进入视野，',
        brokenSegment: '因此林岸所以便',
        suffix: '开始怀疑“过去/未来”的二分。',
        correctReplacement: '林岸便',
        distractors: <String>['因此林岸所以', '林岸因为便', '所以林岸因此便'],
        errorType: '便：前情触发后的判断变化',
        whyWrong: '前句已经交代触发场景，用“便”承接人物判断变化即可，不需要再堆“因此/所以”。',
        revisionRule: '叙事中前一情境触发后一动作，可用“便”自然承接。',
        memoryTip: '两岸同时可见，判断随之改变。',
        misconception: '把叙事触发关系写成多层说明性因果标记',
      )''')
replace_by_broken('shanghai-bund', '既记录货物与责任，又', r'''GoldChallengeGrammarSpec(
        targetId: 'buzhi-hai',
        prefix: '旧提单',
        brokenSegment: '不只记录货物与责任，而且还又',
        suffix: '让林岸想到家里的日常。',
        correctReplacement: '不只记录货物与责任，还',
        distractors: <String>['不只记录货物与责任，而且又还', '既不只记录货物与责任，还又', '不只记录货物与责任，所以还'],
        errorType: '不只…还…：信息层次扩展',
        whyWrong: '“不只……还……”已经完整表达从贸易记录扩展到家庭记忆，再加“而且又”会重复。',
        revisionRule: '从一个信息层扩展到另一个层次，可用“不只A，还B”。',
        memoryTip: '这张纸承载的不止一层信息。',
        misconception: '在信息层次扩展中重复叠加多个并列标记',
      )''')
replace_by_broken('shanghai-bund', '这种同时可见的变化', r'''GoldChallengeGrammarSpec(
        targetId: 'nominal-reference',
        prefix: '林岸看见外滩退远、陆家嘴靠近。',
        brokenSegment: '两岸这样一起看见的这个变化',
        suffix: '让他重新理解两岸关系。',
        correctReplacement: '两岸同时可见的变化',
        distractors: <String>['两岸这个看见的变化', '这个两岸同时的看见变化', '两岸同时可见这个地变化'],
        errorType: '名词短语回指：把整体现象说清楚',
        whyWrong: '“这样一起看见的这个变化”口语化且指向松散，无法清楚概括前句的两岸同时进入视野。',
        revisionRule: '回指复杂现象时，用明确的名词短语概括它。',
        memoryTip: '把前句压缩成“什么变化”，而不是只说“这个”。',
        misconception: '用松散代词和口语成分回指复杂的两岸视觉关系',
      )''')
replace_by_broken('shanghai-bund', '不只是一张纸，而是', r'''GoldChallengeGrammarSpec(
        targetId: 'buzhi-haibaokuo',
        prefix: '这张旧提单承载的',
        brokenSegment: '不止货运记录，就是',
        suffix: '一段仍能进入新生活的家庭来路。',
        correctReplacement: '不止是货运记录，还包括',
        distractors: <String>['不是货运记录，就是', '不止货运记录，所以包括', '既是货运记录，就是还有'],
        errorType: '不止是…还包括…：意义扩展',
        whyWrong: '这里不是在两个对象中二选一，而是在纸面记录之外继续增加它承载的家庭意义。',
        revisionRule: '从表层意义扩展到更多内容，可用“不止是A，还包括B”。',
        memoryTip: '旧提单不是被否定，而是被读出更多层次。',
        misconception: '把意义扩展误解成在纸面记录和家庭来路之间二选一',
      )''')

# Suzhou: visibility, waiting and mature care.
replace_by_broken('suzhou-humble-administrators-garden', '于是', r'''GoldChallengeGrammarSpec(
        targetId: 'zhecai',
        prefix: '程朗在下一处停下等她，',
        brokenSegment: '所以这才因此让',
        suffix: '外婆开始相信短暂看不见不等于走散。',
        correctReplacement: '这才让',
        distractors: <String>['所以才因此让', '这因此所以才让', '因为这才所以让'],
        errorType: '这才让…：前情改变判断',
        whyWrong: '“这才让”已经把前一句动作作为改变判断的关键触发，不需要再叠加多个因果词。',
        revisionRule: '强调前情终于带来认知变化，可用“这才让……”。',
        memoryTip: '真正改变外婆判断的是程朗在下一处等她。',
        misconception: '在“这才让”已经完整的认知转折中重复叠加因果词',
      )''')
replace_by_broken('suzhou-humble-administrators-garden', '既走在前面，又', r'''GoldChallengeGrammarSpec(
        targetId: 'que-still-waits',
        prefix: '程朗',
        brokenSegment: '走在前面，所以却',
        suffix: '会在下一处停下回头。',
        correctReplacement: '走在前面，却',
        distractors: <String>['走在前面，所以', '走在前面，因为却', '走在前面，因此但是'],
        errorType: '却：表面分离与实际等待的对照',
        whyWrong: '走在前面并不会因果推出等待；这里要表达看似拉开距离，却仍维持约定。',
        revisionRule: '前后事实形成反预期对照时，可用“却”。',
        memoryTip: '走在前面和会等待并不冲突。',
        misconception: '把保持距离与继续等待误写成直接因果关系',
      )''')
replace_by_broken('suzhou-humble-administrators-garden', '不再是一直喊回程朗，而是', r'''GoldChallengeGrammarSpec(
        targetId: 'allow-er-buzai',
        prefix: '陈玉兰开始',
        brokenSegment: '允许程朗走在前面，所以不再',
        suffix: '每次一看不见就喊他回来。',
        correctReplacement: '允许程朗走在前面，而不再',
        distractors: <String>['允许程朗走在前面，因为不再', '允许程朗走在前面，所以才不再', '允许程朗走在前面，并且所以不再'],
        errorType: '而不再：新做法替代旧做法',
        whyWrong: '这里说明照护方式从“每次喊回”转到“允许走前面”，是替代关系，不是简单因果结论。',
        revisionRule: '新行为取代旧行为时，可用“A，而不再B”。',
        memoryTip: '重点是照护方式被替换，而不是谁导致谁。',
        misconception: '把照护方式的替代变化误写成普通因果结果',
      )''')
replace_by_broken('suzhou-humble-administrators-garden', '不如', r'''GoldChallengeGrammarSpec(
        targetId: 'bi-geng-important',
        prefix: '后来，陈玉兰觉得',
        brokenSegment: '“会等待、会回头”更重要比',
        suffix: '“一直看得见”。',
        correctReplacement: '“会等待、会回头”比',
        distractors: <String>['“会等待、会回头”更比', '比“会等待、会回头”更加', '“会等待、会回头”所以比'],
        errorType: 'A比B更…：比较语序',
        whyWrong: '“更重要比”把程度副词放到了比较标记前；中文应先说“A比B”，再说“更重要”。',
        revisionRule: '比较结构按“A比B + 更/更重要”组织。',
        memoryTip: '先摆出比较双方，再说明哪一项更重要。',
        misconception: '把“更”提前到“比”前，打乱比较结构',
      )''')
replace_by_broken('suzhou-humble-administrators-garden', '是因为', r'''GoldChallengeGrammarSpec(
        targetId: 'qianti-shi',
        prefix: '短暂遮挡能成为这次练习的一部分，',
        brokenSegment: '前提因为',
        suffix: '程朗会在下一处重新出现并等待。',
        correctReplacement: '前提是',
        distractors: <String>['前提所以', '前提在因为', '因为前提是所以'],
        errorType: '前提是：条件说明',
        whyWrong: '“前提”是名词，后面用“是”引出具体条件；“前提因为”把名词说明和原因连词混在一起。',
        revisionRule: '说明某判断成立所需条件，可用“前提是……”。',
        memoryTip: '短暂看不见能成为练习，是有条件的：他会重新出现并等待。',
        misconception: '把成立条件“前提”误写成普通原因连接词',
      )''')

# Xi'an: route boundary and belonging.
replace_by_broken('xian-city-wall', '所以', r'''GoldChallengeGrammarSpec(
        targetId: 'bian-result',
        prefix: '周遥没有按停跑表，',
        brokenSegment: '因此路线所以便',
        suffix: '从城墙继续伸向新家。',
        correctReplacement: '路线便',
        distractors: <String>['因此路线所以', '路线因为便', '所以路线因此便'],
        errorType: '便：动作后的直接结果',
        whyWrong: '不按停跑表之后，轨迹继续增长是紧接结果，用“便”承接即可，不需要多层因果词。',
        revisionRule: '叙事中的直接后续结果可用“便”。',
        memoryTip: '跑表没停，轨迹便继续增长。',
        misconception: '把紧接发生的结果写成多重因果连接',
      )''')
replace_by_broken('xian-city-wall', '但', r'''GoldChallengeGrammarSpec(
        targetId: 'sui-que',
        prefix: '城墙',
        brokenSegment: '虽然清楚围出内外，所以生活路线却',
        suffix: '不断穿过城门。',
        correctReplacement: '虽清楚围出内外，生活路线却',
        distractors: <String>['因为围出内外，生活路线却', '虽围出内外，所以生活路线', '围出内外，因此生活路线却'],
        errorType: '虽…却…：物理边界与生活路线对照',
        whyWrong: '城墙围出内外并不是生活路线穿越它的原因；两者是空间边界与实际生活之间的对照。',
        revisionRule: '“虽A，却B”表达A存在但B呈现反预期事实。',
        memoryTip: '墙是闭合的，生活路线却可以穿过门。',
        misconception: '把物理边界和生活穿行的对照误写成因果关系',
      )''')
replace_by_broken('xian-city-wall', '这个数字', r'''GoldChallengeGrammarSpec(
        targetId: 'quoted-nominal-reference',
        prefix: '跑表显示一整圈已经完成。',
        brokenSegment: '这个东西',
        suffix: '原本被周遥当成告别的终点。',
        correctReplacement: '“一整圈”这个数字',
        distractors: <String>['这个一整圈东西', '那一个它', '这些一整圈的这个'],
        errorType: '明确回指：抽象数字信息',
        whyWrong: '前句核心是跑表上的“一整圈”完成信息，“这个东西”太模糊，无法说明回指对象。',
        revisionRule: '回指抽象信息时，把关键名词直接说出来。',
        memoryTip: '这里指的是“一整圈”这个数字，不是城墙本身。',
        misconception: '用模糊的“这个东西”代替关键的跑表终点信息',
      )''')
replace_by_broken('xian-city-wall', '既保存历史边界，又', r'''GoldChallengeGrammarSpec(
        targetId: 'yimian-yimian',
        prefix: '城墙',
        brokenSegment: '一面保存历史边界，而且一面又',
        suffix: '与今天的交通和生活并存。',
        correctReplacement: '一面保存历史边界，一面',
        distractors: <String>['一面保存历史边界，所以一面', '既一面保存历史边界，又一面', '一面保存历史边界，而且又一面'],
        errorType: '一面…一面…：双重城市角色',
        whyWrong: '这里把城墙的两种并存角色并列呈现，“一面……一面……”已经完整，不需要再叠加其他并列词。',
        revisionRule: '同一主体同时呈现两个方面，可用“一面A，一面B”。',
        memoryTip: '历史边界与今天生活是同一城墙的两个面向。',
        misconception: '在双重角色结构中重复堆叠多套并列关联词',
      )''')
replace_by_broken('xian-city-wall', '才', r'''GoldChallengeGrammarSpec(
        targetId: 'bixu-xian',
        prefix: '要理解路线为什么能越过城墙，周遥',
        brokenSegment: '必须就先',
        suffix: '把住址变化和归属感分开。',
        correctReplacement: '必须先',
        distractors: <String>['就必须先才', '必须所以先', '先必须就'],
        errorType: '必须先：认知步骤的必要顺序',
        whyWrong: '“必须”已经表达必要性，“先”表达步骤顺序，再加“就”会让结构混乱。',
        revisionRule: '必要步骤用“必须先 + 动作”。',
        memoryTip: '先把住址和归属拆开，才能理解轨迹为何继续。',
        misconception: '把必要性和先后顺序写成多个副词无序叠加',
      )''')

path.write_text(text, encoding='utf-8')
print('closed human de-skinned single-level grammar skeleton collisions')
