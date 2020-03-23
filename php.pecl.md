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
## 常见错误

1. 会有很多这种类似的错误，将一个bool当作数组来使用，可以自己修改REST.php文件
`Trying to access array offset on value of type bool in /opt/php-7.4.4/share/pear/PEAR/REST.php on line 181`
```
vi /opt/php-7.4.4/share/pear/PEAR/REST.php

// if (time() - $cacheid['age'] < $cachettl) {
if (is_array($cacheid) && time() - $cacheid['age'] < $cachettl) {
```
2. No releases available for package
找不到任何包，原因是curl的证书不行了，试试看`pecl search redis`，会提示`Connection to 'ssl://pecl.php.net:443' failed`
证书在这里可以找到[https://curl.haxx.se/docs/caextract.html](https://curl.haxx.se/docs/caextract.html)
证书放在`/etc/pki/tls/cert.pem`这里
```
php -r "print_r(openssl_get_cert_locations());"
Array
(
    [default_cert_file] => /etc/pki/tls/cert.pem
    [default_cert_file_env] => SSL_CERT_FILE
    [default_cert_dir] => /etc/pki/tls/certs
    [default_cert_dir_env] => SSL_CERT_DIR
    [default_private_dir] => /etc/pki/tls/private
    [default_default_cert_area] => /etc/pki/tls
    [ini_cafile] => 
    [ini_capath] => 
)
```
但是`/etc/pki/tls/cert.pem`只是一个软链接，实际指向`/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem`
所以下载证书，并将其命名为`tls-ca-bundle.pem`即可，原文件记得备份
```
cd /etc/pki/ca-trust/extracted/pem/
curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
mv tls-ca-bundle.pem tls-ca-bundle.pem.bak
mv cacert.pem tls-ca-bundle.pem
```
