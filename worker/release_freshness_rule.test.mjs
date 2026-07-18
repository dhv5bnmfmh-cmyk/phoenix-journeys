import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const index = readFileSync('app/web/index.html', 'utf8');
const bootstrap = readFileSync('app/web/flutter_bootstrap.js', 'utf8');
const headers = readFileSync('app/web/_headers', 'utf8');
const worker = readFileSync('worker/index.mjs', 'utf8');
const deploy = readFileSync('.github/workflows/deploy-cloudflare.yml', 'utf8');

test('every Flutter bootstrap URL carries a generated release version', () => {
  assert.match(
    index,
    /flutter_bootstrap\.js\?v=\{\{flutter_service_worker_version\}\}/,
  );
});

test('legacy Flutter service workers and caches are retired safely', () => {
  assert.match(bootstrap, /navigator\.serviceWorker\.getRegistrations\(\)/);
  assert.match(bootstrap, /flutter_service_worker\.js/);
  assert.match(bootstrap, /registration\.unregister\(\)/);
  assert.match(bootstrap, /window\.caches\.delete\(name\)/);
  assert.match(bootstrap, /window\.location\.reload\(\)/);
  assert.match(bootstrap, /phoenix-legacy-flutter-worker-reset/);
});

test('Phoenix app-shell files are never served stale', () => {
  for (const path of [
    '/',
    '/index.html',
    '/flutter_bootstrap.js',
    '/main.dart.js',
    '/flutter_service_worker.js',
  ]) {
    assert.match(headers, new RegExp(`(^|\\n)${path.replaceAll('/', '\\/')}\\n`));
  }
  assert.match(
    headers,
    /Cache-Control: no-store, no-cache, must-revalidate, max-age=0/,
  );
});

test('production health proves the exact commit is live', () => {
  assert.match(worker, /release: env\?\.PHOENIX_RELEASE \?\? 'local'/);
  assert.match(deploy, /PHOENIX_RELEASE:\$\{\{ github\.sha \}\}/);
  assert.match(deploy, /health\.release !== expectedRelease/);
});
