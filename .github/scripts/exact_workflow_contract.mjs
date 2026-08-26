import { appendFile } from 'node:fs/promises';
import { pathToFileURL } from 'node:url';

export const PRODUCER_BENCHMARK_SECONDS = 19 * 60 + 44;
export const DEFAULT_WAIT_SECONDS = 45 * 60;
const terminalFailures = new Set([
  'failure',
  'cancelled',
  'timed_out',
  'action_required',
  'stale',
  'startup_failure',
]);
const activeStatuses = new Set(['queued', 'in_progress', 'requested', 'waiting', 'pending']);

function workflowJobBlock(source, jobName) {
  const lines = String(source ?? '').replace(/\r\n/g, '\n').split('\n');
  const start = lines.findIndex((line) => line === `  ${jobName}:`);
  if (start < 0) throw new Error(`Flutter CI topology missing job: ${jobName}`);
  let end = lines.length;
  for (let index = start + 1; index < lines.length; index += 1) {
    if (/^  [A-Za-z0-9_-]+:\s*$/.test(lines[index])) {
      end = index;
      break;
    }
  }
  return lines.slice(start, end).join('\n');
}

function requireWorkflowMarkers(block, markers, label) {
  for (const marker of markers) {
    if (!block.includes(marker)) throw new Error(`${label} missing topology marker: ${marker}`);
  }
}

export function validateFlutterProducerTopology(source) {
  const produce = workflowJobBlock(source, 'produce');
  const verdict = workflowJobBlock(source, 'producer-verdict');
  const outcomes = ['agents', 'analyze', 'test', 'quality', 'quality_contract', 'build', 'worker'];

  requireWorkflowMarkers(produce, [
    '- name: Full Flutter Test',
    '- name: Dedicated isolated Journey quality report',
    '- name: Upload exact Journey quality artifact',
    '- name: Build web release',
    '- name: Validate Cloudflare Worker bundle',
    '- name: Upload exact tested web artifact',
    'outputs:',
  ], 'Flutter heavy producer');
  for (const outcome of outcomes) {
    const outputName = `${outcome}_outcome`;
    requireWorkflowMarkers(
      produce,
      [`${outputName}: \${{ steps.${outcome}.outcome }}`],
      'Flutter heavy producer outputs',
    );
    requireWorkflowMarkers(
      verdict,
      [`\${{ needs.produce.outputs.${outputName} }}`],
      'Flutter producer verdict inputs',
    );
  }
  if (produce.includes('- name: Enforce verification results')) {
    throw new Error('Flutter heavy producer must not own final enforcement verdict');
  }

  requireWorkflowMarkers(verdict, [
    'needs: produce',
    'if: always()',
    'timeout-minutes: 5',
    '- name: Enforce verification results',
  ], 'Flutter producer verdict');
  for (const forbidden of ['flutter test', 'flutter build web', 'wrangler@4', 'actions/upload-artifact']) {
    if (verdict.includes(forbidden)) {
      throw new Error(`Flutter producer verdict must remain a cheap retry unit: ${forbidden}`);
    }
  }
  return true;
}

export function classifyExactRuns(runs, workflowName, candidateSha) {
  const exact = runs
    .filter((run) => run?.name === workflowName && run?.head_sha === candidateSha)
    .sort((a, b) => {
      const aTime = Date.parse(a.updated_at || a.created_at || 0) || 0;
      const bTime = Date.parse(b.updated_at || b.created_at || 0) || 0;
      if (aTime !== bTime) return bTime - aTime;
      return Number(b.run_attempt || 0) - Number(a.run_attempt || 0);
    });

  const success = exact.find((run) => run.status === 'completed' && run.conclusion === 'success');
  if (success) return { state: 'SUCCESS', run: success };

  const active = exact.find((run) => activeStatuses.has(run.status));
  if (active) return { state: 'IN_PROGRESS', run: active };

  const failure = exact.find(
    (run) => run.status === 'completed' && terminalFailures.has(run.conclusion),
  );
  if (failure) return { state: 'FAILURE', run: failure };

  const completedOther = exact.find((run) => run.status === 'completed');
  if (completedOther) return { state: 'FAILURE', run: completedOther };
  return { state: 'MISSING', run: null };
}

export function assertConsumerBudget(waitSeconds, producerBenchmarkSeconds = PRODUCER_BENCHMARK_SECONDS) {
  if (!Number.isFinite(waitSeconds) || waitSeconds < producerBenchmarkSeconds + 5 * 60) {
    throw new Error(
      `consumer wait budget ${waitSeconds}s does not cover producer contract ` +
        `${producerBenchmarkSeconds}s plus 300s orchestration margin`,
    );
  }
  return true;
}

export function requiredArtifactNames(candidateSha) {
  return [`phoenix-web-${candidateSha}`, `phoenix-journey-quality-${candidateSha}`];
}

export function validateExactArtifacts(artifacts, candidateSha) {
  const required = requiredArtifactNames(candidateSha);
  const names = new Set((artifacts || []).filter((a) => !a.expired).map((a) => a.name));
  for (const name of required) {
    if (!names.has(name)) throw new Error(`missing exact artifact: ${name}`);
  }
  for (const artifact of artifacts || []) {
    if (artifact.expired) continue;
    if ((artifact.name.startsWith('phoenix-web-') || artifact.name.startsWith('phoenix-journey-quality-')) &&
        !required.includes(artifact.name)) {
      throw new Error(`wrong-SHA producer artifact present: ${artifact.name}`);
    }
  }
  return required;
}

export function validateHealthIdentity(health, candidateSha) {
  if (!health || health.ok !== true || health.ai !== true || health.service !== 'phoenix-journeys' || health.release !== candidateSha) {
    throw new Error(`preview health identity mismatch for ${candidateSha}`);
  }
  return true;
}

function headers(token) {
  return {
    Accept: 'application/vnd.github+json',
    Authorization: `Bearer ${token}`,
    'X-GitHub-Api-Version': '2022-11-28',
  };
}

async function githubJson(url, token) {
  const response = await fetch(url, { headers: headers(token) });
  if (!response.ok) {
    throw new Error(`GitHub API ${response.status} for ${url}: ${await response.text()}`);
  }
  return response.json();
}

export async function awaitExactWorkflow({
  repository,
  workflowName,
  candidateSha,
  waitSeconds = DEFAULT_WAIT_SECONDS,
  pollSeconds = 10,
  token,
  apiUrl = 'https://api.github.com',
  log = console.log,
}) {
  assertConsumerBudget(waitSeconds);
  if (!token) throw new Error('GITHUB_TOKEN is required for exact workflow resolution');
  const deadline = Date.now() + waitSeconds * 1000;
  let lastState = null;

  while (Date.now() <= deadline) {
    const url = `${apiUrl}/repos/${repository}/actions/runs?head_sha=${encodeURIComponent(candidateSha)}&event=pull_request&per_page=100`;
    const payload = await githubJson(url, token);
    const classified = classifyExactRuns(payload.workflow_runs || [], workflowName, candidateSha);
    if (classified.state !== lastState) {
      log(`EXACT WORKFLOW ${workflowName} ${candidateSha} = ${classified.state}`);
      lastState = classified.state;
    }
    if (classified.state === 'SUCCESS') return classified.run;
    if (classified.state === 'FAILURE') {
      throw new Error(
        `${workflowName === 'Cloudflare PR Preview' ? 'PREVIEW PRODUCER FAILED' : 'EXACT PRODUCER FAILED'} | ` +
          `${workflowName} run=${classified.run?.id ?? 'unknown'} conclusion=${classified.run?.conclusion ?? 'unknown'} sha=${candidateSha}`,
      );
    }
    await new Promise((resolve) => setTimeout(resolve, pollSeconds * 1000));
  }
  throw new Error(`exact workflow wait budget exhausted: ${workflowName} sha=${candidateSha} budget=${waitSeconds}s`);
}

export async function verifyRunArtifacts({ repository, runId, candidateSha, token, apiUrl = 'https://api.github.com' }) {
  const run = await githubJson(`${apiUrl}/repos/${repository}/actions/runs/${runId}`, token);
  if (run.head_sha !== candidateSha || run.status !== 'completed' || run.conclusion !== 'success') {
    throw new Error(
      `producer run identity mismatch: run=${runId} head=${run.head_sha} status=${run.status} conclusion=${run.conclusion}`,
    );
  }
  const payload = await githubJson(`${apiUrl}/repos/${repository}/actions/runs/${runId}/artifacts?per_page=100`, token);
  validateExactArtifacts(payload.artifacts || [], candidateSha);
  return run;
}

async function writeOutput(name, value) {
  if (!process.env.GITHUB_OUTPUT) return;
  await appendFile(process.env.GITHUB_OUTPUT, `${name}=${value}\n`, 'utf8');
}

async function cli() {
  const [mode, workflowName, candidateSha, waitArg] = process.argv.slice(2);
  const repository = process.env.GITHUB_REPOSITORY;
  const token = process.env.GITHUB_TOKEN;
  if (!mode || !workflowName || !candidateSha || !repository) {
    throw new Error('usage: exact_workflow_contract.mjs <await|verify-artifacts> <workflow-name> <sha> [wait-seconds]');
  }

  if (mode === 'await') {
    const waitSeconds = waitArg ? Number(waitArg) : DEFAULT_WAIT_SECONDS;
    const run = await awaitExactWorkflow({ repository, workflowName, candidateSha, waitSeconds, token });
    if (workflowName === 'Flutter CI') {
      await verifyRunArtifacts({ repository, runId: run.id, candidateSha, token });
    }
    await writeOutput('run_id', run.id);
    await writeOutput('producer_sha', run.head_sha);
    console.log(`EXACT PRODUCER SUCCESS | workflow=${workflowName} run=${run.id} sha=${candidateSha}`);
    return;
  }

  if (mode === 'verify-artifacts') {
    const runId = Number(waitArg);
    if (!Number.isInteger(runId) || runId <= 0) throw new Error('verify-artifacts requires run-id as fourth argument');
    await verifyRunArtifacts({ repository, runId, candidateSha, token });
    console.log(`EXACT ARTIFACT CONTRACT = PASS | run=${runId} sha=${candidateSha}`);
    return;
  }

  throw new Error(`unknown mode: ${mode}`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  cli().catch((error) => {
    console.error(error?.stack || String(error));
    process.exitCode = 1;
  });
}
