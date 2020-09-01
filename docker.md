#### 下载安装
> 参考 [Docker官方教程](https://docs.docker.com/engine/install/centos/)，也可以参考 [阿里云 Docker安装教程](https://developer.aliyun.com/mirror/docker-ce)
```bash
dnf config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
mkdir /home/download && cd /home/download
curl -LO https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install -y ./containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install -y docker-ce
systemctl start docker
systemctl enable docker
sudo usermod -aG docker $USER
```

#### 国内镜像
> 查看[Docker 官方指导](https://docs.docker.com/registry/recipes/mirror/)，申请[阿里云镜像加速器](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)

编辑 `/etc/docker/daemon.json` ，内容如下，其中URL替换成阿里云申请的镜像地址
```json
{
    "registry-mirrors": ["https://yourid.mirror.aliyuncs.com"]
}
```
然后重启相关服务
```bash
systemctls daemon-reload
systemctls restart docker
```

最后通过 `docker info` 查看到更换后的地址

#### 域名解析
> 默认安装后docker内的容器无法解析域名

```bash
firewall-cmd --zone=public --add-masquerade --permanent
firewall-cmd --reload
systemctl restart docker
```