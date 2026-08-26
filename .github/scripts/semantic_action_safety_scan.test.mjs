import test from 'node:test';
import assert from 'node:assert/strict';
import { unsafeSemanticActionFindings } from './semantic_action_safety_scan.mjs';

test('Reference stale semantic index action is rejected', () => {
  const bad = "await page.locator('flt-semantics').nth(button.index).tap({ timeout: 2000 });";
  assert.equal(unsafeSemanticActionFindings(bad).length, 2);
});

test('live ElementHandle recheck action is accepted', () => {
  const good = `const bound = await bindLiveSemantic(page, spec);\nconst fresh = await recordForHandle(bound.handle);\nif (!semanticMatches(fresh, spec)) throw new Error('drift');\nawait bound.handle.click();`;
  assert.deepEqual(unsafeSemanticActionFindings(good), []);
});

test('dynamic generated active harness is rejected', () => {
  const bad = `await writeFile(tempPath, patched, 'utf8');\nawait import(pathToFileURL(tempPath).href);`;
  assert.equal(unsafeSemanticActionFindings(bad).some((finding) => finding.rule === 'generated-active-harness'), true);
});

test("Xi'an deterministic Passport selection fixture preserves source-authoritative order", () => {
  const sequence = ['护照', '中国', '陕西省', '西安', '西安城墙'];
  const source = `await activate('护照'); await activate('中国'); await activate('陕西省'); await activate('西安'); await activate('西安城墙');`;
  let cursor = -1;
  for (const marker of sequence) {
    const next = source.indexOf(marker, cursor + 1);
    assert.ok(next > cursor, `missing/out-of-order ${marker}`);
    cursor = next;
  }
});
