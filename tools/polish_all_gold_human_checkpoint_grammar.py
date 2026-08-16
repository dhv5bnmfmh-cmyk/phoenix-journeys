from pathlib import Path
import re

path = Path('app/lib/data/all_gold_challenge_gold_profiles.dart')
text = path.read_text(encoding='utf-8')


def bounds(journey_id: str) -> tuple[int, int]:
    marker = f"  '{journey_id}': GoldChallengeProfile("
    start = text.find(marker)
    if start < 0:
        raise SystemExit(f'missing {journey_id}')
    profiles = list(re.finditer(r"(?m)^  '[^']+': GoldChallengeProfile\(", text))
    following = [m.start() for m in profiles if m.start() > start]
    end = min(following) if following else text.find('};', start)
    return start, end


def replace_level(journey_id: str, level: int, block: str) -> None:
    global text
    s, e = bounds(journey_id)
    section = text[s:e]
    starts = [m.start() for m in re.finditer(r'GoldChallengeGrammarSpec\(', section)]
    if len(starts) != 10:
        raise SystemExit(f'{journey_id}: expected 10 grammar blocks, found {len(starts)}')
    gs = starts[level - 1]
    ge = section.find('\n      ),', gs)
    if ge < 0:
        raise SystemExit(f'{journey_id} Lv{level}: missing grammar end')
    ge += len('\n      ),')
    section = section[:gs] + block.strip() + ',' + section[ge:]
    text = text[:s] + section + text[e:]


def replace_distractors(journey_id: str, level: int, values: list[str]) -> None:
    global text
    s, e = bounds(journey_id)
    section = text[s:e]
    starts = [m.start() for m in re.finditer(r'GoldChallengeGrammarSpec\(', section)]
    gs = starts[level - 1]
    ge = section.find('\n      ),', gs)
    block = section[gs:ge]
    correct_match = re.search(r"correctReplacement: '((?:\\'|[^'])*)'", block)
    if not correct_match:
        raise SystemExit(f'{journey_id} Lv{level}: no correct replacement')
    correct = correct_match.group(1).replace("\\'", "'")
    cleaned = []
    for value in values:
        if not value or value == correct or value in cleaned:
            continue
        cleaned.append(value)
    if len(cleaned) != 3:
        raise SystemExit(f'{journey_id} Lv{level}: expected 3 unique wrong options, got {cleaned}')
    def q(v: str) -> str:
        return "'" + v.replace('\\', '\\\\').replace("'", "\\'") + "'"
    repl = 'distractors: <String>[' + ', '.join(q(v) for v in cleaned) + '],'
    pattern = re.compile(r'distractors: <String>\[.*?\],', re.S)
    if len(pattern.findall(block)) != 1:
        raise SystemExit(f'{journey_id} Lv{level}: distractor block mismatch')
    block = pattern.sub(repl, block, count=1)
    section = section[:gs] + block + section[ge:]
    text = text[:s] + section + text[e:]


# Rewrite the remaining human-checkpoint items whose old broken sentence could
# still be read as acceptable Chinese or whose target was not structurally
# decisive enough for a Gold grammarRepair.
replace_level('beijing-summer-palace', 1, r'''GoldChallengeGrammarSpec(
        targetId: 'time-frame-zai',
        prefix: '许澄专门',
        brokenSegment: '冬至前在',
        suffix: '十七孔桥西北侧等光。',
        correctReplacement: '在冬至前',
        distractors: <String>['冬至前在', '在冬至以前前', '在冬至的前'],
        errorType: '“在 + 时间”框架的语序',
        whyWrong: '时间介词“在”应放在时间词“冬至前”之前；“冬至前在”把介词留在了时间短语后面。',
        revisionRule: '时间框架按“在 + 时间 + 动作”组织。',
        memoryTip: '先说“在什么时候”，再进入地点和动作。',
        misconception: '把时间介词“在”错放到时间短语之后',
      )''')
replace_level('guangzhou-chen-clan-academy', 10, r'''GoldChallengeGrammarSpec(
        targetId: 'modal-boundary-buneng',
        prefix: '未经嘉禾同意，秀仪',
        brokenSegment: '不能可以',
        suffix: '把她的名字或影像带进公开亲族关系里。',
        correctReplacement: '不能',
        distractors: <String>['不能可以', '不可以能', '不能够可以'],
        errorType: '否定能愿动词不可重复叠加',
        whyWrong: '“不能”和“可以”表达相反的许可判断，不能在同一谓语位置直接叠在一起。',
        revisionRule: '表达权限边界时选一个明确的能愿动词：这里用“不能”。',
        memoryTip: '未经当事人同意，权限表达要单一而明确。',
        misconception: '把“不能”和“可以”两个相反的许可词叠在同一位置',
      )''')
replace_level('hangzhou-west-lake', 1, r'''GoldChallengeGrammarSpec(
        targetId: 'aspect-location-order',
        prefix: '方毓',
        brokenSegment: '一直把预约卡藏着在包里',
        suffix: '，没有拿出来。',
        correctReplacement: '一直把预约卡藏在包里',
        distractors: <String>['一直把预约卡藏着在包里', '一直把预约卡藏在着包里', '一直把预约卡在包里藏着了'],
        errorType: '处所补语与“着”的位置',
        whyWrong: '“藏在包里”已经完整说明存放位置；把“着”插在“藏”和“在包里”之间会破坏处所结构。',
        revisionRule: '“动词 + 在 + 处所”先保持完整，再判断是否真的需要体标记。',
        memoryTip: '先读完整的“藏在包里”。',
        misconception: '把体标记“着”插进“动词 + 在 + 处所”的固定结构',
      )''')
replace_level('hangzhou-west-lake', 5, r'''GoldChallengeGrammarSpec(
        targetId: 'yi-bian-trigger',
        prefix: '',
        brokenSegment: '方毓一看见周绍庭下意识扶住她，就便',
        suffix: '停住下一题并拿出预约卡。',
        correctReplacement: '方毓一看见周绍庭下意识扶住她，便',
        distractors: <String>['方毓一看见周绍庭下意识扶住她，就便', '方毓一看见周绍庭下意识扶住她，才便', '方毓一看见周绍庭下意识扶住她，便就'],
        errorType: '“一…便…”触发结构中的副词赘余',
        whyWrong: '“一看见……便……”已经完整表达动作一出现，后续反应随即发生；“就便”重复标记即时结果。',
        revisionRule: '使用“一A，便B”时，不再在“便”前后叠加同层结果副词。',
        memoryTip: '扶手肘一出现，方毓便停止出题。',
        misconception: '在已经完整的即时触发结构中重复叠加“就/便”',
      )''')
replace_level('hangzhou-west-lake', 10, r'''GoldChallengeGrammarSpec(
        targetId: 'focus-zaiyu',
        prefix: '两个人最后面对的关键',
        brokenSegment: '不在景名是否答对，而在如何一起面对记忆变化',
        suffix: '。',
        correctReplacement: '不在于景名是否答对，而在于如何一起面对记忆变化',
        distractors: <String>['不在景名是否答对，而在如何一起面对记忆变化', '不是于景名是否答对，而是在于如何一起面对记忆变化', '不在于景名是否答对，而是在如何一起面对记忆变化'],
        errorType: '抽象评价焦点需要“在于”引出内容',
        whyWrong: '“关键”讨论的是评价焦点，不是空间位置；两个分句都应使用“在于”引出具体内容。',
        revisionRule: '抽象重心用“关键不在于A，而在于B”。',
        memoryTip: '问“关键在于什么”，不是“关键在哪里”。',
        misconception: '把抽象评价中的“在于”误当成普通处所介词“在”',
      )''')
replace_level('nanjing-qinhuai-river', 1, r'''GoldChallengeGrammarSpec(
        targetId: 'modal-before-sequence',
        prefix: '距离亮灯只剩七分钟，魏舟',
        brokenSegment: '先必须把安全条件判断清楚',
        suffix: '。',
        correctReplacement: '必须先把安全条件判断清楚',
        distractors: <String>['先必须把安全条件判断清楚', '必须把先安全条件判断清楚', '必须先安全条件把判断清楚'],
        errorType: '能愿动词与顺序副词的语序',
        whyWrong: '“必须”先说明必要性，“先”再说明动作次序，因此应说“必须先……”。',
        revisionRule: '能愿动词通常放在表示动作顺序的“先”之前。',
        memoryTip: '先判断什么必须做，再说它是第几步。',
        misconception: '把必要性“必须”和步骤“先”的语序颠倒',
      )''')
replace_level('nanjing-qinhuai-river', 5, r'''GoldChallengeGrammarSpec(
        targetId: 'modal-choice-redundancy',
        prefix: '来不及重新确认改线，魏舟',
        brokenSegment: '只得只好放弃',
        suffix: '最快方案。',
        correctReplacement: '只得放弃',
        distractors: <String>['只得只好放弃', '只好只得放弃', '只得不得不放弃'],
        errorType: '“只得/只好/不得不”同层情态不可叠加',
        whyWrong: '“只得”“只好”“不得不”都表达受条件限制后的唯一选择，在同一谓语前叠用会重复。',
        revisionRule: '同一层的被迫选择保留一个情态表达。',
        memoryTip: '时间不够，魏舟“只得放弃”最快方案。',
        misconception: '为了强调无奈而把多个同义情态词重复堆叠',
      )''')
replace_level('shanghai-bund', 1, r'''GoldChallengeGrammarSpec(
        targetId: 'time-place-order',
        prefix: '林岸',
        brokenSegment: '从小外滩在',
        suffix: '接触家里的货运单据。',
        correctReplacement: '从小在外滩',
        distractors: <String>['从小外滩在', '在从小外滩', '从小于外滩'],
        errorType: '时间副词与处所介词短语语序',
        whyWrong: '“从小”先交代长期时间背景，“在外滩”再交代处所；“外滩在”不能这样放在动作前。',
        revisionRule: '长期时间背景后接“在 + 地点”，再进入动作。',
        memoryTip: '从小，在哪里，做什么。',
        misconception: '把地点名和处所介词“在”的顺序颠倒',
      )''')
replace_level('shanghai-bund', 5, r'''GoldChallengeGrammarSpec(
        targetId: 'aspect-after-kaishi',
        prefix: '轮渡离开西岸、两岸同时进入视野以后，林岸',
        brokenSegment: '便开始了去怀疑',
        suffix: '“过去/未来”的二分。',
        correctReplacement: '便开始怀疑',
        distractors: <String>['便开始了去怀疑', '便开始着怀疑', '便开始怀疑了着'],
        errorType: '“开始 + 动词”后不机械叠加体标记',
        whyWrong: '“开始”后可直接接动作“怀疑”；“开始了去/开始着”把体标记和目的结构机械套在一起。',
        revisionRule: '表示某动作开始时，用“开始 + 动词/动词短语”。',
        memoryTip: '两岸同时进入视野后，他“开始怀疑”原来的二分。',
        misconception: '在“开始 + 动词”结构中机械加入“了/着/去”',
      )''')
replace_level('xian-city-wall', 5, r'''GoldChallengeGrammarSpec(
        targetId: 'equivalence-redundancy',
        prefix: '周遥后来明白，搬出城墙',
        brokenSegment: '并不等于就是',
        suffix: '离开自己的旧生活。',
        correctReplacement: '并不等于',
        distractors: <String>['并不等于就是', '并不就是等于', '并不等于是'],
        errorType: '“等于”和判断词“是”不可重复套用',
        whyWrong: '“等于”本身已经表达等同判断，再加“就是/是”会重复同一个判断结构。',
        revisionRule: '否定错误等同时，直接用“A并不等于B”。',
        memoryTip: '搬出城墙并不等于离开旧生活。',
        misconception: '把“等于”和“是”两个等同判断结构重复叠加',
      )''')

# Human-checkpoint option polish for every non-Datong Gold Lv1/Lv5/Lv10.
# Each list contains the actual broken form plus two plausible, diagnosable
# learner near-misses. These strings are checked against the current correct
# replacement before writing.
D = {
('beijing-forbidden-city', 1): ['把两条路线都清楚的', '把两条路线都清楚得', '把两条路线清楚地都'],
('beijing-forbidden-city', 5): ['到两条线在共同节点相遇，他就才开始', '直到两条线在共同节点相遇，他就开始', '两条线在共同节点相遇以后，他才就开始'],
('beijing-forbidden-city', 10): ['取决到', '取决在', '被取决于'],
('beijing-summer-palace', 1): ['冬至前在', '在冬至以前前', '在冬至的前'],
('beijing-summer-palace', 5): ['因为', '但是', '尽管'],
('beijing-summer-palace', 10): ['先把来源和旧痕迹看清楚以后，就能才', '把来源看清楚，才可以能', '先把来源看清楚，就才可以'],
('chengdu-kuanzhai-alley', 1): ['先门口把竹椅', '把门口的竹椅先', '先把竹椅的门口'],
('chengdu-kuanzhai-alley', 5): ['一会儿服务坐茶，而且一会儿又', '一会儿服务坐茶，所以一会儿', '一会儿服务坐茶，但是一会儿'],
('chengdu-kuanzhai-alley', 10): ['是所以', '所以是因为', '是因为所以'],
('guangzhou-chen-clan-academy', 1): ['手机慢慢地举起', '慢慢的举起手机', '慢慢得举起手机'],
('guangzhou-chen-clan-academy', 5): ['所以', '因为', '既然'],
('guangzhou-chen-clan-academy', 10): ['不能可以', '不可以能', '不能够可以'],
('hangzhou-west-lake', 1): ['一直把预约卡藏着在包里', '一直把预约卡藏在着包里', '一直把预约卡在包里藏着了'],
('hangzhou-west-lake', 5): ['方毓一看见周绍庭下意识扶住她，就便', '方毓一看见周绍庭下意识扶住她，才便', '方毓一看见周绍庭下意识扶住她，便就'],
('hangzhou-west-lake', 10): ['不在景名是否答对，而在如何一起面对记忆变化', '不是于景名是否答对，而是在于如何一起面对记忆变化', '不在于景名是否答对，而是在如何一起面对记忆变化'],
('jiangmen-kaiping-diaolou', 1): ['寄回从海外一份', '从海外一份寄回', '从海外寄了一份回'],
('jiangmen-kaiping-diaolou', 5): ['这个所以让', '这所以让', '因为这让'],
('jiangmen-kaiping-diaolou', 10): ['围绕到', '围绕在', '围绕着到'],
('luoyang-longmen-grottoes', 1): ['先自己按想象', '先自己的想象按', '先按自己想象的'],
('luoyang-longmen-grottoes', 5): ['所以', '因为', '因此'],
('luoyang-longmen-grottoes', 10): ['足以只支持有限判断，而且能', '只能支持有限判断，却能', '只支持有限判断，所以足以'],
('nanjing-qinhuai-river', 1): ['先必须把安全条件判断清楚', '必须把先安全条件判断清楚', '必须先安全条件把判断清楚'],
('nanjing-qinhuai-river', 5): ['只得只好放弃', '只好只得放弃', '只得不得不放弃'],
('nanjing-qinhuai-river', 10): ['就能', '仍能', '因此能'],
('shanghai-bund', 1): ['从小外滩在', '在从小外滩', '从小于外滩'],
('shanghai-bund', 5): ['便开始了去怀疑', '便开始着怀疑', '便开始怀疑了着'],
('shanghai-bund', 10): ['从纸面单据逐渐转向成', '从纸面单据转向于', '由纸面单据转向到'],
('suzhou-humble-administrators-garden', 1): ['走慢慢地在前面，', '慢慢的走在前面，', '在前面地慢慢走，'],
('suzhou-humble-administrators-garden', 5): ['这才使得让外婆', '这才让得外婆', '这使得让外婆才'],
('suzhou-humble-administrators-garden', 10): ['前提因为', '前提在因为', '因为前提是所以'],
('xian-city-wall', 1): ['周遥要搬家全家', '全家周遥要搬', '周遥全家搬要'],
('xian-city-wall', 5): ['并不等于就是', '并不就是等于', '并不等于是'],
('xian-city-wall', 10): ['必须就先', '先必须', '必须所以先'],
}
for key, values in D.items():
    replace_distractors(key[0], key[1], values)

if len(D) != 33:
    raise SystemExit(f'expected 33 non-Datong human grammar checkpoints, got {len(D)}')

path.write_text(text, encoding='utf-8')
print('polished 33 non-Datong Lv1/Lv5/Lv10 grammar checkpoints')
print('rewrote 10 structurally ambiguous human-gate grammar items')
