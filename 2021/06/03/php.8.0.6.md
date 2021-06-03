[返回主页](../../../README.md)

## 安装

`--without-pear`: 默认直接安装时，最后会在安装`pear`的时候报错，提示错误的签名，所以暂时不安装`pear`，有需要可额外单独安装，地址：https://pear.php.net/manual/en/installation.getting.php

`--with-mysqli`: `phpmyadmin` 需要这个扩展

```bash
make clean
./buildconf
./configure  --prefix=/opt/php-8.0.6 --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --without-pear --enable-fpm --with-openssl --with-pcre-jit --without-sqlite3 --enable-bcmath --with-gmp --with-curl --enable-gd --with-jpeg --with-freetype --enable-mbstring --enable-pcntl --without-pdo-sqlite --with-mysqli --with-pdo-mysql --with-zlib --with-zlib-dir
make && make install
```

## 配置

```bash
cp /home/download/php-src/php.ini-production /etc/php.ini
cp /opt/php/etc/php-fpm.conf.default /opt/php/etc/php-fpm.conf
cp /opt/php/etc/php-fpm.d/www.conf.default /opt/php/etc/php-fpm.d/www.conf

cp /home/download/php-src/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service
systemctl daemon-reload
```

## Redis

```bash
git pull origin develop
make clean
phpize
./configure
make && make install

vi /etc/php.d/redis.ini
[redis]
extension=redis
```

## Swoole

```bash
git pull origin master
make clean
phpize
./configure --enable-openssl --enable-swoole-json --enable-swoole-curl
make && make install

vi /etc/php.d/swoole.ini
[swoole]
extension=swoole
```