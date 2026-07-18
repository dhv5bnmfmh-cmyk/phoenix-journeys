import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';

import '../data/journey_data.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import 'word_mark.dart';

Future<void> showWordDetail(BuildContext context, WordEntry entry) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _WordDetailSheet(entry: entry),
  );
}

class _WordDetailSheet extends StatefulWidget {
  const _WordDetailSheet({required this.entry});

  final WordEntry entry;

  @override
  State<_WordDetailSheet> createState() => _WordDetailSheetState();
}

class _WordDetailSheetState extends State<_WordDetailSheet> {
  late final FlutterTts _tts;
  bool _isSpeaking = false;
  bool _speechUnavailable = false;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _tts.setStartHandler(() => _setSpeaking(true));
    _tts.setCompletionHandler(() => _setSpeaking(false));
    _tts.setCancelHandler(() => _setSpeaking(false));
    _tts.setErrorHandler((_) {
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
        _speechUnavailable = true;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_speak());
    });
  }

  void _setSpeaking(bool value) {
    if (!mounted) return;
    setState(() {
      _isSpeaking = value;
      if (value) _speechUnavailable = false;
    });
  }

  Future<void> _speak() async {
    if (mounted) {
      setState(() {
        _isSpeaking = true;
        _speechUnavailable = false;
      });
    }

    try {
      final state = context.read<AppState>();
      await _tts.stop();
      await _tts.setLanguage(state.isTraditional ? 'zh-TW' : 'zh-CN');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      final result = await _tts.speak(state.displayText(widget.entry.word));
      if (result != 1 && mounted) {
        setState(() {
          _isSpeaking = false;
          _speechUnavailable = true;
        });
      }
    } catch (error) {
      debugPrint('Unable to pronounce ${widget.entry.word}: $error');
      if (!mounted) return;
      setState(() {
        _isSpeaking = false;
        _speechUnavailable = true;
      });
    }
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isSaved = state.isWordSaved(widget.entry.word);
    final language = state.translationLanguage;
    final examples = widget.entry.studyExamples.take(3).toList(growable: false);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        18,
        2,
        18,
        22 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WordMark(word: widget.entry.word, size: 56),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.displayText(widget.entry.word),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          widget.entry.pinyin,
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: PhoenixTheme.gold.withValues(alpha: .16),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            state.displayText(widget.entry.partOfSpeech),
                            style: const TextStyle(
                              color: PhoenixTheme.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: _isSpeaking ? '正在朗读' : '重新朗读',
                    onPressed: _isSpeaking ? null : _speak,
                    iconSize: 20,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      _isSpeaking
                          ? Icons.graphic_eq
                          : Icons.volume_up_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _DefinitionCard(
                icon: Icons.menu_book_outlined,
                title: '中文释义',
                text: widget.entry.simpleChinese,
                color: PhoenixTheme.ink,
              ),
              const SizedBox(height: 7),
              _DefinitionCard(
                icon: Icons.language,
                title: 'English definition',
                text: widget.entry.englishDefinition,
                color: PhoenixTheme.ai,
              ),
              const SizedBox(height: 7),
              _DefinitionCard(
                icon: Icons.translate,
                title: widget.entry.nativeLabel(language),
                text: widget.entry.nativeDefinition(language),
                color: PhoenixTheme.translation,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    size: 18,
                    color: PhoenixTheme.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    state.displayText('三个例句'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...examples.asMap().entries.map(
                    (entry) => _ExampleCard(
                      number: entry.key + 1,
                      example: entry.value,
                      nativeLabel: widget.entry.nativeLabel(language),
                      nativeText: entry.value.nativeText(language),
                    ),
                  ),
              if (_speechUnavailable) ...[
                const SizedBox(height: 10),
                Text(
                  state.displayText(
                    '当前浏览器没有提供中文语音，请检查静音设置或换用 Safari、Chrome。',
                  ),
                  style: const TextStyle(color: Colors.black54, fontSize: 11.5),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => state.toggleSavedWord(widget.entry.word),
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                  ),
                  label: Text(
                    state.displayText(isSaved ? '已加入生词本' : '加入生词本'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefinitionCard extends StatelessWidget {
  const _DefinitionCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  state.displayText(title),
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            state.displayText(text),
            style: const TextStyle(fontSize: 13, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    required this.number,
    required this.example,
    required this.nativeLabel,
    required this.nativeText,
  });

  final int number;
  final WordExample example;
  final String nativeLabel;
  final String nativeText;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: PhoenixTheme.red.withValues(alpha: .09),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  state.displayText(example.chinese),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _ExampleLine(label: '拼音', text: example.pinyin),
          const SizedBox(height: 4),
          _ExampleLine(label: nativeLabel, text: nativeText),
          const SizedBox(height: 4),
          _ExampleLine(label: 'English', text: example.english),
        ],
      ),
    );
  }
}

class _ExampleLine extends StatelessWidget {
  const _ExampleLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(minWidth: 42, maxWidth: 96),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: PhoenixTheme.ink.withValues(alpha: .055),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            state.displayText(label),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            state.displayText(text),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 11.5,
              height: 1.32,
            ),
          ),
        ),
      ],
    );
  }
}
