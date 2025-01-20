# Redis 单机版 - Windows

## 目录结构
redis-windows/├── config/ # 配置文件目录
│   └── redis.conf # Redis配置文件
├── redis-standalone-compose.yml # Docker编排文件
├── start.bat # 启动脚本
└── README.md # 说明文档

## 部署步骤
1. 创建必要的目录

bash
mkdir C:\docker\redis\standalone\data C:\docker\redis\standalone\logs

2. 启动服务

bash
start.bat

## 常用命令

### Docker 相关命令

bash
# 启动服务
docker-compose -f redis-standalone-compose.yml up -d

# 停止服务
docker-compose -f redis-standalone-compose.yml down

# 查看容器状态
docker ps | findstr redis-standalone

# 查看容器日志
docker logs redis-standalone

### Redis 客户端命令

bash
# 进入Redis容器
docker exec -it redis-standalone bash

# 使用Redis客户端连接（容器内）
redis-cli -a harborkod@redis@admin

# 使用Redis客户端连接（主机）
redis-cli -h localhost -p 6379 -a harborkod@redis@admin

### 持久化文件说明

bash
# 进入数据目录
cd /data

# 查看持久化文件
ls
appendonlydir  dump.rdb

# 查看AOF目录内容
cd appendonlydir
ls
appendonly.aof.1.base.rdb  appendonly.aof.1.incr.aof  appendonly.aof.manifest

# 查看RDB文件信息（检查文件完整性）
redis-check-rdb dump.rdb

# 查看RDB文件内容的方法：
# 方法1：通过redis-cli导入到Redis服务器
redis-cli -a harborkod@redis@admin
> SELECT 0
> FLUSHALL
> RESTORE key 0 filename

# 方法2：使用python工具rdb解析（需要安装）
pip install rdbtools python-lzf
rdb --command json dump.rdb

# 查看AOF文件内容
cat appendonlydir/appendonly.aof.1.incr.aof

# 检查AOF文件是否完整
redis-check-aof appendonlydir/appendonly.aof.1.incr.aof

文件说明：
1. dump.rdb：
   - RDB持久化文件
   - 二进制格式的数据快照
   - 不可直接查看，因为是二进制格式
   - 使用 redis-check-rdb 工具检查完整性
   - 需要使用专门的工具（如rdbtools）来解析内容
   - 或者通过导入到Redis服务器来查看数据

2. appendonlydir目录：
   - appendonly.aof.manifest：AOF文件清单，记录文件状态
   - appendonly.aof.1.base.rdb：基础AOF文件，RDB格式
   - appendonly.aof.1.incr.aof：增量AOF文件，记录新的写操作
   - 使用 redis-check-aof 工具检查文件完整性

注意：
1. RDB文件是二进制格式，不能直接查看内容
2. 需要专门的工具来解析RDB文件
3. AOF文件可以直接查看，因为是文本格式的命令记录
4. 建议使用官方工具进行文件检查
5. 不要手动修改这些文件，可能导致数据损坏

## 配置说明
- 端口：6379
- 密码：harborkod@redis@admin
- 最大内存：512MB
- 持久化：开启AOF和RDB
- 日志级别：notice
- 日志路径：/var/log/redis/redis.log

## 注意事项
1. 确保 Docker 已经正确安装并启动
2. 确保端口 6379 未被占用
3. 生产环境建议修改默认密码
4. 定期备份数据目录
5. 不要手动修改持久化文件，可能导致数据损坏 