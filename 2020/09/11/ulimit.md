[返回主页](../../../README.md)

## Too many open files

> WARNING accept_connection(:97): accept() failed, Error: Too many open files[24]

临时解决：`ulimit -n 655350`

永久解决：`vi /etc/security/limits.conf`

```bash
*                soft    nofile          655350
*                hard    nofile          655350
root             soft    nofile          655350
root             hard    nofile          655350
*                soft    nproc           655350
*                hard    nproc           655350
root             soft    nproc           655350
root             hard    nproc           655350
*                soft    core            unlimited
*                hard    core            unlimited
root             soft    core            unlimited
root             hard    core            unlimited
```

对于通过Systemctl管理的服务，如果不生效，可以在服务文件中加入字段 `LimitNOFILE = 655350`