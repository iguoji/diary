[返回主页](../../../README.md)

## Redis

### 系统调优

1. 编辑文件 `vi /etc/sysctl.conf`，追加或调整以下内容
```bash
net.core.somaxconn = 2048
vm.overcommit_memory = 1
```
2. 重新加载文件以便生效 `sysctl -p`
3. 临时执行，`echo never > /sys/kernel/mm/transparent_hugepage/enabled`
4. 编辑文件 `vi /rc.local`，追加或调整以下内容，[源自Github](https://github.com/redis/redis/issues/3176)
```bash
if test -f /sys/kernel/mm/transparent_hugepage/enabled; then
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi
if test -f /sys/kernel/mm/transparent_hugepage/defrag; then
    echo never > /sys/kernel/mm/transparent_hugepage/defrag
fi
```

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
daemonize no
supervised systemd
requirepass 123456

# 设置环境变量
vi /etc/profile

# 追加或调整以下内容
REDIS=/opt/redis-6.0.7
PATH=$PATH:$REDIS/bin

# 重启后环境变量生效
```

### 系统服务

> 官方示例：/home/download/redis-6.0.7.copy/utils/systemd-redis_server.service

1. 创建服务文件，`vi /usr/lib/systemd/system/redis.service`，内容如下

```bash
[Unit]
Description=Redis data structure server
Documentation=https://redis.io/documentation
#Before=your_application.service another_example_application.service
#AssertPathExists=/var/lib/redis
Wants=network-online.target
After=network-online.target

[Service]
#ExecStart=/opt/redis-6.0.7/bin/redis-server --supervised systemd --daemonize no
## Alternatively, have redis-server load a configuration file:
ExecStart=/opt/redis-6.0.7/bin/redis-server /opt/redis-6.0.7/redis.conf
LimitNOFILE=10032
NoNewPrivileges=yes
#OOMScoreAdjust=-900
#PrivateTmp=yes
Type=notify
TimeoutStartSec=infinity
TimeoutStopSec=infinity
UMask=0077
#User=redis
#Group=redis
#WorkingDirectory=/var/lib/redis

[Install]
WantedBy=multi-user.target
```

2. 重新加载Systemd的服务文件 `systemctl daemon-reload`

3. 开启服务 `systemctl start redis`

4. 开机启动 `systemctl enable redis`

## phpredis

### 编译安装

```bash
# 进入下载目录
cd /home/download

# 下载redis
curl -LO https://github.com/phpredis/phpredis/archive/5.3.1.tar.gz

# 解压并进入目录
tar -xf phpredis-5.3.1.tar.gz
cd phpredis-5.3.1

# 编译安装过
phpize
./configure
make && make install

# 编译失败，参考：https://github.com/phpredis/phpredis/issues/1809
# 解决办法，从Github上重新下载 develop 版本，再次进行上面的步骤
```

### PHP开启redis扩展

创建文件 `vi /opt/php-8.0.0beta3/etc/php.d/redis.ini`

内容如下
```bash
[redis]
extension=redis
```
然后通过 `php -m` 查看是否开启成功