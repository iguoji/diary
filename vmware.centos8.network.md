## Vmware 网络

1. NAT模式：VMnet8

2. 子网IP：192.168.2.0

3. 起始IP：192.168.2.10

## IP设置

```bash
cat /etc/sysconfig/network-scripts/ifcfg-ens33
```

```bash
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens33"
UUID="1680e673-1517-4df3-9921-4eef4f78d65c"
DEVICE="ens33"
ONBOOT="yes"
# 重点是下面四行
IPADDR="192.168.2.11"
PREFIX="24"
GATEWAY="192.168.2.2"
NDS1="192.168.2.2"
IPV6_PRIVACY="no"
```

## 设置DNS服务器

```bash
vi /etc/resolv.conf
```
```bash
# 和上面保持一致
nameserver 192.168.2.2
```