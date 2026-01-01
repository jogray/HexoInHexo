# Hexo 快速使用教程

## 什么是 Hexo？

Hexo 是一个快速、简洁且高效的博客框架，基于 Node.js 构建。它使用 Markdown 解析文章，能在几秒内生成静态网页。

## 安装前提

- Node.js（建议 v14 或以上版本）
- Git

## 快速开始

### 1. 安装 Hexo CLI

```bash
npm install -g hexo-cli
```

### 2. 初始化博客

创建一个新的博客项目：

```bash
hexo init myblog
cd myblog
npm install
```

### 3. 本地预览

启动本地服务器：

```bash
hexo server
# 简写: hexo s
```

访问 `http://localhost:4000` 即可查看您的博客。

## 基本使用

### 创建新文章

```bash
hexo new "文章标题"
# 或简写
hexo n "文章标题"
```

这会在 `source/_posts/` 目录下创建一个 Markdown 文件。

### 编写文章

打开创建的 `.md` 文件，编辑 Front-matter 和内容：

```markdown
---
title: 我的第一篇文章
date: 2026-01-01 10:00:00
tags: 
  - 标签1
  - 标签2
categories: 分类名称
---

这里是文章内容，支持 Markdown 语法。

## 二级标题

正文内容...
```

### 生成静态文件

```bash
hexo generate
# 简写: hexo g
```

生成的静态文件会存放在 `public/` 目录中。

### 清理缓存

```bash
hexo clean
```

当修改了配置或遇到问题时，建议先清理缓存。

## 配置站点

编辑根目录下的 `_config.yml` 文件：

```yaml
# 网站信息
title: 我的博客
subtitle: 副标题
description: 网站描述
author: 作者名称
language: zh-CN
timezone: Asia/Shanghai

# URL
url: https://yoursite.com
permalink: :year/:month/:day/:title/

# 主题
theme: landscape
```

## 常用主题

- **NexT**: 简洁优雅的主题
  ```bash
  git clone https://github.com/next-theme/hexo-theme-next themes/next
  ```

- **Fluid**: 优雅的 Material Design 风格
  ```bash
  npm install hexo-theme-fluid
  ```

- **Butterfly**: 功能丰富的主题
  ```bash
  git clone -b master https://github.com/jerryc127/hexo-theme-butterfly.git themes/butterfly
  ```

安装主题后，在 `_config.yml` 中修改：

```yaml
theme: next  # 或其他主题名称
```

## 部署到 GitHub Pages

### 1. 安装部署插件

```bash
npm install hexo-deployer-git --save
```

### 2. 配置 _config.yml

```yaml
deploy:
  type: git
  repo: https://github.com/username/username.github.io.git
  branch: main
```

### 3. 部署

```bash
hexo clean
hexo generate
hexo deploy
# 或者一键三连: hexo clean && hexo g -d
```

## 常用插件

### 本地搜索

```bash
npm install hexo-generator-search --save
```

### RSS 订阅

```bash
npm install hexo-generator-feed --save
```

### sitemap 生成

```bash
npm install hexo-generator-sitemap --save
```

### 图片处理

```bash
npm install hexo-asset-image --save
```

在 `_config.yml` 中开启资源文件夹：

```yaml
post_asset_folder: true
```

## 常用命令总结

| 命令 | 简写 | 说明 |
|------|------|------|
| `hexo init` | - | 初始化博客 |
| `hexo new <title>` | `hexo n` | 创建新文章 |
| `hexo new page <name>` | - | 创建新页面 |
| `hexo generate` | `hexo g` | 生成静态文件 |
| `hexo server` | `hexo s` | 启动本地服务器 |
| `hexo deploy` | `hexo d` | 部署网站 |
| `hexo clean` | - | 清理缓存 |
| `hexo g -d` | - | 生成并部署 |
| `hexo s -g` | - | 生成并预览 |

## 文件结构

```
myblog/
├── _config.yml       # 网站配置文件
├── package.json      # 应用依赖
├── scaffolds/        # 模板文件夹
├── source/           # 源文件夹
│   ├── _posts/       # 文章目录
│   └── ...
├── themes/           # 主题文件夹
└── public/           # 生成的静态文件（不需要提交到版本控制）
```

## Front-matter 常用字段

```yaml
---
title: 文章标题
date: 2026-01-01 10:00:00      # 创建时间
updated: 2026-01-02 10:00:00   # 更新时间
tags:                           # 标签
  - Tag1
  - Tag2
categories: 分类                # 分类
permalink: custom-url           # 自定义链接
excerpt: 文章摘要               # 摘要
cover: /images/cover.jpg        # 封面图
top: true                       # 置顶
---
```

## 进阶技巧

### 草稿功能

创建草稿：

```bash
hexo new draft "草稿标题"
```

预览草稿：

```bash
hexo server --draft
```

发布草稿：

```bash
hexo publish draft "草稿标题"
```

### 自定义页面

创建"关于"页面：

```bash
hexo new page about
```

在导航栏中添加链接（具体方法取决于使用的主题）。

### 使用数学公式

安装渲染插件：

```bash
npm uninstall hexo-renderer-marked
npm install hexo-renderer-kramed --save
```

在主题配置中启用 MathJax 或 KaTeX。

## 常见问题

### 1. 端口被占用

指定其他端口：

```bash
hexo server -p 5000
```

### 2. 文章不显示

- 检查 Front-matter 格式是否正确
- 确保日期格式正确且不是未来时间
- 运行 `hexo clean` 清理缓存

### 3. 主题不生效

- 确认主题文件夹名称与配置一致
- 检查主题是否正确下载到 `themes/` 目录
- 清理缓存后重新生成

## 学习资源

- [Hexo 官方文档](https://hexo.io/zh-cn/docs/)
- [Hexo GitHub](https://github.com/hexojs/hexo)
- [主题列表](https://hexo.io/themes/)
- [插件列表](https://hexo.io/plugins/)

## 总结

Hexo 的基本使用流程：

1. 创建文章：`hexo new "标题"`
2. 编写内容：编辑 Markdown 文件
3. 本地预览：`hexo s`
4. 生成部署：`hexo g -d`

祝您使用愉快！🎉
