[返回主页](../../../README.md)

> https://mariadb.org/download/

1. 更新软件源

> 内容来自：https://mariadb.org/download/

编辑文件 `vi /etc/yum.repos.d/MariaDB.repo` ，内容如下

```bash
# MariaDB 10.5 [Stable] CentOS repository list - created 2020-09-08 04:08 UTC
# https://mariadb.org/download-test/
[mariadb]
name = MariaDB
baseurl = https://mirrors.ustc.edu.cn/mariadb/yum/10.5/centos8-amd64
module_hotfixes=1
gpgkey=https://mirrors.ustc.edu.cn/mariadb/yum/RPM-GPG-KEY-MariaDB
gpgcheck=1
```

2. 执行安装 `dnf install -y MariaDB-server-10.5.5`

3. 启动服务 `systemctl start mariadb`

4. 开机启动 `systemctl enable mariadb`

5. 安全设置 `mysql_secure_installation`
    * `Enter current password for root (enter for none):` 没有当前密码，直接回车
    * `Switch to unix_socket authentication [Y/n]` 不验证密码，输入`n`后回车
    * `Change the root password? [Y/n]` 是否更改密码，直接回车，表示修改
    * 接下来输入两次密码
    * `Remove anonymous users? [Y/n]` 是否删除匿名用户，回车，表示删除
    * `Disallow root login remotely? [Y/n]` 是否禁止root用户远程登录，输入`n`后回车
    * `Remove test database and access to it? [Y/n]` 是否删除测试数据库和账号，回车
    * `Reload privilege tables now? [Y/n]` 重新载入权限设置，回车

6. 远程登录

```sql
grant all privileges on *.* to 'root'@'%' identified by '123456';
flush privileges;
```