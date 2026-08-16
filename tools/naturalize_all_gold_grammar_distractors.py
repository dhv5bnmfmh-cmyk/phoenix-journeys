from pathlib import Path
import re

path = Path('app/lib/data/all_gold_challenge_gold_profiles.dart')
text = path.read_text(encoding='utf-8')


def bounds(journey_id: str) -> tuple[int, int]:
    marker = f"  '{journey_id}': GoldChallengeProfile("
    start = text.find(marker)
    if start < 0:
        raise SystemExit(f'missing profile {journey_id}')
    matches = list(re.finditer(r"(?m)^  '[^']+': GoldChallengeProfile\(", text))
    following = [m.start() for m in matches if m.start() > start]
    end = min(following) if following else text.find('};', start)
    if end < 0:
        raise SystemExit(f'missing end for {journey_id}')
    return start, end


def grammar_bounds(section: str, level: int) -> tuple[int, int]:
    starts = [m.start() for m in re.finditer(r'GoldChallengeGrammarSpec\(', section)]
    if len(starts) != 10:
        raise SystemExit(f'expected 10 grammar blocks, found {len(starts)}')
    start = starts[level - 1]
    end = section.find('\n      ),', start)
    if end < 0:
        raise SystemExit(f'missing grammar end at level {level}')
    return start, end + len('\n      ),')


def replace_level(journey_id: str, level: int, block: str) -> None:
    global text
    s, e = bounds(journey_id)
    section = text[s:e]
    gs, ge = grammar_bounds(section, level)
    section = section[:gs] + block.strip() + ',' + section[ge:]
    text = text[:s] + section + text[e:]


def dq(value: str) -> str:
    return "'" + value.replace('\\', '\\\\').replace("'", "\\'") + "'"


# Human-gate ambiguity repairs: make the broken Chinese itself structurally
# wrong so grammarRepair never depends on remembering a Story judgment.
replace_level('beijing-forbidden-city', 1, r'''GoldChallengeGrammarSpec(
        targetId: 'adverb-scope-particle',
        prefix: '沈砚',
        brokenSegment: '把两条路线都清楚的',
        suffix: '描在同一张纸上。',
        correctReplacement: '把两条路线都清楚地',
        distractors: <String>['把两条路线都清楚的', '把两条路线都清楚得', '把两条路线清楚地都'],
        errorType: '的/地/得与副词范围',
        whyWrong: '“清楚”在这里修饰动作“描”，需要用“地”；“都”说明两条路线都被画出。',
        revisionRule: '方式状语用“地”，并把范围副词放在它所管的对象之后。',
        memoryTip: '先找“都”管什么，再看“清楚”修饰什么动作。',
        misconception: '把修饰动作的“地”误写成“的”，并混淆“都”的范围',
      )''')
replace_level('beijing-forbidden-city', 6, r'''GoldChallengeGrammarSpec(
        targetId: 'contrast-adverb-redundancy',
        prefix: '沈砚原来想找出一条唯一路线，',
        brokenSegment: '后来却但是',
        suffix: '保留了两条线。',
        correctReplacement: '后来却',
        distractors: <String>['后来却但是', '后来所以却', '后来因为却'],
        errorType: '转折副词赘余：“却”与“但是”重复',
        whyWrong: '“却”已经能承接前后反差，再叠加“但是”会把同一层转折标记两次。',
        revisionRule: '同一转折关系保留一个清楚的转折标记。',
        memoryTip: '“原来想……后来却……”已经完整。',
        misconception: '认为转折词叠得越多，反差越清楚',
      )''')
replace_level('beijing-summer-palace', 10, r'''GoldChallengeGrammarSpec(
        targetId: 'auxiliary-order-after-evidence',
        prefix: '许澄',
        brokenSegment: '先把来源和旧痕迹看清楚以后，就能才',
        suffix: '说明为什么保留它们。',
        correctReplacement: '先把来源和旧痕迹看清楚，才能',
        distractors: <String>['先把来源和旧痕迹看清楚以后，就能才', '把来源看清楚，才可以能', '先把来源看清楚，就才可以'],
        errorType: '能愿动词与“才”的语序',
        whyWrong: '强调完成来源辨认之后才具备解释能力，应说“才能说明”；“就能才”把结果副词与能愿动词次序打乱。',
        revisionRule: '表达具备条件后才有能力做某事，用“才能 + 动词”。',
        memoryTip: '先看清依据，才能解释保留。',
        misconception: '把“才”和“能”拆开乱序，削弱先决条件关系',
      )''')
replace_level('hangzhou-west-lake', 10, r'''GoldChallengeGrammarSpec(
        targetId: 'zaiyu-redundancy',
        prefix: '两个人最后面对的关键',
        brokenSegment: '不在于是景名是否答对，而在于是',
        suffix: '如何一起面对记忆变化。',
        correctReplacement: '不在于景名是否答对，而在于',
        distractors: <String>['不在于是景名是否答对，而在于是', '不是在于景名是否答对，而是在于', '不在景名是否答对于，而在于'],
        errorType: '“在于”后不再叠加判断词“是”',
        whyWrong: '“关键在于……”已经能引出评价焦点，再加“是”会把“在于”和判断句结构重复套用。',
        revisionRule: '抽象评价用“关键不在于A，而在于B”。',
        memoryTip: '“在于”后直接接内容，不再加“是”。',
        misconception: '把“在于”和“是”两种判断结构重复叠加',
      )''')
replace_level('xian-city-wall', 5, r'''GoldChallengeGrammarSpec(
        targetId: 'bingbu-jiu-redundancy',
        prefix: '周遥后来明白，',
        brokenSegment: '搬出城墙，并不就意味着',
        suffix: '离开自己的旧生活。',
        correctReplacement: '搬出城墙，并不意味着',
        distractors: <String>['搬出城墙，并不就意味着', '搬出城墙，并不是就意味着', '搬出城墙，并不一定就意味着着'],
        errorType: '否定副词赘余：“并不”后不必再加“就”',
        whyWrong: '“并不意味着”已经完整否定错误推论，再插入“就”会让结构拖沓。',
        revisionRule: '否定某个推论时，直接用“A并不意味着B”。',
        memoryTip: '先把“并不意味着”作为完整结构读出来。',
        misconception: '在完整的否定推论结构中多加结果副词“就”',
      )''')

# Two additional near-miss candidates per Journey×Level. The actual broken
# segment is always kept as distractor 1 below, so every item tests a real,
# diagnosable learner error rather than random word salad.
ALT = {
('beijing-forbidden-city',1): ['把两条路线都清楚得','把两条路线清楚地都'],
('beijing-forbidden-city',2): ['使共同节点变得更清楚','共同节点被变得更清楚'],
('beijing-forbidden-city',3): ['仔细得','仔细的'],
('beijing-forbidden-city',4): ['把两条路线合并于','把两条路线合并到为'],
('beijing-forbidden-city',5): ['直到两条线在共同节点相遇，他就开始','两条线在共同节点相遇以后，他才就开始'],
('beijing-forbidden-city',6): ['后来所以却','后来因为却'],
('beijing-forbidden-city',7): ['因为不同，所以','虽然不同，因此'],
('beijing-forbidden-city',8): ['每人各自沿','各自分别沿'],
('beijing-forbidden-city',9): ['不再问“谁更正确”，而开始问成','不再把“谁更正确”问，而开始问'],
('beijing-forbidden-city',10): ['取决在','被取决于'],
('beijing-summer-palace',1): ['专门于冬至前','冬至前地专门'],
('beijing-summer-palace',2): ['安静得','安静的'],
('beijing-summer-palace',3): ['吹得落','吹下来得'],
('beijing-summer-palace',4): ['先捡回照片，但是再','先捡回照片，因为再'],
('beijing-summer-palace',5): ['尽管','但是'],
('beijing-summer-palace',6): ['不但留下旧照片，但是还','既留下旧照片，而且还'],
('beijing-summer-palace',7): ['哪怕失去了金光，因此','因为失去了金光，也'],
('beijing-summer-palace',8): ['这个相机变化','这一张照片变化'],
('beijing-summer-palace',9): ['比起把旧痕迹遮掉，所以更重要','因为把旧痕迹遮掉，更重要的是'],
('beijing-summer-palace',10): ['把来源看清楚，才可以能','先把来源看清楚，就才可以'],
('chengdu-kuanzhai-alley',1): ['先把竹椅门口的','先把门口竹椅的'],
('chengdu-kuanzhai-alley',2): ['快速得','快速的'],
('chengdu-kuanzhai-alley',3): ['把竹椅安排到在','把竹椅安排成为'],
('chengdu-kuanzhai-alley',4): ['有人经过以后，竹椅才','因为有人经过，竹椅就'],
('chengdu-kuanzhai-alley',5): ['一会儿服务坐茶，所以一会儿','一会儿服务坐茶，而且一会儿'],
('chengdu-kuanzhai-alley',6): ['才往旁边移','就随着往旁边移'],
('chengdu-kuanzhai-alley',7): ['才会','仍会'],
('chengdu-kuanzhai-alley',8): ['移动竹椅的人仍然只有林夏，也包括','移动竹椅的人不再林夏，也包括'],
('chengdu-kuanzhai-alley',9): ['给竹椅找一个永远正确的位置，所以','给竹椅找一个永远正确的位置，但是'],
('chengdu-kuanzhai-alley',10): ['因此因为','虽然是因为'],
('guangzhou-chen-clan-academy',1): ['慢慢的举起手机','手机慢慢地举起'],
('guangzhou-chen-clan-academy',2): ['轻轻得','轻轻的'],
('guangzhou-chen-clan-academy',3): ['扣得在','扣成在'],
('guangzhou-chen-clan-academy',4): ['嘉禾退了一步，所以秀仪便','因为嘉禾一退，秀仪便因此'],
('guangzhou-chen-clan-academy',5): ['所以','因为'],
('guangzhou-chen-clan-academy',6): ['把嘉禾现在的姓名确认作为','确认给嘉禾现在的姓名'],
('guangzhou-chen-clan-academy',7): ['没有公开合照，因此妨碍嘉禾','没有公开合照，就会妨碍嘉禾'],
('guangzhou-chen-clan-academy',8): ['不该被秀仪给亲族证明关系','不该让嘉禾的影像被秀仪证明关系'],
('guangzhou-chen-clan-academy',9): ['不留下合照，所以不越过嘉禾的边界','不留下合照，但是也越过嘉禾的边界'],
('guangzhou-chen-clan-academy',10): ['没有嘉禾同意，秀仪因此可以','即使嘉禾不同意，秀仪仍要'],
('hangzhou-west-lake',1): ['一直把预约卡藏着地','一直预约卡藏'],
('hangzhou-west-lake',2): ['慢慢得','慢慢的'],
('hangzhou-west-lake',3): ['扶得住了','扶着住'],
('hangzhou-west-lake',4): ['随着以后','继续以后地'],
('hangzhou-west-lake',5): ['虽然周绍庭扶住她，方毓才','正因为周绍庭扶住她，所以方毓'],
('hangzhou-west-lake',6): ['所以','因为'],
('hangzhou-west-lake',7): ['答不出景名，也就证明','因为答不出景名，就等于'],
('hangzhou-west-lake',8): ['而且再拿出','同时因此拿出'],
('hangzhou-west-lake',9): ['原因因为','原因所以在'],
('hangzhou-west-lake',10): ['不是在于景名是否答对，而是在于','不在景名是否答对于，而在于'],
('jiangmen-kaiping-diaolou',1): ['寄从海外回一份','一份从海外寄回地'],
('jiangmen-kaiping-diaolou',2): ['认真得','认真的'],
('jiangmen-kaiping-diaolou',3): ['用来于','用于给'],
('jiangmen-kaiping-diaolou',4): ['先折起原图，但是再','虽然折起原图，再'],
('jiangmen-kaiping-diaolou',5): ['这所以让','因为这个让'],
('jiangmen-kaiping-diaolou',6): ['所以','因为'],
('jiangmen-kaiping-diaolou',7): ['放弃独楼，因此解除梁川','只要放弃独楼，就不再承担'],
('jiangmen-kaiping-diaolou',8): ['改写成为到','改写为了成'],
('jiangmen-kaiping-diaolou',9): ['没有完整照搬海外柱廊，所以只','虽然没有完整照搬海外柱廊，但是只'],
('jiangmen-kaiping-diaolou',10): ['围绕于','围绕在'],
('luoyang-longmen-grottoes',1): ['按先自己的想象','先按自己的想象地'],
('luoyang-longmen-grottoes',2): ['来自从哪份资料','来自哪份资料从'],
('luoyang-longmen-grottoes',3): ['关得掉了','关着掉'],
('luoyang-longmen-grottoes',4): ['说不出具体来源，因为所以','说不出具体来源，虽然就'],
('luoyang-longmen-grottoes',5): ['所以','因为'],
('luoyang-longmen-grottoes',6): ['一方面记录现存状态，但是另一方面','一方面记录现存状态，所以另一方面'],
('luoyang-longmen-grottoes',7): ['删掉模型因为让转场不顺，林砚仍','删掉模型固然让转场不顺，所以林砚'],
('luoyang-longmen-grottoes',8): ['由林砚受到标成','让林砚被标成'],
('luoyang-longmen-grottoes',9): ['与其说要把每处残损补满，但是说','虽然说要把每处残损补满，所以'],
('luoyang-longmen-grottoes',10): ['只能支持有限判断，而且足以','只足以支持有限判断，所以能'],
('nanjing-qinhuai-river',1): ['让魏舟必须先判断安全条件','魏舟先必须判断安全条件'],
('nanjing-qinhuai-river',2): ['快速得检查','快速的检查'],
('nanjing-qinhuai-river',3): ['把未确认的改线列到为','把未确认的改线列成到'],
('nanjing-qinhuai-river',4): ['先放下工具，但是再','虽然放下工具，再'],
('nanjing-qinhuai-river',5): ['所以魏舟因而','魏舟因为所以'],
('nanjing-qinhuai-river',6): ['保留通行照明，而且同时','既保留通行照明，同时又'],
('nanjing-qinhuai-river',7): ['虽有一段灯保持黑暗，因此主要路线才','有一段灯保持黑暗，所以主要路线仍'],
('nanjing-qinhuai-river',8): ['既没有接管控制台，而且也没有','没有接管控制台，但是也没有'],
('nanjing-qinhuai-river',9): ['保留一段黑暗，所以不采用未确认改线','保留一段黑暗，但是采用未确认改线'],
('nanjing-qinhuai-river',10): ['因此能','仍能'],
('shanghai-bund',1): ['在从小外滩','外滩地从小'],
('shanghai-bund',2): ['平静得','平静的'],
('shanghai-bund',3): ['把旧提单装进到','把旧提单进装到'],
('shanghai-bund',4): ['一度想还提单，因为最后','虽然想还提单，最后所以'],
('shanghai-bund',5): ['才就开始便','才开始便才'],
('shanghai-bund',6): ['所以','因为'],
('shanghai-bund',7): ['不只记录货物与责任，而且又还','既不只记录货物与责任，还又'],
('shanghai-bund',8): ['两岸这个看见的变化','这个两岸同时的看见变化'],
('shanghai-bund',9): ['不是货运记录，就是','不止货运记录，所以包括'],
('shanghai-bund',10): ['从纸面单据转向于','由纸面单据转向到'],
('suzhou-humble-administrators-garden',1): ['慢慢的走在前面，','在前面地慢慢走，'],
('suzhou-humble-administrators-garden',2): ['还再','才'],
('suzhou-humble-administrators-garden',3): ['挡得住了看不见','挡着住'],
('suzhou-humble-administrators-garden',4): ['先抬手，但是再','虽然抬手，再'],
('suzhou-humble-administrators-garden',5): ['这才让得外婆','这使得让外婆才'],
('suzhou-humble-administrators-garden',6): ['即使第二次暂时看不见程朗，所以陈玉兰也','虽然第二次暂时看不见程朗，所以陈玉兰'],
('suzhou-humble-administrators-garden',7): ['走在前面，因为却','走在前面，因此但是'],
('suzhou-humble-administrators-garden',8): ['允许程朗走在前面，并且所以不再','允许程朗走在前面，因为不再'],
('suzhou-humble-administrators-garden',9): ['“会等待、会回头”更比','比“会等待、会回头”更加'],
('suzhou-humble-administrators-garden',10): ['前提在因为','因为前提是所以'],
('xian-city-wall',1): ['全家周遥要搬','周遥全家搬要'],
('xian-city-wall',2): ['从傍晚永宁门','永宁门从傍晚'],
('xian-city-wall',3): ['跑得完了','跑完成地'],
('xian-city-wall',4): ['先看数字，但是再','虽然看数字，再'],
('xian-city-wall',5): ['搬出城墙，并不是就意味着','搬出城墙，并不一定就意味着着'],
('xian-city-wall',6): ['路线又接着继续再','路线接续着又继续'],
('xian-city-wall',7): ['虽围出内外，所以生活路线','因为围出内外，生活路线却'],
('xian-city-wall',8): ['这个一整圈东西','这些一整圈的这个'],
('xian-city-wall',9): ['一面保存历史边界，而且又一面','既一面保存历史边界，又一面'],
('xian-city-wall',10): ['就必须先才','必须所以先'],
}


def field(block: str, name: str) -> str:
    m = re.search(rf"{name}: '((?:\\'|[^'])*)'", block)
    if not m:
        raise SystemExit(f'missing {name}')
    return m.group(1).replace("\\'", "'")


def naturalize(journey_id: str, level: int, alts: list[str]) -> None:
    global text
    s, e = bounds(journey_id)
    section = text[s:e]
    gs, ge = grammar_bounds(section, level)
    block = section[gs:ge]
    broken = field(block, 'brokenSegment')
    correct = field(block, 'correctReplacement')
    candidates = [broken, *alts]
    chosen = []
    for value in candidates:
        value = value.strip()
        if not value or value == correct or value in chosen:
            continue
        chosen.append(value)
    if len(chosen) < 3:
        raise SystemExit(f'{journey_id} Lv{level}: only {len(chosen)} distinct distractors')
    chosen = chosen[:3]
    replacement = 'distractors: <String>[' + ', '.join(dq(v) for v in chosen) + '],'
    pattern = re.compile(r'distractors: <String>\[.*?\],', re.S)
    if len(pattern.findall(block)) != 1:
        raise SystemExit(f'{journey_id} Lv{level}: distractor list mismatch')
    block = pattern.sub(replacement, block, count=1)
    section = section[:gs] + block + section[ge:]
    text = text[:s] + section + text[e:]


for key, alts in ALT.items():
    naturalize(key[0], key[1], alts)

if len(ALT) != 110:
    raise SystemExit(f'expected 110 non-Datong grammar units, got {len(ALT)}')

path.write_text(text, encoding='utf-8')
print('naturalized distractors for 110 non-Datong Gold grammar units')
print('repaired five human-gate ambiguous grammar items')
