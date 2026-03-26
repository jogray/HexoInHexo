# Hexo 文章写作与优化完全指南

## 引言

这篇教程将深入讲解如何在 Hexo 中创建、组织和优化博客文章，使其更加专业、易于发现和维护。

## 第一部分：文章的创建与基础配置

### 1.1 创建新文章

最基础的方式：

```bash
hexo new "我的第一篇文章"
```

这会在 `source/_posts/` 目录下创建 `我的第一篇文章.md` 文件。

### 1.2 使用脚手架模板

Hexo 提供了 scaffolds（脚手架）功能，可以定制新文章的默认模板。

查看默认脚手架：

```bash
ls scaffolds/
# 通常包含：
# - post.md （文章模板）
# - page.md （页面模板）
# - draft.md （草稿模板）
```

编辑 `scaffolds/post.md` 来自定义模板：

```markdown
---
title: {{ title }}
date: {{ date }}
updated: {{ date }}
tags: 
categories: 
description: 
cover: 
top: false
---

在这里开始写作...
```

### 1.3 创建特殊页面

创建"关于我"页面（不会在文章列表中显示）：

```bash
hexo new page about
```

这会创建 `source/about/index.md` 文件。

## 第二部分：Front-matter 详解

Front-matter 是 YAML 格式的文章元数据，位于文件顶部，用三条短横线包围。

### 2.1 必用字段

```yaml
---
title: 文章标题
date: 2026-01-01 10:30:00
---
```

- **title**: 文章标题，会显示在文章页面和列表中
- **date**: 文章发布日期，格式为 YYYY-MM-DD HH:mm:ss

### 2.2 常用字段

```yaml
---
title: 深度学习入门指南
date: 2026-01-01 10:30:00
updated: 2026-01-15 14:20:00
author: 作者名称
tags:
  - 机器学习
  - Python
categories: 技术教程
description: 这是一篇关于深度学习的入门教程
cover: /images/cover-deep-learning.jpg
permalink: /blog/deep-learning-guide/
---
```

字段说明：

| 字段 | 说明 | 例子 |
|------|------|------|
| `title` | 文章标题 | "深度学习入门" |
| `date` | 发布日期 | 2026-01-01 10:30:00 |
| `updated` | 更新日期 | 2026-01-15 14:20:00 |
| `author` | 作者 | 张三 |
| `tags` | 标签（数组） | [机器学习, Python] |
| `categories` | 分类 | 技术教程 |
| `description` | 描述/摘要 | 文章简介 |
| `cover` | 封面图片 | /images/cover.jpg |
| `permalink` | 自定义链接 | /blog/my-post/ |
| `comments` | 是否开启评论 | true/false |
| `toc` | 是否显示目录 | true/false |
| `top` | 是否置顶 | true/false |
| `secret` | 是否加密 | true/false |

### 2.3 进阶字段

```yaml
---
title: 文章标题
date: 2026-01-01
sticky: 1              # 置顶优先级，数字越大越靠前
draft: false           # 是否为草稿
mathjax: true          # 是否启用数学公式
highlight: true        # 是否启用代码高亮
---
```

### 2.4 自定义字段

可以添加任何自定义字段供主题使用：

```yaml
---
title: 文章标题
date: 2026-01-01
readTime: 15           # 阅读时间（分钟）
difficulty: 中等       # 难度等级
source: 原创           # 来源
feature: 推荐          # 特殊标记
---
```

## 第三部分：Markdown 写作规范

### 3.1 标题结构

```markdown
# 一级标题 - 通常是文章标题
## 二级标题 - 主要章节
### 三级标题 - 子章节
#### 四级标题 - 细节
```

**重要**：不要在 Markdown 中使用一级标题，因为 Front-matter 中的 title 已经是一级标题。

### 3.2 强调文本

```markdown
**加粗文本** 或 __加粗文本__
*斜体文本* 或 _斜体文本_
***加粗斜体*** 或 ___加粗斜体___
~~删除线~~
`行内代码`
```

### 3.3 代码块

带语言标识的代码块会启用语法高亮：

````markdown
```python
def hello_world():
    print("Hello, World!")
```

```javascript
function helloWorld() {
    console.log("Hello, World!");
}
```

```bash
echo "Hello, World!"
```
````

指定行号和高亮行：

````markdown
```python {linenos=true,linenostart=1,hl_lines=[2,4]}
def add(a, b):
    return a + b      # 这行会被高亮

def subtract(a, b):
    return a - b      # 这行也会被高亮
```
````

### 3.4 列表

无序列表：

```markdown
- 项目 1
- 项目 2
  - 嵌套项目 2.1
  - 嵌套项目 2.2
- 项目 3
```

有序列表：

```markdown
1. 第一步
2. 第二步
   1. 子步骤 1
   2. 子步骤 2
3. 第三步
```

任务列表：

```markdown
- [x] 已完成的任务
- [ ] 未完成的任务
- [x] 已完成的任务
```

### 3.5 链接和引用

```markdown
[链接文本](https://example.com)
[链接文本](https://example.com "链接标题")

# 参考式链接
[链接文本][ref]
[ref]: https://example.com

# 自动链接
<https://example.com>
<user@example.com>
```

### 3.6 图片

```markdown
![图片描述](/images/my-image.jpg)
![图片描述](/images/my-image.jpg "图片标题")

# 带链接的图片
[![图片描述](/images/my-image.jpg)](https://example.com)
```

**最佳实践**：始终提供有意义的 alt 文本用于 SEO 和无障碍访问。

### 3.7 表格

```markdown
| 列1 | 列2 | 列3 |
|-----|-----|-----|
| 内容1 | 内容2 | 内容3 |
| 内容4 | 内容5 | 内容6 |

# 对齐方式
| 左对齐 | 居中 | 右对齐 |
|:------|:----:|-------:|
| L | C | R |
| L | C | R |
```

### 3.8 引用块

```markdown
> 这是一个引用块
> 可以有多行
> 
> 也可以有多个段落

> 嵌套引用
> > 二级引用
> > > 三级引用
```

### 3.9 水平线

```markdown
---
或
***
或
___
```

### 3.10 脚注

```markdown
这是一个带脚注的句子[^1]。

[^1]: 这是脚注的内容。
```

## 第四部分：数学公式

### 4.1 安装支持

安装 KaTeX 渲染器：

```bash
npm uninstall hexo-renderer-marked
npm install hexo-renderer-kramed --save
```

修改 `_config.yml`：

```yaml
# 开启数学公式支持
markdown:
  render:
    html: true
    xhtmlOut: false
    breaks: false
    langPrefix: hljs-
    linkify: true
    typographer: true
    quotes: '""'''

kramed:
  html: true
  xhtmlOut: false
  breaks: false
  langPrefix: hljs-
  linkify: true
  typographer: true
  quotes: '""'''
```

### 4.2 使用公式

行内公式（使用 `$...$`）：

```markdown
爱因斯坦的质能方程：$E=mc^2$
```

块级公式（使用 `$$...$$` 或 ```math```）：

```markdown
$$
\frac{-b \pm \sqrt{b^2-4ac}}{2a}
$$

或者

```math
\frac{-b \pm \sqrt{b^2-4ac}}{2a}
```
```

常用公式例子：

```markdown
# 分数
$$\frac{a}{b}$$

# 上标和下标
$$x^2 + y_1$$

# 根号
$$\sqrt{x}$$

# 求和
$$\sum_{i=1}^{n} x_i$$

# 积分
$$\int_0^\infty e^{-x} dx$$

# 矩阵
$$\begin{matrix}
a & b \\
c & d
\end{matrix}$$
```

## 第五部分：文章组织与管理

### 5.1 分类与标签的最佳实践

**分类**（分层结构）：

```yaml
---
title: 深度学习完全指南
categories:
  - 技术
  - 机器学习
  - 深度学习
---
```

这会创建分层结构：技术 > 机器学习 > 深度学习

**标签**（扁平结构）：

```yaml
---
title: 深度学习完全指南
tags:
  - 神经网络
  - CNN
  - 计算机视觉
  - Python
---
```

**建议**：
- 分类：用于大的主题分组（2-3 级）
- 标签：用于细粒度的内容标记（多个即可）

### 5.2 文章摘要

自动摘录：

```markdown
---
title: 我的文章
---

这是文章的前两行内容会作为摘要...

<!-- more -->

剩余内容不会在首页显示
```

或手动设置：

```yaml
---
title: 我的文章
description: 这是手动编写的文章摘要，会显示在列表中
---
```

### 5.3 草稿管理

创建草稿（不会发布）：

```bash
hexo new draft "草稿标题"
```

草稿保存在 `source/_drafts/` 目录。

预览草稿：

```bash
hexo server --draft
```

发布草稿：

```bash
hexo publish draft "草稿标题"
```

## 第六部分：SEO 优化

### 6.1 URL 结构

在 `_config.yml` 中配置：

```yaml
# 推荐：易读的 URL 结构
permalink: :year/:month/:day/:title/
# 结果：2026/01/01/my-article/

# 或者
permalink: :title/
# 结果：my-article/

# 或者
permalink: /posts/:id.html
# 结果：/posts/12345.html
```

**最佳实践**：
- 包含日期可提高时间相关文章的排名
- 使用有意义的标题而不是 ID
- URL 应该简短易记

### 6.2 元数据优化

```yaml
---
title: 如何使用 Hexo 搭建个人博客 - 2026 完全指南
date: 2026-01-01
description: 详细的 Hexo 教程，包括安装、配置、主题、插件、部署等内容。适合初学者和进阶用户。
tags:
  - Hexo
  - 博客
  - 静态网站生成器
cover: /images/hexo-guide.jpg
---
```

**优化点**：
- title：包含关键词和吸引用户
- description：简洁明了，150 字以内
- tags：使用相关的长尾关键词
- cover：高质量配图提高点击率

### 6.3 内容优化

1. **关键词使用**
   - 在标题中包含主要关键词
   - 在文章前 100 字内出现关键词
   - 自然地在正文中使用关键词，避免堆砌

2. **标题优化**
   ```markdown
   # 好的标题
   ## 初学者如何用 Hexo 搭建个人博客（5步完成）
   
   # 不好的标题
   ## Hexo 教程
   ```

3. **内容结构**
   - 使用清晰的标题层级
   - 段落简短，3-5 句为宜
   - 使用列表和表格提高可读性
   - 添加内部链接指向相关文章

4. **多媒体使用**
   - 添加有意义的图片
   - 提供高质量的代码示例
   - 如需要，添加演示视频

### 6.4 内链优化

在文章中链接到其他相关文章：

```markdown
请参考[《Hexo 主题配置指南》](/manual/02-hexo-theme-guide/)了解更多。

或使用 Hexo 标签插件：

{% post_link 02-hexo-theme-guide %}
```

## 第七部分：高级写作技巧

### 7.1 代码片段管理

创建可复用的代码文件：

```bash
source/_includes/code/example.js
```

在文章中引入：

```markdown
{% include_code lang:javascript code/example.js %}
```

### 7.2 自定义样式

在文章中使用 HTML（如果主题支持）：

```html
<div class="alert alert-info">
  <strong>提示：</strong> 这是一个提示框
</div>
```

或使用主题提供的标签插件：

```
{% note info %}
这是一个信息提示框
{% endnote %}
```

### 7.3 引用和归属

```markdown
> 这是一个引用
>
> —— 作者名称，出处链接
```

### 7.4 系列文章

在 Front-matter 中添加系列标记：

```yaml
---
title: 深度学习教程（第一部分）
series: 深度学习完全指南
series_index: 1
---
```

## 第八部分：常见问题

### Q1: 文章不显示怎么办？

检查清单：

```yaml
---
date: 2025-12-31 23:59:59  # ✓ 日期不在未来
---
```

```bash
# ✓ 清理缓存
hexo clean
hexo generate
hexo server
```

### Q2: 如何让某篇文章置顶？

```yaml
---
title: 重要公告
top: true
sticky: 1
---
```

### Q3: 如何禁用某篇文章的评论？

```yaml
---
title: 我的文章
comments: false
---
```

### Q4: 支持 Word 转换吗？

建议安装 Pandoc 转换工具：

```bash
# macOS
brew install pandoc

# Linux
sudo apt-get install pandoc

# 转换
pandoc input.docx -o output.md
```

## 第九部分：发布工作流程

推荐的文章发布流程：

1. **计划阶段**
   ```bash
   hexo new draft "文章标题"
   ```

2. **写作阶段**
   - 编辑 `source/_drafts/` 下的文件
   - 使用 `hexo server --draft` 预览
   - 不断修改和完善

3. **审查阶段**
   - 检查拼写和语法
   - 验证代码示例的准确性
   - 检查链接是否有效

4. **发布阶段**
   ```bash
   hexo publish draft "文章标题"
   ```

5. **部署阶段**
   ```bash
   hexo clean && hexo g -d
   ```

## 第十部分：性能优化建议

1. **图片优化**
   - 压缩图片大小
   - 使用 WebP 格式
   - 使用图床服务（如 CDN）

2. **代码优化**
   - 使用代码高亮库（Highlight.js 或 Prism.js）
   - 避免过长的代码块

3. **内容优化**
   - 定期清理过时的文章
   - 更新旧文章中的信息
   - 使用 `updated` 字段标记更新

## 总结

一篇优秀的 Hexo 文章应该具备：

✓ 清晰的 Front-matter 配置
✓ 合理的标题层级
✓ 优化的 SEO 元数据
✓ 清晰易读的内容结构
✓ 有意义的多媒体内容
✓ 正确的链接和引用

遵循这些规范，你的博客将更加专业、易于维护，也更容易被搜索引擎和读者发现。
