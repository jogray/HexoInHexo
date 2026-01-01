# Hexo in Hexo 教程项目

本项目是一组面向 Hexo 博客搭建的中文教程合集，并提供可直接部署的示例站点。仓库内含快速入门、主题开发、部署托管、SEO 优化、进阶集成等完整文章，便于新手快速上手，也方便有经验的用户查阅要点。你可以使用本仓库作为练手内容生成静态站点并发布到 GitHub Pages 或任意静态托管平台。

## 仓库内容
- `QUICKSTART.md`：Hexo 核心概念与快速上手。
- `manual/`：系列进阶教程，包括：
  1) 文章写作与优化
  2) 主题开发与自定义
  3) 部署与托管
  4) SEO 优化
  5) 高级技巧与工具集成
- `Dockerfile`：开发环境镜像，方便本地预览。
- `Dockerfile.release`：发布镜像，按需生成静态站点并用轻量服务器提供访问。
- `compose.yml`：一条命令启动预览服务。
- `build.sh`：在容器内初始化 Hexo、注入教程并生成静态文件。

## 快速开始（Docker Compose）
1. 安装 Docker 与 Docker Compose。
2. 在仓库根目录执行：
   ```bash
   docker compose up --build -d
   ```
3. 浏览器访问 `http://localhost:40000` 预览教程站点。
4. 停止服务：
   ```bash
   docker compose down
   ```

## 手动构建（可选）
如需自定义构建流程：
```bash
npm install -g hexo-cli
./build.sh      # 初始化并生成静态站点到 blog/public
npx http-server blog/public -p 4000
```

## 自定义与发布
- 直接修改 `manual/` 下的教程或新增文章，重新执行 `build.sh` 即可生成。
- 若要部署到 GitHub Pages，可使用 `Dockerfile.release` 构建发布镜像，或在 CI 中执行 `hexo g -d` 将 `public/` 推送到 Pages 分支。
- 如有自定义域名，在生成后的 `public/CNAME` 写入域名并配置 DNS CNAME 指向你的 GitHub Pages 域名。

## 适用人群
- 希望快速上手 Hexo 的新手。
- 需要系统化教程的个人或团队。
- 想要一键预览、便捷部署到静态托管平台的用户。

## 许可
内容与示例遵循 MIT 许可证，欢迎二次创作与分享。