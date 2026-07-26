from pathlib import Path
import re

path = Path('app/lib/widgets/journey_challenge_panel.dart')
text = path.read_text(encoding='utf-8')

paragraph_pattern = re.compile(
    r"          child: selected\.isEmpty\n"
    r"              \? Text\(.*?\n"
    r"                \),\n"
    r"        \),\n"
    r"        const SizedBox\(height: 7\),",
    re.S,
)
paragraph_replacement = """          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: selected.isEmpty
                    ? Text(
                        t('依次点击 ${_session.correctIds.length} 句，拼回短文'),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var index = 0; index < selected.length; index++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${index + 1}. ${t(selected[index].text)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  height: 1.4,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              _speakerButton(
                selected.isEmpty
                    ? '依次点击${_session.correctIds.length}句，拼回短文'
                    : selected.map((item) => item.text).join('。'),
                keyName: 'challenge-paragraph-speaker',
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),"""
text, count = paragraph_pattern.subn(paragraph_replacement, text, count=1)
if count != 1:
    raise RuntimeError(f'paragraph speaker patch failed: {count}')

grammar_marker = """      children: [
        Text(
          t('第一步 · 点击有问题的部分'),
"""
grammar_insert = """      children: [
        Container(
          key: const ValueKey('challenge-grammar-sentence'),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: .24),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: .12)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  t(grammar.originalSentence),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.2,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _speakerButton(
                grammar.originalSentence,
                keyName: 'challenge-grammar-sentence-speaker',
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Text(
          t('第一步 · 点击有问题的部分'),
"""
if grammar_marker not in text:
    raise RuntimeError('grammar speaker marker missing')
text = text.replace(grammar_marker, grammar_insert, 1)

missing_old = """          child: Text(
            _session.selectedSingleOption == null
                ? t('请选择一句放在这里')
                : t(_session.selectedSingleOption!.text),
            style: TextStyle(
              color: _session.selectedSingleOption == null
                  ? Colors.white60
                  : Colors.white,
              height: 1.4,
              fontWeight: FontWeight.w800,
            ),
          ),
"""
missing_new = """          child: Row(
            children: [
              Expanded(
                child: Text(
                  _session.selectedSingleOption == null
                      ? t('请选择一句放在这里')
                      : t(_session.selectedSingleOption!.text),
                  style: TextStyle(
                    color: _session.selectedSingleOption == null
                        ? Colors.white60
                        : Colors.white,
                    height: 1.4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _speakerButton(
                _session.selectedSingleOption?.text ?? '请选择一句放在这里',
                keyName: 'challenge-missing-slot-speaker',
              ),
            ],
          ),
"""
if missing_old not in text:
    raise RuntimeError('missing sentence speaker marker missing')
text = text.replace(missing_old, missing_new, 1)

path.write_text(text, encoding='utf-8')
