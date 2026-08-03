# Phoenix UI and Visual Standard

**System:** Phoenix Product Standard System v1.0  
**Status:** BINDING  
**Minimum visual baseline:** PR `#137`, Commit `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`

## 1. Purpose

This standard defines mandatory UI, responsive, visual, state, motion, and approval requirements for Phoenix. It applies to Home, Explore, Passport, Profile, Shadowing, normal Journeys, special Journeys, and every learning stage.

The binding rule is:

> **NEW RESULT >= CURRENT STABLE BASELINE**

PR `#137` is the minimum acceptable visual and interaction experience.

## 2. Covered product surfaces

The standard applies to:

- Home;
- Explore;
- Passport;
- Profile;
- Shadowing;
- normal Journey entry and flow;
- special Journey entry and flow;
- Story;
- Vocabulary;
- Discovery;
- Challenge;
- Reflection;
- Writing;
- Memory;
- Completion;
- Stamp;
- Rewards;
- shared navigation, dialogs, sheets, banners, toasts, controls, and state components.

Each surface MUST have a defined purpose, hierarchy, route, state model, mobile behavior, and stable-baseline comparison path.

## 3. Page hierarchy

Every page MUST present a clear order:

1. product or Journey context;
2. page title and current stage;
3. primary content;
4. primary action;
5. supporting actions;
6. progress, status, or reward information;
7. safe exit or back path.

The hierarchy MUST remain understandable under text expansion, small screens, keyboard appearance, loading, error, and reduced-motion settings. Decorative content MUST NOT obscure learning content or primary actions.

## 4. Component hierarchy and consistency

Equivalent actions MUST use equivalent components, labels, states, and placement unless a documented Journey-specific reason requires variation.

Shared components MUST define:

- default, pressed, focused, selected, disabled, loading, success, and error states;
- semantic role and accessible name;
- minimum tap area;
- icon and text behavior;
- truncation and wrapping policy;
- light/dark or theme behavior where supported;
- motion and reduced-motion behavior.

Consistency does not permit identical storytelling or visual templates across Journeys. Product structure may be shared; Journey identity MUST remain independent.

## 5. Spacing and layout

Layouts MUST use a documented spacing system rather than arbitrary per-page values. Review MUST verify:

- consistent outer margins;
- predictable gaps between related and unrelated groups;
- sufficient separation between adjacent tap targets;
- stable alignment across states;
- no accidental overlap, clipping, or unreachable content;
- scroll content with adequate final inset above persistent controls and system areas.

A smaller viewport MUST not be treated as a uniformly scaled desktop canvas. Components MAY reflow, stack, collapse, or move while preserving hierarchy and function.

## 6. Typography and readability

Typography MUST establish clear roles for display, page title, section title, body, annotation, label, metadata, and feedback.

Requirements:

- readable size and line height on supported phones;
- predictable line wrapping;
- no essential content conveyed through tiny text;
- no decorative font that reduces comprehension;
- adequate contrast against every image and state;
- support for system text scaling without loss of function;
- correct script and punctuation for all supported languages;
- no text embedded in images when the content must translate, scale, or be read by assistive technology.

Text over imagery MUST use a verified readable region, overlay, shadow, container, or alternate composition. A beautiful crop that makes text unreadable is a failure.

## 7. Contrast and non-color communication

Text, icons, controls, focus indicators, progress, selected state, errors, and success state MUST remain perceivable under expected display conditions. Color MUST NOT be the only signal for state or correctness. Contrast evidence SHOULD include automated measurement plus visual inspection in the actual composition.

## 8. Safe areas and system UI

All supported pages MUST respect:

- top status and sensor areas;
- bottom home indicator and navigation areas;
- rounded corners and cutouts;
- on-screen keyboard;
- system text scaling;
- supported orientation policy;
- overlays, dialogs, sheets, and persistent controls.

No primary action, playback control, navigation control, or required content may be hidden behind system UI.

## 9. Small-screen adaptation

Small-screen verification MUST include the narrowest supported width and representative long translations.

The candidate MUST prevent:

- horizontal overflow;
- clipped titles or controls;
- inaccessible bottom actions;
- image focal loss;
- modal content beyond reach;
- compressed tap targets;
- unreadable side-by-side content;
- keyboard-covered input or submission controls.

## 10. Image quality, crop, and focus

Production imagery MUST preserve or exceed the PR `#137` level of completion:

- high resolution appropriate to rendered size and density;
- clear foreground, midground, and background;
- lighting, weather, material, atmosphere, and spatial depth;
- independent city, realm, and Journey identity;
- composition aligned with the story and learning stage;
- a deliberate focal point;
- crop rules for supported phone aspect ratios;
- a readable region for overlaid content;
- graceful loading and failure behavior.

Crop approval MUST use actual target viewports. Source image quality does not guarantee mobile crop quality.

## 11. Visual differentiation

Normal and special Journeys MAY share product components and stage structure. They MUST NOT share a uniform visual template that erases identity.

The following MUST be independently designed where applicable:

- composition;
- viewpoint and scale;
- environment;
- lighting and weather;
- material language;
- color relationships;
- character presence;
- cultural details;
- story-stage imagery;
- memory anchor;
- special Journey visual mechanism.

A repeated composition with only color, sky, icon, or minor shape changes is not differentiation.

## 12. Loading, error, empty, and fallback UI

### Loading

Loading UI MUST begin promptly, maintain layout stability, identify the active operation when needed, and end in a valid state. Skeletons or progress indicators MUST resemble the final hierarchy and MUST NOT become permanent placeholders.

### Error

Error UI MUST state what failed, preserve recoverable state, avoid secret leakage, and provide retry, back, or safe alternative where applicable.

### Empty

Empty UI MUST be intentional, distinguishable from loading and error, explain the absence, and present the next available action.

### Fallback

Fallback UI MUST preserve safe function without routing to incorrect content or reducing the release experience to a low-detail placeholder. Programmatic fallback art MAY appear only after a verified asset failure and MUST be clearly treated as degraded behavior.

## 13. Motion

Motion MUST communicate state, continuity, progress, or spatial relationship. It MUST NOT delay essential actions, conceal content, cause unstable layout, or serve as decoration without product value.

All applicable motion MUST define:

- trigger;
- duration and interruption behavior;
- interaction during motion;
- exit and route-transition behavior;
- performance acceptance;
- reduced-motion alternative.

## 14. Reduced motion

When reduced motion is requested, the product MUST remove or substantially simplify non-essential movement while preserving state changes, progress, navigation, and comprehension. Disabling animation MUST NOT leave invisible content, skipped feedback, or broken timing.

## 15. Mobile operation areas

Primary and frequent controls MUST be reachable, separated, and sized for touch. Destructive actions MUST not sit where accidental taps are likely. Playback, writing, navigation, and completion controls MUST remain operable with one hand where the stable design provides that usability.

## 16. Surface-specific requirements

### Home

MUST preserve clear entry to the principal Phoenix experience, stable navigation, current progress or recommendation context, and complete loading/error behavior.

### Explore

MUST make Journey identity, availability, entitlement, and selection understandable. Cards or entries MUST not become visually interchangeable.

### Passport

MUST present progress, completed Journeys, stamps, and reward meaning without obscuring status or accessibility.

### Profile

MUST preserve account, language, preferences, subscription or entitlement, privacy, and sign-out behavior with safe confirmation where needed.

### Shadowing

MUST maintain readable text, synchronized playback state, clear speed/voice controls where supported, accessible alternatives, and stable interruption recovery.

### Journey and learning stages

Story, Vocabulary, Discovery, Challenge, Reflection, Writing, Memory, Completion, Stamp, and Rewards MUST share coherent navigation and progress language while retaining stage-specific purpose. A stage MUST not be reduced to a renamed generic card.

## 17. Prohibited production visual patterns

The following are prohibited in the formal product unless explicitly covered by the limited exceptions in Section 18:

- low-detail programmatic SVG;
- low-detail programmatic WebP;
- simple gradients combined with circles, rectangles, or a few paths as the principal visual;
- flat Journey backgrounds;
- one template recolored in bulk;
- one composition reused across Journeys;
- placeholder or test imagery in a release build;
- imagery below the stable baseline's detail density;
- visual downgrade for easier rights registration or provenance tracking;
- approval based only on file existence, dimensions, hash, `complianceScore`, `varietyScore`, or automated fields;
- batch visual replacement without Founder mobile approval.

## 18. Limited programmatic visual exceptions

Programmatic visuals MAY be used only as:

- a loading-failure fallback;
- a temporary placeholder excluded from every release build;
- an isolated experimental Preview;
- a Founder-approved design direction with explicit scope and candidate evidence.

An exception MUST identify purpose, route, lifecycle, release exclusion or approval record, and removal condition. An experiment does not establish permission for batch runtime use.

## 19. Visual approval gates

Every new or replaced runtime visual MUST pass all applicable gates:

1. Rights Gate;
2. Technical Gate;
3. Visual Quality Gate;
4. Stable Baseline Comparison Gate;
5. Founder Mobile Preview Approval Gate.

Failure or missing evidence at any gate results in `BLOCKED`, `REQUIRES_REVISION`, or `REGRESSION`, never `PASS`.

## 20. Evidence

Visual evidence MUST include applicable:

- exact candidate Commit and paths;
- source dimensions and format;
- runtime route and asset reference;
- screenshots at required viewports;
- stable and candidate comparison captures;
- loading, error, empty, and fallback captures;
- reduced-motion behavior;
- reproducible Preview path;
- Founder approval record.

Automated tests support technical correctness but do not replace human visual or mobile review.

## 21. Completion rule

A UI or visual task MUST NOT be marked Completed, expanded, moved to Ready, or merged when:

- any affected surface is below PR `#137`;
- the mobile crop or interaction is unverified;
- Founder approval is required and not APPROVED;
- a placeholder remains in runtime;
- an unauthorized template is reused;
- rights approval is mistaken for visual approval;
- the mandatory stable comparison is missing.

Completion reporting follows [Phoenix Development Completion Standard](PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md).