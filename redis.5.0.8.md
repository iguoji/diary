#### 下载redis
```bash
mkdir /home/download && cd /home/download
curl -LO http://download.redis.io/releases/redis-5.0.8.tar.gz
tar -xf redis-5.0.8.tar.gz
```
#### 编译安装
```bash
cd /home/download/redis-5.0.8
make PREFIX=/opt/redis-5.0.8 install
```
#### 环境配置
* redis.conf
    ```bash
    cp /home/download/redis-5.0.8/redis.conf /etc/redis.conf

    vi /etc/redis.conf

    # Redis服务器地址，只能通过这个地址进行访问，建议填写内网IP
    bind 192.168.1.168
    # 是否只能内网访问
    protected-mode no
    # 后台运行
    daemonize yes
    # 密码
    requirepass 123456
    ```

* 系统服务
    ```bash
    vi /usr/lib/systemd/system/redis.service

    [Unit]
    Description=redis - cache server
    After=network.target

    [Service]
    Type=forking
    # pid文件在/etc/redis.conf中设置
    PIDFile=/var/run/redis_6379.pid
    ExecStartPost=/bin/sleep 0.1
    ExecStart=/opt/redis-5.0.8/bin/redis-server /etc/redis.conf
    ExecReload=/bin/kill -s HUP $MAINPID
    ExecStop=/bin/kill -s QUIT $MAINPID
    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target

    systemctl daemon-reload
    ```
* 开机启动
```bash
systemctl enable redis
```
* 重启服务
```bash
systemctl restart redis
```
* 环境变量
```bash
vi /etc/profile

# REDIS
REDIS=/opt/redis-5.0.8
PATH=$PATH:$REDIS/bin

# 导出变量
export PATH

source /etc/profile
```