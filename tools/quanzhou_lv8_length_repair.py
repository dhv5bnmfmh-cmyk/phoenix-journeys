from pathlib import Path

path = Path('app/lib/data/quanzhou_kaiyuan_gold_content.dart')
text = path.read_text(encoding='utf-8')
old = """  _QuanzhouStorySegment(\n    fromLevel: 8,\n    paragraph: 1,\n    chinese: '许宁收起钥匙，没有把弟弟推到门外，也没有说“家永远不变”。姐弟可以继续，不必靠空房作保证。',\n    vietnamese: 'Hứa Ninh cất chìa khóa, không đẩy em trai ra ngoài cánh cửa, cũng không nói “nhà sẽ mãi không đổi”. Họ vẫn có thể là chị em mà không cần một căn phòng trống làm bảo chứng.',\n    english: 'Xu Ning puts the key away. She neither pushes her brother outside the family nor promises that “home will never change.” They can remain siblings without an empty room serving as proof.',\n  ),\n"""
if text.count(old) != 1:
    raise SystemExit(f'expected one redundant Lv8 segment, found {text.count(old)}')
path.write_text(text.replace(old, '', 1), encoding='utf-8')
print('Removed one redundant Lv8 explanatory segment.')
