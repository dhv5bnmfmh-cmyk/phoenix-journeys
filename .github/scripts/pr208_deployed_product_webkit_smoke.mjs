import { pathToFileURL } from 'node:url';
import { returnToExplore, setConfiguredLevel } from './journey_level_session_harness.mjs';

const { webkit, devices } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sha = process.argv[3];
if (!baseUrl || !sha) throw new Error('usage: smoke <url> <sha>');
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function records(page) {
  return page.locator('flt-semantics').evaluateAll((nodes) => nodes.map((node, index) => {
    const rect = node.getBoundingClientRect();
    return { index, role: node.getAttribute('role') || '', text: [node.getAttribute('aria-label'), node.textContent].filter(Boolean).join(' ').replace(/\s+/g, ' ').trim(), disabled: node.getAttribute('aria-disabled') === 'true', x: rect.x, y: rect.y, width: rect.width, height: rect.height, visible: rect.width > 0 && rect.height > 0 };
  }));
}
async function find(page, needle, { role, exact = false, timeout = 15000 } = {}) {
  const end = performance.now() + timeout;
  while (performance.now() < end) {
    const found = (await records(page)).filter((x) => x.visible && (!role || x.role === role) && (exact ? x.text === needle : x.text.includes(needle))).sort((a,b) => a.width*a.height-b.width*b.height)[0];
    if (found) return found;
    await sleep(80);
  }
  throw new Error(`visible state missing: ${needle}`);
}
async function tap(page, text, options = {}) {
  const x = await find(page, text, { ...options, role: 'button' });
  if (x.disabled) throw new Error(`disabled: ${text}`);
  await page.locator('flt-semantics').nth(x.index).tap();
}
async function openStory(page, level, title) {
  await page.goto(`${baseUrl}/?unlock=all&prototype=journeys&v=${sha}`, { waitUntil: 'domcontentloaded', timeout: 60000 });
  const placeholder = page.locator('flt-semantics-placeholder').first();
  await placeholder.waitFor({ state: 'attached', timeout: 60000 });
  await placeholder.evaluate((node) => node.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
  await setConfiguredLevel(page, level);
  await returnToExplore(page);
  await tap(page, '护照'); await tap(page, '中国', { exact: true });
  await tap(page, '北京市', { exact: true }); await tap(page, '故宫博物院');
  await tap(page, title);
  await find(page, '1/5');
  const narration = (await records(page)).filter((x) => x.visible && x.role === 'button' && x.text.includes('开始朗读')).sort((a,b)=>a.width*a.height-b.width*b.height)[0];
  if (!narration) throw new Error('narration control missing');
  await page.touchscreen.tap(narration.x + narration.width * .535, narration.y + Math.min(22, narration.height / 2));
  await find(page, '正在朗读');
  const button = await find(page, '继续', { role: 'button' });
  const started = performance.now();
  await page.locator('flt-semantics').nth(button.index).tap();
  await find(page, '下一个单词', { timeout: 3000 }).catch(() => find(page, '完成并收起', { timeout: 3000 }));
  const elapsed = performance.now() - started;
  if (elapsed >= 3000) throw new Error(`${title} Lv${level} Word Detail ${elapsed}ms`);
  await page.evaluate(() => new Promise((resolve) => requestAnimationFrame(() => resolve())));
  return elapsed;
}

const browser = await webkit.launch({ headless: true });
const results = [];
for (const spec of [{ level: 5, title: '交接前的标记' }, { level: 6, title: '交接前的标记' }, { level: 6, title: '两条路，一张图' }]) {
  const context = await browser.newContext({ ...devices['iPhone 13 Pro Max'] });
  await context.addInitScript(() => {
    class U extends EventTarget { constructor(text) { super(); this.text=text; this.lang=''; this.rate=1; this.pitch=1; this.volume=1; } }
    const synth={ speaking:false, pending:false, paused:false, getVoices:()=>[], speak(u){this.speaking=true;setTimeout(()=>u.dispatchEvent(new Event('start')),0);}, cancel(){this.speaking=false;}, pause(){this.paused=true;}, resume(){this.paused=false;this.speaking=true;} };
    Object.defineProperty(window,'SpeechSynthesisUtterance',{configurable:true,value:U});
    Object.defineProperty(window,'speechSynthesis',{configurable:true,value:synth});
  });
  const page = await context.newPage();
  results.push({ ...spec, wordDetailMs: await openStory(page, spec.level, spec.title) });
  await context.close();
}
await browser.close();
console.log(`DEPLOYED_WEBKIT_SMOKE ${JSON.stringify({ sha, results })}`);
