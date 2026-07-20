from pathlib import Path

JOURNEY = Path('app/lib/screens/journey_screen.dart')
NARRATION = Path('app/lib/services/narration_controller.dart')
RULE = Path('worker/adaptive_story_support_audio_rule.test.mjs')


def replace_once(source: str, old: str, new: str, label: str) -> str:
    if old not in source:
        raise RuntimeError(f'missing target: {label}')
    return source.replace(old, new, 1)

journey = JOURNEY.read_text(encoding='utf-8')
if '_fitJourneyTextSize' not in journey:
    journey = replace_once(
        journey,
        "import 'dart:async';\n",
        "import 'dart:async';\nimport 'dart:math' as math;\n",
        'math import',
    )

    old_support = """  Future<void> _showReadingSupport({
    required String title,
    required String pinyin,
    required String nativeLabel,
    required String nativeText,
    required String english,
  }) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * .52;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: _ReadingSupportSheet(
              title: title,
              pinyin: pinyin,
              nativeLabel: nativeLabel,
              nativeText: nativeText,
              english: english,
            ),
          ),
        );
      },
    );
  }
"""
    new_support = """  String get _nativeSupportLanguageCode {
    return switch (_appState.translationLanguage) {
      '英语' => 'en-US',
      '中文解释' => _appState.isTraditional ? 'zh-TW' : 'zh-CN',
      _ => 'vi-VN',
    };
  }

  Future<void> _speakSupportText(
    String text, {
    required String languageCode,
  }) async {
    final spoken = await _narration.speakWord(
      text,
      languageCode: languageCode,
    );
    if (!spoken && mounted) {
      _showAgentMessage('当前设备暂时无法朗读这段文字。');
    }
  }

  Future<void> _showReadingSupport({
    required String title,
    required String pinyin,
    required String nativeLabel,
    required String nativeText,
    required String english,
  }) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final maxHeight = MediaQuery.sizeOf(sheetContext).height * .52;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: _ReadingSupportSheet(
              title: title,
              pinyin: pinyin,
              nativeLabel: nativeLabel,
              nativeText: nativeText,
              english: english,
              onSpeakNative: () => _speakSupportText(
                nativeText,
                languageCode: _nativeSupportLanguageCode,
              ),
              onSpeakEnglish: () => _speakSupportText(
                english,
                languageCode: 'en-US',
              ),
            ),
          ),
        );
      },
    );
  }

  double _fitJourneyTextSize(
    BuildContext context,
    BoxConstraints constraints,
    List<String> texts, {
    required double minSize,
    required double maxSize,
    required double lineHeight,
  }) {
    if (texts.isEmpty || !constraints.hasBoundedHeight) return minSize;

    final availableWidth =
        (constraints.maxWidth - 58).clamp(120.0, constraints.maxWidth).toDouble();
    final availableHeight = constraints.maxHeight;
    final textScaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    var low = minSize;
    var high = maxSize;

    for (var iteration = 0; iteration < 10; iteration += 1) {
      final candidate = (low + high) / 2;
      var totalHeight = 0.0;
      for (final text in texts) {
        final painter = TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: candidate,
              height: lineHeight,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: direction,
          textScaler: textScaler,
        )..layout(maxWidth: availableWidth);
        totalHeight += math.max(18, painter.height) + 6;
      }

      if (totalHeight <= availableHeight) {
        low = candidate;
      } else {
        high = candidate;
      }
    }
    return low;
  }
"""
    journey = replace_once(journey, old_support, new_support, 'reading support method')

    old_story = """          Expanded(
            child: AnimatedBuilder(
              animation: _narration,
              builder: (context, _) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _journeyContent.storyParagraphs
                        .asMap()
                        .entries
                        .map((entry) {
                          final annotation = _experience.storyAnnotations[entry.key];
                          final snapshot = _narration.highlightSnapshot;
                          final isActive =
                              snapshot?.contentId == 'story' &&
                              snapshot?.itemId == 'story-${entry.key}';
                          return _CompactTextBlock(
                            index: entry.key + 1,
                            active: isActive,
                            onSupport: () => unawaited(
                              _showReadingSupport(
                                title: '故事第 ${entry.key + 1} 段',
                                pinyin: annotation.pinyin,
                                nativeLabel: annotation.nativeLabel(language),
                                nativeText: annotation.nativeText(
                                  language,
                                  entry.value,
                                ),
                                english: annotation.english,
                              ),
                            ),
                            child: InteractiveStoryText(
                              text: entry.value,
                              entries: _experience.words,
                              narrationController: _narration,
                              highlightStart: isActive ? snapshot!.start : null,
                              highlightEnd: isActive ? snapshot!.end : null,
                              narrationContentId: 'story',
                              narrationItemId: 'story-${entry.key}',
                              style: const TextStyle(
                                fontSize: 10.8,
                                height: 1.18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
                );
              },
            ),
          ),
"""
    new_story = """          Expanded(
            child: LayoutBuilder(
              key: const ValueKey('adaptive-story-text-area'),
              builder: (context, constraints) {
                final fontSize = _fitJourneyTextSize(
                  context,
                  constraints,
                  _journeyContent.storyParagraphs,
                  minSize: 10.8,
                  maxSize: 20,
                  lineHeight: 1.22,
                );
                return AnimatedBuilder(
                  animation: _narration,
                  builder: (context, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _journeyContent.storyParagraphs
                          .asMap()
                          .entries
                          .map((entry) {
                            final annotation =
                                _experience.storyAnnotations[entry.key];
                            final snapshot = _narration.highlightSnapshot;
                            final isActive =
                                snapshot?.contentId == 'story' &&
                                snapshot?.itemId == 'story-${entry.key}';
                            return _CompactTextBlock(
                              index: entry.key + 1,
                              active: isActive,
                              onSupport: () => unawaited(
                                _showReadingSupport(
                                  title: '故事第 ${entry.key + 1} 段',
                                  pinyin: annotation.pinyin,
                                  nativeLabel: annotation.nativeLabel(language),
                                  nativeText: annotation.nativeText(
                                    language,
                                    entry.value,
                                  ),
                                  english: annotation.english,
                                ),
                              ),
                              child: InteractiveStoryText(
                                text: entry.value,
                                entries: _experience.words,
                                narrationController: _narration,
                                highlightStart:
                                    isActive ? snapshot!.start : null,
                                highlightEnd: isActive ? snapshot!.end : null,
                                narrationContentId: 'story',
                                narrationItemId: 'story-${entry.key}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  height: 1.22,
                                  fontWeight: isActive
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            );
                          })
                          .toList(growable: false),
                    );
                  },
                );
              },
            ),
          ),
"""
    journey = replace_once(journey, old_story, new_story, 'adaptive story list')

    old_discovery = """          Expanded(
            child: AnimatedBuilder(
              animation: _narration,
              builder: (context, _) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _experience.discoveries
                        .asMap()
                        .entries
                        .map((entry) {
                          final item = entry.value;
                          final snapshot = _narration.highlightSnapshot;
                          final isActive =
                              snapshot?.contentId == 'discovery' &&
                              snapshot?.itemId == 'discovery-${entry.key}';
                          return _CompactTextBlock(
                            index: entry.key + 1,
                            active: isActive,
                            onSupport: () => unawaited(
                              _showReadingSupport(
                                title: '今日发现 ${entry.key + 1}',
                                pinyin: item.pinyin,
                                nativeLabel: item.nativeLabel(language),
                                nativeText: item.nativeText(language),
                                english: item.english,
                              ),
                            ),
                            child: InteractiveStoryText(
                              text: item.text,
                              entries: _experience.words,
                              narrationController: _narration,
                              highlightStart: isActive ? snapshot!.start : null,
                              highlightEnd: isActive ? snapshot!.end : null,
                              narrationContentId: 'discovery',
                              narrationItemId: 'discovery-${entry.key}',
                              style: TextStyle(
                                fontSize: 9.9,
                                height: 1.12,
                                fontWeight: isActive
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                            ),
                          );
                        })
                        .toList(growable: false),
                  ),
                );
              },
            ),
          ),
"""
    new_discovery = """          Expanded(
            child: LayoutBuilder(
              key: const ValueKey('adaptive-discovery-text-area'),
              builder: (context, constraints) {
                final discoveryTexts = _experience.discoveries
                    .map((item) => item.text)
                    .toList(growable: false);
                final fontSize = _fitJourneyTextSize(
                  context,
                  constraints,
                  discoveryTexts,
                  minSize: 9.9,
                  maxSize: 19,
                  lineHeight: 1.2,
                );
                return AnimatedBuilder(
                  animation: _narration,
                  builder: (context, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _experience.discoveries
                          .asMap()
                          .entries
                          .map((entry) {
                            final item = entry.value;
                            final snapshot = _narration.highlightSnapshot;
                            final isActive =
                                snapshot?.contentId == 'discovery' &&
                                snapshot?.itemId == 'discovery-${entry.key}';
                            return _CompactTextBlock(
                              index: entry.key + 1,
                              active: isActive,
                              onSupport: () => unawaited(
                                _showReadingSupport(
                                  title: '今日发现 ${entry.key + 1}',
                                  pinyin: item.pinyin,
                                  nativeLabel: item.nativeLabel(language),
                                  nativeText: item.nativeText(language),
                                  english: item.english,
                                ),
                              ),
                              child: InteractiveStoryText(
                                text: item.text,
                                entries: _experience.words,
                                narrationController: _narration,
                                highlightStart:
                                    isActive ? snapshot!.start : null,
                                highlightEnd: isActive ? snapshot!.end : null,
                                narrationContentId: 'discovery',
                                narrationItemId: 'discovery-${entry.key}',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  height: 1.2,
                                  fontWeight: isActive
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            );
                          })
                          .toList(growable: false),
                    );
                  },
                );
              },
            ),
          ),
"""
    journey = replace_once(
        journey,
        old_discovery,
        new_discovery,
        'adaptive discovery list',
    )

    old_sheet = """class _ReadingSupportSheet extends StatelessWidget {
  const _ReadingSupportSheet({
    required this.title,
    required this.pinyin,
    required this.nativeLabel,
    required this.nativeText,
    required this.english,
  });

  final String title;
  final String pinyin;
  final String nativeLabel;
  final String nativeText;
  final String english;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        _SupportLine(label: '拼音', text: pinyin, color: PhoenixTheme.red),
        const SizedBox(height: 5),
        _SupportLine(
          label: nativeLabel,
          text: nativeText,
          color: PhoenixTheme.translation,
        ),
        const SizedBox(height: 5),
        _SupportLine(label: 'English', text: english, color: PhoenixTheme.ai),
      ],
    );
  }
}

class _SupportLine extends StatelessWidget {
  const _SupportLine({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 7, 9, 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(text, style: const TextStyle(fontSize: 11.5, height: 1.28)),
        ],
      ),
    );
  }
}
"""
    new_sheet = """class _ReadingSupportSheet extends StatelessWidget {
  const _ReadingSupportSheet({
    required this.title,
    required this.pinyin,
    required this.nativeLabel,
    required this.nativeText,
    required this.english,
    required this.onSpeakNative,
    required this.onSpeakEnglish,
  });

  final String title;
  final String pinyin;
  final String nativeLabel;
  final String nativeText;
  final String english;
  final Future<void> Function() onSpeakNative;
  final Future<void> Function() onSpeakEnglish;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        _SupportLine(label: '拼音', text: pinyin, color: PhoenixTheme.red),
        const SizedBox(height: 5),
        _SupportLine(
          key: const ValueKey('support-native-audio'),
          label: nativeLabel,
          text: nativeText,
          color: PhoenixTheme.translation,
          onSpeak: onSpeakNative,
        ),
        const SizedBox(height: 5),
        _SupportLine(
          key: const ValueKey('support-english-audio'),
          label: 'English',
          text: english,
          color: PhoenixTheme.ai,
          onSpeak: onSpeakEnglish,
        ),
      ],
    );
  }
}

class _SupportLine extends StatelessWidget {
  const _SupportLine({
    required this.label,
    required this.text,
    required this.color,
    this.onSpeak,
    super.key,
  });

  final String label;
  final String text;
  final Color color;
  final Future<void> Function()? onSpeak;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(9, 5, 5, 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (onSpeak != null)
                IconButton(
                  tooltip: '朗读 $label',
                  onPressed: () => unawaited(onSpeak!()),
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints.tightFor(
                    width: 30,
                    height: 30,
                  ),
                  icon: Icon(
                    Icons.volume_up_rounded,
                    size: 18,
                    color: color,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 1),
          Text(text, style: const TextStyle(fontSize: 11.5, height: 1.28)),
        ],
      ),
    );
  }
}
"""
    journey = replace_once(journey, old_sheet, new_sheet, 'support audio controls')
    JOURNEY.write_text(journey, encoding='utf-8')

narration = NARRATION.read_text(encoding='utf-8')
if "requestedPrefix" not in narration:
    old_voice = """        for (final dynamic rawVoice in availableVoices) {
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
"""
    new_voice = """        final requestedPrefix =
            languageCode.toLowerCase().split(RegExp('[-_]')).first;
        for (final dynamic rawVoice in availableVoices) {
          if (rawVoice is! Map) continue;
          final name = '${rawVoice['name'] ?? ''}';
          final locale = '${rawVoice['locale'] ?? rawVoice['language'] ?? ''}';
          final lowerName = name.toLowerCase();
          final lowerLocale = locale.toLowerCase();
          if (!lowerLocale.startsWith(requestedPrefix)) continue;

          var score = 10;
          if (lowerLocale == languageCode.toLowerCase()) score += 80;
          if (lowerName.contains('natural')) score += 60;
          if (lowerName.contains('premium')) score += 50;
          if (lowerName.contains('enhanced')) score += 45;
          if (requestedPrefix == 'zh') {
            for (final preferredName in const [
              'xiaoxiao',
              'tingting',
              'meijia',
              'yunxi',
              'sinji',
            ]) {
              if (lowerName.contains(preferredName)) score += 35;
            }
          }
"""
    narration = replace_once(
        narration,
        old_voice,
        new_voice,
        'multilingual voice selection',
    )
    NARRATION.write_text(narration, encoding='utf-8')

RULE.write_text("""import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const journey = readFileSync('app/lib/screens/journey_screen.dart', 'utf8');
const narration = readFileSync('app/lib/services/narration_controller.dart', 'utf8');

test('Story and Discovery fit their text to the available phone height', () => {
  assert.match(journey, /_fitJourneyTextSize/);
  assert.match(journey, /adaptive-story-text-area/);
  assert.match(journey, /adaptive-discovery-text-area/);
  assert.match(journey, /TextPainter/);
  assert.match(journey, /MainAxisAlignment\.spaceBetween/);
  assert.match(journey, /maxSize: 20/);
  assert.match(journey, /maxSize: 19/);
});

test('reading notes expose native-language and English speakers', () => {
  assert.match(journey, /support-native-audio/);
  assert.match(journey, /support-english-audio/);
  assert.match(journey, /Icons\.volume_up_rounded/);
  assert.match(journey, /onSpeakNative/);
  assert.match(journey, /onSpeakEnglish/);
  assert.match(journey, /languageCode: 'en-US'/);
  assert.match(journey, /'越南语'[\s\S]*'vi-VN'/);
});

test('narration selects voices for Vietnamese and English as well as Chinese', () => {
  assert.match(narration, /requestedPrefix/);
  assert.match(narration, /lowerLocale\.startsWith\(requestedPrefix\)/);
  assert.doesNotMatch(narration, /lowerLocale\.startsWith\('zh'\)/);
});
""", encoding='utf-8')
