[返回主页](../../../README.md)

## 安装过程

```bash
# 进入下载目录
cd /home/download

# 下载安装文件
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"

# 执行安装文件
php composer-setup.php

# 正常安装结果
All settings correct for using Composer
Downloading...

Composer (version 1.10.10) successfully installed to: /home/download/composer.phar
Use it: php composer.phar

# 设置为全局对象
mv composer.phar /usr/local/bin/composer

# 执行下面命令查看安装结果
composer

# 添加Composer专属用户
useradd composer

# 设置阿里云镜像地址
su - composer --session-command "composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/"

```

## 情况一，php未启用zlib

```bash
Downloading...

Composer (version 1.10.10) successfully installed to: /home/download/composer.phar
Use it: php composer.phar

Some settings on your machine may cause stability issues with Composer.
If you encounter issues, try to change the following:

The zlib extension is not loaded, this can slow down Composer a lot.
If possible, install it or recompile php with --with-zlib

The php.ini used by your command-line PHP is: /opt/php-8.0.0beta3/etc/php.ini
If you can not modify the ini file, you can also run `php -d option=value` to modify ini values on the fly. You can use -d multiple times.
```

解决办法：[给PHP启用zlib扩展，完了再执行刚才报错的命令](php.ext.zlib.md)

## 情况二，别用root执行

```bash
# 意思是别用 `root` 用户来执行 `Composer` 的命令，这样存在风险
Do not run Composer as root/super user! See https://getcomposer.org/root for details

# 先添加一个用户
useradd composer

# 也可以给这个用户设置密码
passwd composer

# 完了使用 composer 用户执行 composer 命令，例如
su - composer --session-command "composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/"
```

## 情况三，zip压缩包问题

```bash
# 大概意思是你的系统没有压缩和解压zip的能力
Failed to download hyperf/hyperf-skeleton from dist: The zip extension and unzip command are both missing, skipping.
Your command-line PHP is using multiple ini files. Run `php --ini` to show them.
Now trying to download from source

# 安装 zip unzip
dnf install -y zip unzip
```