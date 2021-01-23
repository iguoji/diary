[返回主页](../../../README.md)

## 准备

```bash
# 安装git
dnf install git -y
# 编译工具
dnf install -y bison autoconf automake libtool ccache libxml2-devel openssl-devel libcurl-devel libpng-devel libjpeg-devel freetype-devel gmp-devel gcc-c++
# 为php的mbstring模块安装oniguruma包
cd /opt
git clone https://github.com/kkos/oniguruma.git
cd /opt/oniguruma
autoreconf -vfi
./configure && make && make install
# 为php准备re2c包
cd /opt
git clone https://github.com/skvadrik/re2c.git
cd /opt/re2c
autoreconf -i -W all
./configure && make && make install
```

## PHP

```bash
# 克隆php
cd /opt
git clone https://github.com/php/php-src.git
cd /opt/php-src

# 临时设置mbstring模块所需的依赖
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/

# 编译安装，可执行文件、配置文件和将放在 `/opt/php-master` 目录下
./buildconf
./configure \
    --prefix=/opt/php-master \
    --with-config-file-path=/opt/php-master/etc \
    --with-config-file-scan-dir=/opt/php-master/etc/php.d \
    --with-pear \
    --enable-fpm \
    --with-openssl \
    --with-pcre-jit \
    --without-sqlite3 \
    --enable-bcmath \
    --with-gmp \
    --with-curl \
    --enable-gd \
    --with-jpeg \
    --with-freetype \
    --enable-mbstring \
    --enable-pcntl \
    --without-pdo-sqlite \
    --with-pdo-mysql \
    --with-zlib \
    --with-zlib-dir
make && make install

# 配置文件
# php.ini
cp /opt/php-src/php.ini-production /opt/php-master/etc/php.ini
# php.d/
mkdir /opt/php-master/etc/php.d

# php-fpm 配置文件
mv /opt/php-master/etc/php-fpm.conf.default /opt/php-master/etc/php-fpm.conf
mv /opt/php-master/etc/php-fpm.d/www.conf.default /opt/php-master/etc/php-fpm.d/www.conf

# 环境变量
ln -s /opt/php-master /opt/php
vi /etc/profile.d/php.sh
# 输入以下内容
PHP=/opt/php/
export PATH=$PATH:$PHP/bin:$PHP/sbin

# :wq保存后重新登录ssh生效
# 重新登录 `ssh` 后，输入 `php -v`， 看到下列信息表示安装成功
PHP 8.1.0-dev (cli) (built: Jan 23 2021 19:13:01) ( NTS )
Copyright (c) The PHP Group
Zend Engine v4.1.0-dev, Copyright (c) Zend Technologies

# Systemctl 快捷服务
cp /opt/php-src/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service
systemctl daemon-reload
# 立即启动并设置开机自动启动 php-fpm
systemctl enable php-fpm
systemctl start php-fpm
```

## Mariadb

1. 配置 `MariaDB` 的官方仓库源， `vi /etc/yum.repos.d/MariaDB.repo`

```
# MariaDB 10.5 CentOS repository list - created 2021-01-23 11:14 UTC
# https://mariadb.org/download/
[mariadb]
name = MariaDB
baseurl = http://nyc2.mirrors.digitalocean.com/mariadb/yum/10.5/centos8-amd64
module_hotfixes=1
gpgkey=http://nyc2.mirrors.digitalocean.com/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1
```

2. 执行安装， `dnf install MariaDB-server -y`

3. 启动并设置开机启动 `systemctl start mariadb`、 `systemctl enable mariadb`

3. 安全设置， `mysql_secure_installation`
    * `Enter current password for root (enter for none):` 没有当前密码，直接回车
    * `Switch to unix_socket authentication [Y/n]` 不验证密码，输入`n`后回车
    * `Change the root password? [Y/n]` 是否更改密码，直接回车，表示修改
    * 接下来输入两次密码
    * `Remove anonymous users? [Y/n]` 是否删除匿名用户，回车，表示删除
    * `Disallow root login remotely? [Y/n]` 是否禁止root用户远程登录，输入`n`后回车
    * `Remove test database and access to it? [Y/n]` 是否删除测试数据库和账号，回车
    * `Reload privilege tables now? [Y/n]` 重新载入权限设置，回车

## Redis

```
# 克隆 redis
cd /opt
git clone https://github.com/redis/redis.git redis-src
cd /opt/redis

# 编译安装
dnf install systemd-devel
make PREFIX=/opt/redis-master install

# 调整配置文件
cp /opt/redis-src/redis.conf /opt/redis-master/redis.conf
vi /opt/redis-master/redis.conf

# 配置文件内容调整如下
bind 服务器的内网或外网IP
protected-mode no
daemonize no
supervised systemd
requirepass 123456

# 设置环境变量
ln -s /opt/redis-master /opt/redis
vi /etc/profile.d/redis.sh

# 输入以下内容
REDIS=/opt/redis
PATH=$PATH:$REDIS/bin

# :wq保存后重新登录ssh生效
# 重新登录 `ssh` 后，输入 `redis -v`， 看到下列信息表示安装成功
redis-cli 255.255.255 (git:9c148310)

# Systemctl 快捷服务
cp /opt/redis-src/utils/systemd-redis_server.service /usr/lib/systemd/system/redis.service
# 调整systemd服务文件，并将其中ExecStart调整成如下内容
vi /usr/lib/systemd/system/redis.service
ExecStart=/opt/redis/bin/redis-server /opt/redis/redis.conf
# 重新加载Systemd的服务文件
systemctl daemon-reload
# 立即启动并设置开机自动启动 redis
systemctl enable redis
systemctl start redis
```

## phpredis

```
# 克隆phpredis
cd /opt
git clone https://github.com/phpredis/phpredis.git
cd /opt/phpredis

# 编译安装
./configure && make && make install

# PHP开启redis扩展
vi /opt/php/etc/php.d/redis.ini

[redis]
extension=redis

# 查看模块是否成功加载
php -m
```

## Nginx

```
# 安装软件包管理工具
dnf install -y yum-utils

# 设置软件源
vi /etc/yum.repos.d/nginx.repo

[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

# 设置nginx默认安装的版本
yum-config-manager --enable nginx-mainline

# 安装nginx
dnf install -y nginx

# 立即启动并设置开机自动启动
systemctl start nginx
systemctl enable nginx
```