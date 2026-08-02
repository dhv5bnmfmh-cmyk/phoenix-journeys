# Phoenix Visual Safe Replacement Protocol

Documentation Status: Active
Documentation Version: 1.0.0
Owner: Phoenix Visual Architecture
Scope: Sprint 29 Safe Replacement Phase 0

本文件是 `docs/visual/` 权威规范的执行协议，不替代 Visual System、Copyright Policy 或 `design/ASSET_REGISTER.csv`。

## Naming

发布资源使用：`phoenix-<page-or-journey>-<purpose>-<state-or-variant>-<breakpoint>-v<version>.<format>`。

- 页面或 Journey、用途、状态/变体、尺寸或断点、版本、格式必须明确。
- 禁止 `final-final`、`new`、`latest`、`test`、`copy`、`temp` 和未定义缩写。
- 可编辑母版与发布文件使用相同语义主干；母版位于 `design/sources/`。

## Stable Asset ID

格式：`PHX-<FAMILY>-<PURPOSE>-<NNN>`。ID 由产品语义分配，不依赖哈希、文件名、临时路径或生成批次。

## Rights Evidence Package

每项新资源必须在 `design/evidence/` 保存一份记录，并在唯一权威登记表 `design/ASSET_REGISTER.csv` 中引用。字段必须覆盖：Asset ID、路径、家族、运行时页面、Creator、日期、Creation Method、Tool/Version、Source File、Editable Master、Prompt 或人工设计记录、Seed、Input Asset 与权利、Commercial Use Basis、Terms Evidence、Modification/Redistribution Rights、Attribution、Trademark/Likeness/Cultural Review、SHA-256、Git Blob SHA、响应式版本、静态后备、Reduced Motion、Reviewer/Date、Gate Result、Preview/Release Eligibility。

不适用字段写 `NOT_APPLICABLE`；无法证明字段写 `UNKNOWN`。任何 `UNKNOWN` 均不能通过 Rights Gate。

## Source and Release

- 必须保存可编辑 SVG、可重复执行脚本、参数、设计说明和使用说明。
- 发布文件必须关联母版，拥有独立 SHA-256 与 Git Blob SHA，通过压缩、解码、响应式、降级和运行时引用校验。
- SVG 禁止脚本、外部引用、嵌入字体、第三方路径或远程资源。

## Replacement Sequence

`创建新资源 → 权利证据 → Quality Gate → Story–Visual → 响应式 → 性能 → 测试 → 代码切换 → 远端验证 → 旧资源停止引用 → 旧资源退役`。

新资源全部 Gate 通过前不得删除旧资源。旧资源退役后在 Asset Register 保留历史行并标记 `RETIRED_REPLACED`。

## Required Gates

Rights Evidence、Originality、Trademark、Likeness/Privacy、Cultural Accuracy、Visual Quality、Story–Visual、Responsive、Accessibility、Reduced Motion、Static Fallback、Performance、Runtime Integration、Test。不可 Waive 项失败时不得切换运行时。

## Phase 1 Creation Boundary

Phase 1 只允许本地程序化 SVG、由这些 SVG 离线导出的 WebP，以及 Flutter/CSS 原生运动。禁止外部图片、地图瓦片、地图 API、外部字体图标、外部 Lottie、外部生成或分析服务。
