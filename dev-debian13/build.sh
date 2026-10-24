#!/bin/bash
set -e

IMAGE_NAME="debian13-i3-dev"
CONTAINER_NAME="debian13-dev"

# 构建镜像
echo "🔨 构建 Docker 镜像..."
docker build -t "$IMAGE_NAME" .

# 运行容器（映射 SSH 端口 2222 到容器 22，映射 xrdp 端口 3389）
echo "🚀 启动容器..."
docker run -d \
  --name "$CONTAINER_NAME" \
  --hostname debian13-dev \
  -p 2222:22 \
  -p 3389:3389 \
  --restart unless-stopped \
  "$IMAGE_NAME"

echo "✅ 容器已启动。"
echo "SSH 连接: ssh -X root@localhost -p 2222   （密码: 123456，请尽快修改）"
echo "如果使用 xrdp，可通过远程桌面连接 localhost:3389"
