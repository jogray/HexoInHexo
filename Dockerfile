FROM node:24-alpine AS builder
WORKDIR /app

# 先复制构建脚本（只有它变化时才重新执行后续步骤）
COPY build.sh ./
RUN chmod +x ./build.sh

# 复制文档文件（只有文档变化时才影响这一层）
COPY QUICKSTART.md ./
COPY manual/ ./manual/

# 执行构建（会被缓存，除非上面的文件变了）
RUN ./build.sh

WORKDIR /app/blog
CMD ["hexo", "server", "-i", "0.0.0.0", "-p", "4000"]
EXPOSE 4000

FROM busybox:stable-glibc AS release
WORKDIR /app
COPY --from=builder /app/blog/public ./public
CMD ["httpd", "-f", "-p", "4000", "-h", "/app/public"]
EXPOSE 4000
