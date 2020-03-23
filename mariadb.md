## MariaDB安装
参考[MariaDB官方教程](https://mariadb.com/kb/en/yum/)
1. 添加软件源
```
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
```
2. 查看版本，得到版本号
```
yum info MariaDB-server
```
很可能出先两个，一个是10.4.12版本的(MariaDB)，一个是5.5版本的(mariadb)
5.5版本的是Centos默认自带的，避免出现意外，接下来的安装都附带版本号
3. 执行安装
```
yum install -y MariaDB-client-10.4.12 MariaDB-server-10.4.12 MariaDB-devel-10.4.12
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
```
4. 安装向导
    * `Enter current password for root (enter for none):` 没有当前密码，直接回车
    * `Switch to unix_socket authentication [Y/n]` 不验证密码，输入`n`后回车
    * `Change the root password? [Y/n]` 是否更改密码，直接回车，表示修改
    * 接下来输入两次密码
    * `Remove anonymous users? [Y/n]` 是否删除匿名用户，回车，表示删除
    * `Disallow root login remotely? [Y/n]` 是否禁止root用户远程登录，输入`n`后回车
    * `Remove test database and access to it? [Y/n]` 是否删除测试数据库和账号，回车
    * `Reload privilege tables now? [Y/n]` 重新载入权限设置，回车
    
5. 远程链接
```
mysql -h 127.0.0.1 -u root -p
123456
MariaDB [(none)]> use mysql;
MariaDB [mysql]> grant all privileges on *.* to 'root'@'%' identified by '123456';
MariaDB [mysql]> flush privileges;
MariaDB [mysql]> select user,host from user;
+-------+-----------+
| User  | Host      |
+-------+-----------+
| root  | %         |
| mysql | localhost |
| root  | localhost |
+-------+-----------+
3 rows in set (0.001 sec)
```
