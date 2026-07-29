# Phoenix Journey Content Quality Agent

`PhoenixJourneyContentQualityAgent` is the release authority for journey content. The deterministic auditor detects structural and content problems; the agent converts those findings into scores, release decisions, and repair instructions.

## Release decisions

- `approved`: no detected issues; content may be published.
- `needsRevision`: improvement-level findings remain; content stays out of release until refined.
- `blocked`: one or more critical findings exist; publishing is prohibited.

## Complete release surface

The release catalog contains:

- 8 regular city journeys;
- 4 special journeys covering literary fantasy, mythology, zhiguai, and folk-inspired fiction;
- 10 public Phoenix levels for each journey;
- 120 mandatory journey-level inspections in every preview release.

The report must use `allJourneyExperiences`. Using only `dailyJourneyExperiences` is incomplete and must fail product-rule validation.

## What the agent reviews

The agent runs against every regular and special journey at Phoenix Lv.1–10. It reviews:

- the approved character range and one- or two-paragraph shape for the active Phoenix level;
- opening scene, narrative movement, paragraph boundaries, and closing meaning;
- pinyin, Vietnamese, and English alignment;
- discovery novelty, depth, and one- or two-entry structure;
- vocabulary validity and duplication;
- separation between comprehension and expression prompts;
- genre integrity for special journeys, preventing urban-heritage filler from entering dream, myth, zhiguai, or folk-fantasy stories;
- retention of HSK and TOCFL only as internal calibration and migration evidence.

## Special-journey narrative integrity

Special journeys use their own enrichment arcs:

- `literary-roaming`: butterfly, bamboo forest, dream, awakening, and identity;
- `myth-tracing`: moonlight, osmanthus, bamboo slip, white rabbit, return, and myth variation;
- `strange-night-talks`: storm, inn, shadowless guest, coin, promise, watches of the night, and rooster call;
- `folk-secret-land`: river lantern, upstream movement, future reflection, local specificity, and choice.

Their adaptive stories must not fall back to generic architecture, restoration, street, or heritage-preservation passages.

## Agent output

Every journey-level combination receives:

- a score from 0 to 100 and a quality grade;
- an `approved`, `needsRevision`, or `blocked` release status;
- issue dimensions and priorities;
- concrete repair actions, such as rebuilding paragraph two, restoring multilingual support, correcting the Phoenix length range, or replacing repeated discoveries.

## Visible PR report

Every pull-request update runs `app/tool/generate_journey_quality_report.dart` before the preview build. The workflow:

1. inspects all 12 journeys across Phoenix Lv.1–10;
2. writes both Markdown and JSON evidence;
3. records regular, special, total-journey, profile, and inspection counts;
4. uploads the evidence as a workflow artifact;
5. creates or updates one dedicated quality-agent comment on the pull request;
6. blocks the preview build when any combination is `needsRevision` or `blocked`.

A valid clean report must show 12 journeys, 10 profiles, 120 inspections, zero revisions, and zero blocked combinations.

## CI enforcement

Flutter tests call `inspectPublishedCatalog` across `allJourneyExperiences` and every Phoenix profile. Additional tests verify special-journey length ranges, paragraph structure, multilingual support, genre signals, and separation between the four expanded stories. CI and the Cloudflare preview require the entire batch to be publishable.
