import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import test from 'node:test';

const root=new URL('../',import.meta.url);
const parameters=JSON.parse(readFileSync(new URL('../design/sources/special-journeys-v1/parameters.json',import.meta.url),'utf8'));
const manifest=JSON.parse(readFileSync(new URL('../design/evidence/SPECIAL_JOURNEYS_V1_MANIFEST.json',import.meta.url),'utf8'));
const runtime=readFileSync(new URL('../app/lib/widgets/special_realm_background.dart',import.meta.url),'utf8');
const evidence=readFileSync(new URL('../design/evidence/SPECIAL_JOURNEYS_V1_EVIDENCE.md',import.meta.url),'utf8');

test('phase 2 is exactly nine independent Journeys and ninety releases',()=>{
  assert.equal(parameters.journeys.length,9);
  assert.equal(parameters.scenes.length,10);
  assert.equal(manifest.records.length,90);
  assert.equal(new Set(parameters.journeys.map(j=>j.motif)).size,9);
  assert.equal(new Set(parameters.journeys.map(j=>j.composition)).size,9);
  assert.equal(new Set(manifest.records.map(r=>r.release)).size,90);
  assert.equal(new Set(manifest.records.map(r=>r.master)).size,90);
});

test('all releases, editable masters and runtime references are complete',()=>{
  const releaseHashes=[];
  for(const record of manifest.records){
    const release=new URL(`../${record.release}`,import.meta.url),master=new URL(`../${record.master}`,import.meta.url);
    assert.equal(existsSync(release),true,record.release);
    assert.equal(existsSync(master),true,record.master);
    assert.match(runtime,new RegExp(record.release.replace('app/','').replace(/[.*+?^${}()|[\]\\]/g,'\\$&')),record.release);
    releaseHashes.push(createHash('sha256').update(readFileSync(release)).digest('hex'));
    const svg=readFileSync(master,'utf8');
    assert.match(svg,/viewBox="0 0 900 1600"/);
    assert.doesNotMatch(svg,/<script\b|javascript:|xlink:href\s*=|<image\b/i,record.master);
    assert.doesNotMatch(svg.replace('http://www.w3.org/2000/svg',''),/https?:\/\//i,record.master);
  }
  assert.equal(new Set(releaseHashes).size,90,'no release may be a byte duplicate');
  assert.equal((runtime.match(/rights-safe-v1\//g)??[]).length,90);
});

test('the visual bibles and rights declaration cover all nine Journeys',()=>{
  assert.match(evidence,/No old Phoenix visual, external image, texture, photograph/);
  assert.match(evidence,/External Visual Service Used: `NONE`/);
  for(const journey of parameters.journeys){
    assert.equal(evidence.includes(`| \`${journey.id}\``),true,journey.id);
    assert.notEqual(journey.forbidden,'');
    assert.equal(journey.dataFile.startsWith('app/lib/data/'),true);
  }
});

test('runtime preserves reduced motion, bounded preloading and final fallback',()=>{
  assert.match(runtime,/disableAnimations/);
  assert.match(runtime,/assets\[current\], assets\.first/);
  assert.match(runtime,/_motion\.dispose\(\)/);
  assert.match(runtime,/errorBuilder:/);
  assert.match(runtime,/_programmaticFallback/);
});
