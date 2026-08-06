import test from 'node:test';
import assert from 'node:assert/strict';
import {
  classifyAuthorityChanges, assertCandidateNotExecuted, buildTrustedIdentity,
} from '../src/trusted-audit.mjs';

test('Candidate Runner unconditional PASS is audited data, never authority', () => {
  const changes = classifyAuthorityChanges(['tools/phoenix_agent_runner/src/audit.mjs']);
  assert.equal(changes[0].authority, 'CANDIDATE_UNTRUSTED_CHANGE');
  assert.equal(changes[0].execution_effect, 'NONE_FOR_CURRENT_AUDIT');
});

test('Candidate critical test deletion cannot change trusted authority', () => {
  const changes = classifyAuthorityChanges(['tools/phoenix_agent_runner/test/critical.test.mjs']);
  assert.equal(changes[0].execution_effect, 'NONE_FOR_CURRENT_AUDIT');
});

test('Candidate Rule Registry modification remains untrusted', () => {
  const changes = classifyAuthorityChanges(['ai/development/policies/rule_registry.json']);
  assert.equal(changes[0].authority, 'CANDIDATE_UNTRUSTED_CHANGE');
});

test('Candidate commands are rejected', () => {
  assert.doesNotThrow(() => assertCandidateNotExecuted('git diff candidate/'));
  assert.throws(() => assertCandidateNotExecuted('node candidate/tools/phoenix_agent_runner/src/cli.mjs'));
});

test('trusted identity binds source and candidate commits', () => {
  const identity = buildTrustedIdentity({
    trustedRunnerSha: 'a'.repeat(40), trustedRunnerTree: 'b'.repeat(40),
    trustedWorkflowPath: '.github/workflows/phoenix-agent-audit.yml',
    trustedRuleInventoryDigest: 'c'.repeat(64), trustedSchemaDigest: 'd'.repeat(64),
    candidateSha: 'e'.repeat(40), candidateTree: 'f'.repeat(40), baseSha: '1'.repeat(40),
    prNumber: 148, runId: '7', runAttempt: 1, eventType: 'pull_request_target',
  });
  assert.equal(identity.candidate_execution, 'PROHIBITED');
  assert.equal(identity.bootstrap_status, 'TRUSTED_SOURCE_IMPLEMENTED_OPERATIONAL_ACTIVATION_PENDING_MERGE');
});
