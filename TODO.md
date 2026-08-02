# Phoenix TODO

Documentation Status: Active

Documentation Version: 1.0.0

Last Updated: 2026-08-01

Execution Authority: Phoenix 唯一近期执行队列。

## 1. 职责与当前状态

本文件将 [`roadmap/ROADMAP.md`](roadmap/ROADMAP.md) 转化为有顺序、可审核的工作队列。ROADMAP 管阶段顺序与 Sprint 编号；本文件管可执行准备、依赖与完成证据；`CHANGELOG` 只记录已经发生的工作。

Sprint 27 已完成 Story 全量合规审查与 P0/P1 直接修复，Sprint 28 已完成 Story 深度质量修复与最终复审。Sprint 29 保持 `In Progress`：Safe Replacement Phase 0–3A 已完成 9 项全局关键资源、90 项特别 Journey 资源和 27 项普通 Journey 核心入口背景的本地原创替换；其余 271 项版权证据仍存在不可 Waive 的 P0 缺口。Sprint 30–32 保持 `Planned`。

## 2. Planned 执行队列

| 顺序 | Sprint | 状态 | 必须取得的结果 | 允许开始条件 |
|---:|---|---|---|---|
| 1 | 27 — Story 全量合规审查与 P0/P1 直接修复 | Completed | 36 个 Journey 已全量复审；普通/特别 Journey 与关联学习内容的 P0/P1 已修复并复审为零。 | 退出证据：106 条普通 Journey ReadingAnnotation 同步、WordEntry/Discovery/Challenge 输入复核、Node `340/340`、静态校验通过。 |
| 2 | 28 — Story 深度质量修复与最终复审 | Completed | 36/36 深度复审；9 个 P2 已精确修复；Story Gate、Checklist、Review 通过；P0/P1/P2/P3 清零。 | 4 个普通与 4 个特别 Journey 精确修复；6 条 ReadingAnnotation 四语同步；Node `340/340` 与静态校验通过。 |
| 3 | 29 — Visual 全量合规审查与 P0/P1 直接修复 | In Progress | 397 个有效资源已登记。Phase 0–3A 已完成 126 项安全替换；126 项新资源为 `EVIDENCE_COMPLETE`，126 项旧资源为 `RETIRED_REPLACED`。剩余 264 个 `EVIDENCE_PARTIAL`、7 个 `EVIDENCE_MISSING` 仍阻止整体 Preview/Release 资格。 | Phase 3A `Completed`；Phase 3B、3C 为 `Planned` 且需用户再次批准；版权证据 P0 全部解除后方可退出。 |
| 4 | 30 — Visual 深度质量、素材替换与性能整改 | Planned | 解决 Release 所需 P2/P3、响应式、性能、Reduced Motion、Static Fallback、失败和生命周期问题。 | Sprint 29 退出证据完整。 |
| 5 | 31 — Story–Visual 跨系统一致性审查与直接修复 | Planned | 逐 Journey 联合审查，修复 Story、Visual 或两者，并复查受影响学习/UI 接口。 | Sprint 28 与 Sprint 30 退出证据完整。 |
| 6 | 32 — Story & Visual 全量回归、Quality Gate、CI 与 Preview | Planned | 通过 Story/Visual 全量回归、Gate、设备状态、构建、自动化测试、CI 和已验证公开 Preview。 | Sprint 31 联合审核退出证据完整。 |

详细范围和不可降低的退出条件由 ROADMAP 第 4 节管理。只有获得明确执行指令且入口依赖通过时，Sprint 才能从 `Planned` 变为 `In Progress`。

## 3. Sprint 27–32 执行控制

- [x] Sprint 27 已审查全部 27 个普通 Journey、9 个特别 Journey 及其真实 Story 学习数据。
- [x] Sprint 27 已记录并复审问题等级、来源位置、受影响 Journey、规范与证据。
- [x] Sprint 27 已在真实内容源中修复全部已识别 P0/P1，没有以报告替代修复。
- [x] Sprint 27 已完成 P0/P1 清零；P2/P3 文学精修仍由 Planned Sprint 28 负责。
- [x] Sprint 27 Story 修改已同步复核生词、发现、动态挑战输入、回忆与盖章流程。
- [x] Sprint 28 已完成 36/36 深度文学复审、故事库差异性与文化真实性复查。
- [x] Sprint 28 已修复 9 个 P2；最终 P0/P1/P2/P3 均为零，没有以降级或改规则伪造通过。
- [x] Sprint 28 已同步 6 条 ReadingAnnotation 的中文、拼音、英文与越南语，并复核全部学习流程接口。
- [x] Sprint 28 Story Quality Gate、Checklist、Review、Node `340/340` 与静态内容校验通过；本地 Flutter/Dart 不可用，结果以远端 CI 为准。
- [ ] Visual 修改同步版权记录、响应式版本、性能证据、Reduced Motion、Static Fallback 和失败恢复。（已完成资产登记、特别 Journey 预载/静态后备/最终降级与生命周期检查点；版权证据恢复未完成。）
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

本次更新后 Sprint 27–28 为 `Completed`，Sprint 29 为 `In Progress`，Sprint 30–32 保持 `Planned`。项目当前不存在权威 CHANGELOG 文件，因此没有创建第二套变更记录；真实变更证据保留在 Commit、PR、本文件与 ROADMAP。
