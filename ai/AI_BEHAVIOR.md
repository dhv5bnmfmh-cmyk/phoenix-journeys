# Phoenix AI Behavior

AI 是同行者，不是冷漠的评分机器。

## Must

- 回应 Explorer 的每次有效输入
- 先理解表达，再指出改进
- 解释为什么需要修改
- 给出更自然但符合 Explorer 水平的版本
- 不确定事实时明确说明
- 区分事实、解释、推测和传说

## Must Not

- 编造历史、地点、人物或科学知识
- 使用羞辱、焦虑或命令式语言
- 将未经审核的 AI 内容直接写入生产数据库
- 用复杂表达压倒初级 Explorer

## Binding Journey Story truth + place-causality behavior

Before drafting, repairing, evaluating, or preparing any Phoenix Journey Story for Gold acceptance, the Agent MUST read and follow [PHOENIX NARRATIVE AND DISCOVERY STANDARD](../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md), [PHOENIX NEW JOURNEY CREATION STANDARD](../docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md), and the canonical semantic gate implemented in `app/lib/data/journey_semantic_fingerprint_catalog.dart`.

The mandatory development order is:

> **FACT FIRST** → **PLACE CAUSALITY** → **STORY MECHANISM** → **ANTI-TEMPLATE COMPARISON** → **LV1 CAUSAL PROOF** → **STORY LOCK** → **LV1-LV10 EXPANSION** → **STORY / DISCOVERY SEPARATION** → **LEARNING PACKAGE** → **GOLD PROMOTION**

The Agent MUST NOT jump from a location name directly to a full Lv1-Lv10 Story.

Before Story lock the Agent MUST:

1. research the real place using the binding source hierarchy: UNESCO/equivalent heritage authority; government; official museum/heritage/monument authority; official cultural institution; reputable academic/institutional source when required;
2. classify every material Story premise as `VERIFIED FACT`, `FICTIONAL CHARACTER ACTION`, `FICTIONAL DIALOGUE`, `FICTIONAL PERSONAL MOTIVATION`, `INTERPRETIVE STORY DEVICE`, or `UNSUPPORTED FACTUAL CLAIM`;
3. trace every verified factual premise that materially supports Goal, Conflict, Choice, Climax, Consequence, Transformation, Ending, Cultural Anchor, or dramatic engine to approved source evidence;
4. keep fictional protagonists, dialogue, motives, present-day actions, and protagonist-created objects clearly fictional and compatible with the verified setting;
5. never invent historical events, heritage rules, architecture, conservation restrictions, cultural practices, named historical actions, spatial facts, causal explanations, real-person dialogue, real-person intentions, or other factual premises because they make the Story work;
6. distinguish observed spatial effect from documented historical intention; one does not prove the other;
7. create a `PLACE_CAUSAL_MECHANISM` record identifying the verified place property, authoritative evidence, generic-place substitution result, and affected Story causal dimensions;
8. reject a Story whose Goal → Conflict → Choice → Climax → Consequence remains substantially unchanged when the named place is replaced with a generic park, café, museum, old street, school, or unrelated attraction;
9. define the Story architecture before full prose: protagonist, relationship geometry, goal, conflict, choice, climax, consequence, transformation, ending, cultural-anchor function, and dramatic engine;
10. compare the candidate against every approved Gold semantic fingerprint using the existing Rule A / Rule B gate;
11. require Lv1 to contain the causal skeleton before any Lv2-Lv10 expansion;
12. record machine-verifiable contract evidence separately from human/Founder semantic-sufficiency and literary review.

The Agent MUST use these exact stop outcomes where applicable:

- `SOURCE EVIDENCE INSUFFICIENT — STORY DEVELOPMENT STOPPED`
- `UNVERIFIED FACTUAL CLAIM — BLOCKED`
- `GENERIC-PLACE STORY — NOT GOLD READY`
- `TEMPLATE COLLISION - NOT GOLD READY`
- `LV1 CAUSAL PROOF FAILED — DO NOT EXPAND`

The Agent MUST NOT continue after a binding STOP condition, fabricate a workaround, use tourism blogs/social posts/unsourced travel articles/AI summaries as binding factual evidence, weaken tests to admit a candidate, or add filler facts merely to create drama.

Distinctness never overrides truth. If a unique dramatic engine depends on an unsupported factual premise, the Agent MUST remove the premise, replace it with a verified place mechanism, convert only the character action into clearly fictional contemporary behavior where truthful, or stop.

## Binding Journey semantic anti-template behavior

When drafting, repairing, evaluating, or preparing a Phoenix Journey for Gold acceptance, the Agent MUST first read and follow [PHOENIX NARRATIVE AND DISCOVERY STANDARD](../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md) and the canonical normalized semantic catalog implemented in `app/lib/data/journey_semantic_fingerprint_catalog.dart`.

For every NEW Gold Journey candidate, the Agent MUST:

1. inspect the complete approved-Gold semantic fingerprint catalog before drafting the final Story;
2. define the candidate normalized semantic fingerprint before final Story approval;
3. compare the candidate against every approved Gold Journey using the deterministic CORE collision gate;
4. cite exact active-Story evidence for every CORE mechanism;
5. provide a concise semantic rationale for every CORE mechanism that explains the causal mapping from the cited Story evidence to the normalized mechanism family;
6. cite enough focused active-Story spans to demonstrate the causal function when one sentence is insufficient, without copying whole Story levels as evidence padding;
7. avoid bare landmark names, protagonist biographies, incidental scenery, or other surface facts as evidence for a causal mechanism unless that surface fact is itself the dimension being evidenced;
8. reject `TEMPLATE COLLISION - NOT GOLD READY` rather than changing names, cities, professions, objects, descriptive wording, visual motifs, or enum labels to disguise reused causal structure;
9. prefer an existing reusable `NarrativeMechanismFamily` whenever its causal function is materially equivalent;
10. if a genuinely new mechanism family is proposed, record why no existing family is semantically equivalent, which nearest existing families were considered, and what causal distinction makes the new family necessary before the taxonomy is extended;
11. redesign the dramatic engine and causal mechanism when a collision is found, rather than laundering the same mechanism through a near-synonym enum;
12. update Narrative DNA, semantic fingerprints, Story-evidence spans, and semantic rationales only from the final active canonical Story, never from an abandoned or legacy Story package;
13. rerun semantic anti-template tests after any Story or fingerprint change that can affect opening, conflict, choice, climax, consequence, transformation, relationship, ending, cultural-anchor function, or dramatic engine.

The Agent MUST distinguish **Evidence Provenance** from **Semantic Sufficiency**. Deterministic CI can verify active-source identity, exact Story-span presence, dimension/mechanism alignment, non-empty rationale fields, approved source-record presence, fact/fiction classification fields, declared generic-substitution outcome, and Lv1 causal-contract completeness. CI MUST NOT be represented as independently understanding whether arbitrary natural-language Story prose semantically entails an enum, whether a factual interpretation is intellectually honest, whether a Story truly feels native to the place, or whether prose works emotionally. Founder/Agent review remains responsible for those judgments.

The Agent MUST NOT create a Journey-specific semantic category, bypass, allowlist, Founder-name exception, city exception, temporary exception, hard-coded `PASS`, alternate test-only classification, or near-synonym mechanism family solely to evade a collision. Existing approved-Gold semantic collision debt must be surfaced honestly and must not be used as precedent for a future candidate.

## Binding Journey background production behavior

When generating, replacing, evaluating, or integrating Phoenix Journey background images, the Agent MUST first read and follow [PHOENIX AI BACKGROUND PRODUCTION STANDARD](../docs/PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md).

The background standard is binding, not advisory. In particular:

- no background image generation may start before Visual DNA + Cross-Journey Differentiation + Shot Plan + 1–3 Pilot plan are complete;
- no full production library may be generated before Pilot approval;
- no runtime integration is allowed without Rights Gate `PASS` and IP Similarity Review `PASS`;
- canonical Journey Story content is read-only during visual production;
- automated scores or metadata do not replace human visual judgment or Founder approval where required;
- the current stable visual baseline MUST NOT be lowered;
- no Agent may hard-code `PASS`, skip Rights review, skip required Founder review, skip the Pilot rule, create an undocumented Journey-specific exception, weaken or remove tests, or change canonical Story merely to get background production accepted.

Any exception MUST be explicit, documented, scoped, and Founder-approved where the governing Phoenix standard requires it.
