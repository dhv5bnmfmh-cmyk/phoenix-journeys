# Phoenix Visual Checklist

Documentation Status: Active
Documentation Version: 1.0.0
Priority: ★★★★★ (Mandatory Visual Execution Checklist)
Owner: Phoenix Visual Architecture

---

# 1. 使用说明

Phoenix Visual Checklist（简称 Visual Checklist）是所有 Phoenix 图片、背景、动画与视觉资源进入独立 Review、真实页面 QA 和正式版前必须执行的统一检查工具。

Visual Producer、Visual Reviewer、Asset Integrator、Developer、QA Owner，以及适用的 Story、Learning、UI/UX、Performance、Accessibility、Copyright 与 Cultural Reviewer 必须使用本 Checklist。检查从 `VISUAL_PIPELINE.md` Stage 21 开始；导入后必须补完本文件的资源导入、页面级 QA、跨资源一致性与最终签署部分。

本 Checklist 不能替代：

- `VISUAL_PIPELINE.md` 的生产与回退流程。
- `VISUAL_DECISION_TREE.md` 的路径选择。
- `IMAGE_QUALITY_GATE.md` 的 Gate、Blocker 与评分裁决。
- `VISUAL_REVIEW_PROMPT.md` 的独立 Review。

执行规则：

1. `[B]` 为 Blocker，全部资源必检且不得标记 `NOT_APPLICABLE`。
2. `[C]` 为 Critical，适用时失败即使整体不得通过。
3. `[M]` 为 Mandatory，全部资源必检。
4. `[CM]` 为 Conditional Mandatory，仅在括号条件成立时必检；不成立时可标记 `NOT_APPLICABLE`，但必须记录原因和判定证据。
5. 每项必须记录 `YES / NO / NOT_APPLICABLE`、Evidence ID、Reviewer 与日期；不得留空。
6. `YES` 必须有可追踪 Evidence；`NO` 必须建立 Finding、Severity、Owner、最早返回 Stage 与目标 Revision。
7. 修复后必须保留原 Finding，建立新 Evidence，并从受影响的最早章节重新检查。
8. Candidate、Master、Runtime Variant、Fallback、Prompt、Source、Story、页面、Commit、Build 或设备范围变化时，所有受影响结果自动失效。
9. Evidence 必须保存在与 Candidate ID、Asset Version、Commit 和 Build 关联的项目 Evidence Package；聊天记忆、口头确认或“看起来不错”无效。
10. Visual Owner 汇总结果；专业 Reviewer 只签署自己拥有的范围；资产生成者不得成为唯一最终确认人。
11. Checklist 完成不等于正式发布。`IMAGE_QUALITY_GATE`、本 Checklist、`VISUAL_REVIEW_PROMPT`、页面级 QA 与 Release Authorization 必须分别通过。

本 Checklist 使用两个不可混淆的执行 Scope：

- `PRE_IMPORT`：Pipeline Stage 21 执行第 2–17 节及第 20 节的导入前比较。适用项全部通过后记为 `PRE_IMPORT_CHECKLIST_PASS`，统一 Checklist Status 为 `PASSED`、Scope 为 `PRE_IMPORT`；它只允许进入 Stage 22 Independent Review，不证明导入、页面 QA 或正式版资格。
- `RUNTIME_RELEASE`：Stage 23 导入后继续执行第 18–22 节，并按真实 Build 重新检查受影响的第 12–17、20 节。先完成除 `FINAL-003`、`FINAL-011` 与“最终发布确认”外的全部适用项，形成 `RUNTIME_CHECKLIST_PASS`，供 Gate 17 与 Release Review 使用；Gate 17 给出 `FORMAL_PASS` 后，再完成这两个确认项和最终发布签署，才允许在第 25 节判断 `APPROVED_FOR_RELEASE`。

两个 Scope 必须使用同一 Candidate Evidence Chain。后续导入、页面、资源或 Build 变化会使相关 `PRE_IMPORT` 结果失效；不得用 Phase A 的 PASS 冒充 Phase B 的完成状态。

每个章节的执行记录至少包含：Section、Item ID、Severity、Result、Evidence ID/Path、Finding ID、Owner、Checked Date、Return Stage、Recheck Revision。

---

# 2. 资源识别信息

以下字段必须在检查前填写并锁定：

| Field | Required value |
| --- | --- |
| 资源名称 | 唯一、可读名称 |
| 资源 ID | Asset ID |
| Candidate / Version | Candidate ID 与 Asset Version |
| 页面名称 | Page、Route 与 State |
| Journey 名称 | Journey ID 与显示名称 |
| Journey 类型 | Ordinary / Special / Non-Journey |
| 资源类型 | Background / Map / Passport / Banner / Loading / Splash / Illustration / Icon / Character / Architecture / Programmatic / Motion / Other |
| 静态或动态 | Static / Motion / Hybrid |
| 负责人 | Visual Owner 与执行者 |
| 生成方式 | AI Original / Programmatic / Manual Original / Licensed Third-party / Hybrid |
| 创建日期 | ISO 8601 日期 |
| 最后修改日期 | ISO 8601 日期 |
| 原始文件路径 | Master / Layer Source 的版本化路径 |
| 优化文件路径 | Runtime Variant Manifest |
| 静态降级文件 | 同版本 Fallback 路径或经批准的 N/A 原因 |
| Prompt 或设计说明位置 | Prompt Version / Design Record URI |
| 版权记录位置 | Source Register / License Evidence URI |
| 对应 Commit | 完整 Commit SHA |
| 对应 PR | PR 编号或明确的 Pre-PR 状态 |
| 当前状态 | 本文件第 23 节的统一状态 |

- [ ] `ID-001` **[B]** Candidate、Asset、Journey、Story、Page、Commit 与 Build 标识唯一且互相一致。
- [ ] `ID-002` **[B]** Master、Runtime Variant、Static Fallback 与 Evidence Hash 属于同一 Revision。

---

# 3. 需求与范围检查

- [ ] `REQ-001` **[B]** 页面目标明确。
- [ ] `REQ-002` **[B]** Journey 名称明确。
- [ ] `REQ-003` **[B]** Journey 类型明确。
- [ ] `REQ-004` **[B]** 故事主题与 Approved Story Version 明确。
- [ ] `REQ-005` **[B]** 用户学习目标明确。
- [ ] `REQ-006` **[M]** 情绪明确。
- [ ] `REQ-007` **[M]** 时间明确。
- [ ] `REQ-008` **[M]** 天气明确。
- [ ] `REQ-009` **[B]** 地点明确。
- [ ] `REQ-010` **[B]** 文化背景明确。
- [ ] `REQ-011` **[B]** 文字区域明确。
- [ ] `REQ-012` **[B]** 按钮区域明确。
- [ ] `REQ-013` **[B]** 交互区域明确。
- [ ] `REQ-014` **[B]** 手机要求明确。
- [ ] `REQ-015` **[B]** 平板要求明确。
- [ ] `REQ-016` **[M]** 是否需要动态已明确并有 Decision Record。
- [ ] `REQ-017` **[B]** 静态降级要求明确。
- [ ] `REQ-018` **[B]** 性能目标明确。
- [ ] `REQ-019` **[B]** 版权与商业使用要求明确。

Evidence：Requirement Record、Story/Page/Journey Analysis、Safe-area Contract、Device Scope、Performance Budget、Source Method。任一关键需求不明确，整体状态为 `BLOCKED`，返回 Pipeline Stage 01–03，禁止进入生成阶段。

---

# 4. 规范读取检查

- [ ] `DOC-001` **[B]** 已检查 `PHOENIX_CONSTITUTION` 的真实存在与状态；缺失时未虚构内容。
- [ ] `DOC-002` **[B]** 已读取 `docs/systems/` 下全部适用 Documentation。
- [ ] `DOC-003` **[B]** 已读取 Story System 与 Approved Story Contract。
- [ ] `DOC-004` **[B]** 已读取 `VISUAL_CONSTITUTION.md`。
- [ ] `DOC-005` **[M]** 已读取 `VISUAL_PHILOSOPHY.md`。
- [ ] `DOC-006` **[M]** 已读取 `VISUAL_GUIDELINES.md`。
- [ ] `DOC-007` **[CM]** 已读取 `BACKGROUND_GUIDELINES.md`（背景或背景相关资源）。
- [ ] `DOC-008` **[CM]** 已读取 `AI_IMAGE_GENERATION_GUIDE.md`（AI 生成或 AI 后期）。
- [ ] `DOC-009` **[B]** 已读取 `VISUAL_PIPELINE.md`。
- [ ] `DOC-010` **[B]** 已读取 `VISUAL_DECISION_TREE.md`。
- [ ] `DOC-011` **[B]** 已读取 `IMAGE_QUALITY_GATE.md`。
- [ ] `DOC-012` **[B]** 已读取当前任务真实存在且适用的页面、UI、Learning、Audio、Animation、Accessibility、Performance、QA 与 Release 规范。
- [ ] `DOC-013` **[B]** 已读取当前 Journey 的完整故事、时间、天气、人物、场景与文化输入。
- [ ] `DOC-014` **[M]** 已读取已有同类视觉与完整 Journey Visual Library。

每次读取必须记录 File Path、Documentation Status、Version、Commit/Hash、Read Date 与 Reader。不存在的规范必须记录为 Missing Authority，不得标记成“已读取”。

---

# 5. 研究与真实性检查

- [ ] `RES-001` **[B]** 城市信息已由可靠来源确认。
- [ ] `RES-002` **[B]** 地理位置与必要空间关系已确认。
- [ ] `RES-003` **[B]** 建筑风格已确认。
- [ ] `RES-004` **[B]** 历史时期已确认。
- [ ] `RES-005` **[B]** 服装时代与地区已确认。
- [ ] `RES-006` **[C]** 器物用途、结构与场景关系合理。
- [ ] `RES-007` **[C]** 食物和生活方式符合地区、时代与人物。
- [ ] `RES-008` **[B]** 文化、宗教与传统符号含义已确认。
- [ ] `RES-009` **[CM]** 特别 Journey 的原典、版本与核心精神已确认。
- [ ] `RES-010` **[CM]** 神话、志怪、传奇、民间文学或诗词来源已确认。
- [ ] `RES-011` **[B]** 未错误混合朝代。
- [ ] `RES-012` **[B]** 未错误混合地区文化。
- [ ] `RES-013` **[B]** 未误用宗教或传统符号。
- [ ] `RES-014` **[B]** 未使用文化、民族、地区、年龄或性别刻板印象。
- [ ] `RES-015` **[B]** 艺术化改编保留核心文化含义并记录改编边界。

Evidence：Source Claim Matrix、原典/历史/地理来源、访问日期、Cultural Reviewer Decision。文化含义无法确认时整体 `BLOCKED`，返回 Pipeline Stage 04，不得进入正式版。

---

# 6. 原创性与版权检查

- [ ] `COPY-001` **[B]** 资源为可追踪的 AI 原创、程序化原创、手工原创或获商业授权的组合。
- [ ] `COPY-002` **[B]** 未直接使用版权未知网络图片、纹理、字体、Icon 或参考输入。
- [ ] `COPY-003` **[B]** 未复制电影画面或其可识别构图。
- [ ] `COPY-004` **[B]** 未复制游戏画面或资产。
- [ ] `COPY-005` **[B]** 未复制动漫画面或角色设计。
- [ ] `COPY-006` **[B]** 未复制出版物插图。
- [ ] `COPY-007` **[B]** 未复制商业摄影。
- [ ] `COPY-008` **[B]** 未使用未经授权角色或肖像。
- [ ] `COPY-009` **[B]** 未使用未经授权 Logo。
- [ ] `COPY-010` **[B]** 未使用未经授权商标或品牌识别。
- [ ] `COPY-011` **[B]** 未模仿具体艺术家的独特风格。
- [ ] `COPY-012` **[B]** 所有第三方资源具有覆盖 Phoenix 用途的商业授权。
- [ ] `COPY-013` **[B]** 第三方许可证、条款版本与获取日期已保存。
- [ ] `COPY-014` **[B]** 每个素材与输入来源可追踪。
- [ ] `COPY-015` **[M]** 生成方式、工具与版本已记录。
- [ ] `COPY-016` **[M]** Prompt 或程序化/人工设计说明已保存。
- [ ] `COPY-017` **[B]** Copyright Reviewer 已确认商业可用状态。

任何来源、授权或商业使用无法确认，立即 `BLOCKED`，对应 `IMAGE_QUALITY_GATE` Gate 1；不得导入、Waive 或以总分补偿。

---

# 7. 文件与画质检查

- [ ] `FILE-001` **[B]** 原始文件存在且 Hash 已记录。
- [ ] `FILE-002` **[B]** 优化文件与响应式 Variant 存在。
- [ ] `FILE-003` **[B]** 全部文件可正常打开、解码与显示。
- [ ] `FILE-004` **[B]** 文件未损坏、无缺失区域。
- [ ] `FILE-005` **[B]** 分辨率达到 `IMAGE_QUALITY_GATE` Gate 2 的用途标准。
- [ ] `FILE-006` **[B]** 手机目标尺寸清晰。
- [ ] `FILE-007` **[B]** 平板目标尺寸清晰。
- [ ] `FILE-008` **[B]** 高 DPI / Retina 显示清晰。
- [ ] `FILE-009` **[B]** 无可见模糊。
- [ ] `FILE-010` **[B]** 无错误拉伸或比例变形。
- [ ] `FILE-011` **[C]** 无可见锯齿。
- [ ] `FILE-012` **[B]** 无严重压缩色块。
- [ ] `FILE-013` **[B]** 无色带或暗部断层。
- [ ] `FILE-014` **[B]** 无错误透明边缘或 Alpha 杂色。
- [ ] `FILE-015` **[B]** 无明显拼接。
- [ ] `FILE-016` **[C]** 无过度锐化、光晕或假细节。
- [ ] `FILE-017` **[M]** 无不服务显示需求的超高分辨率。
- [ ] `FILE-018` **[B]** 不同屏幕比例裁切合理。
- [ ] `FILE-019` **[B]** 主体与关键文化元素未被错误裁切。
- [ ] `FILE-020` **[M]** 缩略图版本在实际显示尺寸清晰。
- [ ] `FILE-021` **[B]** 静态降级图达到对应静态用途画质。

Evidence：Master/Variant Hash、尺寸、格式、压缩设置、100% Crop 与真实设备截图。

---

# 8. AI 错误检查

## 8.1 人物

- [ ] `AI-H-001` **[B]** 面部结构正常。
- [ ] `AI-H-002` **[B]** 五官数量、位置与方向正常。
- [ ] `AI-H-003` **[B]** 手指数量、连接与动作正常。
- [ ] `AI-H-004` **[B]** 肢体数量、关节与连接正常。
- [ ] `AI-H-005` **[B]** 服装结构、闭合与穿着关系正常。
- [ ] `AI-H-006` **[B]** 身体比例正常。
- [ ] `AI-H-007` **[B]** 人物数量符合 Story/Scene Contract。
- [ ] `AI-H-008` **[B]** 人物未重复复制或身份混合。

## 8.2 建筑

- [ ] `AI-A-001` **[B]** 建筑结构可成立。
- [ ] `AI-A-002` **[C]** 门窗比例、重复规律与连接合理。
- [ ] `AI-A-003` **[B]** 透视、消失点与尺度合理。
- [ ] `AI-A-004` **[B]** 建筑时代正确。
- [ ] `AI-A-005` **[B]** 建筑地区与文化正确。
- [ ] `AI-A-006` **[B]** 牌匾、文字与符号正确。

## 8.3 环境

- [ ] `AI-E-001` **[B]** 无漂浮或错误连接物体。
- [ ] `AI-E-002` **[C]** 无无意义重复物体或纹理。
- [ ] `AI-E-003` **[B]** 无错误反射。
- [ ] `AI-E-004` **[B]** 无错误阴影。
- [ ] `AI-E-005` **[B]** 无冲突光源。
- [ ] `AI-E-006` **[B]** 无不合理比例。
- [ ] `AI-E-007` **[C]** 无不自然纹理。
- [ ] `AI-E-008` **[C]** 无塑料质感或生成性光泽。

## 8.4 文字与符号

- [ ] `AI-T-001` **[B]** 无乱码。
- [ ] `AI-T-002` **[B]** 无错误文字、错别字或错误数字。
- [ ] `AI-T-003` **[B]** 无伪汉字。
- [ ] `AI-T-004` **[B]** 无错误 Logo、品牌或商标。
- [ ] `AI-T-005` **[B]** 无错误文化、宗教或传统符号。

## 8.5 整体与严重等级

- [ ] `AI-O-001` **[C]** 无明显 AI 生成痕迹、拼贴感或不自然一致性。
- [ ] `AI-O-002` **[B]** Blocker Error 为零。
- [ ] `AI-O-003` **[B]** Critical Error 为零。
- [ ] `AI-O-004` **[C]** Major Error 已修复并重新进入 Gate 3。
- [ ] `AI-O-005` **[M]** Minor Error 已记录，且保留理由不影响正式品质。

Blocker 或 Critical 存在时禁止通过。不得用遮罩、模糊、暗化或裁切隐藏错误；必须重新生成或按 Gate 3 允许范围修复后重新审核。

---

# 9. 构图与层次检查

- [ ] `COMP-001` **[C]** 主视觉明确且与 Story/Journey 目标一致。
- [ ] `COMP-002` **[C]** 构图重心稳定。
- [ ] `COMP-003` **[M]** 视觉动线引导内容而非离开内容。
- [ ] `COMP-004` **[M]** 前景成立并有明确职责。
- [ ] `COMP-005` **[M]** 中景成立并承载主要叙事或空间关系。
- [ ] `COMP-006` **[M]** 远景成立并提供环境与方向。
- [ ] `COMP-007` **[C]** 景深、尺度与空气透视自然。
- [ ] `COMP-008` **[C]** 层次服务故事、阅读与探索。
- [ ] `COMP-009` **[M]** 留白位置和面积合理。
- [ ] `COMP-010` **[M]** 画面有呼吸感。
- [ ] `COMP-011` **[M]** 细节丰富但不杂乱。
- [ ] `COMP-012` **[C]** 没有无意义堆叠。
- [ ] `COMP-013` **[C]** 没有为凑前中远景强行添加元素。
- [ ] `COMP-014` **[B]** 手机裁切后构图成立。
- [ ] `COMP-015` **[B]** 平板裁切后构图成立。
- [ ] `COMP-016` **[B]** 全部批准宽高比构图成立。
- [ ] `COMP-017` **[B]** 文字区未被主体或高频细节占据。
- [ ] `COMP-018` **[B]** 按钮区未被主体、高对比或误导元素占据。

前景、中景、远景不适合 Icon 或纯功能资源时，必须以等效的信息层级、轮廓层级和状态层级检查，不能直接跳过层次职责。

---

# 10. 光影与色彩检查

- [ ] `LIGHT-001` **[C]** 主光源明确。
- [ ] `LIGHT-002` **[B]** 光线方向统一。
- [ ] `LIGHT-003` **[B]** 阴影方向与接触关系正确。
- [ ] `LIGHT-004` **[B]** 反射符合材质、空间与光源。
- [ ] `LIGHT-005` **[C]** 色温统一且有意图。
- [ ] `LIGHT-006` **[C]** 主色符合 Journey Identity。
- [ ] `LIGHT-007` **[C]** 色彩符合 Story 情绪与时间。
- [ ] `LIGHT-008` **[M]** 饱和度克制。
- [ ] `LIGHT-009` **[C]** 暗部保留必要细节。
- [ ] `LIGHT-010` **[C]** 高光不过曝且不抢夺内容。
- [ ] `LIGHT-011` **[M]** 无灰脏、浑浊或统一蒙灰。
- [ ] `LIGHT-012` **[C]** 无塑料光泽。
- [ ] `LIGHT-013` **[C]** 无廉价滤镜感。
- [ ] `LIGHT-014` **[B]** 文字区亮度与局部对比支持阅读。
- [ ] `LIGHT-015` **[B]** 按钮区对比支持识别与状态判断。
- [ ] `LIGHT-016` **[C]** 手机真实设备显示稳定。
- [ ] `LIGHT-017` **[C]** 平板真实设备显示稳定。
- [ ] `LIGHT-018` **[M]** 已检查不同显示特性下的严重偏色风险。

---

# 11. 故事与 Journey 一致性检查

- [ ] `STORY-001` **[B]** 视觉与 Approved Story 主题一致。
- [ ] `STORY-002` **[B]** 时间一致。
- [ ] `STORY-003` **[B]** 天气一致。
- [ ] `STORY-004` **[B]** 地点与地理身份一致。
- [ ] `STORY-005` **[C]** 情绪与情绪曲线一致。
- [ ] `STORY-006` **[B]** 人物身份、数量、服装与状态一致。
- [ ] `STORY-007` **[B]** 场景与事件一致。
- [ ] `STORY-008` **[B]** 关键道具一致。
- [ ] `STORY-009` **[CM]** 普通 Journey 的现实、地方与生活定位正确。
- [ ] `STORY-010` **[CM]** 特别 Journey 的类型、原典精神与幻想边界正确。
- [ ] `STORY-011` **[B]** 未出现 Story 中不存在且会改变意义的关键元素。
- [ ] `STORY-012` **[B]** 未遗漏 Scene Contract 要求的关键元素。
- [ ] `STORY-013` **[B]** 未错误使用其他城市或地区元素。
- [ ] `STORY-014` **[B]** 未错误使用其他时代元素。
- [ ] `STORY-015` **[C]** 与其他 Journey 在构图、色彩、符号和主视觉上有明确差异。
- [ ] `STORY-016` **[C]** 拥有独立、可识别的 Journey Visual Identity。
- [ ] `STORY-017` **[M]** 能帮助用户形成该 Journey 的真实记忆锚点。

Story Owner 必须确认事实与意义；Visual Reviewer 不得自行替代 Story 审核。

---

# 12. 阅读与交互安全检查

- [ ] `SAFE-001` **[B]** 标题在全部目标状态清晰。
- [ ] `SAFE-002` **[B]** 正文清晰。
- [ ] `SAFE-003` **[B]** 生词卡片清晰。
- [ ] `SAFE-004` **[B]** 挑战选项清晰且彼此可区分。
- [ ] `SAFE-005` **[B]** 按钮清晰。
- [ ] `SAFE-006` **[B]** 导航清晰。
- [ ] `SAFE-007` **[B]** 字幕清晰。
- [ ] `SAFE-008` **[B]** 朗读控制清晰。
- [ ] `SAFE-009` **[B]** 动态元素不穿过文字安全区。
- [ ] `SAFE-010` **[B]** 动态或高对比元素不干扰按钮区。
- [ ] `SAFE-011` **[B]** 交互区域无视觉误导。
- [ ] `SAFE-012` **[B]** 刘海与顶部系统安全区有效。
- [ ] `SAFE-013` **[B]** 底部系统安全区有效。
- [ ] `SAFE-014` **[B]** 横屏安全区有效。
- [ ] `SAFE-015` **[B]** 竖屏安全区有效。
- [ ] `SAFE-016` **[B]** 批准语言范围的最长实际文本可容纳。
- [ ] `SAFE-017` **[C]** 阅读不依赖厚重遮罩。
- [ ] `SAFE-018` **[M]** 遮罩仅在构图、光影、细节、裁切与自然留白优化后克制使用。
- [ ] `SAFE-019` **[B]** 背景不会造成误点击或错误状态判断。

阅读失败必须依次返回构图、光影、局部细节、裁切、自然留白，最后才允许轻量遮罩；不得用大面积黑色遮罩掩盖失败构图。

---

# 13. 学习体验检查

- [ ] `LEARN-001` **[B]** 不影响 Story 阅读。
- [ ] `LEARN-002` **[B]** 不影响生词理解与卡片识别。
- [ ] `LEARN-003` **[B]** 不影响发现页探索。
- [ ] `LEARN-004` **[B]** 不影响挑战答题、选项判断与反馈。
- [ ] `LEARN-005` **[B]** 不影响留下印象流程。
- [ ] `LEARN-006` **[B]** 不影响盖章反馈。
- [ ] `LEARN-007` **[B]** 不影响自动或手动朗读。
- [ ] `LEARN-008` **[B]** 不影响字幕。
- [ ] `LEARN-009` **[C]** 不造成过度认知负担。
- [ ] `LEARN-010` **[C]** 不抢夺学习焦点。
- [ ] `LEARN-011` **[M]** 能增强 Story 记忆。
- [ ] `LEARN-012` **[M]** 能形成与内容对应的视觉记忆锚点。
- [ ] `LEARN-013` **[B]** 视觉信息与学习内容一致。
- [ ] `LEARN-014` **[C]** 没有仅为装饰而增加的干扰元素。

视觉再华丽，只要破坏学习流程，本章节即失败并返回 Pipeline Stage 03、06、07、14 或真实根因 Stage。

---

# 14. 动态背景与动画检查

本章节 23 项均为 `[CM]`：仅 Motion 或 Hybrid Candidate 必检；纯静态 Candidate 可逐项标记 `NOT_APPLICABLE`，但必须引用 Static/Motion Decision Record。

- [ ] `MOTION-001` **[CM-C]** 动态确实提升氛围、空间或叙事体验。
- [ ] `MOTION-002` **[CM-C]** 动态方向合理。
- [ ] `MOTION-003` **[CM-C]** 动态速度克制。
- [ ] `MOTION-004` **[CM-B]** 动作符合物理规律或经批准的幻想规则。
- [ ] `MOTION-005` **[CM-C]** 循环无明显接缝。
- [ ] `MOTION-006` **[CM-B]** 无危险或频繁闪烁。
- [ ] `MOTION-007` **[CM-B]** 无强烈缩放。
- [ ] `MOTION-008` **[CM-B]** 无镜头乱晃。
- [ ] `MOTION-009` **[CM-C]** 无廉价粒子。
- [ ] `MOTION-010` **[CM-C]** 无不自然漂浮。
- [ ] `MOTION-011` **[CM-C]** 无重复机械感。
- [ ] `MOTION-012` **[CM-B]** 不经过文字安全区。
- [ ] `MOTION-013` **[CM-B]** 不影响按钮、导航或点击判断。
- [ ] `MOTION-014` **[CM-B]** 不影响朗读、字幕与播放控制。
- [ ] `MOTION-015` **[CM-B]** 不造成眩晕或持续视觉疲劳。
- [ ] `MOTION-016` **[CM-B]** 页面离开后暂停并释放不必要资源。
- [ ] `MOTION-017` **[CM-B]** 页面返回后状态正确恢复。
- [ ] `MOTION-018` **[CM-B]** 支持 `prefers-reduced-motion`。
- [ ] `MOTION-019` **[CM-C]** 支持 Phoenix 手动减少动态效果设置。
- [ ] `MOTION-020` **[CM-B]** 同版本高清静态降级有效。
- [ ] `MOTION-021` **[CM-B]** 低性能设备自动或明确降级。
- [ ] `MOTION-022` **[CM-B]** 动画加载或运行失败时不会黑屏。
- [ ] `MOTION-023` **[CM-B]** 动态不自然时已取消动态并退回高清静态方案。

不得为了“有动画”保留低质量动态。任一 Motion Blocker 失败，禁止发布动态版本。

---

# 15. 响应式与设备检查

## 15.1 Device Matrix

每个结果单元格是一项独立 Checklist Item，按 `设备 ID + 列 ID` 记录。`Y/N/NA` 必须替换为审核结果并关联 Evidence；表中共 110 项。

| Device ID | Device scope | 主体 `01` | 文字 `02` | 按钮 `03` | 导航 `04` | 层次 `05` | 裁切 `06` | 无拉伸 `07` | 无闪屏 `08` | 动画稳定 `09` | 静态降级 `10` | 失败回退 `11` |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `DEV-SM` | 小屏手机 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-ST` | 标准手机 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-LG` | 大屏手机 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-TP` | 平板竖屏 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-TL` | 平板横屏 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-DR` | 桌面预留 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-HD` | 高 DPI | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-NT` | 刘海屏/系统安全区 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-WN` | 弱网络设备 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |
| `DEV-LP` | 低性能设备 | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA | Y/N/NA |

严重等级：列 `01`–`04`、`06`–`08`、`10`–`11` 为 `[B]`；列 `05` 为 `[C]`；列 `09` 为 Motion/Hybrid 的 `[CM-B]`，静态资源可有证据地标记 `NOT_APPLICABLE`。桌面若仅为未来预留，`DEV-DR` 可按当前批准 Scope 标记 `[CM]`；一旦桌面进入 Release Scope，全部单元格成为必检。

## 15.2 Matrix Evidence

每个设备必须记录真实或批准仿真设备、OS、Viewport、DPI、Orientation、Build、Network/Profile、Screenshot/Recording 和 Result。小屏、标准手机、大屏、平板竖横屏与当前 Release Scope 的高 DPI/安全区不得整体跳过。

---

# 16. 性能检查

- [ ] `PERF-001` **[B]** 文件格式符合内容、兼容与解码要求。
- [ ] `PERF-002` **[M]** AVIF 可用且质量/兼容成立时优先采用。
- [ ] `PERF-003` **[B]** WebP 或批准的兼容回退有效。
- [ ] `PERF-004` **[C]** PNG 仅用于 Alpha、无损或明确必要场景。
- [ ] `PERF-005` **[B]** SVG 来源、节点、语义与渲染安全。
- [ ] `PERF-006` **[B]** 响应式尺寸齐全且映射正确。
- [ ] `PERF-007` **[C]** 首屏资源预加载符合真实关键路径。
- [ ] `PERF-008` **[C]** 非首屏资源懒加载且无延迟破坏。
- [ ] `PERF-009` **[B]** 文件体积符合 Gate 12 或更严格批准预算。
- [ ] `PERF-010` **[B]** 未使用超大视频或无可控回退的视频。
- [ ] `PERF-011` **[C]** 未使用无意义透明 PNG。
- [ ] `PERF-012` **[B]** 缓存策略与失效规则正确。
- [ ] `PERF-013` **[B]** 资源版本、Hash 与缓存版本一致。
- [ ] `PERF-014` **[C]** 页面切换无明显闪屏。
- [ ] `PERF-015` **[B]** 动画帧率达到 Gate 12 目标或已降级。
- [ ] `PERF-016` **[B]** 无持续内存增长。
- [ ] `PERF-017` **[B]** 页面离开后资源正确暂停或释放。
- [ ] `PERF-018` **[B]** 弱网络有可用回退。
- [ ] `PERF-019` **[B]** 低性能设备有可用降级。
- [ ] `PERF-020` **[B]** 加载失败有占位或静态回退。
- [ ] `PERF-021` **[C]** 未为视觉炫技引入无必要大型依赖。

Evidence：Transfer Size、Network Trace、Decode/Memory/GPU/Frame Metrics、Cache Test、弱网与低性能录屏。性能不合格禁止进入正式版。

---

# 17. 无障碍与舒适性检查

- [ ] `A11Y-001` **[B]** 文字与必要 UI 对比度达到适用标准。
- [ ] `A11Y-002` **[B]** 不依赖颜色表达唯一含义或状态。
- [ ] `A11Y-003` **[B]** 支持减少动态效果。
- [ ] `A11Y-004` **[B]** 无危险闪烁。
- [ ] `A11Y-005` **[B]** 无眩晕风险。
- [ ] `A11Y-006` **[C]** 无持续视觉疲劳。
- [ ] `A11Y-007` **[B]** 低视力与文字放大状态仍可阅读和操作。
- [ ] `A11Y-008` **[B]** 高对比模式可用。
- [ ] `A11Y-009` **[B]** 功能性图片有准确语义说明或等效文本。
- [ ] `A11Y-010` **[C]** 装饰性图片不会被辅助技术错误朗读。
- [ ] `A11Y-011` **[B]** 动态资源可以暂停或降级。
- [ ] `A11Y-012` **[B]** Gate 13 的全部无障碍阻断项已关闭。

版权、文化误导、运动安全和无障碍 Blocker 不得 Waive。

---

# 18. 资源导入检查

- [ ] `IMPORT-001` **[B]** 文件命名符合 Visual/AI Image 命名规范。
- [ ] `IMPORT-002` **[B]** 文件目录与 Archive/Runtime 边界正确。
- [ ] `IMPORT-003` **[B]** 资源引用指向批准的 Runtime Variant。
- [ ] `IMPORT-004` **[B]** 响应式资源映射正确。
- [ ] `IMPORT-005` **[B]** 静态回退资源已接入并同版本。
- [ ] `IMPORT-006` **[B]** Metadata 完整。
- [ ] `IMPORT-007` **[B]** 版权记录完整并可追踪。
- [ ] `IMPORT-008` **[M]** 生成记录完整。
- [ ] `IMPORT-009` **[B]** Master、Variant 与 Fallback Hash 已记录。
- [ ] `IMPORT-010` **[B]** 缓存版本已更新并验证失效。
- [ ] `IMPORT-011` **[C]** 未使用资源已从运行引用清理。
- [ ] `IMPORT-012` **[B]** 旧资源未被错误引用。
- [ ] `IMPORT-013` **[B]** 加载失败处理已实现并验证。
- [ ] `IMPORT-014` **[B]** 页面返回状态恢复正常。
- [ ] `IMPORT-015` **[C]** 不存在内容相同、用途相同的重复 Runtime 资源。
- [ ] `IMPORT-016` **[C]** 不存在未引用、未归档或无 Owner 的孤立文件。

本章节只能在 Pipeline Stage 23 的真实目标 Commit 上完成。素材生成完成不等于导入完成。

---

# 19. 页面级 QA 检查

- [ ] `PAGE-001` **[B]** 页面首次进入正常。
- [ ] `PAGE-002` **[B]** 页面刷新正常。
- [ ] `PAGE-003` **[B]** 页面返回正常。
- [ ] `PAGE-004` **[B]** 页面切换正常。
- [ ] `PAGE-005` **[B]** 背景加载正常。
- [ ] `PAGE-006` **[B]** 背景加载失败回退正常。
- [ ] `PAGE-007` **[B]** 自动朗读与视觉状态共同正常。
- [ ] `PAGE-008` **[B]** 手动朗读与控制正常。
- [ ] `PAGE-009` **[B]** 字幕显示、滚动与同步正常。
- [ ] `PAGE-010` **[B]** 按钮点击、状态与反馈正常。
- [ ] `PAGE-011` **[C]** 页面滚动正常。
- [ ] `PAGE-012` **[B]** 横竖屏切换正常。
- [ ] `PAGE-013` **[B]** 弱网络流程正常或正确降级。
- [ ] `PAGE-014` **[B]** 低性能模式正常。
- [ ] `PAGE-015` **[B]** 减少动态效果模式正常。
- [ ] `PAGE-016` **[B]** 普通 Journey 适用页面与状态正常。
- [ ] `PAGE-017` **[B]** 特别 Journey 适用页面与状态正常。
- [ ] `PAGE-018` **[B]** 免费用户流程正常。
- [ ] `PAGE-019` **[B]** 付费用户流程正常。
- [ ] `PAGE-020` **[B]** 锁定状态正常。
- [ ] `PAGE-021` **[B]** 解锁状态正常。
- [ ] `PAGE-022` **[B]** 页面恢复后视觉、Audio、Learning 与交互状态正常。

必须在真实 Phoenix Build、目标 Commit、页面、设备、网络和用户状态执行。不得仅查看独立图片、设计稿或 Storybook 后勾选页面级 QA。

---

# 20. 跨资源一致性检查

- [ ] `CROSS-001` **[B]** 符合 `VISUAL_CONSTITUTION.md`。
- [ ] `CROSS-002` **[C]** 符合 `VISUAL_PHILOSOPHY.md`。
- [ ] `CROSS-003` **[C]** 符合 `VISUAL_GUIDELINES.md`。
- [ ] `CROSS-004` **[CM]** 背景资源符合 `BACKGROUND_GUIDELINES.md`。
- [ ] `CROSS-005` **[B]** 符合 Story System 与 Approved Story Contract。
- [ ] `CROSS-006` **[B]** 符合 Learning System 的真实有效输入与流程。
- [ ] `CROSS-007` **[B]** 符合 UI/UX 布局、状态与交互边界。
- [ ] `CROSS-008` **[C]** 与已有 Journey Visual Library 属于同一 Phoenix 视觉语言。
- [ ] `CROSS-009` **[C]** 不存在风格突变。
- [ ] `CROSS-010` **[C]** 不存在同一页面内部组件、背景与动效冲突。
- [ ] `CROSS-011` **[C]** 不存在多个 Journey 高度相似。
- [ ] `CROSS-012` **[C]** 色彩语言一致但 Journey Identity 可区分。
- [ ] `CROSS-013` **[C]** 光影语言一致且符合时间/情绪。
- [ ] `CROSS-014` **[CM]** 动态语言与现有 Phoenix Motion 体系一致。
- [ ] `CROSS-015` **[CM]** Icon 轮廓、网格、重量、状态与现有体系一致。

导入前执行 Library Comparison；页面级 QA 后必须按真实合成结果重新执行本章节。

---

# 21. Gate 与 Review 确认

本章节属于 `RUNTIME_RELEASE` 汇总。Stage 21 的 `PRE_IMPORT` Record 不把尚未发生的 Independent Review、Import、Page QA 或 Gate 17 `FORMAL_PASS` 标成 `NOT_APPLICABLE`，也不把它们计入 Phase A 的适用项；这些项目必须在对应 Stage 完成后由同一 Evidence Chain 补审。

`RUNTIME_CHECKLIST_PASS` 是 Gate 17 的 Checklist 输入：它要求全部运行期实质检查和 Independent Review 已通过，但暂不计算依赖 Gate 17 自身结果的 `FINAL-003`、`FINAL-011` 与最终发布确认。Gate 17 `FORMAL_PASS` 后只补录这些结果与签署，不得改变前序资源检查结论。这样禁止 Checklist 与 Gate 17 互相伪造先决 PASS。

- [ ] `FINAL-001` **[B]** `VISUAL_PIPELINE.md` 的适用 Stage 全部完成并有 Evidence。
- [ ] `FINAL-002` **[B]** `VISUAL_DECISION_TREE.md` 路径正确且 Decision Record 完整。
- [ ] `FINAL-003` **[B]** `IMAGE_QUALITY_GATE` Gate 0–17 已按两阶段模型全部审核。
- [ ] `FINAL-004` **[B]** `BLOCK-001`–`BLOCK-040` 当前命中数为零。
- [ ] `FINAL-005` **[B]** 所有不可 Waive 项通过。
- [ ] `FINAL-006` **[C]** `CONDITIONAL_PASS` 与合法非阻断 Waiver 有完整原因、风险、批准人、期限与修复计划。
- [ ] `FINAL-007` **[B]** `VISUAL_REVIEW_PROMPT` 已由独立 Reviewer 执行。
- [ ] `FINAL-008` **[B]** Review Finding 已修复或按上游规则合法处置。
- [ ] `FINAL-009` **[B]** 修复后受影响 Gate、Checklist 与 Review 已重新执行。
- [ ] `FINAL-010` **[B]** 页面级 QA 已通过。
- [ ] `FINAL-011` **[B]** Gate 17 总分不低于 95/100，强制满分维度全部满分。

本章节不能把 Checklist 自己标记为上游 Gate 的替代证据。

---

# 22. 最终签署

| Sign-off | Required signer | Date | Status | Evidence | Unresolved risk | Waiver / Expiry |
| --- | --- | --- | --- | --- | --- | --- |
| 视觉负责人确认 | Visual Owner / Independent Visual Reviewer | 必填 | 本节状态 | Gate/Checklist/Review Evidence | 必填；无则记录 None | 必填；无则记录 None |
| Story 负责人确认 | Story Owner（Journey/Story 适用时） | 必填 | 本节状态 | Story/Journey Evidence | 同上 | 同上 |
| Learning 负责人确认 | Learning Owner（学习页面适用时） | 必填 | 本节状态 | Learning Flow Evidence | 同上 | 同上 |
| UI/UX 负责人确认 | UI/UX Owner | 必填 | 本节状态 | Layout/Interaction Evidence | 同上 | 同上 |
| 性能确认 | Performance Reviewer | 必填 | 本节状态 | Gate 12 Evidence | 同上 | 同上 |
| 无障碍确认 | Accessibility Reviewer | 必填 | 本节状态 | Gate 13 Evidence | 同上 | 同上 |
| 版权确认 | Copyright Reviewer | 必填 | 本节状态 | Gate 1 Evidence | 同上 | 同上 |
| QA 确认 | QA Owner | 必填 | 本节状态 | Gate 15 Evidence | 同上 | 同上 |
| 最终发布确认 | Release Owner | 必填 | 本节状态 | Gate 17 + Release Evidence | 同上 | 同上 |

签署人只能确认其权限范围。任何签署不能降低 Constitution、Gate、Blocker、设备、性能、无障碍或页面 QA 标准。

---

# 23. Checklist 状态

| Status | Meaning | Downstream permission |
| --- | --- | --- |
| `NOT_STARTED` | 尚未检查 | 无 |
| `IN_PROGRESS` | 正在检查，仍有未完成项 | 无正式导入或发布权限 |
| `BLOCKED` | 命中 Blocker、缺少必要 Authority/Evidence 或无法合法判断 | 停止并返回上游 |
| `FAILED` | 已确认不满足要求 | 修复后重新审核 |
| `CONDITIONAL_PASS` | 仅剩可合法处置的非阻断有限问题 | 只允许修正、复审或明确批准的非发布流程 |
| `PASSED` | 全部适用项有 Evidence 且通过 | 只允许进入下一个规定 Stage |
| `NOT_APPLICABLE` | 条件项不适用且已有原因、范围与 Evidence | 仅该 Item；不得用于整体 Checklist |

与 `IMAGE_QUALITY_GATE.md` 的对应关系：Checklist `IN_PROGRESS` 对应 Gate 审核中的 `IN_REVIEW`；Checklist 不使用 Gate 的 `WAIVED` 作为 Item Result，合法 Waiver 仍须把该 Item 记为 `CONDITIONAL_PASS` 并引用 Waiver Record。阻断项永远不得标记 `NOT_APPLICABLE`。

---

# 24. 失败与重新审核

- 任一 `[B]` 为 `NO`、缺证或无法确认，整体状态立即为 `BLOCKED`。
- 任一适用 `[C]` 为 `NO`，整体不得 `PASSED`。
- 任一 `[CM]` 条件成立时必须执行；用错误 Scope 标记 `NOT_APPLICABLE` 视为 Blocker。
- 修复后必须重新执行受影响章节及其下游 Gate、Checklist、Review 与页面 QA。
- Story、Learning、UI、Audio、Animation、Performance、Accessibility、Code 或 Release Scope 变化后，必须重新执行对应接口检查。
- 不允许只修改检查结果而不修改真实资源、配置、代码或 Evidence。
- 不允许在没有新 Evidence、新 Candidate Revision 和 Reviewer 日期时直接改为 `PASSED`。
- 所有失败、修复、Waiver、失效和重新审核必须保留历史记录。
- 版权不明、Blocker/Critical AI Error、严重文化误导、阅读/按钮/学习不可用、闪烁/眩晕、无静态降级、严重性能或页面功能破坏不得通过 Waiver、`NOT_APPLICABLE`、总分或排期绕过。

失败记录至少包含 Finding ID、Item ID、Severity、Observed Evidence、Expected Rule、Root Cause、Return Stage、Owner、Target Revision、Fix Evidence、Recheck Result 与 Reviewer。

---

# 25. 最终输出格式

Checklist Final Record 必须输出：

| Field | Required result |
| --- | --- |
| 资源信息 | 第 2 节完整 Identity 与版本 |
| 完成率 | 已作出有效结果的 Item / 适用 Item × 100% |
| 适用检查项数量 | 排除有合法理由的 `NOT_APPLICABLE` 后数量 |
| `PASSED` 数量 | Result = YES 且 Evidence 有效的 Item 数量 |
| `FAILED` 数量 | Result = NO 的非 Blocker Item 数量 |
| `BLOCKED` 数量 | 命中 Blocker 或缺少必要 Evidence 的 Item 数量 |
| `NOT_APPLICABLE` 数量 | 仅合法条件项，附原因与 Evidence |
| 阻断项 | Blocker ID / Checklist Item / Finding / Return Stage |
| 未解决问题 | Severity、Owner、期限与风险 |
| Gate 评分 | Gate 17 的 17 维度与总分 |
| Review 状态 | `VISUAL_REVIEW_PROMPT` Result 与 Evidence |
| 页面 QA 状态 | Target Build/Commit、Matrix 与 Result |
| 最终结论 | 下列唯一允许值之一 |

最终结论只能是：

- `REJECTED`：权利、文化伤害、复制或根本方向不可恢复。
- `BLOCKED`：资料、来源、授权、Reviewer、设备、Build 或 Evidence 无法确认，或命中 Blocker。
- `REQUIRES_REVISION`：存在可修正的 FAIL/Critical/Major 问题。
- `CONDITIONAL_PASS`：只剩合法非阻断有限问题；不得进入正式版。
- `APPROVED_FOR_PREVIEW`：导入前 Gate、Checklist 与独立 Review 已通过，只允许进入批准的 Preview/页面 QA。
- `APPROVED_FOR_RELEASE`：Gate 0–17、全部适用 Checklist、独立 Review、版权、文化、设备、性能、无障碍、静态降级、页面级 QA 与最终签署全部通过。

只有全部正式版条件满足时，才允许 `APPROVED_FOR_RELEASE`。Checklist 结论不执行 Merge 或 Release；Release System 仍须独立授权。

---

# 26. Gate Coverage Map

| Image Quality Gate | Checklist coverage |
| --- | --- |
| Gate 0 — 资料与需求 | 第 2–4 节 |
| Gate 1 — 原创性与版权 | 第 6、18、21–22 节 |
| Gate 2 — 画质与技术完整性 | 第 7、15–16、18 节 |
| Gate 3 — AI Error | 第 8 节 |
| Gate 4 — 构图与空间层次 | 第 9、12、15 节 |
| Gate 5 — 光影与色彩 | 第 10、12、15、20 节 |
| Gate 6 — Story/Journey 一致性 | 第 11、20、22 节 |
| Gate 7 — 文化与历史真实性 | 第 5、8、11、22 节 |
| Gate 8 — 阅读与交互安全 | 第 9、10、12、15、19 节 |
| Gate 9 — 学习体验 | 第 13、19、22 节 |
| Gate 10 — 动态效果 | 第 14–17、19–20 节 |
| Gate 11 — 设备与响应式 | 第 7、9、12、15、19 节 |
| Gate 12 — 性能 | 第 15–16、18–19、22 节 |
| Gate 13 — 无障碍与舒适性 | 第 12、14–15、17、19、22 节 |
| Gate 14 — 资源导入完整性 | 第 2、18–19 节 |
| Gate 15 — 页面级 QA | 第 15、19、21–22 节 |
| Gate 16 — 跨资源一致性 | 第 11、20、22 节 |
| Gate 17 — 最终发布评审 | 第 21–25 节 |

Gate 覆盖必须是 18/18。若上游 Gate 增加、删除或改变强制条件，本 Checklist 必须重新 Review；清单遗漏不能降低 Gate。

---

# 27. Checklist Inventory and Audit Rule

本版本计数规则：

- 编号 Checklist 行每行计 1 项。
- Device Matrix 每个结果单元格计 1 项，共 110 项。
- 最终签署每行计 1 项，共 9 项。
- 资源识别字段是 Record Field，不计入 Checklist Item。

本版本 Checklist 总项数为 **445**：编号检查项 326、Device Matrix 110、最终签署 9。

条件必检项为 **51**：编号 `[CM]`/`[CM-*]` 32 项、Device Matrix Motion 列 10 项、桌面预留非 Motion 单元格 9 项。桌面进入正式 Release Scope 后，对应 9 项转为 Mandatory；动态资源的 Motion 列转为 Mandatory。

本版本定义 **327 个潜在阻断项**：编号 `[B]`/`[CM-B]` 227 项，Device Matrix `[B]`/`[CM-B]` 100 项。这里的“潜在”表示 Conditional Item 只有在适用条件成立时进入 Candidate 的 Blocker Count；适用后不得跳过或降级。

阻断项按当前适用 Scope 计算，不能只按文档标签总数判断 Candidate。审计工具必须同时检查：

1. 编号 `[B]` 与 `[CM-B]` 项。
2. Device Matrix 中定义为 `[B]` 的单元格。
3. 最终签署中由上游 Blocker 导致的缺失或失败。
4. `IMAGE_QUALITY_GATE.md` 的 40 条不可补偿 Blocker。

任何 Item 无法明确给出条件、步骤、结果或 Evidence 类型时，本 Checklist 不得发布。任何 `NOT_APPLICABLE` 缺少适用性规则、原因或证据时，按 `BLOCKED` 处理。

---

# 28. Permanent Rule

Visual Checklist 的职责是证明“所有必须检查的内容都被真实检查并留下证据”，不是证明“看起来不错”。

任何来源不明、授权不清、明显 AI Error、文化误导、阅读或按钮不可用、学习流程受阻、动态不自然、闪烁或眩晕、设备未验证、性能不合格、无静态降级、页面级 QA 失败或 Evidence 版本不一致，均不得通过勾选、`NOT_APPLICABLE`、Waiver、总分或签署绕过。

> Story Before Visual. Learning Before Decoration. Reading Before Effects. Evidence Before Approval.
