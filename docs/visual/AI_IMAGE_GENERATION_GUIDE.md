# Phoenix AI Image Generation Guide

Documentation Status: Active
Documentation Version: 1.0.0
Priority: ★★★★★ (Mandatory AI Image Generation Standard)
Owner: Phoenix Visual Architecture
Documentation History: Reconstructed and Reviewed; activated by Phoenix Visual System v1.0 Review.

---

# 1. Purpose

Phoenix AI Image Generation Guide（PAIGG）定义 Phoenix 使用生成式人工智能创建视觉资源时必须遵守的正式标准。

本文件适用于：

- Journey Background
- Special Journey Background
- Story Illustration
- Discovery Illustration
- Map Asset
- Passport Asset
- Journey Thumbnail
- Banner
- Splash
- Loading Illustration
- UI Illustration
- Decorative Asset
- Static Fallback
- Animation Source Layer
- Future Visual Asset

本规范不负责定义 Phoenix 的最高视觉原则。

最高视觉原则由：

- `VISUAL_CONSTITUTION.md`
- `VISUAL_PHILOSOPHY.md`

定义。

本规范负责将这些原则转化为可执行的 AI 图片生产标准。

任何 AI 生成图片在进入 Phoenix 前，都必须完成：

```text
需求确认

↓

规范读取

↓

Story 与 Journey 研究

↓

文化研究

↓

视觉方案

↓

Prompt 设计

↓

图片生成

↓

AI 错误检查

↓

文化真实性检查

↓

版权检查

↓

质量审核

↓

性能处理

↓

正式命名

↓

Metadata 登记

↓

导入审核
```

任何阶段失败，图片不得进入 Phoenix Official Visual Library。

---

# 2. AI Image Mission

Phoenix 使用 AI 生成图片，不是为了：

- 快速填满页面。
- 展示 AI 能力。
- 批量制造背景。
- 降低美术判断标准。
- 用技术替代文化研究。
- 用高分辨率掩盖构图问题。

AI 在 Phoenix 中只是视觉生产工具。

视觉方向、文化判断、阅读安全和最终质量，必须由 Phoenix Visual System 决定。

AI 不拥有 Phoenix 的视觉风格解释权。

AI 不得根据模型默认审美自动决定：

- 画面风格。
- 城市形象。
- 人物形象。
- 历史环境。
- 色彩方向。
- Journey 情绪。
- 文化元素。

所有正式视觉决策必须来自 Phoenix Documentation。

---

# 3. Governing Principles

所有 AI 图片必须遵守以下原则。

## Principle One

Originality Before Convenience。

原创优先。

不得为了快速完成而使用、复制或重组来源不明的视觉内容。

---

## Principle Two

Story Before Image。

故事优先。

图片必须服务 Story，而不是要求 Story 配合图片。

---

## Principle Three

Learning Before Decoration。

学习优先。

图片不得降低阅读、理解、操作和记忆体验。

---

## Principle Four

Cultural Authenticity Before Visual Impact。

文化真实性优先。

不得为了视觉冲击破坏城市、历史或文学来源。

---

## Principle Five

Quality Before Quantity。

品质优先。

宁可减少图片数量，也不得导入低质量生成图。

---

## Principle Six

Traceability Before Import。

可追踪性优先。

无法确认生成来源、授权状态或制作方式的资源，不得导入。

---

## Principle Seven

Static Quality Before Forced Animation。

用于动态背景的源图，首先必须是一张成立的高质量静态图。

不能依靠动画掩盖静态构图缺陷。

---

# 4. Allowed Creation Methods

Phoenix 正式视觉资源只允许以下来源。

## 4.1 Original AI Generation

根据 Phoenix 正式 Documentation、Story、Journey Metadata 与文化研究，从零生成原创图片。

生成过程必须可追踪。

---

## 4.2 Programmatic Generation

使用程序化绘制、矢量图形、着色器、Canvas、SVG 或其它自有程序生成视觉资源。

程序化资源同样必须符合：

- Visual Constitution。
- Visual Guidelines。
- Copyright Policy。
- Performance Guide。
- Image Quality Gate。

---

## 4.3 Original Manual Creation

由项目成员原创绘制、建模、摄影或设计，并确认拥有完整商业使用权。

---

## 4.4 Licensed Third-party Resources

只有在以下条件全部满足时，才允许使用：

- 许可证明确。
- 允许商业使用。
- 允许当前修改方式。
- 允许当前分发方式。
- 来源可追踪。
- 授权记录完整。
- 不违反 Phoenix Visual Style。

版权状态不明确时，一律视为不可使用。

---

# 5. Forbidden Sources

Phoenix 禁止将以下内容直接作为正式资源或生成参考主体：

- 网络搜索下载图片。
- 来源未知图片。
- 社交媒体图片。
- Pinterest 收藏图。
- 电影截图。
- 电视剧画面。
- 动漫截图。
- 游戏截图。
- 商业海报。
- 品牌宣传图。
- 未授权摄影作品。
- 未授权插画。
- 未授权纹理包。
- 未授权 3D 模型。
- 无法确认许可证的图库资源。
- 其它项目内部资源。
- 带水印图片。
- 带版权标记图片。
- 经过裁切仍可识别来源的作品。
- 从现成作品中提取的角色、建筑组合或画面构图。

不得通过：

- 改色。
- 镜像。
- 裁切。
- 模糊。
- 重绘局部。
- AI 风格转换。
- 添加滤镜。

规避版权或来源问题。

---

# 6. Forbidden Intellectual Property

AI Prompt、参考输入和最终图片均不得包含或复制：

- 受版权保护的角色。
- 动漫人物。
- 游戏角色。
- 电影角色。
- 品牌吉祥物。
- 商业 Logo。
- 商标。
- 产品包装。
- 明确可识别的商业 UI。
- 受保护的建筑灯光设计或展览设计。
- 影视独特镜头。
- 游戏独特场景。
- 商业插画独特构图。
- 特定作品中的标志性道具。
- 具体艺术家的独特个人风格。

禁止使用以下指令方式：

```text
像某位具体艺术家

某电影风格

某游戏原画风格

某动漫风格

某品牌广告风格
```

Phoenix 必须建立自己的视觉语言。

---

# 7. Commercial Use Standard

任何正式 AI 图片必须满足商业使用要求。

生成前必须确认：

- 使用的生成服务允许商业使用。
- 当前账户或授权层级允许商业使用。
- 输入素材拥有合法权利。
- 生成结果不包含受保护内容。
- 不依赖来源未知的参考图。
- 不包含可识别商标或品牌。
- 不包含未经许可的真实人物肖像。
- 生成记录可以追踪。

“由 AI 生成”不自动等于“无版权风险”。

AI 生成资源仍必须经过版权审核。

---

# 8. Source Traceability

每一个 AI 视觉资源必须拥有完整来源记录。

记录至少包括：

- Asset ID。
- Journey ID。
- Page Type。
- Resource Type。
- Creation Method。
- Generation Date。
- Generation Tool Category。
- Prompt Version。
- Input Reference Status。
- Copyright Status。
- Commercial Use Status。
- Human Review Status。
- Master Resolution。
- Runtime Resolution。
- File Format。
- Static Fallback。
- Reduced Motion Variant。
- Quality Gate Result。
- Visual Review Result。
- Asset Version。

未建立来源记录的图片，不得进入正式资源目录。

---

# 9. Required Pre-generation Research

AI 图片生成前，必须完成必要研究。

AI 不得直接依据 Journey 名称猜测画面。

---

## 9.1 Story Research

必须读取：

- Story 正文。
- Story Metadata。
- 人物。
- 冲突。
- 情绪。
- 时间。
- 天气。
- 结尾。
- Journey Flow。

必须确认图片服务的是哪一段 Story。

---

## 9.2 Journey Research

必须确认：

- Ordinary Journey 或 Special Journey。
- 城市或文学来源。
- Journey Identity。
- 页面类型。
- 视觉重点。
- 学习阶段。
- 跨页面背景关系。

---

## 9.3 Cultural Research

必须研究：

- 地理。
- 建筑。
- 植物。
- 气候。
- 地貌。
- 服饰。
- 器物。
- 生活方式。
- 历史时期。
- 民俗。
- 文学来源。

AI 模型的默认知识不得作为唯一文化依据。

---

## 9.4 Visual Library Review

生成前必须检查 Phoenix 现有视觉库。

确认：

- 是否已有相似构图。
- 是否已有相似光线。
- 是否已有相似天气。
- 是否已有相似色彩。
- 是否已有相似建筑视角。
- 是否已有相似人物位置。
- 是否已有相似前景。
- 是否已有相似动态方案。

重复率过高时，必须重新设计视觉方案。

---

# 10. Visual Design Brief

生成 Prompt 前，必须先建立 Visual Design Brief。

Design Brief 必须明确：

- Asset Purpose。
- Journey ID。
- Page Type。
- Story Relationship。
- Main Theme。
- Main Emotion。
- Secondary Emotion。
- Time。
- Weather。
- Cultural Context。
- Main Color。
- Supporting Color。
- Accent Color。
- Main Light Source。
- Foreground。
- Midground。
- Background。
- Atmosphere。
- Main Visual Focus。
- Reading Safe Area。
- Button Safe Area。
- Intended Device。
- Aspect Ratio。
- Static Fallback Requirement。
- Animation Layer Requirement。
- Prohibited Elements。

没有完整 Design Brief，不得开始生成。

---

# 11. Prompt Architecture

Phoenix AI 图片 Prompt 必须是结构化视觉指令。

不得只输入：

```text
漂亮的中国古城背景
```

不得依赖：

- “高级感”。
- “电影感”。
- “东方感”。

等抽象词自行生成。

Prompt 必须将抽象目标转化为具体视觉条件。

---

## 11.1 Prompt Order

正式 Prompt 应按以下顺序组织：

```text
资源目的

↓

Story 与 Journey

↓

场景与文化

↓

时间与天气

↓

镜头与构图

↓

前景、中景、远景

↓

光影

↓

色彩

↓

材质与空气

↓

阅读安全区

↓

人物与动作

↓

画质要求

↓

禁止内容
```

---

## 11.2 Asset Purpose

Prompt 首先说明资源用途。

必须明确：

- Journey Background。
- Story Illustration。
- Discovery Illustration。
- Passport Thumbnail。
- Map Node。
- Banner。
- Loading Illustration。
- Static Fallback。
- Animation Source Layer。

用途不同，构图和细节密度必须不同。

---

## 11.3 Story Context

Prompt 应用简洁、准确的语言说明：

- 故事发生地点。
- 当前情节。
- 人物正在做什么。
- 当前情绪。
- 画面必须支持的阅读目的。

不得把完整故事正文直接塞入 Prompt。

Prompt 只保留与视觉相关的信息。

---

## 11.4 Cultural Context

Prompt 必须明确：

- 城市。
- 地区。
- 历史时期。
- 建筑类型。
- 植物环境。
- 生活细节。
- 文化器物。

禁止使用模糊词：

```text
中国风

古风

东方建筑

亚洲城市
```

这些词无法保证文化真实性。

---

## 11.5 Composition

Prompt 必须明确：

- 镜头高度。
- 镜头距离。
- 主体位置。
- 视线方向。
- 地平线位置。
- 前景。
- 中景。
- 远景。
- 留白位置。
- 阅读安全区。
- 按钮安全区。

不得让 AI 自行决定全部构图。

---

## 11.6 Lighting

Prompt 必须明确：

- 主光源。
- 光源方向。
- 时间。
- 阴影方向。
- 光线强度。
- 色温。
- 暗部保留程度。
- 阅读区域亮度稳定要求。

禁止仅写：

```text
cinematic lighting
```

而不定义真实光源。

---

## 11.7 Color

Prompt 必须明确：

- 主色。
- 辅助色。
- 强调色。
- 饱和度。
- 色温。
- 禁止颜色。
- 文字安全区的对比要求。

---

## 11.8 Material and Atmosphere

Prompt 应明确重要材质：

- 石材。
- 木材。
- 水面。
- 砖瓦。
- 布料。
- 植物。
- 雪。
- 雨。
- 雾。
- 空气透视。

材质必须自然。

不得形成塑料、蜡质或过度光滑的 CG 质感。

---

# 12. Negative Prompt Standard

正式生成必须包含明确禁止项。

禁止项应根据资源类型与文化场景调整。

通用禁止项包括：

- 文字。
- 乱码。
- Logo。
- 水印。
- 商标。
- 广告。
- 现代标识。
- 错误建筑。
- 错误时代元素。
- 重复人物。
- 重复建筑。
- 重复窗户。
- 畸形手部。
- 多余手指。
- 多余四肢。
- 错误五官。
- 错误透视。
- 错误阴影。
- 错误倒影。
- 漂浮物体。
- 不合理比例。
- 塑料质感。
- 过度锐化。
- 过度 HDR。
- 荧光色。
- 廉价粒子。
- 游戏 UI。
- 网游风。
- 赛博风。
- 商业海报构图。
- 动漫角色。
- 影视角色。
- 品牌元素。
- 具体艺术家风格。

Negative Prompt 不能代替正向构图设计。

---

# 13. Prompt Version Management

每个正式视觉资产的 Prompt 必须拥有版本。

格式：

```text
prompt-v1
prompt-v2
prompt-v3
```

每次修改 Prompt，应记录修改原因。

包括：

- 构图修正。
- 文化修正。
- 光影修正。
- AI 错误修正。
- 安全区修正。
- Journey 差异化修正。
- 性能适配修正。

不得只保留最终图片而丢失生成逻辑。

---

# 14. Generation Resolution

正式母版应优先使用 4K 级生成或高质量放大后重新审核。

最低要求不是单纯像素数量。

4K 母版仍必须保证：

- 真实细节。
- 清晰边缘。
- 自然纹理。
- 无重复纹理。
- 无生成噪点。
- 无虚假锐化。
- 无局部融化。
- 无细节漂移。

低分辨率图片通过普通放大达到 4K，不等于符合正式标准。

---

# 15. Image Quality Standard

正式 AI 图片必须具备：

- 清晰主视觉。
- 合理空间。
- 前景、中景、远景。
- 自然景深。
- 可信光源。
- 正确阴影。
- 统一色彩。
- 自然材质。
- 稳定阅读区。
- 充足裁切空间。
- 设备适配能力。
- Journey Identity。
- 文化真实性。
- 长期耐读性。

图片不得仅因为“看起来漂亮”而通过审核。

---

# 16. AI Error Categories

AI 错误分为以下类别。

---

## 16.1 Human Anatomy Errors

包括：

- 手指数错误。
- 手掌融合。
- 手臂数量错误。
- 关节弯曲异常。
- 腿部融合。
- 面部不对称。
- 眼睛方向异常。
- 牙齿异常。
- 耳朵异常。
- 身体比例错误。
- 人物与物体融合。
- 半透明人物。
- 漂浮人物。
- 人物影子缺失。

任何明显人体错误均为阻断问题。

---

## 16.2 Architecture Errors

包括：

- 建筑结构不成立。
- 屋顶悬空。
- 门窗比例错误。
- 台阶无出口。
- 楼层逻辑混乱。
- 重复窗户。
- 透视冲突。
- 建筑文化混搭。
- 错误现代元素。
- 错误年代材料。
- 标志性建筑变形。

建筑错误不得以“插画风”作为理由保留。

---

## 16.3 Object Errors

包括：

- 器物结构错误。
- 重复物体。
- 半个物体。
- 漂浮器物。
- 尺寸关系错误。
- 功能结构不成立。
- 影子与物体不一致。
- 物体穿透环境。

---

## 16.4 Text Errors

包括：

- AI 乱码。
- 错误汉字。
- 无意义英文。
- 扭曲招牌。
- 虚构 Logo。
- 错误数字。
- 混合文字。

正式背景默认禁止出现 AI 生成文字。

必须出现文字时，应在后期使用人工确认内容重新绘制。

---

## 16.5 Lighting Errors

包括：

- 多个冲突主光源。
- 阴影方向不一致。
- 人物与建筑受光不同。
- 倒影亮度错误。
- 无来源轮廓光。
- 夜景无光源却整体发亮。
- 室内外色温逻辑错误。
- 高光穿过实体。

---

## 16.6 Perspective Errors

包括：

- 地平线冲突。
- 建筑消失点不一致。
- 台阶方向错误。
- 桥梁结构扭曲。
- 人物比例随距离异常。
- 水平面倾斜。
- 门窗角度不一致。
- 前景与中景尺度错误。

---

## 16.7 Nature Errors

包括：

- 植物种类与地区不符。
- 树枝重复。
- 花朵排列机械。
- 水流方向错误。
- 山体纹理重复。
- 云层不自然。
- 雨雪方向与风不一致。
- 倒影与岸边结构不对应。
- 月亮与光线逻辑冲突。

---

## 16.8 Generative Texture Errors

包括：

- 局部融化。
- 无意义纹理。
- 重复图案。
- 过度平滑。
- 塑料感。
- 蜡质人物。
- AI 油腻高光。
- 虚假细节。
- 远景乱码。
- 边缘破碎。
- 不自然锐化。

---

# 17. AI Error Review Procedure

每张图片至少执行以下审核顺序：

```text
全图构图检查

↓

四角与边缘检查

↓

主视觉检查

↓

人物检查

↓

建筑检查

↓

文化检查

↓

文字与 Logo 检查

↓

透视检查

↓

光影检查

↓

倒影检查

↓

重复元素检查

↓

100% 尺寸检查

↓

目标设备裁切检查
```

只看缩略图不得判定图片通过。

必须检查原始分辨率。

---

# 18. Regeneration Rules

发现以下问题时，必须重新生成：

- 主构图失败。
- 文化方向错误。
- 主体身份错误。
- 建筑结构严重错误。
- 人物结构严重错误。
- 透视体系错误。
- Journey Identity 不成立。
- 阅读安全区无法修复。
- 画面与 Story 不符。
- 版权风险无法排除。

不得通过局部修图挽救根本错误的图片。

---

## 18.1 Allowed Post-processing

允许后期处理：

- 合理裁切。
- 色彩统一。
- 对比微调。
- 曝光微调。
- 去除小型生成瑕疵。
- 清理无意义文字。
- 修复局部边缘。
- 添加人工确认的文字。
- 创建阅读遮罩。
- 分离动画图层。
- 输出设备变体。
- 压缩与格式转换。

后期处理后必须重新完成 Quality Gate。

---

## 18.2 Forbidden Post-processing

禁止：

- 用强模糊隐藏错误。
- 用暗色遮罩隐藏建筑错误。
- 大面积克隆造成重复。
- 通过锐化伪造清晰度。
- 用滤镜统一不一致的 Journey。
- 删除水印后使用。
- 裁掉版权标记后使用。
- 通过镜像规避来源识别。
- 用局部修补掩盖整体构图失败。

---

# 19. Character Generation

当图片包含人物时，必须明确：

- 人物身份。
- 年龄范围。
- 文化背景。
- 服饰时期。
- 动作。
- 视线。
- 与场景关系。
- 是否属于 Story 正式角色。

背景中的人物不得：

- 抢夺文字焦点。
- 形成无意义人群。
- 出现重复脸。
- 穿着错误。
- 以刻板印象表现地区文化。
- 使用真实公众人物肖像。
- 使用未经授权的真实人物形象。

儿童人物必须以自然、尊重、非商品化方式呈现。

---

# 20. Architecture Generation

建筑类视觉必须先确认：

- 建筑名称。
- 建筑类型。
- 城市。
- 历史时期。
- 结构特点。
- 材料。
- 屋顶。
- 门窗。
- 空间比例。
- 周边环境。
- 是否属于真实遗产。

标志性建筑不得凭模型想象自由改造。

需要准确表现时，应以可靠资料完成文化研究，但不得直接复制受版权保护的摄影构图。

---

# 21. Special Journey Generation

特别 Journey 的图片必须额外读取：

- Story Constitution。
- Story Philosophy。
- Special Journey Guide。
- Story 正文。
- 原典或文化来源说明。

特别 Journey 可以使用合理想象。

但不得：

- 现代网络小说化。
- 欧美奇幻化。
- 网游化。
- 赛博化。
- 使用通用紫黑雾气模板。
- 用怪物堆积制造神秘。
- 破坏原典核心精神。
- 误用宗教或民俗符号。

神秘感应来自：

- 光影。
- 留白。
- 空间。
- 时间。
- 不完全显露。
- 文学意象。
- 文化语境。

---

# 22. Ordinary Journey Generation

普通 Journey 必须建立在真实生活与真实文化之上。

视觉应体现：

- 人物生活痕迹。
- 城市空间。
- 地方材料。
- 日常节奏。
- 自然环境。
- 真实时间与天气。

禁止：

- 旅游宣传海报化。
- 明信片化。
- 所有城市都空无一人。
- 所有古城都金色黄昏。
- 所有水乡都薄雾小船。
- 所有山景都云海日出。
- 只替换地标而重复构图。

---

# 23. Cross-Journey Difference

生成前后都必须检查整个 Visual Library。

至少比较：

- 构图。
- 镜头高度。
- 主体位置。
- 光线。
- 时间。
- 天气。
- 色彩。
- 前景元素。
- 建筑角度。
- 人物配置。
- 动态方案。
- 阅读安全区位置。
- 结尾页面视觉。

如果多个 Journey 仅通过换色产生差异，必须重新设计。

---

# 24. Image Naming Standard

正式运行时资源必须使用统一英文小写命名。

标准结构：

```text
{journey-id}-{page-type}-{asset-role}-{device-or-state}.{format}
```

字段说明：

- `journey-id`：Journey 唯一 ID。
- `page-type`：story、vocabulary、discovery、challenge、reflection、stamp、passport、map 等。
- `asset-role`：background、foreground、midground、far、overlay、thumbnail、illustration 等。
- `device-or-state`：mobile、tablet、desktop、static、reduced-motion、dark、light 等。
- `format`：avif、webp、png、svg 等。

文件名必须能够直接判断资源用途。

---

## 24.1 Naming Rules

必须：

- 使用小写英文。
- 使用连字符。
- 使用正式 Journey ID。
- 使用标准页面名称。
- 使用标准资源角色。
- 避免无意义缩写。
- 保持跨 Journey 一致。

---

## 24.2 Forbidden Names

禁止：

```text
final.png
final2.webp
new-bg.png
best-image.png
test.png
use-this.png
background-copy.png
img001.png
final-final-v3.png
```

禁止使用：

- 空格。
- 中文标点。
- 随机编号。
- 个人姓名。
- 生成工具名称。
- “最新”“最终”等不可维护词语。

---

# 25. Source File Naming

原始母版与运行时资源必须分开命名与存放。

母版名称应包含：

```text
{asset-id}-master-{version}.{source-format}
```

运行时资源名称不得包含：

- Prompt 内容。
- AI 工具名称。
- 个人账户名称。
- 临时生成批次名称。

Prompt 和生成信息应保存在 Metadata 中，而不是运行时文件名。

---

# 26. Directory Standard

AI 生成资源必须按照以下逻辑管理：

```text
visual source assets

↓

review candidates

↓

approved masters

↓

runtime variants

↓

archive
```

不同状态不得混放。

---

## 26.1 Source Assets

保存：

- 原始母版。
- 图层。
- Prompt 记录。
- 生成信息。
- 授权信息。
- 修订记录。

Source Assets 不直接参与产品运行。

---

## 26.2 Review Candidates

保存等待审核的候选图。

候选图不得被业务页面引用。

---

## 26.3 Approved Masters

只保存已通过视觉审核的高分辨率母版。

---

## 26.4 Runtime Variants

只保存：

- 已压缩。
- 已命名。
- 已生成目标尺寸。
- 已通过性能审核。
- 已确认静态降级。
- 已确认设备适配。

的正式资源。

---

## 26.5 Archive

保存已废弃但需要追踪的资源。

Archive 不得参与构建或运行。

---

# 27. Import Requirements

图片导入 Phoenix 前必须完成以下事项：

- 文件命名正确。
- 文件目录正确。
- Metadata 完整。
- 版权状态确认。
- 商业使用状态确认。
- AI 错误审核完成。
- Image Quality Gate 通过。
- Visual Checklist 通过。
- Visual Review 通过。
- 手机裁切通过。
- 平板裁切通过。
- 未来桌面扩展合理。
- 静态降级图存在。
- Reduced Motion 资源存在或确认不需要。
- WebP 或 AVIF 输出完成。
- 缓存策略确认。
- Loading 状态确认。
- 加载失败回退确认。

任一项缺失，不得导入。

---

# 28. Runtime Asset Standard

运行时图片必须优先使用：

- AVIF。
- WebP。

透明或矢量场景可使用：

- PNG。
- SVG。

不得直接使用：

- 未压缩母版。
- 编辑工程文件。
- 超大 PNG 背景。
- 来源不明格式。
- 重复保存的相同图片。

运行时资源必须根据：

- 手机。
- 平板。
- 桌面。
- DPI。
- 网络条件。

提供合理版本。

---

# 29. Responsive Variants

每个关键视觉资源应确认是否需要：

- Mobile Portrait。
- Mobile Landscape。
- Tablet Portrait。
- Tablet Landscape。
- Desktop。
- Thumbnail。
- Static Fallback。
- Reduced Motion。

不得假设同一张图片通过自动裁切可以覆盖全部比例。

每个变体必须重新检查：

- 主体。
- 构图。
- 阅读安全区。
- 按钮安全区。
- 光源。
- 地平线。
- Journey Identity。
- 文化元素。

---

# 30. Import Validation

导入后必须在真实页面验证：

- 图片已正确显示。
- 无拉伸。
- 无模糊。
- 无错误裁切。
- 无闪屏。
- 页面切换稳定。
- 返回页面后正确恢复。
- 文字清晰。
- 按钮清晰。
- 朗读操作不受影响。
- Challenge 不受影响。
- Loading 状态自然。
- 加载失败回退有效。
- Reduced Motion 有效。
- 低性能设备降级有效。
- 内存占用合理。
- 图片不会重复解码造成卡顿。

导入成功不等于审核完成。

必须完成运行时验证。

---

# 31. Revision and Replacement

视觉资源需要修改或替换时，必须：

1. 确认修改原因。
2. 保留原 Asset ID 或建立明确替代关系。
3. 更新 Prompt Version。
4. 更新 Asset Version。
5. 更新 Metadata。
6. 重新执行 AI Error Review。
7. 重新执行版权审核。
8. 重新执行 Image Quality Gate。
9. 重新执行设备验证。
10. 确认旧资源不再被引用。

不得直接覆盖文件而不更新记录。

---

# 32. Rejection Conditions

出现以下任一情况，图片必须拒绝：

- 来源未知。
- 商业使用权限未知。
- 输入参考图无授权。
- 模仿具体艺术家。
- 复制影视、动漫、游戏或品牌。
- 包含 Logo 或商标。
- 包含 AI 乱码。
- 存在人物结构错误。
- 存在建筑结构错误。
- 存在文化错误。
- 存在透视错误。
- 存在光影错误。
- 重复元素明显。
- 塑料质感明显。
- Journey 不一致。
- Story 不一致。
- 阅读安全区失败。
- 手机裁切失败。
- 平板裁切失败。
- 性能不合格。
- 静态降级缺失。
- Metadata 缺失。
- Quality Gate 未通过。
- Visual Review 未通过。

不得使用“上线后再修”作为导入理由。

---

# 33. AI Image Review Roles

正式 AI 图片审核必须同时采用以下视角：

- Phoenix Visual Architect。
- Story Editor。
- Cultural Reviewer。
- Learning Experience Reviewer。
- UI/UX Reviewer。
- Accessibility Reviewer。
- Performance Reviewer。
- Copyright Reviewer。

单一“画面漂亮”判断不足以通过审核。

---

# 34. Quality Decision

AI 图片最终决策只有两种：

```text
PASS

允许进入 Phoenix Visual Pipeline 下一阶段
```

或：

```text
FAIL

返回正确阶段重新设计或重新生成
```

不存在：

- 基本通过。
- 暂时使用。
- 以后再修。
- 先导入看看。
- 有一点问题但不影响。

任何正式 Gate 失败，都禁止进入 Phoenix Official Visual Library。

---

# 35. Governance

AI Image Generation Guide 长期维护遵循以下规则。

## Rule One

不得违反 Visual Constitution。

## Rule Two

不得重复 Visual Philosophy。

## Rule Three

不得重新定义 Background Guidelines。

## Rule Four

不得替代 Copyright Policy。

## Rule Five

不得替代 Performance Guide。

## Rule Six

Prompt、生成、审核、命名与导入必须保持同一条可追踪链。

## Rule Seven

生成工具变化，不得改变 Phoenix Visual Standard。

## Rule Eight

任何新 AI 生成方式，都必须先通过现有版权、质量和性能规范。

---

# 36. Permanent Rule

Phoenix AI Image Generation Guide 是 Phoenix 使用 AI 创建视觉资源的唯一正式生成规范。

任何 AI 在生成：

- Journey Background。
- Special Journey Background。
- Story Illustration。
- Discovery Illustration。
- Map。
- Passport。
- Banner。
- Splash。
- Loading。
- UI Illustration。
- Static Fallback。
- Animation Source Layer。

之前，必须：

1. 读取 Visual README。
2. 读取 Visual Constitution。
3. 读取 Visual Philosophy。
4. 读取 Visual Guidelines。
5. 读取对应 Story 与 Journey Documentation。
6. 完成城市与文化研究。
7. 建立 Visual Design Brief。
8. 编写结构化 Prompt。
9. 确认原创与商业使用条件。
10. 生成高质量母版。
11. 完成 AI 错误检查。
12. 完成文化真实性检查。
13. 完成跨 Journey 重复检查。
14. 完成版权审核。
15. 完成正式命名与 Metadata 登记。
16. 通过 Image Quality Gate。
17. 通过 Visual Checklist。
18. 通过 Visual Review。
19. 完成性能处理与设备变体。
20. 完成导入后的真实页面验证。

任何步骤失败，资源不得进入 Phoenix Official Visual Library。

AI 是生产工具。

Phoenix Documentation 才是视觉标准。
