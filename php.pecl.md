## Pecl安装
先下载go-pear.phar，需通过wget下载
```
wget http://pear.php.net/go-pear.phar
php go-pear.phar
```
接下来一路按回车就好，Pear和Pecl是同一个东西
最后设置下php.ini的路径，方便自动添加扩展
```
pecl config-set php_ini /etc/php.ini
```
