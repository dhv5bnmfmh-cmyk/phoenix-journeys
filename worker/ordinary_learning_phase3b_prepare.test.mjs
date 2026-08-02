import test from 'node:test';
import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {existsSync,mkdirSync,mkdtempSync,readFileSync,readdirSync,rmSync,writeFileSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {dirname,join,resolve} from 'node:path';
import {gunzipSync,gzipSync} from 'node:zlib';

test('prepare Phase 3B artifacts from the locally authored evidence bundle',()=>{
 const root=resolve(import.meta.dirname,'..');
 const parts=readdirSync(resolve(root,'worker')).filter(n=>n.startsWith('phase3b-prep-bundle.part')).sort();
 assert.ok(parts.length>=2);
 const payload=JSON.parse(gunzipSync(Buffer.concat(parts.map(n=>readFileSync(resolve(root,'worker',n))))).toString('utf8'));
 const written=[]; const out=mkdtempSync(join(tmpdir(),'phoenix-phase3b-'));
 try{
  for(const [path,b64] of Object.entries(payload)){const full=resolve(root,path);mkdirSync(dirname(full),{recursive:true});writeFileSync(full,Buffer.from(b64,'base64'));written.push(full);}
  execFileSync(process.execPath,[resolve(root,'worker/scripts/prepare_ordinary_learning_phase3b_artifacts.mjs'),out],{cwd:root,stdio:['ignore','pipe','inherit']});
  const names=readdirSync(out).sort();
  for(const required of ['ASSET_REGISTER.phase3b-1.csv','ASSET_REGISTER.phase3b-2.csv','ASSET_REGISTER.phase3b-3.csv','ASSET_REGISTER.phase3b-verified.csv','journey_background_generated.phase3b-1.dart','journey_background_generated.phase3b-2.dart','journey_background_generated.phase3b-3.dart','ORDINARY_LEARNING_V1_MANIFEST.verified.json','ROADMAP.phase3b-final.md','TODO.phase3b-final.md','summary.json'])assert.ok(names.includes(required),required);
  const encoded=gzipSync(Buffer.from(JSON.stringify(Object.fromEntries(names.map(n=>[n,readFileSync(join(out,n),'utf8')]))))).toString('base64');
  console.log(`PHASE3B_ARTIFACT_BUNDLE_BEGIN\n${encoded}\nPHASE3B_ARTIFACT_BUNDLE_END`);
 }finally{for(const full of written)rmSync(full,{force:true});rmSync(out,{recursive:true,force:true});}
});
