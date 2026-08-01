# Phoenix TODO

Documentation Status: Active

Documentation Version: 1.0.0

Last Updated: 2026-08-01

Execution Authority: Phoenix 唯一近期执行队列。

## 1. 职责与当前状态

本文件将 [`roadmap/ROADMAP.md`](roadmap/ROADMAP.md) 转化为有顺序、可审核的工作队列。ROADMAP 管阶段顺序与 Sprint 编号；本文件管可执行准备、依赖与完成证据；`CHANGELOG` 只记录已经发生的工作。

当前没有整改 Sprint 处于活动状态。Sprint 27–32 全部为 `Planned`。本次规划更新不启动 Sprint 27，也不声称当前软件已经符合 Story System v1.0 或 Visual System v1.0。

## 2. Planned 执行队列

| 顺序 | Sprint | 状态 | 必须取得的结果 | 允许开始条件 |
|---:|---|---|---|---|
| 1 | 27 — Story 全量合规审查与 P0/P1 直接修复 | Planned | 审查全部真实 Story 范围；修复并复审全部已发现 P0/P1 及受影响学习内容。 | Story System v1.0 基线可用，且 Sprint 27 获得明确执行指令。 |
| 2 | 28 — Story 深度质量修复与最终复审 | Planned | 修复 P2 与累积 P3；Story Gate、Checklist、Review 通过；P0/P1/P2 清零。 | Sprint 27 退出证据完整。 |
| 3 | 29 — Visual 全量合规审查与 P0/P1 直接修复 | Planned | 审查真实页面和资源；修复或替换全部 Visual P0/P1，包括版权和 AI 阻断项。 | Sprint 28 退出证据建立当前 Story 基线。 |
| 4 | 30 — Visual 深度质量、素材替换与性能整改 | Planned | 解决 Release 所需 P2/P3、响应式、性能、Reduced Motion、Static Fallback、失败和生命周期问题。 | Sprint 29 退出证据完整。 |
| 5 | 31 — Story–Visual 跨系统一致性审查与直接修复 | Planned | 逐 Journey 联合审查，修复 Story、Visual 或两者，并复查受影响学习/UI 接口。 | Sprint 28 与 Sprint 30 退出证据完整。 |
| 6 | 32 — Story & Visual 全量回归、Quality Gate、CI 与 Preview | Planned | 通过 Story/Visual 全量回归、Gate、设备状态、构建、自动化测试、CI 和已验证公开 Preview。 | Sprint 31 联合审核退出证据完整。 |

详细范围和不可降低的退出条件由 ROADMAP 第 4 节管理。只有获得明确执行指令且入口依赖通过时，Sprint 才能从 `Planned` 变为 `In Progress`。

## 3. Sprint 27–32 执行控制

- [ ] 审查当前 Sprint 范围内的真实代码、页面、内容、数据和资源。
- [ ] 每个问题记录等级、来源位置、受影响 Journey/页面、违反规范和证据。
- [ ] 修复真实来源中的每个范围内失败项，不得以报告替代修复。
- [ ] P0/P1 优先于 P2/P3；按权威 Gate 阻断 Preview 或 Release。
- [ ] Story 修改同步生词、发现、挑战、留下印象、盖章及其他受影响学习数据。
- [ ] Visual 修改同步版权记录、响应式版本、性能证据、Reduced Motion、Static Fallback 和失败恢复。
- [ ] 修复后重跑全部受影响 Gate、Checklist、Review 和页面级 QA。
- [ ] 保留 Commit、PR、测试、CI、设备与 Review 证据；状态文字不能证明完成。
- [ ] 动态不自然时使用高清静态视觉，不得降低 Release 标准来保留动画。
- [ ] 拒绝版权不明资源，重新生成或替换存在严重 AI 错误的资源。
- [ ] 未经用户明确授权不得合并 `main`。

以上项目在对应 Sprint 开始后强制执行。当前未勾选表示“尚未执行”，不表示失败，也不表示完成。

## 4. Sprint 退出证据

| Sprint | 完成前最低证据 |
|---|---|
| 27 | 全量 Story 清单、问题和直接修复链接、学习内容同步、P0/P1 复审结果。 |
| 28 | Story Quality Gate、Story Checklist、Story Review、故事库重复与难度/文化证据、P0/P1/P2 为零。 |
| 29 | 全量 Visual 清单、资源/页面问题、替换或修复记录、版权和 AI 错误证据、P0/P1 复审结果。 |
| 30 | 质量与性能整改、响应式资源、设备/弱网测试、Reduced Motion、Static Fallback 和生命周期恢复证据。 |
| 31 | 逐 Journey Story–Visual 矩阵、不一致项权威判断、直接修复及跨系统复审。 |
| 32 | 通过的 Gate/Checklist/Review、回归矩阵、构建和自动化测试、CI、真实 Commit/PR、已验证公开 Preview、最终合规报告。 |

没有真实 Commit、PR、CI 和 Preview 证据，Sprint 32 不得完成。`APPROVED_FOR_PREVIEW` 不等于 `APPROVED_FOR_RELEASE`。

## 5. 后续 Planned 阶段

| Sprint | 阶段 | 状态 | 入口依赖 |
|---|---|---|---|
| 33–46 | Learning System | Planned | Sprint 32 完成。 |
| 47–60 | UI/UX System | Planned | Learning System 阶段完成。 |
| 61–74 | Audio System | Planned | UI/UX System 阶段完成。 |

以上阶段均未开始。详细任务拆分必须保持 ROADMAP 中的编号区间和依赖顺序。后续 Sprint 从 75 或更高编号开始，除非先修订权威 ROADMAP。

## 6. 状态规则

- `Planned`：顺序和范围已确定，但执行尚未开始。
- `In Progress`：获得明确授权后，正在修改真实项目来源。
- `Blocked`：入口依赖或不可 Waive 要求阻止继续。
- `Completed`：全部退出条件和证据已存在并通过审核。

本次更新后 Sprint 27–32 必须保持 `Planned`。不得通过改状态伪造进度，也不得在工作真实发生前把计划移入 `CHANGELOG`。
