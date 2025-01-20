#!/bin/bash

# 创建必要的目录
mkdir -p /docker/redis/cluster/{redis1,redis2,redis3}/{data,logs}

# 设置目录权限
chown -R 1001:1001 /docker/redis/cluster
chmod -R 755 /docker/redis/cluster

# 系统参数优化
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 511 > /proc/sys/net/core/somaxconn
sysctl vm.overcommit_memory=1

# 启动容器
docker-compose -f redis-cluster-compose.yml up -d

# 等待容器启动
sleep 5

# 创建集群
docker exec -it redis1 redis-cli --cluster create \
  redis1:6379 redis2:6379 redis3:6379 \
  --cluster-replicas 0 -a yourpassword 