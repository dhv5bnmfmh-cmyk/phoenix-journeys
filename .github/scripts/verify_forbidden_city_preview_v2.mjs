import { pathToFileURL } from 'node:url';
import { resolve } from 'node:path';
import {
  assertNoJourneyLiveControls,
  journeySessionLevel,
  returnToExplore,
  saveMemoryAndWaitCommitted,
  setConfiguredLevel,
  tapSemanticChoice,
} from './journey_level_session_harness.mjs';

const { chromium } = await import(pathToFileURL(process.env.PLAYWRIGHT_PATH).href);
const baseUrl = process.argv[2];
const sourceSha = process.argv[3];
const grammarOnly = process.argv[4] === 'grammar-only';
if (!baseUrl || !sourceSha) throw new Error('usage: verify_forbidden_city_preview_v2.mjs <preview-url> <sha>');

const levels = [5];
const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
const clean = (value) => String(value ?? '').replace(/\s+/g, ' ').trim();
const photoFixture = resolve('app/assets/images/phoenix-flight-cycle-v2.webp');

async function records(page) {
  return page.locator('flt-semantics').evaluateAll((els) => els.map((el, index) => {
    const r = el.getBoundingClientRect();
    const s = getComputedStyle(el);
    return {
      index,
      role: el.getAttribute('role'),
      label: el.getAttribute('aria-label') || '',
      value: el.getAttribute('aria-valuetext') || '',
      description: el.getAttribute('aria-description') || '',
      text: String(el.textContent || '').replace(/\s+/g, ' ').trim(),
      disabled: el.getAttribute('aria-disabled') === 'true',
      visible: r.width > 0 && r.height > 0 && s.display !== 'none' && s.visibility !== 'hidden',
      y: r.y,
      area: r.width * r.height,
    };
  }));
}

const recText = (r) => clean([r.label, r.value, r.description, r.text].filter(Boolean).join(' '));

async function findSemantic(page, needle, { role = null, prefix = false, exact = false, timeout = 15000 } = {}) {
  const deadline = Date.now() + timeout;
  const wanted = clean(needle);
  while (Date.now() < deadline) {
    const rs = await records(page);
    const matches = rs.filter((r) => {
      if (!r.visible || (role && r.role !== role)) return false;
      const text = recText(r);
      return exact ? text === wanted : (prefix ? text.startsWith(wanted) : text.includes(wanted));
    }).sort((a, b) => {
      if (a.role === 'button' && b.role !== 'button') return -1;
      if (b.role === 'button' && a.role !== 'button') return 1;
      return a.area - b.area;
    });
    if (matches.length) return page.locator('flt-semantics').nth(matches[0].index);
    await sleep(100);
  }
  throw new Error(`semantic state not found: ${needle}`);
}

async function exists(page, needle, options = {}) {
  try {
    await findSemantic(page, needle, { ...options, timeout: options.timeout ?? 500 });
    return true;
  } catch (_) {
    return false;
  }
}

async function tapButton(page, needle, { prefix = false, exact = false, timeout = 15000 } = {}) {
  const deadline = Date.now() + timeout;
  let lastError = null;
  while (Date.now() < deadline) {
    const remaining = Math.max(250, deadline - Date.now());
    try {
      const node = await findSemantic(page, needle, {
        role: 'button',
        prefix,
        exact,
        timeout: Math.min(1500, remaining),
      });
      const disabled = await node.getAttribute('aria-disabled', { timeout: Math.min(750, remaining) });
      if (disabled === 'true') throw new Error(`button disabled: ${needle}`);
      await node.tap({ timeout: Math.min(2000, remaining) });
      return;
    } catch (error) {
      if (String(error?.message || error).includes(`button disabled: ${needle}`)) throw error;
      if (!(await exists(page, needle, { role: 'button', prefix, exact, timeout: 200 }))) return;
      lastError = error;
      await sleep(100);
    }
  }
  throw lastError ?? new Error(`button not tappable: ${needle}`);
}

async function visibleText(page) {
  return (await records(page)).filter((r) => r.visible).map(recText).filter(Boolean).join('\n');
}

async function enableSemantics(page) {
  const placeholder = page.locator('flt-semantics-placeholder').first();
  if (await placeholder.count()) await placeholder.evaluate((el) => el.click());
  await page.locator('flt-semantics').first().waitFor({ state: 'attached', timeout: 30000 });
}

async function currentSessionLevel(page) {
  return journeySessionLevel(page);
}

async function waitStage(page, n) {
  await findSemantic(page, `${n}/6`, { prefix: true, timeout: 20000 });
}

async function openForbiddenCity(page) {
  if (await exists(page, '北京 · 紫禁城', { timeout: 600 })) {
    if (!(await exists(page, '1/6', { prefix: true, timeout: 600 }))) {
      throw new Error('Forbidden City title is visible without Story stage');
    }
    return;
  }

  await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 30000 });
  await tapButton(page, '选择城市', { prefix: true });
  await findSemantic(page, '选择城市与地点', { timeout: 15000 });
  await tapSemanticChoice(page, '北京', { expectedText: '北京的地点' });
  await findSemantic(page, '北京的地点', { timeout: 15000 });
  await tapSemanticChoice(page, '紫禁城', { absentText: '北京的地点' });

  for (let i = 0; i < 100; i += 1) {
    if (await exists(page, '1/6', { prefix: true, timeout: 120 })) return;
    if (await exists(page, 'PHOENIX JOURNEYS', { timeout: 120 })) break;
    await sleep(100);
  }

  if (await exists(page, 'PHOENIX JOURNEYS', { timeout: 1000 })) {
    for (const action of ['开始', '继续', '再次探索']) {
      if (await exists(page, action, { role: 'button', prefix: true, timeout: 700 })) {
        await tapButton(page, action, { prefix: true });
        await waitStage(page, 1);
        return;
      }
    }
  }
  throw new Error('Forbidden City did not open after destination selection');
}

function requireStoryIdentity(text, level) {
  for (const marker of ['沈砚', '阿宁']) {
    if (!text.includes(marker)) throw new Error(`Lv${level} Story missing ${marker}`);
  }
  if (!text.includes('中轴') && !text.includes('午门')) throw new Error(`Lv${level} Story missing Forbidden City spatial mechanism`);
  if (!text.includes('路线') && !text.includes('两条线')) throw new Error(`Lv${level} Story missing route mechanism`);
  if (level === 3 && !text.includes('判断')) throw new Error('Lv3 Story must contain 判断 at its first appearance');
  if (level === 5 && !text.includes('证据')) throw new Error('Lv5 Story must contain 证据 at its first appearance');
}

function traceVocabulary(story, vocabulary) {
  const ignore = new Set(['故事', '单词', '发现', '挑战', '继续', '返回', '朗读', '查看', '中文难度', '重点词汇']);
  const words = [...new Set(vocabulary.match(/[\u3400-\u9fff]{2,6}/g) ?? [])];
  return words.filter((w) => !ignore.has(w) && story.includes(w));
}

async function nextToVocabulary(page, level, storyText) {
  await tapButton(page, '继续', { prefix: true });
  await sleep(400);
  if (!(await exists(page, '2/6', { prefix: true, timeout: 700 }))) {
    await page.touchscreen.tap(22, 58);
  }
  await waitStage(page, 2);
  if ((await currentSessionLevel(page)) !== level) throw new Error(`Lv${level} Vocabulary level drift`);
  const text = await visibleText(page);
  const traced = traceVocabulary(storyText, text);
  if (!traced.length) throw new Error(`Lv${level} Vocabulary has no visible same-level Story trace`);
}

async function nextToDiscovery(page, level) {
  await tapButton(page, '继续', { prefix: true });
  await waitStage(page, 3);
  if ((await currentSessionLevel(page)) !== level) throw new Error(`Lv${level} Discovery level drift`);
  const text = await visibleText(page);
  const hasSpecificSpatialAnchor = ['中轴', '宫门', '院落', '景运门', '乾清门', '外朝', '内廷']
    .some((w) => text.includes(w));
  const hasCausalSpatialMechanism = text.includes('沈砚') &&
    text.includes('阿宁') &&
    text.includes('建筑') &&
    text.includes('路线') &&
    (text.includes('连接') || text.includes('共同节点'));
  const hasLv10TransferSpatialMechanism = level === 10 &&
    text.includes('建筑') &&
    text.includes('连接') &&
    text.includes('路线') &&
    text.includes('人物目标') &&
    text.includes('行动后果');
  if (!hasSpecificSpatialAnchor && !hasCausalSpatialMechanism && !hasLv10TransferSpatialMechanism) {
    throw new Error(`Lv${level} Discovery missing Forbidden City spatial content`);
  }
}

async function nextToChallenge(page, level) {
  await tapButton(page, '继续', { prefix: true });
  await waitStage(page, 4);
  if ((await currentSessionLevel(page)) !== level) throw new Error(`Lv${level} Challenge level drift`);
  await findSemantic(page, '挑战 1/12', { timeout: 15000 });
}

async function firstHskChoice(page) {
  const rs = await records(page);
  const visibleAll = rs.filter((r) => r.visible);
  const visible = visibleAll.filter((r) => !r.disabled);
  const excluded = ['提交', '下一题', '完成挑战', '撤销', '重置', '朗读', '返回', 'Back'];
  const submit = visibleAll
    .filter((r) => r.role === 'button' && (recText(r).startsWith('提交') || recText(r) === '确认位置'))
    .sort((a, b) => a.area - b.area)[0];
  const prompt = visibleAll
    .filter((r) => r.role !== 'button' && (
      recText(r).includes('STEP 1 · 哪里错？')
      || recText(r).includes('STEP 2 · 怎么改？')
      || recText(r).includes('____')
    ))
    .sort((a, b) => a.area - b.area)[0];
  if (!submit || !prompt) throw new Error('HSK challenge prompt/submit boundary not found');

  const choices = visible.filter((r) => {
    if (!['button', 'checkbox'].includes(r.role)) return false;
    const text = recText(r);
    if (!/[\u3400-\u9fff]/.test(text)) return false;
    if (excluded.some((item) => text.startsWith(item))) return false;
    return r.y >= prompt.y && r.y < submit.y;
  }).sort((a, b) => a.y - b.y || a.area - b.area || a.index - b.index);
  if (!choices.length) throw new Error('HSK challenge choice not found inside question boundary');

  console.log(`HSK CHOICE TAP = ${recText(choices[0])}`);
  await page.locator('flt-semantics').nth(choices[0].index).tap({ timeout: 10000 });
  await page.evaluate(() => new Promise((resolve) => {
    requestAnimationFrame(() => requestAnimationFrame(resolve));
  }));
  await sleep(75);
}

function hanOnly(value) {
  return String(value ?? '').replace(/[^\u3400-\u9fff]/g, '');
}

async function visibleRebuildTiles(page) {
  const rs = await records(page);
  const prompt = rs
    .filter((r) => r.visible && recText(r).includes('复原一条与北京 · 紫禁城相关的知识句'))
    .sort((a, b) => a.area - b.area)[0];
  const undo = rs
    .filter((r) => r.visible && r.role === 'button' && recText(r) === '撤销')
    .sort((a, b) => a.area - b.area)[0];
  if (!prompt || !undo) throw new Error('rebuild tile boundary missing');
  return rs.filter((r) => {
    if (!r.visible || r.disabled || !['button', 'checkbox'].includes(r.role)) return false;
    const text = recText(r);
    if (!/[\u3400-\u9fff]/.test(text)) return false;
    return r.y >= prompt.y && r.y < undo.y;
  }).sort((a, b) => a.y - b.y || a.index - b.index);
}

function recoverRebuildAnswer(displayed, modeIndex) {
  if (displayed.length < 2) throw new Error('rebuild semantic chunks missing');
  const shift = (modeIndex + 1) % displayed.length;
  const unrotated = [
    ...displayed.slice(displayed.length - shift),
    ...displayed.slice(0, displayed.length - shift),
  ];
  return [...unrotated].reverse();
}

async function solveRebuild(page, modeIndex, level) {
  const tiles = await visibleRebuildTiles(page);
  const displayed = tiles.map((r) => recText(r));
  if (level === 5) {
    const answer = recoverRebuildAnswer(displayed, modeIndex).join('');
    if (hanOnly(answer).length < 10 || hanOnly(answer).length > 30) {
      throw new Error(
        'Lv5 rebuild learning sentence length is outside 10-30 Han characters',
      );
    }
    if (displayed.every((tile) => hanOnly(tile).length === 1)) {
      throw new Error('Lv5 rebuild still uses all single-character tiles');
    }
    for (const proper of ['紫禁城', '乾清门', '午门', '故宫博物院']) {
      if (answer.includes(proper) && !displayed.some((tile) => tile.includes(proper))) {
        throw new Error(`Lv5 rebuild split protected proper noun: ${proper}`);
      }
    }
  }

  const ordered = recoverRebuildAnswer(displayed, modeIndex);
  for (const text of ordered) {
    const rs = await records(page);
    const target = rs
      .filter((r) => r.visible && !r.disabled && ['button', 'checkbox'].includes(r.role) && recText(r) === text)
      .sort((a, b) => a.y - b.y || a.index - b.index)[0];
    if (!target) throw new Error(`rebuild tile disappeared: ${text}`);
    await page.locator('flt-semantics').nth(target.index).tap({ timeout: 10000 });
    await sleep(80);
    const afterTap = await visibleText(page);
    if (!afterTap.includes(text)) {
      throw new Error(`built rebuild tile text became invisible after selection: ${text}`);
    }
  }
  if (level === 5) {
    await page.screenshot({
      path: `test-results/lv5-rebuild-built-${modeIndex + 1}.png`,
      fullPage: false,
    });
  }
}

async function fillCompletionBlanks(page, level) {
  for (let blank = 1; blank <= level; blank += 1) {
    await findSemantic(page, `空位 ${blank}/${level}`, { timeout: 5000 });
    await firstHskChoice(page);
  }
}

async function advanceGrammarToStep2(page) {
  if (!(await exists(page, 'STEP 1 · 哪里错？', { timeout: 1000 }))) {
    throw new Error('HSK grammar state drift before STEP 1 confirmation');
  }

  await firstHskChoice(page);
  await tapButton(page, '确认位置', { exact: true });
  const locationCorrect = await exists(page, '位置正确', { timeout: 1500 });
  const locationWrong = locationCorrect
    ? false
    : await exists(page, '位置错误', { timeout: 1500 });
  if (!locationCorrect && !locationWrong) {
    throw new Error('HSK grammar STEP 1 did not show location feedback');
  }
  await findSemantic(page, 'STEP 1 · 哪里错？', { timeout: 1000 });
  if (await exists(page, 'STEP 2 · 怎么改？', { timeout: 300 })) {
    throw new Error('HSK grammar auto-advanced before explicit continue');
  }
  if (locationWrong) {
    await findSemantic(page, '正确错误位置：', { timeout: 1000 });
    await findSemantic(page, '本身在这个句子里语法成立', { timeout: 1000 });
    await findSemantic(page, '真正的问题：', { timeout: 1000 });
  } else {
    await findSemantic(page, '为什么这里错：', { timeout: 1000 });
  }
  await findSemantic(page, '语法点：', { timeout: 1000 });
  await tapButton(page, '继续修改', { exact: true });
  await findSemantic(page, 'STEP 2 · 怎么改？', { timeout: 1500 });
}

async function completeHskChallenge(page, level) {
  for (let question = 1; question <= 12; question += 1) {
    await findSemantic(page, `挑战 ${question}/12`, { timeout: 15000 });
    await findSemantic(page, '朗读当前题目', { role: 'button', exact: true, timeout: 5000 });
    const before = await visibleText(page);
    const modeIndex = (question - 1) % 4;

    if (before.includes('句子复原')) {
      await solveRebuild(page, modeIndex, level);
    } else if (before.includes('语病修复')) {
      await findSemantic(page, '有语病的完整句子', { timeout: 5000 });
      await findSemantic(page, 'STEP 1 · 哪里错？', { timeout: 5000 });
      await advanceGrammarToStep2(page);
      await findSemantic(page, 'STEP 2 · 怎么改？', { timeout: 5000 });
      await firstHskChoice(page);
    } else if (before.includes('补全故事')) {
      if (before.includes('选择能补回这里的完整句')) {
        throw new Error('completion fourth-question legacy mechanic still visible');
      }
      await fillCompletionBlanks(page, level);
    }

    await tapButton(page, '提交', { prefix: true });
    await findSemantic(page, '正确答案：', { timeout: 5000 });
    const after = await visibleText(page);
    for (const marker of before.includes('句子复原')
      ? ['句子复原', '复原一条与北京 · 紫禁城相关的知识句']
      : before.includes('语病修复')
        ? ['语病修复', '有语病的完整句子']
        : ['补全故事']) {
      if (!after.includes(marker)) {
        throw new Error(`challenge body replaced after inline feedback: ${marker}`);
      }
    }
    await findSemantic(page, after.includes('回答正确') ? '回答正确' : '回答错误', { timeout: 5000 });
    if (before.includes('语病修复')) {
      await findSemantic(page, '修改错误', { timeout: 5000 });
      await findSemantic(page, '为什么不对：', { timeout: 5000 });
      await findSemantic(page, '修改原则：', { timeout: 5000 });
    }
    if (after.includes('回答错误')) {
      const explicitMarker = before.includes('句子复原')
        ? '位置错误'
        : before.includes('语病修复')
          ? '错误位置'
          : '填错';
      await findSemantic(page, explicitMarker, { timeout: 5000 });
    }
    if (grammarOnly && question === 8) {
      console.log('Lv5 GRAMMAR 4/4 EXPLANATION TARGETED = PASS');
      return;
    }
    await tapButton(
      page,
      question === 12 ? '完成挑战' : '下一题',
      question === 12 ? { exact: true } : { prefix: true },
    );
  }
  await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 15000 });
  if ((await currentSessionLevel(page)) !== level) throw new Error(`Lv${level} Challenge completion level drift`);
}

async function challengeOptionTargets(page) {
  const rs = await records(page);
  const toTarget = (r) => ({ role: r.role, label: clean(r.label), text: recText(r) });
  const lettered = rs.filter((r) => {
    if (!r.visible || r.disabled) return false;
    const label = clean(r.label);
    return /^[A-D]\s/.test(label) && /[\u3400-\u9fff]/.test(label);
  }).sort((a, b) => a.index - b.index);
  if (lettered.length) return lettered.map(toTarget);

  const excluded = [
    '提交第', '朗读', '进入下一种挑战', '完成三连挑战', '再练重点项', '继续留下回忆',
    '完成挑战后继续', '返回', 'Back',
    '短文复原', '语病修复', '补回句子', '简 / 繁', '声线', '减速', '加速', '提示',
  ];
  return rs.filter((r) => {
    if (!r.visible || r.disabled) return false;
    const text = recText(r);
    if (text.length < 4 || !/[\u3400-\u9fff]/.test(text)) return false;
    if (!['button', 'group'].includes(r.role)) return false;
    return !excluded.some((x) => text.includes(x));
  }).sort((a, b) => b.area - a.area).map(toTarget);
}

async function requiredChallengeSelections(page) {
  const text = await visibleText(page);
  const match = text.match(/依次点击\s*(\d+)\s*句/);
  if (match) return Number(match[1]);
  return 1;
}

async function ensureGrammarSegment(page) {
  const text = await visibleText(page);
  if (!text.includes('第一步 · 点击有问题的部分')) return;
  const rs = await records(page);
  const segments = rs.filter((r) =>
    r.visible && !r.disabled && r.role === 'checkbox' && /[\u3400-\u9fff]/.test(recText(r))
  ).sort((a, b) => a.index - b.index);
  if (!segments.length) throw new Error('grammar repair segment selector not found');
  await page.locator('flt-semantics').nth(segments[0].index).tap({ timeout: 10000 });
  await sleep(120);
}

async function tapChallengeTarget(page, target) {
  const rs = await records(page);
  const matches = rs.filter((r) => {
    if (!r.visible || r.disabled) return false;
    if (target.label) return clean(r.label) === target.label;
    return r.role === target.role && recText(r) === target.text;
  }).sort((a, b) => a.area - b.area);
  if (!matches.length) throw new Error(`challenge option target disappeared: ${target.label || target.text}`);
  await page.locator('flt-semantics').nth(matches[0].index).tap({ timeout: 10000 });
  await sleep(120);
}

async function chooseOptions(page) {
  await ensureGrammarSegment(page);
  const count = await requiredChallengeSelections(page);
  const targets = await challengeOptionTargets(page);
  if (targets.length < count) throw new Error(`only ${targets.length} challenge options found; need ${count}`);
  for (const target of targets.slice(0, count)) {
    await tapChallengeTarget(page, target);
  }
}

async function waitForNextChallenge(page) {
  await findSemantic(page, '提交第 1 / 3 次答案', { role: 'button', prefix: true, timeout: 12000 });
}

async function resolveChallengeMode(page, modeIndex) {
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    await chooseOptions(page);
    await tapButton(page, '提交第', { prefix: true });
    await sleep(500);

    if (await exists(page, '进入下一种挑战', { role: 'button', timeout: 1200 })) {
      await tapButton(page, '进入下一种挑战');
      await waitForNextChallenge(page);
      return;
    }
    if (await exists(page, '完成三连挑战', { role: 'button', timeout: 1200 })) {
      await tapButton(page, '完成三连挑战');
      await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 12000 });
      return;
    }

    if (attempt < 3) {
      await findSemantic(page, `提交第 ${attempt + 1} / 3 次答案`, { role: 'button', prefix: true, timeout: 5000 });
    }
  }
  throw new Error(`challenge mode ${modeIndex + 1} did not resolve`);
}

async function completeChallenge(page, level) {
  if (await exists(page, '挑战 1/12', { timeout: 600 })) {
    await completeHskChallenge(page, level);
    return;
  }
  for (let mode = 0; mode < 3; mode += 1) await resolveChallengeMode(page, mode);
  await findSemantic(page, '继续留下回忆', { role: 'button', prefix: true, timeout: 15000 });
  if ((await currentSessionLevel(page)) !== level) throw new Error(`Lv${level} Challenge completion level drift`);
}

async function nextToMemory(page, level) {
  await tapButton(page, '继续留下回忆', { prefix: true });
  await waitStage(page, 5);
  if ((await currentSessionLevel(page)) !== level) throw new Error(`Lv${level} Memory level drift`);
  const text = await visibleText(page);
  await findSemantic(page, '这段旅程，你最想留下什么？', { timeout: 5000 });
  await findSemantic(page, '添加照片', { role: 'button', exact: true, timeout: 5000 });
  await page.getByRole('textbox').first().waitFor({ state: 'attached', timeout: 5000 });
  await findSemantic(page, '结束旅程', { role: 'button', exact: true, timeout: 5000 });
  if (text.includes('Journey Summary') || text.includes('Memory Anchor')) {
    throw new Error(`Lv${level} Memory still exposes Phoenix-generated summary`);
  }
  if (level === 5) {
    await page.getByRole('textbox').first().fill('第一次完成紫禁城双路线探索');
    const [chooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      tapButton(page, '添加照片', { prefix: true }),
    ]);
    await chooser.setFiles(photoFixture);
    await findSemantic(page, '已添加 1 张照片', { timeout: 15000 });
  }
}

async function nextToCompletion(page, level) {
  await tapButton(page, '结束旅程', { prefix: true });
  await waitStage(page, 6);
  await findSemantic(page, 'Journey Completion', { exact: true, timeout: 15000 });
  await findSemantic(page, '返回首页', { role: 'button', exact: true, timeout: 15000 });
  if ((await currentSessionLevel(page)) !== level) throw new Error(`Lv${level} Completion level drift`);
  const text = await visibleText(page);
  if (!text.includes('北京') || !text.includes('紫禁城')) {
    throw new Error(`Lv${level} Completion Beijing / Forbidden City identity missing`);
  }
  if (!text.includes('路线') && !text.includes('两条')) {
    throw new Error(`Lv${level} Completion route closure missing`);
  }
}

async function openMemoryTimeline(page) {
  if (await exists(page, '北京 · 紫禁城', { role: 'button', timeout: 800 })) return;

  if (await exists(page, '返回首页', { role: 'button', prefix: true, timeout: 800 })) {
    await tapButton(page, '返回首页', { prefix: true });
    await findSemantic(page, 'PHOENIX JOURNEYS', { timeout: 15000 });
  }

  if (!(await exists(page, '回忆时间轴', { role: 'button', prefix: true, timeout: 800 }))) {
    await tapButton(page, '我的', { prefix: true });
  }

  await findSemantic(page, '回忆时间轴', { role: 'button', prefix: true, timeout: 15000 });
  await tapButton(page, '回忆时间轴', { prefix: true });
  await findSemantic(page, '北京 · 紫禁城', { role: 'button', timeout: 15000 });
}

async function openMemoryDetail(page) {
  await openMemoryTimeline(page);
  const card = await findSemantic(page, '北京 · 紫禁城', { role: 'button', timeout: 15000 });
  await card.evaluate((el) => el.click());
  await findSemantic(page, '当前回忆保存在此设备。', { timeout: 15000 });
}

async function committedMemoryCardState(page) {
  const card = await findSemantic(page, '北京 · 紫禁城', { role: 'button', timeout: 15000 });
  const cardText = clean(await card.evaluate((el) => [
    el.getAttribute('aria-label'),
    el.getAttribute('aria-valuetext'),
    el.getAttribute('aria-description'),
    el.textContent,
  ].filter(Boolean).join(' ')));
  for (const marker of ['修改后的紫禁城回忆', '我来过这里']) {
    if (!cardText.includes(marker)) throw new Error(`Memory timeline card missing ${marker}`);
  }
  return { cardText };
}

async function durableMemoryState(page, { expectPhoto }) {
  const snapshot = await page.evaluate(({ keyHint, journeyId }) => {
    const decode = (raw) => {
      let value = raw;
      for (let depth = 0; depth < 4 && typeof value === 'string'; depth += 1) {
        try {
          value = JSON.parse(value);
        } catch (_) {
          break;
        }
      }
      return value;
    };

    const matches = [];
    for (let index = 0; index < localStorage.length; index += 1) {
      const key = localStorage.key(index);
      if (!key || !key.includes(keyHint)) continue;
      const raw = localStorage.getItem(key);
      const decoded = decode(raw);
      const entries = Array.isArray(decoded) ? decoded : [];
      const entry = entries.find((candidate) =>
        candidate &&
        candidate.journeyId === journeyId &&
        candidate.legacy !== true
      );
      matches.push({ key, entry: entry ?? null });
    }

    return {
      candidates: matches.map((match) => match.key),
      match: matches.find((candidate) => candidate.entry != null) ?? null,
    };
  }, {
    keyHint: 'journeyMemory.entries.v1',
    journeyId: 'beijing-forbidden-city',
  });

  if (!snapshot.match) {
    throw new Error(`durable Memory metadata missing beijing-forbidden-city; keys=${snapshot.candidates.join(',')}`);
  }

  const { key, entry } = snapshot.match;
  const note = clean(entry.updatedNote || entry.initialNote);
  const visitNote = clean(entry.visitNote);
  const photoRefs = Array.isArray(entry.photoRefs) ? entry.photoRefs : null;

  if (!key.includes('journeyMemory.entries.v1')) {
    throw new Error(`unexpected durable Memory key: ${key}`);
  }
  if (note !== '修改后的紫禁城回忆') {
    throw new Error(`durable Memory note mismatch: ${note}`);
  }
  if (visitNote !== '雨后的红墙很安静') {
    throw new Error(`durable Memory visit note mismatch: ${visitNote}`);
  }
  if (entry.isVisited !== true) {
    throw new Error('durable Memory isVisited mismatch');
  }
  if (photoRefs == null) {
    throw new Error('durable Memory photoRefs is not an array');
  }
  if (expectPhoto ? photoRefs.length === 0 : photoRefs.length !== 0) {
    throw new Error(`durable Memory photoRefs mismatch: ${JSON.stringify(photoRefs)}`);
  }

  return {
    key,
    journeyId: entry.journeyId,
    note,
    visitNote,
    isVisited: entry.isVisited,
    photoRefs,
  };
}

async function validateLivingMemoryPersistence(page) {
  await openMemoryDetail(page);

  const fields = page.getByRole('textbox');
  const noteField = page.getByRole('textbox', { name: /我的回忆/ }).first();
  await (await noteField.count() ? noteField : fields.first()).fill('修改后的紫禁城回忆');

  const visited = await findSemantic(page, '我真的来到这里了', { timeout: 5000 });
  await visited.tap({ timeout: 10000 });
  await findSemantic(page, '到访日期', { timeout: 5000 });

  const visitField = page.getByRole('textbox', { name: /现场感受/ }).first();
  const allFields = await page.getByRole('textbox').all();
  await (await visitField.count() ? visitField : allFields[allFields.length - 1]).fill('雨后的红墙很安静');

  await findSemantic(page, '删除照片', { role: 'button', timeout: 5000 });
  await tapButton(page, '删除照片', { prefix: true });

  await saveMemoryAndWaitCommitted(page, {
    reopenCommittedState: async () => {
      await committedMemoryCardState(page);
    },
    readCommittedState: () => durableMemoryState(page, { expectPhoto: false }),
  });

  await page.reload({ waitUntil: 'load', timeout: 140000 });
  await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 40000 });
  await enableSemantics(page);
  await openMemoryTimeline(page);
  await committedMemoryCardState(page);
  await durableMemoryState(page, { expectPhoto: false });

  console.log('FORBIDDEN CITY LIVING MEMORY SAVE + DURABLE RELOAD = PASS');
}

async function assertNoBlockingError(page, pageErrors, label) {
  const text = await visibleText(page).catch(() => '');
  const joined = `${text}\n${pageErrors.join('\n')}`;
  for (const fatal of [
    'Bad state: Forbidden City Challenge requires an exact locked Lv1-Lv10 Story binding.',
    'Unhandled Exception',
    'A RenderFlex overflowed',
  ]) {
    if (joined.includes(fatal)) throw new Error(`${label}: blocking runtime error: ${fatal}`);
  }
}

async function runLevel(browser, level) {
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    deviceScaleFactor: 3,
    isMobile: true,
    hasTouch: true,
    locale: 'zh-CN',
    reducedMotion: 'reduce',
  });
  const page = await context.newPage();
  const pageErrors = [];
  page.on('pageerror', (e) => pageErrors.push(e?.stack || e?.message || String(e)));

  try {
    const sep = baseUrl.includes('?') ? '&' : '?';
    const url = `${baseUrl}${sep}unlock=all&prototype=journeys&v=${sourceSha}`;
    const response = await page.goto(url, { waitUntil: 'load', timeout: 140000 });
    if (!response?.ok()) throw new Error(`Preview HTTP load failed: ${response?.status()}`);
    await page.waitForFunction(() => document.querySelector('flutter-view') != null, null, { timeout: 140000 });
    await page.waitForFunction(() => document.getElementById('phoenix-loading') == null, null, { timeout: 40000 });
    await enableSemantics(page);

    await setConfiguredLevel(page, level);
    await returnToExplore(page);
    await openForbiddenCity(page);
    await waitStage(page, 1);
    if ((await currentSessionLevel(page)) !== level) throw new Error(`Lv${level} Story session snapshot mismatch`);
    await assertNoJourneyLiveControls(page);
    const story = await visibleText(page);
    requireStoryIdentity(story, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Story`);
    console.log(`Lv${level} STORY = PASS`);

    if (level === 5) {
      const header = await findSemantic(page, '1/6', { prefix: true, timeout: 5000 });
      await header.evaluate((el) => el.setAttribute('data-founder-stable-header', 'true'));
      await tapButton(page, '开始朗读', { exact: true, timeout: 5000 });
      await findSemantic(page, '正在朗读', { timeout: 8000 });
      await page.evaluate(() => new Promise((resolveFrame) => {
        requestAnimationFrame(() => requestAnimationFrame(() => requestAnimationFrame(resolveFrame)));
      }));
      const stableHeaderCount = await page.locator(
        'flt-semantics[data-founder-stable-header="true"]',
      ).count();
      if (stableHeaderCount !== 1) {
        throw new Error('Story header semantics node rebuilt during narration progress');
      }
      if (await exists(page, '暂停朗读', { role: 'button', exact: true, timeout: 800 })) {
        await tapButton(page, '暂停朗读', { exact: true });
      }
      console.log('Lv5 STORY HEADER STABILITY = PASS');
    }

    await nextToVocabulary(page, level, story);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Vocabulary`);
    console.log(`Lv${level} VOCABULARY = PASS`);

    await nextToDiscovery(page, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Discovery`);
    console.log(`Lv${level} DISCOVERY = PASS`);

    await nextToChallenge(page, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Challenge`);
    await completeChallenge(page, level);
    console.log(`Lv${level} CHALLENGE = PASS`);
    if (grammarOnly) {
      await assertNoBlockingError(page, pageErrors, `Lv${level} Grammar targeted`);
      return;
    }

    await nextToMemory(page, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Memory`);
    console.log(`Lv${level} MEMORY = PASS | 两条都能走通的路线`);

    await nextToCompletion(page, level);
    await assertNoBlockingError(page, pageErrors, `Lv${level} Completion`);
    console.log(`Lv${level} COMPLETION = PASS`);
    // Founder-first targeted smoke only requires Memory to be enterable.
    console.log(`Lv${level} ACTUAL PREVIEW SIX-STAGE = PASS`);
  } catch (error) {
    const snapshot = await records(page).catch(() => []);
    console.error(`Lv${level} SEMANTICS SNAPSHOT = ${JSON.stringify(snapshot.slice(0, 180))}`);
    throw error;
  } finally {
    await context.close();
  }
}

const browser = await chromium.launch({ headless: true });
try {
  for (const level of levels) await runLevel(browser, level);
  console.log(`FORBIDDEN CITY ACTUAL PREVIEW E2E = PASS | SHA=${sourceSha} | LEVELS=${levels.join(',')}`);
} finally {
  await browser.close();
}
