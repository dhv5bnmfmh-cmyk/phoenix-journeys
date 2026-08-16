from pathlib import Path

path = Path('app/lib/data/all_gold_challenge_gold_profiles.dart')
text = path.read_text(encoding='utf-8')

def replace_once(old, new, label):
    global text
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected 1 occurrence, found {count}')
    text = text.replace(old, new, 1)

replace_once(
    "GoldChallengeGrammarSpec(targetId: 'paired-conjunction', prefix: '来源清单', brokenSegment: '既记录现存状态，而且又', suffix: '区分历史照片与有据复原。', correctReplacement: '既记录现存状态，又', distractors: <String>['虽然记录现存状态，所以', '不但记录现存状态，但是', '不是记录现存状态，又'], errorType: '既…又…', whyWrong: '两个并列功能用“既……又……”。', revisionRule: '不要叠加“而且又”。', memoryTip: '既/又成对。', misconception: '重复并列关联词')",
    "GoldChallengeGrammarSpec(targetId: 'evidence-classification-parallel', prefix: '来源清单', brokenSegment: '一方面记录现存状态，而且另一方面', suffix: '区分历史照片与有据复原。', correctReplacement: '一方面记录现存状态，另一方面', distractors: <String>['一方面记录现存状态，所以另一方面', '既记录现存状态，另一方面又', '一方面记录现存状态，但是另一方面'], errorType: '一方面…另一方面…：分类并列', whyWrong: '两类证据职责是并列展开，不能把“一方面/另一方面”与另一套关联词叠加。', revisionRule: '并列分析两个维度时保持“一方面……另一方面……”结构完整。', memoryTip: '来源分类要把两个判断维度并排说清。', misconception: '把证据分类的并列结构写成混合关联结构')",
    'longmen lv6 classification',
)

replace_once(
    "GoldChallengeGrammarSpec(targetId: 'reference', prefix: '林砚把文件标成“无依据，不使用”。', brokenSegment: '这个', suffix: '把视觉判断与证据判断分开。', correctReplacement: '这个标记', distractors: <String>['那块石面', '它们这个', '这些照片们'], errorType: '指代清晰', whyWrong: '前句重点是标记行为和分类结果，需明确回指。', revisionRule: '用具体名词回指抽象动作。', memoryTip: '不要让“这个”在文件、模型、标记之间漂移。', misconception: '用模糊代词回指多个对象')",
    "GoldChallengeGrammarSpec(targetId: 'passive-marking', prefix: '那层补全模型', brokenSegment: '把林砚标成', suffix: '“无依据，不使用”。', correctReplacement: '被林砚标成', distractors: <String>['让林砚被标成', '对林砚标成', '由林砚受到标成'], errorType: '被字句：受事与施事关系', whyWrong: '被标记的是“补全模型”，林砚是执行标记的人，原句把施受关系倒置。', revisionRule: '需要突出受事时，用“受事 + 被 + 施事 + 动作”。', memoryTip: '先问谁被标记，再问谁执行标记。', misconception: '把模型与标记者的施受关系写反')",
    'longmen lv8 passive',
)

replace_once(
    "GoldChallengeGrammarSpec(targetId: 'not-but', prefix: '真实性要求的', brokenSegment: '不是把每处残损补满就是', suffix: '让现存状态与依据层级保持可辨。', correctReplacement: '不是把每处残损补满，而是', distractors: <String>['不是把残损补满，所以', '不仅把残损补满，而且', '虽然不补满，但是'], errorType: '不是…而是…', whyWrong: '故事纠正“真实=视觉完整”的旧判断。', revisionRule: '用“不是A，而是B”重设真实性标准。', memoryTip: '区分完整外观与可核对依据。', misconception: '把标准转换写成二选一')",
    "GoldChallengeGrammarSpec(targetId: 'rather-than-reframing', prefix: '讨论真实性时，', brokenSegment: '与其说要把每处残损补满，所以说', suffix: '要让现存状态与依据层级保持可辨。', correctReplacement: '与其说要把每处残损补满，不如说', distractors: <String>['虽然说要把每处残损补满，所以', '不是说要把每处残损补满，而且说', '与其说要把每处残损补满，但是说'], errorType: '与其…不如…：评价重心转换', whyWrong: '句子是在比较两种真实性理解并把重心转向证据可辨，应使用“与其……不如……”。', revisionRule: '比较两种解释并明确更合适的一项时，用“与其A，不如B”。', memoryTip: '不是简单否定A，而是把评价中心移到B。', misconception: '把解释重心转换误写成普通因果或转折')",
    'longmen lv9 reframing',
)

replace_once(
    "GoldChallengeGrammarSpec(targetId: 'argument-relation', prefix: '历史照片和题记', brokenSegment: '对复原判断受到', suffix: '影响。', correctReplacement: '影响复原判断的范围', distractors: <String>['被复原判断影响', '对复原判断被影响', '受到复原判断去影响'], errorType: '论元关系', whyWrong: '资料是判断依据，复原范围是受其约束的对象。', revisionRule: '明确证据如何限制解释。', memoryTip: '画出“资料 → 复原判断”。', misconception: '把证据和判断的作用方向颠倒')",
    "GoldChallengeGrammarSpec(targetId: 'reason-explanation', prefix: '复原范围', brokenSegment: '之所以不能凭风格补满，是所以', suffix: '历史照片和题记只支持有限判断。', correctReplacement: '之所以不能凭风格补满，是因为', distractors: <String>['因为不能凭风格补满，所以因为', '虽然不能凭风格补满，是因为', '之所以不能凭风格补满，因此'], errorType: '之所以…是因为…：解释结构', whyWrong: '前半句提出需要解释的结果，后半句给出证据原因，应使用“之所以……是因为……”。', revisionRule: '先提出“为什么会这样”的结果，再用“是因为”给出原因。', memoryTip: '把证据边界说成完整的解释关系，而不是堆两个结果词。', misconception: '把原因解释结构与普通因果连接词混用')",
    'longmen lv10 reason',
)

path.write_text(text, encoding='utf-8')
print('refined Longmen Challenge grammar progression')
