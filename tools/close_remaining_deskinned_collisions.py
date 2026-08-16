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
        raise SystemExit(f'{journey_id} Lv{level}: missing block end')
    block_end += len('\n      ),')
    section = section[:block_start] + block.strip() + ',' + section[block_end:]
    text = text[:start] + section + text[end:]


replace_level('shanghai-bund', 5, r'''GoldChallengeGrammarSpec(
        targetId: 'yihou-bian',
        prefix: '轮渡离开西岸、两岸同时进入视野以后，林岸',
        brokenSegment: '才便开始',
        suffix: '怀疑“过去/未来”的二分。',
        correctReplacement: '便开始',
        distractors: <String>['才就开始便', '便才开始就', '才开始便才'],
        errorType: '便：叙事触发后的自然承接',
        whyWrong: '“才”强调迟至某条件后发生，“便”强调随即发生；这里两岸一同进入视野后判断随即变化，不应把两个时间副词叠在一起。',
        revisionRule: '前一场景直接触发后一判断时，可用“便”承接。',
        memoryTip: '两岸同时进入视野，林岸便开始重新判断。',
        misconception: '把“迟至才发生”和“随即便发生”两个时间视角混用',
      )''')

replace_level('xian-city-wall', 6, r'''GoldChallengeGrammarSpec(
        targetId: 'jixu-redundancy',
        prefix: '周遥没有按停跑表，',
        brokenSegment: '路线接着又继续',
        suffix: '从城墙伸向新家。',
        correctReplacement: '路线继续',
        distractors: <String>['路线又接着继续再', '路线接续着又继续', '路线继续又接着再'],
        errorType: '“接着/又/继续”语义重复',
        whyWrong: '“接着”“又”“继续”都在强调后续延续，叠在一起会让动作关系臃肿。',
        revisionRule: '同一层的延续意义保留一个清楚的表达。',
        memoryTip: '跑表没停，路线“继续”就够了。',
        misconception: '把多个表示延续的副词和动词全部堆在同一动作上',
      )''')

replace_level('suzhou-humble-administrators-garden', 5, r'''GoldChallengeGrammarSpec(
        targetId: 'causative-redundancy',
        prefix: '程朗在下一处停下等她，',
        brokenSegment: '这才使得让外婆',
        suffix: '开始相信短暂看不见不等于走散。',
        correctReplacement: '这才让外婆',
        distractors: <String>['这才让得外婆', '这使得让外婆才', '这才使让得外婆'],
        errorType: '使得/让：使令结构赘余',
        whyWrong: '“使得”和“让”都可以引出受影响者，这里连续使用会重复同一使令关系。',
        revisionRule: '同一使令关系选择“使得”或“让”中的一个完整结构。',
        memoryTip: '程朗的等待“让外婆”改变判断即可。',
        misconception: '把两个表达使令关系的结构连续套在同一个受影响者前',
      )''')

replace_level('shanghai-bund', 10, r'''GoldChallengeGrammarSpec(
        targetId: 'zhuanxiang',
        prefix: '承载贸易关系的工具',
        brokenSegment: '从纸面单据逐渐转向成',
        suffix: '数字系统。',
        correctReplacement: '从纸面单据逐渐转向',
        distractors: <String>['从纸面单据转向成为到', '由纸面单据转向成到', '从纸面单据逐渐成转向'],
        errorType: '转向：变化方向与结果词赘余',
        whyWrong: '“转向”本身已经表达变化方向，再接“成”会把方向变化和结果变化重复套用。',
        revisionRule: '表达发展方向改变，可用“从A转向B”。',
        memoryTip: '工具的变化是从纸面“转向”数字系统。',
        misconception: '在已经表达变化方向的“转向”后再次添加结果词',
      )''')

path.write_text(text, encoding='utf-8')
print('closed five residual de-skinned grammar collisions')
