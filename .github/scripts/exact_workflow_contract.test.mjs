import test from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import {
  PRODUCER_BENCHMARK_SECONDS,
  assertConsumerBudget,
  classifyExactRuns,
  requiredArtifactNames,
  validateExactArtifacts,
  validateFlutterProducerTopology,
  validateHealthIdentity,
} from './exact_workflow_contract.mjs';

const sha = 'f'.repeat(40);
const run = (overrides = {}) => ({
  id: 7,
  name: 'Flutter CI',
  head_sha: sha,
  status: 'completed',
  conclusion: 'success',
  created_at: '2026-08-26T00:00:00Z',
  updated_at: '2026-08-26T00:20:00Z',
  ...overrides,
});

test('producer SUCCESS fixture resolves exact successful run', () => {
  assert.equal(classifyExactRuns([run()], 'Flutter CI', sha).state, 'SUCCESS');
});

test('producer FAILURE fixture short-circuits consumers', () => {
  const result = classifyExactRuns([run({ conclusion: 'failure' })], 'Flutter CI', sha);
  assert.equal(result.state, 'FAILURE');
});

test('producer IN_PROGRESS fixture remains producer-aware', () => {
  const result = classifyExactRuns([run({ status: 'in_progress', conclusion: null })], 'Flutter CI', sha);
  assert.equal(result.state, 'IN_PROGRESS');
});

test('wrong SHA cannot satisfy exact producer', () => {
  const result = classifyExactRuns([run({ head_sha: 'a'.repeat(40) })], 'Flutter CI', sha);
  assert.equal(result.state, 'MISSING');
});

test('consumer wait budget covers measured 19m44s producer with margin', () => {
  assert.equal(PRODUCER_BENCHMARK_SECONDS, 1184);
  assert.equal(assertConsumerBudget(45 * 60), true);
  assert.throws(() => assertConsumerBudget(15 * 60), /does not cover producer contract/);
});

test('exact artifact names are SHA-bound', () => {
  assert.deepEqual(requiredArtifactNames(sha), [
    `phoenix-web-${sha}`,
    `phoenix-journey-quality-${sha}`,
  ]);
});

test('missing artifact is rejected', () => {
  assert.throws(
    () => validateExactArtifacts([{ name: `phoenix-web-${sha}`, expired: false }], sha),
    /missing exact artifact/,
  );
});

test('wrong-SHA artifact is rejected', () => {
  assert.throws(
    () => validateExactArtifacts([
      { name: `phoenix-web-${sha}`, expired: false },
      { name: `phoenix-journey-quality-${sha}`, expired: false },
      { name: `phoenix-web-${'a'.repeat(40)}`, expired: false },
    ], sha),
    /wrong-SHA producer artifact/,
  );
});

test('preview health requires exact release identity', () => {
  assert.equal(validateHealthIdentity({ ok: true, ai: true, service: 'phoenix-journeys', release: sha }, sha), true);
  assert.throws(
    () => validateHealthIdentity({ ok: true, ai: true, service: 'phoenix-journeys', release: 'a'.repeat(40) }, sha),
    /identity mismatch/,
  );
});

const splitTopologyFixture = `jobs:\n  produce:\n    outputs:\n      agents_outcome: \${{ steps.agents.outcome }}\n      analyze_outcome: \${{ steps.analyze.outcome }}\n      test_outcome: \${{ steps.test.outcome }}\n      quality_outcome: \${{ steps.quality.outcome }}\n      quality_contract_outcome: \${{ steps.quality_contract.outcome }}\n      build_outcome: \${{ steps.build.outcome }}\n      worker_outcome: \${{ steps.worker.outcome }}\n    steps:\n      - name: Full Flutter Test\n      - name: Dedicated isolated Journey quality report\n      - name: Upload exact Journey quality artifact\n      - name: Build web release\n      - name: Validate Cloudflare Worker bundle\n      - name: Upload exact tested web artifact\n  producer-verdict:\n    needs: produce\n    if: always()\n    runs-on: ubuntu-latest\n    timeout-minutes: 5\n    steps:\n      - name: Enforce verification results\n        run: |\n          echo \"\${{ needs.produce.outputs.agents_outcome }}\"\n          echo \"\${{ needs.produce.outputs.analyze_outcome }}\"\n          echo \"\${{ needs.produce.outputs.test_outcome }}\"\n          echo \"\${{ needs.produce.outputs.quality_outcome }}\"\n          echo \"\${{ needs.produce.outputs.quality_contract_outcome }}\"\n          echo \"\${{ needs.produce.outputs.build_outcome }}\"\n          echo \"\${{ needs.produce.outputs.worker_outcome }}\"\n`;

test('split heavy producer and cheap verdict topology is accepted', () => {
  assert.equal(validateFlutterProducerTopology(splitTopologyFixture), true);
});

test('same-job enforcement topology is rejected', () => {
  const oldTopology = splitTopologyFixture
    .replace('      - name: Upload exact tested web artifact\n', '      - name: Upload exact tested web artifact\n      - name: Enforce verification results\n')
    .replace('      - name: Enforce verification results\n        run:', '      - name: Final verdict placeholder\n        run:');
  assert.throws(() => validateFlutterProducerTopology(oldTopology), /final enforcement|missing topology marker/);
});

test('checked-in Flutter CI keeps producer and verdict as separate retry units', async () => {
  const workflow = await readFile(new URL('../workflows/flutter-ci.yml', import.meta.url), 'utf8');
  assert.equal(validateFlutterProducerTopology(workflow), true);
});
