#!/bin/bash
set -euo pipefail

cd blog
# Configure Hexo for Chinese
# 配置 Hexo 的中文相关选项
sed -i "s/language: en/language: zh/" _config.yml
sed -i "s/timezone: ''/timezone: Asia\/Shanghai/" _config.yml
sed -i "s/title: Hexo/title: Hexo 中文教程/" _config.yml
sed -i "s/subtitle: ''/subtitle: 从入门到精通/" _config.yml
sed -i "s/description: ''/description: 详细的 Hexo 博客搭建教程，包括安装、配置、主题、部署、SEO 优化等/" _config.yml
sed -i "s/author: John Doe/author: Hexo in Hexo/" _config.yml

# Configure URL/root for local and GitHub Pages
# 为本地与 GitHub Pages 分别配置 URL 与根路径
if [ -n "${GITHUB_REPOSITORY:-}" ]; then
    repo_owner="${GITHUB_REPOSITORY%%/*}"
    repo_name="${GITHUB_REPOSITORY##*/}"
    site_url="https://${repo_owner}.github.io/${repo_name}"
    site_root="/${repo_name}/"
else
    site_url="http://localhost:4000"
    site_root="/"
fi

# Hexo versions may not include `root` in default _config.yml.
# Newer Hexo 默认配置可能不包含 root 字段，需要在缺失时追加。
if grep -q '^url:' _config.yml; then
    sed -i "s|^url:.*|url: ${site_url}|" _config.yml
else
    printf 'url: %s\n' "${site_url}" >> _config.yml
fi

if grep -q '^root:' _config.yml; then
    sed -i "s|^root:.*|root: ${site_root}|" _config.yml
else
    sed -i "/^url:/a root: ${site_root}" _config.yml
fi

# Add quickstart and manuals as posts
# 将 QUICKSTART 和 manual 目录内容作为文章导入
# Function to add Front-matter to a file
# 为文件添加 Front-matter 的函数
add_frontmatter() {
    local input_file="$1"
    local output_file="$2"
    local title="$3"
    
    # 检查变量 $title 是否为空字符串
    # Check whether the $title variable is an empty string
    # -z 选项用于测试字符串长度是否为零
    # The -z option tests whether the string length is zero
    if [ -z "$title" ]; then
        title=$(grep -m 1 '^#' "$input_file" | sed 's/^#* *//')
    fi
    
    # Generate Front-matter and prepend to file (skip first heading to avoid duplication)
    # 生成 Front-matter 并写入文件头（跳过第一个标题避免重复）
    {
        echo "---"
        echo "title: $title"
        echo "date: $(date -u +%Y-%m-%d\ %H:%M:%S)"
        echo "updated: $(date -u +%Y-%m-%d\ %H:%M:%S)"
        echo "---"
        echo ""
        # Skip the first line that starts with # (the main title)
        # 跳过以 # 开头的第一行（主标题行）
        sed '1{/^#/d;}' "$input_file"
    } > "$output_file"
}

# Process QUICKSTART.md
# 处理 QUICKSTART.md
add_frontmatter "../QUICKSTART.md" "source/_posts/00-quickstart.md" "Hexo 快速使用教程"

# Process manual files
# 处理 manual 目录中的教程文件
for file in ../manual/*.md; do
    [ -e "$file" ] || continue
    filename=$(basename "$file")
    title=$(grep -m 1 '^#' "$file" | sed 's/^#* *//')
    add_frontmatter "$file" "source/_posts/$filename" "$title"
done

# Build static site
# 生成静态站点文件
hexo generate