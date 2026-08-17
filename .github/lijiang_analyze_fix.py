from pathlib import Path

# Remove legacy inactive Lijiang tourism seed constants now that the active product
# has a dedicated Gold source. This also makes legacy contamination structurally impossible.
p = Path('app/lib/data/journey_expansion_batch_two.dart')
text = p.read_text()
start = text.index('const _lijiangParagraphs = <String>[')
end = text.index('\nfinal datongYungangJourney = _record(', start)
text = text[:start] + text[end + 1:]
p.write_text(text)

# Immutable vocabulary is canonical content, so make the collection const instead of
# emitting one lint per WordEntry construction.
p = Path('app/lib/data/lijiang_old_town_gold_content.dart')
text = p.read_text()
old = 'final lijiangOldTownWords = <WordEntry>['
new = 'const lijiangOldTownWords = <WordEntry>['
if old not in text:
    raise SystemExit('Lijiang vocabulary declaration marker missing')
p.write_text(text.replace(old, new, 1))

# Use a set literal for the uniqueness assertion.
p = Path('app/test/lijiang_old_town_gold_test.dart')
text = p.read_text()
old = '<String>[grammar.correctReplacement, ...grammar.distractors].toSet(),'
new = '<String>{grammar.correctReplacement, ...grammar.distractors},'
if old not in text:
    raise SystemExit('challenge set marker missing')
p.write_text(text.replace(old, new, 1))
