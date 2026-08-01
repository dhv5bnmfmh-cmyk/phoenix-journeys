# Phoenix Dynamic Background System

> Version: `1.0.0`
> Updated: 2026-08-01
> Status: active runtime contract

## Purpose

Phoenix uses one shared background runtime across startup, exploration, passport, shadowing, profile, ordinary Journey and special Journey pages. Existing destination artwork that already meets the quality bar is retained. The shared runtime adds restrained cinematic depth, atmosphere and motion without replacing strong artwork merely for novelty.

## Original asset statement

The new motion layer is original Phoenix project code. It is generated procedurally at runtime with Flutter `CustomPainter`, gradients and geometry. It does not download, trace or reproduce third-party film, game, animation, brand or artist assets. No external logo, character, text, stock image or commercial visual package is included.

Existing repository destination images remain governed by their existing source records and asset catalog. Unknown-license network imagery is prohibited.

## Visual structure

Each active Journey ID deterministically produces a destination palette and environment treatment:

- Far distance: sky gradient and atmospheric light.
- Mid distance: two slow mountain or city-silhouette depth planes.
- Near distance: restrained foreground landform and haze.
- Water destinations: low-opacity reflected light lines.
- Text safety: a stable low-contrast center field and subtle edge scrim.

Journey identity is derived from the Journey ID and semantic keywords such as lake, river, stream, palace, wall, tulou and Dunhuang. Existing destination art remains the main cultural image; the procedural layer supplies continuity and motion.

## Motion contract

- One slow 38–42 second loop.
- No flashing, shaking, particle explosion or fast parallax.
- Motion affects only paint transforms and gradients.
- Every layer is inside `RepaintBoundary` and `IgnorePointer` where appropriate.
- Buttons, narration, highlights, input and page navigation remain interactive.
- The static frame at progress 0.37–0.42 is the fallback image.

## Reduced-motion and low-performance behavior

Motion stops when any of these conditions is true:

- Operating system requests reduced motion.
- Phoenix user setting “减少动态效果” is enabled.
- Preview query uses `motion=off`.
- Very narrow, high-density devices trigger conservative background reduction.

Preview query `motion=on` can force motion for visual QA. The preference is stored locally using SharedPreferences and restores after refresh or returning to the app.

## Loading and failure behavior

The procedural layer has no network dependency and no image decode cost. Existing destination images keep their current precache, errorBuilder and static fallback behavior. Therefore slow networks show the local static scene immediately, while the procedural layer paints without a black frame.

## Responsive behavior

The painter uses current viewport dimensions rather than fixed pixels. Foreground, haze, lighting and water reflections scale across phones, tablets and wide screens. No image stretching is introduced.

## QA checklist

- Check startup, explore, passport, shadowing and profile.
- Check Story, Vocabulary, Discovery, Challenge, Memory and completion pages.
- Check ordinary and special Journeys.
- Check portrait phone, narrow phone, tablet and wide layout.
- Check simplified and traditional Chinese.
- Check narration, word playback, return restoration and page transition.
- Toggle reduced motion and refresh.
- Test `motion=off` and `motion=on`.
- Confirm no flash, black frame, blocked pointer or text contrast regression.
