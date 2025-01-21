#!/bin/bash

echo "[INFO] Starting Redis Standalone Server..."

# 检查并拉取镜像
echo "[INFO] Checking Redis image..."
if ! docker images | grep -q "redis.*7.2.4"; then
    echo "[INFO] Redis image not found, pulling from registry..."
    docker pull redis:7.2.4
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to pull Redis image. Please check your network connection."
        exit 1
    fi
fi

# 创建必要的目录
echo "[INFO] Creating directories..."
mkdir -p /docker/redis/standalone/{data,logs}

# 设置目录权限
echo "[INFO] Setting directory permissions..."
chown -R 1001:1001 /docker/redis
chmod -R 755 /docker/redis

# 系统参数优化
echo "[INFO] Optimizing system parameters..."
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 511 > /proc/sys/net/core/somaxconn
sysctl vm.overcommit_memory=1

# 启动容器
echo "[INFO] Starting Redis container..."
docker-compose -f redis-standalone-compose.yml up -d

# 等待容器启动
echo "[INFO] Waiting for container to start..."
sleep 3

# 检查容器状态
echo "[INFO] Checking container status..."
if docker ps | grep redis-standalone > /dev/null; then
    echo "[SUCCESS] Redis Standalone Server is running."
    echo "[INFO] Container ID: $(docker ps -q -f name=redis-standalone)"
    echo "[INFO] You can connect to Redis using: redis-cli -h localhost -p 6379 -a harborkod@redis@admin"
else
    echo "[ERROR] Redis Standalone Server failed to start."
    echo "[INFO] Checking container logs..."
    docker logs redis-standalone
    exit 1
fi 