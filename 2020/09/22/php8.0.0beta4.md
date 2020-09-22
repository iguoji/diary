[返回主页](../../../README.md)

## 前言

准备试试PHP的注解，最新语法 `#[]` 在 `php8.0.0beta4` 上才实现

但是下载速度太慢，所以在 `Windows 10` 上使用迅雷下载的

通过 `PowerShell` 传送到 `Centos 8` 上

传送命令：`scp .\php-8.0.0beta4.tar.gz root@192.168.2.12:/home/download`，回车输入密码即可


## 编译安装

```bash
# 前往下载目录
cd /home/download
# 解压
tar -xf php-8.0.0beta4.tar.gz && cd php-8.0.0beta4
# mbstring模块所需的依赖
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/
# 编译
./configure \
    --prefix=/opt/php-8.0.0beta4 \
    --with-config-file-path=/opt/php-8.0.0beta4/etc \
    --with-config-file-scan-dir=/opt/php-8.0.0beta4/etc/php.d \
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
```

## 复制文件

```bash
# php.ini
cp /home/download/php-8.0.0beta4/php.ini-production /opt/php-8.0.0beta4/etc/php.ini
# php.d/
mkdir /opt/php-8.0.0beta4/etc/php.d

# php-fpm 配置文件
mv /opt/php-8.0.0beta4/etc/php-fpm.conf.default /opt/php-8.0.0beta4/etc/php-fpm.conf
mv /opt/php-8.0.0beta4/etc/php-fpm.d/www.conf.default /opt/php-8.0.0beta4/etc/php-fpm.d/www.conf

# systemctl 服务
cp /home/download/php-8.0.0beta4/sapi/fpm/php-fpm.service /usr/lib/systemd/system/php-fpm.service
systemctl daemon-reload
```

## 环境变量

以前安装PHP的时候想的是直接改环境变量中的PHP目录，就可以随便切换PHP版本了

但是好像还是不太方便，最终决定通过软连接来实现，先创建软连接，如下：

```bash
ln -s /opt/php-8.0.0beta4 /opt/php
```

这样的话，以后随时想切换PHP版本就可以删掉这个软连接，然后再新建一个软连接，即时生效

然后将以前在 `/etc/profile` 文件中的PHP相关内容删掉

之后再创建 `/etc/profile.d/php.sh` 文件，并输入下面的内容：

```bash
PHP=/opt/php/
export PATH=$PATH:$PHP/bin:$PHP/sbin
```

同理，也可以将以前在 `/etc/profile` 中的内容都拿出来

最后重新加载环境变量 `source ~/.bash_profile` 来使其生效

需要在新的 `shell` 窗口才能生效，也可以 `exit` 退出当前用户再重新登录生效

## 常见错误

[点击这里参考以前的文章](../01/centos8.php8.md#常见错误)