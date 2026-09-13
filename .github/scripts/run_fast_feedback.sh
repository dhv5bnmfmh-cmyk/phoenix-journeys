#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

mapping_tests=(
  test/story_discovery_no_yellow_dots_test.dart
  test/founder_real_device_ux_test.dart
  test/all_gold_challenge_cross_gold_dna_test.dart
  test/all_gold_challenge_phase2_contract_test.dart
  test/forbidden_city_full_lifecycle_level_consistency_test.dart
  test/journey_memory_completion_narration_contract_test.dart
  test/narration_compact_progress_test.dart
  test/daily_journey_state_test.dart
  test/journey_access_daily_slots_test.dart
  test/journey_access_entry_widget_test.dart
  test/city_passport_screen_test.dart
  test/city_standard_v1_test.dart
  test/forbidden_city_journey_backlog_test.dart
)

check_mapping() {
  local missing=0
  for test_file in "${mapping_tests[@]}"; do
    if [[ ! -f "$ROOT/app/$test_file" ]]; then
      echo "FAST FEEDBACK MAPPING MISSING: app/$test_file" >&2
      missing=1
    fi
  done
  [[ "$missing" -eq 0 ]]
  echo "FAST FEEDBACK MAPPING = VALID (${#mapping_tests[@]} focused tests)"
}

if [[ "${1:-}" == "--check-mapping" ]]; then
  check_mapping
  exit 0
fi

check_mapping >/dev/null
BASE="${1:-${PHOENIX_FAST_BASE:-HEAD~1}}"
if ! git rev-parse --verify "$BASE" >/dev/null 2>&1; then
  echo "FAST FEEDBACK BASE NOT FOUND: $BASE" >&2
  exit 2
fi

mapfile -t changed_files < <(git diff --name-only "$BASE"...HEAD 2>/dev/null || git diff --name-only "$BASE" HEAD)
if [[ "${#changed_files[@]}" -eq 0 ]]; then
  echo "FAST FEEDBACK: no changed files against $BASE"
  exit 0
fi

tests=()
risk="LOW"
needs_analyze=false
needs_pub_get=false
product_change=false

add_test() {
  local candidate="$1" existing
  for existing in "${tests[@]}"; do
    [[ "$existing" == "$candidate" ]] && return
  done
  tests+=("$candidate")
}

raise_risk() {
  local requested="$1"
  case "$risk:$requested" in
    LOW:MEDIUM|LOW:HIGH|MEDIUM:HIGH) risk="$requested" ;;
  esac
}

for file in "${changed_files[@]}"; do
  case "$file" in
    app/lib/widgets/interactive_story_text.dart)
      product_change=true; needs_analyze=true
      add_test test/story_discovery_no_yellow_dots_test.dart
      add_test test/founder_real_device_ux_test.dart
      ;;
    app/lib/widgets/hsk_story_challenge.dart|app/lib/services/journey_challenge_engine.dart|app/lib/models/journey_challenge.dart)
      product_change=true; needs_analyze=true; raise_risk MEDIUM
      add_test test/all_gold_challenge_cross_gold_dna_test.dart
      add_test test/all_gold_challenge_phase2_contract_test.dart
      add_test test/forbidden_city_full_lifecycle_level_consistency_test.dart
      ;;
    app/lib/services/narration_controller.dart|app/lib/services/narration_follow_coordinator.dart|app/lib/widgets/narration_player_card.dart|app/lib/widgets/journey_stage_narration_button.dart)
      product_change=true; needs_analyze=true; raise_risk HIGH
      add_test test/journey_memory_completion_narration_contract_test.dart
      add_test test/narration_compact_progress_test.dart
      add_test test/founder_real_device_ux_test.dart
      ;;
    app/lib/state/*)
      product_change=true; needs_analyze=true; raise_risk HIGH
      add_test test/daily_journey_state_test.dart
      add_test test/journey_access_daily_slots_test.dart
      add_test test/forbidden_city_full_lifecycle_level_consistency_test.dart
      ;;
    app/lib/app.dart|app/lib/screens/explore_screen.dart|app/lib/screens/journey_screen.dart|app/lib/screens/passport_screen.dart|app/lib/screens/city_passport_screen.dart|app/lib/widgets/journey_picker_sheet.dart|app/lib/widgets/journey_progress_header.dart)
      product_change=true; needs_analyze=true; raise_risk HIGH
      add_test test/journey_access_entry_widget_test.dart
      add_test test/city_passport_screen_test.dart
      add_test test/founder_real_device_ux_test.dart
      ;;
    app/lib/data/forbidden_city_*.dart|app/lib/data/beijing_city_standard.dart|app/lib/data/journey_level_catalog.dart|app/lib/data/adaptive_journey_level_runtime.dart|app/lib/data/dedicated_adaptive_journey_catalog.dart)
      product_change=true; needs_analyze=true; raise_risk HIGH
      add_test test/city_standard_v1_test.dart
      add_test test/forbidden_city_journey_backlog_test.dart
      add_test test/forbidden_city_full_lifecycle_level_consistency_test.dart
      ;;
    app/pubspec.yaml)
      product_change=true; needs_pub_get=true; needs_analyze=true; raise_risk MEDIUM
      ;;
    app/lib/*.dart|app/lib/**/*.dart)
      product_change=true; needs_analyze=true
      ;;
    app/assets/*|app/assets/**/*)
      product_change=true
      ;;
  esac
done

echo "FAST FEEDBACK RISK = $risk"
printf 'CHANGED: %s\n' "${changed_files[@]}"

if [[ "$product_change" != true ]]; then
  echo "FAST FEEDBACK: infrastructure/docs-only change; use Governance Static Validation, no Flutter suite."
  exit 0
fi

if [[ "$needs_pub_get" == true ]]; then
  (cd app && flutter pub get)
fi

if [[ "${#tests[@]}" -gt 0 ]]; then
  echo "TARGETED TESTS: ${tests[*]}"
  (cd app && flutter test "${tests[@]}")
else
  echo "TARGETED TESTS: no deterministic feature mapping for these files"
fi

if [[ "$needs_analyze" == true ]]; then
  (cd app && flutter analyze)
fi

if [[ "$risk" == "HIGH" ]]; then
  echo "HIGH RISK: run the relevant specialized integration/E2E check before release when its scoped workflow applies."
fi

echo "FAST FEEDBACK = PASS"
