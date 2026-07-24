# Phoenix Journeys Development Plan

> 当前产品北极星、完整历史路线、故事先行方向、AI 同行者、城市故事宇宙与动态背景品质准则，以 [`PHOENIX_PRODUCT_ROUTE.md`](./PHOENIX_PRODUCT_ROUTE.md) 为准。
>
> 本文件保留早期工程阶段计划，供回顾基础建设过程使用。任何新功能不得把 Phoenix 改成每日打卡学习软件。

Last updated: 2026-07-24

## Current Architecture

- Client: Flutter
- Application source: `app/`
- State: Provider + SharedPreferences
- Content: repository-managed Journey files under `content/`
- Planned backend: Supabase
- First Journey: Beijing · Forbidden City
- Primary target: mobile web/PWA, then packaged mobile apps

## Current Product Baseline

Already present:

- Explore, Passport and Profile navigation
- Beijing Journey starter experience
- Simplified/traditional Chinese toggle
- Word detail sheet with pinyin and Vietnamese explanation
- Local learning memory persistence
- Initial map/flight visual treatment
- Product, AI, content and licensing principles

Not production-ready yet:

- Flutter Web/PWA project files and install experience
- Reliable Cloudflare build/deployment workflow
- CI checks for analyze/test/web build
- Real map data and route model
- Text-to-speech and automatic reading
- Long-press word segmentation across arbitrary Chinese text
- AI guide and writing feedback backend
- Authentication and cloud sync
- Reviewed content sources and production asset licenses
- Error, offline, loading and privacy states

## Development Mode

### Small safe changes

Commit directly to `main` after checking affected files.

### Feature work

Use a focused feature branch, run checks, open a pull request, then merge after review.

### Required checks

- `flutter analyze`
- `flutter test`
- `flutter build web`
- Mobile viewport acceptance check
- No secrets committed
- Factual content and asset licenses recorded

## Phase 1 — Stable PWA Foundation

1. Audit and restore complete Flutter Web platform files.
2. Configure PWA manifest, icons, theme, install metadata and offline shell.
3. Add GitHub Actions for analyze, test and web build.
4. Document Cloudflare deployment path.
5. Improve responsive mobile shell, safe areas and loading/error states.
6. Add basic route and state architecture that can scale beyond one Journey.

Exit criteria:

- A clean checkout can build for web.
- CI passes on every push and pull request.
- The app installs as a PWA on supported mobile browsers.
- Main screens work at common iPhone and Android viewport widths.

## Phase 2 — Core Learning Experience

1. Structured Journey model loaded from content files.
2. Story text with long-press/tap word lookup.
3. Pinyin, Chinese definition and Vietnamese explanation.
4. Word and Discovery text-to-speech.
5. Vocabulary collection and automatic learning history.
6. Real city route/map model and polished flight animation.
7. City stamp and Passport progression.

## Phase 3 — AI Guide and Writing

1. Secure AI gateway with no client-side secret keys.
2. AI guide grounded only in reviewed Journey sources.
3. Contextual city questions and follow-up conversation.
4. Writing task, scoring rubric and respectful correction flow.
5. Safety, factuality and insufficient-evidence responses.
6. Cost limits, logging and abuse protection.

## Phase 4 — Accounts and Cloud Data

1. Supabase authentication.
2. Cloud-synced memories, vocabulary and Passport stamps.
3. Private-by-default photo uploads.
4. Sharing cards and Journey timeline.
5. Subscription capacity model without advertising or content paywalls.

## Immediate Sprint

### Sprint 1A — Build and PWA audit

- Inspect `app/web`, platform metadata and deployment files.
- Add missing web/PWA files when needed.
- Add CI workflow.
- Verify the production build command.
- Remove temporary repository test artifacts.

### Sprint 1B — Mobile foundation

- Audit navigation and safe-area behavior.
- Define reusable responsive spacing and screen constraints.
- Add consistent loading, empty and error components.
- Update widget tests to match the current interface.

## Product Rules

- Phoenix Journeys is the only active product project.
- Build the real product, not standalone demos.
- Mobile experience comes first.
- No third-party advertising.
- AI must not invent cultural, historical or scientific facts.
- Every production Journey needs reviewed sources.
- Every production visual/audio asset needs a recorded license or ownership status.
- Story and curiosity lead; language learning stays naturally embedded.
- Do not add daily streak pressure, compulsory review or classroom-style progression as the main product loop.
