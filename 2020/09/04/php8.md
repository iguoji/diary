[返回主页](../../../README.md)

## 编译安装

```bash
# 前往下载目录
cd /home/download
# 下载PHP
curl -LO  https://downloads.php.net/~carusogabriel/php-8.0.0beta3.tar.gz
# 解压
tar -xf php-8.0.0beta3.tar.gz && cd php-8.0.0beta3
# mbstring模块所需的依赖
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
# 编译
./configure \
    --prefix=/opt/php-8.0.0beta3 \
    --with-config-file-path=/opt/php-8.0.0beta3/etc \
    --with-config-file-scan-dir=/opt/php-8.0.0beta3/etc/php.d \
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

## 初步准备

```bash
# 编辑环境变量
vi /etc/profile

# 在末尾追加以下内容或修改老版本的路径
# PHP
PHP=/opt/php-8.0.0beta3/
PATH=$PATH:$PHP/bin:$PHP/sbin
# 导出变量
export PATH

# 重启后环境变量便生效、source /etc/profile 这种方式不再生效

# php.ini
cp /home/download/php-8.0.0beta3/php.ini-production /opt/php-8.0.0beta3/etc/php.ini
# php.d/
mkdir /opt/php-8.0.0beta3/etc/php.d

# php-fpm 配置文件
mv /opt/php-8.0.0beta3/etc/php-fpm.conf.default /opt/php-8.0.0beta3/etc/php-fpm.conf
mv /opt/php-8.0.0beta3/etc/php-fpm.d/www.conf.default /opt/php-8.0.0beta3/etc/php-fpm.d/www.conf

# systemctl 服务
cp /home/download/php-8.0.0beta3/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service
systemctl daemon-reload
```

## 常见错误

[点击这里参考以前的文章](../01/centos8.php8.md#常见错误)