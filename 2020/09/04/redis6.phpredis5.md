[返回主页](../../../README.md)

## Redis

### 编译安装
```bash
# 进入下载目录
cd /home/download

# 下载redis
curl -LO http://download.redis.io/releases/redis-6.0.7.tar.gz

# 解压并进入目录
tar -xf redis-6.0.7.tar.gz
cd redis-6.0.7

# 所需依赖，可能还需要 gcc gcc-c++ 之类的依赖，但我当前已有
dnf install -y systemd-devel

# 执行安装
# make PREFIX=/opt/redis-6.0.7 BUILD_WITH_SYSTEMD=yes USE_SYSTEMD=yes install
make PREFIX=/opt/redis-6.0.7 install
```

### 环境设置
```bash
# 调整配置文件
cp /home/download/redis-6.0.7/redis.conf /opt/redis-6.0.7/redis.conf
vi /opt/redis-6.0.7/redis.conf

# 配置文件内容调整如下
bind 192.168.2.12
protected-mode no
# 官方systemd有问题，暂时只能设置为no，当前日期：2020-09-04 17:35
daemonize no
supervised systemd
requirepass 123456

# 设置环境变量
vi /etc/profile

# 追加或调整以下内容
REDIS=/opt/redis-6.0.7
PATH=$PATH:$REDIS/bin

# 重启后环境变量生效

# 设置Systemctl服务
# 可以参考官方示例，就在源码包下
# /home/download/redis-6.0.7.copy/utils/systemd-redis_server.service
vi /usr/lib/systemd/system/redis.service

# 追加或调整以下内容
[Unit]
Description=Redis data structure server
Documentation=https://redis.io/documentation
#Before=your_application.service another_example_application.service
#AssertPathExists=/var/lib/redis
Wants=network-online.target
After=network-online.target

[Service]
# 服务类型
Type=notify
# 可打开文件数量
LimitNOFILE=10032
# 防止子进程提权
NoNewPrivileges=yes
# 因内存不足而被关闭的优先级，可设为 -1000(禁止被杀死) 到 1000(最先被杀死)之间的整数值
OOMScoreAdjust=-900
# 私有的临时文件，不予其他进程共享临时文件
PrivateTmp=yes
# 允许启动所耗费的时间
TimeoutStartSec=infinity
# 允许停止所耗费的时间
TimeoutStopSec=infinity
# 文件创建掩码
UMask=0077
# 最终运行该程序的用户
#User=redis
#Group=redis
# 工作目录
#WorkingDirectory=/opt/redis-6.0.7
# 启动命令
ExecStart=/opt/redis-6.0.7/bin/redis-server /opt/redis-6.0.7/redis.conf

[Install]
WantedBy=multi-user.target

# 重新加载Systemctl
systemctl daemon-reload
```

## 暂时到这里，太吵了