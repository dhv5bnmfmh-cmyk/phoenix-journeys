# Phoenix PR #195 — Visual and Rights Review Packet

PRODUCT_VISUAL_EVIDENCE_BASIS_SHA: `d2392bdb6f5ecf3dae50883cf5be1390928656fb`

CURRENT_FOUNDER_REVIEW_HEAD: resolve from remote PR `#195` at review time.

FOUNDER_PREVIEW_URL_TEMPLATE: `https://phoenix-journeys-pr-195.7hn5tyrjgh.workers.dev/?unlock=all&prototype=journeys&v=<CURRENT_PR_HEAD>`

The current concrete Preview URL and its Health identity belong in the exact-head handoff. The packet deliberately does not embed its own commit SHA.

The PR changes release configuration only: it adds five already-existing, byte-unchanged AI-original background directories to Flutter's asset bundle. Objective evidence and Agent prechecks do not assert Human Visual PASS.

## Product visual evidence and current-head review context

- At the product visual evidence basis SHA, the Preview was opened at a mobile-width learner surface and rendered the Journey selector, Story card, Discovery card, safe-area layout, and generated background without loading/fallback errors.
- `app/build/unit_test_assets/AssetManifest.bin` and the expanded `app/build/unit_test_assets/assets/images/backgrounds/generated/...` tree contain all 50 affected files after the basis Flutter test bundle was produced. This is the reproducible capture equivalent for bundle identity.
- Before Founder review, resolve the current remote PR head, substitute it into `FOUNDER_PREVIEW_URL_TEMPLATE`, and require Cloudflare Preview Health to report that same release SHA. Flutter CI, Mobile Interaction Audit, Startup Performance Audit, Cloudflare Preview, and Health must all be terminal PASS for that head.
- Human/Founder mobile visual judgment remains **PENDING** for each row below.

### Invalidation rule

Regenerate this visual packet when visual-relevant product evidence changes, including image bytes, an active asset path, a release asset mapping, visual runtime behavior, relevant layout/render behavior, or applicable visual-standard requirements.

An evidence-only, documentation-only, or test-only commit does not invalidate the underlying product visual evidence when product visual bytes, mappings, and behavior remain unchanged. It does require fresh verification that the Founder Preview and Health identities match the current remote PR head.

## Affected Journey records

| Journey ID | Active asset path (10 `.webp` files) | Release bundle presence | Rights/source record | Text/crop/safe-area context | Agent visual precheck | Human visual |
|---|---|---|---|---|---|---|
| `huangshan-cloud-peaks` | `app/assets/images/backgrounds/generated/huangshan/cloud-peaks/01-pre-dawn.webp` … `10-moonlit-finale.webp` | `app/pubspec.yaml` mapping plus basis `build/unit_test_assets/.../huangshan/cloud-peaks/` | `JourneyBackgroundOrigin.aiGenerated`; generated 2026-07-30; compliance reviewed; asset identity is Journey ID + shot name | Inspect map header, Story/Discovery cards, readable overlay, crop at narrow width, and top/bottom safe areas at the current-head Preview | AGENT PASS: 10 distinct WebP files resolve; runtime metadata and bundle output agree; no missing/fallback defect | **PENDING** |
| `zhangjiajie-wulingyuan` | `app/assets/images/backgrounds/generated/zhangjiajie/wulingyuan/01-pre-dawn.webp` … `10-moonlit-finale.webp` | `app/pubspec.yaml` mapping plus basis `build/unit_test_assets/.../zhangjiajie/wulingyuan/` | `JourneyBackgroundOrigin.aiGenerated`; generated 2026-07-30; compliance reviewed; asset identity is Journey ID + shot name | Current-head mobile review, including pillar crop and overlay contrast | AGENT PASS: objective release and runtime identity checks pass | **PENDING** |
| `kaifeng-song-capital` | `app/assets/images/backgrounds/generated/kaifeng/song-capital/01-pre-dawn.webp` … `10-moonlit-finale.webp` | `app/pubspec.yaml` mapping plus basis `build/unit_test_assets/.../kaifeng/song-capital/` | `JourneyBackgroundOrigin.aiGenerated`; generated 2026-07-30; compliance reviewed; asset identity is Journey ID + shot name | Current-head mobile review, including architecture crop and text contrast | AGENT PASS: objective release and runtime identity checks pass | **PENDING** |
| `dali-cangshan-erhai` | `app/assets/images/backgrounds/generated/dali/cangshan-erhai/01-pre-dawn.webp` … `10-moonlit-finale.webp` | `app/pubspec.yaml` mapping plus basis `build/unit_test_assets/.../dali/cangshan-erhai/` | `JourneyBackgroundOrigin.aiGenerated`; generated 2026-07-30; compliance reviewed; asset identity is Journey ID + shot name | Current-head mobile review, including mountain/lake crop and card readability | AGENT PASS: objective release and runtime identity checks pass | **PENDING** |
| `harbin-central-street` | `app/assets/images/backgrounds/generated/harbin/central-street/01-pre-dawn.webp` … `10-moonlit-finale.webp` | `app/pubspec.yaml` mapping plus basis `build/unit_test_assets/.../harbin/central-street/` | `JourneyBackgroundOrigin.aiGenerated`; generated 2026-07-30; compliance reviewed; asset identity is Journey ID + shot name | Current-head mobile review, including streetscape crop, snow/highlight contrast, and safe areas | AGENT PASS: objective release and runtime identity checks pass | **PENDING** |

## Rights precision

### Objective rights evidence

- Source/ownership basis: repository-declared `JourneyBackgroundOrigin.aiGenerated` (AI-original production assets), not third-party photographs or transformed reference imagery.
- Allowed use: Phoenix production/runtime use under the repository's AI-original production rule.
- Repository provenance: tracked WebP bytes under the five paths above; generated date and Journey identity in `app/lib/data/journey_background_generated.dart`; bundle identity in `app/pubspec.yaml` and exact-head build output.
- Asset identity: 10 named shots per Journey, 50 total, each deterministically bound to a Journey ID.
- Objective Rights Gate and IP/provenance checks: PASS in current automated policy evidence; this PR does not change image bytes, prompts, provenance metadata, or identity.

### Human rights judgment

**NOT A SEPARATE REQUIRED HUMAN GATE FOR THIS DELTA.** Binding basis: `PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md` sections 2 and 4 require an AI-original Rights/IP Gate; `PHOENIX_UI_VISUAL_STANDARD.md` section 19 separately requires Founder Mobile Preview Approval. Neither clause requires a named Human/Founder to repeat the objective rights determination when unchanged AI-original bytes are merely added to the release bundle. If a human sees apparent third-party similarity during visual review, the Rights Gate must be reopened rather than silently approved.

## Human fields

- HUMAN VISUAL REVIEWER:
- HUMAN VISUAL REVIEW DATE:
- HUMAN VISUAL RESULT: HUMAN_REVIEW_REQUIRED
- HUMAN VISUAL NOTES:
- FINAL FOUNDER MOBILE APPROVAL: PENDING
