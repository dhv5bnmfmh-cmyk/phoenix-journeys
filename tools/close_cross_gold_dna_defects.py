from pathlib import Path
import re

path = Path('app/lib/data/all_gold_challenge_gold_profiles.dart')
text = path.read_text(encoding='utf-8')


def section_bounds(journey_id: str) -> tuple[int, int]:
    start_marker = f"  '{journey_id}': GoldChallengeProfile("
    start = text.find(start_marker)
    if start < 0:
        raise SystemExit(f'missing profile {journey_id}')
    top_level_profiles = list(
        re.finditer(r"(?m)^  '[^']+': GoldChallengeProfile\(", text)
    )
    starts = [match.start() for match in top_level_profiles if match.start() > start]
    end = min(starts) if starts else text.find("};", start)
    if end < 0:
        raise SystemExit(f'missing profile end {journey_id}')
    return start, end


def replace_grammar(journey_id: str, target_id: str, block: str) -> None:
    global text
    start, end = section_bounds(journey_id)
    section = text[start:end]
    pattern = re.compile(
        r"GoldChallengeGrammarSpec\(\s*targetId: '"
        + re.escape(target_id)
        + r"'.*?\n\s*\),",
        re.S,
    )
    matches = list(pattern.finditer(section))
    if len(matches) != 1:
        raise SystemExit(
            f'{journey_id}/{target_id}: expected 1 grammar block, found {len(matches)}'
        )
    section = pattern.sub(block.strip() + ',', section, count=1)
    text = text[:start] + section + text[end:]


def replace_in_profile(journey_id: str, old: str, new: str) -> None:
    global text
    start, end = section_bounds(journey_id)
    section = text[start:end]
    count = section.count(old)
    if count != 1:
        raise SystemExit(
            f'{journey_id}: expected one occurrence of {old!r}, found {count}'
        )
    section = section.replace(old, new, 1)
    text = text[:start] + section + text[end:]


# Suzhou: break both Summer-Palace and Shanghai four-level grammar runs with
# two Story-owned language objectives: completed repetition (又/再) and
# “即使……也……” boundary reasoning.
replace_grammar(
    'suzhou-humble-administrators-garden',
    'de-di-de',
    r'''GoldChallengeGrammarSpec(
      targetId: 'observed-repetition-you-zai',
      prefix: '第二次转过屋角时，陈玉兰',
      brokenSegment: '再',
      suffix: '暂时看不见程朗。',
      correctReplacement: '又',
      distractors: <String>['才', '就', '还再'],
      errorType: '又/再：已发生重复与未发生重复',
      whyWrong: '这里叙述的是已经发生的第二次短暂遮挡，应使用“又”；“再”更常指尚未发生或将要重复的动作。',
      revisionRule: '已经发生的重复常用“又”，计划或将来的再次动作常用“再”。',
      memoryTip: '先判断第二次事件已经发生，还是还没发生。',
      misconception: '把已经发生的第二次遮挡误写成将来再次发生',
    )''',
)
replace_grammar(
    'suzhou-humble-administrators-garden',
    'contrast',
    r'''GoldChallengeGrammarSpec(
      targetId: 'even-if-boundary',
      prefix: '',
      brokenSegment: '即使第二次暂时看不见程朗，但是陈玉兰也',
      suffix: '没有再喊他的名字。',
      correctReplacement: '即使第二次暂时看不见程朗，陈玉兰也',
      distractors: <String>[
        '虽然第二次暂时看不见程朗，所以陈玉兰',
        '因为第二次暂时看不见程朗，陈玉兰也',
        '即使第二次暂时看不见程朗，所以陈玉兰也',
      ],
      errorType: '即使…也…：让步条件与关系边界',
      whyWrong: '“即使”已经建立让步条件，后半句用“也”承接即可；再叠加“但是”会把两套结构混在一起。',
      revisionRule: '“即使A，也B”保持一套让步结构，不额外叠加“但是/所以”。',
      memoryTip: '看到“即使”，先寻找与它呼应的“也”。',
      misconception: '把照护边界的让步关系叠成两套连接结构',
    )''',
)

# Longmen: move low-level grammar away from generic adverb drills and into
# evidence-source attribution without requiring higher-level historical trivia.
replace_grammar(
    'luoyang-longmen-grottoes',
    'de-di-de',
    r'''GoldChallengeGrammarSpec(
      targetId: 'source-preposition',
      prefix: '周澄问：“这个补全判断',
      brokenSegment: '来自从哪份资料',
      suffix: '？”',
      correctReplacement: '来自哪份资料',
      distractors: <String>['从来自哪份资料', '来自于从哪份资料', '来自哪份资料从'],
      errorType: '来源结构：“来自”与“从”不可重复套用',
      whyWrong: '“来自”本身已经表达来源，再加“从”会重复标记同一个来源关系。',
      revisionRule: '表达来源时选择“来自A”或“从A来”，不要把两个框架叠在一起。',
      memoryTip: '一句话只保留一套来源标记。',
      misconception: '把“来自”和“从”重复用于同一证据来源',
    )''',
)

# Kaiping: distinguish family-purpose allocation from generic 把字句 drills.
replace_grammar(
    'jiangmen-kaiping-diaolou',
    'ba-structure',
    r'''GoldChallengeGrammarSpec(
      targetId: 'purpose-marker',
      prefix: '哥哥第一封信里的投入',
      brokenSegment: '用给',
      suffix: '自家独楼，梁川不能直接挪作众楼资金。',
      correctReplacement: '用于',
      distractors: <String>['用来于', '用于给', '给用于'],
      errorType: '用途标记：“用于”直接引出用途',
      whyWrong: '这里要说明这笔投入原先限定的用途，应使用“用于”；“用给”把用途和给予结构混在一起。',
      revisionRule: '说明资金、材料或空间的用途时，可用“A用于B”。',
      memoryTip: '先问这笔投入原来“用于什么”。',
      misconception: '把资金用途关系误写成给予对象关系',
    )''',
)

# Expand every short rationale found by the aggregate DNA gate. These are
# Journey-owned explanations, not padding: each names the concrete learner
# misunderstanding that would lead to the distractor.
replacements = [
    ('beijing-summer-palace', "misconception: '把结果当成原因'", "misconception: '把错过金光的结果反过来当成原因'"),
    ('beijing-summer-palace', "misconception: '把让步误当因果'", "misconception: '把失去金光后的让步关系误写成直接因果'"),
    ('chengdu-kuanzhai-alley', "misconception: '重复并列关联词'", "misconception: '在竹椅双重用途句里重复叠加并列关联词'"),
    ('nanjing-qinhuai-river', "misconception: '把原因写成转折'", "misconception: '把灯影方案的原因关系误写成转折关系'"),
    ('nanjing-qinhuai-river', "misconception: '重复关联词'", "misconception: '在秦淮夜间路线句里重复叠加关联词'"),
    ('guangzhou-chen-clan-academy', "misconception: '重复关联词'", "misconception: '在姓名与影像边界句里重复叠加关联词'"),
    ('suzhou-humble-administrators-garden', "misconception: '把因果改成转折'", "misconception: '把程朗等待带来的判断变化误写成转折关系'"),
    ('suzhou-humble-administrators-garden', "misconception: '重复关联词'", "misconception: '在前行与等待并存句里重复叠加关联词'"),
    ('luoyang-longmen-grottoes', "misconception: '把让步写成因果'", "misconception: '把放弃模型成本与证据选择的让步关系误写成因果'"),
]
for journey_id, old, new in replacements:
    replace_in_profile(journey_id, old, new)

# Suzhou Lv6 short rationale is removed together with the replaced grammar
# block above, so it intentionally has no separate string replacement.

path.write_text(text, encoding='utf-8')
print('closed six cross-Gold grammar-run collisions')
print('expanded all short misconception rationales from aggregate DNA gate')
