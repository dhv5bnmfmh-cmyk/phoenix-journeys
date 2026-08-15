from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{path}: expected exactly one target, found {count}')
    p.write_text(text.replace(old, new, 1))


replace_once(
    'app/lib/data/daily_journey_catalog.dart',
    "import 'journey_expansion_catalog.dart';",
    "import 'journey_expansion_catalog.dart' hide quanzhouKaiyuanJourney;",
)

replace_once(
    'app/lib/data/quanzhou_kaiyuan_gold_content.dart',
    """  _QuanzhouStorySegment(
    fromLevel: 10,
    paragraph: 1,
    chinese: '人声从戒坛方向传来，许安没有回头确认姐姐还在不在。空下来的腰间没有给他新的保证，只留下下一次回来必须先敲门的事实。',
    vietnamese: 'Tiếng người vọng từ phía giới đàn. Hứa An không quay lại để xác nhận chị còn đứng đó hay không. Khoảng trống bên hông không cho anh một bảo đảm mới; nó chỉ để lại sự thật rằng lần sau trở về, anh phải gõ cửa trước.',
    english: 'Voices carry from the ordination platform. Xu An does not turn to check whether his sister is still there. The empty place at his waist gives him no new guarantee; it leaves only the fact that next time he returns, he must knock first.',
  ),
""",
    "",
)
