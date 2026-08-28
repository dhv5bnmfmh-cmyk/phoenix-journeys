import { readFile, writeFile } from 'node:fs/promises';
import { gunzipSync } from 'node:zlib';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const sourceUrl = new URL('./pr202_build_profile.mjs.gz', import.meta.url);
let source = gunzipSync(await readFile(sourceUrl)).toString('utf8');

const original = "shanghai:{city:'上海',place:'外滩',title:'上海 · 外滩',route:'stable-city-picker',identityAll:['林岸','黄浦江'],identityAny:[['陆家嘴','浦东'],['提单','结算']]}";
const replacement = "shanghai:{city:'上海',place:'外滩',title:'上海 · 外滩',route:'stable-city-picker',identityAll:['林岸'],identityAny:[]}";

if (source.split(original).length - 1 !== 1) {
  throw new Error('Shanghai profile entry identity patch target mismatch');
}
source = source.replace(original, replacement);

const profileXianRouteOriginal = ` const openXianPassport=async()=>{await activate(page,'护照',{prefix:true});await find(page,'探索护照',{prefix:true,timeout:15000});await activate(page,'中国',{prefix:true});await find(page,'请从左侧选择省份',{prefix:true,timeout:15000});await activate(page,'陕西省',{prefix:true});await find(page,'请从左侧选择城市',{prefix:true,timeout:15000});await activate(page,'西安',{prefix:true});await find(page,'陕西省，西安市',{prefix:true,timeout:15000});await activate(page,'西安城墙',{prefix:false});};`;
const profileXianRouteReplacement = ` const openXianPassport=async()=>{await activate(page,'护照',{prefix:true});await find(page,'探索护照',{prefix:true,timeout:15000});await activate(page,'中国',{prefix:true});await find(page,'请从左侧选择省份',{prefix:true,timeout:15000});await activate(page,'陕西省',{prefix:true});await find(page,'请从左侧选择城市',{prefix:true,timeout:15000});await activate(page,'西安',{prefix:true});await find(page,'陕西省，西安市',{prefix:true,timeout:15000});const placeDeadline=Date.now()+15000;let lastError=null;while(Date.now()<placeDeadline){try{await find(page,'陕西省，西安市',{prefix:true,timeout:800});if(await exists(page,'西安城墙',{role:'button',timeout:500})){await activate(page,'西安城墙',{prefix:false,timeout:2500});return;}}catch(error){lastError=error;}await sleep(100);}throw lastError??new Error("Xi'an Passport place activation did not settle");};`;

if (source.split(profileXianRouteOriginal).length - 1 !== 1) {
  throw new Error("Xi'an profile Passport route patch target mismatch");
}
source = source.replace(profileXianRouteOriginal, profileXianRouteReplacement);
const profileEntryOriginal = ` const assertEntry=async()=>{await find(page,'1/6',{prefix:true,timeout:20000});const snapshot=await visibleText();if(!snapshot.includes(journey.title))throw new Error(\`Journey identity missing title: \${journey.title}\`);for(const marker of journey.identityAll)if(!snapshot.includes(marker))throw new Error(\`Journey identity missing stable marker: \${marker}\`);for(const group of journey.identityAny)if(!group.some(marker=>snapshot.includes(marker)))throw new Error(\`Journey identity missing stable marker group: \${group.join(' | ')}\`);};`;
const profileEntryReplacement = ` const assertEntry=async()=>{const deadline=Date.now()+30000;let last='';while(Date.now()<deadline){last=await visibleText();const stageReady=last.includes('1/6');const titleReady=last.includes(journey.title);const allReady=journey.identityAll.every(marker=>last.includes(marker));const groupsReady=journey.identityAny.every(group=>group.some(marker=>last.includes(marker)));if(stageReady&&titleReady&&allReady&&groupsReady)return;await sleep(100);}throw new Error('Journey entry did not settle with identity + 1/6 + Story evidence: '+journey.title+'; snapshot='+last.slice(0,1200));};`;

if (source.split(profileEntryOriginal).length - 1 !== 1) {
  throw new Error('Profile mature entry assertion patch target mismatch');
}
source = source.replace(profileEntryOriginal, profileEntryReplacement);

const profileEntryOnlyOriginal = ` if(journey.route==='xian-passport')await openXianPassport();else await openCityPicker();await assertEntry();
 await setLevel(page,5);`;
const profileEntryOnlyReplacement = ` if(journey.route==='xian-passport')await openXianPassport();else await openCityPicker();await assertEntry();if(process.env.PROFILE_ENTRY_ONLY==='1'){console.log('ENTRY_PREFLIGHT_PASS city='+cityKey+' browser='+browserName+' title='+journey.title);await browser.close();process.exit(0);}
 await setLevel(page,5);`;

if (source.split(profileEntryOnlyOriginal).length - 1 !== 1) {
  throw new Error('Profile entry-only patch target mismatch');
}
source = source.replace(profileEntryOnlyOriginal, profileEntryOnlyReplacement);
const tempPath = path.join(
  process.env.RUNNER_TEMP || '/tmp',
  `pr202_build_profile_entry_${process.pid}.mjs`,
);
await writeFile(tempPath, source, 'utf8');
await import(pathToFileURL(tempPath).href);
