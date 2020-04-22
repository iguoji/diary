## 安装PHP

1. 下载解压
```
mkdir /home/download
cd /home/download
curl -O https://www.php.net/distributions/php-7.4.4.tar.gz
tar -xvf php-7.4.4.tar.gz -C /home
cd /home/php-7.4.4
```
2. 编译安装
```
yum install -y gcc libxml2-devel sqlite-devel
./configure --help
./configure --prefix=/opt/php --with-config-file-path=/etc --sysconfdir=/etc --enable-fpm --with-fpm-systemd --with-openssl --with-curl --enable-mbstring && make install
--prefix 指定安装的目录
--with-config-file-path 指定php.ini配置文件的路径
--enable-fpm 启用fpm支持
--with-fpm-systemd 启用systemctl服务支持
--with-openssl 启用openssl
--with-curl 启用curl
--enable-mbstring 支持mb系列函数
```
3. php.ini
```
cp php.ini-production /etc/php.ini
```
4. php-fpm.conf
```
mv /etc/php-fpm.conf.default /etc/php-fpm.conf
vi /etc/php-fpm.conf
pid=/run/php-fpm.pid
```
5. php-fpm.d
```
mv /etc/php-fpm.d/www.conf.default /etc/php-fpm.d/www.conf
```
6. 环境变量(放在最后一行)
```
vi /etc/profile

# PHP
PHP=/opt/php-7.4.4
PATH=$PATH:$PHP/bin:$PHP/sbin

# 导出变量
export PATH

source profile
```
7. [Systemctl.Service](cecntos.systemctl.md)
