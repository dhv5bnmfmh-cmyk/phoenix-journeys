# Phoenix Image Quality Gate

Documentation Status: Active
Documentation Version: 1.0.0
Priority: ★★★★★ (Mandatory Visual Quality Gate)
Owner: Phoenix Visual Architecture

---

# 1. Purpose

Phoenix Image Quality Gate（简称 Image Quality Gate）是所有图片、背景和视觉资源进入 Phoenix 正式视觉库、真实页面与正式版之前必须通过的统一质量门。

本文件负责：

- 用统一 Gate 判断 Visual Candidate 是否达到 Phoenix 正式质量。
- 识别不可被评分、Waiver、排期或实现状态覆盖的阻断问题。
- 规定每个 Gate 的输入、方法、证据、Owner、失败回退和重新审核。
- 规定画质、AI Error、文化、版权、阅读、学习、动态、设备、性能、无障碍、导入和页面级 QA 的最低条件。
- 产生可供 `VISUAL_CHECKLIST`、`VISUAL_REVIEW_PROMPT` 与 Release System 使用的版本化 Gate Record。

本文件不负责：

- 选择视觉路径；路径由 `VISUAL_DECISION_TREE.md` 决定。
- 生产或导入资产；生产和导入由 `VISUAL_PIPELINE.md` 执行。
- 改写 Story、Learning、UI、Audio、Animation、Code、QA 或 Release 规则。
- 用总分替代专业判断。
- 用单独查看图片替代真实页面 QA。
- 自动证明代码中的现有视觉已经合格。

Image Quality Gate PASS 不等于 Checklist PASS、Visual Review PASS、Page-level QA PASS、PR 已合并或正式版已发布。

---

# 2. Authority and Required Reading

审核前必须读取：

1. 当前用户明确指令与安全、法律、平台边界。
2. `docs/systems/README.md`。
3. `docs/systems/SYSTEM_ARCHITECTURE.md`。
4. `docs/systems/SYSTEM_DEPENDENCY.md`。
5. `docs/systems/SYSTEM_LIFECYCLE.md`。
6. `docs/systems/SYSTEM_PRIORITY.md`。
7. 目标 Journey 的 Approved Story Contract 与适用 Story Documentation。
8. `docs/visual/README.md`。
9. `docs/visual/VISUAL_CONSTITUTION.md`。
10. `docs/visual/VISUAL_PHILOSOPHY.md`。
11. `docs/visual/VISUAL_GUIDELINES.md`。
12. `docs/visual/BACKGROUND_GUIDELINES.md`（背景适用时）。
13. `docs/visual/AI_IMAGE_GENERATION_GUIDE.md`（AI 生成适用时）。
14. `docs/visual/VISUAL_DECISION_TREE.md`。
15. `docs/visual/VISUAL_PIPELINE.md`。
16. 真实存在且适用的 UI、Learning、Audio、Animation、Accessibility、Performance、QA 与 Release 规范。

本 Gate 低于 Constitution、Philosophy、Guidelines 与 Decision Tree 的专业权威，但高于 Checklist 与 Review Prompt 的质量判定。Checklist 和 Review Prompt 不得降低本 Gate。

---

# 3. Scope

本 Gate 适用于：

- 普通 Journey。
- 特别 Journey。
- 故事背景。
- 动态背景。
- 静态背景。
- 首页视觉。
- 世界地图。
- 城市地图。
- 护照。
- 生词页。
- 发现页。
- 挑战页。
- 留下印象页。
- 盖章页。
- Banner。
- Loading。
- Splash。
- UI 插画。
- Icon。
- 人物视觉。
- 建筑视觉。
- 文化场景。
- AI 原创图片。
- 程序化视觉资源。
- 动态视觉资源。
- 其他进入 Phoenix 的视觉内容。

新建、替换、实质修改、重新压缩、重新裁切、重新分层、改变动画、改变格式或改变页面引用的资源，都必须重新执行受影响 Gate。

---

# 4. Candidate Identity and Evidence Chain

每次审核必须锁定：

- Candidate ID。
- Asset ID 与 Asset Version。
- Journey ID、Story ID 与 Story Version（适用时）。
- Page、State 与 Consumer。
- Branch、Commit、Build 与 Environment。
- Master Hash 与每个 Runtime Variant Hash。
- Gate Specification Version。

版本不一致时不得拼接 Evidence。

任何 Master、Runtime Asset、Static Fallback、Reduced Motion Variant 或页面 Build 改变后，依赖该对象的旧 Gate PASS 自动失效。

---

# 5. Unified Gate Status

| Status | Meaning | May continue downstream? |
| --- | --- | --- |
| `NOT_STARTED` | 尚未进入审核或没有审核输入 | 否 |
| `IN_REVIEW` | 审核正在进行，结果未锁定 | 否 |
| `BLOCKED` | 必要资料、权威、版权、文化、设备、Build 或 Evidence 不可确认 | 否 |
| `FAILED` | 已确认不满足通过条件 | 否 |
| `CONDITIONAL_PASS` | 仅存在非阻断、可关闭的有限 Finding，已指定 Owner 与期限 | 只允许进入修正或后续非发布 Review；不得导入或发布 |
| `PASSED` | 全部适用强制条件满足，Evidence 完整 | 是，仍须继续后续 Gate |
| `WAIVED` | 非阻断项由有权批准人限时接受风险 | 仅在本文件允许范围内；不得用于阻断项 |

## 5.1 Status Transition

```text
NOT_STARTED
→ IN_REVIEW
→ PASSED / CONDITIONAL_PASS / FAILED / BLOCKED

CONDITIONAL_PASS
→ IN_REVIEW
→ PASSED / FAILED / WAIVED

WAIVED
→ 到期或资产变化
→ IN_REVIEW
```

`BLOCKED` 解除后必须回到 `IN_REVIEW`，不能直接变为 `PASSED`。

`FAILED` 修正后必须产生新 Candidate Revision，并重新进入 `IN_REVIEW`。

## 5.2 Waiver Rules

WAIVED 只能用于非阻断项，且必须记录：

- Waiver ID。
- 精确 Gate 与 Finding。
- 原因。
- 风险与受影响用户。
- 批准人及其权限。
- 生效版本。
- 有效期限或撤销条件。
- 补偿控制。
- 后续修复计划、Owner 与验证方式。

Waiver 到期、资产变化或风险扩大时立即失效。

以下永远不得 Waive：

- 版权、商业使用、商标、肖像或来源阻断。
- Blocker/Critical AI Error。
- 文化误导、严重历史错误、宗教或传统符号误用。
- 阅读、按钮、导航、朗读、字幕、Challenge 或学习流程不可用。
- 闪烁、眩晕与运动安全风险。
- 无静态降级、Reduced Motion 或关键失败回退。
- 严重性能、内存、GPU、掉帧或页面功能破坏。
- 页面级 QA 阻断缺陷。
- Candidate、Commit、Build 或 Evidence 版本不一致。

---

# 6. Review Roles and Separation

| Role | Authority |
| --- | --- |
| Gate Owner | 管理 Gate Record、顺序、状态与最终签署，不替代专业 Reviewer |
| Visual Reviewer | 画质、构图、层次、光影、色彩、Phoenix 风格与跨资源一致性 |
| Story Owner | Story、人物、情绪、时间、天气与 Journey Meaning |
| Cultural Reviewer | 城市、建筑、服装、器物、历史、原典、宗教与文化含义 |
| Copyright Reviewer | 来源、许可、商业使用、品牌、角色、肖像与生成输入 |
| UI/UX Reviewer | 布局、文字、按钮、导航、热点、字幕和页面状态 |
| Learning Reviewer | Story、生词、发现、挑战、留下印象与盖章流程 |
| Audio Reviewer | 朗读、字幕、播放状态与视觉干扰 |
| Animation Reviewer | 动作、循环、自然度、暂停与恢复 |
| Accessibility Reviewer | 对比、非颜色唯一表达、闪烁、眩晕、替代文本与 Reduced Motion |
| Performance Reviewer | 格式、尺寸、加载、解码、内存、GPU、帧率、缓存与降级 |
| QA Owner | 真实页面、设备、状态、网络与回归验证 |
| Release Owner | 汇总同一 Candidate 的全部 PASS Evidence；不降低 Gate |

资产生成者不得成为唯一最终审核者。AI 可以辅助检查，但不得独立批准自身生成或修复的 Candidate。

---

# 7. Non-compensable Blocker Catalog

以下 40 条阻断规则具有唯一 ID。任一命中时：

1. 当前 Gate 为 `BLOCKED` 或 `FAILED`。
2. 总分不得计算为正式通过。
3. `CONDITIONAL_PASS` 与 `WAIVED` 均不可用。
4. 禁止导入、正式页面启用与 Release。

| Blocker ID | Blocking condition | Required return |
| --- | --- | --- |
| `BLOCK-001` | 需求、页面、Journey、Story Version 或用途不明确 | Pipeline Stage 01–03 |
| `BLOCK-002` | 必要 Documentation、Owner 或上游 Contract 缺失/冲突 | Pipeline Stage 02 / System Owner |
| `BLOCK-003` | 来源未知或来源记录不可追踪 | Pipeline Stage 04/13；必要时 Reject |
| `BLOCK-004` | 商业使用、修改、再分发或模型/工具许可无法确认 | Pipeline Stage 13；禁止导入 |
| `BLOCK-005` | 明显复制电影、游戏、动漫、出版物、摄影构图或其他作品 | Reject Candidate |
| `BLOCK-006` | 未授权品牌、Logo、商标、角色、公众人物或肖像 | Remove/Reject Candidate |
| `BLOCK-007` | 模仿具体艺术家的独特风格 | Pipeline Stage 09；重新设计 Prompt |
| `BLOCK-008` | 使用无法确认授权的网络素材、纹理、字体、Icon 或参考输入 | Reject/Replace Source |
| `BLOCK-009` | Master/Runtime 文件损坏、缺失区域或无法打开 | Pipeline Stage 10/18 |
| `BLOCK-010` | 目标显示中严重模糊、拉伸、压缩色块、锯齿、色带或错误透明边缘 | Pipeline Stage 10/17/18 |
| `BLOCK-011` | Blocker 级人体、建筑、透视、文字、光影或物理错误 | Pipeline Stage 09–10；重新生成 |
| `BLOCK-012` | Critical AI Error 未修复 | Pipeline Stage 09–11 |
| `BLOCK-013` | 通过遮罩、模糊、暗化或裁切隐藏 Blocker/Critical Error | Reject Current Revision |
| `BLOCK-014` | 构图导致主体、文字、按钮或关键 Story 信息无法同时成立 | Pipeline Stage 06–07 |
| `BLOCK-015` | 光源、阴影或反射体系根本冲突，破坏可信度或阅读 | Pipeline Stage 05–06/09–10 |
| `BLOCK-016` | Visual 与 Approved Story、时间、天气、人物、场景或 Journey 类型矛盾 | Pipeline Stage 03/05/14 |
| `BLOCK-017` | 文化、历史、建筑、服装、器物、地区或朝代严重错误 | Pipeline Stage 04–12 |
| `BLOCK-018` | 特别 Journey 违背原典核心精神或误导传统来源 | Story Owner / Pipeline Stage 04–05 |
| `BLOCK-019` | 宗教、民族、民俗、仪式或传统符号误用 | Pipeline Stage 04–12 |
| `BLOCK-020` | 文化含义无法确认但 Candidate 继续生成或拟导入 | Block and return Research |
| `BLOCK-021` | 标题、正文、生词、字幕或必要信息不可读 | Pipeline Stage 06–07 |
| `BLOCK-022` | 按钮、导航、Challenge 选项、热点或点击判断不可用 | Pipeline Stage 07/23 |
| `BLOCK-023` | 朗读、播放、暂停、字幕或 Audio 状态被视觉阻断 | Pipeline Stage 07/16/24 |
| `BLOCK-024` | 视觉破坏 Story→生词→发现→挑战→留下印象→盖章流程 | Corresponding System / Pipeline Stage 03/07/24 |
| `BLOCK-025` | 动画闪烁或超出安全频率风险 | Pipeline Stage 08/16；使用静态 |
| `BLOCK-026` | 动画引发眩晕、镜头乱晃或强缩放风险 | Pipeline Stage 08/16；使用静态 |
| `BLOCK-027` | 动态不自然、明显循环、掉帧或廉价效果仍被保留 | Pipeline Stage 08/16；高清静态替代 |
| `BLOCK-028` | 动态无暂停、离页不停、返回不恢复或状态失控 | Pipeline Stage 16/23/24 |
| `BLOCK-029` | 缺少同版本高清静态降级或 `prefers-reduced-motion` 路径 | Pipeline Stage 19 |
| `BLOCK-030` | 手机或平板关键设备/比例尚未验证 | Pipeline Stage 17 |
| `BLOCK-031` | 主体、文字、按钮或层次在批准设备中错误裁切/遮挡 | Pipeline Stage 06/07/17 |
| `BLOCK-032` | 严重文件体积、加载、解码、内存、GPU、热量或帧率问题 | Pipeline Stage 18 |
| `BLOCK-033` | 弱网、低内存或低性能设备无可用降级 | Pipeline Stage 18–19 |
| `BLOCK-034` | 视觉只靠颜色表达功能状态或低视力用户无法理解 | Accessibility / Pipeline Stage 07/24 |
| `BLOCK-035` | 功能性图片无语义/替代文本且信息无法由其他方式获得 | Accessibility / Import Stage |
| `BLOCK-036` | 导入文件名、目录、Metadata、资源映射或 Hash 错误 | Pipeline Stage 23 |
| `BLOCK-037` | 旧资源仍被错误引用、Fallback 版本错配或缓存加载旧资产 | Pipeline Stage 23–24 |
| `BLOCK-038` | 页面级 QA 未执行、目标 Build/Commit 不一致或存在功能破坏 | Pipeline Stage 24 |
| `BLOCK-039` | `IMAGE_QUALITY_GATE`、`VISUAL_CHECKLIST` 或 `VISUAL_REVIEW_PROMPT` 缺失/失败 | Corresponding Gate/Review Stage |
| `BLOCK-040` | Evidence 被拼接、伪造、过期或无法关联同一 Candidate | Return earliest affected Gate |

---

# 8. Standard Gate Record

每个 Gate 必须记录以下 12 个字段：

| Required field | Requirement |
| --- | --- |
| Gate 目标 | 该 Gate 保护的产品结果 |
| 适用范围 | 哪些 Candidate 必须执行，哪些条件允许 N/A |
| 检查输入 | 审核使用的同版本 Artifact 与 Evidence |
| 检查方法 | 可重复的人工、工具、设备或页面步骤 |
| 通过条件 | 可验证的全部 PASS 条件 |
| 失败条件 | 可修正但不满足正式标准的情况 |
| 阻断条件 | 对应 Blocker ID 和不可继续条件 |
| 证据要求 | 必须保存的文件、截图、记录、Hash 或测量 |
| 负责人 | Gate Owner 与专业 Reviewer |
| 失败返回路径 | `VISUAL_PIPELINE.md` 的最早根因 Stage |
| 重新审核要求 | 哪些改变使旧 PASS 失效，必须重跑哪些 Gate |
| 状态记录方式 | Gate ID、Status、Finding、Reviewer、Date、Version 与 Evidence URI |

以下 Gate 章节均按此结构执行。

---

# 9. Gate 0 — Data and Requirement Completeness

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证审核从完整需求、页面、Journey、Story、文化、安全区、设备和来源信息开始。 |
| 适用范围 | 全部视觉 Candidate，无 N/A。 |
| 检查输入 | Requirement Record、Documentation Reading Record、Story/Page/Journey Analysis、Safe-area Contract、Static/Motion Decision、Source/Generation Record。 |
| 检查方法 | 逐项核对页面/Journey 名称、Story 主题、情绪、时间、天气、文化、文字/按钮安全区、手机/平板、静态/动态目标、来源和生成方式。 |
| 通过条件 | 所有输入明确、版本一致、Owner 可识别，无未解决 Missing Authority。 |
| 失败条件 | 非关键 Metadata 不完整，但能够回到明确 Owner 修正。 |
| 阻断条件 | `BLOCK-001`、`BLOCK-002`、`BLOCK-040`。资料不足禁止进入 Gate 1。 |
| 证据要求 | Requirement、Reading Record、Candidate/Asset/Journey/Story Version、Owner、Branch/Commit、Input Index。 |
| 负责人 | Gate Owner、Requirement Owner、Visual Architect。 |
| 失败返回路径 | Pipeline Stage 01 Requirement、Stage 02 Documentation 或 Stage 03 Analysis。 |
| 重新审核要求 | Requirement、Story、Page、Journey、Device Scope 或 Source Method 变化后重跑 Gate 0 及全部下游 Gate。 |
| 状态记录方式 | `GATE-00` + 统一 Status + Missing Item/Owner/Return Stage + Evidence URI。 |

---

# 10. Gate 1 — Originality and Copyright

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 证明最终资源原创、来源可追踪且可用于 Phoenix 商业产品。 |
| 适用范围 | 全部视觉资源、程序化代码输出、Prompt 输入、参考、字体、Icon、纹理、视频与后期元素。 |
| 检查输入 | Prompt/Design Record、Source Register、License、工具/模型条款、第三方清单、最终 Candidate 与 Metadata。 |
| 检查方法 | 追踪每个元素；核对商业使用、修改、再分发、商标、肖像、品牌、角色、艺术家模仿与作品复制；检查网络素材授权。 |
| 通过条件 | 所有元素来源、许可证和商业使用明确；无复制、模仿、未授权品牌/角色或版权不明内容。 |
| 失败条件 | 可替换的非阻断来源记录格式问题；修正前不得 PASS。 |
| 阻断条件 | `BLOCK-003`–`BLOCK-008`。任一命中立即失败，禁止导入 Phoenix。 |
| 证据要求 | Source ID、URL/Provider、Access Date、License Copy、Terms Version、Prompt、Generation Method、Copyright Reviewer Decision。 |
| 负责人 | Copyright Reviewer；必要时法律/产品授权 Owner。 |
| 失败返回路径 | Pipeline Stage 04、09、10 或 13；无法补证时 Reject Candidate。 |
| 重新审核要求 | Prompt、输入参考、模型/工具、后期元素、字体、Icon、Logo 或授权条款变化时重跑 Gate 1 及 Gate 17。 |
| 状态记录方式 | `GATE-01` + Source/License Matrix + Status + Reviewer + Date + Evidence URI。 |

---

# 11. Gate 2 — Image Quality and Technical Integrity

## 11.1 Minimum Resolution Standard

以下为 Gate 审核最低像素，不代表运行时必须加载 Master：

| Use | Minimum approved master/review output | Minimum runtime delivery target |
| --- | --- | --- |
| 全屏/首屏背景 | 长边 ≥ 3840 px、短边 ≥ 2160 px；竖向母版同等像素密度 | Mobile ≥ 1440 × 2560；Tablet ≥ 2048 × 2732；Desktop reserve ≥ 2560 × 1440 |
| Story/Journey 页面背景 | 长边 ≥ 3840 px、短边 ≥ 2160 px，并保留多比例裁切空间 | 目标设备物理显示尺寸的 ≥ 1.5×；高 DPI 优先 2× |
| Banner | ≥ 2400 × 960，且文本安全区不依赖烧入文字 | 最大显示尺寸的 ≥ 2× |
| 卡片插画 | ≥ 1600 × 1200 或对应比例等效像素 | 最大显示尺寸的 ≥ 2× |
| 方形缩略图/Passport/Map Node | ≥ 1200 × 1200 | 最大显示尺寸的 ≥ 2×，不得低于 512 × 512 |
| UI Illustration | ≥ 1600 px 长边；透明边缘需原始 Alpha | 最大显示尺寸的 ≥ 2× |
| Icon | SVG 优先；位图 Master ≥ 256 × 256 | 必须覆盖 1×/2×/3×，最小目标尺寸仍清晰 |
| 动画图层 | 与最终合成 Master 同像素密度，边缘有运动/裁切补偿 | 不得因分层降低目标设备清晰度 |
| Static Fallback/Poster | 不低于对应静态背景或视频显示标准 | 与动态显示区域同等清晰度 |

桌面是当前预留范围时，必须验证可扩展构图；若当前 Release Scope 正式支持桌面，则 Desktop 输出从预留变为强制 Runtime Variant。

## 11.2 Compression Standard

允许压缩必须同时满足：

- 100% 尺寸、目标显示尺寸与高 DPI 设备看不到结构性损失。
- 不产生色块、色带、边缘光晕、文字/线条污染、纹理糊化或透明边缘杂色。
- 与 Master 对比不改变主色、暗部层次、文化细节或 Journey Identity。
- 质量损失不能用锐化、噪点或滤镜掩盖。

## 11.3 Gate Record

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证 Master 与 Runtime Variant 在所有目标显示中清晰、完整、未损坏且裁切合理。 |
| 适用范围 | 全部位图、矢量、视频帧、程序化截图、动画图层与 Fallback。 |
| 检查输入 | Master、Runtime Variants、尺寸/格式/压缩记录、Hash、目标设备与 Crop Map。 |
| 检查方法 | 原始尺寸、100%、目标尺寸、高 DPI、Retina、手机/平板/桌面范围逐项比较；检查模糊、拉伸、压缩色块、锯齿、锐化、拼接、色带、Alpha、破损和裁切。 |
| 通过条件 | 满足分辨率表；所有目标设备清晰；无可见技术缺陷；裁切保持主体、层次和安全区。 |
| 失败条件 | 可重新导出/压缩/裁切修正的质量问题。 |
| 阻断条件 | `BLOCK-009`、`BLOCK-010`、`BLOCK-031`。严重画质问题不得发布。 |
| 证据要求 | Original/Runtime Dimension、DPI、Format、Compression Setting、File Size、Hash、100% Crop、Device Screenshot。 |
| 负责人 | Visual Reviewer、Performance Reviewer、QA Owner。 |
| 失败返回路径 | Pipeline Stage 10、17 或 18；构图根因返回 Stage 06。 |
| 重新审核要求 | 重新导出、压缩、裁切、格式、尺寸、Alpha 或图层变化后重跑 Gate 2、11、12、14、15。 |
| 状态记录方式 | `GATE-02` + Variant Matrix + Defect Severity + Status + Evidence URI。 |

不允许发布：低分辨率放大、截图充当 Master、明显模糊/拉伸、压缩色块、锯齿、色带、错误透明边缘、破损、过锐化、明显拼接或关键裁切失败。

---

# 12. Gate 3 — AI Error

## 12.1 Severity Model

| Severity | Definition | Required decision |
| --- | --- | --- |
| `Blocker` | 根本人体/建筑/文字/文化/权利/透视/物理错误，或掩盖错误行为 | 必须重新生成；禁止局部掩盖、导入与 Waiver |
| `Critical` | 清晰可见并严重破坏可信度、构图、Story、文化、阅读或正式品质 | 必须修复或重新生成；未关闭不得继续 |
| `Major` | 范围有限但在目标尺寸可见，影响完整性、一致性或专业品质 | 修复后重新进入 Gate 3 与受影响 Gate |
| `Minor` | 不影响结构、文化、Story、权利、安全区和正式体验的微小 Finding | 仅在不影响正式品质时记录理由；可 `CONDITIONAL_PASS`，Gate 17 前必须关闭或合法 Waive |

## 12.2 Gate Record

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 消除人物、建筑、物体、文字、透视、光影、纹理、物理与明显生成痕迹。 |
| 适用范围 | 所有 AI 生成、AI 修复、AI 放大或含 AI 图层的资源；非 AI 程序化资源仍检查相同可见错误。 |
| 检查输入 | 原始分辨率 Candidate、Prompt、Master、图层、目标裁切、AI Error Report。 |
| 检查方法 | 全图→四角→主体→面部/手指/肢体/服装/比例→建筑→透视→重复/漂浮物→反射→光源/阴影→纹理/塑料感→文字/乱码/牌匾/符号→时代/地区→物理→AI 痕迹。 |
| 通过条件 | Blocker/Critical/Major 为零；Minor 已关闭或符合严格记录条件。 |
| 失败条件 | 存在任何未关闭 Major/Minor，或审核范围不完整。 |
| 阻断条件 | `BLOCK-011`–`BLOCK-013` 以及由 AI Error 触发的 `BLOCK-017`–`BLOCK-020`。 |
| 证据要求 | 100% Annotated Review、Severity、Location、Prompt Version、Before/After、Reviewer、Decision。 |
| 负责人 | Independent Visual Reviewer；人物/建筑/文化问题由对应专业 Reviewer 复核。 |
| 失败返回路径 | Pipeline Stage 09–11；根本构图返回 Stage 06，文化返回 Stage 04。 |
| 重新审核要求 | 任何像素、Prompt、AI 修复、放大、裁切或遮罩变化后重跑 Gate 2–8 及 Gate 17。 |
| 状态记录方式 | `GATE-03` + Finding ID + Severity + Disposition + Status + Evidence URI。 |

不得通过遮罩、模糊、暗化、裁切、缩小、加噪或滤镜隐藏 Blocker/Critical Error。

---

# 13. Gate 4 — Composition and Spatial Depth

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证主视觉、空间、层次、动线、重心、留白和裁切服务 Story 与阅读。 |
| 适用范围 | 全部背景、插画、地图、Banner、Splash、Loading、人物/建筑场景；Icon 仅适用重心、留白与裁切。 |
| 检查输入 | Composition Plan、Layer Map、Master、Device Crops、Safe-area Contract。 |
| 检查方法 | 检查主视觉、前/中/远景、景深、视觉动线、重心、呼吸感、留白、拥挤、主体裁切和多比例完整性；验证层次是否有真实职责。 |
| 通过条件 | 主视觉清楚；空间可信；层次与电影式构图服务 Story；不同裁切仍完整；无为了凑层次加入的无意义元素。 |
| 失败条件 | 动线混乱、重心不稳、留白不足、层次机械、局部拥挤或可修裁切问题。 |
| 阻断条件 | `BLOCK-014`、`BLOCK-031`。构图使内容和交互无法成立时直接失败。 |
| 证据要求 | Composition Overlay、Layer Map、Focal-flow、各比例 Crop、Reviewer Notes。 |
| 负责人 | Visual Architect / Visual Reviewer；UI Reviewer 验证安全区。 |
| 失败返回路径 | Pipeline Stage 05–07；多比例问题返回 Stage 17。 |
| 重新审核要求 | 主体、镜头、地平线、图层、裁切、安全区或比例变化后重跑 Gate 4、8、11、16、17。 |
| 状态记录方式 | `GATE-04` + Composition Finding + Device Scope + Status + Evidence URI。 |

“高级感、层次感和电影感”必须来自真实空间、克制光影、呼吸和稳定视线，不得来自无意义元素、滤镜或复杂特效。

---

# 14. Gate 5 — Lighting and Color

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 建立可信、克制、自然且服务 Journey、Story 和阅读的光影与色彩。 |
| 适用范围 | 全部彩色/灰阶视觉、动态与静态 Variant、Light/Dark 环境。 |
| 检查输入 | Lighting/Color Brief、Master、Device Capture、Story Time/Weather/Emotion、Journey Palette。 |
| 检查方法 | 核对主光源、方向、阴影、反射、色温、主/辅/强调色、情绪、饱和、灰脏、塑料光泽、局部亮度、夜景暗部、明暗层次和设备显示。 |
| 通过条件 | 主光清楚且物理一致；色温/颜色符合 Journey 和情绪；夜景保留暗部；文字区域稳定；跨设备无显著漂移。 |
| 失败条件 | 可修正的曝光、白平衡、局部亮度、饱和或色彩一致性问题。 |
| 阻断条件 | `BLOCK-015`、`BLOCK-021`；光影与 Story 时间/天气矛盾时同时命中 `BLOCK-016`。 |
| 证据要求 | Light Map、Histogram/Color Comparison、Device Screenshots、Night Detail Crop、Reviewer Decision。 |
| 负责人 | Visual Reviewer；Story Owner 验证时间/情绪，UI Reviewer 验证阅读。 |
| 失败返回路径 | Pipeline Stage 05–06；生成错误返回 Stage 09–10，设备色彩返回 Stage 17–18。 |
| 重新审核要求 | 曝光、色温、调色、遮罩、格式或压缩变化后重跑 Gate 2、5、8、11。 |
| 状态记录方式 | `GATE-05` + Lighting/Color Findings + Status + Evidence URI。 |

廉价滤镜、统一青橙、紫黑雾、金棕古城、过饱和或整体压暗不得替代真实光影设计。

---

# 15. Gate 6 — Story and Journey Consistency

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证视觉忠实表达 Approved Story 和独立 Journey Identity。 |
| 适用范围 | Journey、Story、页面背景、地图/护照、人物、文化场景及跨页面资产；无 Journey 的全局资源验证 Page/Product Contract。 |
| 检查输入 | Approved Story Contract、Journey Metadata、Visual Direction、Candidate、同 Journey 页面组与 Visual Library。 |
| 检查方法 | 核对主题、人物、场景、情绪曲线、时间、天气、Journey 类型、文本关系、跨 Journey 相似度、城市/时代/文化元素和记忆锚点。 |
| 通过条件 | 无 Story 矛盾；普通/特别定位正确；具有可识别独立身份；同 Journey 连续、跨 Journey 不模板化；帮助记忆而不取代 Story。 |
| 失败条件 | 情绪、色彩、细节或跨页面一致性可修；不得以换色掩盖重复。 |
| 阻断条件 | `BLOCK-016`；严重文化错配同时触发 `BLOCK-017`–`BLOCK-020`。 |
| 证据要求 | Story-to-Visual Matrix、Journey Library Comparison、Version Match、Cross-page Captures。 |
| 负责人 | Story Owner、Visual Architect、Learning Reviewer。 |
| 失败返回路径 | Pipeline Stage 03、05、06 或 14；Story 本身问题交 Story Owner。 |
| 重新审核要求 | Story/Journey Version、人物、场景、情绪、时间、天气、构图或 Palette 变化后重跑 Gate 4–9、16、17。 |
| 状态记录方式 | `GATE-06` + Story/Journey Version + Similarity Findings + Status + Evidence URI。 |

白昼/夜晚矛盾、地点/建筑错误、情绪完全冲突、多个 Journey 近似构图色彩或只有装饰无 Story 关联，均不得 PASS。

---

# 16. Gate 7 — Cultural and Historical Authenticity

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 防止城市、建筑、服装、器物、历史、原典、宗教与传统文化被错误或刻板表达。 |
| 适用范围 | 所有含真实地点、时代、人物、建筑、食物、器物、符号、宗教/民俗或传统来源的资源。 |
| 检查输入 | Cultural Research Evidence、Source Record、Story Contract、Candidate、Fact/Interpretation Boundary。 |
| 检查方法 | 核对城市、建筑、服装、食物、器物、符号、朝代、地区；特别 Journey 核对神话/志怪/传奇/民间文学和原典精神；检查刻板印象、宗教/传统误用和艺术改编边界。 |
| 通过条件 | 关键文化含义有可靠 Evidence；无错误混搭和误导；艺术化改编保留核心意义；Cultural Reviewer PASS。 |
| 失败条件 | 可修正的非核心细节偏差；修正前不得 PASS。 |
| 阻断条件 | `BLOCK-017`–`BLOCK-020`。无法确认文化含义时 Gate 失败。 |
| 证据要求 | Source Claim Matrix、Annotated Cultural Review、Original Spirit Record、Reviewer Credentials/Role、Decision。 |
| 负责人 | Cultural Reviewer；Story Owner 验证原典与 Story 边界。 |
| 失败返回路径 | Pipeline Stage 04 Cultural Research、Stage 05 Direction 或 Stage 09–10 Regeneration。 |
| 重新审核要求 | 任何文化元素、人物服饰、建筑、器物、符号、时代或来源变化后重跑 Gate 3、6、7、16、17。 |
| 状态记录方式 | `GATE-07` + Source IDs + Cultural Findings + Status + Evidence URI。 |

---

# 17. Gate 8 — Reading and Interaction Safety

## 17.1 Required Correction Order

背景导致文字或交互不清晰时必须依次处理：

1. 优化构图。
2. 调整真实光影。
3. 调整局部细节与纹理密度。
4. 调整裁切。
5. 增加自然留白或暗部。
6. 最后才使用轻量、局部、可解释遮罩。

大面积黑色、厚重、模糊或高不透明遮罩不得用于掩盖失败构图。

## 17.2 Gate Record

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证标题、正文、卡片、按钮、导航、选项、字幕、朗读和系统安全区在所有状态可读可操作。 |
| 适用范围 | 所有页面视觉、背景、Banner、Loading、Splash、地图、护照、功能性插画与动态。 |
| 检查输入 | Safe-area Contract、UI State Matrix、Locale、Font Scale、Device Crops、Static/Motion Candidate。 |
| 检查方法 | 检查标题、正文、生词卡片、按钮、导航、Challenge 选项、字幕、刘海/系统区、多语言长度、动态路径、点击判断和遮罩依赖；按修正顺序验证。 |
| 通过条件 | 全部目标设备、语言、字体和状态清晰；动态不穿过关键区；点击判断可靠；不依赖厚重遮罩。 |
| 失败条件 | 可通过前五级修正解决的局部对比、细节或裁切问题。 |
| 阻断条件 | `BLOCK-014`、`BLOCK-021`–`BLOCK-023`、`BLOCK-031`。 |
| 证据要求 | Safe-area Overlay、State/Locale/Font Matrix、Device Captures、Contrast Evidence、Interaction Recording。 |
| 负责人 | UI/UX Reviewer、Visual Reviewer、Audio Reviewer、Accessibility Reviewer。 |
| 失败返回路径 | Pipeline Stage 06–07、17；动态问题返回 Stage 08/16。 |
| 重新审核要求 | UI Layout、文字、Locale、Font、Crop、Motion、Mask 或页面状态变化后重跑 Gate 8、9、11、13、15。 |
| 状态记录方式 | `GATE-08` + Page/State/Device Matrix + Status + Evidence URI。 |

---

# 18. Gate 9 — Learning Experience

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证视觉服务语言学习，不增加无意义认知负担或替代学习内容。 |
| 适用范围 | Story、生词、发现、挑战、留下印象、盖章及其入口、朗读/字幕和完成反馈。 |
| 检查输入 | Learning Flow Contract、Story Version、Page State Matrix、Candidate、Audio/Subtitle Contract。 |
| 检查方法 | 验证 Story 阅读、生词理解、发现探索、Challenge 答题、留下印象、盖章反馈、朗读/字幕、注意力和记忆锚点；检查视觉是否暗示答案或以奖励取代内容。 |
| 通过条件 | 流程全部可完成；视觉降低而非增加负担；Memory Anchor 来自 Story；视觉不取代语言学习。 |
| 失败条件 | 非阻断但可测量的认知干扰或视觉优先级偏差。 |
| 阻断条件 | `BLOCK-024`，以及引发不可读/不可操作的 `BLOCK-021`–`BLOCK-023`。 |
| 证据要求 | Flow Recording、Page State Evidence、Learning Reviewer Notes、Story/Asset Version Match。 |
| 负责人 | Learning Reviewer、Story Owner、UI/UX Reviewer、Audio Reviewer。 |
| 失败返回路径 | Pipeline Stage 03、05、07 或 24；业务规则问题返回 Learning/UI/Audio Owner。 |
| 重新审核要求 | 页面视觉、Story、Learning State、Challenge、Memory、Stamp、Audio 或字幕变化后重跑 Gate 6、8、9、15、17。 |
| 状态记录方式 | `GATE-09` + Flow/State + Status + Finding + Evidence URI。 |

视觉再华丽，只要破坏学习流程，Gate 9 即失败。

---

# 19. Gate 10 — Motion Quality

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 只允许自然、克制、可暂停、可恢复、可降级且不影响阅读和交互的动态。 |
| 适用范围 | 动态背景、动画、视频、SVG/CSS/Canvas/WebGL/程序化运动；纯静态资源记录 `N/A — Static`，仍须验证 Fallback 条件不适用理由。 |
| 检查输入 | Motion Intent、动态 Candidate、Static Fallback、Reduced Motion Variant、Frame/Loop/State Evidence。 |
| 检查方法 | 检查氛围价值、自然度、物理方向、速度、循环接缝、闪烁、镜头晃动/缩放、粒子、漂浮、阅读/按钮、眩晕、暂停、离页停止、返回恢复、`prefers-reduced-motion` 与静态降级。 |
| 通过条件 | 动态确有价值；自然低权重；无接缝/闪烁/眩晕/掉帧；状态正确；Reduced Motion 与高清静态有效。 |
| 失败条件 | 动态价值不足、速度/幅度/循环可修但尚未满足；未修正前不得 PASS。 |
| 阻断条件 | `BLOCK-025`–`BLOCK-029`。任何运动安全风险直接失败。 |
| 证据要求 | Full-loop Recording、Frame-time Data、Pause/Leave/Return Test、Reduced Motion Capture、Static Hash。 |
| 负责人 | Animation Reviewer、Accessibility Reviewer、Performance Reviewer、UI/UX Reviewer。 |
| 失败返回路径 | Pipeline Stage 08/16；不自然时必须选择 Stage 19 高清静态方案。 |
| 重新审核要求 | 动作、速度、周期、图层、触发、暂停、恢复、Fallback 或运行代码变化后重跑 Gate 8、10–13、15。 |
| 状态记录方式 | `GATE-10` + Motion/Static Decision + Metrics + Status + Evidence URI。 |

不得为了“有动画”保留低质量动画。动态不自然时必须退回高清静态背景。

---

# 20. Gate 11 — Device and Responsive Adaptation

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证小/标准/大屏手机、平板、方向、比例、DPI、系统安全区和字体变化中的完整体验。 |
| 适用范围 | 全部 Runtime Asset；桌面为当前预留，若 Release Scope 支持桌面则变为强制。 |
| 检查输入 | Device Matrix、Responsive Variants、Crop Map、Safe-area Contract、DPI/Font/Theme Config、Motion/Fallback。 |
| 检查方法 | 小屏手机、标准手机、大屏手机、Tablet Portrait/Landscape、Desktop Reserve、宽高比、高 DPI、刘海/安全区、旋转、缩放、文字放大和深浅显示逐项检查。 |
| 通过条件 | 主体无错误裁切；安全区有效；按钮可用；层次成立；动态稳定；静态回退可用；所有要求设备有 Evidence。 |
| 失败条件 | 单一 Variant 可修的裁切、比例、缩放或 Theme 差异。 |
| 阻断条件 | `BLOCK-030`、`BLOCK-031`；动态掉帧同时触发 `BLOCK-027/032`。 |
| 证据要求 | Device/OS/Browser/Orientation/DPI/Font/Theme Matrix、Screenshots/Recordings、Variant Hash。 |
| 负责人 | QA Owner、UI/UX Reviewer、Visual Reviewer、Accessibility Reviewer。 |
| 失败返回路径 | Pipeline Stage 06–07、17；Master 不足返回 Stage 10，动态问题返回 Stage 16。 |
| 重新审核要求 | Crop、Variant、Layout、DPI、Font、Theme、Orientation 或设备范围变化后重跑 Gate 2、4、8、10–13、15。 |
| 状态记录方式 | `GATE-11` + Device Matrix + Per-device Status + Evidence URI。 |

---

# 21. Gate 12 — Performance

## 21.1 Default Performance Budgets

若平台已有更严格批准预算，以更严格者为准。没有专项预算时使用：

| Resource | Default maximum transfer size |
| --- | --- |
| 首屏关键静态视觉（单个） | 500 KB；首屏全部视觉总量 1 MB |
| 非首屏全屏静态背景（单个 Device Variant） | 800 KB |
| Banner / Card Illustration | 220 KB |
| Thumbnail / Map Node / Passport Marker | 120 KB |
| Raster Icon | 32 KB；SVG 应保持必要节点与最小可读结构 |
| Short-loop Video | 2.5 MB，且必须有 Poster、暂停、弱网与静态回退 |

动态目标：支持目标刷新率时优先稳定 60 fps；审核设备上的 p95 不低于 55 fps，且不得持续出现超过 50 ms 的长帧。若设备能力不足，必须自动或明确切换低性能/静态模式。

## 21.2 Gate Record

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 使格式、尺寸、加载、解码、内存、GPU、帧率、缓存和降级符合真实设备与网络预算。 |
| 适用范围 | 全部 Runtime Asset、动画、视频、程序化效果、Static Fallback 与缓存版本。 |
| 检查输入 | AVIF/WebP/PNG/SVG/Video Variants、Size/Format Record、Network/Memory/GPU/Frame Data、Cache/Loading Contract。 |
| 检查方法 | 检查格式、响应式尺寸、首屏预加载、非首屏懒加载、体积、透明 PNG、无意义分辨率、GPU、内存增长、帧率、离页释放、弱网回退、低性能降级、缓存、切换闪屏和失败占位。 |
| 通过条件 | 满足批准预算；无持续内存增长/GPU 过载/明显掉帧；加载与切换稳定；弱网、低性能、失败路径可用。 |
| 失败条件 | 可通过编码、尺寸、加载、缓存或图层优化解决的预算超限。 |
| 阻断条件 | `BLOCK-032`、`BLOCK-033`；严重问题禁止进入正式版。 |
| 证据要求 | File-size Report、Network Trace、Decode/Memory/GPU/Frame Metrics、Cache/Release Test、Weak-network/Low-device Recording。 |
| 负责人 | Performance Reviewer、Developer、QA Owner；Visual Architect 验证品质未被破坏。 |
| 失败返回路径 | Pipeline Stage 18；形式过重返回 Decision Tree Form/Motion Path 和 Pipeline Stage 08/16。 |
| 重新审核要求 | 文件、格式、尺寸、编码、加载、缓存、动画、代码或依赖变化后重跑 Gate 2、10–12、14–15、17。 |
| 状态记录方式 | `GATE-12` + Budget/Actual + Device/Network + Status + Evidence URI。 |

性能不合格禁止进入正式版。

---

# 22. Gate 13 — Accessibility and Comfort

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证视觉对低视力、运动敏感和使用辅助技术的用户可读、可理解、可控制。 |
| 适用范围 | 全部功能性/内容图片、页面视觉、动态、状态、Icon 与交互反馈。 |
| 检查输入 | Contrast Evidence、Semantic/Alt-text Map、State Matrix、Reduced Motion、High-contrast Capture、Motion Risk Test。 |
| 检查方法 | 检查文字对比、非颜色唯一表达、动画减少、闪烁、眩晕、疲劳、低视力、高对比兼容、替代文本、功能图片语义、暂停和降级。 |
| 通过条件 | 关键内容与状态可感知；无闪烁/眩晕风险；动态可暂停/降级；功能图片语义完整；高对比与低视力条件可用。 |
| 失败条件 | 可修正的 Alt Text、语义、对比或非阻断舒适性 Finding。 |
| 阻断条件 | `BLOCK-025`、`BLOCK-026`、`BLOCK-029`、`BLOCK-034`、`BLOCK-035`。眩晕或闪烁风险直接失败。 |
| 证据要求 | Contrast Measurement、High-contrast/Low-vision Capture、Semantic Tree、Alt-text Review、Reduced Motion/Keyboard/Screen-reader Evidence（适用时）。 |
| 负责人 | Accessibility Reviewer、UI/UX Reviewer、Animation Reviewer、QA Owner。 |
| 失败返回路径 | Pipeline Stage 07、08、16、19、23 或 24。 |
| 重新审核要求 | 颜色、文字、状态、Icon、语义、Alt Text、Motion 或 Fallback 变化后重跑 Gate 8、10–13、15。 |
| 状态记录方式 | `GATE-13` + Accessibility Finding + User Impact + Status + Evidence URI。 |

---

# 23. Gate 14 — Asset Import Integrity

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证批准资源以正确名称、目录、版本、Metadata、Fallback 和引用进入 Phoenix。 |
| 适用范围 | 全部拟导入或已导入 Runtime Asset、程序化资源、映射、缓存与 Archive。 |
| 检查输入 | Import Manifest、File Tree、Asset/Variant Hash、Metadata、Copyright/Generation Record、Responsive/Fallback Map、Target Commit。 |
| 检查方法 | 检查命名、目录、引用、备用资源、静态回退、Metadata、版权/生成/尺寸记录、响应式映射、缓存版本、未使用资源、旧引用、失败处理和返回恢复。 |
| 通过条件 | Manifest 与文件/代码一致；只引用 Approved Runtime Asset；Fallback/Mapping/Cache 正确；旧资源不再运行；状态可恢复。 |
| 失败条件 | 可修正的命名、Metadata、清理或非阻断映射问题。 |
| 阻断条件 | `BLOCK-036`、`BLOCK-037`、`BLOCK-040`。 |
| 证据要求 | Import Manifest、Tree/Reference Diff、Hash Matrix、Metadata Record、Fallback/Failure Test、Rollback Map。 |
| 负责人 | Asset Integrator/Developer、Visual Architect、Code/UI Owner。 |
| 失败返回路径 | Pipeline Stage 23；资产变化返回对应 Stage 10–22。 |
| 重新审核要求 | 文件、路径、引用、Hash、Metadata、Cache、Fallback 或旧资源清理变化后重跑 Gate 14–17。 |
| 状态记录方式 | `GATE-14` + Commit + Manifest Version + Status + Evidence URI。 |

素材生成完成不等于导入完成。必须在真实页面验证。

---

# 24. Gate 15 — Page-level QA

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 在真实 Phoenix Build 中验证视觉与页面、Audio、Interaction、Learning、Network、Device 和状态共同成立。 |
| 适用范围 | 全部已导入资源；仅独立 Library Asset 不得以 N/A 跳过未来 Consumer Page QA。 |
| 检查输入 | Target Commit/Build、Imported Asset、Page/State/Device/Network Matrix、Gate 0–14 Evidence。 |
| 检查方法 | 验证首次进入、返回、刷新、切换、音频播放、自动朗读、字幕、按钮、滚动、旋转、弱网、加载失败、Reduced Motion、低性能、免费/付费、普通/特别 Journey 与不同解锁状态。 |
| 通过条件 | 全部批准页面、状态、设备、网络和用户路径 PASS；无视觉引发功能破坏；Build/Commit/Asset Version 一致。 |
| 失败条件 | 可复现但非阻断的视觉回归；修复前不得最终 PASS。 |
| 阻断条件 | `BLOCK-021`–`BLOCK-024`、`BLOCK-027`–`BLOCK-038` 中适用项。不得只看图片判定完成。 |
| 证据要求 | Build/Commit、Page URL/Route、Device Matrix、Screenshots/Recordings、Logs、Network/Failure Evidence、Defect Disposition。 |
| 负责人 | QA Owner；Visual/UI/Learning/Audio/Animation/Accessibility/Performance Owner 按缺陷归属修正。 |
| 失败返回路径 | 集成问题 Pipeline Stage 23；资源问题返回最早根因 Stage；业务问题返回对应 Professional System。 |
| 重新审核要求 | Asset、Import、Page、State、Audio、Learning、Device、Network、Code 或 Build 变化后重跑受影响测试和 Gate 15–17。 |
| 状态记录方式 | `GATE-15` + Build/Commit + Test Matrix + Status + Evidence URI。 |

---

# 25. Gate 16 — Cross-resource Consistency

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 保证 Candidate 与 Phoenix Visual System、Story/Learning/UI、Journey Library 和同页面组件形成一致视觉语言。 |
| 适用范围 | 全部资源，必须与当前目标 Visual Library 和同页面资产比较。 |
| 检查输入 | Candidate、Visual Library、Visual Constitution/Philosophy/Guidelines、Story/Learning/UI Contract、Cross-page Captures。 |
| 检查方法 | 检查 Constitution、Philosophy、Style Guide（真实存在时）、Story、Learning、UI、Journey Library、页面色彩/层次/动效、风格突变、组件冲突和背景相似度。 |
| 通过条件 | 属于 Phoenix；同 Journey 连续；跨 Journey 独特；页面组件协调；无风格突变和多个高度相似背景。 |
| 失败条件 | 可修正的色彩、层次、细节、动效语言或局部组件冲突。 |
| 阻断条件 | 违反 Constitution/Story/Learning/UI 基础边界，或跨资源冲突导致 `BLOCK-014`、`BLOCK-016`、`BLOCK-021`–`BLOCK-024`。 |
| 证据要求 | Library Comparison Grid、Cross-page Capture、Similarity Findings、System Owner Decision。 |
| 负责人 | Visual Architect；Story、Learning、UI Owner 复核各自接口。 |
| 失败返回路径 | Pipeline Stage 05、06、14、15 或 23；不得要求 Story 配合已有视觉。 |
| 重新审核要求 | Library、Candidate、Palette、Component、Page、Motion 或 Style Direction 变化后重跑 Gate 4–9、16、17。 |
| 状态记录方式 | `GATE-16` + Comparison Scope + Findings + Status + Evidence URI。 |

---

# 26. Gate 17 — Final Release Review

## 26.1 Scoring Model

总分固定为 100 分：

| Dimension | Weight | Full-score requirement |
| --- | ---: | --- |
| 原创与版权 | 8 | Gate 1 PASSED；必须 8/8，零容忍 |
| 画质 | 7 | Gate 2 PASSED，无目标设备可见技术缺陷 |
| AI 错误 | 8 | Gate 3 PASSED；Blocker/Critical/Major 为零，必须 8/8 |
| 构图 | 5 | 主视觉、动线、重心、留白和裁切完整 |
| 层次 | 4 | 前中远景/等效空间职责自然，不机械堆叠 |
| 光影 | 5 | 主光、阴影、反射、暗部与阅读可信 |
| 色彩 | 4 | Journey、情绪、色温、饱和与设备显示一致 |
| Journey 一致性 | 8 | Story/Journey/Version 一致且身份独立 |
| 文化真实性 | 9 | Gate 7 PASSED；无误导，必须 9/9 |
| 阅读体验 | 8 | Gate 8 PASSED；文字与操作全部可用，必须 8/8 |
| 学习体验 | 6 | Gate 9 PASSED；学习流程完整 |
| 动态质量 | 4 | 动态适用时自然安全；静态资源的 Motion N/A 与降级决定正确；必须 4/4 |
| 响应式适配 | 5 | Gate 11 PASSED；全部目标设备 PASS |
| 性能 | 5 | Gate 12 PASSED；必须 5/5 |
| 无障碍 | 5 | Gate 13 PASSED；必须 5/5 |
| 页面级 QA | 5 | Gate 15 PASSED；必须 5/5 |
| 跨资源一致性 | 4 | Gate 16 PASSED，无风格突变或冲突 |
| **Total** | **100** | **正式通过最低 95/100** |

## 26.2 Non-compensation Rule

以下维度必须满分，任何失分直接阻止正式通过：

- 原创与版权：8/8。
- AI 错误：8/8。
- 文化真实性：9/9。
- 阅读体验：8/8。
- 动态质量：4/4。
- 性能：5/5。
- 无障碍：5/5。
- 页面级 QA：5/5。

所有 `BLOCK-001`–`BLOCK-040` 必须为未命中或已通过新 Revision 关闭。

95 分只是必要条件，不是充分条件。

即使总分 100，只要存在任一 Blocker、Gate 不是最终可接受状态、Evidence 不一致或强制满分维度未满，结果仍为 `FAILED/BLOCKED`。

## 26.3 Final Decision

| Decision | Conditions | Downstream action |
| --- | --- | --- |
| `CONDITIONAL_PASS` | 总分可达到 ≥95，但只剩非阻断 Minor Finding，已有 Owner/期限；不得命中 Blocker | 只允许修正与复审，不得导入/发布 |
| `FORMAL_PASS` | Gate 0–16 全部适用项 `PASSED` 或合法未到期非阻断 `WAIVED`；Checklist 与 Independent Visual Review 已通过；总分 ≥95；强制维度满分；Blocker=0；Evidence 同版本 | 可交给 Release System 判断；仍不等于 Release |
| `RETURN_FOR_REVISION` | 无不可接受权利问题，但总分 <95、存在 FAILED/Major/Minor 未关闭或可修正缺陷 | 返回最早根因 Stage，建立新 Revision |
| `COMPLETE_REJECTION` | 版权/来源不可恢复、明显复制、不可接受文化伤害、反复根本错误或 Candidate 方向违背 Phoenix | 终止 Candidate，不得导入 |
| `BLOCKED` | 资料、权威、Reviewer、设备、Build、版权、文化或 Evidence 无法确认 | 停止，解除阻断后重新审核 |

## 26.4 Gate Record

| Required field | Gate definition |
| --- | --- |
| Gate 目标 | 汇总 Gate 0–16、Blocker Catalog 与 100 分模型，判定是否达到正式质量。 |
| 适用范围 | 全部拟进入 Phoenix Visual Library、Checklist、Review、页面或正式版的 Candidate。 |
| 检查输入 | Gate 0–16 Records、Blocker Matrix、Score Sheet、Evidence Index、`VISUAL_CHECKLIST` Result、`VISUAL_REVIEW_PROMPT` Result、Candidate/Commit/Build Identity。 |
| 检查方法 | 先检查 Blocker=0，再检查 Status/Evidence/强制满分，最后计算加权总分；不得反序用分数筛掉阻断项。 |
| 通过条件 | `FORMAL_PASS` 条件全部满足；Checklist 与 Independent Visual Review 通过；总分 ≥95；强制维度满分；无失效 Waiver。 |
| 失败条件 | 总分 <95、任一 Gate FAILED/CONDITIONAL_PASS、强制维度失分或非阻断 Finding 未合法处置。 |
| 阻断条件 | 任一 `BLOCK-001`–`BLOCK-040`、Gate BLOCKED、版本不一致或 Evidence 缺失。 |
| 证据要求 | Final Score、Blocker Matrix、Gate Status Matrix、Waiver Register、Reviewer Signatures、Evidence Index。 |
| 负责人 | Gate Owner、Independent Visual Reviewer；Release Owner 只能消费结果。 |
| 失败返回路径 | 按 Blocker/Finding 返回 Pipeline 最早根因 Stage；版权不可恢复时 Complete Rejection。 |
| 重新审核要求 | 任一 Gate 输入、Candidate、Runtime Variant、Waiver、Commit、Build 或 Evidence 变化后重跑受影响 Gate 与 Gate 17。 |
| 状态记录方式 | `GATE-17` + Score + Blocker Count + Final Decision + Reviewers + Evidence URI。 |

---

# 27. Gate Sequence and Stop Rule

```text
Gate 0 资料与需求完整性
→ Gate 1 原创性与版权
→ Gate 2 画质与技术完整性
→ Gate 3 AI 错误
→ Gate 4 构图与空间层次
→ Gate 5 光影与色彩
→ Gate 6 Story 与 Journey 一致性
→ Gate 7 文化与历史真实性
→ Gate 8 阅读与交互安全
→ Gate 9 学习体验
→ Gate 10 动态效果
→ Gate 11 设备与响应式适配
→ Gate 12 性能
→ Gate 13 无障碍与舒适性
→ Gate 14 资源导入完整性
→ Gate 15 页面级 QA
→ Gate 16 跨资源一致性
→ Gate 17 最终发布评审
```

## 27.1 Phase A — Pre-import Admission

在 `VISUAL_PIPELINE.md` Stage 20 执行 Gate 0–13，并执行 Gate 16 中可在导入前完成的 Visual Library、Story、Learning、UI 与 Journey 一致性比较。只有这些检查全部 `PASSED`，才能把本阶段结果记为 `PRE_IMPORT_PASS`；其统一 Gate Status 记为 `PASSED`，Scope 必须明确写为 `PRE_IMPORT`。

`PRE_IMPORT_PASS` 只允许 Candidate 继续执行 `VISUAL_CHECKLIST`、`VISUAL_REVIEW_PROMPT` 与 Pipeline Stage 23 导入。它不是 Gate 17 `FORMAL_PASS`，不能证明页面级 QA 或正式版资格。

## 27.2 Phase B — Runtime and Release Admission

完成 Pipeline Stage 23 导入后，执行 Gate 14；在 Stage 24 的真实目标 Build 完成 Gate 15，并按真实页面结果重新执行 Gate 16。随后 Gate 17 汇总 Gate 0–16、Checklist 与 Independent Visual Review 的同版本 Evidence，才能给出 `FORMAL_PASS`。

执行规则：

- Gate 0–13 是导入前质量链；Gate 14–16 验证导入与真实运行。
- Gate 14 前必须已经完成适用的 Gate 0–13、导入前 Gate 16、Checklist 与 Independent Visual Review。
- Gate 15 只能在真实目标 Build 上执行。
- Gate 17 只能汇总同一 Candidate/Commit/Build 的有效 Evidence。
- 任一 Gate `BLOCKED` 或 `FAILED`，立即停止未执行的下游 Gate。
- `CONDITIONAL_PASS` 不能越过 Gate 17 进入正式导入或 Release。
- 修正后必须从最早根因 Gate 重启，并使相关下游 PASS 失效。

---

# 28. Evidence Requirements

每个通过的视觉资源必须保存：

- 资源名称、Asset ID 与 Version。
- Journey 或页面。
- Story Version（适用时）。
- 生成方式与生成日期。
- Prompt 或设计说明。
- 原始文件、Master 与图层。
- 优化文件与全部 Runtime Variant。
- 文件尺寸、像素、格式、体积与 Hash。
- Copyright Status、Source Register 与 License Evidence。
- Cultural Review Status 与 Source Claim Matrix。
- Gate 0–17 结果。
- Visual Checklist 结果。
- Visual Review 结果。
- Page-level QA 结果。
- Reviewer、Owner、日期与签署状态。
- Branch、Commit、Build、Environment。
- Static Fallback、Reduced Motion、Low-performance 与 Failure Variant。
- 最终状态与 Release Handoff（适用时）。

Evidence 必须：

- 可定位到具体文件、版本、页面与审核结论。
- 能由另一个 Reviewer 重复检查。
- 保存原始失败 Finding 与修正历史。
- 不以聊天记忆、缩略图、口头说明或“看起来不错”代替。

---

# 29. Gate Result Record

正式 Gate Result 至少包含：

| Field | Required value |
| --- | --- |
| Candidate Identity | Candidate/Asset/Journey/Story/Page/Version |
| Target Identity | Branch/Commit/Build/Environment |
| Gate Specification | `IMAGE_QUALITY_GATE.md` Version |
| Gate Matrix | Gate 0–17 Status、Reviewer、Date 与 Evidence URI |
| Blocker Matrix | `BLOCK-001`–`BLOCK-040` 命中与关闭状态 |
| Finding Matrix | Finding ID、Severity、Owner、Return Stage、Disposition |
| Waiver Register | 仅合法非阻断 Waiver；含批准人与期限 |
| Score | 17 维度、权重、原始分与总分 |
| Mandatory Full-score Check | 8 个不可失分维度的明确结果 |
| Final Decision | CONDITIONAL_PASS / FORMAL_PASS / RETURN_FOR_REVISION / COMPLETE_REJECTION / BLOCKED |
| Downstream State | Checklist/Review/Import/Release 是否允许继续 |

不得删除 FAILED/BLOCKED 历史来制造全绿记录。

---

# 30. Re-review and Invalidation

以下变化自动使相关 PASS 失效：

- Prompt、模型、工具、参考或来源变化。
- Master 像素、AI 修复、重绘、放大或后期变化。
- 裁切、尺寸、格式、压缩、Alpha 或文件 Hash 变化。
- Story、Journey、Culture Source、Page、UI、Learning 或 Audio Contract 变化。
- 动画、速度、周期、图层、触发、暂停或恢复变化。
- Static Fallback、Reduced Motion 或 Low-performance Variant 变化。
- 文件名、目录、引用、缓存版本或加载策略变化。
- Target Branch、Commit、Build、Device Scope 或 Release Scope 变化。
- Waiver 到期、撤销或风险扩大。

重新审核必须：

1. 保留旧 Record。
2. 建立新 Candidate Revision。
3. 标记失效 Gate。
4. 从最早受影响 Gate 重新检查。
5. 重跑所有依赖该 Gate 的下游 Gate、Checklist、Review 与 Page QA。

---

# 31. No-bypass Rules

以下做法一律禁止：

- 用总分补偿版权、AI Error、文化、阅读、安全、性能或 Page QA 阻断。
- 用 `CONDITIONAL_PASS` 导入或发布。
- 用 WAIVED 处理任何 Blocker。
- 先导入再补来源、文化、设备、性能或 Fallback Evidence。
- 用自动测试替代人工视觉、文化、版权或页面 Review。
- 用单一设备、单一比例、单一页面状态或缩略图代表全范围。
- 用遮罩、模糊、暗化、裁切或滤镜隐藏根本错误。
- 删除失败资源入口或 Finding 后声称 Gate 通过。
- 用 PR、Commit、Preview、代码引用或用户未投诉证明质量。
- 让 AI 生成并独立批准自身 Candidate。
- 将 Gate PASS 写成已合并或已发布。

---

# 32. Relationship with Pipeline, Decision Tree, Checklist and Review

| Document | Unique responsibility |
| --- | --- |
| `VISUAL_DECISION_TREE.md` | 在生产前选择资源类型、静态/动态、形式、风险与规范路径 |
| `VISUAL_PIPELINE.md` | 执行需求、研究、设计、生成、审核、优化、导入、Page QA 与 Release Eligibility Stage |
| `IMAGE_QUALITY_GATE.md` | 判断 Candidate 是否满足统一质量、Blocker 与评分标准 |
| `VISUAL_CHECKLIST` | 检查正式规范、文件、Metadata 与 Evidence 是否遗漏 |
| `VISUAL_REVIEW_PROMPT` | 统一独立 AI/人工 Review 输入与 Finding 输出，不创造或降低规则 |

三者关系：

```text
Decision Tree selects
→ Pipeline produces
→ Image Quality Gate judges
→ Checklist verifies completeness
→ Review finds residual risk
→ Page-level QA proves runtime behavior
→ Release System authorizes delivery
```

不存在任何反向路径允许低层工具修改上游规则。

---

# 33. Permanent Rule

Phoenix 视觉正式质量永远遵循：

> Story Before Visual. Learning Before Decoration. Reading Before Effects. Authenticity Before Style. Originality Before Convenience. Evidence Before Approval.

来源不明、授权不清、明显复制、Blocker/Critical AI Error、文化误导、阅读或交互不可用、闪烁或眩晕、无静态降级、严重性能问题、页面功能破坏或 Evidence 版本不一致，均为零容忍阻断。

总分必须达到至少 95/100，但高分永远不能覆盖阻断项或强制满分维度。

只有 Gate 0–17 对同一 Candidate 完成正式判定，且后续 Checklist、Independent Review 与 Release Evidence 全部满足，视觉资源才有资格进入 Phoenix 正式版。
