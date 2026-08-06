# Phoenix Pull Request Evidence Record

> Checkboxes are declarations, not evidence. Every material claim MUST be supported by one or more exact paths, SHAs, Trees, CI runs, command outputs, screenshots, reproducible Preview paths, or Founder approval records.

## 1. PR identity

- Stable PR: `#137`
- Stable Commit: `5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977`
- Candidate Commit: `<full sha>`
- Candidate Tree: `<full sha>`
- Parent Commit: `<full sha>`
- Task scope: `<exact authorized scope>`
- Changed paths: `<exact added / modified / deleted paths>`
- Affected routes: `<exact routes or NONE>`
- Affected Journeys: `<exact Journey IDs or NONE>`

`docs/PHOENIX_STABLE_BASELINE_STANDARD.md` is the single normative authority for the current Stable PR and Stable Commit. Other governance documents may preserve permanent product rules but MUST NOT define a conflicting current baseline. Any conflict must be corrected, not silently ignored or hidden by deleting valid permanent-rule references.

PR `#132` is historical and is not the current development baseline. Closed PRs `#138`–`#141` are historical or problem evidence only. They MUST NOT be used as a development baseline.

## 2. Change declarations

- Visual change: `YES / NO`
- Core interaction change: `YES / NO`
- Audio change: `YES / NO`
- Rights impact: `YES / NO`
- Closed PR used as baseline: `YES / NO`
- Programmatic placeholder entered runtime: `YES / NO`
- Runtime code change: `YES / NO`
- Image or asset change: `YES / NO`
- Story or Journey data change: `YES / NO`
- Dependency change: `YES / NO`
- Workflow change: `YES / NO`
- External disclosure of unpublished Phoenix content: `YES / NO`

`Closed PR used as baseline` and `Programmatic placeholder entered runtime` MUST be `NO`.

## 3. Changed-path inventory

### Added

- `<path or NONE>`

### Modified

- `<path or NONE>`

### Deleted

- `<path or NONE>`

### Unexpected paths

- `NONE / <exact paths and reason>`

## 4. Implementation proof

Provide evidence for every applicable item:

- Correct page component: `<path + evidence>`
- Correct route and parameters: `<route + evidence>`
- Correct Journey ID / Story ID: `<IDs + evidence>`
- Correct data and language records: `<paths + evidence>`
- Correct asset paths: `<paths + runtime evidence>`
- Stable resources preserved: `<diff / mapping evidence>`
- Loading / Error / Empty / Fallback: `<routes + evidence>`
- Progress / Persistence / Reward / Entitlement: `<evidence>`
- Accessibility: `<evidence>`
- No unrelated changes: `<comparison evidence>`

## 5. STABLE_BASELINE_COMPARISON

Every development task MUST compare the candidate with the current approved stable `main`. The binding rule is:

`NEW RESULT >= CURRENT STABLE BASELINE`

Candidate Tree and Parent Commit MUST be present inside this comparison report, not only in PR identity. Compared Routes and Compared Journey IDs MUST be separate. Persistence and Access / Entitlement require independent results and evidence and are not implied by Function Result or by a checkbox.

```text
STABLE_BASELINE_COMPARISON

Stable PR: #137
Stable Commit: 5fcadcb4a1c424706957e9d6bd72cc7f9f2c6977

Candidate Commit:
Candidate Tree:
Parent Commit:

Changed Scope:
Changed Paths:

Compared Pages:
Compared Routes:
Compared Journey IDs:
Compared Features:
Compared Assets:

Visual Result:
Visual Evidence Level:

Functional Result:
Functional Evidence Level:

Interaction Result:
Interaction Evidence Level:

Mobile Result:
Mobile Evidence Level:

Performance Result:
Performance Evidence Level:

Content Result:
Content Evidence Level:

Audio Result:
Audio Evidence Level:

Accessibility Result:
Accessibility Evidence Level:

Persistence Result:
Persistence Evidence Level:

Access / Entitlement Result:
Access / Entitlement Evidence Level:

Rights Result:
Rights Evidence Level:

Unexpected Regression:
Founder Preview Required:
Founder Preview Link:
Founder Preview Result:
Final Comparison Decision:
```

Allowed Result values:

- `PASS`
- `REQUIRES_REVISION`
- `REGRESSION`
- `BLOCKED`
- `NOT_APPLICABLE`

Allowed Evidence Level values:

- `VERIFIED`
- `PARTIALLY_VERIFIED`
- `UNVERIFIED`
- `CONTRADICTORY`

`NOT_APPLICABLE` requires a scoped applicability reason and supporting evidence. It is not automatic `PASS`.

Missing any required field, Result, Evidence Level, or required applicability reason:

`INCOMPLETE_STABLE_BASELINE_COMPARISON_MISSING`

Any downgrade below the current stable baseline:

`REGRESSION_BLOCKS_READY_AND_MERGE`

## 6. Permanent Phoenix product verification

These are permanent product gates. They remain required when the changed scope touches them and MUST NOT be removed merely because a newer evidence format exists.

- [ ] Phoenix Agent 规则测试通过
- [ ] Flutter Analyze 通过
- [ ] Flutter Test 通过
- [ ] Web Release 构建通过
- [ ] 独立 PR 体验链接可以打开
- [ ] 思考、表达、旅程回忆键盘稳定
- [ ] 进度保存、简繁切换正常
- [ ] Loading、Error、Empty 与 Fallback 状态符合当前稳定基线
- [ ] 免费、付费、随机、解锁与未解锁状态均按适用范围验证
- [ ] 未经用户体验确认不得合并到 `main`
- [ ] 一个 PR 只开发或修复一项明确授权的功能或范围

## 7. Narration verification

Narration changes MUST follow the permanent narration development rules and preserve one consistent runtime state model.

- [ ] 故事页朗读、暂停、继续、调速正常
- [ ] 发现页朗读、暂停、继续、调速正常
- [ ] 所有朗读默认 `1.0×` 本地自然语速，范围为 `0.5×–1.5×`
- [ ] 速度数字下方显示“减速 / 加速”，每次固定变化 `0.1×`，调整后全部朗读入口同步同一倍率
- [ ] 中文、英文、越南语使用正确本地语言与自然声音
- [ ] 声音、三角形、短文高亮同步
- [ ] 声音、进度、百分比、当前段落和字符三角形同步
- [ ] 生词与「注」临时朗读后从原准确位置继续
- [ ] 所有朗读入口共用 `NarrationController`，没有独立播放状态或计时器
- [ ] 朗读失败、暂停、继续、调速与页面离开后的状态恢复具有可复现证据

## 8. Vocabulary verification

Vocabulary behavior MUST remain consistent across Story and Discovery and MUST use prepared, reviewed Journey content rather than runtime placeholder generation.

- [ ] 故事页与发现页生词均显示词性、探索者母语和英文释义
- [ ] 所有普通与特别旅程的故事、发现均为 1–2 段，并随 HSK / TOCFL 水平变化
- [ ] 故事保持叙事与意义，发现保持文化解释，两者没有复制粘贴凑长度
- [ ] 每个已发布生词都随 Journey 内容包预下载真实应用例句
- [ ] 点开生词立即读取本地例句，不现场请求 AI，也不显示等待生成状态
- [ ] 预下载例句包含目标词、完整拼音、探索者母语、英文和用法说明
- [ ] PhoenixVocabularyAgent 与 PhoenixQualityAgent 只在内容制作阶段生成并复核例句
- [ ] 例句没有“故事里出现了这个词”等万能占位句
- [ ] 生词查看与朗读正常

## 9. Journey access verification

Journey access behavior MUST be proven for the applicable development, Preview, free, paid, random, locked, and unlocked states.

- [ ] 开发分支与 PR 体验版保持全部旅程开放
- [ ] 免费探索者每天稳定随机早晚各一段，同日两段不重复
- [ ] 同一用户、同一日期、同一时段在刷新、重启与重新登录后不重新抽取
- [ ] 下午释放后，当天已释放的 Journey 仍可继续使用
- [ ] 付费探索者可以打开全部已发布旅程
- [ ] 免费、付费与随机旅程权限统一经过 `JourneyAccessPolicy`
- [ ] 商业时段与策略保持可配置，没有硬编码进 Journey 内容
- [ ] Journey access evidence includes account state, mode, stable test identifier, local date/timezone, slot, Journey ID, route, expected result, actual result, and persistence result

## 10. AI orchestration, privacy, Secret and disclosure verification

All online AI behavior MUST use the approved orchestration path, provider order, privacy boundaries, and Secret storage rules.

- [ ] PhoenixBrainAgent 是唯一 AI 总调度入口
- [ ] Guide / Writing / Conversation / Learning 在线功能由 PhoenixBrainAgent 调度并经过 PhoenixQualityAgent 隐藏复核
- [ ] Vocabulary 内容制作由 PhoenixBrainAgent 调度并在发布前写入 Journey 内容包
- [ ] GPT-5.6 通过 OpenAI Responses API 优先运行，Cloudflare Workers AI 自动回退
- [ ] PhoenixMemoryAgent 只处理有限客户端学习档案，服务器不持久保存
- [ ] PhoenixKnowledgeAgent 只提供已审核 Journey 背景
- [ ] 在线 AI 返回 orchestrator / provider / model / quality / memory / knowledge
- [ ] `OPENAI_API_KEY` 仅存在于 Cloudflare Secret，仓库与客户端没有密钥
- [ ] 仓库、客户端、日志、Preview 与截图中没有 Secret
- [ ] 未发布 Phoenix 内容没有发送到未经批准的外部服务
- [ ] External disclosure of unpublished Phoenix content is `NO`, or an exact approved exception and scope are recorded

## 11. Visual and rights verification

- Visual change: `YES / NO`
- Stable comparison captures: `<links / paths / NONE>`
- Candidate captures: `<links / paths / NONE>`
- Tested devices and viewports: `<details / NONE>`
- Mobile crop and focal point result: `<result + evidence / NOT_APPLICABLE with reason>`
- Safe-area and small-screen result: `<result + evidence / NOT_APPLICABLE with reason>`
- Reduced-motion result: `<result + evidence / NOT_APPLICABLE with reason>`
- Founder approval state: `APPROVED / REJECTED / PENDING / NOT_REQUIRED`
- Founder approval record: `<exact record / NONE>`
- Rights-impact paths: `<paths / NONE>`
- Source / license / permission / creation evidence: `<records / NONE>`
- Technical gate: `<result>`
- Visual quality gate: `<result>`
- Stable comparison gate: `<result>`
- Founder approval gate: `<result>`

PR `#137` is the minimum visual standard. Rights evidence, file existence, hashes, dimensions, automated fields, or CI success do not establish visual approval.

Production use is prohibited for low-detail programmatic SVG/WebP, flat backgrounds, simple gradients with circles, rectangles or a few paths, recolored templates, repeated compositions, placeholders, or visuals below the stable baseline. Programmatic visuals are permitted only for an approved fallback, non-release temporary placeholder, isolated experiment Preview, or a Founder-approved design direction. Batch visual replacement requires Founder mobile approval.

Rights approval is separate from visual approval. Rights compliance MUST NOT be achieved by reducing product or visual quality below the stable baseline.

## 12. Technical and CI evidence

| Check | Candidate Commit | Run / Command | Status | Evidence |
|---|---|---|---|---|
| Phoenix Agent rules |  |  | `NOT_TRIGGERED / QUEUED / IN_PROGRESS / SUCCESS / FAILURE / CANCELLED / NOT_RUN_NO_LOCAL_EXECUTION_ENVIRONMENT` |  |
| Flutter Analyze |  |  |  |  |
| Flutter Test |  |  |  |  |
| Web Release build |  |  |  |  |
| Cloudflare Worker bundle |  |  |  |  |
| Route / data validation |  |  |  |  |
| Asset validation |  |  |  |  |
| Accessibility validation |  |  |  |  |
| Other |  |  |  |  |

Do not report a local command as run when no local execution environment was available. A non-terminal check is not `SUCCESS`.

## 13. Regression, Preview, Founder approval and final decision

### Preview evidence

- Preview link: `<reproducible link / NOT_AVAILABLE>`
- Candidate Commit tied to Preview: `<sha / UNVERIFIED>`
- Entry route and steps: `<exact instructions>`
- Pages and Journeys tested: `<list>`
- Tested account/access states: `<list>`
- Preview result: `<result + evidence level>`

A deployed Preview does not by itself prove functional, visual, interaction, audio, performance, persistence, access, accessibility, or mobile quality.

### Regression result

- Unexpected regression: `NONE / <details>`
- Issue Severity: `NONE / P0 / P1 / P2 / P3`
- Affected stable evidence: `<details>`
- Required repair or restoration: `<details / NONE>`
- Verification after repair: `<details / NONE>`

Any regression blocks Completed, Ready, merge, batch expansion, and the next stage.

### Final decision

- CI evidence: `<actual terminal status and run IDs>`
- Stable comparison: `PASS / REQUIRES_REVISION / REGRESSION / BLOCKED`
- Founder approval state: `APPROVED / REJECTED / PENDING / NOT_REQUIRED`
- Final decision: `DRAFT / REQUIRES_REVISION / BLOCKED / READY_REQUESTED / MERGE_REQUESTED`
- Explicit authorization for Ready: `YES / NO`
- Explicit authorization for merge: `YES / NO`

## 14. Merge checklist

- [ ] PR is based on the latest approved stable `main` identified by `docs/PHOENIX_STABLE_BASELINE_STANDARD.md`.
- [ ] Stable PR and Stable Commit are exact.
- [ ] Candidate Commit, Tree, and Parent are recorded inside the comparison report.
- [ ] Task scope and changed paths are complete.
- [ ] No closed PR is used as the baseline.
- [ ] No unauthorized or unrelated file is changed.
- [ ] Correct pages, routes, IDs, records, and assets are proven.
- [ ] Required Loading, Error, Empty, and Fallback states are verified.
- [ ] Required permanent narration, vocabulary, Journey access, AI, privacy and Secret gates are verified when applicable.
- [ ] Required technical checks reached actual terminal conclusions.
- [ ] The complete `STABLE_BASELINE_COMPARISON` is present.
- [ ] Function, visual, interaction, mobile, performance, content, audio, accessibility, rights, persistence and access results are not below the stable baseline.
- [ ] Every `NOT_APPLICABLE` result has a reason and evidence.
- [ ] Visual or core interaction changes have explicit Founder mobile approval.
- [ ] Programmatic placeholders did not enter runtime.
- [ ] Rights evidence is not being used as visual approval.
- [ ] No unpublished Phoenix content was disclosed to an unapproved external service.
- [ ] No regression remains unresolved.
- [ ] 用户已确认可以合并到 `main`
- [ ] Ready and merge actions match explicit authorization.

未经体验确认，不合并到 `main`。Checkbox is not evidence, and checked boxes do not override contradictory evidence or missing proof.

## 15. Permanent rule references

### Stable-baseline authority

- `docs/PHOENIX_STABLE_BASELINE_STANDARD.md` is the single normative authority for Stable PR and Stable Commit identity.

### Product standards

- `docs/PHOENIX_PRODUCT_QUALITY_STANDARD.md`
- `docs/PHOENIX_UI_VISUAL_STANDARD.md`
- `docs/PHOENIX_JOURNEY_SYSTEM_STANDARD.md`
- `docs/PHOENIX_NEW_JOURNEY_CREATION_STANDARD.md`
- `docs/PHOENIX_FULL_APPLICATION_AUDIT_STANDARD.md`
- `docs/PHOENIX_DEVELOPMENT_COMPLETION_STANDARD.md`
- `docs/PHOENIX_QUALITY_UNIFICATION_ROADMAP.md`

### Permanent product rules

- `docs/development-workflow.md` → 「永久朗读开发准则」
- `docs/development-workflow.md` → 「永久生词展示与例句准则」
- `docs/development-workflow.md` → 「永久 AI Agent 开发准则」
- `docs/development-workflow.md` → 「永久旅程访问与订阅准则」

The permanent product rules and the mandatory Stable Baseline Comparison apply together. Neither replaces the other. The latest approved stable `main` remains the only valid development baseline. It changes only after explicit Founder approval and merge into `main`.

## 16. Narrative and Discovery Evidence

Required for every Story, Discovery, or Journey-content PR under [Phoenix Narrative and Discovery Standard](docs/PHOENIX_NARRATIVE_AND_DISCOVERY_STANDARD.md).

```text
Affected Journey IDs:
Story Function:
Discovery Function:
Protagonist Mode:
Protagonist Identity Evidence:
Relationship:
Relationship Causal Function:
Goal:
Why Goal Matters:
Conflict:
Conflict Connection to Goal:
Enacted Choice:
Choice Evidence:
Caused Consequence:
Consequence Causal Evidence:
Emotional Arc:
Cultural Anchor in Action:
Narrative Engine:
Opening Type:
Progression Structure:
Climax:
Ending State:
Memory Anchor:
Special Mechanism:
Catalog Comparison:
Level Invariants:
Automated Check Scope:
Checks Not Covered by Automation:
Automated Structural Result:
Human Literary Review:
Human Literary Result:
Founder Preview Requirement:
```

Required declarations:

```text
Story / Discovery functional overlap: NONE / DETAILS
Narrative template reuse: NONE / DETAILS
Automated score used as literary approval: NO
Batch size: <count>
Pilot approval: APPROVED / REJECTED / PENDING / NOT_APPLICABLE
```

- [ ] Story and Discovery each submit a Function Contract.
- [ ] Generic second-person perspective alone is not used as protagonist identity.
- [ ] Relationship causality, enacted Choice, and caused Consequence have exact evidence.
- [ ] Opening, climax, and ending state are independently reviewed.
- [ ] Story / Discovery functional separation is reviewed beyond exact-text difference.
- [ ] A current-catalog differentiation matrix is attached.
- [ ] Phoenix Lv.1 through Lv.10 narrative invariants are recorded.
- [ ] Automated structural checks are separated from human literary approval.
- [ ] One normal pilot and one special pilot follow the binding order.
- [ ] Default controlled batch size is two to three Journeys after pilot approval.
- [ ] No second pilot or batch rewrite begins before the required prior Founder decision.

## 17. PHOENIX DEVELOPMENT AGENT TASK CONTRACT

This section extends the existing Phoenix Evidence Record. It does not replace Stable Baseline, Visual, Narration, Access, AI, Privacy, Secret, Evidence, or Founder gates.

- Task ID: `<required>`
- Task Mode: `READ_ONLY_AUDIT / AUTHORIZED_REMEDIATION / GOVERNANCE_DOCUMENTATION / RUNTIME_DEVELOPMENT / VISUAL_REMEDIATION`
- Authorized Scope: `<exact scope>`
- Allowed Paths: `<exact paths or glob patterns>`
- Forbidden Paths: `<exact paths or glob patterns>`
- Base SHA: `<full sha>`
- Candidate SHA: `<full sha>`
- Applicable Rule IDs: `<PDA-R...>`
- Builder Agent: `<agent_id>`
- Auditor Agent: `<different agent_id>`
- Required Tests: `<exact checks>`
- Required Evidence: `<exact evidence classes>`
- Founder Experience Required: `YES / NO`
- Ready Authorization: `PRESENT / NOT_PRESENT`
- Merge Authorization: `PRESENT / NOT_PRESENT`
- External Disclosure: `NOT_PERMITTED / <approved exact exception>`
- Scope Expansion Status: `NONE / AUTHORIZATION_REQUIRED / AUTHORIZED`

The machine-readable JSON block is required for Phoenix Agent Audit Workflow execution.

<!-- PHOENIX_TASK_CONTRACT_JSON_START -->
```json
{
  "task_id": "<required>",
  "task_title": "<required>",
  "task_mode": "READ_ONLY_AUDIT",
  "repository": "dhv5bnmfmh-cmyk/phoenix-journeys",
  "expected_main": "<full sha>",
  "base_branch": "main",
  "base_sha": "<full sha>",
  "head_branch": "<branch>",
  "initial_head_sha": "<full sha>",
  "current_head_sha": "<full sha>",
  "authorized_scope": "<exact authorized scope>",
  "allowed_paths": [],
  "forbidden_paths": [],
  "authorized_findings": [],
  "prohibited_actions": [],
  "applicable_rules": [],
  "required_tests": [],
  "required_evidence": [],
  "founder_gates": {
    "founder_experience_required": false,
    "founder_experience_result": "NOT_REQUIRED",
    "founder_governance_review": "REQUIRED",
    "ready_authorization": "NOT_PRESENT",
    "merge_authorization": "NOT_PRESENT",
    "preview_deletion_authorization": "NOT_PRESENT",
    "next_phase_authorization": "NOT_PRESENT"
  },
  "external_disclosure": {
    "permitted": false,
    "services": [],
    "content": []
  },
  "retry_limit": 0,
  "stop_conditions": [],
  "builder_agent": "PhoenixBuilderAgent",
  "auditor_agent": "PhoenixAuditAgent",
  "requested_agents": [
    "PhoenixGovernorAgent",
    "PhoenixPlannerAgent",
    "PhoenixVerifierAgent",
    "PhoenixAuditAgent"
  ],
  "requested_actions": [
    "READ_REPOSITORY",
    "VALIDATE_CONFIG",
    "GENERATE_AUDIT_REPORT"
  ]
}
```
<!-- PHOENIX_TASK_CONTRACT_JSON_END -->

- [ ] Builder and Auditor are different Agents.
- [ ] Builder and Remediator capabilities match their current manifest status.
- [ ] AI Review Result is `NOT_RUN` when no AI review actually executed.
- [ ] Deterministic Result, AI Review Result, Founder Gate Result, and Final Agent Decision are reported separately.
- [ ] Ready, Merge, Preview deletion, and next-phase authorization are independent gates.
- [ ] Scope expansion stops and waits for separate Founder authorization.
