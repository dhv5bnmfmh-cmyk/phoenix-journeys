from pathlib import Path
import re

path = Path('app/lib/data/pingyao_ancient_city_challenge_profile.dart')
text = path.read_text()
pattern = r"""    GoldChallengeGrammarSpec\(
      targetId:'pingyao-who-must-leave',
.*?      misconception:'把“既”放到判断动词之后，破坏并列对称',
    \),"""
replacement = """    GoldChallengeGrammarSpec(
      targetId:'pingyao-who-must-leave',
      prefix:'Lv8 Story 中，',
      brokenSegment:'票号把信任没有变成抽象口号，而是把它分配给柜台、账本、分号和凭证',
      suffix:'。',
      correctReplacement:'票号没有把信任变成抽象口号，而是把它分配给柜台、账本、分号和凭证',
      distractors:<String>['票号没有信任把变成抽象口号，而是把它分配给柜台、账本、分号和凭证','票号没有把信任变成抽象口号，把它而是分配给柜台、账本、分号和凭证','票号把信任没有变成抽象口号，而是把它分配给柜台、账本、分号和凭证'],
      errorType:'“没有把……而是把……”对比结构',
      whyWrong:'Lv8 Story 已明确写出“票号没有把信任变成抽象口号，而是把它分配给柜台、账本、分号和凭证”；两个“把”字结构分别承载被否定与被肯定的处理方式。',
      revisionRule:'对比“没有采用 A，而是采用 B”时，保持“没有 + 把字结构，而是 + 把字结构”的范围与并列关系清楚。',
      memoryTip:'没有把 A 变成 B，而是把 A 分配给 C。',
      misconception:'把“没有”塞到把字结构内部，破坏否定范围与前后对比',
    ),"""
updated, count = re.subn(pattern, lambda _: replacement, text, count=1, flags=re.S)
if count != 1:
    raise SystemExit(f'expected one Lv8 grammar match, found {count}')
path.write_text(updated)
