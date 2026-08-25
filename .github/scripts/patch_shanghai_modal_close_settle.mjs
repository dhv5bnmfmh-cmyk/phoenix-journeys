import fs from 'node:fs';

const target = process.argv[2];
if (!target) throw new Error('usage: patch_shanghai_modal_close_settle.mjs <patched-verify-script>');

let source = fs.readFileSync(target, 'utf8');

function replaceOnce(label, needle, replacement) {
  const first = source.indexOf(needle);
  const last = source.lastIndexOf(needle);
  if (first < 0 || first !== last) throw new Error(`${label}: expected exactly one patch target`);
  source = `${source.slice(0, first)}${replacement}${source.slice(first + needle.length)}`;
}

replaceOnce(
  'known modal close-state abstraction',
  `function knownTransientModalCloseRecord(recordsToClassify, classification) {
  if (classification.kind !== 'known') return null;
  for (const label of classification.definition.closeLabels) {
    const exact = recordsToClassify.find((record) =>
      record.visible !== false &&
      !record.disabled &&
      record.role === 'button' &&
      semanticRecordText(record) === label
    );
    if (exact) return exact;
  }
  return null;
}

function runTransientModalFixturePreflight() {`,
  `function knownTransientModalCloseRecord(recordsToClassify, classification) {
  if (classification.kind !== 'known') return null;
  for (const label of classification.definition.closeLabels) {
    const exact = recordsToClassify.find((record) =>
      record.visible !== false &&
      !record.disabled &&
      record.role === 'button' &&
      semanticRecordText(record) === label
    );
    if (exact) return exact;
  }
  return null;
}

function isUnidentifiedDialogShellClassification(classification) {
  return classification.kind === 'unknown' &&
    classification.dialogs.length > 0 &&
    classification.dialogs.every((text) => {
      const normalized = clean(text);
      return normalized === '' || normalized === 'Dialog';
    });
}

function transientModalIdentityState(recordsToClassify) {
  const classification = classifyTransientModalRecords(recordsToClassify);
  if (isUnidentifiedDialogShellClassification(classification)) return { kind: 'mounting-unidentified' };
  return classification;
}

function transientModalCloseState(recordsToClassify) {
  const classification = transientModalIdentityState(recordsToClassify);
  if (classification.kind !== 'known') return classification;
  const closeRecord = knownTransientModalCloseRecord(recordsToClassify, classification);
  return closeRecord
    ? { kind: 'known-ready', definition: classification.definition, closeRecord }
    : { kind: 'known-waiting-close', definition: classification.definition };
}

function runTransientModalFixturePreflight() {`
);

replaceOnce(
  'delayed close-control and identity fixtures',
  `  const vocabulary = classifyTransientModalRecords(vocabularyModal);
  if (vocabulary.kind !== 'known' || vocabulary.definition.id !== 'vocabulary-word-detail') {
    throw new Error('Known Vocabulary word-detail modal fixture was not recognized');
  }
  const vocabularyClose = knownTransientModalCloseRecord(vocabularyModal, vocabulary);
  if (!vocabularyClose || semanticRecordText(vocabularyClose) !== 'Dismiss') {
    throw new Error('Known Vocabulary word-detail modal fixture did not resolve its real Dismiss control');
  }

  const postDismissStage = [`,
  `  const vocabulary = classifyTransientModalRecords(vocabularyModal);
  if (vocabulary.kind !== 'known' || vocabulary.definition.id !== 'vocabulary-word-detail') {
    throw new Error('Known Vocabulary word-detail modal fixture was not recognized');
  }
  const vocabularyClose = knownTransientModalCloseRecord(vocabularyModal, vocabulary);
  if (!vocabularyClose || semanticRecordText(vocabularyClose) !== 'Dismiss') {
    throw new Error('Known Vocabulary word-detail modal fixture did not resolve its real Dismiss control');
  }

  const vocabularyMounting = vocabularyModal.filter((record) => record.role !== 'button');
  const mountingState = transientModalCloseState(vocabularyMounting);
  if (mountingState.kind !== 'known-waiting-close' || mountingState.definition.id !== 'vocabulary-word-detail') {
    throw new Error('Known Vocabulary modal mounting fixture did not wait for its close semantics');
  }
  const readyState = transientModalCloseState(vocabularyModal);
  if (readyState.kind !== 'known-ready' || semanticRecordText(readyState.closeRecord) !== 'Dismiss') {
    throw new Error('Known Vocabulary modal did not transition from mounting to close-ready semantics');
  }

  const emptyDialogShell = [
    { index: 0, role: null, label: 'Dialog', text: '', visible: true, disabled: false },
  ];
  if (transientModalIdentityState(emptyDialogShell).kind !== 'mounting-unidentified') {
    throw new Error('Empty Flutter Dialog shell fixture was not treated as identity-mounting state');
  }
  const shellThenKnownState = transientModalIdentityState(vocabularyModal);
  if (shellThenKnownState.kind !== 'known' || shellThenKnownState.definition.id !== 'vocabulary-word-detail') {
    throw new Error('Empty Dialog shell did not settle to the known Vocabulary modal fixture');
  }

  const postDismissStage = [`
);

replaceOnce(
  'unknown fixture identity negative',
  `  const unknown = classifyTransientModalRecords(unknownModal);
  if (unknown.kind !== 'unknown') {
    throw new Error('Unknown dialog fixture was not rejected');
  }
  if (knownTransientModalCloseRecord(unknownModal, unknown) !== null) {
    throw new Error('Unknown dialog fixture unexpectedly produced an auto-dismiss target');
  }

  console.log('TRANSIENT MODAL FIXTURE PREFLIGHT = PASS | Flutter label=Dialog voice + Vocabulary modals recognized -> real close controls -> Stage semantics re-read | unknown Dialog rejected');`,
  `  const unknown = classifyTransientModalRecords(unknownModal);
  if (unknown.kind !== 'unknown') {
    throw new Error('Unknown dialog fixture was not rejected');
  }
  if (isUnidentifiedDialogShellClassification(unknown)) {
    throw new Error('Unknown dialog with concrete identity was misclassified as an empty mounting shell');
  }
  if (knownTransientModalCloseRecord(unknownModal, unknown) !== null) {
    throw new Error('Unknown dialog fixture unexpectedly produced an auto-dismiss target');
  }
  if (transientModalIdentityState(unknownModal).kind !== 'unknown') {
    throw new Error('Empty Dialog shell settling to an unknown modal did not remain a hard-stop classification');
  }

  console.log('TRANSIENT MODAL FIXTURE PREFLIGHT = PASS | Flutter label=Dialog voice + Vocabulary modals recognized | empty Dialog shell waits for identity | delayed close mount waits -> ready | real close controls -> Stage semantics re-read | concrete unknown Dialog rejected');`
);

replaceOnce(
  'runtime close-control and identity settle polling',
  `async function dismissKnownTransientModal(page) {
  const currentRecords = await records(page);
  const classification = classifyTransientModalRecords(currentRecords);
  if (classification.kind === 'none') return false;
  if (classification.kind === 'unknown') {
    throw new Error(\`UNKNOWN MODAL != AUTO-DISMISS | \${classification.dialogs.join(' || ')}\`);
  }

  const closeRecord = knownTransientModalCloseRecord(currentRecords, classification);
  if (!closeRecord) {
    throw new Error(\`Known transient modal \${classification.definition.id} has no allowed close control\`);
  }

  console.log(
    \`KNOWN TRANSIENT MODAL = \${classification.definition.id} | TITLE=\${classification.definition.title} | ACTION=\${semanticRecordText(closeRecord)}\`
  );
  await activateSemantic(page, page.locator('flt-semantics').nth(closeRecord.index));

  const deadline = Date.now() + 5000;
  while (Date.now() < deadline) {
    await sleep(100);
    const after = classifyTransientModalRecords(await records(page));
    if (after.kind === 'none') {
      console.log(\`KNOWN TRANSIENT MODAL DISMISSED = \${classification.definition.id} | RE-READ SEMANTICS\`);
      return true;
    }
    if (after.kind === 'unknown') {
      throw new Error(\`UNKNOWN MODAL != AUTO-DISMISS | \${after.dialogs.join(' || ')}\`);
    }
  }
  throw new Error(\`Known transient modal did not dismiss: \${classification.definition.id}\`);
}`,
  `async function dismissKnownTransientModal(page) {
  const identityDeadline = Date.now() + 5000;
  let initial = null;
  while (Date.now() < identityDeadline) {
    const state = transientModalIdentityState(await records(page));
    if (state.kind === 'none') return false;
    if (state.kind === 'mounting-unidentified') {
      await sleep(100);
      continue;
    }
    if (state.kind === 'unknown') {
      throw new Error(\`UNKNOWN MODAL != AUTO-DISMISS | \${state.dialogs.join(' || ')}\`);
    }
    initial = state;
    break;
  }
  if (!initial) throw new Error('UNIDENTIFIED MODAL SHELL did not mount semantic identity');

  const expectedId = initial.definition.id;
  console.log(\`KNOWN TRANSIENT MODAL = \${expectedId} | TITLE=\${initial.definition.title} | WAITING FOR ALLOWED CLOSE SEMANTICS\`);

  const closeDeadline = Date.now() + 5000;
  let closeRecord = null;
  while (Date.now() < closeDeadline) {
    const state = transientModalCloseState(await records(page));
    if (state.kind === 'none') {
      console.log(\`KNOWN TRANSIENT MODAL DISAPPEARED = \${expectedId} | RE-READ SEMANTICS\`);
      return true;
    }
    if (state.kind === 'mounting-unidentified') {
      await sleep(100);
      continue;
    }
    if (state.kind === 'unknown') {
      throw new Error(\`UNKNOWN MODAL != AUTO-DISMISS | \${state.dialogs.join(' || ')}\`);
    }
    if (state.definition.id !== expectedId) {
      throw new Error(\`Transient modal identity changed before close: \${expectedId} -> \${state.definition.id}\`);
    }
    if (state.kind === 'known-ready') {
      closeRecord = state.closeRecord;
      break;
    }
    await sleep(100);
  }
  if (!closeRecord) throw new Error(\`Known transient modal \${expectedId} did not mount an allowed close control\`);

  console.log(\`KNOWN TRANSIENT MODAL CLOSE READY = \${expectedId} | ACTION=\${semanticRecordText(closeRecord)}\`);
  await activateSemantic(page, page.locator('flt-semantics').nth(closeRecord.index));

  const dismissDeadline = Date.now() + 5000;
  while (Date.now() < dismissDeadline) {
    await sleep(100);
    const after = transientModalIdentityState(await records(page));
    if (after.kind === 'none') {
      console.log(\`KNOWN TRANSIENT MODAL DISMISSED = \${expectedId} | RE-READ SEMANTICS\`);
      return true;
    }
    if (after.kind === 'mounting-unidentified') continue;
    if (after.kind === 'unknown') {
      throw new Error(\`UNKNOWN MODAL != AUTO-DISMISS | \${after.dialogs.join(' || ')}\`);
    }
    if (after.definition.id !== expectedId) {
      throw new Error(\`Transient modal identity changed while dismissing: \${expectedId} -> \${after.definition.id}\`);
    }
  }
  throw new Error(\`Known transient modal did not dismiss: \${expectedId}\`);
}`
);

fs.writeFileSync(target, source, 'utf8');
console.log(`TRANSIENT MODAL CLOSE-SETTLE PATCH = PASS | ${target}`);
