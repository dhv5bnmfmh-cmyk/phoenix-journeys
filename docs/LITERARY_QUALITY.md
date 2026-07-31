# Phoenix Literary Quality Compatibility Entry

> 状态：兼容入口  
> Story System Version：`1.0.0`  
> 最后整理：2026-08-01

文学质量规则已拆分到 Phoenix Story System，避免人物、节奏、AI 痕迹、全库差异化和发布门槛在多个文件中漂移。

请按以下顺序读取：

- 文学声音、电影感、画面、呼吸、留白与自然中文：[`story/STORY_STYLE_GUIDE.md`](story/STORY_STYLE_GUIDE.md)
- 人物、冲突、高潮、结尾与学习闭环：[`story/STORY_GUIDELINES.md`](story/STORY_GUIDELINES.md)
- 全库重复、人物、剧情、情绪、教育意义与世界观：[`story/STORY_LIBRARY_RULES.md`](story/STORY_LIBRARY_RULES.md)
- 41 篇人物、叙事、情绪与结尾矩阵：[`story/CONTENT_VARIETY_GUIDE.md`](story/CONTENT_VARIETY_GUIDE.md)
- 十道强制发布门槛：[`story/STORY_QUALITY_GATE.md`](story/STORY_QUALITY_GATE.md)
- 固定总编辑审核 Prompt：[`story/STORY_REVIEW_PROMPT.md`](story/STORY_REVIEW_PROMPT.md)

运行时自动文学检查仍由 `JourneyLiteraryQualityAuditor` 执行。任何 severe 或 medium 问题都会阻断发布；自动检查通过后仍必须执行 Story Review Prompt 的人工总编辑复审。

本文件只保留兼容链接，不再维护另一套文学规范。
