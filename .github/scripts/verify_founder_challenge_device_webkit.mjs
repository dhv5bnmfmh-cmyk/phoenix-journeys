import { pathToFileURL } from 'node:url';

const playwrightModule = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const { webkit } = playwrightModule;

const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) {
  throw new Error('usage: verify_founder_challenge_device_webkit.mjs <url> <source-sha>');
}

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();

async function records(page) {
  return page.locator('flt-semantics').evaluateAll((elements) => elements.map((element, index) => {
    const rect = element.getBoundingClientRect();
    const style = getComputedStyle(element);
    return {
      index,
      role: element.getAttribute('role') || '',
      text: [
        element.getAttribute('aria-label'),
        element.getAttribute('aria-valuetext'),
        element.getAttribute('aria-description'),
        element.textContent,
      ].filter(Boolean).join(' ').replace(/\s+/g, ' ').trim(),
      disabled: element.getAttribute('aria-disabled') === 'true',
      visible: rect.width > 0 && rect.height > 0 && style.display !== 'none' && style.visibility !== 'hidden',
      x: rect.x,
      y: rect.y,
      width: rect.width,
      height: rect.height,
      area: rect.width * rect.height,
    };
  }));
}

async function visibleRecords(page) {
  return (await records(page)).filter((record) => record.visible);
}

async function findRecord(page, needle, {
  role = null,
  exact = false,
  prefix = false,
  timeout = 15000,
} = {}) {
  const wanted = clean(needle);
  const deadline = Date.now() + timeout;
  let snapshot = '';
  while (Date.now() < deadline) {
    const candidates = (await visibleRecords(page)).filter((record) => {
      if (role && record.role !== role) return false;
      const text = clean(record.text);
      if (exact) return text === wanted;
      if (prefix) return text.startsWith(wanted);
      return text.includes(wanted);
    }).sort((a, b) => a.area - b.area);
    if (candidates.length) return candidates[0];
    snapshot = (await visibleRecords(page)).map((record) => clean(record.text)).join(' | ');
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${needle}; snapshot=${snapshot.slice(0, 1600)}`);
}

async function exists(page, needle, options = {}) {
  try {
    await findRecord(page, needle, { ...options, timeout: options.timeout ?? 700 });
    return true;
  } catch (_) {
    return false;
  }
}

async function countVisible(page, needle, { role = null, exact = false, prefix = false } = {}) {
  const wanted = clean(needle);
  return (await visibleRecords(page)).filter((record) => {
    if (role && record.role !== role) return false;
    const text = clean(record.text);
    if (exact) return text === wanted;
    if (prefix) return text.startsWith(wanted);
    return text.includes(wanted);
  }).length;
}

async function tapRecord(page, record) {
  const locator = page.locator('flt-semantics').nth(record.index);
  await locator.scrollIntoViewIfNeeded().catch(() => {});
  const box = await locator.boundingBox();
  if (!box) throw new Error(`semantic action has no tappable box: ${record.text}`);
  await page.touchscreen.tap(box.x + box.width / 2, box.y + box.height / 2);
}

async function tapText(page, needle, options = {}) {
  const record = await findRecord(page, needle, options);
  if (record.disabled) throw new Error(`semantic action disabled: ${needle}`);
  await tapRecord(page, record);
}

async function enableSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((element) => element.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 20000 });
}

async function configuredLevel(page) {
  for (const record of await visibleRecords(page)) {
    const match = record.text.match(/Phoenix 中文难度\s*(\d+)\s*级/);
    if (match) return Number(match[1]);
  }
  throw new Error('configured Phoenix level not found');
}

async function setLevel2(page) {
  const mobileHarness = await import(
    pathToFileURL(`${process.cwd()}/.github/scripts/journey_level_session_harness.mjs`).href,
  );
  await mobileHarness.setConfiguredLevel(page, 2);
  await mobileHarness.returnToExplore(page);
  console.log('WEBKIT LV2 CONFIGURATION = PASS');
}

async function findJourneyAction(page) {
  for (const prefix of ['开始', '继续', '再次探索']) {
    try {
      return await findRecord(page, prefix, { role: 'button', prefix: true, timeout: 1200 });
    } catch (_) {}
  }
  throw new Error('Home: no Journey action found');
}

async function enterChallenge(page) {
  const action = await findJourneyAction(page);
  await tapRecord(page, action);
  await findRecord(page, '1/5 Story', { timeout: 20000 });

  await tapText(page, '继续', { role: 'button', exact: true });
  await sleep(500);
  await page.touchscreen.tap(22, 58);
  await findRecord(page, '2/5 Vocabulary', { timeout: 15000 });

  await tapText(page, '继续', { role: 'button', exact: true });
  await findRecord(page, '3/5 Discovery', { timeout: 15000 });

  await tapText(page, '继续', { role: 'button', exact: true });
  await findRecord(page, '挑战 1/12', { timeout: 15000 });
  console.log('WEBKIT REACHED CHALLENGE 1/12 = PASS');
}

const excludedActionTexts = [
  '上一步',
  '提交',
  '下一题',
  '朗读题目',
  '朗读答题反馈',
  '撤销',
  '重置',
  '继续留下回忆',
];

function excludedAction(text) {
  const value = clean(text);
  return excludedActionTexts.some((item) => value === item || value.startsWith(item));
}

async function firstAnswerCandidate(page) {
  const candidates = (await visibleRecords(page))
    .filter((record) => ['button', 'checkbox'].includes(record.role) && !record.disabled && !excludedAction(record.text))
    .filter((record) => record.y > 100)
    .sort((a, b) => a.y - b.y || a.x - b.x || a.area - b.area);
  return candidates[0] ?? null;
}

async function submitCurrentQuestion(page, questionNumber) {
  const deadline = Date.now() + 30000;
  while (Date.now() < deadline) {
    if (await exists(page, '下一题', { role: 'button', exact: true, timeout: 250 })) return;

    const submit = await findRecord(page, '提交', {
      role: 'button',
      exact: true,
      timeout: 350,
    }).catch(() => null);
    if (submit && !submit.disabled) {
      await tapRecord(page, submit);
      await sleep(250);
      continue;
    }

    const candidate = await firstAnswerCandidate(page);
    if (candidate) {
      await tapRecord(page, candidate);
      await sleep(180);
      continue;
    }

    const snapshot = (await visibleRecords(page))
      .map((record) => `${record.role}:${clean(record.text)}:${record.disabled ? 'disabled' : 'enabled'}`)
      .join(' | ');
    throw new Error(
      `Challenge ${questionNumber}/12 has no actionable answer candidate; ` +
      `snapshot=${snapshot.slice(0, 1800)}`,
    );
  }
  throw new Error(`Challenge ${questionNumber}/12 could not reach submitted state`);
}

async function advanceToQuestion(page, nextNumber) {
  await tapText(page, '下一题', { role: 'button', exact: true });
  await findRecord(page, `挑战 ${nextNumber}/12`, { timeout: 15000 });
}

async function installSpeechCapture(page) {
  await page.evaluate(() => {
    window.__phoenixCapturedSpeech = [];
    const synth = window.speechSynthesis;
    if (!synth || typeof synth.speak !== 'function') {
      throw new Error('window.speechSynthesis.speak unavailable in WebKit');
    }
    if (synth.__phoenixCaptureInstalled) return;
    const original = synth.speak.bind(synth);
    const wrapped = (utterance) => {
      window.__phoenixCapturedSpeech.push(String(utterance?.text ?? ''));
      try {
        return original(utterance);
      } catch (_) {
        return undefined;
      }
    };
    try {
      synth.speak = wrapped;
    } catch (_) {
      Object.defineProperty(synth, 'speak', {
        configurable: true,
        value: wrapped,
      });
    }
    Object.defineProperty(synth, '__phoenixCaptureInstalled', {
      configurable: true,
      value: true,
    });
  });
}

async function clearSpeech(page) {
  await page.evaluate(() => { window.__phoenixCapturedSpeech = []; });
}

async function capturedSpeech(page) {
  return page.evaluate(() => [...(window.__phoenixCapturedSpeech ?? [])]);
}

async function waitForSpeech(page, timeout = 8000) {
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    const spoken = await capturedSpeech(page);
    if (spoken.length) return spoken;
    await sleep(100);
  }
  throw new Error('WebKit captured no Web Speech utterance');
}

async function dump(page) {
  const snapshot = (await visibleRecords(page)).map((record) => ({
    role: record.role,
    text: clean(record.text),
    disabled: record.disabled,
    rect: [
      Math.round(record.x),
      Math.round(record.y),
      Math.round(record.width),
      Math.round(record.height),
    ],
  }));
  console.error(`WEBKIT SEMANTICS SNAPSHOT = ${JSON.stringify(snapshot)}`);
  console.error(`WEBKIT SPEECH SNAPSHOT = ${JSON.stringify(await capturedSpeech(page).catch(() => []))}`);
}

const browser = await webkit.launch({ headless: true });
let page;
try {
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    deviceScaleFactor: 3,
    isMobile: true,
    hasTouch: true,
    locale: 'zh-CN',
    reducedMotion: 'reduce',
  });
  page = await context.newPage();
  const pageErrors = [];
  page.on('pageerror', (error) => pageErrors.push(error?.stack || error?.message || String(error)));
  page.on('console', (message) => console.log(`[webkit console:${message.type()}] ${message.text()}`));

  const separator = baseUrl.includes('?') ? '&' : '?';
  const candidateUrl = `${baseUrl}${separator}unlock=all&prototype=journeys&v=${sourceSha}`;
  await page.goto(candidateUrl, { waitUntil: 'load', timeout: 140000 });
  await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
  await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 40000 });
  await enableSemantics(page);
  await findRecord(page, 'PHOENIX JOURNEYS', { timeout: 20000 });
  await installSpeechCapture(page);

  await setLevel2(page);
  await enterChallenge(page);

  for (let question = 1; question <= 10; question += 1) {
    await submitCurrentQuestion(page, question);
    await advanceToQuestion(page, question + 1);
  }

  // Question 11 establishes that feedback state/audio does not leak into question 12.
  await submitCurrentQuestion(page, 11);
  if (!(await exists(page, '朗读答题反馈', { timeout: 1000 }))) {
    throw new Error('Q11 post-submit feedback speaker missing');
  }
  await clearSpeech(page);
  await tapText(page, '朗读答题反馈', { prefix: true });
  const q11Feedback = await waitForSpeech(page);
  if (!q11Feedback.some((text) => text.includes('正确答案') && text.includes('解释'))) {
    throw new Error(`Q11 feedback TTS missing correct answer/explanation: ${JSON.stringify(q11Feedback)}`);
  }
  await advanceToQuestion(page, 12);
  if (await exists(page, '朗读答题反馈', { timeout: 800 })) {
    throw new Error('DEVICE REGRESSION C: feedback speaker leaked into next question');
  }
  if (!(await exists(page, '朗读题目', { timeout: 1000 }))) {
    throw new Error('DEVICE REGRESSION C: question speaker missing after next-question reset');
  }
  console.log('DEVICE REGRESSION C RESET = PASS');

  // Capture question audio before submit and prove feedback audio is a distinct post-submit payload.
  await clearSpeech(page);
  await tapText(page, '朗读题目', { prefix: true });
  const questionSpeech = await waitForSpeech(page);
  const questionText = questionSpeech.at(-1) ?? '';
  if (!questionText) throw new Error('Q12 question speaker emitted empty text');
  if (await exists(page, '朗读答题反馈', { timeout: 500 })) {
    throw new Error('DEVICE REGRESSION C: feedback speaker visible before submit');
  }

  await submitCurrentQuestion(page, 12);

  const internalBackCount = await countVisible(page, '上一步', { role: 'button', exact: true });
  const internalNextCount = await countVisible(page, '下一题', { role: 'button', exact: true });
  const outerContinueBefore = await countVisible(page, '继续留下回忆', { role: 'button', exact: true });
  if (internalBackCount !== 1 || internalNextCount !== 1 || outerContinueBefore !== 0) {
    throw new Error(
      `DEVICE REGRESSION A/B: invalid final submitted navigation state: ` +
      `back=${internalBackCount}, next=${internalNextCount}, outerContinue=${outerContinueBefore}`,
    );
  }
  console.log('DEVICE REGRESSION A = PASS');
  console.log('DEVICE REGRESSION B PRE-COMPLETION = PASS');

  if (!(await exists(page, '朗读答题反馈', { timeout: 1000 }))) {
    throw new Error('DEVICE REGRESSION C: feedback speaker missing after submit');
  }
  await clearSpeech(page);
  await tapText(page, '朗读答题反馈', { prefix: true });
  const feedbackSpeech = await waitForSpeech(page);
  const feedbackText = feedbackSpeech.at(-1) ?? '';
  if (!feedbackText.includes('正确答案') || !feedbackText.includes('解释')) {
    throw new Error(`DEVICE REGRESSION C: feedback TTS missing correct answer/explanation: ${feedbackText}`);
  }
  if (feedbackText === questionText || feedbackText.includes(questionText)) {
    throw new Error(
      `DEVICE REGRESSION C: feedback speaker replayed question audio: ` +
      `question=${questionText}; feedback=${feedbackText}`,
    );
  }
  console.log(`QUESTION AUDIO CAPTURE = ${questionText}`);
  console.log(`FEEDBACK AUDIO CAPTURE = ${feedbackText}`);
  console.log('DEVICE REGRESSION C = PASS');

  await tapText(page, '下一题', { role: 'button', exact: true });
  await findRecord(page, '继续留下回忆', { role: 'button', exact: true, timeout: 15000 });

  const nextAfterCompletion = await countVisible(page, '下一题', { role: 'button', exact: true });
  const backAfterCompletion = await countVisible(page, '上一步', { role: 'button', exact: true });
  const outerContinueAfter = await countVisible(page, '继续留下回忆', { role: 'button', exact: true });
  if (nextAfterCompletion !== 0 || backAfterCompletion !== 1 || outerContinueAfter !== 1) {
    throw new Error(
      `DEVICE REGRESSION B: Challenge/Journey controls overlap after completion: ` +
      `back=${backAfterCompletion}, next=${nextAfterCompletion}, outerContinue=${outerContinueAfter}`,
    );
  }
  console.log('DEVICE REGRESSION B = PASS');

  if (pageErrors.length) {
    throw new Error(`WebKit page errors: ${pageErrors.join('\n')}`);
  }
  console.log(`MOBILE WEBKIT SOURCE SHA = ${sourceSha}`);
  console.log('FOUNDER DEVICE MOBILE WEBKIT REGRESSION = PASS');
} catch (error) {
  if (page) await dump(page).catch(() => {});
  console.error('FOUNDER DEVICE MOBILE WEBKIT REGRESSION FAILURE', error?.stack || error);
  process.exitCode = 1;
} finally {
  await browser.close();
}
