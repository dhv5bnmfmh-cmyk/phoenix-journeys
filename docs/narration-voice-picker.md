# Phoenix narration voice picker

## Product contract

- The voice picker lives inside the existing narration speed control.
- Simplified Mandarin and Taiwan Mandarin keep separate device preferences.
- Automatic best-voice selection remains the default.
- Preview speech never changes journey progress.
- A missing saved voice falls back to Phoenix natural-voice ranking.
- Story, discovery, word, and support narration use the same saved preference.

## Release protection

Flutter and Node rules must pass before an isolated Cloudflare preview is published. The stable `main` release is not changed until the explorer approves the preview.
