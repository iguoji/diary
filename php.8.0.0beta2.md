#### 下载安装

```bash
# 进入下载文件夹目录
cd /home/download
# 下载PHP
curl -LO https://downloads.php.net/~pollita/php-8.0.0beta2.tar.gz
# 解压PHP
tar -xf php-8.0.0beta2.tar.gz
```
#### 安装选项

[./configure --help](php.configure.md)

#### 编译安装

> 缺少组件的话，通过dnf/yum进行安装，一般组件需要加上-devel后缀

```bash
./configure \
    --prefix=/opt/php-8.0.0beta2 \
    --with-config-file-path=/etc \
    --with-config-file-scan-dir=/etc/php.d \
    --with-pear \
    --enable-fpm \
    --with-fpm-systemd \
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

#### 配置服务

> 下面复制操作时，如有提示覆盖，输入y回车进行覆盖即可

+ php.ini

```bash
cp /home/download/php-8.0.0beta2/php.ini-production /etc/php.ini
```

+ php-fpm.conf

```bash
mv /opt/php-8.0.0beta2/etc/php-fpm.conf.default /etc/php-fpm.conf

```