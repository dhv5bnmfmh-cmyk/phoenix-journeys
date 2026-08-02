# Phoenix Roadmap

Documentation Status: Active

Documentation Version: 1.0.0

Last Updated: 2026-08-01

Planning Authority: Phoenix 唯一长期开发规划。

## 1. 规划职责

本文件管理 Phoenix 的阶段顺序、Sprint 编号、依赖和完成边界。根目录 [`TODO.md`](../TODO.md) 将近期阶段转化为执行队列；`CHANGELOG` 只记录已经发生且有证据的变更，不负责安排未来工作。

Roadmap 状态不是实现证据。只有在所需文档、代码或内容修改、审核证据、Commit 及阶段退出条件真实存在时，Sprint 才能标记为 `Completed`。`Planned` 不代表功能已经实现。

## 2. 当前基线

| 范围 | 状态 | 证据边界 |
|---|---|---|
| Story System v1.0 Documentation | Completed and Reviewed | Story 规范已成为权威标准；不代表全部运行时故事已合规。 |
| Visual System v1.0 Documentation | Completed and Reviewed | Final Decision：`VISUAL_SYSTEM_V1_APPROVED`；不代表全部运行时视觉已合规。 |
| Story 与 Visual 软件合规整改 | In Progress | Sprint 27–28 已完成 Story 合规整改与深度质量封版；Sprint 29 为 `In Progress`，Sprint 30–32 保持 `Planned`。 |
| Learning System | Planned | 仅可在 Sprint 32 完成后开始。 |
| UI/UX System | Planned | 依赖 Learning System 完成。 |
| Audio System | Planned | 依赖 UI/UX System 完成。 |

## 3. Documentation 与 Development 顺序

| Sprint | 阶段 | 状态 | 前置依赖 |
|---|---|---|---|
| 01–12 | Story System Documentation and Review | Completed | 当前 Documentation Recovery 与 Review 记录构成有效基线。 |
| 13–26 | Visual System Documentation and v1.0 Review | Completed | Systems Documentation 与 Story System 接口。 |
| 27–32 | Story & Visual Conformance and Remediation Phase | In Progress | Sprint 27–28 已完成；Sprint 29 为 `In Progress`，Sprint 30–32 保持 `Planned`。 |
| 33–46 | Learning System | Planned | Sprint 32 具备真实回归证据并完成。 |
| 47–60 | UI/UX System | Planned | Learning System 阶段完成。 |
| 61–74 | Audio System | Planned | UI/UX System 阶段完成。 |
| 75 起 | 后续 Phoenix 阶段 | Unscheduled | 开始前必须获得 Sprint 74 之后的唯一编号。 |

上述区间连续且互斥。后续计划不得复用 Sprint 27–74，也不得在必需的上游阶段退出前启动下游阶段。

## 4. Story & Visual Conformance and Remediation Phase

本阶段使用已封版的 Story System v1.0 和 Visual System v1.0 审查 Phoenix 的真实代码、真实页面、真实内容、真实数据和真实资源。这是产品合规整改，不是再次审核规范文件。审查发现不合规时，责任 Sprint 必须修复真实对象及受影响接口；只输出报告不能完成 Sprint。

### Sprint 27 — Story 全量合规审查与 P0/P1 直接修复

Status: Completed

范围：全部普通 Journey、特别 Journey、故事、短文、角色、故事标题与文案，以及关联生词、发现页、挑战题、留下印象、盖章文案和 Story 与学习流程关联数据。

必须执行：

- 按 Story Constitution、Story Philosophy、Story Pipeline、Story Decision Tree 和 Story Checklist 审查真实内容。
- 在真实内容源中直接修复全部已发现 P0/P1；问题清单本身不是交付物。
- 故事修改后同步检查并修正生词、发现、挑战、留下印象和盖章内容。
- 保留问题、修复、受影响 Journey 与回归结果之间的可追踪证据。

退出条件：审查范围内已识别 Story P0/P1 全部修复并复审。不得用未分级或仅报告的结果进入 Sprint 28。

完成证据（2026-08-01）：27 个普通 Journey 与 9 个特别 Journey 已全量复审；普通 Journey 已完成独立人物叙事整改，特别 Journey 已移除共享幻想扩展并修复三个无后果结尾。106 条普通 Journey ReadingAnnotation、WordEntry、Discovery 与动态 Challenge 输入已同步复核；Story P0/P1 复审结果均为零。Node 回归 `340/340` 通过，`git diff --check` 与本地静态内容校验通过；本地环境未提供 Flutter/Dart SDK，Flutter 结果以远端 CI 状态为准。

### Sprint 28 — Story 深度质量修复与最终复审

Status: Completed

范围：P2/P3、AI 腔、流水账、人物模板化、相似开场或结尾、重复冲突或情绪曲线、城市差异不足、特别 Journey 文学性不足、文化真实性、HSK/TOCFL 难度、故事库重复率及 Story 与学习内容不一致。

必须执行：

- 修复真实内容和全部受影响学习接口。
- 执行故事库级重复率与独立出版质量审核，不得只逐篇孤立通过。
- 修复后重跑受影响的 Story Quality Gate、Story Checklist、Story Review 与页面级 QA。

退出条件：Story Quality Gate、Story Checklist、Story Review 全部通过；P0/P1/P2 清零；P3 不得累积为故事库整体质量或出版风险。

完成证据（2026-08-01）：36 个 Journey 已完成逐篇深度文学复审与故事库级差异性复查。审核识别并修复 9 个 P2：4 个普通 Journey 的说明式结尾，以及 4 个特别 Journey 中 5 处说理、元叙事或模板化表达；未大幅重写 Story。6 条受影响 ReadingAnnotation 已同步中文、拼音、英文与越南语，WordEntry、Discovery、动态 Challenge、Memory、Impression 与 Stamp 保持一致。最终 P0/P1/P2/P3 均为零；Node 回归 `340/340`、静态内容校验与 `git diff --check` 通过。本地环境未提供 Flutter/Dart SDK，Flutter 结果以本 Sprint 远端 CI 为准。

### Sprint 29 — Visual 全量合规审查与 P0/P1 直接修复

Status: In Progress

范围：全部静态和动态背景、Journey 图片、首页、世界地图、城市地图、护照、故事页、生词页、发现页、挑战页、留下印象页、盖章页、特别 Journey 入口、Banner、Loading、Splash、UI 插画、Icon 及手机和平板视觉状态。

必须执行：

- 按 Visual System v1.0 审查真实软件和真实资源。
- 检查画质、有效层次、AI 错误、文化真实性、版权、性能、动画、响应式表现及真实页面使用。
- 对 P0/P1 直接修复范围内代码或配置，或替换失败资源；不得只写审核报告。
- 每个替换资源必须保留生成、版权、资产、Gate 和设备证据。

退出条件：审查范围内已识别 Visual P0/P1 全部修复或替换并复审；版权不明或存在严重 AI 错误的资源不得保留 Preview 或 Release 资格。

进行中证据（2026-08-02）：已枚举并登记 397 个有效视觉资源，技术预载、失败降级、Reduced Motion 与生命周期修复保持有效。Safe Replacement Phase 0 已建立唯一命名、稳定 Asset ID、可编辑源文件、权利证据包与 14 项 Gate 流程；Phase 1 已替换 9 项全局关键运行时资源；Phase 2 已以本地确定性流程替换 90 项特别 Journey 资源；Phase 3A 已为 27 个普通 Journey 建立独立城市生活场景矩阵，并完成 27 项核心入口背景的原创 SVG/WebP 替换。Phase 0–3A 累计 126 项新资源为 `EVIDENCE_COMPLETE`，126 项旧资源为 `RETIRED_REPLACED`；当前仍有 264 项 `EVIDENCE_PARTIAL`、7 项 `EVIDENCE_MISSING`，合计 271 项保持 `BLOCKED_PENDING_EVIDENCE`。Phase 3B 与 Phase 3C 为 `Planned`，未经用户再次批准不得开始。Sprint 29 在剩余权利证据 P0 阻断解除前不得标记为 Completed；Sprint 30–32 保持 Planned。

### Sprint 30 — Visual 深度质量、素材替换与性能整改

Status: Planned

范围：P2/P3；缺少有效前景、中景、远景；低清、模糊或拉伸；塑料感；廉价粒子；循环明显；闪烁、眩晕或掉帧；Journey 视觉重复；文字与按钮安全区；手机和平板裁切；AVIF/WebP；响应式图片；弱网络；低性能设备；`prefers-reduced-motion`；Static Fallback；加载失败回退；页面返回恢复。

必须执行：

- 修复或替换真实资源及其接入，再重跑受影响 Gate、Checklist、Review、性能、无障碍和页面级 QA。
- 动态效果不自然时必须退回高清静态背景，不得为了保留动画降低正式版质量。
- 以证据验证响应式交付、资源生命周期、性能预算、失败处理与设备降级。

退出条件：Release 所需 P2 风险已解决，P3 累积不降低系统质量，且不存在性能、Reduced Motion、Static Fallback、版权、无障碍或设备阻断项。

### Sprint 31 — Story–Visual 跨系统一致性审查与直接修复

Status: Planned

逐个 Journey 检查地点、时间、天气、人物、服装、建筑、文化、情绪、主色与故事氛围、关键道具是否一致；特别 Journey 是否尊重原典；视觉是否加入故事中不存在的内容或提前泄露挑战答案；Story 修改后 Visual 是否同步；Visual 修改后受影响学习内容是否同步。

对每个不一致项，根据系统权威和来源证据决定修改 Story、Visual 或两者，并直接实施修复。随后重跑受影响的 Story、Visual、Learning 接口、UI、无障碍、性能和页面级检查。不得保留互相矛盾的 Story 与 Visual 状态。

退出条件：每个范围内 Journey 都有可追踪联合审核证据，P0/P1/P2 跨系统矛盾清零。

### Sprint 32 — Story & Visual 全量回归、Quality Gate、CI 与 Preview

Status: Planned

必须完成：

- Story Quality Gate、Story Checklist、Story Review、Visual Quality Gate、Visual Checklist、Visual Review 和 Story–Visual 一致性检查。
- 普通 Journey 与特别 Journey 回归。
- 手机、平板、支持的不同屏幕比例、弱网络、低性能设备、Reduced Motion、Static Fallback、图片加载失败及页面返回恢复。
- 自动朗读与动态背景并行。
- 免费、付费、锁定和解锁状态。
- 构建、自动化测试、CI、公开 Preview，以及有真实证据的最终合规报告。

退出条件：存在真实整改 Commit 和 PR 变更，所需 CI 通过，公开 Preview 已验证，全部不可 Waive Gate 通过，最终报告链接证据。没有真实 Commit、PR、CI 和 Preview，不得声称 Story & Visual 软件整改完成。

## 5. 永久整改规则

1. 审查真实代码、页面、内容和资源；只审核规范文件不充分。
2. 发现不合规后修复真实来源，不得停在报告。
3. P0/P1 优先于较低等级问题。
4. 不得修改 Checklist 或报告来伪造通过。
5. 故事修改必须同步关联学习内容和状态接口。
6. 视觉修改必须同步设备、性能、版权、无障碍和降级方案。
7. Story 与 Visual 必须联合审核后才能完成本阶段。
8. 动态不自然时退回高清静态背景。
9. 版权不明资源必须删除或替换。
10. 严重 AI 错误资源必须重新生成或替换。
11. 所有新视觉素材必须原创或有可验证的 Phoenix 商业使用授权。
12. Sprint 32 必须提供真实公开 Preview。
13. 只有用户明确指令可以授权合并 `main`。
14. 完成必须由真实实现证据支持，状态文字不能替代证据。

## 6. 依赖与 Gate 顺序

`Story P0/P1 → Story 深度质量 → Visual P0/P1 → Visual 深度质量与性能 → Story–Visual 联合合规 → 全量回归/Gate/CI/Preview → Learning System`

下游发现问题可以将工作返回责任上游范围。这是整改反馈环，不是循环权威依赖：Story 管叙事事实，Visual 管视觉实现，Learning 管学习接口，Systems Documentation 管跨系统优先级与生命周期。

Sprint 32 完成前不得开始 Sprint 33。Learning、UI/UX 和 Audio 均保持 `Planned`，在各自证据形成前不得声称已封版或完成。

## 7. 产品版本方向

以下内容保留自既有 Roadmap，用于表达产品演进方向；它不覆盖 Sprint 顺序，也不证明实现状态。

### v0.1 — Founder Prototype

- Explore / Passport / Me
- Forbidden City Journey
- Local memory storage
- Basic word explanations

### v0.2 — Founder Experience

- Adaptive story difficulty
- Simplified / Traditional conversion
- Translation-language settings
- Tap-to-explain throughout Story
- AI feedback for Wonder and Express
- Original vocabulary illustrations
- Automatic learning timeline
- Beijing map correction

### v0.3 — Alpha

- Supabase account and cloud sync
- Real AI API integration
- Content-source records
- Audio pronunciation
- 10 Beijing Journeys
- Feedback status tracking

### v0.5 — Closed Beta

- 50 Explorers
- Analytics with privacy protection
- Accessibility review
- Performance and offline reading

### v1.0 — Public Launch

- iOS and Android release
- Chinese Journey library
- Explorer Pass
- Production privacy, moderation and content review

## 8. 规划变更控制

- Sprint 编号调整必须在同一规划变更中同步本文件与根目录 `TODO.md`。
- 一个 Sprint 编号只属于一个阶段，不得复用。
- Audio System 之后的新工作从 Sprint 75 开始，除非先明确修订本 Roadmap。
- 调整顺序必须记录依赖理由，不能静默绕过上游 Gate。
- `Completed`、`In Progress` 与 `Planned` 必须严格区分；Sprint 27–28 为 `Completed`，Sprint 29 为 `In Progress`，Sprint 30–32 保持 `Planned`。
- 只有真实完成并具备证据的实现事实才能写入 `CHANGELOG`。
