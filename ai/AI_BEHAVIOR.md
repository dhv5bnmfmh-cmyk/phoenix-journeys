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

## Binding Journey semantic anti-template behavior

When drafting, repairing, evaluating, or preparing a Phoenix Journey for Gold acceptance, the Agent MUST first read and follow [PHOENIX NARRATIVE AND DISCOVERY STANDARD](../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md) and the canonical normalized semantic catalog implemented in `app/lib/data/journey_semantic_fingerprint_catalog.dart`.

For every NEW Gold Journey candidate, the Agent MUST:

1. inspect the complete approved-Gold semantic fingerprint catalog before drafting the final Story;
2. define the candidate normalized semantic fingerprint before final Story approval;
3. compare the candidate against every approved Gold Journey using the deterministic CORE collision gate;
4. provide exact active-Story evidence for every CORE mechanism;
5. reject `TEMPLATE COLLISION - NOT GOLD READY` rather than changing names, cities, professions, objects, descriptive wording, or visual motifs to disguise reused causal structure;
6. redesign the dramatic engine and causal mechanism when a collision is found;
7. update Narrative DNA and Story-evidence records only from the final active canonical Story, never from an abandoned or legacy Story package;
8. rerun semantic anti-template tests after any Story change that can affect opening, conflict, choice, climax, consequence, transformation, relationship, ending, cultural-anchor function, or dramatic engine.

The Agent MUST NOT create a Journey-specific semantic category, bypass, allowlist, Founder-name exception, city exception, temporary exception, hard-coded `PASS`, or alternate test-only classification. Existing approved-Gold semantic collision debt must be surfaced honestly and must not be used as precedent for a future candidate.

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
