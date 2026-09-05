import '../models/journey_challenge.dart';
import 'journey_challenge_engine_legacy.dart' as legacy;

export 'journey_challenge_engine_legacy.dart' hide JourneyChallengeEngine;

/// Product-facing challenge adapter.
///
/// The underlying challenge engine remains shared. Forbidden City Sentence
/// Rebuild is authored here as a compact mobile learning interaction so the
/// user rebuilds one meaningful knowledge sentence without turning the task
/// into a long paragraph puzzle.
class JourneyChallengeEngine {
  const JourneyChallengeEngine();

  StoryChallengeSet build({
    required String journeyId,
    required int sessionLevel,
    required List<String> storyParagraphs,
  }) {
    final base = const legacy.JourneyChallengeEngine().build(
      journeyId: journeyId,
      sessionLevel: sessionLevel,
      storyParagraphs: storyParagraphs,
    );
    if (journeyId != _forbiddenCityJourneyId) return base;

    var rebuildIndex = 0;
    final questions = <StoryChallengeQuestion>[];
    for (final question in base.questions) {
      if (question.mode != StoryChallengeMode.sentenceRebuild) {
        questions.add(question);
        continue;
      }
      questions.add(
        _compactForbiddenCityRebuild(
          question,
          sessionLevel,
          rebuildIndex,
        ),
      );
      rebuildIndex += 1;
    }

    return StoryChallengeSet(
      journeyId: base.journeyId,
      sessionLevel: base.sessionLevel,
      questions: List<StoryChallengeQuestion>.unmodifiable(questions),
    );
  }
}

const _forbiddenCityJourneyId = 'beijing-forbidden-city';

class _ConciseRebuildBlueprint {
  const _ConciseRebuildBlueprint(this.sentence, this.chunks);

  final String sentence;
  final List<String> chunks;
}

const _forbiddenCityConciseRebuildBands = <List<_ConciseRebuildBlueprint>>[
  <_ConciseRebuildBlueprint>[
    _ConciseRebuildBlueprint(
      '午门是紫禁城南面正门',
      <String>['午门', '是', '紫禁城', '南面正门'],
    ),
    _ConciseRebuildBlueprint(
      '中轴串起紫禁城宫殿群',
      <String>['中轴', '串起', '紫禁城', '宫殿群'],
    ),
    _ConciseRebuildBlueprint(
      '乾清门连接外朝和内廷',
      <String>['乾清门', '连接', '外朝', '和内廷'],
    ),
    _ConciseRebuildBlueprint(
      '故宫博物院藏宫廷文物',
      <String>['故宫博物院', '藏', '宫廷', '文物'],
    ),
  ],
  <_ConciseRebuildBlueprint>[
    _ConciseRebuildBlueprint(
      '紫禁城中轴组织宫殿群',
      <String>['紫禁城', '中轴', '组织', '宫殿群'],
    ),
    _ConciseRebuildBlueprint(
      '午门兼有入口礼仪功能',
      <String>['午门', '兼有', '入口', '礼仪功能'],
    ),
    _ConciseRebuildBlueprint(
      '乾清门处在内外廷之间',
      <String>['乾清门', '处在', '内外廷', '之间'],
    ),
    _ConciseRebuildBlueprint(
      '故宫博物院保存古建筑',
      <String>['故宫博物院', '保存', '古建筑'],
    ),
  ],
  <_ConciseRebuildBlueprint>[
    _ConciseRebuildBlueprint(
      '中轴形成宫城空间层级',
      <String>['中轴', '形成', '宫城', '空间层级'],
    ),
    _ConciseRebuildBlueprint(
      '午门开启宫城礼仪序列',
      <String>['午门', '开启', '宫城', '礼仪序列'],
    ),
    _ConciseRebuildBlueprint(
      '乾清门是内外廷转换处',
      <String>['乾清门', '是', '内外廷', '转换处'],
    ),
    _ConciseRebuildBlueprint(
      '故宫博物院藏历代文物',
      <String>['故宫博物院', '藏', '历代', '文物'],
    ),
  ],
  <_ConciseRebuildBlueprint>[
    _ConciseRebuildBlueprint(
      '中轴秩序并不等于路线',
      <String>['中轴', '秩序', '并不等于', '路线'],
    ),
    _ConciseRebuildBlueprint(
      '午门入口不是唯一路线',
      <String>['午门', '入口', '不是', '唯一', '路线'],
    ),
    _ConciseRebuildBlueprint(
      '乾清门可汇合不同任务',
      <String>['乾清门', '可', '汇合', '不同', '任务'],
    ),
    _ConciseRebuildBlueprint(
      '故宫博物院用文物释史',
      <String>['故宫博物院', '用', '文物', '释史'],
    ),
  ],
  <_ConciseRebuildBlueprint>[
    _ConciseRebuildBlueprint(
      '中轴框架并非行动路线',
      <String>['中轴', '框架', '并非', '行动', '路线'],
    ),
    _ConciseRebuildBlueprint(
      '午门序列不是唯一答案',
      <String>['午门', '序列', '不是', '唯一', '答案'],
    ),
    _ConciseRebuildBlueprint(
      '乾清门需结合任务判断',
      <String>['乾清门', '需', '结合', '任务', '判断'],
    ),
    _ConciseRebuildBlueprint(
      '故宫博物院以证据释史',
      <String>['故宫博物院', '以', '证据', '释史'],
    ),
  ],
];

StoryChallengeQuestion _compactForbiddenCityRebuild(
  StoryChallengeQuestion source,
  int level,
  int index,
) {
  final band = ((level.clamp(1, 10).toInt() - 1) ~/ 2).clamp(0, 4);
  final authored = _forbiddenCityConciseRebuildBands[band][index];
  if (_hanCount(authored.sentence) != 10) {
    throw StateError('Forbidden City rebuild must stay exactly 10 Han characters.');
  }
  if (authored.chunks.join() != authored.sentence) {
    throw StateError('Forbidden City concise rebuild chunks must reconstruct the sentence.');
  }

  final punctuationSentence = '${authored.sentence}。';
  final tiles = _scramble(authored.chunks, index);
  final signature = source.signature;

  return StoryChallengeQuestion(
    id: source.id,
    mode: source.mode,
    sourceSentence: punctuationSentence,
    prompt: source.prompt,
    answer: authored.sentence,
    options: source.options,
    characterTiles: List<String>.unmodifiable(tiles),
    errorSegments: source.errorSegments,
    errorSegmentIndex: source.errorSegmentIndex,
    grammarFamily: source.grammarFamily,
    grammarWhyWrong: source.grammarWhyWrong,
    grammarRevisionRule: source.grammarRevisionRule,
    grammarOptionExplanations: source.grammarOptionExplanations,
    completionSegments: source.completionSegments,
    completionBlanks: source.completionBlanks,
    narrationText: punctuationSentence,
    signature: QuestionDesignSignature(
      journeyId: signature.journeyId,
      sessionLevel: signature.sessionLevel,
      mode: signature.mode,
      sourceParagraphIndex: signature.sourceParagraphIndex,
      sourceSentenceIndex: signature.sourceSentenceIndex,
      sourceHash: _hash(punctuationSentence),
      syntaxPattern: _syntax(punctuationSentence),
      operationType: signature.operationType,
      errorFamily: signature.errorFamily,
      gapType: signature.gapType,
      answerShape: '${_hanCount(authored.sentence)}字 / ${authored.chunks.length}块',
      distractorStrategy: signature.distractorStrategy,
      blankPositionPattern: signature.blankPositionPattern,
    ),
  );
}

List<String> _scramble(List<String> ordered, int index) {
  final result = List<String>.of(ordered.reversed);
  if (result.length > 2) {
    final shift = (index + 1) % result.length;
    return <String>[
      ...result.skip(shift),
      ...result.take(shift),
    ];
  }
  return result;
}

int _hanCount(String value) =>
    RegExp(r'[\u3400-\u9fff]').allMatches(value).length;

String _syntax(String sentence) {
  if (sentence.contains('把')) return '把字句';
  if (sentence.contains(RegExp(r'因为|所以|因此'))) return '因果结构';
  if (sentence.contains(RegExp(r'却|但是|而'))) return '转折结构';
  if (sentence.startsWith(RegExp(r'当|后来|随后|这时|为了'))) return '时间目的前置';
  if (sentence.contains('，')) return '复句';
  return '主谓宾';
}

String _hash(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
