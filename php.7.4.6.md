### PHP 7.4.6
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