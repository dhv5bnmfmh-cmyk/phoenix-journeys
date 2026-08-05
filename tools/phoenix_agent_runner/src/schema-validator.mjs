import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { extname } from 'node:path';

const SECRET_PATTERNS = [
  ['GITHUB_TOKEN', /gh[opsu]_[A-Za-z0-9_]{20,}/g],
  ['AWS_ACCESS_KEY', /AKIA[0-9A-Z]{16}/g],
  ['PRIVATE_KEY', /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/g],
  ['GENERIC_API_KEY', /\b(?:api[_-]?key|secret|token)\s*[:=]\s*["']?([A-Za-z0-9_\-]{16,})/gi],
];

const TEXT_EXTENSIONS = new Set([
  '', '.md', '.txt', '.json', '.jsonl', '.yml', '.yaml', '.js', '.mjs', '.cjs',
  '.ts', '.tsx', '.jsx', '.dart', '.py', '.sh', '.bash', '.toml', '.ini', '.cfg',
  '.xml', '.html', '.css', '.scss', '.sql', '.graphql', '.lock',
]);

export function fingerprint(value) {
  return createHash('sha256').update(value).digest('hex').slice(0, 16);
}

export function scanText(text, source = 'unknown') {
  const findings = [];
  for (const [type, pattern] of SECRET_PATTERNS) {
    pattern.lastIndex = 0;
    for (const match of text.matchAll(pattern)) {
      const value = match[1] || match[0];
      findings.push({ type, fingerprint: fingerprint(value), source });
    }
  }
  return findings;
}

export function assertSafeText(text, source = 'unknown') {
  const findings = scanText(text, source);
  if (findings.length) throw new SecretScanError('SECRET_DETECTED', findings);
}

export class SecretScanError extends Error {
  constructor(code, findings = []) {
    super(code);
    this.name = 'SecretScanError';
    this.code = code;
    this.findings = findings;
  }
}

export function parseNameStatusZ(buffer) {
  const parts = buffer.toString('utf8').split('\0');
  if (parts.at(-1) === '') parts.pop();
  const records = [];
  for (let i = 0; i < parts.length;) {
    const status = parts[i++];
    if (!status) throw new SecretScanError('NAME_STATUS_PARSE_FAILED');
    const kind = status[0];
    if (kind === 'R' || kind === 'C') {
      if (i + 1 >= parts.length) throw new SecretScanError('NAME_STATUS_PARSE_FAILED');
      records.push({ status, kind, source: parts[i++], destination: parts[i++] });
    } else {
      if (i >= parts.length) throw new SecretScanError('NAME_STATUS_PARSE_FAILED');
      records.push({ status, kind, path: parts[i++] });
    }
  }
  return records;
}

function runGit(repo, args, encoding = null) {
  try {
    return execFileSync('git', ['-C', repo, ...args], {
      encoding,
      stdio: ['ignore', 'pipe', 'pipe'],
      maxBuffer: 64 * 1024 * 1024,
    });
  } catch {
    throw new SecretScanError('SCANNER_EXECUTION_FAILED');
  }
}

function blob(repo, ref, path) {
  return runGit(repo, ['show', `${ref}:${path}`]);
}

function isBinary(buffer, path) {
  if (buffer.includes(0)) return true;
  if (!TEXT_EXTENSIONS.has(extname(path).toLowerCase())) {
    const sample = buffer.subarray(0, Math.min(buffer.length, 8192));
    let controls = 0;
    for (const byte of sample) if (byte < 9 || (byte > 13 && byte < 32)) controls++;
    if (sample.length && controls / sample.length > 0.01) return true;
  }
  return false;
}

export function scanCandidateRepository({
  repo,
  baseSha,
  candidateSha,
  governanceBody = '',
  taskContract = '',
  evidenceManifest = '',
  generatedReport = '',
  stepSummary = '',
  artifactMetadata = '',
  binaryAllowlist = [],
}) {
  const raw = runGit(repo, ['diff', '--name-status', '-z', '-M', '-C', baseSha, candidateSha]);
  const records = parseNameStatusZ(raw);
  const findings = [];
  const scanned = [];
  const historical = [];
  const allow = new Set(binaryAllowlist);

  for (const record of records) {
    const currentPath = record.destination || record.path;
    const sourcePath = record.source;
    if (sourcePath) scanned.push({ path: sourcePath, role: 'rename_or_copy_source' });
    if (record.kind === 'D') {
      historical.push({ path: record.path, status: 'DELETED_HISTORICAL_EXPOSURE_REVIEW' });
      continue;
    }
    const content = blob(repo, candidateSha, currentPath);
    if (isBinary(content, currentPath)) {
      if (!allow.has(currentPath)) {
        throw new SecretScanError('UNSCANNABLE_BINARY_BLOCKED', [{ source: currentPath }]);
      }
      scanned.push({ path: currentPath, role: 'binary_allowlisted' });
      continue;
    }
    findings.push(...scanText(content.toString('utf8'), currentPath));
    scanned.push({ path: currentPath, role: 'current_blob' });
  }

  const additions = runGit(repo, ['diff', '--unified=0', '--no-ext-diff', baseSha, candidateSha], 'utf8')
    .split('\n').filter(line => line.startsWith('+') && !line.startsWith('+++')).join('\n');
  findings.push(...scanText(additions, 'git_diff_additions'));
  for (const [source, text] of Object.entries({
    governanceBody, taskContract, evidenceManifest, generatedReport, stepSummary, artifactMetadata,
  })) findings.push(...scanText(String(text), source));

  if (findings.length) throw new SecretScanError('SECRET_DETECTED', findings);
  return { result: 'PASS', records, scanned, historical };
}

export function sanitizeScanError(error) {
  if (!(error instanceof SecretScanError)) return { code: 'SCANNER_EXECUTION_FAILED', findings: [] };
  return {
    code: error.code,
    findings: error.findings.map(({ type = 'UNKNOWN', fingerprint: fp = 'unavailable', source = 'unknown' }) => ({
      type,
      fingerprint: fp,
      source,
    })),
  };
}
