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
    start, end = bounds(journey_id)
    section = text[start:end]
    starts = [m.start() for m in re.finditer(r'GoldChallengeGrammarSpec\(', section)]
    if len(starts) != 10:
        raise SystemExit(f'{journey_id}: expected 10 grammar blocks, found {len(starts)}')
    block_start = starts[level - 1]
    block_end = section.find('\n      ),', block_start)
    if block_end < 0:
        raise SystemExit(f'{journey_id} Lv{level}: no block end')
    block_end += len('\n      ),')
    section = section[:block_start] + block.strip() + ',' + section[block_end:]
    text = text[:start] + section + text[end:]


replace_level('beijing-forbidden-city', 4, r'''GoldChallengeGrammarSpec(
        targetId: 'merge-into',
        prefix: '沈砚没有',
        brokenSegment: '把两条路线合并成到',
        suffix: '一条所谓的唯一路线。',
        correctReplacement: '把两条路线合并为',
        distractors: <String>['把两条路线合并到为', '让两条路线合并成为到', '把两条路线合为到'],
        errorType: '合并为：结果内容',
        whyWrong: '“合并为”直接说明两条路线被处理后的结果内容，“成到”把结果和方向结构混在一起。',
        revisionRule: '说明合并后的结果，用“合并为 + 结果”。',
        memoryTip: '这里不是移动到某处，而是变成一种结果。',
        misconception: '把路线合并的结果关系误写成方向补语',
      )''')
replace_level('beijing-forbidden-city', 10, r'''GoldChallengeGrammarSpec(
        targetId: 'qujueyu',
        prefix: '路线怎样形成，',
        brokenSegment: '取决到',
        suffix: '不同角色的行动目的。',
        correctReplacement: '取决于',
        distractors: <String>['取决在', '取决给', '取决受到'],
        errorType: '取决于：条件来源',
        whyWrong: '“取决”后用“于”引出决定条件；“取决到”把条件关系误写成方向关系。',
        revisionRule: '表达某结果由什么条件决定，用“取决于……”。',
        memoryTip: '路线差异取决于角色要做什么。',
        misconception: '把决定条件误当成动作到达的方向',
      )''')

replace_level('chengdu-kuanzhai-alley', 3, r'''GoldChallengeGrammarSpec(
        targetId: 'anpaizai',
        prefix: '林夏原想',
        brokenSegment: '把竹椅安排成到',
        suffix: '一个固定位置。',
        correctReplacement: '把竹椅安排在',
        distractors: <String>['把竹椅安排成为', '把竹椅安排到在', '让竹椅安排在到'],
        errorType: '安排在：位置落点',
        whyWrong: '这里说的是把竹椅放在某个位置，应使用“安排在”；“成到”混入了结果变化。',
        revisionRule: '动作落在具体位置时，用“在 + 地点/位置”。',
        memoryTip: '问的是椅子放在哪里，不是变成什么。',
        misconception: '把位置落点误写成状态变化结构',
      )''')

replace_level('nanjing-qinhuai-river', 3, r'''GoldChallengeGrammarSpec(
        targetId: 'liewei',
        prefix: '魏舟没有',
        brokenSegment: '把未确认的改线列成到',
        suffix: '可以执行的临时方案。',
        correctReplacement: '把未确认的改线列为',
        distractors: <String>['把未确认的改线列到为', '让未确认改线列成为到', '把未确认改线列入成为'],
        errorType: '列为：分类与认定',
        whyWrong: '这里是把改线认定为某类方案，用“列为”；“成到”混合了变化和方向。',
        revisionRule: '把对象归入某种身份或类别，可用“列为 + 类别”。',
        memoryTip: '安全未确认，所以不能把它“列为”可执行方案。',
        misconception: '把分类认定关系误写成方向变化结构',
      )''')

replace_level('shanghai-bund', 3, r'''GoldChallengeGrammarSpec(
        targetId: 'zhuangjin',
        prefix: '林岸最后',
        brokenSegment: '把旧提单装到进',
        suffix: '自己的包里。',
        correctReplacement: '把旧提单装进',
        distractors: <String>['把旧提单装进到', '把旧提单进装到', '把旧提单装着进到'],
        errorType: '装进：趋向补语',
        whyWrong: '“进”已经表达由外到内的方向，再加“到”会重复方向标记。',
        revisionRule: '“装进 + 容器/空间”直接表达进入内部。',
        memoryTip: '旧提单是被放进包里，不是“装到进”。',
        misconception: '在已经有趋向补语“进”的结构里再次添加方向标记',
      )''')

replace_level('jiangmen-kaiping-diaolou', 10, r'''GoldChallengeGrammarSpec(
        targetId: 'weirao',
        prefix: '家庭投入的去向',
        brokenSegment: '围绕到',
        suffix: '众楼的共同避难功能重新安排。',
        correctReplacement: '围绕',
        distractors: <String>['围绕于到', '围到绕', '围绕给到'],
        errorType: '围绕：以某核心组织安排',
        whyWrong: '“围绕”本身已经引出组织安排的核心，不需要再加方向词“到”。',
        revisionRule: '表达以某个核心重新组织内容，可用“围绕 + 核心”。',
        memoryTip: '这次重新分配围绕的是众楼共同避难功能。',
        misconception: '把组织核心误写成动作到达的方向',
      )''')

replace_level('xian-city-wall', 5, r'''GoldChallengeGrammarSpec(
        targetId: 'bingbu-yiwei',
        prefix: '',
        brokenSegment: '搬出城墙，就意味着',
        suffix: '离开自己的旧生活。',
        correctReplacement: '搬出城墙，并不意味着',
        distractors: <String>['搬出城墙，因此一定意味着', '只要搬出城墙，就等同于', '搬出城墙，所以必须意味着'],
        errorType: '并不意味着：否定错误推论',
        whyWrong: '住址越过城墙不必然推出与旧生活断开，原句把空间变化写成了必然关系。',
        revisionRule: '否定一个看似自然但不成立的推论，可用“A并不意味着B”。',
        memoryTip: '搬家改变住址，不自动切断归属。',
        misconception: '把住址变化误推成与旧城关系必然结束',
      )''')

path.write_text(text, encoding='utf-8')
print('removed non-Datong grammar skeletons that duplicated locked Datong reference patterns')
