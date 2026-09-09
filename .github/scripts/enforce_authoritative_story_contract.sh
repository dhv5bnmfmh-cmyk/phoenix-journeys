#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

contract='docs/AUTHORITATIVE_STORY_DEVELOPMENT_CONTRACT.md'
test -s "$contract"

for authority in \
  PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md \
  PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD_APPENDIX_STORY_DEPTH_HISTORY.md \
  PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md \
  PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md \
  PHOENIX_JOURNEY_SYSTEM_STANDARD.md \
  PHOENIX_PRODUCT_QUALITY_STANDARD.md \
  PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md \
  journey-content-quality-gate.md \
  FAST_DEVELOPMENT_GOVERNANCE_V2.md; do
  test -s "docs/$authority"
  grep -Fq "$authority" "$contract"
done

grep -Fq 'templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md' "$contract"
grep -Fq 'templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md' "$contract"
grep -Fq '两条路，一张图' "$contract"

rejected='story\.forbidden_city\.modern_evidence_handoff|seed\.forbidden_city\.modern_evidence_handoff|fixture\.forbidden_city\.modern_evidence_handoff|交接前的标记|forbiddenCitySecondStory|forbidden_city_second_story|forbidden_city_story_runtime|forbidden_city_content_pipeline_fixture|forbidden_city_story_engine_v1'
if grep -R -n -E "$rejected" app/lib app/test .github/scripts .github/workflows \
  --exclude='enforce_authoritative_story_contract.sh'; then
  echo 'Rejected Story runtime or support path remains.' >&2
  exit 1
fi

test "$(grep -R -l -F "title: '两条路，一张图'" app/lib/data | wc -l)" -eq 1

for workflow in .github/workflows/deploy-cloudflare.yml \
  .github/workflows/preview-cloudflare.yml \
  .github/workflows/flutter-ci.yml; do
  grep -Fq '.github/scripts/enforce_authoritative_story_contract.sh' "$workflow"
done

for workflow in .github/workflows/*.yml; do
  if grep -E -q 'wrangler(@[0-9]+)? deploy|statuses/\$|Publish exact' "$workflow"; then
    grep -Fq '.github/scripts/enforce_authoritative_story_contract.sh' "$workflow" || {
      echo "Story Preview/Deploy/Publish bypass: $workflow" >&2
      exit 1
    }
  fi
done

echo 'AUTHORITATIVE STORY DEVELOPMENT CONTRACT: ENFORCED'
echo 'GOLDEN STORY: 两条路，一张图'
echo 'REJECTED STORY PATHS: 0'
