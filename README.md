## Centos
### 常用命令
#### 下载文件
> `L` 支持重定向，`O` 按URL的文件名保存
```bash
curl -LO http://url/file.tar.gz
```
#### 解压文件
```bash
tar -xf file.tar.gz
```
#### Win10通过SCP发送文件到Centos

```bash
# Windows PowerShell命令行
scp .\onig-6.9.5.tar.gz root@192.168.2.11:/home/download
```

## Centos8

### 网络设置

#### IP设置

```bash
cat /etc/sysconfig/network-scripts/ifcfg-ens33
```

```bash
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens33"
UUID="1680e673-1517-4df3-9921-4eef4f78d65c"
DEVICE="ens33"
ONBOOT="yes"
# 重点是下面四行
IPADDR="192.168.2.11"
PREFIX="24"
GATEWAY="192.168.2.2"
NDS1="192.168.2.2"
IPV6_PRIVACY="no"
```

#### 设置DNS服务器

```bash
vi /etc/resolv.conf
```
```bash
# 和上面保持一致
nameserver 192.168.2.2
```

### 软件源
```bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
dnf makecache
```


### Docker

#### 下载安装
> 参考 [Docker官方教程](https://docs.docker.com/engine/install/centos/)，也可以参考 [阿里云 Docker安装教程](https://developer.aliyun.com/mirror/docker-ce)
```bash
dnf config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
mkdir /home/download && cd /home/download
curl -LO https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install -y ./containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install -y docker-ce
systemctl start docker
systemctl enable docker
sudo usermod -aG docker $USER
```

#### 国内镜像
> 查看[Docker 官方指导](https://docs.docker.com/registry/recipes/mirror/)，申请[阿里云镜像加速器](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)

编辑 `/etc/docker/daemon.json` ，内容如下，其中URL替换成阿里云申请的镜像地址
```json
{
    "registry-mirrors": ["https://yourid.mirror.aliyuncs.com"]
}
```
然后重启相关服务
```bash
systemctls daemon-reload
systemctls restart docker
```

最后通过 `docker info` 查看到更换后的地址

#### 域名解析
> 默认安装后docker内的容器无法解析域名

```bash
firewall-cmd --zone=public --add-masquerade --permanent
firewall-cmd --reload
systemctl restart docker
```


### PHP
> PHP编译安装问题大部分出现在缺少依赖，当某些依赖通过dnf或yum搜索不到时就很头疼
#### 下载PHP
```bash
mkdir /home/download && cd /home/download
curl -O http://mirrors.sohu.com/php/php-7.4.6.tar.gz
tar -xf php-7.4.6.tar.gz
```
#### 安装依赖
> [oniguruma](https://github.com/kkos/oniguruma) 是mbstring所需的依赖
```bash
dnf install -y gcc systemd-devel libxml2-devel openssl-devel sqlite-devel libcurl-devel
cd /home/download
curl -LO https://github.com/kkos/oniguruma/releases/download/v6.9.5/onig-6.9.5.tar.gz
tar -xf onig-6.9.5.tar.gz
cd onig-6.9.5
dnf install -y autoconf automake libtool make
./configure --prefix=/opt/oniguruma --libdir=/lib64 && make install
```
#### 编译安装
> 可通过 ./configure --help 查看选项
```bash
cd /home/download/php-7.4.6
./configure \
    --prefix=/opt/php-7.4.6 \
    --with-config-file-path=/etc \
    --with-config-file-scan-dir=/etc/php.d \
    --sysconfdir=/etc \
    --with-libdir=lib64 \
    --enable-fpm \
    --with-fpm-systemd \
    --with-openssl \
    --with-curl \
    --enable-mbstring \
    --with-pdo-mysql \
    --with-zlib-dir \
    --with-pear
make && make install
```
* `--prefix` 指定安装的目录
* `--with-config-file-path` 指定php.ini配置文件的路径
* `--with-config-file-scan-dir` 扩展的配置信息可以放这里
* `--with-libdir` 64位系统最好加上
* `--enable-fpm` 启用fpm支持
* `--with-fpm-systemd` 启用systemctl服务支持
* `--with-openssl` 启用openssl
* `--with-curl` 启用curl
* `--enable-mbstring` 支持mb系列函数
* `--with-pdo-mysql` 对mysql的支持，最好加上，后期安装常常会有各种意外

#### 环境配置
* php.ini
```bash
cp /home/download/php-7.4.6/php.ini-production /etc/php.ini
```
* php-fpm.conf
```bash
mv /etc/php-fpm.conf.default /etc/php-fpm.conf
vi /etc/php-fpm.conf
pid=/run/php-fpm.pid
```
* php-fpm.d
```bash
mv /etc/php-fpm.d/www.conf.default /etc/php-fpm.d/www.conf
```
* 系统服务
```bash
cp /home/download/php-7.4.6/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service
systemctl daemon-reload
```
* 开机启动
```bash
systemctl enable php-fpm
```
* 重启服务
```bash
systemctl restart php-fpm
```
* 环境变量

    ```bash
    vi /etc/profile

    # PHP
    PHP=/opt/php-7.4.6
    PATH=$PATH:$PHP/bin:$PHP/sbin

    # 导出变量
    export PATH

    source /etc/profile
    ```

#### 编译安装扩展

首先进入扩展的源代码文件夹，接下来

第一步： `phpize`

第二步： `./configure --其他选项`

第三步： `make && make install`

#### redis扩展

通过 `pecl` 安装

```bash
pecl install redis

vi /etc/php.d/redis.ini

[redis]
extension=redis.so
```

#### swoole扩展

前置需求：`dnf install -y gcc-c++`

通过 `pecl` 安装

```bash
pecl install swoole
```

编译安装

```bash
mkdir /home/download && cd /home/download
curl -LO https://github.com/swoole/swoole-src/archive/v4.5.2.tar.gz
tar xf v4.5.2.tar.gz
cd swoole-src-4.5.2
phpize
./configure --enable-openssl --enable-http2 && make && make install
vi /etc/php.d/swoole.ini
[swoole]
extension=swoole.so
```

### Pecl

```bash
mkdir /home/download && cd /home/download
curl -LO http://pear.php.net/go-pear.phar
php go-pear.phar
```
因为此前已经设置了PHP的环境变量，所以接下来一路回车即可

通过 `pecl install` 安装非常慢，可以先把 `tgz` 下载下来后再执行 `pecl install file.tgz`

#### 自动配置php.ini

```bash
pear config-set php_ini /etc/php.ini
```

PS：每次安装扩展后需要手动重启`php-fpm`服务，这样`extension=xxx.so`才会自动加入`php.ini`里

### Redis
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

### Composer

```bash
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
php composer-setup.php
mv composer.phar /usr/local/bin/composer
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
```

### Mariadb

#### 下载安装
> 参考 [MariaDB官方教程](https://mariadb.com/kb/en/yum/)

```bash
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
dnf install -y MariaDB-client-10.4.12 MariaDB-server-10.4.12 MariaDB-devel-10.4.12
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
```

安装向导

* `Enter current password for root (enter for none):` 没有当前密码，直接回车
* `Switch to unix_socket authentication [Y/n]` 不验证密码，输入`n`后回车
* `Change the root password? [Y/n]` 是否更改密码，直接回车，表示修改
* 接下来输入两次密码
* `Remove anonymous users? [Y/n]` 是否删除匿名用户，回车，表示删除
* `Disallow root login remotely? [Y/n]` 是否禁止root用户远程登录，输入`n`后回车
* `Remove test database and access to it? [Y/n]` 是否删除测试数据库和账号，回车
* `Reload privilege tables now? [Y/n]` 重新载入权限设置，回车

常见问题

* 授权远程用户

```sql
grant all privileges on *.* to 'root'@'%' identified by '123456';
flush privileges;
```

* 配置文件调整 `/etc/my.cnf.d/server.cnf`

```ini
[mysqld]
# 跳过DNS反解析
skip-name-resolve

[galera]
# 设置Mysql的IP
bind-address=0.0.0.0
```

### Nginx

#### 下载安装
> 参考 [Nginx官方教程](http://nginx.org/en/linux_packages.html#RHEL-CentOS)

```bash
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

dnf install -y nginx
```

## 历史文章
* nginx
    + [nginx安装](nginx.md)
* php
    + [php编译安装](php.md)
    + [php扩展编译安装](php.ext.md)
    + [pecl](php.pecl.md)
* redis
    + [redis编译安装](redis.md)
* mariadb
    + [mariadb安装](mariadb.md)
* centos
    + [systemctl](cecntos.systemctl.md)
