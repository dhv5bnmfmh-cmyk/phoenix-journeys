from pathlib import Path

# Triggered only on the isolated feature branch; removed after successful validation.
journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text(encoding='utf-8')

method_anchor = """    await _narration.resumeFromOffset(resumeOffset);\n  }\n\n  Future<void> _prepareAgentAction(FocusNode focusNode, String message) async {\n"""
method_replacement = """    await _narration.resumeFromOffset(resumeOffset);\n  }\n\n  Future<void> _enterVocabularyAtFirstWord() async {\n    await _goToStep(1);\n    if (!mounted || step != 1 || _experience.words.isEmpty) return;\n\n    await WidgetsBinding.instance.endOfFrame;\n    if (!mounted || step != 1) return;\n\n    await _openWord(_experience.words.first);\n  }\n\n  Future<void> _prepareAgentAction(FocusNode focusNode, String message) async {\n"""
if method_anchor not in journey:
    raise SystemExit('Could not find _openWord method anchor.')
journey = journey.replace(method_anchor, method_replacement, 1)

story_anchor = """    return _page(\n      title: '故事',\n      child: Column(\n"""
story_replacement = """    return _page(\n      title: '故事',\n      onNext: () => unawaited(_enterVocabularyAtFirstWord()),\n      child: Column(\n"""
if story_anchor not in journey:
    raise SystemExit('Could not find Story page button anchor.')
journey = journey.replace(story_anchor, story_replacement, 1)
journey_path.write_text(journey, encoding='utf-8')

rule_path = Path('worker/story_discovery_vocabulary_rule.test.mjs')
rule = rule_path.read_text(encoding='utf-8')
rule_append = """

test('Story Continue enters the first vocabulary word automatically', () => {
  assert.match(journey, /Future<void> _enterVocabularyAtFirstWord\(\) async/);
  assert.match(journey, /await _goToStep\(1\);/);
  assert.match(journey, /await WidgetsBinding\.instance\.endOfFrame;/);
  assert.match(journey, /await _openWord\(_experience\.words\.first\);/);
  assert.match(
    journey,
    /onNext: \(\) => unawaited\(_enterVocabularyAtFirstWord\(\)\),/,
  );
});
"""
if 'Story Continue enters the first vocabulary word automatically' in rule:
    raise SystemExit('Rule test already exists.')
rule_path.write_text(rule.rstrip() + rule_append, encoding='utf-8')
