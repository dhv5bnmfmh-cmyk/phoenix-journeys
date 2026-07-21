from pathlib import Path

sheet_path = Path('app/lib/widgets/word_detail_sheet.dart')
sheet = sheet_path.read_text(encoding='utf-8')

getter_anchor = """  WordEntry get _entry => widget.entries[_index];
  bool get _isLast => _index == widget.entries.length - 1;
"""
getter_replacement = """  WordEntry get _entry => widget.entries[_index];
  bool get _isFirst => _index == 0;
  bool get _isLast => _index == widget.entries.length - 1;
"""
if getter_anchor not in sheet:
    raise SystemExit('Could not find word index getters.')
sheet = sheet.replace(getter_anchor, getter_replacement, 1)

method_anchor = """  Future<void> _nextWord() async {
    if (_isSpeaking) return;
    if (_isLast) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _index += 1;
      _speechUnavailable = false;
      _generatedExample = null;
    });
    unawaited(_loadExample());
    await _speak();
  }
"""
method_replacement = """  Future<void> _previousWord() async {
    if (_isSpeaking || _isFirst) return;

    setState(() {
      _index -= 1;
      _speechUnavailable = false;
      _generatedExample = null;
    });
    unawaited(_loadExample());
    await _speak();
  }

  Future<void> _nextWord() async {
    if (_isSpeaking) return;
    if (_isLast) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _index += 1;
      _speechUnavailable = false;
      _generatedExample = null;
    });
    unawaited(_loadExample());
    await _speak();
  }
"""
if method_anchor not in sheet:
    raise SystemExit('Could not find next-word method.')
sheet = sheet.replace(method_anchor, method_replacement, 1)

buttons_anchor = """              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => state.toggleSavedWord(entry.word),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(32),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                        size: 17,
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.displayText(isSaved ? '已收藏' : '收藏生词'),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      key: const ValueKey('next-word-button'),
                      onPressed: _isSpeaking ? null : _nextWord,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: PhoenixTheme.red,
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: Icon(
                        _isLast
                            ? Icons.keyboard_arrow_down
                            : Icons.arrow_forward,
                        size: 18,
                      ),
                      label: Text(
                        state.displayText(_isLast ? '完成并收起' : '下一个单词'),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
"""
buttons_replacement = """              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const ValueKey('save-word-button'),
                      onPressed: () => state.toggleSavedWord(entry.word),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                        size: 16,
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.displayText(isSaved ? '已收藏' : '收藏生词'),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 10.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const ValueKey('previous-word-button'),
                      onPressed: _isSpeaking || _isFirst ? null : _previousWord,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.displayText('上一个生词'),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 10.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: FilledButton.icon(
                      key: const ValueKey('next-word-button'),
                      onPressed: _isSpeaking ? null : _nextWord,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        backgroundColor: PhoenixTheme.red,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                      ),
                      icon: Icon(
                        _isLast
                            ? Icons.keyboard_arrow_down
                            : Icons.arrow_forward,
                        size: 16,
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          state.displayText(
                            _isLast ? '完成并收起' : '下一个单词',
                          ),
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
"""
if buttons_anchor not in sheet:
    raise SystemExit('Could not find word action row.')
sheet = sheet.replace(buttons_anchor, buttons_replacement, 1)
sheet_path.write_text(sheet, encoding='utf-8')

rule_path = Path('worker/compact_word_study.test.mjs')
rule = rule_path.read_text(encoding='utf-8')
rule_append = """

test('word detail actions keep Save Previous and Next on one row', () => {
  assert.match(sheet, /bool get _isFirst => _index == 0;/);
  assert.match(sheet, /Future<void> _previousWord\(\) async/);
  assert.match(sheet, /_index -= 1;/);
  assert.match(sheet, /key: const ValueKey\('previous-word-button'\)/);
  assert.match(
    sheet,
    /onPressed: _isSpeaking \|\| _isFirst \? null : _previousWord/,
  );

  const save = sheet.indexOf("state.displayText(isSaved ? '已收藏' : '收藏生词')");
  const previous = sheet.indexOf("state.displayText('上一个生词')");
  const next = sheet.indexOf("_isLast ? '完成并收起' : '下一个单词'");
  assert.ok(save >= 0 && save < previous && previous < next);
});
"""
if 'word detail actions keep Save Previous and Next on one row' in rule:
    raise SystemExit('Previous-word rule test already exists.')
rule_path.write_text(rule.rstrip() + rule_append, encoding='utf-8')
