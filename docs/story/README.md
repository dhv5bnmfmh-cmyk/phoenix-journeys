# Phoenix Story System

> Story System Version：`1.0.0`  
> 状态：正式版强制规范  
> 适用范围：故事母版、Phoenix Lv.1–10 短文、普通 Journey、特别 Journey、Discovery、挑战语境、回忆与盖章  
> 当前基线：32 个普通 Journey、9 个特别 Journey、41 篇正式母版、410 个等级检查组合  
> 最后整理：2026-08-01

Phoenix Story System 把整个故事库视为一本持续出版的作品，而不是 41 篇互不相干的小作文。任何 AI 在开发、修改、审核或生成故事前，必须完整读取本目录全部文件，再读取当前故事数据、等级运行时、来源、测试与 Preview。

## 文件职责

| 文件 | 负责内容 | 什么时候读取 |
| --- | --- | --- |
| `STORY_GUIDELINES.md` | 单篇故事、学习闭环、普通与特别 Journey 的完整规格 | 所有故事任务第一轮必读 |
| `STORY_STYLE_GUIDE.md` | Phoenix 的文学声音、画面、节奏、留白与自然中文 | 写作、改写、翻译、润色时必读 |
| `STORY_QUALITY_GATE.md` | 十道发布 Gate、阻断条件、评分与证据 | 审核、提交、Preview 前必读 |
| `STORY_REVIEW_PROMPT.md` | 固定总编辑审核 Prompt 与反复修改流程 | 所有 AI 审核故事时原样执行 |
| `STORY_GENERATION_GUIDE.md` | AI 生成前检查、写作步骤、等级与学习页面联动 | 新增或重写故事时必读 |
| `STORY_LIBRARY_RULES.md` | 作品集层面的平衡、重复率、世界观与维护规则 | 修改任一故事及批量扩张时必读 |
| `SPECIAL_JOURNEY_GUIDE.md` | 古典、志怪、传奇、神话、民间与特殊文体改编边界 | 所有特别 Journey 任务必读 |
| `CONTENT_VARIETY_GUIDE.md` | 人物、情绪、剧情、文化、节奏、结局与主题矩阵 | 立项、生成、全库复审时必读 |

## Story System 内部优先级

1. `STORY_QUALITY_GATE.md` 的发布阻断规则
2. `STORY_LIBRARY_RULES.md` 的全库一致性与差异化规则
3. `STORY_GUIDELINES.md` 的完整内容规格
4. `SPECIAL_JOURNEY_GUIDE.md` 的原典与类型边界
5. `STORY_STYLE_GUIDE.md` 的文学表达规则
6. `CONTENT_VARIETY_GUIDE.md` 的矩阵与配额检查
7. `STORY_GENERATION_GUIDE.md` 的生产流程
8. `STORY_REVIEW_PROMPT.md` 的审核执行文本

上级项目规则仍以 Founder 最新决定、`../AI_DEVELOPMENT_GUIDE.md` 和 `../PRODUCT_PRINCIPLES.md` 为先。

## 固定读取顺序

```text
story/README.md
→ STORY_GUIDELINES.md
→ STORY_STYLE_GUIDE.md
→ STORY_LIBRARY_RULES.md
→ CONTENT_VARIETY_GUIDE.md
→ SPECIAL_JOURNEY_GUIDE.md
→ STORY_GENERATION_GUIDE.md
→ STORY_REVIEW_PROMPT.md
→ STORY_QUALITY_GATE.md
→ 当前 41 篇故事与 410 个等级短文
→ 来源、Discovery、挑战、回忆、测试与 Preview
```

不得只读一份文件后开始写作。

## 当前真实内容结构

- 每篇正式母版有 4 个 story section 与 4 组中、拼音、越南语、英语阅读支持。
- 运行时由 Phoenix Lv.1–10 重组为 1 或 2 段，长度从 150 至 900 个中文字符。
- 每篇注册独立主角、叙事模式、情绪曲线与结尾模式。
- Story 负责人物、行动、冲突、选择与余韵。
- Discovery 负责来源、年代、技术、文化解释与事实边界。
- 单词来自真实 Story 或 Discovery，并使用自然中拼越英例句。
- 挑战固定为短文复原、语病修复、补回句子。
- 回忆保存 Explorer 对人物、动作、选择或画面的个人印象。
- 盖章代表完成一段经历，不只是读完资料。

## 完成定义

Story System 任务只有在以下条件全部满足时才算完成：

- 文档、故事数据、等级短文与测试同步。
- 十道 Story Quality Gate 全部通过。
- severe = 0，medium = 0。
- 全故事库差异化检查通过。
- 41 Journey × 10 Levels 全部通过内容质量检查。
- Flutter Analyze、测试、Web Build、Worker 与 PR Preview 通过。
- PR 保持与 `main` 隔离，合并只由 Founder 批准。
