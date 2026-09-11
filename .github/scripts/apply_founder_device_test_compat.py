from pathlib import Path

path = Path('app/test/founder_device_fix_v1_test.dart')
text = path.read_text()

replacements = [
    (
        '    required List<bool> feedback,\n',
        '    required List<String> feedback,\n',
        1,
    ),
    (
        '              onFeedbackAudio: (_, correct) async => feedback.add(correct),\n',
        '              onFeedbackAudio: (_, text) async => feedback.add(text),\n',
        1,
    ),
    (
        '    final feedback = <bool>[];\n',
        '    final feedback = <String>[];\n',
        3,
    ),
    (
        '    expect(feedback, <bool>[true]);\n',
        "    expect(feedback, hasLength(1));\n"
        "    expect(feedback.single, contains('正确答案：${question.answer}'));\n",
        1,
    ),
    (
        '    expect(feedback, <bool>[true, true]);\n',
        "    expect(feedback, hasLength(2));\n"
        "    expect(feedback.last, contains('正确答案：${question.answer}'));\n",
        1,
    ),
    (
        '    expect(feedback, <bool>[false]);\n',
        "    expect(feedback, hasLength(1));\n"
        "    expect(feedback.single, contains('正确答案：${question.answer}'));\n",
        1,
    ),
    (
        '    expect(feedback, <bool>[false, false]);\n',
        "    expect(feedback, hasLength(2));\n"
        "    expect(feedback.last, contains('正确答案：${question.answer}'));\n",
        1,
    ),
]

for old, new, expected in replacements:
    count = text.count(old)
    if count != expected:
        raise SystemExit(
            f'{path}: expected {expected} matches, found {count}: {old[:80]!r}'
        )
    text = text.replace(old, new)

path.write_text(text)
