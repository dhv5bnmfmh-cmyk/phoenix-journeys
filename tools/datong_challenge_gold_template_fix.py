from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    if old not in text:
        raise SystemExit(f'anchor not found in {path}: {old[:140]!r}')
    p.write_text(text.replace(old, new, 1))


panel = 'app/lib/widgets/journey_challenge_panel.dart'
replace_once(
    panel,
    """      'guangzhou-chen-clan-academy' ||
      'suzhou-humble-administrators-garden' ||
      'datong-yungang-grottoes' =>
        _adaptiveGrammarForJourney(journeyId, difficulty, datongLevel: datongLevel),
""",
    """      'guangzhou-chen-clan-academy' ||
      'suzhou-humble-administrators-garden' =>
        _adaptiveGrammarForJourney(journeyId, difficulty),
      'datong-yungang-grottoes' => _datongGrammarForLevel(
          datongLevel ??
              (throw StateError(
                'Datong grammarRepair requires an exact active level binding.',
              )),
        ),
""",
)

anchor = """  static _GrammarSpec _adaptiveGrammarForJourney(
    String journeyId,
    JourneyChallengeDifficulty difficulty, {
    int? datongLevel,
  }) {
"""
if anchor not in Path(panel).read_text():
    raise SystemExit('adaptive grammar anchor not found')

block = r'''  static _GrammarSpec _datongGrammarForLevel(int level) {
    return switch (level) {
      1 => const _GrammarSpec(
          segments: [
            '北魏定都平城后，',
            '云冈大规模后来有条件集中资源进行开凿',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '北魏定都平城后，云冈大规模后来有条件集中资源进行开凿。',
          correctedSentence: '北魏定都平城后，云冈后来有条件集中资源进行大规模开凿。',
          correctOptionId: 'correct',
          correctReplacement: '云冈后来有条件集中资源进行大规模开凿',
          distractors: [
            '云冈后来大规模有条件把资源集中开凿',
            '云冈有条件后来集中资源被大规模开凿',
            '云冈后来集中资源有条件进行开凿大规模',
          ],
          errorType: '语序不当：范围修饰语位置混乱',
          errorLocation: '“大规模后来……进行开凿”',
          whyWrong: '“大规模”修饰“开凿”，应放在“开凿”前；“后来”应先交代时间，再说明具备的条件。',
          revisionRule: '先放时间，再放条件，把方式或规模修饰语放到它修饰的动作前。',
          memoryTip: '中文语序先理时间和条件，再让“大规模”贴近“开凿”。',
        ),
      2 => const _GrammarSpec(
          segments: [
            '在早期皇家支持下，',
            '把昙曜五窟成为早期大型营造的重要代表',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '在早期皇家支持下，把昙曜五窟成为早期大型营造的重要代表。',
          correctedSentence: '在早期皇家支持下，昙曜五窟成为早期大型营造的重要代表。',
          correctOptionId: 'correct',
          correctReplacement: '昙曜五窟成为早期大型营造的重要代表',
          distractors: [
            '把昙曜五窟作为早期大型营造成为代表',
            '昙曜五窟把早期大型营造成为重要代表',
            '使昙曜五窟把早期大型营造作为重要代表',
          ],
          errorType: '把字句误用：“成为”不能直接作把字句谓语',
          errorLocation: '“把昙曜五窟成为”',
          whyWrong: '“成为”表示主体身份或状态变化，不能写成“把某物成为……”。这里让“昙曜五窟”直接作主语最自然。',
          revisionRule: '遇到“成为”时先找发生身份变化的主语，不要机械套“把”。',
          memoryTip: '“谁成为谁”可以；“把谁成为谁”不可以。',
        ),
      3 => const _GrammarSpec(
          segments: [
            '国家力量能够集中资源，',
            '因此大型石窟营造所以获得更强的组织条件',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '国家力量能够集中资源，因此大型石窟营造所以获得更强的组织条件。',
          correctedSentence: '国家力量能够集中资源，因此大型石窟营造获得更强的组织条件。',
          correctOptionId: 'correct',
          correctReplacement: '因此大型石窟营造获得更强的组织条件',
          distractors: [
            '所以因此大型石窟营造获得更强的组织条件',
            '因此所以大型石窟营造获得更强的组织条件',
            '大型石窟营造因此所以获得更强的组织条件',
          ],
          errorType: '关联词重复：结果标记叠加',
          errorLocation: '“因此……所以……”',
          whyWrong: '“因此”和“所以”都表示结果，同一层因果关系不需要连续使用两个结果标记。',
          revisionRule: '一层因果只保留一个清楚的结果关联词。',
          memoryTip: '看到“因此”和“所以”同时出现，先检查是不是重复表达同一个结果。',
        ),
      4 => const _GrammarSpec(
          segments: [
            '在494年北魏迁都洛阳以后，',
            '使云冈营造进入新的历史阶段',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '在494年北魏迁都洛阳以后，使云冈营造进入新的历史阶段。',
          correctedSentence: '494年北魏迁都洛阳以后，云冈营造进入新的历史阶段。',
          correctOptionId: 'correct',
          correctReplacement: '云冈营造进入新的历史阶段',
          distractors: [
            '因此使云冈营造进入新的历史阶段',
            '让云冈营造所以进入新的历史阶段',
            '云冈营造被使进入新的历史阶段',
          ],
          errorType: '主语残缺：介词结构后又使用使令动词',
          errorLocation: '“在……以后，使云冈营造……”',
          whyWrong: '句首“在……以后”已经是时间状语，再接“使”会让整句缺少自然主语。让“云冈营造”直接作主语即可。',
          revisionRule: '时间状语之后要检查主句是否有明确主语。',
          memoryTip: '“在……以后”只是时间背景，后面仍需要一个能直接行动或变化的主语。',
        ),
      5 => const _GrammarSpec(
          segments: [
            '中期营造继续发展，',
            '洞窟布局与雕饰呈现得更加丰富的表达',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '中期营造继续发展，洞窟布局与雕饰呈现得更加丰富的表达。',
          correctedSentence: '中期营造继续发展，洞窟布局与雕饰呈现出更加丰富的表达。',
          correctOptionId: 'correct',
          correctReplacement: '洞窟布局与雕饰呈现出更加丰富的表达',
          distractors: [
            '洞窟布局与雕饰呈现着更加丰富去表达',
            '洞窟布局与雕饰呈现为更加丰富去表达',
            '洞窟布局与雕饰呈现到更加丰富的表达',
          ],
          errorType: '动词搭配不当：“呈现”与结果宾语的搭配',
          errorLocation: '“呈现得……表达”',
          whyWrong: '这里后面跟的是“表达”这个结果宾语，应使用“呈现出……表达”，而不是用“得”引出程度补语。',
          revisionRule: '动词后接结果或显现出的内容时，检查是否需要“出”而不是“得”。',
          memoryTip: '“呈现出某种面貌/表达”是完整搭配。',
        ),
      6 => const _GrammarSpec(
          segments: [
            '随着494年北魏迁都洛阳以后，',
            '大规模皇家开凿不再按原有规模继续',
            '。',
          ],
          problemSegmentIndex: 0,
          originalSentence: '随着494年北魏迁都洛阳以后，大规模皇家开凿不再按原有规模继续。',
          correctedSentence: '494年北魏迁都洛阳以后，大规模皇家开凿不再按原有规模继续。',
          correctOptionId: 'correct',
          correctReplacement: '494年北魏迁都洛阳以后，',
          distractors: [
            '随着494年北魏迁都洛阳以后，',
            '因为随着494年北魏迁都洛阳以后，',
            '在随着494年北魏迁都洛阳以后，',
          ],
          errorType: '时间结构杂糅：“随着”与“……以后”重复套用',
          errorLocation: '“随着……以后”',
          whyWrong: '“随着……”和“……以后”都能建立时间变化背景，但这里叠在一起造成结构杂糅。',
          revisionRule: '同一时间关系选择一种完整结构，不要把两个框架套在一起。',
          memoryTip: '“随着变化”或“变化以后”二选一，句子会更干净。',
        ),
      7 => const _GrammarSpec(
          segments: [
            '迁都改变了皇家营造条件，',
            '但较小规模的造像活动仍然继续了出现',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '迁都改变了皇家营造条件，但较小规模的造像活动仍然继续了出现。',
          correctedSentence: '迁都改变了皇家营造条件，但较小规模的造像活动仍然继续出现。',
          correctOptionId: 'correct',
          correctReplacement: '但较小规模的造像活动仍然继续出现',
          distractors: [
            '但较小规模的造像活动仍然继续着了出现',
            '但较小规模的造像活动仍然被继续出现',
            '但较小规模的造像活动仍然继续出现了着',
          ],
          errorType: '动态助词误用：“继续”后不能这样插入“了”',
          errorLocation: '“继续了出现”',
          whyWrong: '“继续”在这里直接修饰后面的动作“出现”，不能在两者之间插入表示完成的“了”。',
          revisionRule: '“继续 + 动词”通常直接连接，完成体标记要看整个事件是否真的完成。',
          memoryTip: '“继续出现”表示延续，不要把“了”塞进两个动词中间。',
        ),
      8 => const _GrammarSpec(
          segments: [
            '云冈造像艺术',
            '既吸收多种艺术传统，并且又与中国传统结合',
            '，形成融合后的独特面貌。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '云冈造像艺术既吸收多种艺术传统，并且又与中国传统结合，形成融合后的独特面貌。',
          correctedSentence: '云冈造像艺术既吸收多种艺术传统，又与中国传统结合，形成融合后的独特面貌。',
          correctOptionId: 'correct',
          correctReplacement: '既吸收多种艺术传统，又与中国传统结合',
          distractors: [
            '既吸收多种艺术传统，而且并且与中国传统结合',
            '不但既吸收多种艺术传统，又与中国传统结合',
            '既吸收多种艺术传统，所以又与中国传统结合',
          ],
          errorType: '关联结构杂糅：“既……又……”被其他关联词打断',
          errorLocation: '“既……并且又……”',
          whyWrong: '这里是并列的两个方面，“既……又……”已经完整，再插入“并且”会造成关联结构重复。',
          revisionRule: '成对关联词要保持成套、对称，不要在中间叠加同义连接词。',
          memoryTip: '看到“既”，优先寻找与它成对的“又”。',
        ),
      9 => const _GrammarSpec(
          segments: [
            '政治中心和赞助条件先后改变，',
            '云冈的营造方式不是突然中断，就是逐步转变',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '政治中心和赞助条件先后改变，云冈的营造方式不是突然中断，就是逐步转变。',
          correctedSentence: '政治中心和赞助条件先后改变，云冈的营造方式不是突然中断，而是逐步转变。',
          correctOptionId: 'correct',
          correctReplacement: '云冈的营造方式不是突然中断，而是逐步转变',
          distractors: [
            '云冈的营造方式不是突然中断，或者是逐步转变',
            '云冈的营造方式虽然突然中断，还是逐步转变',
            '云冈的营造方式既然突然中断，就是逐步转变',
          ],
          errorType: '关联关系错误：选择关系误代转折校正关系',
          errorLocation: '“不是……就是……”',
          whyWrong: '这里不是在两个可能结果中二选一，而是在否定“突然中断”后指出真正的理解“逐步转变”，应使用“不是……而是……”。',
          revisionRule: '先判断逻辑关系是选择、并列、因果还是纠正，再选关联词。',
          memoryTip: '“不是A，而是B”用于纠正理解；“不是A，就是B”用于二选一。',
        ),
      10 => const _GrammarSpec(
          segments: [
            '云冈融合多种传统并形成鲜明表达，',
            '这不仅塑造了自身艺术语言，而且也对后来的佛教石窟艺术受到影响',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '云冈融合多种传统并形成鲜明表达，这不仅塑造了自身艺术语言，而且也对后来的佛教石窟艺术受到影响。',
          correctedSentence: '云冈融合多种传统并形成鲜明表达，这不仅塑造了自身艺术语言，而且也影响了后来的佛教石窟艺术。',
          correctOptionId: 'correct',
          correctReplacement: '这不仅塑造了自身艺术语言，而且也影响了后来的佛教石窟艺术',
          distractors: [
            '这不仅塑造了自身艺术语言，而且也对后来的佛教石窟艺术产生受到影响',
            '这不仅塑造了自身艺术语言，而且也被后来的佛教石窟艺术影响了出去',
            '这不仅塑造了自身艺术语言，而且也使后来的佛教石窟艺术被影响受到',
          ],
          errorType: '主动与被动结构混用：“对……受到影响”搭配冲突',
          errorLocation: '“对后来的佛教石窟艺术受到影响”',
          whyWrong: '“对……”要求后面说明主体施加的作用；“受到影响”却把同一对象放在被动位置，两种结构不能这样混用。',
          revisionRule: '明确谁影响谁：主动写“影响了……”，被动写“……受到影响”。',
          memoryTip: '复杂因果句先画出施事者和受事者，再决定用主动还是被动。',
        ),
      _ => throw RangeError.range(level, 1, 10, 'level'),
    };
  }

'''
Path(panel).write_text(Path(panel).read_text().replace(anchor, block + anchor, 1))

# Keep the adaptive helper generic for all other Journeys; Datong no longer uses it.
replace_once(
    panel,
    """  static _GrammarSpec _adaptiveGrammarForJourney(
    String journeyId,
    JourneyChallengeDifficulty difficulty, {
    int? datongLevel,
  }) {
""",
    """  static _GrammarSpec _adaptiveGrammarForJourney(
    String journeyId,
    JourneyChallengeDifficulty difficulty,
  ) {
""",
)

# The old Datong context case is now unreachable; remove it to prevent future noun-swap reuse.
p = Path(panel)
text = p.read_text()
start = text.find("      'datong-yungang-grottoes' => switch (datongLevel ?? 1) {")
if start == -1:
    raise SystemExit('old Datong adaptive case not found')
end_marker = "        },\n      'literary-roaming' => ("
end = text.find(end_marker, start)
if end == -1:
    raise SystemExit('old Datong adaptive case end not found')
text = text[:start] + "      'literary-roaming' => (" + text[end + len(end_marker):]
p.write_text(text)

# Strengthen Datong runtime regression around anti-template, teach-before-test and progression.
test = 'app/test/datong_yungang_challenge_runtime_test.dart'
replace_once(
    test,
    """    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsWidgets);
    expect(find.textContaining('494年'), findsNothing);
    expect(find.textContaining('昙曜五窟'), findsNothing);
""",
    """    expect(find.textContaining('北魏定都平城后'), findsWidgets);
    expect(find.textContaining('云冈大规模后来有条件集中资源进行开凿'), findsWidgets);
    expect(find.textContaining('494年'), findsNothing);
    expect(find.textContaining('昙曜五窟'), findsNothing);
    expect(find.textContaining('通过观察'), findsNothing);
""",
)
replace_once(
    test,
    """    expect(find.textContaining('中期营造高峰与更复杂的艺术表达'), findsWidgets);
    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsNothing);
""",
    """    expect(find.textContaining('中期营造继续发展'), findsWidgets);
    expect(find.textContaining('呈现得更加丰富的表达'), findsWidgets);
    expect(find.textContaining('北魏定都平城后'), findsNothing);
    expect(find.textContaining('不但'), findsNothing);
""",
)
replace_once(
    test,
    """    expect(find.textContaining('云冈在中国与东亚佛教石窟艺术中的影响'), findsWidgets);
    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsNothing);
""",
    """    expect(find.textContaining('云冈融合多种传统并形成鲜明表达'), findsWidgets);
    expect(find.textContaining('对后来的佛教石窟艺术受到影响'), findsWidgets);
    expect(find.textContaining('北魏定都平城后'), findsNothing);
    expect(find.textContaining('由于'), findsNothing);
""",
)

# Record the human-discovered TEMPLATE defect and bounded repair.
record = 'docs/DATONG_YUNGANG_GOLD_REMEDIATION_RECORD.md'
p = Path(record)
text = p.read_text()
marker = '## Datong grammar anti-template repair'
if marker not in text:
    text += r'''

## Datong grammar anti-template repair

Human Challenge review under the newly adopted canonical contract found a `TEMPLATE` defect after the first Challenge Gold mapping: Datong `grammarRepair` had level-aware historical nouns but still reused the same three adaptive grammar-error skeletons used by other Journeys. Green static/runtime checks could not approve that content shape.

Datong now owns ten level-bound Chinese grammar repairs. The progression moves through word order, `把` construction, duplicate result conjunctions, subject completeness, verb-complement collocation, time-structure contamination, aspect, paired conjunctions, logical relation choice, and active/passive argument structure. Historical context remains taught-before-tested at the same level, but the answer depends on Chinese structure rather than historical trivia. No other Journey Challenge content is remediated in PR #186.
'''
p.write_text(text)

Path('tools/datong_challenge_gold_template_fix.py').unlink(missing_ok=True)
Path('.github/workflows/datong_challenge_gold_template_fix_once.yml').unlink(missing_ok=True)
