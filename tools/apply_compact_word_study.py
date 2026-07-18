from pathlib import Path
import re

word_sheet = Path('app/lib/widgets/word_detail_sheet.dart')
word_sheet.write_text(r'''import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import 'word_mark.dart';

Future<void> showWordDetail(
  BuildContext context,
  WordEntry entry, {
  required Future<bool> Function() onSpeak,
  List<WordEntry>? entries,
  int? initialIndex,
  Future<bool> Function(WordEntry entry)? onSpeakEntry,
}) {
  final studyEntries = entries == null || entries.isEmpty
      ? <WordEntry>[entry]
      : List<WordEntry>.unmodifiable(entries);
  final matchingIndex = studyEntries.indexWhere(
    (candidate) => candidate.word == entry.word,
  );
  final requestedIndex = initialIndex ?? matchingIndex;
  final safeIndex = requestedIndex < 0
      ? 0
      : requestedIndex.clamp(0, studyEntries.length - 1);

  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => FractionallySizedBox(
      heightFactor: .88,
      child: _WordDetailSheet(
        entries: studyEntries,
        initialIndex: safeIndex,
        onSpeak: onSpeak,
        onSpeakEntry: onSpeakEntry,
      ),
    ),
  );
}

class _WordDetailSheet extends StatefulWidget {
  const _WordDetailSheet({
    required this.entries,
    required this.initialIndex,
    required this.onSpeak,
    required this.onSpeakEntry,
  });

  final List<WordEntry> entries;
  final int initialIndex;
  final Future<bool> Function() onSpeak;
  final Future<bool> Function(WordEntry entry)? onSpeakEntry;

  @override
  State<_WordDetailSheet> createState() => _WordDetailSheetState();
}

class _WordDetailSheetState extends State<_WordDetailSheet> {
  late int _index;
  bool _isSpeaking = false;
  bool _speechUnavailable = false;

  WordEntry get _entry => widget.entries[_index];
  bool get _isLast => _index == widget.entries.length - 1;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_speak());
    });
  }

  Future<void> _speak() async {
    if (_isSpeaking) return;
    setState(() {
      _isSpeaking = true;
      _speechUnavailable = false;
    });

    final callback = widget.onSpeakEntry;
    final success = callback == null
        ? await widget.onSpeak()
        : await callback(_entry);
    if (!mounted) return;
    setState(() {
      _isSpeaking = false;
      _speechUnavailable = !success;
    });
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
    });
    await _speak();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final entry = _entry;
    final isSaved = state.isWordSaved(entry.word);
    final language = state.translationLanguage;
    final example = entry.studyExamples.isEmpty ? null : entry.studyExamples.first;
    final compact = MediaQuery.sizeOf(context).height < 720;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        14,
        0,
        14,
        10 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              Row(
                children: [
                  WordMark(word: entry.word, size: compact ? 40 : 46),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.displayText(entry.word),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: compact ? 21 : 24,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              '${_index + 1} / ${widget.entries.length}',
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.pinyin,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          state.displayText(entry.partOfSpeech),
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    tooltip: _isSpeaking ? '正在朗读' : '重新朗读',
                    onPressed: _isSpeaking ? null : _speak,
                    visualDensity: VisualDensity.compact,
                    iconSize: 19,
                    icon: Icon(
                      _isSpeaking ? Icons.graphic_eq : Icons.volume_up_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  value: (_index + 1) / widget.entries.length,
                  color: PhoenixTheme.red,
                  backgroundColor: PhoenixTheme.gold.withValues(alpha: .18),
                ),
              ),
              const SizedBox(height: 7),
              _CompactDefinitionLine(
                label: '中文',
                text: entry.simpleChinese,
                color: PhoenixTheme.ink,
              ),
              const SizedBox(height: 4),
              _CompactDefinitionLine(
                label: 'English',
                text: entry.englishDefinition,
                color: PhoenixTheme.ai,
              ),
              const SizedBox(height: 4),
              _CompactDefinitionLine(
                label: entry.nativeLabel(language),
                text: entry.nativeDefinition(language),
                color: PhoenixTheme.translation,
              ),
              const SizedBox(height: 7),
              Expanded(
                child: _CoreExampleCard(
                  example: example,
                  nativeLabel: entry.nativeLabel(language),
                  nativeText: example?.nativeText(language) ?? '',
                  compact: compact,
                ),
              ),
              if (_speechUnavailable) ...[
                const SizedBox(height: 4),
                Text(
                  state.displayText('当前浏览器没有提供中文语音，请检查静音设置。'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54, fontSize: 9.5),
                ),
              ],
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => state.toggleSavedWord(entry.word),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                        size: 17,
                      ),
                      label: Text(
                        state.displayText(isSaved ? '已收藏' : '收藏生词'),
                        style: const TextStyle(fontSize: 11),
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
                        _isLast ? Icons.keyboard_arrow_down : Icons.arrow_forward,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactDefinitionLine extends StatelessWidget {
  const _CompactDefinitionLine({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .065),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 54,
            child: Text(
              state.displayText(label),
              style: TextStyle(
                color: color,
                fontSize: 9.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            child: Text(
              state.displayText(text),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11.2, height: 1.18),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoreExampleCard extends StatelessWidget {
  const _CoreExampleCard({
    required this.example,
    required this.nativeLabel,
    required this.nativeText,
    required this.compact,
  });

  final WordExample? example;
  final String nativeLabel;
  final String nativeText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (example == null) {
      return const Center(
        child: Text('暂无例句', style: TextStyle(color: Colors.black45)),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 8 : 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '核心例句',
            style: TextStyle(
              color: PhoenixTheme.red,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            state.displayText(example!.chinese),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 12 : 13,
              height: 1.18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          _CompactExampleLine(label: '拼音', text: example!.pinyin),
          const SizedBox(height: 2),
          _CompactExampleLine(label: nativeLabel, text: nativeText),
          const SizedBox(height: 2),
          _CompactExampleLine(label: 'English', text: example!.english),
        ],
      ),
    );
  }
}

class _CompactExampleLine extends StatelessWidget {
  const _CompactExampleLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 54,
          child: Text(
            state.displayText(label),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: Text(
            state.displayText(text),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9.8, height: 1.15),
          ),
        ),
      ],
    );
  }
}
''')

journey_path = Path('app/lib/screens/journey_screen.dart')
journey = journey_path.read_text()
old_call = '''    await showWordDetail(
      context,
      entry,
      onSpeak: () => _narration.speakWord(
        _appState.displayText(entry.word),
        languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      ),
    );'''
new_call = '''    final initialIndex = words.indexWhere((item) => item.word == entry.word);
    await showWordDetail(
      context,
      entry,
      entries: words,
      initialIndex: initialIndex < 0 ? 0 : initialIndex,
      onSpeak: () => _narration.speakWord(
        _appState.displayText(entry.word),
        languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      ),
      onSpeakEntry: (currentEntry) => _narration.speakWord(
        _appState.displayText(currentEntry.word),
        languageCode: _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      ),
    );'''
if old_call not in journey:
    raise SystemExit('showWordDetail call not found')
journey = journey.replace(old_call, new_call, 1)

start = journey.index('  Widget _discoveryPage() {')
end = journey.index('  Widget _wonderPage() {', start)
discovery = journey[start:end]
discovery = discovery.replace(
    '''                        return Expanded(
                          child: _CompactTextBlock(''',
    '''                        return _CompactTextBlock(''',
)
discovery = discovery.replace(
    '''                            ),
                          ),
                        );''',
    '''                            ),
                        );''',
)
discovery = discovery.replace('fontSize: 10.8,', 'fontSize: 10.2,')
discovery = discovery.replace('height: 1.2,', 'height: 1.15,')
if 'return Expanded(\n                          child: _CompactTextBlock(' in discovery:
    raise SystemExit('Discovery still uses equal-height Expanded cards')
journey = journey[:start] + discovery + journey[end:]
journey_path.write_text(journey)

controller_path = Path('app/lib/services/narration_controller.dart')
controller = controller_path.read_text()
controller = controller.replace(
    '''  static const speedOptions = <NarrationSpeedOption>[
    NarrationSpeedOption(label: '0.8×', rate: .32),
    NarrationSpeedOption(label: '1.0×', rate: .40),
    NarrationSpeedOption(label: '1.2×', rate: .48),
    NarrationSpeedOption(label: '1.5×', rate: .60),
  ];''',
    '''  static const speedOptions = <NarrationSpeedOption>[
    NarrationSpeedOption(label: '0.8×', rate: .29),
    NarrationSpeedOption(label: '1.0×', rate: .36),
    NarrationSpeedOption(label: '1.2×', rate: .44),
    NarrationSpeedOption(label: '1.5×', rate: .54),
  ];''',
)
controller = controller.replace('  double _speechRate = .40;', '  double _speechRate = .36;')
controller = controller.replace(
    '  Completer<bool>? _wordSpeechCompleter;\n',
    '  Completer<bool>? _wordSpeechCompleter;\n  String? _configuredVoiceLanguage;\n',
    1,
)
controller = controller.replace('(_speechRate / .40)', '(_speechRate / .36)')

voice_method = r'''  Future<void> _configureNaturalVoice(String languageCode) async {
    await _tts.setLanguage(languageCode);
    if (_configuredVoiceLanguage == languageCode) return;

    try {
      final dynamic availableVoices = await _tts.getVoices;
      if (availableVoices is List) {
        Map<String, String>? bestVoice;
        var bestScore = -1;
        for (final dynamic rawVoice in availableVoices) {
          if (rawVoice is! Map) continue;
          final name = '${rawVoice['name'] ?? ''}';
          final locale = '${rawVoice['locale'] ?? rawVoice['language'] ?? ''}';
          final lowerName = name.toLowerCase();
          final lowerLocale = locale.toLowerCase();
          if (!lowerLocale.startsWith('zh')) continue;

          var score = 10;
          if (lowerLocale == languageCode.toLowerCase()) score += 80;
          if (lowerName.contains('natural')) score += 60;
          if (lowerName.contains('premium')) score += 50;
          if (lowerName.contains('enhanced')) score += 45;
          for (final preferredName in const [
            'xiaoxiao',
            'tingting',
            'meijia',
            'yunxi',
            'sinji',
          ]) {
            if (lowerName.contains(preferredName)) score += 35;
          }

          if (score > bestScore && name.isNotEmpty && locale.isNotEmpty) {
            bestScore = score;
            bestVoice = <String, String>{'name': name, 'locale': locale};
          }
        }
        if (bestVoice != null) await _tts.setVoice(bestVoice);
      }
    } catch (error) {
      debugPrint('Natural Chinese voice selection unavailable: $error');
    }

    _configuredVoiceLanguage = languageCode;
  }

'''
marker = '  Future<void> _speakFrom(int offset, {bool stopEngineFirst = true}) async {'
if voice_method not in controller:
    if marker not in controller:
        raise SystemExit('_speakFrom marker not found')
    controller = controller.replace(marker, voice_method + marker, 1)
controller = controller.replace(
    '''      await _tts.setLanguage('zh-CN');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(1.0);''',
    '''      await _configureNaturalVoice('zh-CN');
      await _tts.setSpeechRate(_speechRate);
      await _tts.setPitch(.98);''',
    1,
)
controller = controller.replace(
    '''      await _tts.setLanguage(languageCode);
      await _tts.setSpeechRate(.42);
      await _tts.setPitch(1.0);''',
    '''      await _configureNaturalVoice(languageCode);
      await _tts.setSpeechRate(.38);
      await _tts.setPitch(.98);''',
    1,
)
controller_path.write_text(controller)

player_path = Path('app/lib/widgets/narration_player_card.dart')
player = player_path.read_text().replace(
    '(widget.controller.speechRate / .40)',
    '(widget.controller.speechRate / .36)',
)
player_path.write_text(player)

test_path = Path('worker/compact_word_study.test.mjs')
test_path.write_text(r'''import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const sheet = readFileSync('app/lib/widgets/word_detail_sheet.dart', 'utf8');
const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync(
  'app/lib/services/narration_controller.dart',
  'utf8',
);

test('word study sheet fits one viewport and advances through the list', () => {
  assert.match(sheet, /FractionallySizedBox\([\s\S]*heightFactor: \.88/);
  assert.doesNotMatch(sheet, /SingleChildScrollView/);
  assert.match(sheet, /下一个单词/);
  assert.match(sheet, /完成并收起/);
  assert.match(sheet, /if \(_isLast\) \{[\s\S]*Navigator\.of\(context\)\.pop/);
  assert.match(journey, /entries: words/);
  assert.match(journey, /onSpeakEntry:/);
});

test('Discovery cards follow text height instead of equal-height expansion', () => {
  const start = journey.indexOf('Widget _discoveryPage()');
  const end = journey.indexOf('Widget _wonderPage()', start);
  const discovery = journey.slice(start, end);
  assert.doesNotMatch(discovery, /return Expanded\([\s\S]*_CompactTextBlock/);
  assert.match(discovery, /fontSize: 10\.2/);
  assert.match(discovery, /height: 1\.15/);
});

test('narration uses a natural Chinese voice profile when available', () => {
  assert.match(narration, /getVoices/);
  assert.match(narration, /natural/);
  assert.match(narration, /premium/);
  assert.match(narration, /NarrationSpeedOption\(label: '1\.0×', rate: \.36\)/);
  assert.match(narration, /setPitch\(\.98\)/);
});
''')
