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
升级到新版本
```
pecl channel-update pecl.php.net
```
记录错误1
`Trying to access array offset on value of type bool in /opt/php-7.4.4/share/pear/PEAR/REST.php on line 181`
```
vi /opt/php-7.4.4/share/pear/PEAR/REST.php

// if (time() - $cacheid['age'] < $cachettl) {
if (is_array($cacheid) && time() - $cacheid['age'] < $cachettl) {
```
