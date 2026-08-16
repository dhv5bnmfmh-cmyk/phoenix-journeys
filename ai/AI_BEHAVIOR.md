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

Before drafting, repairing, evaluating, or preparing any Phoenix Journey Story for Gold acceptance, the Agent MUST read and follow [PHOENIX NARRATIVE AND DISCOVERY STANDARD](../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md), [PHOENIX NEW JOURNEY CREATION STANDARD](../docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md), [PHOENIX NEW JOURNEY ACCEPTANCE MATRIX](../docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md), and the canonical semantic gate implemented in `app/lib/data/journey_semantic_fingerprint_catalog.dart`.

## Binding Journey Content Expansion Behavior

Before proposing a new Journey candidate the Agent MUST:

- Identify the Expansion Layer (LAYER 1: National Coverage; LAYER 2: City Place Network; LAYER 3: Place Story Universe).
- Read Parent geographic hierarchy and declare Parent Province-Level Region, Parent City, and Parent Place when applicable.
- Read same-Place active Story inventory and City inventory and the Founder-approved Gold catalog.
- Declare Truth Mode, Incremental Cultural Value, and Incremental Human Value for the candidate.
- Run Same-Place collision and Whole-library differentiation (machine + human gates) prior to STORY LOCK.

One City != One Story; One Place != One Story. Continue to follow existing Gold / Truth / Place Causality rules. Do not treat any Pilot method as a content template.

Summer Palace Founder-approved Method Pilot is NOT a Story template, Level template, Cultural template, or Place Story Universe template.

Before developing a new Journey candidate that targets the same Place the Agent MUST:

- Read the same-Place active Story inventory.
- Read the City inventory.
- Read the whole Founder-approved Gold catalog.
- Declare the candidate's Truth Mode and record evidence classification.
- Demonstrate Incremental Cultural Value and Incremental Human Value in writing with supporting evidence paths.
- Execute a human Same-Place differentiation (compare opening, protagonist, relationship, Goal, Conflict, Choice, Cost, Climax, Consequence, Memory Moment, Story Shape, and cultural mechanism) and record the differentiation result.

Only after these items pass may the Agent proceed with pre-lock architecture and the normal Story development gates. 

The mandatory development order is:

> **FACT FIRST** → **PLACE CAUSALITY** → **STORY MECHANISM** → **MACHINE ANTI-TEMPLATE** → **HUMAN STORY DIFFERENTIATION** → **LV1 CAUSAL + HUMAN PROOF** → **STORY LOCK** → **LV1-LV10 EXPANSION** → **STORY / DISCOVERY SEPARATION** → **LEARNING PACKAGE** → **GOLD PROMOTION**

The Agent MUST NOT jump from a location name directly to a full Lv1-Lv10 Story.

Before Story lock the Agent MUST:

1. research the real place using the binding source hierarchy: UNESCO/equivalent heritage authority; government; official museum/heritage/monument authority; official cultural institution; reputable academic/institutional source when required;
2. classify every material Story premise using the canonical world/character categories in §18.3; a fictional ordinary character's identity, backstory, relationship, private action, dialogue, motivation, choice, cost, and personal consequence do not require documentary proof merely because the Story has a historical setting;
3. trace every verified factual premise that materially supports Goal, Conflict, Choice, Climax, Consequence, Transformation, Ending, Cultural Anchor, or dramatic engine to approved source evidence;
4. keep fictional protagonists, relationships, dialogue, motives, historical or present-day private actions, and protagonist-created objects clearly fictional, historically/socially/physically plausible, and compatible with the verified setting;
5. never invent historical events, heritage rules, architecture, conservation restrictions, cultural practices, named historical actions, spatial facts, causal explanations, real-person dialogue, real-person intentions, or other factual premises because they make the Story work;
6. distinguish observed spatial effect from documented historical intention; one does not prove the other;
7. create a `PLACE_CAUSAL_MECHANISM` record identifying the verified place property, authoritative evidence, generic-place substitution result, and affected Story causal dimensions;
8. reject a Story whose current Goal → Conflict → Choice → Climax → Consequence remains substantially unchanged when the verified place mechanism is removed or replaced by the genuine generic-place condition; do not transplant the place-specific cause, institution, event, property, or fictional setup into the control case;
9. define Story architecture before full prose: protagonist, relationship geometry, goal, human stakes, conflict, choice, cost, climax, consequence, transformation, ending, Story Shape, Memory Moment, cultural-anchor function, and dramatic engine;
10. compare the candidate against every approved Gold semantic fingerprint using the existing Rule A / Rule B machine gate;
11. separately compare the de-skinned Story spine against every approved Gold Story at the human-reader level;
12. for new Stories and Founder-authorized major remediation, consider at least three genuinely different architectures before Lv1 and choose the strongest one;
13. require Lv1 to pass both `LV1 CAUSAL PROOF` and `LV1 HUMAN STORY PROOF` before any Lv2-Lv10 expansion;
14. use Lv5 as the primary literary review level and verify Lv10 deepens character, relationship, environment, cultural context, and psychological texture rather than merely adding exposition;
15. run `LAST_EXPLANATION_REMOVAL_TEST` after the Story is complete;
16. record machine-verifiable contract evidence separately from Agent semantic sufficiency, Agent literary review, human anti-template review, and Founder approval.

The Agent MUST use these exact stop outcomes where applicable:

- `SOURCE EVIDENCE INSUFFICIENT — STORY DEVELOPMENT STOPPED`
- `UNVERIFIED FACTUAL CLAIM — BLOCKED`
- `GENERIC-PLACE STORY — NOT GOLD READY`
- `TEMPLATE COLLISION - NOT GOLD READY`
- `HUMAN STORY COLLISION — NOT GOLD READY`
- `LV1 CAUSAL PROOF FAILED — DO NOT EXPAND`
- `LV1 HUMAN STORY PROOF FAILED — DO NOT EXPAND`

`SOURCE EVIDENCE INSUFFICIENT` applies only when a required world claim cannot be verified or every plausible architecture would require a prohibited invented world fact. A failed fictional plot means `REDESIGN`; it does not by itself prove that the Journey is evidence-blocked.

The Agent MUST NOT search endlessly for a documented historical individual to serve as protagonist, reject a fictional ordinary character because private choices lack sources, or treat `FICTIONAL CHARACTER ACTION` as `UNSUPPORTED FACTUAL CLAIM`. The Agent MUST verify every world claim the fictional character encounters. The binding construction model is:

> **VERIFIED WORLD + FICTIONAL HUMAN CHARACTER + PLAUSIBLE FICTIONAL HUMAN ACTION = VALID HISTORICAL-CULTURAL FICTION**

`PHOENIX PROTECTS THE TRUTH OF THE WORLD, NOT THE DOCUMENTARY EXISTENCE OF EVERY FICTIONAL CHARACTER.` Fiction may create human meaning. Fiction may not create false history.

The Agent MUST NOT continue after a binding STOP condition, fabricate a workaround, weaken tests to admit a candidate, or add filler facts merely to create drama. Distinctness never overrides truth.

## Binding Journey semantic anti-template behavior

For every NEW Gold Journey candidate, the Agent MUST:

1. inspect the complete approved-Gold semantic fingerprint catalog before drafting the final Story;
2. define the candidate normalized semantic fingerprint before final Story approval;
3. compare it against every approved Gold Journey using deterministic CORE collision Rule A / Rule B;
4. cite exact active-Story evidence and a semantic rationale for every CORE mechanism;
5. reject collisions rather than disguising reused causality through names, cities, professions, objects, wording, visual motifs, or enum labels;
6. prefer an existing reusable `NarrativeMechanismFamily` whenever causally equivalent;
7. prohibit taxonomy laundering and Journey-specific near-synonym families created to evade collision;
8. update Narrative DNA, fingerprints, Story evidence, and rationales only from the final active Story;
9. rerun the semantic anti-template gate after any Story or fingerprint change that can affect causal structure.

Rule A = 0 and Rule B = 0 mean only `MACHINE SEMANTIC COLLISION = PASS`. They MUST NOT be represented as `HUMAN STORY DIFFERENTIATION = PASS`, literary approval, Founder approval, or Gold readiness.

## Binding human Story quality behavior

Phoenix Gold Story must first work as an independent Chinese short story: a reader should want to finish it and be able to remember the person, the place, and one decisive moment. Cultural knowledge must enter lived action. Place must change what happens. Causality should live inside the Story instead of reading like a test case.

### Chinese narrative quality

`中国人的方式` MUST NOT be reduced to idioms, archaic diction, costumes, poetry, historical protagonists, or one prescribed traditional value. Human review SHOULD look for lived Chinese narrative texture such as family, friendship, apprenticeship, neighbors, colleagues, old customers, strangers helping one another, responsibility, promise, debt, trust, reluctance to part, dignity, silence, and tacit understanding when organically required by the Story.

Small actions are allowed to carry large meaning. Prefer action over explanation, and leave room for silence. Environment such as rain, light, water, doors, bridges, alleys, sound, wind, shadow, crowd flow, and occlusion SHOULD participate in pacing and pressure instead of functioning as a fact container.

### Protagonist humanity

Every Story review MUST answer:

- What does this person actually want?
- Why today?
- Why can it not simply wait until tomorrow?
- Why can the protagonist not walk away?
- What happens if it fails?
- What do they refuse to admit?
- What are they reluctant to lose?
- What do they fear losing?
- Why does another person matter, when another person is present?

If the answers reduce to `because the assignment/task requires it`, `PROTAGONIST HUMANITY = FAIL`.

### Relationship causality

Delete the supporting character and reread the Story. If Goal, Conflict, Choice, Climax, and Ending remain substantially unchanged, `RELATIONSHIP NOT CAUSAL = FAIL`. A friend must not exist only to test a prototype, ask one convenient question, announce the answer, or validate the protagonist.

### Goal, Choice, Cost, Climax, Transformation

Completing an assignment, design, report, photograph, survey, or artifact is a weak default Goal unless personal need, relationship need, identity judgment, or real-world stakes make it matter.

Every major Choice MUST receive `COST OF CHOICE REVIEW`: what is lost, missed, risked, exposed, assumed, or promised? A choice that is only a better method is not enough by itself.

A climax MUST NOT default to `the friend understood`, `the prototype worked`, `the object did not break`, `the teacher approved`, or `the report passed`. Those are validation results. The climax should expose a decision under pressure, an irreversible relationship change, a relinquishment, an accepted consequence, an action the protagonist previously would not take, or a place-driven truth that can no longer be avoided.

Transformation SHOULD be behavioral. `她意识到……`, `他明白……`, or `她终于懂得……` are not sufficient primary evidence when the Story can show the change through a final action, choice, or relationship response.

### Memory Moment + Story Shape

Every Story MUST declare one literary `STORY MEMORY MOMENT`: if the reader remembers one image a week later, what is it? If no distinct image/action remains, `STORY MEMORY MOMENT = WEAK`.

Every Story MUST also declare its own `STORY SHAPE` in event-level language. Narrative-engine names do not prove shape difference. If two Journeys have substantially the same human-readable shape, prefer rewriting the newer Candidate.

### De-skinned Story Spine

For every Candidate, remove city, attraction, names, profession labels, academic/specialist labels, cultural nouns, and named props, then record only:

`who wants what → why it matters → what blocks them → how relationship creates pressure → what fails → what must be chosen → what the choice costs → what the climax is → what irreversible result follows → how the person changes → final action`.

Compare this spine against every current Founder-approved Gold Story. If two Stories remain highly similar after stripping the skin, `HUMAN STORY COLLISION — NOT GOLD READY` even when Rule A = 0 and Rule B = 0.

The following high-frequency skeleton requires automatic scrutiny and MUST NOT become a Phoenix default engine:

`student receives assignment → first version fails → friend raises question → protagonist re-observes place → redesigns artifact → friend tests again → second version succeeds → protagonist applies method to next project`.

Photography assignments, research projects, design prototypes, maps, cards, worksheets, reports, presentations, peer testing, and teacher evaluation MUST NOT become bulk Story engines merely because their surface subjects differ.

### Catalog diversity and anti-template restraint

Phoenix MUST NOT become a `20-year-old university student universe`. Catalog comparison must consider age/life stage, lived situation, relationship geometry, opening pattern, climax pattern, ending pattern, Memory Moment, and emotional texture. Diversity MUST emerge from Story need, not mechanical occupation quotas.

These quality dimensions are not a replacement Story template. A Story may have an explicit binary Choice or a long-form behavioral change; a countdown or no deadline; a large climax or a quiet irreversible action. Literary quality does not require disaster, death, family rupture, or cinematic escalation.

### Level literary gates

`LV1 HUMAN STORY PROOF` asks whether the protagonist is credible, wants something concrete, has meaningful stakes/relationship where applicable, experiences an event, performs a decisive action, and ends as a Story rather than a knowledge summary. If Lv1 reads like a product requirement, case study, course assignment, or museum explanation, FAIL.

Lv5 is the primary literary review level. Review natural Chinese, character breath, dialogue, exposition, place-in-action, rhythm, AI-engineering tone, memorable scene, and aftertaste.

Lv10 MUST deepen rather than inflate. Additional text should deepen character, relationship, environment, psychological detail, and cultural context, not merely add facts, terminology, history, or theme explanation.

### Last Explanation Removal Test

After the Story is complete, remove the last explanatory sentence. If the Story becomes stronger, more restrained, or more memorable, the sentence MUST stay removed. Ending meaning SHOULD be carried by the final action, relationship response, or image whenever possible.

### Authority states

The Agent MUST keep these separate:

- `MACHINE_CONTENT_GATE`
- `MACHINE_SEMANTIC_GATE`
- `AGENT_SEMANTIC_SUFFICIENCY`
- `AGENT_LITERARY_REVIEW`
- `HUMAN_NARRATIVE_ANTI_TEMPLATE`
- `FOUNDER_STORY_APPROVAL`
- `OVERALL_STORY_QUALITY`

Machine scores, green CI, field completeness, Rule A = 0, or Rule B = 0 MUST NOT infer literary `PASS`. Before explicit Founder approval, `FOUNDER_STORY_APPROVAL = PENDING`.

## Phoenix single-track development

Phoenix has one permanent branch: `main`. At any time the maximum is one active development branch, one active development PR, and one active development line. The source of truth is current remote `main` plus the one explicitly Founder-authorized active development branch.

Before any write, report and verify `STARTING_MAIN_SHA`, `ACTIVE_DEVELOPMENT_BRANCH`, `ACTIVE_DEVELOPMENT_PR`, and `REMOTE_ACTIVE_DEVELOPMENT_LINE_COUNT`. If the count is greater than one, report `MULTIPLE ACTIVE DEVELOPMENT LINES — BLOCKED` and do not write. Every new task must fetch current remote main and create its sole branch from that exact SHA. `RELATED HISTORY != CURRENT SOURCE OF TRUTH`.

Follow `ONE JOURNEY AT A TIME`, `ONE ACTIVE DEVELOPMENT PR AT A TIME`, `ONE ACTIVE DEVELOPMENT BRANCH AT A TIME`, and `ONE ACTIVE DEVELOPMENT LINE`. Old PRs, Preview branches, temporary validation branches, prototypes, and remediation branches are historical evidence, never a starting baseline.

### Journey scope isolation

Before editing Journey-owned learner-visible content, the Agent MUST read Founder authorization and the binding [Journey Scope Isolation Gate](../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md#2013-journey-scope-isolation-gate). Record `AUTHORIZED_BASELINE_SHA` before implementation and derive `AUTHORIZED_JOURNEY_SET` only from Journey IDs explicitly authorized by Founder. A standards-only task that authorizes no Journey learner content has `AUTHORIZED_JOURNEY_SET = EMPTY`.

`SHARED FILE != SHARED AUTHORITY`. Editing one Journey inside a shared catalog does not authorize neighboring Journey Story, title, headline, description, teaser, Entry copy, Vocabulary, Discovery, Reading Support, Wonder, Express, Challenge, Memory, Completion, narration, learner-facing metadata, questions, prompts, translations, or meaning-bearing labels.

The Agent MUST NOT perform opportunistic or nearby content cleanup. `NOTICE != AUTHORIZATION`: report an unrelated defect as `OUT_OF_SCOPE_FINDING` and leave that Journey's learner-visible content unchanged. Test success, better grammar, a useful correction, a tiny delta, or an already-open shared file never expands scope.

Before declaring a candidate Founder-review ready, perform a Journey ownership-level final diff audit against `AUTHORIZED_BASELINE_SHA` and report `AUTHORIZED_JOURNEY_SET`, `SHARED_INFRASTRUCTURE_DELTA`, `OTHER_JOURNEY_CONTENT_DELTA`, and `JOURNEY_SCOPE_LEAKAGE`. If unauthorized learner-visible content belonging to any `OUT_OF_SCOPE_JOURNEY` changed, stop with `JOURNEY_SCOPE_LEAKAGE` and `SCOPE LEAKAGE — NOT READY FOR FOUNDER APPROVAL`.

Leakage may be restored only when baseline provenance is deterministic and the restoration is itself authorized, or when Founder explicitly expands `AUTHORIZED_JOURNEY_SET`. The Agent MUST NOT silently convert discovered work into authorized work. Green CI is validation evidence, never scope authorization.

The scope audit is SHA-bound together with Founder review. Any later source commit invalidates the prior exact-head scope audit and prior Founder approval and requires a new exact-head audit, Preview validation where applicable, and Founder review.

### No silent product replacement

`ABSENCE OF AUTHORIZATION = PRESERVE CURRENT MAIN`. A historical checkout must never restore or overwrite current UI, navigation, runtime, six-stage behavior, active Story, or any other unauthorized product surface. Before writing, create a `PROTECTED BASELINE MANIFEST` covering the current main SHA, scoped screen/runtime path, active Story source, Journey IDs, six-stage behavior, and UI/navigation behavior. Closeout must prove the authorized delta plus protected baseline parity.

`FILE EXISTS != ACTIVE PRODUCT`. Audit and implementation authority follow `ACTIVE RUNTIME`, `ACTIVE RESOLVER`, `ACTIVE BINDING`, and `CURRENT MAIN`; inactive file residue is archive evidence only. Founder approval remains SHA-bound: PR head, Founder-reviewed Candidate, and Preview release must be identical, and any source commit invalidates prior approval.

Founder-approved Stories are reviewable for quality debt but MUST NOT be modified merely because the Agent recommends reopening them. Record `REOPEN RECOMMENDED` and wait for Founder authorization. An unapproved active Candidate may be remediated directly within its authorized Story scope.

### Story × Culture × Level behavior

The Agent MUST apply [Canonical Story × Culture × Level Standard](../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md#19-canonical-story--culture--level-standard): cultural knowledge creates Story pressure through character action; every important fact passes the Cultural Fact Action Test; place mechanisms survive human causality review; Story encounter precedes Discovery explanation; Discovery defaults to `2/2/2/2/3/3/3/3/3/3`; every adjacent level adds new understanding while remaining independently complete; Lv10 has a mastery delta; Story length uses minimum sufficient natural prose; action precedes terminology; four languages share one active semantic event; vocabulary has current provenance; and internal QA language never appears in learner-visible content.

The Agent MUST preserve the six-stage product architecture. Cognitive bands govern content semantics only. New methods proceed through one Pilot, exact-head audit/Preview, Founder Experience, final audit, canonical formalization, horizontal audit, then one-Journey-at-a-time remediation. Green automation is never literary or Founder authority.

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

## Binding Story Depth + Historical Truth behavior

Before drafting or locking a Story that uses historical people, artifacts, historical events, historical settings, or material historical causality, the Agent MUST also read and follow [Story Depth + Historical Story Universe Appendix](../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD_APPENDIX_STORY_DEPTH_HISTORY.md). The appendix is a binding supporting extension of the parent Narrative and Discovery Standard, not a parallel Story standard.

Historical truth is higher priority than narrative convenience. The Agent MUST NOT invent a historical fact to make a Story complete, dramatic, emotionally satisfying, or easier to differentiate.

For every material historical claim that drives Story causality, the Agent MUST:

1. record claim-level provenance;
2. preserve the parent source hierarchy;
3. assign truth status and source confidence;
4. keep `UNKNOWN` unknown and `CONTESTED` contested;
5. preserve certainty strength across Chinese, Pinyin, Vietnamese, and English;
6. verify temporal consistency where period-specific people, artifacts, institutions, technologies, practices, routes, or building phases are involved;
7. never invent real-person consequential action, dialogue, private motive, inner thought, relationship, belief, or design intention;
8. never invent missing artifact ownership, movement, excavation, discovery, restoration, or collection provenance;
9. use `OBJECT BIOGRAPHY` only when verified object life creates human causal pressure rather than a fact timeline;
10. stop rather than fill a historical gap with plausible fiction presented as fact.

Before Story Lock for every new Gold Story or Founder-authorized major remediation, the Agent MUST declare a `STORY DEPTH PROFILE` with exactly one `PRIMARY_DEPTH_MECHANISM`, normally one to three `SECONDARY_DEPTH_MECHANISMS`, optional supporting depth, and meaningful `INTENTIONALLY_UNUSED_DEPTH` where useful.

The sixteen Story Depth dimensions are a possibility space, not a checklist. Primary and Secondary depth used as Gold evidence must pass `DEPTH ACTION TEST`. If removing the claimed depth leaves Goal, Conflict, Choice, Cost, and Consequence materially unchanged, it is decorative. `PRIMARY_DEPTH_DECORATIVE` blocks Gold.

The Agent MUST distinguish `GOLD DEFECT`, `GOLD DEPTH OPPORTUNITY`, and `FUTURE PLACE STORY OPPORTUNITY`. `DEPTH OPPORTUNITY != GOLD DEFECT`; an already complete Gold Story is not reopened merely because further depth can be imagined.

When evaluating a later same-Place Story, the Agent MUST additionally compare Subject, Time Layer, Human Lens, Historical Scale, Truth Mode, Cultural Slice, Primary/Secondary Depth, Human Need, social position, material/practice mechanism, value tension, Memory type, emotional texture, Story Signature, Incremental Human Value, and Incremental Cultural Value.

The Agent MUST treat `PLACE → PLACE STORY UNIVERSE → STORY EXPERIENCE → JOURNEY RUN` as future experience semantics only. Standards authorization does not authorize runtime Story rotation, Story Experience persistence, progress UI, schema migration, or a second same-Place Story implementation.

Future multi-Story semantics are `UNSEEN FIRST`, `DIFFERENT PER NEW RUN`, and `STABLE WITHIN THE RUN`. Pure random is not the preferred primary selection strategy, and reopening a page is not automatically a new Journey Run.

`EXPERIENCE DIVERSITY COMES FROM MULTIPLE APPROVED GOLD STORIES, NOT RUNTIME-GENERATED RANDOMNESS`. Every future Story Experience remains a full Gold package across Story, Lv1–Lv10, Vocabulary, Discovery, Reading Support, Challenge, Memory, and Completion.
