# Phoenix Changelog

> 本文件记录用户可感知功能、开发流程、内容规模与长期规则变化。  
> 格式参考 Keep a Changelog；PR 与 commit 是发布证据，不作为运行时配置。

## [Unreleased]

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
- 新增 AI 故事生成前重复检查、全库维护规则、特别 Journey 原典与改编边界。
- 新增 Story System 文档契约测试，检查九份规范、版本、永久预读规则、十道 Gate 与 41 篇矩阵。
- 新增 Story System 运行时测试，检查 9 个特别 Journey 的分类、专属扩展、多语言对齐和普通城市 filler 隔离。
- 为 `changan-last-bus`、`tide-letter`、`arcade-lost-property`、`tea-horse-echo`、`ice-city-star-map` 增加独立中拼越英高级短文扩展语料。

#### Changed

- 任何 AI 开发、修改、审核或生成故事前，必须完整读取 `docs/story/` 全部规范。
- 故事工作不再只审核单篇，必须同时检查整个故事库与全部 Phoenix Lv.1–10 短文。
- 全故事库被定义为一本持续出版的作品，而不是互相独立的小作文集合。
- 全部 9 个特别 Journey 统一进入特别短文扩展链，不再有 5 个特别 Journey 落入普通城市扩展器。
- Story、单词、Discovery、Challenge、回忆与盖章被纳入同一出版单元审核。
- `ROADMAP.md` 与 `TODO.md` 已按 Story System v1.0.0 更新。

#### Quality Standard

- Story 发布要求：severe = 0、medium = 0。
- 任一 Story Gate 未通过即禁止 Preview 发布。
- 修改一篇故事后必须检查相邻故事、同城市、同类型、同主题与完整矩阵。
- 修改造成其他故事显得相似时，必须同步调整相关故事。
- 41 Journey × 10 Levels 仍必须全部达到 `approved`。

### Previous Unreleased Work

#### Added

- 将 `AI_DEVELOPMENT_GUIDE.md` 升级为 Phoenix 全项目最高级开发规范入口。
- 增加项目使命、目标用户、学习理念、产品定位与长期规划。
- 固化 `Review → Plan → Implement → QA → Challenge → Preview → Merge` 开发闭环。
- 增加故事、短文、发现、挑战、生词、图片与动画统一规范。
- 增加五星内容与开发质量评分体系、一票否决项和正式版发布门槛。
- 增加故事、图片、动画、UI、代码、学习价值、AI 痕迹、重复率、HSK 与 TOCFL 审核流程。
- 在主指南内增加 110 项编号 Review Checklist。
- 增加“任务完成后自动 Review、自动 QA、自动寻找提升点”的正式规则，并限制在批准任务范围内持续优化。
- 建立完整 AI Development Guide 文档体系：
  - `AI_DEVELOPMENT_GUIDE.md`
  - `ROADMAP.md`
  - `TODO.md`
  - `UI_GUIDELINES.md`
  - `STORY_GUIDELINES.md`
  - `CONTENT_QUALITY.md`
  - `REVIEW_CHECKLIST.md`
  - `PRODUCT_PRINCIPLES.md`
  - `CHANGELOG.md`
- 增加 AI 开发读取顺序、决策优先级、分支、提交、Preview、验证和完成定义。
- 增加 UI、朗读、地图、护照、键盘、图片、简繁和移动端长期契约。
- 增加普通与特别 Journey 的基础内容包、来源、多语言与等级适配规范。
- 增加内容品质 Gate、Lv.1–10 长度表、挑战奖励规则和发布证据要求。
- 增加结构化 Roadmap、可执行 TODO 与合并前 Review Checklist。
- 新增 `LITERARY_QUALITY.md`，将人物、目标、冲突、情绪曲线、高潮、结尾、年龄适配与全库差异化写入正式标准。
- 新增正式编辑层，为 32 个普通 Journey 与 9 个特别 Journey 注册独立主角、叙事模式、情绪曲线和结尾模式。
- 新增 `JourneyLiteraryQualityAuditor`，自动检查通用开场、保护式结尾、角色建立、直接人物声音、叙事模式、结尾模式、AI 固定句式与跨故事相似度。
- 新增全库文学质量测试，要求 41 个运行时 Journey 全部拥有正式编辑稿、四段故事与四组中拼越英阅读支持。

#### Changed

- 将旧的英文产品原则扩展并整理为中文长期规范。
- 统一产品访问规则：免费 Explorer 每日上午与下午各一次普通 Journey；付费 Explorer 普通 Journey 无次数限制；开发 Preview 全开放。
- 明确公开 Journey 流程固定为“故事 → 单词 → 发现 → 挑战 → 回忆 → 完成”。
- 明确“思考／表达”只可作为兼容数据或独立 AI 能力存在，不得恢复为主流程步骤。
- 明确跟读训练使用独立导航入口。
- 删除规范中的重复规则，改用专项文件和交叉引用维护。
- 明确 Founder Preview 至少达到四星，合并 `main` 必须达到五星且获得 Founder 明确批准。
- 将全故事库从统一第二人称文化导览结构升级为人物驱动叙事；每篇拥有地点专属任务、冲突、行动变化和可回收结尾。
- 普通 Journey 不再默认以时间／天气进入、以遗产保护升华；保护主题只在与具体人物行动相关时使用。
- 特别 Journey 不再统一依赖“神秘物件出现 → 追踪异常 → 天亮消失”，改用身份、信任、档案、伦理、家庭、版权与公共记忆等不同叙事引擎。
- 颐和园 Phoenix Lv.1–10 统一从正式编辑母版适配，低等级不再静默回退到旧导览稿。
- 修正一批第六批 Journey 词语的机械词性标注，例如“灌溉、监测、修复、融合”等按真实用法标为动词。

#### Runtime Impact

- Flutter 运行目录会为全部 41 个 Journey 应用正式编辑稿。
- Story 按 Phoenix Lv.1–10 自适应，原有单词、发现、挑战、回忆、完成、地图、护照与盖章流程不变。
- 原始来源绑定按 section 顺序保留；新增人物与情节用于学习叙事，不伪造历史人物、日期或机构事实。
- 文学质量 Gate、Story Quality Gate 与原有内容质量 Gate 同时生效。

## [PR #140] - 2026-07-31

### Added

- 新增 5 个完整普通 Journey：
  - 都江堰水利工程
  - 大足石刻
  - 武当山
  - 福建土楼
  - 沈阳故宫
- 每个新 Journey 接入故事、单词、发现、挑战、回忆、完成、目录、地图、护照、背景、词库、来源与品质检查。
- 新增独立地理节点与来源绑定。

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

- 起始发布证据 commit：`24068c3cb7a06f5e1d05d4ad0ae7ef168f09b5dd`
- PR：`#140`
- 状态：Draft、未合并 `main`
- Preview 使用 PR 独立 Cloudflare Worker。

## Historical Milestones

### PR #132

- 记录为新的稳定开发基线。
- 确立未来工作必须从最新稳定 `main` 或 Founder 指定体验基线创建分支。
- 继续禁止直接在 `main` 开发。

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
- Story System 版本、矩阵、Gate 或固定审核 Prompt 变化必须记录。
- 用户可感知 UI、学习规则、奖励、访问权限或隐私变化必须记录。
- 仅内部重构且无行为变化时，可在 PR 说明，不必制造版本条目。
- 已完成 TODO 应从 `TODO.md` 移除，并在本文件留下结果。
- 不得修改历史条目来掩盖旧行为；需要修正时新增“Corrected”说明。
