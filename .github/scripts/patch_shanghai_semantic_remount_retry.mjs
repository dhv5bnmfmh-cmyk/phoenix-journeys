import fs from 'node:fs';

const target = process.argv[2];
if (!target) throw new Error('usage: patch_shanghai_semantic_remount_retry.mjs <patched-verify-script>');

let source = fs.readFileSync(target, 'utf8');

function replaceOnce(label, needle, replacement) {
  const first = source.indexOf(needle);
  const last = source.lastIndexOf(needle);
  if (first < 0 || first !== last) throw new Error(`${label}: expected exactly one patch target`);
  source = `${source.slice(0, first)}${replacement}${source.slice(first + needle.length)}`;
}

replaceOnce(
  'narration seek semantic remount retry',
  `async function narrationExplicitlyCompleted(page) {
  const text = await visibleText(page);
  return discoveryNarrationState(text).finished;
}

async function seekNarrationProgress(page, progress) {
  if (await narrationExplicitlyCompleted(page)) return false;

  const rs = await records(page);
  const rail = rs.find((r) => r.visible && !r.disabled && r.role === 'button' && recText(r).includes('朗读进度，可拖动跳转'));
  if (!rail) {
    if (await narrationExplicitlyCompleted(page)) return false;
    throw new Error('Discovery narration seek rail not found while narration is not complete');
  }

  const identity = { expectedRole: 'button', expectedNeedle: '朗读进度，可拖动跳转' };
  let bound;
  try {
    bound = await bindStableSemanticRecord(page, rail, identity);
  } catch (error) {
    if (await narrationExplicitlyCompleted(page)) return false;
    throw error;
  }
  const { handle } = bound;
  const box = await handle.boundingBox();
  if (!box || box.width <= 2 || box.height <= 2) {
    if (await narrationExplicitlyCompleted(page)) return false;
    throw new Error('Discovery narration seek rail has no actionable geometry while narration is not complete');
  }
  const position = {
    x: Math.max(1, Math.min(box.width - 1, box.width * progress)),
    y: box.height / 2,
  };

  try {
    verifyBoundSemanticIdentity(await readBoundSemanticHandle(handle), identity);
  } catch (error) {
    if (await narrationExplicitlyCompleted(page)) return false;
    throw error;
  }

  const mode = interactionModeByPage.get(page);
  if (mode === interactionModes.desktop) {
    await handle.click({ position, timeout: 10000, noWaitAfter: true });
  } else if (mode === interactionModes.touch) {
    await handle.tap({ position, timeout: 10000 });
  } else {
    throw new Error('browser interaction mode was not registered before narration seek');
  }
  await sleep(300);
  return true;
}`,
  `async function narrationExplicitlyCompleted(page) {
  const text = await visibleText(page);
  return discoveryNarrationState(text).finished;
}

function isSemanticRemountRace(error) {
  const message = String(error?.message || error);
  return message.includes('detached before') ||
    message.includes('Element is not attached') ||
    message.includes('not attached to the DOM') ||
    message.includes('Target page, context or browser has been closed') === false && message.includes('detached');
}

async function seekNarrationProgress(page, progress) {
  if (await narrationExplicitlyCompleted(page)) return false;

  const identity = { expectedRole: 'button', expectedNeedle: '朗读进度，可拖动跳转' };
  const maxRemountAttempts = 5;
  let lastRemountError = null;

  for (let attempt = 1; attempt <= maxRemountAttempts; attempt += 1) {
    if (await narrationExplicitlyCompleted(page)) return false;

    const rs = await records(page);
    const rail = rs.find((r) => r.visible && !r.disabled && r.role === 'button' && recText(r).includes('朗读进度，可拖动跳转'));
    if (!rail) {
      if (await narrationExplicitlyCompleted(page)) return false;
      lastRemountError = new Error('Discovery narration seek rail temporarily absent during semantic remount');
      if (attempt < maxRemountAttempts) {
        await sleep(60);
        continue;
      }
      break;
    }

    try {
      // The numeric snapshot index is observation metadata only. Every retry starts
      // from a fresh semantics snapshot, then binds and re-proves the live narration rail.
      const { handle } = await bindStableSemanticRecord(page, rail, identity);
      let live = await readBoundSemanticHandle(handle);
      verifyBoundSemanticIdentity(live, identity);

      const box = await handle.boundingBox();
      if (!box || box.width <= 2 || box.height <= 2) {
        if (await narrationExplicitlyCompleted(page)) return false;
        throw new Error('Discovery narration seek rail has no actionable geometry while narration is not complete');
      }
      const position = {
        x: Math.max(1, Math.min(box.width - 1, box.width * progress)),
        y: box.height / 2,
      };

      live = await readBoundSemanticHandle(handle);
      verifyBoundSemanticIdentity(live, identity);

      const mode = interactionModeByPage.get(page);
      if (mode === interactionModes.desktop) {
        await handle.click({ position, timeout: 10000, noWaitAfter: true });
      } else if (mode === interactionModes.touch) {
        await handle.tap({ position, timeout: 10000 });
      } else {
        throw new Error('browser interaction mode was not registered before narration seek');
      }
      await sleep(300);
      return true;
    } catch (error) {
      if (await narrationExplicitlyCompleted(page)) return false;
      if (!isSemanticRemountRace(error)) throw error;
      lastRemountError = error;
      if (attempt < maxRemountAttempts) {
        await sleep(60);
        continue;
      }
    }
  }

  throw new Error(\`Discovery narration rail could not remain bound after \${maxRemountAttempts} fresh semantic-remount attempts: \${lastRemountError?.message || 'unknown remount race'}\`);
}`
);

replaceOnce(
  'semantic remount fixture',
  `  if (terminalWrongLevel) throw new Error('terminal level-drift negative fixture unexpectedly passed');`,
  `  if (terminalWrongLevel) throw new Error('terminal level-drift negative fixture unexpectedly passed');

  const remountSequence = [
    { index: 18, connected: false, role: 'button', text: '朗读进度，可拖动跳转 2%' },
    { index: 7, connected: true, role: 'button', text: '降低当前难度' },
    { index: 19, connected: true, role: 'button', text: '朗读进度，可拖动跳转 2%' },
  ];
  const staleDetached = remountSequence[0];
  const reboundRail = remountSequence.find((entry) => entry.connected && entry.role === 'button' && entry.text.includes('朗读进度，可拖动跳转'));
  if (staleDetached.connected) throw new Error('semantic-remount fixture did not detach original narration rail');
  if (!reboundRail || reboundRail.index !== 19) throw new Error('semantic-remount fixture failed to re-resolve fresh narration identity');
  if (remountSequence[1].text !== '降低当前难度') throw new Error('semantic-remount fixture did not preserve nearby difficulty-control risk');`
);

fs.writeFileSync(target, source, 'utf8');
console.log(`SEMANTIC REMOUNT RETRY PATCH = PASS | ${target}`);
