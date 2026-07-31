# Phoenix Changelog

> 本文件记录用户可感知功能、开发流程、内容规模与长期规则变化。  
> 格式参考 Keep a Changelog；PR 与 commit 是发布证据，不作为运行时配置。

## [Unreleased]

### Added

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

### Changed

- 将旧的英文产品原则扩展并整理为中文长期规范。
- 统一产品访问规则：免费 Explorer 每日上午与下午各一次普通 Journey；付费 Explorer 普通 Journey 无次数限制；开发 Preview 全开放。
- 明确公开 Journey 流程固定为“故事 → 单词 → 发现 → 挑战 → 回忆 → 完成”。
- 明确“思考/表达”只可作为兼容数据或独立 AI 能力存在，不得恢复为主流程步骤。
- 明确跟读训练使用独立导航入口。
- 删除规范中的重复规则，改用专项文件和交叉引用维护。

### Runtime Impact

- 本次文档建设不改变 Flutter 或 Worker 运行行为。
- 后续代码若与规范不一致，必须通过独立任务、测试和迁移逐项修正，不能假装文档修改已自动完成产品实现。

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
