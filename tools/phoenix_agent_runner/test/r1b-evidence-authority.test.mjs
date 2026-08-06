import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  AUDIT_MODES, assertTrustedSourceIdentity, assertAuditEvidenceMode,
  assertCanonicalFreshness,
} from '../src/identity-freshness.mjs';
import {
  TRUSTED_EVIDENCE_TYPES, normalizeRequiredEvidenceTypes,
  assertNoSelfAssertedEvidence, fetchAuthoritativeCiEvidence,
  fetchAuthoritativeFounderEvidence, produceTrustedEvidenceEntries,
} from '../src/evidence-authority.mjs';
import { createTrustedGithubRequest, requiredFounderAction } from '../src/trusted-cli.mjs';
import { validateObject } from '../src/schema-validator.mjs';

const sha=(c)=>c.repeat(40), dig=(c)=>c.repeat(64);
const identity={repository:'o/r',pr_number:148,base_branch:'main',base_sha:sha('a'),head_branch:'feature',candidate_sha:sha('b'),candidate_tree:sha('c'),task_contract_digest:dig('d'),governance_body_digest:dig('e'),workflow_run_id:'100',run_attempt:2};
const now=new Date('2026-08-06T00:00:00Z');
const root=resolve(import.meta.dirname,'../../..');
const founderSchema=JSON.parse(readFileSync(resolve(root,'ai/development/schemas/founder_authorization.schema.json'),'utf8'));
const policy={
  github_record_authority:{
    ci:{allowed_workflow_names:['Phoenix Agent Audit'],allowed_check_names:['Phoenix Agent Bootstrap Source Tests'],allowed_events:['pull_request']},
    founder:{allowed_github_identities:['founder'],allowed_author_associations:['OWNER']},
  },
};
const run=(o={})=>({id:7,name:'Phoenix Agent Audit',repository:{full_name:'o/r'},head_sha:identity.candidate_sha,status:'completed',conclusion:'success',run_attempt:2,event:'pull_request',created_at:'2026-08-05T23:00:00Z',updated_at:'2026-08-05T23:01:00Z',url:'https://api.github.com/repos/o/r/actions/runs/7',...o});
const auth=(o={})=>({trust_class:'TRUSTED_GITHUB_RECORD',repository:'o/r',pr_number:148,exact_head:identity.candidate_sha,action_type:'GOVERNANCE_PASS',founder_github_identity:'founder',trusted_evidence_source:'https://api.github.com/repos/o/r/pulls/148/reviews/9',issued_at:'2026-08-05T23:00:00Z',expires_at:null,revoked:false,...o});
const body=(a)=>`<!-- PHOENIX_FOUNDER_AUTHORIZATION_JSON_START -->\n\`\`\`json\n${JSON.stringify(a)}\n\`\`\`\n<!-- PHOENIX_FOUNDER_AUTHORIZATION_JSON_END -->`;
const review=(a=auth(),o={})=>({id:9,state:'APPROVED',url:'https://api.github.com/repos/o/r/pulls/148/reviews/9',body:body(a),user:{login:'founder'},author_association:'OWNER',submitted_at:'2026-08-05T23:00:00Z',...o});
const founderArgs=(record)=>({repository:'o/r',prNumber:148,identity,reference:{review_id:'9'},expectedAction:'GOVERNANCE_PASS',policy,founderSchema,validateAuthorization:validateObject,request:async()=>record,now});
const ciArgs=(record)=>({repository:'o/r',identity,reference:{workflow_run_id:'7'},policy,request:async()=>record});

// Trusted source and previous Evidence identity.
test('1 exact trusted checkout SHA equals live Base SHA',()=>assert.equal(assertTrustedSourceIdentity({observedTrustedCheckoutSha:identity.base_sha,declaredTrustedCheckoutSha:identity.base_sha,authorizedTrustedSourceSha:identity.base_sha,liveBaseSha:identity.base_sha}),true));
test('2 trusted checkout SHA mismatch blocks',()=>assert.throws(()=>assertTrustedSourceIdentity({observedTrustedCheckoutSha:sha('f'),declaredTrustedCheckoutSha:sha('f'),authorizedTrustedSourceSha:identity.base_sha,liveBaseSha:identity.base_sha}),/TRUSTED_SOURCE_IDENTITY_MISMATCH/u));
test('3 workflow dispatch default-branch race blocks',()=>assert.throws(()=>assertTrustedSourceIdentity({observedTrustedCheckoutSha:sha('f'),declaredTrustedCheckoutSha:sha('f'),authorizedTrustedSourceSha:sha('f'),liveBaseSha:identity.base_sha}),/TRUSTED_SOURCE_IDENTITY_MISMATCH/u));
test('4 Base branch same SHA retarget blocks',()=>assert.throws(()=>assertCanonicalFreshness({...identity,base_branch:'release'},identity),/EVIDENCE_STALE_REAUDIT_REQUIRED/u));
test('5 FRESH_AUDIT with no old Evidence passes',()=>assert.equal(assertAuditEvidenceMode({auditMode:'FRESH_AUDIT',previousEvidence:null,currentIdentity:identity}),'FRESH_AUDIT'));
test('6 REAUDIT missing previous identity blocks',()=>assert.throws(()=>assertAuditEvidenceMode({auditMode:'REAUDIT',previousEvidence:null,currentIdentity:identity}),/PREVIOUS_EVIDENCE_REQUIRED/u));
test('7 REAUDIT old run ID blocks',()=>assert.throws(()=>assertAuditEvidenceMode({auditMode:'REAUDIT',previousEvidence:{...identity,workflow_run_id:'99'},currentIdentity:identity}),/EVIDENCE_STALE_REAUDIT_REQUIRED/u));
test('8 REAUDIT old attempt blocks',()=>assert.throws(()=>assertAuditEvidenceMode({auditMode:'REAUDIT',previousEvidence:{...identity,run_attempt:1},currentIdentity:identity}),/EVIDENCE_STALE_REAUDIT_REQUIRED/u));
test('9 no-op Commit old SHA blocks',()=>assert.throws(()=>assertAuditEvidenceMode({auditMode:'REAUDIT',previousEvidence:{...identity,candidate_sha:sha('f')},currentIdentity:identity}),/EVIDENCE_STALE_REAUDIT_REQUIRED/u));
test('10 old Artifact identity tree blocks',()=>assert.throws(()=>assertAuditEvidenceMode({auditMode:'REAUDIT',previousEvidence:{...identity,candidate_tree:sha('f')},currentIdentity:identity}),/EVIDENCE_STALE_REAUDIT_REQUIRED/u));
test('explicit audit mode inventory',()=>assert.deepEqual(AUDIT_MODES,['FRESH_AUDIT','REAUDIT']));

// CI authority.
test('11 fabricated CI JSON blocks',()=>assert.throws(()=>assertNoSelfAssertedEvidence({PHOENIX_CI_EVIDENCE_JSON:'{"result":"PASS"}'}),/SELF_ASSERTED_CI_EVIDENCE_FORBIDDEN/u));
test('12 missing Check or Workflow Run ID blocks',async()=>assert.rejects(fetchAuthoritativeCiEvidence({...ciArgs(run()),reference:{}}),/CI_GITHUB_RECORD_REFERENCE_REQUIRED/u));
test('13 nonexistent Run ID fails closed',async()=>assert.rejects(fetchAuthoritativeCiEvidence({...ciArgs(run()),request:async()=>{throw Object.assign(new Error('404'),{code:'TRUSTED_GITHUB_API_REQUEST_FAILED:404'});}}),/404/u));
test('14 Run belongs to other Repository blocks',async()=>assert.rejects(fetchAuthoritativeCiEvidence(ciArgs(run({repository:{full_name:'x/y'}}))),/REPOSITORY_MISMATCH/u));
test('15 Run belongs to old Head blocks',async()=>assert.rejects(fetchAuthoritativeCiEvidence(ciArgs(run({head_sha:sha('f')}))),/HEAD_MISMATCH/u));
test('16 non-terminal Run blocks',async()=>assert.rejects(fetchAuthoritativeCiEvidence(ciArgs(run({status:'in_progress',conclusion:null}))),/NOT_TERMINAL/u));
test('17 failed Run blocks',async()=>assert.rejects(fetchAuthoritativeCiEvidence(ciArgs(run({conclusion:'failure'}))),/NOT_SUCCESS/u));
test('18 valid terminal exact-Head GitHub Run passes',async()=>assert.equal((await fetchAuthoritativeCiEvidence(ciArgs(run()))).authority,'GITHUB_API_VERIFIED'));
test('old CI run attempt blocks',async()=>assert.rejects(fetchAuthoritativeCiEvidence(ciArgs(run({run_attempt:1}))),/ATTEMPT_MISMATCH/u));
test('candidate trust_class cannot create CI PASS',()=>assert.throws(()=>produceTrustedEvidenceEntries({identity,requiredTypes:['ci'],proofs:{ci:{authority:'CANDIDATE_CLAIM',record_id:7,record_url:'x',status:'completed',conclusion:'success',head_sha:identity.candidate_sha,repository:'o/r',run_attempt:2,source:'x',command_or_path:'x'}},producedAt:now.toISOString()}),/GITHUB_AUTHORITY_MISSING/u));

// Founder authority.
test('19 fabricated TRUSTED_GITHUB_RECORD JSON blocks',()=>assert.throws(()=>assertNoSelfAssertedEvidence({PHOENIX_FOUNDER_EVIDENCE_JSON:'{"trust_class":"TRUSTED_GITHUB_RECORD"}'}),/SELF_ASSERTED_FOUNDER_EVIDENCE_FORBIDDEN/u));
test('20 missing Founder record ID blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence({...founderArgs(review()),reference:{}}),/RECORD_REFERENCE_REQUIRED/u));
test('21 wrong Founder identity blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({founder_github_identity:'attacker'})))),/IDENTITY_MISMATCH/u));
test('22 wrong PR blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({pr_number:149})))),/PR_MISMATCH/u));
test('23 wrong Head blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({exact_head:sha('f')})))),/HEAD_MISMATCH/u));
test('24 wrong action type blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({action_type:'READY_AUTHORIZATION'})))),/ACTION_MISMATCH/u));
test('25 MERGE authorization cannot replace READY',async()=>assert.rejects(fetchAuthoritativeFounderEvidence({...founderArgs(review(auth({action_type:'MERGE_AUTHORIZATION'}))),expectedAction:'READY_AUTHORIZATION'}),/ACTION_MISMATCH/u));
test('26 READY authorization cannot replace GOVERNANCE',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({action_type:'READY_AUTHORIZATION'})))),/ACTION_MISMATCH/u));
test('27 expired authorization blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({expires_at:'2026-08-05T23:30:00Z'})))),/EXPIRED/u));
test('28 revoked authorization blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({revoked:true})))),/REVOKED/u));
test('29 malformed issued_at blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({issued_at:'bad'})))),/SCHEMA_INVALID|ISSUED_AT_INVALID/u));
test('30 valid GitHub Founder record exact action and Head passes',async()=>assert.equal((await fetchAuthoritativeFounderEvidence(founderArgs(review()))).authority,'GITHUB_API_VERIFIED'));
test('non-Founder GitHub identity blocks',async()=>assert.rejects(fetchAuthoritativeFounderEvidence(founderArgs(review(auth({founder_github_identity:'attacker'}),{user:{login:'attacker'},author_association:'NONE'}))),/IDENTITY_NOT_ALLOWED/u));
test('Founder record schema is authoritative',()=>assert.equal(validateObject(founderSchema,auth(),'founder_authorization').action_type,'GOVERNANCE_PASS'));
test('action mapping is exact',()=>{assert.equal(requiredFounderAction({requested_actions:['READY']}),'READY_AUTHORIZATION');assert.equal(requiredFounderAction({requested_actions:[]}),'GOVERNANCE_PASS');});
test('trusted GitHub client rejects untrusted API path',async()=>{const request=createTrustedGithubRequest({repository:'o/r',token:'test',apiUrl:'https://api.github.com',fetchImpl:async()=>({ok:true,json:async()=>({})})});await assert.rejects(request('/repos/x/y/actions/runs/1'),/API_PATH_INVALID/u);});
test('evidence inventory remains exact',()=>assert.deepEqual(normalizeRequiredEvidenceTypes(['repository evidence','commit evidence','diff evidence','changed paths evidence','test evidence','ci evidence','workflow evidence','founder evidence']),TRUSTED_EVIDENCE_TYPES));
