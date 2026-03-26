# Hexo 部署与托管完全指南

## 引言

将你的 Hexo 博客部署到互联网上，让全世界都能访问，是博客之旅的重要一步。本教程详细介绍如何将 Hexo 博客部署到各种主流平台。

## 第一部分：部署前准备

### 1.1 生成静态文件

在部署之前，必须生成静态网站文件：

```bash
hexo clean      # 清理缓存和已生成的文件
hexo generate   # 生成静态文件到 public/ 目录
```

或者一次性完成：

```bash
hexo g          # 简写
```

生成的文件位于 `public/` 目录，这就是最终要部署的内容。

### 1.2 本地预览生成的网站

```bash
hexo server     # 启动本地服务器预览
```

访问 `http://localhost:4000` 查看生成的网站效果，确认没有问题再部署。

### 1.3 配置部署信息

在根目录的 `_config.yml` 中配置部署选项：

```yaml
deploy:
  type: git
  repo: https://github.com/username/username.github.io.git
  branch: main
```

不同的部署方式有不同的配置，后文会详细介绍。

## 第二部分：GitHub Pages 部署（最流行）

### 2.1 前置要求

- GitHub 账户
- Git 已安装
- 已生成的静态文件

### 2.2 创建 GitHub Pages 仓库

1. 登录 GitHub
2. 创建新仓库，仓库名必须为：`username.github.io`
   - 例如：`zhangsan.github.io`（其中 zhangsan 是你的用户名）
3. 确保仓库是公开的（Public）

### 2.3 安装部署工具

```bash
npm install hexo-deployer-git --save
```

### 2.4 配置部署

编辑 `_config.yml`：

```yaml
deploy:
  type: git
  repo: https://github.com/username/username.github.io.git
  branch: main      # GitHub Pages 默认使用 main 或 master 分支
  message: "Site updated: {{ now('YYYY-MM-DD HH:mm:ss') }}"  # 提交信息
```

或者使用 SSH（需要配置 SSH 密钥）：

```yaml
deploy:
  type: git
  repo: git@github.com:username/username.github.io.git
  branch: main
```

### 2.5 一键部署

```bash
hexo clean && hexo generate && hexo deploy
```

或使用简写：

```bash
hexo g -d
```

或逐步执行：

```bash
hexo clean
hexo generate
hexo deploy
```

### 2.6 验证部署

1. 在浏览器中访问 `https://username.github.io`
2. 等待 1-5 分钟让 DNS 生效
3. 检查网站是否正常显示

### 2.7 配置自定义域名（可选）

如果你有自己的域名，可以将其指向 GitHub Pages：

1. 在仓库中创建文件 `public/CNAME`（Hexo 会自动生成）
   ```
   yourdomain.com
   ```

2. 在 Hexo 项目中，编辑 `source/CNAME` 文件：
   ```
   yourdomain.com
   ```

3. 在你的域名 DNS 设置中，添加 CNAME 记录：
   ```
   别名: www
   指向: username.github.io
   ```

   或添加 A 记录指向 GitHub Pages IP：
   ```
   主机: @
   类型: A
   值: 185.199.108.153
        185.199.109.153
        185.199.110.153
        185.199.111.153
   ```

4. 等待 DNS 生效（通常 24 小时内）

### 2.8 启用 HTTPS

1. 在 GitHub 仓库设置中找到 "Pages" 选项
2. 勾选 "Enforce HTTPS"

GitHub 会自动为你申请 SSL 证书。

## 第三部分：Netlify 部署（推荐）

Netlify 相比 GitHub Pages 提供了更多功能，包括自动构建、预览等。

### 3.1 准备工作

- 有 Git 仓库（GitHub、GitLab、Bitbucket）
- Netlify 账户

### 3.2 连接仓库

1. 访问 [netlify.com](https://netlify.com)
2. 点击 "Sign up"，使用 GitHub 账户登录
3. 点击 "New site from Git"
4. 选择你的 Git 提供商（GitHub）
5. 授权 Netlify 访问你的仓库

### 3.3 配置构建设置

1. 选择包含 Hexo 博客的仓库
2. 配置构建设置：
   - **Build command**: `hexo generate` 或 `hexo g`
   - **Publish directory**: `public`

3. 点击 "Deploy site"

### 3.4 自动部署

现在每次你推送代码到仓库时，Netlify 会自动：
1. 拉取最新代码
2. 运行构建命令
3. 部署新版本

```bash
# 只需 push 到 GitHub
git add .
git commit -m "Update blog"
git push origin main
```

### 3.5 配置自定义域名

1. 在 Netlify 网站设置中，找到 "Domain settings"
2. 点击 "Add custom domain"
3. 输入你的域名
4. 按照提示修改 DNS 记录

### 3.6 启用自动续期 SSL

Netlify 会自动为你的自定义域名申请和续期 SSL 证书，无需额外配置。

### 3.7 高级功能

**环境变量**：
在 "Build & deploy" → "Environment" 中添加环境变量，可在构建时使用。

**构建钩子**：
在 "Build & deploy" → "Build hooks" 中创建 URL，可通过 POST 请求触发部署：

```bash
curl -X POST https://api.netlify.com/build_hooks/xxxxx
```

**重定向和代理**：
在根目录创建 `_redirects` 文件：

```
/old-post/* /new-post/:splat 301
/about /about-me 200
```

## 第四部分：Vercel 部署

Vercel 是 Next.js 团队开发的平台，性能优秀。

### 4.1 准备工作

- Git 仓库
- Vercel 账户

### 4.2 部署步骤

1. 访问 [vercel.com](https://vercel.com)
2. 点击 "Import Project"
3. 选择 "Import Git Repository"
4. 连接你的 GitHub 账户并选择仓库

### 4.3 配置项目

1. 在项目设置中：
   - **Framework**: 选择 "Other"
   - **Build Command**: `hexo generate`
   - **Output Directory**: `public`

2. 点击 "Deploy"

### 4.4 自定义域名

1. 项目 → Settings → Domains
2. 添加你的域名
3. 更新 DNS 记录

### 4.5 环境变量

项目 → Settings → Environment Variables，添加构建时所需的变量。

## 第五部分：腾讯云（国内）

对于使用国内域名的用户，腾讯云或阿里云可能是更好的选择。

### 5.1 云开发静态托管

1. 访问腾讯云云开发 [cloudbase.net](https://cloudbase.net)
2. 创建环境
3. 进入静态托管

### 5.2 部署方法

**方法一：Web 控制台**
1. 进入静态托管
2. 创建部署
3. 上传 `public/` 目录中的文件

**方法二：命令行部署**

```bash
# 安装工具
npm install -g @cloudbase/cli

# 登录
cloudbase login

# 部署
cloudbase hosting:deploy public/ -e your-env-id
```

**方法三：自动化部署**

配置 GitHub Actions：

在仓库中创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to Tencent CloudBase

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Install dependencies
        run: npm install
      
      - name: Build with Hexo
        run: npm run build
      
      - name: Deploy to CloudBase
        env:
          SECRET_ID: ${{ secrets.TENCENT_SECRET_ID }}
          SECRET_KEY: ${{ secrets.TENCENT_SECRET_KEY }}
        run: |
          npm install -g @cloudbase/cli
          cloudbase login --secret-id $SECRET_ID --secret-key $SECRET_KEY
          cloudbase hosting:deploy public/ -e your-env-id
```

### 5.3 配置自定义域名

1. 在云开发控制台 → 静态托管 → 域名管理
2. 添加自定义域名
3. 配置 DNS 记录

## 第六部分：阿里云（国内）

### 6.1 对象存储 OSS 部署

1. 登录阿里云控制台
2. 进入对象存储 OSS
3. 创建 Bucket
4. 启用静态网站托管

### 6.2 安装部署工具

```bash
npm install hexo-deployer-aliyun --save
```

### 6.3 配置部署

```yaml
deploy:
  type: aliyun
  accessKeyId: your-access-key-id
  accessKeySecret: your-access-key-secret
  bucket: your-bucket-name
  endpoint: oss-cn-hangzhou.aliyuncs.com
  cdnPath: /
  assetPath: assets/
```

获取 AccessKey：
1. 登录阿里云控制台
2. 点击账户头像 → AccessKey 管理
3. 创建新的 AccessKey

### 6.4 部署

```bash
hexo clean && hexo generate && hexo deploy
```

### 6.5 配置 CDN（加速访问）

1. 进入阿里云 CDN 控制台
2. 创建 CDN 加速域名
3. 选择 OSS 作为源站
4. 配置 DNS 指向 CDN

## 第七部分：Docker 容器部署

如果想在自己的服务器上部署，可以使用 Docker：

### 7.1 创建 Dockerfile

```dockerfile
FROM node:18-alpine

WORKDIR /app

# 安装 Hexo CLI
RUN npm install -g hexo-cli

# 复制项目文件
COPY . .

# 安装依赖
RUN npm install

# 生成静态文件
RUN hexo generate

# 安装 web 服务器
RUN npm install -g http-server

# 暴露端口
EXPOSE 8080

# 启动服务
CMD ["http-server", "public", "-p", "8080"]
```

### 7.2 构建 Docker 镜像

```bash
docker build -t my-hexo-blog .
```

### 7.3 运行容器

```bash
docker run -p 8080:8080 my-hexo-blog
```

### 7.4 使用 Docker Compose

创建 `docker-compose.yml`：

```yaml
version: '3'

services:
  blog:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - ./source:/app/source
      - ./themes:/app/themes
    environment:
      - NODE_ENV=production
```

运行：

```bash
docker-compose up -d
```

## 第八部分：使用 GitHub Actions 自动部署

无需在本地执行部署命令，每次 push 时自动部署。

### 8.1 创建 GitHub Actions 工作流

在仓库中创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy

on:
  push:
    branches:
      - main  # 监听 main 分支的推送

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: 18
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

### 8.2 配置工作流触发条件

上述工作流会在：
- 推送到 main 分支时自动触发
- 也可以手动触发（在 Actions 标签页）

### 8.3 高级配置

**仅在特定文件变化时部署**：

```yaml
on:
  push:
    branches: [main]
    paths:
      - 'source/**'
      - 'themes/**'
      - '_config.yml'
      - 'package.json'
```

**定时部署**：

```yaml
on:
  schedule:
    - cron: '0 0 * * 0'  # 每周日午夜
```

**手动触发**：

```yaml
on:
  workflow_dispatch:
```

## 第九部分：性能优化部署

### 9.1 启用 Gzip 压缩

Netlify 和 Vercel 默认启用，GitHub Pages 需要手动配置：

创建 `.htaccess` 文件（如果使用 Apache）：

```apache
<IfModule mod_deflate.c>
  AddOutputFilterByType DEFLATE text/html
  AddOutputFilterByType DEFLATE text/plain
  AddOutputFilterByType DEFLATE text/xml
  AddOutputFilterByType DEFLATE text/css
  AddOutputFilterByType DEFLATE text/javascript
  AddOutputFilterByType DEFLATE application/javascript
</IfModule>
```

### 9.2 缓存控制

添加到 `_headers` 文件（Netlify）：

```
/
  Cache-Control: max-age=3600

/css/*
  Cache-Control: max-age=31536000

/js/*
  Cache-Control: max-age=31536000

/images/*
  Cache-Control: max-age=31536000
```

### 9.3 使用 CDN

推荐的 CDN 服务：
- Cloudflare（免费版即可）
- Bunny CDN
- jsDelivr（用于 npm 包）

以 Cloudflare 为例：
1. 注册 Cloudflare 账户
2. 添加你的域名
3. 修改 DNS 记录指向 Cloudflare
4. Cloudflare 会自动缓存静态文件

## 第十部分：监控与维护

### 10.1 设置部署通知

GitHub Actions 失败时会发送邮件通知，也可以配置 Webhook：

```yaml
- name: Notify on failure
  if: failure()
  run: |
    curl -X POST https://your-webhook-url \
      -H 'Content-Type: application/json' \
      -d '{"text":"Deployment failed"}'
```

### 10.2 部署日志检查

- **GitHub Pages**: 仓库 → Settings → Pages，查看最近的构建
- **Netlify**: Deploys 标签页查看部署历史
- **Vercel**: Deployments 标签页查看部署日志

### 10.3 回滚部署

如果部署出现问题：

**GitHub Pages**：
推送之前的代码版本：

```bash
git revert <commit-hash>
git push
```

**Netlify/Vercel**：
在部署历史中点击之前的部署版本，点击 "Redeploy"

### 10.4 性能监控

使用 Google PageSpeed Insights 检查性能：

https://pagespeed.web.dev/

或 Lighthouse：

```bash
# 安装
npm install -g lighthouse

# 运行
lighthouse https://yourblog.com --view
```

## 第十一部分：故障排除

### Q1: 部署成功但网站显示 404

**原因**：
- GitHub Pages 仓库名称错误
- 分支设置错误

**解决**：
```bash
# 确保仓库名为 username.github.io
# GitHub Pages 设置中检查 Source 分支是否正确
```

### Q2: 网站样式丢失或图片不显示

**原因**：
- `_config.yml` 中的 URL 配置错误

**解决**：
```yaml
# 如果在子目录（如 username.github.io/blog）
url: https://username.github.io/blog
root: /blog/
```

### Q3: 部署很慢

**原因**：
- 静态文件过大
- 网络连接慢

**解决**：
```bash
# 压缩图片
npm install hexo-image-link --save

# 启用增量部署
# Netlify 自动支持
```

### Q4: 自定义域名不生效

**原因**：
- DNS 记录配置错误
- DNS 未生效

**解决**：
```bash
# 检查 DNS 解析
nslookup yourdomain.com

# 使用 dig 命令查看详细信息
dig yourdomain.com
```

### Q5: HTTPS 证书错误

**原因**：
- DNS 未完全生效
- 域名配置不匹配

**解决**：
- 等待 DNS 完全生效（最多 24 小时）
- 确认 CNAME 记录指向正确的主机

## 第十二部分：最佳实践

### 12.1 选择合适的部署方案

| 平台 | 优点 | 缺点 | 适合场景 |
|------|------|------|---------|
| GitHub Pages | 免费、集成度高 | 国外访问快 | 个人博客 |
| Netlify | 功能丰富、自动构建 | 国外访问快 | 中等规模 |
| Vercel | 性能优秀、自动优化 | 国外访问快 | 高性能需求 |
| 腾讯云 | 国内快速、便宜 | 配置复杂 | 国内用户 |
| 阿里云 | 国内快速、功能全 | 需备案 | 国内用户 |
| 自建服务器 | 完全控制、私密 | 维护复杂 | 企业级博客 |

### 12.2 部署前检查清单

```bash
# 清理缓存
hexo clean

# 本地生成和预览
hexo generate
hexo server

# 检查生成的文件
ls -la public/

# 确认 public/ 目录不在 .gitignore 中（可选）
cat .gitignore | grep public

# 提交代码
git add .
git commit -m "blog update"
git push
```

### 12.3 定期维护

- 每月检查部署日志
- 定期更新依赖包
- 监控网站性能
- 备份重要文章

## 第十三部分：与 CDN 的集成

### 13.1 配置 Cloudflare

1. 注册 Cloudflare 账户
2. 添加网站
3. 修改域名 NS 记录为 Cloudflare 提供的值
4. 在 Cloudflare 中启用：
   - Auto Minify（自动压缩）
   - Brotli（高效压缩）
   - Rocket Loader（JavaScript 优化）

### 13.2 缓存规则

在 Cloudflare Rules 中创建缓存规则：

```
路径: /css/* → Cache Level: Cache Everything
路径: /js/* → Cache Level: Cache Everything
路径: /images/* → Cache Level: Cache Everything
路径: / → Cache Level: Standard
```

### 13.3 安全设置

启用 Cloudflare 的安全功能：
- DDoS 防护
- WAF 规则
- Bot 管理
- 速率限制

## 总结

Hexo 博客部署的关键点：

✓ 根据地域选择合适的部署平台
✓ 配置自动化部署流程
✓ 启用 HTTPS 保护用户隐私
✓ 使用 CDN 加速全球访问
✓ 定期监控和维护
✓ 建立备份和回滚机制
✓ 优化部署性能和访问速度

无论选择哪个平台，遵循这些最佳实践能确保你的博客稳定、快速、安全地为读者服务！
