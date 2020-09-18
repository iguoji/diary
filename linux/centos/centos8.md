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

###
+ [Too many open files](../../2020/09/11/ulimit.md)

### /etc/sysctl

> 通过 sysctl -p 即可生效

```ini
net.unix.max_dgram_qlen = 100
net.ipv4.tcp_mem  = 379008      505344      758016
net.ipv4.tcp_wmem = 4096        16384       4194304
net.ipv4.tcp_rmem = 4096        87380       4194304
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 81920
net.ipv4.tcp_synack_retries = 3
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_tw_reuse = 1
# net.ipv4.tcp_tw_recycle = 1
net.ipv4.ip_local_port_range = 20000 65000
net.ipv4.tcp_max_tw_buckets = 200000
net.ipv4.route.max_size = 5242880

net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 30000

#net.netfilter.nf_conntrack_max = 2621440

kernel.msgmnb = 4203520
kernel.msgmni = 64
kernel.msgmax = 8192
kernel.core_pattern = /data/core_files/core-%e-%p-%t

fs.file-max = 6815744

vm.overcommit_memory = 1
```