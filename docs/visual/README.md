# Phoenix Visual System

Documentation Status: Active
Documentation Version: 1.0.0
Priority: Visual Documentation Navigation Entry
Owner: Phoenix Visual Architecture
Last Review Date: 2026-08-01
Visual System Review Status: `VISUAL_SYSTEM_V1_APPROVED`

---

# 1. Purpose

Phoenix Visual System 是 Phoenix 全部视觉资源的正式专业规范体系。本 README 是唯一入口，负责导航、读取顺序、职责边界、任务路径、版本状态与维护规则；它不重复或降低专业文件中的正式规则。

Visual System 管理图片、背景、地图、护照、Journey 视觉、页面视觉、动画来源、程序化视觉、UI 插画、Icon、Banner、Loading、Splash 及其生成、审核、导入、运行和降级。它不定义 Story 内容、Learning 规则、UI 业务逻辑、Audio 行为、代码架构或 Release 授权。

Visual System 的基本承诺是：视觉服务 Story、阅读、Learning 与探索。美观、动效和技术复杂度不得覆盖文化真实性、版权、可读性、交互、无障碍、性能、设备适配或页面级 QA。

# 2. Visual System v1.0 Status

Phoenix Visual System v1.0 已完成规范体系审核并封版：

| Item | Result |
|---|---|
| Documentation Status | `Active` |
| Documentation Version | `1.0.0` |
| Review Decision | `VISUAL_SYSTEM_V1_APPROVED` |
| Review Scope | `docs/visual/` 全部 13 个 Markdown 文件 |
| P0 / P1 | `0 / 0` |
| Open blocking issue | None |
| Product implementation claim | None；本状态只批准规范体系，不证明真实资源或软件已经合规 |

v1.0 封版不代表规范永不更新。任何后续变更必须按 Systems Lifecycle、Priority 和本文件第 11 节传播；不得静默改变已批准规则。

# 3. Authority and Priority

Visual 任务遵守 `docs/systems/SYSTEM_PRIORITY.md` 的唯一顺序：

1. 用户当前明确指令。
2. 安全、法律和平台限制；这是不可覆盖的 Boundary Gate。
3. `PHOENIX_CONSTITUTION`（真实存在且状态有效时）。
4. `PRODUCT_PRINCIPLES`（真实存在且状态有效时）。
5. Systems Documentation。
6. `VISUAL_CONSTITUTION.md`。
7. `VISUAL_PHILOSOPHY.md`。
8. `VISUAL_GUIDELINES.md` 与适用专业 Guidelines。
9. `VISUAL_DECISION_TREE.md`。
10. `VISUAL_PIPELINE.md`。
11. `IMAGE_QUALITY_GATE.md`。
12. `VISUAL_CHECKLIST.md`。
13. `VISUAL_REVIEW_PROMPT.md`。
14. ROADMAP、TODO、CHANGELOG。
15. 代码与既有资源只作为实现事实和证据。

`COPYRIGHT_POLICY.md` 与 `PERFORMANCE_GUIDE.md` 是专业规范：分别在权利与性能范围内约束 Decision Tree、Pipeline、Gate、Checklist 和 Review，但不得违反 Constitution、Philosophy 或 Guidelines。专项规则只在自身范围内优先于通用规则。

高位规范缺失、状态无效或冲突无法裁决时，必须停止受影响的生成、导入、Preview 或 Release 判断并报告，不得由 AI、代码或旧资源补写缺失权威。

# 4. Visual System Inventory

`docs/visual/` 当前正式文件共 13 个：

| Order | File | Unique responsibility | Status | Version |
|---:|---|---|---|---|
| 1 | [`README.md`](./README.md) | 唯一入口、导航、状态、读取路径与维护 | Active | 1.0.0 |
| 2 | [`VISUAL_CONSTITUTION.md`](./VISUAL_CONSTITUTION.md) | Visual System 不可违反的最高专业原则 | Active | 1.0.0 |
| 3 | [`VISUAL_PHILOSOPHY.md`](./VISUAL_PHILOSOPHY.md) | 视觉理念、美学判断、阅读与学习取舍 | Active | 1.0.0 |
| 4 | [`VISUAL_GUIDELINES.md`](./VISUAL_GUIDELINES.md) | 全部视觉资源的通用执行标准 | Active | 1.0.0 |
| 5 | [`BACKGROUND_GUIDELINES.md`](./BACKGROUND_GUIDELINES.md) | 静态、动态、Journey 与页面背景专项规则 | Active | 1.0.0 |
| 6 | [`AI_IMAGE_GENERATION_GUIDE.md`](./AI_IMAGE_GENERATION_GUIDE.md) | AI 图片 Prompt、生成、原始输出、缺陷与导出流程 | Active | 1.0.0 |
| 7 | [`COPYRIGHT_POLICY.md`](./COPYRIGHT_POLICY.md) | 原创、版权、商标、人格/隐私、授权与 Rights Record | Active | 1.0.0 |
| 8 | [`PERFORMANCE_GUIDE.md`](./PERFORMANCE_GUIDE.md) | 格式、预算、加载、缓存、生命周期、设备与降级 | Active | 1.0.0 |
| 9 | [`VISUAL_DECISION_TREE.md`](./VISUAL_DECISION_TREE.md) | 资源、Journey、风险、形式和技术方案路由 | Active | 1.0.0 |
| 10 | [`VISUAL_PIPELINE.md`](./VISUAL_PIPELINE.md) | 从需求到导入、页面 QA 和 Release 资格的生产流程 | Active | 1.0.0 |
| 11 | [`IMAGE_QUALITY_GATE.md`](./IMAGE_QUALITY_GATE.md) | Gate 0–17、Blocker、证据、评分和发布质量判定 | Active | 1.0.0 |
| 12 | [`VISUAL_CHECKLIST.md`](./VISUAL_CHECKLIST.md) | 可勾选、可留证、可审计的执行检查 | Active | 1.0.0 |
| 13 | [`VISUAL_REVIEW_PROMPT.md`](./VISUAL_REVIEW_PROMPT.md) | 固定独立综合 Review、问题分级、评分与决定 | Active | 1.0.0 |

当前 v1.0 不包含第二入口、Visual Roadmap、独立 Style Guide 或独立 Animation Guidelines。风格通用规则由 Constitution、Philosophy 与 Guidelines 管理；背景动效由 Background Guidelines 管理；技术形式、运动质量、性能、降级与审核分别由 Decision Tree、Pipeline、Performance Guide、Gate、Checklist 和 Review 管理。未来是否拆分新文件必须经过正式 Documentation 变更，不能引用不存在的文件。

# 5. Mandatory Reading Order

任何 Visual 任务必须按以下顺序读取真实存在且适用的文件：

1. 当前用户明确指令、Repository README 与目标 Branch/Commit。
2. `docs/systems/README.md`。
3. `docs/systems/SYSTEM_ARCHITECTURE.md`。
4. `docs/systems/SYSTEM_DEPENDENCY.md`。
5. `docs/systems/SYSTEM_LIFECYCLE.md`。
6. `docs/systems/SYSTEM_PRIORITY.md`。
7. 目标 Journey 的 Approved Story Contract，以及适用的 Story README、Constitution、Philosophy、Decision Tree、Pipeline 与 Checklist。
8. 本 README。
9. `VISUAL_CONSTITUTION.md`。
10. `VISUAL_PHILOSOPHY.md`。
11. `VISUAL_GUIDELINES.md`。
12. 适用专业规范：Background、AI Generation、Copyright、Performance。
13. `VISUAL_DECISION_TREE.md`。
14. `VISUAL_PIPELINE.md`。
15. `IMAGE_QUALITY_GATE.md`。
16. `VISUAL_CHECKLIST.md`。
17. `VISUAL_REVIEW_PROMPT.md`。
18. 真实目标页面、代码、资源、构建、设备与 Evidence。

尚未建立正式规范的 Learning、UI/UX、Audio、Animation、Accessibility、QA 或 Release System，只能按真实存在的 Systems 接口、当前需求和实现证据参与协作；不得声称这些系统已封版，也不得虚构缺失规则。

# 6. Task Reading Paths

所有路径都先执行第 5 节；下表只列任务额外重点，不是跳读许可。

| Task | Required focus | Mandatory outcome |
|---|---|---|
| 普通 Journey | Story Contract → Background → Copyright → Decision Tree Ordinary Path → Pipeline | 地方文化、现实空间、独立视觉身份、设备与页面证据 |
| 特别 Journey | 原典/文化 Evidence → Background → Copyright → Decision Tree Special Path → Pipeline | 尊重原典精神；幻想不廉价、不现代网文模板化 |
| 静态背景 | Background → Decision Tree Static Path → Performance | 构图、安全区、响应式 Variant 与运行时预算 |
| 动态背景/动画 | Background → Decision Tree Motion/Form Path → Performance | 动态必要性、自然度、Reduced Motion、离页释放与高清静态降级 |
| AI 原创图片 | AI Generation → Copyright → Decision Tree AI/Copyright Path | Prompt、输入权利、原始输出、缺陷、Hash 与商业使用证据 |
| 人物/建筑/文化场景 | Story/Cultural Evidence → AI Generation → Copyright → Decision Tree People/Architecture Path | 结构、时代、地区、肖像、隐私、商标和文化真实性通过 |
| 首页/地图/护照 | Visual Guidelines → Background → Copyright → Performance → Resource Route | 热点、地理、裁切、按需加载、缓存和页面状态恢复 |
| 故事/生词/发现/挑战/留下印象/盖章 | Story Contract → Visual Guidelines → Background → UI/Learning Interface Evidence | 不抢阅读、按钮、朗读或学习流程；页面级 QA 完整 |
| Banner/Loading/Splash/UI 插画/Icon | Visual Guidelines → Copyright → Performance → 对应 Resource Route | 用途明确、语义/装饰边界、格式、体积和失败路径 |
| 视频/Canvas/WebGL/程序化效果 | Decision Tree Form Path → Performance → Copyright（含依赖/输入） | 必要性、兼容、Context/内存/电池、回退和无障碍替代 |
| 视觉 Review | Gate → Checklist → Review Prompt → 真实页面 Evidence | 统一 Finding、评分、复审范围和 Preview/Release 判断 |
| 性能优化 | Performance → Gate 12 → Checklist 性能/设备/生命周期项 | 不以画质破坏换数字，也不以画质为由突破 Blocker |

# 7. Closed Production and Review Loop

Phoenix v1.0 的正式闭环为：

```text
Requirement
→ Documentation Reading
→ Story/Page/Journey Analysis
→ Cultural and Visual Research
→ Visual Direction
→ Composition and Safe Areas
→ Static/Motion Decision
→ Prompt and Original Production
→ AI Error, Culture and Copyright Review
→ Device, Performance and Static Fallback
→ Pre-import Image Quality Gate
→ PRE_IMPORT Checklist
→ Independent Visual Review
→ Import into Phoenix
→ Runtime Gate and Checklist Completion
→ Page-level QA
→ Gate 17 Final Release Review
→ Approved Preview Evidence
→ Release System Authorization
```

Pipeline 定义每阶段目标、输入、动作、输出、负责人、进入/退出条件、强制 Gate 与失败返回。Decision Tree 只选择路径，不改变 Pipeline 或上游规则。Gate 判断质量；Checklist 验证执行和证据；Review Prompt 汇总独立审核，三者不能互相替代。

预导入 PASS 只允许导入真实目标页面继续 QA。素材生成、导入、Checklist、Review、Preview、Commit 或 PR 均不等于正式发布。只有同一 Candidate/Asset/Story/Journey/Commit/Build 的 Gate 0–17、Checklist、Independent Review、版权、文化、设备、性能、无障碍、静态降级和页面 QA 全部通过，Release System 才能判断正式发布。

# 8. Mandatory Blockers

## 8.1 Canonical Terms and Status Domains

Phoenix v1.0 的正式缺陷等级统一为 `P0 BLOCKER`、`P1 CRITICAL`、`P2 MAJOR`、`P3 MINOR`；资源级 AI Error 使用相同的 `BLOCKER`、`CRITICAL`、`MAJOR`、`MINOR` 严重度，不建立另一套中文状态值。

Gate 的持久化状态为 `NOT_STARTED`、`IN_REVIEW`、`BLOCKED`、`FAILED`、`CONDITIONAL_PASS`、`PASSED`、`WAIVED`。Checklist 的持久化状态按其执行职责使用 `NOT_STARTED`、`IN_PROGRESS`、`BLOCKED`、`FAILED`、`CONDITIONAL_PASS`、`PASSED`、`NOT_APPLICABLE`；`IN_PROGRESS` 与 `NOT_APPLICABLE` 不是 Gate 状态，不能跨域替换。Pipeline 阶段成功值统一为 `PASSED`。

综合 Review 的最终结论只使用 `REVIEW_BLOCKED_MISSING_EVIDENCE`、`REJECTED`、`BLOCKED`、`REQUIRES_REVISION`、`CONDITIONAL_PASS`、`APPROVED_FOR_PREVIEW`、`APPROVED_FOR_RELEASE`。Decision Tree 的 `ELIGIBLE_*` 是路由结果，不是 Review 或 Release 状态，也不自动授予 Preview/Release 权限。

## 8.2 Non-waivable Categories

以下类别不得 Waive、不得标记不适用、不得用评分补偿：

- 来源、版权、商业使用、商标、肖像或必要授权不明。
- Blocker/Critical AI Error、明显复制或严重生成痕迹。
- 严重文化、历史、地区、原典或宗教符号错误。
- 标题、正文、生词、字幕、按钮、导航、挑战选项或热点不可用。
- 视觉破坏朗读、Audio 状态或 Story → 生词 → 发现 → 挑战 → 留下印象 → 盖章流程。
- 闪烁、眩晕、动态不自然、严重掉帧或无同版本静态降级。
- 手机、平板、必要比例、弱网、低性能或 Reduced Motion 未验证。
- 严重体积、解码、GPU、内存、生命周期、缓存或页面恢复问题。
- 导入完整性错误、页面级 QA 未通过、Evidence/Commit/Build 不一致。

发现阻断项必须返回 Pipeline 最早根因阶段，修改真实资源或实现、更新版本化 Evidence，并重跑所有受影响 Gate、Checklist、Review 与页面 QA。禁止只改状态或 Review 文本。

# 9. Cross-system Interfaces

| System | Provides to Visual | Visual obligation | Boundary |
|---|---|---|---|
| Story | Journey Identity、人物、地点、时间、天气、情绪、文化、原典与不可改变意义 | 表达并保护同版本 Story；Story 变化后重审受影响视觉 | Visual 不改写 Story；Story 不规定视觉实现 |
| Learning | 学习目标、内容优先级和流程保护需求（真实存在时） | 不增加认知负担，不阻断学习步骤 | Visual 不创造 Learning Rule |
| UI/UX | 布局、组件、文字/按钮/导航/安全区与状态 Contract（真实存在时） | 构图适配真实交互并联合检查 | Visual 不定义业务交互 |
| Audio | 朗读、字幕、播放/暂停和媒体状态需求（真实存在时） | 动画与加载不抢占或阻断 Audio | Visual 不定义 Audio Engine |
| Accessibility | 对比、语义、运动减少和舒适性要求（真实存在时） | 提供等价静态与可感知状态 | 缺失正式规范时不得推断其已完成 |
| QA | 目标页面、设备、网络、状态和回归 Evidence | 提供可验证 Candidate、Fallback 和预期结果 | QA 验证规则，不创造视觉方向 |
| Release | Candidate、Commit、Build、授权与回滚要求 | 只交付全部 Gate 通过的版本 | Visual 不合并或发布 |

普通 Journey 必须保持真实地方文化；特别 Journey 必须尊重原典与文化精神。Visual 修改后重新检查 Story、Learning、UI、Audio、Accessibility、Performance 与 QA 接口；Story 或页面 Contract 修改后，相关 Visual Evidence 失效并按依赖范围复审。

# 10. AI and Developer Execution Rules

未来 AI 或开发者必须：

1. 锁定需求、Branch、Commit、Candidate、页面与 Journey。
2. 按第 5 节记录实际读取文件、状态和版本。
3. 使用 Decision Tree 选择唯一合法路径。
4. 按 Pipeline 生产并保留阶段输入、输出与失败历史。
5. AI 生成时保存 Prompt、模型/平台、输入权利、原始输出、选择、修改和 Hash。
6. 使用 Copyright Policy 判断商业使用；复杂法律问题升级人工审核。
7. 使用 Performance Guide 输出响应式、弱网、低性能、Reduced Motion 与静态降级方案。
8. 在真实目标页面执行 Gate、Checklist、Independent Review 与页面 QA。
9. Evidence 缺失时返回规定的 BLOCKED 状态，不得猜测 PASS。
10. 只输出资格判断；未经当前明确授权不得 Import、Preview、Merge 或 Release。

# 11. Version and Maintenance

Visual Documentation 使用 `Major.Minor.Patch`：

- Major：Visual Constitution、Architecture 或整体视觉身份发生兼容性破坏。
- Minor：新增正式规范或扩展不破坏既有原则的专业能力。
- Patch：术语、引用、排版、证据字段或不改变规则含义的澄清。

任何变更必须记录原因、受影响文件与版本，并按依赖方向同步 Constitution → Philosophy → Guidelines/专业规范 → Decision Tree → Pipeline → Gate → Checklist → Review Prompt → 实现与测试。高位变更未传播完成前，受影响 Candidate 不得进入正式版。

不得通过 README 创造专业规则，不得创建重复入口，不得用 ROADMAP、TODO、CHANGELOG 或代码反向修改正式规范。当前状态、历史重建来源和实际产品实现状态必须分开记录。

# 12. Phoenix Visual System v1.0 Review Record

本次 Review 审核的是规范体系，不是实际软件视觉资源或产品合规整改。

| Review dimension | Result |
|---|---|
| File integrity, UTF-8, Markdown, links and paths | PASSED |
| Responsibility boundaries and authority order | PASSED after README/path corrections |
| Terminology and state model | PASSED |
| Pipeline closure and failure return | PASSED |
| Decision Tree entry, YES/NO exits, dead-end and cycle review | PASSED |
| Gate 0–17 fields, blockers and scoring | PASSED |
| Checklist Gate coverage and evidence controls | PASSED |
| Fixed Visual Review Prompt independence | PASSED |
| AI generation and Background coverage | PASSED |
| Copyright and rights bypass review | PASSED |
| Performance, lifecycle and degradation bypass review | PASSED |
| Story–Visual and other system boundaries | PASSED |
| Future AI/developer executability | PASSED |

Final Decision: `VISUAL_SYSTEM_V1_APPROVED`

该决定只表示 Visual Documentation v1.0 自身完整、闭环、可执行且无 P0/P1 规范问题。任何真实资源、页面、Preview 或 Release 仍必须逐项执行全部规范并提供同版本证据。

# 13. Permanent Rule

任何 Phoenix 视觉资源开始前必须进入本 README，遵守有效上游，完成正确任务路径，并通过 Decision Tree、Pipeline、Gate、Checklist、Independent Review 与页面级 QA。视觉资源只有在版权、文化、Story/Journey、阅读、Learning、Audio、设备、性能、无障碍、Reduced Motion、静态降级和 Release Evidence 全部成立时，才具有正式版资格。

绕过 Visual Documentation Navigation、使用不存在规范、用高分补偿阻断项、把素材完成视为页面完成、把 Preview 视为 Release，均不属于 Phoenix Official Visual Development Process。
