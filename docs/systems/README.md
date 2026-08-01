# Phoenix Documentation System

Documentation Status: Reconstructed and Reviewed
Documentation Version: 1.0.0
Priority: ★★★★★ (Highest)
Owner: Phoenix Documentation Architecture

---

# 1. Purpose

Phoenix Documentation System（简称 PDS）是 Phoenix 全部正式 Documentation 的总入口。

它负责：

- 指明不同任务必须读取哪些文档。
- 规定文档读取顺序。
- 说明各 Professional System 的职责边界。
- 说明文档之间的优先级与冲突处理方式。
- 保持产品需求、实现状态、测试证据与发布记录可追踪。
- 让未来 AI、开发者、编辑、设计者、审核者与发布负责人从同一事实基础开始工作。

Documentation System 不是：

- 产品功能清单。
- Visual System 的替代规范。
- 代码注释集合。
- 临时开发笔记。
- 自动证明功能已完成的证据。

本文件只负责 Documentation Navigation、Governance 与跨系统边界。

它不重新定义：

- Story 规则。
- Visual 原则。
- Learning 流程。
- UI 交互。
- Audio 行为。
- QA Gate。
- Release 操作。

各专业规则必须由对应 System 的正式 Documentation 定义。

---

# 2. Documentation Mission

Phoenix Documentation 的使命是：

> 让每一次产品决策、内容生产、设计、开发、审核与发布，都能够从正确规范开始，并与当前真实实现保持一致。

Phoenix 不允许未来 AI 或开发者仅凭：

- 旧聊天记录。
- 记忆。
- 文件名猜测。
- 过期 Roadmap。
- 页面截图。
- 单一测试。
- 单一代码片段。

决定产品规则或宣称功能状态。

Documentation 负责定义应当是什么。

代码与测试负责证明当前实现是什么。

发布记录负责证明哪些内容已经正式交付。

三者必须保持关联，但不得互相冒充。

---

# 3. Documentation Principles

## Principle One

Single Source of Truth。

同一正式规则只允许存在一个权威来源。

其它文档应引用，不得复制后形成第二套规则。

---

## Principle Two

Reality Before Assumption。

功能状态必须由当前代码、测试、运行验证与发布记录共同确认。

不得因文档写有目标，就声称功能已经完成。

---

## Principle Three

Architecture Before Implementation。

先确认系统、依赖、生命周期、优先级与目标规范。

再修改内容、视觉、UI、代码或发布配置。

---

## Principle Four

Explicit Status Before Interpretation。

所有状态必须明确区分：

- 已完成。
- 开发中。
- 规划中。

不得使用模糊语言掩盖状态差异。

---

## Principle Five

System Boundaries Before Convenience。

一个 System 不得为了方便接管另一个 System 的职责。

例如：

- Visual 不定义 Learning Logic。
- UI 不改写 Story。
- QA 不创造产品规则。
- Release 不降低 Quality Gate。

---

## Principle Six

Evidence Before Completion Claims。

“文档完成”“代码已实现”“测试通过”“正式发布”是四种不同结论。

任何结论必须拥有对应证据。

---

## Principle Seven

Documentation Evolves Without Losing Traceability。

文档可以演进。

但必须保留：

- 明确版本。
- 变更原因。
- 影响范围。
- 与代码和发布的关联。

---

# 4. Documentation Directory Map

Phoenix 正式 Documentation 采用以下目标结构：

```text
docs/

├── core/
│   ├── README.md
│   ├── PHOENIX_CONSTITUTION.md
│   └── PRODUCT_PRINCIPLES.md
│
├── systems/
│   ├── README.md
│   ├── SYSTEM_ARCHITECTURE.md
│   ├── SYSTEM_DEPENDENCY.md
│   ├── SYSTEM_LIFECYCLE.md
│   └── SYSTEM_PRIORITY.md
│
├── story/
│   └── ...
│
├── visual/
│   └── ...
│
├── learning/
│   └── ...
│
├── ui/
│   └── ...
│
├── audio/
│   └── ...
│
├── qa/
│   └── ...
│
├── code/
│   └── ...
│
└── release/
    └── ...
```

Repository 中的辅助信息继续按职责存放：

```text
roadmap/ROADMAP.md
TODO.md
CHANGELOG.md
```

目标结构不等于当前所有文件已经存在。

缺失文件必须通过独立 Documentation Recovery Sprint 或正式 Documentation Sprint 建立。

不得因目录已规划，就声称该 System 的规范已经完成。

---

# 5. Current Documentation State

截至本版本，Documentation 状态必须按仓库事实理解。

## 5.1 已重建、恢复并通过本次 Review

- `docs/systems/README.md`：Documentation System 总入口。
- `docs/systems/SYSTEM_ARCHITECTURE.md`：Professional Systems 架构、边界与接口。
- `docs/systems/SYSTEM_DEPENDENCY.md`：系统、开发、Review 与 Release 依赖。
- `docs/systems/SYSTEM_LIFECYCLE.md`：从需求到维护或退役的生命周期。
- `docs/systems/SYSTEM_PRIORITY.md`：规范冲突的唯一优先级。
- `docs/story/README.md`：Story System 唯一入口。
- `docs/story/STORY_CONSTITUTION.md`：Story System 最高专业规范。
- `docs/story/STORY_PHILOSOPHY.md`：Story 文学与阅读理念。
- `docs/story/STORY_DECISION_TREE.md`：Story 类型与问题处理路径。
- `docs/story/STORY_PIPELINE.md`：Story Production Pipeline。
- `docs/story/STORY_CHECKLIST.md`：Story 发布前检查清单。
- `docs/visual/README.md`：Visual System 导航。
- `docs/visual/VISUAL_CONSTITUTION.md`：Visual System 最高规范。
- `docs/visual/VISUAL_PHILOSOPHY.md`：Visual 思想与美学基础。
- `docs/visual/VISUAL_GUIDELINES.md`：Visual 统一执行规范。
- `docs/visual/BACKGROUND_GUIDELINES.md`：Background 专项规范。
- `docs/visual/AI_IMAGE_GENERATION_GUIDE.md`：AI 原创视觉生成规范。

Visual 文件的 Review 状态只在 Visual System 职责范围内生效。

它们不拥有 Product、Story、Learning、UI、Audio、Code、QA 或 Release 的解释权。

## 5.2 尚未重建或尚未恢复

- Story Guidelines、Ordinary/Special Journey Guidelines、Story Quality Gate 与 Story Review Prompt。
- 其它曾经存在但无法逐字安全恢复的 Documentation。

重建文件必须标记：

```text
Documentation Status: Reconstructed and Reviewed
```

重建表示：

- 依据当前产品、代码与已恢复规范重新建立。
- 不是旧文档的逐字恢复。
- 必须经过独立 Commit 审查。

## 5.3 规划中

- Learning System 正式规范集。
- UI System 正式规范集。
- Audio System 正式规范集。
- QA System 正式规范集。
- Code System 正式规范集。
- Release System 正式规范集。
- 尚未恢复或尚未建立的 Visual 专项文件。

规划中的 Documentation 不得被引用为已经生效的完整规范。

在专项文件建立前，只能依据当前有效上位规则、现有代码事实、测试和明确决策工作。

---

# 6. System Responsibilities

每个 System 只负责自己的专业范围。

## 6.1 Core System

Core 负责定义 Phoenix 不可轻易改变的产品基础。

包括：

- Phoenix 为什么存在。
- Explorer 的核心价值。
- 产品定位。
- 真实性、原创性与学习价值。
- 隐私、广告、付费与长期伦理原则。
- 全部 Professional Systems 必须遵守的最高产品边界。

Core 不负责具体实现步骤。

当前仓库根目录和 `docs/` 下的部分早期 Product 文档提供历史与产品原则依据，但在正式 Core 目录重建前，必须同时检查其日期、代码事实与后续正式规范。

---

## 6.2 Documentation System

Documentation System 负责：

- 文档架构。
- 文档导航。
- 系统依赖。
- 系统生命周期。
- 系统优先级。
- 文档状态。
- 文档版本。
- 文档维护与冲突处理。

Documentation System 不定义专业系统内部规则。

---

## 6.3 Story System

Story 负责：

- Journey 世界与叙事意义。
- 人物、场景、冲突、转折与结尾。
- Ordinary Journey 与 Special Journey 的叙事边界。
- 事实、传说、解释与文学想象的标识。
- Story 来源、文化真实性与叙事质量。
- Phoenix Lv.1–10 的故事表达要求。

Story 不负责：

- 视觉实现。
- UI 布局。
- 音频引擎。
- Challenge 代码。
- 发布流程。

---

## 6.4 Visual System

Visual 负责：

- Visual Constitution。
- Visual Philosophy。
- 视觉一致性与 Journey Identity。
- 图片、背景、地图、护照、Banner、Loading、Splash 与 UI Illustration 的视觉表达。
- AI 原创视觉生成、文化视觉检查、版权与商业使用检查。
- 阅读安全区、按钮安全区、设备适配、静态降级与视觉质量审核。

Visual 不负责：

- 定义产品目标。
- 改写 Story。
- 定义 Learning Flow。
- 定义 UI Business Logic。
- 定义 Audio 行为。
- 定义 Release 决策。

Visual 的完整职责以 `docs/visual/README.md` 及其正式规范为准。

本文件不得覆盖、缩减或重新解释 Visual System。

---

## 6.5 Learning System

Learning 负责：

- Phoenix Learning Flow。
- Story、Vocabulary、Discovery、Challenge、Reflection 与 Stamp 的学习关系。
- Phoenix Lv.1–10 难度适配。
- 词汇解释、复习、挑战机会、反馈与学习记忆。
- 学习目标、评估、奖励与无焦虑体验。
- 免费与付费容量规则对学习公平性的影响。

Learning 不负责视觉风格或页面绘制。

当前代码存在 Journey 学习流程、难度适配、词汇、挑战与本地学习状态；这只能证明相应实现存在，不能代替未来 Learning Documentation。

---

## 6.6 UI System

UI 负责：

- 信息架构。
- 页面结构。
- 导航。
- 组件。
- 交互状态。
- Responsive Layout。
- Accessibility。
- 输入、按钮、反馈、错误与空状态。

UI 与 Visual 共同构成体验，但职责不同：

- UI 决定如何操作。
- Visual 决定如何被看见。

UI 不得以布局需要为理由破坏 Visual 的阅读安全原则。

Visual 也不得以氛围为理由改变 UI 的学习和交互逻辑。

---

## 6.7 Audio System

Audio 负责：

- Story 与 Discovery 朗读。
- 词语发音。
- Voice Selection。
- 语速、暂停、继续、定位与恢复。
- 跟读训练、语音识别、评分与反馈。
- 音频可访问性、错误处理与设备兼容。

Audio 不负责 Story 内容或 Visual Motion。

当前代码存在朗读控制、Voice Picker、Narration Follow、Seek、Web Speech 与独立跟读训练；其正式状态仍必须由运行验证、测试与 Release 记录确认。

---

## 6.8 QA System

QA 负责验证：

- 需求是否实现。
- 正式规范是否满足。
- 测试是否覆盖关键行为。
- 手机、平板与 Web 是否稳定。
- 内容、文化、版权、可访问性与性能是否通过对应 Gate。
- 回归风险是否可接受。

QA 不负责创造产品规则。

QA 只能依据正式规范与验收条件判定 PASS 或 FAIL。

---

## 6.9 Code System

Code 负责：

- Flutter Application Architecture。
- State、Data、Service、Agent、Screen 与 Widget 边界。
- Worker、AI Gateway 与服务接口。
- 数据模型、持久化、错误处理与性能实现。
- 测试结构、代码质量与依赖管理。
- Documentation 要求在实现中的可追踪落地。

Code 不得自行修改产品宪法、Story 意义或 Visual 原则。

当实现限制与正式规范冲突时，必须回到对应 System 解决，不得静默降低规范。

---

## 6.10 Release System

Release 负责：

- Branch、Commit、PR、Preview 与 Merge 流程。
- CI、Build、Deployment 与 Rollback。
- 版本号与 Release Evidence。
- 发布前 Gate 汇总。
- Stable、Preview、Alpha 与正式版本边界。
- CHANGELOG 与可交付状态记录。

Release 不得：

- 把代码已提交等同于正式发布。
- 把 Preview 通过等同于已合并 `main`。
- 绕过 QA 或专业 Gate。
- 在没有授权时合并 `main`。

---

# 7. Current Product Evidence

Documentation 读取必须结合当前仓库事实。

当前代码树能够确认存在以下实现：

- Flutter Application。
- Explore、Passport、Shadowing Training 与 Me 导航入口。
- Ordinary Journey 与 Special Journey 数据结构。
- Story、Discovery、Challenge、Reflection/Memory 与 Stamp 页面流程代码。
- Phoenix Lv.1–10 难度与内容适配代码。
- Vocabulary、点词解释与已保存词汇相关实现。
- 本地状态、Journey Progress、Stamp 与学习记录相关实现。
- Narration、Voice Selection、Seek、Follow 与 Web Speech 相关实现。
- 跟读内容、语音识别评分与训练历史相关实现。
- Journey Background、Map、Passport 与 Special Realm 视觉资源。
- Flutter Tests 与 Worker Product Rule Tests。
- Cloudflare、CI 与 Preview 相关仓库配置。

以上属于“实现存在”的代码事实。

它不自动证明：

- 所有功能已经达到正式版质量。
- 所有设备已经通过验收。
- 所有内容已经完成文化审核。
- 所有视觉已经通过完整 Visual Pipeline。
- 所有规划中的 Backend 已经上线。
- 所有代码已经合并并发布到 `main`。

当前仓库同时包含 Supabase Schema 与 Backend 设计资料。

在存在真实部署、连接、测试与 Release Evidence 之前，Backend 与 Cloud Sync 必须视为规划中或开发中，不得声称已完成。

---

# 8. Standard Documentation Reading Order

任何 Phoenix 工作统一采用以下基础顺序：

```text
Repository README

↓

Documentation System README

↓

Core Constitution and Product Principles

↓

SYSTEM_ARCHITECTURE

↓

SYSTEM_DEPENDENCY

↓

SYSTEM_LIFECYCLE

↓

SYSTEM_PRIORITY

↓

Target System README

↓

Target System Constitution / Philosophy / Guidelines

↓

Adjacent System Dependencies

↓

Task-specific Decision Tree / Pipeline / Gate / Checklist / Review

↓

Current Code, Tests, Roadmap and Release Evidence

↓

Development
```

尚未重建的文档不得被假装已经读取。

如果任务依赖缺失的最高级规则，并且无法从现有有效规范与明确产品决策安全判断：

必须停止。

先恢复对应 Documentation。

---

# 9. Task Reading Routes

不同任务必须进入不同 Documentation 路径。

## 9.1 Product Direction

读取：

1. Repository README。
2. Documentation System README。
3. Core Constitution。
4. Product Principles。
5. System Architecture、Dependency、Lifecycle 与 Priority。
6. Roadmap。
7. 当前代码与 Release Evidence。

不得仅根据 Roadmap 改变产品原则。

---

## 9.2 New Journey

读取：

1. Documentation 基础顺序。
2. Story System。
3. Learning System。
4. Visual System。
5. UI、Audio 与 QA 中与该 Journey 有关的规范。
6. Content Sources 与 Journey Metadata。
7. Release Gate。

Story 先定义世界与意义。

Visual 只表达该世界。

---

## 9.3 Story Writing or Revision

读取：

1. Documentation 基础顺序。
2. Story README。
3. Story Constitution、Philosophy 与 Guidelines。
4. Ordinary 或 Special Journey 专项规范。
5. Story Decision Tree。
6. Story Source、文化资料与事实审核要求。
7. Learning Level 规范。
8. Story Pipeline、Quality Gate、Checklist 与 Review。

Visual Documentation 只在需要视觉关联时读取。

不得让 Visual 反向改写 Story。

---

## 9.4 Visual Asset or Background

读取：

1. Documentation 基础顺序。
2. 对应 Story 与 Journey Documentation。
3. `docs/visual/README.md`。
4. `VISUAL_CONSTITUTION.md`。
5. `VISUAL_PHILOSOPHY.md`。
6. `VISUAL_GUIDELINES.md`。
7. 对应 Visual 专项规范。
8. Visual Pipeline、Quality Gate、Checklist 与 Review。
9. 性能、设备与版权要求。

Visual 的详细读取顺序以 `docs/visual/README.md` 为唯一入口。

---

## 9.5 Learning Flow or Challenge

读取：

1. Documentation 基础顺序。
2. Learning System。
3. Story System 中与内容和难度有关的规范。
4. UI System 中与交互有关的规范。
5. Audio System 中与朗读或跟读有关的规范。
6. QA 的学习与回归 Gate。
7. 当前 Learning Services、State 与 Tests。

---

## 9.6 UI Page or Component

读取：

1. Documentation 基础顺序。
2. UI System。
3. 对应业务 System。
4. Visual Guidelines 与 Background Guidelines。
5. Accessibility、Responsive 与 QA 规范。
6. 当前 Screen、Widget 与 Widget Tests。

UI 不得只依据截图实现。

---

## 9.7 Narration or Shadowing

读取：

1. Documentation 基础顺序。
2. Audio System。
3. Learning System。
4. Story 的语言内容规范。
5. UI 的控制与状态规范。
6. Accessibility 与 QA 规范。
7. 当前 Narration、Speech、Shadowing Services 与 Tests。

---

## 9.8 Bug Fix

读取：

1. Documentation System README。
2. 受影响 System 的正式规范。
3. 依赖 System 的相关规则。
4. 当前代码路径。
5. 现有测试与历史决策。
6. Release 与回归要求。

Bug Fix 不得以“只改一行”为理由绕过规范。

---

## 9.9 QA or Review

读取：

1. Documentation System README。
2. 被审核 System 的正式规则。
3. 对应 Gate、Checklist 与 Review Prompt。
4. Acceptance Criteria。
5. 代码、测试、设备验证与 Preview Evidence。

Review 必须引用规则来源。

不得用个人偏好代替正式标准。

---

## 9.10 Release or Deployment

读取：

1. Documentation 基础顺序。
2. Release System。
3. QA Gate。
4. 受影响专业系统的发布条件。
5. Branch、Commit、PR 与 CI 状态。
6. Preview、Build、Deployment 与 Rollback Evidence。
7. CHANGELOG。

发布负责人不重新定义专业质量标准。

---

# 10. Documentation Priority Overview

当文档发生冲突时，按以下顺序处理：

```text
Level 1 — Phoenix Constitution and Non-negotiable Product Principles

↓

Level 2 — Documentation Architecture, Dependency, Lifecycle and Priority

↓

Level 3 — Target System Constitution

↓

Level 4 — Target System Philosophy and Guidelines

↓

Level 5 — Specialized Guides, Pipelines and Policies

↓

Level 6 — Quality Gates, Checklists and Review Prompts

↓

Level 7 — Roadmap, Release Plan and Operational Documentation

↓

Level 8 — Implementation Notes and Historical Documentation
```

同一层级发生冲突时：

1. 先确认适用范围。
2. 先使用职责更具体的正式文档。
3. 再比较 Documentation Version 与生效状态。
4. 检查是否存在明确 Decision Record。
5. 无法消除冲突时停止开发并升级到对应 System Owner。

不得：

- 静默选择更容易执行的规则。
- 用较新的低层文件覆盖上位 Constitution。
- 用代码现状证明错误实现已经成为正式规则。
- 用 Roadmap 覆盖当前正式标准。

Visual System 内部冲突必须依照 `VISUAL_CONSTITUTION.md` 的 Authority 处理。

Documentation System 不降低其内部优先级。

---

# 11. Documentation Status and Product Status

Documentation Status 与 Product Status 必须分别记录。

## 11.1 Documentation Status

允许状态：

- `Official Standard`：正式生效的规范。
- `Reconstructed`：依据当前证据重建，非旧文档逐字恢复，尚未完成正式 Recovery Review。
- `Reconstructed and Reviewed`：重建文件已经过跨文档 Recovery Review；仍不表示与旧文档逐字相同。
- `Working Draft`：正在编写，尚未正式生效。
- `Deprecated`：已被正式替代，不得用于新工作。
- `Historical Reference`：只用于理解历史，不具有当前规范权威。

## 11.2 Product Status

允许状态：

- `Completed`：需求、实现、测试、验收与目标交付状态均有证据。
- `In Development`：已有实现或分支工作，但尚未满足全部完成条件。
- `Planned`：只有目标或设计，尚无可验证完整实现。

## 11.3 Prohibited Status Inference

禁止以下推断：

- Documentation `Official Standard` = 功能已完成。
- 代码文件存在 = 功能已发布。
- 测试存在 = 测试已通过。
- PR 存在 = 已合并。
- Preview 存在 = 正式版。
- Roadmap 条目存在 = 功能已实现。
- 旧文档写“Already present” = 当前仍然完整有效。

---

# 12. Documentation Update Principles

## 12.1 Correct Owner

规则必须更新在拥有该职责的 System 中。

不得把专业规则临时写入 Documentation README。

---

## 12.2 One Rule, One Source

已有正式来源时：

- 修改原来源。
- 更新引用。
- 更新受影响 Gate。

不得复制一份稍有差异的新规则。

---

## 12.3 Narrow Change

每次 Documentation Sprint 应拥有明确单一文件范围。

不得在一个 Sprint 中顺便重写多个 System。

---

## 12.4 Evidence-based Update

文档更新必须说明依据：

- Founder 决策。
- 当前产品需求。
- 正式 Review 结论。
- 代码事实。
- QA 发现。
- Release 约束。
- 法律、版权或平台要求。

不得仅因 AI 认为“更合理”而改变正式规则。

---

## 12.5 No Retroactive Completion

新增规范不得反向声称旧实现已经符合。

旧实现必须重新审核。

---

## 12.6 Dependency Update

修改上游规范后，必须检查：

- 下游 Guidelines。
- Pipeline。
- Gate。
- Checklist。
- Review Prompt。
- Code。
- Tests。
- Release Criteria。

---

# 13. Documentation and Code Synchronization

Documentation 与代码同步采用双向检查，但权责不同。

## 13.1 Before Development

开发前必须：

1. 确认正式需求来源。
2. 读取目标 System 文档。
3. 检查依赖与优先级。
4. 检查当前代码和测试。
5. 标记现状与规范的差距。
6. 明确本次变更是否需要先更新 Documentation。

## 13.2 During Development

开发中必须保持：

- 名称与正式术语一致。
- 数据模型与文档定义一致。
- 状态与生命周期一致。
- 错误与降级路径可验证。
- 新规则拥有测试或审核证据。

## 13.3 After Development

开发完成后必须检查：

- 代码是否实现文档要求。
- 测试是否覆盖关键规则。
- 文档中的实现状态是否需要更新。
- Roadmap 与任务状态是否需要更新。
- CHANGELOG 是否需要记录。
- Release Gate 是否通过。

## 13.4 Synchronization Failure

出现以下任一情况时，不得宣称完成：

- 文档要求存在但代码未实现。
- 代码新增行为但无需求或规范来源。
- 测试与正式规则不一致。
- 旧文档状态与当前代码冲突且未标记。
- 发布记录无法证明目标版本包含该变更。

代码与 Documentation 冲突时：

- 先判断代码是缺陷，还是正式需求已变更。
- 若代码是缺陷，修改代码。
- 若需求已正式变更，先更新正确文档并完成审查，再修改代码。
- 不得直接把代码现状写成新规则以消除冲突。

---

# 14. ROADMAP, TODO and CHANGELOG

三者职责不同，不得混用。

## 14.1 ROADMAP

`roadmap/ROADMAP.md` 负责：

- 产品阶段。
- 里程碑。
- 长期方向。
- 目标顺序。
- 预期结果。

ROADMAP 回答：

> Phoenix 接下来为什么向这个方向发展？

ROADMAP 不负责：

- 记录每一个即时任务。
- 证明功能已经完成。
- 代替 CHANGELOG。
- 代替正式 System Documentation。

当前 Roadmap 中存在早期阶段描述。

使用前必须与当前代码、测试和 Release 状态核对，不得直接视为最新实现清单。

## 14.2 TODO

`TODO.md` 负责：

- 当前可执行工作。
- 明确问题。
- Owner。
- 优先级。
- 阻塞条件。
- 验收条件。

TODO 回答：

> 当前具体还要做什么？

TODO 不负责：

- 定义长期产品原则。
- 记录已经发布的历史。
- 创建未经规范支持的新需求。

当前仓库未包含正式 `TODO.md`。

在正式建立前，不得虚构其内容或状态。

## 14.3 CHANGELOG

`CHANGELOG.md` 负责：

- 已交付版本的变化。
- Added、Changed、Fixed、Removed。
- 版本与日期。
- 必要的迁移或兼容影响。

CHANGELOG 回答：

> 已经正式交付了什么变化？

CHANGELOG 不负责：

- 规划未来。
- 管理待办。
- 代替 Git History。
- 证明未发布分支已经进入正式版。

当前仓库未包含正式 `CHANGELOG.md`。

在正式建立前，Release 状态必须依赖 Git、PR、CI、Deployment 与明确 Release Evidence。

---

# 15. AI Pre-development Reading Rules

任何 AI 在修改 Phoenix 前，必须执行以下规则。

## Rule One

先读取当前仓库，不依赖旧会话记忆。

---

## Rule Two

读取 Repository README 与本 Documentation README。

---

## Rule Three

读取 Core、System Architecture、Dependency、Lifecycle 与 Priority。

缺失时必须明确记录缺失，不得假装已读取。

---

## Rule Four

读取目标 System README 与全部直接适用规范。

视觉任务必须从 `docs/visual/README.md` 进入，不得直接生成图片。

---

## Rule Five

读取所有直接依赖 System 的相关规范。

例如：

- Journey Visual 必须读取 Story。
- Challenge UI 必须读取 Learning 与 UI。
- Shadowing 必须读取 Audio、Learning 与 UI。
- Release 必须读取 QA 与目标 System Gate。

---

## Rule Six

读取当前实现、测试与运行配置。

不得只读 Documentation 就推断功能状态。

---

## Rule Seven

确认当前 Branch、Commit、工作区状态与目标 Release 范围。

---

## Rule Eight

在开始修改前输出明确范围：

- 本次改什么。
- 本次不改什么。
- 依赖哪些规范。
- 如何验证。

---

## Rule Nine

任何缺少关键事实、版权状态、文化依据或上位规则的任务必须停止并请求补充。

不得自行补全关键产品决策。

---

## Rule Ten

开发完成后，AI 必须报告真实结果：

- 文件变化。
- 测试结果。
- 未验证项。
- Branch。
- Commit。
- Preview 或 Release 状态。

不得声称没有证据支持的完成状态。

---

# 16. Documentation Versioning

Phoenix Documentation 采用：

```text
Major.Minor.Patch
```

## 16.1 Major

用于：

- Constitution 重大变化。
- System Architecture 重大变化。
- System 边界重大调整。
- 与旧版本不兼容的正式规则变化。

Major 更新必须检查全部下游 System。

## 16.2 Minor

用于：

- 新增正式 Documentation。
- 新增正式能力规范。
- 新增 Pipeline、Gate、Policy 或 Checklist。
- 向后兼容的职责扩展。

## 16.3 Patch

用于：

- 术语统一。
- 拼写修复。
- 引用修复。
- 排版修复。
- 不改变正式规则的说明澄清。

## 16.4 Reconstructed Version

重建文件从 `1.0.0` 开始。

其版本表示重建后的正式维护线。

不表示它与无法恢复的旧文件逐字相同。

---

# 17. Documentation Maintenance Rules

每一份正式 Documentation 必须包含或能够明确识别：

- 标题。
- Documentation Status 或正式 Status。
- Documentation Version 或 Version。
- Priority。
- Owner。
- Purpose。
- Scope。
- Authority。
- Dependencies。
- Permanent Rule。

专项文件可以根据职责增加：

- Pipeline。
- Gate。
- Checklist。
- Review。
- Failure Rules。
- Device Rules。
- Performance Rules。
- Copyright Rules。

维护时必须：

1. 使用 Phoenix 正式术语。
2. 保持同一概念同一名称。
3. 避免跨文档复制规则。
4. 更新所有失效引用。
5. 检查上下游影响。
6. 单独提交可审查 Commit。
7. 不在未授权情况下合并 `main`。

---

# 18. Review and Conflict Resolution

Documentation Review 必须检查：

- 是否属于正确 System。
- 是否与上位规则冲突。
- 是否覆盖另一个 System 的职责。
- 是否把规划写成已完成。
- 是否把代码存在写成正式发布。
- 是否与当前代码事实明显冲突。
- 是否使用一致术语。
- 是否提供可执行读取路径。
- 是否明确失败与停止条件。
- 是否需要同步 Gate、Checklist、Tests 或 Release Criteria。

冲突处理流程：

```text
发现冲突

↓

确认文件状态与适用范围

↓

确认 System Owner

↓

应用 Documentation Priority

↓

检查当前代码与 Decision Evidence

↓

修正正确的权威来源

↓

同步下游文档、代码与测试

↓

重新审核
```

不得通过删除冲突描述但保留冲突实现的方式解决问题。

---

# 19. Relationship with Visual Documentation

Documentation System 是 Visual Documentation 的上游导航层。

它只规定：

- 什么时候进入 Visual System。
- 从哪里进入 Visual System。
- Visual 与其它 System 的边界。
- Visual 文档在全局 Documentation 中的优先关系。

Visual System 自己决定：

- Visual Constitution。
- Visual Philosophy。
- Visual Guidelines。
- Background Guidelines。
- AI Image Generation。
- Visual Pipeline。
- Visual Quality Gate。
- Visual Checklist。
- Visual Review。
- Copyright 与 Performance 的视觉要求。

因此：

任何视觉任务完成本 README 的基础读取后，必须进入：

```text
docs/visual/README.md
```

并以该文件继续专业导航。

本 README 不替代任何 Visual 文件。

---

# 20. Permanent Rule

`docs/systems/README.md` 是 Phoenix Documentation System 的总入口。

任何 Product、Story、Visual、Learning、UI、Audio、QA、Code 或 Release 工作开始之前，都必须：

1. 读取当前 Repository README。
2. 读取本 Documentation README。
3. 确认 Core 原则。
4. 确认 System Architecture、Dependency、Lifecycle 与 Priority。
5. 进入目标 System README。
6. 读取任务直接适用的正式规范。
7. 读取相邻依赖 System。
8. 核对当前代码、测试、Branch、Commit 与 Release Evidence。
9. 区分 Completed、In Development 与 Planned。
10. 通过对应 Pipeline、Gate、Checklist 与 Review。

任何缺失的关键 Documentation 都必须被明确标记。

不得用记忆、猜测、旧聊天记录、过期 Roadmap 或代码偶然行为替代正式规范。

Documentation 定义规则。

代码实现规则。

QA 验证规则。

Release 证明交付。

只有四者保持一致，Phoenix 才能长期、安全、可审查地发展。
