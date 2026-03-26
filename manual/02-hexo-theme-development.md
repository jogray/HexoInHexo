# Hexo 主题开发与自定义完全指南

## 引言

本教程详细介绍如何在 Hexo 中使用、自定义和开发主题。无论是对现有主题进行定制，还是从零开始创建自己的主题，都能找到相应的指导。

## 第一部分：主题基础知识

### 1.1 主题的作用

主题决定了你的博客的外观和功能。Hexo 通过主题来控制：

- 页面布局和样式
- 导航菜单
- 侧边栏
- 评论系统
- 搜索功能
- SEO 优化

### 1.2 目录结构

一个完整的 Hexo 主题目录结构如下：

```
theme-name/
├── _config.yml         # 主题配置文件
├── languages/          # 多语言支持
│   ├── default.yml
│   ├── zh-CN.yml
│   └── en.yml
├── layout/             # 模板文件（EJS 或其他模板引擎）
│   ├── index.ejs       # 首页
│   ├── post.ejs        # 文章页
│   ├── page.ejs        # 页面
│   ├── archive.ejs     # 归档页
│   ├── category.ejs    # 分类页
│   ├── tag.ejs         # 标签页
│   └── layout.ejs      # 主布局（其他模板的父模板）
├── source/             # 静态资源
│   ├── css/
│   │   ├── style.css
│   │   └── responsive.css
│   ├── js/
│   │   └── script.js
│   └── images/
└── scripts/            # 自定义脚本
```

### 1.3 主题配置文件

`themes/your-theme/_config.yml` 示例：

```yaml
# 导航菜单
menu:
  Home: /
  Archives: /archives/
  Categories: /categories/
  Tags: /tags/
  About: /about/

# 侧边栏
sidebar:
  position: right      # left 或 right
  display: post        # post（仅文章页）、always（总是显示）、hide（隐藏）

# 评论系统
comments:
  enabled: true
  provider: disqus     # 或 utterances、gitalk 等
  disqus_shortname: your-shortname

# 搜索
search:
  enabled: true
  provider: algolia    # 或 local、google

# 分析
analytics:
  enabled: true
  provider: google
  google_analytics_id: UA-XXXXXXXX-X

# 自定义颜色
colors:
  primary: '#3498db'
  secondary: '#2c3e50'
  accent: '#e74c3c'

# 字体
fonts:
  heading: "'Segoe UI', sans-serif"
  body: "'Segoe UI', sans-serif"
```

## 第二部分：安装与激活主题

### 2.1 从官方主题库安装

Hexo 有许多优秀的开源主题。常用的包括：

**NexT**（最受欢迎）：

```bash
cd themes
git clone https://github.com/next-theme/hexo-theme-next.git next
```

**Fluid**（简洁优雅）：

```bash
npm install hexo-theme-fluid
```

**Butterfly**（功能丰富）：

```bash
git clone -b master https://github.com/jerryc127/hexo-theme-butterfly.git butterfly
```

**Matery**（卡片风格）：

```bash
git clone https://github.com/blinkfox/hexo-theme-matery themes/matery
```

### 2.2 激活主题

在根目录的 `_config.yml` 中修改：

```yaml
theme: next          # 主题文件夹的名称
```

### 2.3 验证主题是否生效

```bash
hexo clean
hexo generate
hexo server
```

访问 `http://localhost:4000` 查看效果。

## 第三部分：主题配置与自定义

### 3.1 主题配置 vs 站点配置

**站点配置**（`_config.yml`）：
- 网站的全局设置
- 构建和部署选项
- 默认的 Markdown 渲染设置

**主题配置**（`themes/theme-name/_config.yml`）：
- 主题外观和功能
- 菜单、侧边栏、评论系统
- 主题特定的功能选项

### 3.2 自定义菜单

编辑主题配置文件：

```yaml
menu:
  首页: /
  分类: /categories/
  标签: /tags/
  归档: /archives/
  关于: /about/
  友链: /links/
  RSS: /atom.xml

menu_icons:
  首页: fa fa-home
  分类: fa fa-th
  标签: fa fa-tags
  归档: fa fa-archive
  关于: fa fa-user
```

### 3.3 配置侧边栏

```yaml
sidebar:
  position: right       # 左侧或右侧
  display: post        # 仅在文章页显示
  
# 侧边栏组件
widgets:
  - search
  - recent_posts
  - categories
  - tags
  - tagcloud
  - archives
  - about
```

### 3.4 设置个人头像和介绍

```yaml
avatar: /images/avatar.jpg
bio: 一个热爱编程的开发者
motto: 用代码改变世界
```

### 3.5 配置社交链接

```yaml
social:
  GitHub: https://github.com/your-username
  Twitter: https://twitter.com/your-username
  LinkedIn: https://linkedin.com/in/your-username
  Email: mailto:your-email@example.com
  WeChat: /images/wechat-qr.jpg
  Weibo: https://weibo.com/your-username
```

## 第四部分：高级自定义

### 4.1 自定义 CSS 样式

大多数主题支持自定义样式。在 `themes/your-theme/source/css/` 中创建 `custom.css`：

```css
/* 自定义主题色 */
:root {
  --primary-color: #3498db;
  --secondary-color: #2c3e50;
  --accent-color: #e74c3c;
}

/* 自定义字体 */
body {
  font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
  font-size: 16px;
  line-height: 1.8;
}

/* 自定义标题样式 */
h1, h2, h3, h4, h5, h6 {
  font-weight: 600;
  margin-bottom: 1rem;
}

/* 自定义链接颜色 */
a {
  color: var(--primary-color);
  text-decoration: none;
  transition: color 0.3s;
}

a:hover {
  color: var(--accent-color);
}

/* 自定义代码块 */
code {
  background: #f4f4f4;
  padding: 2px 6px;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
}

pre {
  background: #2c3e50;
  color: #ecf0f1;
  padding: 15px;
  border-radius: 5px;
  overflow-x: auto;
}

/* 自定义卡片样式 */
.post-card {
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.post-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.15);
}
```

然后在主题的 layout 文件中引入：

```html
<link rel="stylesheet" href="/css/custom.css">
```

### 4.2 自定义 JavaScript

创建 `themes/your-theme/source/js/custom.js`：

```javascript
// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
  // 平滑滚动
  setupSmoothScroll();
  
  // 返回顶部按钮
  setupBackToTop();
  
  // 图片懒加载
  setupLazyLoad();
});

// 平滑滚动
function setupSmoothScroll() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();
      const target = document.querySelector(this.getAttribute('href'));
      if (target) {
        target.scrollIntoView({ behavior: 'smooth' });
      }
    });
  });
}

// 返回顶部
function setupBackToTop() {
  const btn = document.querySelector('.back-to-top');
  window.addEventListener('scroll', function() {
    if (window.scrollY > 300) {
      btn.classList.add('show');
    } else {
      btn.classList.remove('show');
    }
  });
  
  btn.addEventListener('click', function() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
}

// 图片懒加载
function setupLazyLoad() {
  const images = document.querySelectorAll('img[data-src]');
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.removeAttribute('data-src');
        observer.unobserve(img);
      }
    });
  });
  
  images.forEach(img => observer.observe(img));
}
```

在 layout 文件中引入：

```html
<script src="/js/custom.js"></script>
```

### 4.3 修改主题模板

找到要修改的模板文件，例如修改文章页面 `layout/post.ejs`：

```ejs
<!DOCTYPE html>
<html>
<head>
  <title><%= page.title %> | <%= config.title %></title>
</head>
<body>
  <header>
    <%- partial('_partial/header') %>
  </header>
  
  <main>
    <article class="post">
      <h1><%= page.title %></h1>
      
      <div class="post-meta">
        <span class="author"><%= page.author || config.author %></span>
        <span class="date"><%= date(page.date, 'YYYY-MM-DD') %></span>
        <span class="reading-time"><%= page.readTime || '5' %> min read</span>
      </div>
      
      <div class="post-content">
        <%- page.content %>
      </div>
      
      <div class="post-footer">
        <% if (page.tags && page.tags.length) { %>
          <div class="tags">
            <% page.tags.forEach(function(tag) { %>
              <a href="<%= tag.path %>" class="tag"><%= tag.name %></a>
            <% }); %>
          </div>
        <% } %>
      </div>
    </article>
    
    <%- partial('_partial/comments') %>
  </main>
  
  <footer>
    <%- partial('_partial/footer') %>
  </footer>
</body>
</html>
```

## 第五部分：从零开始创建主题

### 5.1 创建主题结构

```bash
cd themes
mkdir my-theme
cd my-theme
mkdir -p layout source/{css,js,images} languages scripts
touch _config.yml
```

### 5.2 创建基础配置文件

`themes/my-theme/_config.yml`：

```yaml
# 主题信息
name: My Theme
version: 1.0.0
description: A simple and beautiful Hexo theme

# 菜单
menu:
  首页: /
  归档: /archives/
  关于: /about/

# 样式
color:
  primary: '#3498db'
  secondary: '#ecf0f1'

# 字体
font: 'Segoe UI', sans-serif
```

### 5.3 创建主布局模板

`themes/my-theme/layout/layout.ejs`：

```ejs
<!DOCTYPE html>
<html lang="<%= config.language || 'en' %>">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><% if (page.title) { %><%= page.title %> | <% } %><%= config.title %></title>
  <meta name="description" content="<%= page.description || config.description %>">
  
  <%- css('css/style.css') %>
</head>
<body>
  <div id="app">
    <%- partial('_partial/header') %>
    
    <main id="main">
      <%- body %>
    </main>
    
    <%- partial('_partial/footer') %>
  </div>
  
  <%- js('js/script.js') %>
</body>
</html>
```

### 5.4 创建页面模板

`themes/my-theme/layout/index.ejs`（首页）：

```ejs
<div class="posts">
  <% page.posts.each(function(post) { %>
    <article class="post-item">
      <h2><a href="<%= post.path %>"><%= post.title %></a></h2>
      <div class="post-meta">
        <span class="date"><%= date(post.date, 'YYYY-MM-DD') %></span>
        <span class="category"><%= post.categories.map(cat => cat.name).join(', ') %></span>
      </div>
      <p class="post-excerpt"><%- post.excerpt %></p>
      <a href="<%= post.path %>" class="read-more">阅读全文 →</a>
    </article>
  <% }); %>
  
  <div class="pagination">
    <% if (page.prev) { %>
      <a href="<%= config.root %><%= page.prev_link %>" class="prev">← 上一页</a>
    <% } %>
    
    <span class="page-number"><%= page.current %>/<%= page.total %></span>
    
    <% if (page.next) { %>
      <a href="<%= config.root %><%= page.next_link %>" class="next">下一页 →</a>
    <% } %>
  </div>
</div>
```

`themes/my-theme/layout/post.ejs`（文章页）：

```ejs
<article class="post">
  <header class="post-header">
    <h1 class="post-title"><%= page.title %></h1>
    <div class="post-meta">
      <span class="date"><%= date(page.date, 'YYYY-MM-DD HH:mm:ss') %></span>
      <% if (page.categories && page.categories.length) { %>
        <span class="category">
          <% page.categories.forEach(function(cat, i) { %>
            <a href="<%= cat.path %>"><%= cat.name %></a><% if (i < page.categories.length - 1) { %> / <% } %>
          <% }); %>
        </span>
      <% } %>
    </div>
  </header>
  
  <div class="post-content">
    <%- page.content %>
  </div>
  
  <footer class="post-footer">
    <% if (page.tags && page.tags.length) { %>
      <div class="tags">
        <% page.tags.forEach(function(tag) { %>
          <a href="<%= tag.path %>" class="tag"><%= tag.name %></a>
        <% }); %>
      </div>
    <% } %>
    
    <nav class="post-nav">
      <% if (page.prev) { %>
        <a href="<%= config.root %><%= page.prev.path %>" class="prev">← <%= page.prev.title %></a>
      <% } %>
      <% if (page.next) { %>
        <a href="<%= config.root %><%= page.next.path %>" class="next"><%= page.next.title %> →</a>
      <% } %>
    </nav>
  </footer>
</article>
```

### 5.5 创建样式文件

`themes/my-theme/source/css/style.css`：

```css
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html, body {
  width: 100%;
  height: 100%;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: 16px;
  line-height: 1.6;
  color: #333;
  background: #fff;
}

a {
  color: #3498db;
  text-decoration: none;
  transition: color 0.3s;
}

a:hover {
  color: #2980b9;
}

#app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

header {
  background: #2c3e50;
  color: #ecf0f1;
  padding: 20px 0;
}

nav {
  max-width: 1000px;
  margin: 0 auto;
  padding: 0 20px;
}

nav ul {
  list-style: none;
  display: flex;
  gap: 30px;
}

nav a {
  color: #ecf0f1;
}

nav a:hover {
  color: #3498db;
}

main {
  flex: 1;
  max-width: 1000px;
  width: 100%;
  margin: 40px auto;
  padding: 0 20px;
}

.post-item {
  padding: 20px 0;
  border-bottom: 1px solid #ecf0f1;
}

.post-item:last-child {
  border-bottom: none;
}

.post-item h2 {
  margin-bottom: 10px;
}

.post-meta {
  font-size: 14px;
  color: #7f8c8d;
  margin-bottom: 15px;
}

.post-excerpt {
  margin-bottom: 15px;
  color: #555;
}

.read-more {
  color: #3498db;
  font-weight: 500;
}

.post {
  padding: 40px 0;
}

.post-title {
  font-size: 32px;
  margin-bottom: 20px;
}

.post-content {
  margin: 30px 0;
  line-height: 1.8;
}

.post-content h2 {
  font-size: 24px;
  margin: 30px 0 15px;
  padding-bottom: 10px;
  border-bottom: 2px solid #ecf0f1;
}

.post-content h3 {
  font-size: 20px;
  margin: 20px 0 10px;
}

.post-content code {
  background: #f4f4f4;
  padding: 2px 6px;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
}

.post-content pre {
  background: #2c3e50;
  color: #ecf0f1;
  padding: 15px;
  border-radius: 5px;
  overflow-x: auto;
  margin: 20px 0;
}

.post-content pre code {
  background: none;
  padding: 0;
  color: inherit;
}

.post-content blockquote {
  border-left: 4px solid #3498db;
  padding-left: 15px;
  margin: 20px 0;
  color: #7f8c8d;
  font-style: italic;
}

.post-content img {
  max-width: 100%;
  height: auto;
  margin: 20px 0;
  border-radius: 5px;
}

.tags {
  margin: 20px 0;
}

.tag {
  display: inline-block;
  background: #ecf0f1;
  color: #2c3e50;
  padding: 5px 12px;
  margin-right: 10px;
  margin-bottom: 10px;
  border-radius: 20px;
  font-size: 14px;
  transition: background 0.3s;
}

.tag:hover {
  background: #3498db;
  color: #fff;
}

.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 40px 0;
}

.pagination a {
  padding: 10px 20px;
  background: #ecf0f1;
  border-radius: 5px;
  transition: background 0.3s;
}

.pagination a:hover {
  background: #3498db;
  color: #fff;
}

footer {
  background: #2c3e50;
  color: #ecf0f1;
  text-align: center;
  padding: 30px 20px;
  margin-top: 40px;
}

@media (max-width: 768px) {
  main {
    margin: 20px auto;
  }
  
  .post-title {
    font-size: 24px;
  }
  
  nav ul {
    flex-direction: column;
    gap: 10px;
  }
}
```

## 第六部分：使用辅助函数

在主题模板中，Hexo 提供了许多辅助函数：

### 6.1 链接生成

```ejs
<%- url_for(post.path) %>                    <!-- 生成文章链接 -->
<%- link_to(post.title, post.path) %>        <!-- 生成带标签的链接 -->
<%- link_to('Home', '/') %>                   <!-- 首页链接 -->
```

### 6.2 时间格式化

```ejs
<%= date(post.date, 'YYYY-MM-DD') %>         <!-- 日期：2026-01-01 -->
<%= date(post.date, 'YYYY年MM月DD日') %>     <!-- 中文格式 -->
<%= time(post.date, 'HH:mm:ss') %>           <!-- 时间：10:30:00 -->
```

### 6.3 资源引入

```ejs
<%- css('css/style.css') %>           <!-- 引入 CSS -->
<%- js('js/script.js') %>             <!-- 引入 JS -->
<%- image('images/logo.png') %>       <!-- 引入图片 -->
```

### 6.4 页面数据

```ejs
<%= config.title %>                   <!-- 网站标题 -->
<%= config.author %>                  <!-- 作者名 -->
<%= page.title %>                     <!-- 当前页面标题 -->
<%= page.date %>                      <!-- 当前页面日期 -->
<%= paginator.total_posts %>          <!-- 总文章数 -->
```

### 6.5 条件判断

```ejs
<% if (is_home()) { %>
  <!-- 在首页显示 -->
<% } %>

<% if (is_post()) { %>
  <!-- 在文章页显示 -->
<% } %>

<% if (is_archive()) { %>
  <!-- 在归档页显示 -->
<% } %>

<% if (is_category()) { %>
  <!-- 在分类页显示 -->
<% } %>

<% if (is_tag()) { %>
  <!-- 在标签页显示 -->
<% } %>
```

### 6.6 遍历

```ejs
<!-- 遍历所有文章 -->
<% site.posts.forEach(function(post) { %>
  <%= post.title %>
<% }); %>

<!-- 遍历所有分类 -->
<% site.categories.forEach(function(cat) { %>
  <%= cat.name %>
<% }); %>

<!-- 遍历所有标签 -->
<% site.tags.forEach(function(tag) { %>
  <%= tag.name %>
<% }); %>
```

## 第七部分：多语言支持

### 7.1 创建语言文件

`themes/my-theme/languages/en.yml`：

```yaml
menu:
  home: Home
  archives: Archives
  tags: Tags
  categories: Categories
  about: About

post:
  posted: Posted on
  updated: Updated on
  reading_time: Reading time
  word_count: Word count
  views: Views
```

`themes/my-theme/languages/zh-CN.yml`：

```yaml
menu:
  home: 首页
  archives: 归档
  tags: 标签
  categories: 分类
  about: 关于

post:
  posted: 发布于
  updated: 更新于
  reading_time: 阅读时间
  word_count: 字数
  views: 浏览
```

### 7.2 在模板中使用

```ejs
<%= __('menu.home') %>      <!-- 获取翻译 -->
<%= __('post.posted') %>
```

## 第八部分：主题发布和分享

### 8.1 准备主题

```
my-theme/
├── _config.yml
├── languages/
├── layout/
├── scripts/
├── source/
├── README.md
├── LICENSE
└── package.json
```

### 8.2 创建 package.json

```json
{
  "name": "hexo-theme-my-theme",
  "version": "1.0.0",
  "description": "A simple and beautiful Hexo theme",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [
    "hexo",
    "theme",
    "blog"
  ],
  "author": "Your Name",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/your-username/hexo-theme-my-theme.git"
  },
  "bugs": {
    "url": "https://github.com/your-username/hexo-theme-my-theme/issues"
  },
  "homepage": "https://github.com/your-username/hexo-theme-my-theme"
}
```

### 8.3 创建 README.md

```markdown
# Hexo Theme My Theme

A simple and beautiful Hexo theme.

## Features

- Responsive design
- Multi-language support
- Dark mode support
- SEO optimized
- Fast loading

## Installation

```bash
git clone https://github.com/your-username/hexo-theme-my-theme.git themes/my-theme
```

## Configuration

See `_config.yml` for configuration options.

## License

MIT
```

### 8.4 发布到 NPM（可选）

```bash
npm adduser
npm publish
```

然后用户可以通过以下方式安装：

```bash
npm install hexo-theme-my-theme
```

## 第九部分：常见问题

### Q1: 如何使用多个主题？

```bash
# 创建多个主题文件夹
themes/theme1
themes/theme2

# 在 _config.yml 中切换
theme: theme1  # 改为 theme2 使用另一个主题
```

### Q2: 如何继承现有主题进行定制？

```yaml
# 在 _config.yml 中设置基础主题
inherit: landscape
```

或复制整个主题文件夹进行修改。

### Q3: 如何添加自定义评论系统？

在主题的 `scripts/` 目录创建脚本，或在 layout 文件中直接添加评论代码：

```ejs
<!-- 在 layout/post.ejs 中 -->
<div id="disqus_thread"></div>
<script>
  var disqus_config = function () {
    this.page.url = '<%= post.permalink %>';
    this.page.identifier = '<%= post._id %>';
  };
  (function() {
    var d = document, s = d.createElement('script');
    s.src = 'https://your-disqus.disqus.com/embed.js';
    s.setAttribute('data-timestamp', +new Date());
    (d.head || d.body).appendChild(s);
  })();
</script>
```

### Q4: 主题文件修改后不显示怎么办？

```bash
hexo clean
hexo generate
hexo server
```

清理缓存并重新生成是必须的。

### Q5: 如何在主题中使用 SCSS 或 Less？

安装对应的渲染器：

```bash
# SCSS
npm install hexo-renderer-scss --save

# Less
npm install hexo-renderer-less --save
```

然后在 `source/` 目录中使用 `.scss` 或 `.less` 文件。

## 第十部分：性能优化

### 10.1 CSS 优化

```css
/* 使用 CSS 变量减少重复 */
:root {
  --primary: #3498db;
  --secondary: #ecf0f1;
  --border-radius: 5px;
}

/* 使用简写属性 */
.post {
  margin: 20px 0;
  padding: 15px;
  border-radius: var(--border-radius);
}

/* 避免过度嵌套 */
.header .nav .item a {  /* 不好 */
}

.nav-item a {  /* 好 */
}
```

### 10.2 JavaScript 优化

```javascript
// 事件委托
document.addEventListener('click', function(e) {
  if (e.target.matches('.post-link')) {
    handlePostClick(e);
  }
});

// 节流函数
function throttle(func, delay) {
  let lastCall = 0;
  return function(...args) {
    const now = Date.now();
    if (now - lastCall >= delay) {
      func.apply(this, args);
      lastCall = now;
    }
  };
}

window.addEventListener('scroll', throttle(function() {
  updateScrollPosition();
}, 100));
```

### 10.3 图片优化

```ejs
<!-- 使用 srcset 支持不同分辨率 -->
<img 
  src="/images/logo.jpg" 
  srcset="/images/logo-2x.jpg 2x, /images/logo-3x.jpg 3x"
  alt="Logo">

<!-- 使用 WebP 格式 -->
<picture>
  <source srcset="/images/logo.webp" type="image/webp">
  <img src="/images/logo.jpg" alt="Logo">
</picture>
```

## 总结

主题开发的关键要点：

✓ 理解主题的目录结构和配置系统
✓ 掌握 EJS 模板语言的基本语法
✓ 学会使用 Hexo 提供的辅助函数
✓ 遵循最佳实践的 HTML/CSS/JS 代码规范
✓ 考虑响应式设计和性能优化
✓ 提供充分的文档和易用的配置选项

无论是自定义现有主题还是创建全新主题，这些知识都能帮助你打造一个专属的个人博客！
