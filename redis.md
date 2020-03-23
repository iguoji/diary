## Redis 安装
1. 下载解压
```
mkdir /home/download && cd /home/download
curl -O http://download.redis.io/releases/redis-5.0.8.tar.gz
tar -zxf redis-5.0.8.tar.gz -C /home
```
2. 编译安装
```
cd /home/redis-5.0.8
make PREFIX=/opt/redis-5.0.8 install
```
3. 配置文件
```
cp /home/redis-5.0.8/redis.conf /etc/redis.conf
vi /etc/redis.conf

# Redis服务器地址，只能通过这个地址进行访问，建议填写内网IP
bind 192.168.1.168
# 是否只能内网访问
protected-mode no
# 后台运行
daemonize yes
# 密码
requirepass 123456
```
4. 环境变量(放在最后一行)
```
vi /etc/profile

# Redis
REDIS=/opt/redis-5.0.8
PATH=$PATH:$REDIS/bin

# 导出变量
export PATH

source /etc/profile
```
5. [Systemctl.Service](cecntos.systemctl.md)
