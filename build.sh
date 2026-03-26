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

# Switch theme to Butterfly
# 切换为 Butterfly 主题
if grep -q '^theme:' _config.yml; then
    sed -i "s|^theme:.*|theme: butterfly|" _config.yml
else
    printf 'theme: butterfly\n' >> _config.yml
fi

# Configure URL/root for local and GitHub Pages
# 为本地与 GitHub Pages 分别配置 URL 与根路径
# -n 选项用于测试字符串是否非空
if [ -n "${GITHUB_REPOSITORY:-}" ]; then
    repo_owner="${GITHUB_REPOSITORY%%/*}" # 去掉最后一个斜杠及其后的部分，得到仓库所有者
    repo_name="${GITHUB_REPOSITORY##*/}" # 去掉最后一个斜杠及其前的部分，得到仓库名称
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

# Configure Butterfly profile/social links
# 配置 Butterfly 右侧个人卡片与社交链接
if [ -n "${GITHUB_REPOSITORY:-}" ]; then
    github_owner="${GITHUB_REPOSITORY%%/*}"
elif [ -n "${GITHUB_ACTOR:-}" ]; then
    github_owner="${GITHUB_ACTOR}"
else
    github_owner="$(git -C .. config --get remote.origin.url 2>/dev/null | sed -E 's#.*github.com[:/]([^/]+)/.*#\1#' || true)"
    github_owner="${github_owner:-jogray}"
fi

cat > _config.butterfly.yml <<EOF
avatar:
    img: https://github.com/${github_owner}.png?size=256

aside:
    card_author:
        button:
            enable: true
            icon: fab fa-github
            text: GitHub
            link: https://github.com/${github_owner}

social:
  fab fa-github: https://github.com/${github_owner} || GitHub
EOF

# Resolve a source file path to repository-relative path
# 将源文件路径转换为仓库相对路径
to_repo_path() {
    local input_file="$1"
    echo "${input_file#../}"
}

# Get first/last commit timestamps from git history
# 从 Git 历史中获取首次/最近提交时间
get_git_created_at() {
    local input_file="$1"
    local repo_path
    repo_path=$(to_repo_path "$input_file")
    git -C .. log --follow --format=%aI -- "$repo_path" 2>/dev/null | tail -n 1 || true
}

get_git_updated_at() {
    local input_file="$1"
    local repo_path
    repo_path=$(to_repo_path "$input_file")
    git -C .. log --follow -1 --format=%aI -- "$repo_path" 2>/dev/null || true
}

# Convert epoch seconds to ISO 8601 UTC
# 将 epoch 秒转换为 ISO 8601 UTC
epoch_to_iso_utc() {
    local epoch="$1"
    date -u -d "@${epoch}" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null \
        || date -u -r "${epoch}" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null \
        || node -e "console.log(new Date(Number(process.argv[1]) * 1000).toISOString().replace(/\.\d{3}Z$/, 'Z'))" "${epoch}"
}

# Get file mtime in ISO 8601 UTC as a no-git fallback
# 无 Git 历史时用文件修改时间（ISO 8601 UTC）兜底
get_file_mtime_at() {
    local input_file="$1"
    local epoch
    epoch=$(stat -c %Y "$input_file" 2>/dev/null || stat -f %m "$input_file" 2>/dev/null || true)
    if [ -n "${epoch}" ]; then
        epoch_to_iso_utc "${epoch}"
    fi
}

# Add quickstart and manuals as posts
# 将 QUICKSTART 和 manual 目录内容作为文章导入
# Function to add Front-matter to a file
# 为文件添加 Front-matter 的函数
add_frontmatter() {
    local input_file="$1"
    local output_file="$2"
    local title="$3"
    local created_at
    local updated_at
    
    # 检查变量 $title 是否为空字符串
    # Check whether the $title variable is an empty string
    # -z 选项用于测试字符串长度是否为零
    # The -z option tests whether the string length is zero
    if [ -z "$title" ]; then
        title=$(grep -m 1 '^#' "$input_file" | sed 's/^#* *//')
    fi

    created_at=$(get_git_created_at "$input_file")
    updated_at=$(get_git_updated_at "$input_file")

    # Fallback for files without git history (e.g. in Docker build context)
    # 无 Git 历史时（例如 Docker 构建上下文）回退到文件 mtime
    if [ -z "$created_at" ]; then
        created_at=$(get_file_mtime_at "$input_file")
    fi
    if [ -z "$updated_at" ]; then
        updated_at="$created_at"
    fi

    # Last safety net if mtime cannot be resolved
    # mtime 仍无法获取时使用当前 UTC 作为最终兜底
    if [ -z "$created_at" ]; then
        created_at=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    fi
    if [ -z "$updated_at" ]; then
        updated_at="$created_at"
    fi
    
    # Generate Front-matter and prepend to file (skip first heading to avoid duplication)
    # 生成 Front-matter 并写入文件头（跳过第一个标题避免重复）
    {
        echo "---"
        echo "title: $title"
        echo "date: $created_at"
        echo "updated: $updated_at"
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