import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { execFileSync } from 'node:child_process';
import { resolve } from 'node:path';

const root = resolve(import.meta.dirname, '../..');
const configPath = resolve(root, 'design/sources/special-journeys-v1/parameters.json');
const config = JSON.parse(await readFile(configPath, 'utf8'));
const masterRoot = resolve(root, 'design/sources/special-journeys-v1/masters');
const releaseRoot = resolve(root, 'app/assets/images/special-realms/rights-safe-v1');
const tempRoot = resolve('/tmp', 'phoenix-special-journeys-v1');
await Promise.all([mkdir(masterRoot, { recursive: true }), mkdir(releaseRoot, { recursive: true }), mkdir(tempRoot, { recursive: true })]);

const esc = (value) => String(value).replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('"', '&quot;');
const p = (points) => points.map(([x,y]) => `${x},${y}`).join(' ');
const line = (x1,y1,x2,y2,stroke,width=8,opacity=.8) => `<path d="M${x1} ${y1} L${x2} ${y2}" fill="none" stroke="${stroke}" stroke-width="${width}" stroke-linecap="round" opacity="${opacity}"/>`;

function changan(s,c) {
  const busY=940-s.index*18, gateX=110+(s.index%4)*170;
  return `<path d="M0 1120 Q220 960 450 1080 T900 990 V1600H0Z" fill="${c[1]}"/><g opacity=".8">${[0,1,2,3].map(i=>`<rect x="${55+i*225}" y="${560+i%2*55}" width="150" height="520" rx="8" fill="${c[0]}"/><path d="M${75+i*225} 1080V720Q130 ${630+i%2*55} ${185+i*225} 720V1080" fill="${c[2]}" opacity=".45"/>`).join('')}</g><g transform="translate(${gateX} ${busY})"><rect width="430" height="190" rx="38" fill="${c[4]}"/><rect x="48" y="34" width="265" height="80" rx="10" fill="${c[1]}"/><circle cx="92" cy="188" r="38" fill="${c[0]}"/><circle cx="344" cy="188" r="38" fill="${c[0]}"/><rect x="330" y="32" width="58" height="75" fill="${c[3]}"/></g>${Array.from({length:12},(_,i)=>line(70+i*77,220,25+i*77,470,c[4],4,.35)).join('')}${s.index>=5?`<path d="M620 690 q80-110 160 0 q-80 95-160 0Z" fill="${c[3]}" opacity=".7"/>`:''}`;
}
function tide(s,c) {
  const water=920+s.index*12;
  return `<rect y="${water}" width="900" height="${1600-water}" fill="${c[1]}"/>${[0,1,2,3,4].map(i=>`<path d="M-80 ${water+80+i*100} Q150 ${water+10+i*100} 360 ${water+75+i*100} T980 ${water+45+i*100}" fill="none" stroke="${c[2+i%2]}" stroke-width="${18-i*2}" opacity="${.28+i*.08}"/>`).join('')}<path d="M70 1000V580h210v420M95 660h160M145 580v-120h70v120" fill="none" stroke="${c[4]}" stroke-width="22" opacity=".72"/><g transform="translate(${500+(s.index%3)*55} ${660+s.index*17}) rotate(${-8+s.index})"><path d="M0 0h250v155H0Z" fill="${c[4]}"/><path d="M0 0l125 88L250 0" fill="none" stroke="${c[3]}" stroke-width="10"/></g>${s.index>=6?`<g transform="translate(330 430)"><circle r="120" fill="${c[0]}" stroke="${c[3]}" stroke-width="18"/><circle r="42" fill="${c[4]}"/><path d="M-75 0A75 75 0 0 1 75 0" fill="none" stroke="${c[2]}" stroke-width="12"/></g>`:''}`;
}
function arcade(s,c) {
  return `<path d="M0 400H900V1600H0Z" fill="${c[1]}"/>${[0,1,2,3].map(i=>`<path d="M${40+i*230} 1430V670Q${145+i*230} ${480+(i%2)*80} ${250+i*230} 670V1430" fill="${i%2?c[0]:c[4]}" opacity="${.35+i*.1}"/>`).join('')}<path d="M0 1320L900 1070V1600H0Z" fill="${c[4]}" opacity=".35"/>${Array.from({length:12},(_,i)=>`<path d="M${(i%4)*230-30} ${1120+Math.floor(i/4)*150}l115-55 115 55-115 55Z" fill="none" stroke="${c[3]}" stroke-width="7" opacity=".55"/>`).join('')}<g transform="translate(${170+s.index*42} ${620+s.index*30})"><path d="M0 170Q125-20 250 170Z" fill="${c[2]}"/><path d="M125 165v360q0 90 80 55" fill="none" stroke="${c[0]}" stroke-width="18"/></g>${s.index>=7?`<rect x="610" y="850" width="190" height="240" fill="${c[3]}" opacity=".65"/><path d="M640 900h130M640 950h100M640 1000h120" stroke="${c[0]}" stroke-width="8"/>`:''}`;
}
function tea(s,c) {
  return `<path d="M0 820L210 450l170 250 190-390 330 510v780H0Z" fill="${c[1]}"/><path d="M0 1050L250 700l170 270 210-410 270 390v650H0Z" fill="${c[2]}" opacity=".72"/><path d="M60 1600Q170 1220 390 1110T800 610" fill="none" stroke="${c[3]}" stroke-width="${90-s.index*3}" opacity=".8"/>${Array.from({length:6},(_,i)=>`<ellipse cx="${175+i*105}" cy="${1210-i*105}" rx="30" ry="15" fill="${c[0]}" transform="rotate(-35 ${175+i*105} ${1210-i*105})"/>`).join('')}<g transform="translate(${540+(s.index%2)*65} ${520+s.index*25})"><path d="M0 0q70 80 140 0l-25 150H25Z" fill="${c[4]}"/><circle cx="70" cy="160" r="32" fill="${c[3]}"/></g>${[0,1,2].map(i=>`<path d="M80 ${430+i*65}q180 ${-90+i*10} 360 0t360 0" fill="none" stroke="${c[4]}" stroke-width="7" opacity="${.2+i*.12}"/>`).join('')}`;
}
function ice(s,c) {
  const x=120+(s.index%4)*150;
  return `<rect y="510" width="900" height="1090" fill="${c[1]}"/><path d="M0 510L180 320l130 190 180-260 170 260 130-150 110 150" fill="${c[2]}" opacity=".55"/>${[0,1,2,3,4].map(i=>`<path d="M${70+i*175} 560v780h95V${650+i%2*160}h80" fill="none" stroke="${i%2?c[3]:c[4]}" stroke-width="20" opacity=".55"/>`).join('')}<g transform="translate(${x} ${810+s.index*22})"><rect width="310" height="270" rx="12" fill="${c[0]}" stroke="${c[4]}" stroke-width="12"/><circle cx="80" cy="85" r="38" fill="none" stroke="${c[2]}" stroke-width="10"/><path d="M155 70h110M155 115h85M45 195h220" stroke="${c[3]}" stroke-width="12"/></g>${Array.from({length:10},(_,i)=>`<circle cx="${90+(i*137)%760}" cy="${190+(i*83)%310}" r="${4+i%4}" fill="${c[4]}"/><path d="M${90+(i*137)%760} ${190+(i*83)%310}L${90+((i+1)*137)%760} ${190+((i+1)*83)%310}" stroke="${c[2]}" stroke-width="3" opacity=".4"/>`).join('')}`;
}
function literary(s,c) {
  return `<path d="M0 1040Q260 880 450 1030T900 950V1600H0Z" fill="${c[1]}"/>${Array.from({length:9},(_,i)=>`<path d="M${50+i*110} 1200Q${30+i*115} 750 ${120+i*100} 260" stroke="${i%3===0?c[4]:c[2]}" stroke-width="${18+i%4*5}" fill="none" opacity=".65"/><path d="M${80+i*105} ${520+i%3*120}q${i%2?80:-80}-70 ${i%2?110:-110}-10" stroke="${c[3]}" stroke-width="9" fill="none" opacity=".45"/>`).join('')}<path d="M0 1190Q270 1070 450 1180T900 1100" stroke="${c[4]}" stroke-width="8" fill="none" opacity=".55"/><g transform="translate(${260+s.index*48} ${430+s.index*32}) rotate(${s.index*6})"><path d="M0 0q-110-90-120 35Q-70 90 0 40Q70 90 120 35Q110-90 0 0Z" fill="${c[3]}" opacity=".85"/><circle r="10" fill="${c[0]}"/></g>${s.index>=6?`<path d="M120 1350Q450 1160 780 1350" stroke="${c[2]}" stroke-width="35" fill="none" opacity=".45"/>`:''}`;
}
function myth(s,c) {
  return `<path d="M0 1600V910L240 760l170 80 210-270 280 210v820Z" fill="${c[1]}"/><path d="M90 1520L300 1300l-80-120 210-190-65-120 260-240" fill="none" stroke="${c[4]}" stroke-width="80" opacity=".5"/>${[0,1,2,3,4].map(i=>`<path d="M${115+i*155} 1130V${520-i%2*110}q70-100 140 0v610" fill="none" stroke="${c[2]}" stroke-width="22" opacity=".6"/>`).join('')}<g transform="translate(${500-s.index*30} ${650+s.index*33}) rotate(${-18+s.index*4})">${[0,1,2,3].map(i=>`<rect x="${i*42}" y="0" width="34" height="260" rx="12" fill="${c[3]}"/><path d="M${i*42+10} 45v155" stroke="${c[0]}" stroke-width="5"/>`).join('')}<path d="M0 25h160M0 235h160" stroke="${c[4]}" stroke-width="9"/></g><ellipse cx="${210+s.index*35}" cy="350" rx="170" ry="95" fill="${c[4]}" opacity=".24"/>`;
}
function strange(s,c) {
  const chairX=170+s.index*48;
  return `<rect y="430" width="900" height="1170" fill="${c[0]}"/><path d="M70 1440V610h250v830M580 1440V520h250v920" fill="none" stroke="${c[2]}" stroke-width="28"/><path d="M0 1140L900 960V1600H0Z" fill="${c[1]}"/>${[0,1,2,3,4].map(i=>`<path d="M${i*220-80} 1600L${i*180+40} 1040" stroke="${c[3]}" stroke-width="9" opacity=".38"/>`).join('')}<g transform="translate(${chairX} ${780+s.index*22})"><path d="M0 0h190v260H0Z" fill="${c[3]}"/><path d="M25 260v180M165 260v180" stroke="${c[4]}" stroke-width="22"/><path d="M-35 440h260" stroke="${c[4]}" stroke-width="10" opacity="${s.index<7?.65:0}"/></g><g transform="translate(520 630)"><rect width="250" height="330" fill="${c[4]}" opacity=".75"/><path d="M45 70h160M45 125h130M45 180h170M45 235h110" stroke="${c[1]}" stroke-width="10"/></g>`;
}
function folk(s,c) {
  const vesselX=120+s.index*56;
  return `<path d="M0 520Q200 460 420 540T900 500V1600H0Z" fill="${c[1]}"/>${[0,1,2,3,4,5].map(i=>`<path d="M-120 ${650+i*145}Q160 ${550+i*145} 420 ${650+i*145}T1020 ${600+i*145}" fill="none" stroke="${i%2?c[2]:c[4]}" stroke-width="${12+i*3}" opacity="${.18+i*.06}"/>`).join('')}<g transform="translate(${vesselX} ${860-s.index*28}) rotate(${-8+s.index})"><path d="M0 80L120 0l120 80-120 80Z" fill="${c[3]}"/><path d="M120 0v-150" stroke="${c[4]}" stroke-width="12"/><path d="M120-150l90 75-90 20Z" fill="${c[4]}" opacity=".7"/></g><path d="M80 1500Q300 1320 480 1400T850 1220" fill="none" stroke="${c[0]}" stroke-width="55" opacity=".7"/>${s.index>=7?`<path d="M500 1160q120-180 240 0q-120 90-240 0Z" fill="${c[4]}" opacity=".35"/>`:''}`;
}

const renderers = { 'changan-last-bus':changan, 'tide-letter':tide, 'arcade-lost-property':arcade, 'tea-horse-echo':tea, 'ice-city-star-map':ice, 'literary-roaming':literary, 'myth-tracing':myth, 'strange-night-talks':strange, 'folk-secret-land':folk };

const box=(x,y,w,h,fill,opacity=.75)=>`<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="12" fill="${fill}" opacity="${opacity}"/>`;
const circle=(x,y,r,fill,opacity=.75)=>`<circle cx="${x}" cy="${y}" r="${r}" fill="${fill}" opacity="${opacity}"/>`;
const details = {
  'changan-last-bus': (s,c) => [
    `<path d="M110 430h680" stroke="${c[3]}" stroke-width="18" opacity=".45"/>`,
    `${circle(680,470,115,c[0],.8)}${circle(680,470,82,c[4],.25)}`,
    `<path d="M120 560L780 900" stroke="${c[4]}" stroke-width="45" opacity=".16"/>`,
    `<path d="M520 650h250v150H520Z" fill="${c[3]}"/><path d="M645 650v150" stroke="${c[0]}" stroke-width="7" stroke-dasharray="18 14"/>`,
    `${box(90,350,250,300,c[0],.75)}${[0,1,2].map(i=>box(125,400+i*75,180,35,c[4],.35)).join('')}`,
    `<path d="M80 760Q450 450 820 760" fill="none" stroke="${c[3]}" stroke-width="34"/>`,
    `${box(540,640,190,260,c[4],.42)}<path d="M570 860h130" stroke="${c[0]}" stroke-width="20"/>`,
    `${circle(690,500,135,c[3],.5)}<path d="M560 500h260" stroke="${c[4]}" stroke-width="14"/>`,
    `<path d="M130 520Q450 300 770 520" fill="none" stroke="${c[4]}" stroke-width="9" stroke-dasharray="24 22"/>`,
    `<path d="M120 250L780 720" stroke="${c[4]}" stroke-width="120" opacity=".18"/>`,
  ][s.index-1],
  'tide-letter': (s,c) => [
    `${box(90,390,260,250,c[0],.82)}${circle(220,515,68,c[4],.5)}`,
    `<path d="M90 650Q300 520 510 650T880 600" fill="none" stroke="${c[4]}" stroke-width="25" opacity=".45"/>`,
    `${box(540,360,250,160,c[4],.7)}<path d="M540 360l125 95 125-95" fill="none" stroke="${c[3]}" stroke-width="12"/>`,
    `<path d="M140 420h620v390H140Z" fill="${c[0]}" opacity=".7"/><path d="M150 430Q450 720 750 430" fill="${c[2]}" opacity=".55"/>`,
    `${circle(220,480,90,c[0],.8)}${box(360,420,300,120,c[4],.45)}`,
    `<path d="M100 470q75-100 150 0t150 0t150 0t150 0" fill="none" stroke="${c[4]}" stroke-width="16"/>`,
    `${circle(680,420,130,c[4],.18)}<path d="M570 420h220" stroke="${c[3]}" stroke-width="8"/>`,
    `${box(120,350,560,260,c[0],.62)}<path d="M170 470q70-100 140 0t140 0t140 0" fill="none" stroke="${c[4]}" stroke-width="12"/>`,
    `<path d="M110 460Q450 290 790 460" fill="none" stroke="${c[3]}" stroke-width="38" opacity=".5"/>`,
    `<path d="M180 350h540l-90 210H270Z" fill="${c[4]}" opacity=".35"/>`,
  ][s.index-1],
  'arcade-lost-property': (s,c) => [
    `<path d="M120 520h660" stroke="${c[4]}" stroke-width="20" opacity=".4"/>`,
    `${box(550,380,230,310,c[4],.6)}${[0,1,2].map(i=>line(590,450+i*70,735,450+i*70,c[0],8,.7)).join('')}`,
    `${circle(190,480,75,c[3],.65)}${box(340,400,170,190,c[0],.7)}`,
    `<path d="M120 690L760 430" stroke="${c[2]}" stroke-width="28" stroke-dasharray="28 18"/>`,
    `${[0,1,2].map(i=>box(110+i*220,380+i%2*100,150,130,c[4],.45)).join('')}`,
    `<path d="M100 430q120-130 240 0t240 0t240 0" fill="none" stroke="${c[3]}" stroke-width="20"/>`,
    `${box(260,330,380,420,c[0],.72)}${box(320,420,95,120,c[4],.38)}${box(470,510,100,150,c[3],.4)}`,
    `<path d="M160 520L450 350L740 520" fill="none" stroke="${c[4]}" stroke-width="25"/>`,
    `${circle(450,510,170,c[4],.12)}${circle(450,510,65,c[2],.45)}`,
    `<path d="M90 290L790 720" stroke="${c[4]}" stroke-width="110" opacity=".2"/>`,
  ][s.index-1],
  'tea-horse-echo': (s,c) => [
    `<path d="M80 560q180-150 360 0t360 0" fill="none" stroke="${c[4]}" stroke-width="14" opacity=".45"/>`,
    `${circle(660,450,90,c[3],.55)}<path d="M660 540v170" stroke="${c[4]}" stroke-width="18"/>`,
    `<path d="M110 440q90-120 180 0t180 0t180 0" fill="none" stroke="${c[4]}" stroke-width="20"/>`,
    `<path d="M160 660L390 420L620 590L790 370" fill="none" stroke="${c[3]}" stroke-width="32"/>`,
    `${box(120,350,210,280,c[0],.7)}${circle(620,430,75,c[4],.25)}`,
    `<path d="M100 600Q300 350 500 600T850 500" fill="none" stroke="${c[4]}" stroke-width="10" stroke-dasharray="20 18"/>`,
    `${[0,1,2].map(i=>circle(230+i*200,430+i%2*100,55,c[3],.35)).join('')}`,
    `${box(180,330,530,300,c[4],.25)}${[0,1,2].map(i=>line(240,410+i*70,650,410+i*70,c[0],9,.65)).join('')}`,
    `<path d="M150 620q300-320 600 0" fill="none" stroke="${c[3]}" stroke-width="45" opacity=".4"/>`,
    `<path d="M90 500Q450 250 810 500" fill="none" stroke="${c[4]}" stroke-width="50" opacity=".25"/>`,
  ][s.index-1],
  'ice-city-star-map': (s,c) => [
    `<path d="M100 430h700" stroke="${c[4]}" stroke-width="18" opacity=".4"/>`,
    `${box(110,340,240,380,c[0],.7)}${circle(230,480,50,c[3],.5)}`,
    `<path d="M120 650L300 380L480 610L720 300" fill="none" stroke="${c[4]}" stroke-width="16"/>`,
    `${box(540,360,230,330,c[0],.72)}${[0,1,2].map(i=>circle(600+i*65,470+i%2*60,18,c[4],.65)).join('')}`,
    `${box(100,360,180,240,c[4],.3)}${box(340,430,180,180,c[3],.28)}${box(590,320,180,300,c[2],.3)}`,
    `<path d="M100 420l700 250" stroke="${c[4]}" stroke-width="70" opacity=".15"/>`,
    `${circle(450,470,180,c[4],.12)}<path d="M320 470h260" stroke="${c[3]}" stroke-width="12"/>`,
    `${box(130,330,640,340,c[0],.7)}${[0,1,2,3].map(i=>line(190,410+i*60,710,410+i*60,c[4],7,.55)).join('')}`,
    `<path d="M150 620Q450 280 750 620" fill="none" stroke="${c[4]}" stroke-width="28" stroke-dasharray="16 20"/>`,
    `<path d="M120 690L450 310L780 690" fill="${c[4]}" opacity=".12"/>`,
  ][s.index-1],
  'literary-roaming': (s,c) => [
    `${circle(450,430,180,c[4],.12)}<path d="M300 430q150-180 300 0q-150 130-300 0Z" fill="${c[3]}" opacity=".45"/>`,
    `<path d="M100 650Q300 300 500 650T850 500" fill="none" stroke="${c[4]}" stroke-width="15"/>`,
    `<path d="M100 400L780 680" stroke="${c[3]}" stroke-width="35" opacity=".3"/>`,
    `<path d="M130 700Q310 380 450 700Q600 390 770 700" fill="none" stroke="${c[4]}" stroke-width="24"/>`,
    `${[0,1,2].map(i=>box(160+i*210,390+i%2*80,110,150,c[2+i%2],.34)).join('')}`,
    `<path d="M110 520h680" stroke="${c[3]}" stroke-width="14" stroke-dasharray="12 25"/>`,
    `${circle(300,470,110,c[4],.16)}${circle(600,470,110,c[3],.18)}`,
    `${box(160,350,580,310,c[0],.55)}<path d="M230 520h440" stroke="${c[4]}" stroke-width="9"/>`,
    `<path d="M170 610q280-360 560 0" fill="none" stroke="${c[3]}" stroke-width="38" opacity=".34"/>`,
    `<path d="M100 260L800 720" stroke="${c[4]}" stroke-width="120" opacity=".12"/>`,
  ][s.index-1],
  'myth-tracing': (s,c) => [
    `<path d="M130 650L450 320L770 650" fill="none" stroke="${c[4]}" stroke-width="25" opacity=".5"/>`,
    `${box(570,350,180,320,c[3],.4)}${[0,1,2].map(i=>line(610,430+i*70,710,430+i*70,c[0],6,.65)).join('')}`,
    `<path d="M120 570q160-250 320 0t320 0" fill="none" stroke="${c[2]}" stroke-width="24"/>`,
    `<path d="M180 690L350 510L470 600L700 340" fill="none" stroke="${c[4]}" stroke-width="45" opacity=".42"/>`,
    `${[0,1,2].map(i=>box(130+i*230,390+i%2*75,145,190,c[3],.3)).join('')}`,
    `<path d="M90 480Q450 270 810 480" fill="none" stroke="${c[4]}" stroke-width="11" stroke-dasharray="30 18"/>`,
    `${circle(450,460,170,c[4],.1)}${box(390,390,120,220,c[3],.4)}`,
    `${box(130,330,640,330,c[0],.55)}${[0,1,2].map(i=>line(200,420+i*70,700,420+i*70,c[4],7,.5)).join('')}`,
    `<path d="M160 640Q450 320 740 640" fill="none" stroke="${c[3]}" stroke-width="36" opacity=".35"/>`,
    `<ellipse cx="450" cy="430" rx="270" ry="170" fill="${c[4]}" opacity=".13"/>`,
  ][s.index-1],
  'strange-night-talks': (s,c) => [
    `${box(120,340,220,340,c[4],.36)}${[0,1,2].map(i=>line(165,430+i*70,300,430+i*70,c[0],8,.7)).join('')}`,
    `<path d="M100 650L800 430" stroke="${c[3]}" stroke-width="38" opacity=".28"/>`,
    `${circle(680,450,95,c[4],.16)}${box(590,560,180,110,c[3],.4)}`,
    `<path d="M160 360h580v330H160Z" fill="${c[0]}" opacity=".52"/><path d="M450 360v330" stroke="${c[4]}" stroke-width="10"/>`,
    `${[0,1,2].map(i=>box(130+i*230,430+i%2*100,150,170,c[3],.3)).join('')}`,
    `<path d="M100 500q175-190 350 0t350 0" fill="none" stroke="${c[4]}" stroke-width="18"/>`,
    `${circle(450,470,160,c[4],.09)}<path d="M330 470h240" stroke="${c[3]}" stroke-width="12"/>`,
    `${box(140,330,620,350,c[4],.22)}${[0,1,2].map(i=>line(220,420+i*70,680,420+i*70,c[0],8,.7)).join('')}`,
    `<path d="M150 650Q450 340 750 650" fill="none" stroke="${c[3]}" stroke-width="30" opacity=".38"/>`,
    `<path d="M100 300L800 700" stroke="${c[4]}" stroke-width="100" opacity=".1"/>`,
  ][s.index-1],
  'folk-secret-land': (s,c) => [
    `<path d="M90 530q180-160 360 0t360 0" fill="none" stroke="${c[4]}" stroke-width="16" opacity=".42"/>`,
    `${box(580,360,190,260,c[3],.42)}<path d="M620 410h110" stroke="${c[4]}" stroke-width="10"/>`,
    `<path d="M100 670L780 370" stroke="${c[2]}" stroke-width="30" opacity=".42"/>`,
    `<path d="M160 650Q330 320 500 650Q650 390 790 610" fill="none" stroke="${c[4]}" stroke-width="24"/>`,
    `${[0,1,2].map(i=>box(120+i*230,400+i%2*90,150,150,c[3],.28)).join('')}`,
    `<path d="M100 470q120-110 240 0t240 0t240 0" fill="none" stroke="${c[4]}" stroke-width="18"/>`,
    `${circle(450,470,170,c[4],.1)}<path d="M320 470h260" stroke="${c[3]}" stroke-width="12"/>`,
    `${box(140,340,620,320,c[0],.5)}${[0,1,2].map(i=>line(210,430+i*65,690,430+i*65,c[4],7,.52)).join('')}`,
    `<path d="M130 630Q450 300 770 630" fill="none" stroke="${c[3]}" stroke-width="38" opacity=".35"/>`,
    `<path d="M90 270L810 710" stroke="${c[4]}" stroke-width="110" opacity=".13"/>`,
  ][s.index-1],
};

function svgFor(journey, scene) {
  const c=journey.palette, renderer=renderers[journey.id];
  const focusX=180+((scene.index*137)%540), focusY=260+scene.index*62;
  return `<?xml version="1.0" encoding="UTF-8"?>\n<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 1600" width="900" height="1600" role="img" aria-label="${esc(journey.name)} ${esc(scene.purpose)} original Phoenix visual"><defs><linearGradient id="sky" x1="0" y1="0" x2="0" y2="1"><stop stop-color="${c[0]}"/><stop offset=".55" stop-color="${c[1]}"/><stop offset="1" stop-color="${c[2]}"/></linearGradient><radialGradient id="focus"><stop stop-color="${c[4]}" stop-opacity=".5"/><stop offset="1" stop-color="${c[4]}" stop-opacity="0"/></radialGradient></defs><rect width="900" height="1600" fill="url(#sky)"/><ellipse cx="${focusX}" cy="${focusY}" rx="390" ry="430" fill="url(#focus)"/>${renderer(scene,c)}${details[journey.id](scene,c)}<rect x="42" y="42" width="816" height="1516" rx="28" fill="none" stroke="${c[4]}" stroke-width="3" opacity=".16"/></svg>\n`;
}

const records=[];
for (const journey of config.journeys) {
  const masterDir=resolve(masterRoot,journey.id), releaseDir=resolve(releaseRoot,journey.id);
  await Promise.all([mkdir(masterDir,{recursive:true}),mkdir(releaseDir,{recursive:true})]);
  for (const scene of config.scenes) {
    const stem=`${journey.id}-${String(scene.index).padStart(2,'0')}-${scene.slug}-portrait-v1`;
    const master=resolve(masterDir,`${stem}.svg`), png=resolve(tempRoot,`${stem}.png`), release=resolve(releaseDir,`${stem}.webp`);
    await writeFile(master,svgFor(journey,scene));
    execFileSync('inkscape',[master,'--export-type=png',`--export-filename=${png}`,'--export-width=900','--export-height=1600'],{stdio:'ignore'});
    execFileSync('convert',[png,'-strip','-define','webp:method=6','-quality','82',release]);
    records.push({journeyId:journey.id,storyId:journey.storyId,scene:scene.index,purpose:scene.purpose,storyPhase:scene.storyPhase,master:master.slice(root.length+1),release:release.slice(root.length+1)});
  }
}
await writeFile(resolve(root,'design/evidence/SPECIAL_JOURNEYS_V1_MANIFEST.json'),`${JSON.stringify({version:config.version,created:'2026-08-02',generator:'worker/scripts/generate_special_journey_rights_safe_assets.mjs',parameters:'design/sources/special-journeys-v1/parameters.json',records},null,2)}\n`);
console.log(`Generated ${records.length} editable masters and ${records.length} WebP releases.`);
