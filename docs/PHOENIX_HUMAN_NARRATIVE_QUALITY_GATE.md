# Phoenix Human Narrative Quality Gate

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Applies to:** New Journeys, Story remediation, Gold candidates, Gold promotion review  
**Stable baseline rule:** `NEW RESULT >= CURRENT STABLE BASELINE`

This standard supplements the Phoenix Narrative and Discovery Standard, Phoenix New Journey Creation Standard, Phoenix Product Quality Standard, Phoenix Development Completion Standard, and their acceptance matrices. Where another standard already imposes a stricter requirement, the stricter requirement governs.

## 1. Purpose

Phoenix separates three different kinds of approval:

1. **Machine / deterministic contract verification**;
2. **Agent human-quality semantic and literary review**;
3. **Founder Story approval tied to an exact candidate and Preview**.

These three results MUST NOT be collapsed into one generic `PASS`.

A machine result such as `360 / 360`, `100 / 100`, `Rule A = 0`, `Rule B = 0`, complete evidence fields, or green CI does not establish literary quality, human-perceived originality, emotional effectiveness, or Founder approval.

## 2. Mandatory authority states

Every new Journey, Story remediation, and Gold candidate MUST record these states separately:

```text
MACHINE_CONTENT_GATE: PASS / FAIL
MACHINE_SEMANTIC_GATE: PASS / FAIL
AGENT_SEMANTIC_SUFFICIENCY: PASS / REQUIRES_REVISION / BLOCKED / PENDING
AGENT_LITERARY_REVIEW: PASS / REQUIRES_REVISION / BLOCKED / PENDING
HUMAN_NARRATIVE_ANTI_TEMPLATE: PASS / REQUIRES_REVISION / BLOCKED / PENDING
FOUNDER_STORY_APPROVAL: APPROVED / REJECTED / PENDING
OVERALL_STORY_QUALITY: PASS / REQUIRES_REVISION / BLOCKED / PENDING
```

`OVERALL_STORY_QUALITY = PASS` is permitted only when all applicable machine gates are `PASS`, all required Agent/human gates are `PASS`, and Founder approval is `APPROVED` where the governing phase requires Founder approval.

If Agent literary review or human anti-template review has not occurred, the only truthful overall result is `PENDING` or a stricter failure state.

## 3. Reader-perceived originality is a blocking requirement

Semantic fingerprints are a deterministic floor, not the full originality decision.

Every Story candidate MUST undergo a **de-skinned narrative comparison** against every current Founder-approved Gold Story.

For this comparison, temporarily remove or ignore surface identity such as:

- city and landmark names;
- character names;
- age when incidental;
- profession when incidental;
- named artifact or object;
- visual motif;
- weather, time of day, and cosmetic setting detail;
- taxonomy labels and mechanism-family names.

Then compare the actual event-and-decision spine:

> OPENING TRIGGER → DESIRE → STAKES → RELATIONSHIP PRESSURE → CONFLICT → FAILED ASSUMPTION / FAILURE MODE → CHOICE → COST → CLIMAX → CONSEQUENCE → TRANSFORMATION → ENDING BEHAVIOR

The reviewer MUST also compare:

- place-causal function;
- information-reveal pattern;
- relationship geometry;
- source of pressure;
- emotional movement;
- memory anchor function;
- scene rhythm;
- reader experience.

If a candidate remains materially the same Story after surface details are removed, the result is:

`HUMAN NARRATIVE TEMPLATE REUSE — NOT GOLD READY`

This blocks Story Lock, Gold promotion, and any claim of Story Quality `PASS`, even when Rule A and Rule B are both zero.

## 4. No taxonomy laundering

A new dramatic-engine name, Narrative DNA phrase, fingerprint enum, or semantic family does not make a Story original.

Taxonomy MUST describe a causal distinction already visible in the Story.

The reviewer MUST be able to explain the decisive difference from the nearest approved Gold in ordinary reader-facing language without using:

- enum names;
- semantic fingerprint fields;
- Rule A / Rule B arithmetic;
- governance terminology.

If the distinction only exists in metadata, classification prose, or mechanism naming, the candidate is blocked as:

`NARRATIVE MECHANISM TAXONOMY LAUNDERING — BLOCKED`

## 5. Place-irreplaceability gate

The Story MUST be materially changed if its verified place-causal property is removed or replaced.

The reviewer MUST perform both:

1. the generic-place substitution test required by the Narrative and Discovery Standard; and
2. at least three approved-Gold substitution probes using materially different existing Journey locations.

If Goal → Conflict → Choice → Climax → Consequence survives with only cosmetic edits, the result is:

`GENERIC-PLACE STORY — NOT GOLD READY`

A location name or cultural fact appended to an otherwise reusable plot does not pass.

## 6. Human stakes and conflict quality gate

A Story is not Gold-quality merely because all structural fields exist.

Agent literary review MUST judge whether:

- the protagonist wants something specific for a believable human reason;
- the outcome matters beyond completing a generic assignment or task;
- the relationship creates pressure, obligation, trust, disagreement, dependence, loss, responsibility, or another causal force where a relationship is present;
- conflict is more than missing information, task difficulty, or a defective first prototype;
- the protagonist faces competing needs, interpretations, loyalties, risks, responsibilities, or consequences;
- doing nothing has a meaningful consequence where the Story architecture requires urgency;
- the Story contains enough pressure to justify its decisive moment.

A mechanically complete Story with negligible human stakes MUST be `REQUIRES_REVISION`.

## 7. Choice, cost, climax, and consequence gate

The key Choice MUST expose character and alter the causal path.

The reviewer MUST identify:

```text
Choice:
What competing value / need is rejected or accepted:
Cost / risk / commitment:
Why the choice is not automatic:
What becomes irreversible or newly committed:
Climax caused by the choice:
Visible consequence:
```

A generic `try again`, `make it clearer`, `collect more information`, `take another photograph`, `redesign the object`, or equivalent optimization is insufficient by itself.

The climax MUST do more than demonstrate that the revised method works. It MUST resolve or expose the central Story pressure.

## 8. Transformation and ending gate

Transformation MUST be demonstrated through a changed action, relationship, responsibility, willingness, decision, habit, or way of seeing.

A concluding explanation such as `她终于明白……`, `他意识到……`, or another moral summary does not by itself satisfy transformation.

The ending MUST be compared with the current Gold catalog for both mechanism and reader-perceived rhythm.

## 9. Memory-anchor uniqueness gate

Every candidate MUST declare one durable Journey-specific memory anchor.

The anchor may be an image, gesture, action, sentence, object, spatial moment, decision, relationship moment, or another Story-native element.

Objects such as cards, notebooks, photographs, maps, diagrams, models, foldouts, arrows, worksheets, or prototypes MUST NOT become default Phoenix Story devices.

The reviewer MUST answer:

> If the reader remembers one thing from this Story a week later, what is it, and why could that memory not belong equally well to another approved Journey?

If the answer is interchangeable, the candidate requires revision.

## 10. Pre-lock architecture alternatives

Before Story Lock for a new Story or a Founder-authorized substantial remediation, the Agent MUST consider at least three **structurally distinct** Story architectures.

They must differ in more than names, professions, objects, location labels, or wording. At minimum the alternatives SHOULD vary several of:

- relationship geometry;
- personal stakes;
- source of conflict;
- pressure mechanism;
- choice and cost;
- climax mechanism;
- transformation;
- memory anchor;
- ending behavior.

The design record MUST state why the selected architecture is stronger and why the rejected alternatives are weaker, less place-causal, less truthful, less distinctive, or less emotionally effective.

This is a design-quality requirement, not permission to draft three complete Lv1-Lv10 packages. Full level expansion remains prohibited before Story Lock.

## 11. Mandatory nearest-Gold review

After all-Gold semantic comparison, the Agent MUST identify the nearest Story at the human narrative level.

Required record:

```text
Nearest approved Gold Journey:
Shared surface elements:
Shared structural elements:
De-skinned candidate spine:
De-skinned reference spine:
Decisive event-level differences:
Relationship difference:
Choice / cost difference:
Climax difference:
Ending difference:
Place-causal difference:
Why a reader would not confuse the two:
Result:
```

`Different dramatic-engine enum` is not an acceptable decisive difference.

## 12. Human narrative anti-template pairwise matrix

Every candidate MUST be reviewed against every current approved Gold Story using the canonical record template:

`docs/templates/PHOENIX_HUMAN_NARRATIVE_QUALITY_GATE_RECORD.md`

Each pair receives an independent human result. One strong difference against one Journey does not substitute for the remaining catalog comparisons.

Any blocking pair blocks Gold readiness.

## 13. Quality-report language boundary

Automated content-quality tooling MAY report:

- automated contract `PASS` / `FAIL`;
- counts;
- scores;
- structural issues;
- language-level issues;
- evidence provenance;
- deterministic semantic collisions.

It MUST NOT label those outputs as overall literary approval, Founder approval, or Gold Story approval.

Machine tooling SHOULD use language such as:

`AUTOMATED CONTENT GATE: PASS — ELIGIBLE FOR HUMAN REVIEW`

and MUST expose human / Founder status separately.

When human review has not been supplied, automated reports MUST explicitly show:

```text
AGENT_LITERARY_REVIEW: PENDING
HUMAN_NARRATIVE_ANTI_TEMPLATE: PENDING
FOUNDER_STORY_APPROVAL: PENDING
OVERALL_STORY_QUALITY: PENDING
AUTOMATED_SCORE_USED_AS_LITERARY_APPROVAL: NO
```

## 14. Story rewrite verification

When a remediation task is explicitly intended to improve Story quality, the final report MUST state:

```text
STORY_CONTENT_CHANGED: YES / NO
OLD_STORY_ARCHITECTURE:
NEW_STORY_ARCHITECTURE:
WHY_CHANGE_WAS_NEEDED:
WHY_NEW_VERSION_IS_STRONGER:
```

If `STORY_CONTENT_CHANGED = NO`, the Agent MUST provide a full human-quality review proving the existing Story remains the strongest compliant architecture. Green CI is not sufficient evidence.

## 15. Exact-head Founder experience boundary

No Story is Founder-approved merely because a Preview was deployed.

Founder review MUST be tied to the exact candidate SHA and exact-head Preview required by the Development Completion Standard.

The final pre-Founder state is:

```text
MACHINE_CONTENT_GATE: PASS
MACHINE_SEMANTIC_GATE: PASS
AGENT_SEMANTIC_SUFFICIENCY: PASS
AGENT_LITERARY_REVIEW: PASS
HUMAN_NARRATIVE_ANTI_TEMPLATE: PASS
FOUNDER_STORY_APPROVAL: PENDING
OVERALL_STORY_QUALITY: PENDING FOUNDER APPROVAL
```

Only explicit Founder approval may advance the Founder field.

## 16. Binding stop codes

The following stop codes are added to the Phoenix Story-quality system:

- `HUMAN_NARRATIVE_TEMPLATE_REUSE`
- `HUMAN_LITERARY_REVIEW_MISSING`
- `READER_PERCEIVED_NARRATIVE_DUPLICATION`
- `STORY_QUALITY_STATUS_CONFLATION`
- `NARRATIVE_MECHANISM_TAXONOMY_LAUNDERING`
- `HUMAN_STAKES_INSUFFICIENT`
- `CHOICE_COST_INSUFFICIENT`
- `CLIMAX_ONLY_PROVES_METHOD`
- `MEMORY_ANCHOR_INTERCHANGEABLE`

Each blocking-code record MUST include exact Story evidence, compared Journey IDs where applicable, required action, reviewer, and verification method.

## 17. Completion rule

A candidate MUST NOT be reported as `STORY REMEDIATION COMPLETE`, `GOLD READY`, `NARRATIVE QUALITY PASS`, or equivalent when any required human/Agent/Founder state is `PENDING`, `REQUIRES_REVISION`, or `BLOCKED`.

Machine green is necessary evidence. It is never a substitute for human narrative judgment.
