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
./configure --prefix=/opt/php --with-config-file-path=/etc --sysconfdir=/etc --enable-fpm && make install
--prefix 指定安装的目录
--with-config-file-path 指定php.ini配置文件的路径
--enable-fpm 启用fpm支持
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
6. 环境变量
```
vi /etc/profile

# 这一段放在最底部，自己添加的环境变量
PHP=/opt/php-7.4.4
PATH=$PATH:$PHP/bin:$PHP/sbin
export PATH


```
