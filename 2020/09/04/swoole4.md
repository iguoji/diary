[返回主页](../../../README.md)

## 编译安装

```bash
# 进入下载目录
cd /home/download/
# 下载源码
curl -LO https://github.com/swoole/swoole-src/archive/v4.5.3.tar.gz
# 解压源码
tar -xf v4.5.3.tar.gz
cd swoole-src-4.5.3
# 所需依赖
dnf install -y gcc-c++
# 编译安装 ./configure 成功后的最后一行是 config.status: creating config.h
phpize
./configure --enable-openssl --enable-http2
make && make install
# 安装成功
Build complete.
Don't forget to run 'make test'.

Installing shared extensions:     /opt/php-8.0.0beta3/lib/php/extensions/no-debug-non-zts-20200804/
Installing header files:          /opt/php-8.0.0beta3/include/php/
```

## 给PHP安装Swoole扩展

```bash
# 创建文件
vi /opt/php-8.0.0beta3/etc/php.d/swoole.ini
# 内容如下
[swoole]
extension=swoole
```