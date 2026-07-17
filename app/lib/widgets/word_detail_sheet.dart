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
      await _tts.stop();
      await _tts.setLanguage('zh-CN');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      final result = await _tts.speak(widget.entry.word);
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
        22,
        4,
        22,
        24 + MediaQuery.viewInsetsOf(context).bottom,
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
                  WordMark(word: widget.entry.word, size: 64),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.entry.word,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.entry.pinyin,
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: PhoenixTheme.gold.withValues(alpha: .16),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            widget.entry.partOfSpeech,
                            style: const TextStyle(
                              color: PhoenixTheme.red,
                              fontSize: 11,
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
                    icon: Icon(
                      _isSpeaking
                          ? Icons.graphic_eq
                          : Icons.volume_up_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _DefinitionCard(
                icon: Icons.menu_book_outlined,
                title: '中文释义',
                text: widget.entry.simpleChinese,
                color: PhoenixTheme.ink,
              ),
              const SizedBox(height: 10),
              _DefinitionCard(
                icon: Icons.language,
                title: 'English definition',
                text: widget.entry.englishDefinition,
                color: PhoenixTheme.ai,
              ),
              const SizedBox(height: 10),
              _DefinitionCard(
                icon: Icons.translate,
                title: widget.entry.nativeLabel(language),
                text: widget.entry.nativeDefinition(language),
                color: PhoenixTheme.translation,
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    size: 20,
                    color: PhoenixTheme.red,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '三个例句',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...examples.asMap().entries.map(
                    (entry) => _ExampleCard(
                      number: entry.key + 1,
                      example: entry.value,
                      nativeLabel: widget.entry.nativeLabel(language),
                      nativeText: entry.value.nativeText(language),
                    ),
                  ),
              if (_speechUnavailable) ...[
                const SizedBox(height: 12),
                const Text(
                  '当前浏览器没有提供中文语音，请检查静音设置或换用 Safari、Chrome。',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _speak,
                      icon: const Icon(Icons.volume_up_outlined),
                      label: const Text('再听一次'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => state.toggleSavedWord(widget.entry.word),
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                      ),
                      label: Text(isSaved ? '已加入生词本' : '加入生词本'),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(text, style: const TextStyle(height: 1.5)),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: PhoenixTheme.gold.withValues(alpha: .22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: PhoenixTheme.red.withValues(alpha: .09),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: PhoenixTheme.red,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  example.chinese,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _ExampleLine(label: '拼音', text: example.pinyin),
          const SizedBox(height: 7),
          _ExampleLine(label: nativeLabel, text: nativeText),
          const SizedBox(height: 7),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12.5,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
