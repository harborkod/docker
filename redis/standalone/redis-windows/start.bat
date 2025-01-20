@echo off

:: 创建必要的目录
mkdir C:\docker\redis\standalone\data
mkdir C:\docker\redis\standalone\logs

:: 启动容器
docker-compose -f redis-standalone-compose.yml up -d 