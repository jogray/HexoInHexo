#!/bin/bash
set -euo pipefail

# Prepare toolchain and Hexo CLI
# 准备工具链和 Hexo 命令行工具
# Check if running in Alpine (Docker) or Ubuntu (GitHub Actions)
# 检查当前运行环境是 Alpine（Docker）还是 Ubuntu（GitHub Actions）
if command -v apk >/dev/null 2>&1; then
    apk add --no-cache git
elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y git
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y git
else
    echo "Unsupported package manager. Please install git manually."
    exit 1
fi

npm install hexo-cli -g

# Bootstrap Hexo project
# 初始化 Hexo 项目骨架
hexo init blog
cd blog
npm install

# Install Butterfly theme and required renderers
# 安装 Butterfly 主题及其渲染依赖
npm install hexo-theme-butterfly hexo-renderer-pug hexo-renderer-stylus

# Drop default hello-world to keep generated site clean
# 删除默认 hello-world 文章，保持站点内容干净
rm -f source/_posts/hello-world.md