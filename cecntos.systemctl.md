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
