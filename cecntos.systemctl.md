## PHP.service
方式一：使用PHP安装包自带的 `cp /home/php-7.4.4/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service`

方式二：自己创建服务文件
`vi /usr/lib/systemd/system/php-fpm.service`

```
[Unit]
Description=The PHP FastCGI Process Manager
After=network.target

[Service]
# pid文件在/etc/php-fpm.conf中设置
PIDFile=/run/php-fpm.pid
Type=forking
ExecStart=/opt/php-7.4.4/sbin/php-fpm
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill -INT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
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
