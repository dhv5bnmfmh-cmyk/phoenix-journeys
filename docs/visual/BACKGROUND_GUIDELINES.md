# Phoenix Background Guidelines

Documentation Status: Active
Documentation Version: 1.0.0
Priority: ★★★★★ (Mandatory Background Standard)
Owner: Phoenix Visual Architecture
Documentation History: Reconstructed and Reviewed; activated by Phoenix Visual System v1.0 Review.

---

# 1. Purpose

Phoenix Background Guidelines（PBG）定义 Phoenix 全部背景资源的正式规范。

本文件适用于：

- Story Background
- Journey Background
- Special Journey Background
- Vocabulary Background
- Discovery Background
- Challenge Background
- Reflection Background
- Stamp Background
- Passport Background
- Map Background
- Home Background
- Loading Background
- Splash Background
- UI Ambient Background

背景不是装饰层。

背景属于 Phoenix Learning Experience。

背景负责：

- 建立空间。
- 建立时间。
- 建立天气。
- 建立文化。
- 建立情绪。
- 建立 Journey Identity。
- 支撑故事。
- 保护阅读。
- 保护学习。

背景不得：

- 抢夺故事。
- 抢夺文字。
- 抢夺按钮。
- 抢夺朗读。
- 抢夺 Challenge。
- 抢夺学习者注意力。

任何背景都必须遵守：

- VISUAL_CONSTITUTION.md
- VISUAL_PHILOSOPHY.md
- VISUAL_GUIDELINES.md

并在发布前通过：

- IMAGE_QUALITY_GATE.md
- VISUAL_CHECKLIST.md
- VISUAL_REVIEW_PROMPT.md

---

# 2. Background Mission

Phoenix 的背景使命不是让页面“更漂亮”。

背景的使命是：

> 让学习者自然进入 Journey，同时不意识到背景正在引导自己。

真正优秀的背景，不会要求用户停下来欣赏。

它会让用户愿意继续阅读。

背景必须服务：

- Story。
- Learning。
- UI。
- Audio。
- Journey Flow。

如果背景很漂亮，但：

- 文字看不清。
- 按钮不清楚。
- 阅读被打断。
- 动画让人分心。
- 城市文化错误。
- Journey Identity 模糊。

该背景仍然属于失败。

---

# 3. Core Principles

所有 Phoenix 背景必须遵守以下原则。

## Principle One

Story Before Background。

故事优先。

背景服务故事。

---

## Principle Two

Learning Before Atmosphere。

学习优先。

氛围不得影响学习。

---

## Principle Three

Reading Before Motion。

阅读优先。

动态必须退居阅读之后。

---

## Principle Four

Authenticity Before Decoration。

文化真实优先。

不得为了视觉效果混搭错误文化。

---

## Principle Five

Depth Before Detail。

空间层次优先。

细节数量不是品质。

---

## Principle Six

Static Quality Before Forced Motion。

如果动态不自然。

必须使用高质量静态背景。

---

## Principle Seven

Journey Identity Before Generic Beauty。

每个 Journey 必须属于自己的世界。

不得只生成“通用漂亮背景”。

---

# 4. Background Definition

每一个正式背景在设计前，必须定义以下内容。

## 4.1 Theme

主题。

回答：

这个背景在表达什么？

---

## 4.2 Story Relationship

故事关联。

回答：

它如何服务当前 Story？

---

## 4.3 Journey Relationship

Journey 关联。

回答：

为什么它只属于这个 Journey？

---

## 4.4 Emotion

主要情绪。

例如：

- 宁静。
- 好奇。
- 温暖。
- 神秘。
- 思念。
- 勇敢。
- 期待。
- 离别。
- 发现。

一个背景只能拥有一个主情绪。

可存在一个次情绪。

不得同时堆叠过多情绪。

---

## 4.5 Time

明确时间。

包括：

- 清晨。
- 上午。
- 午后。
- 黄昏。
- 夜晚。
- 黎明前。
- 雨后。
- 季节转换。

---

## 4.6 Weather

明确天气。

包括：

- 晴。
- 阴。
- 薄雾。
- 小雨。
- 雪。
- 微风。
- 云层变化。

天气必须服务 Story。

不得为了动态随意加入雨、雪或雾。

---

## 4.7 Culture

明确文化来源。

包括：

- 城市。
- 地域。
- 历史时期。
- 建筑传统。
- 植物环境。
- 日常生活。
- 民俗。
- 文学来源。

---

## 4.8 Color

明确：

- 主色。
- 辅助色。
- 强调色。
- 中性色。

不得使用无依据滤镜。

---

## 4.9 Main Light

明确主光源。

必须说明：

- 光从哪里来。
- 光照向哪里。
- 阴影落向哪里。
- 阅读区如何保持稳定。

---

## 4.10 Reading Safe Area

明确阅读安全区。

---

## 4.11 Button Safe Area

明确按钮安全区。

---

## 4.12 Dynamic Elements

明确：

哪些元素运动。

哪些元素静止。

---

## 4.13 Static Fallback

明确：

动态关闭或加载失败时使用的静态背景。

---

# 5. Background Spatial Architecture

Phoenix 背景必须拥有清晰空间结构。

标准结构如下：

```text
Foreground

↓

Midground

↓

Background

↓

Atmosphere

↓

Interface
```

界面位于背景之上。

背景任何层级不得穿透并干扰界面。

---

# 6. Foreground

前景用于建立进入感、空间感与真实感。

前景可以包含：

- 树枝。
- 竹叶。
- 花草。
- 石栏。
- 窗框。
- 屋檐边缘。
- 桥栏。
- 灯笼边缘。
- 布帘。
- 低矮植物。
- 局部器物。

前景不是装饰框。

前景必须解释：

镜头正在从哪里观察世界。

---

## 6.1 Foreground Functions

前景负责：

- 建立镜头位置。
- 增加景深。
- 引导视线。
- 强化 Journey 环境。
- 轻微遮挡无关区域。
- 支持自然动态。

---

## 6.2 Foreground Scale

前景可以比中景更大。

但不得：

- 占据主要阅读区。
- 形成黑色大片。
- 让屏幕显得拥挤。
- 遮挡人物或城市主体。
- 让用户误以为可点击。

---

## 6.3 Foreground Motion

允许：

- 轻微树叶摆动。
- 帘子缓慢移动。
- 花瓣少量经过。
- 雨滴出现在边缘。
- 雾气轻微掠过。

禁止：

- 大幅摆动。
- 高频重复。
- 物体不断横穿屏幕。
- 前景不断遮挡文字。
- 大量粒子迎面冲来。
- 强烈景深模糊变化。

---

## 6.4 Foreground Safety

前景必须避开：

- 标题。
- 正文。
- 生词卡片。
- Challenge 选项。
- 朗读控制。
- 返回按钮。
- 底部导航。
- Passport 热点。
- Stamp 区域。

---

# 7. Midground

中景是 Story 的主要发生空间。

它通常包含：

- 核心建筑。
- 街道。
- 庭院。
- 河流。
- 桥梁。
- 人物活动区。
- 市场。
- 山路。
- 室内空间。
- 主要文化元素。

中景是背景的叙事核心。

---

## 7.1 Midground Functions

中景负责：

- 承载 Story Scene。
- 支持人物存在。
- 建立 Journey Identity。
- 提供文化细节。
- 引导视觉焦点。
- 形成阅读后的长期记忆。

---

## 7.2 Midground Focus

中景应拥有一个主要视觉焦点。

可以是：

- 一座建筑。
- 一条街。
- 一座桥。
- 一扇门。
- 一段山路。
- 一处庭院。
- 一艘船。
- 一盏灯。

不得同时存在多个强视觉中心。

---

## 7.3 Midground Detail

细节应与 Story 相关。

允许：

- 建筑材料。
- 生活器物。
- 地方植物。
- 水面纹理。
- 道路痕迹。
- 灯光。
- 窗户。
- 门廊。
- 市井细节。

禁止：

- 为了“丰富”堆入无关元素。
- 添加无法解释的摆件。
- 使用错误年代物品。
- 将所有文化符号集中在同一画面。
- 重复复制建筑或人物。

---

## 7.4 Midground and Text

主要文字区域后方的中景必须：

- 降低对比。
- 降低纹理。
- 避免人物脸部。
- 避免高亮窗户。
- 避免密集建筑边缘。
- 避免动态主体。

---

# 8. Background and Far Distance

远景负责建立世界尺度。

远景可以包含：

- 天空。
- 远山。
- 城市轮廓。
- 古城墙。
- 湖面。
- 山谷。
- 云层。
- 远处宫殿。
- 寺庙轮廓。
- 森林。
- 海岸线。

---

## 8.1 Background Functions

远景负责：

- 建立地点。
- 建立时代。
- 建立天气。
- 建立空气透视。
- 提供空间延伸。
- 形成探索感。

---

## 8.2 Background Detail

远景细节必须少于中景。

距离越远：

- 对比越低。
- 饱和度越低。
- 边缘越柔和。
- 纹理越简化。
- 动态越缓慢。

不得让远景比中景更清晰。

---

## 8.3 Horizon

地平线位置必须服务构图。

不得：

- 切过人物头部。
- 穿过标题。
- 与按钮边缘重合。
- 让空间上下失衡。

---

## 8.4 Sky

天空不是填充区。

天空应表达：

- 时间。
- 天气。
- 色温。
- 空气。
- 情绪。

禁止：

- 过度戏剧化云层。
- 高频闪电。
- 大面积廉价星空。
- 无 Story 依据的极光。
- 不自然渐变。
- AI 生成乱码云形。

---

# 9. Atmosphere Layer

环境层负责统一整个画面。

可包含：

- 雾。
- 空气透视。
- 薄云。
- 体积光。
- 水汽。
- 微尘。
- 雪。
- 细雨。
- 光尘。

环境层必须克制。

它不是特效层。

---

## 9.1 Atmosphere Functions

环境层负责：

- 统一色温。
- 柔化空间。
- 强化时间。
- 增加深度。
- 连接前景、中景与远景。

---

## 9.2 Atmosphere Density

环境层不得：

- 覆盖主体。
- 压低文字对比。
- 让画面灰白。
- 让建筑失真。
- 让所有 Journey 都有同样雾气。
- 使用明显循环粒子。

---

# 10. Static Background

静态背景是 Phoenix 的正式视觉形式。

静态不代表低级。

高质量静态背景优先于不自然动态。

---

## 10.1 Static Requirements

静态背景必须：

- 构图完整。
- 光影可信。
- 层次清晰。
- Journey Identity 明确。
- 阅读安全。
- 按钮安全。
- 手机和平板自然。
- 可作为动态背景的第一帧或降级图。
- 无明显 AI 错误。
- 无版权风险。

---

## 10.2 Static Fallback

所有动态背景必须拥有静态降级图。

静态降级图必须：

- 与动态首帧一致。
- 不出现运动残影。
- 不出现半透明对象。
- 不依赖动画才能成立。
- 不产生页面切换黑屏。
- 在慢网络下立即可用。

---

# 11. Dynamic Background

动态背景是静态背景的延伸。

不是独立特效。

动态的目标：

让世界有呼吸感。

不是让用户注意到动画。

---

## 11.1 Recommended Motion

允许：

- 云层缓慢移动。
- 雾气轻微漂移。
- 树叶小幅摆动。
- 水面低频变化。
- 灯光柔和呼吸。
- 雨线自然落下。
- 雪花少量飘落。
- 花瓣偶尔经过。
- 视差缓慢变化。
- 镜头极轻推进。
- 远景亮度缓慢变化。

---

## 11.2 Motion Speed

背景动态必须低速。

用户在正常阅读时，不应被迫追踪运动。

推荐逻辑：

- 前景：小幅、低速。
- 中景：极少运动。
- 远景：更慢。
- 环境层：长周期。
- 镜头：几乎不可察觉。

---

## 11.3 Motion Amplitude

动态幅度必须克制。

禁止：

- 大幅左右漂移。
- 明显上下浮动。
- 强烈缩放。
- 镜头摇晃。
- 快速推进。
- 元素不断重复经过。
- 背景持续变焦。

---

## 11.4 Loop

循环必须自然。

不得出现：

- 突然跳回。
- 云层断裂。
- 水面重置。
- 灯光瞬间变化。
- 粒子集体消失。
- 镜头位置跳动。
- 时间倒流感。

如果无法制作自然循环。

必须使用静态背景。

---

## 11.5 Reading During Motion

阅读过程中：

- 主要文本区域后方应保持稳定。
- 不得出现强光扫过。
- 不得出现高对比物体移动。
- 不得出现人物从文字后穿过。
- 不得出现持续闪烁。
- 不得改变文字区域亮度。

---

# 12. Reduced Motion

Phoenix 必须支持减少动态效果。

包括：

- 系统 `prefers-reduced-motion`。
- 产品内“减少动态效果”设置。
- 低性能设备自动降级。
- QA 强制静态模式。

Reduced Motion 开启后：

- 停止镜头移动。
- 停止视差。
- 停止粒子。
- 停止背景漂移。
- 保留必要状态反馈。
- 使用静态降级图。

不得只减慢动画。

必须真正降低动态负担。

---

# 13. Reading Safety

阅读安全是背景的最高执行标准。

任何背景必须保护：

- 标题。
- Story 正文。
- 生词。
- 拼音。
- 翻译。
- Discovery。
- Challenge。
- Reflection。
- Stamp。
- Audio Controls。

---

## 13.1 Reading Safe Area Requirements

阅读安全区必须具备：

- 稳定亮度。
- 稳定色彩。
- 低纹理密度。
- 低动态。
- 无主体脸部。
- 无高亮窗户。
- 无密集文字形状。
- 无复杂建筑线条。
- 无快速阴影。

---

## 13.2 Text Background Treatment

当背景无法自然提供安全区时，可以使用：

- 柔和渐变。
- 半透明阅读层。
- 局部压暗。
- 局部提亮。
- 景深弱化。
- 低对比遮罩。

禁止：

- 粗重黑框。
- 发光文字。
- 霓虹描边。
- 高饱和底板。
- 不透明大白卡覆盖整个背景。

---

## 13.3 Reading State

阅读时背景动态应比首页、地图或 Loading 更克制。

Story 页面优先级：

```text
Text

↓

Audio

↓

Navigation

↓

Background
```

---

# 14. Button Safety

背景不得影响：

- Primary Button。
- Secondary Button。
- Back Button。
- Audio Button。
- Challenge Option。
- Continue Button。
- Passport Hotspot。
- Stamp Action。

按钮后方应保持：

- 稳定对比。
- 低动态。
- 无高亮。
- 无复杂轮廓。
- 无装饰性图标。

背景中的装饰不得看起来像可点击控件。

---

# 15. Journey Consistency

每一个 Journey 必须拥有独立且一致的背景系统。

Journey 一致性包括：

- 统一时间逻辑。
- 统一天气逻辑。
- 统一主色倾向。
- 统一建筑材料。
- 统一植物环境。
- 统一文化细节。
- 统一情绪。
- 统一光线方向。
- 统一视觉节奏。

---

## 15.1 Cross-page Consistency

同一 Journey 的以下页面必须属于同一个世界：

- Story。
- Vocabulary。
- Discovery。
- Challenge。
- Reflection。
- Stamp。
- Passport Thumbnail。

可以改变：

- 景别。
- 光线强度。
- 细节密度。
- 动态幅度。
- 阅读安全区。

不得改变：

- 城市。
- 文化。
- 时间逻辑。
- 建筑风格。
- Journey Identity。

---

## 15.2 Page-specific Background Weight

不同页面背景权重不同。

### Story

背景中等强度。

支撑文学与沉浸。

### Vocabulary

背景降低细节。

生词优先。

### Discovery

背景可以增加相关观察细节。

但不能替代内容。

### Challenge

背景最低权重。

题目与选项优先。

### Reflection

背景情绪可稍增强。

动态仍保持克制。

### Stamp

可加强仪式感。

不得突然切换为另一种产品风格。

---

# 16. Ordinary Journey Background

普通 Journey 背景应建立在：

- 真实城市。
- 真实文化。
- 真实生活。
- 真实建筑。
- 真实自然环境。

普通 Journey 不应：

- 神话化。
- 奇幻化。
- 过度滤镜化。
- 变成旅游海报。
- 变成建筑百科图。

背景应让学习者感受到：

真实的人在这里生活。

---

# 17. Special Journey Background

特别 Journey 背景可以拥有：

- 神秘感。
- 文学感。
- 超现实暗示。
- 传统想象。
- 志怪气质。
- 神话空间。

但必须：

- 尊重原典。
- 保留文化精神。
- 维持东方文学气质。
- 保持视觉可信度。
- 避免现代网游奇幻。
- 避免欧美魔幻视觉。
- 避免紫黑雾气成为通用模板。

特别 Journey 的神秘感应来自：

- 未知。
- 留白。
- 光影。
- 空间。
- 声音暗示。
- 文化符号。

不是来自廉价特效。

---

# 18. Cultural Consistency

背景必须符合真实文化。

检查范围包括：

- 建筑。
- 屋顶。
- 门窗。
- 街道。
- 桥梁。
- 植物。
- 器物。
- 服饰。
- 交通。
- 灯光。
- 地貌。
- 季节。
- 历史时期。

---

## 18.1 Prohibited Cultural Mixing

禁止：

- 不同城市标志建筑随意混合。
- 不同时代建筑同时出现。
- 现代广告进入古代场景。
- 北方植物出现在不合理南方环境。
- 错误服饰。
- 错误宗教元素。
- 错误文字。
- 错误牌匾。
- “东方元素”无依据堆积。

---

## 18.2 Cultural Research

背景制作前必须读取：

- Story。
- Journey Metadata。
- 城市研究。
- 文化研究。
- Special Journey 来源资料（如适用）。

文化不确定。

不得生成正式背景。

---

# 19. Learning Consistency

背景必须与 Learning Flow 一致。

Phoenix 学习流程：

```text
Story

↓

Vocabulary

↓

Discovery

↓

Challenge

↓

Reflection

↓

Stamp
```

背景应帮助流程自然推进。

不得让不同页面像不同产品。

---

## 19.1 Vocabulary

背景不得抢生词。

避免：

- 复杂纹理。
- 强动态。
- 高对比人物。
- 密集建筑。

---

## 19.2 Discovery

背景可以强化观察。

但知识必须来自 Discovery Content。

不得让背景承担全部解释。

---

## 19.3 Challenge

背景应降低存在感。

挑战题必须是唯一视觉中心。

---

## 19.4 Reflection

背景可支持情绪回收。

但不得强迫用户接受特定教育意义。

---

## 19.5 Stamp

背景应表达完成感。

盖章代表完成一次 Journey。

不是游戏奖励爆发。

禁止：

- 粒子爆炸。
- 强烈闪光。
- 大幅震动。
- 夸张金币效果。

---

# 20. Audio Consistency

背景不得影响朗读体验。

视觉动态必须与 Audio 保持克制关系。

朗读时：

- 不增加新动态。
- 不进行镜头切换。
- 不突然改变光线。
- 不出现高对比运动。
- 不因为语音段落切换而闪屏。

环境音与背景动态如需同步：

必须保持自然。

不得让用户注意到循环点。

---

# 21. Responsive Background

背景必须同时适配：

- 手机竖屏。
- 手机横屏（如支持）。
- 平板竖屏。
- 平板横屏。
- 未来桌面。
- 分屏窗口。
- 不同 DPI。

---

## 21.1 Mobile

手机端优先。

必须保证：

- 主体可识别。
- 安全区足够。
- 前景不过大。
- 中景不被裁掉。
- 远景仍建立地点。
- 文字后方稳定。

---

## 21.2 Tablet

平板不能只是放大手机图。

应：

- 展开环境。
- 保留阅读焦点。
- 增加合理横向空间。
- 保持 Journey Identity。

---

## 21.3 Desktop

桌面端允许扩展远景。

不得：

- 拉伸竖图。
- 放大到模糊。
- 新增第二主视觉。
- 让背景成为宽屏壁纸。

---

## 21.4 Responsive Cropping

裁切必须人工或规则化确认。

不得只依赖自动中心裁切。

每个比例必须检查：

- 主体。
- 安全区。
- 光源。
- 地平线。
- 文化元素。
- 动态边界。

---

# 22. Loading and Transition

页面切换不得出现：

- 黑屏。
- 白闪。
- 图片跳动。
- 背景瞬间缩放。
- 前后页面色温断裂。
- 动态重新从明显起点开始。

---

## 22.1 Loading State

背景加载时必须优先显示：

- 静态降级图。
- 主色渐变。
- 低成本程序化背景。

不得等待高清资源加载完成后才显示页面。

---

## 22.2 Transition

同一 Journey 页面切换时：

应保持：

- 色彩连续。
- 空间连续。
- 光线连续。
- Journey Identity 连续。

可改变景别。

不得突然换世界。

---

## 22.3 Return Restoration

用户返回页面时：

背景应恢复合理状态。

不得：

- 黑屏。
- 重播强开场动画。
- 光线突然重置。
- 动态位置明显跳变。
- 音频与视觉不同步。

---

# 23. Performance

背景必须遵守 Performance Guide。

重点包括：

- 图片压缩。
- WebP 或 AVIF。
- 响应式资源。
- Lazy Load。
- 首屏关键资源 Preload。
- 缓存。
- 静态降级。
- 动画暂停。
- 页面隐藏时停止动画。
- 低性能设备降级。
- 避免内存泄漏。
- 避免过多同时绘制层。

---

## 23.1 Performance Priority

性能不足时，降级顺序：

```text
减少粒子

↓

停止镜头移动

↓

停止视差

↓

停止环境动态

↓

使用静态背景
```

不得首先：

降低文字质量。

降低 UI 清晰度。

降低学习体验。

---

# 24. Background Resource Management

每个背景资源必须拥有：

- Asset ID。
- Journey ID。
- Page Type。
- Source Type。
- Creation Method。
- Copyright Status。
- Master Resolution。
- Runtime Resolution。
- Format。
- Static Fallback。
- Reduced Motion Variant。
- Review Status。
- Version。

不得导入来源不明背景。

---

# 25. Naming

背景文件统一使用：

```text
{journey-id}-{page}-background-{variant}.{format}
```

常见 Variant：

- mobile。
- tablet。
- desktop。
- static。
- reduced-motion。
- foreground。
- midground。
- far。
- overlay。

禁止：

- final。
- new。
- best。
- bg2。
- test。
- final-final。

---

# 26. Background Review

背景完成后必须审核：

## Space

- 前景是否合理。
- 中景是否承载 Story。
- 远景是否建立地点。
- 景深是否自然。

## Reading

- 文字是否清楚。
- 按钮是否清楚。
- 动态是否克制。
- 安全区是否稳定。

## Journey

- 是否属于当前 Journey。
- 是否与其它 Journey 过于相似。
- 是否与跨页面视觉一致。

## Culture

- 建筑是否正确。
- 地域是否正确。
- 时代是否正确。
- 植物和器物是否正确。

## Learning

- 是否服务 Story。
- 是否支持 Vocabulary。
- 是否支持 Discovery。
- 是否不干扰 Challenge。
- 是否支持 Reflection 与 Stamp。

## Technical

- 静态降级是否存在。
- Reduced Motion 是否有效。
- 手机、平板、桌面是否通过。
- 页面切换是否稳定。
- 性能是否合理。

---

# 27. Failure Rules

以下任一情况出现，背景禁止进入正式版：

- 没有前中远景层次。
- 文字不清楚。
- 按钮不可见。
- 动态不自然。
- 循环明显。
- Journey 不一致。
- 城市文化错误。
- 学习受到影响。
- 动画造成眩晕。
- 静态降级缺失。
- 加载失败黑屏。
- 手机或平板裁切失败。
- AI 错误未修复。
- 版权来源不明。
- 性能无法稳定运行。

失败后必须返回对应阶段重新设计。

不得通过降低 Gate 进入正式版。

---

# 28. Governance

Background Guidelines 长期维护遵循：

## Rule One

不得违反 Visual Constitution。

## Rule Two

不得重复 Visual Philosophy。

## Rule Three

不得代替 Performance Guide 中的动画性能、生命周期与降级规则。

## Rule Four

不得代替 Performance Guide。

## Rule Five

背景相关专项规则只在本文件定义。

其它文档应引用本文件。

## Rule Six

新增背景类型时，必须接入：

- Visual Decision Tree。
- Visual Pipeline。
- Image Quality Gate。
- Visual Checklist。
- Visual Review Prompt。

---

# 29. Permanent Rule

Phoenix Background Guidelines 是 Phoenix 全部背景资源的唯一正式规范。

任何：

- Story Background。
- Journey Background。
- Special Journey Background。
- Vocabulary Background。
- Discovery Background。
- Challenge Background。
- Reflection Background。
- Stamp Background。
- Passport Background。
- Map Background。
- Home Background。
- Loading Background。
- Splash Background。

都必须：

1. 定义主题、Story、Journey、情绪、时间、天气与文化。
2. 建立前景、中景、远景与环境层。
3. 保护阅读安全区与按钮安全区。
4. 保持 Journey、文化与学习一致。
5. 动态自然、缓慢、克制。
6. 动态失败时使用高质量静态背景。
7. 支持 Reduced Motion 与低性能降级。
8. 支持手机、平板与未来桌面。
9. 通过 Image Quality Gate、Visual Checklist 与 Visual Review。

只有完成以上全部要求，背景才允许进入 Phoenix Official Visual Library。
