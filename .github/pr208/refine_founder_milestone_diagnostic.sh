#!/usr/bin/env bash
set -euo pipefail

PRODUCT_BRANCH="product/city-standard-v1-beijing-forbidden-city"
BASE_PRODUCT_SHA="d560fa1403e5c8ec14e4291eaf4ae34184a125b8"
DIAGNOSTIC_BRANCH="diagnostic/pr208-founder-device-milestones-d560fa"
PREVIOUS_DIAGNOSTIC_SHA="2c9653038487955b4289b32b0d1166000e9a519f"

remote_product="$(git ls-remote origin "refs/heads/${PRODUCT_BRANCH}" | awk '{print $1}')"
test "$remote_product" = "$BASE_PRODUCT_SHA"
remote_diag="$(git ls-remote origin "refs/heads/${DIAGNOSTIC_BRANCH}" | awk '{print $1}')"
test "$remote_diag" = "$PREVIOUS_DIAGNOSTIC_SHA"

git fetch origin "$DIAGNOSTIC_BRANCH"
git checkout -B "$DIAGNOSTIC_BRANCH" "$PREVIOUS_DIAGNOSTIC_SHA"
test "$(git rev-parse HEAD^)" = "$BASE_PRODUCT_SHA"
test -z "$(git status --porcelain)"

python3 <<'PY'
from pathlib import Path
p = Path('app/lib/screens/journey_screen.dart')
text = p.read_text()

old_callback = """      title: '故事',
      onNext: () {
        _pjDiagnostic('PJ_CONTINUE_TAP_RECEIVED');
        unawaited(_enterVocabularyAtFirstWord());
      },
"""
new_callback = """      title: '故事',
      onNext: () => unawaited(_enterVocabularyAtFirstWord()),
"""
if text.count(old_callback) != 1:
    raise SystemExit('diagnostic callback anchor not unique')
text = text.replace(old_callback, new_callback, 1)

old_method = """  Future<void> _enterVocabularyAtFirstWord() async {
    try {
"""
new_method = """  Future<void> _enterVocabularyAtFirstWord() async {
    _pjDiagnostic('PJ_CONTINUE_TAP_RECEIVED');
    try {
"""
if text.count(old_method) != 1:
    raise SystemExit('diagnostic method-entry anchor not unique')
text = text.replace(old_method, new_method, 1)
p.write_text(text)
PY

test "$(git diff --name-only)" = "app/lib/screens/journey_screen.dart"
git diff --check
grep -Fq "onNext: () => unawaited(_enterVocabularyAtFirstWord())," app/lib/screens/journey_screen.dart
grep -A2 -F "Future<void> _enterVocabularyAtFirstWord() async {" app/lib/screens/journey_screen.dart | grep -Fq "PJ_CONTINUE_TAP_RECEIVED"
for marker in \
  PJ_CONTINUE_TAP_RECEIVED \
  PJ_CONTINUE_PRE_GUARDS_COMPLETE \
  PJ_STEP_1_COMMIT_BEGIN \
  PJ_STEP_1_COMMITTED \
  PJ_VOCAB_BUILD_BEGIN \
  PJ_VOCAB_FIRST_FRAME; do
  grep -q "$marker" app/lib/screens/journey_screen.dart
done

git config user.name 'github-actions[bot]'
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
git add app/lib/screens/journey_screen.dart
git commit -m 'diagnostic(pr208): preserve Continue callback source contract'
diag_sha="$(git rev-parse HEAD)"
test "$(git rev-parse HEAD^)" = "$PREVIOUS_DIAGNOSTIC_SHA"
git push origin "HEAD:refs/heads/${DIAGNOSTIC_BRANCH}"

remote_product="$(git ls-remote origin "refs/heads/${PRODUCT_BRANCH}" | awk '{print $1}')"
test "$remote_product" = "$BASE_PRODUCT_SHA"
if [[ -n "${GITHUB_ENV:-}" ]]; then
  echo "DIAGNOSTIC_SHA=$diag_sha" >> "$GITHUB_ENV"
fi
echo "DIAGNOSTIC_SHA=$diag_sha"
