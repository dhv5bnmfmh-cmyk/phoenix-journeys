# PHOENIX AI BACKGROUND PRODUCTION STANDARD
## Agent Executable Edition v1.0

**STATUS:** BINDING  
**SCOPE:** ALL NEW OR REPLACED PHOENIX JOURNEY BACKGROUND IMAGES  
**DEFAULT PRODUCTION METHOD:** AI ORIGINAL ONLY  
**RUNTIME INTEGRATION:** GATED  
**FOUNDER APPROVAL:** REQUIRED WHERE VISUAL STANDARD REQUIRES IT

This standard is binding together with [Phoenix UI and Visual Standard](PHOENIX_UI_VISUAL_STANDARD.md), [Phoenix Journey System Standard](PHOENIX_JOURNEY_SYSTEM_STANDARD.md), [Phoenix New Journey Creation Standard](PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md), the [Phoenix New Journey Acceptance Matrix](templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md), and the existing [destination background runtime policy](destination-background-policy.md).

It governs new Journey backgrounds, replacement backgrounds, AI image production, visual pilots, Journey visual libraries, background evaluation, and runtime background integration. Where an older background rule conflicts with this standard on production sequencing, source eligibility, rights review, pilot gating, mobile review, or visual approval, this standard controls. Existing stable-baseline, minimum-library-count, runtime-selection, metadata, and test requirements remain binding unless explicitly strengthened here.

## 1. Governing principles

The following rules are mandatory and ordered as product constraints, not suggestions:

> **NEW RESULT >= CURRENT STABLE VISUAL BASELINE**
>
> **QUALITY > QUANTITY**
>
> **IDENTITY > TEMPLATE**
>
> **AUTHENTICITY > SPECTACLE**
>
> **MOBILE EXPERIENCE > DESKTOP BEAUTY**
>
> **LEGAL SAFETY > CONVENIENCE**
>
> **STORY WORLD > TOURISM POSTER**
>
> **AI GENERATED != AUTOMATICALLY SAFE**
>
> **REFERENCE != PRODUCTION ASSET**
>
> **NO RIGHTS GATE PASS = NO RUNTIME INTEGRATION**

The stable visual baseline defined by the Phoenix UI and Visual Standard is a floor. Background production MUST preserve or exceed it.

## 2. AI Original Only production rule

All NEW Phoenix production Journey background images MUST be AI-original unless an explicit, separately documented commercial-rights exception has been approved for that specific asset and use.

The following MUST NOT be shipped directly as Phoenix production backgrounds without an approved exception and independently verified commercial rights:

- Google Images photos;
- Baidu images;
- Pinterest images;
- social-media images;
- tourism-site images;
- museum-site images without rights verification;
- stock photos without a verified license covering the intended commercial use;
- movie screenshots;
- TV screenshots;
- game screenshots;
- third-party artwork;
- photographer images;
- advertising material;
- promotional images.

An Agent MUST NOT crop, recolor, AI-edit, style-transfer, trace, photobash, or upscale such material and then classify the result as Phoenix-original.

An exception does not waive the Rights Gate, IP Similarity Review, Visual Quality Gate, mobile review, or Founder approval where applicable.

## 3. Reference imagery is not a production asset

Internet or public imagery MAY be consulted only as research reference for:

- historical research;
- architectural verification;
- geographic verification;
- clothing verification;
- vegetation verification;
- materials research;
- transport verification;
- weather and environmental study.

Reference imagery MUST NOT enter production runtime unless commercial rights for that production use are independently verified and the exception is explicitly documented.

> **REFERENCE ≠ ASSET.**

A research reference is evidence for understanding a place or period. It is not permission to copy, transform, redistribute, or ship the reference itself.

## 4. Copyright and IP Safety Gate

Every Pilot and Production candidate MUST pass an IP / Rights Gate before runtime integration.

Reject or regenerate an image that appears materially similar to:

- recognizable copyrighted photography;
- copyrighted artwork;
- film frames;
- game scenes or game artwork;
- TV frames;
- advertising art;
- commercial key art;
- protected character designs;
- distinctive third-party compositions.

Agents MUST NOT request or use direct-imitation prompts such as:

- `in the exact style of [living artist]`;
- `in the style of [specific photographer]`;
- `make this exactly like [movie/game]`;
- equivalent wording whose purpose is to reproduce an identifiable protected creator, work, shot, or composition.

Broad visual-language descriptions are permitted, including:

- cinematic natural light;
- documentary realism;
- 35mm environmental perspective;
- soft atmospheric depth;
- wet-surface reflections;
- historic architectural realism;
- blue-hour exposure.

## 5. No Rights Assumption

Rights uncertainty is a blocking condition.

> **If rights are unclear: NOT APPROVED.**

Never assume:

- public website = public domain;
- museum website = commercial rights;
- social media = reusable;
- search result = licensed;
- AI generation = automatically legally safe.

When the relevant rights cannot be established, the Agent MUST set the Rights Gate to `FAIL` or `BLOCKED`, stop runtime integration, and choose a safer production path.

## 6. Mandatory IP Similarity Review

AI-original status does not end IP review. Every candidate MUST receive a similarity review for substantial resemblance to a known protected photograph, artwork, film shot, TV frame, game artwork, advertising image, key art, or promotional composition.

Allowed similarity-review states are:

- `PASS`;
- `REGENERATE`;
- `BLOCKED`.

`REGENERATE` means the candidate MUST NOT proceed in its current form. `BLOCKED` means production or integration MUST stop until the blocking issue is resolved through an approved path.

## 7. Audit provenance

Every production candidate MUST have auditable provenance. At minimum record:

- Journey ID;
- Asset ID;
- Shot ID;
- Visual DNA version;
- Shot Plan version;
- Prompt version;
- generation method, model, or tool;
- generation date;
- AI Original status;
- Third-party production asset used: `YES` / `NO`;
- Rights Gate;
- IP Similarity Review;
- Cultural Review;
- Historical Review;
- Mobile Crop Review;
- Founder Approval status;
- Production Runtime status;
- asset version.

Provenance MUST NOT require secrets, API keys, credentials, tokens, private model keys, or other sensitive authentication material. This record exists for auditability and traceability.

## 8. Visual DNA Gate before generation

**NO IMAGE GENERATION may begin until a Journey Visual DNA exists.**

Visual DNA MUST define:

- Journey;
- location;
- Story identity;
- historical or modern period;
- narrative mood;
- geographic identity;
- architectural identity;
- materials;
- season;
- weather logic;
- time-of-day logic;
- lighting;
- color philosophy;
- human presence;
- clothing;
- transport;
- objects;
- foreground;
- midground;
- background;
- camera language;
- depth;
- atmosphere;
- mobile readable region;
- Memory Anchor relationship;
- forbidden generic motifs;
- cross-Journey visual differences.

If the Visual DNA could be reused for another Journey by replacing only the landmark or city name, the result is `FAIL`.

## 9. Cross-Journey differentiation review

Before image generation, the proposed Visual DNA and Shot Plan MUST be compared against existing approved Phoenix Journeys.

At minimum compare:

- composition;
- camera height;
- camera distance;
- dominant geometry;
- foreground treatment;
- human density;
- materials;
- weather;
- lighting;
- time pattern;
- color philosophy;
- Story relationship;
- visual rhythm;
- Memory Anchor imagery.

Simple landmark substitution is `FAIL`.

## 10. Anti-Template Gate

Different city does not automatically mean different visual design.

Across different Journeys, the production system MUST NOT repeatedly use the same:

- framing;
- central-landmark arrangement;
- foreground tree device;
- golden-hour treatment;
- water-reflection treatment;
- camera height;
- visual rhythm.

A shared product system MAY provide consistent technical structure. It MUST NOT produce a universal visual template that erases Journey identity.

## 11. Shot Plan required before generation

Before any Pilot generation, the Agent MUST create a Shot Plan. Every planned image MUST define:

- Shot ID;
- purpose;
- Story relationship;
- location;
- time;
- weather;
- camera position;
- camera height;
- camera distance;
- viewing direction;
- foreground;
- midground;
- background;
- primary focal point;
- secondary focal point;
- human density;
- lighting;
- mobile readable region;
- historical verification requirement;
- cultural verification requirement;
- IP risk notes;
- anti-template note.

> **No Shot Plan = NO GENERATION.**

## 12. Pilot-first rule

For every NEW visual direction, generate only **1–3 Pilot images first**.

Do NOT immediately generate a full 10-image production library.

A Pilot MUST pass all applicable:

- Visual QA;
- Historical QA;
- Cultural QA;
- Architecture QA;
- Geography QA;
- IP / Rights QA;
- IP Similarity Review;
- Mobile Crop QA;
- UI Readability QA;
- Anti-Template QA;
- Performance feasibility;
- Founder visual review where required by the Phoenix UI and Visual Standard or Journey lifecycle.

Before Pilot approval:

> **FULL PRODUCTION LIBRARY: BLOCKED.**

A rejected Pilot returns to Visual DNA, Shot Plan, prompt, or candidate revision as needed. Rejection never authorizes bulk generation.

## 13. Full production library after Pilot approval

After Visual Pilot approval, target a minimum of **10 approved images per Journey where current Phoenix runtime policy requires it**.

The 10-image rule is a final approved-library requirement, not permission to bypass Pilot gating.

A production library MUST form **ONE COHERENT STORY WORLD** while varying, as appropriate:

- camera positions;
- distances;
- focal relationships;
- weather;
- light;
- human density;
- spatial depth;
- visual tension;
- Story purpose;
- negative space;
- movement implication.

No fixed universal 10-shot template may be imposed across Journeys.

## 14. Image quality standard

Production candidates MUST use:

- high-resolution source material;
- 4K-class visual detail or equivalent source fidelity;
- high-DPI mobile quality;
- a sharp focal subject;
- stable geometry;
- realistic textures;
- natural architectural detail;
- natural spatial depth;
- realistic reflections;
- credible shadows;
- clean atmosphere.

Reject candidates showing:

- blur;
- pixelation;
- compression artifacts;
- oversharpening;
- AI texture melt;
- broken architecture;
- warped doors or windows;
- repeated ornament;
- deformed humans;
- extra limbs;
- fake hands;
- floating objects;
- incorrect shadows;
- incorrect reflections;
- bad perspective;
- fake signs;
- random pseudo-Chinese;
- watermarks;
- logos;
- embedded captions.

4K dimensions alone do NOT establish `PASS`.

## 15. Photoreal and cinematic quality target

The preferred visual target is:

> cinematic environmental realism  
> + premium documentary photography  
> + narrative establishing-shot quality  
> + natural atmospheric depth

Avoid:

- cheap game art;
- stock-photo look;
- tourism-ad look;
- generic AI postcard treatment;
- plastic materials;
- hyper-perfect surfaces;
- fantasy-China shorthand;
- excessive HDR;
- over-saturation;
- extreme teal-orange grading;
- unreal bloom;
- fake lens flare.

## 16. Spatial depth

Where appropriate, major backgrounds SHOULD contain meaningful:

- Foreground;
- Midground;
- Background.

Do not make an entire Journey library visually flat.

Foreground may include architecture edge, stone, tree branch, railing, door frame, human silhouette, water edge, or street element. Midground normally carries the primary scene. Background supplies landscape, architecture, skyline, haze, weather, or other spatial context.

## 17. Composition

Every image MUST have intentional focal hierarchy.

Permitted composition tools include:

- rule of thirds;
- architectural symmetry;
- asymmetry;
- leading lines;
- natural framing;
- negative space;
- deep perspective;
- human-scale environmental composition.

No single composition formula may dominate a complete Journey library.

Forbidden full-library pattern:

> all 10 images = centered landmark + sky.

## 18. Camera language

Use camera language that serves the Story and place. Valid options include:

- wide establishing view;
- medium environmental view;
- human eye-level view;
- slightly low angle;
- elevated perspective;
- framed architecture;
- street-depth view;
- waterside view;
- route perspective;
- environmental detail.

Avoid:

- every image using drone-style perspective;
- every image using postcard-wide perspective;
- extreme ultra-wide distortion;
- fisheye;
- unnecessary dramatic camera angles.

## 19. Lighting

Lighting MUST be physically plausible for the place, period, weather, and stated time.

Allowed examples include:

- morning;
- soft daylight;
- cloudy;
- pre-rain;
- post-rain;
- golden hour;
- blue hour;
- night illumination;
- winter diffused light.

Do NOT force all Journeys into golden hour. Avoid artificial dramatic light rays unless the environment credibly produces them.

## 20. Color DNA

Colors MUST arise from the place and Story.

Require:

- natural materials;
- natural vegetation;
- controlled saturation;
- retained highlight detail;
- retained shadow detail;
- a coherent palette.

Each Journey SHOULD develop its own Color DNA. Do NOT globally apply one cinematic color filter to all Journeys.

## 21. Weather logic

Weather MUST support:

- place;
- Story;
- season;
- emotion;
- historical plausibility.

Rain, snow, mist, wind, humidity, and similar conditions MUST affect the visible environment consistently, including applicable:

- surfaces;
- reflections;
- visibility;
- human behavior;
- material darkness;
- sky;
- atmosphere.

Weather is not random decoration.

## 22. Cultural Accuracy Gate

Verify applicable:

- architecture;
- roads;
- bridges;
- boats;
- wall structure;
- clothing;
- plants;
- objects;
- transport;
- public behavior;
- religious elements;
- decorations;
- signage;
- city morphology;
- historical technology.

Forbidden shortcuts include:

- generic Asian fantasy;
- random red lanterns;
- random dragons;
- random temple symbols;
- mixed dynasties;
- fake "Chinese" details.

> **Cultural specificity > stereotype.**

## 23. Historical Accuracy Gate

When a Story is historical, verify applicable:

- era;
- building existence;
- building restoration state;
- clothing;
- transport;
- lighting technology;
- road materials;
- historical landscape;
- known architectural state.

If a historical detail is uncertain, simplify the image. Do NOT invent detail merely to make the image more impressive.

## 24. People

People MAY support:

- scale;
- daily life;
- era;
- culture;
- Story atmosphere.

The environment remains primary unless the Story explicitly requires a different hierarchy.

Avoid:

- large portrait faces as default background focus;
- posed tourist photography;
- everyone facing the camera;
- repeated people;
- deformed anatomy;
- wrong-period or culturally incorrect clothing.

## 25. Logos, watermark, and embedded text

Production backgrounds MUST NOT contain:

- watermarks;
- logos;
- captions;
- UI;
- subtitles;
- artist signatures;
- AI-tool signatures;
- random English;
- fake Chinese;
- poster typography.

Phoenix text remains runtime-rendered.

## 26. Trademark control

Avoid unnecessary modern:

- store logos;
- car badges;
- fashion logos;
- advertising boards;
- commercial marks.

If a real-world mark is unavoidable and incidental, it MUST remain small, factual, non-prominent, and non-deceptive. Do not invent near-copy fake trademarks.

## 27. Mobile-first authority

Mobile is authoritative for background acceptance.

Every image MUST survive the required portrait crop. Verify:

- primary subject;
- architecture;
- human scale;
- safe top zone;
- safe bottom zone;
- Story text area;
- button area;
- no important subject clipping.

Desktop beauty cannot compensate for mobile failure.

## 28. UI Readable Region

Every image MUST intentionally provide a visually quieter region suitable for Phoenix UI.

Examples include:

- sky;
- water;
- soft wall;
- dark architecture;
- distant haze;
- low-detail foliage;
- negative space.

Do NOT rely on heavy blur to rescue poor composition. Prefer a better image composition.

## 29. Story relationship

Backgrounds MUST build the Journey Story World rather than behave as interchangeable tourism posters.

Across a production library, at least some images SHOULD relate meaningfully to applicable:

- opening;
- movement;
- turning point;
- conflict environment;
- weather change;
- resolution;
- ending;
- Memory Anchor.

Do NOT make every image a literal illustration of one sentence.

## 30. Realistic imperfection

Natural imperfection is desirable when authentic to the scene. Examples include:

- weathered stone;
- aged wood;
- uneven pavement;
- natural foliage;
- subtle stains;
- humidity;
- wet surfaces;
- non-perfect reflections;
- atmospheric haze.

Avoid environments that resemble an unreal, perfectly polished theme park.

## 31. Runtime performance and asset size

Production images MUST be optimized for downloaded mobile applications.

Do NOT ship raw generation masters into runtime. Preserve an archival master separately when needed for audit or future derivation.

Runtime assets MUST use appropriate optimized formats and settings. Do NOT ship giant 20–80 MB background images.

Performance review MUST consider:

- decode cost;
- memory impact;
- file size;
- mobile loading behavior;
- visual fidelity after optimization.

High source resolution and good runtime performance are both required. Neither replaces the other.

## 32. Future motion compatibility

Where practical, a static background MAY be composed so a future lightweight parallax or dynamic treatment could use:

- clear depth;
- clean architecture;
- separable foreground;
- usable sky;
- stable geometry.

Do NOT sacrifice static visual quality for hypothetical animation.

The previous heavy Living Story experiment is NOT the target. Background assets SHOULD remain lightweight-friendly.

## 33. Content / visual separation

Canonical Journey content is **READ-ONLY** during visual production.

Background work MAY consume approved:

- Story;
- Narrative DNA;
- Memory Anchor;
- locations;
- historical information.

Visual production MUST NOT modify:

- Story;
- Words;
- Discovery;
- Challenge;
- Memory;
- Complete;

merely to make image generation easier.

If the visual system cannot represent canonical content, fix the visual direction. Do NOT rewrite the Story.

## 34. Versioning and rollback

Approved production images MUST NOT be silently overwritten.

Every replacement MUST record:

- Asset ID;
- Version;
- Previous Version;
- Replacement Reason;
- Review Status;
- Rollback Path.

Never replace approved imagery without traceability and a recoverable prior version or documented restoration path.

## 35. Safe fallback

If a background fails to load, do NOT display a wrong city, wrong Journey, or wrong historical era.

Use a safe Phoenix fallback consistent with current runtime policy. Silent cross-Journey fallback is prohibited.

## 36. Automated-score limitation

The following are useful technical evidence but are NOT sufficient proof of visual quality or rights approval:

- `complianceScore`;
- `varietyScore`;
- resolution;
- AI-generated metadata;
- file existence;
- dimensions;
- hash or manifest presence.

Automated validation supports QA. Founder and human visual judgment remain authoritative where the governing visual lifecycle requires them.

## 37. Per-image QA output

Every Pilot and Production candidate MUST produce the following review record:

```text
Asset ID:

Journey:

Shot Purpose:

AI Original:
YES / NO

Generation Method:

Prompt Version:

Resolution:

Visual Quality:
PASS / FAIL

Location Accuracy:
PASS / FAIL

Cultural Accuracy:
PASS / FAIL

Historical Accuracy:
PASS / FAIL / N/A

Foreground / Midground / Background:
PASS / FAIL

Focal Point:
PASS / FAIL

Mobile Crop:
PASS / FAIL

UI Readable Region:
PASS / FAIL

Anti-Template:
PASS / FAIL

IP Safety:
PASS / FAIL

IP Similarity Review:
PASS / FAIL

Watermark / Logo:
ABSENT / PRESENT

Unwanted Text:
ABSENT / PRESENT

Rights Gate:
PASS / FAIL

Recommendation:
APPROVE / REGENERATE / REJECT
```

A `FAIL`, `PRESENT` watermark/logo, `PRESENT` unwanted text, or failed Rights Gate MUST prevent production approval until the candidate is replaced or corrected through an approved process.

## 38. Production-library QA output

After the full production set is prepared, record:

```text
Journey:

Approved Images:

Required Minimum:
>=10 where applicable

Internal Diversity:
PASS / FAIL

Cross-Journey Differentiation:
PASS / FAIL

Repeated Composition:
YES / NO

Repeated Lighting Template:
YES / NO

Repeated Camera Template:
YES / NO

Repeated Color Grade:
YES / NO

Mobile Coverage:
PASS / FAIL

Story World Coverage:
PASS / FAIL

Rights Gate:
PASS / FAIL

Founder Approval:
APPROVED / PENDING / REJECTED
```

A failed library Rights Gate, failed mobile coverage, failed cross-Journey differentiation, or required Founder approval that is not `APPROVED` blocks runtime integration.

## 39. Required pre-generation Agent output

Before any background image generation, the responsible Agent MUST return a pre-generation record containing:

```text
Journey:

Visual DNA:

Cross-Journey Visual Difference:

Shot Plan:

Pilot Images Requested:
1–3

IP Safety Plan:

Historical / Cultural Verification Plan:

Mobile Crop Plan:

UI Readable Region Plan:

Runtime Performance Plan:

Status:
READY FOR PILOT GENERATION
```

If any required field is missing or unverified, the Agent MUST NOT set the status to `READY FOR PILOT GENERATION` and MUST NOT generate images.

## 40. Runtime integration eligibility

A candidate is eligible for runtime integration only when all applicable gates have passed, including:

1. Visual DNA complete;
2. Cross-Journey Differentiation complete;
3. Shot Plan complete;
4. Pilot approved before full production;
5. AI Original rule satisfied or explicit documented commercial-rights exception approved;
6. Rights Gate `PASS`;
7. IP Similarity Review `PASS`;
8. Visual Quality `PASS`;
9. Cultural Accuracy `PASS`;
10. Historical Accuracy `PASS` or justified `N/A`;
11. Location / Architecture / Geography review `PASS` where applicable;
12. Mobile Crop `PASS`;
13. UI Readable Region `PASS`;
14. Anti-Template `PASS`;
15. runtime optimization and asset-weight review `PASS`;
16. provenance complete;
17. versioning and rollback data complete;
18. Founder approval `APPROVED` where required;
19. current runtime-library metadata and minimum-count rules satisfied;
20. relevant tests and quality gates passed.

A failed or missing mandatory gate is `BLOCKED`, not an invitation to hard-code a passing value.

## 41. Prohibited shortcuts

Never:

- scrape images for production backgrounds;
- download internet images into production assets without an approved rights exception;
- remove watermarks;
- AI-edit copyrighted photos and claim Phoenix originality;
- style-transfer copyrighted art into production;
- copy film shots;
- copy game scenes;
- imitate a living artist's style;
- imitate a specific photographer's style;
- use generic China templates;
- bulk recolor backgrounds and claim Journey differentiation;
- generate 10 production candidates before Pilot approval;
- ignore mobile crop;
- ignore IP uncertainty;
- ignore historical errors;
- approve based only on automated scores;
- modify canonical Story to accommodate visuals;
- merge before Founder approval where required.

## 42. No-bypass governance

No Agent may create acceptance by weakening the standard.

An Agent MUST NOT:

- create a Journey-specific exception merely to pass production;
- hard-code `PASS`;
- skip Rights review;
- skip Founder review where required;
- skip the Pilot rule;
- lower the stable visual baseline;
- change canonical Story to make visuals easier;
- remove or weaken tests merely to obtain acceptance.

Any exception MUST be explicit, documented, scoped, and Founder-approved where the governing Phoenix standard requires Founder approval. The exception record MUST identify the exact asset or rule, reason, rights basis where relevant, owner, approval state, lifecycle, and rollback or removal condition.

## 43. Agent execution contract

Any GPT, Codex, Agent, automation, or human-directed AI workflow that generates, replaces, evaluates, or integrates Phoenix Journey backgrounds MUST read this standard before background work begins.

Execution order for visual production is:

> **Story Gold**  
> → **Visual DNA**  
> → **Cross-Journey Differentiation**  
> → **Shot Plan**  
> → **1–3 Pilot**  
> → **Rights / IP QA**  
> → **Historical / Cultural QA**  
> → **Mobile QA**  
> → **Founder Review where required**  
> → **Full Production Library**  
> → **Runtime Integration**

No stage may be skipped by generating more assets, lowering a score threshold, rewriting Story content, or treating automated metadata as human approval.

## 44. Documentation consistency rule

When this standard changes, reviewers MUST check all repository standards and Agent instructions that govern Journey visuals, background libraries, rights, mobile crop, minimum image count, Pilot behavior, Founder approval, and runtime integration.

Conflicting wording MUST be resolved in the same governance change. Do not leave two binding standards with contradictory requirements for image source, Pilot count, minimum final library size, rights, Founder approval, AI generation, stable visual baseline, or mobile crop.

## 45. Governance-only change boundary

A standards-only PR that adopts or revises this document MUST NOT implicitly authorize image generation or asset replacement. Image production remains a separate gated task.

Documentation work under this standard does not by itself authorize:

- generation of missing-city images;
- replacement of approved backgrounds;
- modification of dynamic backgrounds;
- addition of AI-generated production assets;
- modification of canonical Journey Story content;
- runtime integration.

## 46. Final binding rule

A Phoenix Journey background is not approved because it exists, is high-resolution, was generated by AI, has a high `complianceScore`, has a high `varietyScore`, or fills the required library count.

It is production-eligible only when the complete visual, mobile, cultural, historical, IP, rights, provenance, performance, versioning, runtime, and applicable Founder gates have passed while preserving or exceeding the current stable visual baseline.
