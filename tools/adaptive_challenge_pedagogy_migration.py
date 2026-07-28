from pathlib import Path

PANEL_PATH = Path('app/lib/widgets/journey_challenge_panel.dart')
TEST_PATH = Path('app/test/adaptive_challenge_pedagogy_test.dart')
RULE_PATH = Path('worker/adaptive_challenge_pedagogy_rule.test.mjs')

source = PANEL_PATH.read_text()

marker = 'const int journeyChallengeOptionCount = 5;\n'
helpers = r'''

@visibleForTesting
String adaptiveChallengeHint({
  required JourneyChallengeType type,
  required JourneyChallengeDifficulty difficulty,
  required int attempt,
}) {
  final secondAttempt = attempt >= 2;
  return switch (difficulty) {
    JourneyChallengeDifficulty.beginner => switch (type) {
        JourneyChallengeType.paragraphRebuild => secondAttempt
            ? '先选开头，再找最后发生的变化。'
            : '先找写地点、时间或人物出现的句子。',
        JourneyChallengeType.grammarRepair => secondAttempt
            ? '读一遍修改后的句子，看看主语和动作是否搭配。'
            : '先找主语，再看哪个词让句子变得不自然。',
        JourneyChallengeType.missingSentence => secondAttempt
            ? '正确句要能连接前一句的人物和后一句的结果。'
            : '先看前一句说的是谁，再看后一句发生了什么。',
      },
    JourneyChallengeDifficulty.standard => switch (type) {
        JourneyChallengeType.paragraphRebuild => secondAttempt
            ? '开头介绍整体，中间发生行动，最后才出现观察、决定或结果。'
            : '先找交代地点或时间的句子，再安排人物行动和最后的变化。',
        JourneyChallengeType.grammarRepair => secondAttempt
            ? '检查关联词搭配、主语位置和前后句式是否平行。'
            : '先检查句子有没有明确主语，再看动词与宾语是否自然。',
        JourneyChallengeType.missingSentence => secondAttempt
            ? '正确句必须既接住前文，又能解释后文为什么会出现。'
            : '同时观察前一句留下的主语，以及后一句出现的结果或转折。',
      },
    JourneyChallengeDifficulty.advanced => switch (type) {
        JourneyChallengeType.paragraphRebuild => secondAttempt
            ? '比较叙事视角、时间推进和因果落点，排除只在局部通顺的句子。'
            : '先建立段落骨架，再判断每句承担背景、行动、转折还是收束功能。',
        JourneyChallengeType.grammarRepair => secondAttempt
            ? '比较每个方案的句法中心、语义指向与关联结构，排除表面通顺但逻辑松动的修改。'
            : '先定位错误层级：成分、搭配、指代、语序或逻辑，再选择最小且完整的修正。',
        JourneyChallengeType.missingSentence => secondAttempt
            ? '检验候选句是否同时完成指代回接、逻辑过渡和后文铺垫。'
            : '观察前后文的主题链、时间线与因果关系，不要只凭关键词重复判断。',
      },
  };
}

@visibleForTesting
String adaptiveChallengeExplanation({
  required JourneyChallengeType type,
  required JourneyChallengeDifficulty difficulty,
  required String baseExplanation,
}) {
  return switch (difficulty) {
    JourneyChallengeDifficulty.beginner => switch (type) {
        JourneyChallengeType.paragraphRebuild =>
          '故事通常先介绍地点或人物，再写行动，最后写结果。',
        JourneyChallengeType.grammarRepair =>
          '修改后要有清楚的主语，词语也要和动作自然搭配。',
        JourneyChallengeType.missingSentence =>
          '正确句要接住前一句，并让后一句自然发生。',
      },
    JourneyChallengeDifficulty.standard => baseExplanation,
    JourneyChallengeDifficulty.advanced => switch (type) {
        JourneyChallengeType.paragraphRebuild =>
          '$baseExplanation 还要检查叙事焦点、时间推进与段落收束是否连续。',
        JourneyChallengeType.grammarRepair =>
          '$baseExplanation 判断时应同时验证句法中心、语义指向和关联结构。',
        JourneyChallengeType.missingSentence =>
          '$baseExplanation 高质量衔接还要保持主题链、指代对象和逻辑方向一致。',
      },
  };
}

@visibleForTesting
String adaptiveChallengeMemoryTip({
  required JourneyChallengeType type,
  required JourneyChallengeDifficulty difficulty,
  required String baseTip,
}) {
  return switch (difficulty) {
    JourneyChallengeDifficulty.beginner => switch (type) {
        JourneyChallengeType.paragraphRebuild => '记住：地点 → 行动 → 结果。',
        JourneyChallengeType.grammarRepair => '先找谁，再看做什么。',
        JourneyChallengeType.missingSentence => '前一句是谁，后一句为什么。',
      },
    JourneyChallengeDifficulty.standard => baseTip,
    JourneyChallengeDifficulty.advanced => switch (type) {
        JourneyChallengeType.paragraphRebuild =>
          '$baseTip 再标出每句的篇章功能。',
        JourneyChallengeType.grammarRepair =>
          '$baseTip 优先选择改动最小、结构最完整的方案。',
        JourneyChallengeType.missingSentence =>
          '$baseTip 最后反读整段，确认逻辑没有断层。',
      },
  };
}
'''

if 'String adaptiveChallengeHint({' not in source:
    if marker not in source:
        raise SystemExit('option count marker missing')
    source = source.replace(marker, marker + helpers, 1)

source = source.replace(
    "_explanationLine('为什么', _session.explanation)",
    "_explanationLine('为什么', _session.adaptiveExplanation)",
    1,
)
source = source.replace(
    "_explanationLine('记忆方法', _session.memoryTip)",
    "_explanationLine('记忆方法', _session.adaptiveMemoryTip)",
    1,
)
if '_session.adaptiveExplanation' not in source:
    raise SystemExit('adaptive explanation call missing')

method_start = source.index('  List<Widget> _grammarExplanationLines() {')
method_end = source.index('  Widget _explanationLine(', method_start)
grammar_method = r'''  List<Widget> _grammarExplanationLines() {
    final grammar = _session.grammar!;
    return switch (_session.difficulty) {
      JourneyChallengeDifficulty.beginner => [
          _explanationLine('错误位置', grammar.errorLocation),
          _explanationLine('修改后', grammar.correctedSentence),
          _explanationLine('简单规则', grammar.revisionRule),
          _explanationLine('记忆方法', grammar.memoryTip),
        ],
      JourneyChallengeDifficulty.standard => [
          _explanationLine('病句类型', grammar.errorType),
          _explanationLine('错误位置', grammar.errorLocation),
          _explanationLine('原句', grammar.originalSentence),
          _explanationLine('修改后', grammar.correctedSentence),
          _explanationLine('为什么错误', grammar.whyWrong),
          _explanationLine('修改原则', grammar.revisionRule),
          _explanationLine('记忆方法', grammar.memoryTip),
        ],
      JourneyChallengeDifficulty.advanced => [
          _explanationLine('病句类型', grammar.errorType),
          _explanationLine('错误位置', grammar.errorLocation),
          _explanationLine('原句', grammar.originalSentence),
          _explanationLine('修改后', grammar.correctedSentence),
          _explanationLine('为什么错误', grammar.whyWrong),
          _explanationLine('修改原则', grammar.revisionRule),
          _explanationLine(
            '结构分析',
            '${grammar.errorType}。${grammar.whyWrong} ${grammar.revisionRule}',
          ),
          _explanationLine('记忆方法', grammar.memoryTip),
        ],
    };
  }

'''
source = source[:method_start] + grammar_method + source[method_end:]

hint_start = source.index('  String get firstHint')
hint_end = source.index('  static _ChallengeSession _buildParagraph(', hint_start)
new_getters = r'''  String get firstHint => adaptiveChallengeHint(
    type: type,
    difficulty: difficulty,
    attempt: 1,
  );

  String get secondHint => adaptiveChallengeHint(
    type: type,
    difficulty: difficulty,
    attempt: 2,
  );

  String get adaptiveExplanation => adaptiveChallengeExplanation(
    type: type,
    difficulty: difficulty,
    baseExplanation: explanation,
  );

  String get adaptiveMemoryTip => adaptiveChallengeMemoryTip(
    type: type,
    difficulty: difficulty,
    baseTip: memoryTip,
  );

'''
source = source[:hint_start] + new_getters + source[hint_end:]
PANEL_PATH.write_text(source)

TEST_PATH.write_text(r'''import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

void main() {
  test('beginner hints are shorter and more direct', () {
    final hint = adaptiveChallengeHint(
      type: JourneyChallengeType.missingSentence,
      difficulty: JourneyChallengeDifficulty.beginner,
      attempt: 1,
    );
    final advanced = adaptiveChallengeHint(
      type: JourneyChallengeType.missingSentence,
      difficulty: JourneyChallengeDifficulty.advanced,
      attempt: 1,
    );

    expect(hint, contains('前一句'));
    expect(advanced, contains('主题链'));
    expect(advanced.length, greaterThan(hint.length));
  });

  test('standard explanation preserves authored content', () {
    const authored = '原有完整讲解';
    expect(
      adaptiveChallengeExplanation(
        type: JourneyChallengeType.paragraphRebuild,
        difficulty: JourneyChallengeDifficulty.standard,
        baseExplanation: authored,
      ),
      authored,
    );
  });

  test('advanced memory support adds an analysis action', () {
    final tip = adaptiveChallengeMemoryTip(
      type: JourneyChallengeType.grammarRepair,
      difficulty: JourneyChallengeDifficulty.advanced,
      baseTip: '检查主语',
    );
    expect(tip, contains('改动最小'));
  });
}
''')

RULE_PATH.write_text(r'''import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

const panel = readFileSync(
  'app/lib/widgets/journey_challenge_panel.dart',
  'utf8',
);

test('challenge hints and explanations adapt to all three levels', () => {
  assert.match(panel, /adaptiveChallengeHint/);
  assert.match(panel, /adaptiveChallengeExplanation/);
  assert.match(panel, /adaptiveChallengeMemoryTip/);
  assert.match(panel, /JourneyChallengeDifficulty\.beginner/);
  assert.match(panel, /JourneyChallengeDifficulty\.standard/);
  assert.match(panel, /JourneyChallengeDifficulty\.advanced/);
  assert.match(panel, /主题链/);
  assert.match(panel, /结构分析/);
});

test('adaptive pedagogy does not change attempts or rewards', () => {
  assert.match(panel, /attempts >= 3/);
  assert.match(panel, /1 => '金币'/);
  assert.match(panel, /2 => '银币'/);
  assert.match(panel, /_ => '铜币'/);
  assert.match(panel, /: '碎银'/);
});
''')
