## PHP.service
先创建服务文件
`vi /usr/lib/systemd/system/php-fpm.service`

```
[Unit]
# 描述
Description=php-fpm - dynamic php-fpm daemon
# 启动前的条件，可以设置多个Before\After之类的
Before=network-pre.target

[Service]
# PID文件
PIDFile=/run/php-fpm.pid
# 类型 - 后台运行
Type=forking
# 启动
ExecStart=/opt/php-7.4.4/sbin/php-fpm
# 重载
ExecReload=/bin/kill -USR2 $MAINPID
# 停止
ExecStop=/bin/kill -INT $MAINPID
# 分配私有空间
PrivateTmp=true

[Install]
# 这里还没懂
WantedBy=multi-user.target
# 别名
Alias=phpfpm.service
```

最后重新加载systemctl
`systemctl daemon-reload`

## Redis.service
先创建服务文件
`vi /usr/lib/systemd/system/redis.service`

```
[Unit]
Description=redis - cache server
After=network-online.target remote-fs.target
Wants=network-online.target

[Service]
Type=forking
# pid文件在/etc/redis.conf中设置
PIDFile=/var/run/redis_6379.pid
ExecStart=/opt/redis-5.0.8/bin/redis-server /etc/redis.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID

[Install]
WantedBy=multi-user.target
```

最后重新加载systemctl
`systemctl daemon-reload`
