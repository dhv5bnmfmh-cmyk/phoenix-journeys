# Phoenix System Dependency

Documentation Status: Reconstructed
Documentation Version: 1.0.0
Priority: ★★★★★ (Highest)
Owner: Phoenix System Architecture

---

# 1. Purpose

Phoenix System Dependency（简称 PSD）定义 Phoenix Documentation、Professional Systems、Development、Review 与 Release 之间的正式依赖规则。

本文件回答：

- 哪一个系统必须先提供什么。
- 哪一个系统可以消费什么。
- 哪些依赖是必须依赖。
- 哪些依赖是可选依赖。
- 数据、内容、状态与证据如何流动。
- 多个系统互相协作时如何避免循环依赖。
- 依赖失败时必须返回哪里修正。
- 跨系统修改后必须同步检查什么。

本文件不重新定义各 System 的使命与完整职责。

系统职责以 `SYSTEM_ARCHITECTURE.md` 为准。

专业规则以目标 System 的正式 Documentation 为准。

---

# 2. Authority

本文件位于：

```text
Documentation System README

↓

SYSTEM_ARCHITECTURE

↓

SYSTEM_DEPENDENCY

↓

SYSTEM_LIFECYCLE

↓

SYSTEM_PRIORITY

↓

Professional System Documentation

↓

Development, Review and Release
```

`SYSTEM_ARCHITECTURE.md` 定义：

- 有哪些 System。
- 每个 System 负责什么。
- 每个 System 的边界是什么。

本文件定义：

- System 之间如何依赖。
- 依赖方向是什么。
- 依赖满足到什么程度才允许继续。
- 依赖失败如何处理。

本文件不得改变：

- Core Product Principles。
- Story Authority。
- Visual Constitution。
- Learning Meaning。
- QA Gate。
- Release Authorization。

---

# 3. Dependency Mission

Phoenix Dependency System 的使命是：

> 让每一项工作都从经过确认的上游输入开始，并把可验证输出交给明确下游，避免猜测、隐式状态、重复规则与循环依赖。

依赖不是文件引用数量。

依赖是正式 Contract。

一个有效依赖必须明确：

- Provider。
- Consumer。
- Artifact 或 State。
- Version。
- Status。
- Validation。
- Failure Owner。

缺少任一关键项时，依赖不得视为已满足。

---

# 4. Dependency Principles

## Principle One

Upstream Before Downstream。

上游输入未确认，下游不得开始正式生产。

---

## Principle Two

Contract Before Integration。

系统集成前，必须先定义输入、输出、状态和失败行为。

---

## Principle Three

Required Before Optional。

必须依赖未满足时，不得用可选依赖补偿。

---

## Principle Four

Evidence Before Assumption。

文件、类、Agent、测试或 Workflow 存在，不代表依赖已经通过。

必须检查内容、版本、状态与验证证据。

---

## Principle Five

No Circular Authority。

下游不得成为自己上游规则的批准者。

---

## Principle Six

Feedback Is Not Authority Reversal。

下游可以向上游反馈问题。

反馈不等于下游取得上游决策权。

---

## Principle Seven

Failure Returns to the Owner。

依赖失败必须返回拥有该输入的 System 修正。

不得由下游静默改写。

---

# 5. Dependency Vocabulary

## 5.1 Upstream

上游是提供目标、规则、内容、状态、资产或证据的 System。

上游负责其输出的正确性、版本和状态。

## 5.2 Downstream

下游是消费上游 Contract 并继续表达、实现、验证或交付的 System。

下游负责：

- 验证输入是否满足要求。
- 不越权修改输入意义。
- 输出可追踪结果。

## 5.3 Provider

Provider 是某个具体依赖 Artifact 的唯一正式提供者。

同一 Artifact 不得同时拥有多个冲突 Provider。

## 5.4 Consumer

Consumer 只能消费 Provider 已批准的版本。

Consumer 不得依赖未审查临时副本。

## 5.5 Contract

Contract 是跨系统依赖的正式接口。

至少包含：

- ID。
- Version。
- Owner。
- Schema 或结构。
- Required Fields。
- Status。
- Validation Result。
- Failure Behavior。

## 5.6 Dependency Gate

Dependency Gate 判断输入是否允许进入下游。

结果只有：

- `PASS`。
- `FAIL`。
- `BLOCKED`。
- `NOT APPLICABLE`。

不得使用“基本可以”“先接入再说”作为正式结果。

---

# 6. Required and Optional Dependencies

## 6.1 Required Dependency

必须依赖是缺失时无法安全、正确或合法继续的依赖。

常见必须依赖包括：

- Core Product Principles。
- 当前任务适用的 System Documentation。
- Story Contract。
- Source/Evidence Status。
- Learning Flow Contract。
- Visual Copyright Status。
- UI State Contract。
- Accessibility Requirement。
- QA PASS。
- Release Authorization。

必须依赖失败：

立即停止下游流程。

## 6.2 Optional Dependency

可选依赖是能够增强质量、效率或体验，但缺失时仍可在正式规则允许下完成的依赖。

例如：

- 不影响事实判断的补充研究。
- 非关键页面的额外视觉变体。
- 非必要环境音。
- 不改变体验的附加 Analytics。
- 不影响正式 Gate 的辅助 AI Review。

可选依赖必须满足：

- 不改变必须依赖定义。
- 不成为唯一可用路径。
- 缺失时有明确基础方案。
- 不引入新的版权、隐私、性能或可访问性风险。

## 6.3 Conditional Required Dependency

某些依赖只在特定范围内成为必须依赖。

例如：

- 包含动态背景时，Animation、Reduced Motion、Performance 与 Static Fallback 为必须依赖。
- 纯静态视觉不依赖运行时 Animation，但仍依赖 Visual、Copyright、Performance 与 QA。
- 使用 AI 生成资源时，AI Error、Source Traceability、Copyright 与 AI Review 为必须依赖。
- 使用麦克风时，Permission、Privacy、Audio Error Alternative 与 Accessibility 为必须依赖。
- 修改正式发布路径时，Rollback 与 Deployment Verification 为必须依赖。

Conditional Dependency 必须在任务范围确认阶段转为明确的 `Required` 或 `Not Applicable`。

不得长期保持模糊。

---

# 7. Documentation Dependencies

任何开发、内容、视觉、审核或发布任务必须先满足 Documentation Dependency。

## 7.1 Base Reading Dependency

统一顺序：

```text
Repository README

↓

docs/systems/README.md

↓

Core Constitution and Product Principles

↓

SYSTEM_ARCHITECTURE.md

↓

SYSTEM_DEPENDENCY.md

↓

SYSTEM_LIFECYCLE.md

↓

SYSTEM_PRIORITY.md

↓

Target System README

↓

Target System Standards

↓

Task-specific Pipeline, Gate, Checklist and Review
```

## 7.2 Missing Documentation

如果必须文档尚未恢复或建立：

- 明确标记缺失。
- 判断现有上位规则是否足以安全执行。
- 关键产品、文化、版权、学习或发布规则无法确认时停止。
- 先建立或恢复正确 Documentation。

不得：

- 根据旧聊天补写事实。
- 假装读取不存在的文件。
- 用代码当前行为代替缺失的 Constitution。
- 用 Roadmap 代替正式规范。

## 7.3 Visual Documentation Dependency

任何 Visual 任务必须从：

```text
docs/visual/README.md
```

进入。

然后依序读取：

- `VISUAL_CONSTITUTION.md`。
- `VISUAL_PHILOSOPHY.md`。
- `VISUAL_GUIDELINES.md`。
- 目标视觉专项规范。
- Visual Pipeline、Gate、Checklist 与 Review。

本文件只定义进入 Visual System 的依赖关系。

不重新定义 Visual 规则。

## 7.4 Documentation Version Dependency

下游必须记录所依赖文档的有效 Version。

上游 Documentation Version 改变时，下游必须检查：

- Contract 是否变化。
- 实现是否仍符合。
- Test 是否仍有效。
- Gate 是否需要更新。
- Release Candidate 是否需要重新审核。

---

# 8. Product System Dependency Map

Phoenix 主要产品依赖方向如下：

```text
Core

↓

Story and Learning Intent

↓

Content Contract

↓

Visual, UI/UX and Audio Experience Contracts

↓

Animation Contract where applicable

↓

Code Implementation

↓

Performance and Accessibility Validation

↓

AI Review and Professional Review

↓

QA

↓

Release
```

真实工作允许分阶段并行。

并行不等于取消依赖。

只有当各并行 System 已收到稳定输入，并且拥有独立输出边界时才允许并行。

---

# 9. Core Dependencies

Core 是全部 Phoenix Systems 的最高产品上游。

## 9.1 Required Downstream Use

以下 Systems 必须遵守 Core：

- Story。
- Learning。
- Content。
- Visual。
- UI/UX。
- Audio。
- Animation。
- Code。
- Performance。
- Accessibility。
- AI Review。
- QA。
- Release。

## 9.2 Core Inputs

Core 只依赖：

- Founder Authority。
- Explorer 长期价值。
- 法律、伦理、隐私与平台约束。
- 经验证的重大产品证据。

## 9.3 Forbidden Reverse Dependency

Core 不得依赖：

- 某个当前 Widget 的限制。
- 某个 AI Model 的能力。
- 某张已生成图片。
- 某次 Preview 的临时行为。
- 某个短期商业指标。

这些只能形成反馈。

不能反向成为 Core Authority。

---

# 10. Story Dependencies

## 10.1 Required Upstream Dependencies

Story 必须依赖：

- Core Product Principles。
- Journey Purpose。
- 可靠文化、历史、地理或文学来源。
- Content Research Evidence。
- Ordinary 或 Special Journey 类型。
- 适用的语言等级要求。

## 10.2 Required Downstream Consumers

Story Contract 是以下 Systems 的必须输入：

- Learning：定义学习内容与意义保持。
- Content：封装运行时 Story、Vocabulary 与 Metadata。
- Visual：定义世界、地点、人物、时间、天气、文化与情绪。
- UI/UX：定义阅读结构与内容状态。
- Audio：定义可朗读文本、语言与段落。
- AI Review：执行事实、文化与叙事检查。
- QA：执行 Story Quality 与跨等级一致性验证。

## 10.3 Optional Dependencies

Story 可选依赖：

- Visual Mood Exploration，用于确认表达可能性。
- Audio Readability Feedback，用于发现朗读困难。
- UI Reading-length Feedback，用于发现布局风险。

这些反馈不得：

- 改变 Story 核心意义。
- 替代文化来源。
- 反向要求 Story 配合已完成视觉。

## 10.4 Story Dependency Failure

以下任一情况出现，Story Contract FAIL：

- 来源不足。
- 事实与传说未区分。
- Ordinary/Special 类型不明。
- 核心意义不稳定。
- Level 版本改变原意。
- 文化真实性无法确认。

失败后返回 Story 与 Content Research。

Visual、Learning、UI、Audio 与 Code 不得自行修正 Story。

---

# 11. Content Dependencies

Content System 具有两个不同阶段。

必须分开，避免 Story ↔ Content 循环。

## 11.1 Research Evidence Phase

```text
Reliable Sources

↓

Content Research Evidence

↓

Story
```

此阶段 Content 是 Story 的上游证据提供者。

Content 不决定叙事意义。

## 11.2 Runtime Packaging Phase

```text
Approved Story and Learning Contract

↓

Content Runtime Packaging

↓

UI, Audio and Code
```

此阶段 Story 与 Learning 是 Content Packaging 的上游。

这两个阶段不是循环依赖。

因为：

- 输入 Artifact 不同。
- Owner 不同。
- 时间顺序不同。
- Approval Gate 不同。

## 11.3 Required Dependencies

Runtime Content 必须依赖：

- Approved Story Version。
- Learning Content Requirements。
- Stable Journey/Geo/Level IDs。
- Language and Locale Contract。
- Source/Evidence Status。
- Human or authorized Review Status。

## 11.4 Downstream Consumers

- Learning Runtime。
- UI/UX。
- Audio。
- Visual Brief。
- Code Catalog。
- AI Review。
- QA。
- Release。

## 11.5 Content Dependency Failure

以下情况禁止进入 Runtime：

- Schema 不完整。
- ID 冲突。
- Source 缺失。
- 多语言意义不一致。
- 未审核 AI Output。
- Story Version 不匹配。
- Level 标记错误。

---

# 12. Learning Dependencies

## 12.1 Required Upstream Dependencies

Learning 必须依赖：

- Core 的学习与 Explorer 原则。
- Approved Story Meaning。
- Reviewed Content。
- Phoenix Level Contract。
- Accessibility Requirements。

## 12.2 Required Downstream Consumers

Learning Flow 与 State Contract 是以下 Systems 的必须输入：

- UI/UX：页面顺序、状态、操作与完成条件。
- Audio：朗读、跟读、速度与反馈语义。
- Animation：只消费已批准的状态变化，不消费学习内部逻辑。
- Code：State、Progress、Persistence 与 Reward 实现。
- AI Review：学习一致性与无焦虑检查。
- QA：学习路径、难度与反馈验证。
- Release：学习 Gate Evidence。

## 12.3 Learning and Story Relationship

Story 定义：

- 世界。
- 人物。
- 意义。
- 文化与叙事。

Learning 定义：

- 学习顺序。
- 难度。
- 词汇与发现机会。
- Challenge 与 Feedback。
- Completion 与 Memory。

Learning 可以要求语言表达适配。

Learning 不得改写 Story 核心意义。

## 12.4 Learning and Visual Relationship

Learning 向 Visual 提供：

- 页面学习优先级。
- 内容密度。
- Reading Safe Area 需求。
- Challenge 与 Vocabulary 的低干扰要求。

Visual 向 Learning Experience 提供：

- 经过审核的视觉环境。
- Journey Identity。
- 视觉记忆支持。

Visual 不创建 Learning Content。

Learning 不规定具体美术实现。

## 12.5 Learning Dependency Failure

以下情况必须停止 UI/Code 集成：

- Flow 顺序不明。
- Completion Condition 不明。
- Level 行为不明。
- Challenge Attempt/Reward 规则冲突。
- Persistence 要求不明。
- 视觉或音频行为增加额外学习负担。

---

# 13. Visual Dependencies

## 13.1 Required Upstream Dependencies

任何正式 Visual 工作必须依赖：

- Core Product Principles。
- Visual Documentation。
- Approved Story/Journey Contract。
- Content Research 与文化依据。
- UI Reading/Button Safe Area Contract。
- Learning 页面优先级。
- Copyright 与 Commercial Use Evidence。
- Accessibility 与 Performance Constraints。

## 13.2 Required Downstream Consumers

Approved Visual Contract 可供以下 Systems 消费：

- UI/UX。
- Animation。
- Code。
- Performance。
- Accessibility。
- AI Review。
- QA。
- Release。

## 13.3 Visual and UI Staged Dependency

Visual 与 UI 必须采用分阶段 Contract，禁止循环等待。

阶段一：

```text
Learning and UI Information Architecture

↓

Reading Safe Area and Button Safe Area Contract

↓

Visual Production
```

阶段二：

```text
Approved Visual Asset and Metadata

↓

UI Runtime Integration
```

UI 先提供布局约束。

Visual 后提供可集成资产。

UI 不等待最终图片才定义信息层级。

Visual 不等待最终 UI 才定义全部安全区。

## 13.4 Visual and Animation Dependency

动态视觉额外依赖：

- Approved Static Visual。
- Motion Intent。
- Layer Plan。
- Reduced Motion Requirement。
- Performance Budget。
- Static Fallback。

如果动态不自然：

必须使用高质量静态方案。

## 13.5 Visual and Audio Relationship

Visual 不依赖 Audio 才能成立。

Audio 播放时，Visual/Animation 必须遵守：

- 不增加强动态。
- 不遮挡朗读状态。
- 不制造光线或镜头切换干扰。
- 不让 Audio Event 形成视觉循环依赖。

## 13.6 Visual Dependency Failure

以下任一依赖失败，Visual 禁止导入：

- Story 不稳定。
- 文化依据不足。
- 版权或商业使用无法确认。
- 阅读或按钮安全区失败。
- AI 错误明显。
- 手机或平板适配失败。
- 静态降级缺失。
- 性能未验证。
- Visual Gate 未通过。

---

# 14. UI/UX Dependencies

## 14.1 Required Upstream Dependencies

UI/UX 必须依赖：

- Core 的简洁与 Explorer 原则。
- Learning Flow 与 State Contract。
- Story/Content Structure。
- Visual Safe Area 与 Approved Asset Contract。
- Audio Control/State Contract。
- Accessibility Requirements。
- Performance Budget。

## 14.2 Required Downstream Consumers

UI State Contract 是以下 Systems 的输入：

- Animation：状态转场。
- Code：Screen、Widget、Navigation 与 State 实现。
- Accessibility：Focus、Semantics、Input 与 Text Scale 验证。
- QA：交互与恢复场景。
- Release：UI Acceptance Evidence。

## 14.3 UI and Audio Staged Dependency

阶段一：

```text
Learning Audio Requirement

↓

Audio State Contract

↓

UI Control Design
```

阶段二：

```text
UI Command

↓

Audio Runtime

↓

Audio State Event

↓

UI State Rendering
```

这是命令与事件流。

不是双方互相拥有规则的循环依赖。

## 14.4 UI Dependency Failure

以下情况禁止进入正式实现或 Release：

- Primary Action 不明。
- State 无法恢复。
- Loading/Error/Offline 缺失。
- 背景影响文字或按钮。
- Audio 状态与实际播放不一致。
- Focus、Semantics 或触控不合格。
- 小屏或平板布局失败。

---

# 15. Audio Dependencies

## 15.1 Required Upstream Dependencies

Audio 必须依赖：

- Approved Story/Content Text。
- Language、Locale 与 Pronunciation Metadata。
- Learning Goal。
- UI Command Contract。
- Permission 与 Privacy Requirement。
- Accessibility Alternative。
- Device Capability。

## 15.2 Required Downstream Consumers

Audio Runtime 输出由以下 Systems 消费：

- UI/UX：播放、暂停、进度、错误与恢复状态。
- Learning：跟读结果与训练反馈。
- Animation：仅消费批准的低干扰事件。
- Code：Persistence、Service 与 Platform Integration。
- Accessibility：可见替代与控制验证。
- QA：真实设备、浏览器与权限场景。

## 15.3 Optional Audio Dependencies

以下能力可按 Journey 范围成为可选依赖：

- 环境音。
- 非必要音效。
- 非学习关键语音反馈。

缺失时不得影响：

- 文本阅读。
- 核心学习。
- 状态理解。
- Journey 完成。

## 15.4 Audio Dependency Failure

以下情况必须提供可见、可操作降级：

- Speech Engine 不可用。
- Voice 不存在。
- Browser 阻止自动播放。
- 麦克风权限被拒绝。
- Recognition 不可靠。
- Audio State 与 UI 不一致。

不得显示虚假 Playing State。

---

# 16. Animation Dependencies

## 16.1 Conditional Dependency

静态页面不必须依赖运行时 Animation。

任何存在 Motion 的页面，Animation 立即成为必须依赖。

## 16.2 Required Upstream Dependencies

- Visual Motion Intent。
- UI State Transition。
- Static Fallback。
- Reduced Motion Requirement。
- Performance Budget。
- Device Capability。

## 16.3 Downstream Dependencies

- Code Implementation。
- Performance Validation。
- Accessibility Validation。
- QA Naturalness and Interaction Review。
- Release Gate。

## 16.4 Forbidden Dependency

Animation 禁止直接依赖：

- 未稳定的 Story 文本。
- Learning Internal State 的全部细节。
- Audio Boundary 的高频事件。
- 未审核 AI 生成图层。

只允许依赖明确、低频、版本化的 Trigger 与 Contract。

## 16.5 Animation Failure

- 循环不自然。
- 交互被覆盖。
- 文字区域亮度变化。
- Reduced Motion 无效。
- 性能不稳定。
- 返回页面跳变。

任一失败：

停止动态。

退回 Approved Static Fallback。

---

# 17. Development Dependencies

Development 不得直接从需求文字跳到代码。

## 17.1 Required Development Chain

```text
Approved Requirement

↓

Applicable Documentation

↓

System Contracts

↓

Current Code and Test Inspection

↓

Implementation Plan

↓

Code / Content / Asset Change

↓

Targeted Validation

↓

Cross-system Validation
```

## 17.2 Code Dependencies

Code 必须依赖：

- 稳定 ID。
- 明确 Schema。
- 明确 State。
- 明确 Error/Fallback。
- 明确 Accessibility Behavior。
- 明确 Performance Constraint。
- 明确 Acceptance Criteria。

## 17.3 Test Dependencies

Test 必须依赖：

- 正式规则。
- 真实 Contract。
- 可重复 Fixture。
- 明确 Expected Result。

测试不得依赖实现内部偶然行为作为唯一正确答案。

## 17.4 External Dependencies

新增 Package、API、Model、Service 或 Platform Capability 前必须检查：

- 必要性。
- License。
- Privacy。
- Security。
- Commercial Use。
- Offline/Fallback。
- Performance。
- Accessibility。
- Maintenance Risk。

外部依赖失败不得破坏 Core Learning Path。

## 17.5 Development Dependency Failure

以下情况停止开发：

- Requirement Owner 不明。
- System Contract 冲突。
- 输入版本不稳定。
- Secret 或权限缺失。
- 外部 License 不明。
- 无法建立安全 Fallback。
- 关键测试无法定义。

---

# 18. Review Dependencies

Review 必须依赖正式规则与可检查对象。

## 18.1 Review Chain

```text
Candidate Output

↓

Target System Standards

↓

Specialized Gate and Checklist

↓

AI Review where applicable

↓

Human / Professional Review

↓

QA Evidence
```

## 18.2 Required Review Dependencies

每次 Review 至少需要：

- Candidate Version。
- Applicable Documentation Version。
- Scope。
- Acceptance Criteria。
- Source/Metadata。
- Test 或 Inspection Evidence。
- Reviewer Role。
- PASS/FAIL/BLOCKED Result。

## 18.3 AI Review Dependency

AI Review 在以下情况为必须依赖：

- AI 生成 Story/Content。
- AI 生成 Visual。
- 大规模跨 Journey 一致性检查。
- 已定义由 AI Review 执行的正式 Gate。

AI Review 结果仍必须依赖：

- 正式规则。
- Source Evidence。
- Human Escalation Path。

AI Review 不得成为自己的批准者。

## 18.4 Professional Review Dependencies

不同对象依赖不同 Reviewer：

| Object | Required review perspectives |
| --- | --- |
| Story | Story、Culture、Source、Learning |
| Content | Source、Language、Schema、Learning |
| Visual | Visual、Story、Culture、Copyright、UI、Accessibility、Performance |
| UI/UX | Learning、Visual、Accessibility、Performance |
| Audio | Language、Learning、UI、Accessibility、Device |
| Animation | Visual、UI、Accessibility、Performance |
| Code | Architecture、Security、Test、Performance |
| Release | QA、CI、Artifact、Environment、Authorization |

## 18.5 Review Failure

Review FAIL 必须包含：

- Failed Rule。
- Evidence。
- Owner System。
- Return Stage。
- Re-review Requirement。

不得只写：

- 不够好。
- 再优化。
- 感觉不对。

---

# 19. QA Dependencies

QA 是 Release 的必须上游。

## 19.1 Required Upstream Dependencies

QA 必须依赖：

- Approved Requirement。
- Applicable Documentation。
- Candidate Commit/Build/Content/Asset Version。
- System-specific Gate Result。
- Test Environment。
- Device/Browser Matrix。
- AI Review 与 Professional Review Evidence（适用时）。

## 19.2 QA Output Dependencies

Release 只能消费：

- 明确 Scope 的 QA Result。
- 与目标 Commit/Artifact 一致的 Evidence。
- 已列出未验证项的结果。
- 没有未处理 Blocking Failure 的状态。

## 19.3 QA and Story/Learning/Visual/UI/Audio

- Story 向 QA 提供 Story Contract 与 Source Status。
- Learning 向 QA 提供 Flow、Level、Challenge 与 Completion Criteria。
- Visual 向 QA 提供 Asset Metadata、Gate、Fallback 与 Device Variants。
- UI 向 QA 提供 State、Navigation、Responsive 与 Recovery Criteria。
- Audio 向 QA 提供 Playback、Permission、Error 与 Restoration Criteria。
- QA 只验证，不改写这些规则。

## 19.4 QA Dependency Failure

以下情况 QA 必须 `BLOCKED` 或 `FAIL`：

- Candidate Version 不明。
- 测试结果属于另一个 Commit。
- 必须环境不可用。
- 必须设备未验证。
- Gate 缺失。
- Evidence 不完整。
- Review Scope 小于 Release Scope。

---

# 20. Release Dependencies

Release 是产品依赖链的最后交付系统。

## 20.1 Required Release Inputs

任何正式 Release 必须依赖：

- 明确 Branch 与 Commit SHA。
- Approved Scope。
- Required Professional Gate PASS。
- QA PASS。
- CI PASS。
- Build Artifact Identity。
- Environment Configuration。
- Deployment/Health Check Plan。
- Rollback Point。
- Release Authorization。

## 20.2 Conditional Release Inputs

按范围决定：

- Preview Evidence。
- Migration Plan。
- Data Backup。
- App Store Metadata。
- Privacy Review。
- Copyright Package。
- Performance Benchmark。
- Accessibility Report。

一旦范围触发，就必须转为 Required。

## 20.3 Release Outputs

- Deployment Record。
- Release Version。
- Target Commit SHA。
- Artifact Identity。
- Health Check Result。
- Rollback Reference。
- CHANGELOG Entry。

## 20.4 Forbidden Release Dependencies

Release 禁止依赖：

- 未提交工作区。
- 无法追踪 Commit 的 Build。
- 另一个分支的测试结果。
- 口头“应该通过”。
- Preview 截图作为唯一证据。
- AI Review PASS 作为唯一 QA。
- 未授权 Merge。

## 20.5 Documentation-only Release

Documentation Recovery Commit 可以不触发产品 Preview。

但仍必须依赖：

- 正确 Branch。
- 单一文件 Scope。
- Markdown/结构检查。
- 跨文档冲突检查。
- 真实 Commit。
- 未合并 `main` 的明确状态。

---

# 21. Data and Content Flow

Phoenix 必须区分不同流向。

## 21.1 Authority Flow

```text
Core

↓

Professional Standards

↓

System Contracts

↓

Implementation
```

Authority 只向下流动。

下游反馈不能自动反转 Authority。

## 21.2 Research and Content Flow

```text
Reliable Sources

↓

Content Research Evidence

↓

Story and Learning Approval

↓

Structured Runtime Content

↓

UI, Audio and Code
```

## 21.3 Visual Flow

```text
Story + Culture + Learning + UI Safe Areas

↓

Visual Design and Production

↓

Visual Review and Copyright Check

↓

Runtime Variants and Static Fallback

↓

UI/Animation/Code Integration

↓

Page-level QA
```

## 21.4 Runtime State Flow

```text
Explorer Action

↓

UI Command

↓

Learning / Audio / Navigation Service

↓

Validated State Change

↓

Persistence where required

↓

UI Rendering and Accessibility Announcement
```

## 21.5 Review Evidence Flow

```text
System Output

↓

Specialized Review

↓

AI Review where applicable

↓

QA

↓

Release Evidence
```

## 21.6 Prohibited Flow

禁止：

- Runtime UI 直接写回正式 Story Source。
- AI Output 绕过 Content Review 进入 Catalog。
- Visual Candidate 绕过 Copyright 进入 Runtime Assets。
- Test Fixture 反向成为正式 Content。
- Preview State 写回 Production 状态。
- Release Artifact 反向覆盖未更新的 Source。

---

# 22. Upstream and Downstream Rules

## 22.1 Upstream Responsibilities

上游必须：

- 提供唯一可识别 Artifact。
- 提供 Version。
- 提供 Status。
- 提供 Required Fields。
- 提供 Validation Evidence。
- 说明 Breaking Change。
- 说明 Failure Owner。

## 22.2 Downstream Responsibilities

下游必须：

- 验证输入版本。
- 验证 Required Fields。
- 拒绝未批准输入。
- 不修改上游意义。
- 记录实际消费版本。
- 对自己的输出负责。
- 将失败返回正确 Owner。

## 22.3 Feedback Responsibilities

下游反馈必须包含：

- 观察到的问题。
- 可重复证据。
- 受影响 Contract。
- 建议回到的 System。
- 是否 Blocking。

反馈不得直接附带未经批准的规则修改。

---

# 23. No Circular Dependencies

Phoenix 禁止循环依赖。

## 23.1 Circular Authority

禁止：

```text
Story waits for Visual approval

while

Visual waits for Story meaning
```

正确方式：

Story 先批准 Meaning Contract。

Visual 再表达。

## 23.2 Circular Data Ownership

禁止两个 System 同时拥有同一 State 的写入权。

例如：

- UI 与 Learning 同时修改 Completion State。
- UI 与 Audio 同时推断 Playing State。
- Content 与 Code 同时生成正式 Journey ID。

必须指定单一 Owner。

## 23.3 Circular Review

禁止：

- AI 生成并独立批准自己的资源。
- 开发者只用自己新增的测试证明需求正确。
- Release 修改 Gate 后批准同一 Candidate。

## 23.4 Reciprocal Coordination Is Not a Cycle

以下关系可以双向沟通，但必须阶段化：

- Story Research Evidence → Story → Runtime Content Packaging。
- UI Safe Area → Visual Asset → UI Integration。
- Audio Contract → UI Command → Audio Event → UI Render。
- Code Limitation → Owner Review → Updated Contract → Code Change。

判断是否为循环依赖时检查：

- 是否同一 Artifact。
- 是否同一阶段。
- 是否同一批准权。
- 是否双方都等待对方完成。

任一为真且无明确 Owner，视为循环风险。

## 23.5 Cycle Resolution

发现循环时：

1. 列出全部 Artifact。
2. 为每个 Artifact 指定唯一 Owner。
3. 拆分 Research、Definition、Implementation 与 Feedback 阶段。
4. 固定 Authority Direction。
5. 建立 Versioned Contract。
6. 删除隐式共享写入。
7. 增加 Contract Test。

---

# 24. Dependency Failure Handling

## 24.1 Failure Types

依赖失败包括：

- Missing。
- Invalid。
- Outdated。
- Conflicting。
- Unreviewed。
- Unauthorized。
- Unavailable。
- Incompatible。
- Untraceable。

## 24.2 Failure Response

统一流程：

```text
Detect Dependency Failure

↓

Stop Downstream Progress

↓

Identify Provider and Artifact

↓

Record Evidence and Impact

↓

Return to Owner System

↓

Correct and Re-version

↓

Re-run Dependency Gate

↓

Resume Downstream Work
```

## 24.3 No Silent Substitution

禁止：

- 用旧 Story 代替缺失新 Story。
- 用低分辨率图代替未完成正式图并不标记。
- 用默认 Voice 伪装指定 Voice 已工作。
- 用 Mock Data 进入正式 Release。
- 用另一个 Commit 的 QA 结果替代当前结果。

## 24.4 Approved Fallback

Fallback 只有在以下条件全部满足时才允许：

- 由 Owner System 预先定义。
- 不改变核心意义。
- 不降低安全、版权或可访问性。
- 状态对 UI 和 QA 可见。
- 已通过对应 Gate。

例如：

- 动态背景失败 → Approved Static Fallback。
- Speech Engine 失败 → 可阅读文本与明确重试状态。
- 网络失败 → Reviewed Local Content。

## 24.5 Blocking Failures

以下依赖失败永远阻断正式导入或 Release：

- Core Rule 冲突。
- Story 事实或文化依据无法确认。
- 版权或商业使用无法确认。
- 明显 AI 错误。
- Learning Flow 被破坏。
- 文字、按钮或关键操作不可用。
- Accessibility Blocking Failure。
- Performance 无法在目标设备稳定运行。
- QA 未通过。
- Release Authorization 缺失。

---

# 25. Cross-system Change Synchronization

任何跨系统修改必须执行同步检查。

## 25.1 Change Impact Identification

修改前必须列出：

- Owner System。
- Changed Contract。
- Upstream Inputs。
- Downstream Consumers。
- Required Documentation。
- Required Tests。
- Required Reviews。
- Release Impact。

## 25.2 Upstream Change Checklist

上游变化时检查：

- Story Version 是否变化。
- Content Schema 是否变化。
- Learning State 是否变化。
- Visual Brief 是否失效。
- UI State 是否失效。
- Audio Text/Boundary 是否失效。
- Test Fixture 是否失效。
- Release Candidate 是否需要重建。

## 25.3 Downstream Change Checklist

下游实现变化时检查：

- 是否仍符合上游 Contract。
- 是否产生新 State。
- 是否需要新的 Error/Fallback。
- 是否改变 Performance。
- 是否改变 Accessibility。
- 是否需要更新 QA Scenario。
- 是否需要更新 Release Evidence。

## 25.4 Documentation Synchronization

跨系统变化必须检查：

- `SYSTEM_ARCHITECTURE.md`。
- `SYSTEM_DEPENDENCY.md`。
- `SYSTEM_LIFECYCLE.md`。
- `SYSTEM_PRIORITY.md`。
- Owner System Documentation。
- Consumer System Documentation。
- Pipeline、Gate、Checklist 与 Review Prompt。

不受影响的文件不得为了“保持一致”被无意义改写。

## 25.5 Code Synchronization

必须检查：

- Models。
- Catalog/Schema。
- State。
- Services。
- Screens/Widgets。
- Agents。
- Tests。
- Worker Rules。
- Build/Deployment Configuration。

## 25.6 Review Synchronization

必须重新执行所有受影响 Gate。

旧 PASS 只对旧 Contract 与旧 Candidate 有效。

## 25.7 Release Synchronization

如果已创建 Preview 或 Release Candidate：

- 更新 Commit SHA。
- 重新 Build。
- 重新运行受影响 CI。
- 重新验证 Preview。
- 更新 Release Evidence。
- 旧 Artifact 不得继续作为当前候选。

---

# 26. Cross-system Change Examples

## 26.1 Story Text Change

必须检查：

- Content Version。
- Level Meaning Preservation。
- Vocabulary 与 Discovery。
- Audio Text/Boundary。
- Visual Scene 是否仍一致。
- UI Reading Length。
- QA Story 与 Narration Tests。

## 26.2 Learning Flow Change

必须检查：

- UI Navigation。
- Progress State。
- Challenge State。
- Audio Trigger。
- Animation Trigger。
- Persistence。
- Accessibility。
- QA 与 Release Evidence。

## 26.3 Visual Asset Change

必须检查：

- Story/Journey Identity。
- Copyright Metadata。
- UI Safe Areas。
- Animation Layers。
- Static Fallback。
- Device Variants。
- Performance。
- Accessibility。
- Page-level QA。

## 26.4 Audio Change

必须检查：

- UI Control State。
- Learning Goal。
- Position Restoration。
- Permission/Privacy。
- Accessibility Alternative。
- Browser/Device QA。

## 26.5 Code Refactor

必须检查：

- Public Contract 是否保持。
- State/Persistence 是否迁移。
- Error/Fallback 是否保持。
- Tests 是否仍验证正式行为，而非内部实现。
- Performance 与 Accessibility 是否回归。

## 26.6 Release Workflow Change

必须检查：

- Branch/PR Rules。
- CI Coverage。
- Artifact Identity。
- Secret and Environment Handling。
- Preview Isolation。
- Health Check。
- Rollback。
- Merge Authorization。

---

# 27. Dependency Review

每次 Dependency Review 必须确认：

- Provider 唯一。
- Consumer 明确。
- Required/Optional 已标记。
- Conditional Dependency 已解析。
- Artifact 有 Version。
- Status 可验证。
- 上游不依赖下游批准自己的规则。
- 数据只有明确 Owner 可以写入。
- 失败有 Return Path。
- Fallback 已批准。
- Review Evidence 与 Candidate 一致。
- Release Evidence 与 Commit 一致。
- Visual 任务已从 Visual README 进入。
- Story、Learning、Visual、UI、Audio、QA 与 Release 的边界未被混合。

任何关键依赖不明确：

Dependency Review 必须 `FAIL` 或 `BLOCKED`。

不得进入下一阶段。

---

# 28. Permanent Rule

Phoenix 所有正式工作必须建立明确依赖链。

Documentation 定义读取依赖。

Core 定义最高产品依赖。

Story 定义世界与意义依赖。

Content 提供研究证据并封装已批准内容。

Learning 定义学习流程与状态依赖。

Visual 依赖 Story、Culture、Learning、UI Safe Area、Copyright、Performance 与 Accessibility。

UI/UX 依赖 Learning、Content、Visual、Audio、Accessibility 与 Performance Contracts。

Audio 依赖 Approved Text、Learning Goal、UI Command、Permission、Device 与 Accessibility。

Animation 在存在 Motion 时依赖 Visual Intent、UI State、Static Fallback、Reduced Motion 与 Performance。

Code 依赖所有已批准专业 Contract。

AI Review 与 Professional Review 依赖正式规则和可追踪 Candidate。

QA 依赖完整输入、专业 Gate 与可重复证据。

Release 必须依赖目标 Commit 的 QA PASS、CI、Artifact、Health Check、Rollback 与授权。

任何必须依赖失败：

立即停止下游。

返回拥有该输入的上游 System 修正。

任何可选依赖：

不得成为核心功能、安全、版权、可访问性或正式质量的唯一来源。

Phoenix 禁止：

- 循环 Authority。
- 循环 State Ownership。
- 自我 Review 与自我批准。
- 隐式共享写入。
- 跨 Commit 复用不匹配 Evidence。
- 用 Fallback 隐藏依赖失败。

只有上游、下游、数据流、Review 与 Release Evidence 全部可追踪，Phoenix 才允许进入下一阶段。
