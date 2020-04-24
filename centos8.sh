#!/bin/bash

# 主菜单
menus=("All" "Nginx" "PHP" "MariaDB" "Redis" "Exit")

# 下载目录
tmp="/home/download"

# PHP
php_url="http://192.168.2.20/"


# 显示主菜单
showMenus(){
    echo '===================================='
    for((i=0;i<${#menus[*]};i++));do
        echo "($i) ${menus[i]}"
    done;
    echo '===================================='
    read -p "Please Input Your Choose：" index
}

# PHP
php(){
    echo "PHP Install"
    read -p "version：" php_version
    if [ ${#php_version} -lt 2 ]
    then

    fi
    read -p "php bin path：" php_path
    read -p "php ini path：" php_ini_path
    php_file="php-$php_version.tar.gz"
    php_url="$php_url$php_file"
    set -eux
        mkdir -p $tmp
        cd $tmp
        curl -LO $php_url
        tar -xvf ./$php_file -C $tmp
        ls -Flash $tmp
        cd $tmp/php-$php_version && ls -Flash ./
        rm -rf ../$php_file
        dnf install -y make gcc systemd-devel libxml2-devel openssl-devel sqlite-devel libcurl-devel
        ./configure \
            --prefix=$php_path \
            --with-config-file-path=$php_ini_path \
            --with-config-file-scan-dir=$php_ini_path/conf.d \
            --sysconfdir=$php_ini_path \
            --enable-fpm \
            --with-fpm-systemd \
            --with-openssl \
            --with-curl;
        make
        make install
        dnf clean all
}

# 菜单询问
while showMenus
do
    case $index in
        0)
            echo "All"
        ;;
        1)
            echo "Nginx"
        ;;
        2)

            php
        ;;
        3)
            echo "MariaDB"
        ;;
        4)
            echo "Redis"
        ;;
        *)
            echo "Bye"
            break
        ;;
    esac
done

