import fs from 'node:fs';

const target = process.argv[2];
if (!target) {
  throw new Error('usage: patch_shanghai_transient_modal_semantic_shape.mjs <patched-verify-script>');
}

let source = fs.readFileSync(target, 'utf8');

function replaceOnce(label, needle, replacement) {
  const first = source.indexOf(needle);
  const last = source.lastIndexOf(needle);
  if (first < 0 || first !== last) {
    throw new Error(`${label}: expected exactly one patch target`);
  }
  source = `${source.slice(0, first)}${replacement}${source.slice(first + needle.length)}`;
}

replaceOnce(
  'known transient modal allowlist',
  `const knownTransientModalDefinitions = Object.freeze([
  Object.freeze({
    id: 'chinese-voice-selector',
    title: '中文朗读声线',
    markers: Object.freeze(['中文朗读声线', '当前浏览器没有提供可选择的中文声线']),
    closeLabels: Object.freeze(['关闭', 'Dismiss']),
  }),
]);`,
  `const knownTransientModalDefinitions = Object.freeze([
  Object.freeze({
    id: 'chinese-voice-selector',
    title: '中文朗读声线',
    markers: Object.freeze(['中文朗读声线', '当前浏览器没有提供可选择的中文声线']),
    closeLabels: Object.freeze(['关闭', 'Dismiss']),
  }),
  Object.freeze({
    id: 'vocabulary-word-detail',
    title: 'Vocabulary word detail',
    markers: Object.freeze([
      '已下载例句',
      '用法：来自 Phoenix 已审核并随旅程下载的实际应用例句。',
      '收藏单词',
      '上一个单词',
      '下一个单词',
    ]),
    closeLabels: Object.freeze(['Dismiss']),
  }),
]);`
);

replaceOnce(
  'Flutter dialog semantic shape',
  `function classifyTransientModalRecords(recordsToClassify) {
  const dialogs = recordsToClassify.filter((record) => record.visible !== false && record.role === 'Dialog');`,
  `function isDialogSemanticRecord(record) {
  if (record?.visible === false) return false;
  return record?.role === 'Dialog' || clean(record?.label) === 'Dialog';
}

function classifyTransientModalRecords(recordsToClassify) {
  const dialogs = recordsToClassify.filter(isDialogSemanticRecord);`
);

replaceOnce(
  'voice fixture actual Flutter shape',
  `      index: 0,
      role: 'Dialog',
      text: 'Dismiss 中文朗读声线 关闭 简体普通话 台湾国语 当前浏览器没有提供可选择的中文声线。 Phoenix 仍会自动使用最佳可用声线。',`,
  `      index: 0,
      role: null,
      label: 'Dialog',
      text: 'Dismiss 中文朗读声线 关闭 简体普通话 台湾国语 当前浏览器没有提供可选择的中文声线。 Phoenix 仍会自动使用最佳可用声线。',`
);

replaceOnce(
  'vocabulary fixture insertion',
  `  const closeRecord = knownTransientModalCloseRecord(knownModal, known);
  if (!closeRecord || !['关闭', 'Dismiss'].includes(semanticRecordText(closeRecord))) {
    throw new Error('Known voice modal fixture did not resolve a real close control');
  }

  const postDismissStage = [`,
  `  const closeRecord = knownTransientModalCloseRecord(knownModal, known);
  if (!closeRecord || !['关闭', 'Dismiss'].includes(semanticRecordText(closeRecord))) {
    throw new Error('Known voice modal fixture did not resolve a real close control');
  }

  const vocabularyModal = [
    {
      index: 0,
      role: null,
      label: 'Dialog',
      text: 'Dismiss 外滩 1 / 5 已下载例句 已审核 这个晚上，他先到外滩和母亲见面。 用法：来自 Phoenix 已审核并随旅程下载的实际应用例句。 收藏单词 上一个单词 下一个单词',
      visible: true,
      disabled: false,
    },
    { index: 1, role: 'button', text: 'Dismiss', visible: true, disabled: false },
  ];
  const vocabulary = classifyTransientModalRecords(vocabularyModal);
  if (vocabulary.kind !== 'known' || vocabulary.definition.id !== 'vocabulary-word-detail') {
    throw new Error('Known Vocabulary word-detail modal fixture was not recognized');
  }
  const vocabularyClose = knownTransientModalCloseRecord(vocabularyModal, vocabulary);
  if (!vocabularyClose || semanticRecordText(vocabularyClose) !== 'Dismiss') {
    throw new Error('Known Vocabulary word-detail modal fixture did not resolve its real Dismiss control');
  }

  const postDismissStage = [`
);

replaceOnce(
  'unknown fixture actual Flutter shape',
  `    { index: 0, role: 'Dialog', text: '未知系统确认 对学习记录执行不可逆操作', visible: true, disabled: false },`,
  `    { index: 0, role: null, label: 'Dialog', text: '未知系统确认 对学习记录执行不可逆操作', visible: true, disabled: false },`
);

replaceOnce(
  'modal fixture success log',
  `  console.log('TRANSIENT MODAL FIXTURE PREFLIGHT = PASS | known voice modal recognized -> real close control -> Stage semantics re-read | unknown Dialog rejected');`,
  `  console.log('TRANSIENT MODAL FIXTURE PREFLIGHT = PASS | Flutter label=Dialog voice + Vocabulary modals recognized -> real close controls -> Stage semantics re-read | unknown Dialog rejected');`
);

fs.writeFileSync(target, source, 'utf8');
console.log(`TRANSIENT MODAL SEMANTIC-SHAPE PATCH = PASS | ${target}`);
