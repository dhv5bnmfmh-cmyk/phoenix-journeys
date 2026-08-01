# Phoenix Visual Production Pipeline

Documentation Status: Active
Documentation Version: 1.0.0
Priority: ★★★★★ (Mandatory Visual Production Process)
Owner: Phoenix Visual Architecture

---

# 1. Purpose

Phoenix Visual Production Pipeline（简称 Visual Pipeline）定义视觉资源从需求进入、研究、设计、生成、审核、优化、导入，到页面级 QA 与正式版资格判定的唯一生产流程。

本文件把上游视觉原则转换为可执行阶段，但不重新定义：

- Story Meaning、人物、事件或文化事实。
- Learning Flow、Challenge Logic、奖励或完成条件。
- UI 信息架构、组件行为或交互状态。
- Audio 内容、朗读逻辑或语音控制。
- `IMAGE_QUALITY_GATE`、`VISUAL_CHECKLIST` 或 `VISUAL_REVIEW_PROMPT` 的独立审核标准。
- QA、Release、版权、Accessibility 或 Performance System 的专业规则。

本 Pipeline 的目标不是“生成一张好看的图片”，而是产生能够安全、合法、真实、稳定地服务 Phoenix 故事、阅读、学习与探索的正式视觉资产。

素材完成不等于功能完成。

导入 Phoenix 不等于允许进入正式版。

---

# 2. Authority and Required Reading Order

执行者必须按以下顺序读取真实存在且适用的规范：

1. 当前用户明确指令与任务边界。
2. Repository README。
3. `docs/systems/README.md`。
4. `docs/systems/SYSTEM_ARCHITECTURE.md`。
5. `docs/systems/SYSTEM_DEPENDENCY.md`。
6. `docs/systems/SYSTEM_LIFECYCLE.md`。
7. `docs/systems/SYSTEM_PRIORITY.md`。
8. `docs/story/README.md` 与目标 Journey 的 Approved Story Contract。
9. `docs/story/STORY_CONSTITUTION.md`。
10. `docs/story/STORY_PHILOSOPHY.md`。
11. 真实存在且适用的 Story Decision Tree、Pipeline、Checklist 与专项规范。
12. `docs/visual/README.md`。
13. `docs/visual/VISUAL_CONSTITUTION.md`。
14. `docs/visual/VISUAL_PHILOSOPHY.md`。
15. `docs/visual/VISUAL_GUIDELINES.md`。
16. `docs/visual/BACKGROUND_GUIDELINES.md`（背景或背景图层适用时）。
17. `docs/visual/AI_IMAGE_GENERATION_GUIDE.md`（AI 生成适用时）。
18. 真实存在且适用的 UI、Learning、Audio、Animation、Accessibility、Performance、QA 与 Release 规范。
19. 本 `VISUAL_PIPELINE.md`。
20. `IMAGE_QUALITY_GATE`、`VISUAL_CHECKLIST` 与 `VISUAL_REVIEW_PROMPT`（进入相应阶段时）。

上位文件缺失、不可读、状态无效或发生无法裁决的冲突时，必须按 `SYSTEM_PRIORITY.md` 停止受影响决定。不得用本 Pipeline、代码现状、AI 推测或已生成素材补写缺失权威。

---

# 3. Scope

本 Pipeline 适用于 Phoenix 全部新建、替换或实质修改的视觉资产，包括：

- 普通 Journey。
- 特别 Journey。
- 故事背景。
- 动态背景。
- 静态背景。
- 首页视觉。
- 世界地图。
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
- 其他 AI 原创视觉资源。

本 Pipeline 同时适用于：

- 高分辨率 Master Asset。
- Foreground、Midground、Far Background 与 Overlay 图层。
- Mobile、Tablet、横竖屏与不同屏幕比例变体。
- Static、Animated、Reduced Motion 与 Low-performance Variant。
- Thumbnail、Map Node、Passport Marker 与运行时导出资源。

纯业务逻辑、Story 正文、Learning Rule、UI 行为或 Audio 实现不属于本 Pipeline 的生产输出。

---

# 4. Canonical Flow

```text
需求确认
→ 读取 Phoenix Documentation
→ 页面、故事和 Journey 分析
→ 文化与视觉研究
→ 视觉方向设计
→ 构图与前景、中景、远景规划
→ 文字、按钮和交互安全区规划
→ 静态或动态方案选择
→ AI 图片生成 Prompt 设计
→ 原创素材生成
→ AI 错误检查
→ 文化真实性检查
→ 版权与商业使用检查
→ Journey 一致性检查
→ 视觉风格一致性检查
→ 动画自然度检查
→ 手机和平板适配
→ 性能优化
→ 静态降级方案
→ IMAGE_QUALITY_GATE
→ VISUAL_CHECKLIST
→ VISUAL_REVIEW_PROMPT
→ 导入 Phoenix
→ 页面级 QA
→ 允许进入正式版
```

任何阶段的输入版本变化，会使依赖该输入的下游批准失效。执行者必须返回最早受影响阶段，重新生成 Evidence，并重新通过全部受影响 Gate。

---

# 5. Pipeline Status and Gate Model

每个 Visual Candidate 必须拥有唯一 Candidate ID、Asset ID、Journey ID（适用时）、Asset Version 与 Evidence Set。

阶段结果只有：

| Result | Meaning | Required action |
| --- | --- | --- |
| `PASSED` | 当前阶段全部进入与退出条件满足，Evidence 完整 | 允许进入下一阶段 |
| `NEEDS_REVISION` | 问题可由明确上游阶段修正 | 停止下游并按 Return Path 返回 |
| `BLOCKED` | 权威、来源、版权、真实性、设备、性能或必要依赖无法确认 | 禁止导入与发布，直到阻断解除 |
| `REJECTED` | Candidate 根本方向、权利或质量不符合 Phoenix | 终止 Candidate；如需继续，建立新版本并从指定上游重启 |

不存在：

- 基本通过。
- 暂时通过。
- 先导入再检查。
- 上线后再修。
- 高分覆盖 Blocking Failure。
- AI 自动批准自身输出。

本文件中标记 `YES` 的强制 Gate 不可跳过。所有 25 个阶段均为正式流程的必需交接点；其中 Stage 11–25 是 Release Blocking Gate，任一失败都直接禁止正式导入或发布。

---

# 6. Roles and Separation of Duties

| Role | Primary responsibility | Prohibited authority |
| --- | --- | --- |
| Requirement Owner | 确认用途、范围、目标页面、目标设备与验收结果 | 不得以排期绕过 Gate |
| Visual Producer | 建立 Brief、Prompt、Master 与变体 | 不得独立批准自己的最终资源 |
| Visual Architect | 批准视觉方向、构图、Journey Identity 与视觉一致性 | 不得改写 Story 或 Learning Rule |
| Story Owner | 确认 Approved Story Version、场景、人物、情绪与原典精神 | 不得规定具体画风、动效实现或文件格式 |
| Cultural Reviewer | 验证城市、时代、建筑、服饰、器物、自然与文化语境 | 不得用个人审美替代证据 |
| Copyright Reviewer | 验证输入、参考、模型、生成方式、许可与商业使用记录 | 不得对无法确认的权利作推定通过 |
| UI/UX Owner | 提供布局、组件、交互、文字与按钮安全区 Contract | 不得反向修改视觉哲学或 Story Meaning |
| Learning Owner | 提供学习内容、优先级与流程保护要求 | 不得设计图片或动画风格 |
| Audio Owner | 提供朗读控件、播放状态与听觉流程保护要求 | 不得以音频效果反向创造视觉规则 |
| Animation Reviewer | 验证运动逻辑、循环、自然度与 Reduced Motion | 不得用动画掩盖静态构图失败 |
| Accessibility Reviewer | 验证闪烁、眩晕、对比、缩放与 Reduced Motion | 不得降低内容意义 |
| Performance Reviewer | 验证大小、格式、解码、内存、帧率、加载与降级 | 不得以性能为由静默破坏 Journey Identity |
| QA Owner | 执行页面级、设备级与回归验证 | 不得创造或降低 Visual Rule |
| Release Owner | 汇总同一 Candidate 的 Gate Evidence 并判断 Release Eligibility | 不得替代专业 Reviewer 或绕过失败项 |

同一 AI 可以辅助多个阶段，但不得同时成为生成者与唯一批准者。涉及文化、版权、正式 Review 或 Release Authorization 的结论必须保留可追踪的人类责任或项目明确批准机制。

---

# 7. Required Artifact Chain

完整 Visual Candidate 至少必须形成以下可追踪链：

```text
Requirement Record
→ Documentation Reading Record
→ Page / Story / Journey Analysis
→ Cultural and Visual Research Evidence
→ Visual Direction Brief
→ Composition Plan
→ Safe-area Contract
→ Static / Motion Decision
→ Prompt Record（AI 适用时）
→ Original Master and Candidate Set
→ AI Error Evidence
→ Cultural Authenticity Evidence
→ Copyright and Commercial-use Evidence
→ Journey Consistency Evidence
→ Visual Consistency Evidence
→ Motion Review Evidence
→ Device Adaptation Evidence
→ Performance Evidence
→ Static Fallback Evidence
→ Image Quality Gate Result
→ Visual Checklist Result
→ Visual Review Result
→ Import Record
→ Page-level QA Result
→ Release Eligibility Record
```

任何输出必须引用同一 Candidate ID、Asset Version、Story Version、Journey Version 与目标 Commit（适用时）。混用版本时结果为 `BLOCKED`。

---

# 8. Stage 01 — Requirement Confirmation

| Field | Definition |
| --- | --- |
| 目标 | 确认为什么需要该视觉、服务哪个页面和 Journey、解决什么体验问题，以及本次是否为新建、替换或实质修改。 |
| 输入 | 当前明确指令、产品需求、页面范围、Journey ID、目标用户、目标设备、现有资产与已知问题。 |
| 执行动作 | 定义 Asset Type、页面、状态、尺寸方向、语言、主题、静态/动态候选范围、交付边界与不可改变项；明确不开发业务功能。 |
| 输出 | Versioned Requirement Record、Candidate ID、Asset ID、Scope、Acceptance Intent 与 Out-of-scope List。 |
| 负责人 | Requirement Owner；Visual Architect、Story/UI/Learning Owner 按适用范围会签。 |
| 必须读取的规范 | Systems 五份规范、Visual README；Story 或页面相关任务同时读取 Story README。 |
| 进入条件 | 请求来源、目标仓库/版本和修改授权可确认。 |
| 退出条件 | 资源用途、页面、Journey、用户、设备、交付范围与禁止事项无歧义。 |
| 强制 Gate | `YES — REQUIREMENT_GATE`。范围不明、同时要求改变 Story/Learning/UI Logic 或授权不足时不得继续。 |
| 失败后的返回路径 | 返回 Requirement Owner 澄清；涉及规范冲突时进入 `SYSTEM_PRIORITY` 冲突流程。 |

---

# 9. Stage 02 — Phoenix Documentation Reading

| Field | Definition |
| --- | --- |
| 目标 | 建立当前 Candidate 的真实权威链、依赖链和禁止边界。 |
| 输入 | PASS 的 Requirement Record、当前 Branch/Commit、Documentation 文件与状态。 |
| 执行动作 | 按本文件第 2 章读取；记录适用、不适用、缺失或冲突文件；确认 Constitution → Philosophy → Guidelines → Pipeline → Gate 的优先级。 |
| 输出 | Documentation Reading Record、Applicable Rules Index、Missing Authority List 与 Conflict Result。 |
| 负责人 | Visual Architect；Documentation Owner 验证文档状态与冲突。 |
| 必须读取的规范 | 本文件第 2 章列出的全部适用规范。 |
| 进入条件 | Stage 01 PASS，目标 Documentation 可访问。 |
| 退出条件 | 每一项设计、生成、检查、导入与 QA 决定均能指向有效规范；无未解决冲突。 |
| 强制 Gate | `YES — DOCUMENTATION_GATE`。缺失且当前决定依赖该权威时为 `BLOCKED`。 |
| 失败后的返回路径 | 缺失或冲突返回 Documentation Owner / System Owner；不得以现有图片或代码代替。 |

---

# 10. Stage 03 — Page, Story and Journey Analysis

| Field | Definition |
| --- | --- |
| 目标 | 把页面目的、Approved Story Meaning、Journey Identity 与学习/交互限制转换为视觉输入。 |
| 输入 | Documentation Reading Record、Approved Story Contract、页面 Contract、Learning Flow、Audio 控件与当前资产。 |
| 执行动作 | 分析人物、目标、场景、时间、天气、文化、情绪、阅读节奏、页面状态、文字长度、按钮、朗读、Challenge、留下印象与盖章关系；区分普通与特别 Journey。 |
| 输出 | Page–Story–Journey Analysis、Visual Opportunities、Protected Content List 与 Consumer Contract。 |
| 负责人 | Visual Architect；Story、Learning、UI/UX、Audio Owner 提供各自权威输入。 |
| 必须读取的规范 | Story README、Constitution、Philosophy、适用 Decision Tree/Pipeline；Visual Constitution、Philosophy、Guidelines；页面相关规范。 |
| 进入条件 | Stage 02 PASS；Story Version 和页面用途可确认。无 Story 的全局资源必须有稳定 Product/Page Contract。 |
| 退出条件 | Visual 不创造或改写 Story、Learning、UI 或 Audio Rule；所有内容与操作优先级明确。 |
| 强制 Gate | `YES — CONTENT_ALIGNMENT_GATE`。Story Version 不明或 Consumer 使用不同版本时为 `BLOCKED`。 |
| 失败后的返回路径 | Story 问题返回 Story Owner；Learning/UI/Audio Contract 问题返回对应 Owner；不得由 Visual 自行补写。 |

---

# 11. Stage 04 — Cultural and Visual Research

| Field | Definition |
| --- | --- |
| 目标 | 建立可验证的城市、时代、原典、生活方式、自然环境与视觉参照基础。 |
| 输入 | PASS 的分析、Story Source、Journey Metadata、地点/时代/文化范围与研究问题。 |
| 执行动作 | 研究建筑结构、材料、街道、服饰、器物、植物、地貌、天气、光线、生活痕迹与原典意象；区分事实、演变、民间传统与 Phoenix 合理想象；记录来源和使用边界。 |
| 输出 | Cultural and Visual Research Evidence、Fact/Interpretation Boundary、Risk List 与 Approved Reference Notes。 |
| 负责人 | Cultural Reviewer；Story Owner 验证叙事来源，Visual Architect 验证视觉可用性。 |
| 必须读取的规范 | Story Constitution/Philosophy、Visual Constitution/Philosophy/Guidelines、Background Guidelines、AI Image Generation Guide 的文化与来源要求。 |
| 进入条件 | Stage 03 PASS；研究对象、时期、地区与特别 Journey 原典可识别。 |
| 退出条件 | 关键文化判断有可靠依据；参考材料权利状态已记录；无未经说明的时代、宗教、民族或地域混搭。 |
| 强制 Gate | `YES — CULTURAL_RESEARCH_GATE`。真实性不足、来源不可靠或原典精神不明时禁止进入设计。 |
| 失败后的返回路径 | 返回 Research Owner 扩充或替换研究；Journey/Story 定位错误返回 Stage 03 或 Story Pipeline。 |

---

# 12. Stage 05 — Visual Direction Design

| Field | Definition |
| --- | --- |
| 目标 | 建立符合 Phoenix 且具有独立 Journey Identity 的视觉方向。 |
| 输入 | Requirement、Page–Story–Journey Analysis、Research Evidence、Visual Library 对比与品牌约束。 |
| 执行动作 | 定义情绪、时间、天气、主要空间、镜头、光线、色温、主/辅/强调色、材质、文化细节、主视觉与禁止元素；比较现有 Journey，排除模板化重复。 |
| 输出 | Approved Visual Direction Brief、Journey Identity Statement、Mood/Color/Lighting Direction 与 Prohibited Elements。 |
| 负责人 | Visual Architect；Story Owner 与 Cultural Reviewer 验证 Meaning 和真实性。 |
| 必须读取的规范 | Visual Constitution、Visual Philosophy、Visual Guidelines；背景适用时读取 Background Guidelines。 |
| 进入条件 | Stage 04 PASS；Research Evidence 可支持方向。 |
| 退出条件 | 方向服务 Story、阅读与学习；普通 Journey 真实具体，特别 Journey 尊重原典精神；与 Visual Library 可区分。 |
| 强制 Gate | `YES — VISUAL_DIRECTION_GATE`。只靠换色、通用古风/东方风、旅游海报或网游模板形成方向时 FAIL。 |
| 失败后的返回路径 | 文化原因返回 Stage 04；Story/Journey 定位原因返回 Stage 03；视觉重复返回本 Stage 重设方向。 |

---

# 13. Stage 06 — Composition and Depth Planning

| Field | Definition |
| --- | --- |
| 目标 | 在生成前固定镜头、主视觉、视线与前景/中景/远景关系。 |
| 输入 | PASS 的 Visual Direction Brief、目标比例、页面布局、Story Scene 与环境结构。 |
| 执行动作 | 规划镜头高度/距离、地平线、消失点、主体位置、视线方向、前景入口、中景行动区、远景世界、空气层、景深、光源与裁切余量；为图层动画保留可分离结构。 |
| 输出 | Composition Plan、Layer Map、Crop Map、Light Map 与 Focal-flow Diagram。 |
| 负责人 | Visual Architect / Visual Producer；UI/UX Owner 提供布局限制。 |
| 必须读取的规范 | Visual Guidelines 的 Composition、Layering、Ratio 与 Responsive 章节；Background Guidelines（适用时）；AI Image Generation Guide 的 Prompt Architecture。 |
| 进入条件 | Stage 05 PASS；目标页面和比例已知。 |
| 退出条件 | 具有可信空间与唯一视觉中心；前、中、远景职责明确；不同设备裁切后仍保留 Journey Identity。 |
| 强制 Gate | `YES — COMPOSITION_GATE`。平面拼贴、透视冲突、主体与阅读区竞争或无法安全裁切时 FAIL。 |
| 失败后的返回路径 | 返回本 Stage 重构构图；视觉方向不支持可用构图时返回 Stage 05。 |

---

# 14. Stage 07 — Text, Button and Interaction Safe-area Planning

| Field | Definition |
| --- | --- |
| 目标 | 在素材生成前保护全部文字、按钮、朗读控件和学习流程。 |
| 输入 | Composition Plan、UI Layout Contract、全部页面状态、文本长度范围、Locale、字体缩放与系统安全区。 |
| 执行动作 | 标记 Reading、Button、Navigation、Audio Control、Challenge Option、Map Hotspot、Passport Hotspot、Loading/Error 与 Gesture Safe Area；检查简繁体、辅助语言、Dynamic Island、状态栏和底部手势区。 |
| 输出 | Versioned Safe-area Contract、Overlay Mock、State Coverage Map 与 Contrast Requirement。 |
| 负责人 | UI/UX Owner 与 Visual Architect 共同负责；Learning、Audio、Accessibility Reviewer 验证。 |
| 必须读取的规范 | Visual Guidelines 的 Reading/Button/Mobile/Tablet Standards；Background Guidelines 的安全区要求；适用 UI、Learning、Audio、Accessibility 规范。 |
| 进入条件 | Stage 06 PASS；布局与交互状态真实存在或已批准。 |
| 退出条件 | 正常、播放、暂停、选择、错误、重试、完成、Loading 与返回状态均有安全区域；装饰不伪装成控件。 |
| 强制 Gate | `YES — SAFE_AREA_GATE`。影响阅读、按钮、朗读或学习流程时禁止继续生成和导入。 |
| 失败后的返回路径 | 构图可修时返回 Stage 06；布局 Contract 问题返回 UI/UX Owner；学习或音频状态不明返回对应 Owner。 |

---

# 15. Stage 08 — Static or Motion Decision

| Field | Definition |
| --- | --- |
| 目标 | 只在动效具有明确体验价值且能够自然、稳定、可降级时选择动态方案。 |
| 输入 | Visual Direction、Layer Map、Safe-area Contract、目标设备能力、Accessibility 与 Performance Constraints。 |
| 执行动作 | 比较高清静态、分层轻动效、视差、循环背景与状态动画；定义为什么动、什么动、幅度、速度、周期、触发、停止、Reduced Motion 与 Static Fallback；默认优先静态。 |
| 输出 | Static/Motion Decision Record、Motion Intent、Layer Requirements、Risk Budget 与 Fallback Requirement。 |
| 负责人 | Visual Architect；Animation、Accessibility、Performance、UI/UX Reviewer 会签。 |
| 必须读取的规范 | Visual Constitution/Philosophy、Visual Guidelines 的 Motion Hierarchy、Background Guidelines 的动态/静态规则，以及真实存在的 Animation、Accessibility、Performance 规范。 |
| 进入条件 | Stage 07 PASS；安全区和设备范围明确。 |
| 退出条件 | 动态价值可解释、不会抢夺阅读、实现和降级路径可验证；否则选择高清静态方案。 |
| 强制 Gate | `YES — MOTION_DECISION_GATE`。没有必要性、无法自然实现或无法提供静态降级时，只允许静态。 |
| 失败后的返回路径 | 退回本 Stage 选择高清静态；若静态构图也不成立，返回 Stage 06。 |

---

# 16. Stage 09 — AI Image Prompt Design

| Field | Definition |
| --- | --- |
| 目标 | 把 Approved Brief 转换为结构化、可追踪、原创且不让模型自行决定关键事实的生成指令。 |
| 输入 | Research Evidence、Visual Direction、Composition Plan、Safe-area Contract、Static/Motion Decision 与禁止元素。 |
| 执行动作 | 按用途→Story/Journey→文化→时间天气→镜头构图→前中远景→光影→色彩材质→安全区→人物动作→质量→Negative Prompt 编写；记录模型/工具、Prompt Version、输入参考与许可。 |
| 输出 | Prompt Record、Negative Prompt、Reference Register、Generation Settings 与 Expected Review Risks。 |
| 负责人 | Visual Producer；Visual Architect、Cultural Reviewer、Copyright Reviewer 审核。 |
| 必须读取的规范 | `AI_IMAGE_GENERATION_GUIDE.md` 全文，以及 Visual Guidelines、Background Guidelines 和 Approved Story Contract。 |
| 进入条件 | Stage 08 PASS；所有 Prompt 输入权利可记录。非 AI 原创流程须记录不适用理由与替代创作说明。 |
| 退出条件 | Prompt 具体、可复现、无艺术家模仿、品牌/影视/动漫/游戏复制要求，且明确安全区和禁止内容。 |
| 强制 Gate | `YES — PROMPT_GATE`（AI 生成适用时）。Prompt 依赖无授权参考或模糊文化词替代研究时 FAIL。 |
| 失败后的返回路径 | 版权输入问题返回 Stage 04/版权 Reviewer；构图问题返回 Stage 06；文化问题返回 Stage 04；其余返回本 Stage。 |

---

# 17. Stage 10 — Original Asset Generation

| Field | Definition |
| --- | --- |
| 目标 | 生成或制作高质量原创 Master Candidate，而非直接生产未经审核的运行时文件。 |
| 输入 | Approved Prompt Record 或原创制作说明、Design Brief、目标分辨率、图层要求与 Candidate ID。 |
| 执行动作 | 生成多个受控候选；保留原始输出、Prompt、参数、Reference Register 与批次关系；选出符合构图方向的候选；不在此阶段用滤镜掩盖错误。 |
| 输出 | Original Candidate Set、High-resolution Master Candidates、Generation Log 与 Initial Selection Rationale。 |
| 负责人 | Visual Producer；Visual Architect 只做方向初筛，不作最终批准。 |
| 必须读取的规范 | AI Image Generation Guide；Visual Guidelines 的 Resolution、Naming、Directory 与 Metadata 要求。 |
| 进入条件 | Stage 09 PASS，或非 AI 原创制作说明获得批准；Source 与 Review Candidate 目录分离。 |
| 退出条件 | Master 清晰、可检查、可裁切、可追踪；没有把低分辨率放大冒充高质量母版。 |
| 强制 Gate | `YES — ORIGINAL_ASSET_GATE`。来源记录、Prompt/制作记录或 Master 缺失时不得进入审核。 |
| 失败后的返回路径 | 生成质量问题返回 Stage 09；方向根因返回 Stage 05；构图根因返回 Stage 06。 |

---

# 18. Stage 11 — AI Error Inspection

| Field | Definition |
| --- | --- |
| 目标 | 在原始分辨率和目标裁切中发现所有明显生成错误与结构错误。 |
| 输入 | Original Candidate Set、Master、Prompt、Layer Files 与 Crop Map。 |
| 执行动作 | 按全图、四角、主体、人物、手部、建筑、器物、文字/Logo、透视、光影、阴影、倒影、自然、重复纹理、边缘与 100% 尺寸顺序检查；再检查所有目标裁切。 |
| 输出 | AI Error Report、Annotated Evidence、PASS/REJECTED Result 与 Regeneration Decision。 |
| 负责人 | Visual Reviewer；Visual Producer 修正但不能独立批准。 |
| 必须读取的规范 | AI Image Generation Guide 的 AI Error Categories、Review Procedure、Regeneration 与 Rejection Conditions。 |
| 进入条件 | Stage 10 PASS；可以访问原始分辨率文件。 |
| 退出条件 | 无明显人体、建筑、文字、透视、光影、倒影、自然或生成纹理错误。 |
| 强制 Gate | `YES — AI_ERROR_GATE`，Release Blocking。有明显 AI 错误时禁止导入。 |
| 失败后的返回路径 | 局部非根本错误可修复后重新执行本 Stage；构图、身份、文化、透视体系或大面积错误返回 Stage 09/10 重新生成。 |

---

# 19. Stage 12 — Cultural Authenticity Inspection

| Field | Definition |
| --- | --- |
| 目标 | 验证成品不是“看起来像”，而是真正属于目标地点、时代、文化与 Story。 |
| 输入 | AI Error PASS Candidate、Research Evidence、Story Contract、Prompt Record 与 Cultural Risk List。 |
| 执行动作 | 核对建筑、材料、门窗、服饰、器物、植物、地貌、天气、生活方式、文字、宗教/民俗符号、时代关系与文化精神；特别 Journey 额外核对原典精神，普通 Journey 核对地方生活真实性。 |
| 输出 | Cultural Authenticity Report、Evidence Links、Finding Severity 与 PASS/NEEDS_REVISION/BLOCKED。 |
| 负责人 | Cultural Reviewer；Story Owner 验证 Story/原典接口，Visual Architect 处理表现修正。 |
| 必须读取的规范 | Story Constitution/Philosophy、Approved Story Contract、Visual Constitution/Guidelines、Background Guidelines、AI Image Generation Guide 的 Ordinary/Special 规则。 |
| 进入条件 | Stage 11 PASS；研究证据与 Candidate Version 一致。 |
| 退出条件 | 关键事实准确、合理想象边界清楚、无刻板印象与无依据混搭；文化 Reviewer 给出可追踪 PASS。 |
| 强制 Gate | `YES — CULTURAL_AUTHENTICITY_GATE`，Release Blocking。文化真实性不足必须重新研究和设计。 |
| 失败后的返回路径 | 研究不足返回 Stage 04；方向错误返回 Stage 05；Prompt/生成错误返回 Stage 09/10；Story 来源问题返回 Story Owner。 |

---

# 20. Stage 13 — Copyright and Commercial-use Inspection

| Field | Definition |
| --- | --- |
| 目标 | 证明每个输入、参考、生成方式、后期元素与最终输出可合法用于 Phoenix 商业产品。 |
| 输入 | Candidate、Prompt/Creation Record、Reference Register、工具/模型条款、第三方素材清单、字体/Icon/Logo 信息与后期记录。 |
| 执行动作 | 检查来源、授权范围、商业使用、再分发、商标、肖像、遗产/馆藏限制、具体艺术家模仿、影视动漫游戏角色、品牌元素、水印与许可保存；确认 Metadata 可追踪。 |
| 输出 | Copyright and Commercial-use Record、License Evidence、Restrictions、Reviewer Decision 与 Asset Metadata。 |
| 负责人 | Copyright Reviewer；必要时由法律/产品授权 Owner 裁决。 |
| 必须读取的规范 | Visual Constitution 的 Originality、AI Image Generation Guide 的 Copyright/Source/Reference/Rejection 规则，以及真实存在的 Copyright Policy。 |
| 进入条件 | Stage 12 PASS；全部输入和后期来源已列出。 |
| 退出条件 | 原创性、来源和商业使用均可确认；无未处理商标、肖像、版权或许可限制。 |
| 强制 Gate | `YES — COPYRIGHT_GATE`，Release Blocking。版权或商业使用无法确认时禁止导入。 |
| 失败后的返回路径 | 无法补证时 `REJECTED`；可替换参考/元素时返回 Stage 04/09/10，并重新执行 Stage 11–13。 |

---

# 21. Stage 14 — Journey Consistency Inspection

| Field | Definition |
| --- | --- |
| 目标 | 确认 Candidate 与目标 Journey、Story Version、页面角色及同 Journey 资产形成同一世界。 |
| 输入 | Copyright PASS Candidate、Approved Story Contract、Journey Metadata、页面资产组与相关 Audio/Learning/UI Contract。 |
| 执行动作 | 对照人物、地点、时间、天气、光线、情绪、文化、场景、关键物件、颜色倾向、视觉记忆与页面顺序；检查 Story→生词→发现→挑战→留下印象→盖章的视觉衔接。 |
| 输出 | Journey Consistency Matrix、Version Match Evidence、Cross-page Findings 与 PASS/NEEDS_REVISION。 |
| 负责人 | Visual Architect；Story Owner、Learning Owner 与页面 Owner 会签。 |
| 必须读取的规范 | Approved Story Contract、Story Constitution/Philosophy、Visual Constitution/Guidelines、适用 Background Guidelines。 |
| 进入条件 | Stage 13 PASS；所有对比资产和 Contract 版本可识别。 |
| 退出条件 | Candidate 不改写 Story，同 Journey 各页面保持身份连续但不机械重复；所有 Consumer 指向同一批准版本。 |
| 强制 Gate | `YES — JOURNEY_CONSISTENCY_GATE`，Release Blocking。Story/Journey/版本不一致时禁止导入。 |
| 失败后的返回路径 | Story 数据错误返回 Story Owner；视觉方向错误返回 Stage 05；单一页面表达错误返回 Stage 06/09/10。 |

---

# 22. Stage 15 — Visual Style Consistency Inspection

| Field | Definition |
| --- | --- |
| 目标 | 维持 Phoenix 整体统一与每个 Journey 局部独特，避免模板、滤镜或跨资源质量漂移。 |
| 输入 | Journey Consistency PASS Candidate、Phoenix Visual Library、同类型页面资产与 Visual Direction Brief。 |
| 执行动作 | 比较镜头、构图、光影、色彩、材质、空间深度、细节密度、文化表达、阅读优先级与 AI 质感；检查跨 Journey 重复和同 Journey 风格断裂。 |
| 输出 | Visual Consistency Report、Library Comparison、Duplicate Risk Result 与 PASS/NEEDS_REVISION。 |
| 负责人 | Visual Architect；Visual Reviewer 提供独立复核。 |
| 必须读取的规范 | Visual Constitution、Visual Philosophy、Visual Guidelines、AI Image Generation Guide 的 Cross-Journey Difference。 |
| 进入条件 | Stage 14 PASS；可读取当前目标 Visual Library。 |
| 退出条件 | 整体属于 Phoenix、目标 Journey 可辨认、无明显生成模板和仅换色重复。 |
| 强制 Gate | `YES — VISUAL_CONSISTENCY_GATE`，Release Blocking。风格漂移或重复率不可接受时禁止继续。 |
| 失败后的返回路径 | 方向重复返回 Stage 05；构图重复返回 Stage 06；局部生成质感返回 Stage 09/10。 |

---

# 23. Stage 16 — Motion Naturalness Inspection

| Field | Definition |
| --- | --- |
| 目标 | 验证动态符合真实运动、阅读节奏、设备能力与 Accessibility，不展示特效本身。 |
| 输入 | Motion Candidate、Static Master、Motion Intent、Layer Map、Safe-area Contract、目标帧率与循环设置。 |
| 执行动作 | 检查运动来源、方向、速度、幅度、景深关系、视差、镜头稳定、循环接缝、停顿、触发/停止、播放恢复、文字与控件后方运动、Reduced Motion；测试闪烁、眩晕、掉帧和机械循环。 |
| 输出 | Motion Review Report、Frame/Loop Evidence、Accessibility Result、Performance Finding 与 Motion/Static Decision。 |
| 负责人 | Animation Reviewer；Visual Architect、Accessibility、Performance、UI/UX Reviewer 会签。 |
| 必须读取的规范 | Visual Constitution/Philosophy、Visual Guidelines 的 Motion/Reading Safety、Background Guidelines 的 Dynamic/Static 规则，以及适用 Animation/Accessibility/Performance 规范。 |
| 进入条件 | Stage 15 PASS；动态方案在 Stage 08 获批；高清静态 Master 可用。静态资源记录 `N/A — Static` 后进入下一 Stage。 |
| 退出条件 | 动态自然、低权重、无明显循环、无闪烁眩晕、无掉帧、不遮挡内容且 Reduced Motion 正确。 |
| 强制 Gate | `YES — MOTION_NATURALNESS_GATE`，Release Blocking。动态不自然时必须退回高清静态方案；动画闪烁、眩晕、掉帧或循环明显时禁止发布。 |
| 失败后的返回路径 | 立即停用动态并采用 Stage 08 批准的高清静态方案；如需重做动态，返回 Stage 06/08，重新执行全部下游检查。 |

---

# 24. Stage 17 — Mobile, Tablet and Ratio Adaptation

| Field | Definition |
| --- | --- |
| 目标 | 证明视觉在手机、平板、横竖屏和不同屏幕比例中保持清晰、安全与 Journey Identity。 |
| 输入 | Static/Motion PASS Candidate、Master、Crop Map、Safe-area Contract、设备矩阵、DPI 与 Locale/字体缩放范围。 |
| 执行动作 | 生成并检查 Mobile Portrait/Landscape、Tablet Portrait/Landscape、窄/高/宽比例、系统安全区、不同 DPI、简繁体与字体放大；重新检查主体、地平线、文化元素、文字、按钮、朗读与手势区。 |
| 输出 | Runtime Crop/Variant Set、Device Adaptation Matrix、Screenshots/Recordings 与 PASS/NEEDS_REVISION。 |
| 负责人 | Visual Producer 与 UI/UX Reviewer；Accessibility 和 QA 提供设备验证。 |
| 必须读取的规范 | Visual Guidelines 的 Ratio、Mobile、Tablet、Responsive 与 Resolution Standards；Background Guidelines 的适配规则。 |
| 进入条件 | Stage 16 PASS 或 Static N/A；目标设备和比例矩阵已批准。 |
| 退出条件 | 所有要求的设备、方向、比例和文字条件均有 Evidence；无拉伸、错误裁切、模糊、遮挡或身份丢失。 |
| 强制 Gate | `YES — DEVICE_ADAPTATION_GATE`，Release Blocking。未完成手机、平板和不同屏幕比例检查时禁止发布。 |
| 失败后的返回路径 | 可裁切问题返回本 Stage；无法通过裁切修复时返回 Stage 06/07；Master 清晰度不足返回 Stage 09/10。 |

---

# 25. Stage 18 — Performance Optimization

| Field | Definition |
| --- | --- |
| 目标 | 在不破坏 Story、Journey Identity、可读性与 Accessibility 的前提下，使资源稳定运行。 |
| 输入 | Device Variant Set、Master、Motion Assets、目标平台、网络与低性能设备范围、加载/缓存 Contract。 |
| 执行动作 | 选择 AVIF/WebP/PNG/SVG 等适用格式；设置尺寸、压缩、DPI 与缓存；测量文件大小、下载、解码、内存、页面切换、帧率和重复解码；优化图层数量与动画成本。 |
| 输出 | Optimized Runtime Asset Set、Performance Measurements、Budget Result、Loading/Cache Strategy 与 Regression Risk。 |
| 负责人 | Performance Reviewer / Developer；Visual Architect 验证优化未破坏视觉意义。 |
| 必须读取的规范 | Visual Guidelines 的 Runtime Resolution/Asset Management；AI Image Generation Guide 的 Runtime Asset Standard；适用 Performance、Code 与 Platform 规范。 |
| 进入条件 | Stage 17 PASS；运行目标、测量方法和低性能设备定义明确。 |
| 退出条件 | 资源在目标预算内；清晰度、色彩、透明度和动画自然度未被破坏；低性能风险可降级。 |
| 强制 Gate | `YES — PERFORMANCE_GATE`，Release Blocking。未完成性能优化和低性能设备降级时禁止发布。 |
| 失败后的返回路径 | 编码/尺寸问题返回本 Stage；图层/动效成本过高返回 Stage 08/16 并优先静态；视觉方向本身不可运行返回 Stage 05。 |

---

# 26. Stage 19 — Static Fallback and Low-performance Degradation

| Field | Definition |
| --- | --- |
| 目标 | 确保动画关闭、Reduced Motion、低性能、加载失败或不支持环境仍拥有完整、高清、可理解体验。 |
| 输入 | Optimized Runtime Assets、Motion Decision、Static Master、设备/性能结果、Loading/Error Contract。 |
| 执行动作 | 输出高清静态、Reduced Motion、低性能、加载失败和不支持格式的降级资源；定义选择条件、切换、恢复、缓存与状态一致性；验证降级不丢失 Story、操作或完成状态。 |
| 输出 | Static Fallback Set、Fallback Selection Contract、Reduced Motion Evidence、Failure Recovery Evidence 与 PASS/NEEDS_REVISION。 |
| 负责人 | Visual Architect、Performance Reviewer、Accessibility Reviewer 与 Developer。 |
| 必须读取的规范 | Background Guidelines 的 Static Fallback、Visual Guidelines 的 Performance/Responsive、AI Image Generation Guide 的 Import/Runtime Requirements，以及适用 Accessibility/Performance 规范。 |
| 进入条件 | Stage 18 PASS；每个动态或高成本资源有可追踪 Static Master。 |
| 退出条件 | 所有动态资源拥有高清静态方案；低性能、Reduced Motion 和失败路径可自动或明确切换；核心流程不依赖动画。 |
| 强制 Gate | `YES — STATIC_FALLBACK_GATE`，Release Blocking。静态降级缺失、低清、版本错误或不能完成学习流程时禁止继续。 |
| 失败后的返回路径 | 静态 Master 不合格返回 Stage 06/09/10；选择逻辑问题返回 Performance/Code 实现阶段；再执行 Stage 17–19。 |

---

# 27. Stage 20 — IMAGE_QUALITY_GATE

| Field | Definition |
| --- | --- |
| 目标 | 由独立正式 Gate 判断同一 Candidate 的图片质量是否允许进入最终核对。 |
| 输入 | Stage 01–19 的完整 Artifact Chain、Optimized Assets、Fallback Set 与全部 Blocking Gate Evidence。 |
| 执行动作 | 使用真实存在且有效的 `IMAGE_QUALITY_GATE` 逐项审核；记录 Candidate ID、版本、Finding、Evidence、Reviewer 与 PASS/FAIL/BLOCKED。不得由本 Pipeline 自创或降低 Gate。 |
| 输出 | Versioned Image Quality Gate Result 与 Finding Return Map。 |
| 负责人 | Image Quality Gate Owner / Visual Reviewer；生成者不得成为唯一批准者。 |
| 必须读取的规范 | `IMAGE_QUALITY_GATE` 全文及其上游 Visual Constitution、Philosophy、Guidelines 和专项规范。 |
| 进入条件 | Stage 01–19 全部 PASS/N/A 合法且版本一致；正式 Gate 文件真实存在并有效。 |
| 退出条件 | `IMAGE_QUALITY_GATE = PASS`，Required Finding 为零，Evidence 可复核。 |
| 强制 Gate | `YES — IMAGE_QUALITY_GATE`，Release Blocking。文件缺失、状态无效或任一强制项失败时不得继续正式导入。 |
| 失败后的返回路径 | 按 Finding 返回 Stage 04–19 中拥有根因的最早阶段；修正后重跑所有受影响下游 Gate。 |

---

# 28. Stage 21 — VISUAL_CHECKLIST

| Field | Definition |
| --- | --- |
| 目标 | 确认正式规范、文件、Metadata、变体、Evidence 与禁止条件没有遗漏。 |
| 输入 | Image Quality Gate PASS Candidate、完整 Artifact Chain、Asset Metadata、Runtime Variants 与 Import Plan。 |
| 执行动作 | 使用真实存在且有效的 `VISUAL_CHECKLIST` 逐项核对；每项记录 PASS/FAIL/BLOCKED/N/A 与 Evidence；N/A 必须说明适用性依据。 |
| 输出 | Completed Visual Checklist、Finding List、Evidence Index 与 PASS/FAIL/BLOCKED。 |
| 负责人 | Visual Reviewer / QA Owner；Visual Producer 提供材料但不独立批准。 |
| 必须读取的规范 | `VISUAL_CHECKLIST` 全文、`IMAGE_QUALITY_GATE` 结果及全部适用上游 Visual Documentation。 |
| 进入条件 | Stage 20 PASS；Checklist 文件真实存在且与当前规范版本兼容。 |
| 退出条件 | Required Item 全部 PASS，FAIL/BLOCKED/空白为零，所有 N/A 合法。 |
| 强制 Gate | `YES — VISUAL_CHECKLIST_GATE`，Release Blocking。Checklist 失败或缺失时禁止进入正式版。 |
| 失败后的返回路径 | 返回 Checklist 指向的最早根因 Stage；Checklist 遗漏上游强制项时先遵守上游并修正 Checklist Owner 的正式文件。 |

---

# 29. Stage 22 — VISUAL_REVIEW_PROMPT

| Field | Definition |
| --- | --- |
| 目标 | 通过统一 Review 输入发现跨规范、跨页面、跨设备和跨 Journey 风险，同时保留人类最终责任。 |
| 输入 | Quality Gate PASS、Checklist PASS、Candidate、全分辨率文件、设备 Evidence、Metadata 与 Review Context。 |
| 执行动作 | 使用真实存在且有效的 `VISUAL_REVIEW_PROMPT` 执行 AI/人工 Review；验证 Prompt 输出引用真实规范和 Evidence；人工处置全部 Finding；禁止 AI 自动批准自身生成资源。 |
| 输出 | Visual Review Report、Finding Disposition、Human Decision、Residual Risk 与 PASS/FAIL/BLOCKED。 |
| 负责人 | Independent Visual Reviewer；Cultural、Copyright、UI、Learning、Audio、Accessibility、Performance Reviewer 按 Finding 复核。 |
| 必须读取的规范 | `VISUAL_REVIEW_PROMPT` 全文、Quality Gate、Checklist 与其引用的全部上游规范。 |
| 进入条件 | Stage 20–21 PASS；Review Prompt 真实存在、版本有效，Review 输入属于同一 Candidate。 |
| 退出条件 | 所有 Blocking/Major Finding 已关闭并有 Evidence；独立 Reviewer 给出 PASS。 |
| 强制 Gate | `YES — VISUAL_REVIEW_GATE`，Release Blocking。Review 失败、缺失或 Finding 未关闭时禁止进入正式版。 |
| 失败后的返回路径 | 按根因返回 Stage 03–21；任何资产变化使 Stage 20–22 的相关 PASS 失效并必须重跑。 |

---

# 30. Stage 23 — Import into Phoenix

| Field | Definition |
| --- | --- |
| 目标 | 只把已批准、已优化、可追踪的 Runtime Asset 导入正确目录和页面引用，不改变业务逻辑。 |
| 输入 | Stage 20–22 全部 PASS、Approved Runtime Asset Set、Metadata、Naming/Directory Plan、Fallback Contract 与目标 Branch/Commit。 |
| 执行动作 | 验证文件名、路径、格式、版本和 Metadata；导入运行时资源并建立引用；配置静态/Reduced Motion/低性能/加载失败变体；记录变更文件和目标 Commit。不得导入 Master、Review Candidate 或 Archive。 |
| 输出 | Import Record、Imported Asset Manifest、Code/Configuration Reference（如适用）、Target Commit 与 Rollback Map。 |
| 负责人 | Developer / Asset Integrator；Visual Architect 验证资产，Code/UI Owner 验证引用边界。 |
| 必须读取的规范 | Visual Guidelines 的 Naming/Directory/Metadata/Management；AI Image Generation Guide 的 Import Requirements；适用 Code、UI 与 Release 规范。 |
| 进入条件 | Quality Gate、Checklist、Review 均 PASS；版权、文化、设备、性能与 Fallback Evidence 完整。 |
| 退出条件 | 仅 Approved Runtime Assets 被引用；版本与 Metadata 正确；构建可定位资产；Rollback 路径明确。 |
| 强制 Gate | `YES — IMPORT_GATE`，Release Blocking。明显 AI 错误、版权不明、文化不足、影响阅读/按钮/朗读/学习、设备/性能/Fallback 未完成时禁止导入。 |
| 失败后的返回路径 | 命名/目录/引用问题返回本 Stage；资产本身变化返回对应 Stage 10–22 并使旧批准失效。 |

---

# 31. Stage 24 — Page-level QA

| Field | Definition |
| --- | --- |
| 目标 | 在真实页面、真实状态和目标设备上证明视觉与 Story、Learning、UI、Audio、Animation 和运行性能共同成立。 |
| 输入 | Imported Candidate、目标 Commit/Build、页面状态矩阵、设备矩阵、Fallback Contract、Gate/Checklist/Review Evidence。 |
| 执行动作 | 检查显示、清晰度、裁切、拉伸、文字、按钮、朗读控制、播放/暂停、Challenge 选择与重试、留下印象、盖章、地图/护照热点、Loading/Error、返回/重进、页面切换、缓存、闪屏、Reduced Motion、低性能降级、帧率和内存；执行相关回归。 |
| 输出 | Page-level QA Report、Screenshots/Recordings、Device Matrix、Regression Result、Defect List 与 PASS/FAIL/BLOCKED。 |
| 负责人 | QA Owner；UI、Learning、Audio、Visual、Animation、Accessibility、Performance Owner 按缺陷归属修正。 |
| 必须读取的规范 | Systems Lifecycle/Dependency、全部适用 Visual Documentation、页面相关 Story/Learning/UI/Audio/Accessibility/Performance/QA 规范。 |
| 进入条件 | Stage 23 PASS；可运行目标 Build 与同一 Commit 可验证。 |
| 退出条件 | 所有目标页面、状态、设备、比例与降级路径通过；无阻断阅读、操作、朗读、学习或性能的缺陷。 |
| 强制 Gate | `YES — PAGE_LEVEL_QA_GATE`，Release Blocking。导入后未完成页面级 QA 时不得把素材完成视为功能完成。 |
| 失败后的返回路径 | 资产缺陷返回 Stage 10–22；裁切/安全区返回 Stage 06/07/17；动态返回 Stage 08/16/19；集成问题返回 Stage 23；业务逻辑缺陷返回对应 System，不由 Visual 改写规则。 |

---

# 32. Stage 25 — Official Release Eligibility

| Field | Definition |
| --- | --- |
| 目标 | 判断 Visual Candidate 是否具备进入正式版的资格，而不是自行执行 Merge 或 Release。 |
| 输入 | Page-level QA PASS、完整 Artifact Chain、目标 Commit、全部专业 Gate、Release Evidence 与授权范围。 |
| 执行动作 | 核对 Candidate/Asset/Story/Journey/Commit 版本；确认 AI Error、Culture、Copyright、Journey、Style、Motion、Device、Performance、Fallback、Quality Gate、Checklist、Review 与 Page QA 均 PASS；确认没有过期批准或未关闭 Finding。 |
| 输出 | `ELIGIBLE_FOR_RELEASE` 或 `NOT_ELIGIBLE_FOR_RELEASE` Record、Evidence Index 与 Release Handoff。 |
| 负责人 | Release Owner 汇总；Visual、QA 与各专业 Gate Owner 保留各自批准权。 |
| 必须读取的规范 | Systems Lifecycle/Priority、全部适用 Visual Gate Evidence 与真实存在的 Release 规范。 |
| 进入条件 | Stage 24 PASS；目标 Commit 与全部 Evidence 一致；具有当前 Release Authorization。 |
| 退出条件 | 只有全部强制项 PASS 时可标记 `ELIGIBLE_FOR_RELEASE`；该状态仍不等于已合并或已发布。 |
| 强制 Gate | `YES — RELEASE_ELIGIBILITY_GATE`。Quality Gate、Checklist、Review 任一失败，或页面 QA/设备/性能/降级未完成时禁止进入正式版。 |
| 失败后的返回路径 | 返回拥有最早失败根因的 Stage；授权或 Release Evidence 缺失时保持 `NOT_ELIGIBLE_FOR_RELEASE`，不得自行合并 `main`。 |

---

# 33. Asset-specific Routing Requirements

所有资源执行同一 25 阶段主流程。以下差异只增加检查，不减少 Gate。

| Asset scope | Mandatory additional focus |
| --- | --- |
| 普通 Journey | 真实城市与地方生活、具体空间和材料、非旅游海报、跨 Journey 构图差异 |
| 特别 Journey | 原典/文化精神、合理想象边界、非网游/欧美奇幻/紫黑雾模板、神秘感来自文学与空间 |
| 故事背景 | Story Scene、人物行动空间、阅读节奏、正文安全区、朗读控制 |
| 动态背景 | Motion Intent、自然度、循环、Reduced Motion、帧率、高清静态降级 |
| 静态背景 | 空间深度、光线、裁切、长期耐读性；不得因静态而降低设备或性能检查 |
| 首页视觉 | Phoenix 品牌身份、入口层级、首次加载、导航清晰、不得把营销冲击置于阅读价值之上 |
| 世界地图 | 地理关系、路径/落点真实性、缩放层级、热点与标签安全、地图可用性 |
| 护照 | Journey Identity、热点、旅程名、盖章关系、可读性、完成状态与地图层次 |
| 生词页 | 单词、词性、母语与英语辅助信息优先；卡片、朗读按钮和点词区域不得被背景干扰 |
| 发现页 | 文化资料与 Story 区分、来源内容优先、朗读状态和探索操作安全 |
| 挑战页 | 题目、至少五个选项、正确/错误/重试/跳转状态清晰；视觉不得暗示答案或干扰作答 |
| 留下印象页 | Memory Anchor 与 Story Version 一致；视觉保存故事印象，不把奖励或总结当作文学结尾 |
| 盖章页 | 盖章是 Journey Completion 表达而非 Story 结尾；触发、保留、Reduced Motion 与静态状态清晰 |
| Banner | 信息层级、横向裁切、文字留白、缩略状态和品牌一致性 |
| Loading | 等待状态真实、无虚假进度、低刺激、加载失败与重试可见 |
| Splash | 启动速度、品牌识别、系统安全区、不同比例、不过度动画 |
| UI 插画 | 解释或支持状态，不伪装成交互控件，不改变 UI Business Logic |
| Icon | 小尺寸可辨认、语义一致、光学对齐、对比和无颜色唯一表达；AI 生成结果须转换为可控正式资产并复核 |
| 其他 AI 原创资源 | 明确用途、Owner、消费者、来源、商业使用、运行格式和适用 Gate；不得以“其他”降低标准 |

---

# 34. Mandatory Failure Return Matrix

| Failure | Immediate decision | Earliest required return |
| --- | --- | --- |
| 需求或授权不清 | `BLOCKED` | Stage 01 |
| Documentation 缺失或冲突 | `BLOCKED` | Stage 02 / Documentation Owner |
| Story、Journey 或页面版本不一致 | `BLOCKED` | Stage 03 / 对应 System Owner |
| 文化研究不足 | `NEEDS_REVISION` | Stage 04 |
| 视觉方向模板化或与 Phoenix 不符 | `NEEDS_REVISION` | Stage 05 |
| 构图、层次、透视或裁切根本失败 | `NEEDS_REVISION` | Stage 06 |
| 文字、按钮、朗读或交互安全区失败 | `BLOCKED` | Stage 06–07 |
| 动态没有必要、无法自然或无法降级 | `NEEDS_REVISION` | Stage 08；改用高清静态 |
| Prompt 含无授权参考、模仿或文化模糊指令 | `BLOCKED` | Stage 04/09 |
| 明显 AI 错误 | `REJECTED` 或 `NEEDS_REVISION` | Stage 09–11；禁止导入 |
| 文化真实性不足 | `NEEDS_REVISION` | Stage 04–12 |
| 版权或商业使用无法确认 | `BLOCKED/REJECTED` | Stage 04/09/10/13；禁止导入 |
| Journey 或 Story 不一致 | `NEEDS_REVISION` | Stage 03/05/14 |
| Phoenix 风格或跨 Journey 差异不足 | `NEEDS_REVISION` | Stage 05/06/15 |
| 动画闪烁、眩晕、掉帧或循环明显 | `BLOCKED` | Stage 08/16；改用高清静态 |
| 手机、平板或比例失败 | `BLOCKED` | Stage 06/07/17 |
| 性能预算或低性能运行失败 | `BLOCKED` | Stage 08/16/18 |
| 静态/Reduced Motion/失败降级缺失 | `BLOCKED` | Stage 19 |
| IMAGE_QUALITY_GATE 失败或缺失 | `BLOCKED` | Finding 指向的最早 Stage |
| VISUAL_CHECKLIST 失败或缺失 | `BLOCKED` | Finding 指向的最早 Stage |
| VISUAL_REVIEW_PROMPT Review 失败或缺失 | `BLOCKED` | Finding 指向的最早 Stage |
| 导入路径、版本或引用错误 | `NEEDS_REVISION` | Stage 23 |
| 页面级 QA 失败 | `BLOCKED` | 缺陷所属最早 Stage |
| Release Evidence 或授权不完整 | `NOT_ELIGIBLE_FOR_RELEASE` | Stage 25 / Release Owner |

返回上游后：

1. 立即停止未执行的下游阶段。
2. 标记所有受变更影响的旧 PASS 为失效。
3. 保留旧 Evidence，不得静默覆盖历史。
4. 建立新 Asset Version 或 Candidate Revision。
5. 从最早根因 Stage 重新执行。
6. 重新通过全部受影响 Gate、Checklist、Review 与页面级 QA。

---

# 35. Permanent Import and Release Prohibitions

以下任一情况存在时，视觉资源禁止导入 Phoenix：

- 存在明显 AI 人体、建筑、器物、文字、透视、光影、倒影、自然或生成纹理错误。
- 版权、商业使用、输入参考、肖像、商标或来源无法确认。
- 文化真实性不足，或普通 Journey 的地方生活、特别 Journey 的原典精神未通过审核。
- Visual 与 Approved Story Contract、Journey Identity 或页面用途不一致。
- 影响文字阅读、按钮识别、朗读控制、Challenge 操作、留下印象或学习流程。
- 手机、平板或关键屏幕比例尚未完成资产级适配。
- 性能、静态降级、Reduced Motion 或加载失败回退尚未完成。
- `IMAGE_QUALITY_GATE`、`VISUAL_CHECKLIST` 或 `VISUAL_REVIEW_PROMPT` 不存在、状态无效、版本不兼容或结果不是 PASS。

以下任一情况存在时，视觉资源禁止进入正式版：

- 动态效果不自然且仍被启用；此时必须使用经审核的高清静态方案。
- 动画闪烁、造成眩晕、掉帧或循环接缝/节奏明显。
- 手机、平板、横竖屏或不同屏幕比例检查未完成。
- 性能优化、低性能设备降级或 Reduced Motion 未完成。
- Quality Gate、Checklist、Review 任一失败、缺失或 Evidence 过期。
- 导入后的页面级 QA 未完成或失败。
- 目标 Build、Commit、Asset Version、Story Version 或 Evidence 不一致。
- Release Authorization 缺失。

任何总分、视觉偏好、排期、已投入成本、代码已引用、Preview 可见或用户暂未投诉，都不能覆盖上述禁止条件。

---

# 36. Page-level QA Minimum Coverage

页面级 QA 至少覆盖：

- 目标页面首次进入、返回、重进、刷新和状态恢复。
- Story → 生词 → 发现 → 挑战 → 留下印象 → 盖章的适用视觉衔接。
- 普通 Journey 与特别 Journey 的入口、运行和完成状态。
- 首页、世界地图、护照、Banner、Loading 与 Splash 的适用路径。
- 简体、繁体、辅助语言和字体放大后的文字安全。
- 主按钮、返回、播放、暂停、朗读、选项、重试、地图/护照热点与盖章操作。
- Mobile Portrait/Landscape 与 Tablet Portrait/Landscape。
- 不同屏幕比例、DPI、刘海/Dynamic Island、状态栏与底部手势区。
- 动画开启、Reduced Motion、低性能降级、静态降级与不支持格式。
- 正常网络、慢速、加载失败、重试、缓存命中与资源恢复。
- 清晰度、裁切、拉伸、闪屏、跳帧、掉帧、循环、内存与重复解码。
- 旧资源不再被引用，Archive 不参与运行。

页面级 QA PASS 必须引用同一目标 Commit 和 Build。仅检查 Master、设计稿、截图或单一设备不能替代页面级 QA。

---

# 37. AI and Developer Execution Protocol

未来 AI 或开发者执行本 Pipeline 时必须：

1. 锁定 Branch、Commit、Candidate ID、Asset ID、Journey ID 与 Story Version。
2. 按第 2 章完成 Documentation Reading Record。
3. 从 Stage 01 开始，不得因已有 Candidate 而倒推 Requirement 或研究。
4. 每个 Stage 只消费已 `PASSED` 的上游输出。文中历史性短语“Gate PASS”只表示 Gate 的 `PASSED` 状态，不是第二个状态值。
5. 每个输出记录 Owner、Version、Date、Evidence Location 与 Result。
6. 不用对话记忆、缩略图、代码文件存在或旧截图代替正式 Evidence。
7. 不让生成 AI 自动批准自己的素材。
8. 不在 Visual Pipeline 中修改 Story、Learning、UI、Audio、QA 或 Release Rule。
9. 任一强制 Gate 失败时立即停止下游并执行 Return Path。
10. 资产发生实质变化时使受影响下游 PASS 失效。
11. 只有 Stage 20–22 PASS 后才允许导入。
12. 只有 Stage 24 PASS 后才可请求 Release Eligibility。
13. 只有 Stage 25 输出 `ELIGIBLE_FOR_RELEASE`，才可交给 Release System；不得自行合并或发布。

执行记录可以存入项目批准的 Evidence 载体，但不得把本文件改写成单一 Candidate 的工作表。本文件是正式流程规范，不是一次性模板。

---

# 38. Pipeline Completion Criteria

一个 Visual Candidate 只有同时满足以下条件，才算完成本 Pipeline：

- Stage 01–25 全部具有同一 Candidate 的合法 PASS 或明确允许的 N/A。
- 明显 AI Error 为零。
- Cultural Authenticity PASS。
- Copyright and Commercial-use PASS。
- Journey Consistency 与 Visual Consistency PASS。
- 动态自然，或已经替换为合格高清静态方案。
- 闪烁、眩晕、掉帧与明显循环问题为零。
- 手机、平板、横竖屏与批准比例全部 PASS。
- Performance、Low-performance、Reduced Motion 与 Static Fallback 全部 PASS。
- `IMAGE_QUALITY_GATE`、`VISUAL_CHECKLIST` 与 `VISUAL_REVIEW_PROMPT` 全部 PASS。
- Import Record 与页面级 QA PASS。
- 目标 Commit、Build、Asset、Story、Journey 与 Evidence Version 一致。
- Release Owner 输出 `ELIGIBLE_FOR_RELEASE`。

Pipeline Completion 只表示视觉资源具备交付资格。

它不自动表示：

- 产品功能已完成。
- PR 已合并。
- `main` 已更新。
- Preview 或正式版已发布。

---

# 39. Permanent Rule

Phoenix Visual Production 永远遵循：

> Story Before Visual. Learning Before Decoration. Reading Before Effects. Authenticity Before Style. Originality Before Convenience.

每一个视觉资源必须从正确需求和真实内容开始，经研究、设计、构图、安全区、静态/动态选择、原创生产、AI Error、文化、版权、一致性、动画、设备、性能和降级检查，再通过独立 Quality Gate、Checklist 与 Review。

通过后才允许导入 Phoenix。

导入后仍必须完成页面级 QA。

只有同一 Candidate 的全部强制 Evidence 通过，才允许进入正式版。
