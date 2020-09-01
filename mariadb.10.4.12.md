#### 下载安装
> 参考 [MariaDB官方教程](https://mariadb.com/kb/en/yum/)

```bash
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
dnf install -y MariaDB-client-10.4.12 MariaDB-server-10.4.12 MariaDB-devel-10.4.12
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
```

安装向导

* `Enter current password for root (enter for none):` 没有当前密码，直接回车
* `Switch to unix_socket authentication [Y/n]` 不验证密码，输入`n`后回车
* `Change the root password? [Y/n]` 是否更改密码，直接回车，表示修改
* 接下来输入两次密码
* `Remove anonymous users? [Y/n]` 是否删除匿名用户，回车，表示删除
* `Disallow root login remotely? [Y/n]` 是否禁止root用户远程登录，输入`n`后回车
* `Remove test database and access to it? [Y/n]` 是否删除测试数据库和账号，回车
* `Reload privilege tables now? [Y/n]` 重新载入权限设置，回车

常见问题

* 授权远程用户

```sql
grant all privileges on *.* to 'root'@'%' identified by '123456';
flush privileges;
```

* 配置文件调整 `/etc/my.cnf.d/server.cnf`

```ini
[mysqld]
# 跳过DNS反解析
skip-name-resolve

[galera]
# 设置Mysql的IP
bind-address=0.0.0.0
```