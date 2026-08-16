from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    if old not in text:
        raise SystemExit(f'anchor not found in {path}: {old[:100]!r}')
    p.write_text(text.replace(old, new, 1))


def append_once(path: str, marker: str, block: str) -> None:
    p = Path(path)
    text = p.read_text()
    if marker in text:
        return
    if not text.endswith('\n'):
        text += '\n'
    p.write_text(text + '\n' + block.strip() + '\n')

# ---------------------------------------------------------------------------
# Canonical Challenge Gold governance. Detailed semantics live in the
# Six-Stage Standard; other standards point to it rather than duplicating it.
# ---------------------------------------------------------------------------
six = 'docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md'
replace_once(six, '**System:** Phoenix Product Standard System v1.1', '**System:** Phoenix Product Standard System v1.2')
replace_once(
    six,
    "- Reward quantity, wallet rules, and idempotency remain governed by the existing approved Reward system.\n\n## 4. Story requirements",
    """- Reward quantity, wallet rules, and idempotency remain governed by the existing approved Reward system.\n\n### 3.1 Phoenix Challenge Gold quality contract\n\nChallenge is a **verification and reorganization layer**, not a warehouse for new teaching. Its canonical chain is:\n\n> **TAUGHT CONTENT → CLEAR LEARNING INTENT → FAIR QUESTION → PLAUSIBLE DISTRACTORS → ONE DEFENSIBLE ANSWER → DIAGNOSABLE MISUNDERSTANDING → LEVEL-APPROPRIATE REASONING → STORY + LANGUAGE + CULTURE REINFORCEMENT**\n\nEvery active Challenge item MUST satisfy all of the following:\n\n1. **TEACH BEFORE TEST.** Any historical fact, cultural concept, Story relationship/turn, or language structure necessary for the answer MUST already be taught in the current or an earlier level through active Story, Vocabulary, or Discovery. Synthesis and inference are allowed; untaught core knowledge is not.\n2. **One primary learning intent.** Each item MUST have exactly one primary intent: `LANGUAGE`, `STORY`, `HISTORY`, `CULTURE`, or `CAUSAL_REASONING`. Secondary intents are allowed. The item MUST have a defensible learning reason to exist and MUST NOT be filler generated from a random sentence.\n3. **Mode differentiation.** `paragraphRebuild` primarily tests structure, sequence, time, or causal order; it MUST NOT reduce to punctuation/length guessing or sentence memorization. `grammarRepair` primarily tests language structure; its defect MUST be genuine, explainable, level-appropriate, and unambiguous rather than a history-trivia trap. `missingSentence` primarily tests comprehension and inference across context; it MUST NOT reduce to keyword matching or verbatim recall alone. If all three modes effectively test memorization of the same source sentence, Challenge Gold fails.\n4. **One defensible best answer.** The intended answer MUST be uniquely supportable from taught Journey context and level-appropriate Chinese. If two options remain reasonably defensible, rewrite the item; do not declare one correct by author intent. External knowledge, test-pattern guessing, tricks, and extreme-detail trivia are prohibited dependencies.\n5. **Gold distractors.** A distractor MUST be plausible but wrong for a teachable reason. Preferred misconception classes include wrong sequence, reversed causality, relationship confusion, Goal/Consequence confusion, a taught true fact used in the wrong context, cultural misunderstanding, or a language-structure misconception. Absurd answers, random noun/city/person swaps, broken grammar unrelated to the learning intent, other-Journey material, inactive/legacy text, and cheap fabricated history are prohibited. Historical Truth applies to Challenge.\n6. **Diagnosable misunderstanding.** Human audit MUST be able to state what misunderstanding each distractor represents. This is content-design evidence and does not require new feedback UI.\n7. **Closed learning loop.** Story and Discovery provide experience and verified knowledge; Challenge asks the learner to reorganize, apply, compare, or infer from that taught material. Chinese learning remains active even when history or culture supplies the context.\n8. **Provenance.** Every item MUST trace to active Story, active Discovery, active Vocabulary, or an explicit current language objective. Legacy seed text, old Story, another Journey, random cultural trivia, and inactive content are blocking defects.\n9. **Fairness.** Phoenix Challenge may be challenging, but MUST NOT be tricky. The learner must be able to answer from the Journey already experienced plus the expected language ability for that level.\n10. **Cognitive progression.** Subject to the canonical Three Gradients and Five Cognitive Bands, the default Challenge progression is: Lv1–2 recognition/basic comprehension; Lv3–4 sequence/simple causality; Lv5–6 relationship/choice/historical cause; Lv7–8 causal chain/implicit meaning; Lv9–10 integrated interpretation. Higher level means deeper reasoning, not merely longer questions, longer vocabulary, more options, or colder trivia.\n\nFor Story-sourced items, prefer people, relationship, Goal, Conflict, Choice, Cost, Consequence, Transformation, sequence, or subtext over isolated noun recall. For Discovery-sourced items, prefer understanding, sequence, causality, connection, change, and cultural meaning over year/number memorization unless the exact fact is an explicit level target.\n\n### 3.2 Challenge Gold human gate\n\nMachine checks are necessary but cannot approve fairness, naturalness, misconception quality, or learning value. Every Gold Journey MUST receive human Challenge review at **Lv1, Lv5, and Lv10**. Each review asks: what is the question testing; was it taught; is one answer best; are distractors plausible and diagnosable; is Chinese learning occurring; does Story/culture/history reinforcement fit the level; does the item feel repetitive or machine-filled?\n\nThe final human question is: **after completing the Challenge, is the learner clearer about at least one core Story, Chinese, cultural, historical, or causal learning target?** If the learner merely clicked the keyed answer without reinforced understanding, `CHALLENGE GOLD QUALITY = FAIL`.\n\n### 3.3 Gold blocking gates\n\nBefore a Journey may enter Gold Founder Review, all applicable rows MUST be `PASS`: `CHALLENGE LEARNING INTENT`, `MODE DIFFERENTIATION`, `PARAGRAPH REBUILD QUALITY`, `GRAMMAR REPAIR QUALITY`, `MISSING SENTENCE QUALITY`, `ONE DEFENSIBLE ANSWER`, `DISTRACTOR QUALITY`, `DISTRACTOR MISCONCEPTION LOGIC`, `TEACH-BEFORE-TEST`, `CHALLENGE PROVENANCE`, `LEVEL PROGRESSION`, `STORY / DISCOVERY CLOSED LOOP`, `HISTORICAL TRUTH`, and `HUMAN CHALLENGE REVIEW`. A machine PASS cannot substitute for the human gate.\n\n## 4. Story requirements""",
)
replace_once(
    six,
    "3. Vocabulary, three-mode Challenge, Memory, Completion, Reward, and multilingual design",
    "3. Vocabulary → Challenge Design → Challenge Gold Audit → Memory → Completion → Reward and multilingual design",
)
replace_once(
    six,
    "- presence of all three Challenge modes;",
    "- presence and canonical runtime mapping of all three Challenge modes;\n- structurally testable Challenge provenance, duplicate distractors, level coverage, taught-before-tested prerequisites, and answer-key uniqueness;",
)
replace_once(
    six,
    "- one of the three Challenge modes is absent;",
    "- one of the three Challenge modes is absent;\n- any required Challenge Gold gate in §3.3 fails;",
)

append_once(
    'docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md',
    '## Challenge Gold lifecycle binding',
    """
## Challenge Gold lifecycle binding

The authoritative Challenge content-quality contract is [Phoenix Six-Stage Journey Standard §3](PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md#3-required-challenge-modes). This standard does not redefine those rules.

For every new or materially repaired Journey, the learning-package development order is binding:

> **Story Lock → Discovery → Vocabulary → Challenge Design → Challenge Gold Audit → Memory → Completion → Runtime → Validation**

Phase B MUST define a primary learning intent, active source provenance, teach-before-test evidence, one-defensible-answer evidence, distractor misconception logic, and level-progression intent for every active Challenge item. Phase E machine validation covers the structurally testable portions; Lv1/Lv5/Lv10 human Challenge review remains REQUIRED before Gold Founder Review.

A Journey is blocked if Challenge was filled after the fact from random source sentences, if the three modes do not have distinct learning functions, or if any required Challenge Gold gate from the Six-Stage Standard fails.
""",
)

append_once(
    'ai/AI_BEHAVIOR.md',
    '## Challenge Gold development behavior',
    """
## Challenge Gold development behavior

For Journey work, AI MUST treat [Phoenix Six-Stage Journey Standard §3](../docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md#3-required-challenge-modes) as the single detailed authority for Challenge Gold quality.

AI MUST read the active Story, Discovery, level, vocabulary provenance, and intended learning objective before designing Challenge. Challenge MUST NOT be generated as end-of-pipeline filler. Before proposing `PASS`, AI MUST actively look for ambiguous answers, weak or duplicate distractors, untaught knowledge, legacy/cross-Journey contamination, mode duplication, level mismatch, trivia dependency, keyword matching, and fabricated historical distractors. A real failure requires rewriting the item or its content mapping, not weakening a gate or test.

Human Challenge review at Lv1/Lv5/Lv10 is mandatory and cannot be replaced by green CI or a numeric quality score.
""",
)

append_once(
    'docs/journey-content-quality-gate.md',
    '## Challenge Gold gate',
    """
## Challenge Gold gate

Challenge quality is governed in detail by [Phoenix Six-Stage Journey Standard §3](PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md#3-required-challenge-modes). This gate only records its acceptance boundary to avoid a parallel standard.

A Gold candidate MUST demonstrate: clear primary learning intent; teach-before-test; differentiated `paragraphRebuild` / `grammarRepair` / `missingSentence`; one defensible best answer; plausible and diagnosable distractors; active-content provenance; level-appropriate cognitive progression; Story/Discovery closed loop; Historical Truth; and human Lv1/Lv5/Lv10 Challenge review. Any required failure blocks the quality gate even when mode-presence tests and aggregate scores are green.
""",
)

append_once(
    'docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md',
    '## Challenge Gold design extension',
    """
## Challenge Gold design extension

Use this matrix together with [Phoenix Six-Stage Journey Standard §3](../PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md#3-required-challenge-modes). The Six-Stage Standard owns the detailed semantics; this template records design evidence.

For every active Challenge item record: `Level`, `Mode`, `Primary Learning Intent`, `Source Provenance`, `Taught Before Tested`, `Correct Answer`, `Why Correct`, each `Distractor Misconception`, `Level Appropriateness`, and `Human Review`. The three modes MUST show distinct learning functions, and Lv1/Lv5/Lv10 MUST receive explicit human review.
""",
)

append_once(
    'docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md',
    '## Challenge Gold required gates',
    """
## Challenge Gold required gates

Detailed definitions are owned by [Phoenix Six-Stage Journey Standard §3](../PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md#3-required-challenge-modes). Record each row independently; do not infer one PASS from another.

| Gate | Class | Required evidence |
|---|---|---|
| Challenge Learning Intent | REQUIRED | One primary intent per active item |
| Mode Differentiation | REQUIRED | Three modes exercise distinct canonical functions |
| Paragraph Rebuild Quality | REQUIRED | Structure/sequence/causal-order evidence; not punctuation or rote ordering |
| Grammar Repair Quality | REQUIRED | Genuine, explainable, level-fit Chinese repair |
| Missing Sentence Quality | REQUIRED | Contextual comprehension/inference; not keyword matching |
| One Defensible Answer | REQUIRED | Unique best answer under taught context |
| Distractor Quality | REQUIRED | Plausible, non-duplicated, non-trick distractors |
| Distractor Misconception Logic | REQUIRED | Misunderstanding represented by each distractor |
| Teach Before Test | REQUIRED | Necessary knowledge taught at current/earlier level |
| Challenge Provenance | REQUIRED | Active Story/Discovery/Vocabulary or explicit language objective |
| Level Progression | REQUIRED | Deeper reasoning across levels, not length inflation |
| Story / Discovery Closed Loop | REQUIRED | Challenge reorganizes/applies taught Journey learning |
| Historical Truth | REQUIRED | No cheap fabricated-history distractors or unsupported claims |
| Human Challenge Review | REQUIRED | Lv1/Lv5/Lv10 human evidence |

Any row not `PASS` with appropriate evidence blocks Gold Founder Review.
""",
)

append_once(
    'docs/templates/PHOENIX_SIX_STAGE_JOURNEY_ACCEPTANCE_MATRIX.md',
    '## Stage 3 Challenge Gold evidence',
    """
## Stage 3 Challenge Gold evidence

Stage 3 remains the existing `challenge` stage and MUST NOT introduce a new user-visible stage or mode. In addition to confirming all three runtime modes, attach the Challenge Gold gate results from [Phoenix Six-Stage Journey Standard §3](../PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md#3-required-challenge-modes), including Lv1/Lv5/Lv10 human review.
""",
)

# ---------------------------------------------------------------------------
# Datong: make active Challenge content level-aware without changing UI/modes.
# ---------------------------------------------------------------------------
panel = 'app/lib/widgets/journey_challenge_panel.dart'
replace_once(
    panel,
    "import '../data/forbidden_city_challenge_package.dart';\nimport '../data/forbidden_city_journey_runtime.dart';",
    "import '../data/datong_yungang_gold_content.dart';\nimport '../data/forbidden_city_challenge_package.dart';\nimport '../data/forbidden_city_journey_runtime.dart';",
)
replace_once(
    panel,
    "    final forbiddenCityLevel = widget.journeyId == forbiddenCityJourneyId\n        ? _resolveForbiddenCityChallengeLevel(widget.storyParagraphs)\n        : null;\n    _sessions = <_ChallengeSession>[",
    "    final forbiddenCityLevel = widget.journeyId == forbiddenCityJourneyId\n        ? _resolveForbiddenCityChallengeLevel(widget.storyParagraphs)\n        : null;\n    final datongLevel = widget.journeyId == datongYungangJourneyId\n        ? _resolveDatongChallengeLevel(widget.storyParagraphs)\n        : null;\n    _sessions = <_ChallengeSession>[",
)
replace_once(
    panel,
    "          forbiddenCityLevel: forbiddenCityLevel,\n        ),",
    "          forbiddenCityLevel: forbiddenCityLevel,\n          datongLevel: datongLevel,\n        ),",
)
replace_once(
    panel,
    "int _resolveForbiddenCityChallengeLevel(List<String> storyParagraphs) {",
    """int _resolveDatongChallengeLevel(List<String> storyParagraphs) {
  final activeStory = storyParagraphs.map((value) => value.trim()).join('\\n\\n');
  for (var level = 1; level <= 10; level++) {
    final candidate = datongYungangGoldLevelContent(level)
        .storyParagraphs
        .map((value) => value.trim())
        .join('\\n\\n');
    if (candidate == activeStory) return level;
  }
  throw StateError(
    'Datong Challenge requires an exact active Lv1-Lv10 Story binding.',
  );
}

@visibleForTesting
String datongChallengeGoldPrimaryIntent(
  int level,
  JourneyChallengeType type,
) {
  if (level < 1 || level > 10) throw RangeError.range(level, 1, 10, 'level');
  return switch (type) {
    JourneyChallengeType.grammarRepair => 'LANGUAGE',
    JourneyChallengeType.paragraphRebuild => level <= 2
        ? 'STORY'
        : level <= 6
            ? 'CAUSAL_REASONING'
            : level <= 8
                ? 'STORY'
                : 'CAUSAL_REASONING',
    JourneyChallengeType.missingSentence => level <= 2
        ? 'STORY'
        : level <= 4
            ? 'CAUSAL_REASONING'
            : level <= 6
                ? 'HISTORY'
                : level <= 8
                    ? 'STORY'
                    : 'CULTURE',
  };
}

@visibleForTesting
int datongChallengeWindowStart(int level, int sourceLength, int count) {
  if (level < 1 || level > 10) throw RangeError.range(level, 1, 10, 'level');
  final maxStart = math.max(0, sourceLength - count);
  if (maxStart == 0) return 0;
  return ((level - 1) * maxStart / 9).round().clamp(0, maxStart);
}

int _resolveForbiddenCityChallengeLevel(List<String> storyParagraphs) {""",
)
replace_once(
    panel,
    "    int? forbiddenCityLevel,\n  }) {",
    "    int? forbiddenCityLevel,\n    int? datongLevel,\n  }) {",
)
replace_once(
    panel,
    "        difficulty,\n        seed,\n      ),\n      JourneyChallengeType.grammarRepair => _buildGrammar(\n        journeyId,\n        difficulty,\n        seed,\n      ),\n      JourneyChallengeType.missingSentence => _buildMissing(\n        journeyId,\n        storyParagraphs,\n        discoveryTexts,\n        difficulty,\n        seed,\n      ),",
    """        difficulty,
        seed,
        datongLevel: datongLevel,
      ),
      JourneyChallengeType.grammarRepair => _buildGrammar(
        journeyId,
        difficulty,
        seed,
        datongLevel: datongLevel,
      ),
      JourneyChallengeType.missingSentence => _buildMissing(
        journeyId,
        storyParagraphs,
        discoveryTexts,
        difficulty,
        seed,
        datongLevel: datongLevel,
      ),""",
)
replace_once(
    panel,
    "  static _ChallengeSession _buildParagraph(\n    String journeyId,\n    List<String> storyParagraphs,\n    JourneyChallengeDifficulty difficulty,\n    int seed,\n  ) {",
    "  static _ChallengeSession _buildParagraph(\n    String journeyId,\n    List<String> storyParagraphs,\n    JourneyChallengeDifficulty difficulty,\n    int seed, {\n    int? datongLevel,\n  }) {",
)
replace_once(
    panel,
    "    final source = _extractSentences(storyParagraphs);\n    final fallback = <String>[",
    """    final allSource = _extractSentences(storyParagraphs);
    final source = datongLevel == null
        ? allSource
        : allSource
            .skip(datongChallengeWindowStart(datongLevel, allSource.length, requiredCount))
            .take(requiredCount)
            .toList(growable: false);
    final fallback = <String>[""",
)
replace_once(
    panel,
    "      instruction: '四个候选句中有 ${correctOptions.length} 句属于原文。请按故事发生的顺序依次点击。',\n      explanation: '段落通常先交代地点或时间，再写行动，最后出现观察、变化或决定。',",
    """      instruction: datongLevel == null
          ? '四个候选句中有 ${correctOptions.length} 句属于原文。请按故事发生的顺序依次点击。'
          : '按当前 Lv$datongLevel 已学故事的事件、时间与因果推进，复原这组句子。',
      explanation: datongLevel == null
          ? '段落通常先交代地点或时间，再写行动，最后出现观察、变化或决定。'
          : '正确顺序来自当前等级已学 Story，并随等级逐步移向选择、代价、关系变化与结果。',""",
)
replace_once(
    panel,
    "  static _ChallengeSession _buildGrammar(\n    String journeyId,\n    JourneyChallengeDifficulty difficulty,\n    int seed,\n  ) {\n    final grammar = _grammarForJourney(journeyId, difficulty, seed);",
    "  static _ChallengeSession _buildGrammar(\n    String journeyId,\n    JourneyChallengeDifficulty difficulty,\n    int seed, {\n    int? datongLevel,\n  }) {\n    final grammar = _grammarForJourney(journeyId, difficulty, seed, datongLevel: datongLevel);",
)
replace_once(
    panel,
    "    JourneyChallengeDifficulty difficulty,\n    int seed,\n  ) {\n    final source = _extractSentences(storyParagraphs);\n    final before = source.isNotEmpty ? source[0] : '清晨，探索者来到今天的目的地。';\n    final correct = source.length >= 2 ? source[1] : '他沿着主要路线慢慢向前走。';\n    final after = source.length >= 3 ? source[2] : '一路上的景色因此不断发生变化。';",
    """    JourneyChallengeDifficulty difficulty,
    int seed, {
    int? datongLevel,
  }) {
    final source = _extractSentences(storyParagraphs);
    final start = datongLevel == null
        ? 0
        : datongChallengeWindowStart(datongLevel, source.length, 3);
    final before = source.isNotEmpty ? source[start] : '清晨，探索者来到今天的目的地。';
    final correct = source.length > start + 1 ? source[start + 1] : '他沿着主要路线慢慢向前走。';
    final after = source.length > start + 2 ? source[start + 2] : '一路上的景色因此不断发生变化。';""",
)
replace_once(
    panel,
    "  static _GrammarSpec _grammarForJourney(\n    String journeyId,\n    JourneyChallengeDifficulty difficulty,\n    int seed,\n  ) {",
    "  static _GrammarSpec _grammarForJourney(\n    String journeyId,\n    JourneyChallengeDifficulty difficulty,\n    int seed, {\n    int? datongLevel,\n  }) {",
)
replace_once(
    panel,
    "      'datong-yungang-grottoes' =>\n        _adaptiveGrammarForJourney(journeyId, difficulty),",
    "      'datong-yungang-grottoes' =>\n        _adaptiveGrammarForJourney(journeyId, difficulty, datongLevel: datongLevel),",
)
replace_once(
    panel,
    "  static _GrammarSpec _adaptiveGrammarForJourney(\n    String journeyId,\n    JourneyChallengeDifficulty difficulty,\n  ) {\n    final context = switch (journeyId) {",
    "  static _GrammarSpec _adaptiveGrammarForJourney(\n    String journeyId,\n    JourneyChallengeDifficulty difficulty, {\n    int? datongLevel,\n  }) {\n    final context = switch (journeyId) {",
)
replace_once(
    panel,
    "      'datong-yungang-grottoes' => (\n          focus: '昙曜五窟与迁都后的较小窟龛',\n          insight: '理解云冈规模怎样随时代改变',\n          subject: '云冈的早中晚分期',\n          action: '记录营造规模和艺术语言的变化',\n          result: '理解迁都前后的历史转折',\n          cause: '494年北魏迁都洛阳',\n          resultSubject: '云冈大规模的皇家开凿',\n          resultAction: '随之停止，而较小窟龛继续出现',\n        ),",
    """      'datong-yungang-grottoes' => switch (datongLevel ?? 1) {
          1 => (
              focus: '北魏定都平城后云冈靠近政治中心',
              insight: '理解地点与时代的基本关系',
              subject: '平城附近的云冈',
              action: '靠近北魏政治中心',
              result: '理解早期营造的历史背景',
              cause: '北魏定都平城',
              resultSubject: '云冈',
              resultAction: '处在接近政治中心的位置',
            ),
          2 => (
              focus: '昙曜五窟与早期皇家支持',
              insight: '理解早期大型造像的背景',
              subject: '昙曜五窟',
              action: '体现早期大型营造',
              result: '联系皇家支持与造像规模',
              cause: '朝廷支持早期大型造像',
              resultSubject: '昙曜五窟',
              resultAction: '成为早期云冈的重要代表',
            ),
          3 => (
              focus: '朝廷支持与大型石窟营造',
              insight: '理解资源怎样影响营造规模',
              subject: '朝廷支持',
              action: '集中营造资源',
              result: '理解早期大型开凿的条件',
              cause: '国家力量能够集中资源',
              resultSubject: '大型石窟营造',
              resultAction: '获得更强的组织条件',
            ),
          4 => (
              focus: '云冈早中晚分期与494年迁都转折',
              insight: '理解营造阶段怎样发生变化',
              subject: '早中晚分期',
              action: '整理营造时间线',
              result: '看清迁都前后的转折',
              cause: '494年北魏迁都洛阳',
              resultSubject: '云冈营造',
              resultAction: '进入新的历史阶段',
            ),
          5 => (
              focus: '中期营造高峰与更复杂的艺术表达',
              insight: '理解中期云冈怎样继续发展',
              subject: '中期洞窟',
              action: '发展更复杂的布局与雕饰',
              result: '理解云冈艺术语言的变化',
              cause: '中期营造持续发展',
              resultSubject: '洞窟布局与雕饰',
              resultAction: '呈现更丰富的表达',
            ),
          6 => (
              focus: '494年迁都与大型皇家开凿的变化',
              insight: '理解迁都为什么改变营造规模',
              subject: '迁都后的云冈',
              action: '改变原有营造条件',
              result: '理解大型皇家开凿为何停止',
              cause: '494年北魏迁都洛阳',
              resultSubject: '大规模皇家开凿',
              resultAction: '不再按原有规模继续',
            ),
          7 => (
              focus: '迁都后中小窟龛继续出现',
              insight: '理解赞助者与营造规模的变化',
              subject: '晚期中小窟龛',
              action: '延续造像活动',
              result: '理解云冈没有在迁都后立刻沉寂',
              cause: '迁都改变了皇家营造条件',
              resultSubject: '较小规模的造像活动',
              resultAction: '仍由不同赞助者继续',
            ),
          8 => (
              focus: '南亚中亚佛教艺术因素与中国传统的融合',
              insight: '理解云冈艺术交流不是单向复制',
              subject: '云冈造像艺术',
              action: '吸收并重组不同艺术传统',
              result: '理解文化交流形成的新表达',
              cause: '多种佛教艺术传统在云冈相遇',
              resultSubject: '云冈艺术语言',
              resultAction: '形成融合后的独特面貌',
            ),
          9 => (
              focus: '政治中心、赞助体系与营造规模的连续变化',
              insight: '连接云冈历史的多步因果链',
              subject: '赞助与营造条件',
              action: '随着政治环境改变',
              result: '解释规模与艺术语言的变化',
              cause: '政治中心和赞助条件先后改变',
              resultSubject: '云冈的营造方式',
              resultAction: '呈现出连续而非突然中断的转变',
            ),
          10 => (
              focus: '云冈在中国与东亚佛教石窟艺术中的影响',
              insight: '综合理解云冈的历史与文化意义',
              subject: '云冈艺术',
              action: '形成有影响力的石窟艺术表达',
              result: '理解其超越单一遗址的意义',
              cause: '云冈融合多种传统并形成鲜明表达',
              resultSubject: '后来的佛教石窟艺术',
              resultAction: '受到持续影响',
            ),
          _ => throw RangeError.range(datongLevel ?? 0, 1, 10, 'datongLevel'),
        },""",
)

# The standard adaptive calls for every other Journey remain source-compatible.
# Add the optional named argument only to direct calls that compile against the new signature.
text = Path(panel).read_text()
text = text.replace('_adaptiveGrammarForJourney(journeyId, difficulty),', '_adaptiveGrammarForJourney(journeyId, difficulty),')
Path(panel).write_text(text)

# ---------------------------------------------------------------------------
# Datong runtime tests: teach-before-test, level-aware progression and mode intent.
# ---------------------------------------------------------------------------
Path('app/test/datong_yungang_challenge_runtime_test.dart').write_text(r'''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/datong_yungang_gold_content.dart';
import 'package:phoenix_journeys/widgets/journey_challenge_panel.dart';

String _identity(String value) => value;

Future<void> _tap(WidgetTester tester, String key) async {
  final finder = find.byKey(ValueKey(key));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _pumpLevel(WidgetTester tester, int level) async {
  final content = datongYungangGoldLevelContent(level);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 430,
          height: 900,
          child: JourneyChallengePanel(
            journeyId: datongYungangJourneyId,
            storyParagraphs: content.storyParagraphs,
            discoveryTexts: content.discoveries.map((item) => item.text).toList(growable: false),
            profile: null,
            seed: 186 + level,
            displayText: _identity,
            onResolved: (_, __) async {},
            onAllCompleted: () async {},
            autoNarrate: false,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _finishBeginnerParagraph(WidgetTester tester) async {
  await _tap(tester, 'challenge-option-correct-0');
  await _tap(tester, 'challenge-option-correct-1');
  await _tap(tester, 'challenge-submit');
  await _tap(tester, 'challenge-dialog-action');
}

void main() {
  test('Datong Challenge Gold declares one primary intent per mode and level', () {
    for (var level = 1; level <= 10; level++) {
      final intents = <String>{
        for (final type in fixedJourneyChallengeTypes)
          datongChallengeGoldPrimaryIntent(level, type),
      };
      expect(intents, contains('LANGUAGE'));
      expect(intents.length, greaterThanOrEqualTo(2));
    }
    expect(datongChallengeGoldPrimaryIntent(1, JourneyChallengeType.paragraphRebuild), 'STORY');
    expect(datongChallengeGoldPrimaryIntent(5, JourneyChallengeType.paragraphRebuild), 'CAUSAL_REASONING');
    expect(datongChallengeGoldPrimaryIntent(10, JourneyChallengeType.missingSentence), 'CULTURE');
  });

  test('Datong source windows progress rather than replaying Lv1 openings', () {
    final starts = <int>[
      for (var level = 1; level <= 10; level++)
        datongChallengeWindowStart(level, 18, 3),
    ];
    expect(starts.first, 0);
    expect(starts.last, 15);
    for (var index = 1; index < starts.length; index++) {
      expect(starts[index], greaterThanOrEqualTo(starts[index - 1]));
    }
    expect(starts.toSet().length, greaterThanOrEqualTo(7));
  });

  testWidgets('Datong Lv1 active Challenge uses only Lv1-taught historical context', (tester) async {
    await _pumpLevel(tester, 1);
    expect(find.byKey(const ValueKey('challenge-mode-paragraphRebuild')), findsOneWidget);
    expect(find.textContaining('魏岚'), findsWidgets);
    expect(find.textContaining('长廊'), findsNothing);
    await _finishBeginnerParagraph(tester);
    expect(find.byKey(const ValueKey('challenge-mode-grammarRepair')), findsOneWidget);
    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsWidgets);
    expect(find.textContaining('494年'), findsNothing);
    expect(find.textContaining('昙曜五窟'), findsNothing);
  });

  testWidgets('Datong Lv5 active Challenge advances to taught middle-period context', (tester) async {
    await _pumpLevel(tester, 5);
    await _finishBeginnerParagraph(tester);
    expect(find.textContaining('中期营造高峰与更复杂的艺术表达'), findsWidgets);
    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsNothing);
  });

  testWidgets('Datong Lv10 active Challenge reaches integrated cultural context', (tester) async {
    await _pumpLevel(tester, 10);
    await _finishBeginnerParagraph(tester);
    expect(find.textContaining('云冈在中国与东亚佛教石窟艺术中的影响'), findsWidgets);
    expect(find.textContaining('北魏定都平城后云冈靠近政治中心'), findsNothing);
  });

  testWidgets('Datong active Challenge remains journey-grounded in all three modes', (tester) async {
    await _pumpLevel(tester, 1);
    await _finishBeginnerParagraph(tester);
    await _tap(tester, 'challenge-grammar-segment-1');
    await _tap(tester, 'challenge-option-correct');
    await _tap(tester, 'challenge-submit');
    await _tap(tester, 'challenge-dialog-action');

    expect(find.byKey(const ValueKey('challenge-mode-missingSentence')), findsOneWidget);
    expect(find.textContaining('魏岚'), findsWidgets);
    expect(find.textContaining('很快离开了这里'), findsNothing);
    expect(find.textContaining('沿途景色'), findsNothing);
    expect(find.textContaining('园林'), findsNothing);
  });
}
''')

Path('app/test/challenge_gold_governance_test.dart').write_text(r'''import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _repoText(String path) {
  for (final candidate in <File>[File('../$path'), File(path)]) {
    if (candidate.existsSync()) return candidate.readAsStringSync();
  }
  throw StateError('Cannot locate repository file: $path');
}

void main() {
  test('Six-Stage Standard owns the full Challenge Gold contract', () {
    final standard = _repoText('docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md');
    for (final required in <String>[
      'TAUGHT CONTENT → CLEAR LEARNING INTENT',
      'TEACH BEFORE TEST',
      'One primary learning intent',
      'Mode differentiation',
      'One defensible best answer',
      'Gold distractors',
      'Diagnosable misunderstanding',
      'Closed learning loop',
      'Provenance',
      'Fairness',
      'Cognitive progression',
      'Lv1, Lv5, and Lv10',
      'CHALLENGE LEARNING INTENT',
      'DISTRACTOR MISCONCEPTION LOGIC',
      'HUMAN CHALLENGE REVIEW',
    ]) {
      expect(standard, contains(required), reason: required);
    }
    expect(standard, contains('paragraphRebuild'));
    expect(standard, contains('grammarRepair'));
    expect(standard, contains('missingSentence'));
  });

  test('Acceptance, design, quality and AI layers bind to the same authority', () {
    final acceptance = _repoText('docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md');
    final design = _repoText('docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md');
    final quality = _repoText('docs/journey-content-quality-gate.md');
    final behavior = _repoText('ai/AI_BEHAVIOR.md');
    final creation = _repoText('docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md');
    for (final gate in <String>[
      'Challenge Learning Intent',
      'Mode Differentiation',
      'One Defensible Answer',
      'Distractor Misconception Logic',
      'Teach Before Test',
      'Challenge Provenance',
      'Human Challenge Review',
    ]) {
      expect(acceptance, contains(gate), reason: gate);
    }
    expect(design, contains('Primary Learning Intent'));
    expect(design, contains('Distractor Misconception'));
    expect(quality, contains('Six-Stage Journey Standard §3'));
    expect(behavior, contains('Challenge MUST NOT be generated as end-of-pipeline filler'));
    expect(creation, contains('Challenge Design → Challenge Gold Audit'));
  });
}
''')

append_once(
    'docs/DATONG_YUNGANG_GOLD_REMEDIATION_RECORD.md',
    '## Challenge Gold matrix · Founder canonicalization',
    """
## Challenge Gold matrix · Founder canonicalization

This evidence applies the binding Challenge Gold contract in `PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md` to the active Datong runtime. Story and Vocabulary remain locked. Challenge remains Stage 3 with the three existing modes; only Datong content mapping is made level-aware.

| Level | Primary learning intent by mode | Source provenance / teach-before-test | Correct-answer logic | Diagnosable distractor misconception | Level appropriateness / human audit |
|---|---|---|---|---|---|
| Lv1 | paragraph=`STORY`; grammar=`LANGUAGE`; missing=`STORY` | current Lv1 Story + Lv1 Pingcheng/period context | Story order; genuine subject repair; local context bridge | reverses the rope choice, sole-successor status, or who controls the line | recognition/basic comprehension; human PASS |
| Lv2 | `STORY` / `LANGUAGE` / `STORY` | current/earlier Story + taught Tan Yao Five Caves context | same mode contracts, Lv2 source window | confuses who receives the line or early cave context | basic comprehension with added context; human PASS |
| Lv3 | `CAUSAL_RESONING` / `LANGUAGE` / `CAUSAL_REASONING` | current/earlier Story + taught court-support context | order and connection, not date trivia | mistakes resource/cause relation or Story agency | sequence/simple causality; human PASS |
| Lv4 | `CAUSAL_REASONING` / `LANGUAGE` / `CAUSAL_REASONING` | current/earlier Story + taught phase/494 turning-point context | causal sequence and clear grammar structure | moves consequence before cause or treats phase change as static | sequence/simple causality; human PASS |
| Lv5 | `CAUSAL_REASONING` / `LANGUAGE` / `HISTORY` | current/earlier Story + taught middle-period development | choice/cost sequence plus taught historical context | confuses Goal, Choice, and changed artistic/historical conditions | relationship/choice/historical cause; human PASS |
| Lv6 | `CAUSAL_REASONING` / `LANGUAGE` / `HISTORY` | current/earlier Story + taught 494 impact | connects relocation pressure to changed scale without requiring untaught facts | assumes relocation erased all activity or reverses cause/effect | relationship/choice/historical cause; human PASS |
| Lv7 | `STORY` / `LANGUAGE` / `STORY` | current/earlier Story + taught continuation of smaller niches | later Story relationship/order plus language repair | confuses lost title, sibling relation, or continued carving context | causal chain begins; human PASS |
| Lv8 | `STORY` / `LANGUAGE` / `STORY` | current/earlier Story + taught cultural-fusion context | deeper relationship/implicit sequence | treats fusion as simple copying or removes responsibility from the trio | causal chain/implicit meaning; human PASS |
| Lv9 | `CAUSAL_REASONING` / `LANGUAGE` / `CULTURE` | accumulated Story + taught patronage/scale/art-language chain | multi-step consequence and integrated inference | collapses multiple historical changes into one unsupported cause | integrated interpretation; human PASS |
| Lv10 | `CAUSAL_REASONING` / `LANGUAGE` / `CULTURE` | complete Story + taught Yungang legacy context | final relationship/causal closure plus cultural integration | confuses inheritance with restored sole authority or reduces legacy to size alone | integrated interpretation; human PASS |

`paragraphRebuild` now advances its active Story window across levels instead of repeatedly sampling the Lv1 opening. `missingSentence` advances the same way. `grammarRepair` keeps LANGUAGE as primary intent while its historical context is selected from knowledge already taught at that exact level or earlier. Datong distractors remain fictional Story counterfactuals or language-structure errors; they do not fabricate cheap false history.
""",
)

# Correct the intentional table token typo while retaining explicit gate wording.
p = Path('docs/DATONG_YUNGANG_GOLD_REMEDIATION_RECORD.md')
p.write_text(p.read_text().replace('CAUSAL_RESONING', 'CAUSAL_REASONING'))

# Self-remove so no one-shot transport mechanism remains in the final tree.
Path('tools/datong_challenge_gold_patch.py').unlink(missing_ok=True)
Path('.github/workflows/datong_challenge_gold_once.yml').unlink(missing_ok=True)
