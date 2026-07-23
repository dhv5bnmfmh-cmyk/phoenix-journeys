from pathlib import Path

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text(encoding='utf-8')
old = """                AnimatedOpacity(
                  key: const ValueKey('journey-content-opacity'),
                  duration: const Duration(milliseconds: 1600),
                  curve: Curves.easeInOutCubic,
                  opacity: immersed ? .035 : 1,
"""
new = """                AnimatedOpacity(
                  key: const ValueKey('journey-content-opacity'),
                  duration: Duration(milliseconds: immersed ? 1600 : 120),
                  curve: Curves.easeInOutCubic,
                  opacity: immersed ? .035 : 1,
"""
if journey.count(old) != 1:
    raise SystemExit(f'journey opacity anchor mismatch: {journey.count(old)}')
journey_path.write_text(journey.replace(old, new, 1), encoding='utf-8')

rule_path = Path('worker/journey_immersion_rule.test.mjs')
rule = rule_path.read_text(encoding='utf-8')
old_rule = "  assert.match(journey, /Duration\\(milliseconds: 1600\\)/);\n"
new_rule = "  assert.match(journey, /Duration\\(milliseconds: immersed \\? 1600 : 120\\)/);\n"
if rule.count(old_rule) != 1:
    raise SystemExit(f'immersion duration rule mismatch: {rule.count(old_rule)}')
rule_path.write_text(rule.replace(old_rule, new_rule, 1), encoding='utf-8')
