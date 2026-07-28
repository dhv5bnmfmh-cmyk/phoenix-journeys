from pathlib import Path

ROOT = Path('.')
PANEL = Path('app/lib/widgets/journey_challenge_panel.dart')


def replace_required(source: str, old: str, new: str, label: str) -> str:
    if old not in source:
        raise SystemExit(f'{label} marker missing')
    return source.replace(old, new)


panel = PANEL.read_text()
panel = replace_required(
    panel,
    'const int journeyChallengeOptionCount = 5;',
    'const int journeyChallengeOptionCount = 4;',
    'option count',
)
panel = replace_required(
    panel,
    "key: const ValueKey('challenge-five-options')",
    "key: const ValueKey('challenge-four-options')",
    'option container key',
)
panel = replace_required(panel, '五个候选句中有', '四个候选句中有', 'paragraph instruction')
panel = replace_required(panel, '从五个长度接近的修改方案中', '从四个长度接近的修改方案中', 'grammar instruction')
panel = replace_required(panel, '从五个长度接近的答案中', '从四个长度接近的答案中', 'missing instruction')
PANEL.write_text(panel)

count_test = Path('app/test/journey_challenge_option_count_test.dart')
source = count_test.read_text()
source = replace_required(source, 'exposes five candidate answers', 'exposes four candidate answers', 'count test name')
source = replace_required(source, 'expect(journeyChallengeOptionCount, 5);', 'expect(journeyChallengeOptionCount, 4);', 'count assertion')
count_test.write_text(source)

panel_test = Path('app/test/journey_challenge_panel_test.dart')
source = panel_test.read_text()
source = replace_required(source, 'start with five choices', 'start with four choices', 'widget test name')
source = replace_required(source, "ValueKey('challenge-five-options')", "ValueKey('challenge-four-options')", 'widget key')
old_extra = """      expect(
        find.byKey(const ValueKey('challenge-option-distractor-2')),
        findsOneWidget,
      );
"""
source = replace_required(source, old_extra, '', 'fifth paragraph option assertion')
panel_test.write_text(source)

balance_test = Path('app/test/challenge_option_balancer_test.dart')
source = balance_test.read_text()
source = replace_required(source, '      count: 4,', '      count: 3,', 'balancer selection count')
source = replace_required(source, 'expect(selected, hasLength(4));', 'expect(selected, hasLength(3));', 'balancer length assertion')
source = replace_required(source, 'expect(selected.toSet(), hasLength(4));', 'expect(selected.toSet(), hasLength(3));', 'balancer unique assertion')
balance_test.write_text(source)

old_rule = Path('worker/five_option_challenge_rule.test.mjs')
new_rule = Path('worker/four_option_challenge_rule.test.mjs')
rule = old_rule.read_text()
rule = replace_required(rule, 'keeps five candidate answers', 'keeps four candidate answers', 'rule title')
rule = replace_required(rule, '/journeyChallengeOptionCount = 5/', '/journeyChallengeOptionCount = 4/', 'rule count regex')
rule = rule.replace("  assert.doesNotMatch(panel, /候选答案固定为 4 个/);\n", '')
rule = rule.replace("  assert.doesNotMatch(panel, /_fourOptions/);\n", '')
rule = replace_required(rule, '/五个长度接近的修改方案/', '/四个长度接近的修改方案/', 'grammar copy rule')
rule = replace_required(rule, '/五个长度接近的答案/', '/四个长度接近的答案/', 'missing copy rule')
new_rule.write_text(rule)
old_rule.unlink()

pr118 = Path('worker/pr118_product_rules.test.mjs')
source = pr118.read_text()
source = replace_required(source, 'three sequential five-choice challenge modes', 'three sequential four-choice challenge modes', 'PR118 title')
source = replace_required(source, '/journeyChallengeOptionCount = 5/', '/journeyChallengeOptionCount = 4/', 'PR118 count')
pr118.write_text(source)

docs = Path('docs/adaptive-level-content-v2.md')
source = docs.read_text()
source = source.replace('five candidate answers', 'four candidate answers')
source = source.replace('five unique candidates', 'four unique candidates')
source = source.replace('five-option challenges', 'four-option challenges')
docs.write_text(source)

for path in [PANEL, count_test, panel_test, balance_test, new_rule, pr118, docs]:
    if not path.exists():
        raise SystemExit(f'missing output: {path}')

residual_checks = {
    PANEL: ['journeyChallengeOptionCount = 5', 'challenge-five-options', '五个候选句', '五个长度接近'],
    count_test: ['five candidate answers', 'journeyChallengeOptionCount, 5'],
    panel_test: ['five choices', 'challenge-five-options'],
    pr118: ['five-choice', 'journeyChallengeOptionCount = 5'],
    docs: ['five candidate answers', 'five unique candidates', 'five-option challenges'],
}
for path, forbidden in residual_checks.items():
    text = path.read_text()
    for value in forbidden:
        if value in text:
            raise SystemExit(f'residual {value!r} in {path}')
