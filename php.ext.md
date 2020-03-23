## openssl
```
cd /home/php-7.4.4/ext/openssl
phpize
./configure --with-php-config=/opt/php-7.4.4/bin/php-config
make install
```
然后去/etc/php.ini将extension=openssl加上

## 常见错误
1. `Cannot find config.m4.`，将扩展文件夹下的config0.m4复制一份为config.m4即可
2. `Cannot find autoconf.`，缺少autoconf，`yum install -y autoconf`
3. `No package 'openssl' found`，缺少opensll，`yum install -y openssl openssl-devel`
