# Hexo 高级技巧与工具集成完全指南

## 引言

本教程介绍 Hexo 的高级功能和与其他工具的集成方案，帮助你构建更强大、更高效的博客系统。无论是自动化工作流程、集成分析工具，还是扩展功能，本教程都能为你提供详细的指导。

## 第一部分：Hexo 脚本和插件开发

### 1.1 理解 Hexo 的事件系统

Hexo 提供了事件钩子（Hooks），允许你在特定时刻执行自定义代码。

**可用的事件**：

```javascript
// hexo/scripts/custom-script.js

// 初始化完成
hexo.on('ready', function() {
  console.log('Hexo ready');
});

// 生成前
hexo.before('generate', function() {
  console.log('Before generate');
});

// 生成完成
hexo.on('generateAfter', function() {
  console.log('Generate complete');
});

// 部署前
hexo.before('deploy', function() {
  console.log('Before deploy');
});

// 部署完成
hexo.after('deploy', function() {
  console.log('Deploy complete');
});

// 离线前
hexo.before('exit', function() {
  console.log('Before exit');
});
```

### 1.2 创建自定义脚本

在 `hexo/scripts/` 目录创建自定义脚本：

```javascript
// scripts/count-words.js
'use strict';

hexo.extend.filter.register('post_parse', function(data) {
  // 计算文章字数
  const text = data.raw || data.content || '';
  const wordCount = text.length;
  
  data.wordCount = wordCount;
  data.readingTime = Math.ceil(wordCount / 300); // 假设每分钟读 300 字
  
  return data;
});
```

然后在模板中使用：

```ejs
<p>字数：<%= post.wordCount %></p>
<p>阅读时间：<%= post.readingTime %> 分钟</p>
```

### 1.3 创建自定义过滤器（Filters）

过滤器用于处理数据：

```javascript
// scripts/custom-filter.js
'use strict';

// 为文章添加额外数据
hexo.extend.filter.register('before_post_render', function(data) {
  // 添加阅读估计
  const readingTime = Math.ceil(data.content.length / 300);
  data.reading_time = readingTime;
  
  return data;
});

// 生成页面时添加数据
hexo.extend.filter.register('before_generate', function() {
  // 可以在这里修改全局数据
  hexo.config.buildDate = new Date().toISOString();
});

// 处理最终输出
hexo.extend.filter.register('after_render:html', function(str, data) {
  // 修改生成的 HTML
  return str.replace(/placeholder/g, 'replacement');
});
```

### 1.4 创建自定义生成器（Generators）

生成器用于创建新的页面：

```javascript
// scripts/custom-generator.js
'use strict';

hexo.extend.generator.register('custom', function(locals) {
  return {
    path: 'sitemap.json',
    layout: false,
    data: {
      posts: locals.posts.data,
      pages: locals.pages.data
    }
  };
});
```

创建对应的模板 `themes/your-theme/layout/sitemap.json.ejs`：

```ejs
<%
const posts = [];
site.posts.forEach(post => {
  posts.push({
    title: post.title,
    url: post.permalink,
    date: post.date,
    updated: post.updated
  });
});
%>
<%- JSON.stringify(posts, null, 2) %>
```

### 1.5 创建自定义命令

创建新的 Hexo 命令：

```javascript
// scripts/custom-command.js
'use strict';

hexo.extend.console.register('count', 'Count posts and pages', {
  usage: 'hexo count',
  desc: 'Count the number of posts and pages',
  arguments: []
}, function(args) {
  const postCount = this.posts.length;
  const pageCount = this.pages.length;
  
  console.log(`Posts: ${postCount}`);
  console.log(`Pages: ${pageCount}`);
  console.log(`Total: ${postCount + pageCount}`);
});
```

使用：

```bash
hexo count
# Posts: 50
# Pages: 5
# Total: 55
```

### 1.6 创建 Hexo 插件

完整的插件结构：

```
hexo-my-plugin/
├── lib/
│   ├── index.js         # 主文件
│   ├── filter.js        # 过滤器
│   ├── generator.js     # 生成器
│   └── console.js       # 命令
├── package.json
└── README.md
```

`lib/index.js`：

```javascript
'use strict';

module.exports = function(hexo) {
  // 加载各个模块
  require('./filter')(hexo);
  require('./generator')(hexo);
  require('./console')(hexo);
};
```

`lib/filter.js`：

```javascript
'use strict';

module.exports = function(hexo) {
  hexo.extend.filter.register('before_post_render', function(data) {
    // 过滤器逻辑
    return data;
  });
};
```

`lib/generator.js`：

```javascript
'use strict';

module.exports = function(hexo) {
  hexo.extend.generator.register('my-generator', function(locals) {
    return {
      path: 'my-page.html',
      layout: 'my-layout',
      data: {}
    };
  });
};
```

`lib/console.js`：

```javascript
'use strict';

module.exports = function(hexo) {
  hexo.extend.console.register('my-command', 'My command', {
    usage: 'hexo my-command',
    desc: 'Do something'
  }, function(args) {
    console.log('Command executed');
  });
};
```

`package.json`：

```json
{
  "name": "hexo-my-plugin",
  "version": "1.0.0",
  "description": "My Hexo plugin",
  "main": "lib/index.js",
  "scripts": {
    "test": "mocha"
  },
  "keywords": [
    "hexo",
    "plugin"
  ],
  "author": "Your Name",
  "license": "MIT",
  "peerDependencies": {
    "hexo": "^4.0.0 || ^5.0.0 || ^6.0.0"
  }
}
```

## 第二部分：Hexo 与 Git 集成

### 2.1 自动提交和推送

安装插件：

```bash
npm install hexo-git-commit --save
```

配置 `_config.yml`：

```yaml
git_commit:
  enabled: true
  message: "Site update: {{ now('YYYY-MM-DD HH:mm:ss') }}"
  branch: main
```

使用：

```bash
# 生成、提交和推送
hexo g && hexo git-commit -m "Blog update" && git push
```

或创建脚本 `scripts/auto-git.js`：

```javascript
'use strict';

hexo.extend.console.register('git-push', 'Auto commit and push', function(args) {
  const { spawn } = require('child_process');
  
  const commands = [
    ['git', ['add', '.']],
    ['git', ['commit', '-m', `Blog update: ${new Date().toISOString()}`]],
    ['git', ['push', 'origin', 'main']]
  ];
  
  let index = 0;
  
  function runCommand() {
    if (index >= commands.length) {
      console.log('✓ Git sync completed');
      return;
    }
    
    const [cmd, args] = commands[index++];
    const proc = spawn(cmd, args);
    
    proc.on('close', runCommand);
  }
  
  runCommand();
});
```

### 2.2 GitHub Actions 自动化

创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: 18
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Test links
        run: npm run test:links || true
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        if: github.ref == 'refs/heads/main'
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
      
      - name: Deploy to Netlify
        uses: netlify/actions/cli@master
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
        with:
          args: deploy --prod --dir=public
```

## 第三部分：Hexo 与数据库集成

### 3.1 使用 Algolia 实现搜索功能

安装插件：

```bash
npm install hexo-algolia --save
```

配置 `_config.yml`：

```yaml
algolia:
  applicationID: your-app-id
  apiKey: your-api-key
  indexName: your-index-name
  chunkSize: 5000
  fields:
    - objectID: post.path
      title: post.title
      url: post.url
      permalink: post.permalink
      excerpt: post.excerpt
      content: post.content
```

在主题模板中添加搜索框：

```html
<!-- 在 layout/_partial/header.ejs 中 -->
<div class="search-box">
  <input type="search" id="algolia-search" placeholder="搜索...">
  <ul id="search-results"></ul>
</div>

<script src="https://cdn.jsdelivr.net/npm/algoliasearch@4/dist/algoliasearch.umd.js"></script>
<link href="https://cdn.jsdelivr.net/npm/@docsearch/css@3" rel="stylesheet" />

<script>
const searchClient = algoliasearch('YOUR_APP_ID', 'YOUR_SEARCH_KEY');
const index = searchClient.initIndex('your-index-name');

document.getElementById('algolia-search').addEventListener('input', (e) => {
  if (e.target.value.length > 0) {
    index.search(e.target.value).then(({ hits }) => {
      const resultsHtml = hits.map(hit => `
        <li>
          <a href="${hit.permalink}">
            <strong>${hit.title}</strong>
            <p>${hit.excerpt}</p>
          </a>
        </li>
      `).join('');
      document.getElementById('search-results').innerHTML = resultsHtml;
    });
  }
});
</script>
```

部署：

```bash
# 推送索引数据到 Algolia
ALGOLIA_APP_ID=your-app-id ALGOLIA_ADMIN_API_KEY=your-admin-key npx hexo algolia
```

### 3.2 使用 Firebase 进行实时数据同步

安装 Firebase：

```bash
npm install firebase --save
```

创建 `scripts/firebase-sync.js`：

```javascript
'use strict';

const firebase = require('firebase/app');
require('firebase/database');

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};

firebase.initializeApp(firebaseConfig);
const db = firebase.database();

hexo.extend.filter.register('after_generate', function() {
  const posts = [];
  
  hexo.locals.get('posts').forEach(post => {
    posts.push({
      title: post.title,
      slug: post.slug,
      date: post.date,
      updated: post.updated,
      tags: post.tags.map(t => t.name),
      categories: post.categories.map(c => c.name)
    });
  });
  
  // 上传到 Firebase
  db.ref('posts').set(posts, (error) => {
    if (error) {
      console.error('Error uploading to Firebase:', error);
    } else {
      console.log('✓ Posts synced to Firebase');
    }
  });
});
```

## 第四部分：Hexo 与 API 集成

### 4.1 集成豆瓣电影/书籍

创建 `scripts/douban-sync.js`：

```javascript
'use strict';

const axios = require('axios');

hexo.extend.console.register('sync-douban', 'Sync Douban data', function(args) {
  const userId = args[0] || 'YOUR_DOUBAN_ID';
  
  // 获取豆瓣数据（使用第三方 API）
  axios.get(`https://api.douban.com/v2/user/${userId}`)
    .then(response => {
      const userData = response.data;
      
      // 创建文件
      const fs = require('fs');
      const path = require('path');
      
      const doubanFile = path.join(hexo.source_dir, '_data', 'douban.json');
      
      if (!fs.existsSync(path.dirname(doubanFile))) {
        fs.mkdirSync(path.dirname(doubanFile), { recursive: true });
      }
      
      fs.writeFileSync(doubanFile, JSON.stringify(userData, null, 2));
      console.log('✓ Douban data synced');
    })
    .catch(error => {
      console.error('Error syncing Douban:', error.message);
    });
});
```

在主题中使用：

```ejs
<% if (site.data.douban) { %>
  <div class="douban">
    <h2>我在豆瓣</h2>
    <p><%= site.data.douban.description %></p>
  </div>
<% } %>
```

### 4.2 集成 LeetCode 成就

创建 `scripts/leetcode-sync.js`：

```javascript
'use strict';

const axios = require('axios');

hexo.extend.console.register('sync-leetcode', 'Sync LeetCode data', function(args) {
  const username = args[0] || 'YOUR_LEETCODE_USERNAME';
  
  const query = `
    query {
      matchedUser(username: "${username}") {
        username
        profile {
          realName
          aboutMe
        }
        submitStats {
          totalSubmissionNum {
            difficulty
            count
            submissions
          }
        }
        problemsSolvedBeatsStats {
          difficulty
          percentage
        }
      }
    }
  `;
  
  axios.post('https://leetcode.com/graphql', {
    query: query
  })
    .then(response => {
      const data = response.data.data.matchedUser;
      
      const fs = require('fs');
      const path = require('path');
      
      const leetcodeFile = path.join(hexo.source_dir, '_data', 'leetcode.json');
      
      if (!fs.existsSync(path.dirname(leetcodeFile))) {
        fs.mkdirSync(path.dirname(leetcodeFile), { recursive: true });
      }
      
      fs.writeFileSync(leetcodeFile, JSON.stringify(data, null, 2));
      console.log('✓ LeetCode data synced');
    })
    .catch(error => {
      console.error('Error syncing LeetCode:', error.message);
    });
});
```

## 第五部分：Hexo 与 CMS 集成

### 5.1 与 Headless CMS 集成（如 Strapi）

安装依赖：

```bash
npm install axios lodash --save
```

创建 `scripts/strapi-sync.js`：

```javascript
'use strict';

const axios = require('axios');
const path = require('path');
const fs = require('fs');

const STRAPI_URL = 'http://localhost:1337';
const STRAPI_API_TOKEN = 'your-api-token';

hexo.extend.console.register('sync-strapi', 'Sync posts from Strapi', function(args) {
  const strapiClient = axios.create({
    baseURL: STRAPI_URL,
    headers: {
      'Authorization': `Bearer ${STRAPI_API_TOKEN}`
    }
  });
  
  strapiClient.get('/api/articles?populate=*')
    .then(response => {
      const posts = response.data.data;
      
      posts.forEach(post => {
        const frontMatter = `---
title: ${post.attributes.title}
date: ${new Date(post.attributes.createdAt).toISOString()}
updated: ${new Date(post.attributes.updatedAt).toISOString()}
tags:
${post.attributes.tags.data.map(tag => `  - ${tag.attributes.name}`).join('\n')}
categories:
${post.attributes.categories.data.map(cat => `  - ${cat.attributes.name}`).join('\n')}
---

${post.attributes.content}
`;
        
        const filename = path.join(
          hexo.source_dir,
          '_posts',
          `${post.attributes.slug}.md`
        );
        
        fs.writeFileSync(filename, frontMatter);
      });
      
      console.log(`✓ ${posts.length} posts synced from Strapi`);
      
      // 重新生成
      hexo.call('generate', {});
    })
    .catch(error => {
      console.error('Error syncing from Strapi:', error.message);
    });
});
```

### 5.2 与 Notion 集成

使用 `notion-to-md` 库：

```bash
npm install notion-to-md notion-client --save
```

创建 `scripts/notion-sync.js`：

```javascript
'use strict';

const { Client } = require('@notionhq/client');
const { NotionToMarkdown } = require('notion-to-md');
const path = require('path');
const fs = require('fs');

const notion = new Client({ auth: process.env.NOTION_TOKEN });
const n2m = new NotionToMarkdown({ notionClient: notion });

hexo.extend.console.register('sync-notion', 'Sync posts from Notion', function(args) {
  const databaseId = process.env.NOTION_DATABASE_ID;
  
  notion.databases.query({
    database_id: databaseId,
    filter: {
      property: 'Published',
      checkbox: { equals: true }
    }
  })
    .then(async (response) => {
      for (const page of response.results) {
        const markdown = await n2m.pageToMarkdown(page.id);
        const title = page.properties.Name.title[0].plain_text;
        const slug = page.properties.Slug.rich_text[0].plain_text;
        
        const frontMatter = `---
title: ${title}
date: ${new Date(page.created_time).toISOString()}
updated: ${new Date(page.last_edited_time).toISOString()}
---

${markdown}
`;
        
        const filename = path.join(
          hexo.source_dir,
          '_posts',
          `${slug}.md`
        );
        
        fs.writeFileSync(filename, frontMatter);
      }
      
      console.log(`✓ ${response.results.length} posts synced from Notion`);
      hexo.call('generate', {});
    })
    .catch(error => {
      console.error('Error syncing from Notion:', error.message);
    });
});

module.exports = {
  notion,
  n2m
};
```

## 第六部分：Hexo 与分析工具集成

### 6.1 与 Plausible Analytics 集成

在主题配置中添加：

```yaml
plausible_analytics:
  enabled: true
  domain: yourblog.com
```

在 `layout/layout.ejs` 中添加：

```html
<% if (theme.plausible_analytics && theme.plausible_analytics.enabled) { %>
  <script defer data-domain="<%= theme.plausible_analytics.domain %>" src="https://plausible.io/js/script.js"></script>
<% } %>
```

### 6.2 与 Umami 集成

```html
<!-- 在 layout/layout.ejs 中 -->
<script async src="https://analytics.example.com/script.js" data-website-id="your-website-id"></script>
```

### 6.3 自定义分析脚本

创建 `scripts/custom-analytics.js`：

```javascript
'use strict';

hexo.extend.filter.register('after_render:html', function(str, data) {
  const analyticsCode = `
<script>
  // 自定义分析
  document.addEventListener('DOMContentLoaded', function() {
    // 跟踪页面浏览
    window.pageView = {
      url: window.location.href,
      title: document.title,
      timestamp: new Date().toISOString()
    };
    
    // 发送到服务器
    fetch('/api/analytics', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(window.pageView)
    });
    
    // 跟踪点击
    document.addEventListener('click', function(e) {
      if (e.target.tagName === 'A') {
        console.log('Clicked:', e.target.href);
      }
    });
  });
</script>
  `;
  
  return str.replace('</body>', analyticsCode + '</body>');
});
```

## 第七部分：Hexo 与评论系统集成

### 7.1 与 Waline 集成

安装 Waline：

```bash
npm install @waline/client --save
```

在主题配置中添加：

```yaml
waline:
  enabled: true
  serverURL: https://waline.example.com
```

在 `layout/post.ejs` 中添加：

```ejs
<% if (theme.waline && theme.waline.enabled) { %>
  <div id="waline"></div>
  <script type="module">
    import { init } from 'https://unpkg.com/@waline/client';
    
    init({
      el: '#waline',
      serverURL: '<%= theme.waline.serverURL %>',
      path: window.location.pathname,
    });
  </script>
<% } %>
```

### 7.2 与 Giscus 集成

在 `layout/post.ejs` 中添加：

```ejs
<% if (theme.giscus && theme.giscus.enabled) { %>
  <script src="https://giscus.app/client.js"
          data-repo="<%= theme.giscus.repo %>"
          data-repo-id="<%= theme.giscus.repo_id %>"
          data-category="<%= theme.giscus.category %>"
          data-category-id="<%= theme.giscus.category_id %>"
          data-mapping="pathname"
          data-strict="0"
          data-reactions-enabled="1"
          data-emit-metadata="0"
          data-input-position="bottom"
          data-theme="light"
          data-lang="zh-CN"
          crossorigin="anonymous"
          async>
  </script>
<% } %>
```

主题配置：

```yaml
giscus:
  enabled: true
  repo: username/repo
  repo_id: R_kgDOXXXXXX
  category: Announcements
  category_id: DIC_kwDOXXXXXX4XXXX
```

## 第八部分：Hexo 工作流自动化

### 8.1 创建完整的发布工作流

创建 `scripts/publish-workflow.js`：

```javascript
'use strict';

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

function runCommand(command, args, description) {
  return new Promise((resolve, reject) => {
    console.log(`\n📝 ${description}...`);
    
    const proc = spawn(command, args, { 
      stdio: 'inherit',
      cwd: process.cwd()
    });
    
    proc.on('close', (code) => {
      if (code === 0) {
        console.log(`✓ ${description} completed`);
        resolve();
      } else {
        reject(new Error(`${description} failed with code ${code}`));
      }
    });
  });
}

hexo.extend.console.register('publish', 'Complete publish workflow', async function(args) {
  try {
    const title = args.join(' ') || 'Blog Update';
    
    // 1. 清理和生成
    await runCommand('npm', ['run', 'clean'], 'Cleaning');
    await runCommand('npm', ['run', 'build'], 'Building');
    
    // 2. 测试
    console.log('\n🧪 Running tests...');
    // 可以添加测试脚本
    
    // 3. Git 提交
    await runCommand('git', ['add', '.'], 'Staging files');
    await runCommand('git', ['commit', '-m', `feat: ${title}`], 'Committing');
    
    // 4. 推送
    await runCommand('git', ['push', 'origin', 'main'], 'Pushing to GitHub');
    
    // 5. 部署
    await runCommand('npm', ['run', 'deploy'], 'Deploying');
    
    console.log('\n🎉 Publish workflow completed!');
  } catch (error) {
    console.error('❌ Workflow failed:', error.message);
    process.exit(1);
  }
});
```

使用：

```bash
hexo publish "New blog post"
```

### 8.2 设置 package.json 脚本

```json
{
  "scripts": {
    "clean": "hexo clean",
    "build": "hexo generate",
    "server": "hexo server",
    "deploy": "hexo deploy",
    "draft": "hexo new draft",
    "publish": "hexo publish",
    "test:links": "node scripts/test-links.js",
    "dev": "npm run clean && npm run server"
  }
}
```

## 第九部分：性能监控与优化

### 9.1 页面性能监控

创建 `scripts/performance-monitor.js`：

```javascript
'use strict';

hexo.extend.filter.register('after_render:html', function(str, data) {
  const perfScript = `
<script>
  window.addEventListener('load', function() {
    // 获取性能数据
    const perfData = window.performance.timing;
    const pageLoadTime = perfData.loadEventEnd - perfData.navigationStart;
    
    // 记录指标
    const metrics = {
      url: window.location.href,
      loadTime: pageLoadTime,
      domInteractive: perfData.domInteractive - perfData.navigationStart,
      domComplete: perfData.domComplete - perfData.navigationStart,
      resourcesCount: window.performance.getEntriesByType('resource').length
    };
    
    console.log('Performance metrics:', metrics);
    
    // 发送到分析服务
    if (navigator.sendBeacon) {
      navigator.sendBeacon('/api/perf', JSON.stringify(metrics));
    }
  });
</script>
  `;
  
  return str.replace('</body>', perfScript + '</body>');
});
```

### 9.2 构建时间分析

```javascript
// scripts/build-time-analyzer.js
'use strict';

let startTime;

hexo.on('ready', function() {
  startTime = Date.now();
});

hexo.on('generateAfter', function() {
  const endTime = Date.now();
  const buildTime = endTime - startTime;
  console.log(`✓ Build completed in ${buildTime}ms`);
  
  if (buildTime > 30000) {
    console.warn('⚠️  Build time exceeds 30 seconds. Consider optimizing.');
  }
});
```

## 第十部分：Docker 容器化 Hexo

### 10.1 创建完整的 Docker 设置

`Dockerfile`：

```dockerfile
FROM node:18-alpine

WORKDIR /app

# 安装系统依赖
RUN apk add --no-cache git

# 复制 package 文件
COPY package*.json ./

# 安装 npm 依赖
RUN npm ci --only=production

# 复制源代码
COPY . .

# 生成静态文件
RUN npm run build

# 暴露端口
EXPOSE 4000

# 启动命令
CMD ["npm", "start"]
```

`docker-compose.yml`：

```yaml
version: '3.8'

services:
  hexo:
    build: .
    container_name: hexo-blog
    ports:
      - "4000:4000"
    volumes:
      - ./source:/app/source
      - ./themes:/app/themes
      - ./public:/app/public
    environment:
      - NODE_ENV=production
    restart: unless-stopped
  
  nginx:
    image: nginx:alpine
    container_name: hexo-nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./public:/usr/share/nginx/html
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - hexo
    restart: unless-stopped
```

## 第十一部分：安全最佳实践

### 11.1 隐藏敏感信息

使用环境变量：

```javascript
// scripts/secure-config.js
'use strict';

// 加载环境变量
require('dotenv').config();

hexo.extend.filter.register('before_generate', function() {
  // 不要在代码中硬编码敏感信息
  process.env.ALGOLIA_API_KEY = process.env.ALGOLIA_API_KEY;
  process.env.ANALYTICS_ID = process.env.ANALYTICS_ID;
});
```

`.env` 文件：

```
ALGOLIA_API_KEY=your-key
ANALYTICS_ID=your-id
GITHUB_TOKEN=your-token
```

### 11.2 内容安全策略

在 `_headers` 文件中添加（Netlify）：

```
/*
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  X-XSS-Protection: 1; mode=block
  Referrer-Policy: no-referrer-when-downgrade
  Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' cdn.jsdelivr.net; style-src 'self' 'unsafe-inline'
```

## 第十二部分：高级调试技巧

### 12.1 启用详细日志

```bash
# 启用调试模式
DEBUG=* hexo generate

# 只看 Hexo 的日志
DEBUG=hexo* hexo generate
```

### 12.2 创建调试脚本

```javascript
// scripts/debug-helper.js
'use strict';

hexo.extend.console.register('debug-posts', 'Debug posts data', function(args) {
  const posts = hexo.locals.get('posts');
  
  posts.forEach(post => {
    console.log('Post:', {
      title: post.title,
      slug: post.slug,
      date: post.date,
      tags: post.tags.map(t => t.name),
      categories: post.categories.map(c => c.name),
      path: post.path
    });
  });
});
```

## 总结

Hexo 高级功能和工具集成的要点：

✓ 理解事件系统和过滤器
✓ 开发自定义脚本和插件
✓ 与 Git 和 GitHub Actions 集成
✓ 连接外部数据源和 CMS
✓ 集成分析和评论系统
✓ 自动化发布工作流
✓ 优化性能和监控
✓ 使用 Docker 容器化
✓ 遵循安全最佳实践

通过这些高级技巧和集成，你可以将 Hexo 从一个简单的静态网站生成器发展成一个强大的、自动化的、功能丰富的博客平台。根据你的具体需求，选择合适的工具和技术进行整合，构建属于你的独特博客系统！
