#!/bin/sh
set -euo pipefail

# Prepare toolchain and Hexo CLI
# Check if running in Alpine (Docker) or Ubuntu (GitHub Actions)
if command -v apk >/dev/null 2>&1; then
    apk add --no-cache git
else
    apt-get update
    apt-get install -y git
fi

npm install hexo-cli -g

# Bootstrap Hexo project
hexo init blog
cd blog
npm install

# Drop default hello-world to keep generated site clean
rm -f source/_posts/hello-world.md

# Configure Hexo for Chinese
sed -i "s/language: en/language: zh-CN/" _config.yml
sed -i "s/timezone: ''/timezone: Asia\/Shanghai/" _config.yml
sed -i "s/title: Hexo/title: Hexo 中文教程/" _config.yml
sed -i "s/subtitle: ''/subtitle: 从入门到精通/" _config.yml
sed -i "s/description: ''/description: 详细的 Hexo 博客搭建教程，包括安装、配置、主题、部署、SEO 优化等/" _config.yml
sed -i "s/author: John Doe/author: Hexo in Hexo/" _config.yml

# Add quickstart and manuals as posts
# Function to add Front-matter to a file
add_frontmatter() {
    local input_file="$1"
    local output_file="$2"
    local title="$3"
    
    # Extract first heading as title if not provided
    if [ -z "$title" ]; then
        title=$(grep -m 1 '^#' "$input_file" | sed 's/^#* *//')
    fi
    
    # Generate Front-matter and prepend to file (skip first heading to avoid duplication)
    {
        echo "---"
        echo "title: $title"
        echo "date: $(date -u +%Y-%m-%d\ %H:%M:%S)"
        echo "updated: $(date -u +%Y-%m-%d\ %H:%M:%S)"
        echo "---"
        echo ""
        # Skip the first line that starts with # (the main title)
        sed '1{/^#/d;}' "$input_file"
    } > "$output_file"
}

# Process QUICKSTART.md
add_frontmatter "../QUICKSTART.md" "source/_posts/00-quickstart.md" "Hexo 快速使用教程"

# Process manual files
for file in ../manual/*.md; do
    [ -e "$file" ] || continue
    filename=$(basename "$file")
    title=$(grep -m 1 '^#' "$file" | sed 's/^#* *//')
    add_frontmatter "$file" "source/_posts/$filename" "$title"
done

# Build static site
hexo generate