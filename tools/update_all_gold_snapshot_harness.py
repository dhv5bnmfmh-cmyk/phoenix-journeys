from pathlib import Path

path = Path('app/test/all_gold_challenge_runtime_snapshot_test.dart')
text = path.read_text(encoding='utf-8')

text = text.replace(
    "import 'package:phoenix_journeys/data/forbidden_city_challenge_package.dart';\n",
    '',
    1,
)
old = '''Future<void> _completeParagraph(
  WidgetTester tester, {
  required String journeyId,
  required int level,
}) async {
  if (journeyId == 'beijing-forbidden-city') {
    final record = forbiddenCityParagraphRebuild.singleWhere(
      (entry) => entry.level == level,
    );
    for (final index in record.correctOrder) {
      await _tap(tester, 'challenge-option-story-$index');
    }
  } else {
    for (var index = 0; index < 4; index++) {
      final key = 'challenge-option-correct-$index';
      if (_key(key).evaluate().isNotEmpty) await _tap(tester, key);
    }
  }
  await _tap(tester, 'challenge-submit');
  expect(_key('challenge-explanation-dialog'), findsOneWidget);
}
'''
new = '''Future<void> _completeParagraph(
  WidgetTester tester, {
  required String journeyId,
  required int level,
}) async {
  for (var index = 0; index < 4; index++) {
    final key = 'challenge-option-correct-$index';
    if (_key(key).evaluate().isNotEmpty) await _tap(tester, key);
  }
  await _tap(tester, 'challenge-submit');
  expect(_key('challenge-explanation-dialog'), findsOneWidget);
}
'''
if text.count(old) != 1:
    raise SystemExit('snapshot paragraph harness anchor mismatch')
text = text.replace(old, new, 1)
path.write_text(text, encoding='utf-8')
print('updated all-Gold snapshot harness for current runtime option IDs')
