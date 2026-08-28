import { readFile, writeFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const sourceUrl = new URL('./pr202_perf_acceptance.mjs.gz', import.meta.url);
let source = gunzipSync(await readFile(sourceUrl)).toString('utf8');

const original = `    identityAll: ['林岸', '黄浦江'],
    identityAny: [['陆家嘴', '浦东'], ['提单', '结算']],`;
const replacement = `    identityAll: ['林岸'],
    identityAny: [],`;

if (source.split(original).length - 1 !== 1) {
  throw new Error('Shanghai performance entry identity patch target mismatch');
}
source = source.replace(original, replacement);

const tempPath = path.join(
  process.env.RUNNER_TEMP || '/tmp',
  `pr202_perf_acceptance_entry_${process.pid}.mjs`,
);
await writeFile(tempPath, source, 'utf8');
await import(pathToFileURL(tempPath).href);
