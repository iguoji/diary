[返回主页](../../../README.md)

#### 更换DNF软件源
```bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
dnf makecache
```
#### 下载解压PHP
```bash
mkdir /home/download && cd /home/download
curl -LO https://downloads.php.net/~pollita/php-8.0.0beta2.tar.gz
tar -xf php-8.0.0beta2.tar.gz
cd php-8.0.0beta2
```
#### PHP的编译依赖工具
```bash
dnf install -y autoconf automake libtool libxml2-devel openssl-devel libcurl-devel libpng-devel libjpeg-devel freetype-devel gmp-devel
```
#### 编译安装PHP
```bash
./configure \
    --prefix=/opt/php-8.0.0beta2 \
    --with-config-file-path=/opt/php-8.0.0beta2/etc \
    --with-config-file-scan-dir=/opt/php-8.0.0beta2/etc/php.d \
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
    --with-zlib-dir
make && make install
```

#### 安装结果
```bash
Build complete.
Don't forget to run 'make test'.

Installing shared extensions:     /opt/php-8.0.0beta2/lib/php/extensions/no-debug-non-zts-20200804/
Installing PHP CLI binary:        /opt/php-8.0.0beta2/bin/
Installing PHP CLI man page:      /opt/php-8.0.0beta2/php/man/man1/
Installing PHP FPM binary:        /opt/php-8.0.0beta2/sbin/
Installing PHP FPM defconfig:     /opt/php-8.0.0beta2/etc/
Installing PHP FPM man page:      /opt/php-8.0.0beta2/php/man/man8/
Installing PHP FPM status page:   /opt/php-8.0.0beta2/php/php/fpm/
Installing phpdbg binary:         /opt/php-8.0.0beta2/bin/
Installing phpdbg man page:       /opt/php-8.0.0beta2/php/man/man1/
Installing PHP CGI binary:        /opt/php-8.0.0beta2/bin/
Installing PHP CGI man page:      /opt/php-8.0.0beta2/php/man/man1/
Installing build environment:     /opt/php-8.0.0beta2/lib/php/build/
Installing header files:          /opt/php-8.0.0beta2/include/php/
Installing helper programs:       /opt/php-8.0.0beta2/bin/
program: phpize
program: php-config
Installing man pages:             /opt/php-8.0.0beta2/php/man/man1/
page: phpize.1
page: php-config.1
Installing PEAR environment:      /opt/php-8.0.0beta2/lib/php/
[PEAR] Archive_Tar    - installed: 1.4.9
[PEAR] Console_Getopt - installed: 1.4.3
[PEAR] Structures_Graph- installed: 1.1.1
[PEAR] XML_Util       - installed: 1.4.5

# 意思是说Pear建议1.4.4版的，但是你默认安装的是1.4.9，所以不用管
warning: pear/PEAR dependency package "pear/Archive_Tar" installed version 1.4.9 is not the recommended version 1.4.4

[PEAR] PEAR           - installed: 1.10.12
Wrote PEAR system config file at: /opt/php-8.0.0beta2/etc/pear.conf

# 需要将 /opt/php-8.0.0beta2/lib/php 添加到 php.ini 的 include_path 属性中
# 例如 include_path = .:/opt/php-8.0.0beta2/lib/php，但实际上默认便是这样
# 可以通过 /opt/php-8.0.0beta2/bin/php -r "echo get_include_path().PHP_EOL;" 看到
You may want to add: /opt/php-8.0.0beta2/lib/php to your php.ini include_path

/home/download/php-8.0.0beta2/build/shtool install -c ext/phar/phar.phar /opt/php-8.0.0beta2/bin/phar.phar
ln -s -f phar.phar /opt/php-8.0.0beta2/bin/phar
Installing PDO headers:           /opt/php-8.0.0beta2/include/php/ext/pdo/
```

#### 环境变量

```bash
vi /etc/profile

# 在末尾追加以下内容
# PHP
PHP=/opt/php-8.0.0beta2/
PATH=$PATH:$PHP/bin:$PHP/sbin

# 导出变量
export PATH

# 重新加载环境变量，以便立即生效
source /etc/profile
```

#### php.ini

```bash
cp /home/download/php-8.0.0beta2/php.ini-production /opt/php-8.0.0beta2/etc/php.ini
mkdir /opt/php-8.0.0beta2/etc/php.d
```

#### php-fpm.ini

```bash
mv /opt/php-8.0.0beta2/etc/php-fpm.conf.default /opt/php-8.0.0beta2/etc/php-fpm.conf
```

#### 常见错误

+ configure error: Package requirements (libxml-2.0 >= 2.9.0) were not met

```bash
checking for libxml-2.0 >= 2.9.0... no
configure: error: Package requirements (libxml-2.0 >= 2.9.0) were not met:

Package 'libxml-2.0', required by 'virtual:world', not found

# 解决方法
dnf install -y libxml2-devel
```

+ configure error: Package requirements (openssl >= 1.0.1) were not met:

```bash
checking for openssl >= 1.0.1... no
configure: error: Package requirements (openssl >= 1.0.1) were not met:

Package 'openssl', required by 'virtual:world', not found

# 解决方法
dnf install -y openssl-devel
```

+ configure: error: Package requirements (libcurl >= 7.29.0) were not met:

```bash
checking for libcurl >= 7.29.0... no
configure: error: Package requirements (libcurl >= 7.29.0) were not met:

Package 'libcurl', required by 'virtual:world', not found

# 解决方法
dnf install -y libcurl-devel
```

+ configure: error: Package requirements (libpng) were not met:

```bash
checking for libpng... no
configure: error: Package requirements (libpng) were not met:

Package 'libpng', required by 'virtual:world', not found

# 解决方法
dnf install -y libpng-devel
```

+ configure: error: Package requirements (libjpeg) were not met:

```bash
checking for libjpeg... no
configure: error: Package requirements (libjpeg) were not met:

Package 'libjpeg', required by 'virtual:world', not found

# 解决方法
dnf install -y libjpeg-devel
```

+ configure: error: Package requirements (freetype2) were not met:

```bash
checking for freetype2... no
configure: error: Package requirements (freetype2) were not met:

Package 'freetype2', required by 'virtual:world', not found

# 解决方法
dnf install -y freetype-devel
```

+ configure: error: GNU MP Library version 4.2 or greater required.

```bash
checking for GNU gettext support... no
checking for GNU MP support... yes
checking for __gmpz_rootrem in -lgmp... no
configure: error: GNU MP Library version 4.2 or greater required.

# 解决办法
dnf install -y gmp-devel
```

+ configure: error: Package requirements (oniguruma) were not met:

```bash
checking for oniguruma... no
configure: error: Package requirements (oniguruma) were not met:

Package 'oniguruma', required by 'virtual:world', not found

# 解决办法
dnf install -y make
cd /home/download
curl -LO https://github.com/kkos/oniguruma/releases/download/v6.9.5_rev1/onig-6.9.5_rev1.tar.gz
tar -xf onig-6.9.5_rev1.tar.gz
cd onig-6.9.5
./configure && make && make install
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
```