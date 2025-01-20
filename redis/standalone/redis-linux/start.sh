#!/bin/bash

# 创建必要的目录
mkdir -p /docker/redis/standalone/{data,logs}
mkdir -p /var/redis

# 设置目录权限，只需设置到/docker/redis这一层
chown -R 1001:1001 /docker/redis
chmod -R 755 /docker/redis
chown -R 1001:1001 /var/redis
chmod -R 755 /var/redis

# 系统参数优化
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo 511 > /proc/sys/net/core/somaxconn
sysctl vm.overcommit_memory=1

# 启动容器
docker-compose -f redis-standalone-compose.yml up -d 