import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

import { auditTask } from '../src/audit.mjs';
import {
  validateRepositoryConfig,
  validateTrustedSchemaInventory,
} from '../src/validation.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(here, '../../..');
const read = (relative) => JSON.parse(
  fs.readFileSync(path.join(repoRoot, relative), 'utf8'),
);

const registry = read('ai/development/policies/rule_registry.json');
const capabilityPolicy = read('ai/development/policies/capability_policy.json');
const scopePolicy = read('ai/development/policies/scope_policy.json');
const agents = fs.readdirSync(path.join(repoRoot, 'ai/development/agents'))
  .filter((name) => name.endsWith('.agent.json'))
  .map((name) => read(`ai/development/agents/${name}`));

function withSchemaInventory(mutator) {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'phoenix-schema-inventory-'));
  const schemaDir = path.join(root, 'schemas');
  fs.cpSync(path.join(repoRoot, 'ai/development/schemas'), schemaDir, {
    recursive: true,
  });
  try {
    mutator?.(schemaDir);
    return validateTrustedSchemaInventory(schemaDir);
  } finally {
    fs.rmSync(root, { recursive: true, force: true });
  }
}

test('JSON, Agent Manifest, Rule Registry, Schema, and example fixtures validate', () => {
  const { errors, manifests, registry: loadedRegistry, schemas } =
    validateRepositoryConfig(repoRoot);
  assert.deepEqual(errors, []);
  assert.equal(manifests.length, 6);
  assert.ok(loadedRegistry.rules.length >= 15);
  assert.deepEqual(
    Object.keys(schemas).sort(),
    [
      'audit_report.schema.json',
      'evidence_manifest.schema.json',
      'execution_principal.schema.json',
      'finding.schema.json',
      'founder_authorization.schema.json',
      'task_contract.schema.json',
    ],
  );
});

test('mandatory six-schema inventory passes', () => {
  assert.deepEqual(withSchemaInventory().errors, []);
});

test('missing execution principal schema fails', () => {
  const { errors } = withSchemaInventory((schemaDir) => {
    fs.rmSync(path.join(schemaDir, 'execution_principal.schema.json'));
  });
  assert.ok(errors.some((error) =>
    error.includes('Missing mandatory schema: execution_principal.schema.json')));
});

test('missing Founder authorization schema fails', () => {
  const { errors } = withSchemaInventory((schemaDir) => {
    fs.rmSync(path.join(schemaDir, 'founder_authorization.schema.json'));
  });
  assert.ok(errors.some((error) =>
    error.includes('Missing mandatory schema: founder_authorization.schema.json')));
});

test('duplicate schema ID fails', () => {
  const { errors } = withSchemaInventory((schemaDir) => {
    const principal = JSON.parse(fs.readFileSync(
      path.join(schemaDir, 'execution_principal.schema.json'),
      'utf8',
    ));
    const founderPath = path.join(schemaDir, 'founder_authorization.schema.json');
    const founder = JSON.parse(fs.readFileSync(founderPath, 'utf8'));
    founder.$id = principal.$id;
    fs.writeFileSync(founderPath, `${JSON.stringify(founder, null, 2)}\n`);
  });
  assert.ok(errors.some((error) => error.includes('duplicate schema $id')));
});

test('schema replaced by empty object fails inventory validation', () => {
  const { errors } = withSchemaInventory((schemaDir) => {
    fs.writeFileSync(
      path.join(schemaDir, 'finding.schema.json'),
      '{}\n',
    );
  });
  assert.ok(errors.some((error) =>
    error.includes('finding.schema.json: trusted schema compilation failed')));
});

test('unsupported schema keyword fails inventory validation', () => {
  const { errors } = withSchemaInventory((schemaDir) => {
    const schemaPath = path.join(schemaDir, 'finding.schema.json');
    const schema = JSON.parse(fs.readFileSync(schemaPath, 'utf8'));
    schema.phoenixUnsupportedKeyword = true;
    fs.writeFileSync(schemaPath, `${JSON.stringify(schema, null, 2)}\n`);
  });
  assert.ok(errors.some((error) =>
    error.includes('finding.schema.json: trusted schema compilation failed')));
});

test('extra unauthorized schema fails inventory validation', () => {
  const { errors } = withSchemaInventory((schemaDir) => {
    const source = fs.readFileSync(
      path.join(schemaDir, 'finding.schema.json'),
      'utf8',
    );
    fs.writeFileSync(path.join(schemaDir, 'unexpected.schema.json'), source);
  });
  assert.ok(errors.some((error) =>
    error.includes('Unauthorized schema file: unexpected.schema.json')));
});

test('valid_read_only_task fixture passes', () => {
  const task = read('ai/development/examples/valid_read_only_task.json');
  const evidenceManifest = read('ai/development/examples/example_evidence_manifest.json');
  const { report, exitCode } = auditTask({
    task,
    registry,
    evidenceManifest,
    changedPaths: [],
    repoRoot: null,
    agentManifests: agents,
    capabilityPolicy,
    scopePolicy,
  });
  assert.equal(exitCode, 0);
  assert.equal(report.deterministic_result, 'PASS');
});

test('invalid_scope_task fixture fails when supplied a forbidden runtime path', () => {
  const task = read('ai/development/examples/invalid_scope_task.json');
  const evidenceManifest = read('ai/development/examples/example_evidence_manifest.json');
  const { report, exitCode } = auditTask({
    task,
    registry,
    evidenceManifest,
    changedPaths: ['app/lib/main.dart'],
    repoRoot: null,
    agentManifests: agents,
    capabilityPolicy,
    scopePolicy,
  });
  assert.equal(exitCode, 2);
  assert.equal(report.final_agent_decision, 'SCOPE_EXPANSION_REQUIRED');
});

test('GitHub workflow preserves read-only permissions and required triggers', () => {
  const workflow = fs.readFileSync(
    path.join(repoRoot, '.github/workflows/phoenix-agent-audit.yml'),
    'utf8',
  );
  for (const trigger of ['opened','synchronize','reopened','ready_for_review','workflow_dispatch']) {
    assert.ok(workflow.includes(trigger), `missing trigger ${trigger}`);
  }
  assert.match(workflow, /contents:\s*read/u);
  assert.match(workflow, /pull-requests:\s*read/u);
  for (const forbidden of [
    'contents: write',
    'pull-requests: write',
    'issues: write',
    'deployments: write',
    'actions: write',
    'secrets.',
    'wrangler delete',
    'enable_auto_merge',
  ]) {
    assert.ok(!workflow.includes(forbidden), `forbidden workflow content: ${forbidden}`);
  }

  const uploadArtifactRefs = [
    ...workflow.matchAll(/actions\/upload-artifact@([^\s'"}]+)/gu),
  ].map((match) => match[1]);
  assert.ok(uploadArtifactRefs.length > 0, 'actions/upload-artifact must be used');
  for (const ref of uploadArtifactRefs) {
    assert.match(ref, /^[0-9a-f]{40}$/u, `upload-artifact must use a full Commit SHA: ${ref}`);
  }
  assert.ok(uploadArtifactRefs.includes('ea165f8d65b6e75b540449e92b4886f43607fa02'));
  assert.doesNotMatch(
    workflow,
    /actions\/upload-artifact@(v\d+(?:\.\d+)*|main|master)\b/u,
  );

  const bootstrapStart = workflow.indexOf('bootstrap-source-tests:');
  const trustedStart = workflow.indexOf('trusted-audit:');
  assert.ok(bootstrapStart >= 0, 'Bootstrap Source Test job must exist');
  assert.ok(trustedStart > bootstrapStart, 'Trusted Audit must remain a separate job');
  const bootstrap = workflow.slice(bootstrapStart, trustedStart);

  assert.match(
    bootstrap,
    /name:\s*Phoenix Agent Bootstrap Source Tests/u,
  );
  assert.match(
    bootstrap,
    /ref:\s*\$\{\{\s*github\.event\.pull_request\.head\.sha\s*\}\}/u,
  );
  assert.doesNotMatch(
    bootstrap,
    /ref:\s*(main|master|governance\/development-agent-system-phase-a)\s*$/mu,
  );
  assert.match(
    bootstrap,
    /TESTED_SHA="\$\(git rev-parse HEAD\)"/u,
  );
  assert.match(
    bootstrap,
    /\[\[\s*"\$TESTED_SHA"\s*==\s*"\$\{\{\s*github\.event\.pull_request\.head\.sha\s*\}\}"\s*\]\]/u,
  );
  assert.doesNotMatch(bootstrap, /\bgithub\.sha\b/u);
  assert.match(
    bootstrap,
    /exact_candidate_sha=\$\{\{\s*steps\.identity\.outputs\.tested_sha\s*\}\}[\s\S]*?\}\s*>\s*bootstrap-source-test\/result\.txt/u,
  );
  assert.match(
    bootstrap,
    /path:\s*tools\/phoenix_agent_runner\/bootstrap-source-test\//u,
  );
  assert.match(
    bootstrap,
    /Exact Candidate SHA:.*\$\{\{\s*steps\.identity\.outputs\.tested_sha\s*\}\}/u,
  );
  assert.match(bootstrap, /persist-credentials:\s*false/u);
  assert.match(bootstrap, /permissions:\s*\n\s+contents:\s*read/u);
  assert.match(
    bootstrap,
    /authority=NON_AUTHORITATIVE_BOOTSTRAP_SOURCE_TEST/u,
  );
  assert.match(
    workflow.slice(trustedStart),
    /name:\s*Trusted read-only governance audit/u,
  );
  assert.ok(workflow.includes('GITHUB_STEP_SUMMARY'));
});
