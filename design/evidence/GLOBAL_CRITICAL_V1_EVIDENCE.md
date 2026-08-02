# Global Critical Visuals v1 — Rights and Gate Evidence

Status: Active
Creation Date: 2026-08-01
Reviewer: Phoenix Visual Architecture
Protocol: `design/SAFE_REPLACEMENT_PROTOCOL.md`
Generator: `worker/scripts/generate_global_rights_safe_assets.mjs`

## Common declaration

All nine assets were created inside the controlled local repository environment from primitive SVG geometry authored specifically for Phoenix. No existing image, map tile, geographic dataset, icon library, font icon, trademark, likeness, external prompt, external model, external API, online design platform, or third-party source file was used. The editable SVG masters and deterministic generator are committed with the release files.

- Creator: Phoenix Visual Architecture under user-authorized controlled execution
- Creation Method: local programmatic SVG and deterministic local raster export
- Tool: Node.js 24, SVG 1.1, Inkscape 1.2.2, ImageMagick 6.9.11-60
- Model / Model Version / Seed: `NOT_APPLICABLE`
- Input Asset / Input Asset Rights: `NOT_APPLICABLE`
- Commercial Account Evidence: `NOT_APPLICABLE`
- Terms Evidence: `NOT_APPLICABLE — no external service or licensed input used`
- Commercial Use Basis: Phoenix project-original programmatic source created for this repository
- Modification Rights / Redistribution Rights: allowed by Phoenix project owner
- Attribution Requirement: `NOT_APPLICABLE`
- Trademark Review: passed; no mark or third-party logo
- Likeness Review: passed; no person or likeness
- Cultural Review: passed for non-metric, non-political, simplified journey diagrams; no external map data
- Gate Result: all 14 Phase 1 gates passed locally by source inspection and runtime integration tests; remote CI evidence remains pending until the branch checkpoint runs
- Preview / Release Eligibility: asset-level complete; whole library remains blocked

## Nine design records

| Asset ID | Purpose and design record | Editable master | Release file | Runtime page | Responsive / fallback / motion |
|---|---|---|---|---|---|
| `PHX-GLOBAL-HOME-001` | Quiet world-language journey field with lower-half Phoenix route focus and upper title safe area. | `design/sources/global-critical-v1/phoenix-home-journey-keyart-portrait-v1.svg` | `app/assets/images/home/phoenix-home-journey-keyart-portrait-v1.webp` | Explore Home | `BoxFit.cover`; gradient final fallback; subtle camera stops under Reduced Motion. |
| `PHX-GLOBAL-MAP-WORLD-001` | Non-metric simplified world relationship diagram; route remains a Flutter overlay. | `design/sources/global-critical-v1/phoenix-world-route-atlas-landscape-v1.svg` | `app/assets/images/maps/phoenix-world-route-atlas-landscape-v1.webp` | Explore flight / Passport continent | cover/contain by page; `_FlightMapFallback` or passport gradient; flight stops under Reduced Motion. |
| `PHX-GLOBAL-MAP-ASIA-001` | Non-metric East Asia relationship field with no border claims, labels or external data. | `design/sources/global-critical-v1/phoenix-east-asia-route-atlas-landscape-v1.svg` | `app/assets/images/maps/phoenix-east-asia-route-atlas-landscape-v1.webp` | Explore destination flight / Passport Asia | cover/contain by page; existing programmatic fallbacks; route motion controlled in Flutter. |
| `PHX-GLOBAL-MAP-CHINA-001` | Non-metric passport geography field; Journey hotspots remain authoritative Flutter data. | `design/sources/global-critical-v1/phoenix-china-passport-atlas-portrait-v1.svg` | `app/assets/images/maps/phoenix-china-passport-atlas-portrait-v1.webp` | Passport China | contain with pinch zoom; passport gradient fallback; no embedded motion. |
| `PHX-GLOBAL-SPLASH-001` | Fast portrait launch field using globe geometry and Phoenix journey focus without text duplication. | `design/sources/global-critical-v1/phoenix-launch-journey-cover-portrait-v1.svg` | `app/assets/images/phoenix-launch-journey-cover-portrait-v1.webp` | Web startup Splash | cover; solid/gradient CSS fallback; breathing animation disabled by Reduced Motion. |
| `PHX-GLOBAL-DYNAMIC-001` | Three-frame locally drawn Phoenix flight silhouette sprite. | `design/sources/global-critical-v1/phoenix-launch-flight-sprite-landscape-v1.svg` | `app/assets/images/phoenix-launch-flight-sprite-landscape-v1.webp` | Web startup Dynamic Layer | CSS 3-frame cycle; static first frame under Reduced Motion; removed with startup layer. |
| `PHX-GLOBAL-ICON-064-001` | Geometric Phoenix compass mark, 64 px favicon. | `design/sources/global-critical-v1/phoenix-app-mark-square-64-v1.svg` | `app/web/phoenix-app-mark-square-64-v1.svg` | Web favicon | SVG viewBox; dark/light contrast; browser fallback is no icon, never blocking startup. |
| `PHX-GLOBAL-ICON-192-001` | Geometric Phoenix compass mark, 192 px maskable app icon. | `design/sources/global-critical-v1/phoenix-app-mark-square-192-v1.svg` | `app/web/icons/phoenix-app-mark-square-192-v1.svg` | Web manifest | scalable SVG, maskable safe area, no motion. |
| `PHX-GLOBAL-ICON-512-001` | Geometric Phoenix compass mark, 512 px maskable app icon. | `design/sources/global-critical-v1/phoenix-app-mark-square-512-v1.svg` | `app/web/icons/phoenix-app-mark-square-512-v1.svg` | Web manifest | scalable SVG, maskable safe area, no motion. |

## Hash evidence

SHA-256 and Git Blob SHA are stored per release file and editable master in `design/ASSET_REGISTER.csv`. Exact reproduction is performed by the committed generator; external network access is neither required nor allowed.
