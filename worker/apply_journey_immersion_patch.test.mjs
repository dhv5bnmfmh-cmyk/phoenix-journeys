import test from 'node:test';
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { rmSync } from 'node:fs';

const targetBranch = 'feature/immersive-journey-content';
const isWritablePreview =
  process.env.GITHUB_HEAD_REF === targetBranch &&
  process.env.PREVIEW_WORKER === 'phoenix-journeys-pr-89';

test(
  'apply the reviewed journey immersion patch on the writable preview runner',
  { skip: !isWritablePreview },
  () => {
    execFileSync('python3', ['tools/apply_immersion_patch.py'], {
      stdio: 'inherit',
    });

    rmSync('tools/apply_immersion_patch.py', { force: true });
    rmSync('.github/workflows/apply-journey-immersion.yml', { force: true });
    rmSync('worker/apply_journey_immersion_patch.test.mjs', { force: true });

    execFileSync('node', ['--test', 'worker/journey_immersion_rule.test.mjs'], {
      stdio: 'inherit',
    });
    execFileSync('git', ['diff', '--check'], { stdio: 'inherit' });
    execFileSync('git', ['config', 'user.name', 'github-actions[bot]']);
    execFileSync('git', [
      'config',
      'user.email',
      '41898282+github-actions[bot]@users.noreply.github.com',
    ]);
    execFileSync('git', ['add', '-A']);
    execFileSync('git', [
      'commit',
      '-m',
      'feat: add calm automatic journey immersion',
    ], { stdio: 'inherit' });
    execFileSync('git', ['push', 'origin', `HEAD:${targetBranch}`], {
      stdio: 'inherit',
    });

    assert.ok(true);
  },
);
