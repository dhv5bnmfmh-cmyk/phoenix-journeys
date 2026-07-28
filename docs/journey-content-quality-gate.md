# Phoenix Journey Content Quality Agent

`PhoenixJourneyContentQualityAgent` is the release authority for journey content. The existing auditor remains the deterministic detection engine; the agent turns those findings into scores, release decisions, and repair instructions.

## Release decisions

- `approved`: no detected issues; content may be published.
- `needsRevision`: only improvement-level findings remain; content stays out of release until refined.
- `blocked`: one or more critical findings exist; publishing is prohibited.

## What the agent reviews

The agent runs against every published regular and special journey for every HSK and TOCFL profile. It reviews:

- narrative shape, opening scene, turning flow, paragraph boundaries, and closing meaning;
- pinyin, Vietnamese, and English alignment;
- discovery novelty, depth, and one- or two-entry structure;
- vocabulary validity and duplication;
- separation between comprehension and expression prompts;
- fit with the selected language profile.

## Agent output

Every journey/profile combination receives:

- a score from 0 to 100 and a quality grade;
- an `approved`, `needsRevision`, or `blocked` release status;
- issue dimensions and priorities;
- concrete repair actions, such as rebuilding paragraph two, restoring multilingual support, or replacing repeated discoveries with historical or cultural context.

## CI enforcement

Flutter tests call `inspectPublishedCatalog` across the complete journey catalog and every HSK/TOCFL profile. CI and the Cloudflare preview require the entire batch to be publishable. A critical issue, warning, missing profile, or failed agent rule stops the release.
