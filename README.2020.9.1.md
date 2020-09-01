## Centos

### 常用命令
```bash
# `L` 支持重定向，`O` 按URL的文件名保存
curl -LO http://url/file.tar.gz

# 解压文件
tar -xf file.tar.gz

# Win10通过SCP发送文件到Centos
# 下例命令在Windows PowerShell命令行执行
scp .\onig-6.9.5.tar.gz root@192.168.2.11:/home/download
```

### 网络设置

[Vmware15 Pro Centos8 NAT网络IP设置](vmware.centos8.network.md)



### 软件源
```bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo
dnf makecache
```


## PHP

[PHP8.0.0beta2](php.8.0.0beta2.md)

[PHP7.4.6 + pecl + redis + swoole](php.7.4.6.md)

## Composer

```bash
php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
php composer-setup.php
mv composer.phar /usr/local/bin/composer
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
```

## Redis

[Redis5.0.8](redis.5.0.8.md)

## Mariadb

[Mariadb.10.4.12](mariadb.10.4.12.md)

## Nginx

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

## Docker

[概览](docker.md)

## 性能调优

### Centos

 1. ulimit

    系统资源设置，通常回设置可打开文件最大数量

    通过 `ulimit -a` 可以查看到相关数据

    通过 `ulimit -n 100000` 可以进行设置文件数量（本次启动有效）

### PHP

 1. memory_limit

    PHP脚本内存空间大小

    memory_limit = 1024M，建议设置大点，不然内存泄漏的BUG很快就会被发现

### Mysql

 1. innodb_flush_log_at_trx_commit

    提交事务时日志写入磁盘的策略选择

    0：延迟写，最快、最不安全

    1：实时写，实时刷（默认），最慢

    2：实时写，延迟刷，折中，（大多数推荐）

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
