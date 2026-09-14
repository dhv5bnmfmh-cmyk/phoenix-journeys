import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const appendix = readFileSync(
  new URL('../docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD_APPENDIX_STORY_DEPTH_HISTORY.md', import.meta.url),
  'utf8',
);
const aiBehavior = readFileSync(
  new URL('../ai/AI_BEHAVIOR.md', import.meta.url),
  'utf8',
);
const designMatrix = readFileSync(
  new URL('../docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md', import.meta.url),
  'utf8',
);
const acceptanceMatrix = readFileSync(
  new URL('../docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md', import.meta.url),
  'utf8',
);
const expansionRoadmap = readFileSync(
  new URL('../docs/PHOENIX_JOURNEY_CONTENT_EXPANSION_ROADMAP.md', import.meta.url),
  'utf8',
);

function containsAll(text, required) {
  for (const phrase of required) {
    assert.ok(text.includes(phrase), `missing required governance phrase: ${phrase}`);
  }
}

test('historical truth architecture preserves uncertainty and blocks invented history', () => {
  containsAll(appendix, [
    'HISTORICAL TRUTH OVERRIDES NARRATIVE CONVENIENCE',
    'NARRATIVE COMPLETENESS NEVER OVERRIDES HISTORICAL TRUTH',
    'A BEAUTIFUL FALSE STORY IS A PHOENIX FAILURE',
    'NO RELIABLE SOURCE → NO VERIFIED FACT CLAIM',
    'UNKNOWN REMAINS UNKNOWN',
    'CONTESTED REMAINS CONTESTED',
    'UNCERTAINTY IS PART OF HISTORICAL TRUTH',
    'Claim-level provenance',
    'Source confidence',
    'Real historical person protection',
    'UNKNOWN PROVENANCE != INVENTED PROVENANCE',
    'TEMPORAL CONSISTENCY TEST',
    'Multilingual truth parity',
  ]);

  containsAll(aiBehavior, [
    'Historical truth is higher priority than narrative convenience',
    'record claim-level provenance',
    'keep `UNKNOWN` unknown and `CONTESTED` contested',
    'never invent real-person consequential action',
    'never invent missing artifact ownership',
    'verify temporal consistency',
  ]);
});

test('Story Depth is causal and remains a non-checklist possibility space', () => {
  containsAll(appendix, [
    'STORY DEPTH != MORE FACTS',
    'DEPTH MUST CHANGE ACTION',
    'Sixteen-dimensional possibility space',
    'not sixteen mandatory boxes',
    'PRIMARY_DEPTH_MECHANISM',
    'SECONDARY_DEPTH_MECHANISMS',
    'INTENTIONALLY_UNUSED_DEPTH',
    'Depth Action Test',
    'PRIMARY_DEPTH_DECORATIVE',
    'MATERIAL != PROP',
    'SENSORY DETAIL != DECORATION',
    'LITERARY POSSIBILITY != MANDATORY TECHNIQUE',
    'DEPTH OPPORTUNITY != GOLD DEFECT',
    'STORY IMPROVEMENT MAY BE INFINITE. GOLD COMPLETION IS NOT.',
  ]);

  containsAll(designMatrix, [
    'Story Depth Profile',
    'PRIMARY_DEPTH_MECHANISM',
    'SECONDARY_DEPTH_MECHANISMS',
    'INTENTIONALLY_UNUSED_DEPTH',
    'Depth Action Test',
    'STORY SIGNATURE',
    'FUTURE_PLACE_STORY_OPPORTUNITIES',
  ]);
});

test('Historical Story Universe and same-Place differentiation add new axes without quotas', () => {
  containsAll(appendix, [
    'Story Universe coordinates',
    'SUBJECT',
    'TIME LAYER',
    'HUMAN LENS',
    'HISTORICAL SCALE',
    'Place Time Universe',
    'Continuity × Change Test',
    'ONE EVENT MAY CONTAIN MULTIPLE HUMAN TRUTHS',
    'MULTIPLE PERSPECTIVES != MANUFACTURED CONTROVERSY',
    'PLACE NETWORK STORY',
    'Historical Story families',
    'HISTORICAL DEPTH != HISTORICAL EXPOSITION',
    'SAME PLACE, NEW HUMAN EXPERIENCE',
    'SAME PLACE, DIFFERENT TIME, DIFFERENT LIFE, DIFFERENT HISTORY',
    'CULTURAL COVERAGE IS ACCUMULATIVE ACROSS STORIES',
  ]);

  containsAll(acceptanceMatrix, [
    'NJ-110',
    'Claim-level historical provenance',
    'NJ-118',
    'Story Depth Profile',
    'NJ-128',
    'Same-Place depth/historical differentiation',
    'NJ-130',
    'Future run semantics boundary',
  ]);
});

test('Place Story Universe experience semantics are defined but runtime remains deferred', () => {
  containsAll(appendix, [
    'PLACE → PLACE STORY UNIVERSE → STORY EXPERIENCE → JOURNEY RUN',
    'UNSEEN FIRST',
    'DIFFERENT PER NEW RUN',
    'STABLE WITHIN THE RUN',
    'EXPERIENCE DIVERSITY COMES FROM MULTIPLE APPROVED GOLD STORIES, NOT RUNTIME-GENERATED RANDOMNESS',
    'No UI, persistence, Stamp, Passport, or progress implementation is authorized here.',
    'RUNTIME_IMPLEMENTED = NO',
    'MULTI_STORY_SELECTION_IMPLEMENTED = NO',
    'DATA_MODEL_CHANGED = NO',
  ]);

  containsAll(expansionRoadmap, [
    'PLACE STORY UNIVERSE EXPERIENCE PILOT ORDER',
    'UNSEEN FIRST',
    'STABLE WITHIN THE RUN',
    'This roadmap does not authorize Story Experience runtime',
    'STORY DEPTH ROUND 2',
  ]);
});

test('acceptance governance makes truth and depth review enforceable without treating optional depth as failure', () => {
  containsAll(acceptanceMatrix, [
    'Artifact provenance integrity',
    'Temporal consistency',
    'Multilingual truth parity',
    'Primary Depth Action Test',
    'Gold defect versus Depth Opportunity',
    'Story Signature',
    'PRIMARY_DEPTH_DECORATIVE',
    'ARTIFACT_PROVENANCE_FABRICATED',
    'TEMPORAL_ANACHRONISM',
    'DEPTH OPPORTUNITY != GOLD DEFECT',
  ]);

  containsAll(aiBehavior, [
    'The sixteen Story Depth dimensions are a possibility space, not a checklist.',
    'DEPTH OPPORTUNITY != GOLD DEFECT',
    'Standards authorization does not authorize runtime Story rotation',
  ]);
});