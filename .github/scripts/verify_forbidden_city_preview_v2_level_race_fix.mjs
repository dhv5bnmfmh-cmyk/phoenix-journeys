import { readFile, writeFile } from 'node:fs/promises';

// The session-lock contract removes in-Journey level races. Keep the historical
// workflow entry point while delegating to the canonical configured-level E2E.
// The current Grammar UI labels the red error segment as "修改错误". The canonical
// E2E still contains one stale "错误位置" assertion, so adapt only that harness
// expectation while this historical wrapper executes. Product code is untouched.
const canonicalUrl = new URL('./verify_forbidden_city_preview_v2.mjs', import.meta.url);
const original = await readFile(canonicalUrl, 'utf8');
const staleAssertion = "? '错误位置'\n          : '填错';";
const currentAssertion = "? '修改错误'\n          : '填错';";

if (!original.includes(staleAssertion)) {
  throw new Error('stale Grammar error-marker assertion not found');
}

await writeFile(canonicalUrl, original.replace(staleAssertion, currentAssertion));
try {
  await import('./verify_forbidden_city_preview_v2.mjs');
} finally {
  await writeFile(canonicalUrl, original);
}
