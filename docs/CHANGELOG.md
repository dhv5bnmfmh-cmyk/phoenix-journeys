# Phoenix Changelog

> 本文件记录用户可感知功能、开发流程、内容规模与长期规则变化。  
> 格式参考 Keep a Changelog；PR 与 commit 是发布证据，不作为运行时配置。

## [Unreleased]

### Dynamic Background System 1.0.0

#### Added

- 新增全应用 `PhoenixDynamicBackground`，覆盖启动、探索、护照、跟读、我的以及完整 Journey 流程。
- 新增 `PhoenixAmbientOverlay`，在保留现有高质量目的地图片的前提下加入克制的雾光、景深和前景漂移。
- 新增原创程序化视觉系统：远景天空、中景层次、前景轮廓、水面微光与 Journey 专属确定性配色。
- 新增全局“减少动态效果”设置，使用 SharedPreferences 保存并在刷新、返回页面后恢复。
- 新增系统 reduced-motion、`motion=off` 静态降级、`motion=on` QA 强制模式与窄屏高密度设备保护。
- 新增动态背景 Widget 测试，覆盖渲染、按钮可操作、设置持久化与 Journey 配色差异。
- 新增 `VISUAL_BACKGROUND_SYSTEM.md`，记录原创来源、技术方案、动态标准、降级策略与 QA 清单。

#### Changed

- Phoenix 所有页面共享同一轻量电影环境层，相同页面类型保持统一，每个 Journey 保留自己的视觉配色与现有目的地素材。
- 背景动态使用 Flutter CustomPainter、38–42 秒长周期循环、RepaintBoundary 与 IgnorePointer，不增加第三方视觉或动画依赖。
- 慢网络和图片加载失败时，程序化静态帧立即可用，现有图片错误回退继续生效，不出现黑屏。
- 全局动态开关改为无 Overlay 依赖的可访问性语义按钮，不影响启动、导航、朗读和测试环境。

#### Copyright

- 本次新增视觉全部由 Phoenix 项目程序化原创生成，不包含网络下载素材、品牌、Logo、受保护角色或特定艺术家风格模仿。

### Story System Version 1.0.0

#### Added

- 新增 `docs/README.md`，作为全项目文档导航与优先级入口。
- 建立 `docs/story/` Phoenix Story System：
  - `README.md`
  - `STORY_GUIDELINES.md`
  - `STORY_STYLE_GUIDE.md`
  - `STORY_QUALITY_GATE.md`
  - `STORY_REVIEW_PROMPT.md`
  - `STORY_GENERATION_GUIDE.md`
  - `STORY_LIBRARY_RULES.md`
  - `SPECIAL_JOURNEY_GUIDE.md`
  - `CONTENT_VARIETY_GUIDE.md`
- 将 41 篇正式故事整理为人物、叙事任务、情绪、节奏、文化、高潮、结局与主题矩阵。
- 建立十道 Story 发布 Gate：故事结构、角色、文学质量、阅读体验、学习价值、Phoenix 流程、文化真实性、故事差异化、AI 痕迹与最终评分。
- 新增固定 Story Review Prompt，以出版社总编辑、儿童文学编辑、语言学家、HSK／TOCFL 教材专家、文化编辑、产品经理与 UX 设计师共同审核。
- 新增 Story System 文档契约测试与运行时测试。
- 为 5 个特别 Journey 增加独立中拼越英高级短文扩展语料。

#### Changed

- 任何 AI 开发、修改、审核或生成故事前，必须完整读取 `docs/story/` 全部规范。
- 故事工作必须同时检查整个故事库与全部 Phoenix Lv.1–10 短文。
- 全部 9 个特别 Journey 统一进入特别短文扩展链。
- Story、单词、Discovery、Challenge、回忆与盖章纳入同一出版单元审核。

#### Quality Standard

- Story 发布要求：severe = 0、medium = 0。
- 任一 Story Gate 未通过即禁止 Preview 发布。
- 41 Journey × 10 Levels 必须全部达到 `approved`。

### Development Governance

#### Added

- 将 `AI_DEVELOPMENT_GUIDE.md` 升级为 Phoenix 全项目最高级开发规范入口。
- 固化 `Review → Plan → Implement → QA → Challenge → Preview → Merge` 开发闭环。
- 建立 UI、内容、故事、产品原则、Review Checklist、Roadmap、TODO 与 Changelog 文档体系。
- 建立五星内容与开发质量评分体系、一票否决项和正式版发布门槛。
- 建立故事、图片、动画、UI、代码、学习价值、AI 痕迹、重复率、HSK 与 TOCFL 审核流程。
- 新增 `LITERARY_QUALITY.md`、正式编辑层与 `JourneyLiteraryQualityAuditor`。

#### Changed

- 统一公开 Journey 流程为“故事 → 单词 → 发现 → 挑战 → 回忆 → 完成”。
- “思考／表达”只可作为兼容数据或独立 AI 能力存在，不得恢复为主流程步骤。
- 跟读训练使用独立导航入口。
- Founder Preview 至少达到四星，合并 `main` 必须达到五星并获得 Founder 明确批准。
- 全故事库从统一第二人称导览升级为人物驱动叙事。

## [PR #140] - 2026-08-01

### Added

- 新增 5 个完整普通 Journey：都江堰水利工程、大足石刻、武当山、福建土楼、沈阳故宫。
- 建立 Phoenix Story System v1.0.0。
- 建立 Phoenix Dynamic Background System v1.0.0。
- 全页面接入原创程序化环境背景、克制动态、静态降级和减少动态效果设置。

### Quality Snapshot

- 普通 Journey：32
- 特别 Journey：9
- Journey 总数：41
- Phoenix Level：10
- 检查组合：410
- 通过：410
- 需要修改：0
- 禁止发布：0
- 最低分：100
- 平均分：100.0

### Release Evidence

- PR：`#140`
- 状态：Draft、未合并 `main`
- Preview 使用 PR 独立 Cloudflare Worker，并绑定真实 head commit。

## Historical Milestones

### PR #132

- 记录为新的稳定开发基线。
- 未来工作必须从最新稳定 `main` 或 Founder 指定体验基线创建分支。
- 禁止直接在 `main` 开发。

### PR #129

- 建立每个 PR 的隔离 Worker 与标准全开放 Preview 链接。
- Preview 使用 feature head commit，而不是 pull request merge ref。
- 部署验证成功后才发布链接。
- PR 关闭后清理对应 Preview Worker。

### PR #118

- 确立稳定 Journey 主流程：故事、单词、发现、挑战、回忆、完成。
- 从主流程移除“思考／表达”。
- 将 HSK／TOCFL 选择从阻塞弹窗移向设置与统一等级体系。
- 建立三连挑战方向与特别 Journey 接入。
- 修复恢复 Discovery 时不应未经用户操作自动朗读的规则。

## Changelog Maintenance

- 新增、修改或删除 Journey 时记录数量与品质快照。
- Story System、Dynamic Background System、矩阵、Gate 或固定审核 Prompt 变化必须记录。
- 用户可感知 UI、学习规则、奖励、访问权限或隐私变化必须记录。
- 仅内部重构且无行为变化时，可在 PR 说明，不必制造版本条目。
- 已完成 TODO 应从 `TODO.md` 移除，并在本文件留下结果。
- 不得修改历史条目来掩盖旧行为；需要修正时新增“Corrected”说明。
