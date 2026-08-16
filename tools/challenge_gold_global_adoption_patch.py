from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    if old not in text:
        raise SystemExit(f'anchor not found in {path}: {old[:120]!r}')
    p.write_text(text.replace(old, new, 1))


def append_once(path: str, marker: str, block: str) -> None:
    p = Path(path)
    text = p.read_text()
    if marker in text:
        return
    if not text.endswith('\n'):
        text += '\n'
    p.write_text(text + '\n' + block.strip() + '\n')


six = 'docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md'
replace_once(
    six,
    '**Effective scope:** all new Journeys, Story repairs, Journey flow changes, acceptance matrices, quality gates, previews, and release decisions created after this standard  ',
    '**Effective scope:** all new Journeys, Story repairs, Journey flow changes, acceptance matrices, quality gates, previews, and release decisions; §3 Challenge Gold additionally governs every current Founder-approved Gold Journey, every remediated/modified Journey, and every future Gold promotion candidate  ',
)
replace_once(
    six,
    "Before a Journey may enter Gold Founder Review, all applicable rows MUST be `PASS`: `CHALLENGE LEARNING INTENT`, `MODE DIFFERENTIATION`, `PARAGRAPH REBUILD QUALITY`, `GRAMMAR REPAIR QUALITY`, `MISSING SENTENCE QUALITY`, `ONE DEFENSIBLE ANSWER`, `DISTRACTOR QUALITY`, `DISTRACTOR MISCONCEPTION LOGIC`, `TEACH-BEFORE-TEST`, `CHALLENGE PROVENANCE`, `LEVEL PROGRESSION`, `STORY / DISCOVERY CLOSED LOOP`, `HISTORICAL TRUTH`, and `HUMAN CHALLENGE REVIEW`. A machine PASS cannot substitute for the human gate.\n\n## 4. Story requirements",
    """Before a Journey may enter or retain Gold Challenge status, every applicable canonical gate MUST be `PASS`:\n\n- `CHALLENGE LEARNING INTENT`\n- `TEACH BEFORE TEST`\n- `MODE DIFFERENTIATION`\n- `PARAGRAPH REBUILD QUALITY`\n- `GRAMMAR REPAIR QUALITY`\n- `MISSING SENTENCE QUALITY`\n- `ONE DEFENSIBLE ANSWER`\n- `PLAUSIBLE DISTRACTORS`\n- `DIAGNOSABLE MISUNDERSTANDING`\n- `HISTORICAL TRUTH IN CHALLENGE`\n- `ACTIVE CONTENT PROVENANCE`\n- `NO LEGACY CONTAMINATION`\n- `NO CROSS-JOURNEY CONTAMINATION`\n- `LEVEL-APPROPRIATE REASONING`\n- `COGNITIVE PROGRESSION`\n- `STORY / DISCOVERY CLOSED LOOP`\n- `LANGUAGE LEARNING VALUE`\n- `LV1 HUMAN CHALLENGE REVIEW`\n- `LV5 HUMAN CHALLENGE REVIEW`\n- `LV10 HUMAN CHALLENGE REVIEW`\n\n`DISTRACTOR QUALITY`, `DISTRACTOR MISCONCEPTION LOGIC`, `CHALLENGE PROVENANCE`, `LEVEL PROGRESSION`, `HISTORICAL TRUTH`, and `HUMAN CHALLENGE REVIEW` remain valid compatibility labels for evidence already recorded under the gates above; they do not define parallel standards. **Any required gate failure means `GOLD CHALLENGE = FAIL`.** A machine PASS cannot substitute for a human gate.\n\n### 3.4 Existing Gold is not grandfathered\n\n**EXISTING GOLD IS NOT GRANDFATHERED AGAINST NEW CANONICAL CHALLENGE QUALITY.** Founder approval, prior Gold status, merge history, or previously green tests do not prove compliance with a later Challenge Gold requirement.\n\nWhen Challenge Gold governance is newly adopted or materially strengthened, Phoenix MUST audit the **current approved Gold registry from merged current `main` at audit start**. Do not use a remembered count, stale handoff, or historical registry snapshot. Every Gold Journey in that registry MUST be audited at **Lv1-Lv10 across all three active modes**: `paragraphRebuild`, `grammarRepair`, and `missingSentence`. Lv1, Lv5, and Lv10 additionally require the human gate in §3.2. No item may receive `PASS BY LEGACY APPROVAL`.\n\nAfter the first merge that establishes a materially stronger Challenge Gold contract, the next content-development line MUST be an all-Gold Challenge audit and remediation before a new Journey Story enters development, unless the Founder explicitly changes priority. This convergence requirement does not authorize a parallel branch or PR and does not authorize unrelated product redesign.\n\n### 3.5 All-Gold audit matrix and audit-first policy\n\nThe canonical **PHOENIX ALL-GOLD CHALLENGE MATRIX** records one row per `Journey × Level × Mode`. Each row MUST record at least: `JOURNEY ID`, `LEVEL`, `MODE`, `PRIMARY LEARNING INTENT`, optional `SECONDARY INTENT`, `ACTIVE SOURCE`, `SOURCE PROVENANCE`, `TAUGHT BEFORE TESTED`, `CORRECT ANSWER`, `WHY CORRECT`, `ALTERNATIVE ANSWER AMBIGUITY`, `DISTRACTOR QUALITY`, `DISTRACTOR MISCONCEPTION`, `HISTORICAL TRUTH`, `LANGUAGE VALUE`, `STORY / DISCOVERY CONNECTION`, `LEVEL APPROPRIATENESS`, `COGNITIVE BAND`, `LEGACY CONTAMINATION`, `CROSS-JOURNEY CONTAMINATION`, and `RESULT`. `RESULT` is only `PASS` or `REPAIR REQUIRED`.\n\nGlobal convergence MUST use **AUDIT FIRST**. Do not mass-generate replacement questions before the defect inventory exists. Defects use these canonical audit codes: `TBT` teach-before-test violation; `AMB` ambiguous answer; `DST` weak distractor; `MODE` mode duplication; `PROV` provenance failure; `LEGACY` legacy contamination; `CROSS` cross-Journey contamination; `LEVEL` level mismatch; `PROG` weak cognitive progression; `HIST` historical-truth defect; `LANG` weak Chinese learning value; `LOOP` Story/Discovery closed-loop failure; `TEMPLATE` cross-Journey template repetition.\n\nRepair the smallest real defect. Prefer Challenge content, mapping, distractors, and level binding. If required knowledge is genuinely absent and belongs in the learning package, prefer the minimum Discovery teaching repair or Vocabulary provenance repair. Founder-approved Story spine, Human Story, and Memory Moment remain locked by default; Story is the last teaching layer to reopen and requires a concrete independent reason.\n\n### 3.6 Cross-Gold anti-template and content-shape protection\n\nChallenge quality process is standardized; Challenge content shape is not. **STANDARDIZE THE QUALITY PROCESS. DO NOT STANDARDIZE THE CONTENT SHAPE.**\n\nCross-Gold human review MUST compare question logic, distractor logic, sentence skeleton, causal-question pattern, missing-sentence trick, paragraph-rebuild pattern, and grammar-error pattern. A remediation that copies one Challenge template and merely swaps city, person, building, artifact, or historical nouns is `TEMPLATE` and fails. Journey-specific Challenge must arise from that Journey's own Story, Discovery, language objective, historical mechanism, human relationship, and cultural identity.\n\nHistorical Journeys should, where truthful and level-appropriate, let learners enter history through human experience. Challenge must not collapse into a history quiz: across the Journey it must preserve meaningful balance among Chinese language, Story comprehension, history/culture, and causal reasoning.\n\n### 3.7 Global cognitive and machine/human governance\n\nEvery Gold Journey MUST demonstrate real Lv1→Lv10 cognitive growth. The default direction is `Recognition → Sequence → Causality → Relationship → Interpretation → Integrated Understanding`, subject to the canonical Three Gradients, Five Cognitive Bands, and current level governance. Longer sentences, longer options, or colder facts do not establish progression.\n\nReasonable machine governance includes dynamic Gold-registry coverage, all-Gold Challenge coverage, mode coverage, runtime provenance, level mapping, teach-before-test, legacy and cross-Journey contamination, duplicate distractors, answer structural uniqueness, cognitive-band mapping, historical regression, and Challenge source mapping. Machine checks MUST NOT be described as proving fairness, naturalness, literary quality, or human-designed feel.\n\nAll-Gold convergence is complete only when every current Gold Journey is `CHALLENGE GOLD PASS`, every level and mode has been audited, Lv1/Lv5/Lv10 human review passes for every Journey, cross-Gold anti-template review passes, no legacy or cross-Journey contamination remains, full regression passes, and the exact-head Preview passes.\n\n## 4. Story requirements""",
)

creation = 'docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md'
replace_once(
    creation,
    "This extension governs future new Journeys and separately authorized future remediations. It does not reopen Founder-approved Gold Stories and does not authorize background, Passport, map, or location-hierarchy work.",
    "This extension governs future new Journeys and separately authorized future remediations. It does not automatically reopen Founder-approved Gold **Story spines** and does not authorize background, Passport, map, or location-hierarchy work. Challenge remains separately auditable under the current canonical Challenge Gold contract; existing Gold Challenge is not grandfathered against later Challenge quality requirements.",
)
replace_once(
    creation,
    "> **Story Lock → Discovery → Vocabulary → Challenge Design → Challenge Gold Audit → Memory → Completion → Runtime → Validation**",
    "> **FACT FIRST → STORY ARCHITECTURE → STORY LOCK → DISCOVERY → VOCABULARY → CHALLENGE DESIGN → CHALLENGE GOLD AUDIT → MEMORY → COMPLETION → RUNTIME → FULL VALIDATION → EXACT-HEAD PREVIEW → FOUNDER REVIEW**",
)
append_once(
    creation,
    '### Challenge Gold global convergence precondition',
    """
### Challenge Gold global convergence precondition

The detailed authority remains Phoenix Six-Stage Journey Standard §3. When a materially stronger Challenge Gold contract has been merged, no new Journey Story development may begin while the required current all-Gold Challenge audit/remediation remains incomplete, unless the Founder explicitly changes priority.

The all-Gold line MUST read the approved Gold registry dynamically from merged current `main`, audit all Lv1-Lv10 active `paragraphRebuild`, `grammarRepair`, and `missingSentence` items before mass rewrite, complete the required matrix and defect inventory, repair real defects with the smallest teaching-layer change, and pass Lv1/Lv5/Lv10 human Challenge review plus cross-Gold anti-template review for every Gold Journey.

This convergence gate does not authorize a second development branch, a second PR, Challenge UI redesign, Six-Stage UI changes, Map, Passport, Navigation, Reward, Progress, audio architecture, location hierarchy, dependency changes, or automatic Story rewrite.
""",
)

append_once(
    'ai/AI_BEHAVIOR.md',
    '### Challenge Gold global audit behavior',
    """
### Challenge Gold global audit behavior

Existing Gold is not grandfathered against the current canonical Challenge Gold contract. When the Founder authorizes or canonical governance requires all-Gold convergence, AI MUST read the approved Gold registry from merged current `main`, audit every Journey × Lv1-Lv10 × active Challenge mode first, and only then repair the resulting defect inventory. AI MUST NOT reuse prior Founder approval, prior Gold status, or prior green CI as substitute evidence.

AI MUST classify discovered defects with the canonical `TBT`, `AMB`, `DST`, `MODE`, `PROV`, `LEGACY`, `CROSS`, `LEVEL`, `PROG`, `HIST`, `LANG`, `LOOP`, and `TEMPLATE` codes. Repair must target the smallest real defect. Challenge content/mapping/distractors/level binding come first; minimum Discovery or Vocabulary teaching repair is allowed only when necessary; Founder-approved Story spine/Human Story/Memory Moment stays locked unless a separate concrete defect requires reopening it.

Cross-Gold remediation MUST NOT clone one question shape and swap nouns. AI MUST perform human anti-template comparison of question logic, distractor logic, sentence skeleton, causal pattern, missing-sentence trick, paragraph-rebuild pattern, and grammar-error pattern. Machine coverage cannot approve naturalness, fairness, human-designed feel, or cross-Gold literary distinctness.

After the first merge that adopts a materially stronger Challenge Gold contract, AI MUST prioritize the required all-Gold Challenge audit/remediation before starting a new Journey Story unless the Founder explicitly changes the order.
""",
)

append_once(
    'docs/journey-content-quality-gate.md',
    '### Existing-Gold Challenge convergence gate',
    """
### Existing-Gold Challenge convergence gate

Challenge Gold detail remains owned by Phoenix Six-Stage Journey Standard §3. Existing Gold is not grandfathered: a later Challenge quality requirement triggers re-audit of the dynamic approved Gold registry from merged current `main`. Prior Gold approval or green CI cannot produce `PASS BY LEGACY APPROVAL`.

The global gate requires complete Journey × Lv1-Lv10 × three-mode audit coverage, a defect inventory before mass rewrite, Lv1/Lv5/Lv10 human review for every Gold Journey, cross-Gold anti-template review, no legacy/cross-Journey contamination, and exact-head full regression/Preview evidence. Automated registry/provenance/coverage/TBT/duplication/mapping checks are machine evidence only; fairness, naturalness, misconception quality, and human-designed feel remain human gates.
""",
)

append_once(
    'docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md',
    '### All-Gold Challenge audit matrix',
    """
### All-Gold Challenge audit matrix

Detailed semantics remain owned by Phoenix Six-Stage Journey Standard §3. For global Challenge convergence, create one row for every current approved Gold `Journey × Level × Mode` using the registry from merged current `main`.

| Journey ID | Level | Mode | Primary Learning Intent | Secondary Intent | Active Source | Source Provenance | Taught Before Tested | Correct Answer | Why Correct | Alternative Answer Ambiguity | Distractor Quality | Distractor Misconception | Historical Truth | Language Value | Story / Discovery Connection | Level Appropriateness | Cognitive Band | Legacy Contamination | Cross-Journey Contamination | Result |
|---|---:|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | `PASS / REPAIR REQUIRED` |

Audit defect code:

`TBT / AMB / DST / MODE / PROV / LEGACY / CROSS / LEVEL / PROG / HIST / LANG / LOOP / TEMPLATE`

Cross-Gold anti-template record:

```text
Question logic repetition:
Distractor logic repetition:
Same sentence skeleton:
Same causal question:
Same missing-sentence trick:
Same paragraph-rebuild pattern:
Same grammar-error pattern:
Only nouns changed: YES / NO
Nearest Gold Challenge pattern:
Decisive Journey-specific difference:
Human anti-template result: PASS / REPAIR REQUIRED
```

Lv1, Lv5, and Lv10 human review remains mandatory for every Gold Journey; all other levels and modes still require complete audit rows.
""",
)

acceptance = 'docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md'
replace_once(
    acceptance,
    "| Human Challenge Review | REQUIRED | Lv1/Lv5/Lv10 human evidence |\n\nAny row not `PASS` with appropriate evidence blocks Gold Founder Review.",
    """| Active Content Provenance | REQUIRED | Active Story/Discovery/Vocabulary or explicit current language objective; no inactive seed |
| No Legacy Contamination | REQUIRED | No inactive/legacy Challenge content in active options or answer logic |
| No Cross-Journey Contamination | REQUIRED | No other-Journey content in active options or answer logic |
| Level-Appropriate Reasoning | REQUIRED | Reasoning fits current level and canonical cognitive band |
| Cognitive Progression | REQUIRED | Lv1→Lv10 deepens reasoning rather than length/trivia |
| Language Learning Value | REQUIRED | Chinese learning remains active even when Story/history/culture supplies context |
| Human Challenge Review | REQUIRED | Separate Lv1, Lv5, and Lv10 human evidence |
| Cross-Gold Anti-Template | REQUIRED for Gold convergence | No noun-swapped Challenge content shape |

Any required row not `PASS` with appropriate evidence means `GOLD CHALLENGE = FAIL` and blocks Gold Founder Review. Existing Gold is not grandfathered against later canonical Challenge quality.""",
)

six_acceptance = 'docs/templates/PHOENIX_SIX_STAGE_JOURNEY_ACCEPTANCE_MATRIX.md'
replace_once(
    six_acceptance,
    '**Use for:** every new Journey and every material Story or Journey-flow repair.',
    '**Use for:** every new Journey, every material Story or Journey-flow repair, and every current Gold Journey when Challenge Gold re-audit is required.',
)
append_once(
    six_acceptance,
    '### Stage 3 all-Gold convergence evidence',
    """
### Stage 3 all-Gold convergence evidence

For current-Gold Challenge re-audit, record the dynamic merged-main Gold registry identity, complete Lv1-Lv10 × three-mode coverage, all canonical §3 blocking gates, the all-Gold matrix result, defect codes and repairs, Lv1/Lv5/Lv10 human review, and cross-Gold anti-template result. Previous Gold approval is not acceptance evidence for a newly introduced Challenge gate.
""",
)

# Strengthen governance regression without pretending machine checks prove human quality.
test = Path('app/test/challenge_gold_governance_test.dart')
text = test.read_text()
old = """      'HUMAN CHALLENGE REVIEW',
    ]) {
      expect(standard, contains(required), reason: required);
    }
"""
new = """      'HUMAN CHALLENGE REVIEW',
      'EXISTING GOLD IS NOT GRANDFATHERED AGAINST NEW CANONICAL CHALLENGE QUALITY',
      'PHOENIX ALL-GOLD CHALLENGE MATRIX',
      'PASS BY LEGACY APPROVAL',
      'AUDIT FIRST',
      'STANDARDIZE THE QUALITY PROCESS. DO NOT STANDARDIZE THE CONTENT SHAPE.',
      'LV1 HUMAN CHALLENGE REVIEW',
      'LV5 HUMAN CHALLENGE REVIEW',
      'LV10 HUMAN CHALLENGE REVIEW',
      'NO LEGACY CONTAMINATION',
      'NO CROSS-JOURNEY CONTAMINATION',
      'LANGUAGE LEARNING VALUE',
    ]) {
      expect(standard, contains(required), reason: required);
    }
"""
if old not in text:
    raise SystemExit('governance test primary anchor missing')
text = text.replace(old, new, 1)
old2 = """    expect(creation, contains('Challenge Design → Challenge Gold Audit'));
  });
}
"""
new2 = """    expect(creation, contains('CHALLENGE DESIGN → CHALLENGE GOLD AUDIT'));
    expect(creation, contains('Challenge Gold global convergence precondition'));
    expect(creation, contains('existing Gold Challenge is not grandfathered'));
    expect(design, contains('All-Gold Challenge audit matrix'));
    expect(design, contains('Cross-Gold anti-template record'));
    expect(quality, contains('Existing-Gold Challenge convergence gate'));
    expect(behavior, contains('Challenge Gold global audit behavior'));
    expect(acceptance, contains('Cross-Gold Anti-Template'));

    final sixAcceptance = _repoText(
      'docs/templates/PHOENIX_SIX_STAGE_JOURNEY_ACCEPTANCE_MATRIX.md',
    );
    expect(sixAcceptance, contains('every current Gold Journey'));
    expect(sixAcceptance, contains('Stage 3 all-Gold convergence evidence'));
  });
}
"""
if old2 not in text:
    raise SystemExit('governance test secondary anchor missing')
test.write_text(text.replace(old2, new2, 1))

# Record this PR's bounded adoption responsibility without starting the global line.
append_once(
    'docs/DATONG_YUNGANG_GOLD_REMEDIATION_RECORD.md',
    '## Challenge Gold global adoption boundary',
    """
## Challenge Gold global adoption boundary

PR #186 establishes the canonical Challenge Gold governance while keeping the active product/content remediation scope on Datong. It does not begin the all-Gold remediation line and does not authorize another branch or PR.

After this adoption candidate is Founder-approved and merged, the next development priority is the single **PHOENIX ALL-GOLD CHALLENGE AUDIT AND REMEDIATION** line from merged current `main`, before new Journey Story development unless the Founder explicitly changes priority. Existing Gold Challenge receives no grandfather exemption; Founder-approved Story spines remain locked by default during Challenge remediation.
""",
)

# Remove one-shot transport files from the final product tree.
Path('tools/challenge_gold_global_adoption_patch.py').unlink(missing_ok=True)
Path('.github/workflows/challenge_gold_global_adoption_once.yml').unlink(missing_ok=True)
