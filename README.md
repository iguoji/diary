## php

1. 创建下载目录
mkdir /home/download
2. 进入下载目录
cd /home/download
3. 下载PHP安装包
wget https://www.php.net/distributions/php-7.4.4.tar.gz
4. 解压安装包到home目录
tar -xvf php-7.4.4.tar.gz -C /home
5. 进入php文件夹
cd /home/php-7.4.4
6. 安装编译需要的环境
    * yum install -y gcc libxml2-devel sqlite3-devel
7. 编译配置
    * ./configure --prefix=/opt/php --with-config-file-path=/etc --enable-fpm
    * --prefix 指定安装的目录
    * --with-config-file-path 指定php.ini配置文件的路径
    * --enable-fpm 启用fpm支持
8. 复制配置文件
cp php.ini-production /etc/php.ini
