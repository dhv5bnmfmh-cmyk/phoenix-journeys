# Phoenix Changelog

> 本文件记录用户可感知功能、开发流程、内容规模与长期规则变化。  
> 格式参考 Keep a Changelog；PR 与 commit 是发布证据，不作为运行时配置。

## [Unreleased]

### Added

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

### Changed

- 将旧的英文产品原则扩展并整理为中文长期规范。
- 统一产品访问规则：免费 Explorer 每日上午与下午各一次普通 Journey；付费 Explorer 普通 Journey 无次数限制；开发 Preview 全开放。
- 明确公开 Journey 流程固定为“故事 → 单词 → 发现 → 挑战 → 回忆 → 完成”。
- 明确“思考/表达”只可作为兼容数据或独立 AI 能力存在，不得恢复为主流程步骤。
- 明确跟读训练使用独立导航入口。
- 删除规范中的重复规则，改用专项文件和交叉引用维护。
- 明确 Founder Preview 至少达到四星，合并 `main` 必须达到五星且获得 Founder 明确批准。
- 将全故事库从统一第二人称文化导览结构升级为人物驱动叙事；每篇拥有地点专属任务、冲突、行动变化和可回收结尾。
- 普通 Journey 不再默认以时间／天气进入、以遗产保护升华；保护主题只在与具体人物行动相关时使用。
- 特别 Journey 不再统一依赖“神秘物件出现 → 追踪异常 → 天亮消失”，改用身份、信任、档案、伦理、家庭、版权与公共记忆等不同叙事引擎。
- 颐和园 Phoenix Lv.1–10 统一从正式编辑母版适配，低等级不再静默回退到旧导览稿。
- 修正一批第六批 Journey 词语的机械词性标注，例如“灌溉、监测、修复、融合”等按真实用法标为动词。

### Runtime Impact

- Flutter 运行目录现在会为全部 41 个 Journey 应用正式编辑稿。
- Story 仍按 Phoenix Lv.1–10 自适应，原有生词、发现、挑战、回忆、完成、地图、护照与盖章流程不变。
- 原始来源绑定按 section 顺序保留；新增人物与情节用于学习叙事，不伪造历史人物、日期或机构事实。
- 文学质量 Gate 与原有内容质量 Gate 同时生效；任何 severe 或 medium 文学问题都会阻止正式版发布。

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
- 从主流程移除“思考/表达”。
- 将 HSK / TOCFL 选择从阻塞弹窗移向设置与统一等级体系。
- 建立三连挑战方向与特别 Journey 接入。
- 修复恢复 Discovery 时不应未经用户操作自动朗读的规则。

## Changelog Maintenance

- 新增、修改或删除 Journey 时记录数量与品质快照。
- 用户可感知 UI、学习规则、奖励、访问权限或隐私变化必须记录。
- 仅内部重构且无行为变化时，可在 PR 说明，不必制造版本条目。
- 已完成 TODO 应从 `TODO.md` 移除，并在本文件留下结果。
- 不得修改历史条目来掩盖旧行为；需要修正时新增“Corrected”说明。
