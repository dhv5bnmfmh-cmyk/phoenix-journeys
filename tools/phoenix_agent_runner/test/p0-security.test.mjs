import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { execFileSync } from 'node:child_process';
import { scanText, scanCandidateRepository, sanitizeScanError, SecretScanError } from '../src/secret-scanner.mjs';

function git(repo, ...args) { return execFileSync('git', ['-C', repo, ...args], { encoding: 'utf8' }).trim(); }
function fixture() {
  const repo = mkdtempSync(join(tmpdir(), 'phoenix-p0-'));
  git(repo, 'init', '-q'); git(repo, 'config', 'user.email', 'test@example.invalid'); git(repo, 'config', 'user.name', 'Phoenix Test');
  mkdirSync(join(repo, '.github/workflows'), { recursive: true });
  writeFileSync(join(repo, 'README.md'), 'safe\n');
  writeFileSync(join(repo, '.github/workflows/phoenix-agent-audit.yml'), 'permissions:\n  contents: read\n');
  git(repo, 'add', '.'); git(repo, 'commit', '-qm', 'base');
  return { repo, base: git(repo, 'rev-parse', 'HEAD') };
}
function commit(repo) { git(repo, 'add', '-A'); git(repo, 'commit', '-qm', 'candidate'); return git(repo, 'rev-parse', 'HEAD'); }
function blocked(fn, code = 'SECRET_DETECTED') { assert.throws(fn, error => error instanceof SecretScanError && error.code === code); }

test('secret in allowed source file blocks', () => { const { repo, base } = fixture(); writeFileSync(join(repo, 'README.md'), 'token=ABCDEFGHIJKLMNOPQRSTUVWX\n'); const head = commit(repo); blocked(() => scanCandidateRepository({ repo, baseSha: base, candidateSha: head })); });
test('secret in Workflow blocks', () => { const { repo, base } = fixture(); writeFileSync(join(repo, '.github/workflows/phoenix-agent-audit.yml'), 'api_key: ABCDEFGHIJKLMNOPQRSTUVWX\n'); const head = commit(repo); blocked(() => scanCandidateRepository({ repo, baseSha: base, candidateSha: head })); });
test('secret in renamed file blocks', () => { const { repo, base } = fixture(); writeFileSync(join(repo, 'README.md'), 'secret=ABCDEFGHIJKLMNOPQRSTUVWX\n'); git(repo, 'mv', 'README.md', 'RENAMED.md'); const head = commit(repo); blocked(() => scanCandidateRepository({ repo, baseSha: base, candidateSha: head })); });
test('secret in generated report blocks', () => { const { repo, base } = fixture(); blocked(() => scanCandidateRepository({ repo, baseSha: base, candidateSha: base, generatedReport: 'token=ABCDEFGHIJKLMNOPQRSTUVWX' })); });
test('secret redaction exposes fingerprint only', () => { const value = 'ABCDEFGHIJKLMNOPQRSTUVWX'; const safe = sanitizeScanError(new SecretScanError('SECRET_DETECTED', scanText(`token=${value}`, 'fixture'))); assert.equal(JSON.stringify(safe).includes(value), false); assert.match(safe.findings[0].fingerprint, /^[0-9a-f]{16}$/); });
test('scanner failure blocks', () => blocked(() => scanCandidateRepository({ repo: '/missing', baseSha: 'a', candidateSha: 'b' }), 'SCANNER_EXECUTION_FAILED'));
test('binary input blocks', () => { const { repo, base } = fixture(); writeFileSync(join(repo, 'payload.bin'), Buffer.from([0, 1, 2, 3])); const head = commit(repo); blocked(() => scanCandidateRepository({ repo, baseSha: base, candidateSha: head }), 'UNSCANNABLE_BINARY_BLOCKED'); });
