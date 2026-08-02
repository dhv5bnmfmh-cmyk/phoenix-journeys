import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { existsSync, readFileSync, statSync } from 'node:fs';
import test from 'node:test';

const root = new URL('../', import.meta.url);
const registerPath = new URL('../design/ASSET_REGISTER.csv', import.meta.url);

function parseCsv(text) {
  const rows = [];
  let row = [];
  let field = '';
  let quoted = false;
  for (let index = 0; index < text.length; index += 1) {
    const char = text[index];
    if (quoted) {
      if (char === '"' && text[index + 1] === '"') {
        field += '"';
        index += 1;
      } else if (char === '"') {
        quoted = false;
      } else {
        field += char;
      }
    } else if (char === '"') {
      quoted = true;
    } else if (char === ',') {
      row.push(field);
      field = '';
    } else if (char === '\n') {
      row.push(field);
      rows.push(row);
      row = [];
      field = '';
    } else if (char !== '\r') {
      field += char;
    }
  }
  if (field || row.length) {
    row.push(field);
    rows.push(row);
  }
  return rows;
}

function readRegister() {
  const [headers, ...values] = parseCsv(readFileSync(registerPath, 'utf8'));
  return values.map((row) => Object.fromEntries(headers.map((header, index) => [header, row[index]])));
}

test('asset register covers every current visual file with reproducible hashes', () => {
  const rows = readRegister();
  const visualRows = rows.filter((row) => row['File Format'] !== 'PLACEHOLDER');
  const activeRows = visualRows.filter((row) => row['Rights Status'] !== 'RETIRED_REPLACED');
  const tracked = execFileSync('git', ['ls-files'], {
    cwd: root,
    encoding: 'utf8',
  })
    .trim()
    .split('\n')
    .filter((path) => /\.(?:webp|svg)$/i.test(path))
    .filter((path) => !path.startsWith('design/sources/'))
    .filter((path) => existsSync(new URL(`../${path}`, import.meta.url)))
    .sort();

  assert.equal(visualRows.length, 496);
  assert.equal(activeRows.length, 397);
  assert.deepEqual(
    activeRows.map((row) => row['Repository Path']).sort(),
    tracked,
  );
  assert.equal(new Set(visualRows.map((row) => row['Asset ID'])).size, 496);
  assert.equal(new Set(visualRows.map((row) => row['Repository Path'])).size, 496);

  for (const row of activeRows) {
    const path = new URL(`../${row['Repository Path']}`, import.meta.url);
    const content = readFileSync(path);
    assert.equal(Number(row['File Size']), statSync(path).size, row['Repository Path']);
    assert.equal(
      row['SHA-256'],
      createHash('sha256').update(content).digest('hex'),
      row['Repository Path'],
    );
    assert.equal(
      row['Git Blob SHA'],
      execFileSync('git', ['hash-object', row['Repository Path']], {
        cwd: root,
        encoding: 'utf8',
      }).trim(),
      row['Repository Path'],
    );
    assert.ok(Number(row['Pixel Width']) > 0, row['Repository Path']);
    assert.ok(Number(row['Pixel Height']) > 0, row['Repository Path']);
  }
});

test('rights states preserve evidence gaps without granting preview eligibility', () => {
  const visualRows = readRegister().filter((row) => row['File Format'] !== 'PLACEHOLDER');
  const allowed = new Set([
    'EVIDENCE_COMPLETE',
    'EVIDENCE_PARTIAL',
    'EVIDENCE_MISSING',
    'PROGRAMMATIC_ORIGINAL',
    'OPEN_LICENSE_VERIFIED',
    'PUBLIC_DOMAIN_VERIFIED',
    'BLOCKED_PENDING_EVIDENCE',
    'BLOCKED_REPLACEMENT_REQUIRED',
    'RETIRED_REPLACED',
  ]);

  assert.equal(visualRows.filter((row) => row['Rights Status'] === 'EVIDENCE_PARTIAL').length, 291);
  assert.equal(visualRows.filter((row) => row['Rights Status'] === 'EVIDENCE_MISSING').length, 7);
  assert.equal(visualRows.filter((row) => row['Rights Status'] === 'EVIDENCE_COMPLETE').length, 99);
  assert.equal(visualRows.filter((row) => row['Rights Status'] === 'RETIRED_REPLACED').length, 99);
  assert.equal(visualRows.filter((row) => row['Existing Registry Entry'] === 'YES').length, 70);
  for (const row of visualRows) {
    assert.ok(allowed.has(row['Rights Status']), row['Repository Path']);
    if (row['Rights Status'] === 'EVIDENCE_COMPLETE') {
      assert.equal(row['Preview Eligibility'], 'YES_ASSET_ONLY_LIBRARY_BLOCKED', row['Repository Path']);
      assert.equal(row['Release Eligibility'], 'YES_ASSET_ONLY_LIBRARY_BLOCKED', row['Repository Path']);
      assert.equal(row['Missing Evidence'], 'NOT_APPLICABLE', row['Repository Path']);
      assert.ok(
        ['ALL_14_GATES_PASSED_REMOTE_CI_SUCCESS', 'LOCAL_14_GATES_PASSED_REMOTE_CI_PENDING'].includes(row['Gate Result']),
        row['Repository Path'],
      );
      assert.notEqual(row['Source File'], 'UNKNOWN', row['Repository Path']);
      assert.notEqual(row['Editable Master'], 'UNKNOWN', row['Repository Path']);
      assert.ok(existsSync(new URL(`../${row['Editable Master']}`, import.meta.url)), row['Repository Path']);
    } else if (row['Rights Status'] === 'RETIRED_REPLACED') {
      assert.equal(row['Preview Eligibility'], 'NO_RETIRED', row['Repository Path']);
      assert.equal(row['Release Eligibility'], 'NO_RETIRED', row['Repository Path']);
    } else {
      assert.equal(row['Preview Eligibility'], 'NO', row['Repository Path']);
      assert.equal(row['Release Eligibility'], 'NO', row['Repository Path']);
      assert.notEqual(row['Missing Evidence'], '', row['Repository Path']);
      assert.match(row.Notes, /Repository provenance does not establish legal rights/);
    }
  }
});

test('the corrupt legacy lantern is removed and exact variants are recorded', () => {
  const rows = readRegister();
  assert.equal(
    existsSync(new URL('../app/assets/images/special-realms/upstream-lantern-v2.webp', import.meta.url)),
    false,
  );
  assert.equal(
    rows.some((row) => row['Repository Path'].endsWith('upstream-lantern-v2.webp')),
    false,
  );
  assert.equal(rows.filter((row) => row['Variant Relationship'] === 'EXACT_DUPLICATE').length, 3);
  assert.equal(
    rows.filter((row) => row.Unused === 'YES' && row['File Format'] !== 'PLACEHOLDER' && row['Rights Status'] !== 'RETIRED_REPLACED').length,
    28,
  );
});
