#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
cd "$root"

contract='docs/AUTHORITATIVE_STORY_DEVELOPMENT_CONTRACT.md'
golden='151dcf332bdaea9e75b1797ea45bc2af488d482b'
test -s "$contract"
grep -Fq "$golden" "$contract"
grep -Fq 'Future development start truth:' "$contract"
grep -Fq '`main`' "$contract"
grep -Fq 'Active authoritative standard count: 1' "$contract"
grep -Fq 'STRUCTURE CAN REPEAT. PEDAGOGY AND AUTHORED STORY LOGIC CANNOT BE RESKINNED.' "$contract"
grep -Fq 'Development / Release Failure Prevention' "$contract"
grep -Fq 'forbidden_city_content_uniqueness_remediation_test.dart' "$contract"

legacy_references=(
  docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md
  docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD_APPENDIX_STORY_DEPTH_HISTORY.md
  docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md
  docs/PHOENIX_SIX_STAGE_JOURNEY_STANDARD.md
  docs/PHOENIX_JOURNEY_SYSTEM_STANDARD.md
  docs/PHOENIX_PRODUCT_QUALITY_STANDARD.md
  docs/PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md
  docs/FAST_DEVELOPMENT_GOVERNANCE_V2.md
  docs/PHOENIX_JOURNEY_ACCEPTANCE_CONTRACT.md
  docs/journey-content-quality-gate.md
  docs/templates/PHOENIX_NEW_JOURNEY_ACCEPTANCE_MATRIX.md
  docs/templates/PHOENIX_SIX_STAGE_JOURNEY_ACCEPTANCE_MATRIX.md
  docs/templates/PHOENIX_STORY_DISCOVERY_DESIGN_MATRIX.md
)
for reference in "${legacy_references[@]}"; do
  test -s "$reference"
  grep -Fq 'NON-AUTHORITATIVE REFERENCE' "$reference"
  grep -Fq 'AUTHORITATIVE_STORY_DEVELOPMENT_CONTRACT.md' "$reference"
done

if grep -R -n -F 'product/city-standard-v1-beijing-forbidden-city' .github/workflows .github/scripts \
  --exclude='enforce_authoritative_story_contract.sh'; then
  echo 'Retired branch remains in active workflow/config.' >&2
  exit 1
fi

grep -Fq 'forbidden_city_content_uniqueness_remediation_test.dart' .github/workflows/authoritative-story-development.yml
grep -Fq 'journey_semantic_anti_template_gate_test.dart' .github/workflows/authoritative-story-development.yml
grep -Fq 'founder_story_lifecycle_resume_test.dart' .github/workflows/authoritative-story-development.yml
grep -Fq 'founder_level_switch_journey_reset_test.dart' .github/workflows/authoritative-story-development.yml

for workflow in .github/workflows/deploy-cloudflare.yml .github/workflows/preview-cloudflare.yml .github/workflows/flutter-ci.yml; do
  grep -Fq '.github/scripts/enforce_authoritative_story_contract.sh' "$workflow"
done

echo 'AUTHORITATIVE STORY DEVELOPMENT CONTRACT: ENFORCED'
echo 'ACTIVE AUTHORITATIVE STANDARD COUNT: 1'
echo 'PARALLEL ACTIVE STANDARD COUNT: 0'
echo 'LOGICAL ACTIVE DEVELOPMENT ROUTE: main'
echo "GOLDEN PRODUCT BASELINE: $golden"
