from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    if old not in text:
        raise SystemExit(f'anchor not found in {path}: {old[:180]!r}')
    p.write_text(text.replace(old, new, 1))


panel = 'app/lib/widgets/journey_challenge_panel.dart'

# Lv1: preserve word-order misconception, but make wrong options learner-plausible.
replace_once(
    panel,
    """          distractors: [
            '云冈后来大规模有条件把资源集中开凿',
            '云冈有条件后来集中资源被大规模开凿',
            '云冈后来集中资源有条件进行开凿大规模',
          ],
""",
    """          distractors: [
            '云冈大规模后来有条件集中资源进行开凿',
            '云冈后来大规模有条件集中资源进行开凿',
            '云冈后来有大规模条件集中资源进行开凿',
          ],
""",
)

# Lv4: keep subject-omission as the single misconception family without grotesque passive filler.
replace_once(
    panel,
    """          distractors: [
            '因此使云冈营造进入新的历史阶段',
            '让云冈营造所以进入新的历史阶段',
            '云冈营造被使进入新的历史阶段',
          ],
""",
    """          distractors: [
            '使云冈营造进入新的历史阶段',
            '因此使云冈营造进入新的历史阶段',
            '从而使云冈营造进入新的历史阶段',
          ],
""",
)

# Lv5: use plausible 得/的/地 and result-complement confusions.
replace_once(
    panel,
    """          distractors: [
            '洞窟布局与雕饰呈现着更加丰富去表达',
            '洞窟布局与雕饰呈现为更加丰富去表达',
            '洞窟布局与雕饰呈现到更加丰富的表达',
          ],
""",
    """          distractors: [
            '洞窟布局与雕饰呈现得更加丰富的表达',
            '洞窟布局与雕饰呈现的更加丰富的表达',
            '洞窟布局与雕饰呈现得出更加丰富的表达',
          ],
""",
)

# Lv6: keep the time-frame contamination plausible rather than stacking arbitrary prepositions.
replace_once(
    panel,
    """          distractors: [
            '随着494年北魏迁都洛阳以后，',
            '因为随着494年北魏迁都洛阳以后，',
            '在随着494年北魏迁都洛阳以后，',
          ],
""",
    """          distractors: [
            '随着494年北魏迁都洛阳以后，',
            '随着494年北魏迁都洛阳之后，',
            '在494年北魏随着迁都洛阳以后，',
          ],
""",
)

# Lv7: replace an artificial aspect-particle trap with a natural conjunction mismatch.
old_lv7 = """      7 => const _GrammarSpec(
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
"""
new_lv7 = """      7 => const _GrammarSpec(
          segments: [
            '尽管迁都改变了皇家营造条件，',
            '所以较小规模的造像活动仍然继续出现',
            '。',
          ],
          problemSegmentIndex: 1,
          originalSentence: '尽管迁都改变了皇家营造条件，所以较小规模的造像活动仍然继续出现。',
          correctedSentence: '尽管迁都改变了皇家营造条件，但较小规模的造像活动仍然继续出现。',
          correctOptionId: 'correct',
          correctReplacement: '但较小规模的造像活动仍然继续出现',
          distractors: [
            '所以较小规模的造像活动仍然继续出现',
            '因此较小规模的造像活动仍然继续出现',
            '因为较小规模的造像活动仍然继续出现',
          ],
          errorType: '关联关系错误：“尽管”需要转折承接而不是因果结果',
          errorLocation: '“尽管……所以……”',
          whyWrong: '“尽管”先承认一个不利条件，后半句应转折说明仍然发生的事实；“所以/因此”会把让步关系误写成因果结果。',
          revisionRule: '先判断前半句是原因还是让步条件；“尽管/虽然”通常用“但/但是/却”承接。',
          memoryTip: '看到“尽管”，先找转折，不要顺手接“所以”。',
        ),
"""
replace_once(panel, old_lv7, new_lv7)

# Lv8: retain paired-conjunction confusion but use forms a learner could actually produce.
replace_once(
    panel,
    """          distractors: [
            '既吸收多种艺术传统，而且并且与中国传统结合',
            '不但既吸收多种艺术传统，又与中国传统结合',
            '既吸收多种艺术传统，所以又与中国传统结合',
          ],
""",
    """          distractors: [
            '既吸收多种艺术传统，并且又与中国传统结合',
            '不但吸收多种艺术传统，又与中国传统结合',
            '既吸收多种艺术传统，所以与中国传统结合',
          ],
""",
)

# Lv10: preserve active/passive argument-structure diagnosis with plausible learner errors.
replace_once(
    panel,
    """          distractors: [
            '这不仅塑造了自身艺术语言，而且也对后来的佛教石窟艺术产生受到影响',
            '这不仅塑造了自身艺术语言，而且也被后来的佛教石窟艺术影响了出去',
            '这不仅塑造了自身艺术语言，而且也使后来的佛教石窟艺术被影响受到',
          ],
""",
    """          distractors: [
            '这不仅塑造了自身艺术语言，而且也对后来的佛教石窟艺术受到影响',
            '这不仅塑造了自身艺术语言，而且也被后来的佛教石窟艺术产生影响',
            '这不仅塑造了自身艺术语言，而且也对后来的佛教石窟艺术被影响',
          ],
""",
)

# Update the human-audit record to state why distractor quality was repaired before release.
record = Path('docs/DATONG_YUNGANG_GOLD_REMEDIATION_RECORD.md')
text = record.read_text()
marker = '## Datong grammar distractor quality repair'
if marker not in text:
    text += r'''

## Datong grammar distractor quality repair

A second human Challenge pass rejected several technically wrong grammar distractors because they were too mechanically malformed to be plausible learner choices. Before exact-head release, Datong grammar distractors were tightened around diagnosable Chinese misconceptions: modifier order, subject omission after a time frame, `得/的` and result-complement confusion, contaminated time frames, concession-versus-result conjunction choice, paired conjunctions, and active/passive argument structure. The keyed answer remains unique; wrong choices are wrong for a language reason rather than because they look machine-broken.
'''
record.write_text(text)

Path('tools/datong_challenge_distractor_quality_fix.py').unlink(missing_ok=True)
Path('.github/workflows/datong_challenge_distractor_quality_fix_once.yml').unlink(missing_ok=True)
