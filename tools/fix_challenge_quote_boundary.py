from pathlib import Path

runtime = Path('app/lib/widgets/journey_challenge_panel.dart')
text = runtime.read_text(encoding='utf-8')
old = "        if (!RegExp(r'[。！？!?]$').hasMatch(value)) value = '$value。';\n"
new = "        if (!RegExp(r'[。！？!?][”’\\\"」』）》】]*$').hasMatch(value)) {\n          value = '$value。';\n        }\n"
if text.count(old) != 1:
    raise SystemExit(f'quote boundary runtime anchor expected 1, found {text.count(old)}')
runtime.write_text(text.replace(old, new, 1), encoding='utf-8')

snapshot = Path('app/test/all_gold_challenge_runtime_snapshot_test.dart')
text = snapshot.read_text(encoding='utf-8')
old = "    expect(rows.length, approvedIds.length * 10 * 3);\n"
new = """    expect(rows.length, approvedIds.length * 10 * 3);
    for (final row in rows) {
      final visible = <String>[
        if (row['correctAnswer'] case final String value) value,
        for (final value in (row['options'] as List<String>)) value,
      ];
      for (final value in visible) {
        expect(
          value.contains('。”。') || value.contains('！”。') || value.contains('？”。'),
          isFalse,
          reason: '${row['journeyId']} Lv${row['level']} ${row['mode']} duplicated quote punctuation: $value',
        );
      }
    }
"""
if text.count(old) != 1:
    raise SystemExit(f'snapshot invariant anchor expected 1, found {text.count(old)}')
snapshot.write_text(text.replace(old, new, 1), encoding='utf-8')
print('fixed quoted Story sentence boundary and added runtime regression invariant')
