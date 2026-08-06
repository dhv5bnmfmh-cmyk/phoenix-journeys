import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

export const SHA_RE = /^[0-9a-f]{40}$/;

export function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

export function writeJson(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`, 'utf8');
}

export function parseArgs(argv) {
  const [command = 'audit', ...rest] = argv;
  const args = { _: [], command };
  for (let index = 0; index < rest.length; index += 1) {
    const value = rest[index];
    if (!value.startsWith('--')) {
      args._.push(value);
      continue;
    }
    const key = value.slice(2);
    const next = rest[index + 1];
    if (next === undefined || next.startsWith('--')) {
      args[key] = true;
    } else {
      args[key] = next;
      index += 1;
    }
  }
  return args;
}

export function globToRegExp(glob) {
  let source = '^';
  for (let index = 0; index < glob.length; index += 1) {
    const char = glob[index];
    if (char === '*' && glob[index + 1] === '*') {
      source += '.*';
      index += 1;
    } else if (char === '*') {
      source += '[^/]*';
    } else if ('\\.^$+?()[]{}|'.includes(char)) {
      source += `\\${char}`;
    } else {
      source += char;
    }
  }
  source += '$';
  return new RegExp(source);
}

export function matchesAny(filePath, patterns = []) {
  return patterns.some((pattern) => globToRegExp(pattern).test(filePath));
}

export function normalizePaths(paths) {
  return [...new Set(paths.map((entry) => entry.trim()).filter(Boolean))].sort();
}

export function readChangedPathsFile(filePath) {
  if (!filePath) return null;
  return normalizePaths(fs.readFileSync(filePath, 'utf8').split(/\r?\n/u));
}

export function gitOutput(repoRoot, args) {
  const result = spawnSync('git', args, {
    cwd: repoRoot,
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe'],
  });
  if (result.status !== 0) {
    return {
      ok: false,
      stdout: result.stdout.trim(),
      stderr: result.stderr.trim(),
      status: result.status,
    };
  }
  return {
    ok: true,
    stdout: result.stdout.trim(),
    stderr: result.stderr.trim(),
    status: result.status,
  };
}

export function obtainChangedPaths({ repoRoot, baseSha, headSha, changedPathsFile }) {
  const fromFile = readChangedPathsFile(changedPathsFile);
  if (fromFile !== null) return { paths: fromFile, limitation: null };
  if (!repoRoot) {
    return {
      paths: [],
      limitation: 'Changed paths were not supplied and no repository root was available.',
    };
  }
  const diff = gitOutput(repoRoot, ['diff', '--name-only', `${baseSha}...${headSha}`]);
  if (!diff.ok) {
    return {
      paths: [],
      limitation: `Unable to obtain changed paths with git: ${diff.stderr || 'unknown error'}`,
    };
  }
  return { paths: normalizePaths(diff.stdout.split(/\r?\n/u)), limitation: null };
}

const SECRET_PATTERNS = [
  { name: 'OpenAI-style API key', regex: /\bsk-(?:proj-)?[A-Za-z0-9_-]{16,}\b/u },
  { name: 'Private key material', regex: /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/u },
  { name: 'Cloudflare API token assignment', regex: /\bCLOUDFLARE_API_TOKEN\s*[:=]\s*[^\s${][^\s]*/u },
  { name: 'OpenAI API key assignment', regex: /\bOPENAI_API_KEY\s*[:=]\s*[^\s${][^\s]*/u },
  { name: 'GitHub token assignment', regex: /\bGITHUB_TOKEN\s*[:=]\s*(?:gh[pousr]_[A-Za-z0-9_]{20,}|[A-Za-z0-9_]{32,})/u },
];

export function scanSecrets(value) {
  const serialized = typeof value === 'string' ? value : JSON.stringify(value);
  return SECRET_PATTERNS
    .filter(({ regex }) => regex.test(serialized))
    .map(({ name }) => name);
}

export function extractTaskContractFromEvent(event) {
  if (event?.pull_request?.body) {
    const body = event.pull_request.body;
    const match = body.match(
      /<!-- PHOENIX_TASK_CONTRACT_JSON_START -->\s*```json\s*([\s\S]*?)\s*```\s*<!-- PHOENIX_TASK_CONTRACT_JSON_END -->/u,
    );
    if (!match) {
      throw new Error('PR body does not contain a PHOENIX Task Contract JSON block.');
    }
    return JSON.parse(match[1]);
  }
  const configuredPath = event?.inputs?.task_contract_path;
  if (configuredPath) return { taskContractPath: configuredPath };
  throw new Error('No pull request Task Contract or workflow_dispatch task_contract_path was supplied.');
}

export function nowIso() {
  return new Date().toISOString();
}
