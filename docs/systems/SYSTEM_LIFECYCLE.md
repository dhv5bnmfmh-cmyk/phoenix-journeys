# Phoenix System Lifecycle

Documentation Status: Reconstructed and Reviewed
Documentation Version: 1.0.0
Priority: ★★★★★ (Highest)
Owner: Phoenix System Architecture

---

# 1. Purpose

Phoenix System Lifecycle（简称 PSL）定义 Phoenix 从需求提出到长期维护、重构或退役的完整正式生命周期。

统一生命周期为：

```text
Requirement

↓

Review

↓

Research

↓

Architecture

↓

Documentation

↓

Planning

↓

Development

↓

Self Review

↓

QA

↓

Quality Gate

↓

Preview

↓

User Validation

↓

Release

↓

Monitoring

↓

Maintenance

↓

Refactor or Retirement
```

本文件适用于：

- Product Feature。
- Ordinary Journey。
- Special Journey。
- Story 与 Content。
- Visual Asset 与 Background。
- UI/UX。
- Audio 与 Shadowing。
- Animation。
- Code 与 Infrastructure。
- Documentation。
- QA 与 Release Process。

本文件不声称当前项目中的每个历史功能都完整执行过此生命周期。

历史能力必须依据当前规范重新审核，不能被追溯性地自动判定通过。

---

# 2. Authority

本文件依赖：

- `docs/systems/README.md`。
- `docs/systems/SYSTEM_ARCHITECTURE.md`。
- `docs/systems/SYSTEM_DEPENDENCY.md`。
- Core Product Principles。
- 目标 Professional System Documentation。

本文件定义：

- 阶段顺序。
- 阶段输入与输出。
- 阶段进入与退出条件。
- Gate。
- 失败返回路径。
- 生命周期证据。

本文件不替代：

- Story Pipeline。
- Visual Pipeline。
- Learning Pipeline。
- Code Review Standard。
- QA 专项 Gate。
- Release 操作规范。

专项 Pipeline 可以增加阶段内步骤。

不得删除本文件定义的强制 Gate。

---

# 3. Lifecycle Principles

## Principle One

No Stage Without Input。

没有有效输入，不得进入阶段。

---

## Principle Two

No Exit Without Evidence。

没有可追踪输出和退出证据，不得离开阶段。

---

## Principle Three

Failure Returns Upstream。

失败必须返回拥有问题的阶段。

不得只在当前阶段掩盖。

---

## Principle Four

Documentation Before Development。

规则未明确，不得直接开发。

---

## Principle Five

Self Review Does Not Replace QA。

开发者或生成 AI 的自检不能替代独立 QA。

---

## Principle Six

QA Does Not Replace Professional Quality Gates。

自动测试通过不能替代 Story、Visual、Content、Accessibility、Performance 或 Copyright Gate。

---

## Principle Seven

Preview Is Not Release。

Preview 只用于验证候选版本。

不得视为正式交付。

---

## Principle Eight

Release Is Not the End。

Release 后必须 Monitoring 与 Maintenance。

---

## Principle Nine

Applicability Must Be Decided, Not Assumed。

不适用阶段必须记录：

- 为什么不适用。
- 谁确认。
- 哪个 Gate 仍然执行。

不得静默跳过。

---

# 4. Lifecycle Roles

每个生命周期至少包含以下角色。

## Requirement Owner

定义问题、目标与验收意图。

## System Owner

维护目标 Professional System 的规则与边界。

## Research Owner

负责事实、文化、技术、法律、版权或用户证据。

## Architecture Owner

负责 System、Contract、State 与依赖设计。

## Documentation Owner

负责正式规则、版本与引用。

## Developer / Producer

负责 Code、Content、Visual、Audio、Animation 或其它交付物。

## Reviewer

依据正式规则执行专业审核。

## QA Owner

执行独立验证并记录证据。

## User Validator

从 Explorer 或 Founder 使用体验判断候选是否满足目标。

## Release Owner

负责交付、版本、环境、健康检查与回滚。

同一人可以承担多个角色。

但以下批准权必须保持独立判断：

- 生成者不能仅凭 Self Review 批准 Release。
- AI 不能生成并独立批准自己的资源。
- Release Owner 不能修改 Gate 以通过当前 Candidate。

---

# 5. Lifecycle Scope Profiles

## 5.1 Product Feature

完整执行全部阶段。

Preview、User Validation、QA、Quality Gate 与 Release 不得省略。

## 5.2 Story or Content

全部阶段适用。

Preview 可以是内容审阅环境，而不一定是完整产品部署。

正式进入 Runtime Content 前仍需 User Validation、Quality Gate 与 Release Evidence。

## 5.3 Visual Asset

全部阶段适用。

必须额外进入 Visual Documentation、Copyright、AI Error、Device、Performance 与 Page-level QA。

## 5.4 Documentation-only Change

Requirement、Review、Research、Architecture、Documentation、Planning、Development、Self Review、QA、Quality Gate、User Validation、Release Record 与 Maintenance 仍适用。

产品 Preview 可以判定为 `NOT APPLICABLE`。

但必须通过 Preview Applicability Gate，并说明：

- 没有 Runtime Change。
- 不需要产品部署。
- 文件预览或 Repository Review 已足以验证。

Documentation Commit 不等于合并 `main`。

## 5.5 Emergency Fix

Emergency 只允许缩短时间。

不得取消：

- Requirement Scope。
- Dependency Check。
- Self Review。
- QA。
- Quality Gate。
- Release Authorization。
- Monitoring。

无法在发布前完成的非安全关键证据，必须有明确风险批准与发布后补验时间。

Core、Security、Privacy、Copyright、Accessibility Blocking Gate 不允许延后。

---

# 6. Lifecycle Gate Map

| Gate | Position | Required decision |
| --- | --- | --- |
| G01 Requirement Gate | Requirement → Review | 问题、目标、Owner、范围与非目标明确。 |
| G02 Review Gate | Review → Research | 任务有效、未重复、系统归属与风险级别明确。 |
| G03 Research Gate | Research → Architecture | 必须证据充分、来源可追踪、未知项已处理。 |
| G04 Architecture Gate | Architecture → Documentation | System、Contract、State、依赖与失败路径成立。 |
| G05 Documentation Gate | Documentation → Planning | 正式规则足以直接规划和验证。 |
| G06 Planning Gate | Planning → Development | 工作包、Owner、顺序、测试、Gate 与回滚明确。 |
| G07 Development Completion Gate | Development → Self Review | 实现范围完整、可构建/可检查、没有隐式越权。 |
| G08 Self Review Gate | Self Review → QA | Diff、内容、资产、测试与文档自检完成。 |
| G09 QA Gate | QA → Quality Gate | 目标测试、回归、设备和错误路径有证据。 |
| G10 Professional Quality Gate | Quality Gate → Preview | 所有适用专业 Gate PASS。 |
| G11 Preview Gate | Preview → User Validation | 候选与目标 Commit 一致、可访问、可恢复。 |
| G12 User Validation Gate | User Validation → Release | 真实使用目标通过，反馈已处理或明确拒绝。 |
| G13 Release Authorization Gate | Release | Commit、Artifact、QA、授权与回滚完整。 |
| G14 Release Verification Gate | Release → Monitoring | 部署/交付与目标版本一致，Health Check PASS。 |
| G15 Monitoring Gate | Monitoring → Maintenance | 观察窗口、指标、错误与反馈已经评估。 |
| G16 Maintenance Decision Gate | Maintenance → Refactor/Retirement | 维护、重构或退役方向有证据与 Owner。 |
| G17 Refactor/Retirement Gate | Refactor/Retirement | 迁移、归档、回滚、删除与用户影响已验证。 |

任何 Gate 结果必须记录：

- Candidate ID。
- Version 或 Commit SHA。
- Scope。
- Result。
- Evidence。
- Owner。
- Time。
- Failed Rule（如适用）。

---

# 7. Stage 01 — Requirement

## 7.1 Goal

把想法、问题、反馈或风险转换为明确、可判断、可追踪的正式需求。

## 7.2 Inputs

- Founder 或 Explorer 反馈。
- Monitoring 发现。
- QA Defect。
- Product Roadmap。
- Professional System Gap。
- 法律、隐私、版权、平台或安全要求。
- Maintenance 或 Retirement 发现。

## 7.3 Actions

- 描述真实问题，不先指定实现。
- 明确目标用户与使用场景。
- 明确期望结果。
- 定义 Scope 与 Non-goals。
- 指定 Requirement Owner。
- 初步判断影响 Systems。
- 区分 Completed、In Development 与 Planned。
- 记录成功证据需要什么。

## 7.4 Outputs

- Requirement Statement。
- Scope。
- Non-goals。
- Owner。
- Initial Acceptance Intent。
- Initial System Impact List。
- Priority Request。

## 7.5 Required Standards to Read

- Repository README。
- `docs/systems/README.md`。
- Core Constitution 与 Product Principles。
- 当前 Roadmap、Decision Record 与相关反馈证据。

## 7.6 Required Documentation Updates

- Requirement Record 或正式 Issue。
- 必要时更新 Roadmap 候选，不得提前标记完成。
- 不在本阶段直接修改专业规范，除非需求本身是 Documentation Recovery。

## 7.7 Entry Conditions

- 存在可描述的问题、目标或强制约束。
- 来源可识别。
- 不依赖秘密或未经允许的数据。

## 7.8 Exit Conditions

- 问题、目标、范围、非目标与 Owner 明确。
- 能够判断成功或失败。
- 未把实现方案伪装成唯一需求。
- G01 Requirement Gate PASS。

## 7.9 Failure Return

- 信息不足：留在 Requirement，向提出者补充。
- 与 Core 冲突：返回 Founder/Core Decision。
- 只是重复任务：关闭或合并到已有 Requirement。

## 7.10 Non-skippable Gate

G01 Requirement Gate 不得跳过。

没有明确 Scope 的请求不得进入 Review。

---

# 8. Stage 02 — Review

## 8.1 Goal

在投入研究和设计前确认需求有效、归属正确、风险可控且没有明显冲突。

## 8.2 Inputs

- G01 PASS 的 Requirement。
- 当前 Product/Documentation 状态。
- 当前代码、内容、资产与 Release Baseline。
- 已存在 Issue、PR、Roadmap 与 Decision Record。

## 8.3 Actions

- 检查需求是否已实现、开发中或规划中。
- 检查是否重复或与当前工作冲突。
- 指定 Owner System 与依赖 Systems。
- 识别 Story、Culture、Copyright、Privacy、Accessibility、Performance 与 Release 风险。
- 判断 Scope Profile。
- 判断是否需要用户澄清或 Founder 决策。
- 初步定义必须 Gate。

## 8.4 Outputs

- Reviewed Requirement。
- Owner System。
- Dependency List。
- Risk Classification。
- Scope Profile。
- Required Research List。
- Proceed、Reject、Merge 或 Clarify Decision。

## 8.5 Required Standards to Read

- `docs/systems/README.md`。
- `SYSTEM_ARCHITECTURE.md`。
- `SYSTEM_DEPENDENCY.md`。
- 目标 System README 与上位原则。
- 当前 Branch、Commit、代码和产品状态证据。

## 8.6 Required Documentation Updates

- Requirement Review Result。
- System Impact List。
- Risk 与 Blocking Question。
- 必要时 Decision Record。

## 8.7 Entry Conditions

- G01 PASS。
- Requirement Owner 可识别。
- 需求版本稳定到足以审核。

## 8.8 Exit Conditions

- Owner System、依赖、风险和 Research Scope 明确。
- 冲突与重复已经处理。
- G02 Review Gate PASS。

## 8.9 Failure Return

- 需求不清：返回 Requirement。
- Core 冲突：返回 Core Decision。
- Scope 过大：返回 Requirement 拆分。
- 已有实现但证据不明：进入 Research 核实现状，而非直接开发。

## 8.10 Non-skippable Gate

G02 Review Gate 不得跳过。

未经 Review 的需求不得直接进入 Research 或 Development。

---

# 9. Stage 03 — Research

## 9.1 Goal

获得做出安全、真实、合法且可实现决策所需的可靠证据。

## 9.2 Inputs

- Reviewed Requirement。
- Required Research List。
- Risk Classification。
- 当前 Documentation、代码、内容、资产与运行证据。
- 可用可靠来源。

## 9.3 Actions

- 研究产品与用户场景。
- 研究 Story、文化、历史、地理或文学来源。
- 研究技术、平台、设备、性能与可访问性约束。
- 研究版权、许可与商业使用。
- 检查当前代码真实行为。
- 检查现有 Journey、Visual Library 与重复风险。
- 标记事实、推断、不确定与缺失证据。
- 保留来源与访问状态。

## 9.4 Outputs

- Research Evidence Package。
- Source Records。
- Current-state Findings。
- Constraint List。
- Unknowns。
- Risk Update。
- Architecture-ready Facts。

## 9.5 Required Standards to Read

- Core Truth 与 Originality Principles。
- `SYSTEM_DEPENDENCY.md`。
- 目标 System Research Rules。
- Story/Content Source Rules（适用时）。
- Visual Cultural、Copyright 与 AI Generation Rules（适用时）。
- Platform 官方规范（适用时）。

## 9.6 Required Documentation Updates

- Source/Evidence Record。
- Research Result。
- Copyright/License Record。
- Current-state Status。
- 已解决与未解决问题清单。

## 9.7 Entry Conditions

- G02 PASS。
- Research Scope 明确。
- 来源访问合法。
- 不需要未经授权的隐私或敏感数据。

## 9.8 Exit Conditions

- 所有必须事实有可靠依据。
- 关键未知项已解决或明确阻断。
- 当前实现与目标差距清楚。
- G03 Research Gate PASS。

## 9.9 Failure Return

- 来源不足：留在 Research 或返回 Requirement 缩小 Scope。
- 版权不明：返回 Research/Source Selection，禁止进入生产。
- 文化真实性不明：返回 Research。
- 技术不可行：进入 Review 重新评估目标，不得直接降低规则。

## 9.10 Non-skippable Gate

G03 Research Gate 不得跳过。

事实、文化、版权、隐私或平台关键证据不足时必须阻断。

---

# 10. Stage 04 — Architecture

## 10.1 Goal

将已经确认的需求和研究转换为清晰的 System、Contract、State、Dependency 与 Failure Architecture。

## 10.2 Inputs

- G03 PASS 的 Research Evidence。
- Reviewed Requirement。
- Current Architecture。
- Existing Contracts、State 与 Data Model。
- Performance、Accessibility、Security 与 Release Constraints。

## 10.3 Actions

- 确认 Owner System。
- 定义上游与下游。
- 定义 Input/Output Contract。
- 定义 IDs、Schema、State 与 Version。
- 定义 Error、Fallback、Recovery 与 Persistence。
- 检查禁止循环依赖。
- 定义 Performance 与 Accessibility Architecture。
- 定义 Review、QA 与 Release Evidence Path。
- 决定 Build、Buy、Reuse 或 Remove，但不违反 Core。

## 10.4 Outputs

- Architecture Decision。
- Contract Specification。
- Dependency Graph。
- State/Lifecycle Model。
- Failure and Fallback Model。
- Migration/Compatibility Requirement。
- Architecture Acceptance Criteria。

## 10.5 Required Standards to Read

- `SYSTEM_ARCHITECTURE.md`。
- `SYSTEM_DEPENDENCY.md`。
- Core 与目标 System 上位规范。
- Code、Performance、Accessibility 与 Release 约束。
- Visual Architecture（视觉任务）。

## 10.6 Required Documentation Updates

- Architecture Decision Record。
- Contract/Schema Documentation。
- 必要时更新 System Architecture 与 Dependency。
- Breaking Change 与 Migration Requirement。

## 10.7 Entry Conditions

- G03 PASS。
- 必须研究证据齐全。
- Owner System 确认。

## 10.8 Exit Conditions

- Contract 可直接被 Documentation 与 Planning 使用。
- 没有循环 Authority 或 State Ownership。
- Failure、Fallback 与 Migration 清楚。
- G04 Architecture Gate PASS。

## 10.9 Failure Return

- 需求矛盾：返回 Review/Requirement。
- 证据不足：返回 Research。
- 系统边界冲突：留在 Architecture 并升级 System Owner。
- 无安全 Fallback：返回 Architecture 或 Requirement 缩小 Scope。

## 10.10 Non-skippable Gate

G04 Architecture Gate 不得跳过。

跨系统、状态、数据、AI、权限、发布或长期维护变更必须经过 Architecture。

---

# 11. Stage 05 — Documentation

## 11.1 Goal

把批准的目标、研究和架构转换为未来 AI、开发者与 Reviewer 可以直接执行的正式规范。

## 11.2 Inputs

- G04 PASS 的 Architecture。
- Requirement 与 Research Evidence。
- 当前 Documentation Hierarchy。
- System Owner Decision。

## 11.3 Actions

- 更新正确 Owner System 的正式文档。
- 定义术语、Scope、Rules、Pipeline、Gate 与 Failure。
- 明确 Completed、In Development 与 Planned。
- 更新引用与版本。
- 检查与上位、同级和下游文档冲突。
- 不复制已有规则。
- 为 AI 与开发者提供可执行读取路径。

## 11.4 Outputs

- Versioned Documentation。
- Updated Reading Path。
- Updated Gate/Checklist/Review（适用时）。
- Documentation Review Evidence。
- Documentation Commit Candidate。

## 11.5 Required Standards to Read

- `docs/systems/README.md`。
- `SYSTEM_ARCHITECTURE.md`。
- `SYSTEM_DEPENDENCY.md`。
- Documentation Priority。
- Owner System 全部相关规范。
- Visual 全部适用规范（视觉任务）。

## 11.6 Required Documentation Updates

- 本阶段的目标正式文件。
- 受影响引用。
- 必要的版本与 Decision Record。
- 不得无意义更新不受影响文件。

## 11.7 Entry Conditions

- G04 PASS。
- Architecture 与 Owner Decision 稳定。
- 文件职责与目标路径明确。

## 11.8 Exit Conditions

- 规范完整、无占位、可执行。
- 状态与版本明确。
- 没有跨 System 越权。
- 与现有正式 Documentation 无冲突。
- G05 Documentation Gate PASS。

## 11.9 Failure Return

- 规则依据不足：返回 Research/Architecture。
- 职责冲突：返回 Architecture。
- 内容无法直接执行：留在 Documentation 修正。
- 旧文档无法安全恢复：标记 Reconstructed，不得声称逐字恢复。

## 11.10 Non-skippable Gate

G05 Documentation Gate 不得跳过。

Documentation-only Sprint 在此阶段形成主体交付物，但仍必须继续 Self Review、QA、Quality Gate、User Validation 与 Commit/Release Record。

---

# 12. Stage 06 — Planning

## 12.1 Goal

把批准的 Documentation 与 Architecture 拆分为有顺序、可验证、可回滚的工作计划。

## 12.2 Inputs

- G05 PASS 的 Documentation。
- Architecture Contract。
- Current Repository State。
- Dependency、Risk、Resource 与 Release Constraints。

## 12.3 Actions

- 拆分工作包。
- 指定 Owner 与顺序。
- 标记可并行和必须串行依赖。
- 定义每个工作包的输入、输出与验收。
- 定义 Test、Review、QA 与 Gate。
- 定义 Migration、Fallback 与 Rollback。
- 明确本次不修改内容。
- 控制每个 Sprint 的单一职责。

## 12.4 Outputs

- Execution Plan。
- Work Package List。
- Dependency Order。
- Test/Review Plan。
- Rollback Plan。
- Expected Files/Artifacts。
- Release Scope。

## 12.5 Required Standards to Read

- 已批准 Documentation。
- `SYSTEM_DEPENDENCY.md`。
- 目标 System Pipeline。
- Code/Content/Visual Repository Rules。
- QA 与 Release Requirements。

## 12.6 Required Documentation Updates

- Sprint/Issue Plan。
- 必要时更新 TODO，但不得将计划写入 CHANGELOG。
- 不因规划而提前更新完成状态。

## 12.7 Entry Conditions

- G05 PASS。
- 需求、架构、规范稳定。
- 依赖和阻塞可识别。

## 12.8 Exit Conditions

- 每个工作包可以独立执行和验证。
- 没有未解析必须依赖。
- 测试、Gate、Rollback 与 Release Scope 明确。
- G06 Planning Gate PASS。

## 12.9 Failure Return

- 规则不完整：返回 Documentation。
- Contract 不可执行：返回 Architecture。
- Scope 过大：留在 Planning 拆分或返回 Requirement。
- 依赖不可用：返回对应上游阶段。

## 12.10 Non-skippable Gate

G06 Planning Gate 不得跳过。

紧急修复可以缩短计划，但必须明确 Scope、Test、Risk 与 Rollback。

---

# 13. Stage 07 — Development

## 13.1 Goal

严格按已批准 Plan、Documentation 与 Contract 创建目标 Code、Content、Visual、Audio、Animation 或 Documentation 交付物。

## 13.2 Inputs

- G06 PASS 的 Plan。
- Approved Documentation 与 Architecture。
- Stable Upstream Inputs。
- Clean/understood Branch 与 Working Tree。
- Required Tools、Permissions 与 Assets。

## 13.3 Actions

- 只修改批准 Scope。
- 遵循 Owner System Pipeline。
- 保持 IDs、Schema、State 与术语一致。
- 实现 Error、Fallback、Accessibility 与 Performance 要求。
- 添加或更新必要 Tests。
- 记录来源、版权、Prompt、Asset 或 Migration Metadata。
- 保护用户已有修改。
- 不引入未批准功能。

## 13.4 Outputs

- Candidate Implementation。
- Candidate Content/Asset/Documentation。
- Tests。
- Metadata。
- Buildable/Reviewable State。
- Development Notes 与已知限制。

## 13.5 Required Standards to Read

- 目标 System 全部适用规范。
- Plan 与 Architecture Contract。
- Code/Content/Visual Pipeline。
- Accessibility、Performance、Security 与 Copyright Rules。
- Repository Instructions。

## 13.6 Required Documentation Updates

- 实现要求明确规定的技术或 Metadata 文档。
- 不提前更新 CHANGELOG 为已发布。
- 发现规范缺陷时停止并返回 Documentation，不得在代码中创造隐式规则。

## 13.7 Entry Conditions

- G06 PASS。
- 必须依赖可用。
- Branch、Scope 与 Permissions 明确。
- 无未解决 Blocking Risk。

## 13.8 Exit Conditions

- 批准 Scope 已实现或明确记录未完成。
- Candidate 可检查、可构建或可渲染。
- 必须 Test 已创建或更新。
- 没有已知 Blocking Violation。
- G07 Development Completion Gate PASS。

## 13.9 Failure Return

- 规范矛盾：返回 Documentation/Architecture。
- 上游输入错误：返回拥有输入的阶段。
- 技术不可行：返回 Architecture/Planning。
- 版权、文化或 AI 错误：返回 Research/Production。
- 动态不自然：返回 Visual/Animation Development，并使用高清静态方案。

## 13.10 Non-skippable Gate

G07 Development Completion Gate 不得跳过。

不完整 Candidate 不得进入 Self Review 并伪装完成。

---

# 14. Stage 08 — Self Review

## 14.1 Goal

由 Producer 在交给独立 QA 前，系统性发现 Scope、质量、规则、Diff、测试与证据问题。

## 14.2 Inputs

- Candidate Implementation/Content/Asset/Documentation。
- Approved Plan 与 Documentation。
- Diff、Test 与 Metadata。

## 14.3 Actions

- 检查实际变化文件。
- 检查是否有越界修改。
- 对照 Acceptance Criteria。
- 运行 Targeted Tests、Lint、Format、Build 或 Render。
- 检查 Error、Fallback、Accessibility 与 Performance。
- 检查 Story、Culture、Copyright 与 AI Error（适用时）。
- 检查 Visual Reading/Button Safe Area 与 Device Variants（适用时）。
- 检查 Documentation Header、Version、术语与冲突。
- 删除临时文件和无关变化。

## 14.4 Outputs

- Self Review Result。
- Clean Candidate Diff。
- Targeted Test Evidence。
- Known Limitations。
- QA Handoff Package。

## 14.5 Required Standards to Read

- Approved Requirement、Plan 与 Acceptance Criteria。
- 目标 System Gate/Checklist。
- `SYSTEM_DEPENDENCY.md` 的同步检查。
- Repository Review Rules。

## 14.6 Required Documentation Updates

- Self Review Record。
- 必要的 Metadata 与 Test Evidence。
- 不得将 Self Review PASS 写成 QA 或 Release PASS。

## 14.7 Entry Conditions

- G07 PASS。
- Candidate Scope 完整。
- Diff 可识别。

## 14.8 Exit Conditions

- 无无关变化。
- Targeted Checks PASS。
- 已知问题全部分类。
- QA 可以独立复现与验证。
- G08 Self Review Gate PASS。

## 14.9 Failure Return

- 实现缺陷：返回 Development。
- Plan 缺陷：返回 Planning。
- 规则缺陷：返回 Documentation/Architecture。
- 上游内容错误：返回 Research/Story/Content/Visual Owner。

## 14.10 Non-skippable Gate

G08 Self Review Gate 不得跳过。

Self Review 不能替代 QA、Professional Review 或 User Validation。

---

# 15. Stage 09 — QA

## 15.1 Goal

独立验证 Candidate 是否满足需求、正式规则、回归、安全、设备与错误恢复要求。

## 15.2 Inputs

- G08 PASS 的 QA Handoff Package。
- Candidate Commit/Build/Asset/Content Version。
- Applicable Documentation 与 Acceptance Criteria。
- Test Environment 与 Device Matrix。

## 15.3 Actions

- 运行 Unit、Widget、Integration、Product Rule 与 Manual QA。
- 验证 Happy Path、Error、Offline、Permission、Return 与 Restoration。
- 验证 Mobile、Tablet、Web/Browser 与目标 Device。
- 验证 Story、Learning、Content、Visual、UI、Audio 与 Animation。
- 验证 Accessibility、Performance、Privacy、Copyright 与 Security（适用时）。
- 检查 Test Evidence 与 Candidate Version 一致。
- 记录 PASS、FAIL、BLOCKED 与未验证项。

## 15.4 Outputs

- QA Result。
- Test Evidence。
- Device/Browser Evidence。
- Defect List。
- Regression Result。
- Unverified Items。
- Quality Gate Handoff。

## 15.5 Required Standards to Read

- QA System Documentation。
- 目标 System 全部 Gate 与 Acceptance Criteria。
- `SYSTEM_DEPENDENCY.md`。
- Accessibility、Performance、Copyright 与 Release Requirements。

## 15.6 Required Documentation Updates

- QA Report。
- Test/Device Matrix Result。
- Defect Status。
- 不得提前更新正式 CHANGELOG。

## 15.7 Entry Conditions

- G08 PASS。
- Candidate Version 固定。
- QA Environment 可用。
- 必须 Gate 可执行。

## 15.8 Exit Conditions

- 所有必须测试完成。
- Blocking Defect 为零。
- 未验证项不影响目标 Release，或 Candidate 标记 BLOCKED。
- G09 QA Gate PASS。

## 15.9 Failure Return

- Code/UI/Audio/Animation 缺陷：返回 Development。
- Story/Content/Visual 缺陷：返回对应 Production/Research。
- Architecture 缺陷：返回 Architecture。
- QA 环境缺失：保持 BLOCKED，不得标记 PASS。

## 15.10 Non-skippable Gate

G09 QA Gate 不得跳过。

自动测试通过不得替代真实页面、设备和专业质量检查。

---

# 16. Stage 10 — Quality Gate

## 16.1 Goal

汇总所有适用专业 Gate，判断 Candidate 是否具备进入 Preview 的完整质量条件。

## 16.2 Inputs

- G09 PASS 的 QA Result。
- Professional Review Results。
- Story/Content/Visual/UI/Audio/Animation Gate。
- Accessibility 与 Performance Result。
- Copyright、Privacy、Security 与 AI Review Result。

## 16.3 Actions

- 确认所有 Conditional Gate 已解析。
- 核对 Candidate Version。
- 核对每个 Gate 的 Owner 与 Evidence。
- 检查是否存在“基本通过”“以后再修”。
- 检查 Fallback 与 Rollback。
- 输出单一 Release Candidate Quality Decision。

## 16.4 Outputs

- Quality Gate Matrix。
- Overall PASS、FAIL 或 BLOCKED。
- Failed Rule 与 Return Stage。
- Preview Eligibility。

## 16.5 Required Standards to Read

- 各受影响 System 的 Quality Gate。
- Core Non-negotiable Rules。
- `SYSTEM_DEPENDENCY.md`。
- Visual Quality Rules（视觉任务）。
- Release Entry Requirements。

## 16.6 Required Documentation Updates

- Quality Gate Record。
- Professional Review Result。
- Preview Eligibility Record。

## 16.7 Entry Conditions

- G09 PASS。
- Candidate Version 固定。
- 所有适用 Review 有结果。

## 16.8 Exit Conditions

- 所有 Required Gate PASS。
- 没有 BLOCKED 项。
- Candidate、Evidence 与 Commit/Artifact 一致。
- G10 Professional Quality Gate PASS。

## 16.9 Failure Return

- 返回 Failed Rule 所属阶段。
- 视觉问题返回 Visual Production/Review。
- 动态问题返回 Animation，并启用 Approved Static Fallback。
- 性能/可访问性问题返回 Development/Architecture。
- 版权不明返回 Research，禁止 Preview Import。

## 16.10 Non-skippable Gate

G10 Professional Quality Gate 不得跳过。

QA PASS 不能覆盖专业 Gate FAIL。

---

# 17. Stage 11 — Preview

## 17.1 Goal

在隔离环境中交付与目标 Candidate 完全一致的可体验版本，为 User Validation 提供真实对象。

## 17.2 Inputs

- G10 PASS 的 Candidate。
- Branch 与 Commit SHA。
- Build/Content/Asset Version。
- Preview Environment Configuration。
- Preview Applicability Decision。

## 17.3 Actions

- 构建目标 Candidate。
- 部署隔离 Preview。
- 验证 URL、Health、Commit Freshness 与 Cache。
- 验证目标 Device 可访问。
- 验证 Preview 不写入 Production。
- 记录已知限制。
- Documentation-only Change 执行文件/Repository Preview Applicability Review。

## 17.4 Outputs

- Preview URL 或明确 `NOT APPLICABLE` Record。
- Preview Commit SHA。
- Build Identity。
- Health Check。
- User Validation Instructions。

## 17.5 Required Standards to Read

- Release/Preview Documentation。
- CI 与 Deployment Rules。
- QA Handoff。
- Target System Preview Criteria。
- Documentation-only Applicability Rules（适用时）。

## 17.6 Required Documentation Updates

- Preview Record。
- URL、Commit 与 Build Identity。
- Known Limitations。
- 不得更新为正式 Release。

## 17.7 Entry Conditions

- G10 PASS。
- Candidate 可构建/可交付。
- Preview Environment 隔离。
- Applicability 已决定。

## 17.8 Exit Conditions

- Preview 与目标 Commit 一致。
- Health Check PASS。
- User Validator 可以完成目标场景。
- 或 Documentation-only `NOT APPLICABLE` 理由通过审核。
- G11 Preview Gate PASS。

## 17.9 Failure Return

- Build 失败：返回 Development/Release Configuration。
- Candidate 与 Commit 不一致：返回 Preview Build。
- Runtime Defect：返回 Development/QA。
- Preview 环境风险：返回 Architecture/Release Planning。

## 17.10 Non-skippable Gate

G11 Preview Gate 不得静默跳过。

即使 Preview 不适用，也必须记录 Applicability Decision。

---

# 18. Stage 12 — User Validation

## 18.1 Goal

由 Founder、Explorer 或目标 Reviewer 在真实目标场景中判断 Candidate 是否解决原始需求并保持 Phoenix Experience。

## 18.2 Inputs

- G11 PASS 的 Preview 或 Documentation Candidate。
- Original Requirement 与 Acceptance Intent。
- Validation Scenario。
- Known Limitations。

## 18.3 Actions

- 完成端到端目标场景。
- 检查首次理解、阅读、操作、学习、返回与完成体验。
- 检查 Story、Visual、Audio 与 Journey 感受（适用时）。
- 对 Documentation 检查可读性、完整性、边界与可执行性。
- 记录接受、拒绝、修改或新需求。
- 区分缺陷与新 Scope。

## 18.4 Outputs

- User Validation Result。
- Accepted/Rejected Findings。
- Defect 或 New Requirement Classification。
- Release Recommendation。

## 18.5 Required Standards to Read

- Original Requirement。
- User Acceptance Criteria。
- Founder Acceptance Checklist（适用时）。
- 目标 System 核心原则。
- Preview Instructions。

## 18.6 Required Documentation Updates

- Validation Record。
- Accepted/Rejected Decision。
- 新 Scope 必须进入新的 Requirement，不得塞入当前 Release。

## 18.7 Entry Conditions

- G11 PASS。
- Candidate 可访问、版本明确。
- Validator 与场景明确。

## 18.8 Exit Conditions

- 原始需求被真实验证。
- Blocking User Finding 为零。
- 新需求已分离。
- G12 User Validation Gate PASS。

## 18.9 Failure Return

- 功能缺陷：返回 Development。
- 体验设计问题：返回 UI/Learning/Visual/Audio Architecture。
- 需求理解错误：返回 Requirement/Review。
- Documentation 不可执行：返回 Documentation。

## 18.10 Non-skippable Gate

G12 User Validation Gate 不得跳过。

自动测试、AI Review 与开发者自测不能代替目标用户验证。

---

# 19. Stage 13 — Release

## 19.1 Goal

将通过全部 Gate 的 Candidate，以可追踪、可回滚、获得授权的方式交付到目标环境或正式 Repository Baseline。

## 19.2 Inputs

- G12 PASS 的 Candidate。
- Branch、Commit SHA 与 Artifact Identity。
- QA、Quality Gate 与 User Validation Evidence。
- Release Plan、Health Check 与 Rollback。
- Release/Merge Authorization。

## 19.3 Actions

- 再次确认 Scope 与 Commit。
- 运行 Required CI/Build。
- 确认 Secrets、Environment 与 Migration。
- 取得明确 Release Authorization。
- 部署、发布或提交正式交付记录。
- 执行 Health Check。
- 验证部署版本与 Commit 一致。
- 更新 CHANGELOG 或 Documentation Commit Record。

## 19.4 Outputs

- Released Artifact 或正式 Commit Record。
- Release Version。
- Deployment/Repository Target。
- Health Check Result。
- Rollback Point。
- CHANGELOG Entry（适用时）。

## 19.5 Required Standards to Read

- Release System Documentation。
- QA 与 Quality Gate Result。
- Environment/Deployment Rules。
- Migration、Rollback、Privacy 与 Security Rules。
- Merge Authorization Rules。

## 19.6 Required Documentation Updates

- CHANGELOG（正式产品 Release）。
- Release Record。
- Version/Commit/Artifact Identity。
- Deployment 与 Rollback Reference。
- Documentation-only Sprint 的 Commit SHA 与文件路径。

## 19.7 Entry Conditions

- G12 PASS。
- 所有 Evidence 与 Candidate 一致。
- Release Owner 与授权明确。
- Rollback 可执行。

## 19.8 Exit Conditions

- 目标交付成功。
- Health Check PASS。
- Release Version 可追踪到 Commit。
- Rollback Point 存在。
- G13 Release Authorization 与 G14 Release Verification PASS。

## 19.9 Failure Return

- 授权缺失：留在 Release，不得合并/发布。
- Build/CI 失败：返回 Development/QA。
- Deployment 失败：执行 Rollback，返回 Release Planning/Development。
- Health Check 失败：立即 Rollback 或阻止宣布完成。

## 19.10 Non-skippable Gate

G13 Release Authorization Gate 与 G14 Release Verification Gate 均不得跳过。

Preview 通过不构成合并 `main` 授权。

---

# 20. Stage 14 — Monitoring

## 20.1 Goal

确认 Release 在真实环境中持续稳定，并及时发现错误、性能、可访问性、内容与体验问题。

## 20.2 Inputs

- G14 PASS 的 Release。
- Monitoring Plan。
- Runtime Logs、Errors、Metrics 与 Feedback。
- Privacy-safe Analytics（如已批准）。
- Support/Explorer Reports。

## 20.3 Actions

- 监测启动、错误、加载、性能与服务可用性。
- 监测 Journey Progress、Audio、State Restoration 与关键错误。
- 检查 Visual/Animation 在真实设备的稳定性。
- 检查 Accessibility 与异常网络行为。
- 收集用户反馈，不使用强迫式追踪。
- 区分 Incident、Defect、Improvement 与 New Requirement。

## 20.4 Outputs

- Monitoring Report。
- Incident/Defect Record。
- Performance/Accessibility Finding。
- Maintenance Recommendation。
- Rollback/Emergency Decision（如需要）。

## 20.5 Required Standards to Read

- Release Monitoring Rules。
- Privacy 与 Analytics Rules。
- Performance、Accessibility 与 Error Budgets。
- Target System Runtime Expectations。

## 20.6 Required Documentation Updates

- Monitoring Record。
- Incident Record。
- Known Issue。
- 不得用未经批准的用户数据补充产品文档。

## 20.7 Entry Conditions

- G14 PASS。
- Monitoring Owner 与观察窗口明确。
- 数据收集合规。

## 20.8 Exit Conditions

- 观察窗口完成。
- Blocking Incident 为零或已处理。
- Maintenance/Refactor/Retirement 路径明确。
- G15 Monitoring Gate PASS。

## 20.9 Failure Return

- Critical Incident：立即进入 Emergency Requirement/Review，并评估 Rollback。
- 性能/可访问性回归：返回 Development/QA。
- 内容/文化错误：返回 Story/Content/Visual Research。
- 监测证据不足：延长 Monitoring，不得宣称稳定。

## 20.10 Non-skippable Gate

G15 Monitoring Gate 不得跳过。

“没有收到投诉”不等于 Monitoring PASS。

---

# 21. Stage 15 — Maintenance

## 21.1 Goal

在不破坏正式 Contract 的前提下，保持 Phoenix 内容、代码、资产、依赖、文档与发布路径长期正确和可维护。

## 21.2 Inputs

- Monitoring Result。
- Dependency Update。
- Platform/Package Change。
- Content、Source、Copyright 或文化更新。
- Performance、Accessibility、Security 与 QA Finding。
- Documentation Drift。

## 21.3 Actions

- 修复 Defect 与 Drift。
- 更新依赖并验证兼容性。
- 更新失效来源、版权或 Metadata。
- 优化性能与可访问性。
- 保持 Tests、Documentation 与 Code 同步。
- 清理不再引用的临时资源。
- 评估技术债务与架构债务。
- 决定继续维护、重构或退役。

## 21.4 Outputs

- Maintenance Change。
- Updated Dependency/Source/Metadata。
- Regression Evidence。
- Technical Debt Record。
- Refactor/Retirement Recommendation。

## 21.5 Required Standards to Read

- 受影响 System Documentation。
- `SYSTEM_DEPENDENCY.md` 的跨系统同步规则。
- Code、Performance、Accessibility、QA 与 Release Rules。
- 原 Release Contract。

## 21.6 Required Documentation Updates

- Maintenance Record。
- Dependency/Source Version。
- 必要的 Documentation Patch。
- CHANGELOG（正式交付时）。
- Deprecated/Replacement Relationship（适用时）。

## 21.7 Entry Conditions

- Monitoring 或明确维护事件产生有效输入。
- Owner 与 Scope 明确。
- 当前 Baseline 可追踪。

## 21.8 Exit Conditions

- 维护目标完成并通过受影响 Lifecycle Stages。
- Contract 仍成立或已正式版本化。
- 维护、重构或退役决定明确。
- G16 Maintenance Decision Gate PASS。

## 21.9 Failure Return

- 小修复不足以解决：进入 Refactor Requirement。
- 外部依赖不再安全：进入 Architecture/Retirement Review。
- Source/版权失效：返回 Research，并阻止相关新 Release。
- 回归失败：返回 Development/QA。

## 21.10 Non-skippable Gate

G16 Maintenance Decision Gate 不得跳过。

Maintenance Change 仍必须按影响范围重新执行 Requirement 至 Release 的适用阶段。

---

# 22. Stage 16 — Refactor or Retirement

## 22.1 Goal

当当前实现、内容、资产、Contract 或能力不再适合维护时，以可验证方式重构，或安全地退役并保留必要历史关系。

## 22.2 Inputs

- G16 PASS 的 Maintenance Decision。
- Technical/Architecture Debt Evidence。
- Usage、Performance、Accessibility、Security 或 Cost Evidence。
- Replacement Plan。
- Migration、Archive 与 User Impact。

## 22.3 Actions

### Refactor

- 保持或正式版本化外部 Contract。
- 定义迁移与兼容策略。
- 增加 Characterization/Regression Tests。
- 分阶段替换。
- 验证 State、Content、Progress、Assets 与 Release Path。

### Retirement

- 确认不再使用。
- 定义替代能力或明确无替代原因。
- 迁移数据、内容、进度与引用。
- 标记 Deprecated。
- 从 Runtime、Build 与 Navigation 中移除。
- 保留必要 Archive、Decision 与 CHANGELOG。

## 22.4 Outputs

- Refactored System 或 Retired System/Asset/Feature。
- Migration Result。
- Compatibility Evidence。
- Archive Record。
- Updated Documentation。
- Final Release/Removal Record。

## 22.5 Required Standards to Read

- Core 与 System Architecture。
- `SYSTEM_DEPENDENCY.md`。
- Owner/Consumer System Documentation。
- Data Migration、Privacy、Archive 与 Release Rules。
- QA Regression Requirements。

## 22.6 Required Documentation Updates

- Architecture 与 Dependency（边界变化时）。
- Lifecycle 与 Priority（适用时）。
- Owner/Consumer Documentation。
- Deprecated/Replacement Record。
- Migration Guide。
- CHANGELOG。
- Archive Metadata。

## 22.7 Entry Conditions

- G16 PASS。
- Refactor 或 Retirement 理由有证据。
- 影响 Consumer 全部识别。
- Migration 与 Rollback 可执行。

## 22.8 Exit Conditions

- 所有 Consumer 已迁移或明确结束。
- 无孤立引用、State、Asset 或 Data。
- Regression/Removal QA PASS。
- Documentation 与 Release Record 已更新。
- G17 Refactor/Retirement Gate PASS。

## 22.9 Failure Return

- Consumer 遗漏：返回 Architecture/Planning。
- Migration 失败：Rollback，返回 Development。
- User Impact 不可接受：返回 Requirement/Review。
- Archive/版权/数据义务不清：返回 Research。

## 22.10 Non-skippable Gate

G17 Refactor/Retirement Gate 不得跳过。

禁止直接删除仍被 Runtime、Content、Documentation、Build 或用户数据引用的能力。

---

# 23. Failure Return Matrix

| Failure | Required return stage |
| --- | --- |
| 需求不清、目标错误 | Requirement |
| Scope、Owner、优先级冲突 | Review |
| 事实、文化、版权、隐私、平台证据不足 | Research |
| System、State、Schema、Dependency 或 Fallback 错误 | Architecture |
| 规则缺失、冲突、不可执行 | Documentation |
| 工作包、顺序、测试或回滚不清 | Planning |
| 实现、内容、视觉、音频或动画缺陷 | Development |
| Diff、范围、元数据或自检失败 | Self Review |
| 测试、设备、恢复或回归失败 | QA |
| 专业 Gate 失败 | Quality Gate 所属上游专业阶段 |
| Preview Build、部署或版本不一致 | Preview / Development / Release Planning |
| 用户目标未满足 | Requirement、Architecture 或 Development，依根因决定 |
| Release 授权缺失 | Release，保持未发布 |
| Release Health Check 失败 | Rollback 后返回 Development/Release Planning |
| Runtime Incident | Monitoring → Emergency Requirement |
| 长期维护不可持续 | Refactor or Retirement Review |

失败不得默认返回最近阶段。

必须返回能够修正根因的最早 Owner Stage。

---

# 24. Cross-system Lifecycle Synchronization

跨系统修改在每个阶段必须同步检查。

## 24.1 Story Change

必须同步：

- Content Version。
- Learning Level 与 Vocabulary。
- Visual Scene/Identity。
- UI Reading Length。
- Audio Text/Boundary。
- AI Review、QA 与 Release Evidence。

## 24.2 Learning Change

必须同步：

- UI Flow/State。
- Audio Trigger 与 Feedback。
- Animation Trigger。
- Code Persistence。
- Accessibility。
- Tests、QA 与 Release。

## 24.3 Visual Change

必须同步：

- Story/Journey Contract。
- Source/Copyright Metadata。
- UI Safe Areas。
- Animation Layers 与 Static Fallback。
- Device Variants。
- Performance、Accessibility 与 Page-level QA。

## 24.4 Audio Change

必须同步：

- Content Text/Locale。
- Learning Goal。
- UI State。
- Permission/Privacy。
- Accessibility Alternative。
- Device QA。

## 24.5 Architecture or Contract Change

必须同步：

- Architecture。
- Dependency。
- Documentation。
- Plan。
- Models/State/Schema。
- Migration。
- Tests。
- QA。
- Release Candidate。

旧 Gate PASS 对新 Contract 无效。

---

# 25. Visual Lifecycle Requirements

Visual 任务除完整 Lifecycle 外，还必须遵守：

```text
Visual README

↓

Visual Constitution

↓

Visual Philosophy

↓

Visual Guidelines

↓

Target Visual Documentation

↓

Visual Production

↓

AI Error / Culture / Copyright Review

↓

Device / Performance / Accessibility Validation

↓

Visual Gate

↓

Page-level QA
```

以下情况必须返回 Visual Research、Design 或 Production：

- Story/Journey 不一致。
- 文化错误。
- 明显 AI 错误。
- 版权无法确认。
- 阅读安全区失败。
- 按钮安全区失败。
- 手机或平板适配失败。
- Runtime 性能失败。

动态不自然时：

必须退回高质量静态背景。

不得以 Preview 临时可用为理由保留不合格动态。

---

# 26. Documentation Recovery Lifecycle

Documentation Recovery Sprint 必须执行：

```text
Recovery Requirement

↓

Existing File and Evidence Review

↓

Current Product/Repository Research

↓

System Boundary Confirmation

↓

One-file Reconstruction

↓

Self Review

↓

Cross-document Conflict Check

↓

Documentation Quality Gate

↓

User Review Candidate

↓

Single Real Commit
```

Recovery 文件必须：

- 标记 `Documentation Status: Reconstructed`。
- 标记 Documentation Version。
- 不声称逐字恢复旧文档。
- 不虚构实现状态。
- 区分 Completed、In Development 与 Planned。
- 一次 Sprint 只重建一个文件。
- 单独 Commit。
- 不在未授权情况下合并 `main`。

产品 Preview 对纯 Documentation Recovery 可以 `NOT APPLICABLE`。

真实文件、Conflict Check、User Review 与 Commit 不可省略。

---

# 27. Lifecycle Evidence Record

每个 Candidate 应维护最小 Lifecycle Evidence：

- Requirement ID。
- Scope。
- Owner System。
- Requirement Owner。
- Research Sources。
- Architecture/Contract Version。
- Documentation Version。
- Plan/Work Package。
- Branch。
- Commit SHA。
- Test Results。
- Professional Gate Results。
- Preview URL 或 N/A Reason。
- User Validation Result。
- Release Authorization。
- Release/Deployment Identity。
- Monitoring Window。
- Maintenance/Retirement Decision。

Evidence 必须与 Candidate 一致。

不得跨 Commit、跨 Branch 或跨 Artifact 混用。

---

# 28. Prohibited Lifecycle Practices

Phoenix 禁止：

- 从 Requirement 直接跳到 Development。
- 先开发再补规则。
- 用 Self Review 替代 QA。
- 用自动测试替代 Professional Quality Gate。
- 用 Preview 替代 User Validation。
- 用 User Acceptance 替代 Accessibility、Copyright、Security 或 Performance Gate。
- 用 Preview URL 声称正式 Release。
- 未经授权合并 `main`。
- Release 后不 Monitoring。
- 用 Maintenance 名义加入未评审新功能。
- Refactor 时静默改变外部 Contract。
- Retirement 时直接删除仍被引用的 State、Asset、Content 或 Documentation。
- 将失败标记为“以后再修”并继续进入下一 Gate。
- 对不适用阶段不留任何记录。

---

# 29. Lifecycle Review Checklist

Lifecycle Review 必须确认：

- 16 个阶段均有结果或明确 N/A Reason。
- 每个阶段的 Input 来自已通过上游。
- 每个阶段的 Output 可追踪。
- 必须 Documentation 已读取。
- 必须 Documentation 已更新。
- Entry/Exit Conditions 有证据。
- Failure Return 指向根因 Owner。
- 所有 Required Gate PASS。
- Candidate、Test、Preview 与 Release Commit 一致。
- Visual、Story、Learning、UI、Audio、QA 与 Release 边界清楚。
- 版权、文化、Accessibility、Performance 与 Security 无 Blocking Failure。
- Release 有授权和 Rollback。
- Monitoring 与 Maintenance Owner 明确。

任一强制项缺失：

Lifecycle Review 必须 `FAIL` 或 `BLOCKED`。

---

# 30. Permanent Rule

Phoenix 所有正式变更必须遵循：

```text
Requirement
→ Review
→ Research
→ Architecture
→ Documentation
→ Planning
→ Development
→ Self Review
→ QA
→ Quality Gate
→ Preview
→ User Validation
→ Release
→ Monitoring
→ Maintenance
→ Refactor or Retirement
```

每个阶段必须明确：

- 目标。
- 输入。
- 动作。
- 输出。
- 必须读取的规范。
- 必须更新的文档。
- 进入条件。
- 退出条件。
- 失败返回阶段。
- 禁止跳过的 Gate。

任何阶段没有输入：

不得开始。

任何阶段没有输出证据：

不得结束。

任何 Gate 失败：

必须返回能够修正根因的上游阶段。

任何不适用阶段：

必须记录 Applicability Decision。

Preview 不等于 Release。

Self Review 不等于 QA。

QA 不替代 Professional Quality Gate。

User Validation 不替代 Copyright、Accessibility、Performance、Privacy 或 Security。

Release 不等于生命周期结束。

只有完成 Monitoring、Maintenance，并在需要时安全 Refactor 或 Retirement，Phoenix 的完整生命周期才成立。
