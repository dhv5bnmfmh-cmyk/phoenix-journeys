import { mkdir, writeFile } from 'node:fs/promises';
import { execFileSync } from 'node:child_process';
import { dirname, resolve } from 'node:path';
import { tmpdir } from 'node:os';

const root = resolve(import.meta.dirname, '../..');
const sourceRoot = resolve(root, 'design/sources/global-critical-v1');

const palette = {
  ink: '#102f35', teal: '#1e5d5d', jade: '#4c8171', paper: '#f4e7c7',
  gold: '#d6a24c', ember: '#ba4b31', night: '#160b16', cream: '#fff5db',
};

const svg = (w, h, body, defs = '') => `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${w} ${h}" width="${w}" height="${h}" role="img" aria-label="Original Phoenix programmatic visual">
<defs>${defs}</defs>${body}</svg>\n`;

const commonDefs = `
<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1"><stop stop-color="#102f35"/><stop offset=".55" stop-color="#316f68"/><stop offset="1" stop-color="#d69a58"/></linearGradient>
<linearGradient id="ember" x1="0" y1="0" x2="1" y2="1"><stop stop-color="#ffe087"/><stop offset=".48" stop-color="#d58b36"/><stop offset="1" stop-color="#a9382f"/></linearGradient>
<radialGradient id="halo"><stop stop-color="#fff1bd" stop-opacity=".8"/><stop offset=".45" stop-color="#e0a654" stop-opacity=".25"/><stop offset="1" stop-color="#17383b" stop-opacity="0"/></radialGradient>`;

const iconBody = `<rect width="64" height="64" rx="14" fill="${palette.night}"/><circle cx="32" cy="32" r="24" fill="none" stroke="${palette.gold}" stroke-width="2"/><path d="M32 13c-3 9-9 12-18 13 7 3 11 8 13 16l5-7 5 7c2-8 6-13 13-16-9-1-15-4-18-13Z" fill="url(#ember)"/><path d="M22 28c4 0 7 2 10 7 3-5 6-7 10-7-4 4-6 8-10 17-4-9-6-13-10-17Z" fill="${palette.cream}" fill-opacity=".72"/><circle cx="32" cy="24" r="2.5" fill="${palette.cream}"/>`;

const homeBody = `<rect width="864" height="1536" fill="url(#sky)"/><circle cx="610" cy="440" r="310" fill="url(#halo)"/><g fill="none" stroke="${palette.paper}" stroke-opacity=".22" stroke-width="3"><ellipse cx="585" cy="615" rx="360" ry="210"/><ellipse cx="585" cy="615" rx="265" ry="210"/><path d="M225 615h720M585 405c-70 120-70 300 0 420M585 405c70 120 70 300 0 420"/></g><path d="M68 1180C245 1030 325 940 470 850c115-72 210-96 340-104v790H0v-260c22-35 44-67 68-96Z" fill="#102f35" fill-opacity=".92"/><path d="M170 1050c120-24 210-80 270-170 31 81 92 128 182 151-77 38-132 94-170 169-51-70-144-112-282-150Z" fill="url(#ember)" fill-opacity=".88"/><path d="M203 1062c95 12 167 52 235 125M438 1187c65-58 123-91 208-113" fill="none" stroke="${palette.cream}" stroke-opacity=".62" stroke-width="7" stroke-linecap="round"/><g fill="${palette.gold}" fill-opacity=".7"><circle cx="145" cy="410" r="5"/><circle cx="215" cy="530" r="3"/><circle cx="742" cy="315" r="4"/><circle cx="694" cy="890" r="3"/></g>`;

const worldBody = `<rect width="1333" height="941" fill="#143f47"/><g fill="${palette.jade}" stroke="${palette.paper}" stroke-opacity=".34" stroke-width="4"><path d="M92 220l85-82 150 18 83 62-25 85-73 22-48 114-82-24-29-91-65-34Z"/><path d="M356 485l65 20 52 79-21 102-43 108-47-39-18-116-42-71Z"/><path d="M600 183l109-57 157 17 71 60 135-3 140 75-54 67-107 25-74 85-109-27-85 37-90-67-105-7-51-78Z"/><path d="M772 456l112 10 68 82-21 135-70 105-76-68-35-128Z"/><path d="M1084 663l93-34 80 47-8 79-99 34-73-54Z"/></g><g fill="none" stroke="${palette.gold}" stroke-width="5" stroke-linecap="round"><path d="M265 305C490 80 770 80 1045 310"/><path d="M266 307C520 390 680 430 930 420" stroke-dasharray="12 14"/></g><circle cx="266" cy="307" r="13" fill="${palette.ember}"/><circle cx="1045" cy="310" r="13" fill="${palette.gold}"/><g fill="none" stroke="${palette.paper}" stroke-opacity=".12"><path d="M0 235h1333M0 470h1333M0 705h1333M333 0v941M666 0v941M999 0v941"/></g>`;

const asiaBody = `<rect width="1672" height="941" fill="#173f46"/><path d="M0 104c230 15 345 102 481 128 172 33 243-64 405-42 154 20 175 124 316 155 139 30 235-14 470 22v574H0Z" fill="#4d7c69"/><path d="M690 195c62 69 83 156 71 252-11 92 46 144 91 221l-78 72-97-89-45-117 25-154-55-107Z" fill="#dfcf9e" fill-opacity=".55"/><path d="M890 290c87 18 132 72 146 162l-49 105-77-47 20-80-60-72Z" fill="#dfcf9e" fill-opacity=".48"/><path d="M1115 393l32 41-23 69-32-25Z" fill="#dfcf9e" fill-opacity=".7"/><path d="M1215 460l28 34-20 60-26-26Z" fill="#dfcf9e" fill-opacity=".64"/><g fill="none" stroke="${palette.gold}" stroke-width="6" stroke-linecap="round"><path d="M230 310C480 138 715 195 935 384"/><path d="M935 384c87 78 144 102 250 104" stroke-dasharray="14 18"/></g><circle cx="230" cy="310" r="14" fill="${palette.ember}"/><circle cx="935" cy="384" r="14" fill="${palette.gold}"/><g fill="none" stroke="${palette.paper}" stroke-opacity=".13"><path d="M0 235h1672M0 470h1672M0 705h1672M418 0v941M836 0v941M1254 0v941"/></g>`;

const chinaBody = `<rect width="941" height="1672" fill="#efe1bd"/><path d="M130 290l150-112 138 34 91-69 95 88 125 7 62 119-46 96 58 77-86 92 17 123-96 54-46 153-117-1-72 89-126-43-47-123-94-49 39-139-65-118 80-99-39-90Z" fill="#5e8971" stroke="#244f4e" stroke-width="10"/><g fill="none" stroke="#d0a04e" stroke-width="8" stroke-linecap="round" opacity=".85"><path d="M245 480c135 85 250 114 420 88"/><path d="M292 792c110-68 240-71 348-23"/><path d="M336 1010c91-60 177-62 265-28"/></g><g fill="#fff4d3" stroke="#b64d35" stroke-width="7"><circle cx="566" cy="405" r="17"/><circle cx="560" cy="570" r="17"/><circle cx="455" cy="666" r="17"/><circle cx="625" cy="735" r="17"/><circle cx="496" cy="895" r="17"/><circle cx="402" cy="1060" r="17"/></g><g fill="none" stroke="#244f4e" stroke-opacity=".12"><path d="M0 334h941M0 668h941M0 1002h941M0 1336h941M235 0v1672M470 0v1672M705 0v1672"/></g>`;

const splashBody = `<rect width="941" height="1672" fill="url(#sky)"/><circle cx="470" cy="520" r="350" fill="url(#halo)"/><g fill="none" stroke="${palette.paper}" stroke-opacity=".3"><circle cx="470" cy="520" r="238" stroke-width="7"/><circle cx="470" cy="520" r="190" stroke-width="3" stroke-dasharray="14 18"/><ellipse cx="470" cy="520" rx="238" ry="92" stroke-width="3"/><path d="M232 520h476M470 282c-70 135-70 341 0 476M470 282c70 135 70 341 0 476" stroke-width="3"/></g><path d="M136 1210c131-45 234-125 316-248 74 112 180 190 344 232-147 60-250 154-326 296-76-134-181-225-334-280Z" fill="url(#ember)"/><path d="M226 1221c93 22 176 77 244 172 71-91 151-144 251-172" fill="none" stroke="${palette.cream}" stroke-width="11" stroke-linecap="round"/>`;

const frame = (x, wing) => `<g transform="translate(${x} 0)"><path d="M362 212c-${wing} 74-${wing+78} 161-${wing+112} 276 93-52 184-60 265-22-42-103-112-194-153-241 79 37 146 101 203 193 3-144-37-258-115-367-16-22-44-22-61 0Z" fill="url(#ember)"/><path d="M362 235c-54 84-82 175-84 280 47-65 96-96 148-113 49 23 92 61 130 116-8-102-38-196-88-283-25-42-81-42-106 0Z" fill="${palette.cream}" fill-opacity=".7"/><circle cx="414" cy="210" r="16" fill="${palette.cream}"/></g>`;
const dynamicBody = `<rect width="2172" height="724" fill="none"/>${frame(0,150)}${frame(724,105)}${frame(1448,170)}`;

const assets = [
  ['phoenix-home-journey-keyart-portrait-v1',864,1536,homeBody,commonDefs,'app/assets/images/home/phoenix-home-journey-keyart-portrait-v1.webp'],
  ['phoenix-world-route-atlas-landscape-v1',1333,941,worldBody,commonDefs,'app/assets/images/maps/phoenix-world-route-atlas-landscape-v1.webp'],
  ['phoenix-east-asia-route-atlas-landscape-v1',1672,941,asiaBody,commonDefs,'app/assets/images/maps/phoenix-east-asia-route-atlas-landscape-v1.webp'],
  ['phoenix-china-passport-atlas-portrait-v1',941,1672,chinaBody,commonDefs,'app/assets/images/maps/phoenix-china-passport-atlas-portrait-v1.webp'],
  ['phoenix-launch-journey-cover-portrait-v1',941,1672,splashBody,commonDefs,'app/assets/images/phoenix-launch-journey-cover-portrait-v1.webp'],
  ['phoenix-launch-flight-sprite-landscape-v1',2172,724,dynamicBody,commonDefs,'app/assets/images/phoenix-launch-flight-sprite-landscape-v1.webp'],
];

for (const [name,w,h,body,defs,release] of assets) {
  const master = resolve(sourceRoot, `${name}.svg`);
  await mkdir(dirname(master), { recursive: true });
  await writeFile(master, svg(w,h,body,defs));
  const output = resolve(root, release);
  await mkdir(dirname(output), { recursive: true });
  const png = resolve(tmpdir(), `${name}.png`);
  execFileSync('inkscape', [master, '--export-type=png', `--export-filename=${png}`, `--export-width=${w}`, `--export-height=${h}`]);
  execFileSync('convert', [png, '-strip', '-quality', '86', '-define', 'webp:method=6', output]);
}

for (const size of [64,192,512]) {
  const name = `phoenix-app-mark-square-${size}-v1`;
  const content = svg(64,64,iconBody,commonDefs);
  const master = resolve(sourceRoot, `${name}.svg`);
  const release = resolve(root, size === 64 ? `app/web/${name}.svg` : `app/web/icons/${name}.svg`);
  await mkdir(dirname(master), { recursive: true });
  await mkdir(dirname(release), { recursive: true });
  await writeFile(master, content);
  await writeFile(release, content);
}

console.log('Generated 9 local rights-safe masters and 9 release assets.');
