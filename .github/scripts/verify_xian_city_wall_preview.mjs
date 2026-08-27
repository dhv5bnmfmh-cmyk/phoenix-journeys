import { pathToFileURL } from 'node:url';
const { chromium, webkit, devices } = await import(
pathToFileURL(process.env.PLAYWRIGHT_PATH).href
);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
if (!baseUrl || !sourceSha) {
throw new Error('usage: verify_xian_city_wall_preview.mjs <preview-url> <sha>');
}
const levels = [1, 3, 5, 8, 10];
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();
const expected = {
1: {
story: ['周遥二十二岁', '最后一次告别', '距离还在增加'],
discovery: ['13.74公里'],
vi: ['Chu Dao, 22 tuổi', 'lời chia tay cuối cùng'],
en: ['Zhou Yao, twenty-two', 'final farewell'],
},
3: {
story: ['住址一变', '新家阳台的照片', '继续增加'],
discovery: ['12至14米'],
vi: ['một khi địa chỉ đổi', 'ban công nhà mới'],
en: ['once his address changes', 'new balcony'],
},
5: {
story: ['一场私人告别', '护城河', '完整的一圈'],
discovery: ['护城河'],
vi: ['một nghi thức chia tay riêng', 'hào'],
en: ['private farewell ritual', 'moat'],
},
8: {
story: ['一个干净的句号', '被保护、监测', '没有在永宁门结束的路线'],
discovery: ['无损检测'],
vi: ['một dấu chấm hết sạch sẽ', 'quan trắc'],
en: ['a clean full stop', 'monitored'],
},
10: {
story: ['可量化的闭环', '1961年', '命名为“回家”'],
discovery: ['历史城区'],
vi: ['một vòng khép kín có thể đo', 'Năm 1961'],
en: ['one measurable closed loop', 'In 1961'],
},
};
async function records(page) {
return page.locator('flt-semantics').evaluateAll((elements) =>
elements.map((element, index) => {
const rect = element.getBoundingClientRect();
const style = getComputedStyle(element);
return {
index,
role: element.getAttribute('role'),
label: element.getAttribute('aria-label') || '',
value: element.getAttribute('aria-valuetext') || '',
description: element.getAttribute('aria-description') || '',
text: String(element.textContent || '').replace(/\s+/g, ' ').trim(),
disabled: element.getAttribute('aria-disabled') === 'true',
visible:
rect.width > 0 &&
rect.height > 0 &&
style.display !== 'none' &&
style.visibility !== 'hidden',
area: rect.width * rect.height,
};
}),
);
}
const recordText = (record) =>
clean(
[record.label, record.value, record.description, record.text]
.filter(Boolean)
.join(' '),
);
async function visibleText(page) {
return (await records(page))
.filter((record) => record.visible)
.map(recordText)
.filter(Boolean)
.join('\n');
}
async function findSemantic(
page,
needle,
{ role = null, prefix = false, timeout = 20000 } = {},
) {
const deadline = Date.now() + timeout;
const wanted = clean(needle);
while (Date.now() < deadline) {
const matches = (await records(page))
.filter((record) => {
if (!record.visible || (role && record.role !== role)) return false;
const text = recordText(record);
return prefix ? text.startsWith(wanted) : text.includes(wanted);
})
.sort((left, right) => {
if (left.role === 'button' && right.role !== 'button') return -1;
if (right.role === 'button' && left.role !== 'button') return 1;
return left.area - right.area;
});
if (matches.length) {
return page.locator('flt-semantics').nth(matches[0].index);
}
await sleep(100);
}
throw new Error(`semantic state not found: ${needle}`);
}
async function exists(page, needle, options = {}) {
try {
await findSemantic(page, needle, {
...options,
timeout: options.timeout ?? 700,
});
return true;
} catch (_) {
return false;
}
}
async function activate(page, needle, { prefix = false, timeout = 20000 } = {}) {
const deadline = Date.now() + timeout;
let lastError = null;
while (Date.now() < deadline) {
try {
const node = await findSemantic(page, needle, {
role: 'button',
prefix,
timeout: Math.min(1800, deadline - Date.now()),
});
const disabled = await node.getAttribute('aria-disabled').catch(() => null);
if (disabled === 'true') throw new Error(`button disabled: ${needle}`);
await node.evaluate((element) => element.click());
return;
} catch (error) {
if (String(error?.message || error).includes(`button disabled: ${needle}`)) {
throw error;
}
lastError = error;
await sleep(100);
}
}
throw lastError ?? new Error(`button not activatable: ${needle}`);
}
async function enableSemantics(page) {
const deadline = Date.now() + 60000;
while (Date.now() < deadline) {
const placeholder = page.locator('flt-semantics-placeholder').first();
if (await placeholder.count()) {
await placeholder.evaluate((element) => element.click());
}
if (await page.locator('flt-semantics').count()) return;
await sleep(100);
}
throw new Error('Flutter semantics did not become available');
}
async function requireStartup(page) {
const sep = baseUrl.includes('?') ? '&' : '?';
const url = `${baseUrl}${sep}unlock=all&prototype=journeys&v=${sourceSha}`;
const response = await page.goto(url, { waitUntil: 'load', timeout: 140000 });
if (!response?.ok()) throw new Error(`Preview HTTP load failed: ${response?.status()}`);
await page.waitForFunction(
() => document.querySelector('flutter-view') != null,
null,
{ timeout: 140000 },
);
await page.waitForFunction(
() => document.getElementById('phoenix-loading') == null,
null,
{ timeout: 45000 },
);
await enableSemantics(page);
await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 30000 });
}
async function currentLevel(page) {
for (const record of await records(page)) {
if (!record.visible) continue;
const match = recordText(record).match(/Phoenix 中文难度\s*(\d+)\s*级/);
if (match) return Number(match[1]);
}
throw new Error('Phoenix level selector not found');
}
async function setLevel(page, target) {
for (let guard = 0; guard < 16; guard += 1) {
const level = await currentLevel(page);
if (level === target) return;
const direction = level < target ? '提高当前难度' : '降低当前难度';
const before = level;
await activate(page, direction, { prefix: true });
let moved = false;
for (let i = 0; i < 50; i += 1) {
await sleep(100);
const settled = await currentLevel(page).catch(() => before);
if (settled === target) return;
if (settled !== before) {
moved = true;
break;
}
}
if (!moved) throw new Error(`level selector did not move from ${before}`);
}
throw new Error(`failed to select Lv${target}; current Lv${await currentLevel(page)}`);
}
async function waitStage(page, number) {
await findSemantic(page, `${number}/6`, { prefix: true, timeout: 20000 });
}
async function openViaPassport(page) {
await activate(page, '护照', { prefix: true });
await findSemantic(page, '探索护照', { prefix: true, timeout: 15000 });
console.log('PASSPORT = PASS');
await activate(page, '中国', { prefix: true });
await findSemantic(page, '请从左侧选择省份', { prefix: true, timeout: 15000 });
console.log('PASSPORT CHINA = PASS');
await activate(page, '陕西省', { prefix: true });
await findSemantic(page, '请从左侧选择城市', { prefix: true, timeout: 15000 });
console.log('PASSPORT SHAANXI = PASS');
await activate(page, '西安', { prefix: true });
await findSemantic(page, '陕西省，西安市', { prefix: true, timeout: 15000 });
console.log('PASSPORT XIAN = PASS');
await activate(page, '西安城墙', { prefix: false });
await waitStage(page, 1);
const journeyState = await visibleText(page);
if (!journeyState.includes('西安 · 城墙') || !journeyState.includes('周遥')) {
throw new Error("Xi'an City Wall Journey state not visible after Passport route");
}
console.log('PASSPORT XIAN CITY WALL = PASS');
}
function requireMarkers(text, markers, label) {
for (const marker of markers) {
if (!text.includes(marker)) throw new Error(`${label} missing marker: ${marker}`);
}
}
function requireNoPriorMarker(text, prior, label) {
if (!prior) return;
const stale = [...prior.story, ...prior.vi, ...prior.en]
.filter((marker) => marker.length >= 8)
.find((marker) => text.includes(marker));
if (stale) throw new Error(`${label} contains stale previous-level marker: ${stale}`);
}
async function openFirstStoryAnnotation(page) {
const notes = page.getByRole('button', { name: '注', exact: true });
const count = await notes.count();
if (count < 1) throw new Error('Story Reading Support 注 button not found');
await notes.first().evaluate((element) => element.click());
await findSemantic(page, '故事第 1 段', { timeout: 15000 });
await findSemantic(page, '拼音', { timeout: 15000 });
await findSemantic(page, '探索者母语 · 越南语', { timeout: 15000 });
await findSemantic(page, 'English', { timeout: 15000 });
}
async function closeReadingSupport(page) {
for (const label of ['关闭', 'Close']) {
if (await exists(page, label, { role: 'button', timeout: 500 })) {
await activate(page, label);
return;
}
}
await page.keyboard.press('Escape');
const deadline = Date.now() + 5000;
while (Date.now() < deadline) {
if (!(await exists(page, '故事第 1 段', { timeout: 250 }))) return;
await sleep(100);
}
throw new Error('Story Reading Support popup did not close');
}
async function verifyReadingSupport(page, level, prior, priorSupport) {
const storyText = await visibleText(page);
requireMarkers(storyText, expected[level].story, `Lv${level} CURRENT Story`);
requireNoPriorMarker(storyText, prior, `Lv${level} Story`);
await openFirstStoryAnnotation(page);
const supportText = await visibleText(page);
requireMarkers(supportText, expected[level].vi, `Lv${level} Vietnamese`);
requireMarkers(supportText, expected[level].en, `Lv${level} English`);
if (!/拼音[\s\S]*[A-Za-zĀÁǍÀāáǎàĒÉĚÈēéěèĪÍǏÌīíǐìŌÓǑÒōóǒòŪÚǓÙūúǔùǕǗǙǛǖǘǚǜ]/.test(supportText)) {
throw new Error(`Lv${level} Pinyin support is empty or malformed`);
}
if (priorSupport && supportText === priorSupport) {
throw new Error(`Lv${level} ReadingAnnotation reused previous-level support verbatim`);
}
requireNoPriorMarker(supportText, prior, `Lv${level} ReadingAnnotation`);
await closeReadingSupport(page);
return { storyText, supportText };
}
function storyVocabularyTrace(story, stageText) {
const ignore = new Set(['故事', '单词', '发现', '挑战', '记忆', '完成', '继续', '返回', '朗读', '查看', '中文难度']);
const words = [...new Set(stageText.match(/[\u3400-\u9fff]{2,8}/g) ?? [])];
return words.filter((word) => !ignore.has(word) && story.includes(word));
}
async function toVocabulary(page, level, storyText) {
await activate(page, '继续', { prefix: true });
await sleep(300);
if (!(await exists(page, '2/6', { prefix: true, timeout: 700 }))) {
if (await exists(page, 'Dismiss', { role: 'button', timeout: 700 })) {
await activate(page, 'Dismiss');
} else if (await exists(page, '关闭', { role: 'button', timeout: 700 })) {
await activate(page, '关闭');
} else {
await page.touchscreen.tap(22, 58);
}
}
await waitStage(page, 2);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Vocabulary level drift`);
const text = await visibleText(page);
if (!storyVocabularyTrace(storyText, text).length) {
throw new Error(`Lv${level} Vocabulary has no CURRENT Story trace`);
}
return text;
}
async function toDiscovery(page, level) {
await activate(page, '继续', { prefix: true });
await waitStage(page, 3);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Discovery level drift`);
const text = await visibleText(page);
requireMarkers(text, expected[level].discovery, `Lv${level} Discovery`);
return text;
}
async function toChallenge(page, level) {
await activate(page, '继续', { prefix: true });
await waitStage(page, 4);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Challenge level drift`);
await findSemantic(page, '提交第 1 / 3 次答案', {
role: 'button',
prefix: true,
timeout: 15000,
});
return visibleText(page);
}
async function challengeOptionTargets(page) {
const rs = await records(page);
const toTarget = (record) => ({
role: record.role,
label: clean(record.label),
text: recordText(record),
});
const lettered = rs
.filter((record) => {
if (!record.visible || record.disabled) return false;
const label = clean(record.label);
return /^[A-D]\s/.test(label) && /[\u3400-\u9fff]/.test(label);
})
.sort((left, right) => left.index - right.index);
if (lettered.length) return lettered.map(toTarget);
const excluded = [
'提交第', '朗读', '进入下一种挑战', '完成三连挑战', '再练重点项',
'继续留下回忆', '完成挑战后继续', '返回', 'Back', '查看 Lv.',
'提高当前难度', '降低当前难度', '短文复原', '语病修复', '补回句子',
'简 / 繁', '声线', '减速', '加速', '提示',
];
return rs
.filter((record) => {
if (!record.visible || record.disabled) return false;
const text = recordText(record);
if (text.length < 4 || !/[\u3400-\u9fff]/.test(text)) return false;
if (!['button', 'group'].includes(record.role)) return false;
return !excluded.some((item) => text.includes(item));
})
.sort((left, right) => right.area - left.area)
.map(toTarget);
}
async function requiredChallengeSelections(page) {
const text = await visibleText(page);
const match = text.match(/依次点击\s*(\d+)\s*句/);
return match ? Number(match[1]) : 1;
}
async function ensureGrammarSegment(page) {
const text = await visibleText(page);
if (!text.includes('第一步 · 点击有问题的部分')) return;
const segments = (await records(page))
.filter(
(record) =>
record.visible &&
!record.disabled &&
record.role === 'checkbox' &&
/[\u3400-\u9fff]/.test(recordText(record)),
)
.sort((left, right) => left.index - right.index);
if (!segments.length) throw new Error('grammar repair segment selector not found');
await page.locator('flt-semantics').nth(segments[0].index).evaluate((element) => element.click());
await sleep(120);
}
async function activateChallengeTarget(page, target) {
const matches = (await records(page))
.filter((record) => {
if (!record.visible || record.disabled) return false;
if (target.label) return clean(record.label) === target.label;
return record.role === target.role && recordText(record) === target.text;
})
.sort((left, right) => left.area - right.area);
if (!matches.length) throw new Error(`challenge option disappeared: ${target.label || target.text}`);
await page.locator('flt-semantics').nth(matches[0].index).evaluate((element) => element.click());
await sleep(120);
}
async function chooseOptions(page) {
await ensureGrammarSegment(page);
const count = await requiredChallengeSelections(page);
const targets = await challengeOptionTargets(page);
if (targets.length < count) throw new Error(`only ${targets.length} challenge options found; need ${count}`);
for (const target of targets.slice(0, count)) await activateChallengeTarget(page, target);
}
async function waitForNextChallenge(page) {
await findSemantic(page, '提交第 1 / 3 次答案', {
role: 'button',
prefix: true,
timeout: 12000,
});
}
async function resolveChallengeMode(page, modeIndex) {
for (let attempt = 1; attempt <= 3; attempt += 1) {
await chooseOptions(page);
await activate(page, '提交第', { prefix: true });
await sleep(500);
if (await exists(page, '进入下一种挑战', { role: 'button', timeout: 1200 })) {
await activate(page, '进入下一种挑战');
await waitForNextChallenge(page);
return;
}
if (await exists(page, '完成三连挑战', { role: 'button', timeout: 1200 })) {
await activate(page, '完成三连挑战');
await findSemantic(page, '继续留下回忆', {
role: 'button',
prefix: true,
timeout: 12000,
});
return;
}
if (attempt < 3) {
await findSemantic(page, `提交第 ${attempt + 1} / 3 次答案`, {
role: 'button',
prefix: true,
timeout: 5000,
});
}
}
throw new Error(`challenge mode ${modeIndex + 1} did not resolve`);
}
async function completeChallenge(page, level) {
for (let mode = 0; mode < 3; mode += 1) await resolveChallengeMode(page, mode);
await findSemantic(page, '继续留下回忆', {
role: 'button',
prefix: true,
timeout: 15000,
});
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Challenge completion level drift`);
}
async function toMemory(page, level, storyText) {
await activate(page, '继续留下回忆', { prefix: true });
await waitStage(page, 5);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Memory level drift`);
const text = await visibleText(page);
requireMarkers(text, ['永宁门', '跑表'], `Lv${level} Memory`);
if (!storyVocabularyTrace(storyText, text).length) {
throw new Error(`Lv${level} Memory has no CURRENT Story vocabulary trace`);
}
return text;
}
async function revisitStoryFromMemory(page, level, expectedStoryText, expectedSupportText, prior) {
for (let step = 0; step < 4; step += 1) {
await activate(page, '上一步', { prefix: true });
await sleep(200);
}
await waitStage(page, 1);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Story revisit level drift`);
const text = await visibleText(page);
requireMarkers(text, expected[level].story, `Lv${level} revisited Story`);
requireNoPriorMarker(text, prior, `Lv${level} revisited Story`);
await openFirstStoryAnnotation(page);
const supportText = await visibleText(page);
requireMarkers(supportText, expected[level].vi, `Lv${level} revisited Vietnamese`);
requireMarkers(supportText, expected[level].en, `Lv${level} revisited English`);
if (supportText !== expectedSupportText) {
throw new Error(`Lv${level} ReadingAnnotation changed after Story revisit`);
}
await closeReadingSupport(page);
if (!text.includes(expected[level].story[0]) || !expectedStoryText.includes(expected[level].story[0])) {
throw new Error(`Lv${level} Story revisit identity mismatch`);
}
}
async function forwardToMemoryAfterRevisit(page, level, storyText) {
await toVocabulary(page, level, storyText);
await toDiscovery(page, level);
await activate(page, '继续', { prefix: true });
await waitStage(page, 4);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Challenge revisit level drift`);
await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 15000 });
await activate(page, '继续留下回忆', { prefix: true });
await waitStage(page, 5);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Memory revisit level drift`);
}
async function toCompletion(page, level, storyText) {
await activate(page, '保存回忆并完成', { prefix: true });
await waitStage(page, 6);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Completion level drift`);
const text = await visibleText(page);
requireMarkers(text, ['西安已点亮', '永宁门', '回家'], `Lv${level} Completion`);
if (!storyVocabularyTrace(storyText, text).length) {
throw new Error(`Lv${level} Completion has no CURRENT Story vocabulary trace`);
}
return text;
}
async function restart(page) {
await activate(page, '重新体验', { prefix: true });
await waitStage(page, 1);
}
async function assertNoBlockingError(page, pageErrors, label) {
const text = await visibleText(page).catch(() => '');
const joined = `${text}\n${pageErrors.join('\n')}`;
for (const fatal of ['Unhandled Exception', 'A RenderFlex overflowed', 'Bad state:']) {
if (joined.includes(fatal)) throw new Error(`${label}: blocking runtime error: ${fatal}`);
}
}
async function runBrowser(browserName, browser, contextOptions) {
const context = await browser.newContext(contextOptions);
const page = await context.newPage();
const pageErrors = [];
const failedRequests = [];
page.on('pageerror', (error) => pageErrors.push(error?.stack || error?.message || String(error)));
page.on('requestfailed', (request) => {
failedRequests.push(`${request.url()} :: ${request.failure()?.errorText || 'failed'}`);
});
let prior = null;
let priorSupport = null;
try {
await requireStartup(page);
await openViaPassport(page);
for (let index = 0; index < levels.length; index += 1) {
const level = levels[index];
if (index > 0) await restart(page);
await setLevel(page, level);
await waitStage(page, 1);
if ((await currentLevel(page)) !== level) throw new Error(`Lv${level} Story level switch failed`);
const { storyText, supportText } = await verifyReadingSupport(
page,
level,
prior,
priorSupport,
);
await assertNoBlockingError(page, pageErrors, `${browserName} Lv${level} Story`);
console.log(`${browserName} Lv${level} STORY + READINGANNOTATION + CN/PINYIN/VI/EN = PASS`);
const vocabularyText = await toVocabulary(page, level, storyText);
requireNoPriorMarker(vocabularyText, prior, `${browserName} Lv${level} Vocabulary`);
console.log(`${browserName} Lv${level} VOCABULARY = PASS`);
const discoveryText = await toDiscovery(page, level);
requireNoPriorMarker(discoveryText, prior, `${browserName} Lv${level} Discovery`);
console.log(`${browserName} Lv${level} DISCOVERY = PASS`);
const challengeText = await toChallenge(page, level);
requireNoPriorMarker(challengeText, prior, `${browserName} Lv${level} Challenge`);
await completeChallenge(page, level);
console.log(`${browserName} Lv${level} CHALLENGE = PASS`);
const memoryText = await toMemory(page, level, storyText);
requireNoPriorMarker(memoryText, prior, `${browserName} Lv${level} Memory`);
console.log(`${browserName} Lv${level} MEMORY = PASS`);
await revisitStoryFromMemory(page, level, storyText, supportText, prior);
console.log(`${browserName} Lv${level} STORY REVISIT + LEVEL STABILITY = PASS`);
await forwardToMemoryAfterRevisit(page, level, storyText);
const completionText = await toCompletion(page, level, storyText);
requireNoPriorMarker(completionText, prior, `${browserName} Lv${level} Completion`);
console.log(`${browserName} Lv${level} COMPLETION = PASS`);
console.log(`${browserName} Lv${level} SIX-STAGE = PASS`);
prior = expected[level];
priorSupport = supportText;
}
const blockingRequests = failedRequests.filter(
(entry) => !entry.includes('favicon') && !entry.includes('analytics'),
);
if (blockingRequests.length) {
throw new Error(`${browserName} blocking failed requests: ${blockingRequests.join(' || ')}`);
}
if (pageErrors.length) {
throw new Error(`${browserName} page errors: ${pageErrors.join(' || ')}`);
}
console.log(`${browserName} XIAN CITY WALL DEPLOYED BROWSER = PASS | SHA=${sourceSha}`);
} catch (error) {
console.error(`${browserName} XIAN CITY WALL DEPLOYED BROWSER = FAIL`);
console.error(`CURRENT URL = ${page.url()}`);
console.error(`CURRENT LEVEL = ${await currentLevel(page).catch(() => 'unknown')}`);
console.error(`SEMANTICS = ${(await visibleText(page).catch(() => '')).slice(0, 16000)}`);
console.error(`PAGE ERRORS = ${JSON.stringify(pageErrors)}`);
console.error(`FAILED REQUESTS = ${JSON.stringify(failedRequests)}`);
throw error;
} finally {
await context.close();
}
}
const chromiumBrowser = await chromium.launch({ headless: true });
try {
await runBrowser('DESKTOP CHROMIUM', chromiumBrowser, {
viewport: { width: 1280, height: 900 },
locale: 'zh-CN',
reducedMotion: 'reduce',
});
} finally {
await chromiumBrowser.close();
}
const webkitBrowser = await webkit.launch({ headless: true });
try {
await runBrowser('IPHONE WEBKIT', webkitBrowser, {
...devices['iPhone 13'],
locale: 'zh-CN',
reducedMotion: 'reduce',
});
} finally {
await webkitBrowser.close();
}
console.log(`XIAN CITY WALL DEPLOYED BROWSER ACCEPTANCE = PASS | SHA=${sourceSha} | LEVELS=${levels.join(',')}`);
