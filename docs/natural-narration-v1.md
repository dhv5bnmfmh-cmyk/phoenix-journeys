# Phoenix natural narration v1

Base: stable main commit `d978b227c3dae4ea0627fff293a7478b8afd64f1`.

## Scope

- Warm the browser speech voice catalog before the explorer presses play.
- Rank exact-locale natural, neural, premium, and enhanced voices ahead of compact or robotic fallbacks.
- Keep Simplified Chinese and Traditional Chinese voice regions distinct.
- Apply restrained language-specific pitch and safe speed bounds without changing the explorer's selected speed step.
- Confirm that the browser actually started speech; surface an error instead of leaving the player in a silent fake-playing state.

## Safety

- Story, discovery, vocabulary, challenge, progress, wallet, map, and journey data are unchanged.
- Development remains isolated from `main` until the preview is approved.
