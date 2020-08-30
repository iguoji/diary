# 建议选项

## [--prefix](#--prefix-1)
## [--enable-fpm](#--enable-fpm-1)
## [--with-fpm-systemd](#--with-fpm-systemd-1)
## [--with-config-file-path](#--with-config-file-path-1)
## [--with-config-file-scan-dir](#--with-config-file-scan-dir-1)

# 安装目录

## --prefix

PHP具体安装到哪个目录，默认值 `/usr/local`

例如安装到`/opt/php8`这个目录，可以 `--prefix=/opt/php8`

## --exec-prefix

不确定，默认值和 `--prefix` 保持一致

猜测，PHP依赖文件路径、PHP中可执行文件(如fpm之类)的路径

# SAPI 模块

## --with-apxs2

启用 apxs(apache extension tool) Apache的模块管理工具

## --disable-cli

禁用PHP的Cli版本，无法使用命令行执行PHP

## --enable-embed

PHP所编译出来的SAPI接口，是否可以让第三方程序调用，例如CLI、PHP-FPM等

## --enable-fpm

启用PHP-FPM，连通Nginx、Apache、IIS到PHP的CGI进程管理器

## --with-fpm-user

FPMy运行程序的用户，默认 `nobody`

## --with-fpm-group

FPM运行程序的用户组，默认 `nobody`

## --with-fpm-systemd

是否自动将 PHP-FPM 程序加入系统服务，方便 `systemctl restart php-fpm`

即便没有启用该选项，在PHP的安装包目录下也有相关文件可供直接复制

## --with-fpm-acl

使用 `POSIX` 访问控制列表 (默认 - no) 5.6.5版本起有效，`POSIX` 大概是一套有关API接口的编程标准

该选项应该是与下面的选项联合使用

## --with-fpm-apparmor

`apparmor` 是一个类似 `selinux` 的安全模块，可以通过配置文件来控制PHP-FPM的行为，比如是否可以打开端口、打开哪些端口、是否可以操作文件、可以操作哪些文件等

## --enable-fuzzer

`fuzzer` 是一个漏洞检查工具，估计是给PHP源码开发人员用的

## --enable-fuzzer-msan

与上例配合使用

## --enable-litespeed

`litespeed` 是一个类似 `Nginx` 的支持高并发Web服务器，分商业版(收费)和标准版(免费)，国内使用者较少

## --enable-phpdbg

`phpdbg` 是一个PHP的调试工具，类似 `xdebug`

## --enable-phpdbg-webhelper

与上例配合使用

## --enable-phpdbg-debug

与上例配合使用

## --enable-phpdbg-readline

与上例配合使用

## --disable-cgi

禁用CGI

## --with-valgrind

`valgrind` 是一个查找内存泄漏的工具，看起来很复杂

# 常规设置

## --enable-gcov

`gcov` 是一个代码覆盖率测试工具，可以统计到每一行代码的执行频率

## --enable-debug

编译的时候加入调试符号，应该是方便于PHP源码、扩展插件开发人员使用的

## --enable-debug-assertions

同上使用

## --enable-rtld-now

没有找到资料，关键字 dlopen，动态加载库文件？

## --with-layout

可选PHP|GNU，默认PHP，都说是安装后的文件布局，啥布局，没搞懂，是说安装后文件夹的名称、层次、位置的不同吗？

## --with-config-file-path

`php.ini`的文件位置，例如 `--with-config-file-path=/etc/php.ini` ，安装完后需要自己复制一份到这个位置去

## --with-config-file-scan-dir

PHP 启动时，会先按上例路径加载 `php.ini` 文件，随后加载本例中的所有 `*.ini`文件

例如 `--with-config-file-scan-dir=/etc/php.d`，那么PHP加载完`php.ini`后，将再次扫描`/etc/php.d/`文件夹下的所有`ini`配置文件

## --enable-sigchild

启用PHP自己的 `SIGCHLD` 信号处理函数，当子进程退出时，会向父进程发送 `SIGCHLD` 信号

## --enable-libgcc

启用 libgcc 的精确链接，不懂啥意思。

## --disable-short-tags

禁用短标签，例如 `<? ?>`，通常都是`<?php ?>`

## --enable-dmalloc

`dmalloc` 是内存泄漏检查工具，可以找出是哪个文件第几行造成的

但并没有什么卵用，没有相关的PHP中文资料

## --disable-ipv6

禁用 IPV6

## --enable-dtrace

`dtrace` 是动态跟踪调试工具，很多操作系统内置该工具

PHP官网提供了相关资料 [https://www.php.net/manual/zh/features.dtrace.php](https://www.php.net/manual/zh/features.dtrace.php)

## --enable-fd-setsize

好像和WebSocket、长链接之类的有关，默认`1024`，表示最多支持`1024`个链接，可以改大点

## --enable-werror

好像和安装PHP时的GCC有关，会将所有警告当初错误来处理，似乎和PHP没有关系

## --enable-memory-sanitizer

`sanitizer` 好像也是用来做内存分析的，但仍旧没有PHP相关的中文资料

# 扩展相关

## --disable-all

禁用默认启用的所有扩展

## --without-libxml
## --with-openssl
## --with-kerberos
## --with-system-ciphers
## --with-external-pcre
## --with-pcre-jit
## --without-sqlite3
## --with-zlib
## --enable-bcmath
## --with-bz2[=DIR]
## --enable-calendar
## --disable-ctype
## --with-curl
## --enable-dba
## --with-qdbm[=DIR]
## --with-gdbm[=DIR]
## --with-ndbm[=DIR]
## --with-db4[=DIR]
## --with-db3[=DIR]
## --with-db2[=DIR]
## --with-db1[=DIR]
## --with-dbm[=DIR]
## --with-tcadb[=DIR]
## --with-lmdb[=DIR]
## --without-cdb[=DIR]
## --disable-inifile
## --disable-flatfile
## --disable-dom
## --with-enchant
## --enable-exif
## --with-ffi
## --disable-fileinfo
## --disable-filter
## --enable-ftp
## --with-openssl-dir
## --enable-gd
## --with-external-gd
## --with-webp
## --with-jpeg
## --with-xpm
## --with-freetype
## --enable-gd-jis-conv
## --with-gettext[=DIR]
## --with-gmp[=DIR]
## --with-mhash
## --without-iconv[=DIR]
## --with-imap[=DIR]
## --with-kerberos
## --with-imap-ssl
## --enable-intl
## --with-ldap[=DIR]
## --with-ldap-sasl
## --enable-mbstring
## --disable-mbregex
## --with-mysqli[=FILE]
## --with-mysql-sock[=SOCKPATH]
## --with-oci8[=DIR]
## --with-odbcver[=HEX]
## --with-adabas[=DIR]
## --with-sapdb[=DIR]
## --with-solid[=DIR]
## --with-ibm-db2[=DIR]
## --with-empress[=DIR]
## --with-empress-bcs[=DIR]
## --with-custom-odbc[=DIR]
## --with-iodbc
## --with-esoob[=DIR]
## --with-unixODBC
## --with-dbmaker[=DIR]
## --disable-opcache
## --disable-huge-code-pages
## --disable-opcache-jit
## --enable-pcntl
## --disable-pdo
## --with-pdo-dblib[=DIR]
## --with-pdo-firebird[=DIR]
## --with-pdo-mysql[=DIR]
## --with-zlib-dir[=DIR]
## --with-pdo-oci[=DIR]
## --with-pdo-odbc=flavour,dir
## --with-pdo-pgsql[=DIR]
## --without-pdo-sqlite
## --with-pgsql[=DIR]
## --disable-phar
## --disable-posix
## --with-pspell[=DIR]
## --with-libedit
## --with-readline[=DIR]
## --disable-session
## --with-mm[=DIR]
## --enable-shmop
## --disable-simplexml
## --with-snmp[=DIR]
## --enable-soap
## --enable-sockets
## --with-sodium
## --with-password-argon2[=DIR]
## --enable-sysvmsg
## --enable-sysvsem
## --enable-sysvshm
## --with-tidy[=DIR]
## --disable-tokenizer
## --disable-xml
## --with-expat
## --disable-xmlreader
## --disable-xmlwriter
## --with-xsl
## --enable-zend-test
## --with-zip
## --enable-mysqlnd
## --disable-mysqlnd-compression-support

# PEAR
## --with-pear[=DIR]

# Zend:
## --enable-zts
## --disable-zend-signals

# Libtool
## --enable-shared=PKGS
## --enable-static=PKGS
## --enable-fast-install=PKGS
## --with-gnu-ld
## --disable-libtool-lock
## --with-pic
## --with-tags=TAGS