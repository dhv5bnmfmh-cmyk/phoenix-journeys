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

## Visible PR report

Every pull-request update runs `app/tool/generate_journey_quality_report.dart` before the preview build. The workflow:

1. inspects the complete published catalog across all HSK and TOCFL profiles;
2. writes both Markdown and JSON evidence;
3. uploads the evidence as a workflow artifact;
4. creates or updates one dedicated quality-agent comment on the pull request;
5. blocks the preview build when any profile is `needsRevision` or `blocked`.

The PR report displays the inspection total, approved count, minimum score, average score, and a per-journey summary. Failed combinations include concrete repair actions, while a clean report explicitly authorizes preview publication.

## CI enforcement

Flutter tests call `inspectPublishedCatalog` across the complete journey catalog and every HSK/TOCFL profile. CI and the Cloudflare preview require the entire batch to be publishable. A critical issue, warning, missing profile, failed agent rule, or failed report decision stops the release.
