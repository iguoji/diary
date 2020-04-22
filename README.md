## Centos
### 常用命令
#### 下载文件
> `L` 支持重定向，`O` 按URL的文件名保存
```bash
curl -LO http://url/file.tar.gz
```
#### 解压文件
```bash
tar -xvf file.tar.gz
```

## Centos8
### 软件源
```bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
dnf makecache
```
### PHP
> PHP编译安装问题大部分出现在缺少依赖，当某些依赖通过dnf或yum搜索不到时就很头疼
#### 下载PHP
```bash
mkdir /home/download && cd /home/download
curl -O https://www.php.net/distributions/php-7.4.5.tar.gz
tar -xvf php-7.4.5.tar.gz
```
#### 安装依赖
> [oniguruma](https://github.com/kkos/oniguruma) 是mbstring所需的依赖
```bash
dnf install -y gcc systemd-devel libxml2-devel openssl-devel sqlite-devel libcurl-devel
cd /home/download
curl -LO https://github.com/kkos/oniguruma/releases/download/v6.9.5/onig-6.9.5.tar.gz
tar -xvf onig-6.9.5.tar.gz
cd onig-6.9.5
dnf install -y autoconf automake libtool make
./configure --prefix=/opt/oniguruma --libdir=/lib64 && make install
```
#### 编译安装
> 可通过 ./configure --help 查看选项
```bash
cd /home/download/php-7.4.5
./configure --prefix=/opt/php-7.4.5 --with-config-file-path=/etc --sysconfdir=/etc --enable-fpm --with-fpm-systemd --with-openssl --with-curl --enable-mbstring && make install
```
* `--prefix` 指定安装的目录
* `--with-config-file-path` 指定php.ini配置文件的路径
* `--enable-fpm` 启用fpm支持
* `--with-fpm-systemd` 启用systemctl服务支持
* `--with-openssl` 启用openssl
* `--with-curl` 启用curl
* `--enable-mbstring` 支持mb系列函数

#### 环境配置
* php.ini
```bash
cp /home/download/php-7.4.5/php.ini-production /etc/php.ini
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
cp /home/download/php-7.4.5/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service
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
    PHP=/opt/php-7.4.5
    PATH=$PATH:$PHP/bin:$PHP/sbin

    # 导出变量
    export PATH

    source /etc/profile
    ```

#### redis扩展
```bash
pecl install redis

vi /etc/php.ini

[redis]
extension=redis.so
```

#### swoole扩展
```bash
dnf install -y gcc-c++
mkdir /home/download && cd /home/download
curl -LO https://github.com/swoole/swoole-src/archive/v4.4.17.tar.gz
tar xvf v4.4.17.tar.gz
cd swoole-src-4.4.17
phpize
./configure && make && make install
vi /etc/php.ini
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

### Redis
#### 下载redis
```bash
mkdir /home/download && cd /home/download
curl -LO http://download.redis.io/releases/redis-5.0.8.tar.gz
tar -xvf redis-5.0.8.tar.gz
```
#### 编译安装
```bash
cd /home/download/redis-5.0.8
make PREFIX=/opt/redis-5.0.8 install
```
#### 环境配置
* redis.conf
    ```bash
    cp /home/download/redis.conf /etc/redis.conf

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
