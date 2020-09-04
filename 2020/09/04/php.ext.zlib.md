[返回主页](../../../README.md)

```bash
# 进入PHP的源代码目录
cd /home/download/php-8.0.0beta3

# 进入zlib扩展的目录
cd /ext/zlib

# 执行phpize
phpize

# 执行后如果出现下列结果，就执行 cp config0.m4 config.m4
# Cannot find config.m4.
# Make sure that you run '/opt/php-8.0.0beta3/bin/phpize' in the top level source directory of the module

# 编译安装
# 因为给PHP设置了环境变量，所以不需要指定php-config文件的路径
# 如果没有设置环境变量，可执行 ./configure --with-php-config=/usr/local/php/bin/php-config
./configure
make && make install

# 给PHP添加扩展
vi /opt/php-8.0.0beta3/etc/php.d/zlib.ini

# 该文件内容如下
[zlib]
extension=zlib

# 最后通过 php -m 查看扩展是否安装完成
```