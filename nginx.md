## nginx安装
参考[nginx官方指南](http://nginx.org/en/linux_packages.html#RHEL-CentOS)
```
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
```
如果要使用最新版本
```
yum install yum-utils
yum-config-manager --enable nginx-mainline
```
安装Nginx
```
yum install -y nginx
```
