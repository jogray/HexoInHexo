FROM node:24-alpine AS builder
WORKDIR /app

# Install bash for build script compatibility
# 安装 bash 以兼容构建脚本
RUN apk add --no-cache bash git

COPY require.sh ./
RUN --mount=type=cache,sharing=private,target=/root/.npm chmod +x ./require.sh && ./require.sh

# 先复制构建脚本（只有它变化时才重新执行后续步骤）
COPY build.sh ./

# 复制文档文件（只有文档变化时才影响这一层）
COPY . ./

# Allow workflow-provided GitHub context inside build stage.
ARG GITHUB_REPOSITORY=
ARG GITHUB_ACTOR=
ENV GITHUB_REPOSITORY=$GITHUB_REPOSITORY
ENV GITHUB_ACTOR=$GITHUB_ACTOR

# 执行构建（会被缓存，除非上面的文件变了）
RUN --mount=type=cache,sharing=private,target=/root/.npm chmod +x ./build.sh && ./build.sh

WORKDIR /app/blog
CMD ["hexo", "server", "-i", "0.0.0.0", "-p", "4000"]
EXPOSE 4000

FROM busybox:stable-glibc AS release
WORKDIR /app
COPY --from=builder /app/blog/public ./public
CMD ["httpd", "-f", "-p", "4000", "-h", "/app/public"]
EXPOSE 4000

FROM scratch AS final
COPY --from=release /app/public /
