[返回主页](../../README.md)

## 服务调整

### 防火墙

```bash
# 禁用防火墙
systemctl stop firewalld
systemctl disable firewalld
```

### Selinux

```bash
# 临时关闭
setenforce 0

# 永久关闭
vi /etc/selinux/config
# 将SELINUX=enforcing改成，完了重启
SELINUX=disabled
```

### 软件源

```bash
# 备份
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
# 使用阿里云的软件源
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
# 清除缓存
dnf makecache
```

## 内核调优

+ [Too many open files](../../2020/09/11/ulimit.md)